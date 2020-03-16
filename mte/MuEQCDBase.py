'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class MuEQCDBase():
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.Emb = False
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.muonMediumID = mcCorrections.muonID_medium
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid
    self.muTracking = mcCorrections.muonTracking
    self.eID = mcCorrections.eID
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1
    self.DYreweight = mcCorrections.DYreweight

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case

    self.jes = Kinematics.jes
    self.ues = Kinematics.ues
    self.names = Kinematics.names
    self.ssnames = Kinematics.ssnames
    self.sys = Kinematics.sys
    self.sssys = Kinematics.sssys
    self.qcdsys = Kinematics.qcdsys
    self.functor = Kinematics.functor
    self.var_d = Kinematics.var_d

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13# and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath
    return bool(triggerm23e12)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.mPt < 24 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True

  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Muon Identification
  def obj1_id(self, row):
    return (bool(row.mPFIDMedium) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))

  # Muon Isolation
  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)

  # Electron Identification
  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP90) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Electron Isolation
  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.15)

  # Third lepton veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)

  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
      return False
    elif self.Emb and self.is_DY and not bool(row.isZmumu or row.isZee):
      return False
    elif njets > 2:
      return False
    elif not self.obj1_id(row):
      return False
    elif not self.obj2_id(row):
      return False
    elif not self.obj1_iso(row):
      return False
    elif not self.obj2_iso(row):
      return False
    elif not self.vetos(row):
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    if self.is_recoilC and self.MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    return [myMuon, myMET, myEle]


  def corrFact(self, row, myMuon, myEle):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      self.w1.var("e_pt").setVal(myEle.Pt())
      self.w1.var("e_eta").setVal(myEle.Eta())
      self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
      self.w1.var("m_pt").setVal(myMuon.Pt())
      self.w1.var("m_eta").setVal(myMuon.Eta())
      eff_trg_data = self.w1.function("m_trg_23_data").getVal()*self.w1.function("e_trg_12_data").getVal()
      eff_trg_mc = self.w1.function("m_trg_23_mc").getVal()*self.w1.function("e_trg_12_mc").getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      eID = self.w1.function("e_id90_kit_ratio").getVal()
      eIso = self.w1.function("e_iso_kit_ratio").getVal()
      eReco = self.w1.function('e_trk_ratio').getVal()
      #eID = self.eID(myEle.Eta(), myEle.Pt())
      mID = self.muonMediumID(myMuon.Pt(), abs(myMuon.Eta()))
      mIso = self.muonLooseIsoMediumID(myMuon.Pt(), abs(myMuon.Eta()))
      mTrk = self.muTracking(myMuon.Eta())[0]
      mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*mID*mIso*mTrk*mcSF
      if self.is_DY:
        # DY pT reweighting
        dyweight = self.DYreweight(row.genMass, row.genpT)
        weight = weight * dyweight
        if row.numGenJets < 5:
          weight = weight*self.DYweight[row.numGenJets]
        else:
          weight = weight*self.DYweight[0]
      if self.is_W:
        if row.numGenJets < 5:
          weight = weight*self.Wweight[row.numGenJets]
        else:
          weight = weight*self.Wweight[0]
      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        weight = weight*topweight
        if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and self.Emb:
          weight = 0.0
      weight = self.mcWeight.lumiWeight(weight)

    njets = row.jetVeto30
    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("m_pt").setVal(myMuon.Pt())
    osss = self.w1.function("em_qcd_osss_binned").getVal()

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2018_DR0p5
    if nbtag > 2:
     nbtag = 2
    if (self.is_mc and nbtag > 0):
     btagweight = bTagEventWeight(nbtag, row.jb1pt_2018, row.jb1hadronflavor_2018, row.jb2pt_2018, row.jb2hadronflavor_2018, 1, 0, 0)
     weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
     weight = 0

    return [weight, osss]

