'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import ETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
import FakeRate

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeETauZEE(MegaBase):
  tree = 'et/final/Ntuple'

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

    self.Ele25 = mcCorrections.Ele25
    self.EleIdIso = mcCorrections.EleIdIso
    self.eIDnoiso80 = mcCorrections.eIDnoiso80
    self.DYreweight = mcCorrections.DYreweight
    self.w1 = mcCorrections.w1
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPhi = mcCorrections.EmbedPhi
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

    self.fakeRate = FakeRate.fakerateDeep_weight
    self.fakeRateEle = FakeRate.fakerateEle_weight

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeETauZEE, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.ePt < 27 or abs(row.eEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalSuperTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or bool(self.is_data and row.Flag_eeBadScFilter):#row.Flag_ecalBadCalibFilter -> row.Flag_ecalBadCalibReducedMINIAODFilter
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.15)


  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFindingNewDMs > 0.5) and bool(row.tTightDeepTau2017v2p1VSe > 0.5) and bool(row.tLooseDeepTau2017v2p1VSmu > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tTightDeepTau2017v2p1VSjet > 0.5)


  def obj2_loose(self, row):
    return bool(row.tVLooseDeepTau2017v2p1VSjet > 0.5)


  def vetos(self, row):
    return bool(row.eVetoZTTp001dxyz < 0.5) and bool(row.muVetoZTTp001dxyz < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5)


  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)


  def begin(self):
    for n in Kinematics.zeenames:
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
    histos[name+'/j1Pt'].Fill(row.j1pt, weight)
    histos[name+'/j2Pt'].Fill(row.j2pt, weight)
    histos[name+'/j1Eta'].Fill(row.j1eta, weight)
    histos[name+'/j2Eta'].Fill(row.j2eta, weight)
    histos[name+'/j1Phi'].Fill(row.j1phi, weight)
    histos[name+'/j2Phi'].Fill(row.j2phi, weight)
    histos[name+'/e_t_Mass'].Fill(self.visibleMass(myEle, myTau), weight)
    histos[name+'/e_t_CollinearMass'].Fill(self.collMass(myEle, myMET, myTau), weight)
    histos[name+'/e_t_PZeta'].Fill(row.e_t_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMass, weight)
    histos[name+'/dEtaETau'].Fill(self.deltaEta(myEle.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiETau'].Fill(self.deltaPhi(myEle.Phi(), myTau.Phi()), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), weight)


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

      trigger25 = row.singleE25eta2p1TightPass and row.eMatchesEle25Filter and row.eMatchesEle25Path and row.ePt > 27

      if self.filters(row):
        continue

      if not bool(trigger25):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.tPhi, row.eEta, row.tEta) < 0.5:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
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

      if not self.dieleveto(row):
        continue

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

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
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      if self.visibleMass(myEle, myTau) < 86.2 or self.visibleMass(myEle, myTau) > 96.2:                                                                                                                                                                                      
        continue                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                              
      if self.transverseMass(myEle, myMET) > 40:                                                                                                                                                                                                                              
        continue                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                              
      if myMET.Pt() > 25:                                                                                                                                                                                                                                                     
        continue                                                                                                                                                                                                                                                              


      weight = 1.0
      if self.is_mc:
        tEff = self.Ele25(row.ePt, abs(row.eEta))[0]
        zvtx = 0.991
        eID = self.eIDnoiso80(row.eEta, row.ePt)
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*zvtx*row.prefiring_weight
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
          if row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
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
        self.w1.var('gt_pt').setVal(myEle.Pt())
        self.w1.var('gt_eta').setVal(myEle.Eta())
        esel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Tau selection scale factor
        self.w1.var('gt_pt').setVal(myTau.Pt())
        self.w1.var('gt_eta').setVal(myTau.Eta())
        tsel = self.w1.function('m_sel_id_ic_ratio').getVal()
        # Trigger selection scale factor
        self.w1.var('gt1_pt').setVal(myEle.Pt())
        self.w1.var('gt1_eta').setVal(myEle.Eta())
        self.w1.var('gt2_pt').setVal(myTau.Pt())
        self.w1.var('gt2_eta').setVal(myTau.Eta())
        trgsel = self.w1.function('m_sel_trg_ic_ratio').getVal()
        # Electron Identification, Isolation, tracking, and trigger scale factors
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        e_trg_sf = self.w1.function('e_trg_ic_embed_ratio').getVal()
        e_idiso_sf = self.w1.function('e_idiso_ic_embed_ratio').getVal()
        e_trk_sf = self.w1.function('e_trk_embed_ratio').getVal()
        weight = row.GenWeight*dm*esel*tsel*trgsel*e_trg_sf*e_idiso_sf*e_trk_sf*self.EmbedEta(myEle.Eta(), njets, mjj)*self.EmbedPhi(myEle.Phi(), njets, mjj)
        # Tau Identification
        if self.obj2_tight(row):
          weight = weight * self.deepTauVSjet_Emb_tight(myTau.Pt())[0]
        elif self.obj2_loose(row):
          weight = weight * self.deepTauVSjet_Emb_vloose(myTau.Pt())[0]
        if row.GenWeight > 1:
          continue

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle*frTau
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS')

      if self.obj2_tight(row) and self.obj1_tight(row):
        if self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS')


  def finish(self):
    self.write_histos()
