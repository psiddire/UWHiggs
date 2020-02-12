'''

Run Electron Fake Rate calculation for the e+tau_h channel.

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

class AnalyzeEEEMerge(MegaBase):
  tree = 'eee/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.eIDnoiso90 = mcCorrections.eIDnoiso90
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.eReco = mcCorrections.eReco
    self.w2 = mcCorrections.w2
    self.DYreweight = mcCorrections.DYreweight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    super(AnalyzeEEEMerge, self).__init__(tree, outfile, **kwargs)
    self.tree = EEETree.EEETree(tree)
    self.out = outfile
    self.histograms = {}

  # Charge requirement for the electrons to be coming from Z-decay
  def oppositesign(self,row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True

  # Kinematic Selections
  def kinematics(self, row):
    if row.e1Pt < 20 or abs(row.e1Eta) >= 2.5:
      return False
    if row.e2Pt < 20 or abs(row.e2Eta) >= 2.5:
      return False
    if row.e3Pt < 20 or abs(row.e3Eta) >= 2.1:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # MVA Identification along with Primary Vertex matching for Electron 1
  def obj1_id(self,row):
    return (bool(row.e1MVANoisoWP90) and bool(abs(row.e1PVDZ) < 0.2) and bool(abs(row.e1PVDXY) < 0.045) and bool(row.e1PassesConversionVeto) and bool(row.e1MissingHits < 2))

  # Isolation requirement using Effective Area method for Electron 1
  def obj1_iso(self,row):
    return bool(row.e1RelPFIsoRho < 0.15)

  # MVA Identification along with Primary Vertex matching for Electron 2
  def obj2_id(self, row):
    return (bool(row.e2MVANoisoWP90) and bool(abs(row.e2PVDZ) < 0.2) and bool(abs(row.e2PVDXY) < 0.045) and bool(row.e2PassesConversionVeto) and bool(row.e2MissingHits < 2))

  # Isolation requirement using Effective Area method for Electron 2
  def obj2_iso(self, row):
    return bool(row.e2RelPFIsoRho < 0.15)

  # MVA Identification along with Primary Vertex matching for Electron 3
  def obj3_id(self, row):
    return (bool(row.e3MVANoisoWP80) and bool(abs(row.e3PVDZ) < 0.2) and bool(abs(row.e3PVDXY) < 0.045) and bool(row.e3PassesConversionVeto) and bool(row.e3MissingHits < 2))

  # Tight Isolation requirement using Effective Area method for Electron 3
  def obj3_tight(self, row):
    return bool(row.e3RelPFIsoRho < 0.15)

  # Loose Isolation requirement using Effective Area method for Electron 3
  def obj3_loose(self, row):
    return bool(row.e3RelPFIsoRho < 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names = ['eleloose', 'eletight']
    for n in names:
      self.book(n, 'ePt', 'Electron Pt', 20, 0, 200)
      self.book(n, 'eEta', 'Electron Eta', 20, -3, 3)


  def fill_histos(self, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)


  def process(self):

    for row in self.tree:

      e1trigger27 = row.Ele27WPTightPass and row.e1MatchesEle27Filter and row.e1MatchesEle27Path and row.e1Pt > 28
      e1trigger32 = row.Ele32WPTightPass and row.e1MatchesEle32Filter and row.e1MatchesEle32Path and row.e1Pt > 33
      e1trigger35 = row.Ele35WPTightPass and row.e1MatchesEle35Filter and row.e1MatchesEle35Path and row.e1Pt > 36
      e2trigger27 = row.Ele27WPTightPass and row.e2MatchesEle27Filter and row.e2MatchesEle27Path and row.e2Pt > 28
      e2trigger32 = row.Ele32WPTightPass and row.e2MatchesEle32Filter and row.e2MatchesEle32Path and row.e2Pt > 33
      e2trigger35 = row.Ele35WPTightPass and row.e2MatchesEle35Filter and row.e2MatchesEle35Path and row.e2Pt > 36
      e3trigger27 = row.Ele27WPTightPass and row.e3MatchesEle27Filter and row.e3MatchesEle27Path and row.e3Pt > 28
      e3trigger32 = row.Ele32WPTightPass and row.e3MatchesEle32Filter and row.e3MatchesEle32Path and row.e3Pt > 33
      e3trigger35 = row.Ele35WPTightPass and row.e3MatchesEle35Filter and row.e3MatchesEle35Path and row.e3Pt > 36

      if self.filters(row):
        continue

      if not bool(e1trigger27 or e1trigger32 or e1trigger35 or e2trigger27 or e2trigger32 or e2trigger35 or e3trigger27 or e3trigger32 or e3trigger35):
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
      myEle1 = myEle1 * ROOT.Double(row.e1CorrectedEt/row.e1ecalEnergy)
      myEle2 = ROOT.TLorentzVector()
      myEle2.SetPtEtaPhiM(row.e2Pt, row.e2Eta, row.e2Phi, row.e2Mass)
      myEle2 = myEle2 * ROOT.Double(row.e2CorrectedEt/row.e2ecalEnergy)
      myEle3 = ROOT.TLorentzVector()
      myEle3.SetPtEtaPhiM(row.e3Pt, row.e3Eta, row.e3Phi, row.e3Mass)
      myEle3 = myEle3 * ROOT.Double(row.e3CorrectedEt/row.e3ecalEnergy)

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

      if not self.obj3_id(row):
        continue

      weight = 1.0
      if self.is_mc:
        if e1trigger27 or e1trigger32 or e1trigger35:
          self.w2.var('e_pt').setVal(myEle1.Pt())
          self.w2.var('e_eta').setVal(myEle1.Eta())
          tEff = 0 if self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w2.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()
        elif e2trigger27 or e2trigger32 or e2trigger35:
          self.w2.var('e_pt').setVal(myEle2.Pt())
          self.w2.var('e_eta').setVal(myEle2.Eta())
          tEff = 0 if self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w2.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()
        elif e3trigger27 or e3trigger32 or e3trigger35:
          self.w2.var('e_pt').setVal(myEle3.Pt())
          self.w2.var('e_eta').setVal(myEle3.Eta())
          tEff = 0 if self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w2.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()
        zvtx = 0.991
        # Electron 1 Scale Factors
        e1ID = self.eIDnoiso90(row.e1Eta, row.e1Pt)
        e1Trk = self.eReco(row.e1Eta, row.e1Pt)
        # Electron 2 Scale Factors
        e2ID = self.eIDnoiso90(row.e2Eta, row.e2Pt)
        e2Trk = self.eReco(row.e2Eta, row.e2Pt)
        # Electron 3 Scale Factors
        e3ID = self.eIDnoiso80(row.e3Eta, row.e3Pt)
        e3Trk = self.eReco(row.e3Eta, row.e3Pt)
        weight = weight * tEff * e1ID * e1Trk * e2ID * e2Trk * e3ID * e3Trk * zvtx
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        weight = self.mcWeight.lumiWeight(weight)

      if self.obj3_loose(row):
        self.fill_histos(myEle3, weight, 'eleloose')

      if self.obj3_tight(row):
        self.fill_histos(myEle3, weight, 'eletight')


  def finish(self):
    self.write_histos()
