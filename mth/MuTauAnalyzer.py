from MuTauTree import MuTauTree
import sys
import logging
logging.basicConfig(stream=sys.stderr, level=logging.INFO)
import os
from pdb import set_trace
import ROOT
import math
import glob
import array
import FinalStateAnalysis.PlotTools.pytree as pytree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from math import sqrt, pi, cos
import itertools
import traceback
from FinalStateAnalysis.Utilities.struct import struct
from RecoilCorrector import RecoilCorrector
from FinalStateAnalysis.PlotTools.decorators import memo
from FinalStateAnalysis.PlotTools.decorators import memo_last
import mcCorrections
import bTagSF
import random

mt_collmass = 'm_t_collinearmass'

@memo
def getVar(name, var):
    return name+var
@memo
def split(string, separator='#'):
    return tuple(attr.split(separator))

met_et  = 'type1_pfMetEt'
met_phi = 'type1_pfMetPhi'
ty1met_et  = 'type1_pfMet_shiftedPt%s'
ty1met_phi = 'type1_pfMet_shiftedPhi%s'
t_pt  = 'tPt%s'
#mtMass = 'm_t_Mass%s'
jetVeto = 'jetVeto30%s'
target = os.path.basename(os.environ['megatarget'])
MetCorrection = True

@memo
def jetN(shift=''):
    if '_Jet' in shift:
        return jetVeto %shift.replace('jes', '')
    return jetVeto %('')

@memo
def met(shift=''):
    if '_Jet' in shift or 'ues' in shift:
        return ty1met_et %shift
    return met_et

@memo
def metphi(shift=''):
    if '_Jet' in shift or 'ues' in shift:
        return ty1met_phi %shift
    return met_phi
  
def attr_getter(attribute):
    '''return a function that gets an attribute'''
    def f(row, weight):
        return (getattr(row,attribute), weight)
    return f

def visibleMass(row):
    vobj1 = ROOT.TLorentzVector()
    vobj2 = ROOT.TLorentzVector()
    vobj1.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
    vobj2.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)
    return (vobj1 + vobj2).M()

def collmass(row, met, metPhi):
    ptnu = abs(met*cos(deltaPhi(metPhi, row.tPhi)))
    visfrac = row.tPt/(row.tPt + ptnu)
    return (visibleMass(row) / sqrt(visfrac))

def syst_collmass(met, metPhi, my_ele, my_tau):
    ptnu = abs(met*cos(deltaPhi(metPhi,my_tau.Phi())))
    visfrac = my_tau.Pt()/(my_tau.Pt()+ptnu)
    return ((my_tau+my_ele).M()) / (sqrt(visfrac))

def make_visfrac_systematics(met, metPhi, my_tau):
    ptnu = abs(met*cos(deltaPhi(metPhi,my_tau.Phi())))
    visfrac = my_tau.Pt()/(my_tau.Pt()+ptnu)
    return visfrac

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
    return sqrt(deta*deta + dphi*dphi);

def merge_functions(fcn_1, fcn_2):
    '''merges two functions to become a TH2'''
    def f(row, weight):
        r1, w1 = fcn_1(row, weight)
        r2, w2 = fcn_2(row, weight)
        w = w1 if w1 and w2 else None
        return ((r1, r2), w)
    return f

def remove_element(list_,value_):
    clipboard = []
    for i in range(len(list_)):
        if list_[i] is not value_:
            clipboard.append(list_[i])
    return clipboard

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

class MuTauAnalyzer(MegaBase):
    tree = 'mt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        logging.debug('MuTauAnalyzer constructor')
        self.channel='MT'
        super(MuTauAnalyzer, self).__init__(tree, outfile, **kwargs)
        self.tree = MuTauTree(tree)
        self.outfile=outfile
        self.histograms = {}
        
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

        self.my_tau = ROOT.TLorentzVector()
        self.my_mu = ROOT.TLorentzVector()
        self.my_MET = ROOT.TLorentzVector()

        self.systematics = {
            'pu'   : (['','puUp', 'puDown'] if self.is_mc else []),
            'trig' : (['', 'trUp', 'trDown'] if self.is_mc else []),
            'tes'  : (['scale_t_1prong_13TeVUp', 'scale_t_1prong_13TeVDown', 'scale_t_1prong1pizero_13TeVUp', 'scale_t_1prong1pizero_13TeVDown', 'scale_t_3prong_13TeVUp', 'scale_t_3prong_13TeVDown'] if self.is_mc else ['']),
            'mes'  : (['', 'mesUp', 'mesDown'] if self.is_mc else ['']),
            'mes'  : (['', 'mesUp', 'mesDown'] if self.is_mc else ['']),
            'ues'  : (['', 'ues_UnclusteredEnDown', 'ues_UnclusteredEnUp'] if self.is_mc else ['']),
            'jes'  : (['', 'jes_JetResUp', 'jes_JetResDown', 'jes_JetEnUp', 'jes_JetEnDown'] if self.is_mc else [''])
            #'mtfakeES': (['', 'mtfakeESUp', 'mtfakeESDown'] if self.is_DY or self.is_DYLowMass else ['']),
            #'jes_JetTotalUp',  'jes_JetTotalDown', 'JetEta3to5Up', 'JetEta3to5Down', 'JetEta0to3Up', 'JetEta0to3Down', 'JetEta0to5Up', 'JetEta0to5Down', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown',
            #'jes'  : (['','jes_JetAbsoluteFlavMapDown',  'jes_JetAbsoluteMPFBiasDown',  'jes_JetAbsoluteScaleDown',  'jes_JetAbsoluteStatDown',  'jes_JetFlavorQCDDown',  'jes_JetFragmentationDown',  'jes_JetPileUpDataMCDown',  'jes_JetPileUpPtBBDown',  'jes_JetPileUpPtEC1Down',  'jes_JetPileUpPtEC2Down',  'jes_JetPileUpPtHFDown',  'jes_JetPileUpPtRefDown',  'jes_JetRelativeBalDown',  'jes_JetRelativeFSRDown',  'jes_JetRelativeJEREC1Down', 'jes_JetRelativeJEREC2Down',  'jes_JetRelativeJERHFDown',  'jes_JetRelativePtBBDown',  'jes_JetRelativePtEC1Down',  'jes_JetRelativePtEC2Down',  'jes_JetRelativePtHFDown',  'jes_JetRelativeStatECDown',  'jes_JetRelativeStatFSRDown',  'jes_JetRelativeStatHFDown',  'jes_JetSinglePionECALDown',  'jes_JetSinglePionHCALDown',  'jes_JetTimePtEtaDown',  'jes_JetAbsoluteFlavMapUp', 'jes_JetAbsoluteMPFBiasUp',  'jes_JetAbsoluteScaleUp',  'jes_JetAbsoluteStatUp',  'jes_JetFlavorQCDUp',  'jes_JetFragmentationUp',  'jes_JetPileUpDataMCUp',  'jes_JetPileUpPtBBUp',  'jes_JetPileUpPtEC1Up', 'jes_JetPileUpPtEC2Up',  'jes_JetPileUpPtHFUp',  'jes_JetPileUpPtRefUp',  'jes_JetRelativeBalUp',  'jes_JetRelativeFSRUp',  'jes_JetRelativeJEREC1Up',  'jes_JetRelativeJEREC2Up',  'jes_JetRelativeJERHFUp',  'jes_JetRelativePtBBUp',  'jes_JetRelativePtEC1Up',  'jes_JetRelativePtEC2Up',  'jes_JetRelativePtHFUp',  'jes_JetRelativeStatECUp', 'jes_JetRelativeStatFSRUp',  'jes_JetRelativeStatHFUp',  'jes_JetSinglePionECALUp',  'jes_JetSinglePionHCALUp',  'jes_JetTimePtEtaUp'] if not self.is_data else [''])
        }
        
        self.histo_locations = {}

        self.hfunc   = {
            'nTruePU' : lambda row, weight: (row.nTruePU,None),
            'weight'  : lambda row, weight: (weight,None) if weight is not None else (1.,None),
            'Event_ID': lambda row, weight: (array.array("f", [row.run,row.lumi,int(row.evt)/10**5,int(row.evt)%10**5] ), None),
            'h_collmass_pfmet' : lambda row, weight: (syst_collmass(self.my_MET.Pt(), self.my_MET.Phi(), self.my_mu, self.my_tau), weight),
            'tPt' : lambda row, weight: (self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), weight),
            'met' : lambda row, weight: ( self.my_MET.Pt(),weight),
            'h_collmass_vs_dPhi_pfmet' : merge_functions(
                attr_getter('tDPhiToPfMet_type1'),
                lambda row, weight: (collmass(row, row.type1_pfMetEt, row.type1_pfMetPhi),weight)
            ),
            'visfrac' : lambda row, weight: (make_visfrac_systematics(self.my_MET.Pt(), self.my_MET.Phi(), self.my_tau), weight), 
            'MetEt_vs_dPhi' : merge_functions(
                lambda row, weight: (deltaPhi(row.tPhi, getattr(row, metphi())), weight),
                attr_getter('type1_pfMetEt')
            ),
            'mPFMET_DeltaPhi' : lambda row, weight: (deltaPhi(row.mPhi, getattr(row, metphi())), weight),
            'tPFMET_DeltaPhi' : lambda row, weight: (deltaPhi(row.tPhi, getattr(row, metphi())), weight),
            'evtInfo' : lambda row, weight: (struct(run=row.run,lumi=row.lumi,evt=row.evt,weight=weight), None)
            }

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
            0 : 2.79668853,
            1 : 0.492824977,
            2 : 1.014457295,
            3 : 0.64402901,
            4 : 0.449235695
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
        if row.mPt < 29 or abs(row.mEta) >= 2.4:
            return False
        if row.tPt < 30 or abs(row.tEta) >= 2.3:
            return False
        return True

    def vetos(self, row):
        return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20Loose3HitsVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))

    def obj1_id(self, row):
        return bool(row.mPFIDTight)

    def obj1_tight(self, row):
        return bool(row.mRelPFIsoDBDefaultR04 < 0.15)

    def obj1_loose(self, row):
        return bool(row.mRelPFIsoDBDefaultR04 < 0.25)

    def obj2_id(self, row):
        return bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronVLooseMVA6 > 0.5) and bool(row.tAgainstMuonTight3 > 0.5)

    @memo
    def tauPt(self, tPt, tDecayMode, tZTTGenMatching, shift=''):
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

    @memo
    def metTauC(self, tPt, tDecayMode, tZTTGenMatching, mymet, shift=''):
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

    def event_weight(self, row, sys_shifts):
        weights = {}
        mcweight = 1.
        if self.is_data:
            return {'' : mcweight}
        if self.is_embed:
            return {'' : mcweight * row.GenWeight}
        if self.is_mc:
            mtracking = self.muTracking(row.mEta)[0]
            mID = self.muonTightID(row.mPt, abs(row.mEta))
            mcweight = self.triggerEff(row.mPt, abs(row.mEta))
            dyweight = self.DYreweight(row.genMass, row.genpT) 
            puweight = pucorrector[''](row.nTruePU)
            if row.tZTTGenMatching==5:
                tID = 0.89
            else:
                tID = 1.0
            mcweight = mcweight * row.GenWeight * puweight * tID * mID * mtracking
            if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
                if abs(row.tEta) < 0.4:
                    mcweight = mcweight * 1.17
                elif abs(row.tEta) < 0.8:
                    mcweight = mcweight * 1.29
                elif abs(row.tEta) < 1.2:
                    mcweight = mcweight * 1.14
                elif abs(row.tEta) < 1.7:
                    mcweight = mcweight * 0.93
                else:
                    mcweight = mcweight * 1.61
            elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
                if abs(row.tEta) < 1.46:
                    mcweight = mcweight * 1.09
                elif abs(row.tEta) > 1.558:
                    mcweight = mcweight * 1.19
        if self.is_DY:
            if row.numGenJets < 5:
                mcweight = mcweight * self.DYweight[row.numGenJets] * dyweight
            else:
                mcweight = mcweight * self.DYweight[0] * dyweight
        if self.is_DYlow:
            mcweight = mcweight * 23.105 * dyweight
        if self.is_GluGlu:
            mcweight = mcweight * 0.000519
        if self.is_VBF:
            mcweight = mcweight * 0.000214
        if self.is_WW:
            mcweight = mcweight * 0.417
        if self.is_WZ:
            mcweight = mcweight * 0.294
        if self.is_ZZ:
            mcweight = mcweight * 0.261
        if self.is_EWKWMinus:
            mcweight = mcweight * 0.191
        if self.is_EWKWPlus:
            mcweight = mcweight * 0.246
        if self.is_EWKZToLL:
            mcweight = mcweight * 0.185
        if self.is_EWKZToNuNu:
            mcweight = mcweight * 0.142
        if self.is_ZHTT:
            mcweight = mcweight * 0.000598
        if self.is_ttH:
            mcweight = mcweight * 0.000118
        if self.is_Wminus:
            mcweight = mcweight * 0.000670
        if self.is_Wplus:
            mcweight = mcweight * 0.000636
        if self.is_STtantitop:
            mcweight = mcweight * 0.922
        if self.is_STttop:
            mcweight = mcweight * 0.952
        if self.is_STtWantitop:
            mcweight = mcweight * 0.00545
        if self.is_STtWtop:
            mcweight = mcweight * 0.00552
        if self.is_TTTo2L2Nu:
            mcweight = mcweight * 0.00574
        if self.is_TTToHadronic:
            mcweight = mcweight * 0.385
        if self.is_TTToSemiLeptonic:
            mcweight = mcweight * 0.00118
        if self.is_VBFH:
            mcweight = mcweight * 0.000864
        if self.is_GluGluH:
            mcweight = mcweight * 0.000488
                
        for shift in sys_shifts:
            syst_mcweight = -999.
            if shift=='trUp':
                syst_mcweight = mcweight * 1.02
            elif shift=='trDown':
                syst_mcweight = mcweight * 0.98
            if shift=='puUp' or shift=='puDown':
                puweight_sys = pucorrector[shift](row.nTruePU)
                if puweight==0:
                    syst_mcweight = 0
                else:
                    syst_mcweight = mcweight * puweight_sys/puweight
            weights[shift] =  syst_mcweight if syst_mcweight!=-999. else mcweight
        
        return weights

        
    def begin(self):
        sys_shifts = ['', 'TauLoose', 'TauLoose/Up', 'TauLoose/Down'] + self.systematics['pu'] + self.systematics['trig'] +  self.systematics['mes'] + self.systematics['tes'] + self.systematics['ues'] + self.systematics['jes']
        sys_shifts = list(set(sys_shifts))
        signs = ['OS']
        jetN = ['0Jet', '1Jet', '2Jet', '2JetVBF']
        folder = []
        self.outfile.cd()
        for tuple_path in itertools.product(sys_shifts, signs, jetN):
            folder.append(os.path.join(*tuple_path))
            path = list(tuple_path)
        for f in folder:
            self.book(f, "h_collmass_pfmet", "h_collmass_pfmet", 30, 0, 300)
            #self.book(f, "m_t_Mass", "h_vismass", 30, 0, 300)            
        #index dirs and histograms
        for key, value in self.histograms.iteritems():
            location = os.path.dirname(key)
            name     = os.path.basename(key)
            if location not in self.histo_locations:
                self.histo_locations[location] = {name : value}
            else:
                self.histo_locations[location][name] = value


    def fill_histos(self, folder_str, row, weight, filter_label = ''):
        '''fills histograms'''
        for attr, value in self.histo_locations[folder_str].iteritems():
            name = attr
            if filter_label:
                if not attr.startswith(filter_label+'$'):
                    continue
                attr = attr.replace(filter_label+'$', '')
            if 'Gen' in attr and self.is_data:
                continue 
            if value.InheritsFrom('TH2'):
                if attr in self.hfunc:
                    try:
                        result, out_weight = self.hfunc[attr](row, weight)
                    except Exception as e:
                        raise RuntimeError("Error running function %s. Error: \n\n %s" % (attr, str(e)))
                    r1, r2 = result
                    if out_weight is None:
                        value.Fill( r1, r2 ) #saves you when filling NTuples!
                    else:
                        value.Fill( r1, r2, out_weight )
                else:
                    attr1, attr2 = split(attr)
                    v1 = getattr(row,attr1)
                    v2 = getattr(row,attr2)
                    value.Fill( v1, v2, weight ) if weight is not None else value.Fill( v1, v2 )
            else:
                if attr in self.hfunc:
                    try:
                        result, out_weight = self.hfunc[attr](row, weight)
                    except Exception as e:
                        raise RuntimeError("Error running function %s. Error: \n\n %s" % (attr, str(e)))
                    if out_weight is None:
                        value.Fill( result ) #saves you when filling NTuples!
                    else:
                        value.Fill( result, out_weight )
                else:
                    print "ATT: ", attr, " ", getattr(row,attr), " ", weight 
                    value.Fill( getattr(row,attr), weight ) if weight is not None else value.Fill( getattr(row,attr) )
        return None

    def process(self):
        sys_shifts = self.systematics['pu'] + self.systematics['trig'] + self.systematics['mes'] + self.systematics['tes'] + self.systematics['ues'] + self.systematics['jes']
        logging.debug('Starting processing')
        lock =()
        ievt = 0
        logging.debug('Starting evt loop')
        for row in self.tree:
            if (ievt % 1000) == 0:
                logging.debug('New event')
            ievt += 1

            evt_id = (row.run, row.lumi, row.evt)
            if evt_id == lock: continue
            if lock != () and evt_id == lock:
                logging.info('Removing duplicate of event: %d %d %d' % evt_id)

            if (self.is_DY and not bool(row.isZmumu or row.isZee)) : continue
            if not bool(row.IsoMu27Pass) : continue
            if not self.kinematics(row) : continue
            if deltaR(row.mPhi, row.tPhi, row.mEta, row.tEta) < 0.5 : continue
            if row.jetVeto30 > 2 : continue
            if not self.obj1_id(row) : continue
            if not self.obj2_id(row) : continue
            if not self.vetos(row) : continue
            if not self.oppositesign(row) : continue
            sign = 'OS'

            sys_directories = sys_shifts
            sys_directories = list(set(sys_directories))
            
            isTauTight = bool(row.tRerunMVArun2v2DBoldDMwLTTight)
            isTauLoose = bool(row.tRerunMVArun2v2DBoldDMwLTLoose)

            weight_sys_shifts = sys_shifts
            weight_sys_shifts.append('')
            weight_sys_shifts = list(set(weight_sys_shifts))
            weight_map = self.event_weight(row, weight_sys_shifts)

            if not isTauTight and isTauLoose and self.obj1_tight:
                mc_weight = weight_map['']
                tweight = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, '') * mc_weight
                tLoose_weight = {'TauLoose': tweight}
                weight_map.update(tLoose_weight)
                sys_directories.extend(['TauLoose'])
                sys_directories = remove_element(sys_directories, '')
                myrand = random.random()
                if myrand < 0.5:
                    tweightDown = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, 'frDown') * mc_weight
                    tLooseDown_weight = {'TauLoose/Down': tweightDown}
                    weight_map.update(tLooseDown_weight)
                    tLooseUp_weight = {'TauLoose/Up': tweight}
                    weight_map.update(tLooseUp_weight)
                else:
                    tweightUp = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, 'frUp') * mc_weight
                    tLooseUp_weight = {'TauLoose/Up': tweightUp}
                    weight_map.update(tLooseUp_weight)
                    tLooseDown_weight = {'TauLoose/Down': tweight}
                    weight_map.update(tLooseDown_weight)
                sys_directories.extend(['TauLoose/Up'])
                sys_directories.extend(['TauLoose/Down'])
                sys_directories = remove_element(sys_directories, '')

            if isTauTight and not self.obj1_tight and self.obj1_loose:
                mc_weight = weight_map['']
                mweight = self.fakeRateMuon(row.mPt, '') * mc_weight
                mLoose_weight = {'MuonLoose': mweight}
                weight_map.update(mLoose_weight)
                sys_directories.extend(['MuonLoose'])
                sys_directories = remove_element(sys_directories, '')
                myrand = random.random()
                if myrand < 0.5:
                    mweightDown = self.fakeRateMuon(row.mPt, 'frDown') * mc_weight
                    mLooseDown_weight = {'MuonLoose/Down': mweightDown}
                    weight_map.update(mLooseDown_weight)
                    mLooseUp_weight = {'MuonLoose/Up': mweight}
                    weight_map.update(mLooseUp_weight)
                else:
                    mweightUp = self.fakeRateMuon(row.mPt, 'frUp') * mc_weight
                    mLooseUp_weight = {'MuonLoose/Up': mweightUp}
                    weight_map.update(mLooseUp_weight )
                    mLooseDown_weight = {'MuonLoose/Down': mweight}
                    weight_map.update(mLooseDown_weight )
                sys_directories.extend(['MuonLoose/Up'])
                sys_directories.extend(['MuonLoose/Down'])
                sys_directories = remove_element(sys_directories, '')

            if not isTauTight and isTauLoose and not self.obj1_tight and self.obj1_loose:
                mc_weight = weight_map['']
                mtweight = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, '') * self.fakeRateMuon(row.mPt, '') * mc_weight
                mtLoose_weight = {'MuonLooseTauLoose': mtweight}
                weight_map.update(mtLoose_weight)
                sys_directories.extend(['MuonLooseTauLoose'])
                sys_directories = remove_element(sys_directories, '')
                myrand = random.random()
                if myrand < 0.5:
                    mtweightDown = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, 'frDown') * self.fakeRateMuon(row.mPt, 'frDown') * mc_weight
                    mtLooseDown_weight = {'MuonLooseTauLoose/Down': mtweightDown}
                    weight_map.update(mtLooseDown_weight)
                    mtLooseUp_weight = {'MuonLooseTauLoose/Up': mtweight}
                    weight_map.update(mtLooseUp_weight)
                else:
                    mtweightUp = self.fakeRate(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), abs(row.tEta), row.tDecayMode, 'frUp') * self.fakeRateMuon(row.mPt, 'frUp') * mc_weight
                    mtLooseUp_weight = {'MuonLooseTauLoose/Up': mtweightUp}
                    weight_map.update(mtLooseUp_weight)
                    mtLooseDown_weight = {'MuonLooseTauLoose/Down': mtweight}
                    weight_map.update(mtLooseDown_weight)
                sys_directories.extend(['MuonLooseTauLoose/Up'])
                sys_directories.extend(['MuonLooseTauLoose/Down'])
                sys_directories = remove_element(sys_directories, '')
                
            selection_categories = []
            jetDir = ['0Jet', '1Jet', '2Jet', '2JetVBF']
            
            tpMetEt = row.type1_pfMetEt
            tpMetPhi = row.type1_pfMetPhi
            if self.is_recoilC and MetCorrection:
                tpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
                tpMetEt = math.sqrt(tpMet[0] * tpMet[0] + tpMet[1] * tpMet[1])
                tpMetPhi = math.atan2(tpMet[1], tpMet[0])

            self.my_mu.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
            self.my_tau.SetPtEtaPhiM(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
            self.my_MET.SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt), 0, tpMetPhi, 0)

            myMu = {}
            myTau = {}
            myMET = {}
            
            for sys in sys_directories :
                if 'mes' in sys:
                    if 'mesUp' in sys:
                        myMu[sys] = ROOT.TLorentzVector()
                        myMu[sys].SetPtEtaPhiM(row.mPt_MuonEnUp, row.mEta, row.mPhi, row.mMass)
                    if 'mesDown' in sys:
                        myMu[sys] = ROOT.TLorentzVector()
                        myMu[sys].SetPtEtaPhiM(row.mPt_MuonEnDown, row.mEta, row.mPhi, row.mMass)
                    
                if 'prong' in sys:
                    if row.tDecayMode == 0:
                        if '_1prong_' in sys:
                            if 'Up' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(1.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt) - 0.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)
                            if 'Down' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(0.992 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt) + 0.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)                    
                    elif row.tDecayMode == 1:
                        if '1prong1pizero' in sys:
                            if 'Up' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(1.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt) - 0.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)
                            if 'Down' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(0.992 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt) + 0.008 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)
                    elif row.tDecayMode == 10:
                        if '_3prong_' in sys:
                            if 'Up' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(1.009 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode,row.tZTTGenMatching, tpMetEt) - 0.009 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)
                            if 'Down' in sys:
                                myTau[sys] = ROOT.TLorentzVector()
                                myMET[sys] = ROOT.TLorentzVector()
                                myTau[sys].SetPtEtaPhiM(0.991 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                                myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode,row.tZTTGenMatching, tpMetEt) + 0.009 * self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), 0, tpMetPhi, 0)

                if 'jes_' in sys:
                    myMET[sys] =  ROOT.TLorentzVector()
                    myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, getattr(row, met(sys.replace('jes_', '_')))), 0, getattr(row, metphi(sys.replace('jes_', '_'))), 0)

                if 'ues_' in sys:
                    myMET[sys] =  ROOT.TLorentzVector()
                    myMET[sys].SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, getattr(row, met(sys.replace('ues_', '_')))), 0, getattr(row, metphi(sys.replace('ues_', '_'))), 0)

                my_tau = myTau[sys] if sys in myTau else self.my_tau
                my_met = myMET[sys] if sys in myMET else self.my_MET
                my_mu = myMu[sys] if sys in myMu else self.my_mu

                totalEt = my_tau.Et() + my_met.Et();
                totalPt = (my_tau + my_met).Pt()
                mytMtMet = sqrt(abs(totalEt * totalEt - totalPt * totalPt))
                if not (sys=='TauLoose' or sys=='TauLoose/Up' or sys=='TauLoose/Down' or sys=='MuonLooseTauLoose' or sys=='MuonLooseTauLoose/Up' or sys=='MuonLooseTauLoose/Down') and isTauTight==0: continue
                if not (sys=='MuonLoose' or sys=='MuonLoose/Up' or sys=='MuonLoose/Down' or sys=='MuonLooseTauLoose' or sys=='MuonLooseTauLoose/Up' or sys=='MuonLooseTauLoose/Down') and not self.obj1_tight: continue
                if row.vbfNJets30==0 and mytMtMet < 105:
                    selection_categories.extend([(sys, '', '0Jet', '')])
                if row.vbfNJets30==1 and mytMtMet < 105:
                    selection_categories.extend([(sys, '', '1Jet', '')])
                if row.vbfNJets30==2 and mytMtMet < 105 and row.vbfMass < 550:
                    selection_categories.extend([(sys, '', '2Jet', '')])
                if row.vbfNJets30==2 and mytMtMet < 85 and row.vbfMass > 550:
                    selection_categories.extend([(sys, '', '2JetVBF', '')])

            for selection in selection_categories:
                selection_sys, massRange, jet_dir, selection_step = selection
                dirname = os.path.join(selection_sys, sign, massRange, jet_dir, selection_step)
                tmpTau = ROOT.TLorentzVector()
                tmpMu = ROOT.TLorentzVector()
                tmpMET = ROOT.TLorentzVector()
                tmpTau.SetPtEtaPhiM(self.tauPt(row.tPt, row.tDecayMode, row.tZTTGenMatching), row.tEta, row.tPhi, row.tMass)
                tmpMu.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)
                tmpMET.SetPtEtaPhiM(self.metTauC(row.tPt, row.tDecayMode, row.tZTTGenMatching, tpMetEt), 0, tpMetPhi, 0)
                mytau = myTau[selection_sys] if selection_sys in myTau else tmpTau
                mymet = myMET[selection_sys] if selection_sys in myMET else tmpMET
                mymu = myMu[selection_sys] if selection_sys in myMu else tmpMu

                if dirname[-1] == '/':
                    dirname = dirname[:-1]
                weight_to_use = weight_map[selection_sys] if selection_sys in weight_map else weight_map['']

                self.my_mu = mymu
                self.my_tau = mytau
                self.my_MET = mymet

                self.fill_histos(dirname, row, weight_to_use)

                            
    def finish(self):
        self.write_histos()
