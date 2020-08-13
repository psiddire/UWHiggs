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

cmsswBase = os.environ['CMSSW_BASE'] + '/src/FinalStateAnalysis/TagAndProbe/data/2016/'
f1 = ROOT.TFile(cmsswBase + 'htt_scalefactors_legacy_2016.root')
w1 = f1.Get('w')

