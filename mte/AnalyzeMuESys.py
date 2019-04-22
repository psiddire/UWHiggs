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
import FinalStateAnalysis.TagAndProbe.NvtxWeight as NvtxWeight
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


def transverseMass(myObj, myMET):
  totalEt = myObj.Et() + myMET.Et()
  totalPt = (myObj + myMET).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))


def collMass(myMuon, myMET, myEle):
  ptnu = abs(myMET.Pt() * math.cos(deltaPhi(myMET.Phi(), myEle.Phi())))
  visfrac = myEle.Pt()/(myEle.Pt() + ptnu)
  m_e_Mass = (myMuon + myEle).M() 
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
else:
  pucorrector = {'' : mcCorrections.make_puCorrector('singlem', None, 'DY'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlem', None, 'DY'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlem', None, 'DY')}


class AnalyzeMuESys(MegaBase):
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

    super(AnalyzeMuESys, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}

    self.DYweight = {
      0 : 2.666650438,
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
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 28 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 10 or abs(row.eEta) >= 2.4:
      return False
    return True


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20TightMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
 
 
  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  

  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def begin(self):
    folder = []
    vbffolder = []
    names = ['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet'] 
    vbfnames = ['TightOS2Jet', 'TightSS2Jet', 'TightOS2JetVBF', 'TightSS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'Rate0JetUp', 'Rate0JetDown', 'Rate1JetUp', 'Rate1JetDown', 'Shape0JetUp', 'Shape0JetDown', 'Shape1JetUp', 'Shape1JetDown', 'IsoUp', 'IsoDown', 'eesUp', 'eesDown', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'AbsoluteFlavMapUp', 'AbsoluteFlavMapDown', 'AbsoluteMPFBiasUp', 'AbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'TopptreweightUp', 'TopptreweightDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))

    for f in folder:
      self.book(f, "m_e_Mass", "Muon + Electron Mass", 30, 0, 300)
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 30, 0, 300)      

    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))

    for f in vbffolder:
      self.book(f, "m_e_Mass", "Muon + Electron Mass", 12, 0, 300)
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 12, 0, 300)


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms 
    histos[name+'/m_e_Mass'].Fill((myMuon + myEle).M() , weight)                                                                                                                                                                                            
    histos[name+'/m_e_CollinearMass'].Fill(collMass(myMuon, myMET, myEle), weight)


  def fill_categories(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS'+name)
    if njets==0:
      if transverseMass(myMuon, myMET) > 60 and deltaPhi(myEle.Phi(), myMET.Phi()) < 0.7 and deltaPhi(myEle.Phi(), myMuon.Phi()) > 2.5 and myMuon.Pt() > 30:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet'+name)
    elif njets==1:
      if transverseMass(myMuon, myMET) > 40 and deltaPhi(myEle.Phi(), myMET.Phi()) < 0.7 and deltaPhi(myEle.Phi(), myMuon.Phi()) > 1.0:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet'+name)
    elif njets==2 and mjj < 550:
      if transverseMass(myMuon, myMET) > 15 and deltaPhi(myEle.Phi(), myMET.Phi()) < 0.5:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet'+name)
    elif njets==2 and mjj > 550:
      if transverseMass(myMuon, myMET) > 15 and deltaPhi(myEle.Phi(), myMET.Phi()) < 0.3:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2JetVBF'+name)


  def fill_sscategories(self, row, weight, name=''):

    self.myMuon = ROOT.TLorentzVector()
    self.myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
      
    self.myEle = ROOT.TLorentzVector()
    self.myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

    self.myMET = ROOT.TLorentzVector()
    self.myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

    if self.is_mc:
      self.njets = getattr(row, 'jetVeto30')                                                                                                                                                                                                                              
      self.mjj = getattr(row, 'vbfMass') 
    else:
      self.njets = getattr(row, 'jetVeto30WoNoisyJets')                                                                                                                                                                                           
      self.mjj = getattr(row, 'vbfMassWoNoisyJets') 

    w3.var("njets").setVal(self.njets)
    w3.var("dR").setVal(deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta))
    w3.var("e_pt").setVal(row.ePt)
    w3.var("m_pt").setVal(row.mPt)
    osss = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss0rup = w3.function("em_qcd_osss_0jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss0rdown = w3.function("em_qcd_osss_0jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss0sup = w3.function("em_qcd_osss_0jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss0sdown = w3.function("em_qcd_osss_0jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss1rup = w3.function("em_qcd_osss_1jet_rateup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss1rdown = w3.function("em_qcd_osss_1jet_ratedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss1sup = w3.function("em_qcd_osss_1jet_shapeup").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osss1sdown = w3.function("em_qcd_osss_1jet_shapedown").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osssisoup = w3.function("em_qcd_osss_binned").getVal()*w3.function("em_qcd_extrap_uncert").getVal()*w3.function("em_qcd_extrap_uncert").getVal()
    osssisodown = w3.function("em_qcd_osss_binned").getVal()
          
    self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS')
    if self.njets==0:
      if transverseMass(self.myMuon, self.myMET) > 60 and deltaPhi(self.myEle.Phi(), self.myMET.Phi()) < 0.7 and deltaPhi(self.myEle.Phi(), self.myMuon.Phi()) > 2.5 and self.myMuon.Pt() > 30:
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS0Jet') 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss0rup, 'TightSS0Jet/Rate0JetUp')                                                                                                                                  
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss0rdown, 'TightSS0Jet/Rate0JetDown')                                                                                                                                                 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss0sup, 'TightSS0Jet/Shape0JetUp')                                                                                                                                                    
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss0sdown, 'TightSS0Jet/Shape0JetDown')                                                                                                                                                           
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS0Jet/Rate1JetUp')                                                                                                                                                         
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS0Jet/Rate1JetDown')                                                                                                                                            
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS0Jet/Shape1JetUp')                                                                                                                                                            
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS0Jet/Shape1JetDown')
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisoup, 'TightSS0Jet/IsoUp')
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisodown, 'TightSS0Jet/IsoDown')
    elif self.njets==1:
      if transverseMass(self.myMuon, self.myMET) > 40 and deltaPhi(self.myEle.Phi(), self.myMET.Phi()) < 0.7 and deltaPhi(self.myEle.Phi(), self.myMuon.Phi()) > 1.0:
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS1Jet') 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rup, 'TightSS1Jet/Rate1JetUp')                                                                                                                                                           
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rdown, 'TightSS1Jet/Rate1JetDown')                                                                                                                                                       
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sup, 'TightSS1Jet/Shape1JetUp')                                                                                                                                                         
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sdown, 'TightSS1Jet/Shape1JetDown')                                                                                                                                                            
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS1Jet/Rate0JetUp')                                                                                                                                                                     
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS1Jet/Rate0JetDown')                                                                                                                                                                         
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS1Jet/Shape0JetUp')                                                                                                                                                             
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS1Jet/Shape0JetDown')                                                                                                                                                              
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisoup, 'TightSS1Jet/IsoUp')                                                                                                                                                                 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisodown, 'TightSS1Jet/IsoDown')
    elif self.njets==2 and self.mjj < 550:
      if transverseMass(self.myMuon, self.myMET) > 15 and deltaPhi(self.myEle.Phi(), self.myMET.Phi()) < 0.5:
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2Jet') 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rup, 'TightSS2Jet/Rate1JetUp')                                                                                                                                                            
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rdown, 'TightSS2Jet/Rate1JetDown')                                                                                                                                                        
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sup, 'TightSS2Jet/Shape1JetUp')                                                                                                                                                           
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sdown, 'TightSS2Jet/Shape1JetDown')                                                                                                                                                    
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2Jet/Rate0JetUp')                                                                                                                                                                   
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2Jet/Rate0JetDown')                                                                                                                                                             
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2Jet/Shape0JetUp')                                                                                                                                                                   
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2Jet/Shape0JetDown')                                                                                                                                                              
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisoup, 'TightSS2Jet/IsoUp')                                                                                                                                                                
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisodown, 'TightSS2Jet/IsoDown') 
    elif self.njets==2 and self.mjj > 550:
      if transverseMass(self.myMuon, self.myMET) > 15 and deltaPhi(self.myEle.Phi(), self.myMET.Phi()) < 0.3:
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2JetVBF') 
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rup, 'TightSS2JetVBF/Rate1JetUp')                                                                                                                                                               
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1rdown, 'TightSS2JetVBF/Rate1JetDown')                                                                                                                                                          
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sup, 'TightSS2JetVBF/Shape1JetUp')                                                                                                                                                        
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss1sdown, 'TightSS2JetVBF/Shape1JetDown')                                                                                                                                                       
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2JetVBF/Rate0JetUp')                                                                                                                                                     
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2JetVBF/Rate0JetDown')                                                                                                                                                  
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2JetVBF/Shape0JetUp')                                                                                                                                                           
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osss, 'TightSS2JetVBF/Shape0JetDown')                                                                                                                                                     
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisoup, 'TightSS2JetVBF/IsoUp')                                                                                                                                                          
        self.fill_histos(self.myMuon, self.myMET, self.myEle, weight*osssisodown, 'TightSS2JetVBF/IsoDown') 


  def fill_sys(self, row, weight):

    self.myMuon = ROOT.TLorentzVector()
    self.tmpMuon = ROOT.TLorentzVector()
    self.myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
      
    self.myEle = ROOT.TLorentzVector()
    self.tmpEle = ROOT.TLorentzVector()
    self.myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

    self.myMET = ROOT.TLorentzVector()
    self.tmpMET = ROOT.TLorentzVector()
    self.myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

    self.njets = getattr(row, 'jetVeto30')
    self.mjj = getattr(row, 'vbfMass') 

    if self.is_mc:

      if self.is_recoilC and MetCorrection:
        sysMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
        self.myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight, '')

      if puweight==0:
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, 0, '/puUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, 0, '/puDown')
      else:
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 1.02, '/trUp')
      self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 0.98, '/trDown')

      if self.is_recoilC and MetCorrection:
        self.tmpMET.SetPtEtaPhiM(self.myMET.Pt(), 0, self.myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)), 0, 0, 0)
        if sysMet!=None:
          self.tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(self.myMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)), 0, 0, 1)
        if sysMet!=None:
          self.tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(self.myMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)), 0, 1, 0)
        if sysMet!=None:
          self.tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(self.myMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)), 0, 1, 1)
        if sysMet!=None:
          self.tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(self.myMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/recresoDown')

      if row.eEta < 1.479:
        self.myMETpx = self.myMET.Px() - 0.01 * self.myEle.Px()                                                                                                                                                                                                           
        self.myMETpy = self.myMET.Py() - 0.01 * self.myEle.Py()                                                                                                                                                                                                      
        self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))                                                                                                                                             
        self.tmpEle = self.myEle * ROOT.Double(1.01)
        self.fill_categories(self.myMuon, self.tmpMET, self.tmpEle, self.njets, self.mjj, weight, '/eesUp')
        self.myMETpx = self.myMET.Px() + 0.01 * self.myEle.Px()                                                                                                                                                                                                            
        self.myMETpy = self.myMET.Py() + 0.01 * self.myEle.Py()                                                                                                                                                                                                             
        self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))                                                                                                                                               
        self.tmpEle = self.myEle * ROOT.Double(0.99)
        self.fill_categories(self.myMuon, self.tmpMET, self.tmpEle, self.njets, self.mjj, weight, '/eesDown')
      else:
        self.myMETpx = self.myMET.Px() - 0.025 * self.myEle.Px()                                                                                                                                                                                                            
        self.myMETpy = self.myMET.Py() - 0.025 * self.myEle.Py()                                                                                                                                                                                                            
        self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))                                                                                                                                              
        self.tmpEle = self.myEle * ROOT.Double(1.025)
        self.fill_categories(self.myMuon, self.tmpMET, self.tmpEle, self.njets, self.mjj, weight, '/eesUp')
        self.myMETpx = self.myMET.Px() + 0.025 * self.myEle.Px()                                                                                                                                                                                                            
        self.myMETpy = self.myMET.Py() + 0.025 * self.myEle.Py()                                                                                                                                                                                                             
        self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))                                                                                                                                             
        self.tmpEle = self.myEle * ROOT.Double(0.975)
        self.fill_categories(self.myMuon, self.tmpMET, self.tmpEle, self.njets, self.mjj, weight, '/eesDown')

      self.myMETpx = self.myMET.Px() - 0.002 * self.myMuon.Px()
      self.myMETpy = self.myMET.Py() - 0.002 * self.myMuon.Py()
      self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))
      self.tmpMuon = self.myMuon * ROOT.Double(1.002)
      self.fill_categories(self.tmpMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/mesUp')

      self.myMETpx = self.myMET.Px() + 0.002 * self.myMuon.Px()                                                                                                                                                                                                      
      self.myMETpy = self.myMET.Py() + 0.002 * self.myMuon.Py()                                                                                                                                                                                                             
      self.tmpMET.SetPxPyPzE(self.myMETpx, self.myMETpy, 0, sqrt(self.myMETpx * self.myMETpx + self.myMETpy * self.myMETpy))                                                                                                                                                 
      self.tmpMuon = self.myMuon * ROOT.Double(0.998)
      self.fill_categories(self.tmpMuon, self.tmpMET, self.myEle, self.njets, self.mjj, weight, '/mesDown')

      if self.is_DY or self.is_DYlow:
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight*1.1, '/DYptreweightUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight*0.9, '/DYptreweightDown')

      if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
        topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight/topweight, '/TopptreweightDown')
      
      if not (self.is_recoilC and MetCorrection):
        self.myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight, '/UnclusteredEnUp')
        self.myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight, '/UnclusteredEnDown')

        jes = ['AbsoluteFlavMapUp', 'AbsoluteFlavMapDown', 'AbsoluteMPFBiasUp', 'AbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']

        for j in jes:
          self.myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j) , 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          if 'Jet' in j:
            self.njets = getattr(row, 'jetVeto30_'+j)
            self.mjj = getattr(row, 'vbfMass_'+j) 
          else:
            self.njets = getattr(row, 'jetVeto30_Jet'+j)                                                                                                                                                 
            self.mjj = getattr(row, 'vbfMass_Jet'+j) 
          self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight, '/'+j)

    else:
      self.njets = getattr(row, 'jetVeto30WoNoisyJets')                                                                                                                                                                                                                       
      self.mjj = getattr(row, 'vbfMassWoNoisyJets')
      self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight, '')
      if self.is_embed:
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 1.02, '/trUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 0.98, '/trDown')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 1.04, '/embtrUp')
        self.fill_categories(self.myMuon, self.myMET, self.myEle, self.njets, self.mjj, weight * 0.96, '/embtrDown')


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

      if deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      if self.is_mc and row.jetVeto30 > 2:
        continue
      
      if not self.is_mc and row.jetVeto30WoNoisyJets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue      

      #if self.is_DY or self.is_DYlow:
      #  if not bool(row.isZmumu or row.isZee):
      #    continue

      nbtag = row.bjetDeepCSVVeto20MediumWoNoisyJets
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
      if (not self.is_data and not self.is_embed and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue

      weight = 1.0
      if not self.is_data and not self.is_embed:
        w2.var("m_pt").setVal(row.mPt)
        w2.var("m_eta").setVal(row.mEta)
        mIso = w2.function("m_iso_kit_ratio").getVal()
        mID = w2.function("m_id_kit_ratio").getVal()
        tEff = w2.function("m_trg27_kit_data").getVal()/w2.function("m_trg27_kit_mc").getVal()
        w2.var("e_pt").setVal(row.ePt)
        w2.var("e_eta").setVal(row.eEta)
        eIso = w2.function("e_iso_kit_ratio").getVal()
        eID = w2.function("e_id80_kit_ratio").getVal()
        eTrk = w2.function("e_trk_ratio").getVal()
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*eID*eIso*eTrk

        if self.is_DY:
          w2.var("z_gen_mass").setVal(row.genMass)
          w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          w2.var("z_gen_mass").setVal(row.genMass)
          w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = w2.function("zptmass_weight_nom").getVal()
          weight = weight*11.47563472*dyweight
        if self.is_WG:
          weight = weight*3.094
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
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          topweight = topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*0.00117*topweight
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.00203

      if self.is_embed:
        we.var("gt_pt").setVal(row.mPt)
        we.var("gt_eta").setVal(row.mEta)
        msel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt_pt").setVal(row.ePt)
        we.var("gt_eta").setVal(row.eEta)
        esel = we.function("m_sel_idEmb_ratio").getVal()
        we.var("gt1_pt").setVal(row.mPt)
        we.var("gt1_eta").setVal(row.mEta)
        we.var("gt2_pt").setVal(row.ePt)
        we.var("gt2_eta").setVal(row.eEta)
        trgsel = we.function("m_sel_trg_ratio").getVal()
        we.var("m_pt").setVal(row.mPt)
        we.var("m_eta").setVal(row.mEta)
        we.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_iso_sf = we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = we.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = we.function("m_trg27_embed_kit_ratio").getVal()
        we.var("e_pt").setVal(row.ePt)
        we.var("e_eta").setVal(row.eEta)
        we.var("e_iso").setVal(row.eRelPFIsoRho)
        e_iso_sf = we.function("e_iso_binned_embed_kit_ratio").getVal()
        e_id_sf = we.function("e_id80_embed_kit_ratio").getVal()
        weight = weight*row.GenWeight*m_trg_sf*m_id_sf*m_iso_sf*msel*esel*trgsel*e_id_sf*e_iso_sf

      if self.obj2_iso(row) and self.obj1_iso(row):
        if self.oppositesign(row):
          self.fill_sys(row, weight)
        else:
          self.fill_sscategories(row, weight)


  def finish(self):
    self.write_histos()
