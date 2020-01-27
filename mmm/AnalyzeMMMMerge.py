'''

Muon Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import MuMuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from bTagSF import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeMMMMerge(MegaBase):
  tree = 'mmm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
    self.triggerEff50 = mcCorrections.muonTrigger50
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muonMediumID = mcCorrections.muonID_medium
    self.muonTightIsoMediumID = mcCorrections.muonIso_tight_mediumid
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid
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

    super(AnalyzeMMMMerge, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuMuTree.MuMuMuTree(tree)
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
    if row.m3Pt < 20 or abs(row.m3Eta) >= 2.4:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Particle Flow Identification along with Primary Vertex matching for Muon 1
  def obj1_id(self,row):
    return bool(row.m1PFIDMedium) and bool(abs(row.m1PVDZ) < 0.2) and bool(abs(row.m1PVDXY) < 0.045)

  # Isolation requirement using Delta Beta method for Muon 1
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.25)

  # Particle Flow Identification along with Primary Vertex matching for Muon 2
  def obj2_id(self, row):
    return bool(row.m2PFIDMedium) and bool(abs(row.m2PVDZ) < 0.2) and bool(abs(row.m2PVDXY) < 0.045)

  # Isolation requirement using Delta Beta method for Muon 2
  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.25)

  # Particle Flow Identification along with Primary Vertex matching for Muon 3
  def muon_id(self, row):
    return bool(row.m3PFIDTight) and bool(abs(row.m3PVDZ) < 0.2) and bool(abs(row.m3PVDXY) < 0.045)

  # Tight Isolation for Muon 3
  def muon_tight(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.15)

  # Loose Isolation for Muon 3
  def muon_loose(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.25)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['muonloose', 'muontight']
    for n in names:
      self.book(n, "mPt", "Muon Pt", 20, 0, 200)
      self.book(n, "mEta", "Muon Eta", 20, -3, 3)


  def fill_histos(self, myMuon3, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon3.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon3.Eta(), weight)


  def process(self):

    for row in self.tree:

      trigger24m1 = row.IsoMu24Pass and row.m1Pt > 26 and row.m1MatchesIsoMu24Filter and row.m1MatchesIsoMu24Path
      trigger24m2 = row.IsoMu24Pass and row.m2Pt > 26 and row.m2MatchesIsoMu24Filter and row.m2MatchesIsoMu24Path
      trigger24m3 = row.IsoMu24Pass and row.m3Pt > 26 and row.m3MatchesIsoMu24Filter and row.m3MatchesIsoMu24Path
      trigger50 = row.Mu50Pass and row.m1Pt > 52

      if self.filters(row):
        continue

      if not bool(trigger24m1 or trigger24m2 or trigger24m3 or trigger50):
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
      myMuon3 = ROOT.TLorentzVector()
      myMuon3.SetPtEtaPhiM(row.m3Pt, row.m3Eta, row.m3Phi, row.m3Mass)

      z1diff = abs(91.19 - self.visibleMass(myMuon1, myMuon2))
      z2diff = abs(91.19 - self.visibleMass(myMuon1, myMuon3))
      z3diff = abs(91.19 - self.visibleMass(myMuon2, myMuon3))

      if row.m1Charge * row.m3Charge == -1:
        if z1diff > z2diff:
          continue

      if row.m2Charge * row.m3Charge == -1:
        if z1diff > z3diff:
          continue

      if z1diff > 20:
        continue

      if not self.muon_id(row):
        continue

      weight = 1.0
      if self.is_mc:
        if trigger24m1:
          tEff = self.triggerEff24(row.m1Pt, abs(row.m1Eta))[0]
          weight = weight * tEff
        elif trigger24m2:
          tEff = self.triggerEff24(row.m2Pt, abs(row.m2Eta))[0]
          weight = weight * tEff
        elif trigger24m3:
          tEff = self.triggerEff24(row.m3Pt, abs(row.m3Eta))[0]
          weight = weight * tEff
        elif trigger50:
          tEff = self.triggerEff50(row.m1Pt, abs(row.m1Eta))
          weight = weight * tEff
        # Muon 1 Scale Factors
        m1ID = self.muonMediumID(myMuon1.Eta(), myMuon1.Pt())
        m1Iso = self.muonLooseIsoMediumID(myMuon1.Eta(), myMuon1.Pt())
        m1Trk = self.muTracking(myMuon1.Eta())[0]
        # Muon 2 Scale Factors
        m2ID = self.muonMediumID(myMuon2.Eta(), myMuon2.Pt())
        m2Iso = self.muonLooseIsoMediumID(myMuon2.Eta(), myMuon2.Pt())
        m2Trk = self.muTracking(myMuon2.Eta())[0]
        # Muon 3 Scale Factors
        m3ID = self.muonTightID(myMuon3.Eta(), myMuon3.Pt())
        m3Trk = self.muTracking(myMuon3.Eta())[0]
        if self.muon_loose(row):
          m3Iso = self.muonLooseIsoTightID(myMuon3.Eta(), myMuon3.Pt())
          weight = weight * m3Iso
        if self.muon_tight(row):
          m3Iso = self.muonTightIsoTightID(myMuon3.Eta(), myMuon3.Pt())
          weight = weight * m3Iso
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * m1ID * m1Iso * m1Trk * m2ID * m2Iso * m2Trk * m3ID * m3Trk
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

      # Fill the plots
      if self.muon_loose(row):
        self.fill_histos(myMuon3, weight, 'muonloose')

      if self.muon_tight(row):
        self.fill_histos(myMuon3, weight, 'muontight')


  def finish(self):
    self.write_histos()
