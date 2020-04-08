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

year = '2018'

pu_distributions = glob.glob(os.path.join('inputs', os.environ['jobid'], 'data_MuonEG*pu.root'))

def make_puCorrector(puname=''):
    return PileupWeight.PileupWeight(puname, year, *pu_distributions)

def puCorrector(target=''):
    pucorrector = {'' : make_puCorrector('GGHET')}
    return pucorrector

rc = RoccoR.RoccoR('2018/RoccoR/RoccoR2018.txt')
DYreweight = DYCorrection.make_DYreweight_2018()
Metcorected = RecoilCorrector.Metcorrected('2018/TypeI-PFMet_Run2018.root')
MetSys = MEtSys.MEtSystematics('2017/PFMEtSys_2017.root')
eID = EGammaPOGCorrections.make_egamma_pog_electronID_2018()
muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2018()
muonID_medium = MuonPOGCorrections.make_muon_pog_PFMedium_2018()
muonID_loose = MuonPOGCorrections.make_muon_pog_PFLoose_2018()
muonIso_tight_tightid = MuonPOGCorrections.make_muon_pog_TightIso_2018('Tight')
muonIso_tight_mediumid = MuonPOGCorrections.make_muon_pog_TightIso_2018('Medium')
muonIso_loose_looseid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Loose')
muonIso_loose_mediumid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Medium')
muonIso_loose_tightid = MuonPOGCorrections.make_muon_pog_LooseIso_2018('Tight')
muonTrigger27 = MuonPOGCorrections.mu_IsoMu27_2018
muonTracking = MuonPOGCorrections.mu_trackingEta_2018

cmsswBase = '/afs/hep.wisc.edu/home/psiddire/CMSSW_10_2_16_UL/src/FinalStateAnalysis/TagAndProbe/data/'
f1 = ROOT.TFile(cmsswBase + '2018/htt_scalefactors_legacy_2018.root')
w1 = f1.Get('w')
