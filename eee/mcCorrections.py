import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import ROOT

year = '2018'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu.root'))

def make_puCorrector(puname=''):
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight(puname, year, *pu_distributions)
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('DY')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected("2018/Type1_PFMET_2018.root")
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
Ele24 = EGammaPOGCorrections.el_Ele24_2018
Ele32or35 = EGammaPOGCorrections.el_Ele32orEle35_2018
Ele35 = EGammaPOGCorrections.el_Ele35_2018
EleIdIso = EGammaPOGCorrections.el_IdIso_2018

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2018/htt_scalefactors_legacy_2018.root")
w1 = f1.Get("w")
