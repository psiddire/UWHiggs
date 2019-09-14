'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import itertools
import operator
import mcCorrections
import mcWeights
import Kinematics
from RecoilCorrector import RecoilCorrector
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeEMu(MegaBase):
  tree = 'em/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT

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
    self.EmbedEta = mcCorrections.EmbedEta
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.wp = mcCorrections.wp
 
    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight
    self.Embweight = self.mcWeight.Embweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeEMu, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.mCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if row.mu8e23DZPass:
      if row.mPt > 10 and row.ePt > 24:
        return True
      else:
        return False
    elif row.mu23e12DZPass:
      if row.mPt > 24 and row.ePt > 13:
        return True
      else:
        return False
    else:
      return False


  def kinematics(self, row):
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 24 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
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
    vbffolder = []
    names=['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet', 'TightOS0JetCut', 'TightSS0JetCut', 'TightOS1JetCut', 'TightSS1JetCut']
    vbfnames=['TightOS2Jet', 'TightSS2Jet', 'TightOS2JetVBF', 'TightSS2JetVBF', 'TightOS2JetCut', 'TightSS2JetCut', 'TightOS2JetVBFCut', 'TightSS2JetVBFCut']
    namesize = len(names)
    vbfnamesize = len(vbfnames)

    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 20, 0, 200)
      self.book(names[x], "ePt", "Electron Pt", 20, 0, 200)
      self.book(names[x], "mEta", "Muon Eta", 20, -3, 3)
      self.book(names[x], "eEta", "Electron Eta", 20, -3, 3)
      self.book(names[x], "mPhi", "Muon Phi", 20, -4, 4)
      self.book(names[x], "ePhi", "Electron Phi", 20, -4, 4)
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
      self.book(names[x], "type1_pfMetPhi", "Type1 MET Phi", 20, -4, 4)
      self.book(names[x], "j1Pt", "Jet 1 Pt", 30, 0, 300)
      self.book(names[x], "j2Pt", "Jet 2 Pt", 30, 0, 300)
      self.book(names[x], "j1Eta", "Jet 1 Eta", 20, -3, 3)
      self.book(names[x], "j2Eta", "Jet 2 Eta", 20, -3, 3)
      self.book(names[x], "j1Phi", "Jet 1 Phi", 20, -4, 4)
      self.book(names[x], "j2Phi", "Jet 2 Phi", 20, -4, 4)
      self.book(names[x], "e_m_Mass", "Electron + Muon Mass", 30, 0, 300)
      self.book(names[x], "e_m_CollMass", "Electron + Muon Collinear Mass", 30, 0, 300)
      self.book(names[x], "e_m_PZeta", "Electron + Muon PZeta", 80, -400, 400)
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "vbfMass", "VBF Mass", 100, 0, 1000)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "dEtaEMu", "Delta Eta E Mu", 50, 0, 5)
      self.book(names[x], "dPhiEMu", "Delta Phi Mu E", 40, 0, 4)
      self.book(names[x], "dPhiEMET", "Delta Phi E MET", 40, 0, 4)
      self.book(names[x], "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(names[x], "MTEMET", "Electron MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTMuMET", "Mu MET Transverse Mass", 20, 0, 200)

    for x in range(0,vbfnamesize):
      self.book(vbfnames[x], "mPt", "Muon  Pt", 10, 0, 200)
      self.book(vbfnames[x], "ePt", "Electron Pt", 10, 0, 200)
      self.book(vbfnames[x], "mEta", "Muon Eta", 10, -3, 3)
      self.book(vbfnames[x], "eEta", "Electron Eta", 10, -3, 3)
      self.book(vbfnames[x], "mPhi", "Muon Phi", 10, -4, 4)
      self.book(vbfnames[x], "ePhi", "Electron Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
      self.book(vbfnames[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "j1Pt", "Jet 1 Pt", 15, 0, 300)
      self.book(vbfnames[x], "j2Pt", "Jet 2 Pt", 15, 0, 300)
      self.book(vbfnames[x], "j1Eta", "Jet 1 Eta", 10, -3, 3)
      self.book(vbfnames[x], "j2Eta", "Jet 2 Eta", 10, -3, 3)      
      self.book(vbfnames[x], "j1Phi", "Jet 1 Phi", 10, -4, 4)
      self.book(vbfnames[x], "j2Phi", "Jet 2 Phi", 10, -4, 4)
      self.book(vbfnames[x], "e_m_Mass", "Electron + Muon Mass", 15, 0, 300)
      self.book(vbfnames[x], "e_m_CollMass", "Electron + Muon Collinear Mass", 15, 0, 300)
      self.book(vbfnames[x], "e_m_PZeta", "Electron + Muon PZeta", 40, -400, 400)
      self.book(vbfnames[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(vbfnames[x], "vbfMass", "VBF Mass", 50, 0, 1000)
      self.book(vbfnames[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(vbfnames[x], "dEtaEMu", "Delta Eta E Mu", 25, 0, 5)
      self.book(vbfnames[x], "dPhiEMu", "Delta Phi Mu E", 20, 0, 4)
      self.book(vbfnames[x], "dPhiEMET", "Delta Phi E MET", 20, 0, 4)
      self.book(vbfnames[x], "dPhiMuMET", "Delta Phi Mu MET", 20, 0, 4)
      self.book(vbfnames[x], "MTEMET", "Electron MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "MTMuMET", "Mu MET Transverse Mass", 10, 0, 200)


  def fill_histos(self, row, myEle, myMET, myMuon, njets, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/ePhi'].Fill(myEle.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1ptWoNoisyJets, weight)
    histos[name+'/j2Pt'].Fill(row.j2ptWoNoisyJets, weight)
    histos[name+'/j1Eta'].Fill(row.j1etaWoNoisyJets, weight)
    histos[name+'/j2Eta'].Fill(row.j2etaWoNoisyJets, weight)
    histos[name+'/j1Phi'].Fill(row.j1phiWoNoisyJets, weight)
    histos[name+'/j2Phi'].Fill(row.j2phiWoNoisyJets, weight)
    histos[name+'/e_m_Mass'].Fill(self.visibleMass(myEle, myMuon), weight)
    histos[name+'/e_m_CollMass'].Fill(self.collMass(myEle, myMET, myMuon), weight)
    histos[name+'/e_m_PZeta'].Fill(row.e_m_PZeta, weight)
    histos[name+'/numOfJets'].Fill(njets, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMassWoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaEMu'].Fill(self.deltaEta(myEle.Eta(), myMuon.Eta()), weight)
    histos[name+'/dPhiEMu'].Fill(self.deltaPhi(myEle.Phi(), myMuon.Phi()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/MTMuMET'].Fill(self.transverseMass(myMuon, myMET), weight)


  def process(self):

    for row in self.tree:

      if self.filters(row):
        continue

      if not self.trigger(row):
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

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

      if self.is_data or self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (self.is_mc and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      #if bool(nbtag == 1 and row.jb1pt < 30) or bool(nbtag == 2 and row.jb1pt < 30 and row.jb2pt > 30) or bool(nbtag == 2 and row.jb1pt > 30 and row.jb2pt < 30):
      #  nbtag = nbtag - 1
      #if bool(nbtag == 2 and row.jb1pt < 30 and row.jb2pt < 30):
      #  nbtag = nbtag - 2
      if (nbtag > 0):
        continue

      weight = 1.0
      eff_trg_data = 0
      eff_trg_mc = 0
      eff_trg_embed = 0
      if self.is_mc:
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        if row.mu8e23DZPass:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_8_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
        if row.mu23e12DZPass:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
          eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_12_mc").getVal()
        if row.mu8e23DZPass and row.mu23e12DZPass:
          eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_mc = eff_trg_mc - self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
        tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mTrk = self.muTracking(myMuon.Eta())[0]
        eID = self.eIDnoIsoWP80(myEle.Pt(), abs(myEle.Eta()))
        eTrk = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*eID*eTrk
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMassWoNoisyJets

      if self.is_embed:
        self.w1.var("gt_pt").setVal(myMuon.Pt())
        self.w1.var("gt_eta").setVal(myMuon.Eta())
        msel = self.w1.function("m_sel_idEmb_ratio").getVal()
        self.w1.var("gt_pt").setVal(myEle.Pt())
        self.w1.var("gt_eta").setVal(myEle.Eta())
        esel = self.w1.function("m_sel_idEmb_ratio").getVal()
        self.w1.var("gt1_pt").setVal(myMuon.Pt())
        self.w1.var("gt1_eta").setVal(myMuon.Eta())
        self.w1.var("gt2_pt").setVal(myEle.Pt())
        self.w1.var("gt2_eta").setVal(myEle.Eta())
        trgsel = self.w1.function("m_sel_trg_ratio").getVal()
        self.we.var("m_pt").setVal(myMuon.Pt())
        self.we.var("m_eta").setVal(myMuon.Eta())
        self.we.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_id_sf = self.we.function("m_id_embed_kit_ratio").getVal()
        m_iso_sf = self.we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_trk_sf = self.muTracking(myMuon.Eta())[0]
        self.wp.var("e_pt").setVal(myEle.Pt())
        self.wp.var("e_eta").setVal(myEle.Eta())
        self.wp.var("e_phi").setVal(myEle.Phi())
        self.wp.var("e_iso").setVal(row.eRelPFIsoRho)
        e_id_sf = self.wp.function("e_id80_embed_kit_ratio").getVal()
        e_iso_sf = self.wp.function("e_iso_binned_embed_kit_ratio").getVal()
        e_trk_sf = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        if row.mu8e23DZPass:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_8_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        if row.mu23e12DZPass:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_12_embed").getVal()
        if row.mu8e23DZPass and row.mu23e12DZPass:
          eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed - self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        trg_sf = 0 if eff_trg_embed==0 else eff_trg_data/eff_trg_embed
        weight = weight*row.GenWeight*msel*esel*trgsel*trg_sf*m_id_sf*m_iso_sf*m_trk_sf*e_id_sf*e_iso_sf*e_trk_sf*self.EmbedEta(myEle.Eta(), njets, mjj)

      self.w3.var("njets").setVal(njets)
      self.w3.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
      self.w3.var("e_pt").setVal(myEle.Pt())
      self.w3.var("m_pt").setVal(myMuon.Pt())
      osss = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()

      dphimumet = self.deltaPhi(myMuon.Phi(), myMET.Phi())
      mtemet = self.transverseMass(myEle, myMET)

      if self.obj2_iso(row) and self.obj1_iso(row):
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS')
          if njets==0:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS0Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS0JetCut')
          elif njets==1:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS1Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS1JetCut')
          elif njets==2 and mjj < 500:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS2Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS2JetCut')
          elif njets==2 and mjj > 500:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS2JetVBF')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight, 'TightOS2JetVBFCut')
        if not self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS')
          if njets==0:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS0Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS0JetCut')
          elif njets==1:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS1Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS1JetCut')
          elif njets==2 and mjj < 500:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS2Jet')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS2JetCut')
          elif njets==2 and mjj > 500:
            self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS2JetVBF')
            if mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
              self.fill_histos(row, myEle, myMET, myMuon, njets, weight*osss, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
