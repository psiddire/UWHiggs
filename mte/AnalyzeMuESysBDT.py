'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EMTree
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
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v1.root")
w1 = f1.Get("w")

f2 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
w2 = f2.Get("w")

f3 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v3.root")
w3 = f3.Get("w")

fe = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v17_5.root")
we = fe.Get("w")


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
  vm = ROOT.TLorentzVector()
  ve = ROOT.TLorentzVector()
  vm.SetPtEtaPhiM(row['mPt'], row['mEta'], row['mPhi'], row['mMass'])
  ve.SetPtEtaPhiM(row['ePt'], row['eEta'], row['ePhi'], row['eMass'])
  return (vm+ve).M()


def collMass(row):
  met = row['type1_pfMetEt']
  metPhi = row['type1_pfMetPhi']
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row['ePhi'])))
  visfrac = row['ePt']/(row['ePt']+ptnu)
  m_e_Mass = visibleMass(row)
  return (m_e_Mass/sqrt(visfrac))


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
elif bool('WJetsToLNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'W'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'W'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'W')}
elif bool('W1JetsToLNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'W1'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'W1'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'W1')}
elif bool('W2JetsToLNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'W2'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'W2'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'W2')}
elif bool('W3JetsToLNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'W3'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'W3'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'W3')}
elif bool('W4JetsToLNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'W4'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'W4'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'W4')}
elif bool('WGToLNuG' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'WG'),
                 'puUp' : mcCorrections.make_puCorrectorUp('singlem', None, 'WG'),
                 'puDown' : mcCorrections.make_puCorrectorDown('singlem', None, 'WG')}
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
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Wminusv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Wminusv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Wminusv2')}
elif bool('EWKWPlus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Wplusv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Wplusv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Wplusv2')}
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Zllv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Zllv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Zllv2')}
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'Znunuv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'Znunuv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'Znunuv2')}
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
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'GGHTTv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'GGHTTv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'GGHTTv2')}
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


class AnalyzeMuESysBDT(MegaBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_embed = target.startswith('embedded_')
    self.is_mc = not self.is_data and not self.is_embed
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_GluGlu = bool('GluGlu_LFV' in target)
    self.is_VBF = bool('VBF_LFV' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WG = bool('WGToLNuG' in target)
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
      self.MetSys = MEtSys("PFMEtSys_2017.root")
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")
    self.var_d_star =['mPt', 'ePt', 'm_e_collinearMass', 'dPhiMuMET', 'dPhiEMET', 'dPhiMuE', 'MTMuMET', 'MTEMET']
    self.xml_name = os.path.join(os.getcwd(), "bdtdata/dataset/weights/TMVAClassification_BDTG.weights.xml")
    self.functor = FunctorFromMVA('BDT method', self.xml_name, *self.var_d_star)

    super(AnalyzeMuESysBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
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

    self.DYweight = {
      0 : 2.667,#2.288666996,
      1 : 0.465803642,
      2 : 0.585042564,
      3 : 0.609127575,
      4 : 0.419146762
      }

    self.Wweight = {
      0 : 33.17540884,
      1 : 7.148659335,
      2 : 14.08112642,
      3 : 2.308770158,
      4 : 2.072164726
      }


  def oppositesign(self, row):
    if row['mCharge']*row['eCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['IsoMu27Pass']:
      return False
    return True


  def kinematics(self, row):
    if row['mPt'] < 28 or abs(row['mEta']) >= 2.4:#2.1  
      return False
    if row['ePt'] < 10 or abs(row['eEta']) >= 2.4:#bool(abs(row['eEta']) >= 2.3 or bool(abs(row['eEta']) > 1.4442 and abs(row['eEta']) < 1.566)):       
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20TightMVALTVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return (bool(row['mPFIDTight']) and bool(row['mPVDZ'] < 0.2) and bool(row['mPVDXY'] < 0.045))
 
 
  def obj1_iso(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.15)
  

  def obj2_iso(self, row):
    return bool(row['eRelPFIsoRho'] < 0.1)


  def obj2_id(self, row):
    return (bool(row['eMVANoisoWP80']) and bool(row['ePVDZ'] < 0.2) and bool(row['ePVDXY'] < 0.045) and bool(row['ePassesConversionVeto']) and bool(row['eMissingHits'] < 2))


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30MediumWoNoisyJets'] < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names = ['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet', 'TightOS2Jet', 'TightSS2Jet'] 
    vbfnames = ['TightOS2JetVBF', 'TightSS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'Rate0JetUp', 'Rate0JetDown', 'Rate1JetUp', 'Rate1JetDown', 'Shape0JetUp', 'Shape0JetDown', 'Shape1JetUp', 'Shape1JetDown', 'IsoUp', 'IsoDown', 'eesUp', 'eesDown', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'AbsoluteFlavMapUp', 'AbsoluteFlavMapDown', 'AbsoluteMPFBiasUp', 'AbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'TopptreweightUp', 'TopptreweightDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))

    for f in folder:
      self.book(f, "bdtDiscriminator", "BDT Discriminator", 10, -1.0, 1.0)      

    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))

    for f in vbffolder:
      self.book(f, "bdtDiscriminator", "BDT Discriminator", 10, -1.0, 1.0)

  def fill_histos(self, mva, weight, name=''):
    histos = self.histograms
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)

  def var_d(self, row):
    return {'mPt' : row['mPt'], 'ePt' : row['ePt'], 'm_e_collinearMass' : collMass(row), 'dPhiMuMET' : deltaPhi(row['mPhi'], row['type1_pfMetPhi']), 'dPhiEMET' : deltaPhi(row['ePhi'], row['type1_pfMetPhi']), 'dPhiMuE' : deltaPhi(row['ePhi'], row['mPhi']), 'MTMuMET' : transverseMass(row['mPt'], row['mEta'], row['mPhi'], row['mMass'], row['type1_pfMetEt'], row['type1_pfMetPhi']), 'MTEMET' : transverseMass(row['ePt'], row['eEta'], row['ePhi'], row['eMass'], row['type1_pfMetEt'], row['type1_pfMetPhi'])}

  def fill_sys(self, row, weight, name=''):
    if self.is_mc:
      if 'TightOS' in name:
        puweightUp = pucorrector['puUp'](row['nTruePU'])
        puweightDown = pucorrector['puDown'](row['nTruePU'])
        puweight = pucorrector[''](row['nTruePU'])

        MVA = self.functor(**self.var_d(row))
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
          self.fill_histos(MVA, weight*1.1, name+'/DYptreweightUp')
          self.fill_histos(MVA, weight*0.9, name+'/DYptreweightDown')

        if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
          topweight = topPtreweight(row['topQuarkPt1'], row['topQuarkPt2'])
          self.fill_histos(MVA, weight*2, name+'/TopptreweightUp')
          self.fill_histos(MVA, weight/topweight, name+'/TopptreweightDown')

        metrow = copy.deepcopy(row)
        if self.is_recoilC and MetCorrection:
          sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30WoNoisyJets'])), 0, 0, 0)
          if sysMet!=None:
            metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
            metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
          MVA = self.functor(**self.var_d(metrow))
          self.fill_histos(MVA, weight, name+'/recrespUp')
          sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30WoNoisyJets'])), 0, 0, 1)
          if sysMet!=None:
            metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
            metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
          MVA = self.functor(**self.var_d(metrow))
          self.fill_histos(MVA, weight, name+'/recrespDown')
          sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30WoNoisyJets'])), 0, 1, 0)
          if sysMet!=None:
            metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
            metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
          MVA = self.functor(**self.var_d(metrow))
          self.fill_histos(MVA, weight, name+'/recresoUp')
          sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30WoNoisyJets'])), 0, 1, 1)
          if sysMet!=None:
            metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
            metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
          MVA = self.functor(**self.var_d(metrow))
          self.fill_histos(MVA, weight, name+'/recresoDown')

        eesrow = copy.deepcopy(row)
        tmpept = eesrow['ePt']
        if eesrow['eEta'] < 1.479:
          eesrow['ePt'] = tmpept*1.01
          MVA = self.functor(**self.var_d(eesrow))
          self.fill_histos(MVA, weight, name+'/eesUp')
          eesrow['ePt'] = tmpept*0.99
          MVA = self.functor(**self.var_d(eesrow))
          self.fill_histos(MVA, weight, name+'/eesDown')
        else:
          eesrow['ePt'] = tmpept*1.025
          MVA = self.functor(**self.var_d(eesrow))
          self.fill_histos(MVA, weight, name+'/eesUp')
          eesrow['ePt'] = tmpept*0.975
          MVA = self.functor(**self.var_d(eesrow))
          self.fill_histos(MVA, weight, name+'/eesDown')

        mesrow = copy.deepcopy(row)
        tmpmpt = mesrow['mPt']
        mesrow['mPt'] = tmpmpt*1.002
        MVA = self.functor(**self.var_d(mesrow))
        self.fill_histos(MVA, weight, name+'/mesUp')
        mesrow['mPt'] = tmpmpt*0.998
        MVA = self.functor(**self.var_d(mesrow))
        self.fill_histos(MVA, weight, name+'/mesDown')
      
        if not (self.is_recoilC and MetCorrection):
          uesrow = copy.deepcopy(row)
          uesrow['type1_pfMetEt'] = uesrow['type1_pfMet_shiftedPt_UnclusteredEnUp']
          uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnUp']
          MVA = self.functor(**self.var_d(uesrow))
          self.fill_histos(MVA, weight, name+'/UnclusteredEnUp')
          uesrow['type1_pfMetEt'] = uesrow['type1_pfMet_shiftedPt_UnclusteredEnDown']
          uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnDown']
          MVA = self.functor(**self.var_d(uesrow))
          self.fill_histos(MVA, weight, name+'/UnclusteredEnDown')

          jesrow = copy.deepcopy(row)
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/AbsoluteFlavMapUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/AbsoluteFlavMapDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/AbsoluteMPFBiasUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/AbsoluteMPFBiasDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetAbsoluteScaleUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetAbsoluteScaleDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetAbsoluteStatUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetAbsoluteStatDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetFlavorQCDUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetFlavorQCDUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetFlavorQCDDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetFlavorQCDDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetFragmentationUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetFragmentationUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetFragmentationDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetFragmentationDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpDataMCUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpDataMCDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtBBUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtBBDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtEC1Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtEC1Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtEC2Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtEC2Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtHFUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtHFDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtRefUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetPileUpPtRefDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeFSRUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeFSRUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeFSRDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeFSRDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJEREC1Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJEREC1Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJEREC2Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJEREC2Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJERHFUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeJERHFDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtBBUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtBBUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtBBDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtBBDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtEC1Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtEC1Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Up']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Up']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtEC2Up')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Down']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Down']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtEC2Down')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtHFUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtHFUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativePtHFDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativePtHFDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatECUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatECUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatECDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatECDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatFSRUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatFSRDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatHFUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeStatHFDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetSinglePionECALUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetSinglePionECALUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetSinglePionECALDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetSinglePionECALDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetSinglePionHCALUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetSinglePionHCALDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetTimePtEtaUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetTimePtEtaUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetTimePtEtaDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetTimePtEtaDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeBalUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeBalUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeBalDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeBalDown')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeSampleUp']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleUp']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeSampleUp')
          jesrow['type1_pfMetEt'] = jesrow['type1_pfMet_shiftedPt_JetRelativeSampleDown']
          jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleDown']
          MVA = self.functor(**self.var_d(jesrow))
          self.fill_histos(MVA, weight, name+'/JetRelativeSampleDown')

      else:
        MVA = self.functor(**self.var_d(row))
        self.fill_histos(MVA, weight, name)
        w3.var("njets").setVal(row['jetVeto30WoNoisyJets'])
        w3.var("dR").setVal(deltaR(row['ePhi'], row['mPhi'], row['eEta'], row['mEta']))
        w3.var("e_pt").setVal(row['ePt'])
        w3.var("m_pt").setVal(row['mPt'])
        osss = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
        if row['jetVeto30WoNoisyJets']==0:
          osss0rup = w3.function("em_qcd_osss_0jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0rdown = w3.function("em_qcd_osss_0jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0sup = w3.function("em_qcd_osss_0jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0sdown = w3.function("em_qcd_osss_0jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          self.fill_histos(MVA, weight*osss0rup/osss, name+'/Rate0JetUp')
          self.fill_histos(MVA, weight*osss0rdown/osss, name+'/Rate0JetDown')
          self.fill_histos(MVA, weight*osss0sup/osss, name+'/Shape0JetUp')
          self.fill_histos(MVA, weight*osss0sdown/osss, name+'/Shape0JetDown')
          self.fill_histos(MVA, weight, name+'/Rate1JetUp')
          self.fill_histos(MVA, weight, name+'/Rate1JetDown')
          self.fill_histos(MVA, weight, name+'/Shape1JetUp')
          self.fill_histos(MVA, weight, name+'/Shape1JetDown')
        else:
          osss1rup = w3.function("em_qcd_osss_1jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1rdown = w3.function("em_qcd_osss_1jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1sup = w3.function("em_qcd_osss_1jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1sdown = w3.function("em_qcd_osss_1jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          self.fill_histos(MVA, weight*osss1rup/osss, name+'/Rate1JetUp')
          self.fill_histos(MVA, weight*osss1rdown/osss, name+'/Rate1JetDown')
          self.fill_histos(MVA, weight*osss1sup/osss, name+'/Shape1JetUp')
          self.fill_histos(MVA, weight*osss1sdown/osss, name+'/Shape1JetDown')
          self.fill_histos(MVA, weight, name+'/Rate0JetUp')
          self.fill_histos(MVA, weight, name+'/Rate0JetDown')
          self.fill_histos(MVA, weight, name+'/Shape0JetUp')
          self.fill_histos(MVA, weight, name+'/Shape0JetDown')
        osssisoup = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
        osssisodown = w3.function("em_qcd_osss_binned").getVal()
        self.fill_histos(MVA, weight*osssisoup/osss, name+'/IsoUp')
        self.fill_histos(MVA, weight*osssisodown/osss, name+'/IsoDown')

    else:
      MVA = self.functor(**self.var_d(row))
      self.fill_histos(MVA, weight, name)
      if 'TightSS' in name:
        w3.var("njets").setVal(row['jetVeto30WoNoisyJets'])
        w3.var("dR").setVal(deltaR(row['ePhi'], row['mPhi'], row['eEta'], row['mEta']))
        w3.var("e_pt").setVal(row['ePt'])
        w3.var("m_pt").setVal(row['mPt'])
        osss = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
        if row['jetVeto30WoNoisyJets']==0:
          osss0rup = w3.function("em_qcd_osss_0jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0rdown = w3.function("em_qcd_osss_0jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0sup = w3.function("em_qcd_osss_0jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss0sdown = w3.function("em_qcd_osss_0jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          self.fill_histos(MVA, weight*osss0rup/osss, name+'/Rate0JetUp')
          self.fill_histos(MVA, weight*osss0rdown/osss, name+'/Rate0JetDown')
          self.fill_histos(MVA, weight*osss0sup/osss, name+'/Shape0JetUp')
          self.fill_histos(MVA, weight*osss0sdown/osss, name+'/Shape0JetDown')
          self.fill_histos(MVA, weight, name+'/Rate1JetUp')
          self.fill_histos(MVA, weight, name+'/Rate1JetDown')
          self.fill_histos(MVA, weight, name+'/Shape1JetUp')
          self.fill_histos(MVA, weight, name+'/Shape1JetDown')
        else:
          osss1rup = w3.function("em_qcd_osss_1jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1rdown = w3.function("em_qcd_osss_1jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1sup = w3.function("em_qcd_osss_1jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          osss1sdown = w3.function("em_qcd_osss_1jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
          self.fill_histos(MVA, weight*osss1rup/osss, name+'/Rate1JetUp')
          self.fill_histos(MVA, weight*osss1rdown/osss, name+'/Rate1JetDown')
          self.fill_histos(MVA, weight*osss1sup/osss, name+'/Shape1JetUp')
          self.fill_histos(MVA, weight*osss1sdown/osss, name+'/Shape1JetDown')
          self.fill_histos(MVA, weight, name+'/Rate0JetUp')
          self.fill_histos(MVA, weight, name+'/Rate0JetDown')
          self.fill_histos(MVA, weight, name+'/Shape0JetUp')
          self.fill_histos(MVA, weight, name+'/Shape0JetDown')
        osssisoup = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
        osssisodown = w3.function("em_qcd_osss_binned").getVal()
        self.fill_histos(MVA, weight*osssisoup/osss, name+'/IsoUp')
        self.fill_histos(MVA, weight*osssisodown/osss, name+'/IsoDown')

      if self.is_embed:
        if 'TightOS' in name:
          self.fill_histos(MVA, weight * 1.02, name+'/trUp')
          self.fill_histos(MVA, weight * 0.98, name+'/trDown')
          self.fill_histos(MVA, weight * 1.04, name+'/embtrUp')
          self.fill_histos(MVA, weight * 0.96, name+'/embtrDown')


  def copyrow(self, row):
    subtemp = {}
    tmpMetEt = row.type1_pfMetEt
    tmpMetPhi = row.type1_pfMetPhi

    if self.is_recoilC and MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])
      subtemp["genpX"] = row.genpX
      subtemp["genpY"] = row.genpY
      subtemp["vispX"] = row.vispX
      subtemp["vispY"] = row.vispY

    subtemp["type1_pfMetEt"] = tmpMetEt
    subtemp["type1_pfMetPhi"] = tmpMetPhi

    if self.is_DY or self.is_DYlow:
      subtemp["isZmumu"] = row.isZmumu
      subtemp["isZee"] = row.isZee

    subtemp["ePt"] = row.ePt
    subtemp["eEta"] = row.eEta
    subtemp["ePhi"] = row.ePhi
    subtemp["eMass"] = row.eMass
    subtemp["eCharge"] = row.eCharge
    subtemp["mPt"] = row.mPt
    subtemp["mEta"] = row.mEta
    subtemp["mPhi"] = row.mPhi
    subtemp["mMass"] = row.mMass
    subtemp["mCharge"] = row.mCharge
    subtemp['IsoMu27Pass'] = row.IsoMu27Pass
    subtemp["mPFIDTight"] = row.mPFIDTight
    subtemp["mPFIDMedium"] = row.mPFIDMedium
    subtemp["mRelPFIsoDBDefaultR04"] = row.mRelPFIsoDBDefaultR04
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20TightMVALTVtx"] = row.tauVetoPt20TightMVALTVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["eMVANoisoWP80"] = row.eMVANoisoWP80
    subtemp["eMVANoisoWP90"] = row.eMVANoisoWP90
    subtemp["eRelPFIsoRho"] = row.eRelPFIsoRho
    subtemp["ePVDZ"] = row.ePVDZ
    subtemp["mPVDZ"] = row.mPVDZ
    subtemp["ePVDXY"] = row.ePVDXY
    subtemp["mPVDXY"] = row.mPVDXY
    subtemp["ePassesConversionVeto"] = row.ePassesConversionVeto
    subtemp["eMissingHits"] = row.eMissingHits    
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["jetVeto30WoNoisyJets"] = row.jetVeto30WoNoisyJets
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["bjetDeepCSVVeto20MediumWoNoisyJets"] = row.bjetDeepCSVVeto20MediumWoNoisyJets
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb1eta"] = row.jb1eta
    subtemp["vbfMass"] = row.vbfMass
    subtemp["vbfMassWoNoisyJets"] = row.vbfMassWoNoisyJets
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["topQuarkPt1"] = row.topQuarkPt1
    subtemp["topQuarkPt2"] = row.topQuarkPt2
    subtemp["Flag_goodVertices"] = row.Flag_goodVertices
    subtemp["Flag_globalTightHalo2016Filter"] = row.Flag_globalTightHalo2016Filter
    subtemp["Flag_HBHENoiseFilter"] = row.Flag_HBHENoiseFilter
    subtemp["Flag_HBHENoiseIsoFilter"] = row.Flag_HBHENoiseIsoFilter
    subtemp["Flag_EcalDeadCellTriggerPrimitiveFilter"] = row.Flag_EcalDeadCellTriggerPrimitiveFilter
    subtemp["Flag_BadPFMuonFilter"] = row.Flag_BadPFMuonFilter
    subtemp["Flag_BadChargedCandidateFilter"] = row.Flag_BadChargedCandidateFilter
    subtemp["Flag_eeBadScFilter"] = row.Flag_eeBadScFilter
    subtemp["Flag_ecalBadCalibFilter"] = row.Flag_ecalBadCalibFilter
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

      if deltaR(nrow['ePhi'], nrow['mPhi'], nrow['eEta'], nrow['mEta']) < 0.3:
        continue

      if nrow['jetVeto30WoNoisyJets'] > 2:
        continue

      if not self.obj1_id(nrow):
        continue

      if not self.obj2_id(nrow):
        continue

      if not self.vetos(nrow):
        continue      

      if self.is_DY or self.is_DYlow:
        if not bool(nrow['isZmumu'] or nrow['isZee']):
          continue

      nbtag = nrow['bjetDeepCSVVeto20MediumWoNoisyJets']
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
            z[i]=temp[i]["eRelPFIsoRho"]
            w[i]=temp[i]["ePt"]
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
        w2.var("m_pt").setVal(newrow['mPt'])
        w2.var("m_eta").setVal(newrow['mEta'])
        mIso = w2.function("m_iso_kit_ratio").getVal()
        mID = w2.function("m_id_kit_ratio").getVal()
        tEff = w2.function("m_trg27_kit_data").getVal()/w2.function("m_trg27_kit_mc").getVal()
        w2.var("e_pt").setVal(newrow['ePt'])
        w2.var("e_eta").setVal(newrow['eEta'])
        eIso = w2.function("e_iso_kit_ratio").getVal()
        eID = w2.function("e_id80_kit_ratio").getVal()
        eTrk = w2.function("e_trk_ratio").getVal()
        weight = weight*newrow['GenWeight']*pucorrector[''](newrow['nTruePU'])*tEff*mID*mIso*eID*eIso*eTrk

        if self.is_DY:
          w2.var("z_gen_mass").setVal(newrow['genMass'])
          w2.var("z_gen_pt").setVal(newrow['genpT'])
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          w2.var("z_gen_mass").setVal(newrow['genMass'])
          w2.var("z_gen_pt").setVal(newrow['genpT'])
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*11.47563472*dyweight
        if self.is_WG:
          weight = weight*3.094
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
          weight = weight*0.343
        if self.is_EWKZToLL:
          weight = weight*0.175
        if self.is_EWKZToNuNu:
          weight = weight*0.140
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
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.00117*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.00203

      if self.is_embed:
        we.var("gt_pt").setVal(newrow['mPt'])
        we.var("gt_eta").setVal(newrow['mEta'])
        msel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt_pt").setVal(newrow['ePt'])
        we.var("gt_eta").setVal(newrow['eEta'])
        esel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt1_pt").setVal(newrow['mPt'])
        we.var("gt1_eta").setVal(newrow['mEta'])
        we.var("gt2_pt").setVal(newrow['ePt'])
        we.var("gt2_eta").setVal(newrow['eEta'])
        trgsel = we.function("m_sel_trg_ratio").getVal()
        we.var("m_pt").setVal(newrow['mPt'])
        we.var("m_eta").setVal(newrow['mEta'])
        we.var("m_iso").setVal(newrow['mRelPFIsoDBDefaultR04'])
        m_iso_sf = we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = we.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = we.function("m_trg27_embed_kit_ratio").getVal()
        we.var("e_pt").setVal(newrow['ePt'])
        we.var("e_eta").setVal(newrow['eEta'])
        we.var("e_iso").setVal(newrow['eRelPFIsoRho'])
        e_iso_sf = we.function("e_iso_binned_embed_kit_ratio").getVal()
        e_id_sf = we.function("e_id80_embed_kit_ratio").getVal()
        weight = weight*newrow['GenWeight']*m_trg_sf*m_id_sf*m_iso_sf*msel*esel*trgsel*e_id_sf*e_iso_sf

      w3.var("njets").setVal(newrow['jetVeto30WoNoisyJets'])
      w3.var("dR").setVal(deltaR(nrow['ePhi'], nrow['mPhi'], nrow['eEta'], nrow['mEta']))
      w3.var("e_pt").setVal(newrow['ePt'])
      w3.var("m_pt").setVal(newrow['mPt'])
      osss = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()

      if self.obj2_iso(newrow) and self.obj1_iso(newrow) and transverseMass(newrow['ePt'], newrow['eEta'], newrow['ePhi'], newrow['eMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 60:
        if self.oppositesign(newrow):
          self.fill_sys(newrow, weight, 'TightOS')
          if newrow['jetVeto30WoNoisyJets']==0:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.7 and deltaPhi(newrow['ePhi'], newrow['mPhi']) > 2.5 and newrow['mPt'] > 30:
            self.fill_sys(newrow, weight, 'TightOS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 40  and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.7 and deltaPhi(newrow['ePhi'], newrow['mPhi']) > 1.0:
            self.fill_sys(newrow, weight, 'TightOS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 15 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.5:
            self.fill_sys(newrow, weight, 'TightOS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 15 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.3:# and deltaEta(newrow['eEta'], newrow['mEta']) < 2.0:
            self.fill_sys(newrow, weight, 'TightOS2JetVBF')
        if not self.oppositesign(newrow):
          self.fill_sys(newrow, weight*osss, 'TightSS')
          if newrow['jetVeto30WoNoisyJets']==0:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 60 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.7 and deltaPhi(newrow['ePhi'], newrow['mPhi']) > 2.5 and newrow['mPt'] > 30:
            self.fill_sys(newrow, weight*osss, 'TightSS0Jet')
          elif newrow['jetVeto30WoNoisyJets']==1:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 40  and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.7 and deltaPhi(newrow['ePhi'], newrow['mPhi']) > 1.0:
            self.fill_sys(newrow, weight*osss, 'TightSS1Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] < 550:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 15 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.5:
            self.fill_sys(newrow, weight*osss, 'TightSS2Jet')
          elif newrow['jetVeto30WoNoisyJets']==2 and newrow['vbfMassWoNoisyJets'] > 550:
            #if transverseMass(newrow['mPt'], newrow['mEta'], newrow['mPhi'], newrow['mMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) > 15 and deltaPhi(newrow['ePhi'], newrow['type1_pfMetPhi']) < 0.3:# and deltaEta(newrow['eEta'], newrow['mEta']) < 2.0:
            self.fill_sys(newrow, weight*osss, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
