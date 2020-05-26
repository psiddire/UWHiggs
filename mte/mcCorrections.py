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

year = '2016'

pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu.root'))
pu_distributionsUp = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_up.root'))
pu_distributionsDown = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_MuonEG*pu_down.root'))

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
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2016()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2016()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2016()
Ele25 = EGammaPOGCorrections.el_Ele25_2016
EleIdIso = EGammaPOGCorrections.el_IdIso_2016

cmsswBase = '/afs/hep.wisc.edu/home/psiddire/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data/2016/'
f1 = ROOT.TFile(cmsswBase + 'htt_scalefactors_legacy_2016.root')
w1 = f1.Get('w')

fphi = ROOT.TFile(cmsswBase + 'MuEEmbedPhi.root')
wphi0 = fphi.Get('0Jet')
wphi1 = fphi.Get('1Jet')
wphi2 = fphi.Get('2Jet')

def EmbedPhi(phi, njets, mjj):
    if njets==0:
        corr = wphi0.GetBinContent(wphi0.GetXaxis().FindBin(phi))
    elif njets==1:
        corr = wphi1.GetBinContent(wphi1.GetXaxis().FindBin(phi))
    elif njets==2 and mjj < 550:
        corr = wphi2.GetBinContent(wphi2.GetXaxis().FindBin(phi))
    else:
        corr = 1.0
    if corr > 3.0:
        return 1.0
    else:
        return corr

feta = ROOT.TFile(cmsswBase + 'MuEEmbedEta.root')
weta0 = feta.Get('0Jet')
weta1 = feta.Get('1Jet')
weta2 = feta.Get('2Jet')

def EmbedEta(eta, njets, mjj):
    if njets==0:
        corr = weta0.GetBinContent(weta0.GetXaxis().FindBin(eta))
    elif njets==1:
        corr = weta1.GetBinContent(weta1.GetXaxis().FindBin(eta))
    elif njets==2 and mjj < 550:
        corr = weta2.GetBinContent(weta2.GetXaxis().FindBin(eta))
    else:
        corr = 1.0
    if corr > 3.0 or abs(eta) > 2.4:
        return 1.0
    else:
        return corr

def MESSys(eta):
    if eta < 1.2:
        me = 0.004
        mes = ['/mes1p2Up', '/mes1p2Down']
    elif eta < 2.1:
        me = 0.009
        mes = ['/mes2p1Up', '/mes2p1Down']
    else:
        me = 0.027
        mes = ['/mes2p4Up', '/mes2p4Down']
    return [me, mes]

def RecSys(njets):
    if njets==0:
        rSys = ['/recresp0Up', '/recresp0Down', '/recreso0Up', '/recreso0Down']
    elif njets==1:
        rSys = ['/recresp1Up', '/recresp1Down', '/recreso1Up', '/recreso1Down']
    else:
        rSys = ['/recresp2Up', '/recresp2Down', '/recreso2Up', '/recreso2Down']
    return rSys
