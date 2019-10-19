'''

Run LFV H->MuTau analysis in the mu+tau_h channel.

Authors: Prasanna Siddireddy

'''  

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import array
import mcCorrections
import Kinematics
from bTagSF import PromoteDemote
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVACat

class AnalyzeMuTauBDT2D(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case

    self.var_d_star = ['mPt', 'tPt', 'dPhiMuTau', 'dEtaMuTau', 'type1_pfMetEt', 'm_t_collinearMass', 'MTTauMET', 'dPhiTauMET', 'njets', 'vbfMass']
    self.xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDTCat.weights.xml')
    self.functor = FunctorFromMVACat('BDTCat method', self.xml_name, *self.var_d_star)

    super(AnalyzeMuTauBDT2D, self).__init__(tree, outfile, **kwargs)
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
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or row.Flag_eeBadScFilter:
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


  def var_d(self, myMuon, myMET, myTau, njets, mjj):
    return {'mPt' : myMuon.Pt(), 'tPt' : myTau.Pt(), 'dPhiMuTau' : self.deltaPhi(myMuon.Phi(), myTau.Phi()), 'dEtaMuTau' : self.deltaEta(myMuon.Eta(), myTau.Eta()), 'type1_pfMetEt' : myMET.Et(), 'm_t_collinearMass' : self.collMass(myMuon, myMET, myTau), 'MTTauMET' : self.transverseMass(myTau, myMET), 'dPhiTauMET' : self.deltaPhi(myTau.Phi(), myMET.Phi()), 'njets' : int(njets), 'vbfMass' : mjj}


  def begin(self):
    names=['BDT', 'BDT0Jet', 'BDT1Jet', 'BDT2Jet', 'BDT2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book2(names[x], 'mPt', '', 200, 0, 200, 100, -0.7, 0.3)
      self.book2(names[x], 'tPt', '', 200, 0, 200, 100, -0.7, 0.3)
      self.book2(names[x], 'dPhiMuTau', '', 40, 0, 4, 100, -0.7, 0.3)
      self.book2(names[x], 'dEtaMuTau', '', 50, 0, 5, 100, -0.7, 0.3)
      self.book2(names[x], 'type1_pfMetEt', '', 200, 0, 200, 100, -0.7, 0.3)
      self.book2(names[x], 'm_t_collinearMass', '', 300, 0, 300, 100, -0.7, 0.3)
      self.book2(names[x], 'MTTauMET', '', 200, 0, 200, 100, -0.7, 0.3)
      self.book2(names[x], 'dPhiTauMET', '', 40, 0, 4, 100, -0.7, 0.3)


  def fill_histos(self, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myMuon, myMET, myTau, njets, mjj))
    histos[name+'/mPt'].Fill(myMuon.Pt(), mva, weight)
    histos[name+'/tPt'].Fill(myTau.Pt(), mva, weight)
    histos[name+'/dPhiMuTau'].Fill(self.deltaPhi(myMuon.Phi(), myTau.Phi()), mva, weight)
    histos[name+'/dEtaMuTau'].Fill(self.deltaEta(myMuon.Eta(), myTau.Eta()), mva, weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), mva, weight)
    histos[name+'/m_t_collinearMass'].Fill(self.collMass(myMuon, myMET, myTau), mva, weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), mva, weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), mva, weight)


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

      if self.deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
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

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      nbtag = row.bjetDeepCSVVeto20Medium
      if nbtag > 0:
        continue

      weight = 1.0
      mjj = row.vbfMassWoNoisyJets
      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(myMuon.Pt())
        if not self.oppositesign(row):
          self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau*frMuon*-1, 'BDT')
          if njets==0:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau*frMuon*-1, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau*frMuon*-1, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau*frMuon*-1, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau*frMuon*-1, 'BDT2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        if not self.oppositesign(row):
          self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau, 'BDT')
          if njets==0:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frTau, 'BDT2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(myMuon.Pt())
        if not self.oppositesign(row):
          self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frMuon, 'BDT')
          if njets==0:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frMuon, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frMuon, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frMuon, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myMuon, myMET, myTau, njets, mjj, weight*frMuon, 'BDT2JetVBF')



  def finish(self):
    self.write_histos()
