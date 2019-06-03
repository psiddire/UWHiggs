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
MetCorrection = False
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuEFake(MegaBase):
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

    self.tEff = mcCorrections.efficiency_trigger_mu_2017 
    self.mID = mcCorrections.muonID_medium
    self.mLIso = mcCorrections.muonIso_loose_mediumid
    self.mTIso = mcCorrections.muonIso_tight_mediumid 
    self.mTrk = mcCorrections.muonTracking 
    self.eID = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.fakeRateElectron = mcCorrections.fakerateElectron_weight
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we 

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeMuEFake, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.mu23e12Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 24 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDMedium) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045)) 
  

  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
    

  def obj1_looseiso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)


  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.15)


  def obj2_looseiso(self, row):
    return bool(row.eRelPFIsoRho < 0.2)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP90) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2)) 


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Medium < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names=['MuonLooseOS', 'MuonLooseSS', 'EleLooseOS', 'EleLooseSS', 'MuonLooseEleLooseOS', 'MuonLooseEleLooseSS', 'TightOS', 'TightSS', 'MuonLooseOS0Jet', 'MuonLooseSS0Jet', 'EleLooseOS0Jet', 'EleLooseSS0Jet', 'MuonLooseEleLooseOS0Jet', 'MuonLooseEleLooseSS0Jet', 'TightOS0Jet', 'TightSS0Jet', 'MuonLooseOS1Jet', 'MuonLooseSS1Jet', 'EleLooseOS1Jet', 'EleLooseSS1Jet', 'MuonLooseEleLooseOS1Jet', 'MuonLooseEleLooseSS1Jet', 'TightOS1Jet', 'TightSS1Jet', 'MuonLooseOS2Jet', 'MuonLooseSS2Jet', 'EleLooseOS2Jet', 'EleLooseSS2Jet', 'MuonLooseEleLooseOS2Jet', 'MuonLooseEleLooseSS2Jet', 'TightOS2Jet', 'TightSS2Jet']
    vbfnames=['MuonLooseOS2JetVBF', 'MuonLooseSS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseSS2JetVBF', 'MuonLooseEleLooseOS2JetVBF', 'MuonLooseEleLooseSS2JetVBF', 'TightOS2JetVBF', 'TightSS2JetVBF']

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
      self.book(names[x], "m_e_Mass", "Muon + Electron Mass", 30, 0, 300)
      self.book(names[x], "m_e_CollinearMass", "Muon + Electron Collinear Mass", 30, 0, 300)      
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "dEtaMuE", "Delta Eta Mu E", 50, 0, 5)
      self.book(names[x], "dPhiEMET", "Delta Phi E MET", 40, 0, 4)
      self.book(names[x], "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(names[x], "dPhiMuE", "Delta Phi Mu E", 40, 0, 4)
      self.book(names[x], "MTEMET", "Electron MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTMuMET", "Mu MET Transverse Mass", 20, 0, 200)

    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], "mPt", "Muon  Pt", 10, 0, 200)
      self.book(vbfnames[x], "ePt", "Electron Pt", 10, 0, 200)
      self.book(vbfnames[x], "mEta", "Muon Eta", 10, -3, 3)
      self.book(vbfnames[x], "eEta", "Electron Eta", 10, -3, 3)
      self.book(vbfnames[x], "mPhi", "Muon Phi", 10, -4, 4)
      self.book(vbfnames[x], "ePhi", "Electron Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
      self.book(vbfnames[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "m_e_Mass", "Muon + Electron Mass", 15, 0, 300)
      self.book(vbfnames[x], "m_e_CollinearMass", "Muon + Electron Collinear Mass", 15, 0, 300)
      self.book(vbfnames[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(vbfnames[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(vbfnames[x], "dEtaMuE", "Delta Eta Mu E", 25, 0, 5)
      self.book(vbfnames[x], "dPhiEMET", "Delta Phi E MET", 20, 0, 4)
      self.book(vbfnames[x], "dPhiMuMET", "Delta Phi Mu MET", 20, 0, 4)
      self.book(vbfnames[x], "dPhiMuE", "Delta Phi Mu E", 20, 0, 4)
      self.book(vbfnames[x], "MTEMET", "Electron MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "MTMuMET", "Mu MET Transverse Mass", 10, 0, 200)


  def fill_histos(self, row, myMuon, myMET, myEle, njets, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/ePhi'].Fill(myEle.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/m_e_Mass'].Fill(self.visibleMass(myMuon, myEle), weight)
    histos[name+'/m_e_CollinearMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)
    histos[name+'/numOfJets'].Fill(njets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuE'].Fill(self.deltaEta(myMuon.Eta(), myEle.Eta()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuE'].Fill(self.deltaPhi(myMuon.Phi(), myEle.Phi()), weight)
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

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
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

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

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
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue 

      weight = 1.0
      if self.is_mc:
        self.w1.var("m_pt").setVal(row.mPt)
        self.w1.var("m_eta").setVal(row.mEta)
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        mIso = self.w1.function("m_iso_binned_ratio").getVal()
        mLooseIso = self.w1.function("m_looseiso_binned_ratio").getVal()
        mID = self.w1.function("m_id_ratio").getVal()
        mTrk = self.w1.function("m_trk_ratio").getVal()
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        eIso = self.w1.function("e_iso_binned_ratio").getVal()
        eID = self.w1.function("e_id_ratio").getVal()
        eTrk = self.w1.function("e_trk_ratio").getVal()
        tData = self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
        tMC = self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_12_mc").getVal()
        if tMC==0:
          tEff = 0
        else:
          tEff = tData/tMC
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mTrk*eID*eTrk
        if self.is_DY:
          if row.numGenJets < 5:
            self.w2.var("z_gen_mass").setVal(row.genMass)
            self.w2.var("z_gen_pt").setVal(row.genpT)
            dyweight = self.w2.function("zptmass_weight_nom").getVal()
            weight = weight*dyweight*self.DYweight[row.numGenJets]
          else:
            weight = weight*dyweight*self.DYweight[0]
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_TT:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMassWoNoisyJets
      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
      mtmumet = self.transverseMass(myMuon, myMET)

      if not self.obj2_iso(row) and self.obj2_looseiso(row) and self.obj1_iso(row):
        frEle = self.fakeRateElectron(myEle.Pt())
        if not self.is_data and not self.is_embed:
          mIso = self.mTIso(myMuon.Pt(), abs(row.mEta)) 
          weight = weight*mIso*eIso
        weight = weight*frEle
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseOS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseOS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0: 
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseOS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseOS2Jet') 
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseSS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseSS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseSS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseSS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'EleLooseSS2JetVBF')

      if not self.obj1_iso(row) and self.obj1_looseiso(row) and self.obj2_iso(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        if not self.is_data and not self.is_embed: 
          mLooseIso = self.mLIso(myMuon.Pt(), abs(row.mEta))
          weight = weight*eIso*mLooseIso
        weight = weight*frMuon
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseOS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseOS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0: 
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseOS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseOS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseSS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseSS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseSS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseSS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseSS2JetVBF')

      if not self.obj2_iso(row) and self.obj2_looseiso(row) and not self.obj1_iso(row) and self.obj1_looseiso(row):
        frEle = self.fakeRateElectron(myEle.Pt())
        frMuon = self.fakeRateMuon(myMuon.Pt())
        if not self.is_data and not self.is_embed:
          mLooseIso = self.mLIso(myMuon.Pt(), abs(row.mEta)) 
          weight = weight*mLooseIso*eIso
        weight = weight*frEle*frMuon
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseOS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseOS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0: 
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseOS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseOS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseSS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseSS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseSS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseSS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'MuonLooseEleLooseSS2JetVBF')

      if self.obj2_iso(row) and self.obj1_iso(row):
        if not self.is_data and not self.is_embed:
          mIso = self.mTIso(myMuon.Pt(), abs(row.mEta)) 
          weight = weight*mIso*eIso
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightOS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightOS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0: 
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightOS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightOS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightSS')
          if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightSS0Jet')
          elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightSS1Jet')
          elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightSS2Jet')
          elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3:
            self.fill_histos(row, myMuon, myMET, myEle, njets weight, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
