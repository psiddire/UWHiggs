'''

Electron Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import EMMTree
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

class AnalyzeMME(MegaBase):
  tree = 'emm/final/Ntuple'
  
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
    self.muonMediumID = mcCorrections.muonID_medium
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid
    self.muTracking = mcCorrections.muonTracking
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.DYreweight = mcCorrections.DYreweight
    self.rc = mcCorrections.rc

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeMME, self).__init__(tree, outfile, **kwargs)
    self.tree = EMMTree.EMMTree(tree)
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
    if row.ePt < 20 or abs(row.eEta) >= 2.5:
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

  # MVA Identification along with Primary Vertex matching for Electron
  def ele_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Tight Isolation for Electron
  def ele_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)

  # Loose Isolation for Electron
  def ele_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'eleloose', 'eletight']
    for n in names:
      self.book(n, "ePt", "Electron Pt", 20, 0, 200)
      self.book(n, "eEta", "Electron Eta", 20, -3, 3)
      self.book(n, "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(n, "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(n, "m1Eta", "Muon 1 Eta", 20, -3, 3)
      self.book(n, "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(n, "m2Eta", "Muon 2 Eta", 20, -3, 3)


  def fill_histos(self, myMuon1, myMuon2, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/m1_m2_Mass'].Fill(self.visibleMass(myMuon1, myMuon2), weight)
    histos[name+'/m1Pt'].Fill(myMuon1.Pt(), weight)
    histos[name+'/m1Eta'].Fill(myMuon1.Eta(), weight)
    histos[name+'/m2Pt'].Fill(myMuon2.Pt(), weight)
    histos[name+'/m2Eta'].Fill(myMuon2.Eta(), weight)


  def process(self):

    for row in self.tree:

      trigger24m1 = row.IsoMu24Pass and row.m1Pt > 26 and row.m1MatchesIsoMu24Filter and row.m1MatchesIsoMu24Path
      trigger24m2 = row.IsoMu24Pass and row.m2Pt > 26 and row.m2MatchesIsoMu24Filter and row.m2MatchesIsoMu24Path
      trigger50 = row.Mu50Pass and row.m1Pt > 52

      if self.filters(row):
        continue

      if not bool(trigger24m1 or trigger24m2 or trigger50):
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
      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      #myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.visibleMass(myMuon1, myMuon2) < 70 or self.visibleMass(myMuon1, myMuon2) > 110:
        continue

      if not self.ele_id(row):
        continue

      if not self.ele_loose(row):
        continue

      weight = 1.0
      if self.is_mc:
        if trigger24m1:
          tEff = self.triggerEff24(row.m1Pt, abs(row.m1Eta))[0]
          weight = weight * tEff
        elif trigger24m2:
          tEff = self.triggerEff24(row.m2Pt, abs(row.m2Eta))[0]
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
        # Electron Scale Factors
        eID = self.eIDnoiso80(myEle.Eta(), myEle.Pt())
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * m1ID * m1Iso * m1Trk * m2ID * m2Iso * m2Trk * eID
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

      # Fill the plots for electron
      self.fill_histos(myMuon1, myMuon2, myEle, weight, 'initial')

      if self.ele_loose(row):
        self.fill_histos(myMuon1, myMuon2, myEle, weight, 'eleloose')

      if self.ele_tight(row):
        self.fill_histos(myMuon1, myMuon2, myEle, weight, 'eletight')


  def finish(self):
    self.write_histos()
