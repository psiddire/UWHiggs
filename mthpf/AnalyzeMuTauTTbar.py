'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

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
from bTagSF import PromoteDemote

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeMuTauTTbar(MegaBase):
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

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid
    self.muTracking = mcCorrections.muonTracking
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.rc = mcCorrections.rc
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
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeMuTauTTbar, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 25 or abs(row.mEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


  def begin(self):
    names=['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TightOS2Jet']
    vbfnames=['TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book(names[x], 'mPt', 'Muon  Pt', 20, 0, 200)
      self.book(names[x], 'tPt', 'Tau  Pt', 20, 0, 200)
      self.book(names[x], 'mEta', 'Muon Eta', 20, -3, 3)
      self.book(names[x], 'tEta', 'Tau Eta', 20, -3, 3)
      self.book(names[x], 'mPhi', 'Muon Phi', 20, -4, 4)
      self.book(names[x], 'tPhi', 'Tau Phi', 20, -4, 4)
      self.book(names[x], 'type1_pfMetEt', 'Type1 MET Et', 20, 0, 200)
      self.book(names[x], 'type1_pfMetPhi', 'Type1 MET Phi', 20, -4, 4)
      self.book(names[x], 'j1Pt', 'Jet 1 Pt', 30, 0, 300)
      self.book(names[x], 'j2Pt', 'Jet 2 Pt', 30, 0, 300)
      self.book(names[x], 'j1Eta', 'Jet 1 Eta', 20, -3, 3)
      self.book(names[x], 'j2Eta', 'Jet 2 Eta', 20, -3, 3)
      self.book(names[x], 'j1Phi', 'Jet 1 Phi', 20, -4, 4)
      self.book(names[x], 'j2Phi', 'Jet 2 Phi', 20, -4, 4)
      self.book(names[x], 'm_t_Mass', 'Muon + Tau Mass', 30, 0, 300)
      self.book(names[x], 'm_t_CollinearMass', 'Muon + Tau Collinear Mass', 30, 0, 300)
      self.book(names[x], 'm_t_PZeta', 'Muon + Tau PZeta', 80, -400, 400)
      self.book(names[x], 'numOfJets', 'Number of Jets', 5, 0, 5)
      self.book(names[x], 'numOfVtx', 'Number of Vertices', 100, 0, 100)
      self.book(names[x], 'vbfMass', 'VBF Mass', 100, 0, 1000)
      self.book(names[x], 'dEtaMuTau', 'Delta Eta Mu Tau', 50, 0, 5)
      self.book(names[x], 'dPhiMuMET', 'Delta Phi Mu MET', 40, 0, 4)
      self.book(names[x], 'dPhiTauMET', 'Delta Phi Tau MET', 40, 0, 4)
      self.book(names[x], 'dPhiMuTau', 'Delta Phi Mu Tau', 40, 0, 4)
      self.book(names[x], 'MTMuMET', 'Muon MET Transverse Mass', 20, 0, 200)
      self.book(names[x], 'MTTauMET', 'Tau MET Transverse Mass', 20, 0, 200)

    vbfnamesize = len(vbfnames)
    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], 'mPt', 'Muon  Pt', 10, 0, 200)
      self.book(vbfnames[x], 'tPt', 'Tau  Pt', 10, 0, 200)
      self.book(vbfnames[x], 'mEta', 'Muon Eta', 10, -3, 3)
      self.book(vbfnames[x], 'tEta', 'Tau Eta', 10, -3, 3)
      self.book(vbfnames[x], 'mPhi', 'Muon Phi', 10, -4, 4)
      self.book(vbfnames[x], 'tPhi', 'Tau Phi', 10, -4, 4)
      self.book(vbfnames[x], 'type1_pfMetEt', 'Type1 MET Et', 10, 0, 200)
      self.book(vbfnames[x], 'type1_pfMetPhi', 'Type1 MET Phi', 10, -4, 4)
      self.book(vbfnames[x], 'j1Pt', 'Jet 1 Pt', 15, 0, 300)
      self.book(vbfnames[x], 'j2Pt', 'Jet 2 Pt', 15, 0, 300)
      self.book(vbfnames[x], 'j1Eta', 'Jet 1 Eta', 10, -3, 3)
      self.book(vbfnames[x], 'j2Eta', 'Jet 2 Eta', 10, -3, 3)
      self.book(vbfnames[x], 'j1Phi', 'Jet 1 Phi', 10, -4, 4)
      self.book(vbfnames[x], 'j2Phi', 'Jet 2 Phi', 10, -4, 4)
      self.book(vbfnames[x], 'm_t_Mass', 'Muon + Tau Mass', 15, 0, 300)
      self.book(vbfnames[x], 'm_t_CollinearMass', 'Muon + Tau Collinear Mass', 15, 0, 300)
      self.book(vbfnames[x], 'm_t_PZeta', 'Muon + Tau PZeta', 40, -400, 400)
      self.book(vbfnames[x], 'numOfJets', 'Number of Jets', 5, 0, 5)
      self.book(vbfnames[x], 'numOfVtx', 'Number of Vertices', 100, 0, 100)
      self.book(vbfnames[x], 'vbfMass', 'VBF Mass', 50, 0, 1000)
      self.book(vbfnames[x], 'dEtaMuTau', 'Delta Eta Mu Tau', 20, 0, 5)
      self.book(vbfnames[x], 'dPhiMuMET', 'Delta Phi Mu MET', 10, 0, 4)
      self.book(vbfnames[x], 'dPhiTauMET', 'Delta Phi Tau MET', 10, 0, 4)
      self.book(vbfnames[x], 'dPhiMuTau', 'Delta Phi Mu Tau', 10, 0, 4)
      self.book(vbfnames[x], 'MTMuMET', 'Muon MET Transverse Mass', 10, 0, 200)
      self.book(vbfnames[x], 'MTTauMET', 'Tau MET Transverse Mass', 10, 0, 200)


  def fill_histos(self, row, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/tPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/tPhi'].Fill(myTau.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1ptWoNoisyJets, weight)
    histos[name+'/j2Pt'].Fill(row.j2ptWoNoisyJets, weight)
    histos[name+'/j1Eta'].Fill(row.j1etaWoNoisyJets, weight)
    histos[name+'/j2Eta'].Fill(row.j2etaWoNoisyJets, weight)
    histos[name+'/j1Phi'].Fill(row.j1phiWoNoisyJets, weight)
    histos[name+'/j2Phi'].Fill(row.j2phiWoNoisyJets, weight)
    histos[name+'/m_t_Mass'].Fill(self.visibleMass(myMuon, myTau), weight)
    histos[name+'/m_t_CollinearMass'].Fill(self.collMass(myMuon, myMET, myTau), weight)
    histos[name+'/m_t_PZeta'].Fill(row.m_t_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30WoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMassWoNoisyJets, weight)
    histos[name+'/dEtaMuTau'].Fill(self.deltaEta(myMuon.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuTau'].Fill(self.deltaPhi(myMuon.Phi(), myTau.Phi()), weight)
    histos[name+'/MTMuMET'].Fill(self.transverseMass(myMuon, myMET), weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), weight)


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and (not self.is_DY) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.003 * myTau.Px()
        myMETpy = myMET.Py() - 0.003 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() - 0.036 * myTau.Px()
        myMETpy = myMET.Py() - 0.036 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.036)
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger24 = row.IsoMu24Pass and row.mMatchesIsoMu24Filter and row.mMatchesIsoMu24Path and row.mPt > 25
      trigger27 = row.IsoMu27Pass and row.mMatchesIsoMu27Filter and row.mMatchesIsoMu27Path and row.mPt > 28

      if self.filters(row):
        continue

      if not bool(trigger24 or trigger27):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.mPhi, row.tPhi, row.mEta, row.tEta) < 0.5:
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

      if not self.dimuonveto(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag < 1):
        continue

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      if self.is_mc:
        mTrk = self.muTracking(myMuon.Eta())[0]
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        if self.obj1_tight(row):
          mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        else:
          mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*mID*mTrk*mIso*mcSF*row.prefiring_weight
        self.w2.var('m_pt').setVal(myMuon.Pt())
        self.w2.var('m_eta').setVal(myMuon.Eta())
        if trigger24 or trigger27:
          tEff = 0 if self.w2.function('m_trg24_27_kit_mc').getVal()==0 else self.w2.function('m_trg24_27_kit_data').getVal()/self.w2.function('m_trg24_27_kit_mc').getVal()
          weight = weight*tEff
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.17
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.29
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.14
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.09
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.19
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        if self.is_DY:
          self.w2.var('z_gen_mass').setVal(row.genMass)
          self.w2.var('z_gen_pt').setVal(row.genpT)
          dyweight = self.w2.function('zptmass_weight_nom').getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      m_trg_sf = 0.0
      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        self.we.var('m_pt').setVal(myMuon.Pt())
        self.we.var('m_eta').setVal(myMuon.Eta())
        self.we.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
        self.we.var('gt_pt').setVal(myMuon.Pt())
        self.we.var('gt_eta').setVal(myMuon.Eta())
        msel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt_pt').setVal(myTau.Pt())
        self.we.var('gt_eta').setVal(myTau.Eta())
        tsel = self.we.function('m_sel_idEmb_ratio').getVal()
        self.we.var('gt1_pt').setVal(myMuon.Pt())
        self.we.var('gt1_eta').setVal(myMuon.Eta())
        self.we.var('gt2_pt').setVal(myTau.Pt())
        self.we.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.we.function('m_sel_trg_ratio').getVal()
        m_iso_sf = self.we.function('m_iso_binned_embed_kit_ratio').getVal()
        m_id_sf = self.we.function('m_id_embed_kit_ratio').getVal()
        m_trk_sf = self.muTracking(myMuon.Eta())[0]
        if trigger24 or trigger27:
          m_trg_sf = self.we.function('m_trg24_27_embed_kit_ratio').getVal()
        weight = weight*row.GenWeight*tID*m_trg_sf*m_id_sf*m_iso_sf*m_trk_sf*dm*msel*tsel*trgsel

      mjj = row.vbfMassWoNoisyJets

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        weight = weight*frMuon*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF')

      if self.obj2_tight(row) and self.obj1_tight(row):
        if self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS1Jet')
          elif njets==2 and mjj < 550 and self.transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2Jet')
          elif njets==2 and mjj > 550 and self.transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
