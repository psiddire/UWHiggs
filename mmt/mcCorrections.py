import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import ROOT
import RoccoR

dataset = 'singlem'
year = '2017'

pu_distributions  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root'))
}

def make_puCorrector(puname=''):
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight(puname, year, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    if bool('DYJetsToLL_M-50' in target):
        pucorrector = {'' : make_puCorrector('DY')}
    elif bool('DY1JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY1')}
    elif bool('DY2JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY2')}
    elif bool('DY3JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY3')}
    elif bool('DY4JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY4')}
    elif bool('WW' in target):
        pucorrector = {'' : make_puCorrector('WW')}
    elif bool('WZ' in target):
        pucorrector = {'' : make_puCorrector('WZ')}
    elif bool('ZZ' in target):
        pucorrector = {'' : make_puCorrector('ZZ')}
    else:
        pucorrector = {'' : make_puCorrector('DY')}
    return pucorrector

rc = RoccoR.RoccoR("../../FinalStateAnalysis/TagAndProbe/data/2017/RoccoR/RoccoR2017.txt")
DYreweight = DYCorrection.make_DYreweight_2017()
Metcorected = RecoilCorrector.Metcorrected("2017/Type1_PFMET_2017.root")
muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2017()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2017()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2017()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2017('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2017('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Tight')
muonTrigger27 = MuonPOGCorrections.make_muon_pog_IsoMu27_2017()
muonTrigger50 = MuonPOGCorrections.make_muon_pog_Mu50_2017()
muonTracking = MuonPOGCorrections.mu_trackingEta_2017
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2016('VLoose')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2016('Tight')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2016()
fesTau = TauPOGCorrections.Tau_FES_2016

def FesTau(eta, dm):
    fes = (1.0, 0.0, 0.0)
    if abs(eta) < 1.448:
        if dm == 0:
            fes = fesTau('EBDM0')
        elif dm == 1:
            fes = fesTau('EBDM1')
    elif abs(eta) > 1.558:
        if dm == 0:
            fes = fesTau('EEDM0')
        elif dm == 1:
            fes = fesTau('EEDM1')
    return fes
