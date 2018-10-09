'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi


cut_flow_step = ['allEvents', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso', 'passVetoes', 'passbjetVeto']


def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

  
def visibleMass(row):
  vm = ROOT.TLorentzVector()
  vt = ROOT.TLorentzVector()
  vm.SetPtEtaPhiM(row.mPt,row.mEta,row.mPhi,row.mMass)
  vt.SetPtEtaPhiM(row.tPt,row.tEta,row.tPhi,row.tMass)
  return (vm+vt).M()


def collMass(row):
  met = row.puppiMetEt#type1_pfMetEt
  metPhi = row.puppiMetPhi#type1_pfMetPhi
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row.tPhi)))
  visfrac = row.tPt/(row.tPt+ptnu)
  m_t_Mass = visibleMass(row)
  return (m_t_Mass/sqrt(visfrac))


#pucorrector={'': mcCorrections.make_puCorrector('singlem', None),
#             'puUp': mcCorrections.make_puCorrectorUp('singlem', None),
#             'puDown': mcCorrections.make_puCorrectorDown('singlem', None)
#             }

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


class NewAnalyzeMuTau(MegaBase):
  tree = 'mt/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)

    super(NewAnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonIso = mcCorrections.muonIso_tight if not self.is_data else 1.

    self.DYweight = {
      0 : 0.062905893,#0.061720493,
      1 : 0.019884335,#0.019458555,
      2 : 0.022831095,#0.022374457,
      3 : 0.040462207,#0.039478729,
      4 : 0.008036642#0.009658966
      }

    self.Wweight = {
      0 : 0.879144536,
      1 : 0.801553392,
      2 : 0.316293013,
      3 : 0.056043729,#0.054975434,
      4 : 0.053745319#0.052614600
      }

    self.tauSF={ 
      'vloose' : 0.88,
      'loose'  : 0.89,
      'medium' : 0.89,
      'tight'  : 0.89,
      'vtight' : 0.86,
      'vvtight': 0.84
      }


  def oppositesign(self,row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def event_weight(self, row):

    if self.is_data:
      mcweight = 1.

    else:
      tEff = self.triggerEff(row.mPt, abs(row.mEta))
      mID = self.muonID(row.mPt, abs(row.mEta))
      mIso = self.muonIso(row.mPt, abs(row.mEta))
      mcweight = row.GenWeight*self.tauSF['tight']*tEff*mID*mIso*pucorrector(row.nTruePU)

      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        if abs(row.tEta) < 0.4:
          mcweight = mcweight*1.17
        elif abs(row.tEta) < 0.8:
          mcweight = mcweight*1.29
        elif abs(row.tEta) < 1.2:
          mcweight = mcweight*1.14
        elif abs(row.tEta) < 1.7:
          mcweight = mcweight*0.93
        else:
          mcweight = mcweight*1.61

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if abs(row.tEta) < 1.46:
          mcweight = mcweight*1.80
        elif abs(row.tEta) > 1.558:
          mcweight = mcweight*1.53

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


  def kinematics(self, row):
    if row.mPt < 29 or abs(row.mEta) >= 2.4:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def vetos(self,row):
    return (bool (row.eVetoMVAIso < 1) and bool (row.tauVetoPt20Loose3HitsVtx < 1) and bool (row.muGlbIsoVetoPt10 < 1))


  def obj1_id(self,row):
    return row.mPFIDTight
 
 
  def obj1_iso(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj1_isoloose(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_iso(self, row):
    return row.tRerunMVArun2v2DBoldDMwLTTight


  def obj2_id(self, row):
    return row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding


  def bjetveto(self, row):
    return row.bjetDeepCSVVeto30Loose


  def begin(self):
    names=['initial', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso', 'passVetoes', 'passallselections']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 30, 0, 300)
      self.book(names[x], "tPt", "Tau  Pt", 30, 0, 300)
      self.book(names[x], "mEta", "Muon Eta", 10, -5, 5)
      self.book(names[x], "tEta", "Tau Eta", 10, -5, 5)
      self.book(names[x], "mPhi", "Muon Phi", 10, -5, 5)
      self.book(names[x], "tPhi", "Tau Phi", 10, -5, 5)
      self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 30, 0, 300)
      self.book(names[x], "m_t_CollinearMass", "Muon + Tau Collinear Mass", 30, 0, 300)      

    self.book('', "CUT_FLOW", "Cut Flow", len(cut_flow_step), 0, len(cut_flow_step))
            
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map   = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(row.mPt, weight)
    histos[name+'/tPt'].Fill(row.tPt, weight)
    histos[name+'/mEta'].Fill(row.mEta, weight)
    histos[name+'/tEta'].Fill(row.tEta, weight)
    histos[name+'/mPhi'].Fill(row.mPhi, weight)
    histos[name+'/tPhi'].Fill(row.tPhi, weight)
    histos[name+'/m_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(row), weight)

  def process(self):
    preevt=0
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)
    for row in self.tree:
      if not self.is_data:
        if row.nTruePU < 1:
          continue
      try:
        weight_map = self.event_weight(row)
        if weight_map[''] == 0: continue
        weight = weight_map['']
      except AttributeError:
        weight = 1.0
      cut_flow_trk.new_row(row.run,row.lumi,row.evt)
      cut_flow_trk.Fill('allEvents')
      self.fill_histos(row, weight, 'initial')
      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('oppSign')
      self.fill_histos(row, weight, 'oppSign')
      if not self.trigger(row):
        continue
      cut_flow_trk.Fill('passTrigger')
      self.fill_histos(row, weight, 'passTrigger')
      if not self.kinematics(row):
        continue
      cut_flow_trk.Fill('passKinematics')
      self.fill_histos(row, weight, 'passKinematics')
      if not self.obj1_id(row):
        continue
      cut_flow_trk.Fill('passObj1id')
      self.fill_histos(row, weight, 'passObj1id')
      if not self.obj1_iso(row):
        continue
      cut_flow_trk.Fill('passObj1iso')
      self.fill_histos(row, weight, 'passObj1iso')
      if not self.obj2_id(row):
        continue
      cut_flow_trk.Fill('passObj2id')
      self.fill_histos(row, weight, 'passObj2id')
      if not self.obj2_iso(row):
        continue
      cut_flow_trk.Fill('passObj2iso')
      self.fill_histos(row, weight, 'passObj2iso')
      if not self.vetos(row):
        continue      
      cut_flow_trk.Fill('passVetoes')
      self.fill_histos(row, weight, 'passVetoes')
      if row.evt==preevt:
        continue
      if self.bjetveto(row):
        continue
      cut_flow_trk.Fill('passbjetVeto')
      self.fill_histos(row, weight, 'passallselections')
      preevt=row.evt


  def finish(self):
    self.write_histos()
