import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import FinalStateAnalysis.TagAndProbe.MEtSys as MEtSys
import FinalStateAnalysis.TagAndProbe.RoccoR as RoccoR
import ROOT

dataset = 'muoneg'
year = '2016'

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
    elif bool('WW_Tune' in target):
        pucorrector = {'' : make_puCorrector('WW'),
                       'puUp': make_puCorrectorUp('WW'),
                       'puDown': make_puCorrectorDown('WW')}
    elif bool('WZ_Tune' in target): 
        pucorrector = {'' : make_puCorrector('WZ'),
                       'puUp': make_puCorrectorUp('WZ'),
                       'puDown': make_puCorrectorDown('WZ')}
    elif bool('ZZ_Tune' in target):
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
    elif bool('TT' in target):
        pucorrector = {'' : make_puCorrector('TT'),
                       'puUp': make_puCorrectorUp('TT'),
                       'puDown': make_puCorrectorDown('TT')}
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

rc = RoccoR.RoccoR("2016/RoccoR/RoccoR2016.txt")
DYreweight = DYCorrection.make_DYreweight_2016()
Metcorected = RecoilCorrector.Metcorrected("2016/TypeI-PFMet_Run2016_legacy.root")
MetSys = MEtSys.MEtSystematics("2016/PFMEtSys_2016.root")
mIDIso = MuonPOGCorrections.mIDIso
muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2016()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2016()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2016()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2016('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2016('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2016('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2016('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2016('Tight')
muonTrigger24 = MuonPOGCorrections.mu_IsoMu24_2016
muonTrigger22 = MuonPOGCorrections.mu_IsoMu22_2016
muonTracking = MuonPOGCorrections.mu_trackingEta_2016
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2016()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2016()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
Ele25 = EGammaPOGCorrections.el_Ele25_2016
EleIdIso = EGammaPOGCorrections.el_IdIso_2016

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2016/htt_scalefactors_legacy_2016.root")
w1 = f1.Get("w")

fphi = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2016/EMuEmbedPhi.root")
wphi0 = fphi.Get("0Jet")
wphi1 = fphi.Get("1Jet")
wphi2 = fphi.Get("2Jet")

def EmbedPhi(phi, njets, mjj):
    if njets==0:
        corr = wphi0.GetBinContent(wphi0.GetXaxis().FindBin(phi))
    elif njets==1:
        corr = wphi1.GetBinContent(wphi1.GetXaxis().FindBin(phi))
    elif njets==2 and mjj < 500:
        corr = wphi2.GetBinContent(wphi2.GetXaxis().FindBin(phi))
    else:
        corr = 1.0
    if corr > 2.5:
        return 1.0
    else:
        return corr

feta = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2016/EMuEmbedEta.root")
weta0 = feta.Get("0Jet")
weta1 = feta.Get("1Jet")
weta2 = feta.Get("2Jet")

def EmbedEta(eta, njets, mjj):
    if njets==0:
        corr = weta0.GetBinContent(weta0.GetXaxis().FindBin(eta))
    elif njets==1:
        corr =  weta1.GetBinContent(weta1.GetXaxis().FindBin(eta))
    elif njets==2 and mjj < 500:
        corr = weta2.GetBinContent(weta2.GetXaxis().FindBin(eta))
    else:
        corr = 1.0
    if corr > 2.0 or abs(eta) > 2.4:
        return 1
    else:
        return corr
