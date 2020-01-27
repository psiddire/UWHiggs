'''

Run LFV H->EMu analysis in the e+tau_mu channel.

Authors: Prasanna Siddireddy

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import itertools
import mcCorrections
import mcWeights
import Kinematics
from bTagSF import bTagEventWeight

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeEMuSysQCD(MegaBase):
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
      self.MetSys = mcCorrections.MetSys

    self.triggerEff22 = mcCorrections.muonTrigger22
    self.triggerEff24 = mcCorrections.muonTrigger24
    self.muonMediumID = mcCorrections.muonID_medium
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid
    self.muTracking = mcCorrections.muonTracking
    self.Ele25 = mcCorrections.Ele25
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso90 = mcCorrections.eIDnoiso90
    self.DYreweight = mcCorrections.DYreweight

    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc
    self.EmbedId = mcCorrections.EmbedId
    self.EmbedTrg = mcCorrections.EmbedTrg
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPhi = mcCorrections.EmbedPhi

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    self.jes = Kinematics.jes
    self.ues = Kinematics.ues
    self.names = Kinematics.names
    self.ssnames = Kinematics.ssnames
    self.sys = Kinematics.sys
    self.sssys = Kinematics.sssys
    self.qcdsys = Kinematics.qcdsys

    super(AnalyzeEMuSysQCD, self).__init__(tree, outfile, **kwargs)
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
    if row.ePt < 24 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP90) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.15)


  def obj2_id(self, row):
    return (bool(row.mPFIDMedium) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj2_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ues in itertools.product(self.names, self.ues):
      folder.append(os.path.join(*tuple_path_ues))
    for tuple_path_ss in itertools.product(self.ssnames, self.sssys):
      folder.append(os.path.join(*tuple_path_ss))
    for f in folder:
      self.book(f, "e_m_CollinearMass", "Electron + Muon Collinear Mass", 60, 0, 300)


  def fill_histos(self, myEle, myMET, myMuon, weight, name=''):
    histos = self.histograms
    histos[name+'/e_m_CollinearMass'].Fill(self.collMass(myEle, myMET, myMuon), weight)


  def fill_sshistos(self, myEle, myMET, myMuon, njets, weight, name=''):
    self.w1.var("njets").setVal(njets)
    self.w1.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Phi(), myMuon.Eta()))
    self.w1.var("e_pt").setVal(myEle.Pt())
    self.w1.var("m_pt").setVal(myMuon.Pt())
    osss = self.w1.function("em_qcd_osss").getVal()
    osss0rup = self.w1.function("em_qcd_osss_stat_0jet_unc1_up").getVal()
    osss0rdown = self.w1.function("em_qcd_osss_stat_0jet_unc1_down").getVal()
    osss1rup = self.w1.function("em_qcd_osss_stat_1jet_unc1_up").getVal()
    osss1rdown = self.w1.function("em_qcd_osss_stat_1jet_unc1_down").getVal()
    osss2rup = self.w1.function("em_qcd_osss_stat_2jet_unc1_up").getVal()
    osss2rdown = self.w1.function("em_qcd_osss_stat_2jet_unc1_down").getVal()
    osss0sup = self.w1.function("em_qcd_osss_stat_0jet_unc2_up").getVal()
    osss0sdown = self.w1.function("em_qcd_osss_stat_0jet_unc2_down").getVal()
    osss1sup = self.w1.function("em_qcd_osss_stat_1jet_unc2_up").getVal()
    osss1sdown = self.w1.function("em_qcd_osss_stat_1jet_unc2_down").getVal()
    osss2sup = self.w1.function("em_qcd_osss_stat_2jet_unc2_up").getVal()
    osss2sdown = self.w1.function("em_qcd_osss_stat_2jet_unc2_down").getVal()
    osssisoup = self.w1.function("em_qcd_osss_extrap_up").getVal()
    osssisodown = self.w1.function("em_qcd_osss_extrap_down").getVal()
    if '0Jet' in name:
      oslist = [osss, osss0rup, osss0rdown, osss0sup, osss0sdown, osss, osss, osss, osss, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    elif '1Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss1rup, osss1rdown, osss1sup, osss1sdown, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    elif '2Jet' in name:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss2rup, osss2rdown, osss2sup, osss2sdown, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])
    else:
      oslist = [osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss, osss]
      for i, osl in enumerate(oslist):
        self.fill_histos(myEle, myMET, myMuon, weight*osl, name+self.qcdsys[i])


  def fill_sscategories(self, row, myEle, myMET, myMuon, njets, weight, name=''):
    dphimumet = self.deltaPhi(myMuon.Phi(), myMET.Phi())
    mtemet = self.transverseMass(myEle, myMET)
    mjj = getattr(row, 'vbfMass')
    self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS')
    if njets==0 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
        self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS0Jet')
    elif njets==1 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
        self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 500 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
        self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 500 and mtemet > 60 and dphimumet < 1 and row.e_m_PZeta > -60:
        self.fill_sshistos(myEle, myMET, myMuon, njets, weight, 'TightSS2JetVBF')


  def process(self):

    for row in self.tree:

      triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24

      if self.filters(row):
        continue

      if not bool(triggerm8e23):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.4:
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

      if self.is_data or self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.Energy())

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)

      weight = 1.0
      eff_trg_data = 0
      eff_trg_mc = 0
      if self.is_mc:
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        if triggerm8e23:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_8_ic_data").getVal()*self.w1.function("e_trg_23_ic_data").getVal()
          eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_8_ic_mc").getVal()*self.w1.function("e_trg_23_ic_mc").getVal()
        tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
        mID = 0 if self.w1.function("m_id_ic_mc").getVal()==0 else self.w1.function("m_id_ic_data").getVal()/self.w1.function("m_id_ic_mc").getVal()
        mIso = 0 if self.w1.function("m_iso_ic_mc").getVal()==0 else self.w1.function("m_iso_ic_data").getVal()/self.w1.function("m_iso_ic_mc").getVal()
        #mID = self.muonMediumID(myMuon.Eta(), myMuon.Pt())
        #mIso = self.muonLooseIsoMediumID(myMuon.Eta(), myMuon.Pt())
        mTrk = self.muTracking(myMuon.Eta())[0]
        eID = self.eIDnoiso90(myEle.Eta(), myEle.Pt())
        #eTrk = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*eID*mcSF*row.prefiring_weight
        if self.is_DY:
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight*dyweight
          #if row.numGenJets < 5:
          #  weight = weight*self.DYweight[row.numGenJets]
          #else:
          #  weight = weight*self.DYweight[0]
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

      nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
      if nbtag > 2:
        nbtag = 2
      if bool(self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
        weight = weight * btagweight
      if (bool(self.is_data or self.is_embed) and nbtag > 0):
        weight = 0

      if self.obj1_iso(row) and self.obj2_iso(row):
        if self.oppositesign(row):
          continue
        else:
          self.fill_sscategories(row, myEle, myMET, myMuon, njets, weight)


  def finish(self):
    self.write_histos()
