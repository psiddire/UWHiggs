'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
import FakeRate
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class MuTauBase():
  tree = 'mt/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data

    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    # Load all the different lepton and trigger scale factors
    self.triggerEff27 = mcCorrections.muonTrigger27
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.deepTauVSe = mcCorrections.deepTauVSe
    self.deepTauVSmu = mcCorrections.deepTauVSmu
    self.deepTauVSjet_tight = mcCorrections.deepTauVSjet_tight
    self.deepTauVSjet_vloose = mcCorrections.deepTauVSjet_vloose
    self.deepTauVSjet_Emb_tight = mcCorrections.deepTauVSjet_Emb_tight
    self.deepTauVSjet_Emb_vloose = mcCorrections.deepTauVSjet_Emb_vloose
    self.esTau = mcCorrections.esTau
    self.FesTau = mcCorrections.FesTau
    self.ScaleTau = mcCorrections.ScaleTau
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.fakeRate = FakeRate.fakerate_weight
    self.fakeRateMuon = FakeRate.fakerateMuon_weight

    # Load the definition of the various kinematic variables
    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass

    self.names = Kinematics.names
    self.lhe = Kinematics.lhe

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26
    trigger27 = row.IsoMu27Pass and row.mMatchesIsoMu27Filter and row.mMatchesIsoMu27Path and row.mPt > 29
    return bool(trigger24 or trigger27)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.mPt < 26 or abs(row.mEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True

  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Muon Identification
  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))

  # Muon Tight Isolation
  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Muon Loose Isolation
  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)

  # Tau Identification
  def obj2_id(self, row):
    return (bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tVLooseDeepTau2017v2p1VSe > 0.5) and bool(row.tTightDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2))

  # Tau Tight vs Jet
  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)

  # Tau VLoose vs Jet
  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)

  # Third Lepton Veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)

  # Di-muon veto
  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)

  # Tau momentum correction
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

  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
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
    elif not self.dimuonveto(row):
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myTau = ROOT.TLorentzVector()
    myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    if self.is_recoilC and self.MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    myMET = self.tauPtC(row, myMET, myTau)[0]
    myTau = self.tauPtC(row, myMET, myTau)[1]
    return [myMuon, myMET, myTau]


  def corrFact(self, row, myMuon, myTau):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    self.w1.var('m_pt').setVal(myMuon.Pt())
    self.w1.var('m_eta').setVal(myMuon.Eta())
    self.w1.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
    tEff = self.w1.function('m_trg24_27_binned_kit_ratio').getVal()
    mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
    if self.obj1_tight(row):
      mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
    else:
      mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
    mTrk = self.muTracking(myMuon.Eta())[0]
    mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
    weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*mcSF
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
