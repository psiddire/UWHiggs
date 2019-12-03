'''

Run LFV H->MuE analysis in the mu+tau_e channel.

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
from bTagSF import PromoteDemote

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeMuE(MegaBase):
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

    self.triggerEff24 = mcCorrections.muonTrigger24
    self.triggerEff27 = mcCorrections.muonTrigger27
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.Ele32or35 = mcCorrections.Ele32or35
    self.EleIdIso = mcCorrections.EleIdIso
    self.DYreweight = mcCorrections.DYreweight
    self.DYreweightReco = mcCorrections.DYreweightReco
    self.w1 = mcCorrections.w1

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeMuE, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names = ['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet', 'TightOS0JetCut', 'TightSS0JetCut', 'TightOS1JetCut', 'TightSS1JetCut', 'TightOS2Jet', 'TightSS2Jet', 'TightOS2JetVBF', 'TightSS2JetVBF', 'TightOS2JetCut', 'TightSS2JetCut', 'TightOS2JetVBFCut', 'TightSS2JetVBFCut']
    namesize = len(names)

    for x in range(0, namesize):
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
      self.book(names[x], "m_e_Mass", "Muon + Electron Mass", 30, 0, 300)
      self.book(names[x], "m_e_CollMass", "Muon + Electron Collinear Mass", 30, 0, 300)
      self.book(names[x], "m_e_PZeta", "Muon + Electron PZeta", 80, -400, 400)
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "vbfMass", "VBF Mass", 100, 0, 1000)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "dEtaMuE", "Delta Eta Mu E", 50, 0, 5)
      self.book(names[x], "dPhiMuE", "Delta Phi Mu E", 40, 0, 4)
      self.book(names[x], "dPhiEMET", "Delta Phi E MET", 40, 0, 4)
      self.book(names[x], "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(names[x], "MTEMET", "Electron MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTMuMET", "Mu MET Transverse Mass", 20, 0, 200)


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
    histos[name+'/j1Pt'].Fill(row.j1ptWoNoisyJets, weight)
    histos[name+'/j2Pt'].Fill(row.j2ptWoNoisyJets, weight)
    histos[name+'/j1Eta'].Fill(row.j1etaWoNoisyJets, weight)
    histos[name+'/j2Eta'].Fill(row.j2etaWoNoisyJets, weight)
    histos[name+'/j1Phi'].Fill(row.j1phiWoNoisyJets, weight)
    histos[name+'/j2Phi'].Fill(row.j2phiWoNoisyJets, weight)
    histos[name+'/m_e_Mass'].Fill(self.visibleMass(myMuon, myEle), weight)
    histos[name+'/m_e_CollMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)
    histos[name+'/m_e_PZeta'].Fill(row.e_m_PZeta, weight)
    histos[name+'/numOfJets'].Fill(njets, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMassWoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuE'].Fill(self.deltaEta(myMuon.Eta(), myEle.Eta()), weight)
    histos[name+'/dPhiMuE'].Fill(self.deltaPhi(myMuon.Phi(), myEle.Phi()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/MTMuMET'].Fill(self.transverseMass(myMuon, myMET), weight)


  def process(self):

    for row in self.tree:

      triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24 and row.eMatchesMu8e23DZFilter and row.eMatchesMu8e23DZPath and row.mMatchesMu8e23DZFilter and row.mMatchesMu8e23DZPath
      triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13 and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath

      if self.filters(row):
        continue

      if not bool(triggerm8e23 or triggerm23e12):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      njets = row.jetVeto30
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

      #if self.is_data or self.is_mc:
      #  myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
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
      if (self.is_mc and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
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
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
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
        if triggerm8e23:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_8_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        if triggerm23e12:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_12_embed").getVal()
        if triggerm8e23 and triggerm23e12:
          eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed - self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        trg_sf = 0 if eff_trg_embed==0 else eff_trg_data/eff_trg_embed
        weight = weight*row.GenWeight*msel*esel*trgsel*trg_sf*m_id_sf*m_iso_sf*m_trk_sf*e_id_sf*e_iso_sf*e_trk_sf*self.EmbedEta(myEle.Eta(), njets, mjj)

      self.w3.var("njets").setVal(njets)
      self.w3.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
      self.w3.var("e_pt").setVal(myEle.Pt())
      self.w3.var("m_pt").setVal(myMuon.Pt())
      osss = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()

      dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
      dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
      mtmumet = self.transverseMass(myMuon, myMET)

      if self.obj2_iso(row) and self.obj1_iso(row):
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS0Jet')
            if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS0JetCut')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS1Jet')
            if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS1JetCut')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS2Jet')
            if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS2JetCut')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS2JetVBF')
            if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight, 'TightOS2JetVBFCut')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS0Jet')
            if mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS0JetCut')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS1Jet')
            if mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS1JetCut')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS2Jet')
            if mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS2JetCut')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS2JetVBF')
            if mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
              self.fill_histos(row, myMuon, myMET, myEle, njets, weight*osss, 'TightSS2JetVBFCut')


  def finish(self):
    self.write_histos()
