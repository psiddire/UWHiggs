'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import os
import ROOT
import math
import mcCorrections
import mcWeights
import FakeRate
import Kinematics
from FinalStateAnalysis.TagAndProbe.bTagSF2017 import bTagEventWeight

target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)

class ETauBase():

  def __init__(self):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT
    self.is_ST = self.mcWeight.is_ST
    self.is_VV = self.mcWeight.is_VV
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.Emb = True
    self.is_recoilC = self.mcWeight.is_recoilC
    self.MetCorrection = self.mcWeight.MetCorrection
    if self.is_recoilC and self.MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys
    self.tauSF = mcCorrections.tauSF

    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.eReco = mcCorrections.eReco
    self.deepTauVSe = mcCorrections.deepTauVSe
    self.deepTauVSmu = mcCorrections.deepTauVSmu
    self.deepTauVSjet_tight = mcCorrections.deepTauVSjet_tight
    self.deepTauVSjet_vloose = mcCorrections.deepTauVSjet_vloose
    self.deepTauVSjet_Emb_tight = mcCorrections.deepTauVSjet_Emb_tight
    self.deepTauVSjet_Emb_vloose = mcCorrections.deepTauVSjet_Emb_vloose
    self.esTau = mcCorrections.esTau
    self.tesMC = mcCorrections.tesMC
    self.FesTau = mcCorrections.FesTau
    self.FesMuTau = mcCorrections.FesMuTau
    self.ScaleTau = mcCorrections.ScaleTau
    self.ScaleEmbTau = mcCorrections.ScaleEmbTau
    self.TauID = mcCorrections.TauID
    self.MuonFakeTau = mcCorrections.MuonFakeTau
    self.EleFakeTau = mcCorrections.EleFakeTau
    self.RecSys = mcCorrections.RecSys

    self.DYreweight = mcCorrections.DYreweight
    self.w2 = mcCorrections.w2
    self.w6 = mcCorrections.w6
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPhi = mcCorrections.EmbedPhi
    self.EmbedPt = mcCorrections.EmbedPt

    self.fakeRate = FakeRate.fakerate_weight
    self.fakeRateEle = FakeRate.fakerateEle_weight

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

    self.names = Kinematics.names
    self.loosenames = Kinematics.loosenames
    self.jes = Kinematics.jes
    self.ues = Kinematics.ues
    self.fakes = Kinematics.fakes
    self.sys = Kinematics.sys
    self.recSys = Kinematics.recSys
    self.fakeSys = Kinematics.fakeSys
    self.scaleSys = Kinematics.scaleSys
    self.tauidSys = Kinematics.tauidSys
    self.mtfakeSys = Kinematics.mtfakeSys
    self.etfakeSys = Kinematics.etfakeSys
    self.mtfakeesSys = Kinematics.mtfakeesSys
    self.etfakeesSys = Kinematics.etfakeesSys
    self.functor = Kinematics.functor
    self.var_d = Kinematics.var_d

    self.branches='ePt/F:tPt/F:dPhiETau/F:dEtaETau/F:dPhiEMET/F:dPhiTauMET/F:e_t_collinearMass/F:e_t_visibleMass/F:e_t_PZeta/F:MTTauMET/F:MTEMET/F:type1_pfMetEt/F:njets/I:vbfMass/F:weight/F'
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name='TreeS'
      self.title='TreeS'
    else:
      self.name='TreeB'
      self.title='TreeB'

  # Charge Requirement
  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True

  # Trigger
  def trigger(self, row):
    if self.is_embed:
      if abs(row.eEta) < 1.479:
        trigger27 = row.Ele27WPTightPass and row.eMatchEmbeddedFilterEle27 and row.ePt > 28
        trigger32 = row.Ele32WPTightPass and row.eMatchEmbeddedFilterEle32 and row.ePt > 33
        trigger35 = row.Ele35WPTightPass and row.eMatchEmbeddedFilterEle35 and row.ePt > 36
        trigger2430 = row.Ele24LooseTau30Pass and row.eMatchEmbeddedFilterEle24Tau30 and row.tMatchEmbeddedFilterEle24Tau30 and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1
      else:
        trigger27 = True
        trigger32 = True
        trigger35 = True
        trigger2430 = True
    else:
      trigger27 = row.Ele27WPTightPass and row.eMatchesEle27Filter and row.eMatchesEle27Path and row.ePt > 28
      trigger32 = row.Ele32WPTightPass and row.eMatchesEle32Filter and row.eMatchesEle32Path and row.ePt > 33
      trigger35 = row.Ele35WPTightPass and row.eMatchesEle35Filter and row.eMatchesEle35Path and row.ePt > 36
      trigger2430 = row.Ele24LooseTau30Pass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1
    return [trigger27 or trigger32 or trigger35, trigger2430]

  # Kinematics Selections
  def kinematics(self, row):
    if row.ePt < 25 or abs(row.eEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True

  # MET Filters
  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False

  # Electron Identification
  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))

  # Electron Tight Isolation
  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)

  # Electron Loose Isolation
  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)

  # Tau decay mode finding along with discrimination against electron and muon, and primary vertex matching
  def obj2_id(self, row):
    return bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tTightDeepTau2017v2p1VSe > 0.5) and bool(row.tLooseDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2)

  # Tight Working Point(WP) for Isolation for tau
  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)

  # Very Loose Working Point(WP) for Isolation for tau
  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)

  # Veto of events with additional leptons coming from the primary vertex
  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPtDeepVtx < 0.5)

  # Di-electron veto
  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)

  # Book the histograms
  def begin(self):
    for n in Kinematics.plotnames:
      self.book(n, 'ePt', 'Electron  Pt', 20, 0, 200)
      self.book(n, 'tPt', 'Tau Pt', 20, 0, 200)
      self.book(n, 'eEta', 'Electron Eta', 20, -3, 3)
      self.book(n, 'tEta', 'Tau Eta', 20, -3, 3)
      self.book(n, 'ePhi', 'Electron Phi', 20, -4, 4)
      self.book(n, 'tPhi', 'Tau Phi', 20, -4, 4)
      self.book(n, 'type1_pfMetEt', 'Type1 MET Et', 20, 0, 200)
      self.book(n, 'type1_pfMetPhi', 'Type1 MET Phi', 20, -4, 4)
      self.book(n, 'j1Pt', 'Jet 1 Pt', 30, 0, 300)
      self.book(n, 'j2Pt', 'Jet 2 Pt', 30, 0, 300)
      self.book(n, 'j1Eta', 'Jet 1 Eta', 20, -3, 3)
      self.book(n, 'j2Eta', 'Jet 2 Eta', 20, -3, 3)
      self.book(n, 'j1Phi', 'Jet 1 Phi', 20, -4, 4)
      self.book(n, 'j2Phi', 'Jet 2 Phi', 20, -4, 4)
      self.book(n, 'e_t_Mass', 'Electron + Tau Mass', 30, 0, 300)
      self.book(n, 'e_t_CollinearMass', 'Electron + Tau Collinear Mass', 30, 0, 300)
      self.book(n, 'e_t_PZeta', 'Electron + Tau PZeta', 80, -400, 400)
      self.book(n, 'numOfJets', 'Number of Jets', 5, 0, 5)
      self.book(n, 'numOfVtx', 'Number of Vertices', 100, 0, 100)
      self.book(n, 'vbfMass', 'VBF Mass', 100, 0, 1000)
      self.book(n, 'dEtaETau', 'Delta Eta E Tau', 50, 0, 5)
      self.book(n, 'dPhiEMET', 'Delta Phi E MET', 40, 0, 4)
      self.book(n, 'dPhiTauMET', 'Delta Phi Tau MET', 40, 0, 4)
      self.book(n, 'dPhiETau', 'Delta Phi E Tau', 40, 0, 4)
      self.book(n, 'MTEMET', 'Electron MET Transverse Mass', 20, 0, 200)
      self.book(n, 'MTTauMET', 'Tau MET Transverse Mass', 20, 0, 200)

  # Fill the histograms
  def fill_histos(self, row, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/tPt'].Fill(myTau.Pt(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/ePhi'].Fill(myEle.Phi(), weight)
    histos[name+'/tPhi'].Fill(myTau.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1ptWoNoisyJets, weight)
    histos[name+'/j2Pt'].Fill(row.j2ptWoNoisyJets, weight)
    histos[name+'/j1Eta'].Fill(row.j1etaWoNoisyJets, weight)
    histos[name+'/j2Eta'].Fill(row.j2etaWoNoisyJets, weight)
    histos[name+'/j1Phi'].Fill(row.j1phiWoNoisyJets, weight)
    histos[name+'/j2Phi'].Fill(row.j2phiWoNoisyJets, weight)
    histos[name+'/e_t_Mass'].Fill(self.visibleMass(myEle, myTau), weight)
    histos[name+'/e_t_CollinearMass'].Fill(self.collMass(myEle, myMET, myTau), weight)
    histos[name+'/e_t_PZeta'].Fill(row.e_t_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30WoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMassWoNoisyJets, weight)
    histos[name+'/dEtaETau'].Fill(self.deltaEta(myEle.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiETau'].Fill(self.deltaPhi(myEle.Phi(), myTau.Phi()), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), weight)

  # Selections
  def eventSel(self, row):
    njets = row.jetVeto30WoNoisyJets
    if self.filters(row):
      return False
    elif not bool(self.trigger(row)[0] or self.trigger(row)[1]):
      return False
    elif not self.kinematics(row):
      return False
    elif self.deltaR(row.ePhi, row.tPhi, row.eEta, row.tEta) < 0.5:
      return False
    elif self.Emb and self.is_DY and not bool(row.isZmumu or row.isZee):
      return False
    elif njets > 2:
      return False
    elif not self.obj1_id(row):
      return False
    elif not self.obj2_id(row):
      return False
    elif row.tDecayMode==5 or row.tDecayMode==6:
      return False
    elif not self.vetos(row):
      return False
    elif not self.dieleveto(row):
      return False
    else:
      return True

  # TVector
  def lepVec(self, row):
    myEle = ROOT.TLorentzVector()
    myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
    myMET = ROOT.TLorentzVector()
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)
    myTau = ROOT.TLorentzVector()
    myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    # Recoil
    if self.is_recoilC and self.MetCorrection:
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
        myEle = myEle * ROOT.Double(0.9993) if abs(myEle.Eta()) < 1.479 else myEle * ROOT.Double(0.9887)
      myMETpx = myMETpx - myEle.Px()
      myMETpy = myMETpy - myEle.Py()
      myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
    myMET = self.tauPtC(row, myMET, myTau)[0]
    myTau = self.tauPtC(row, myMET, myTau)[1]
    return [myEle, myMET, myTau]

  # Tau pT correction
  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and row.tZTTGenMatching==5:
      es = self.esTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0])
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      fes = self.FesTau(myTau.Eta(), row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes[0][0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes[0][0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes[0][0])
    if self.is_mc and bool(row.tZTTGenMatching==2 or row.tZTTGenMatching==4):
      fes = self.FesMuTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - fes) * myTau.Px()
      myMETpy = myMET.Py() + (1 - fes) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(fes)
    if self.is_embed:
      es = self.ScaleEmbTau(row.tDecayMode)
      myMETpx = myMET.Px() + (1 - es[0][0]) * myTau.Px()
      myMETpy = myMET.Py() + (1 - es[0][0]) * myTau.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpTau = myTau * ROOT.Double(es[0][0])
    return [tmpMET, tmpTau]

  # Correction Factors
  def corrFact(self, row, myEle, myTau, singEle):
    weight = 1.0
    # MC Corrections
    if self.is_mc:
      singleSF = 0
      eltauSF = 0
      self.w2.var('e_pt').setVal(myEle.Pt())
      self.w2.var('e_iso').setVal(row.eRelPFIsoRho)
      self.w2.var('e_eta').setVal(myEle.Eta())
      eID = self.w2.function('e_id80_kit_ratio').getVal()
      eIso = self.w2.function('e_iso_kit_ratio').getVal()
      eReco = self.w2.function('e_trk_ratio').getVal()
      zvtx = 0.991
      if singEle:
        singleSF = 0 if self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()==0 else self.w2.function('e_trg27_trg32_trg35_kit_data').getVal()/self.w2.function('e_trg27_trg32_trg35_kit_mc').getVal()
      else:
        eltauSF = 0 if self.w2.function('e_trg_EleTau_Ele24Leg_desy_mc').getVal()==0 else self.w2.function('e_trg_EleTau_Ele24Leg_desy_data').getVal()/self.w2.function('e_trg_EleTau_Ele24Leg_desy_mc').getVal()
        eltauSF = eltauSF * self.tauSF.getETauScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi())
      tEff = singleSF + eltauSF
      weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*zvtx*row.prefiring_weight
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
      if self.is_W:
        if row.numGenJets < 5:
          weight = weight * self.Wweight[row.numGenJets]
        else:
          weight = weight * self.Wweight[0]
      # if self.is_TT:
      #   topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
      #   weight = weight*topweight
      if self.is_TT or self.is_ST or self.is_VV:
        if row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and self.Emb:
          weight = 0.0
      weight = self.mcWeight.lumiWeight(weight)

    # Embed Corrections
    if self.is_embed:
      trsel = 0.0
      mjj = row.vbfMassWoNoisyJets
      njets = row.jetVeto30WoNoisyJets
      if row.tDecayMode == 0:
        dm = 0.975
      elif row.tDecayMode == 1:
        dm = 0.975*1.051
      elif row.tDecayMode == 10:
        dm = pow(0.975, 3)
      elif row.tDecayMode == 11:
        dm = pow(0.975, 3)*1.051
      self.w6.var('gt_pt').setVal(myEle.Pt())
      self.w6.var('gt_eta').setVal(myEle.Eta())
      esel = self.w6.function('m_sel_idEmb_ratio').getVal()
      self.w6.var('gt_pt').setVal(myTau.Pt())
      self.w6.var('gt_eta').setVal(myTau.Eta())
      tsel = self.w6.function('m_sel_idEmb_ratio').getVal()
      self.w6.var('gt1_pt').setVal(myEle.Pt())
      self.w6.var('gt1_eta').setVal(myEle.Eta())
      self.w6.var('gt2_pt').setVal(myTau.Pt())
      self.w6.var('gt2_eta').setVal(myTau.Eta())
      trgsel = self.w6.function('m_sel_trg_ratio').getVal()
      self.w6.var('e_pt').setVal(myEle.Pt())
      self.w6.var('e_eta').setVal(myEle.Eta())
      self.w6.var('e_iso').setVal(row.eRelPFIsoRho)
      self.w6.var('t_pt').setVal(myTau.Pt())
      eID = self.w6.function('e_id80_embed_kit_ratio').getVal()
      eIso = self.w6.function('e_iso_binned_embed_kit_ratio').getVal()
      if abs(myEle.Eta()) < 1.479:
        if singEle:
          trsel = trsel + self.w6.function('e_trg27_trg32_trg35_embed_kit_ratio').getVal()
        else:
          trsel = trsel + self.w6.function('e_trg_EleTau_Ele24Leg_kit_ratio_embed').getVal()*self.w6.function('et_emb_LooseChargedIsoPFTau30_kit_ratio').getVal()
      else:
        if singEle:
          trsel = trsel + self.w6.function('e_trg27_trg32_trg35_kit_data').getVal()
        else:
          trsel = trsel + self.w6.function('e_trg_EleTau_Ele24Leg_desy_data').getVal()*self.tauSF.getETauEfficiencyData(myTau.Pt(), myTau.Eta(), myTau.Phi())
      weight = weight*row.GenWeight*dm*esel*tsel*trgsel*eID*eIso*trsel*self.EmbedPhi(myEle.Phi(), njets, mjj)*self.EmbedEta(myEle.Eta(), njets, mjj)*self.EmbedPt(myEle.Pt(), njets, mjj)
      # Tau Identification
      if self.obj2_tight(row):
        weight = weight * self.deepTauVSjet_Emb_tight(myTau.Pt())[0]
      elif self.obj2_loose(row):
        weight = weight * self.deepTauVSjet_Emb_vloose(myTau.Pt())[0]
      if weight > 1 or trsel > 1:
        weight = 0.0

    # b-tag
    nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
    if nbtag > 2:
      nbtag = 2
    if (self.is_mc and nbtag > 0):
      btagweight = bTagEventWeight(nbtag, row.jb1pt_2017, row.jb1hadronflavor_2017, row.jb2pt_2017, row.jb2hadronflavor_2017, 1, 0, 0)
      weight = weight * btagweight
    if (bool(self.is_data or self.is_embed) and nbtag > 0):
      weight = 0.0
    return weight
