import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight2018 as PileupWeight2018
from FinalStateAnalysis.PlotTools.decorators import memo, memo_last
import FinalStateAnalysis.TagAndProbe.ElectronPOGCorrections as ElectronPOGCorrections
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EmbeddedCorrections as EmbedCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.FakeRate as FakeRate
from RecoilCorrector import RecoilCorrector
from MEtSys import MEtSys
import ROOT
import RoccoR

@memo
def getVar(name, var):
    return name+var

is7TeV = bool('7TeV' in os.environ['jobid'])
pu_distributions  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root'))
    }
pu_distributionsUp  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_up.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root'))
    }
pu_distributionsDown  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_down.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root'))
    }
mc_pu_tag = 'S6' if is7TeV else 'PU2018'


def make_puCorrector(dataset, kind=None, puname=''):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced %s'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributions:
        return PileupWeightNew.PileupWeightNew( 'S6' if is7TeV else puname, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorUp(dataset, kind=None, puname=''):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributionsUp:
        return PileupWeightNew.PileupWeightNew( 'S6' if is7TeV else puname, *(pu_distributionsUp[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorDown(dataset, kind=None, puname=''):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributionsDown:
        return PileupWeightNew.PileupWeightNew( 'S6' if is7TeV else puname, *(pu_distributionsDown[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    if bool('DYJetsToLL_M-50' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY'),
                       'puDown': make_puCorrectorDown('singlem', None, 'DY')}
    elif bool('DYJetsToLL_M-10to50' in target):                    
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY10'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY10'),
                       'puDown': make_puCorrectorDown('singlem', None, 'DY10')}
    elif bool('DY1JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY1'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY1'),
                       'puDown': make_puCorrectorDown('singlem', None, 'DY1')}
    elif bool('DY2JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY2'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY2'),  
                       'puDown': make_puCorrectorDown('singlem', None, 'DY2')}
    elif bool('DY3JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY3'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY3'),  
                       'puDown': make_puCorrectorDown('singlem', None, 'DY3')}
    elif bool('DY4JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY4'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY4'),  
                       'puDown': make_puCorrectorDown('singlem', None, 'DY4')} 
    elif bool('WJetsToLNu' in target):      
        pucorrector = {'' : make_puCorrector('singlem', None, 'W'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'W'),  
                       'puDown' : make_puCorrectorDown('singlem', None, 'W')}
    elif bool('W1JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'W1'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'W1'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'W1')}
    elif bool('W2JetsToLNu' in target):                                                                            
        pucorrector = {'' : make_puCorrector('singlem', None, 'W2'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'W2'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'W2')}
    elif bool('W3JetsToLNu' in target): 
        pucorrector = {'' : make_puCorrector('singlem', None, 'W3'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'W3'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'W3')}
    elif bool('W4JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'W4'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'W4'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'W4')}
    elif bool('WGToLNuG' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'WGamma'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'WGamma'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'WGamma')}
    elif bool('WW_TuneCP5' in target):                                                                                                                                                                                                                        
        pucorrector = {'' : make_puCorrector('singlem', None, 'WW'),
                       'puUp': make_puCorrectorUp('singlem', None, 'WW'),
                       'puDown': make_puCorrectorDown('singlem', None, 'WW')}
    elif bool('WZ_TuneCP5' in target): 
        pucorrector = {'' : make_puCorrector('singlem', None, 'WZ'),
                       'puUp': make_puCorrectorUp('singlem', None, 'WZ'),
                       'puDown': make_puCorrectorDown('singlem', None, 'WZ')}
    elif bool('ZZ_TuneCP5' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'ZZ'),
                       'puUp': make_puCorrectorUp('singlem', None, 'ZZ'),
                       'puDown': make_puCorrectorDown('singlem', None, 'ZZ')}
    elif bool('EWKWMinus' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'EWKWminus'),
                       'puUp': make_puCorrectorUp('singlem', None, 'EWKWminus'),
                       'puDown': make_puCorrectorDown('singlem', None, 'EWKWminus')}
    elif bool('EWKWPlus' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'EWKWplus'),
                       'puUp': make_puCorrectorUp('singlem', None, 'EWKWplus'),
                       'puDown': make_puCorrectorDown('singlem', None, 'EWKWplus')}
    elif bool('EWKZ2Jets_ZToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'EWKZll'),
                       'puUp': make_puCorrectorUp('singlem', None, 'EWKZll'),
                       'puDown': make_puCorrectorDown('singlem', None, 'EWKZll')}
    elif bool('EWKZ2Jets_ZToNuNu' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'EWKZnunu'),
                       'puUp': make_puCorrectorUp('singlem', None, 'EWKZnunu'),
                       'puDown': make_puCorrectorDown('singlem', None, 'EWKZnunu')}
    elif bool('ZHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'ZHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'ZHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'ZHTT')}
    elif bool('ttHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'ttH'),
                       'puUp': make_puCorrectorUp('singlem', None, 'ttH'),
                       'puDown': make_puCorrectorDown('singlem', None, 'ttH')}
    elif bool('Wminus' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'WminusHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'WminusHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'WminusHTT')}
    elif bool('Wplus' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'WplusHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'WplusHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'WplusHTT')}
    elif bool('ST_t-channel_antitop' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'STtantitop'),
                       'puUp': make_puCorrectorUp('singlem', None, 'STtantitop'),
                       'puDown': make_puCorrectorDown('singlem', None, 'STtantitop')}
    elif bool('ST_t-channel_top' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'STttop'),
                       'puUp': make_puCorrectorUp('singlem', None, 'STttop'),
                       'puDown': make_puCorrectorDown('singlem', None, 'STttop')} 
    elif bool('ST_tW_antitop' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'STtWantitop'),
                       'puUp': make_puCorrectorUp('singlem', None, 'STtWantitop'),
                       'puDown': make_puCorrectorDown('singlem', None, 'STtWantitop')}
    elif bool('ST_tW_top' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'STtWtop'),
                       'puUp': make_puCorrectorUp('singlem', None, 'STtWtop'),
                       'puDown': make_puCorrectorDown('singlem', None, 'STtWtop')}
    elif bool('TTTo2L2Nu' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'TTTo2L2Nu'),
                       'puUp': make_puCorrectorUp('singlem', None, 'TTTo2L2Nu'),
                       'puDown': make_puCorrectorDown('singlem', None, 'TTTo2L2Nu')}
    elif bool('TTToHadronic' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'TTToHadronic'),
                       'puUp': make_puCorrectorUp('singlem', None, 'TTToHadronic'),
                       'puDown': make_puCorrectorDown('singlem', None, 'TTToHadronic')}
    elif bool('TTToSemiLeptonic' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'TTToSemiLeptonic'),
                       'puUp': make_puCorrectorUp('singlem', None, 'TTToSemiLeptonic'),
                       'puDown': make_puCorrectorDown('singlem', None, 'TTToSemiLeptonic')}
    elif bool('GluGlu_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'GGHMT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'GGHMT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'GGHMT')} 
    elif bool('GluGluHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'GGHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'GGHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'GGHTT')}
    elif bool('GluGluHToWW' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'GGHWW'),
                       'puUp': make_puCorrectorUp('singlem', None, 'GGHWW'),
                       'puDown': make_puCorrectorDown('singlem', None, 'GGHWW')}
    elif bool('VBF_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'VBFHMT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'VBFHMT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'VBFHMT')} 
    elif bool('VBFHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'VBFHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'VBFHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'VBFHTT')}
    elif bool('VBFHToWW' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'VBFHWW'),
                       'puUp': make_puCorrectorUp('singlem', None, 'VBFHWW'),
                       'puDown': make_puCorrectorDown('singlem', None, 'VBFHWW')}
    else:
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY'),
                       'puDown': make_puCorrectorDown('singlem', None, 'DY')}

    return pucorrector
