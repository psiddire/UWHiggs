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

year = '2018'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('GGHET')}
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

