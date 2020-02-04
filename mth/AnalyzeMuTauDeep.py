'''

Run LFV H->MuTau analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
import FakeRate
from bTagSF import bTagEventWeight

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeMuTauDeep(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
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
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc

    self.fakeRate = FakeRate.fakerateDeep_weight
    self.fakeRateMuon = FakeRate.fakerateMuon_weight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeMuTauDeep, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


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


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tVLooseDeepTau2017v2p1VSe > 0.5) and bool(row.tTightDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)


  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, "mPt", "Muon Pt", 20, 0, 200)
      self.book(n, "tPt", "Tau Pt", 20, 0, 200)
      self.book(n, "mEta", "Muon Eta", 20, -3, 3)
      self.book(n, "tEta", "Tau Eta", 20, -3, 3)
      self.book(n, "mPhi", "Muon Phi", 20, -4, 4)
      self.book(n, "tPhi", "Tau Phi", 20, -4, 4)
      self.book(n, "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
      self.book(n, "type1_pfMetPhi", "Type1 MET Phi", 20, -4, 4)
      self.book(n, "j1Pt", "Jet 1 Pt", 30, 0, 300)
      self.book(n, "j2Pt", "Jet 2 Pt", 30, 0, 300)
      self.book(n, "j1Eta", "Jet 1 Eta", 20, -3, 3)
      self.book(n, "j2Eta", "Jet 2 Eta", 20, -3, 3)
      self.book(n, "j1Phi", "Jet 1 Phi", 20, -4, 4)
      self.book(n, "j2Phi", "Jet 2 Phi", 20, -4, 4)
      self.book(n, "m_t_Mass", "Muon + Tau Mass", 30, 0, 300)
      self.book(n, "m_t_CollMass", "Muon + Tau Collinear Mass", 30, 0, 300)
      self.book(n, "m_t_PZeta", "Muon + Tau PZeta", 80, -400, 400)
      self.book(n, "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(n, "vbfMass", "VBF Mass", 100, 0, 1000)
      self.book(n, "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(n, "dEtaMuTau", "Delta Eta Mu Tau", 50, 0, 5)
      self.book(n, "dPhiMuTau", "Delta Phi Mu Tau", 40, 0, 4)
      self.book(n, "dPhiTauMET", "Delta Phi Tau MET", 40, 0, 4)
      self.book(n, "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(n, "MTTauMET", "Tau MET Transverse Mass", 20, 0, 200)
      self.book(n, "MTMuMET", "Mu MET Transverse Mass", 20, 0, 200)


  def fill_histos(self, row, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/tPt'].Fill(myTau.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/tPhi'].Fill(myTau.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1pt, weight)
    histos[name+'/j2Pt'].Fill(row.j2pt, weight)
    histos[name+'/j1Eta'].Fill(row.j1eta, weight)
    histos[name+'/j2Eta'].Fill(row.j2eta, weight)
    histos[name+'/j1Phi'].Fill(row.j1phi, weight)
    histos[name+'/j2Phi'].Fill(row.j2phi, weight)
    histos[name+'/m_t_Mass'].Fill(self.visibleMass(myMuon, myTau), weight)
    histos[name+'/m_t_CollMass'].Fill(self.collMass(myMuon, myMET, myTau), weight)
    histos[name+'/m_t_PZeta'].Fill(row.m_t_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuTau'].Fill(self.deltaEta(myMuon.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiMuTau'].Fill(self.deltaPhi(myMuon.Phi(), myTau.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), weight)
    histos[name+'/MTMuMET'].Fill(self.transverseMass(myMuon, myMET), weight)

  # Tau pT correction
  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and not self.is_DY and row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      fes = self.FesTau(myTau.Eta(), row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes[0])
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 26

      if self.filters(row):
        continue

      if not bool(trigger24):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.mPhi, row.tPhi, row.mEta, row.tEta) < 0.5:
        continue

      njets = row.jetVeto30
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if row.tDecayMode==5 or row.tDecayMode==6:
        continue

      if not self.vetos(row):
        continue

      if not self.dimuonveto(row):
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        tEff = self.triggerEff24(myMuon.Pt(), abs(myMuon.Eta()))[0]
        mID = self.muonTightID(myMuon.Eta(), myMuon.Pt())
        if self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Eta(), myMuon.Pt())
        else:
          mIso = self.muonLooseIsoTightID(myMuon.Eta(), myMuon.Pt())
        mTrk = self.muTracking(myMuon.Eta())[0]
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*mcSF*row.prefiring_weight
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
        if self.is_DY:
          # DY pT reweighting
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight * dyweight
          if row.numGenJets < 5:
            weight = weight * self.DYweight[row.numGenJets]
          else:
            weight = weight * self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMass

      if self.is_embed:
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        elif row.tDecayMode == 11:
          dm = pow(0.975, 3)*1.051
        # Muon selection scale factor
        self.w1.var('gt_pt').setVal(myMuon.Pt())
        self.w1.var('gt_eta').setVal(myMuon.Eta())
        msel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Tau selection scale factor
        self.w1.var('gt_pt').setVal(myTau.Pt())
        self.w1.var('gt_eta').setVal(myTau.Eta())
        tsel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Trigger selection scale factor
        self.w1.var('gt1_pt').setVal(myMuon.Pt())
        self.w1.var('gt1_eta').setVal(myMuon.Eta())
        self.w1.var('gt2_pt').setVal(myTau.Pt())
        self.w1.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.w1.function('m_sel_trg_ic_ratio').getVal()
        # Muon Identification, Isolation, tracking, and trigger scale factors
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_idiso_sf = self.w1.function("m_idiso_ic_embed_ratio").getVal()
        m_trk_sf = self.w1.function("m_trk_ratio").getVal()
        m_trg_sf = self.w1.function("m_trg_ic_embed_ratio").getVal()
        weight = row.GenWeight*dm*msel*tsel*trgsel*m_idiso_sf*m_trk_sf*m_trg_sf
        # Tau Identification
        if self.obj2_tight(row):
          weight = weight * self.deepTauVSjet_Emb_tight(myTau.Pt())[0]
        elif self.obj2_loose(row):
          weight = weight * self.deepTauVSjet_Emb_vloose(myTau.Pt())[0]
        if row.GenWeight > 1:
          weight = 0

      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if (self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data) and nbtag > 0):
        weight = 0

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        if self.oppositesign(row):
          if self.transverseMass(myMuon, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        if self.oppositesign(row):
          if self.transverseMass(myMuon, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        if self.oppositesign(row):
          if self.transverseMass(myMuon, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS2JetVBF')

      if self.obj2_tight(row) and self.obj1_tight(row):
        if self.oppositesign(row):
          if self.transverseMass(myMuon, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS2JetVBF')

  def finish(self):
    self.write_histos()
