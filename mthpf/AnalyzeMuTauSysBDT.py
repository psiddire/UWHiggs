'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import itertools
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVACat, FunctorFromMVA
from bTagSF import PromoteDemote, PromoteDemoteSyst, bTagEventWeight
import random

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeMuTauSysBDT(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.EmbedPt = mcCorrections.EmbedPt

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    self.names = Kinematics.names
    self.loosenames = Kinematics.loosenames
    self.jes = Kinematics.jes
    self.fakes = Kinematics.fakes
    self.sys = Kinematics.sys
    self.fakeSys = Kinematics.fakeSys
    self.scaleSys = Kinematics.scaleSys

    self.var_d_star =['mPt', 'tPt', 'dPhiMuTau', 'dEtaMuTau', 'type1_pfMetEt', 'm_t_collinearMass', 'MTTauMET', 'dPhiTauMET', 'njets', 'vbfMass']
    self.xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml')
    self.functor = FunctorFromMVACat('BDT method', self.xml_name, *self.var_d_star)

    super(AnalyzeMuTauSysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 25 or abs(row.mEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
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


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVLoose > 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_fakes in itertools.product(self.loosenames, self.fakes):
      folder.append(os.path.join(*tuple_path_fakes))
    for f in folder:
      self.book(f, 'bdtDiscriminator', 'BDT Discriminator', 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myTau, njets, mjj))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def var_d(self, myMuon, myMET, myTau, njets, mjj):
    return {'mPt' : myMuon.Pt(), 'tPt' : myTau.Pt(), 'dPhiMuTau' : self.deltaPhi(myMuon.Phi(), myTau.Phi()), 'dEtaMuTau' : self.deltaEta(myMuon.Eta(), myTau.Eta()), 'type1_pfMetEt' : myMET.Et(), 'm_t_collinearMass' : self.collMass(myMuon, myMET, myTau), 'MTTauMET' : self.transverseMass(myTau, myMET), 'dPhiTauMET' : self.deltaPhi(myTau.Phi(), myMET.Phi()), 'njets' : int(njets), 'vbfMass' : mjj}


  def fill_categories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if self.obj2_tight(row) and self.obj1_tight(row):
      self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TightOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TightOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TightOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TightOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TightOS2JetVBF'+name)


  def fill_loosecategories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      weight = weight*frTau
      self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TauLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon
      self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frMuon = self.fakeRateMuon(myMuon.Pt())
      weight = weight*frMuon*frTau
      self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseTauLooseOS'+name)
      if njets==0:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseTauLooseOS0Jet'+name)
      elif njets==1:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseTauLooseOS1Jet'+name)
      elif njets==2 and mjj < 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseTauLooseOS2Jet'+name)
      elif njets==2 and mjj > 550:
        self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight, 'MuonLooseTauLooseOS2JetVBF'+name)


  def fill_sys(self, row, myMuon, myMET, myTau, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpTau = ROOT.TLorentzVector()
    uncorTau = ROOT.TLorentzVector()
    uncorTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    tmpMET = ROOT.TLorentzVector()
    njets = row.jetVeto30WoNoisyJets
    mjj = row.vbfMassWoNoisyJets

    if self.is_mc:

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoDown')

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      if nbtag==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, -1, 0)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      if puweight==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')

      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      if row.tZTTGenMatching==5:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.92/0.89, '/tidUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.86/0.89, '/tidDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/tidUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/tidDown')

      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        if abs(myTau.Eta()) < 0.4:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.29/1.17, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.05/1.17, '/mtfakeDown')
        elif abs(myTau.Eta()) < 0.8:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.59/1.29, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.99/1.29, '/mtfakeDown')
        elif abs(myTau.Eta()) < 1.2:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.19/1.14, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.09/1.14, '/mtfakeDown')
        elif abs(myTau.Eta()) < 1.7:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.53/0.93, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.33/0.93, '/mtfakeDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 2.21/1.61, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.01/1.61, '/mtfakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeDown')

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if abs(myTau.Eta()) < 1.46:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.10/1.09, '/etfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.08/1.09, '/etfakeDown')
        elif abs(myTau.Eta()) > 1.558:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.20/1.19, '/etfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.18/1.19, '/etfakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeDown')

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if row.tDecayMode==0 or row.tDecayMode==1:
          myMETpx = myMET.Px() - 0.007 * myTau.Px()
          myMETpy = myMET.Py() - 0.007 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.007)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeUp')
          myMETpx = myMET.Px() + 0.007 * myTau.Px()
          myMETpy = myMET.Py() + 0.007 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.993)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeDown')

      myMETpx = myMET.Px() - 0.002 * myMuon.Px()
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesUp')

      myMETpx = myMET.Px() + 0.002 * myMuon.Px()
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesDown')

      if not self.is_DY:
        if row.tZTTGenMatching==5:
          if row.tDecayMode==0:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM0Up', '/scaletDM0Down']]
            self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
          elif row.tDecayMode==1:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM1Up', '/scaletDM1Down']]
            self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.008 * myTau.Px()
            myMETpy = myMET.Py() - 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()
            myMETpy = myMET.Py() + 0.008 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.992)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
          elif row.tDecayMode==10:
            sSys = [x for x in self.scaleSys if x not in ['/scaletDM10Up', '/scaletDM10Down']]
            self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
            myMETpx = myMET.Px() - 0.009 * myTau.Px()
            myMETpy = myMET.Py() - 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.009)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
            myMETpx = myMET.Px() + 0.009 * myTau.Px()
            myMETpy = myMET.Py() + 0.009 * myTau.Py()
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(0.991)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
          else:
            self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.scaleSys)
        else:
          self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.scaleSys)

      if self.is_DY:
        self.w2.var('z_gen_mass').setVal(row.genMass)
        self.w2.var('z_gen_pt').setVal(row.genpT)
        dyweight = self.w2.function('zptmass_weight_nom').getVal()
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*1.1, '/DYptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*0.9, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')

      self.tauFRSys(row, myMuon, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep0Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Up')
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep1Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Up')
        else:
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep0Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Down')
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep1Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Down')

      if not (self.is_recoilC and MetCorrection):
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnUp')
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnDown')

        for j in self.jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      self.tauFRSys(row, myMuon, myMET, myTau, njets, mjj, weight)
      myrand = random.random()
      if not self.obj1_tight(row) and self.obj1_loose(row):
        if myrand < 0.5:
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep0Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Up')
          weightDown = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Down') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakep1Down')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Up')
        else:
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp0Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep0Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep0Down')
          weightUp = 0 if self.fakeRateMuon(myMuon.Pt())==0 else self.fakeRateMuon(myMuon.Pt(), 'frp1Up') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakep1Up')
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakep1Down')

      if self.is_embed:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.96, '/embtrDown')

        if row.tDecayMode==0:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM0Up', '/scaletDM0Down']]
          self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
        elif row.tDecayMode==1:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM1Up', '/scaletDM1Down']]
          self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.008 * myTau.Px()
          myMETpy = myMET.Py() - 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.008)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
          myMETpx = myMET.Px() + 0.008 * myTau.Px()
          myMETpy = myMET.Py() + 0.008 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.992)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
        elif row.tDecayMode==10:
          sSys = [x for x in self.scaleSys if x not in ['/scaletDM10Up', '/scaletDM10Down']]
          self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, sSys)
          myMETpx = myMET.Px() - 0.009 * myTau.Px()
          myMETpy = myMET.Py() - 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.009)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
          myMETpx = myMET.Px() + 0.009 * myTau.Px()
          myMETpy = myMET.Py() + 0.009 * myTau.Py()
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.991)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_scaleSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.scaleSys)

        if row.tDecayMode == 0:
          dm = 0.975
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.983/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.967/dm, '/embtrkDown')
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.983*1.065)/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.967*1.037)/dm, '/embtrkDown')
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.967, 3)/dm, '/embtrkDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/embtrkDown')


  def fill_scaleSys(self, row, myMuon, myMET, myTau, njets, mjj, weight, scaleSys):
      for s in scaleSys:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, s)


  def fill_fakeSys(self, row, myMuon, myMET, myTau, njets, mjj, weight, fakeSys):
      for f in fakeSys:
          self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, f)


  def tauFRSys(self, row, myMuon, myMET, myTau, njets, mjj, weight):
    if not self.obj2_tight(row) and self.obj2_loose(row):
      if abs(myTau.Eta()) < 1.5:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM0Up', '/TauFakep1EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep1EBDM0Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM1Up', '/TauFakep1EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep1EBDM1Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EBDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EBDM10Up', '/TauFakep1EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep1EBDM10Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        else:
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.fakeSys)
      else:
        if row.tDecayMode == 0:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM0')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM0Up', '/TauFakep1EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep1EEDM0Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 1:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM1')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM1Up', '/TauFakep1EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep1EEDM1Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        elif row.tDecayMode == 10:
          self.fill_taufr(row, myMuon, myMET, myTau, njets, mjj, weight, 'EEDM10')
          fSys = [x for x in self.fakeSys if x not in ['/TauFakep0EEDM10Up', '/TauFakep1EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EEDM10Down']]
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, fSys)
        else:
          self.fill_fakeSys(row, myMuon, myMET, myTau, njets, mjj, weight, self.fakeSys)


  def fill_taufr(self, row, myMuon, myMET, myTau, njets, mjj, weight, name):
    myrand = random.random()
    if myrand < 0.5:
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakep0'+name+'Down')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Up')
      weightDown = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Down') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakep1'+name+'Down')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Up')
    else:
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp0Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakep0'+name+'Up')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep0'+name+'Down')
      weightUp = 0 if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0 else self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frp1Up') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakep1'+name+'Up')
      self.fill_loosecategories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakep1'+name+'Down')


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.003 * myTau.Px()
        myMETpy = myMET.Py() - 0.003 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() - 0.036 * myTau.Px()
        myMETpy = myMET.Py() - 0.036 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.036)
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 25
      trigger27 = row.IsoMu27Pass and row.mMatchesIsoMu27Filter and row.mMatchesIsoMu27Path and row.mPt > 28

      if self.filters(row):
        continue

      if not bool(trigger24 or trigger27):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
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

      if not self.dimuonveto(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        self.w2.var('m_pt').setVal(myMuon.Pt())
        self.w2.var('m_eta').setVal(myMuon.Eta())
        tEff = 0 if self.w2.function('m_trg24_27_kit_mc').getVal()==0 else self.w2.function('m_trg24_27_kit_data').getVal()/self.w2.function('m_trg24_27_kit_mc').getVal()
        mTrk = self.muTracking(myMuon.Eta())[0]
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        if self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        else:
          mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*tEff*row.GenWeight*pucorrector[''](row.nTruePU)*mID*mTrk*mIso*mcSF*row.prefiring_weight
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.17
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.29
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.14
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.09
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.19
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        if self.is_DY:
          self.w2.var('z_gen_mass').setVal(row.genMass)
          self.w2.var('z_gen_pt').setVal(row.genpT)
          dyweight = self.w2.function('zptmass_weight_nom').getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMassWoNoisyJets

      m_trg_sf = 0.0
      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        self.we.var('m_pt').setVal(myMuon.Pt())
        self.we.var('m_eta').setVal(myMuon.Eta())
        self.we.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
        self.we.var('gt_pt').setVal(myMuon.Pt())
        self.we.var('gt_eta').setVal(myMuon.Eta())
        msel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt_pt').setVal(myTau.Pt())
        self.we.var('gt_eta').setVal(myTau.Eta())
        tsel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt1_pt').setVal(myMuon.Pt())
        self.we.var('gt1_eta').setVal(myMuon.Eta())
        self.we.var('gt2_pt').setVal(myTau.Pt())
        self.we.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.we.function('m_sel_trg_ratio').getVal()
        m_trg_sf = self.we.function('m_trg24_27_embed_kit_ratio').getVal()
        m_iso_sf = self.we.function('m_iso_binned_embed_kit_ratio').getVal()
        m_id_sf = self.we.function('m_id_embed_kit_ratio').getVal()
        m_trk_sf = self.muTracking(myMuon.Eta())[0]
        weight = weight*row.GenWeight*tID*m_trg_sf*m_id_sf*m_iso_sf*m_trk_sf*dm*msel*tsel*trgsel*self.EmbedPt(myMuon.Pt(), njets, mjj)

      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data or self.is_embed) and nbtag > 0):
        weight = 0

      self.fill_sys(row, myMuon, myMET, myTau, weight)

  def finish(self):
    self.write_histos()
