import os
import glob
import FinalStateAnalysis.TagAndProbe.PileupWeightNew as PileupWeightNew
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
mc_pu_tag = 'S6' if is7TeV else 'PU2017'


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

def make_shifted_weights(default, shifts, functors):
    '''make_shifted_weights(default, shifts, functors) --> functor
    takes as imput the central value functor and two lists
    the name of the shifts and the shifted functors
    the returned functor takes one additional string to
    select the shifted functor. If the shift kwarg is missing
    or does not match any shift tag the central (default)
    fuctor output is returned'''
    #make default fetching faster
    default = default 
    def functor(*args, **kwargs):
        shift = ''
        if 'shift' in kwargs:
            shift = kwargs['shift']
            del kwargs['shift']

            #check if to apply shifts
            for tag, fcn in zip(shifts, functors):
                if tag == shift:
                    return fcn(*args, **kwargs)

        return default(*args, **kwargs)
    return functor

fpt = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/MuTauEmbedPt.root")
wpt0 = fpt.Get("0Jet")
wpt1 = fpt.Get("1Jet")
wpt2 = fpt.Get("2Jet")

def EmbedPt(pt, njets, mjj):
    if pt > 200:
        return 1.0
    if njets==0:
        return wpt0.GetBinContent(wpt0.GetXaxis().FindBin(pt))
    elif njets==1:
        return wpt1.GetBinContent(wpt1.GetXaxis().FindBin(pt))
    elif njets==2 and mjj < 550:
        return wpt2.GetBinContent(wpt2.GetXaxis().FindBin(pt))
    else:
        return 1.0

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2615 - 0.0008124*pt
            elif shift=='frp0Up':
                fr = 0.271127 - 0.0008124*pt
            elif shift=='frp0Down':
                fr = 0.251873 - 0.0008124*pt
            elif shift=='frp1Up':
                fr = 0.2615 - 0.0006168*pt
            elif shift=='frp1Down':
                fr = 0.2615 - 0.001008*pt
        elif dm==1:
            if shift=='':
                fr = 0.2036 - 0.0006504*pt
            elif shift=='frp0Up':
                fr = 0.209283 - 0.0006504*pt
            elif shift=='frp0Down':
                fr = 0.197917 - 0.0006504*pt
            elif shift=='frp1Up':
                fr = 0.2036 - 0.0005396*pt
            elif shift=='frp1Down':
                fr = 0.2036 - 0.0007612*pt
        elif dm==10:
            if shift=='':
                fr = 0.1398 + 0.0000672*pt
            elif shift=='frp0Up':
                fr = 0.14983 + 0.0000672*pt
            elif shift=='frp0Down':
                fr = 0.12977 + 0.0000672*pt
            elif shift=='frp1Up':
                fr = 0.1398 + 0.0002811*pt
            elif shift=='frp1Down':
                fr = 0.1398 - 0.0001467*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.3012 - 0.001312*pt
            elif shift=='frp0Up':
                fr = 0.31557 - 0.001312*pt
            elif shift=='frp0Down':
                fr = 0.28683 - 0.001312*pt
            elif shift=='frp1Up':
                fr = 0.3012 - 0.001046*pt
            elif shift=='frp1Down':
                fr = 0.3012 - 0.001578*pt
        elif dm==1:
            if shift=='':
                fr = 0.1966 - 0.0004434*pt
            elif shift=='frp0Up':
                fr = 0.20785 - 0.0004434*pt
            elif shift=='frp0Down':
                fr = 0.18535 - 0.0004434*pt
            elif shift=='frp1Up':
                fr = 0.1966 - 0.0002202*pt
            elif shift=='frp1Down':
                fr = 0.1966 - 0.0006666*pt
        elif dm==10:
            if shift=='':
                fr = 0.1724 - 0.0003947*pt
            elif shift=='frp0Up':
                fr = 0.18904 - 0.0003947*pt
            elif shift=='frp0Down':
                fr = 0.15576 - 0.0003947*pt
            elif shift=='frp1Up':
                fr = 0.1724 - 0.0000369*pt
            elif shift=='frp1Down':
                fr = 0.1724 - 0.0007525*pt
    return fr/(1-fr)

def fakerateMuon_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = 0.7905 + 0.001371*pt
        elif shift=='frp0Up':
            fr = 0.797167 + 0.001371*pt
        elif shift=='frp0Down':
            fr = 0.783833 + 0.001371*pt
        elif shift=='frp1Up':
            fr = 0.7905 + 0.00146129*pt
        elif shift=='frp1Down':
            fr = 0.7905 + 0.00128071*pt
    else:
        fr = 0
    return fr/(1-fr)

rc = RoccoR.RoccoR("../../FinalStateAnalysis/NtupleTools/data/RoccoR2017.txt")

muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2017ReReco()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2017ReReco()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2017ReReco()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2017ReReco('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2017ReReco('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2017ReReco('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2017ReReco('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2017ReReco('Tight')
efficiency_trigger_mu_2017 = MuonPOGCorrections.make_muon_pog_IsoMu27_2017ReReco()
#fakerate_weight = FakeRate.FakeRateWeight()
#fakerateMuon_weight = FakeRate.FakeRateMuonWeight()
fakerateElectron_weight = FakeRate.FakeRateElectronWeight() 
muonTracking = MuonPOGCorrections.mu_trackingEta_2017
DYreweight = DYCorrection.make_DYreweight()
DYreweight1D = DYCorrection.make_DYreweight1D()
embedTrg = EmbedCorrections.embed_IsoMu27_2017ReReco()
embedmID = EmbedCorrections.embed_ID_2017ReReco()
embedmIso = EmbedCorrections.embed_Iso_2017ReReco()
eIDnoIsoWP90 = ElectronPOGCorrections.make_electron_pog_IDnoIsoWP90_2017ReReco()
eIDIsoWP90 = ElectronPOGCorrections.make_electron_pog_IDIsoWP90_2017ReReco()
eIDnoIsoWP80 = ElectronPOGCorrections.make_electron_pog_IDnoIsoWP80_2017ReReco()
eIDIsoWP80 = ElectronPOGCorrections.make_electron_pog_IDIsoWP80_2017ReReco()
eReco = ElectronPOGCorrections.make_electron_pog_Reco_2017ReReco()

f1 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v1.root")
w1 = f1.Get("w")

f2 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
w2 = f2.Get("w")

f3 = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v3.root")
w3 = f3.Get("w")

fe = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_v17_5.root")
we = fe.Get("w")

Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
MetSys = MEtSys("PFMEtSys_2017.root")

f_btag_eff = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/btag.root","r")
h_btag_eff_b = f_btag_eff.Get("btag_eff_b")
h_btag_eff_c = f_btag_eff.Get("btag_eff_c")
h_btag_eff_oth = f_btag_eff.Get("btag_eff_oth")

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
        pucorrector = {'' : make_puCorrector('singlem', None, 'WG'),
                       'puUp' : make_puCorrectorUp('singlem', None, 'WG'),
                       'puDown' : make_puCorrectorDown('singlem', None, 'WG')}
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
        pucorrector = {'' : make_puCorrector('singlem', None, 'Wminus'),
                       'puUp': make_puCorrectorUp('singlem', None, 'Wminus'),
                       'puDown': make_puCorrectorDown('singlem', None, 'Wminus')}
    elif bool('EWKWPlus' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'Wplus'),
                       'puUp': make_puCorrectorUp('singlem', None, 'Wplus'),
                       'puDown': make_puCorrectorDown('singlem', None, 'Wplus')}
    elif bool('EWKZ2Jets_ZToLL' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'Zll'),
                       'puUp': make_puCorrectorUp('singlem', None, 'Zll'),
                       'puDown': make_puCorrectorDown('singlem', None, 'Zll')}
    elif bool('EWKZ2Jets_ZToNuNu' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'Znunu'),
                       'puUp': make_puCorrectorUp('singlem', None, 'Znunu'),
                       'puDown': make_puCorrectorDown('singlem', None, 'Znunu')}
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
    elif bool('VBFHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'VBFHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'VBFHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'VBFHTT')}
    elif bool('VBF_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'VBFHMT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'VBFHMT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'VBFHMT')} 
    elif bool('GluGluHToTauTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'GGHTT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'GGHTT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'GGHTT')}
    elif bool('GluGlu_LFV_HToMuTau' in target):
        pucorrector = {'' : make_puCorrector('singlem', None, 'GGHMT'),
                       'puUp': make_puCorrectorUp('singlem', None, 'GGHMT'),
                       'puDown': make_puCorrectorDown('singlem', None, 'GGHMT')} 
    else:
        pucorrector = {'' : make_puCorrector('singlem', None, 'DY'),
                       'puUp': make_puCorrectorUp('singlem', None, 'DY'),
                       'puDown': make_puCorrectorDown('singlem', None, 'DY')}

    return pucorrector
