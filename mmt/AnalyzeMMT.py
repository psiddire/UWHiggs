'''

Tau Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import MuMuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMMT(MegaBase):
  tree = 'mmt/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.DYreweight = mcCorrections.DYreweight
    self.rc = mcCorrections.rc

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

  # Charge requirement for the muons to be coming from Z-decay
  def oppositesign(self,row):
    if row.m1Charge * row.m2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.m1Pt < 20 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 20 or abs(row.m2Eta) >= 2.4:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Particle Flow Identification along with Primary Vertex matching for Muon 1
  def obj1_id(self,row):
    return bool(row.m1PFIDTight) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045)
 
  # Isolation requirement using Delta Beta method for Muon 1
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.15)
  
  # Particle Flow Identification along with Primary Vertex matching for Muon 2
  def obj2_id(self, row):
    return bool(row.m2PFIDTight) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045)

  # Isolation requirement using Delta Beta method for Muon 2
  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.15)

  # Tau decay mode finding along with discrimination against electron and muon, and primary vertex matching
  def tau_id(self, row):
    return bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5) and bool(abs(row.tPVDZ) < 0.2)

  # Tight Working Point(WP) for Isolation for tau
  def tau_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)

  # Loose Working Point(WP) for Isolation for tau
  def tau_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)

  # Very Loose Working Point(WP) for Isolation for tau
  def tau_vloose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVLoose > 0.5)

  # Very Tight Working Point(WP) for Isolation for tau
  def tau_vtight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVTight > 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'loose', 'LDM0', 'LDM1', 'LDM10', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'tight', 'TDM0', 'TDM1', 'TDM10', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEEDM0', 'TEEDM1', 'TEEDM10']
    for n in names:
      self.book(n, "tPt", "Tau Pt", 20, 0, 200)
      self.book(n, "tEta", "Tau Eta", 20, -3, 3)
      self.book(n, "tDecayMode", "Tau Decay Mode", 20, 0, 20)
      self.book(n, "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(n, "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(n, "m1Eta", "Muon 1 Eta", 20, -3, 3)
      self.book(n, "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(n, "m2Eta", "Muon 2 Eta", 20, -3, 3)


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

  # Tau energy scale correction
  def tauPtC(self, row, myTau):
    tmpTau = myTau
    if self.is_mc and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        tmpTau = myTau * ROOT.Double(0.994)
      elif row.tDecayMode == 1:
        tmpTau = myTau * ROOT.Double(0.995)
      elif row.tDecayMode == 10:
        tmpTau = myTau * ROOT.Double(1.000)
    ## 2017 numbers below. Need to update when 2018 numbers are available.
    # if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
    #   if row.tDecayMode == 0:
    #     tmpTau = myTau * ROOT.Double(1.003)
    #   elif row.tDecayMode == 1:
    #     tmpTau = myTau * ROOT.Double(1.036)

    return tmpTau


  def process(self):

    for row in self.tree:

      trigger24m1 = row.IsoMu24Pass and row.m1Pt > 26 and row.m1MatchesIsoMu24Filter and row.m1MatchesIsoMu24Path
      trigger24m2 = row.IsoMu24Pass and row.m2Pt > 26 and row.m2MatchesIsoMu24Filter and row.m2MatchesIsoMu24Path

      if self.filters(row):
        continue

      if not bool(trigger24m1 or trigger24m2):
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

      weight = 1.0
      if self.is_mc:
        # Need updating: Trigger Scale Factors
        if trigger24m1:
          tEff = self.triggerEff24(row.m1Pt, abs(row.m1Eta))[0]
          weight = weight * tEff
        elif trigger24m2:
          tEff = self.triggerEff24(row.m2Pt, abs(row.m2Eta))[0]
          weight = weight * tEff
        # Muon 1 Scale Factors
        m1ID = self.muonTightID(myMuon1.Eta(), myMuon1.Pt())
        m1Iso = self.muonTightIsoTightID(myMuon1.Eta(), myMuon1.Pt())
        m1Trk = self.muTracking(myMuon1.Eta())[0]
        # Muon 2 Scale Factors
        m2ID = self.muonTightID(myMuon2.Eta(), myMuon2.Pt())
        m2Iso = self.muonTightIsoTightID(myMuon2.Eta(), myMuon2.Pt())
        m2Trk = self.muTracking(myMuon2.Eta())[0]
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * m1ID * m1Iso * m1Trk * m2ID * m2Iso * m2Trk
        # Anti-Muon and Anti-Electron Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(row.tEta) < 0.4:
            weight = weight * 1.274
          elif abs(row.tEta) < 0.8:
            weight = weight * 1.144
          elif abs(row.tEta) < 1.2:
            weight = weight * 1.261
          elif abs(row.tEta) < 1.7:
            weight = weight * 1.159
          else:
            weight = weight * 3.31
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3: 
          if abs(row.tEta) < 1.448:
            weight = weight * 1.175
          elif abs(row.tEta) > 1.558:
            weight = weight * 1.288
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if self.tau_tight(row):
            if row.tPt <= 35:
              weight = weight * 0.913
            elif row.tPt <= 40:
              weight = weight * 0.896
            else:
              weight = weight * 0.928
          elif self.tau_vloose(row):
            if row.tPt <= 35:
              weight = weight * 0.942
            elif row.tPt <= 40:
              weight = weight * 0.866
            else:
              weight = weight * 0.994
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        weight = self.mcWeight.lumiWeight(weight)

      # B-Jet Veto using b-tagging event weight method
      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data) and nbtag > 0):
        weight = 0

      # Fill the plots based on the tau decay mode, eta, and isolation
      self.fill_histos(row, myMuon1, myMuon2, myTau, weight, 'initial')

      if self.tau_vloose(row):
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
