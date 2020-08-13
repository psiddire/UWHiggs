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

year = '2016'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root'))
pu_distributionsUp = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root'))
pu_distributionsDown = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def make_puCorrectorUp(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsUp)

def make_puCorrectorDown(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributionsDown)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('DY'), 'puUp': make_puCorrectorUp('DY'), 'puDown': make_puCorrectorDown('DY')}
    return pucorrector

rc = RoccoR.RoccoR('2016/RoccoR/RoccoR2016.txt')
DYreweight = DYCorrection.make_DYreweight_2016()
Metcorected = RecoilCorrector.Metcorrected('2016/TypeI-PFMet_Run2016_legacy.root')
MetSys = MEtSys.MEtSystematics('2016/PFMEtSys_2016.root')
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
tesMC = TauPOGCorrections.make_tau_pog_TES_2016()
fesTau = TauPOGCorrections.Tau_FES_2016

cmsswBase = os.environ['CMSSW_BASE'] + '/src/FinalStateAnalysis/TagAndProbe/data/2016/'
f1 = ROOT.TFile(cmsswBase + 'htt_scalefactors_legacy_2016.root')
w1 = f1.Get('w')

fpt = ROOT.TFile(cmsswBase + 'MuTauEmbedPt.root')
wpt0 = fpt.Get('0Jet')
wpt1 = fpt.Get('1Jet')
wpt2 = fpt.Get('2Jet')

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
        st = (0.008, ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = (0.006, ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = (0.008, ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = (0.011, ['/scaletDM11Up', '/scaletDM11Down'])
    return st

def ScaleEmbTau(dm):
    if dm==0:
        st = ([0.998, 0.005, -0.005], ['/scaletDM0Up', '/scaletDM0Down'])
    elif dm==1:
        st = ([0.998, 0.002, -0.003], ['/scaletDM1Up', '/scaletDM1Down'])
    elif dm==10:
        st = ([0.987, 0.003, -0.005], ['/scaletDM10Up', '/scaletDM10Down'])
    elif dm==11:
        st = ([0.987, 0.003, -0.005], ['/scaletDM11Up', '/scaletDM11Down'])
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

def MESSys(eta):
    if eta < 1.2:
        me = 0.004
        mes = ['/mes1p2Up', '/mes1p2Down']
    else:
        me = 0.009
        mes = ['/mes2p1Up', '/mes2p1Down']
    return [me, mes]

def RecSys(njets):
    if njets==0:
        rSys = ['/recresp0Up', '/recresp0Down', '/recreso0Up', '/recreso0Down']
    elif njets==1:
        rSys = ['/recresp1Up', '/recresp1Down', '/recreso1Up', '/recreso1Down']
    else:
        rSys = ['/recresp2Up', '/recresp2Down', '/recreso2Up', '/recreso2Down']
    return rSys
