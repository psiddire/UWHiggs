import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import ROOT

dataset = 'singlee'
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
    elif bool('WW' in target):
        pucorrector = {'' : make_puCorrector('WW')}
    elif bool('WZ' in target):
        pucorrector = {'' : make_puCorrector('WZ')}
    elif bool('ZZ' in target):
        pucorrector = {'' : make_puCorrector('ZZ')}
    else:
        pucorrector = {'' : make_puCorrector('DY')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected("2018/Type1_PFMET_2018.root")
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
Ele24 = EGammaPOGCorrections.el_Ele24_2018
Ele32or35 = EGammaPOGCorrections.el_Ele32orEle35_2018
Ele35 = EGammaPOGCorrections.el_Ele35_2018
EleIdIso = EGammaPOGCorrections.el_IdIso_2018
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2018('Tight')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2018('Loose')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2018('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2018('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2018('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2018('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2018()
fesTau = TauPOGCorrections.Tau_FES_2018

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2018/htt_scalefactors_legacy_2018.root")
w1 = f1.Get("w")

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
