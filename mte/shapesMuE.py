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

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'embed*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuESys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuESys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuE.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') or x.startswith('WJets') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WGToLNuG') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau') , mc_samples)]), 
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
    d = f.mkdir(di)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    data = DataAll.Get("m_e_CollinearMass")
    data.SetName('data_obs')
    
    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    embed = views.SubdirectoryView(embedtotal, 'TightOS'+di)
    emb = embed.Get("m_e_CollinearMass")
    emb.SetName('embed')

    embtrup = embed.Get("trUp/m_e_CollinearMass")
    embtrup.SetName("embed_CMS_Trigger_13TeVUp")
    embtrdown = embed.Get("trDown/m_e_CollinearMass")
    embtrdown.SetName("embed_CMS_Trigger_13TeVDown")

    embseltrup = embed.Get("embtrUp/m_e_CollinearMass")
    embseltrup.SetName("embed_CMS_MuonSelection_13TeVUp")
    embseltrdown = embed.Get("embtrDown/m_e_CollinearMass")
    embseltrdown.SetName("embed_CMS_MuonSelection_13TeVDown")

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = QCD.Get("m_e_CollinearMass")
    qcd.SetName('QCD')
    qcdr0up = QCD.Get("Rate0JetUp/m_e_CollinearMass")
    qcdr0up.SetName('QCD_CMS_0JetRate_13TeVUp')
    qcdr0down = QCD.Get("Rate0JetDown/m_e_CollinearMass")
    qcdr0down.SetName('QCD_CMS_0JetRate_13TeVDown')
    qcdr1up = QCD.Get("Rate1JetUp/m_e_CollinearMass")
    qcdr1up.SetName('QCD_CMS_1JetRate_13TeVUp')
    qcdr1down = QCD.Get("Rate1JetDown/m_e_CollinearMass")
    qcdr1down.SetName('QCD_CMS_1JetRate_13TeVDown')
    qcds0up = QCD.Get("Shape0JetUp/m_e_CollinearMass")
    qcds0up.SetName('QCD_CMS_0JetShape_13TeVUp')
    qcds0down = QCD.Get("Shape0JetDown/m_e_CollinearMass")
    qcds0down.SetName('QCD_CMS_0JetShape_13TeVDown')
    qcds1up = QCD.Get("Shape1JetUp/m_e_CollinearMass")
    qcds1up.SetName('QCD_CMS_1JetShape_13TeVUp')
    qcds1down = QCD.Get("Shape1JetDown/m_e_CollinearMass")
    qcds1down.SetName('QCD_CMS_1JetShape_13TeVDown')
    qcdiup = QCD.Get("IsoUp/m_e_CollinearMass")
    qcdiup.SetName('QCD_CMS_Extrapolation_13TeVUp')
    qcdidown = QCD.Get("IsoDown/m_e_CollinearMass")
    qcdidown.SetName('QCD_CMS_Extrapolation_13TeVDown')

    for i in range(13):
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = DY.Get("m_e_CollinearMass")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/m_e_CollinearMass")
        dypuup.SetName(b[i]+"_CMS_Pileup_13TeVUp")
        dypudown = DY.Get("puDown/m_e_CollinearMass")
        dypudown.SetName(b[i]+"_CMS_Pileup_13TeVDown")

        dytrup = DY.Get("trUp/m_e_CollinearMass")
        dytrup.SetName(b[i]+"_CMS_Trigger_13TeVUp")
        dytrdown = DY.Get("trDown/m_e_CollinearMass")
        dytrdown.SetName(b[i]+"_CMS_Trigger_13TeVDown")

        dyrecrespup = DY.Get("recrespUp/m_e_CollinearMass")
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = DY.Get("recrespDown/m_e_CollinearMass")
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        dyrecresoup = DY.Get("recresoUp/m_e_CollinearMass")
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = DY.Get("recresoDown/m_e_CollinearMass")
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        dyptup = DY.Get("DYptreweightUp/m_e_CollinearMass")
        dyptup.SetName(b[i]+"_CMS_DYpTreweight_13TeVUp")
        dyptdown = DY.Get("DYptreweightDown/m_e_CollinearMass")
        dyptdown.SetName(b[i]+"_CMS_DYpTreweight_13TeVDown")

        dyttptup = DY.Get("TopptreweightUp/m_e_CollinearMass")
        dyttptup.SetName(b[i]+"_CMS_TTpTreweight_13TeVUp")
        dyttptdown = DY.Get("TopptreweightDown/m_e_CollinearMass")
        dyttptdown.SetName(b[i]+"_CMS_TTpTreweight_13TeVDown")

        dyeesup = DY.Get("eesUp/m_e_CollinearMass")
        dyeesup.SetName(b[i]+"_CMS_EES_13TeVUp")
        dyeesdown = DY.Get("eesDown/m_e_CollinearMass")
        dyeesdown.SetName(b[i]+"_CMS_EES_13TeVDown")

        dymesup = DY.Get("mesUp/m_e_CollinearMass")
        dymesup.SetName(b[i]+"_CMS_MES_13TeVUp")
        dymesdown = DY.Get("mesDown/m_e_CollinearMass")
        dymesdown.SetName(b[i]+"_CMS_MES_13TeVDown")

        dyuesup = DY.Get("UnclusteredEnUp/m_e_CollinearMass")
        dyuesup.SetName(b[i]+"_CMS_MET_Ues_13TeVUp")
        dyuesdown = DY.Get("UnclusteredEnDown/m_e_CollinearMass")
        dyuesdown.SetName(b[i]+"_CMS_MET_Ues_13TeVDown")

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/m_e_CollinearMass")
        dyjetAFMup.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/m_e_CollinearMass")
        dyjetAFMdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/m_e_CollinearMass")
        dyjetAMPFBup.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/m_e_CollinearMass")
        dyjetAMPFBdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/m_e_CollinearMass")
        dyjetASup.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/m_e_CollinearMass")
        dyjetASdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/m_e_CollinearMass")
        dyjetAStup.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/m_e_CollinearMass")
        dyjetAStdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/m_e_CollinearMass")
        dyjetFQCDup.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/m_e_CollinearMass")
        dyjetFQCDdown.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown")
        dyjetFup = DY.Get("JetFragmentationUp/m_e_CollinearMass")
        dyjetFup.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVUp")
        dyjetFdown = DY.Get("JetFragmentationDown/m_e_CollinearMass")
        dyjetFdown.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/m_e_CollinearMass")
        dyjetPUDMCup.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/m_e_CollinearMass")
        dyjetPUDMCdown.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/m_e_CollinearMass")
        dyjetPUPBBup.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/m_e_CollinearMass")
        dyjetPUPBBdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/m_e_CollinearMass")
        dyjetPUPEC1up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/m_e_CollinearMass")
        dyjetPUPEC1down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/m_e_CollinearMass")
        dyjetPUPEC2up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/m_e_CollinearMass")
        dyjetPUPEC2down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/m_e_CollinearMass")
        dyjetPUPHFup.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/m_e_CollinearMass")
        dyjetPUPHFdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/m_e_CollinearMass")
        dyjetPUPRup.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/m_e_CollinearMass")
        dyjetPUPRdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/m_e_CollinearMass")
        dyjetRFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/m_e_CollinearMass")
        dyjetRFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/m_e_CollinearMass")
        dyjetRJEREC1up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/m_e_CollinearMass")
        dyjetRJEREC1down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/m_e_CollinearMass")
        dyjetRJEREC2up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/m_e_CollinearMass")
        dyjetRJEREC2down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/m_e_CollinearMass")
        dyjetRJERHFup.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/m_e_CollinearMass")
        dyjetRJERHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/m_e_CollinearMass")
        dyjetRPBBup.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/m_e_CollinearMass")
        dyjetRPBBdown.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/m_e_CollinearMass")
        dyjetRPEC1up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/m_e_CollinearMass")
        dyjetRPEC1down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/m_e_CollinearMass")
        dyjetRPEC2up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/m_e_CollinearMass")
        dyjetRPEC2down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/m_e_CollinearMass")
        dyjetRPHFup.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/m_e_CollinearMass")
        dyjetRPHFdown.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/m_e_CollinearMass")
        dyjetRSECup.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/m_e_CollinearMass")
        dyjetRSECdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/m_e_CollinearMass")
        dyjetRSFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/m_e_CollinearMass")
        dyjetRSFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/m_e_CollinearMass")
        dyjetRSHFup.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/m_e_CollinearMass")
        dyjetRSHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/m_e_CollinearMass")
        dyjetSPEup.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/m_e_CollinearMass")
        dyjetSPEdown.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/m_e_CollinearMass")
        dyjetSPHup.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/m_e_CollinearMass")
        dyjetSPHdown.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/m_e_CollinearMass")
        dyjetTPEup.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/m_e_CollinearMass")
        dyjetTPEdown.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/m_e_CollinearMass")
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/m_e_CollinearMass")
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/m_e_CollinearMass")
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/m_e_CollinearMass")
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

        if i==1:
            data.Delete()
            emb.Delete()
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
            embtrup.Delete()
            embtrdown.Delete()
            embseltrup.Delete()
            embseltrdown.Delete()
        f.Write()
