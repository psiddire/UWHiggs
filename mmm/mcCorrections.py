import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import ROOT
import RoccoR

dataset = 'singlem'
year = '2018'

pu_distributions  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu.root'))
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
    elif bool('WW_Tune' in target):
        pucorrector = {'' : make_puCorrector('WW')}
    elif bool('WZ_Tune' in target): 
        pucorrector = {'' : make_puCorrector('WZ')}
    elif bool('ZZ_Tune' in target):
        pucorrector = {'' : make_puCorrector('ZZ')}
    else:
        pucorrector = {'' : make_puCorrector('DY')}
    return pucorrector

rc = RoccoR.RoccoR("../../FinalStateAnalysis/TagAndProbe/data/2018/RoccoR/RoccoR2018.txt")
DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected("2018/Type1_PFMET_2018.root")
muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2018()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2018()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2018()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2018('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2018('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Tight')
muonTrigger24 = MuonPOGCorrections.make_muon_pog_IsoMu24_2018()
muonTracking = MuonPOGCorrections.mu_trackingEta_2018
muonTrigger27 = MuonPOGCorrections.mu_IsoMu27_2018
