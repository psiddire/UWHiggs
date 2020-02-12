import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import ROOT

dataset = 'singlee'
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

DYreweight = DYCorrection.make_DYreweight_2017()
Metcorected = RecoilCorrector.Metcorrected("2017/Type1_PFMET_2017.root")
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2017()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2017()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2017()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90noiso_2017()
eReco = EGammaPOGCorrections.make_egamma_pog_Reco_2017()

f2 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2017/htt_scalefactors_2017_v2.root")
w2 = f2.Get("w")
