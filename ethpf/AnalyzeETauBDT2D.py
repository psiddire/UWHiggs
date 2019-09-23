'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import ETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import array
import mcCorrections
import Kinematics
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVACat

class AnalyzeETauBDT2D(MegaBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateEle = mcCorrections.fakerateElectron_weight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case

    self.var_d_star = ['ePt', 'tPt', 'dPhiETau', 'dEtaETau', 'e_t_collinearMass', 'e_t_visibleMass', 'MTTauMET', 'dPhiTauMET', 'njets', 'vbfMass']
    self.xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDTCat.weights.xml')
    self.functor = FunctorFromMVACat('BDTCat method', self.xml_name, *self.var_d_star)

    super(AnalyzeETauBDT2D, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.ePt < 25 or abs(row.eEta) >= 2.1:
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
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronTightMVA6 > 0.5) and bool(row.tAgainstMuonLoose3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)


  def var_d(self, myEle, myMET, myTau, njets, mjj):
    return {'ePt' : myEle.Pt(), 'tPt' : myTau.Pt(), 'dPhiETau' : self.deltaPhi(myEle.Phi(), myTau.Phi()), 'dEtaETau' : self.deltaEta(myEle.Eta(), myTau.Eta()), 'e_t_collinearMass' : self.collMass(myEle, myMET, myTau), 'e_t_visibleMass' : self.visibleMass(myEle, myTau), 'MTTauMET' : self.transverseMass(myTau, myMET), 'dPhiTauMET' : self.deltaPhi(myTau.Phi(), myMET.Phi()), 'njets' : int(njets), 'vbfMass' : mjj}


  def begin(self):
    names=['BDT', 'BDT0Jet', 'BDT1Jet', 'BDT2Jet', 'BDT2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book2(names[x], "ePt", "", 200, 0, 200, 100, -0.5, 0.5)
      self.book2(names[x], "tPt", "", 200, 0, 200, 100, -0.5, 0.5)
      self.book2(names[x], "dPhiETau", "", 40, 0, 4, 100, -0.5, 0.5)
      self.book2(names[x], "dEtaETau", "", 50, 0, 5, 100, -0.5, 0.5)
      self.book2(names[x], "e_t_collinearMass", "", 300, 0, 300, 100, -0.5, 0.5)
      self.book2(names[x], "e_t_visibleMass", "", 300, 0, 300, 100, -0.5, 0.5)
      self.book2(names[x], "MTTauMET", "", 200, 0, 200, 100, -0.5, 0.5)
      self.book2(names[x], "dPhiTauMET", "", 40, 0, 4, 100, -0.5, 0.5)


  def fill_histos(self, myEle, myMET, myTau, njets, mjj, weight, name=''):
    histos = self.histograms
    mva = self.functor(**self.var_d(myEle, myMET, myTau, njets, mjj))
    histos[name+'/ePt'].Fill(myEle.Pt(), mva, weight)
    histos[name+'/tPt'].Fill(myTau.Pt(), mva, weight)
    histos[name+'/dPhiETau'].Fill(self.deltaPhi(myEle.Phi(), myTau.Phi()), mva, weight)
    histos[name+'/dEtaETau'].Fill(self.deltaEta(myEle.Eta(), myTau.Eta()), mva, weight)
    histos[name+'/e_t_collinearMass'].Fill(self.collMass(myEle, myMET, myTau), mva, weight)
    histos[name+'/e_t_visibleMass'].Fill(self.visibleMass(myEle, myTau), mva, weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), mva, weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), mva, weight)


  def process(self):

    for row in self.tree:

      trigger27 = row.Ele27WPTightPass and row.eMatchesEle27Filter and row.eMatchesEle27Path and row.ePt > 28
      trigger32 = row.Ele32WPTightPass and row.eMatchesEle32Filter and row.eMatchesEle32Path and row.ePt > 33
      trigger35 = row.Ele35WPTightPass and row.eMatchesEle35Filter and row.eMatchesEle35Path and row.ePt > 36
      trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1

      if self.filters(row):
        continue

      if not bool(trigger27 or trigger32 or trigger35 or trigger2430):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.tPhi, row.ePhi, row.tEta, row.eEta) < 0.5:
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

      if not self.dieleveto(row):
        continue

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)
      mjj = row.vbfMassWoNoisyJets

      weight = 1.0
      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        if not self.oppositesign(row):
          self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau*frEle*-1, 'BDT')
          if njets==0:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau*frEle*-1, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau*frEle*-1, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau*frEle*-1, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau*frEle*-1, 'BDT2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        if not self.oppositesign(row):
          self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau, 'BDT')
          if njets==0:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frTau, 'BDT2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        if not self.oppositesign(row):
          self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frEle, 'BDT')
          if njets==0:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frEle, 'BDT0Jet')
          elif njets==1:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frEle, 'BDT1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frEle, 'BDT2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(myEle, myMET, myTau, njets, mjj, weight*frEle, 'BDT2JetVBF')


  def finish(self):
    self.write_histos()
