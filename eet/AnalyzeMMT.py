import MuMuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from math import sqrt, pi
from bTagSF import PromoteDemote

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMMT(MegaBase):
  tree = 'mmt/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonMediumID = mcCorrections.muonID_medium
    self.muonTightIsoMediumID = mcCorrections.muonIso_tight_mediumid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco

    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeMMT, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuTauTree.MuMuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self,row):
    if row.m1Charge * row.m2Charge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.m1Pt < 10 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 10 or abs(row.m2Eta) >= 2.4:
      return False
    if row.tPt < 23 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def obj1_id(self,row):
    return bool(row.m1PFIDMedium) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045)
 
 
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj2_id(self, row):
    return bool(row.m2PFIDMedium) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045)


  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.15)


  def tau_id(self, row):
    return bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronTightMVA6 > 0.5) and bool(row.tAgainstMuonLoose3 > 0.5) and bool(abs(row.tPVDZ) < 0.2)


  def tau_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def tau_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def vetos(self, row):
    return bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names=['initial', 'loose', 'LDM0', 'LDM1', 'LDM10', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'tight', 'TDM0', 'TDM1', 'TDM10', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEEDM0', 'TEEDM1', 'TEEDM10']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "tPt", "Tau Pt", 20, 0, 200)
      self.book(names[x], "tEta", "Tau Eta", 20, -3, 3)
      self.book(names[x], "tDecayMode", "Tau Decay Mode", 20, 0, 20)
      self.book(names[x], "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(names[x], "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 20, -3, 3)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 20, -3, 3)


  def fill_histos(self, row, myMuon1, myMuon2, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/tPt'].Fill(myTau.Pt(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
    histos[name+'/m1_m2_Mass'].Fill(self.visibleMass(myMuon1, myMuon2), weight)
    histos[name+'/m1Pt'].Fill(myMuon1.Pt(), weight)
    histos[name+'/m1Eta'].Fill(myMuon1.Eta(), weight)
    histos[name+'/m2Pt'].Fill(myMuon2.Pt(), weight)
    histos[name+'/m2Eta'].Fill(myMuon2.Eta(), weight)


  def tauPtC(self, row, myTau):
    tmpTau = myTau
    if self.is_mc and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        tmpTau = myTau * ROOT.Double(1.001)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        tmpTau = myTau * ROOT.Double(1.036)
    return tmpTau


  def process(self):

    for row in self.tree:

      m1Trigger27 = row.IsoMu27Pass and row.m1MatchesIsoMu27Filter and row.m1MatchesIsoMu27Path and row.m1Pt > 28
      m1Trigger24 = row.IsoMu24Pass and row.m1MatchesIsoMu24Filter and row.m1MatchesIsoMu24Path and row.m1Pt > 25
      m2Trigger27 = row.IsoMu27Pass and row.m2MatchesIsoMu27Filter and row.m2MatchesIsoMu27Path and row.m2Pt > 28
      m2Trigger24 = row.IsoMu24Pass and row.m2MatchesIsoMu24Filter and row.m2MatchesIsoMu24Path and row.m2Pt > 25

      if self.filters(row):
        continue

      if not bool(m1Trigger27 or m1Trigger24 or m2Trigger27 or m2Trigger24):
        continue

      if not self.kinematics(row):
        continue

      if not self.oppositesign(row):
        continue

      if not self.vetos(row):
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.obj2_iso(row):
        continue

      myMuon1 = ROOT.TLorentzVector()
      myMuon1.SetPtEtaPhiM(row.m1Pt, row.m1Eta, row.m1Phi, row.m1Mass)
      myMuon2 = ROOT.TLorentzVector()
      myMuon2.SetPtEtaPhiM(row.m2Pt, row.m2Eta, row.m2Phi, row.m2Mass)
      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
      myTau = self.tauPtC(row, myTau)

      if self.visibleMass(myMuon1, myMuon2) < 70 or self.visibleMass(myMuon1, myMuon2) > 110:
        continue

      if not self.tau_id(row):
        continue

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
        if m1Trigger24 or m1Trigger27:
          self.w2.var("m_pt").setVal(myMuon1.Pt())
          self.w2.var("m_eta").setVal(myMuon1.Eta())
          tEff = self.w2.function("m_trg24_27_kit_data").getVal()/self.w2.function("m_trg24_27_kit_mc").getVal()
        if m2Trigger24 or m2Trigger27:
          self.w2.var("m_pt").setVal(myMuon2.Pt())
          self.w2.var("m_eta").setVal(myMuon2.Eta())
          tEff = self.w2.function("m_trg24_27_kit_data").getVal()/self.w2.function("m_trg24_27_kit_mc").getVal()
        m1ID = self.muonMediumID(myMuon1.Pt(), abs(myMuon1.Eta()))
        m1Iso = self.muonTightIsoMediumID(myMuon1.Pt(), abs(myMuon1.Eta()))
        m1Trk = self.muTracking(row.m1Eta)[0]
        m2ID = self.muonMediumID(myMuon2.Pt(), abs(myMuon2.Eta()))
        m2Iso = self.muonTightIsoMediumID(myMuon2.Pt(), abs(myMuon2.Eta()))
        m2Trk = self.muTracking(row.m2Eta)[0]
        weight = weight * tEff * m1ID * m1Iso * m1Trk * m2ID * m2Iso * m2Trk
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.06
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.02
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.10
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*1.03
          else:
            weight = weight*1.94
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.80
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.53
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        weight = self.mcWeight.lumiWeight(weight)

      self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'initial')

      if self.tau_loose(row):
        self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'loose')
        if row.tDecayMode == 0:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LDM0')
        elif row.tDecayMode == 1:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LDM1')
        elif row.tDecayMode == 10:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LDM10')

        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEBDM10')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'LEEDM10')

      if self.tau_tight(row):
        self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'tight')
        if row.tDecayMode == 0:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TDM0')
        elif row.tDecayMode == 1:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TDM1')
        elif row.tDecayMode == 10:
          self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TDM10')

        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEBDM10')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'TEEDM10')


  def finish(self):
    self.write_histos()
