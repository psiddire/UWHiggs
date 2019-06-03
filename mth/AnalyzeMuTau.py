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

def transverseMass(vobj, vmet):
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def collMass(myMuon, myMET, myTau):                                                                                                                                                                                                                                            
  ptnu = abs(myMET.Pt() * math.cos(deltaPhi(myMET.Phi(), myTau.Phi())))                                                                                                                                                                                                        
  visfrac = myTau.Pt()/(myTau.Pt() + ptnu)                                                                                                                                                                                                                                     
  m_t_Mass = (myMuon + myTau).M()                                                                                                                                                                                                                                              
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
    if row.mCharge*row.tCharge!=-1:
      return False
    return True


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


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20TightMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
 
 
  def obj1_tight(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  

  def obj1_loose(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.25)

  
  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTVTight > 0.5)#Tight


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Medium < 0.5)


  def dimuonveto(self, row):
    return bool(row.dimuonVeto < 0.5)


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
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
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

    vbfnamesize = len(vbfnames)
    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], "mPt", "Muon  Pt", 10, 0, 200)
      self.book(vbfnames[x], "tPt", "Tau  Pt", 10, 0, 200)
      self.book(vbfnames[x], "mEta", "Muon Eta", 10, -3, 3)
      self.book(vbfnames[x], "tEta", "Tau Eta", 10, -3, 3)
      self.book(vbfnames[x], "mPhi", "Muon Phi", 10, -4, 4)
      self.book(vbfnames[x], "tPhi", "Tau Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
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


  def fill_histos(self, row, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/tPt'].Fill(myMuon.Pt(), weight)
    histos[name+'/mEta'].Fill(myMuon.Eta(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/mPhi'].Fill(myMuon.Phi(), weight)
    histos[name+'/tPhi'].Fill(myTau.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/m_t_Mass'].Fill((myMuon + myTau).M(), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(myMuon, myMET, myTau), weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30WoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/dEtaMuTau'].Fill(deltaEta(myMuon.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiMuMET'].Fill(deltaPhi(myMuon.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiMuTau'].Fill(deltaPhi(myMuon.Phi(), myTau.Phi()), weight)
    histos[name+'/MTMuMET'].Fill(transverseMass(myMuon, myMET), weight)
    histos[name+'/MTTauMET'].Fill(transverseMass(myTau, myMET), weight)


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and (not self.is_DY) and (not self.is_DYlow) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007) 
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py() 
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 
        tmpTau = myTau * ROOT.Double(0.998) 
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    return [tmpMET, tmpTau] 


  def process(self):

    for row in self.tree:

      if row.Flag_goodVertices:
        continue

      if row.Flag_globalTightHalo2016Filter:
        continue

      if row.Flag_HBHENoiseFilter:
        continue

      if row.Flag_HBHENoiseIsoFilter:
        continue

      if row.Flag_EcalDeadCellTriggerPrimitiveFilter:
        continue

      if row.Flag_BadPFMuonFilter:
        continue

      if row.Flag_BadChargedCandidateFilter:
        continue

      if self.is_data and row.Flag_eeBadScFilter:
        continue

      if row.Flag_ecalBadCalibFilter:
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if deltaR(row.mPhi, row.tPhi, row.mEta, row.tEta) < 0.5:
        continue

      if row.jetVeto30WoNoisyJets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue      

      if not self.dimuonveto(row):
        continue

      if self.is_DY or self.is_DYlow:
        if not bool(row.isZmumu or row.isZee):
          continue

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue

      weight = 1.0
      if not self.is_data and not self.is_embed:
        #wmc.var("m_pt").setVal(row.mPt)
        #wmc.var("m_eta").setVal(row.mEta)
        mTrk = self.muTracking(row.mEta)[0]
        tEff = self.triggerEff(row.mPt, abs(row.mEta))
        mID = self.muonTightID(row.mPt, abs(row.mEta))
        #mIso = wmc.function("m_iso_kit_ratio").getVal()
        #mID = wmc.function("m_id_kit_ratio").getVal()
        #tEff = wmc.function("m_trg27_kit_data").getVal()/wmc.function("m_trg27_kit_mc").getVal()
        if row.tZTTGenMatching==5:
          tID = 0.86
        else:
          tID = 1.0
        weight = row.GenWeight*pucorrector(row.nTruePU)*tEff*mID*tID*mTrk
        if self.is_DY:
          wmc.var("z_gen_mass").setVal(row.genMass)
          wmc.var("z_gen_pt").setVal(row.genpT)
          zptweight = wmc.function("zptmass_weight_nom").getVal()
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*zptweight
          else:
            weight = weight*self.DYweight[0]*zptweight
        if self.is_DYlow:
          weight = weight*22.95746177
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
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
        if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6:
            continue
        if self.is_TTTo2L2Nu:
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          weight = weight*0.00116*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.000488
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(row.tEta) < 0.4:
            weight = weight*1.17
          elif abs(row.tEta) < 0.8:
            weight = weight*1.29
          elif abs(row.tEta) < 1.2:
            weight = weight*1.14
          elif abs(row.tEta) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(row.tEta) < 1.46:
            weight = weight*1.09
          elif abs(row.tEta) > 1.558:
            weight = weight*1.19

      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        ws.var("m_pt").setVal(row.mPt)
        ws.var("m_eta").setVal(row.mEta)
        ws.var("gt_pt").setVal(row.mPt)
        ws.var("gt_eta").setVal(row.mEta)
        msel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt_pt").setVal(row.tPt)
        ws.var("gt_eta").setVal(row.tEta)
        tsel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt1_pt").setVal(row.mPt)
        ws.var("gt1_eta").setVal(row.mEta)
        ws.var("gt2_pt").setVal(row.tPt)
        ws.var("gt2_eta").setVal(row.tEta)
        trgsel = ws.function("m_sel_trg_ratio").getVal()
        m_iso_sf = ws.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = ws.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = ws.function("m_trg27_embed_kit_ratio").getVal()
        weight = weight*row.GenWeight*tID*m_trg_sf*m_id_sf*m_iso_sf*dm*msel*tsel*trgsel

      njets = row.jetVeto30WoNoisyJets
      mjj = row.vbfMassWoNoisyJets

      myMuon = ROOT.TLorentzVector()                                                                                                                                                                                                                                  
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)                                                                                                                                                                                                          

      myTau = ROOT.TLorentzVector()                                                                                                                                                                                                                                       
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()                                                                                                                                                                                                                                       
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0] 
      myTau = self.tauPtC(row, myMET, myTau)[1]

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        mIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(row.mPt, abs(row.mEta))
        weight = weight*frTau*mIso
        if self.oppositesign(row):
          if transverseMass(myMuon, myMET) > 60:
            if transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS')
          if njets==0 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS0Jet')
          elif njets==1 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS1Jet')
          elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2Jet')
          elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TauLooseSS2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frMuon = self.fakeRateMuon(row.mPt)
        mIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(row.mPt, abs(row.mEta))
        weight = weight*frMuon*mIso
        if self.oppositesign(row):
          if transverseMass(myMuon, myMET) > 60:
            if transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS')
          if njets==0 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet')
          elif njets==1 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet')
          elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet')
          elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS')
          if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS0Jet')
          elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS1Jet')
          elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS2Jet')
          elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseSS2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frMuon = self.fakeRateMuon(row.mPt)
        mIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(row.mPt, abs(row.mEta))
        weight = weight*mIso*frMuon*frTau
        if self.oppositesign(row):
          if transverseMass(myMuon, myMET) > 60:
            if transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS')
          if njets==0 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet')
          elif njets==1 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet')
          elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet')
          elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS0Jet')
          elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS1Jet')
          elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS2Jet')
          elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'MuonLooseTauLooseSS2JetVBF')

      if self.obj2_tight(row) and self.obj1_tight(row):
        mIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(row.mPt, abs(row.mEta))
        weight = weight*mIso
        if self.oppositesign(row):
          if transverseMass(myMuon, myMET) > 60:
            if transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS')
              if njets==0:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS1Jet')
              elif njets==2 and mjj < 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS2Jet')
              elif njets==2 and mjj > 550:
                self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightWOS2JetVBF')
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS')
          if njets==0 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS0Jet')
          elif njets==1 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS1Jet')
          elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2Jet')
          elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS')
          if njets==0:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS0Jet')
          elif njets==1:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS1Jet')
          elif njets==2 and mjj < 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS2Jet')
          elif njets==2 and mjj > 550:
            self.fill_histos(row, myMuon, myMET, myTau, weight, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
