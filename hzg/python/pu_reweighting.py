import ROOT
from ROOT import gDirectory,TFile,TH1D

import os
from math import floor

from FinalStateAnalysis.Utilities.version import cmssw_major_version,\
     cmssw_minor_version

pwd = gDirectory.GetPath()

puS7  = None
puS10 = None
puS6  = None

from SimGeneral.MixingModule.mix_E7TeV_Fall2011_Reprocess_50ns_PoissonOOTPU_cfi \
     import mix as S6
puS6 = S6.input.nbPileupEvents

if cmssw_major_version() == 5 and cmssw_minor_version()==2:
    from SimGeneral.MixingModule.mix_2012_Startup_50ns_PoissonOOTPU_cfi \
         import mix as S7
    puS7 = S7.input.nbPileupEvents
elif cmssw_major_version() == 5 and cmssw_minor_version()==3:
    from SimGeneral.MixingModule.mix_2012_Startup_50ns_PoissonOOTPU_cfi \
         import mix as S7
    puS7 = S7.input.nbPileupEvents
    from SimGeneral.MixingModule.mix_2012_Summer_50ns_PoissonOOTPU_cfi \
         import mix as S10
    puS10 = S10.input.nbPileupEvents

puS10_norm = sum(puS10.probValue)
puS10_maxbin = len(puS10.probValue)

puhistos = {}

CD_file = TFile.Open(os.environ['CMSSW_BASE']+
                     '/src/UWHiggs/hzg/data/pu_truth_2012_CD.root','READ')
gDirectory.cd(pwd)
CD_truth_histo = CD_file.Get('pileup').Clone('CD2012_truth')
CD_file.Close()
gDirectory.cd(pwd)

CD_truth_histo.Scale(1./CD_truth_histo.Integral())
puhistos['CD_truth_histo'] = CD_truth_histo

def pu_S10_CD_reweight(mcPUTruth):   
    mc_histo_bin = min(int(mcPUTruth),puS10_maxbin)
    
    data_bin = min(puhistos['CD_truth_histo'].GetXaxis().FindBin(mcPUTruth),
                   puhistos['CD_truth_histo'].GetNbinsX())

    bin_width = puhistos['CD_truth_histo'].GetBinWidth(data_bin)
    
    dataProb = puhistos['CD_truth_histo'].GetBinContent(data_bin)
    mcProb = puS10.probValue[mc_histo_bin]*bin_width/puS10_norm
    
    return dataProb/mcProb
    



