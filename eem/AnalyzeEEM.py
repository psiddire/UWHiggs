'''

Muon Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import EEMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEEM(MegaBase):
  tree = 'eem/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.Ele32or35 = mcCorrections.Ele32or35
    self.EleIdIso = mcCorrections.EleIdIso
    self.muonTightID = mcCorrections.muonID_tight
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.DYreweight = mcCorrections.DYreweight
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeEEM, self).__init__(tree, outfile, **kwargs)
    self.tree = EEMuTree.EEMuTree(tree)
    self.out = outfile
    self.histograms = {}

  # Charge requirement for the electrons to be coming from Z-decay
  def oppositesign(self, row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.e1Pt < 10 or abs(row.e1Eta) >= 2.5:
      return False
    if row.e2Pt < 10 or abs(row.e2Eta) >= 2.5:
      return False
    if row.mPt < 20 or abs(row.mEta) >= 2.4:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # MVA Identification along with Primary Vertex matching for Electron 1
  def obj1_id(self, row):
    return (bool(row.e1MVANoisoWP90) and bool(abs(row.e1PVDZ) < 0.2) and bool(abs(row.e1PVDXY) < 0.045) and bool(row.e1PassesConversionVeto) and bool(row.e1MissingHits < 2))

  # Isolation requirement using Effective Area method for Electron 1
  def obj1_iso(self, row):
    return bool(row.e1RelPFIsoRho < 0.15)

  # MVA Identification along with Primary Vertex matching for Electron 2
  def obj2_id(self, row):
    return (bool(row.e2MVANoisoWP90) and bool(abs(row.e2PVDZ) < 0.2) and bool(abs(row.e2PVDXY) < 0.045) and bool(row.e2PassesConversionVeto) and bool(row.e2MissingHits < 2))

  # Isolation requirement using Effective Area method for Electron 2
  def obj2_iso(self, row):
    return bool(row.e2RelPFIsoRho < 0.15)

  # Particle Flow Identification along with Primary Vertex matching for Muon
  def muon_id(self, row):
    return bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045)

  # Tight Isolation for Muon
  def muon_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Loose Isolation for Muon
  def muon_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'muonloose', 'muontight']
    for n in names:
      self.book(n, "mPt", "Muon Pt", 20, 0, 200)
      self.book(n, "mEta", "Muon Eta", 20, -3, 3)
      self.book(n, "e1_e2_Mass", "Invariant Electron Mass", 10, 50, 150)
      self.book(n, "e1Pt", "Ele 1 Pt", 20, 0, 200)
      self.book(n, "e1Eta", "Ele 1 Eta", 20, -3, 3)
      self.book(n, "e2Pt", "Ele 2 Pt", 20, 0, 200)
      self.book(n, "e2Eta", "Ele 2 Eta", 20, -3, 3)


  def fill_histos(self, myEle1, myEle2, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/e1_e2_Mass'].Fill(self.visibleMass(myEle1, myEle2), weight)
    histos[name+'/e1Pt'].Fill(myEle1.Pt(), weight)
    histos[name+'/e1Eta'].Fill(myEle1.Eta(), weight)
    histos[name+'/e2Pt'].Fill(myEle2.Pt(), weight)
    histos[name+'/e2Eta'].Fill(myEle2.Eta(), weight)


  def process(self):

    for row in self.tree:

      trigger27e1 = row.Ele27WPTightPass and row.e1MatchesEle27Filter and row.e1MatchesEle27Path and row.e1Pt > 28
      trigger32e1 = row.Ele32WPTightPass and row.e1MatchesEle32Filter and row.e1MatchesEle32Path and row.e1Pt > 33
      trigger35e1 = row.Ele35WPTightPass and row.e1MatchesEle35Filter and row.e1MatchesEle35Path and row.e1Pt > 36
      trigger27e2 = row.Ele27WPTightPass and row.e2MatchesEle27Filter and row.e2MatchesEle27Path and row.e2Pt > 28
      trigger32e2 = row.Ele32WPTightPass and row.e2MatchesEle32Filter and row.e2MatchesEle32Path and row.e2Pt > 33
      trigger35e2 = row.Ele35WPTightPass and row.e2MatchesEle35Filter and row.e2MatchesEle35Path and row.e2Pt > 36

      if self.filters(row):
        continue

      if not bool(trigger27e1 or trigger27e2 or ttrigger32e1 or trigger32e2 or trigger35e1 or trigger35e2):
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

      if not self.muon_id(row):
        continue

      myEle1 = ROOT.TLorentzVector()
      myEle1.SetPtEtaPhiM(row.e1Pt, row.e1Eta, row.e1Phi, row.e1Mass)
      myEle2 = ROOT.TLorentzVector()
      myEle2.SetPtEtaPhiM(row.e2Pt, row.e2Eta, row.e2Phi, row.e2Mass)
      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      if self.visibleMass(myEle1, myEle2) < 70 or self.visibleMass(myEle1, myEle2) > 110:
        continue

      weight = 1.0
      if self.is_mc:
        # Trigger Scale Factors
        self.w1.var('e_pt').setVal(myEle1.Pt())
        self.w1.var('e_eta').setVal(myEle1.Eta())
        self.w1.var('e_iso').setVal(row.e1RelPFIsoRho)
        eID1 = self.w1.function('e_id90_kit_ratio').getVal()
        eIso1 = self.w1.function('e_iso_kit_ratio').getVal()
        eReco1 = self.w1.function('e_trk_ratio').getVal()
        if e1trigger27 or e1trigger32 or e1trigger35:
          tEff = 0 if self.w1.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w1.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w1.function('e_trg27_trg32_trg35_kit_mc').getVal()
        self.w1.var('e_pt').setVal(myEle2.Pt())
        self.w1.var('e_iso').setVal(row.e2RelPFIsoRho)
        self.w1.var('e_eta').setVal(myEle2.Eta())
        eID2 = self.w1.function('e_id90_kit_ratio').getVal()
        eIso2 = self.w1.function('e_iso_kit_ratio').getVal()
        eReco2 = self.w1.function('e_trk_ratio').getVal()
        if e2trigger27 or e2trigger32 or e2trigger35:
          tEff = 0 if self.w1.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w1.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w1.function('e_trg27_trg32_trg35_kit_mc').getVal()
        # Muon Scale Factors
        mID = self.muonTightID(row.mPt, abs(row.mEta))
        if self.muon_tight(row):
          mIso = self.muonTightIsoTightID(row.mPt, abs(row.mEta))
          weight = weight * mIso
        elif self.muon_loose(row):
          mIso = self.muonLooseIsoTightID(row.mPt, abs(row.mEta))
          weight = weight * mIso
        mTrk = self.muTracking(row.mEta)[0]
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * eID1 * eIso1 * eReco1 * eID2 * eIso2 * eReco2 * tEff * mID * mTrk
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
      nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data) and nbtag > 0):
        weight = 0

      # Fill the plots based on the tau decay mode, eta, and isolation
      self.fill_histos(myEle1, myEle2, myMuon, weight, 'initial')

      if self.muon_loose(row):
        self.fill_histos(myEle1, myEle2, myMuon, weight, 'muonloose')

      if self.muon_tight(row):
        self.fill_histos(myEle1, myEle2, myMuon, weight, 'muontight')


  def finish(self):
    self.write_histos()
