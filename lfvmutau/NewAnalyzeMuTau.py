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
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi

cut_flow_step = ['allEvents', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1iso', 'passObj1id', 'passObj2iso', 'passObj2id', 'passVetoes', 'passbjetVeto']

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


class NewAnalyzeMuTau(MegaBase):
  tree = 'mt/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    target = os.path.basename(os.environ['megatarget'])
    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)

    super(NewAnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


    self.DYweight = {
      0 : 0.123783322,#0.061666112,
      1 : 0.023097619,#0.019443059,
      2 : 0.027516949,#0.022352395,
      3 : 0.058070292,#0.039434916,
      4 : 0.010457258#0.009637152
      }

    self.Wweight = {
      0 : 1.37434619,#1.352888833,
      1 : 1.193586512,#1.177368991,
      2 : 0.363115256,#0.361599983,
      3 : 0.056158658,#0.056122286,
      4 : 0.053636133#0.053602954
      }


  def oppositesign(self,row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  #def event_weight(self, row):

    #mcweight = row.GenWeight
    #mcweight = mcweight*pucorrector(row.nTruePU)

    #if self.is_DY:
    #  if row.numGenJets < 5:
    #    mcweight = mcweight*self.DYweight[row.numGenJets]*0.001
    #  else:
    #    mcweight = mcweight*self.DYweight[0]*0.001

    #if self.is_W:
    #  if row.numGenJets < 5:
    #    mcweight = mcweight*self.Wweight[row.numGenJets]*0.001
    #  else:
    #    mcweight = mcweight*self.Wweight[0]*0.001

    #if self.is_data:
    #   mcweight = 1.

    #weights = {'': mcweight}

    #return weights


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
    return row.mIsGlobal and row.mIsPFMuon and (row.mNormTrkChi2<10) and (row.mMuonHits > 0) and (row.mMatchedStations > 1) and (row.mPVDXY < 0.2) and (row.mPVDZ < 0.5) and (row.mPixHits > 0) and (row.mTkLayersWithMeasurement > 5)
  
 
  def obj1_iso(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  
  
  def obj1_isoloose(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_iso(self, row):
    return row.tByTightIsolationMVArun2v1DBoldDMwLT


  def obj2_mediso(self, row):
    return row.tByMediumIsolationMVArun2v1DBoldDMwLT


  def obj2_id(self, row):
    return row.tAgainstElectronVLooseMVA6 and row.tAgainstMuonTight3 and row.tDecayModeFinding


  def bjetveto(self, row):
    return row.bjetDeepCSVVeto30Loose



  def begin(self):
    names=['passtrigger','pass29cuttrigger','passallselections']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 30, 0, 300)
      self.book(names[x], "tPt", "Tau  Pt", 30, 0, 300)
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
    histos[name+'/m_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(row), weight)


  def process(self):
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)
    for row in self.tree:
      if self.is_data:
        weight = 1.0 
      else:
        weight = row.GenWeight
      #try:
        #weight = row.GenWeight
        #weight_map = self.event_weight(row)
        #if weight_map[''] == 0: continue
        #weight = weight_map['']
      #except AttributeError:
        #weight = 1.0


      cut_flow_trk.new_row(row.run,row.lumi,row.evt)
      cut_flow_trk.Fill('allEvents')
      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('oppSign')
      if not self.trigger(row):
        continue
      cut_flow_trk.Fill('passTrigger')
      self.fill_histos(row, weight, 'passtrigger')

      if row.mPt > 29:
        self.fill_histos(row, weight, 'pass29cuttrigger')

      if not self.kinematics(row):
        continue
      cut_flow_trk.Fill('passKinematics')
      if not self.obj1_iso(row):
        continue
      cut_flow_trk.Fill('passObj1iso')
      if not self.obj1_id(row):
        continue
      cut_flow_trk.Fill('passObj1id')
      if not self.obj2_mediso(row):
        continue
      cut_flow_trk.Fill('passObj2iso')
      if not self.obj2_id(row):
        continue
      cut_flow_trk.Fill('passObj2id')
      if not self.vetos(row):
        continue      
      cut_flow_trk.Fill('passVetoes')
      #if self.bjetveto(row):
      #  continue
      cut_flow_trk.Fill('passbjetVeto')
      self.fill_histos(row, weight, 'passallselections')


  def finish(self):
    self.write_histos()
