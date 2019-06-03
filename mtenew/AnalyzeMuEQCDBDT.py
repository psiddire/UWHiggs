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

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuEQCDBDT(MegaBase):
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

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.var_d_star = ['mPt', 'ePt', 'm_e_collinearMass', 'dPhiMuMET', 'dPhiEMET', 'dPhiMuE', 'MTMuMET', 'MTEMET']
    self.xml_name = os.path.join(os.getcwd(), "bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml")
    self.functor = FunctorFromMVA('BDT method', self.xml_name, *self.var_d_star)

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco
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

    super(AnalyzeMuEQCDBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 29 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 10 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
  

  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
    

  def obj2_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)


  def obj2_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def begin(self):
    folder = []
    vbffolder = []
    names=['MuonAIsoOS', 'MuonAIsoSS', 'MuonAIsoOS0Jet', 'MuonAIsoSS0Jet', 'MuonAIsoOS1Jet', 'MuonAIsoSS1Jet', 'MuonAIsoOS2Jet', 'MuonAIsoSS2Jet', 'MuonAIsoOS2JetVBF', 'MuonAIsoSS2JetVBF']
    namesize = len(names)

    for x in range(0,namesize):
      self.book(names[x], "bdtDiscriminator", "BDT Discriminator", 20, -1.0, 1.0)


  def fill_histos(self, row, myMuon, myMET, myEle, njets, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myEle))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def var_d(self, myMuon, myMET, myEle):
    return {'mPt' : myMuon.Pt(), 'ePt' : myEle.Pt(), 'm_e_collinearMass' : self.collMass(myMuon, myMET, myEle), 'dPhiMuMET' : self.deltaPhi(myMuon.Phi(), myMuon.Phi()), 'dPhiEMET' : self.deltaPhi(myEle.Phi(), myMET.Phi()), 'dPhiMuE' : self.deltaPhi(myEle.Phi(), myMuon.Phi()), 'MTMuMET' : self.transverseMass(myMuon, myMET), 'MTEMET' : self.transverseMass(myEle, myMET)} 


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

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
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

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (self.is_mc and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue 

      weight = 1.0
      if self.is_mc:
        tEff = self.triggerEff(myMuon.Pt(), abs(myMuon.Eta()))
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mTrk = self.muTracking(myMuon.Eta())[0]
        eID = self.eIDnoIsoWP80(myEle.Pt(), abs(myEle.Eta()))
        eTrk = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*eID*eTrk
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
        weight = self.mcWeight.lumiWeight(weight)

      self.w3.var("njets").setVal(njets)
      self.w3.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
      self.w3.var("e_pt").setVal(myEle.Pt())
      self.w3.var("m_pt").setVal(myMuon.Pt())
      osss = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()

      mjj = row.vbfMassWoNoisyJets
      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
      mtmumet = self.transverseMass(myMuon, myMET)

      if self.obj2_tight(row) and self.obj1_loose(row) and not self.obj1_tight(row):
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'MuonAIsoOS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'MuonAIsoOS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'MuonAIsoOS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'MuonAIsoOS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'MuonAIsoOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'MuonAIsoSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'MuonAIsoSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'MuonAIsoSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'MuonAIsoSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'MuonAIsoSS2JetVBF')


  def finish(self):
    self.write_histos()
