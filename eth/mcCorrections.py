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

year = '2017'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root'))
pu_distributionsUp = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_up.root'))
pu_distributionsDown = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_down.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def make_puCorrectorUp(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsUp)

def make_puCorrectorDown(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsDown)

def puCorrector(target=''):
    if bool('DYJetsToLL_M-50' in target):
        pucorrector = {'' : make_puCorrector('DY'), 'puUp' : make_puCorrectorUp('DY'), 'puDown' : make_puCorrectorDown('DY')}
    elif bool('Wminus' in target):
        pucorrector = {'' : make_puCorrector('WminusHTT'), 'puUp' : make_puCorrectorUp('WminusHTT'), 'puDown' : make_puCorrectorDown('WminusHTT')}
    elif bool('Wplus' in target):
        pucorrector = {'' : make_puCorrector('WplusHTT'), 'puUp' : make_puCorrectorUp('WplusHTT'), 'puDown' : make_puCorrectorDown('WplusHTT')}
    else:
        pucorrector = {'' : make_puCorrector('DY1'), 'puUp' : make_puCorrectorUp('DY1'), 'puDown' : make_puCorrectorDown('DY1')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2017()
Metcorected = RecoilCorrector.Metcorrected('2017/Type1_PFMET_2017.root')
MetSys = MEtSys.MEtSystematics('2017/PFMEtSys_2017.root')
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2017()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2017()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2017()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2017()
eReco = EGammaPOGCorrections.make_egamma_pog_Reco_2017()
deepTauVSe = TauPOGCorrections.make_tau_pog_DeepTauVSe_2017('Tight')
againstEle = TauPOGCorrections.make_tau_pog_againstElectron_2017('Tight')
deepTauVSmu = TauPOGCorrections.make_tau_pog_DeepTauVSmu_2017('Loose')
againstMu = TauPOGCorrections.make_tau_pog_againstMuon_2017('Loose')
deepTauVSjet_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2017('Tight')
deepTauVSjet_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_2017('VLoose')
deepTauVSjet_Emb_tight = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2017('Tight')
deepTauVSjet_Emb_vloose = TauPOGCorrections.make_tau_pog_DeepTauVSjet_EMB_2017('VLoose')
mvaTau_tight = TauPOGCorrections.make_tau_pog_MVA_2017('Tight')
mvaTau_vloose = TauPOGCorrections.make_tau_pog_MVA_2017('VLoose')
esTau = TauPOGCorrections.make_tau_pog_ES_2017()
tesMC = TauPOGCorrections.make_tau_pog_TES_2017()
fesTau = TauPOGCorrections.Tau_FES_2017
tauSF = getTauTriggerSFs()

cmsswBase = '/afs/hep.wisc.edu/home/ndev/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data/2017/'
f2 = ROOT.TFile(cmsswBase + 'htt_scalefactors_2017_v2.root')
w2 = f2.Get('w')

f6 = ROOT.TFile(cmsswBase + 'htt_scalefactors_v17_6.root')
w6 = f6.Get('w')

fpt = ROOT.TFile(cmsswBase + 'ETauEmbedPt.root')
wpt0 = fpt.Get('0Jet')
wpt1 = fpt.Get('1Jet')
wpt2 = fpt.Get('2Jet')
wpt3 = fpt.Get('2JetVBF')

def EmbedPt(pt, njets, mjj):
    if njets==0:
        corr = wpt0.GetBinContent(wpt0.GetXaxis().FindBin(pt))
    elif njets==1:
        corr =  wpt1.GetBinContent(wpt1.GetXaxis().FindBin(pt))
    elif njets==2 and mjj < 500:
        corr = wpt2.GetBinContent(wpt2.GetXaxis().FindBin(pt))
    elif njets==2 and mjj > 500:
        corr = wpt3.GetBinContent(wpt3.GetXaxis().FindBin(pt))
    else:
        corr = 1.0
    if corr > 3.0:
        return 1
    else:
        return corr

feta = ROOT.TFile(cmsswBase + 'ETauEmbedEta.root')
weta0 = feta.Get('0Jet')
weta1 = feta.Get('1Jet')
weta2 = feta.Get('2Jet')
weta3 = feta.Get('2JetVBF')

def EmbedEta(eta, njets, mjj):
    if njets==0:
        return weta0.GetBinContent(weta0.GetXaxis().FindBin(eta))
    elif njets==1:
        return weta1.GetBinContent(weta1.GetXaxis().FindBin(eta))
    elif njets==2 and mjj < 500:
        return weta2.GetBinContent(weta2.GetXaxis().FindBin(eta))
    elif njets==2 and mjj > 500:
        return weta3.GetBinContent(weta3.GetXaxis().FindBin(eta))
    else:
        return 1.0

fphi = ROOT.TFile(cmsswBase + 'ETauEmbedPhi.root')
wphi0 = fphi.Get('0Jet')
wphi1 = fphi.Get('1Jet')
wphi2 = fphi.Get('2Jet')
wphi3 = fphi.Get('2JetVBF')

def EmbedPhi(phi, njets, mjj):
    if njets==0:
        return wphi0.GetBinContent(wphi0.GetXaxis().FindBin(phi))
    elif njets==1:
        return wphi1.GetBinContent(wphi1.GetXaxis().FindBin(phi))
    elif njets==2 and mjj < 500:
        return wphi2.GetBinContent(wphi2.GetXaxis().FindBin(phi))
    elif njets==2 and mjj > 500:
        return wphi3.GetBinContent(wphi3.GetXaxis().FindBin(phi))
    else:
        return 1.0

def FesTau(eta, dm):
    fes = (1.0, 0.0, 0.0)
    ef = []
    if abs(eta) < 1.479:
        if dm == 0:
            fes = fesTau('EBDM0')
            ef = ['/etfakeesbdm0Up', '/etfakeesbdm0Down']
        elif dm == 1:
            fes = fesTau('EBDM1')
            ef = ['/etfakeesbdm1Up', '/etfakeesbdm1Down']
    else:
        if dm == 0:
            fes = fesTau('EEDM0')
            ef = ['/etfakeesedm0Up', '/etfakeesedm0Down']
        elif dm == 1:
            fes = fesTau('EEDM1')
            ef = ['/etfakeesedm1Up', '/etfakeesedm1Down']
    return [fes, ef]

def FesMuTau(dm):
    fes = 1.0
    if dm == 0:
        fes = 1.000
    elif dm == 1:
        fes = 0.995
    return fes

def ScaleTau(dm):
    if dm==0:
        st = (0.01, ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = (0.006, ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = (0.007, ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = (0.014, ['/scaletDM11Up', '/scaletDM11Down'])
    return st

def ScaleEmbTau(dm):
    if dm==0:
        st = ([1.000, 0.004, -0.004], ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = ([0.988, 0.005, -0.002], ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = ([0.992, 0.004, -0.005], ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = ([0.992, 0.004, -0.005], ['/scaletDM11Up', '/scaletDM11Down'])
    return st

def TauID(pt):
    if pt < 35:
        ti = ['/tid30Up', '/tid30Down']
    elif pt < 40:
        ti = ['/tid35Up', '/tid35Down']
    else:
        ti = ['/tid40Up', '/tid40Down']
    return ti

def MuonFakeTau(eta):
    if eta < 0.4:
        mf = ['/mtfake0Up', '/mtfake0Down']
    elif eta < 0.8:
        mf = ['/mtfake0p4Up', '/mtfake0p4Down']
    elif eta < 1.2:
        mf = ['/mtfake0p8Up', '/mtfake0p8Down']
    elif eta < 1.7:
        mf = ['/mtfake1p2Up', '/mtfake1p2Down']
    else:
        mf = ['/mtfake1p7Up', '/mtfake1p7Down']
    return mf

def EleFakeTau(eta):
    if eta < 1.479:
        ef = ['/etfakebUp', '/etfakebDown']
    else:
        ef = ['/etfakeeUp', '/etfakeeDown']
    return ef

def RecSys(njets):
    if njets==0:
        rSys = ['/recresp0Up', '/recresp0Down', '/recreso0Up', '/recreso0Down']
    elif njets==1:
        rSys = ['/recresp1Up', '/recresp1Down', '/recreso1Up', '/recreso1Down']
    elif njets==2:
        rSys = ['/recresp2Up', '/recresp2Down', '/recreso2Up', '/recreso2Down']
    return rSys
