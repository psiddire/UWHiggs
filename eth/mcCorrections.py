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
pu_distributionsUp = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu_up.root'))
pu_distributionsDown = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_EGamma*pu_down.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def make_puCorrectorUp(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsUp)

def make_puCorrectorDown(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsDown)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('DY'), 'puUp': make_puCorrectorUp('DY'), 'puDown': make_puCorrectorDown('DY')}
    return pucorrector

DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected('2018/TypeI-PFMet_Run2018.root')
MetSys = MEtSys.MEtSystematics('2017/PFMEtSys_2017.root')
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

cmsswBase = '/afs/hep.wisc.edu/home/psiddire/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data/2018/'
f1 = ROOT.TFile(cmsswBase + 'htt_scalefactors_legacy_2018.root')
w1 = f1.Get('w')

fpt = ROOT.TFile(cmsswBase + 'ETauEmbedPt.root')
wpt0 = fpt.Get('0Jet')
wpt1 = fpt.Get('1Jet')
wpt2 = fpt.Get('2Jet')

def EmbedPt(pt, njets, mjj):
    if njets==0:
        corr = wpt0.GetBinContent(wpt0.GetXaxis().FindBin(pt))
    elif njets==1:
        corr =  wpt1.GetBinContent(wpt1.GetXaxis().FindBin(pt))
    elif njets==2 and mjj < 500:
        corr = wpt2.GetBinContent(wpt2.GetXaxis().FindBin(pt))
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

def EmbedEta(eta, njets, mjj):
    if njets==0:
        sf = weta0.GetBinContent(weta0.GetXaxis().FindBin(eta))
    elif njets==1:
        sf = weta1.GetBinContent(weta1.GetXaxis().FindBin(eta))
    elif njets==2 and mjj < 500:
        sf = weta2.GetBinContent(weta2.GetXaxis().FindBin(eta))
    else:
        sf = 1.0
    if sf > 3:
        return 1.0
    else:
        return sf

fphi = ROOT.TFile(cmsswBase + 'ETauEmbedPhi.root')
wphi0 = fphi.Get('0Jet')
wphi1 = fphi.Get('1Jet')
wphi2 = fphi.Get('2Jet')

def EmbedPhi(phi, njets, mjj):
    if njets==0:
        sf = wphi0.GetBinContent(wphi0.GetXaxis().FindBin(phi))
    elif njets==1:
        sf = wphi1.GetBinContent(wphi1.GetXaxis().FindBin(phi))
    elif njets==2 and mjj < 500:
        sf = wphi2.GetBinContent(wphi2.GetXaxis().FindBin(phi))
    else:
        sf = 1.0
    if sf > 3:
        return 1.0
    else:
        return sf

def FesTau(eta, dm):
    fes = (1.0, 0.0, 0.0)
    ef = []
    if abs(eta) < 1.479:
        if dm == 0:
            fes = fesTau('EBDM0')
            ef = ['etfakeesbdm0Up', 'etfakeesbdm0Down']
        elif dm == 1:
            fes = fesTau('EBDM1')
            ef = ['etfakeesbdm1Up', 'etfakeesbdm1Down']
    else:
        if dm == 0:
            fes = fesTau('EEDM0')
            ef = ['etfakeesedm0Up', 'etfakeesedm0Down']
        elif dm == 1:
            fes = fesTau('EEDM1')
            ef = ['etfakeesedm1Up', 'etfakeesedm1Down']
    return [fes, ef]

def ScaleTau(dm):
    if dm==0:
        st = ([0.007, -0.007], ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = ([0.004, -0.004], ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = ([0.005, -0.005], ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = ([0.011, -0.009], ['/scaletDM11Up', '/scaletDM11Down'])
    return st

def ScaleEmbTau(dm):
    if dm==0:
        st = ([0.004, -0.004], ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = ([0.004, -0.003], ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = ([0.003, -0.003], ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = ([0.003, -0.003], ['/scaletDM11Up', '/scaletDM11Down'])
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
