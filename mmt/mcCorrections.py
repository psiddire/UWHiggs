import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.DYCorrectionReco as DYCorrectionReco
import ROOT
import RoccoR

dataset = 'singlem'
year = '2018'

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

def make_puCorrector(puname=''):
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight(puname, year, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorUp(puname=''):
    if dataset in pu_distributionsUp:
        return PileupWeight.PileupWeight(puname, year, *(pu_distributionsUp[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorDown(puname=''):
    if dataset in pu_distributionsDown:
        return PileupWeight.PileupWeight(puname, year, *(pu_distributionsDown[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def puCorrector(target=''):
    if bool('DYJetsToLL_M-50' in target):
        pucorrector = {'' : make_puCorrector('DY'),
                       'puUp': make_puCorrectorUp('DY'),
                       'puDown': make_puCorrectorDown('DY')}
    elif bool('DYJetsToLL_M-10to50' in target):                    
        pucorrector = {'' : make_puCorrector('DY10'),
                       'puUp': make_puCorrectorUp('DY10'),
                       'puDown': make_puCorrectorDown('DY10')}
    elif bool('DY1JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY1'),
                       'puUp': make_puCorrectorUp('DY1'),
                       'puDown': make_puCorrectorDown('DY1')}
    elif bool('DY2JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY2'),
                       'puUp': make_puCorrectorUp('DY2'),  
                       'puDown': make_puCorrectorDown('DY2')}
    elif bool('DY3JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY3'),
                       'puUp': make_puCorrectorUp('DY3'),  
                       'puDown': make_puCorrectorDown('DY3')}
    elif bool('DY4JetsToLL' in target):
        pucorrector = {'' : make_puCorrector('DY4'),
                       'puUp': make_puCorrectorUp('DY4'),  
                       'puDown': make_puCorrectorDown('DY4')} 
    elif bool('WJetsToLNu' in target):      
        pucorrector = {'' : make_puCorrector('W'),
                       'puUp' : make_puCorrectorUp('W'),  
                       'puDown' : make_puCorrectorDown('W')}
    elif bool('W1JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector('W1'),
                       'puUp' : make_puCorrectorUp('W1'),
                       'puDown' : make_puCorrectorDown('W1')}
    elif bool('W2JetsToLNu' in target):                                                                            
        pucorrector = {'' : make_puCorrector('W2'),
                       'puUp' : make_puCorrectorUp('W2'),
                       'puDown' : make_puCorrectorDown('W2')}
    elif bool('W3JetsToLNu' in target): 
        pucorrector = {'' : make_puCorrector('W3'),
                       'puUp' : make_puCorrectorUp('W3'),
                       'puDown' : make_puCorrectorDown('W3')}
    elif bool('W4JetsToLNu' in target):
        pucorrector = {'' : make_puCorrector('W4'),
                       'puUp' : make_puCorrectorUp('W4'),
                       'puDown' : make_puCorrectorDown('W4')}
    elif bool('WGToLNuG' in target):
        pucorrector = {'' : make_puCorrector('WGamma'),
                       'puUp' : make_puCorrectorUp('WGamma'),
                       'puDown' : make_puCorrectorDown('WGamma')}
    elif bool('WW_TuneCP5' in target):                                                                                                                                                                                                                        
        pucorrector = {'' : make_puCorrector('WW'),
                       'puUp': make_puCorrectorUp('WW'),
                       'puDown': make_puCorrectorDown('WW')}
    elif bool('WZ_TuneCP5' in target): 
        pucorrector = {'' : make_puCorrector('WZ'),
                       'puUp': make_puCorrectorUp('WZ'),
                       'puDown': make_puCorrectorDown('WZ')}
    elif bool('ZZ_TuneCP5' in target):
        pucorrector = {'' : make_puCorrector('ZZ'),
                       'puUp': make_puCorrectorUp('ZZ'),
                       'puDown': make_puCorrectorDown('ZZ')}
    elif bool('EWKWMinus' in target):
        pucorrector = {'' : make_puCorrector('EWKWminus'),
                       'puUp': make_puCorrectorUp('EWKWminus'),
                       'puDown': make_puCorrectorDown('EWKWminus')}
    elif bool('EWKWPlus' in target):
        pucorrector = {'' : make_puCorrector('EWKWplus'),
                       'puUp': make_puCorrectorUp('EWKWplus'),
                       'puDown': make_puCorrectorDown('EWKWplus')}
    elif bool('EWKZ2Jets_ZToLL' in target):
        pucorrector = {'' : make_puCorrector('EWKZll'),
                       'puUp': make_puCorrectorUp('EWKZll'),
                       'puDown': make_puCorrectorDown('EWKZll')}
    elif bool('EWKZ2Jets_ZToNuNu' in target):
        pucorrector = {'' : make_puCorrector('EWKZnunu'),
                       'puUp': make_puCorrectorUp('EWKZnunu'),
                       'puDown': make_puCorrectorDown('EWKZnunu')}
    elif bool('ZHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('ZHTT'),
                       'puUp': make_puCorrectorUp('ZHTT'),
                       'puDown': make_puCorrectorDown('ZHTT')}
    elif bool('ttHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('ttH'),
                       'puUp': make_puCorrectorUp('ttH'),
                       'puDown': make_puCorrectorDown('ttH')}
    elif bool('Wminus' in target):
        pucorrector = {'' : make_puCorrector('WminusHTT'),
                       'puUp': make_puCorrectorUp('WminusHTT'),
                       'puDown': make_puCorrectorDown('WminusHTT')}
    elif bool('Wplus' in target):
        pucorrector = {'' : make_puCorrector('WplusHTT'),
                       'puUp': make_puCorrectorUp('WplusHTT'),
                       'puDown': make_puCorrectorDown('WplusHTT')}
    elif bool('ST_t-channel_antitop' in target):
        pucorrector = {'' : make_puCorrector('STtantitop'),
                       'puUp': make_puCorrectorUp('STtantitop'),
                       'puDown': make_puCorrectorDown('STtantitop')}
    elif bool('ST_t-channel_top' in target):
        pucorrector = {'' : make_puCorrector('STttop'),
                       'puUp': make_puCorrectorUp('STttop'),
                       'puDown': make_puCorrectorDown('STttop')} 
    elif bool('ST_tW_antitop' in target):
        pucorrector = {'' : make_puCorrector('STtWantitop'),
                       'puUp': make_puCorrectorUp('STtWantitop'),
                       'puDown': make_puCorrectorDown('STtWantitop')}
    elif bool('ST_tW_top' in target):
        pucorrector = {'' : make_puCorrector('STtWtop'),
                       'puUp': make_puCorrectorUp('STtWtop'),
                       'puDown': make_puCorrectorDown('STtWtop')}
    elif bool('TTTo2L2Nu' in target):
        pucorrector = {'' : make_puCorrector('TTTo2L2Nu'),
                       'puUp': make_puCorrectorUp('TTTo2L2Nu'),
                       'puDown': make_puCorrectorDown('TTTo2L2Nu')}
    elif bool('TTToHadronic' in target):
        pucorrector = {'' : make_puCorrector('TTToHadronic'),
                       'puUp': make_puCorrectorUp('TTToHadronic'),
                       'puDown': make_puCorrectorDown('TTToHadronic')}
    elif bool('TTToSemiLeptonic' in target):
        pucorrector = {'' : make_puCorrector('TTToSemiLeptonic'),
                       'puUp': make_puCorrectorUp('TTToSemiLeptonic'),
                       'puDown': make_puCorrectorDown('TTToSemiLeptonic')}
    elif bool('GluGlu_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('GGHMT'),
                       'puUp': make_puCorrectorUp('GGHMT'),
                       'puDown': make_puCorrectorDown('GGHMT')} 
    elif bool('GluGlu_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector('GGHET'),
                       'puUp': make_puCorrectorUp('GGHET'),
                       'puDown': make_puCorrectorDown('GGHET')} 
    elif bool('GluGluHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('GGHTT'),
                       'puUp': make_puCorrectorUp('GGHTT'),
                       'puDown': make_puCorrectorDown('GGHTT')}
    elif bool('GluGluHToWW' in target):
        pucorrector = {'' : make_puCorrector('GGHWW'),
                       'puUp': make_puCorrectorUp('GGHWW'),
                       'puDown': make_puCorrectorDown('GGHWW')}
    elif bool('VBF_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('VBFHMT'),
                       'puUp': make_puCorrectorUp('VBFHMT'),
                       'puDown': make_puCorrectorDown('VBFHMT')} 
    elif bool('VBF_LFV_HToETau' in target):
        pucorrector = {'' : make_puCorrector('VBFHET'),
                       'puUp': make_puCorrectorUp('VBFHET'),
                       'puDown': make_puCorrectorDown('VBFHET')} 
    elif bool('VBFHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('VBFHTT'),
                       'puUp': make_puCorrectorUp('VBFHTT'),
                       'puDown': make_puCorrectorDown('VBFHTT')}
    elif bool('VBFHToWW' in target):
        pucorrector = {'' : make_puCorrector('VBFHWW'),
                       'puUp': make_puCorrectorUp('VBFHWW'),
                       'puDown': make_puCorrectorDown('VBFHWW')}
    else:
        pucorrector = {'' : make_puCorrector('DY'),
                       'puUp': make_puCorrectorUp('DY'),
                       'puDown': make_puCorrectorDown('DY')}
    return pucorrector

rc = RoccoR.RoccoR("../../FinalStateAnalysis/TagAndProbe/data/2018/RoccoR/RoccoR2018.txt")
DYreweight = DYCorrection.make_DYreweight_2018()
DYreweightReco = DYCorrectionReco.make_DYreweight()
#Metcorected = RecoilCorrector("../../FinalStateAnalysis/TagAndProbe/data/2018/Type1_PFMET_2018.root")
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
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
