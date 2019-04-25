'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import ETauTree
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
  vobj1.SetPtEtaPhiM(row['ePt'], row['eEta'], row['ePhi'], row['eMass'])
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
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY')}
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY10'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY10'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY10')}
elif bool('DY1JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY1'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY1'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY1')}
elif bool('DY2JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY2')}
elif bool('DY3JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY3'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY3'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY3')}
elif bool('DY4JetsToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY4'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY4'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY4')}
elif bool('WW_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'WW'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'WW'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'WW')}
elif bool('WZ_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'WZ'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'WZ'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'WZ')}
elif bool('ZZ_TuneCP5' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'ZZ'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'ZZ'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'ZZ')}
elif bool('EWKWMinus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'Wminusv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'Wminusv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'Wminusv2')}
elif bool('EWKWPlus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'Wplusv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'Wplusv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'Wplusv2')}
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'Zllv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'Zllv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'Zllv2')}
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'Znunuv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'Znunuv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'Znunuv2')}
elif bool('ZHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'ZHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'ZHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'ZHTT')}
elif bool('ttHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'ttH'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'ttH'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'ttH')}
elif bool('Wminus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'WminusHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'WminusHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'WminusHTT')}
elif bool('Wplus' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'WplusHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'WplusHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'WplusHTT')}
elif bool('ST_t-channel_antitop' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'STtantitop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'STtantitop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'STtantitop')}
elif bool('ST_t-channel_top' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'STttop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'STttop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'STttop')}
elif bool('ST_tW_antitop' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'STtWantitop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'STtWantitop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'STtWantitop')}
elif bool('ST_tW_top' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'STtWtop'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'STtWtop'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'STtWtop')}
elif bool('TTTo2L2Nu' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'TTTo2L2Nu'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'TTTo2L2Nu'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'TTTo2L2Nu')}
elif bool('TTToHadronic' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'TTToHadronic'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'TTToHadronic'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'TTToHadronic')}
elif bool('TTToSemiLeptonic' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'TTToSemiLeptonic'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'TTToSemiLeptonic'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'TTToSemiLeptonic')}
elif bool('VBFHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'VBFHTT'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'VBFHTT'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'VBFHTT')}
elif bool('VBF_LFV_HToETau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'VBFHET'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'VBFHET'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'VBFHET')}
elif bool('GluGluHToTauTau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'GGHTTv2'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'GGHTTv2'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'GGHTTv2')}
elif bool('GluGlu_LFV_HToETau' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'GGHET'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'GGHET'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'GGHET')}
elif bool('QCD' in target):
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'QCD'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'QCD'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'QCD')}
else:
  pucorrector = {'' : mcCorrections.make_puCorrector('singlee', None, 'DY'),
                 'puUp': mcCorrections.make_puCorrectorUp('singlee', None, 'DY'),
                 'puDown': mcCorrections.make_puCorrectorDown('singlee', None, 'DY')}


class AnalyzeETauSys(MegaBase):
  tree = 'et/final/Ntuple'

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

    super(AnalyzeETauSys, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


    self.fakeRate = mcCorrections.fakerate_weight
    self.DYreweight1D = mcCorrections.DYreweight1D
    self.DYreweight = mcCorrections.DYreweight

    self.DYweight = {
      0 : 2.288666996,
      1 : 0.465803642,
      2 : 0.585042564,
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
    if row['eCharge']*row['tCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['Ele35WPTightPass']:
      return False
    return True


  def kinematics(self, row):
    if row['ePt'] < 36 or abs(row['eEta']) >= 2.1:
      return False
    if row['tPt'] < 30 or abs(row['tEta']) >= 2.3:
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20TightMVALTVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return bool(row['eMVANoisoWP80'])
 
 
  def obj1_tight(self, row):
    return bool(row['eRelPFIsoRho'] < 0.15)
  

  def obj1_loose(self, row):
    return bool(row['eRelPFIsoRho'] < 0.25)

  
  def obj2_id(self, row):
    return bool(row['tDecayModeFinding'] > 0.5) and bool(row['tAgainstElectronTightMVA6'] > 0.5) and bool(row['tAgainstMuonLoose3'] > 0.5)


  def obj2_tight(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTTight'] > 0.5)#VTight


  def obj2_loose(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTLoose'] > 0.5)


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30Medium'] < 0.5)


  def dielectronveto(self, row):
    return bool(row['dielectronVeto'] < 0.5)


  def begin(self):
    folder = []
    vbffolder = []
    names = ['TauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'TightOS2Jet'] 
    vbfnames = ['TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'embtrUp', 'embtrDown', 'embtrkUp', 'embtrkDown', 'mtfakeUp', 'mtfakeDown', 'etfakeUp', 'etfakeDown', 'etefakeUp', 'etefakeDown', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'eesUp', 'eesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'AbsoluteFlavMapUp', 'AbsoluteFlavMapDown', 'AbsoluteMPFBiasUp', 'AbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']#'TopptreweightUp', 'TopptreweightDown'
    fakes = ['TauLooseOS/TauFakeUp', 'TauLooseOS0Jet/TauFakeUp', 'TauLooseOS1Jet/TauFakeUp', 'TauLooseOS2Jet/TauFakeUp', 'TauLooseOS/TauFakeDown', 'TauLooseOS0Jet/TauFakeDown', 'TauLooseOS1Jet/TauFakeDown', 'TauLooseOS2Jet/TauFakeDown']
    vbffakes = ['TauLooseOS2JetVBF/TauFakeUp', 'TauLooseOS2JetVBF/TauFakeDown']
    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for fak in fakes:
      folder.append(fak)
    for f in folder:
      self.book(f, "e_t_Mass", "Electron + Tau Mass", 30, 0, 300)
      self.book(f, "e_t_CollinearMass", "Electron + Tau Collinear Mass", 30, 0, 300)      
    for tuple_path_vbf in itertools.product(vbfnames, sys):
      vbffolder.append(os.path.join(*tuple_path_vbf))
    for fak in vbffakes:
      vbffolder.append(fak)
    for f in vbffolder:
      self.book(f, "e_t_Mass", "Electron + Tau Mass", 15, 0, 300)
      self.book(f, "e_t_CollinearMass", "Electron + Tau Collinear Mass", 15, 0, 300)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/e_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/e_t_CollinearMass'].Fill(collMass(row), weight)

  def fill_sys(self, row, weight, name=''):
    if self.is_mc:
      puweightUp = pucorrector['puUp'](row['nTruePU'])
      puweightDown = pucorrector['puDown'](row['nTruePU'])
      puweight = pucorrector[''](row['nTruePU'])
      self.fill_histos(row, weight, name)
      if puweight==0:
        self.fill_histos(row, 0, name+'/puUp')
        self.fill_histos(row, 0, name+'/puDown')
      else:
        self.fill_histos(row, weight * puweightUp/puweight, name+'/puUp')
        self.fill_histos(row, weight * puweightDown/puweight, name+'/puDown')
      self.fill_histos(row, weight * 1.02, name+'/trUp')
      self.fill_histos(row, weight * 0.98, name+'/trDown')

      if row['tZTTGenMatching']==2 or row['tZTTGenMatching']==4:
        if abs(row['tEta']) < 0.4:
          self.fill_histos(row, weight * 1.11/1.06, name+'/mtfakeUp')
          self.fill_histos(row, weight * 1.01/1.06, name+'/mtfakeDown')
        elif abs(row['tEta']) < 0.8:
          self.fill_histos(row, weight * 1.06/1.02, name+'/mtfakeUp')
          self.fill_histos(row, weight * 0.98/1.02, name+'/mtfakeDown')
        elif abs(row['tEta']) < 1.2:
          self.fill_histos(row, weight * 1.14/1.10, name+'/mtfakeUp')
          self.fill_histos(row, weight * 1.06/1.10, name+'/mtfakeDown')
        elif abs(row['tEta']) < 1.7:
          self.fill_histos(row, weight * 1.21/1.03, name+'/mtfakeUp')
          self.fill_histos(row, weight * 0.85/1.03, name+'/mtfakeDown')
        else:
          self.fill_histos(row, weight * 2.29/1.94, name+'/mtfakeUp')
          self.fill_histos(row, weight * 1.59/1.94, name+'/mtfakeDown')
        self.fill_histos(row, weight, name+'/etfakeUp')
        self.fill_histos(row, weight, name+'/etfakeDown')
      elif row['tZTTGenMatching']==1 or row['tZTTGenMatching']==3:
        if abs(row['tEta']) < 1.46:
          self.fill_histos(row, weight * 2.00/1.80, name+'/etfakeUp')
          self.fill_histos(row, weight * 1.60/1.80, name+'/etfakeDown')
        elif abs(row['tEta']) > 1.558:
          self.fill_histos(row, weight * 2.13/1.53, name+'/etfakeUp')
          self.fill_histos(row, weight * 0.93/1.53, name+'/etfakeDown')
        self.fill_histos(row, weight, name+'/mtfakeUp')
        self.fill_histos(row, weight, name+'/mtfakeDown')
      else:
        self.fill_histos(row, weight, name+'/etfakeUp')
        self.fill_histos(row, weight, name+'/etfakeDown')
        self.fill_histos(row, weight, name+'/mtfakeUp')
        self.fill_histos(row, weight, name+'/mtfakeDown')
          
      metrow = copy.deepcopy(row)
      if self.is_recoilC and MetCorrection:
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 0, 0)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        self.fill_histos(metrow, weight, name+'/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 0, 1)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        self.fill_histos(metrow, weight, name+'/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 1, 0)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        self.fill_histos(metrow, weight, name+'/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(row['type1_pfMetEt']*math.cos(row['type1_pfMetPhi']), row['type1_pfMetEt']*math.sin(row['type1_pfMetPhi']), row['genpX'], row['genpY'], row['vispX'], row['vispY'], int(round(row['jetVeto30'])), 0, 1, 1)
        if sysMet!=None:
          metrow['type1_pfMetEt'] = math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1])
          metrow['type1_pfMetPhi'] = math.atan2(sysMet[1], sysMet[0])
        self.fill_histos(metrow, weight, name+'/recresoDown')

      ftesrow = copy.deepcopy(row)
      if ftesrow['tZTTGenMatching']==1 or ftesrow['tZTTGenMatching']==3:
        tmptpt = ftesrow['tPt']
        if ftesrow['tDecayMode'] == 0 or ftesrow['tDecayMode'] == 1:
          ftesrow['tPt'] = tmptpt * 1.007
          self.fill_histos(ftesrow, weight, name+'/etefakeUp')
          ftesrow['tPt'] = tmptpt * 0.993
          self.fill_histos(ftesrow, weight, name+'/etefakeDown')
        else:
          self.fill_histos(ftesrow, weight, name+'/etefakeUp')
          self.fill_histos(ftesrow, weight, name+'/etefakeDown')
      else:
        self.fill_histos(ftesrow, weight, name+'/etefakeUp')
        self.fill_histos(ftesrow, weight, name+'/etefakeDown')

      eesrow = copy.deepcopy(row)
      tmpmpt = eesrow['ePt']
      if eesrow['eEta'] < 1.479:
        eesrow['ePt'] = tmpmpt*1.01
        self.fill_histos(eesrow, weight, name+'/eesUp')
        eesrow['ePt'] = tmpmpt*0.99
        self.fill_histos(eesrow, weight, name+'/eesDown')
      else:
        eesrow['ePt'] = tmpmpt*1.025
        self.fill_histos(eesrow, weight, name+'/eesUp')
        eesrow['ePt'] = tmpmpt*0.975
        self.fill_histos(eesrow, weight, name+'/eesDown')

      if bool(not self.is_DY and not self.is_DYlow):
        scalerow = copy.deepcopy(row)
        normtPt = scalerow['tPt']
        normmet = scalerow['type1_pfMetEt']
        if row['tZTTGenMatching']==5:
          if scalerow['tDecayMode']==0:
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
          elif scalerow['tDecayMode']==1:
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
          elif scalerow['tDecayMode']==10:
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            scalerow['tPt'] = normtPt * 1.009
            scalerow['type1_pfMetEt'] = normmet - 0.009 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            scalerow['tPt'] = normtPt * 0.991
            scalerow['type1_pfMetEt'] = normmet + 0.009 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
          else:
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
        else:
          self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
          self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
          self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM10Down')

      if self.is_DY or self.is_DYlow:
        self.fill_histos(row, weight*1.1, name+'/DYptreweightUp')
        self.fill_histos(row, weight*0.9, name+'/DYptreweightDown')

      #if self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic:
      #  topweight = topPtreweight(row['topQuarkPt1'], row['topQuarkPt2'])
      #  self.fill_histos(row, weight*2, name+'/TopptreweightUp')
      #  self.fill_histos(row, weight/topweight, name+'/TopptreweightDown')
      
      if not (self.is_recoilC and MetCorrection):
        uesrow = copy.deepcopy(row)
        uesrow['type1_pfMetEt'] = self.metTauC(uesrow['tPtInitial'], uesrow['tDecayMode'], uesrow['tZTTGenMatching'], uesrow['type1_pfMet_shiftedPt_UnclusteredEnUp'])
        uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnUp']
        self.fill_histos(uesrow, weight, name+'/UnclusteredEnUp')
        uesrow['type1_pfMetEt'] = self.metTauC(uesrow['tPtInitial'], uesrow['tDecayMode'], uesrow['tZTTGenMatching'], uesrow['type1_pfMet_shiftedPt_UnclusteredEnDown'])
        uesrow['type1_pfMetPhi'] = uesrow['type1_pfMet_shiftedPhi_UnclusteredEnDown']
        self.fill_histos(uesrow, weight, name+'/UnclusteredEnDown')

        jesrow = copy.deepcopy(row)
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapUp']
        self.fill_histos(jesrow, weight, name+'/AbsoluteFlavMapUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteFlavMapDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteFlavMapDown']
        self.fill_histos(jesrow, weight, name+'/AbsoluteFlavMapDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp']
        self.fill_histos(jesrow, weight, name+'/AbsoluteMPFBiasUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_AbsoluteMPFBiasDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown']
        self.fill_histos(jesrow, weight, name+'/AbsoluteMPFBiasDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleUp']
        self.fill_histos(jesrow, weight, name+'/JetAbsoluteScaleUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteScaleDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteScaleDown']
        self.fill_histos(jesrow, weight, name+'/JetAbsoluteScaleDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatUp']
        self.fill_histos(jesrow, weight, name+'/JetAbsoluteStatUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetAbsoluteStatDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetAbsoluteStatDown']
        self.fill_histos(jesrow, weight, name+'/JetAbsoluteStatDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFlavorQCDUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDUp']
        self.fill_histos(jesrow, weight, name+'/JetFlavorQCDUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFlavorQCDDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFlavorQCDDown']
        self.fill_histos(jesrow, weight, name+'/JetFlavorQCDDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFragmentationUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationUp']
        self.fill_histos(jesrow, weight, name+'/JetFragmentationUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetFragmentationDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetFragmentationDown']
        self.fill_histos(jesrow, weight, name+'/JetFragmentationDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCUp']
        self.fill_histos(jesrow, weight, name+'/JetPileUpDataMCUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpDataMCDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpDataMCDown']
        self.fill_histos(jesrow, weight, name+'/JetPileUpDataMCDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBUp']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtBBUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtBBDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtBBDown']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtBBDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Up']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtEC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC1Down']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtEC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Up']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtEC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtEC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtEC2Down']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtEC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFUp']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtHFDown']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefUp']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtRefUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetPileUpPtRefDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetPileUpPtRefDown']
        self.fill_histos(jesrow, weight, name+'/JetPileUpPtRefDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeFSRUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeFSRUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeFSRDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeFSRDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeFSRDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Up']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJEREC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC1Down']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJEREC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Up']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJEREC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJEREC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJEREC2Down']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJEREC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJERHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeJERHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeJERHFDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeJERHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtBBUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtBBUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtBBDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtBBDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtBBDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Up']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtEC1Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC1Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC1Down']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtEC1Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Up'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Up']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtEC2Up')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtEC2Down'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtEC2Down']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtEC2Down')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativePtHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativePtHFDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativePtHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatECUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatECUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatECDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatECDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatECDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatFSRUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatFSRDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatFSRDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatFSRDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatHFUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeStatHFDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeStatHFDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeStatHFDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionECALUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALUp']
        self.fill_histos(jesrow, weight, name+'/JetSinglePionECALUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionECALDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionECALDown']
        self.fill_histos(jesrow, weight, name+'/JetSinglePionECALDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALUp']
        self.fill_histos(jesrow, weight, name+'/JetSinglePionHCALUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetSinglePionHCALDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetSinglePionHCALDown']
        self.fill_histos(jesrow, weight, name+'/JetSinglePionHCALDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetTimePtEtaUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaUp']
        self.fill_histos(jesrow, weight, name+'/JetTimePtEtaUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetTimePtEtaDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetTimePtEtaDown']
        self.fill_histos(jesrow, weight, name+'/JetTimePtEtaDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeBalUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeBalUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeBalDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeBalDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeBalDown')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeSampleUp'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleUp']
        self.fill_histos(jesrow, weight, name+'/JetRelativeSampleUp')
        jesrow['type1_pfMetEt'] = self.metTauC(jesrow['tPtInitial'], jesrow['tDecayMode'], jesrow['tZTTGenMatching'], jesrow['type1_pfMet_shiftedPt_JetRelativeSampleDown'])
        jesrow['type1_pfMetPhi'] = jesrow['type1_pfMet_shiftedPhi_JetRelativeSampleDown']
        self.fill_histos(jesrow, weight, name+'/JetRelativeSampleDown')
        
      if 'TauLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frDown') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(row, weightDown, name+'/TauFakeDown')
          self.fill_histos(row, weight, name+'/TauFakeUp')
        else:
          weightUp = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frUp') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(row, weightUp, name+'/TauFakeUp')
          self.fill_histos(row, weight, name+'/TauFakeDown')

    else:
      self.fill_histos(row, weight, name)
      if 'TauLoose' in name:
        myrand = random.random()
        if myrand < 0.5:
          weightDown = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frDown') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(row, weightDown, name+'/TauFakeDown')
          self.fill_histos(row, weight, name+'/TauFakeUp')
        else:
          weightUp = self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'], 'frUp') * weight/self.fakeRate(row['tPt'], row['tEta'], row['tDecayMode'])
          self.fill_histos(row, weightUp, name+'/TauFakeUp')
          self.fill_histos(row, weight, name+'/TauFakeDown')
      if self.is_embed:
        self.fill_histos(row, weight * 1.02, name+'/trUp')
        self.fill_histos(row, weight * 0.98, name+'/trDown')
        self.fill_histos(row, weight * 1.04, name+'/embtrUp')
        self.fill_histos(row, weight * 0.96, name+'/embtrDown')

        scalerow = copy.deepcopy(row)
        normtPt = scalerow['tPt']
        normmet = scalerow['type1_pfMetEt']
        if row['tZTTGenMatching']==5:
          if scalerow['tDecayMode']==0:
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
          elif scalerow['tDecayMode']==1:
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
            scalerow['tPt'] = normtPt * 1.008
            scalerow['type1_pfMetEt'] = normmet - 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            scalerow['tPt'] = normtPt * 0.992
            scalerow['type1_pfMetEt'] = normmet + 0.008 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
          elif scalerow['tDecayMode']==10:
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            scalerow['tPt'] = normtPt * 1.009
            scalerow['type1_pfMetEt'] = normmet - 0.009 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            scalerow['tPt'] = normtPt * 0.991
            scalerow['type1_pfMetEt'] = normmet + 0.009 * normtPt
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
          else:
            self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
            self.fill_histos(scalerow, weight, name+'/scaletDM10Down')
        else:
          self.fill_histos(scalerow, weight, name+'/scaletDM0Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM0Down')
          self.fill_histos(scalerow, weight, name+'/scaletDM1Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM1Down')
          self.fill_histos(scalerow, weight, name+'/scaletDM10Up')
          self.fill_histos(scalerow, weight, name+'/scaletDM10Down')

        if row['tDecayMode'] == 0:
          dm = 0.975
          self.fill_histos(row, weight * 0.983/dm, name+'/embtrkUp')
          self.fill_histos(row, weight * 0.967/dm, name+'/embtrkDown')
        elif row['tDecayMode'] == 1:
          dm = 0.975*1.051
          self.fill_histos(row, weight * (0.983*1.065)/dm, name+'/embtrkUp')
          self.fill_histos(row, weight * (0.967*1.037)/dm, name+'/embtrkDown')
        elif row['tDecayMode'] == 10:
          dm = pow(0.975, 3)
          self.fill_histos(row, weight * pow(0.983, 3)/dm, name+'/embtrkUp')
          self.fill_histos(row, weight * pow(0.967, 3)/dm, name+'/embtrkDown')
        else:
          self.fill_histos(row, weight, name+'/embtrkUp')
          self.fill_histos(row, weight, name+'/embtrkDown')


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
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])
      subtemp["genpX"] = row.genpX
      subtemp["genpY"] = row.genpY
      subtemp["vispX"] = row.vispX
      subtemp["vispY"] = row.vispY

    subtemp["tPt"] = self.tauPtC(row.tPt, row.tDecayMode, row.tZTTGenMatching)
    subtemp["type1_pfMetEt"] = self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tmpMetEt)
    subtemp["type1_pfMetPhi"] = tmpMetPhi

    if self.is_DY or self.is_DYlow:
      subtemp["isZmumu"] = row.isZmumu
      subtemp["isZee"] = row.isZee

    subtemp["ePt"] = row.ePt
    subtemp["eEta"] = row.eEta
    subtemp["tEta"] = row.tEta
    subtemp["ePhi"] = row.ePhi
    subtemp["tPhi"] = row.tPhi
    subtemp["eMass"] = row.eMass
    subtemp["tMass"] = row.tMass
    subtemp["eCharge"] = row.eCharge
    subtemp["tCharge"] = row.tCharge
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["Ele35WPTightPass"] = row.Ele35WPTightPass
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20TightMVALTVtx"] = row.tauVetoPt20TightMVALTVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["eMVANoisoWP80"] = row.eMVANoisoWP80
    subtemp["eRelPFIsoRho"] = row.eRelPFIsoRho
    subtemp["tDecayModeFinding"] = row.tDecayModeFinding
    subtemp["tAgainstElectronTightMVA6"] = row.tAgainstElectronTightMVA6
    subtemp["tAgainstMuonLoose3"] = row.tAgainstMuonLoose3
    subtemp["tRerunMVArun2v2DBoldDMwLTTight"] = row.tRerunMVArun2v2DBoldDMwLTTight
    subtemp["tRerunMVArun2v2DBoldDMwLTLoose"] = row.tRerunMVArun2v2DBoldDMwLTLoose
    subtemp["tRerunMVArun2v2DBoldDMwLTVTight"] = row.tRerunMVArun2v2DBoldDMwLTVTight
    subtemp["tByCombinedIsolationDeltaBetaCorrRaw3Hits"] = row.tByCombinedIsolationDeltaBetaCorrRaw3Hits
    subtemp["tByIsolationMVArun2v1DBoldDMwLTraw"] = row.tByIsolationMVArun2v1DBoldDMwLTraw
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["tDecayMode"] = row.tDecayMode
    subtemp["tZTTGenMatching"] = row.tZTTGenMatching
    subtemp["dielectronVeto"] = row.dielectronVeto
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["bjetDeepCSVVeto20Medium"] = row.bjetDeepCSVVeto20Medium
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb1eta"] = row.jb1eta
    subtemp["vbfNJets30"] = row.vbfNJets30
    subtemp["vbfMass"] = row.vbfMass
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["topQuarkPt1"] = row.topQuarkPt1
    subtemp["topQuarkPt2"] = row.topQuarkPt2
    subtemp["e_t_DPhi"] = row.e_t_DPhi
    subtemp["e_t_DR"] = row.e_t_DR
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

      if nrow['e_t_DR'] < 0.5:
        continue

      if nrow['jetVeto30'] > 2:
        continue

      if not self.obj1_id(nrow):
        continue

      if not self.obj2_id(nrow):
        continue

      if not self.vetos(nrow):
        continue      

      if not self.dielectronveto(nrow):
        continue

      #if self.is_DY or self.is_DYlow:
      #  if not bool(nrow['isZmumu'] or nrow['isZee']):
      #    continue

      #nbtag = nrow['bjetDeepCSVVeto20Medium']
      #bpt_1 = nrow['jb1pt']
      #bflavor_1 = nrow['jb1hadronflavor']
      #beta_1 = nrow['jb1eta']
      #if (not self.is_data and not self.is_embed and nbtag > 0):
      #  nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      #if (nbtag > 0):
      #  continue

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
            x[i]=temp[i]["eRelPFIsoRho"]
            y[i]=temp[i]["ePt"]
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

      if len(sorted_z) > 1:
        continue

      weight = 1.0
      if not self.is_data and not self.is_embed:
        wmc.var("e_pt").setVal(newrow['ePt'])
        wmc.var("e_eta").setVal(newrow['eEta'])
        eIso = wmc.function("e_iso_kit_ratio").getVal()
        eID = wmc.function("e_id80_kit_ratio").getVal()
        eTrk = wmc.function("e_trk_ratio").getVal()
        tEff = wmc.function("e_trg35_kit_data").getVal()/wmc.function("e_trg35_kit_mc").getVal()
        zvtx = 0.991
        if newrow['tZTTGenMatching']==5:
          tID = 0.89
        else:
          tID = 1.0
        weight = newrow['GenWeight']*pucorrector[''](newrow['nTruePU'])*tEff*eID*tID*eIso*eTrk*zvtx
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
          weight = weight*11.47563472*zptweight
        if self.is_GluGlu:
          weight = weight*0.000556
        if self.is_VBF:
          weight = weight*0.00021
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
          weight = weight*0.0057
        if self.is_TTToHadronic:
          weight = weight*0.379
        if self.is_TTToSemiLeptonic:
          weight = weight*0.00117
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.00203
        if newrow['tZTTGenMatching']==2 or newrow['tZTTGenMatching']==4:
          if abs(newrow['tEta']) < 0.4:
            weight = weight*1.06
          elif abs(newrow['tEta']) < 0.8:
            weight = weight*1.02
          elif abs(newrow['tEta']) < 1.2:
            weight = weight*1.10
          elif abs(newrow['tEta']) < 1.7:
            weight = weight*1.03
          else:
            weight = weight*1.94
        elif newrow['tZTTGenMatching']==1 or newrow['tZTTGenMatching']==3:
          if abs(newrow['tEta']) < 1.46:
            weight = weight*1.80
          elif abs(newrow['tEta']) > 1.558:
            weight = weight*1.53
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
        ws.var("e_pt").setVal(newrow['ePt'])
        ws.var("e_eta").setVal(newrow['eEta'])
        ws.var("gt_pt").setVal(newrow['ePt'])
        ws.var("gt_eta").setVal(newrow['eEta'])
        msel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt_pt").setVal(newrow['tPtInitial'])
        ws.var("gt_eta").setVal(newrow['tEta'])
        tsel = ws.function("m_sel_idEmb_ratio").getVal()
        ws.var("gt1_pt").setVal(newrow['ePt'])
        ws.var("gt1_eta").setVal(newrow['eEta'])
        ws.var("gt2_pt").setVal(newrow['tPtInitial'])
        ws.var("gt2_eta").setVal(newrow['tEta'])
        trgsel = ws.function("m_sel_trg_ratio").getVal()
        e_iso_sf = ws.function("e_iso_binned_embed_kit_ratio").getVal()
        e_id_sf = ws.function("e_id80_embed_kit_ratio").getVal()
        e_trg_sf = ws.function("e_trg35_embed_kit_ratio").getVal()
        weight = weight*newrow['GenWeight']*tID*e_trg_sf*e_id_sf*e_iso_sf*dm*msel*tsel*trgsel


      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and self.obj1_tight(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        if self.oppositesign(newrow):
          if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 60:
            self.fill_sys(newrow, weight*frTau, 'TauLooseOS')
            if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight*frTau, 'TauLooseOS0Jet')
            elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight*frTau, 'TauLooseOS1Jet')
            elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight*frTau, 'TauLooseOS2Jet')
            elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
              self.fill_sys(newrow, weight*frTau, 'TauLooseOS2JetVBF')

      if self.obj2_tight(newrow) and self.obj1_tight(newrow):
        if self.oppositesign(newrow):
          if transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 60:
            self.fill_sys(newrow, weight, 'TightOS')
            if newrow['vbfNJets30']==0 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight, 'TightOS0Jet')
            elif newrow['vbfNJets30']==1 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight, 'TightOS1Jet')
            elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 105:
              self.fill_sys(newrow, weight, 'TightOS2Jet')
            elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550 and transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']) < 85:
              self.fill_sys(newrow, weight, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()