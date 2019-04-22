'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import operator
import mcCorrections
from RecoilCorrector import RecoilCorrector
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])

f = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v17_5.root")
ws = f.Get("w")

fmc = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
wmc = fmc.Get("w")

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)

def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)

def transverseMass(objPt, objEta, objPhi, objMass, MetEt, MetPhi):
  vobj = ROOT.TLorentzVector()
  vmet = ROOT.TLorentzVector()
  vobj.SetPtEtaPhiM(objPt, objEta, objPhi, objMass)
  vmet.SetPtEtaPhiM(MetEt, 0, MetPhi, 0)
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def visibleMass(row):
  vobj1 = ROOT.TLorentzVector()
  vobj2 = ROOT.TLorentzVector()
  vobj1.SetPtEtaPhiM(row['mPt'], row['mEta'], row['mPhi'], row['mMass'])
  vobj2.SetPtEtaPhiM(row['tPt'], row['tEta'], row['tPhi'], row['tMass'])
  return (vobj1 + vobj2).M()

def collMass(row):
  met = row['type1_pfMetEt']
  metPhi = row['type1_pfMetPhi']
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row['tPhi'])))
  visfrac = row['tPt']/(row['tPt']+ptnu)
  m_t_Mass = visibleMass(row)
  return (m_t_Mass/sqrt(visfrac))

def topPtreweight(pt1, pt2):
  if pt1 > 400 : pt1 = 400
  if pt2 > 400 : pt2 = 400
  a = 0.0615
  b = -0.0005
  wt1 = math.exp(a + b * pt1)
  wt2 = math.exp(a + b * pt2)
  wt = sqrt(wt1 * wt2)
  return wt

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

class AnalyzeMuTau(MegaBase):
  tree = 'mt/final/Ntuple'

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
    self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
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
    self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_W)
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
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
    self.DYreweight1D = mcCorrections.DYreweight1D
    self.DYreweight = mcCorrections.DYreweight
    self.muTracking = mcCorrections.muonTracking 
    self.embedTrg = mcCorrections.embedTrg
    self.embedmID = mcCorrections.embedmID
    self.embedmIso = mcCorrections.embedmIso

    self.DYweight = {
      0 : 2.666650438,
      1 : 0.465334904,
      2 : 0.967287905,
      3 : 0.609127575,
      4 : 0.419146762
      }

    self.Wweight = {
      0 : 33.11541041,
      1 : 7.145869534,
      2 : 14.07030624,
      3 : 2.308479086,
      4 : 2.059616837
      }

    self.tauSF={ 
      'vloose' : 0.88,
      'loose'  : 0.89,
      'medium' : 0.89,
      'tight'  : 0.89,
      'vtight' : 0.86,
      'vvtight': 0.84
      }


  def oppositesign(self, row):
    if row['mCharge']*row['tCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['IsoMu27Pass']:
      return False
    return True


  def kinematics(self, row):
    if row['mPt'] < 29 or abs(row['mEta']) >= 2.1:
      return False
    if row['tPt'] < 30 or abs(row['tEta']) >= 2.3:
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20TightMVALTVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return (bool(row['mPFIDTight']) and bool(abs(row['mPVDZ']) < 0.2) and bool(abs(row['mPVDXY']) < 0.045))
 
 
  def obj1_tight(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.15)
  

  def obj1_loose(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.25)

  
  def obj2_id(self, row):
    return (bool(row['tDecayModeFinding'] > 0.5) and bool(row['tAgainstElectronVLooseMVA6'] > 0.5) and bool(row['tAgainstMuonTight3'] > 0.5) and bool(abs(row['tPVDZ']) < 0.2))


  def obj2_tight(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTVTight'] > 0.5)#Tight


  def obj2_loose(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTLoose'] > 0.5)


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30Medium'] < 0.5)


  def dimuonveto(self, row):
    return bool(row['dimuonVeto'] < 0.5)


  def begin(self):
    names=['TauLooseWOS', 'TauLooseOS', 'TauLooseSS', 'MuonLooseWOS', 'MuonLooseOS', 'MuonLooseSS', 'MuonLooseTauLooseWOS', 'MuonLooseTauLooseOS', 'MuonLooseTauLooseSS', 'TightWOS', 'TightOS', 'TightSS', 'TauLooseWOS0Jet', 'TauLooseOS0Jet', 'TauLooseSS0Jet', 'MuonLooseWOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseSS0Jet', 'MuonLooseTauLooseWOS0Jet', 'MuonLooseTauLooseOS0Jet', 'MuonLooseTauLooseSS0Jet', 'TightWOS0Jet', 'TightOS0Jet', 'TightSS0Jet', 'TauLooseWOS1Jet', 'TauLooseOS1Jet', 'TauLooseSS1Jet', 'MuonLooseWOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseSS1Jet', 'MuonLooseTauLooseWOS1Jet', 'MuonLooseTauLooseOS1Jet', 'MuonLooseTauLooseSS1Jet', 'TightWOS1Jet', 'TightOS1Jet', 'TightSS1Jet', 'TauLooseWOS2Jet', 'TauLooseOS2Jet', 'TauLooseSS2Jet', 'MuonLooseWOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseSS2Jet', 'MuonLooseTauLooseWOS2Jet', 'MuonLooseTauLooseOS2Jet', 'MuonLooseTauLooseSS2Jet', 'TightWOS2Jet', 'TightOS2Jet', 'TightSS2Jet'] 
    vbfnames=['TauLooseWOS2JetVBF', 'TauLooseOS2JetVBF', 'TauLooseSS2JetVBF', 'MuonLooseWOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseSS2JetVBF', 'MuonLooseTauLooseWOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'MuonLooseTauLooseSS2JetVBF', 'TightWOS2JetVBF', 'TightOS2JetVBF', 'TightSS2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book(names[x], "mPt", "Muon  Pt", 20, 0, 200)
      self.book(names[x], "tPt", "Tau  Pt", 20, 0, 200)
      self.book(names[x], "mEta", "Muon Eta", 20, -3, 3)
      self.book(names[x], "tEta", "Tau Eta", 20, -3, 3)
      self.book(names[x], "mPhi", "Muon Phi", 20, -4, 4)
      self.book(names[x], "tPhi", "Tau Phi", 20, -4, 4)
      self.book(names[x], "puppiMetEt", "Puppi MET Et", 20, 0, 200)
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
      self.book(names[x], "puppiMetPhi", "Puppi MET Phi", 20, -4, 4)
      self.book(names[x], "type1_pfMetPhi", "Type1 MET Phi", 20, -4, 4)
      self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 30, 0, 300)
      self.book(names[x], "m_t_CollinearMass", "Muon + Tau Collinear Mass", 30, 0, 300)      
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "dEtaMuTau", "Delta Eta Mu Tau", 50, 0, 5)
      self.book(names[x], "dPhiMuMET", "Delta Phi Mu MET", 40, 0, 4)
      self.book(names[x], "dPhiTauMET", "Delta Phi Tau MET", 40, 0, 4)
      self.book(names[x], "dPhiMuTau", "Delta Phi Mu Tau", 40, 0, 4)
      self.book(names[x], "MTMuMET", "Muon MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTTauMET", "Tau MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "vbfMassWoNoisyJets", "VBF Mass", 100, 0, 1000)
    vbfnamesize = len(vbfnames)
    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], "mPt", "Muon  Pt", 10, 0, 200)
      self.book(vbfnames[x], "tPt", "Tau  Pt", 10, 0, 200)
      self.book(vbfnames[x], "mEta", "Muon Eta", 10, -3, 3)
      self.book(vbfnames[x], "tEta", "Tau Eta", 10, -3, 3)
      self.book(vbfnames[x], "mPhi", "Muon Phi", 10, -4, 4)
      self.book(vbfnames[x], "tPhi", "Tau Phi", 10, -4, 4)
      self.book(vbfnames[x], "puppiMetEt", "Puppi MET Et", 10, 0, 200)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
      self.book(vbfnames[x], "puppiMetPhi", "Puppi MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "m_t_Mass", "Muon + Tau Mass", 15, 0, 300)
      self.book(vbfnames[x], "m_t_CollinearMass", "Muon + Tau Collinear Mass", 15, 0, 300)
      self.book(vbfnames[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(vbfnames[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(vbfnames[x], "dEtaMuTau", "Delta Eta Mu Tau", 20, 0, 5)
      self.book(vbfnames[x], "dPhiMuMET", "Delta Phi Mu MET", 10, 0, 4)
      self.book(vbfnames[x], "dPhiTauMET", "Delta Phi Tau MET", 10, 0, 4)
      self.book(vbfnames[x], "dPhiMuTau", "Delta Phi Mu Tau", 10, 0, 4)
      self.book(vbfnames[x], "MTMuMET", "Muon MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "MTTauMET", "Tau MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "vbfMassWoNoisyJets", "VBF Mass", 100, 0, 1000)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(row['mPt'], weight)
    histos[name+'/tPt'].Fill(row['tPt'], weight)
    histos[name+'/mEta'].Fill(row['mEta'], weight)
    histos[name+'/tEta'].Fill(row['tEta'], weight)
    histos[name+'/mPhi'].Fill(row['mPhi'], weight)
    histos[name+'/tPhi'].Fill(row['tPhi'], weight)
    histos[name+'/puppiMetEt'].Fill(row['puppiMetEt'], weight)
    histos[name+'/puppiMetPhi'].Fill(row['puppiMetPhi'], weight)
    histos[name+'/type1_pfMetEt'].Fill(row['type1_pfMetEt'], weight)
    histos[name+'/type1_pfMetPhi'].Fill(row['type1_pfMetPhi'], weight)
    histos[name+'/m_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(row), weight)
    histos[name+'/numOfJets'].Fill(row['jetVeto30WoNoisyJets'], weight)
    histos[name+'/numOfVtx'].Fill(row['nvtx'], weight)
    histos[name+'/dEtaMuTau'].Fill(deltaPhi(row['mEta'], row['tEta']), weight)
    histos[name+'/dPhiMuMET'].Fill(deltaPhi(row['mPhi'], row['type1_pfMetPhi']), weight)
    histos[name+'/dPhiTauMET'].Fill(deltaPhi(row['tPhi'], row['type1_pfMetPhi']), weight)
    histos[name+'/dPhiMuTau'].Fill(deltaPhi(row['mPhi'], row['tPhi']), weight)
    histos[name+'/MTMuMET'].Fill(transverseMass(row['mPt'], row['mEta'], row['mPhi'], row['mMass'], row['type1_pfMetEt'], row['type1_pfMetPhi']), weight)
    histos[name+'/MTTauMET'].Fill(transverseMass(row['tPt'], row['tEta'], row['tPhi'], row['tMass'], row['type1_pfMetEt'], row['type1_pfMetPhi']), weight)
    histos[name+'/vbfMassWoNoisyJets'].Fill(row['vbfMassWoNoisyJets'], weight)

  def tauPtC(self, tPt, tDecayMode, tZTTGenMatching):
    tau_Pt_C = tPt
    if self.is_mc and (not self.is_DY) and (not self.is_DYlow) and tZTTGenMatching==5:
      if tDecayMode == 0:
        tau_Pt_C = 1.007 * tPt
      elif tDecayMode == 1:
        tau_Pt_C = 0.998 * tPt
      elif tDecayMode == 10:
        tau_Pt_C = 1.001 * tPt
      else:
        tau_Pt_C = tPt
    return tau_Pt_C

  def metTauC(self, tPt, tDecayMode, tZTTGenMatching, mymet):
    MET_tPtC = mymet
    if self.is_mc and (not self.is_DY) and (not self.is_DYlow) and tZTTGenMatching==5:
      if tDecayMode == 0:
        MET_tPtC = mymet - 0.007 * tPt
      elif tDecayMode == 1:
        MET_tPtC = mymet + 0.002 * tPt
      elif tDecayMode == 10:
        MET_tPtC = mymet - 0.001 * tPt
      else:
        MET_tPtC = mymet
    return MET_tPtC

  def copyrow(self, row):
    subtemp = {}
    tmpMetEt = row.type1_pfMetEt
    tmpMetPhi = row.type1_pfMetPhi
    subtemp["tPtInitial"] = row.tPt
    subtemp["MetEtInitial"] = tmpMetEt
    if self.is_recoilC and MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])

    subtemp["tPt"] = self.tauPtC(row.tPt, row.tDecayMode, row.tZTTGenMatching)
    subtemp["type1_pfMetEt"] = self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tmpMetEt)
    subtemp["type1_pfMetPhi"] = tmpMetPhi

    if self.is_DY or self.is_DYlow:
      subtemp["isZmumu"] = row.isZmumu
      subtemp["isZee"] = row.isZee

    subtemp["mPt"] = row.mPt
    subtemp["mEta"] = row.mEta
    subtemp["tEta"] = row.tEta
    subtemp["mPhi"] = row.mPhi
    subtemp["tPhi"] = row.tPhi
    subtemp["mMass"] = row.mMass
    subtemp["tMass"] = row.tMass
    subtemp["mCharge"] = row.mCharge
    subtemp["tCharge"] = row.tCharge
    subtemp["puppiMetEt"] = row.puppiMetEt
    subtemp["puppiMetPhi"] = row.puppiMetPhi
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["IsoMu27Pass"] = row.IsoMu27Pass
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20Loose3HitsVtx"] = row.tauVetoPt20Loose3HitsVtx
    subtemp["tauVetoPt20TightMVALTVtx"] = row.tauVetoPt20TightMVALTVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["mPFIDTight"] = row.mPFIDTight
    subtemp["mPVDZ"] = row.mPVDZ
    subtemp["mPVDXY"] = row.mPVDXY
    subtemp["tPVDZ"] = row.tPVDZ
    subtemp["mRelPFIsoDBDefaultR04"] = row.mRelPFIsoDBDefaultR04
    subtemp["tDecayModeFinding"] = row.tDecayModeFinding
    subtemp["tAgainstElectronVLooseMVA6"] = row.tAgainstElectronVLooseMVA6
    subtemp["tAgainstMuonTight3"] = row.tAgainstMuonTight3
    subtemp["tRerunMVArun2v2DBoldDMwLTTight"] = row.tRerunMVArun2v2DBoldDMwLTTight
    subtemp["tRerunMVArun2v2DBoldDMwLTVTight"] = row.tRerunMVArun2v2DBoldDMwLTVTight
    subtemp["tRerunMVArun2v2DBoldDMwLTLoose"] = row.tRerunMVArun2v2DBoldDMwLTLoose
    subtemp["tByCombinedIsolationDeltaBetaCorrRaw3Hits"] = row.tByCombinedIsolationDeltaBetaCorrRaw3Hits
    subtemp["tByIsolationMVArun2v1DBoldDMwLTraw"] = row.tByIsolationMVArun2v1DBoldDMwLTraw
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["jetVeto30WoNoisyJets"] = row.jetVeto30WoNoisyJets
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["tDecayMode"] = row.tDecayMode
    subtemp["tZTTGenMatching"] = row.tZTTGenMatching
    subtemp["dimuonVeto"] = row.dimuonVeto
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["bjetDeepCSVVeto20Medium"] = row.bjetDeepCSVVeto20Medium
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb1eta"] = row.jb1eta
    subtemp["vbfMass"] = row.vbfMass
    subtemp["vbfMassWoNoisyJets"] = row.vbfMassWoNoisyJets
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["topQuarkPt1"] = row.topQuarkPt1
    subtemp["topQuarkPt2"] = row.topQuarkPt2
    subtemp["dimuonVeto"] = row.dimuonVeto
    subtemp["Flag_goodVertices"] = row.Flag_goodVertices
    subtemp["Flag_globalTightHalo2016Filter"] = row.Flag_globalTightHalo2016Filter
    subtemp["Flag_HBHENoiseFilter"] = row.Flag_HBHENoiseFilter
    subtemp["Flag_HBHENoiseIsoFilter"] = row.Flag_HBHENoiseIsoFilter
    subtemp["Flag_EcalDeadCellTriggerPrimitiveFilter"] = row.Flag_EcalDeadCellTriggerPrimitiveFilter
    subtemp["Flag_BadPFMuonFilter"] = row.Flag_BadPFMuonFilter
    subtemp["Flag_BadChargedCandidateFilter"] = row.Flag_BadChargedCandidateFilter
    subtemp["Flag_eeBadScFilter"] = row.Flag_eeBadScFilter
    subtemp["Flag_ecalBadCalibFilter"] = row.Flag_ecalBadCalibFilter
    subtemp["ff"] = 1
    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []

    for row in self.tree:

      nrow = self.copyrow(row)

      if nrow["Flag_goodVertices"]:
        continue

      if nrow["Flag_globalTightHalo2016Filter"]:
        continue

      if nrow["Flag_HBHENoiseFilter"]:
        continue

      if nrow["Flag_HBHENoiseIsoFilter"]:
        continue

      if nrow["Flag_EcalDeadCellTriggerPrimitiveFilter"]:
        continue

      if nrow["Flag_BadPFMuonFilter"]:
        continue

      if nrow["Flag_BadChargedCandidateFilter"]:
        continue

      if self.is_data and nrow["Flag_eeBadScFilter"]:
        continue

      if nrow["Flag_ecalBadCalibFilter"]:
        continue

      if not self.trigger(nrow):
        continue

      if not self.kinematics(nrow):
        continue

      if deltaR(nrow['mPhi'], nrow['tPhi'], nrow['mEta'], nrow['tEta']) < 0.5:
        continue

      if nrow['jetVeto30WoNoisyJets'] > 2:
        continue

      if not self.obj1_id(nrow):
        continue

      if not self.obj2_id(nrow):
        continue

      if not self.vetos(nrow):
        continue      

      if not self.dimuonveto(nrow):
        continue

      if self.is_DY or self.is_DYlow:
        if not bool(nrow['isZmumu'] or nrow['isZee']):
          continue

      nbtag = nrow['bjetDeepCSVVeto20Medium']
      bpt_1 = nrow['jb1pt']
      bflavor_1 = nrow['jb1hadronflavor']
      beta_1 = nrow['jb1eta']
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue

      if count==0:
        temp.append(self.copyrow(row))
        count=count+1
        continue
      else:
        if row.evt==temp[count-1]["evt"]:
          temp.append(self.copyrow(row))
          count=count+1
          continue
        else:
          x = {}
          y = {}
          z = {}
          w = {}
          new_x = {}
          new_y = {}
          new_z = {}
          new_w = {}
          for i in range(count):
            x[i]=temp[i]["mRelPFIsoDBDefaultR04"]
            y[i]=temp[i]["mPt"]
            z[i]=temp[i]["tByIsolationMVArun2v1DBoldDMwLTraw"]
            w[i]=temp[i]["tPt"]
          sorted_x = sorted(x.items(), key=operator.itemgetter(1))
          for i in range(len(sorted_x)):
            if i==0:
              new_y[sorted_x[i][0]] = y[sorted_x[i][0]]
            else:
              if sorted_x[i][1] > sorted_x[i-1][1]:
                break
              else:
                new_y[sorted_x[i][0]] = y[sorted_x[i][0]]

          sorted_y = sorted(new_y.items(), key=operator.itemgetter(1), reverse=True)
          for i in range(len(sorted_y)):
            if i==0:
              new_z[sorted_y[i][0]] = z[sorted_y[i][0]]
            else:
              if sorted_y[i][1] > sorted_y[i-1][1]:
                break
              else:
                new_z[sorted_y[i][0]] = z[sorted_y[i][0]]

          sorted_z = sorted(new_z.items(), key=operator.itemgetter(1))
          for i in range(len(sorted_z)):
            if i==0:
              new_w[sorted_z[i][0]] = w[sorted_z[i][0]]
            else:
              if sorted_z[i][1] > sorted_z[i-1][1]:
                break
              else:
                new_w[sorted_z[i][0]] = w[sorted_z[i][0]]

          sorted_w = sorted(new_w.items(), key=operator.itemgetter(1), reverse=True)
          newrow = temp[sorted_w[0][0]]
          count = 1
          temp = []
          temp.append(self.copyrow(row))


      weight = 1.0
      if not self.is_data and not self.is_embed:
        wmc.var("m_pt").setVal(newrow['mPt'])
        wmc.var("m_eta").setVal(newrow['mEta'])
        #mtracking = self.muTracking(newrow['mEta'])[0]
        #tEff = self.triggerEff(newrow['mPt'], abs(newrow['mEta']))
        #mID = self.muonTightID(newrow['mPt'], abs(newrow['mEta']))
        mIso = wmc.function("m_iso_kit_ratio").getVal()
        mID = wmc.function("m_id_kit_ratio").getVal()
        tEff = wmc.function("m_trg27_kit_data").getVal()/wmc.function("m_trg27_kit_mc").getVal()
        if newrow['tZTTGenMatching']==5:
          tID = 0.89
        else:
          tID = 1.0
        weight = newrow['GenWeight']*pucorrector(newrow['nTruePU'])*tEff*mID*tID*mIso
        if self.is_DY:
          wmc.var("z_gen_mass").setVal(newrow['genMass'])
          wmc.var("z_gen_pt").setVal(newrow['genpT'])
          zptweight = wmc.function("zptmass_weight_nom").getVal()
          dyweight = self.DYreweight(newrow['genMass'], newrow['genpT'])
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*zptweight
          else:
            weight = weight*self.DYweight[0]*zptweight
        if self.is_DYlow:
          wmc.var("z_gen_mass").setVal(newrow['genMass'])
          wmc.var("z_gen_pt").setVal(newrow['genpT'])
          zptweight = wmc.function("zptmass_weight_nom").getVal()
          dyweight = self.DYreweight(newrow['genMass'], newrow['genpT']) 
          weight = weight*22.95746177*zptweight
        if self.is_W:
          if newrow['numGenJets'] < 5:
            weight = weight*self.Wweight[newrow['numGenJets']]
          else:
            weight = weight*self.Wweight[0]
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
          #topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.0057#*topweight
        if self.is_TTToHadronic:
          #topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.379#*topweight
        if self.is_TTToSemiLeptonic:
          #topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.00116#*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.000488
        if newrow['tZTTGenMatching']==2 or newrow['tZTTGenMatching']==4:
          if abs(newrow['tEta']) < 0.4:
            weight = weight*1.17
          elif abs(newrow['tEta']) < 0.8:
            weight = weight*1.29
          elif abs(newrow['tEta']) < 1.2:
            weight = weight*1.14
          elif abs(newrow['tEta']) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif newrow['tZTTGenMatching']==1 or newrow['tZTTGenMatching']==3:
          if abs(newrow['tEta']) < 1.46:
            weight = weight*1.09
          elif abs(newrow['tEta']) > 1.558:
            weight = weight*1.19

      if self.is_embed:
        tID = 0.97
        if newrow['tDecayMode'] == 0:
          dm = 0.975
        elif newrow['tDecayMode'] == 1:
          dm = 0.975*1.051
        elif newrow['tDecayMode'] == 10:
          dm = pow(0.975, 3)
        ws.var("m_pt").setVal(newrow['mPt'])
        ws.var("m_eta").setVal(newrow['mEta'])
        ws.var("gt_pt").setVal(newrow['mPt'])
        ws.var("gt_eta").setVal(newrow['mEta'])
        msel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt_pt").setVal(newrow['tPtInitial'])
        ws.var("gt_eta").setVal(newrow['tEta'])
        tsel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt1_pt").setVal(newrow['mPt'])
        ws.var("gt1_eta").setVal(newrow['mEta'])
        ws.var("gt2_pt").setVal(newrow['tPtInitial'])
        ws.var("gt2_eta").setVal(newrow['tEta'])
        trgsel = ws.function("m_sel_trg_ratio").getVal()
        m_iso_sf = ws.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = ws.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = ws.function("m_trg27_embed_kit_ratio").getVal()
        weight = weight*newrow['GenWeight']*tID*m_trg_sf*m_id_sf*m_iso_sf*dm*msel*tsel*trgsel

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and self.obj1_tight(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        #mIso = 1
        #tIso = 1
        #if not self.is_data and not self.is_embed:
        #  mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60:
            if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 80:
              self.fill_histos(newrow, weight*frTau, 'TauLooseWOS')
              if newrow['jetVeto30WoNoisyJets']==0:
                self.fill_histos(newrow, weight*frTau, 'TauLooseWOS0Jet')
              elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight*frTau, 'TauLooseWOS1Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight*frTau, 'TauLooseWOS2Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight*frTau, 'TauLooseWOS2JetVBF')
          self.fill_histos(newrow, weight*frTau, 'TauLooseOS')
          if newrow['jetVeto30WoNoisyJets']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau, 'TauLooseOS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau, 'TauLooseOS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau, 'TauLooseOS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_histos(newrow, weight*frTau, 'TauLooseOS2JetVBF')
        if not self.oppositesign(newrow):
          self.fill_histos(newrow, weight*frTau, 'TauLooseSS')
          if newrow['jetVeto30WoNoisyJets']==0:
            self.fill_histos(newrow, weight*frTau, 'TauLooseSS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
            self.fill_histos(newrow, weight*frTau, 'TauLooseSS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
            self.fill_histos(newrow, weight*frTau, 'TauLooseSS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
            self.fill_histos(newrow, weight*frTau, 'TauLooseSS2JetVBF')

      if not self.obj1_tight(newrow) and self.obj1_loose(newrow) and self.obj2_tight(newrow):
        frMuon = self.fakeRateMuon(newrow['mPt'])
        #mIso = 1
        #tIso = 1
        #if not self.is_data and not self.is_embed:
        #  mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60:
            if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 80:
              self.fill_histos(newrow, weight*frMuon, 'MuonLooseWOS')
              if newrow['jetVeto30WoNoisyJets']==0:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseWOS0Jet')
              elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseWOS1Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseWOS2Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseWOS2JetVBF')
          self.fill_histos(newrow, weight*frMuon, 'MuonLooseOS')
          if newrow['jetVeto30WoNoisyJets']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frMuon, 'MuonLooseOS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frMuon, 'MuonLooseOS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frMuon, 'MuonLooseOS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_histos(newrow, weight*frMuon, 'MuonLooseOS2JetVBF')
        if not self.oppositesign(newrow):
          self.fill_histos(newrow, weight*frMuon, 'MuonLooseSS')
          if newrow['jetVeto30WoNoisyJets']==0:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseSS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseSS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseSS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight*frMuon, 'MuonLooseSS2JetVBF')

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and not self.obj1_tight(newrow) and self.obj1_loose(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        frMuon = self.fakeRateMuon(newrow['mPt'])
        #mIso = 1
        #tIso = 1
        #if not self.is_data and not self.is_embed:
        #  mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60:
            if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 80:
              self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseWOS')
              if newrow['jetVeto30WoNoisyJets']==0:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseWOS0Jet')
              elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseWOS1Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseWOS2Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseWOS2JetVBF')
          self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseOS')
          if newrow['jetVeto30WoNoisyJets']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseOS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseOS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseOS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseOS2JetVBF')
        if not self.oppositesign(newrow):
          self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseSS')
          if newrow['jetVeto30WoNoisyJets']==0:
            self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseSS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseSS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseSS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight*frTau*frMuon, 'MuonLooseTauLooseSS2JetVBF')

      if self.obj2_tight(newrow) and self.obj1_tight(newrow):
        #mIso = 1
        #tIso = 1
        #if not self.is_data and not self.is_embed:
        #  mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60:
            if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 80:
              self.fill_histos(newrow, weight, 'TightWOS')
              if newrow['jetVeto30WoNoisyJets']==0:
                self.fill_histos(newrow, weight, 'TightWOS0Jet')
              elif newrow['jetVeto30WoNoisyJets']==1:
                self.fill_histos(newrow, weight, 'TightWOS1Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
                self.fill_histos(newrow, weight, 'TightWOS2Jet')
              elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
                self.fill_histos(newrow, weight, 'TightWOS2JetVBF')
          self.fill_histos(newrow, weight, 'TightOS')
          if newrow['jetVeto30WoNoisyJets']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight, 'TightOS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight, 'TightOS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_histos(newrow, weight, 'TightOS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_histos(newrow, weight, 'TightOS2JetVBF')
        if not self.oppositesign(newrow):
          self.fill_histos(newrow, weight, 'TightSS')
          if newrow['jetVeto30WoNoisyJets']==0:
            self.fill_histos(newrow, weight, 'TightSS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
            self.fill_histos(newrow, weight, 'TightSS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
            self.fill_histos(newrow, weight, 'TightSS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
            self.fill_histos(newrow, weight, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
