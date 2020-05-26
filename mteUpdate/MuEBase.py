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
from FinalStateAnalysis.TagAndProbe.bTagSF2018 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class MuEBase():
  tree = 'emu_tree'

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

    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eID = mcCorrections.eID
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
    triggerm23e12 = row.passMu23E12 and row.pt_2 > 24 and row.pt_1 > 13# and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath
    return bool(triggerm23e12)

  # Kinematics requirements on both the leptons
  def kinematics(self, row):
    if row.pt_2 < 24 or abs(row.eta_2) >= 2.4:
      return False
    if row.pt_1 < 13 or abs(row.eta_1) >= 2.5:
      return False
    return True

  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Book histograms
  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, 'm_e_CollMass', 'Muon + Electron Collinear Mass', 30, 0, 300)

  def fill_histos(self, row, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms
    histos[name+'/m_e_CollMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)

  # Selections
  def eventSel(self, row):
    njets = row.njets
    if self.filters(row):
      return False
    elif not self.trigger(row):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.phi_1, row.phi_2, row.eta_1, row.eta_2) < 0.3:
      return False
    elif njets > 2:
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myMuon = ROOT.TLorentzVector()
    myMuon.SetPtEtaPhiM(row.pt_2, row.eta_2, row.phi_2, 0.1057)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.met, 0, row.metphi, 0)
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.pt_1, row.eta_1, row.phi_1, 0.0)
    return [myMuon, myMET, myEle]


  def corrFact(self, row, myMuon, myEle):
    # Apply all the various corrections to the MC samples
    weight = 1.0
    if self.is_mc:
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      self.w1.var('e_iso').setVal(row.iso_1)
      eff_trg_data = self.w1.function('m_trg_23_data').getVal()*self.w1.function('e_trg_12_data').getVal()
      eff_trg_mc = self.w1.function('m_trg_23_mc').getVal()*self.w1.function('e_trg_12_mc').getVal()
      tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
      mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      mTrk = self.muTracking(myMuon.Eta())[0]
      eID = self.w1.function('e_id80_kit_ratio').getVal()
      eIso = self.w1.function('e_iso_kit_ratio').getVal()
      eReco = self.w1.function('e_trk_ratio').getVal()
      weight = weight*row.genweight*pucorrector[''](row.npu)*tEff*mID*mIso*mTrk*eID*eIso*eReco
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
      #if self.is_TT:
        #topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        #weight = weight*topweight
        #if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and self.Emb:
        #  weight = 0.0
      weight = self.mcWeight.lumiWeight(weight)

    njets = row.njets
    mjj = row.mjj

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
      trgsel = self.w1.function('m_sel_trg_ratio').getVal()
      self.w1.var('m_pt').setVal(myMuon.Pt())
      self.w1.var('m_eta').setVal(myMuon.Eta())
      self.w1.var('m_iso').setVal(row.mRelPFIsoDBDefaultR04)
      m_id_sf = self.w1.function('m_id_kit_ratio').getVal()
      m_iso_sf = self.w1.function('m_iso_binned_kit_ratio').getVal()
      self.w1.var('e_pt').setVal(myEle.Pt())
      self.w1.var('e_eta').setVal(myEle.Eta())
      self.w1.var('e_iso').setVal(row.eRelPFIsoRho)
      e_id_sf = self.w1.function('e_id80_kit_data').getVal()/self.w1.function('e_id80_kit_embed').getVal()
      e_iso_sf = self.w1.function('e_iso_embed_kit_ratio').getVal()
      eff_trg_data = self.w1.function('m_trg_23_data').getVal()*self.w1.function('e_trg_12_data').getVal()
      eff_trg_embed = self.w1.function('m_trg_23_embed').getVal()*self.w1.function('e_trg_12_embed').getVal()
      trg_sf = 0 if eff_trg_embed==0 else eff_trg_data/eff_trg_embed
      weight = weight*row.GenWeight*msel*esel*trgsel*trg_sf*m_id_sf*m_iso_sf*e_id_sf*e_iso_sf*self.EmbedPhi(myEle.Phi(), njets, mjj)*self.EmbedEta(myEle.Eta(), njets, mjj)
      if row.GenWeight > 1.0:
        weight = 0

    self.w1.var('njets').setVal(njets)
    self.w1.var('dR').setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Eta(), myMuon.Eta()))
    self.w1.var('e_pt').setVal(myEle.Pt())
    self.w1.var('m_pt').setVal(myMuon.Pt())
    osss = self.w1.function('em_qcd_osss_binned').getVal()

    # b-tag
    nbtag = row.nbtag
    if nbtag > 2:
      nbtag = 2
    if (self.is_mc and nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.bpt_1, row.bflavor_1, row.bpt_2, row.bflavor_2, 1, 0, 0)
      weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
      weight = 0

    return [weight, osss]
