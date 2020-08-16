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

year = '2017'

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

rc = RoccoR.RoccoR("2017/RoccoR/RoccoR2017.txt")
DYreweight = DYCorrection.make_DYreweight_2017()
Metcorected = RecoilCorrector.Metcorrected("2017/Type1_PFMET_2017.root")
MetSys = MEtSys.MEtSystematics("2017/PFMEtSys_2017.root")
muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2017()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2017()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2017()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2017('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2017('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2017('Tight')
muonTrigger27 = MuonPOGCorrections.make_muon_pog_IsoMu27_2017()
muonTracking = MuonPOGCorrections.mu_trackingEta_2017
eID80 = EGammaPOGCorrections.make_egamma_pog_electronID80_2017()
eIDnoiso80 = EGammaPOGCorrections.make_egamma_pog_electronID80noiso_2017()
eID90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2017()
eIDnoiso90 = EGammaPOGCorrections.make_egamma_pog_electronID90_2017()
eReco = EGammaPOGCorrections.make_egamma_pog_Reco_2017()

cmsswBase = os.environ['CMSSW_BASE'] + '/src/FinalStateAnalysis/TagAndProbe/data/2017/'
f1 = ROOT.TFile(cmsswBase + 'htt_scalefactors_legacy_2017.root')
w1 = f1.Get('w')

