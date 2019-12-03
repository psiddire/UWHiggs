'''

Run LFV H->MuE analysis in the mu+tau_e channel.

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
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVACat, FunctorFromMVA
from bTagSF import PromoteDemote, PromoteDemoteSyst, bTagEventWeight

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeMuESysBDTQCD(MegaBase):
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

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.var_d_star = ['mPt', 'ePt', 'm_e_collinearMass', 'dPhiMuMET', 'dPhiEMET', 'dPhiMuE', 'MTMuMET', 'MTEMET', 'njets', 'vbfMass']
    self.xml_name = os.path.join(os.getcwd(), "bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml")
    self.functor = FunctorFromMVACat('BDT method', self.xml_name, *self.var_d_star)

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonMediumID = mcCorrections.muonID_medium
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP90 = mcCorrections.eIDnoIsoWP90
    self.eReco = mcCorrections.eReco
    self.EmbedEta = mcCorrections.EmbedEta
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.wp = mcCorrections.wp

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
    self.names = Kinematics.names
    self.ssnames = Kinematics.ssnames
    self.sys = Kinematics.sys
    self.sssys = Kinematics.sssys
    self.qcdsys = Kinematics.qcdsys

    super(AnalyzeMuESysBDTQCD, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
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


  def obj1_id(self, row):
    return (bool(row.mPFIDMedium) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))


  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.2)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP90) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def begin(self):
    folder = []
    for tuple_path in itertools.product(self.names, self.sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(self.names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ss in itertools.product(self.ssnames, self.sssys):
      folder.append(os.path.join(*tuple_path_ss))
    for f in folder:
      self.book(f, "bdtDiscriminator", "BDT Discriminator", 200, -1.0, 1.0)


  def fill_histos(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myEle, njets, mjj))
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def var_d(self, myMuon, myMET, myEle, njets, mjj):
    return {'mPt' : myMuon.Pt(), 'ePt' : myEle.Pt(), 'm_e_collinearMass' : self.collMass(myMuon, myMET, myEle), 'dPhiMuMET' : self.deltaPhi(myMuon.Phi(), myMET.Phi()), 'dPhiEMET' : self.deltaPhi(myEle.Phi(), myMET.Phi()), 'dPhiMuE' : self.deltaPhi(myMuon.Phi(), myEle.Phi()), 'MTMuMET' : self.transverseMass(myMuon, myMET), 'MTEMET' : self.transverseMass(myEle, myMET), 'njets' : int(njets), 'vbfMass' : mjj}


  def fill_sshistos(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    self.w3.var("njets").setVal(njets)
    self.w3.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Phi(), myMuon.Eta()))
    self.w3.var("e_pt").setVal(myEle.Pt())
    self.w3.var("m_pt").setVal(myMuon.Pt())
    osss = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0rup = self.w3.function("em_qcd_osss_0jet_rateup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0rdown = self.w3.function("em_qcd_osss_0jet_ratedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0sup = self.w3.function("em_qcd_osss_0jet_shapeup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0sdown = self.w3.function("em_qcd_osss_0jet_shapedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1rup = self.w3.function("em_qcd_osss_1jet_rateup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1rdown = self.w3.function("em_qcd_osss_1jet_ratedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1sup = self.w3.function("em_qcd_osss_1jet_shapeup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1sdown = self.w3.function("em_qcd_osss_1jet_shapedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osssisoup = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osssisodown = self.w3.function("em_qcd_osss_binned").getVal()
    if '0Jet' in name:
      oslist = [osss, osss0rup, osss0rdown, osss0sup, osss0sdown, osss, osss, osss, osss, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])
    else:
      oslist = [osss, osss, osss, osss, osss, osss1rup, osss1rdown, osss1sup, osss1sdown, osssisoup, osssisodown]
      for i, osl in enumerate(oslist):
        self.fill_histos(myMuon, myMET, myEle, weight*osl, name+self.qcdsys[i])


  def fill_sscategories(self, row, myMuon, myMET, myEle, njets, weight, name=''):
    mjj = getattr(row, 'vbfMassWoNoisyJets')
    self.fill_sshistos(myMuon, myMET, myEle, njets, mjj, weight, 'TightSS')
    if njets==0:
        self.fill_sshistos(myMuon, myMET, myEle, njets, mjj, weight, 'TightSS0Jet')
    elif njets==1:
        self.fill_sshistos(myMuon, myMET, myEle, njets, mjj, weight, 'TightSS1Jet')
    elif njets==2 and mjj < 550:
        self.fill_sshistos(myMuon, myMET, myEle, njets, mjj, weight, 'TightSS2Jet')
    elif njets==2 and mjj > 550:
        self.fill_sshistos(myMuon, myMET, myEle, njets, mjj, weight, 'TightSS2JetVBF')


  def process(self):

    for row in self.tree:

      triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24# and row.eMatchesMu8e23DZFilter and row.eMatchesMu8e23DZPath and row.mMatchesMu8e23DZFilter and row.mMatchesMu8e23DZPath
      triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13# and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath

      if self.filters(row):
        continue

      if not bool(triggerm8e23 or triggerm23e12):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

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
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)

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
        mID = self.muonMediumID(myMuon.Pt(), abs(myMuon.Eta()))
        mIso = self.muonLooseIsoMediumID(myMuon.Pt(), abs(myMuon.Eta()))
        mTrk = self.muTracking(myMuon.Eta())[0]
        eID = self.eIDnoIsoWP90(myEle.Pt(), abs(myEle.Eta()))
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

      if bool(self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        weight = weight * btagweight
      if bool(self.is_data or self.is_embed):
        if nbtag > 0:
          weight = 0

      if self.obj1_iso(row) and self.obj2_iso(row):
        if self.oppositesign(row):
          continue
        else:
          self.fill_sscategories(row, myMuon, myMET, myEle, njets, weight)


  def finish(self):
    self.write_histos()
