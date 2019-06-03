'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import itertools
import operator
import mcCorrections
import mcWeights
import Kinematics
from RecoilCorrector import RecoilCorrector
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote
import random

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target) 
Emb = False

class AnalyzeMuESysFake(MegaBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.tEff = mcCorrections.efficiency_trigger_mu_2017
    self.mID = mcCorrections.muonID_medium
    self.mLIso = mcCorrections.muonIso_loose_mediumid
    self.mTIso = mcCorrections.muonIso_tight_mediumid
    self.mTrk = mcCorrections.muonTracking
    self.eID = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.fakeRateElectron = mcCorrections.fakerateElectron_weight
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2 
    self.w3 = mcCorrections.w3 
    self.we = mcCorrections.we 

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeMuESysFake, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.mu23e12Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 24 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDMedium) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
 
 
  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)
  

  def obj2_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)


  def obj2_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.2)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP90) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def begin(self):
    folder = []
    vbffolder = []
    names = ['EleLooseOS', 'MuonLooseOS', 'MuonLooseEleLooseOS', 'TightOS', 'EleLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseEleLooseOS0Jet', 'TightOS0Jet', 'EleLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseEleLooseOS1Jet', 'TightOS1Jet'] 
    vbfnames = ['EleLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseEleLooseOS2Jet', 'TightOS2Jet', 'EleLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseEleLooseOS2JetVBF', 'TightOS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'bTagUp', 'bTagDown', 'eescUp', 'eescDown', 'eesiUp', 'eesiDown', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'TopptreweightUp', 'TopptreweightDown', 'JetAbsoluteFlavMapUp', 'JetAbsoluteFlavMapDown', 'JetAbsoluteMPFBiasUp', 'JetAbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']
    fakes = ['MuonFakeUp', 'MuonFakeDown', 'EleFakeUp', 'EleFakeDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_fakes in itertools.product(names, fakes):
      folder.append(os.path.join(*tuple_path_fakes))

    for f in folder:
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 30, 0, 300)      

    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))
    for tuple_path_vbffakes in itertools.product(vbfnames, fakes):
      vbffolder.append(os.path.join(*tuple_path_vbffakes))
    
    for f in vbffolder:
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 12, 0, 300)


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms 
    histos[name+'/m_e_CollinearMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)


  def fill_categories(self, row, myMuon, myMET, myEle, njets, mjj, weight, name=''):

    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())                                                                                                                                                                                                                         
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())                                                                                                                                                                                                                         
    mtmumet = self.transverseMass(myMuon, myMET)

    if self.obj2_tight(row) and self.obj1_tight(row):
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.mTIso(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*mIso 
      self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS'+name)
      if njets==0:
        if mtmumet > 60 and dphiemet < 0.7 and dphiemu> 2.5 and myMuon.Pt() > 30:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet'+name)
      elif njets==1:
        if mtmumet > 40 and dphiemet < 0.7 and dphiemu> 1.0 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 550:
        if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 550:
        if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frEle = self.fakeRateElectron(myEle.Pt())
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.mTIso(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*frEle*mIso
      self.fill_histos(myMuon, myMET, myEle, weight, 'EleLooseOS'+name)
      if njets==0:
        if mtmumet > 60 and dphiemet < 0.7 and dphiemu> 2.5 and myMuon.Pt() > 30:
          self.fill_histos(myMuon, myMET, myEle, weight, 'EleLooseOS0Jet'+name)
      elif njets==1:
        if mtmumet > 40 and dphiemet < 0.7 and dphiemu> 1.0 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'EleLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'EleLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'EleLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frMuon = self.fakeRateMuon(myMuon.Pt())
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.mLIso(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*frMuon*mIso
      self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseOS'+name)
      if njets==0:
        if mtmumet > 60 and dphiemet < 0.7 and dphiemu> 2.5 and myMuon.Pt() > 30:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseOS0Jet'+name)
      elif njets==1:
        if mtmumet > 40 and dphiemet < 0.7 and dphiemu> 1.0 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frEle = self.fakeRateElectron(myEle.Pt())
      frMuon = self.fakeRateMuon(myMuon.Pt())
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.mLIso(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*mIso*frMuon*frEle
      self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseEleLooseOS'+name)
      if njets==0:
        if mtmumet > 60 and dphiemet < 0.7 and dphiemu> 2.5 and myMuon.Pt() > 30:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseEleLooseOS0Jet'+name)
      elif njets==1:
        if mtmumet > 40 and dphiemet < 0.7 and dphiemu> 1.0 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseEleLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseEleLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
          self.fill_histos(myMuon, myMET, myEle, weight, 'MuonLooseEleLooseOS2JetVBF'+name)


  def fill_sys(self, row, myMuon, myMET, myEle, njets, nbtags, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpEle = ROOT.TLorentzVector()
    tmpEleC = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()

    mjj = getattr(row, 'vbfMassWoNoisyJets') 

    if self.is_mc:

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)

      if nbtags[1]==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagUp')
      if nbtags[2]==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagDown')
      if nbtags[0] > 0:
        return
      self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '')

      if puweight==0:
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 0.98, '/trDown')

      if self.is_recoilC and MetCorrection:
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescDown')
      
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiDown')

      myMETpx = myMET.Px() - 0.002 * myMuon.Px()
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(row, tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesUp')
      myMETpx = myMET.Px() + 0.002 * myMuon.Px()
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(row, tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesDown')

      if self.is_DY:
        self.w2.var("z_gen_mass").setVal(row.genMass)
        self.w2.var("z_gen_pt").setVal(row.genpT)
        dyweight = self.w2.function("zptmass_weight_nom").getVal()
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight*dyweight, '/DYptreweightUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight/dyweight, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight/topweight, '/TopptreweightDown')
      
      if not self.obj2_tight(row) or not self.obj1_tight(row):
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateElectron(myEle.Pt(), 'frDown') * weight/self.fakeRateElectron(myEle.Pt()) if self.fakeRateElectron(myEle.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightDown, '/EleFakeDown')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/EleFakeUp')
        else:
          weightUp = self.fakeRateElectron(myEle.Pt(), 'frUp') * weight/self.fakeRateElectron(myEle.Pt()) if self.fakeRateElectron(myEle.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightUp, '/EleFakeUp')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/EleFakeDown')
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateMuon(myMuon.Pt(), 'frDown') * weight/self.fakeRateMuon(myMuon.Pt()) if self.fakeRateMuon(myMuon.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightDown, '/MuonFakeDown')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/MuonFakeUp')
        else:
          weightUp = self.fakeRateMuon(myMuon.Pt(), 'frUp') * weight/self.fakeRateMuon(myMuon.Pt()) if self.fakeRateMuon(myMuon.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightUp, '/MuonFakeUp')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/MuonFakeDown')

      if not (self.is_recoilC and MetCorrection):
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEleC = tmpEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)
        myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        myMETpx = myMET.Px() + tmpEle.Px()
        myMETpy = myMET.Py() + tmpEle.Py()
        myMETpx = myMETpx - tmpEleC.Px()
        myMETpy = myMETpy - tmpEleC.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/UnclusteredEnUp')
        myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        myMETpx = myMET.Px() + tmpEle.Px()
        myMETpy = myMET.Py() + tmpEle.Py()
        myMETpx = myMETpx - tmpEleC.Px()
        myMETpy = myMETpy - tmpEleC.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/UnclusteredEnDown')

        jes = ['JetAbsoluteFlavMapUp', 'JetAbsoluteFlavMapDown', 'JetAbsoluteMPFBiasUp', 'JetAbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']

        for j in jes:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j) , 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          myMETpx = myMET.Px() + tmpEle.Px()
          myMETpy = myMET.Py() + tmpEle.Py()
          myMETpx = myMETpx - tmpEleC.Px()
          myMETpy = myMETpy - tmpEleC.Py()
          myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j) 
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '')
      if not self.obj2_tight(row) or not self.obj1_tight(row):
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateElectron(myEle.Pt(), 'frDown') * weight/self.fakeRateElectron(myEle.Pt()) if self.fakeRateElectron(myEle.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightDown, '/EleFakeDown')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/EleFakeUp')
        else:
          weightUp = self.fakeRateElectron(myEle.Pt(), 'frUp') * weight/self.fakeRateElectron(myEle.Pt()) if self.fakeRateElectron(myEle.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightUp, '/EleFakeUp')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/EleFakeDown')
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateMuon(myMuon.Pt(), 'frDown') * weight/self.fakeRateMuon(myMuon.Pt()) if self.fakeRateMuon(myMuon.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightDown, '/MuonFakeDown')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/MuonFakeUp')
        else:
          weightUp = self.fakeRateMuon(myMuon.Pt(), 'frUp') * weight/self.fakeRateMuon(myMuon.Pt()) if self.fakeRateMuon(myMuon.Pt())!=0 else 0
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weightUp, '/MuonFakeUp')
          self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight, '/MuonFakeDown')
      if self.is_embed:
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 0.98, '/trDown')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(row, myMuon, myMET, myEle, njets, mjj, weight * 0.96, '/embtrDown')


  def process(self):

    for row in self.tree:

      if self.filters(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue 

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue      

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
                                                                                                                                                                                                            
      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

      myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 

      nbtag = row.bjetDeepCSVVeto20Medium
      nbtagup = row.bjetDeepCSVVeto20Medium
      nbtagdown = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
        nbtagup = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 1)
        nbtagdown = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, -1)
      nbtags = [nbtag, nbtagup, nbtagdown]

      weight = 1.0
      if not self.is_data and not self.is_embed:
        mID = self.mID(row.mPt, abs(row.mEta))
        mTrk = self.mTrk(row.mEta)[0]
        #eID = self.eID(row.ePt, abs(row.eEta))
        #eTrk = self.eReco(row.ePt, abs(row.eEta))
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        eIso = self.w1.function("e_iso_binned_ratio").getVal()
        eID = self.w1.function("e_id_ratio").getVal()
        eTrk = self.w1.function("e_trk_ratio").getVal()
        tData = self.w1.function("m_trg_binned_23_data").getVal() * self.w1.function("e_trg_binned_12_data").getVal()
        tMC = self.w1.function("m_trg_binned_23_mc").getVal() * self.w1.function("e_trg_binned_12_mc").getVal()
        if tMC==0:
          tEff = 0
        else:
          tEff = tData/tMC
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mTrk*eID*eTrk*eIso 
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          if row.numGenJets < 5:
            weight = weight*dyweight*self.DYweight[row.numGenJets]
          else:
            weight = weight*dyweight*self.DYweight[0]
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
        weight = self.mcWeight.lumiWeight(weight)

      if self.oppositesign(row):
        self.fill_sys(row, myMuon, myMET, myEle, njets, weight)


  def finish(self):
    self.write_histos()
