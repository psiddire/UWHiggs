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
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3
import bTagSF
import random
import numpy as np
from keras.models import load_model, model_from_json, Sequential
from keras.layers import Dense, Dropout

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


class AnalyzeMuTauSysNN(MegaBase):
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
    self.var_d_star =['mPt', 'tPt', 'dPhiMuTau', 'dEtaMuTau', 'type1_pfMetEt', 'm_t_collinearMass', 'MTTauMET', 'dPhiTauMET']
    self.xml_name = os.path.join(os.getcwd(), "bdtdata/dataset/weights/TMVAClassification_BDTG.weights.xml")
    self.functor = FunctorFromMVA('BDT method', self.xml_name, *self.var_d_star)

    json_file = open('model.json', 'r')
    loaded_model_json = json_file.read()
    json_file.close()
    self.model = model_from_json(loaded_model_json)
    self.model.compile(loss="categorical_crossentropy", optimizer="adam")
    self.model.load_weights('NN_weights.h5')

    super(AnalyzeMuTauSysNN, self).__init__(tree, outfile, **kwargs)
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
    if row['mCharge']*row['tCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['IsoMu27Pass']:
      return False
    return True


  def kinematics(self, row):
    if row['mPt'] < 29 or abs(row['mEta']) >= 2.4:
      return False
    if row['tPt'] < 30 or abs(row['tEta']) >= 2.3:
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20Loose3HitsVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return bool(row['mPFIDTight'])
 
 
  def obj1_tight(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.15)
  

  def obj1_loose(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.25)

  
  def obj2_id(self, row):
    return bool(row['tDecayModeFinding'] > 0.5) and bool(row['tAgainstElectronVLooseMVA6'] > 0.5) and bool(row['tAgainstMuonTight3'] > 0.5)


  def obj2_tight(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTTight'] > 0.5)


  def obj2_loose(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTLoose'] > 0.5)


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30Medium'] < 0.5)


  def dimuonveto(self, row):
    return bool(row['dimuonVeto'] < 0.5)


  def begin(self):
    folder = []
    vbffolder = []

    names = ['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TightOS2Jet', 'TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']

    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'embtrkUp', 'embtrkDown', 'mtfakeUp', 'mtfakeDown', 'etfakeUp', 'etfakeDown', 'etefakeUp', 'etefakeDown', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'AbsoluteFlavMapUp', 'AbsoluteFlavMapDown', 'AbsoluteMPFBiasUp', 'AbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']#'TopptreweightUp', 'TopptreweightDown'

    fakes = ['MuonLooseOS/MuonFakeUp', 'MuonLooseOS0Jet/MuonFakeUp', 'MuonLooseOS1Jet/MuonFakeUp', 'MuonLooseOS2Jet/MuonFakeUp', 'MuonLooseOS/MuonFakeDown', 'MuonLooseOS0Jet/MuonFakeDown', 'MuonLooseOS1Jet/MuonFakeDown', 'MuonLooseOS2Jet/MuonFakeDown', 'TauLooseOS/TauFakeUp', 'TauLooseOS0Jet/TauFakeUp', 'TauLooseOS1Jet/TauFakeUp', 'TauLooseOS2Jet/TauFakeUp', 'TauLooseOS/TauFakeDown', 'TauLooseOS0Jet/TauFakeDown', 'TauLooseOS1Jet/TauFakeDown', 'TauLooseOS2Jet/TauFakeDown', 'MuonLooseTauLooseOS/TauFakeUp', 'MuonLooseTauLooseOS0Jet/TauFakeUp', 'MuonLooseTauLooseOS1Jet/TauFakeUp', 'MuonLooseTauLooseOS2Jet/TauFakeUp', 'MuonLooseTauLooseOS/TauFakeDown', 'MuonLooseTauLooseOS0Jet/TauFakeDown', 'MuonLooseTauLooseOS1Jet/TauFakeDown', 'MuonLooseTauLooseOS2Jet/TauFakeDown', 'MuonLooseTauLooseOS/MuonFakeUp', 'MuonLooseTauLooseOS0Jet/MuonFakeUp', 'MuonLooseTauLooseOS1Jet/MuonFakeUp', 'MuonLooseTauLooseOS2Jet/MuonFakeUp', 'MuonLooseTauLooseOS/MuonFakeDown', 'MuonLooseTauLooseOS0Jet/MuonFakeDown', 'MuonLooseTauLooseOS1Jet/MuonFakeDown', 'MuonLooseTauLooseOS2Jet/MuonFakeDown', 'MuonLooseOS2JetVBF/MuonFakeUp', 'MuonLooseOS2JetVBF/MuonFakeDown', 'TauLooseOS2JetVBF/TauFakeUp', 'TauLooseOS2JetVBF/TauFakeDown', 'MuonLooseTauLooseOS2JetVBF/TauFakeUp', 'MuonLooseTauLooseOS2JetVBF/TauFakeDown', 'MuonLooseTauLooseOS2JetVBF/MuonFakeUp', 'MuonLooseTauLooseOS2JetVBF/MuonFakeDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for fak in fakes:
      folder.append(fak)
    for f in folder:
      self.book(f, "sigDiscriminator", "NN Discriminator", 10, 0.0, 1.0)

  def fill_histos(self, mva, weight, name=''):
    histos = self.histograms
    histos[name+'/sigDiscriminator'].Fill(mva[0][0], weight)

  def var_d(self, row):
    return [[row['mPt'], row['tPt'], deltaPhi(row['mPhi'], row['tPhi']), abs(row['mEta'] - row['tEta']), row['type1_pfMetEt'], collMass(row), transverseMass(row['tPt'], row['tEta'], row['tPhi'], row['tMass'], row['type1_pfMetEt'], row['type1_pfMetPhi']), deltaPhi(row['tPhi'], row['type1_pfMetPhi'])]]

  def fill_sys(self, row, weight, name=''):
    if self.is_mc:
      puweightUp = pucorrector['puUp'](row['nTruePU'])
      puweightDown = pucorrector['puDown'](row['nTruePU'])
      puweight = pucorrector[''](row['nTruePU'])

      MVA = self.model.predict(np.array(self.var_d(row)))
      self.fill_histos(MVA, weight, name)

      if puweight==0:
        self.fill_histos(MVA, 0, name+'/puUp')
        self.fill_histos(MVA, 0, name+'/puDown')
      else:
        self.fill_histos(MVA, weight * puweightUp/puweight, name+'/puUp')
        self.fill_histos(MVA, weight * puweightDown/puweight, name+'/puDown')
      self.fill_histos(MVA, weight * 1.02, name+'/trUp')
      self.fill_histos(MVA, weight * 0.98, name+'/trDown')

      if self.is_DY or self.is_DYlow:
        self.fill_histos(MVA, weight * 1.1, name+'/DYptreweightUp')
        self.fill_histos(MVA, weight * 0.9, name+'/DYptreweightDown')

      #if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
      #  topweight = topPtreweight(row['topQuarkPt1'], row['topQuarkPt2'])
      #  self.fill_histos(MVA, weight*2, name+'/TopptreweightUp')
      #  self.fill_histos(MVA, weight/topweight, name+'/TopptreweightDown')

      if row['tZTTGenMatching']==2 or row['tZTTGenMatching']==4:
        if abs(row['tEta']) < 0.4:
          self.fill_histos(MVA, weight * 1.29/1.17, name+'/mtfakeUp')
          self.fill_histos(MVA, weight * 1.05/1.17, name+'/mtfakeDown')
        elif abs(row['tEta']) < 0.8:
          self.fill_histos(MVA, weight * 1.59/1.29, name+'/mtfakeUp')
          self.fill_histos(MVA, weight * 0.99/1.29, name+'/mtfakeDown')
        elif abs(row['tEta']) < 1.2:
          self.fill_histos(MVA, weight * 1.19/1.14, name+'/mtfakeUp')
          self.fill_histos(MVA, weight * 1.09/1.14, name+'/mtfakeDown')
        elif abs(row['tEta']) < 1.7:
          self.fill_histos(MVA, weight * 1.53/0.93, name+'/mtfakeUp')
          self.fill_histos(MVA, weight * 0.33/0.93, name+'/mtfakeDown')
        else:
          self.fill_histos(MVA, weight * 2.21/1.61, name+'/mtfakeUp')
          self.fill_histos(MVA, weight * 1.01/1.61, name+'/mtfakeDown')
        self.fill_histos(MVA, weight, name+'/etfakeUp')
        self.fill_histos(MVA, weight, name+'/etfakeDown')
      elif row['tZTTGenMatching']==1 or row['tZTTGenMatching']==3:
        if abs(row['tEta']) < 1.46:
          self.fill_histos(MVA, weight * 1.10/1.09, name+'/etfakeUp')
          self.fill_histos(MVA, weight * 1.08/1.09, name+'/etfakeDown')
        elif abs(row['tEta']) > 1.558:
          self.fill_histos(MVA, weight * 1.20/1.19, name+'/etfakeUp')
          self.fill_histos(MVA, weight * 1.18/1.19, name+'/etfakeDown')
        self.fill_histos(MVA, weight, name+'/mtfakeUp')
        self.fill_histos(MVA, weight, name+'/mtfakeDown')
      else:
        self.fill_histos(MVA, weight, name+'/etfakeUp')
        self.fill_histos(MVA, weight, name+'/etfakeDown')
        self.fill_histos(MVA, weight, name+'/mtfakeUp')
        self.fill_histos(MVA, weight, name+'/mtfakeDown')

      if 'TauLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frDown') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(MVA, weightDown, name+'/TauFakeDown')
          self.fill_histos(MVA, weight, name+'/TauFakeUp')
        else:
          weightUp = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frUp') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(MVA, weightUp, name+'/TauFakeUp')
          self.fill_histos(MVA, weight, name+'/TauFakeDown')
      if 'MuonLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateMuon(row['mPt'], 'frDown') * weight/self.fakeRateMuon(row['mPt'])
          self.fill_histos(MVA, weightDown, name+'/MuonFakeDown')
          self.fill_histos(MVA, weight, name+'/MuonFakeUp')
        else:
          weightUp = self.fakeRateMuon(row['mPt'], 'frUp') * weight/self.fakeRateMuon(row['mPt'])
          self.fill_histos(MVA, weightUp, name+'/MuonFakeUp')
          self.fill_histos(MVA, weight, name+'/MuonFakeDown')

      metrow = copy.deepcopy(row)
      if self.is_recoilC and MetCorrection:
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 0, 0)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        MVA = self.model.predict(np.array(self.var_d(metrow)))
        self.fill_histos(MVA, weight, name+'/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 0, 1)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        MVA = self.model.predict(np.array(self.var_d(metrow)))
        self.fill_histos(MVA, weight, name+'/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 1, 0)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        MVA = self.model.predict(np.array(self.var_d(metrow)))
        self.fill_histos(MVA, weight, name+'/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 1, 1)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        MVA = self.model.predict(np.array(self.var_d(metrow)))
        self.fill_histos(MVA, weight, name+'/recresoDown')

      ftesrow = copy.deepcopy(row)
      if ftesrow['tZTTGenMatching']==1 or ftesrow['tZTTGenMatching']==3:
        tmptpt = ftesrow['tPt']
        if ftesrow['tDecayMode'] == 0 or ftesrow['tDecayMode'] == 1:
          ftesrow['tPt'] = tmptpt*1.007
          MVA = self.model.predict(np.array(self.var_d(ftesrow)))
          self.fill_histos(MVA, weight, name+'/etefakeUp')
          ftesrow['tPt'] = tmptpt*0.993
          MVA = self.model.predict(np.array(self.var_d(ftesrow)))
          self.fill_histos(MVA, weight, name+'/etefakeDown')
        else:
          MVA = self.model.predict(np.array(self.var_d(ftesrow)))
          self.fill_histos(MVA, weight, name+'/etefakeUp')
          self.fill_histos(MVA, weight, name+'/etefakeDown')
      else:
        MVA = self.model.predict(np.array(self.var_d(ftesrow)))
        self.fill_histos(MVA, weight, name+'/etefakeUp')
        self.fill_histos(MVA, weight, name+'/etefakeDown')

      mesrow = copy.deepcopy(row)
      tmpmpt = mesrow['mPt']
      mesrow['mPt'] = tmpmpt*1.002
      MVA = self.model.predict(np.array(self.var_d(mesrow)))
      self.fill_histos(MVA, weight, name+'/mesUp')
      mesrow['mPt'] = tmpmpt*0.998
      MVA = self.model.predict(np.array(self.var_d(mesrow)))
      self.fill_histos(MVA, weight, name+'/mesDown')

      if bool(not self.is_DY and not self.is_DYlow):
        scalerow = copy.deepcopy(row)
        normtPt = scalerow['tPt']
        normmet = scalerow['type1_pfMetEt']
        MVA = self.model.predict(np.array(self.var_d(scalerow)))
        if row['tZTTGenMatching']==5:
          if scalerow['tDecayMode']==0:
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
          elif scalerow['tDecayMode']==1:
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
          elif scalerow['tDecayMode']==10:
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            scalerow['tPt'] = normtPt * 1.009
            scalerow['type1_pfMetEt'] = normmet - 0.009 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            scalerow['tPt'] = normtPt * 0.991
            scalerow['type1_pfMetEt'] = normmet + 0.009 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
          else:
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
        else:
          self.fill_histos(MVA, weight, name+'/scaletDM0Up')
          self.fill_histos(MVA, weight, name+'/scaletDM0Down')
          self.fill_histos(MVA, weight, name+'/scaletDM1Up')
          self.fill_histos(MVA, weight, name+'/scaletDM1Down')
          self.fill_histos(MVA, weight, name+'/scaletDM10Up')
          self.fill_histos(MVA, weight, name+'/scaletDM10Down')
      
      if not (self.is_recoilC and MetCorrection):
        uesrow = copy.deepcopy(row)
        uesrow['type1_pfMetEt'] = self.metTauC(uesrow['tPtInitial'], uesrow['tDecayMode'], uesrow['tZTTGenMatching'], uesrow['type1_pfMet_shiftedPt_UnclusteredEnUp'])
        uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnUp']
        MVA = self.model.predict(np.array(self.var_d(uesrow)))
        self.fill_histos(MVA, weight, name+'/UnclusteredEnUp')
        uesrow['type1_pfMetEt'] = self.metTauC(uesrow['tPtInitial'], uesrow['tDecayMode'], uesrow['tZTTGenMatching'], uesrow['type1_pfMet_shiftedPt_UnclusteredEnDown'])
        uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnDown']
        MVA = self.model.predict(np.array(self.var_d(uesrow)))
        self.fill_histos(MVA, weight, name+'/UnclusteredEnDown')

        jesrow = copy.deepcopy(row)
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/AbsoluteFlavMapUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/AbsoluteFlavMapDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/AbsoluteMPFBiasUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/AbsoluteMPFBiasDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetAbsoluteScaleUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetAbsoluteScaleDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetAbsoluteStatUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetAbsoluteStatDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFlavorQCDUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetFlavorQCDUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFlavorQCDDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetFlavorQCDDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFragmentationUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetFragmentationUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFragmentationDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetFragmentationDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpDataMCUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpDataMCDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtBBUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtBBDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtEC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtEC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtEC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtEC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtRefUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetPileUpPtRefDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeFSRUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeFSRUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeFSRDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeFSRDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJEREC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJEREC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJEREC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJEREC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJERHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeJERHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtBBUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtBBUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtBBDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtBBDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtEC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtEC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Up']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtEC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Down']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtEC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativePtHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatECUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatECUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatECDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatECDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatFSRUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatFSRDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFDown'] 
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeStatHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionECALUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetSinglePionECALUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionECALDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetSinglePionECALDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetSinglePionHCALUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetSinglePionHCALDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetTimePtEtaUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetTimePtEtaUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetTimePtEtaDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetTimePtEtaDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeBalUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeBalUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeBalDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeBalDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeSampleUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleUp']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeSampleUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeSampleDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleDown']
        MVA = self.model.predict(np.array(self.var_d(jesrow)))
        self.fill_histos(MVA, weight, name+'/JetRelativeSampleDown')

    else:
      MVA = self.model.predict(np.array(self.var_d(row)))
      self.fill_histos(MVA, weight, name)
      if 'TauLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frDown') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(MVA, weightDown, name+'/TauFakeDown')
          self.fill_histos(MVA, weight, name+'/TauFakeUp')
        else:
          weightUp = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frUp') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(MVA, weightUp, name+'/TauFakeUp')
          self.fill_histos(MVA, weight, name+'/TauFakeDown')
      if 'MuonLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRateMuon(row['mPt'], 'frDown') * weight/self.fakeRateMuon(row['mPt'])
          self.fill_histos(MVA, weightDown, name+'/MuonFakeDown')
          self.fill_histos(MVA, weight, name+'/MuonFakeUp')
        else:
          weightUp = self.fakeRateMuon(row['mPt'], 'frUp') * weight/self.fakeRateMuon(row['mPt'])
          self.fill_histos(MVA, weightUp, name+'/MuonFakeUp')
          self.fill_histos(MVA, weight, name+'/MuonFakeDown')

      if self.is_embed:
        self.fill_histos(MVA, weight * 1.02, name+'/trUp')
        self.fill_histos(MVA, weight * 0.98, name+'/trDown')
        self.fill_histos(MVA, weight * 1.04, name+'/embtrUp')
        self.fill_histos(MVA, weight * 0.96, name+'/embtrDown')

        if row['tDecayMode'] == 0:
          dm = 0.975
          self.fill_histos(MVA, weight * 0.983/dm, name+'/embtrkUp')
          self.fill_histos(MVA, weight * 0.967/dm, name+'/embtrkDown')
        elif row['tDecayMode'] == 1:
          dm = 0.975*1.051
          self.fill_histos(MVA, weight * (0.983*1.065)/dm, name+'/embtrkUp')
          self.fill_histos(MVA, weight * (0.967*1.037)/dm, name+'/embtrkDown')
        elif row['tDecayMode'] == 10:
          dm = pow(0.975, 3)
          self.fill_histos(MVA, weight * pow(0.983, 3)/dm, name+'/embtrkUp')
          self.fill_histos(MVA, weight * pow(0.967, 3)/dm, name+'/embtrkDown')

        scalerow = copy.deepcopy(row)
        normtPt = scalerow['tPt']
        normmet = scalerow['type1_pfMetEt']
        MVA = self.model.predict(np.array(self.var_d(scalerow)))
        if row['tZTTGenMatching']==5:
          if scalerow['tDecayMode']==0:
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
          elif scalerow['tDecayMode']==1:
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
          elif scalerow['tDecayMode']==10:
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            scalerow['tPt'] = normtPt * 1.009
            scalerow['type1_pfMetEt'] = normmet - 0.009 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            scalerow['tPt'] = normtPt * 0.991
            scalerow['type1_pfMetEt'] = normmet + 0.009 * normtPt
            MVA = self.model.predict(np.array(self.var_d(scalerow)))
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
          else:
            self.fill_histos(MVA, weight, name+'/scaletDM0Up')
            self.fill_histos(MVA, weight, name+'/scaletDM0Down')
            self.fill_histos(MVA, weight, name+'/scaletDM1Up')
            self.fill_histos(MVA, weight, name+'/scaletDM1Down')
            self.fill_histos(MVA, weight, name+'/scaletDM10Up')
            self.fill_histos(MVA, weight, name+'/scaletDM10Down')
        else:
          self.fill_histos(MVA, weight, name+'/scaletDM0Up')
          self.fill_histos(MVA, weight, name+'/scaletDM0Down')
          self.fill_histos(MVA, weight, name+'/scaletDM1Up')
          self.fill_histos(MVA, weight, name+'/scaletDM1Down')
          self.fill_histos(MVA, weight, name+'/scaletDM10Up')
          self.fill_histos(MVA, weight, name+'/scaletDM10Down')


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
    subtemp['tPtInitial'] = row.tPt
    subtemp['MetEtInitial'] = tmpMetEt
    if self.is_recoilC and MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])
      subtemp['genpX'] = row.genpX
      subtemp['genpY'] = row.genpY
      subtemp['vispX'] = row.vispX
      subtemp['vispY'] = row.vispY

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
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["mPFIDTight"] = row.mPFIDTight
    subtemp["mRelPFIsoDBDefaultR04"] = row.mRelPFIsoDBDefaultR04
    subtemp["tDecayModeFinding"] = row.tDecayModeFinding
    subtemp["tAgainstElectronVLooseMVA6"] = row.tAgainstElectronVLooseMVA6
    subtemp["tAgainstMuonTight3"] = row.tAgainstMuonTight3
    subtemp["tRerunMVArun2v2DBoldDMwLTTight"] = row.tRerunMVArun2v2DBoldDMwLTTight
    subtemp["tRerunMVArun2v2DBoldDMwLTLoose"] = row.tRerunMVArun2v2DBoldDMwLTLoose
    subtemp["tByCombinedIsolationDeltaBetaCorrRaw3Hits"] = row.tByCombinedIsolationDeltaBetaCorrRaw3Hits
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["tDecayMode"] = row.tDecayMode
    subtemp["tZTTGenMatching"] = row.tZTTGenMatching
    subtemp["dimuonVeto"] = row.dimuonVeto
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["vbfNJets30"] = row.vbfNJets30
    subtemp["vbfMass"] = row.vbfMass
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb2pt"] = row.jb2pt
    subtemp["jb2hadronflavor"] = row.jb2hadronflavor
    subtemp["topQuarkPt1"] = row.topQuarkPt1
    subtemp["topQuarkPt2"] = row.topQuarkPt2
    subtemp['m_t_DPhi'] = row.m_t_DPhi
    subtemp['m_t_DR'] = row.m_t_DR
    subtemp['dimuonVeto'] = row.dimuonVeto
    subtemp["mPt_MuonEnUp"] = row.mPt_MuonEnUp
    subtemp["mPt_MuonEnDown"] = row.mPt_MuonEnDown
    if self.is_mc:
      subtemp["type1_pfMet_shiftedPhi_UnclusteredEnDown"] = row.type1_pfMet_shiftedPhi_UnclusteredEnDown
      subtemp["type1_pfMet_shiftedPhi_UnclusteredEnUp"] = row.type1_pfMet_shiftedPhi_UnclusteredEnUp
      subtemp["type1_pfMet_shiftedPt_UnclusteredEnDown"] = row.type1_pfMet_shiftedPt_UnclusteredEnDown
      subtemp["type1_pfMet_shiftedPt_UnclusteredEnUp"] = row.type1_pfMet_shiftedPt_UnclusteredEnUp
      subtemp["type1_pfMet_shiftedPhi_AbsoluteFlavMapDown"] = row.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown
      subtemp["type1_pfMet_shiftedPhi_AbsoluteFlavMapUp"] = row.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp
      subtemp["type1_pfMet_shiftedPt_AbsoluteFlavMapDown"] = row.type1_pfMet_shiftedPt_AbsoluteFlavMapDown
      subtemp["type1_pfMet_shiftedPt_AbsoluteFlavMapUp"] = row.type1_pfMet_shiftedPt_AbsoluteFlavMapUp
      subtemp["type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown"] = row.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown
      subtemp["type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp"] = row.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp
      subtemp["type1_pfMet_shiftedPt_AbsoluteMPFBiasDown"] = row.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown
      subtemp["type1_pfMet_shiftedPt_AbsoluteMPFBiasUp"] = row.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp
      subtemp["type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"] = row.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown
      subtemp["type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"] = row.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp
      subtemp["type1_pfMet_shiftedPt_JetAbsoluteScaleDown"] = row.type1_pfMet_shiftedPt_JetAbsoluteScaleDown
      subtemp["type1_pfMet_shiftedPt_JetAbsoluteScaleUp"] = row.type1_pfMet_shiftedPt_JetAbsoluteScaleUp
      subtemp["type1_pfMet_shiftedPhi_JetAbsoluteStatDown"] = row.type1_pfMet_shiftedPhi_JetAbsoluteStatDown
      subtemp["type1_pfMet_shiftedPhi_JetAbsoluteStatUp"] = row.type1_pfMet_shiftedPhi_JetAbsoluteStatUp
      subtemp["type1_pfMet_shiftedPt_JetAbsoluteStatDown"] = row.type1_pfMet_shiftedPt_JetAbsoluteStatDown
      subtemp["type1_pfMet_shiftedPt_JetAbsoluteStatUp"] = row.type1_pfMet_shiftedPt_JetAbsoluteStatUp
      subtemp["type1_pfMet_shiftedPhi_JetFlavorQCDDown"] = row.type1_pfMet_shiftedPhi_JetFlavorQCDDown
      subtemp["type1_pfMet_shiftedPhi_JetFlavorQCDUp"] = row.type1_pfMet_shiftedPhi_JetFlavorQCDUp
      subtemp["type1_pfMet_shiftedPt_JetFlavorQCDDown"] = row.type1_pfMet_shiftedPt_JetFlavorQCDDown
      subtemp["type1_pfMet_shiftedPt_JetFlavorQCDUp"] = row.type1_pfMet_shiftedPt_JetFlavorQCDUp
      subtemp["type1_pfMet_shiftedPhi_JetFragmentationDown"] = row.type1_pfMet_shiftedPhi_JetFragmentationDown
      subtemp["type1_pfMet_shiftedPhi_JetFragmentationUp"] = row.type1_pfMet_shiftedPhi_JetFragmentationUp
      subtemp["type1_pfMet_shiftedPt_JetFragmentationDown"] = row.type1_pfMet_shiftedPt_JetFragmentationDown
      subtemp["type1_pfMet_shiftedPt_JetFragmentationUp"] = row.type1_pfMet_shiftedPt_JetFragmentationUp
      subtemp["type1_pfMet_shiftedPhi_JetPileUpDataMCDown"] = row.type1_pfMet_shiftedPhi_JetPileUpDataMCDown
      subtemp["type1_pfMet_shiftedPhi_JetPileUpDataMCUp"] = row.type1_pfMet_shiftedPhi_JetPileUpDataMCUp
      subtemp["type1_pfMet_shiftedPt_JetPileUpDataMCDown"] = row.type1_pfMet_shiftedPt_JetPileUpDataMCDown
      subtemp["type1_pfMet_shiftedPt_JetPileUpDataMCUp"] = row.type1_pfMet_shiftedPt_JetPileUpDataMCUp
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtBBDown"] = row.type1_pfMet_shiftedPhi_JetPileUpPtBBDown
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtBBUp"] = row.type1_pfMet_shiftedPhi_JetPileUpPtBBUp
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtBBDown"] = row.type1_pfMet_shiftedPt_JetPileUpPtBBDown
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtBBUp"] = row.type1_pfMet_shiftedPt_JetPileUpPtBBUp
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"] = row.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"] = row.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtEC1Down"] = row.type1_pfMet_shiftedPt_JetPileUpPtEC1Down
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtEC1Up"] = row.type1_pfMet_shiftedPt_JetPileUpPtEC1Up
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"] = row.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"] = row.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtEC2Down"] = row.type1_pfMet_shiftedPt_JetPileUpPtEC2Down
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtEC2Up"] = row.type1_pfMet_shiftedPt_JetPileUpPtEC2Up
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtHFDown"] = row.type1_pfMet_shiftedPhi_JetPileUpPtHFDown
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtHFUp"] = row.type1_pfMet_shiftedPhi_JetPileUpPtHFUp
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtHFDown"] = row.type1_pfMet_shiftedPt_JetPileUpPtHFDown
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtHFUp"] = row.type1_pfMet_shiftedPt_JetPileUpPtHFUp
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtRefDown"] = row.type1_pfMet_shiftedPhi_JetPileUpPtRefDown
      subtemp["type1_pfMet_shiftedPhi_JetPileUpPtRefUp"] = row.type1_pfMet_shiftedPhi_JetPileUpPtRefUp
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtRefDown"] = row.type1_pfMet_shiftedPt_JetPileUpPtRefDown
      subtemp["type1_pfMet_shiftedPt_JetPileUpPtRefUp"] = row.type1_pfMet_shiftedPt_JetPileUpPtRefUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeFSRDown"] = row.type1_pfMet_shiftedPhi_JetRelativeFSRDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeFSRUp"] = row.type1_pfMet_shiftedPhi_JetRelativeFSRUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeFSRDown"] = row.type1_pfMet_shiftedPt_JetRelativeFSRDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeFSRUp"] = row.type1_pfMet_shiftedPt_JetRelativeFSRUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"] = row.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"] = row.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up
      subtemp["type1_pfMet_shiftedPt_JetRelativeJEREC1Down"] = row.type1_pfMet_shiftedPt_JetRelativeJEREC1Down
      subtemp["type1_pfMet_shiftedPt_JetRelativeJEREC1Up"] = row.type1_pfMet_shiftedPt_JetRelativeJEREC1Up
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"] = row.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"] = row.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up
      subtemp["type1_pfMet_shiftedPt_JetRelativeJEREC2Down"] = row.type1_pfMet_shiftedPt_JetRelativeJEREC2Down
      subtemp["type1_pfMet_shiftedPt_JetRelativeJEREC2Up"] = row.type1_pfMet_shiftedPt_JetRelativeJEREC2Up
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJERHFDown"] = row.type1_pfMet_shiftedPhi_JetRelativeJERHFDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeJERHFUp"] = row.type1_pfMet_shiftedPhi_JetRelativeJERHFUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeJERHFDown"] = row.type1_pfMet_shiftedPt_JetRelativeJERHFDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeJERHFUp"] = row.type1_pfMet_shiftedPt_JetRelativeJERHFUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtBBDown"] = row.type1_pfMet_shiftedPhi_JetRelativePtBBDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtBBUp"] = row.type1_pfMet_shiftedPhi_JetRelativePtBBUp
      subtemp["type1_pfMet_shiftedPt_JetRelativePtBBDown"] = row.type1_pfMet_shiftedPt_JetRelativePtBBDown
      subtemp["type1_pfMet_shiftedPt_JetRelativePtBBUp"] = row.type1_pfMet_shiftedPt_JetRelativePtBBUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtEC1Down"] = row.type1_pfMet_shiftedPhi_JetRelativePtEC1Down
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtEC1Up"] = row.type1_pfMet_shiftedPhi_JetRelativePtEC1Up
      subtemp["type1_pfMet_shiftedPt_JetRelativePtEC1Down"] = row.type1_pfMet_shiftedPt_JetRelativePtEC1Down
      subtemp["type1_pfMet_shiftedPt_JetRelativePtEC1Up"] = row.type1_pfMet_shiftedPt_JetRelativePtEC1Up
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtEC2Down"] = row.type1_pfMet_shiftedPhi_JetRelativePtEC2Down
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtEC2Up"] = row.type1_pfMet_shiftedPhi_JetRelativePtEC2Up
      subtemp["type1_pfMet_shiftedPt_JetRelativePtEC2Down"] = row.type1_pfMet_shiftedPt_JetRelativePtEC2Down
      subtemp["type1_pfMet_shiftedPt_JetRelativePtEC2Up"] = row.type1_pfMet_shiftedPt_JetRelativePtEC2Up
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtHFDown"] = row.type1_pfMet_shiftedPhi_JetRelativePtHFDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativePtHFUp"] = row.type1_pfMet_shiftedPhi_JetRelativePtHFUp
      subtemp["type1_pfMet_shiftedPt_JetRelativePtHFDown"] = row.type1_pfMet_shiftedPt_JetRelativePtHFDown
      subtemp["type1_pfMet_shiftedPt_JetRelativePtHFUp"] = row.type1_pfMet_shiftedPt_JetRelativePtHFUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatECDown"] = row.type1_pfMet_shiftedPhi_JetRelativeStatECDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatECUp"] = row.type1_pfMet_shiftedPhi_JetRelativeStatECUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatECDown"] = row.type1_pfMet_shiftedPt_JetRelativeStatECDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatECUp"] = row.type1_pfMet_shiftedPt_JetRelativeStatECUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"] = row.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"] = row.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatFSRDown"] = row.type1_pfMet_shiftedPt_JetRelativeStatFSRDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatFSRUp"] = row.type1_pfMet_shiftedPt_JetRelativeStatFSRUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatHFDown"] = row.type1_pfMet_shiftedPhi_JetRelativeStatHFDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeStatHFUp"] = row.type1_pfMet_shiftedPhi_JetRelativeStatHFUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatHFDown"] = row.type1_pfMet_shiftedPt_JetRelativeStatHFDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeStatHFUp"] = row.type1_pfMet_shiftedPt_JetRelativeStatHFUp
      subtemp["type1_pfMet_shiftedPhi_JetSinglePionECALDown"] = row.type1_pfMet_shiftedPhi_JetSinglePionECALDown
      subtemp["type1_pfMet_shiftedPhi_JetSinglePionECALUp"] = row.type1_pfMet_shiftedPhi_JetSinglePionECALUp
      subtemp["type1_pfMet_shiftedPt_JetSinglePionECALDown"] = row.type1_pfMet_shiftedPt_JetSinglePionECALDown
      subtemp["type1_pfMet_shiftedPt_JetSinglePionECALUp"] = row.type1_pfMet_shiftedPt_JetSinglePionECALUp
      subtemp["type1_pfMet_shiftedPhi_JetSinglePionHCALDown"] = row.type1_pfMet_shiftedPhi_JetSinglePionHCALDown
      subtemp["type1_pfMet_shiftedPhi_JetSinglePionHCALUp"] = row.type1_pfMet_shiftedPhi_JetSinglePionHCALUp
      subtemp["type1_pfMet_shiftedPt_JetSinglePionHCALDown"] = row.type1_pfMet_shiftedPt_JetSinglePionHCALDown
      subtemp["type1_pfMet_shiftedPt_JetSinglePionHCALUp"] = row.type1_pfMet_shiftedPt_JetSinglePionHCALUp
      subtemp["type1_pfMet_shiftedPhi_JetTimePtEtaDown"] = row.type1_pfMet_shiftedPhi_JetTimePtEtaDown
      subtemp["type1_pfMet_shiftedPhi_JetTimePtEtaUp"] = row.type1_pfMet_shiftedPhi_JetTimePtEtaUp
      subtemp["type1_pfMet_shiftedPt_JetTimePtEtaDown"] = row.type1_pfMet_shiftedPt_JetTimePtEtaDown
      subtemp["type1_pfMet_shiftedPt_JetTimePtEtaUp"] = row.type1_pfMet_shiftedPt_JetTimePtEtaUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeBalDown"] = row.type1_pfMet_shiftedPhi_JetRelativeBalDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeBalUp"] = row.type1_pfMet_shiftedPhi_JetRelativeBalUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeBalDown"] = row.type1_pfMet_shiftedPt_JetRelativeBalDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeBalUp"] = row.type1_pfMet_shiftedPt_JetRelativeBalUp
      subtemp["type1_pfMet_shiftedPhi_JetRelativeSampleDown"] = row.type1_pfMet_shiftedPhi_JetRelativeSampleDown
      subtemp["type1_pfMet_shiftedPhi_JetRelativeSampleUp"] = row.type1_pfMet_shiftedPhi_JetRelativeSampleUp
      subtemp["type1_pfMet_shiftedPt_JetRelativeSampleDown"] = row.type1_pfMet_shiftedPt_JetRelativeSampleDown
      subtemp["type1_pfMet_shiftedPt_JetRelativeSampleUp"] = row.type1_pfMet_shiftedPt_JetRelativeSampleUp

    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []

    for row in self.tree:
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
            z[i]=temp[i]["tByCombinedIsolationDeltaBetaCorrRaw3Hits"]
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

      if not self.trigger(newrow):
        continue

      if not self.kinematics(newrow):
        continue

      if newrow['m_t_DR'] < 0.5:
        continue

      if newrow['jetVeto30'] > 2:
        continue

      if not self.obj1_id(newrow):
        continue

      if not self.obj2_id(newrow):
        continue

      if not self.vetos(newrow):
        continue      

      if not self.dimuonveto(newrow):
        continue

      if self.is_DY or self.is_DYlow:
        if not bool(newrow['isZmumu'] or newrow['isZee']):
          continue

      weight = 1.0
      if not self.is_data and not self.is_embed:

        mtracking = self.muTracking(newrow['mEta'])[0]
        tEff = self.triggerEff(newrow['mPt'], abs(newrow['mEta']))
        mID = self.muonTightID(newrow['mPt'], abs(newrow['mEta']))
        if newrow['tZTTGenMatching']==5:
          tID = 0.89
        else:
          tID = 1.0
        weight = newrow['GenWeight']*pucorrector[''](newrow['nTruePU'])*tEff*mID*mtracking*tID
        if self.is_DY:
          wmc.var("z_gen_mass").setVal(newrow['genMass'])
          wmc.var("z_gen_pt").setVal(newrow['genpT'])
          zptweight = wmc.function("zptmass_weight_nom").getVal()
          dyweight = self.DYreweight(newrow['genMass'], newrow['genpT'])
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          wmc.var("z_gen_mass").setVal(newrow['genMass'])
          wmc.var("z_gen_pt").setVal(newrow['genpT'])
          zptweight = wmc.function("zptmass_weight_nom").getVal()
          dyweight = self.DYreweight(newrow['genMass'], newrow['genpT'])
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
          if newrow['tDecayMode'] == 0:
            newrow['tPt'] = newrow['tPt'] * 1.003
          elif newrow['tDecayMode'] == 1:
            newrow['tPt'] = newrow['tPt'] * 1.036

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
        ws.var("gt_pt").setVal(newrow['tPt'])
        ws.var("gt_eta").setVal(newrow['tEta'])
        tsel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt1_pt").setVal(newrow['mPt'])
        ws.var("gt1_eta").setVal(newrow['mEta'])
        ws.var("gt2_pt").setVal(newrow['tPt'])
        ws.var("gt2_eta").setVal(newrow['tEta'])
        trgsel = ws.function("m_sel_trg_ratio").getVal()
        m_iso_sf = ws.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = ws.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = ws.function("m_trg27_embed_kit_ratio").getVal()                          
        weight = weight*newrow['GenWeight']*tID*m_trg_sf*m_id_sf*m_iso_sf*dm*msel*tsel*trgsel


      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and self.obj1_tight(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          self.fill_sys(newrow, weight*frTau*mIso*tIso, 'TauLooseOS')
          if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*mIso*tIso, 'TauLooseOS0Jet')
          elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*mIso*tIso, 'TauLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*mIso*tIso, 'TauLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_sys(newrow, weight*frTau*mIso*tIso, 'TauLooseOS2JetVBF')

      if not self.obj1_tight(newrow) and self.obj1_loose(newrow) and self.obj2_tight(newrow):
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          self.fill_sys(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS')
          if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS0Jet')
          elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_sys(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS2JetVBF')

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and not self.obj1_tight(newrow) and self.obj1_loose(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          self.fill_sys(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS')
          if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS0Jet')
          elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_sys(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS2JetVBF')

      if self.obj2_tight(newrow) and self.obj1_tight(newrow):
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
        if self.oppositesign(newrow):
          self.fill_sys(newrow, weight*mIso*tIso, 'TightOS')
          if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*mIso*tIso, 'TightOS0Jet')
          elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*mIso*tIso, 'TightOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
            self.fill_sys(newrow, weight*mIso*tIso, 'TightOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
            self.fill_sys(newrow, weight*mIso*tIso, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
