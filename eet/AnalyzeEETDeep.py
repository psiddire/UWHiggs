'''

Tau Fake Rate calculation in the Z+Jets control region.

Authors: Prasanna Siddireddy

'''

import EETauTree
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

class AnalyzeEETDeep(MegaBase):
  tree = 'eet/final/Ntuple'

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

    super(AnalyzeEETDeep, self).__init__(tree, outfile, **kwargs)
    self.tree = EETauTree.EETauTree(tree)
    self.out = outfile
    self.histograms = {}

  # Charge requirement for the electrons to be coming from Z-decay
  def oppositesign(self,row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.e1Pt < 10 or abs(row.e1Eta) >= 2.1:
      return False
    if row.e2Pt < 10 or abs(row.e2Eta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
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

  # Tau decay mode finding along with discrimination against electron and muon, and primary vertex matching
  def tau_id(self, row):
    return bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tTightDeepTau2017v2p1VSe > 0.5) and bool(row.tLooseDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2)

  # Tight Working Point(WP) for Isolation for tau
  def tau_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)

  # Very Loose Working Point(WP) for Isolation for tau
  def tau_vloose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['initial', 'loose', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEBDM11', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'LEEDM11', 'tight', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEBDM11', 'TEEDM0', 'TEEDM1', 'TEEDM10', 'TEEDM11']
    for n in names:
      self.book(n, "tPt", "Tau Pt", 20, 0, 200)
      self.book(n, "tEta", "Tau Eta", 20, -3, 3)
      self.book(n, "tDecayMode", "Tau Decay Mode", 20, 0, 20)
      self.book(n, "e1_e2_Mass", "Invariant Electron Mass", 10, 50, 150)
      self.book(n, "e1Pt", "Electron 1 Pt", 20, 0, 200)
      self.book(n, "e1Eta", "Electron 1 Eta", 20, -3, 3)
      self.book(n, "e2Pt", "Electron 2 Pt", 20, 0, 200)
      self.book(n, "e2Eta", "Electron 2 Eta", 20, -3, 3)


  def fill_histos(self, row, myEle1, myEle2, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/tPt'].Fill(myTau.Pt(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/tDecayMode'].Fill(row.tDecayMode, weight)
    histos[name+'/e1_e2_Mass'].Fill(self.visibleMass(myEle1, myEle2), weight)
    histos[name+'/e1Pt'].Fill(myEle1.Pt(), weight)
    histos[name+'/e1Eta'].Fill(myEle1.Eta(), weight)
    histos[name+'/e2Pt'].Fill(myEle2.Pt(), weight)
    histos[name+'/e2Eta'].Fill(myEle2.Eta(), weight)

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
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if abs(myTau.Eta()) < 1.448:
        if row.tDecayMode == 0:
          tmpTau = myTau * ROOT.Double(1.007)
        elif row.tDecayMode == 1:
          tmpTau = myTau * ROOT.Double(1.035)
      elif abs(myTau.Eta()) > 1.558:
        if row.tDecayMode == 0:
          tmpTau = myTau * ROOT.Double(0.965)
        elif row.tDecayMode == 1:
          tmpTau = myTau * ROOT.Double(1.05)
    return tmpTau


  def process(self):

    for row in self.tree:

      trigger25e1 = row.singleE25eta2p1TightPass and row.e1MatchesEle25Filter and row.e1MatchesEle25Path and row.e1Pt > 27
      trigger25e2 = row.singleE25eta2p1TightPass and row.e2MatchesEle25Filter and row.e2MatchesEle25Path and row.e2Pt > 27

      if self.filters(row):
        continue

      if not bool(trigger25e1 or trigger25e2):
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
      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
      myTau = self.tauPtC(row, myTau)

      if self.visibleMass(myEle1, myEle2) < 70 or self.visibleMass(myEle1, myEle2) > 110:
        continue

      if not self.tau_id(row):
        continue

      if row.tDecayMode==5 or row.tDecayMode==6:
        continue

      weight = 1.0
      if self.is_mc:
        # Trigger Scale Factors
        if trigger25e1:
          tEff = self.Ele25(row.e1Pt, abs(row.e1Eta))[0]
          weight = weight * tEff
        elif trigger25e2:
          tEff = self.Ele25(row.e2Pt, abs(row.e2Eta))[0]
          weight = weight * tEff
        # Electron 1 Scale Factors
        e1ID = self.eIDnoiso90(row.e1Eta, row.e1Pt)
        # Electron 2 Scale Factors
        e2ID = self.eIDnoiso90(row.e2Eta, row.e2Pt)
        weight = weight * row.GenWeight * pucorrector[''](row.nTruePU) * e1ID * e2ID
        # Anti-Muon Discriminator Scale Factors
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(row.tEta) < 0.4:
            weight = weight * 1.379
          elif abs(row.tEta) < 0.8:
            weight = weight * 0.955
          elif abs(row.tEta) < 1.2:
            weight = weight * 1.326
          elif abs(row.tEta) < 1.7:
            weight = weight * 1.040
          else:
            weight = weight * 5.981
        # Anti-Electron Discriminator Scale Factors
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3: 
          if abs(row.tEta) < 1.448:
            weight = weight * 1.22
          elif abs(row.tEta) > 1.558:
            weight = weight * 1.47
        # Tau ID Scale Factor
        elif row.tZTTGenMatching==5:
          if self.tau_tight(row):
            if row.tPt <= 35:
              weight = weight * 0.893
            elif row.tPt <= 40:
              weight = weight * 0.878
            else:
              weight = weight * 0.921
          elif self.tau_vloose(row):
            if row.tPt <= 35:
              weight = weight * 0.961
            elif row.tPt <= 40:
              weight = weight * 0.925
            else:
              weight = weight * 0.976
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
      self.fill_histos(row, myEle1, myEle2, myTau, weight, 'initial')

      if self.tau_vloose(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'loose')
        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM11')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM11')

      if self.tau_tight(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'tight')
        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM11')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM10')
          elif row.tDecayMode == 11:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM11')


  def finish(self):
    self.write_histos()
