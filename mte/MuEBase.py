'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2016 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class MuEBase():
  tree = 'em/final/Ntuple'

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_eraG = self.mcWeight.is_eraG
    self.is_eraH = self.mcWeight.is_eraH
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT
    self.is_ST = self.mcWeight.is_ST
    self.is_VV = self.mcWeight.is_VV
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.Emb = False
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.MESSys = mcCorrections.MESSys
    self.RecSys = mcCorrections.RecSys

    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.rc = mcCorrections.rc
    self.EmbedPhi = mcCorrections.EmbedPhi
    self.EmbedEta = mcCorrections.EmbedEta

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
    self.recSys = Kinematics.recSys
    self.sssys = Kinematics.sssys
    self.qcdsys = Kinematics.qcdsys
    self.mesSys = Kinematics.mesSys
    self.functor = Kinematics.functor
    self.var_d = Kinematics.var_d

    self.branches='mPt/F:ePt/F:m_e_collinearMass/F:m_e_visibleMass/F:dPhiMuMET/F:dPhiEMET/F:dPhiMuE/F:MTMuMET/F:m_e_PZeta/F:MTEMET/F:dEtaMuE/F:type1_pfMetEt/F:njets/I:vbfMass/F:weight/F'
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name='TreeS'
      self.title='TreeS'
    else:
      self.name='TreeB'
      self.title='TreeB'

  # Requirement on the charge of the leptons
  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    if self.is_eraG or self.is_eraH or self.is_embed:
      triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13# and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath
    else:
      triggerm23e12 = row.mu23e12Pass and row.mPt > 24 and row.ePt > 13# and row.eMatchesMu23e12Filter and row.eMatchesMu23e12Path and row.mMatchesMu23e12Filter and row.mMatchesMu23e12Path
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
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))

  # Muon Isolation
  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Muon Tight Isolation
  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

  # Muon Loose Isolation
  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.5)

  # Electron Identification
  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Electron Isolation
  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)

  # Third lepton veto
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPtDeepVtx < 0.5)

  # Book histograms
  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, 'mPt', 'Muon Pt', 20, 0, 200)
      self.book(n, 'ePt', 'Electron Pt', 20, 0, 200)
      self.book(n, 'mEta', 'Muon Eta', 20, -3, 3)
      self.book(n, 'eEta', 'Electron Eta', 20, -3, 3)
      self.book(n, 'mPhi', 'Muon Phi', 20, -4, 4)
      self.book(n, 'ePhi', 'Electron Phi', 20, -4, 4)
      self.book(n, 'type1_pfMetEt', 'Type1 MET Et', 20, 0, 200)
      self.book(n, 'type1_pfMetPhi', 'Type1 MET Phi', 20, -4, 4)
      self.book(n, 'j1Pt', 'Jet 1 Pt', 30, 0, 300)
      self.book(n, 'j2Pt', 'Jet 2 Pt', 30, 0, 300)
      self.book(n, 'j1Eta', 'Jet 1 Eta', 20, -3, 3)
      self.book(n, 'j2Eta', 'Jet 2 Eta', 20, -3, 3)
      self.book(n, 'j1Phi', 'Jet 1 Phi', 20, -4, 4)
      self.book(n, 'j2Phi', 'Jet 2 Phi', 20, -4, 4)
      self.book(n, 'm_e_Mass', 'Muon + Electron Mass', 30, 0, 300)
      self.book(n, 'm_e_CollMass', 'Muon + Electron Collinear Mass', 30, 0, 300)
      self.book(n, 'm_e_PZeta', 'Muon + Electron PZeta', 80, -400, 400)
      self.book(n, 'numOfJets', 'Number of Jets', 5, 0, 5)
      self.book(n, 'vbfMass', 'VBF Mass', 100, 0, 1000)
      self.book(n, 'numOfVtx', 'Number of Vertices', 100, 0, 100)
      self.book(n, 'dEtaMuE', 'Delta Eta Mu E', 50, 0, 5)
      self.book(n, 'dPhiMuE', 'Delta Phi Mu E', 40, 0, 4)
      self.book(n, 'dPhiMuMET', 'Delta Phi Mu MET', 40, 0, 4)
      self.book(n, 'dPhiEMET', 'Delta Phi E MET', 40, 0, 4)
      self.book(n, 'MTMuMET', 'Mu MET Transverse Mass', 20, 0, 200)
      self.book(n, 'MTEMET', 'Electron MET Transverse Mass', 20, 0, 200)

  def fill_histos(self, row, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/ePhi'].Fill(myEle.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1pt, weight)
    histos[name+'/j2Pt'].Fill(row.j2pt, weight)
    histos[name+'/j1Eta'].Fill(row.j1eta, weight)
    histos[name+'/j2Eta'].Fill(row.j2eta, weight)
    histos[name+'/j1Phi'].Fill(row.j1phi, weight)
    histos[name+'/j2Phi'].Fill(row.j2phi, weight)
    histos[name+'/m_e_Mass'].Fill(self.visibleMass(myMuon, myEle), weight)
    histos[name+'/m_e_CollMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)
    histos[name+'/m_e_PZeta'].Fill(row.e_m_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuE'].Fill(self.deltaEta(myMuon.Eta(), myEle.Eta()), weight)
    histos[name+'/dPhiMuE'].Fill(self.deltaPhi(myMuon.Phi(), myEle.Phi()), weight)
    histos[name+'/dPhiMuMET'].Fill(self.deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/MTMuMET'].Fill(self.transverseMass(myMuon, myMET), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)

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
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    # Recoil
    if self.is_recoilC and self.MetCorrection:
      if self.is_W:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30 + 1)))
      else:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)
    # Electron Scale Correction
    if self.is_data:
      myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
    else:
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      if self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/myEle.E())
      elif self.is_embed:
        myEle = myEle * ROOT.Double(0.9976) if abs(myEle.Eta()) < 1.479 else myEle * ROOT.Double(0.993)
      myMETpx = myMETpx - myEle.Px()
      myMETpy = myMETpy - myEle.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    return [myMuon, myMET, myEle]


  def corrFact(self, row, myMuon, myEle):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      eff_trg_data = self.w1.function('m_trg_23_ic_data').getVal()*self.w1.function('e_trg_12_ic_data').getVal()
      eff_trg_mc = self.w1.function('m_trg_23_ic_mc').getVal()*self.w1.function('e_trg_12_ic_mc').getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      mID = self.muonTightID(myMuon.Eta(), myMuon.Pt())
      mIso = self.muonTightIsoTightID(myMuon.Eta(), myMuon.Pt())
      mTrk = self.muTracking(myMuon.Eta())[0]
      mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
      eID = self.eIDnoiso80(myEle.Eta(), myEle.Pt())
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*mcSF*eID*row.prefiring_weight
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
      # if self.is_TT:
      #   topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
      #   weight = weight*topweight
      if self.is_TT or self.is_ST or self.is_VV:
        if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and self.Emb:
          weight = 0.0
      weight = self.mcWeight.lumiWeight(weight)

    njets = row.jetVeto30
    mjj = row.vbfMass

    if self.is_embed:
      self.w1.var('gt_pt').setVal(myMuon.Pt())
      self.w1.var('gt_eta').setVal(myMuon.Eta())
      msel = self.w1.function('m_sel_idEmb_ratio').getVal()
      self.w1.var('gt_pt').setVal(myEle.Pt())
      self.w1.var('gt_eta').setVal(myEle.Eta())
      esel = self.w1.function('m_sel_idEmb_ratio').getVal()
      self.w1.var('gt1_pt').setVal(myMuon.Pt())
      self.w1.var('gt1_eta').setVal(myMuon.Eta())
      self.w1.var('gt2_pt').setVal(myEle.Pt())
      self.w1.var('gt2_eta').setVal(myEle.Eta())
      trgsel = self.w1.function('m_sel_trg_ic_ratio').getVal()
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      self.w1.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
      m_id_sf = self.w1.function('m_id_ic_embed_ratio').getVal()
      m_iso_sf = self.w1.function('m_iso_binned_ic_embed_ratio').getVal()
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      self.w1.var('e_iso').setVal(row.eRelPFIsoRho)
      e_id_sf = self.w1.function('e_id80_data').getVal()/self.w1.function('e_id80_emb').getVal()
      e_iso_sf = self.w1.function('e_iso_binned_ic_embed_ratio').getVal()
      eff_trg_data = self.w1.function('m_trg_23_ic_data').getVal()*self.w1.function('e_trg_12_ic_data').getVal()
      eff_trg_embed = self.w1.function('m_trg_23_ic_embed').getVal()*self.w1.function('e_trg_12_ic_embed').getVal()
      trg_sf = 0 if eff_trg_embed==0 else eff_trg_data/eff_trg_embed
      weight = weight*row.GenWeight*msel*esel*trgsel*trg_sf*m_id_sf*m_iso_sf*e_id_sf*e_iso_sf*self.EmbedPhi(myEle.Phi(), njets, mjj)*self.EmbedEta(myEle.Eta(), njets, mjj)
      if row.GenWeight > 1.0:
        weight = 0

    self.w1.var('njets').setVal(njets)
    self.w1.var('dR').setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var('e_pt').setVal(myEle.Pt())
    self.w1.var('m_pt').setVal(myMuon.Pt())
    osss = self.w1.function('em_qcd_osss').getVal()

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2016_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (self.is_mc and nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2016, row.jb1hadronflavor_2016, row.jb2pt_2016, row.jb2hadronflavor_2016, 1, 0, 0)
      weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
      weight = 0

    return [weight, osss]
