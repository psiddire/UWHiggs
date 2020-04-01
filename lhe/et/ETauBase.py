'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import FakeRate
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class ETauBase():

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data

    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys
    self.tauSF = mcCorrections.tauSF

    self.eID = mcCorrections.eID
    self.w1 = mcCorrections.w1
    self.deepTauVSe = mcCorrections.deepTauVSe
    self.deepTauVSmu = mcCorrections.deepTauVSmu
    self.deepTauVSjet_tight = mcCorrections.deepTauVSjet_tight
    self.deepTauVSjet_vloose = mcCorrections.deepTauVSjet_vloose
    self.deepTauVSjet_Emb_tight = mcCorrections.deepTauVSjet_Emb_tight
    self.deepTauVSjet_Emb_vloose = mcCorrections.deepTauVSjet_Emb_vloose
    self.esTau = mcCorrections.esTau
    self.FesTau = mcCorrections.FesTau
    self.ScaleTau = mcCorrections.ScaleTau

    self.fakeRate = FakeRate.fakerate_weight
    self.fakeRateEle = FakeRate.fakerateEle_weight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    self.names = Kinematics.names
    self.lhe = Kinematics.lhe

  # Charge Requirement
  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    trigger32 = row.Ele32WPTightPass and row.eMatchesEle32Filter and row.eMatchesEle32Path and row.ePt > 33
    trigger35 = row.Ele35WPTightPass and row.eMatchesEle35Filter and row.eMatchesEle35Path and row.ePt > 36
    if self.is_data and row.run < 317509:
      trigger2430 = row.Ele24LooseTau30Pass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 33 and row.tPt > 32 and abs(row.tEta) < 2.1
    else:
      trigger2430 = row.Ele24LooseHPSTau30Pass and row.eMatchesEle24HPSTau30Filter and row.eMatchesEle24HPSTau30Path and row.tMatchesEle24HPSTau30Filter and row.tMatchesEle24HPSTau30Path and row.ePt > 25 and row.ePt < 33 and row.tPt > 32 and abs(row.tEta) < 2.1
    return [trigger32 or trigger35, trigger2430]

  # Kinematics Selections
  def kinematics(self, row):
    if row.ePt < 25 or abs(row.eEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Electron Identification
  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Electron Tight Isolation
  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)

  # Electron Loose Isolation
  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)

  # Tau decay mode finding along with discrimination against electron and muon, and primary vertex matching
  def obj2_id(self, row):
    return bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tTightDeepTau2017v2p1VSe > 0.5) and bool(row.tLooseDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2)

  # Tight Working Point(WP) for Isolation for tau
  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)

  # Very Loose Working Point(WP) for Isolation for tau
  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)

  # Di-electron veto
  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)

  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not bool(self.trigger(row)[0] or self.trigger(row)[1]):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.tPhi, row.eEta, row.tEta) < 0.5:
      return False
    elif njets > 2:
      return False
    elif not self.obj1_id(row):
      return False
    elif not self.obj2_id(row):
      return False
    elif row.tDecayMode==5 or row.tDecayMode==6:
      return False
    elif not self.vetos(row):
      return False
    elif not self.dieleveto(row):
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myTau = ROOT.TLorentzVector()
    myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

    myMETpx = myMET.Px() + myEle.Px()
    myMETpy = myMET.Py() + myEle.Py()
    myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
    myMETpx = myMETpx - myEle.Px()
    myMETpy = myMETpy - myEle.Py()
    myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

    if self.is_recoilC and self.MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    myMET = self.tauPtC(row, myMET, myTau)[0]
    myTau = self.tauPtC(row, myMET, myTau)[1]
    return [myEle, myMET, myTau]

  # Tau pT correction
  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    if bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      fes = self.FesTau(myTau.Eta(), row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes[0])
    return [tmpMET, tmpTau]

  def corrFact(self, row, myEle, myTau, singEle):
    weight = 1.0
    # MC Corrections
    singleSF = 0
    eltauSF = 0
    self.w1.var('e_pt').setVal(myEle.Pt())
    self.w1.var('e_iso').setVal(row.eRelPFIsoRho)
    self.w1.var('e_eta').setVal(myEle.Eta())
    eID = self.w1.function('e_id80_kit_ratio').getVal()
    eIso = self.w1.function('e_iso_kit_ratio').getVal()
    eReco = self.w1.function('e_trk_ratio').getVal()
    if singEle:
      singleSF = self.w1.function('e_trg32_trg35_binned_kit_ratio').getVal()
    else:
      eltauSF = self.w1.function('e_trg_EleTau_Ele24Leg_desy_ratio').getVal()
      if row.tDecayMode==11:
        eltauSF = eltauSF * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), 10)
      else:
        eltauSF = eltauSF * self.tauSF.getTriggerScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi(), row.tDecayMode)
    tEff = singleSF + eltauSF
    weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*zvtx
    # Anti-Muon Discriminator Scale Factors
    if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
      weight = weight * self.deepTauVSmu(myTau.Eta())[0]
    # Anti-Electron Discriminator Scale Factors
    elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
      weight = weight * self.deepTauVSe(myTau.Eta())[0]
    # Tau ID Scale Factor
    elif row.tZTTGenMatching==5:
      if self.obj2_tight(row):
        weight = weight * self.deepTauVSjet_tight(myTau.Pt())[0]
      elif self.obj2_loose(row):
        weight = weight * self.deepTauVSjet_vloose(myTau.Pt())[0]
    weight = self.mcWeight.lumiWeight(weight)

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
      weight = weight * btagweight
    return weight
