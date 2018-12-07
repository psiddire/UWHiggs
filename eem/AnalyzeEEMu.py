import EEMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
from math import sqrt, pi


def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

  
def visibleMass(row):
  ve1 = ROOT.TLorentzVector()
  ve2 = ROOT.TLorentzVector()
  ve1.SetPtEtaPhiM(row.e1Pt, row.e1Eta, row.e1Phi, row.e1Mass)
  ve2.SetPtEtaPhiM(row.e2Pt, row.e2Eta, row.e2Phi, row.e2Mass)
  return (ve1 + ve2).M()


target = os.path.basename(os.environ['megatarget'])

if bool('DYJetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY4')
elif bool('WJetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W')
elif bool('W1JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W1')
elif bool('W2JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W2')
elif bool('W3JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W3')
elif bool('W4JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W4')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZZ')
elif bool('ZHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZHTT')
elif bool('ttHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ttH')
elif bool('Wminus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WminusHTT')
elif bool('Wplus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WplusHTT')
elif bool('ST_t-channel_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtantitop')
elif bool('ST_t-channel_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STttop')
elif bool('ST_tW_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWantitop')
elif bool('ST_tW_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWtop')
elif bool('TTTo2L2Nu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTTo2L2Nu')
elif bool('TTToHadronic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToHadronic')
elif bool('TTToSemiLeptonic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToSemiLeptonic')
elif bool('VBFHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHTT')
elif bool('VBF_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHMT')
elif bool('GluGluHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHTT')
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHMT')
elif bool('QCD' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'QCD')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeEEMu(MegaBase):
  tree = 'eem/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)

    super(AnalyzeEEMu, self).__init__(tree, outfile, **kwargs)
    self.tree = EEMuTree.EEMuTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonTightID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonMediumID = mcCorrections.muonID_medium if not self.is_data else 1.
    self.muonLooseID = mcCorrections.muonID_loose if not self.is_data else 1.
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid if not self.is_data else 1.
    self.muonTightIsoMediumID = mcCorrections.muonIso_tight_mediumid if not self.is_data else 1.
    self.muonLooseIsoLooseID = mcCorrections.muonIso_loose_looseid if not self.is_data else 1.
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid if not self.is_data else 1.
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid if not self.is_data else 1.

    self.DYweight = {
      0 : 2.580886465,
      1 : 0.710032286,
      2 : 0.936178296,
      3 : 0.589537006,
      4 : 0.404224719
      }

    self.Wweight = {
      0 : 36.79747369,
      1 : 7.546943825,
      2 : 13.23876037,
      3 : 2.301051766,
      4 : 2.202236679
      }


  def oppositesign(self,row):
    if row.e1Charge*row.e2Charge!=-1:
      return False
    return True


  def event_weight(self, row):
    if self.is_data:
      mcweight = 1.
    else:
      mcweight = row.GenWeight*pucorrector(row.nTruePU)
      if self.is_DY:
        if row.numGenJets < 5:
          mcweight = mcweight*self.DYweight[row.numGenJets]
        else:
          mcweight = mcweight*self.DYweight[0]
      elif self.is_W:
        if row.numGenJets < 5:
          mcweight = mcweight*self.Wweight[row.numGenJets]
        else:
          mcweight = mcweight*self.Wweight[0]
      elif self.is_WW:
        mcweight = mcweight*0.637
      elif self.is_WZ:
        mcweight = mcweight*0.502
      elif self.is_ZZ:
        mcweight = mcweight*0.354
    weights = {'': mcweight}
    return weights


  def trigger(self, row):
    if not row.doubleE_23_12Pass:
      return False
    return True


  def kinematics(self, row):
    if row.e1Pt < 24 or abs(row.e1Eta) >= 2.1:
      return False
    if row.e2Pt < 13 or abs(row.e2Eta) >= 2.1:
      return False
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    return True


  def obj1_id(self,row):
    if bool(row.e1MissingHits > 0) or not bool(row.e1PassesConversionVeto) or bool(abs(row.e1Eta) > 1.4442 and abs(row.e1Eta) > 1.567) or not bool(row.e1ChargeIdTight) or bool(abs(row.e1PVDZ) > 0.2) or bool(abs(row.e1PVDXY) > 0.045):
      return False
    return True
 
 
  def obj1_iso(self,row):
    return bool(row.e1MVAIsoWP80) and bool(row.e1RelPFIsoDB < 0.1)
  
  
  def obj2_id(self, row):
    if bool(row.e2MissingHits > 0) or not bool(row.e2PassesConversionVeto) or bool(abs(row.e2Eta) > 1.4442 and abs(row.e2Eta) > 1.567) or not bool(row.e2ChargeIdTight) or bool(abs(row.e2PVDZ) > 0.2) or bool(abs(row.e2PVDXY) > 0.045):
      return False
    return True


  def obj2_iso(self, row):
    return bool(row.e2MVAIsoWP80) and bool(row.e2RelPFIsoDB < 0.1)


  def obj3_id(self, row):
    return bool(row.mPFIDMedium)


  def obj3_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj3_tightiso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20Loose3HitsVtx < 0.5))


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Loose < 0.5)


  def begin(self):
    names=['initial', 'muonloose', 'muontight']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon Pt", 30, 0, 300)
      self.book(names[x], "mEta", "Muon Eta", 10, -5, 5)
      self.book(names[x], "e1_e2_Mass", "Invariant Muon Mass", 30, 0, 300)
      self.book(names[x], "e1Pt", "Electron 1 Pt", 30, 0, 300)
      self.book(names[x], "e1Eta", "Electron 1 Eta", 10, -5, 5)
      self.book(names[x], "e2Pt", "Electron 2 Pt", 30, 0, 300)
      self.book(names[x], "e2Eta", "Electron 2 Eta", 10, -5, 5)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(row.mPt, weight)
    histos[name+'/mEta'].Fill(row.mEta, weight)
    histos[name+'/e1_e2_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/e1Pt'].Fill(row.e1Pt, weight)
    histos[name+'/e1Eta'].Fill(row.e1Eta, weight)
    histos[name+'/e2Pt'].Fill(row.e2Pt, weight)
    histos[name+'/e2Eta'].Fill(row.e2Eta, weight)

  def process(self):
    preevt=0

    for row in self.tree:
      try:
        weight_map = self.event_weight(row)
        if weight_map[''] == 0: continue
        weight = weight_map['']
      except AttributeError:
        weight = 1.0

      if not self.oppositesign(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if not self.obj1_id(row):
        continue
      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue
      if not self.obj2_iso(row):
        continue

      if visibleMass(row) < 70 or visibleMass(row) > 110:
        continue
      if not self.vetos(row):
        continue
      if not self.bjetveto(row):
        continue
      if row.evt==preevt:
        continue
      self.fill_histos(row, weight, 'initial')

      if not self.obj3_id(row):
        continue

      if self.obj3_iso(row):
        mID = 1
        mIso = 1
        if not self.is_data:
          mID = self.muonMediumID(row.mPt, abs(row.mEta))
          mIso = self.muonLooseIsoMediumID(row.mPt, abs(row.mEta))
        self.fill_histos(row, weight*mID*mIso, 'muonloose')

      if self.obj3_tightiso(row):
        mID = 1
        mIso = 1
        if not self.is_data:
          mID = self.muonMediumID(row.mPt, abs(row.mEta))
          mIso = self.muonTightIsoMediumID(row.mPt, abs(row.mEta))
        self.fill_histos(row, weight*mID*mIso, 'muontight')

      preevt = row.evt


  def finish(self):
    self.write_histos()
