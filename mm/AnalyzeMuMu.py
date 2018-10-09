'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi


cut_flow_step = ['allEvents', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso', 'passVetoes', 'passAllSelections']


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
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeMuMu(MegaBase):
  tree = 'mm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)

    super(AnalyzeMuMu, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuTree.MuMuTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonIso = mcCorrections.muonIso_tight if not self.is_data else 1.

    self.DYweight = {
      0 : 0.061661087,
      1 : 0.016963692,
      2 : 0.022366645,
      3 : 0.014084886,
      4 : 0.009657510
      }

    self.Wweight = {
      0 : 0.879144536,
      1 : 0.181715142,
      2 : 0.316293013,
      3 : 0.054975434,
      4 : 0.052614600
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

      if self.is_DY:
        if row.numGenJets < 5:
          mcweight = mcweight*self.DYweight[row.numGenJets]
        else:
          mcweight = mcweight*self.DYweight[0]

      if self.is_W:
        if row.numGenJets < 5:
          mcweight = mcweight*self.Wweight[row.numGenJets]
        else:
          mcweight = mcweight*self.Wweight[0]

    weights = {'': mcweight}

    return weights


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def vetos(self,row):
    return (bool (row.eVetoMVAIso < 1) and bool (row.tauVetoPt20Loose3HitsVtx < 1) and bool (row.muGlbIsoVetoPt10 < 1))


  def kinematics(self, row):
    if row.m1Pt < 29 or abs(row.m1Eta) >= 2.4:
      return False
    if row.m2Pt < 29 or abs(row.m2Eta) >= 2.4:
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


  def begin(self):
    names=['initial', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso', 'passVetoes', 'passAllSelections']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "m1Pt", "Muon 1 Pt", 30, 0, 300)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 30, 0, 300)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 10, -5, 5)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 10, -5, 5)
      self.book(names[x], "m1Phi", "Muon 1 Phi", 10, -5, 5)
      self.book(names[x], "m2Phi", "Muon 2 Phi", 10, -5, 5)
      self.book(names[x], "nvtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "m1_m2_Mass", "Visible Mass", 30, 0, 300)

    self.book('', "CUT_FLOW", "Cut Flow", len(cut_flow_step), 0, len(cut_flow_step))
            
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map   = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/m1Pt'].Fill(row.m1Pt, weight)
    histos[name+'/m2Pt'].Fill(row.m2Pt, weight)
    histos[name+'/m1Eta'].Fill(row.m1Eta, weight)
    histos[name+'/m2Eta'].Fill(row.m2Eta, weight)
    histos[name+'/m1Phi'].Fill(row.m1Phi, weight)
    histos[name+'/m2Phi'].Fill(row.m2Phi, weight)
    histos[name+'/nvtx'].Fill(row.nvtx, weight)
    histos[name+'/m1_m2_Mass'].Fill(visibleMass(row), weight)


  def process(self):
    preevt=0
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)

    for row in self.tree:
      try:
        weight_map = self.event_weight(row)
        if weight_map[''] == 0: continue
        weight = weight_map['']
      except AttributeError:
        weight = 1.0

      cut_flow_trk.new_row(row.run, row.lumi, row.evt)
      cut_flow_trk.Fill('allEvents')
      self.fill_histos(row, weight, 'initial')

      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('oppSign')
      self.fill_histos(row, weight, 'oppSign')

      if not self.trigger(row):
        continue
      if not self.is_data:
        tEff = self.triggerEff(row.m1Pt, abs(row.m1Eta))
        weight = weight*tEff
      cut_flow_trk.Fill('passTrigger')
      self.fill_histos(row, weight, 'passTrigger')

      if not self.kinematics(row):
        continue
      cut_flow_trk.Fill('passKinematics')
      self.fill_histos(row, weight, 'passKinematics')

      if not self.obj1_id(row):
        continue
      if not self.is_data:
        m1ID = self.muonID(row.m1Pt, abs(row.m1Eta))
        weight = weight*m1ID
      cut_flow_trk.Fill('passObj1id')
      self.fill_histos(row, weight, 'passObj1id')

      if not self.obj1_iso(row):
        continue
      if not self.is_data:
        m1Iso = self.muonIso(row.m1Pt, abs(row.m1Eta))
        weight = weight*m1Iso
      cut_flow_trk.Fill('passObj1iso')
      self.fill_histos(row, weight, 'passObj1iso')

      if not self.obj2_id(row):
        continue
      if not self.is_data:
        m2ID = self.muonID(row.m2Pt, abs(row.m2Eta))
        weight = weight*m2ID
      cut_flow_trk.Fill('passObj2id')
      self.fill_histos(row, weight, 'passObj2id')

      if not self.obj2_iso(row):
        continue
      if not self.is_data:
        m2Iso = self.muonIso(row.m2Pt, abs(row.m2Eta))
        weight = weight*m2Iso
      cut_flow_trk.Fill('passObj2iso')
      self.fill_histos(row, weight, 'passObj2iso')

      if not self.vetos(row):
        continue      
      cut_flow_trk.Fill('passVetoes')
      self.fill_histos(row, weight, 'passVetoes')

      if row.evt==preevt:
        continue
      cut_flow_trk.Fill('passAllSelections')
      self.fill_histos(row, weight, 'passAllSelections')
      preevt=row.evt


  def finish(self):
    self.write_histos()
