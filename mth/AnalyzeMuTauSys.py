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
import itertools
import operator
import mcCorrections
from RecoilCorrector import RecoilCorrector
from MEtSys import MEtSys
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote
import random

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = False
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
  ptnu = abs(myMET.Et()*math.cos(deltaPhi(myMET.Phi(), myTau.Phi())))
  visfrac = myTau.Pt()/(myTau.Pt()+ptnu)
  m_t_Mass = (myMuon+myTau).M()
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
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY')}
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY10'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY10'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY10')}
elif bool('DYJetsToLL_M-50_TuneCP5_13TeV-amcatnloFXFX' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DYAMC'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DYAMC'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DYAMC')}
elif bool('DY1JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY1'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY1'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY1')}
elif bool('DY2JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY2')}
elif bool('DY3JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY3'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY3'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY3')}
elif bool('DY4JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY4'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY4'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY4')}
elif bool('WW_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'WW'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'WW'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'WW')}
elif bool('WZ_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'WZ'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'WZ'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'WZ')}
elif bool('ZZ_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'ZZ'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'ZZ'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'ZZ')}
elif bool('EWKWMinus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Wminus'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Wminus'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Wminus')}
elif bool('EWKWPlus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Wplus'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Wplus'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Wplus')}
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Zll'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Zll'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Zll')}
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Znunu'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Znunu'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Znunu')}
elif bool('ZHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'ZHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'ZHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'ZHTT')}
elif bool('ttHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'ttH'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'ttH'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'ttH')}
elif bool('Wminus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'WminusHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'WminusHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'WminusHTT')}
elif bool('Wplus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'WplusHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'WplusHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'WplusHTT')}
elif bool('ST_t-channel_antitop' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'STtantitop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'STtantitop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'STtantitop')}
elif bool('ST_t-channel_top' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'STttop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'STttop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'STttop')}
elif bool('ST_tW_antitop' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'STtWantitop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'STtWantitop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'STtWantitop')}
elif bool('ST_tW_top' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'STtWtop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'STtWtop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'STtWtop')}
elif bool('TTTo2L2Nu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'TTTo2L2Nu'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'TTTo2L2Nu'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'TTTo2L2Nu')}
elif bool('TTToHadronic' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'TTToHadronic'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'TTToHadronic'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'TTToHadronic')}
elif bool('TTToSemiLeptonic' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'TTToSemiLeptonic'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'TTToSemiLeptonic'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'TTToSemiLeptonic')}
elif bool('VBFHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'VBFHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'VBFHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'VBFHTT')}
elif bool('VBF_LFV_HToMuTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'VBFHMT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'VBFHMT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'VBFHMT')}
elif bool('GluGluHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'GGHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'GGHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'GGHTT')}
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'GGHMT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'GGHMT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'GGHMT')}
elif bool('QCD' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'QCD'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'QCD'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'QCD')}
else:
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY')}


class AnalyzeMuTauSys(MegaBase):
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
    self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH)
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
      self.MetSys = MEtSys("PFMEtSys_2017.root")
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeMuTauSys, self).__init__(tree, outfile, **kwargs)
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
    folder = []
    vbffolder = []

    names = ['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TightOS1Jet'] 

    vbfnames = ['TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TightOS2Jet', 'TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']

    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'tidUp', 'tidDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'embtrkUp', 'embtrkDown', 'mtfakeUp', 'mtfakeDown', 'etfakeUp', 'etfakeDown', 'etefakeUp', 'etefakeDown', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'JetEta0to3Up', 'JetEta0to3Down', 'JetEta0to5Up', 'JetEta0to5Down', 'JetEta3to5Up', 'JetEta3to5Down', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'TopptreweightUp', 'TopptreweightDown']

    fakes = ['MuonFakeUp', 'MuonFakeDown', 'TauFakeUp', 'TauFakeDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_fakes in itertools.product(names, fakes):
      folder.append(os.path.join(*tuple_path_fakes))
    for f in folder:
      self.book(f, "m_t_CollinearMass", "Muon + Tau Collinear Mass", 30, 0, 300)      

    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))
    for tuple_path_vbffakes in itertools.product(vbfnames, fakes):
      vbffolder.append(os.path.join(*tuple_path_vbffakes))
    for f in vbffolder:
      self.book(f, "m_t_CollinearMass", "Muon + Tau Collinear Mass", 12, 0, 300)


  def fill_histos(self, myMuon, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/m_t_CollinearMass'].Fill(collMass(myMuon, myMET, myTau), weight)


  def fill_categories(self, row, myMuon, myMET, myTau, njets, mjj, weight, name=''):
    if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)                                                                                                                                                                                               
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*frTau*mIso
      if self.oppositesign(row):
        self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS'+name)
        if njets==0 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS0Jet'+name)
        elif njets==1 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS1Jet'+name)
        elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2Jet'+name)
        elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TauLooseOS2JetVBF'+name)

    if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
      frMuon = self.fakeRateMuon(myMuon.Pt())
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*frMuon*mIso 
      if self.oppositesign(row):
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS'+name)
        if njets==0 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS0Jet'+name)
        elif njets==1 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS1Jet'+name)
        elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2Jet'+name)
        elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseOS2JetVBF'+name)

    if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
      frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
      frMuon = self.fakeRateMuon(myMuon.Pt())
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.muonLooseIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*mIso*frMuon*frTau
      if self.oppositesign(row):
        self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS'+name)
        if njets==0 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS0Jet'+name)
        elif njets==1 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS1Jet'+name)
        elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2Jet'+name)
        elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
          self.fill_histos(myMuon, myMET, myTau, weight, 'MuonLooseTauLooseOS2JetVBF'+name)

    if self.obj2_tight(row) and self.obj1_tight(row):
      mIso = 1
      if not self.is_data and not self.is_embed:
        mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
      weight = weight*mIso
      if self.oppositesign(row):
        self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS'+name)
        if njets==0 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS0Jet'+name)
        elif njets==1 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS1Jet'+name)
        elif njets==2 and mjj < 550 and transverseMass(myTau, myMET) < 105:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2Jet'+name)
        elif njets==2 and mjj > 550 and transverseMass(myTau, myMET) < 85:
          self.fill_histos(myMuon, myMET, myTau, weight, 'TightOS2JetVBF'+name)


  def fill_sys(self, row, weight):

    myMuon = ROOT.TLorentzVector()                                                                                                                                                                                                                                      
    tmpMuon = ROOT.TLorentzVector()                                                                                                                                                                                                                                    
    myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

    myTau = ROOT.TLorentzVector()                                                                                                                                                                                                                                        
    tmpTau = ROOT.TLorentzVector()
    uncorTau = ROOT.TLorentzVector()
    myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    uncorTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

    myMET = ROOT.TLorentzVector()                                                                                                                                                                                                                                       
    tmpMET = ROOT.TLorentzVector()                                                                                                                                                                                                                                       
    myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0) 

    njets = row.jetVeto30#WoNoisyJets
    mjj = row.vbfMass#WoNoisyJets

    if self.is_mc:

      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if row.tDecayMode == 0:
          myMETpx = myMET.Px() - 0.003 * myTau.Px()
          myMETpy = myMET.Py() - 0.003 * myTau.Py()
          myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          myTau = myTau * ROOT.Double(1.003)
        elif row.tDecayMode == 1:
          myMETpx = myMET.Px() - 0.036 * myTau.Px()
          myMETpy = myMET.Py() - 0.036 * myTau.Py()
          myMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          myTau = myTau * ROOT.Double(1.036)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0) 

        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0) 
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/recresoDown')

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      if puweight==0:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')

      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.89/0.86, '/tidUp')
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.84/0.86, '/tidDown')

      if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
        if abs(row.tEta) < 0.4:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.29/1.17, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.05/1.17, '/mtfakeDown')
        elif abs(row.tEta) < 0.8:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.59/1.29, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.99/1.29, '/mtfakeDown')
        elif abs(row.tEta) < 1.2:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.19/1.14, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.09/1.14, '/mtfakeDown')
        elif abs(row.tEta) < 1.7:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.53/0.93, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.33/0.93, '/mtfakeDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 2.21/1.61, '/mtfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.01/1.61, '/mtfakeDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeDown')
      elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if abs(row.tEta) < 1.46:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.10/1.09, '/etfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.08/1.09, '/etfakeDown')
        elif abs(row.tEta) > 1.558:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.20/1.19, '/etfakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.18/1.19, '/etfakeDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etfakeDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/mtfakeDown')
          
      if row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
        if row.tDecayMode==0 or row.tDecayMode==1:
          myMETpx = myMET.Px() - 0.007 * myTau.Px()                                                                                                                                                                                                             
          myMETpy = myMET.Py() - 0.007 * myTau.Py()                                                                                                                                                                                                      
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(1.007)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeUp')
          myMETpx = myMET.Px() + 0.007 * myTau.Px()                                                                                                                                                                                                             
          myMETpy = myMET.Py() + 0.007 * myTau.Py()                                                                                                                                                                                                             
          tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          tmpTau = myTau * ROOT.Double(0.993)
          self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/etefakeDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeDown')
      else:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/etefakeDown')

      myMETpx = myMET.Px() - 0.002 * myMuon.Px()                                                                                                                                                                                                               
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()                                                                                                                                                                                                                
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesUp')

      myMETpx = myMET.Px() + 0.002 * myMuon.Px()                                                                                                                                                                                                               
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()                                                                                                                                                                                                               
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(row, tmpMuon, tmpMET, myTau, njets, mjj, weight, '/mesDown')

      if bool(not self.is_DY and not self.is_DYlow):
        if row.tZTTGenMatching==5:
          if row.tDecayMode==0:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.008 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.008 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.992) 
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM0Down')
          elif row.tDecayMode==1:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.008 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.008 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.992) 
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM1Down')
          elif row.tDecayMode==10:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            myMETpx = myMET.Px() - 0.009 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.009 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.009)
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Up')
            myMETpx = myMET.Px() + 0.009 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.009 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.991) 
            self.fill_categories(row, myMuon, tmpMET, tmpTau, njets, mjj, weight, '/scaletDM10Down')
          else:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')

      if self.is_DY:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*1.1, '/DYptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*0.9, '/DYptreweightDown')

      if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
        topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight/topweight, '/TopptreweightDown')
        
      if not self.obj2_tight(row) or not self.obj1_tight(row):
        myrand = random.random()
        if myrand < 0.5:
          if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0:
            weightDown = 0
          else:
            weightDown = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frDown') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakeDown')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakeUp')
        else:
          if self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)==0:
            weightUp = 0
          else:
            weightUp = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frUp') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakeDown')

        myrand = random.random()
        if myrand < 0.5:
          if self.fakeRateMuon(myMuon.Pt()):
            weightDown = 0                                                                                                                                                                                                                                       
          else: 
            weightDown = self.fakeRateMuon(myMuon.Pt(), 'frDown') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakeDown')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakeUp')
        else:
          if self.fakeRateMuon(myMuon.Pt()):
            weightUp = 0
          else:
            weightUp = self.fakeRateMuon(myMuon.Pt(), 'frUp') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakeDown')

      if not (self.is_recoilC and MetCorrection):
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnUp')
        tmpMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
        self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/UnclusteredEnDown')

        jes = ['JetEta0to3Up', 'JetEta0to3Down', 'JetEta0to5Up', 'JetEta0to5Down', 'JetEta3to5Up', 'JetEta3to5Down', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown'] 

        for j in jes:
          tmpMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j), 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          tmpMET = self.tauPtC(row, tmpMET, uncorTau)[0]
          #if j=='JetRelativeBalUp' or j=='JetRelativeBalDown':
          #  njets = getattr(row, 'jetVeto30WoNoisyJets_'+j+'WoNoisyJets')                                                                                                                                                                                                
          #else:                                                                                                                                                                                  
          #  njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          #mjj = getattr(row, 'vbfMassWoNoisyJets_'+j)
          njets = getattr(row, 'jetVeto30_'+j)
          mjj = getattr(row, 'vbfMass_'+j) 
          self.fill_categories(row, myMuon, tmpMET, myTau, njets, mjj, weight, '/'+j) 
      
    else:
      self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '')

      if not self.obj2_tight(row) or not self.obj1_tight(row):
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frDown') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/TauFakeDown')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakeUp')
        else:
          weightUp = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode, 'frUp') * weight/self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/TauFakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/TauFakeDown')

        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateMuon(myMuon.Pt(), 'frDown') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightDown, '/MuonFakeDown')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakeUp')
        else:
          weightUp = self.fakeRateMuon(myMuon.Pt(), 'frUp') * weight/self.fakeRateMuon(myMuon.Pt())
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weightUp, '/MuonFakeUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/MuonFakeDown')

      if self.is_embed:
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.02, '/trUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.98, '/trDown')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.96, '/embtrDown')

        if row.tZTTGenMatching==5:
          if row.tDecayMode==0:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.008 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.008 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.992) 
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          elif row.tDecayMode==1:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
            myMETpx = myMET.Px() - 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.008 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.008)
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            myMETpx = myMET.Px() + 0.008 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.008 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.992) 
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          elif row.tDecayMode==10:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            myMETpx = myMET.Px() - 0.009 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() - 0.009 * myTau.Py()                                                                                                                                                                                                         
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
            tmpTau = myTau * ROOT.Double(1.009)
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            myMETpx = myMET.Px() + 0.009 * myTau.Px()                                                                                                                                                                                                           
            myMETpy = myMET.Py() + 0.009 * myTau.Py()                                                                                                                                                                                                           
            tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, sqrt(myMETpx * myMETpx + myMETpy * myMETpy))                                                                                                                                             
            tmpTau = myTau * ROOT.Double(0.991) 
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
          else:
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
            self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM0Down')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM1Down')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Up')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/scaletDM10Down')

        if row.tDecayMode == 0:
          dm = 0.975
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.983/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * 0.967/dm, '/embtrkDown')
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.983*1.065)/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * (0.967*1.037)/dm, '/embtrkDown')
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.983, 3)/dm, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight * pow(0.967, 3)/dm, '/embtrkDown')
        else:
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/embtrkUp')
          self.fill_categories(row, myMuon, myMET, myTau, njets, mjj, weight, '/embtrkDown')


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

      if deltaR(row.tPhi, row.mPhi, row.tEta, row.mEta) < 0.5:
        continue

      if row.jetVeto30 > 2:#WoNoisyJets
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
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*tID*mTrk
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

      self.fill_sys(row, weight)

  def finish(self):
    self.write_histos()
