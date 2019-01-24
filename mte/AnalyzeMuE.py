'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuETree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import mcCorrections
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi


cut_flow_step = ['allEvents', 'oppSign', 'passTrigger', 'passKinematics', 'passObj1id', 'passObj1iso', 'passObj2id', 'passObj2iso', 'passVetoes', 'passDR', 'passbjetVeto']


def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

  
def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)


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

target = os.path.basename(os.environ['megatarget'])

if bool('DYJetsToLL_M-50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY10')
elif bool('DYJetsToLL_M-50_TuneCP5_13TeV-amcatnloFXFX' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DYAMC')
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
elif bool('EWKWMinus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wminus')
elif bool('EWKWPlus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wplus')
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Zll')
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Znunu')
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

class AnalyzeMuE(MegaBase):
  tree = 'me/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_embed = target.startswith('embedded_')
    self.is_mc = not self.is_data and not self.is_embed
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_GluGlu = bool('GluGlu_LFV' in target)
    self.is_VBF = bool('VBF_LFV' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.is_EWKWMinus = bool('EWKWMinus' in target)
    self.is_EWKWPlus = bool('EWKWPlus' in target)
    self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
    self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
    self.is_ZHTT = bool('ZHToTauTau' in target)
    self.is_ttH = bool('ttHToTauTau' in target)
    self.is_Wminus = bool('Wminus' in target)
    self.is_Wplus = bool('Wplus' in target)
    self.is_STtantitop = bool('ST_t-channel_antitop' in target)
    self.is_STttop = bool('ST_t-channel_top' in target)
    self.is_STtWantitop = bool('ST_tW_antitop' in target)
    self.is_STtWtop = bool('ST_tW_top' in target)
    self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
    self.is_TTToHadronic = bool('TTToHadronic' in target)
    self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
    self.is_VBFH = bool('VBFHToTauTau' in target)
    self.is_GluGluH = bool('GluGluHToTauTau' in target)
    self.is_recoilC = bool(('HTo' in target) or ('Jets' in target))
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")

    super(AnalyzeMuE, self).__init__(tree, outfile, **kwargs)
    self.tree = MuETree.MuETree(tree)
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
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.DYreweight = mcCorrections.DYreweight
    self.muTracking = mcCorrections.muonTracking

    self.DYweight = {
      0 : 2.666650438,
      1 : 0.465334904,
      2 : 0.967287905,
      3 : 0.609127575,
      4 : 0.419146762
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
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 29 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def vetos(self,row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20Loose3HitsVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self,row):
    return row.mPFIDTight
  

  def obj1_iso(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
    

  def obj1_isoloose(self,row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)


  def obj2_iso(self, row):
    return bool(row.eRelPFIsoDB < 0.15)


  def obj2_id(self, row):
    return (row.eMVANoisoWP90 > 0) and (row.ePVDXY < 0.02) and (row.ePVDZ < 0.5)


  def bjetveto(self, row):
    return row.bjetDeepCSVVeto30Loose


  def begin(self):
    names=['passallselections']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 30, 0, 300)
      self.book(names[x], "ePt", "Electron Pt", 30, 0, 300)
      self.book(names[x], "mEta", "Muon Eta", 10, -5, 5)
      self.book(names[x], "eEta", "Electron Eta", 10, -5, 5)
      self.book(names[x], "mPhi", "Muon Phi", 10, -5, 5)
      self.book(names[x], "ePhi", "Electron Phi", 10, -5, 5)
      self.book(names[x], "m_e_Mass", "Muon + Electron Mass", 30, 0, 300)
      self.book(names[x], "m_e_CollinearMass", "Muon + Electron Collinear Mass", 30, 0, 300)      

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
    histos[name+'/ePt'].Fill(row.ePt, weight)
    histos[name+'/mEta'].Fill(row.mEta, weight)
    histos[name+'/eEta'].Fill(row.eEta, weight)
    histos[name+'/mPhi'].Fill(row.mPhi, weight)
    histos[name+'/ePhi'].Fill(row.ePhi, weight)
    histos[name+'/m_e_Mass'].Fill(row.m_e_Mass, weight)
    histos[name+'/m_e_CollinearMass'].Fill(row.m_e_CollinearMass, weight)

  def process(self):
    preevt=0
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)
    for row in self.tree:
      weight = 1.0
      if not self.is_data and not self.is_embed:
        mtracking = self.muTracking(row.mEta)[0]
        tEff = self.triggerEff(row.mPt, row.mEta))
        mID = self.muonTightID(row.mPt, abs(row.mEta))
        weight = weight*row.GenWeight*pucorrector(row.nTruePU)*tEff*mID*mtracking*tID
        if self.is_DY:
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          dyweight = self.DYreweight(row.genMass, row.genpT)
          weight = weight*26.747*dyweight
        if self.is_GluGlu:
          weight = weight*0.0005
        if self.is_VBF:
          weight = weight*0.000214
        if self.is_WW:
          weight = weight*0.407
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261
        if self.is_EWKWMinus:
          weight = weight*0.191
        if self.is_EWKWPlus:
          weight = weight*0.246
        if self.is_EWKZToLL:
          weight = weight*0.175
        if self.is_EWKZToNuNu:
          weight = weight*0.142
        if self.is_ZHTT:
          weight = weight*0.000598
        if self.is_ttH:
          weight = weight*0.000116
        if self.is_Wminus:
          weight = weight*0.000670
        if self.is_Wplus:
          weight = weight*0.000636
        if self.is_STtantitop:
          weight = weight*0.922
        if self.is_STttop:
          weight = weight*0.952
        if self.is_STtWantitop:
          weight = weight*0.00538
        if self.is_STtWtop:
          weight = weight*0.00552
        if self.is_TTTo2L2Nu:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.00116*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.000488


      cut_flow_trk.new_row(row.run,row.lumi,row.evt)
      cut_flow_trk.Fill('allEvents')

      if not self.oppositesign(row):
        continue
      cut_flow_trk.Fill('oppSign')

      if not self.trigger(row):
        continue
      cut_flow_trk.Fill('passTrigger')

      if not self.kinematics(row):
        continue
      cut_flow_trk.Fill('passKinematics')

      if not self.obj1_id(row):
        continue
      cut_flow_trk.Fill('passObj1id')

      if not self.obj1_iso(row):
        continue
      cut_flow_trk.Fill('passObj1iso')

      if not self.obj2_id(row):
        continue
      cut_flow_trk.Fill('passObj2id')

      if not self.obj2_iso(row):
        continue
      cut_flow_trk.Fill('passObj2iso')

      if not self.vetos(row):
        continue      
      cut_flow_trk.Fill('passVetoes')
      
      if deltaR(row.mPhi, row.ePhi, row.mEta, row.eEta) < 0.3:
        continue
      cut_flow_trk.Fill('passDR')

      if row.evt==preevt:
        continue
      if self.bjetveto(row):
        continue
      cut_flow_trk.Fill('passbjetVeto')

      self.fill_histos(row, weight, 'passallselections')
      preevt=row.evt


  def finish(self):
    self.write_histos()
