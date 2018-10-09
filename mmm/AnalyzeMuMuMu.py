import MuMuMuTree
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
  vm1 = ROOT.TLorentzVector()
  vm2 = ROOT.TLorentzVector()
  vm1.SetPtEtaPhiM(row.m1Pt,row.m1Eta,row.m1Phi,row.m1Mass)
  vm2.SetPtEtaPhiM(row.m2Pt,row.m2Eta,row.m2Phi,row.m2Mass)
  return (vm1+vm2).M()


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


class AnalyzeMuMuMu(MegaBase):
  tree = 'mmm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)

    super(AnalyzeMuMuMu, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuMuTree.MuMuMuTree(tree)
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
    if row.m1Charge*row.m2Charge!=-1:
      return False
    return True


  def event_weight(self, row):
    if self.is_data:
      mcweight = 1.
    else:
      mcweight = row.GenWeight*pucorrector(row.nTruePU)
      #if self.is_DY:
      #  if row.numGenJets < 5:
      #    mcweight = mcweight*self.DYweight[row.numGenJets]
      #  else:
      #    mcweight = mcweight*self.DYweight[0]
      if self.is_W:
        if row.numGenJets < 5:
          mcweight = mcweight*self.Wweight[row.numGenJets]
        else:
          mcweight = mcweight*self.Wweight[0]
      elif self.is_WW:
        mcweight = mcweight*0.637#0.407
      elif self.is_WZ:
        mcweight = mcweight*0.502#0.294
      elif self.is_ZZ:
        mcweight = mcweight*0.354#0.261
    weights = {'': mcweight}
    return weights


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.m1Pt < 29 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 10 or abs(row.m2Eta) >= 2.4:
      return False
    if row.m3Pt < 10 or abs(row.m3Eta) >= 2.4:
      return False
    return True


  def obj1_id(self,row):
    return bool(row.m1PFIDTight)
 
 
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj2_id(self, row):
    return bool(row.m2PFIDTight)


  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.15)


  def obj3_id(self, row):
    return bool(row.m3PFIDMedium)


  def obj3_iso(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.25)


  def obj3_tightiso(self, row):
    return bool(row.m3RelPFIsoDBDefaultR04 < 0.15)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20Loose3HitsVtx < 0.5))


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Loose < 0.5)


  def begin(self):
    names=['initial', 'muonloose', 'muontight']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "m3Pt", "Muon 3 Pt", 20, 0, 200)
      self.book(names[x], "m3Eta", "Muon 3 Eta", 20, -3.0, 3.0)
      self.book(names[x], "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(names[x], "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 20, -3.0, 3.0)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 20, -3.0, 3.0)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/m3Pt'].Fill(row.m3Pt, weight)
    histos[name+'/m3Eta'].Fill(row.m3Eta, weight)
    histos[name+'/m1_m2_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
    histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
    histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
    histos[name+'/m2Eta'].Fill(row.m2Eta, weight)

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
      if not self.is_data:
        tEff = self.triggerEff(row.m1Pt, abs(row.m1Eta))
        m1ID = self.muonTightID(row.m1Pt, abs(row.m1Eta))
        m1Iso = self.muonTightIsoTightID(row.m1Pt, abs(row.m1Eta))
        m2ID = self.muonTightID(row.m2Pt, abs(row.m2Eta))
        m2Iso = self.muonTightIsoTightID(row.m2Pt, abs(row.m2Eta))
        weight = weight*m2ID*m2Iso*m1ID*m1Iso*tEff

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

      if not self.obj3_iso(row):
        continue
      m3ID = 1
      m3Iso = 1
      if not self.is_data:
        m3ID = self.muonMediumID(row.m3Pt, abs(row.m3Eta))
        m3Iso = self.muonLooseIsoMediumID(row.m3Pt, abs(row.m3Eta))
      self.fill_histos(row, weight*m3ID*m3Iso, 'muonloose')

      if not self.obj3_tightiso(row):
        continue
      m3ID = 1
      m3Iso = 1
      if not self.is_data:
        m3ID = self.muonMediumID(row.m3Pt, abs(row.m3Eta))
        m3Iso = self.muonTightIsoMediumID(row.m3Pt, abs(row.m3Eta))
      self.fill_histos(row, weight*m3ID*m3Iso, 'muontight')

      preevt=row.evt


  def finish(self):
    self.write_histos()
