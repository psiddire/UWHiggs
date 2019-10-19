'''

Run LFV H->EMu analysis in the e+mu channel.

Authors: Prasanna Siddireddy

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
import itertools
from bTagSF import PromoteDemote

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class AnalyzeEMu(MegaBase):
  tree = 'em/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1
 
    self.deltaR = Kinematics.deltaR
    self.collMass = Kinematics.collMass

    self.names = Kinematics.names
    self.lhe = Kinematics.lhe

    super(AnalyzeEMu, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.mCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter:
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj2_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
  

  def obj2_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.lhe):
      folder.append(os.path.join(*tuple_path))
    for f in folder:
      self.book(f, "e_m_VisibleMass", "Ele + Muon Visible Mass", 60, 0, 300)
      self.book(f, "e_m_GenVisibleMass", "Ele + Muon Gen Visible Mass", 60, 0, 300)


  def fill_histos(self, row, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    for i in range(120):
      lheweight = getattr(row, 'lheweight' + str(i))
      histos[name+'/lhe'+str(i)+'/e_m_VisibleMass'].Fill((myEle+myMuon).M(), weight*lheweight)
      genMuon = ROOT.TLorentzVector()
      genMuon.SetPtEtaPhiM(row.mGenPt, row.mGenEta, row.mGenPhi, row.mMass)
      genEle = ROOT.TLorentzVector()
      genEle.SetPtEtaPhiM(row.eGenPt, row.eGenEta, row.eGenPhi, row.eMass)
      histos[name+'/lhe'+str(i)+'/e_m_GenVisibleMass'].Fill((genEle+genMuon).M(), weight*lheweight)


  def process(self):

    for row in self.tree:

      triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24 and row.eMatchesMu8e23DZFilter and row.eMatchesMu8e23DZPath and row.mMatchesMu8e23DZFilter and row.mMatchesMu8e23DZPath
      triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13 and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath

      if self.filters(row):
        continue

      if not bool(triggerm8e23 or triggerm23e12):
        continue

      if not self.oppositesign(row):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.4:
        continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()

      myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      myMETpx = myMETpx - myEle.Px()
      myMETpy = myMETpy - myEle.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if nbtag > 0:
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if nbtag > 0:
        continue

      weight = 1.0
      eff_trg_data = 0
      eff_trg_mc = 0
      self.w1.var("m_pt").setVal(myMuon.Pt())
      self.w1.var("m_eta").setVal(myMuon.Eta())
      self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
      self.w1.var("e_pt").setVal(myEle.Pt())
      self.w1.var("e_eta").setVal(myEle.Eta())
      self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
      if triggerm8e23:
        eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
        eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_8_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
      if triggerm23e12:
        eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
        eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_12_mc").getVal()
      if triggerm8e23 and triggerm23e12:
        eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
        eff_trg_mc = eff_trg_mc - self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mTrk = self.muTracking(myMuon.Eta())[0]
      eID = self.eIDnoIsoWP80(myEle.Pt(), abs(myEle.Eta()))
      eTrk = self.eReco(myEle.Pt(), abs(myEle.Eta()))
      mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*eID*eTrk*mcSF*row.prefiring_weight

      mjj = row.vbfMassWoNoisyJets

      if self.obj2_iso(row) and self.obj1_iso(row):
        self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS')
        if njets==0:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS0Jet')
        elif njets==1:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS1Jet')
        elif njets==2 and mjj < 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2Jet')
        elif njets==2 and mjj > 500:
          self.fill_histos(row, myEle, myMET, myMuon, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
