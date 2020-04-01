import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import FinalStateAnalysis.TagAndProbe.MEtSys as MEtSys
import ROOT
from getTauTriggerSFs import getTauTriggerSFs

dataset = 'egamma'
year = '2018'

pu_distributions  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root')),
    'egamma'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu.root'))
}

def make_puCorrector(puname=''):
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight(puname, year, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    if bool('GluGlu_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector('GGHET')}
    elif bool('GluGluHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('GGHTT')}
    elif bool('GluGluHToWW' in target):
        pucorrector = {'' : make_puCorrector('GGHWW')}
    elif bool('VBF_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector('VBFHET')}
    elif bool('VBFHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('VBFHTT')}
    elif bool('VBFHToWW' in target):
        pucorrector = {'' : make_puCorrector('VBFHWW')}
    else:
        pucorrector = {'' : make_puCorrector('DY')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected("2018/TypeI-PFMet_Run2018.root")
MetSys = MEtSys.MEtSystematics("2017/PFMEtSys_2017.root")
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2018('Tight')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2018('Loose')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2018('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2018('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2018('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2018('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2018()
fesTau = TauPOGCorrections.Tau_FES_2018
tauSF = getTauTriggerSFs()

cmsswBase = "/afs/hep.wisc.edu/home/psiddire/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data"
f1 = ROOT.TFile(cmsswBase + "2018/htt_scalefactors_legacy_2018.root")
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

def ScaleTau(dm):
    if dm==0:
        st = (0.01, ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = (0.009, ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = (0.011, ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = (0.011, ['/scaletDM11Up', '/scaletDM11Down'])
    return st
