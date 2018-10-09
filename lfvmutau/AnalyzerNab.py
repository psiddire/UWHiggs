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
  met = row.type1_pfMetEt
  metPhi = row.type1_pfMetPhi
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row.tPhi)))
  visfrac = row.tPt/(row.tPt+ptnu)
  m_t_Mass = visibleMass(row)
  return (m_t_Mass/sqrt(visfrac))


class NewNewAnalyzeMuTau(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    target = os.path.basename(os.environ['megatarget'])
    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.isDY = bool('JetsToLL' in target)
    self.isW = bool('JetsToLNu' in target)
    self.isST_tW_antitop = bool('ST_tW_antitop' in target)
    self.isST_tW_top = bool('ST_tW_top' in target)
    self.isST_t_antitop = bool('ST_t-channel_antitop' in target)
    self.isST_t_top = bool('ST_t-channel_top' in target)
    self.isTTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
    self.isTTTo2L2Nu = bool('TTTo2L2Nu' in target)
    self.isTTToHadronic = bool('TTToHadronic' in target)
    self.isWW = bool('WW' in target)
    self.isWZ = bool('WZ' in target)
    self.isZZ = bool('ZZ' in target)
    self.isGluGluHToTauTau = bool('GluGluHToTauTau' in target)
    self.isVBFHToTauTau = bool('VBFHToTauTau' in target)
    self.isZH = bool('ZHToTauTau' in target)
    self.isttH = bool('ttHToTauTau' in target)
    self.isWminusH = bool('WminusHToTauTau' in target)
    self.isWplusH = bool('WplusHToTauTau' in target)
    self.isGluGluHToMuTau = bool('GluGlu_LFV' in target)
    self.isVBFHToMuTau = bool('VBF_LFV' in target)

    if self.isDY:
      self.binned_weight = [0.061666112,0.019443059,0.022352395,0.039434916,0.009637152]
    if self.isW:
      self.binned_weight = [1.352888833,1.177368991,0.361599983,0.056122286,0.053602954]
    self.ST_tW_antitop_weight = 1.28507391898e-07
    self.ST_tW_top_weight = 1.3190925248e-07
    self.ST_t_antitop_weight = 1.72360843555e-05
    self.ST_t_top_weight = 1.93151064419e-05
    self.TTToSemiLeptonic_weight = 2.95154911287e-08
    self.TTTo2L2Nu_weight = 1.4069997141e-07
    self.TTToHadronic_weight = 8.92300155078e-06
    self.WW_weight = 9.72855284053e-06
    self.WZ_weight = 7.02534980386e-06
    self.ZZ_weight = 6.22638180543e-06
    self.GluGluHToTauTau_weight = 3.08114205087e-08
    self.ZH_weight = 1.21686680171e-08
    self.WplusH_weight = 1.53912032136e-08
    self.WminusH_weight = 1.60140481293e-08
    self.VBFHToTauTau_weight = 2.10828233714e-08
    self.ttH_weight = 1.73111987381e-09
    self.GluGluHToMuTau_weight = 7.50537124648e-09
    self.VBFHToMuTau_weight = 5.22979751974e-09


    super(NewNewAnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self,row):
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


  def event_weight(self, row):
    return row.GenWeight


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 29 or abs(row.mEta) >= 2.1:
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


  def gg(self,row):
    if row.mPt < 25: #was45
      return False                                                                                                               
    if deltaPhi(row.mPhi, row.tPhi) < 2.7:
      return False                                                                                                               
    if row.tPt < 30: #was35
      return False                                                                                                               
    if row.tMtToPfMet_type1 > 105: #was50 #newcuts65                                                                           
      return False                                                                                                               
    if self.ls_recoilC and MetCorrection:
      if self.tMtToPfMet_type1MetC > 105:
        return False
    else:                                                                                                                          
      if row.tMtToPfMet_type1 > 105:
        return False                                                                                                             
    if self.Sysin:                                                                                                                
      if self.tMtToPfMet_type1_new > 105:
        return False
    else:                                                                                                                          
      if row.tMtToPfMet_type1 > 105:
        return False                                                                                                             
    if abs(row.tDPhiToPfMet_type1) > 3.0:                                                                                        
      return False                                                                                                            
    if self.ls_recoilC and MetCorrection:                                                                                          
      if abs(self.TauDphiToMet) > 3.0:                                                                                              
        return False                                                                                                             
    else:                                                                                                                          
      if abs(row.tDPhiToPfMet_type1) > 3.0:                                                                                         
        return False
    if row.jetVeto30!=0:                                                                                                           
      return False                                                                                                               
    if row.bjetCISVVeto30Loose:                                                                                                    
      return False                                                                                                              
    return True


  def boost(self,row):
    if row.jetVeto30!=1:                                                                                                        
      return False                                                                                                              
    if row.mPt < 25: #was 35
      return False                                                                                                          
    if row.tPt < 30: #was 40
      return False                                                                                                          
    if row.tMtToPfMet_type1 > 105: #was 35 #newcuts 75                                                                        
      return False                                                                                                          
    if self.ls_recoilC and MetCorrection:
      if self.tMtToPfMet_type1MetC > 105: #was 50 #newcuts65                                                                 
        return False
    else:                                                                                                                       
      if row.tMtToPfMet_type1 > 105:
        return False
    if abs(row.tDPhiToPfMet_type1) > 3.0:                                                                                     
      return False                                                                                                         
    if  self.Sysin:                                                                                                             
      if self.tMtToPfMet_type1_new > 105:
        return False
    else:                                                                                                                       
      if row.tMtToPfMet_type1 > 105:
        return False
    if self.ls_recoilC and MetCorrection:                                                                                       
      if abs(self.TauDphiToMet) > 3.0:                                                                                           
        return False                                                                                                          
    else:                                                                                                                       
      if abs(row.tDPhiToPfMet_type1) > 3.0:                                                                                      
        return False                                                                                                          
    if row.bjetCISVVeto30Loose:                                                                                                 
      return False                                                                                                          
    return True


  def vbf(self,row):
    if row.tPt < 30:   #was 40   #newcuts 30                                                                                      
      return False                                                                                                          
    if row.mPt < 25:   #was 40    #newcut 25                                                                                      
      return False
    if  self.Sysin:                                                                                                               
      if self.tMtToPfMet_type1_new > 85:  #was 50   #newcuts65
        return False
    else:                                                                                                                         
      if row.tMtToPfMet_type1> 85:  #was 50   #newcuts65                                                                         
        return False                                                                                                            
    if row.jetVeto30<2:                                                                                                           
      return False                                                                                                              
    if(row.vbfNJets30<2):                                                                                                          
      return False                                                                                                               
    if(abs(row.vbfDeta)<3.5):   #was 2.5    #newcut 2.0                                                                            
      return False
    if row.vbfMass < 550:    #was 200   newcut 325                                                                                 
      return False
    if row.vbfJetVeto30 > 0:                                                                                                      
      return False                                                                                                              
    if row.bjetCISVVeto30Medium:                                                                                                  
      return False                                                                                                              
    return True


  def vbf_gg(self,row):
    if row.tPt < 30:   #was 40
      return False                                                                                                          
    if row.mPt < 25:   #was 40
      return False                                                                                                   
    if row.tMtToPfMet_type1 > 105: #was 35 #newcuts 55                                                                          
      return False                                                                                                          
    if self.ls_recoilC and MetCorrection:
      if self.tMtToPfMet_type1MetC > 105:
        return False
    else:                                                                                                                         
      if row.tMtToPfMet_type1 > 105:
        return False                                                                                                           
    if  self.Sysin:                                                                                                               
      if self.tMtToPfMet_type1_new > 105:
        return False
    else:                                                                                                                         
      if row.tMtToPfMet_type1> 105:
        return False                                                                                                            
    if row.jetVeto30<2:                                                                                                           
      return False                                                                                                              
    if(row.vbfNJets30<2):                                                                                                          
      return False                                                                                                               
    if (abs(row.vbfDeta)>3.5 and row.vbfMass > 550): #was 2.5 #newcut 2.0                                                    
      if not self.DoJES:
        if (row.vbfMass >= 550):
          return False
    if row.vbfMass > 550: #was 20 newcut 240                                                                                 
      return False                                                                                                               
    if row.vbfMass < 100:
      return False                                                                                                               
    if row.vbfJetVeto30 > 0:                                                                                                      
      return False                                                                                                              
    if row.bjetCISVVeto30Medium:                                                                                                  
      return False                                                                                                              
    return True


  def vbf_vbf(self,row):
    if row.tPt < 30: #was 40
      return False                                                                                                          
    if row.mPt < 25: #was 40
      return False                                                                                                   
    if row.tMtToPfMet_type1 > 85: #was 35 #newcuts 55                                                                           
      return False                                                                                                          
    if self.tMtToPfMet_type1MetC > 85:
      return False                                                                                                          
    if self.ls_recoilC and MetCorrection:
      if self.tMtToPfMet_type1MetC > 105: #was 50 #newcuts65                                                                  
        return False
    else:                                                                                                                         
      if row.tMtToPfMet_type1 > 105:
        return False                                                                                                           
    if  self.Sysin:                                                                                                               
      if self.tMtToPfMet_type1_new > 85: #was 50 #newcuts65                                                                       
        return False
    else:                                                                                                                         
      if row.tMtToPfMet_type1> 85:
        return False                                                                                                            
    if row.jetVeto30<2:                                                                                                           
      return False                                                                                                              
    if(row.vbfNJets30<2):                                                                                                          
      return False                                                                                                               
    if(abs(row.vbfDeta)<3.5 or (row.vbfMass < 550)): #was 2.5 #newcut 2.0                                                    
      if not self.DoJES:
        if((row.vbfMass < 550)):
          return False
    if row.vbfMass > 240: #was 200 newcut 325                                                                                
      return False                                                                                                               
    if row.vbfJetVeto30 > 0:                                                                                                      
      return False                                                                                                              
    if  row.bjetCISVVeto30Medium:                                                                                                 
      return False                                                                                                              
    return True


  def begin(self):
    names=['passtrigger','pass29cuttrigger','passallselections']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 100, 0, 300)
      self.book(names[x], "tPt", "Tau  Pt", 100, 0, 300)
      self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 100, 0, 300)
      self.book(names[x], "m_t_CollinearMass", "Muon + Tau Collinear Mass", 100, 0, 300)      

    self.book('', "CUT_FLOW", "Cut Flow", len(cut_flow_step), 0, len(cut_flow_step))
            
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map   = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def fill_histos(self, row, name=''):
    if self.isW or self.isDY:
      weight = self.event_weight(row)*self.binned_weight[int(row.numGenJets)]*0.001
    elif self.isST_tW_top:
      weight = self.ST_tW_top_weight*self.event_weight(row) 
    elif self.isST_tW_antitop:
      weight = self.ST_tW_antitop_weight*self.event_weight(row) 
    elif self.isST_t_top:
      weight = self.ST_t_top_weight*self.event_weight(row) 
    elif self.isST_t_antitop:
      weight = self.ST_t_antitop_weight*self.event_weight(row)   
    elif self.isWW:
      weight = self.WW_weight*self.event_weight(row) 
    elif self.isWZ:
      weight = self.WZ_weight*self.event_weight(row) 
    elif self.isZZ:
      weight = self.ZZ_weight*self.event_weight(row) 
    elif self.isTTToSemiLeptonic:
      weight = self.TTToSemiLeptonic_weight*self.event_weight(row) 
    elif self.isTTTo2L2Nu:
      weight = self.TTTo2L2Nu_weight*self.event_weight(row)
    elif self.isTTToHadronic:
      weight = self.TTToHadronic_weight*self.event_weight(row)
    elif self.isGluGluHToMuTau:
      weight = self.GluGluHToMuTau_weight*self.event_weight(row)
    elif self.isVBFHToMuTau:
      weight = self.VBFHToMuTau_weight*self.event_weight(row)
    elif self.isGluGluHToTauTau:
      weight = self.GluGluHToTauTau_weight*self.event_weight(row)
    elif self.isVBFHToTauTau:
      weight = self.VBFHToTauTau_weight*self.event_weight(row)
    elif self.isWminusH:
      weight = self.WminusH_weight*self.event_weight(row)
    elif self.isWplusH:
      weight = self.WplusH_weight*self.event_weight(row)
    elif self.isttH:
      weight = self.ttH_weight*self.event_weight(row)
    elif self.isZH:
      weight = self.ZH_weight*self.event_weight(row)
    else:
      weight = self.event_weight(row)

    histos = self.histograms
    histos[name+'/mPt'].Fill(row.mPt, weight)
    histos[name+'/tPt'].Fill(row.tPt, weight)
    histos[name+'/m_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(row), weight)


  def process(self):
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)
    for row in self.tree:

      cut_flow_trk.new_row(row.run,row.lumi,row.evt)
      cut_flow_trk.Fill('allEvents')
      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('oppSign')
      if not self.trigger(row):
        continue
      cut_flow_trk.Fill('passTrigger')
      self.fill_histos(row, 'passtrigger')

      if row.mPt > 29:
        self.fill_histos(row, 'pass29cuttrigger')

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
      if self.bjetveto(row):
        continue
      cut_flow_trk.Fill('passbjetVeto')
      self.fill_histos(row, 'passallselections')


  def finish(self):
    self.write_histos()
