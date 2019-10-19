'''

Run Tau Fake Rate calculation for the e+tau_h channel.

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
from bTagSF import PromoteDemote

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEET(MegaBase):
  tree = 'eet/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

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

    super(AnalyzeEET, self).__init__(tree, outfile, **kwargs)
    self.tree = EETauTree.EETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self,row):
    if row.e1Charge * row.e2Charge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.e1Pt < 10 or abs(row.e1Eta) >= 2.5:
      return False
    if row.e2Pt < 10 or abs(row.e2Eta) >= 2.5:
      return False
    if row.tPt < 23 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def obj1_id(self,row):
    return (bool(row.e1MVANoisoWP80) and bool(abs(row.e1PVDZ) < 0.2) and bool(abs(row.e1PVDXY) < 0.045) and bool(row.e1PassesConversionVeto) and bool(row.e1MissingHits < 2))
 
 
  def obj1_iso(self,row):
    return bool(row.e1RelPFIsoRho < 0.1)
  
  
  def obj2_id(self, row):
    return (bool(row.e2MVANoisoWP80) and bool(abs(row.e2PVDZ) < 0.2) and bool(abs(row.e2PVDXY) < 0.045) and bool(row.e2PassesConversionVeto) and bool(row.e2MissingHits < 2))


  def obj2_iso(self, row):
    return bool(row.e2RelPFIsoRho < 0.1)


  def tau_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronTightMVA6 > 0.5) and bool(row.tAgainstMuonLoose3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def tau_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def tau_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVLoose > 0.5)


  def vetos(self, row):
    return bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    names=['initial', 'loose', 'LDM0', 'LDM1', 'LDM10', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'tight', 'TDM0', 'TDM1', 'TDM10', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEEDM0', 'TEEDM1', 'TEEDM10']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "tPt", "Tau Pt", 20, 0, 200)
      self.book(names[x], "tEta", "Tau Eta", 20, -3, 3)
      self.book(names[x], "tDecayMode", "Tau Decay Mode", 20, 0, 20)
      self.book(names[x], "e1_e2_Mass", "Invariant Electron Mass", 10, 50, 150)
      self.book(names[x], "e1Pt", "Electron 1 Pt", 20, 0, 200)
      self.book(names[x], "e1Eta", "Electron 1 Eta", 20, -3, 3)
      self.book(names[x], "e2Pt", "Electron 2 Pt", 20, 0, 200)
      self.book(names[x], "e2Eta", "Electron 2 Eta", 20, -3, 3)


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

      e1trigger27 = row.Ele27WPTightPass and row.e1MatchesEle27Filter and row.e1MatchesEle27Path and row.e1Pt > 28
      e1trigger32 = row.Ele32WPTightPass and row.e1MatchesEle32Filter and row.e1MatchesEle32Path and row.e1Pt > 33
      e1trigger35 = row.Ele35WPTightPass and row.e1MatchesEle35Filter and row.e1MatchesEle35Path and row.e1Pt > 36
      e2trigger27 = row.Ele27WPTightPass and row.e2MatchesEle27Filter and row.e2MatchesEle27Path and row.e2Pt > 28
      e2trigger32 = row.Ele32WPTightPass and row.e2MatchesEle32Filter and row.e2MatchesEle32Path and row.e2Pt > 33
      e2trigger35 = row.Ele35WPTightPass and row.e2MatchesEle35Filter and row.e2MatchesEle35Path and row.e2Pt > 36

      if self.filters(row):
        continue

      if not bool(e1trigger27 or e1trigger32 or e1trigger35 or e2trigger27 or e2trigger32 or e2trigger35):
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
        if e1trigger27 or e1trigger32 or e1trigger35:
          self.w2.var("e_pt").setVal(myEle1.Pt())
          self.w2.var("e_eta").setVal(myEle1.Eta())
          tEff = 0 if self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()==0 else self.w2.function("e_trg27_trg32_trg35_kit_data").getVal()/self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()
        if e2trigger27 or e2trigger32 or e2trigger35:
          self.w2.var("e_pt").setVal(myEle2.Pt())
          self.w2.var("e_eta").setVal(myEle2.Eta())
          tEff = 0 if self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()==0 else self.w2.function("e_trg27_trg32_trg35_kit_data").getVal()/self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()
        self.w2.var("e_pt").setVal(myEle1.Pt())
        self.w2.var("e_iso").setVal(row.e1RelPFIsoRho)
        self.w2.var("e_eta").setVal(myEle1.Eta())
        e1ID = self.w2.function("e_id80_kit_ratio").getVal()
        e1Iso = self.w2.function("e_iso_kit_ratio").getVal()
        e1Trk = self.w2.function("e_trk_ratio").getVal()
        self.w2.var("e_pt").setVal(myEle2.Pt())
        self.w2.var("e_iso").setVal(row.e2RelPFIsoRho)
        self.w2.var("e_eta").setVal(myEle2.Eta())
        e2ID = self.w2.function("e_id80_kit_ratio").getVal()
        e2Iso = self.w2.function("e_iso_kit_ratio").getVal()
        e2Trk = self.w2.function("e_trk_ratio").getVal()
        zvtx = 0.991 
        weight = weight * tEff * e1ID * e1Iso * e1Trk * e2ID * e2Iso * e2Trk * zvtx
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

      self.fill_histos(row, myEle1, myEle2, myTau, weight, 'initial')

      if self.tau_loose(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'loose')
        if row.tDecayMode == 0:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LDM0')
        elif row.tDecayMode == 1:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LDM1')
        elif row.tDecayMode == 10:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LDM10')

        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEBDM10')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'LEEDM10')

      if self.tau_tight(row):
        self.fill_histos(row, myEle1, myEle2, myTau, weight, 'tight')
        if row.tDecayMode == 0:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TDM0')
        elif row.tDecayMode == 1:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TDM1')
        elif row.tDecayMode == 10:
          self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TDM10')

        if abs(row.tEta) < 1.5:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEBDM10')
        else:
          if row.tDecayMode == 0:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM0')
          elif row.tDecayMode == 1:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM1')
          elif row.tDecayMode == 10:
            self.fill_histos(row, myEle1, myEle2, myTau, weight, 'TEEDM10')


  def finish(self):
    self.write_histos()
