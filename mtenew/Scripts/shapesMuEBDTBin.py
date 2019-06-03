import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.BlindView      import BlindView
from FinalStateAnalysis.PlotTools.PoissonView    import PoissonView
from FinalStateAnalysis.PlotTools.MedianView     import MedianView
from FinalStateAnalysis.PlotTools.ProjectionView import ProjectionView
from FinalStateAnalysis.PlotTools.RebinView  import RebinView
from FinalStateAnalysis.MetaData.data_styles import data_styles, colors
from FinalStateAnalysis.PlotTools.decorators import memo
from FinalStateAnalysis.MetaData.datacommon  import br_w_leptons, br_z_leptons
from FinalStateAnalysis.PlotTools.SubtractionView      import SubtractionView, PositiveView
from optparse import OptionParser
import os
import itertools
import ROOT
import glob
import math
import logging
import pdb
import array
from fnmatch import fnmatch
from yellowhiggs import xs, br, xsbr
from BasePlotter import BasePlotter
from argparse import ArgumentParser
import numpy as np

ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
jobid = os.environ['jobid']
files = []
lumifiles = []
channel = 'me'
period = '13TeV'
sqrts = 13

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*',  'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuESysBDT/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuESysBDT/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuEBDT.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DYJetsToLL_M-50') or x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WGToLNuG') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau') or x.startswith('GluGluHToWW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau') or x.startswith('VBFHToWW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ttHToTauTau') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV') , mc_samples)])
]

b = ['Zll', 'W', 'WG', 'EWK', 'GluGluH', 'VBFH', 'VH', 'ttH', 'TT', 'ST', 'EWKDiboson', 'GluGlu125', 'VBF125']

for di in dirs:

    #if di=='0Jet' or di=='1Jet' or di=='2Jet':
    binning = array.array('d', np.arange(-1.0, 1.0, 0.1))
    #else:
    #    binning = array.array('d', np.arange(-1.0, 1.0, 0.2))

    #if di=='0Jet' or di=='1Jet' or di=='2Jet':
    #    binning = [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    #else:
    #    binning = [-1.0, -0.8, -0.6, -0.4, -0.3, -0.2, -0.1, 0.0, 0.2, 0.4, 0.6, 0.8, 1.0]

    d = f.mkdir(di)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    data = positivize(DataAll.Get("bdtDiscriminator"))
    data = data.Rebin(len(binning)-1, "data_obs", binning)
    
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = positivize(QCD.Get("bdtDiscriminator"))
    qcd = qcd.Rebin(len(binning)-1, "QCD", binning)

    #QCD Systematics
    qcdr0up = positivize(QCD.Get("Rate0JetUp/bdtDiscriminator"))
    qcdr0up = qcdr0up.Rebin(len(binning)-1, "QCD_CMS_0JetRate_13TeVUp", binning)
    qcdr0down = positivize(QCD.Get("Rate0JetDown/bdtDiscriminator"))
    qcdr0down = qcdr0down.Rebin(len(binning)-1, "QCD_CMS_0JetRate_13TeVDown", binning)

    qcdr1up = positivize(QCD.Get("Rate1JetUp/bdtDiscriminator"))
    qcdr1up = qcdr1up.Rebin(len(binning)-1, "QCD_CMS_1JetRate_13TeVUp", binning)
    qcdr1down = positivize(QCD.Get("Rate1JetDown/bdtDiscriminator"))
    qcdr1down = qcdr1down.Rebin(len(binning)-1, "QCD_CMS_1JetRate_13TeVDown", binning)

    qcds0up = positivize(QCD.Get("Shape0JetUp/bdtDiscriminator"))
    qcds0up = qcds0up.Rebin(len(binning)-1, "QCD_CMS_0JetShape_13TeVUp", binning)
    qcds0down = positivize(QCD.Get("Shape0JetDown/bdtDiscriminator"))
    qcds0down = qcds0down.Rebin(len(binning)-1, "QCD_CMS_0JetShape_13TeVDown", binning)

    qcds1up = positivize(QCD.Get("Shape1JetUp/bdtDiscriminator"))
    qcds1up = qcds1up.Rebin(len(binning)-1, "QCD_CMS_1JetShape_13TeVUp", binning)
    qcds1down = positivize(QCD.Get("Shape1JetDown/bdtDiscriminator"))
    qcds1down = qcds1down.Rebin(len(binning)-1, "QCD_CMS_1JetShape_13TeVDown", binning)

    qcdiup = positivize(QCD.Get("IsoUp/bdtDiscriminator"))
    qcdiup = qcdiup.Rebin(len(binning)-1, "QCD_CMS_Extrapolation_13TeVUp", binning)
    qcdidown = positivize(QCD.Get("IsoDown/bdtDiscriminator"))
    qcdidown = qcdidown.Rebin(len(binning)-1, "QCD_CMS_Extrapolation_13TeVDown", binning)

    for i in range(13):
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = positivize(DY.Get("bdtDiscriminator"))
        dy = dy.Rebin(len(binning)-1, b[i], binning)

        #Pileup
        dypuup = positivize(DY.Get("puUp/bdtDiscriminator"))
        dypuup = dypuup.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVUp", binning)
        dypudown = positivize(DY.Get("puDown/bdtDiscriminator"))
        dypudown = dypudown.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVDown", binning)

        #Trigger 
        dytrup = positivize(DY.Get("trUp/bdtDiscriminator"))
        dytrup = dytrup.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVUp", binning)
        dytrdown = positivize(DY.Get("trDown/bdtDiscriminator"))
        dytrdown = dytrdown.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVDown", binning)

        #Recoil Response
        dyrecrespup = positivize(DY.Get("recrespUp/bdtDiscriminator"))
        dyrecrespup = dyrecrespup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVUp", binning)
        dyrecrespdown = positivize(DY.Get("recrespDown/bdtDiscriminator"))
        dyrecrespdown = dyrecrespdown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVDown", binning)

        #Recoil Resolution
        dyrecresoup = positivize(DY.Get("recresoUp/bdtDiscriminator"))
        dyrecresoup = dyrecresoup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVUp", binning)
        dyrecresodown = positivize(DY.Get("recresoDown/bdtDiscriminator"))
        dyrecresodown = dyrecresodown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVDown", binning)

        #DY Pt Reweighting
        dyptup = positivize(DY.Get("DYptreweightUp/bdtDiscriminator"))
        dyptup = dyptup.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVUp", binning)
        dyptdown = positivize(DY.Get("DYptreweightDown/bdtDiscriminator"))
        dyptdown = dyptdown.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVDown", binning)

        #Top Pt Reweighting
        dyttptup = positivize(DY.Get("TopptreweightUp/bdtDiscriminator"))
        dyttptup = dyttptup.Rebin(len(binning)-1, b[i]+"_CMS_TTpTreweight_13TeVUp", binning)
        dyttptdown = positivize(DY.Get("TopptreweightDown/bdtDiscriminator"))
        dyttptdown = dyttptdown.Rebin(len(binning)-1, b[i]+"_CMS_TTpTreweight_13TeVDown", binning)

        #B-Tag 
        dybtagup = positivize(DY.Get("bTagUp/bdtDiscriminator"))
        dybtagup = dybtagup.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVUp", binning)
        dybtagdown = positivize(DY.Get("bTagDown/bdtDiscriminator"))
        dybtagdown = dybtagdown.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVDown", binning)

        #Electron Energy Scale
        dyeescup = positivize(DY.Get("eescUp/bdtDiscriminator"))
        dyeescup = dyeescup.Rebin(len(binning)-1, b[i]+"_CMS_EEScale_13TeVUp", binning)
        dyeescdown = positivize(DY.Get("eescDown/bdtDiscriminator"))
        dyeescdown = dyeescdown.Rebin(len(binning)-1, b[i]+"_CMS_EEScale_13TeVDown", binning)

        #Electron Energy Sigma
        dyeesiup = positivize(DY.Get("eesiUp/bdtDiscriminator"))
        dyeesiup = dyeesiup.Rebin(len(binning)-1, b[i]+"_CMS_EESigma_13TeVUp", binning)
        dyeesidown = positivize(DY.Get("eesiDown/bdtDiscriminator"))
        dyeesidown = dyeesidown.Rebin(len(binning)-1, b[i]+"_CMS_EESigma_13TeVDown", binning)

        #Muon Energy Scale
        dymesup = positivize(DY.Get("mesUp/bdtDiscriminator"))
        dymesup = dymesup.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVUp", binning)
        dymesdown = positivize(DY.Get("mesDown/bdtDiscriminator"))
        dymesdown = dymesdown.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVDown", binning)

        #Unclustered Energy Scale 
        dyuesup = positivize(DY.Get("UnclusteredEnUp/bdtDiscriminator"))
        dyuesup = dyuesup.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVUp", binning)
        dyuesdown = positivize(DY.Get("UnclusteredEnDown/bdtDiscriminator"))
        dyuesdown = dyuesdown.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVDown", binning)

        #Jet Energy Scale
        dyjetAFMup = positivize(DY.Get("JetAbsoluteFlavMapUp/bdtDiscriminator"))
        dyjetAFMup = dyjetAFMup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp", binning)
        dyjetAFMdown = positivize(DY.Get("JetAbsoluteFlavMapDown/bdtDiscriminator"))
        dyjetAFMdown = dyjetAFMdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown", binning)

        dyjetAMPFBup = positivize(DY.Get("JetAbsoluteMPFBiasUp/bdtDiscriminator"))
        dyjetAMPFBup = dyjetAMPFBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp", binning)
        dyjetAMPFBdown = positivize(DY.Get("JetAbsoluteMPFBiasDown/bdtDiscriminator"))
        dyjetAMPFBdown = dyjetAMPFBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown", binning)

        dyjetASup = positivize(DY.Get("JetAbsoluteScaleUp/bdtDiscriminator"))
        dyjetASup = dyjetASup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp", binning)
        dyjetASdown = positivize(DY.Get("JetAbsoluteScaleDown/bdtDiscriminator"))
        dyjetASdown = dyjetASdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown", binning)

        dyjetAStup = positivize(DY.Get("JetAbsoluteStatUp/bdtDiscriminator"))
        dyjetAStup = dyjetAStup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp", binning)
        dyjetAStdown = positivize(DY.Get("JetAbsoluteStatDown/bdtDiscriminator"))
        dyjetAStdown = dyjetAStdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown", binning)

        dyjetFQCDup = positivize(DY.Get("JetFlavorQCDUp/bdtDiscriminator"))
        dyjetFQCDup = dyjetFQCDup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp", binning)
        dyjetFQCDdown = positivize(DY.Get("JetFlavorQCDDown/bdtDiscriminator"))
        dyjetFQCDdown = dyjetFQCDdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown", binning)

        dyjetFup = positivize(DY.Get("JetFragmentationUp/bdtDiscriminator"))
        dyjetFup = dyjetFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVUp", binning)
        dyjetFdown = positivize(DY.Get("JetFragmentationDown/bdtDiscriminator"))
        dyjetFdown = dyjetFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVDown", binning)

        dyjetPUDMCup = positivize(DY.Get("JetPileUpDataMCUp/bdtDiscriminator"))
        dyjetPUDMCup = dyjetPUDMCup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp", binning)
        dyjetPUDMCdown = positivize(DY.Get("JetPileUpDataMCDown/bdtDiscriminator"))
        dyjetPUDMCdown = dyjetPUDMCdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown", binning)

        dyjetPUPBBup = positivize(DY.Get("JetPileUpPtBBUp/bdtDiscriminator"))
        dyjetPUPBBup = dyjetPUPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp", binning)
        dyjetPUPBBdown = positivize(DY.Get("JetPileUpPtBBDown/bdtDiscriminator"))
        dyjetPUPBBdown = dyjetPUPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown", binning)

        dyjetPUPEC1up = positivize(DY.Get("JetPileUpPtEC1Up/bdtDiscriminator"))
        dyjetPUPEC1up = dyjetPUPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp", binning)
        dyjetPUPEC1down = positivize(DY.Get("JetPileUpPtEC1Down/bdtDiscriminator"))
        dyjetPUPEC1down = dyjetPUPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown", binning)

        dyjetPUPEC2up = positivize(DY.Get("JetPileUpPtEC2Up/bdtDiscriminator"))
        dyjetPUPEC2up = dyjetPUPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp", binning)
        dyjetPUPEC2down = positivize(DY.Get("JetPileUpPtEC2Down/bdtDiscriminator"))
        dyjetPUPEC2down = dyjetPUPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown", binning)

        dyjetPUPHFup = positivize(DY.Get("JetPileUpPtHFUp/bdtDiscriminator"))
        dyjetPUPHFup = dyjetPUPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp", binning)
        dyjetPUPHFdown = positivize(DY.Get("JetPileUpPtHFDown/bdtDiscriminator"))
        dyjetPUPHFdown = dyjetPUPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown", binning)

        dyjetPUPRup = positivize(DY.Get("JetPileUpPtRefUp/bdtDiscriminator"))
        dyjetPUPRup = dyjetPUPRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp", binning)
        dyjetPUPRdown = positivize(DY.Get("JetPileUpPtRefDown/bdtDiscriminator"))
        dyjetPUPRdown = dyjetPUPRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown", binning)

        dyjetRFSRup = positivize(DY.Get("JetRelativeFSRUp/bdtDiscriminator"))
        dyjetRFSRup = dyjetRFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp", binning)
        dyjetRFSRdown = positivize(DY.Get("JetRelativeFSRDown/bdtDiscriminator"))
        dyjetRFSRdown = dyjetRFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown", binning)

        dyjetRJEREC1up = positivize(DY.Get("JetRelativeJEREC1Up/bdtDiscriminator"))
        dyjetRJEREC1up = dyjetRJEREC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp", binning)
        dyjetRJEREC1down = positivize(DY.Get("JetRelativeJEREC1Down/bdtDiscriminator"))
        dyjetRJEREC1down = dyjetRJEREC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown", binning)

        dyjetRJEREC2up = positivize(DY.Get("JetRelativeJEREC2Up/bdtDiscriminator"))
        dyjetRJEREC2up = dyjetRJEREC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp", binning)
        dyjetRJEREC2down = positivize(DY.Get("JetRelativeJEREC2Down/bdtDiscriminator"))
        dyjetRJEREC2down = dyjetRJEREC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown", binning)

        dyjetRJERHFup = positivize(DY.Get("JetRelativeJERHFUp/bdtDiscriminator"))
        dyjetRJERHFup = dyjetRJERHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp", binning)
        dyjetRJERHFdown = positivize(DY.Get("JetRelativeJERHFDown/bdtDiscriminator"))
        dyjetRJERHFdown = dyjetRJERHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown", binning)

        dyjetRPBBup = positivize(DY.Get("JetRelativePtBBUp/bdtDiscriminator"))
        dyjetRPBBup = dyjetRPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp", binning)
        dyjetRPBBdown = positivize(DY.Get("JetRelativePtBBDown/bdtDiscriminator"))
        dyjetRPBBdown = dyjetRPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown", binning)

        dyjetRPEC1up = positivize(DY.Get("JetRelativePtEC1Up/bdtDiscriminator"))
        dyjetRPEC1up = dyjetRPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp", binning)
        dyjetRPEC1down = positivize(DY.Get("JetRelativePtEC1Down/bdtDiscriminator"))
        dyjetRPEC1down = dyjetRPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown", binning)

        dyjetRPEC2up = positivize(DY.Get("JetRelativePtEC2Up/bdtDiscriminator"))
        dyjetRPEC2up = dyjetRPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp", binning)
        dyjetRPEC2down = positivize(DY.Get("JetRelativePtEC2Down/bdtDiscriminator"))
        dyjetRPEC2down = dyjetRPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown", binning)

        dyjetRPHFup = positivize(DY.Get("JetRelativePtHFUp/bdtDiscriminator"))
        dyjetRPHFup = dyjetRPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp", binning)
        dyjetRPHFdown = positivize(DY.Get("JetRelativePtHFDown/bdtDiscriminator"))
        dyjetRPHFdown = dyjetRPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown", binning)

        dyjetRSECup = positivize(DY.Get("JetRelativeStatECUp/bdtDiscriminator"))
        dyjetRSECup = dyjetRSECup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp", binning)
        dyjetRSECdown = positivize(DY.Get("JetRelativeStatECDown/bdtDiscriminator"))
        dyjetRSECdown = dyjetRSECdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown", binning)

        dyjetRSFSRup = positivize(DY.Get("JetRelativeStatFSRUp/bdtDiscriminator"))
        dyjetRSFSRup = dyjetRSFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp", binning)
        dyjetRSFSRdown = positivize(DY.Get("JetRelativeStatFSRDown/bdtDiscriminator"))
        dyjetRSFSRdown = dyjetRSFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown", binning)

        dyjetRSHFup = positivize(DY.Get("JetRelativeStatHFUp/bdtDiscriminator"))
        dyjetRSHFup = dyjetRSHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp", binning)
        dyjetRSHFdown = positivize(DY.Get("JetRelativeStatHFDown/bdtDiscriminator"))
        dyjetRSHFdown = dyjetRSHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown", binning)

        dyjetSPEup = positivize(DY.Get("JetSinglePionECALUp/bdtDiscriminator"))
        dyjetSPEup = dyjetSPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp", binning)
        dyjetSPEdown = positivize(DY.Get("JetSinglePionECALDown/bdtDiscriminator"))
        dyjetSPEdown = dyjetSPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown", binning)

        dyjetSPHup = positivize(DY.Get("JetSinglePionHCALUp/bdtDiscriminator"))
        dyjetSPHup = dyjetSPHup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp", binning)
        dyjetSPHdown = positivize(DY.Get("JetSinglePionHCALDown/bdtDiscriminator"))
        dyjetSPHdown = dyjetSPHdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown", binning)

        dyjetTPEup = positivize(DY.Get("JetTimePtEtaUp/bdtDiscriminator"))
        dyjetTPEup = dyjetTPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp", binning)
        dyjetTPEdown = positivize(DY.Get("JetTimePtEtaDown/bdtDiscriminator"))
        dyjetTPEdown = dyjetTPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown", binning)

        dyjetRBup = positivize(DY.Get("JetRelativeBalUp/bdtDiscriminator"))
        dyjetRBup = dyjetRBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp", binning)
        dyjetRBdown = positivize(DY.Get("JetRelativeBalDown/bdtDiscriminator"))
        dyjetRBdown = dyjetRBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown", binning)

        dyjetRSup = positivize(DY.Get("JetRelativeSampleUp/bdtDiscriminator"))
        dyjetRSup = dyjetRSup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp", binning)
        dyjetRSdown = positivize(DY.Get("JetRelativeSampleDown/bdtDiscriminator"))
        dyjetRSdown = dyjetRSdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown", binning)

        if i==1:
            data.Delete()
            qcd.Delete()
            qcdr0up.Delete()
            qcdr0down.Delete()
            qcdr1up.Delete()
            qcdr1down.Delete()
            qcds0up.Delete()
            qcds0down.Delete()
            qcds1up.Delete()
            qcds1down.Delete()
            qcdiup.Delete()
            qcdidown.Delete()
        f.Write()
        dy.Delete()
        dypuup.Delete()
        dypudown.Delete()
        dytrup.Delete()
        dytrdown.Delete()
        dyrecrespup.Delete()
        dyrecrespdown.Delete()
        dyrecresoup.Delete()
        dyrecresodown.Delete()
        dyptup.Delete()
        dyptdown.Delete()
        dyttptup.Delete()
        dyttptdown.Delete()
        dybtagup.Delete()
        dybtagdown.Delete()
        dyeescup.Delete()
        dyeescdown.Delete()
        dyeesiup.Delete()
        dyeesidown.Delete()
        dymesup.Delete()
        dymesdown.Delete()
        dyuesup.Delete()
        dyuesdown.Delete()
        dyjetAFMup.Delete()
        dyjetAFMdown.Delete()
        dyjetAMPFBup.Delete()
        dyjetAMPFBdown.Delete()
        dyjetASup.Delete()
        dyjetASdown.Delete()
        dyjetAStup.Delete()
        dyjetAStdown.Delete()
        dyjetFQCDup.Delete()
        dyjetFQCDdown.Delete()
        dyjetFup.Delete()
        dyjetFdown.Delete()
        dyjetPUDMCup.Delete()
        dyjetPUDMCdown.Delete()
        dyjetPUPBBup.Delete()
        dyjetPUPBBdown.Delete()
        dyjetPUPEC1up.Delete()
        dyjetPUPEC1down.Delete()
        dyjetPUPEC2up.Delete()
        dyjetPUPEC2down.Delete()
        dyjetPUPHFup.Delete()
        dyjetPUPHFdown.Delete()
        dyjetPUPRup.Delete()
        dyjetPUPRdown.Delete()
        dyjetRFSRup.Delete()
        dyjetRFSRdown.Delete()
        dyjetRJEREC1up.Delete()
        dyjetRJEREC1down.Delete()
        dyjetRJEREC2up.Delete()
        dyjetRJEREC2down.Delete()
        dyjetRJERHFup.Delete()
        dyjetRJERHFdown.Delete()
        dyjetRPBBup.Delete()
        dyjetRPBBdown.Delete()
        dyjetRPEC1up.Delete()
        dyjetRPEC1down.Delete()
        dyjetRPEC2up.Delete()
        dyjetRPEC2down.Delete()
        dyjetRPHFup.Delete()
        dyjetRPHFdown.Delete()
        dyjetRSECup.Delete()
        dyjetRSECdown.Delete()
        dyjetRSFSRup.Delete()
        dyjetRSFSRdown.Delete()
        dyjetRSHFup.Delete()
        dyjetRSHFdown.Delete()
        dyjetSPEup.Delete()
        dyjetSPEdown.Delete()
        dyjetSPHup.Delete()
        dyjetSPHdown.Delete()
        dyjetTPEup.Delete()
        dyjetTPEdown.Delete()
        dyjetRBup.Delete()
        dyjetRBdown.Delete()
        dyjetRSup.Delete()
        dyjetRSdown.Delete()
