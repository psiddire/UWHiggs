import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import FinalStateAnalysis.TagAndProbe.MEtSys as MEtSys
import ROOT

year = '2016'

pu_distributions = glob.glob(os.path.join('inputs', os.environ['jobid'], 'data_SingleElectron*pu.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('GGHET')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2016()
Metcorected = RecoilCorrector.Metcorrected('2016/TypeI-PFMet_Run2016_legacy.root')
MetSys = MEtSys.MEtSystematics('2016/PFMEtSys_2016.root')
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2016()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2016()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
Ele25 = EGammaPOGCorrections.el_Ele25_2016
EleIdIso = EGammaPOGCorrections.el_IdIso_2016
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2016('Tight')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2016('Loose')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2016()
fesTau = TauPOGCorrections.Tau_FES_2016

cmsswBase = '/afs/hep.wisc.edu/home/psiddire/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data/'
f1 = ROOT.TFile(cmsswBase + '2016/htt_scalefactors_legacy_2016.root')
w1 = f1.Get('w')

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

