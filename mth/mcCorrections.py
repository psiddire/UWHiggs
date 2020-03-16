import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections
import FinalStateAnalysis.TagAndProbe.DYCorrection as DYCorrection
import FinalStateAnalysis.TagAndProbe.RecoilCorrector as RecoilCorrector
import FinalStateAnalysis.TagAndProbe.MEtSys as MEtSys
import FinalStateAnalysis.TagAndProbe.RoccoR as RoccoR
import ROOT

dataset = 'singlem'
year = '2016'

pu_distributions  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root'))
}
pu_distributionsUp  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_up.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_up.root'))
}
pu_distributionsDown  = {
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root')),
    'muoneg'   : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_down.root')),
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_down.root'))
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
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2016('VLoose')
againstEle = TauPOGCorrections.make_tau_pog_againstElectron_2016('VLoose')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2016('Tight')
againstMu = TauPOGCorrections.make_tau_pog_againstMuon_2016('Tight')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2016('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2016('VLoose')
mvaTau_tight = TauPOGCorrections.make_tau_pog_MVA_2016('Tight')
mvaTau_vloose = TauPOGCorrections.make_tau_pog_MVA_2016('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2016()
fesTau = TauPOGCorrections.Tau_FES_2016

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2016/htt_scalefactors_legacy_2016.root")
w1 = f1.Get("w")

fpt = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2016/MuTauEmbedPt.root")
wpt0 = fpt.Get("0Jet")
wpt1 = fpt.Get("1Jet")
wpt2 = fpt.Get("2Jet")

def EmbedPt(pt, njets, mjj):
    if njets==0:
        corr = wpt0.GetBinContent(wpt0.GetXaxis().FindBin(pt))
    elif njets==1:
        corr =  wpt1.GetBinContent(wpt1.GetXaxis().FindBin(pt))
    elif njets==2 and mjj < 550:
        corr = wpt2.GetBinContent(wpt2.GetXaxis().FindBin(pt))
    else:
        corr = 1.0
    if corr > 2.0:
        return 1
    else:
        return corr

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
