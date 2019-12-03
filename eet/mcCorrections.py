import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.DYCorrectionReco as DYCorrectionReco
import ROOT

dataset='singlee'

is7TeV = bool('7TeV' in os.environ['jobid'])
pu_distributions  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu.root'))
    }
pu_distributionsUp  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_up.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu_up.root'))
    }
pu_distributionsDown  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_down.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu_down.root'))
    }

def make_puCorrector(dataset, puname=''):
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight(puname, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorUp(dataset, puname=''):
    if dataset in pu_distributionsUp:
        return PileupWeight.PileupWeight(puname, *(pu_distributionsUp[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorDown(dataset, puname=''):
    if dataset in pu_distributionsDown:
        return PileupWeight.PileupWeight(puname, *(pu_distributionsDown[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    if bool('DYJetsToLL_M-50' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'DY'),
                       'puUp': make_puCorrectorUp(dataset, 'DY'),
                       'puDown': make_puCorrectorDown(dataset, 'DY')}
    elif bool('DYJetsToLL_M-10to50' in target):                    
        pucorrector = {'' : make_puCorrector(dataset, 'DY10'),
                       'puUp': make_puCorrectorUp(dataset, 'DY10'),
                       'puDown': make_puCorrectorDown(dataset, 'DY10')}
    elif bool('DY1JetsToLL' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'DY1'),
                       'puUp': make_puCorrectorUp(dataset, 'DY1'),
                       'puDown': make_puCorrectorDown(dataset, 'DY1')}
    elif bool('DY2JetsToLL' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'DY2'),
                       'puUp': make_puCorrectorUp(dataset, 'DY2'),  
                       'puDown': make_puCorrectorDown(dataset, 'DY2')}
    elif bool('DY3JetsToLL' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'DY3'),
                       'puUp': make_puCorrectorUp(dataset, 'DY3'),  
                       'puDown': make_puCorrectorDown(dataset, 'DY3')}
    elif bool('DY4JetsToLL' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'DY4'),
                       'puUp': make_puCorrectorUp(dataset, 'DY4'),  
                       'puDown': make_puCorrectorDown(dataset, 'DY4')} 
    elif bool('WJetsToLNu' in target):      
        pucorrector = {'' : make_puCorrector(dataset, 'W'),
                       'puUp' : make_puCorrectorUp(dataset, 'W'),  
                       'puDown' : make_puCorrectorDown(dataset, 'W')}
    elif bool('W1JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'W1'),
                       'puUp' : make_puCorrectorUp(dataset, 'W1'),
                       'puDown' : make_puCorrectorDown(dataset, 'W1')}
    elif bool('W2JetsToLNu' in target):                                                                            
        pucorrector = {'' : make_puCorrector(dataset, 'W2'),
                       'puUp' : make_puCorrectorUp(dataset, 'W2'),
                       'puDown' : make_puCorrectorDown(dataset, 'W2')}
    elif bool('W3JetsToLNu' in target): 
        pucorrector = {'' : make_puCorrector(dataset, 'W3'),
                       'puUp' : make_puCorrectorUp(dataset, 'W3'),
                       'puDown' : make_puCorrectorDown(dataset, 'W3')}
    elif bool('W4JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'W4'),
                       'puUp' : make_puCorrectorUp(dataset, 'W4'),
                       'puDown' : make_puCorrectorDown(dataset, 'W4')}
    elif bool('WGToLNuG' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'WGamma'),
                       'puUp' : make_puCorrectorUp(dataset, 'WGamma'),
                       'puDown' : make_puCorrectorDown(dataset, 'WGamma')}
    elif bool('WW_TuneCP5' in target):                                                                                                                                                                                                                        
        pucorrector = {'' : make_puCorrector(dataset, 'WW'),
                       'puUp': make_puCorrectorUp(dataset, 'WW'),
                       'puDown': make_puCorrectorDown(dataset, 'WW')}
    elif bool('WZ_TuneCP5' in target): 
        pucorrector = {'' : make_puCorrector(dataset, 'WZ'),
                       'puUp': make_puCorrectorUp(dataset, 'WZ'),
                       'puDown': make_puCorrectorDown(dataset, 'WZ')}
    elif bool('ZZ_TuneCP5' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'ZZ'),
                       'puUp': make_puCorrectorUp(dataset, 'ZZ'),
                       'puDown': make_puCorrectorDown(dataset, 'ZZ')}
    elif bool('EWKWMinus' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'EWKWminus'),
                       'puUp': make_puCorrectorUp(dataset, 'EWKWminus'),
                       'puDown': make_puCorrectorDown(dataset, 'EWKWminus')}
    elif bool('EWKWPlus' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'EWKWplus'),
                       'puUp': make_puCorrectorUp(dataset, 'EWKWplus'),
                       'puDown': make_puCorrectorDown(dataset, 'EWKWplus')}
    elif bool('EWKZ2Jets_ZToLL' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'EWKZll'),
                       'puUp': make_puCorrectorUp(dataset, 'EWKZll'),
                       'puDown': make_puCorrectorDown(dataset, 'EWKZll')}
    elif bool('EWKZ2Jets_ZToNuNu' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'EWKZnunu'),
                       'puUp': make_puCorrectorUp(dataset, 'EWKZnunu'),
                       'puDown': make_puCorrectorDown(dataset, 'EWKZnunu')}
    elif bool('ZHToTauTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'ZHTT'),
                       'puUp': make_puCorrectorUp(dataset, 'ZHTT'),
                       'puDown': make_puCorrectorDown(dataset, 'ZHTT')}
    elif bool('ttHToTauTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'ttH'),
                       'puUp': make_puCorrectorUp(dataset, 'ttH'),
                       'puDown': make_puCorrectorDown(dataset, 'ttH')}
    elif bool('Wminus' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'WminusHTT'),
                       'puUp': make_puCorrectorUp(dataset, 'WminusHTT'),
                       'puDown': make_puCorrectorDown(dataset, 'WminusHTT')}
    elif bool('Wplus' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'WplusHTT'),
                       'puUp': make_puCorrectorUp(dataset, 'WplusHTT'),
                       'puDown': make_puCorrectorDown(dataset, 'WplusHTT')}
    elif bool('ST_t-channel_antitop' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'STtantitop'),
                       'puUp': make_puCorrectorUp(dataset, 'STtantitop'),
                       'puDown': make_puCorrectorDown(dataset, 'STtantitop')}
    elif bool('ST_t-channel_top' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'STttop'),
                       'puUp': make_puCorrectorUp(dataset, 'STttop'),
                       'puDown': make_puCorrectorDown(dataset, 'STttop')} 
    elif bool('ST_tW_antitop' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'STtWantitop'),
                       'puUp': make_puCorrectorUp(dataset, 'STtWantitop'),
                       'puDown': make_puCorrectorDown(dataset, 'STtWantitop')}
    elif bool('ST_tW_top' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'STtWtop'),
                       'puUp': make_puCorrectorUp(dataset, 'STtWtop'),
                       'puDown': make_puCorrectorDown(dataset, 'STtWtop')}
    elif bool('TTTo2L2Nu' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'TTTo2L2Nu'),
                       'puUp': make_puCorrectorUp(dataset, 'TTTo2L2Nu'),
                       'puDown': make_puCorrectorDown(dataset, 'TTTo2L2Nu')}
    elif bool('TTToHadronic' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'TTToHadronic'),
                       'puUp': make_puCorrectorUp(dataset, 'TTToHadronic'),
                       'puDown': make_puCorrectorDown(dataset, 'TTToHadronic')}
    elif bool('TTToSemiLeptonic' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'TTToSemiLeptonic'),
                       'puUp': make_puCorrectorUp(dataset, 'TTToSemiLeptonic'),
                       'puDown': make_puCorrectorDown(dataset, 'TTToSemiLeptonic')}
    elif bool('GluGlu_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'GGHMT'),
                       'puUp': make_puCorrectorUp(dataset, 'GGHMT'),
                       'puDown': make_puCorrectorDown(dataset, 'GGHMT')} 
    elif bool('GluGlu_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'GGHET'),
                       'puUp': make_puCorrectorUp(dataset, 'GGHET'),
                       'puDown': make_puCorrectorDown(dataset, 'GGHET')} 
    elif bool('GluGluHToTauTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'GGHTT'),
                       'puUp': make_puCorrectorUp(dataset, 'GGHTT'),
                       'puDown': make_puCorrectorDown(dataset, 'GGHTT')}
    elif bool('GluGluHToWW' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'GGHWW'),
                       'puUp': make_puCorrectorUp(dataset, 'GGHWW'),
                       'puDown': make_puCorrectorDown(dataset, 'GGHWW')}
    elif bool('VBF_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'VBFHMT'),
                       'puUp': make_puCorrectorUp(dataset, 'VBFHMT'),
                       'puDown': make_puCorrectorDown(dataset, 'VBFHMT')} 
    elif bool('VBF_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'VBFHET'),
                       'puUp': make_puCorrectorUp(dataset, 'VBFHET'),
                       'puDown': make_puCorrectorDown(dataset, 'VBFHET')} 
    elif bool('VBFHToTauTau' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'VBFHTT'),
                       'puUp': make_puCorrectorUp(dataset, 'VBFHTT'),
                       'puDown': make_puCorrectorDown(dataset, 'VBFHTT')}
    elif bool('VBFHToWW' in target):
        pucorrector = {'' : make_puCorrector(dataset, 'VBFHWW'),
                       'puUp': make_puCorrectorUp(dataset, 'VBFHWW'),
                       'puDown': make_puCorrectorDown(dataset, 'VBFHWW')}
    else:
        pucorrector = {'' : make_puCorrector(dataset, 'DY'),
                       'puUp': make_puCorrectorUp(dataset, 'DY'),
                       'puDown': make_puCorrectorDown(dataset, 'DY')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2018()
DYreweightReco = DYCorrectionReco.make_DYreweight()
#Metcorected = RecoilCorrector("../../FinalStateAnalysis/TagAndProbe/data/Type1_PFMET_2018.root")
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
Ele24 = EGammaPOGCorrections.el_Ele24_2018
Ele32or35 = EGammaPOGCorrections.el_Ele32orEle35_2018
Ele35 = EGammaPOGCorrections.el_Ele35_2018
EleIdIso = EGammaPOGCorrections.el_IdIso_2018

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2018/htt_scalefactors_v18_2.root")
w1 = f1.Get("w")
