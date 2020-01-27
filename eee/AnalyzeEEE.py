'''

Electron Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import EEETree
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

class AnalyzeEEE(MegaBase):
  tree = 'eee/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.Ele25 = mcCorrections.Ele25
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.eIDnoiso90 = mcCorrections.eIDnoiso90
    self.DYreweight = mcCorrections.DYreweight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeEEE, self).__init__(tree, outfile, **kwargs)
    self.tree = EEETree.EEETree(tree)
    self.out = outfile
    self.histograms = {}

  # Charge requirement for the electrons to be coming from Z-decay
  def oppositesign(self, row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.e1Pt < 10 or abs(row.e1Eta) >= 2.1:
      return False
    if row.e2Pt < 10 or abs(row.e2Eta) >= 2.1:
      return False
    if row.e3Pt < 10 or abs(row.e3Eta) >= 2.1:
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

  # MVA Identification along with Primary Vertex matching for Electron 3
  def ele_id(self, row):
    return (bool(row.e3MVANoisoWP80) and bool(abs(row.e3PVDZ) < 0.2) and bool(abs(row.e3PVDXY) < 0.045) and bool(row.e3PassesConversionVeto) and bool(row.e3MissingHits < 2))

  # Tight Isolation for Electron 3
  def ele_tight(self, row):
    return bool(row.e3RelPFIsoRho < 0.15)

  # Loose Isolation for Electron 3
  def ele_loose(self, row):
    return bool(row.e3RelPFIsoRho < 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'eleloose', 'eletight']
    for n in names:
      self.book(n, "e3Pt", "Ele 3 Pt", 20, 0, 200)
      self.book(n, "e3Eta", "Ele 3 Eta", 20, -3, 3)
      self.book(n, "e1_e2_Mass", "Invariant Ele Mass", 10, 50, 150)
      self.book(n, "e1Pt", "Ele 1 Pt", 20, 0, 200)
      self.book(n, "e1Eta", "Ele 1 Eta", 20, -3, 3)
      self.book(n, "e2Pt", "Ele 2 Pt", 20, 0, 200)
      self.book(n, "e2Eta", "Ele 2 Eta", 20, -3, 3)


  def fill_histos(self, myEle1, myEle2, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/e3Pt'].Fill(myEle.Pt(), weight)
    histos[name+'/e3Eta'].Fill(myEle.Eta(), weight)
    histos[name+'/e1_e2_Mass'].Fill(self.visibleMass(myEle1, myEle2), weight)
    histos[name+'/e1Pt'].Fill(myEle1.Pt(), weight)
    histos[name+'/e1Eta'].Fill(myEle1.Eta(), weight)
    histos[name+'/e2Pt'].Fill(myEle2.Pt(), weight)
    histos[name+'/e2Eta'].Fill(myEle2.Eta(), weight)


  def process(self):

    for row in self.tree:

      trigger25e1 = row.singleE25eta2p1TightPass and row.e1MatchesEle25Filter and row.e1MatchesEle25Path and row.e1Pt > 27
      trigger25e2 = row.singleE25eta2p1TightPass and row.e2MatchesEle25Filter and row.e2MatchesEle25Path and row.e2Pt > 27
      trigger25e3 = row.singleE25eta2p1TightPass and row.e3MatchesEle25Filter and row.e3MatchesEle25Path and row.e3Pt > 27

      if self.filters(row):
        continue

      if not bool(trigger25e1 or trigger25e2 or trigger25e3):
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

      myEle1 = ROOT.TLorentzVector()
      myEle1.SetPtEtaPhiM(row.e1Pt, row.e1Eta, row.e1Phi, row.e1Mass)
      myEle2 = ROOT.TLorentzVector()
      myEle2.SetPtEtaPhiM(row.e2Pt, row.e2Eta, row.e2Phi, row.e2Mass)
      myEle3 = ROOT.TLorentzVector()
      myEle3.SetPtEtaPhiM(row.e3Pt, row.e3Eta, row.e3Phi, row.e3Mass)
      #myEle3 = myEle3 * ROOT.Double(row.e3CorrectedEt/row.e3ecalEnergy)

      z1diff = abs(91.19 - self.visibleMass(myEle1, myEle2))
      z2diff = abs(91.19 - self.visibleMass(myEle1, myEle3))
      z3diff = abs(91.19 - self.visibleMass(myEle2, myEle3))

      if row.e1Charge * row.e3Charge == -1:
        if z1diff > z2diff:
          continue

      if row.e2Charge * row.e3Charge == -1:
        if z1diff > z3diff:
          continue

      if z1diff > 20:
        continue

      if not self.ele_id(row):
        continue

      if not self.ele_loose(row):
        continue

      weight = 1.0
      if self.is_mc:
        # Need updating: Trigger Scale Factors
        if trigger25e1:
          tEff = self.Ele25(row.e1Pt, abs(row.e1Eta))[0]
          weight = weight * tEff
        elif trigger25e2:
          tEff = self.Ele25(row.e2Pt, abs(row.e2Eta))[0]
          weight = weight * tEff
        elif trigger25e3:
          tEff = self.Ele25(row.e3Pt, abs(row.e3Eta))[0]
          weight = weight * tEff
        # Electron 1 Scale Factors
        e1ID = self.eIDnoiso90(row.e1Eta, row.e1Pt)
        # Electron 2 Scale Factors
        e2ID = self.eIDnoiso90(row.e2Eta, row.e2Pt)
        # Electron 3 Scale Factors
        e3ID = self.eIDnoiso80(row.e3Eta, row.e3Pt)
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * e1ID * e2ID * e3ID
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
      self.fill_histos(myEle1, myEle2, myEle3, weight, 'initial')

      if self.ele_loose(row):
        self.fill_histos(myEle1, myEle2, myEle3, weight, 'eleloose')

      if self.ele_tight(row):
        self.fill_histos(myEle1, myEle2, myEle3, weight, 'eletight')


  def finish(self):
    self.write_histos()
