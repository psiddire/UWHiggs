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
channel = 'mt'
period = '13TeV'
sqrts = 13

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuTauSysBDT/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuTauSysBDT/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuTauBDTNoMFakes.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]), 
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

b = ['Zll', 'EWK', 'GluGluH', 'VBFH', 'VH', 'ttH', 'TT', 'ST', 'EWKDiboson', 'GluGlu125', 'VBF125']

for di in dirs:
    d = f.mkdir(di)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    data = DataAll.Get("bdtDiscriminator")
    data.SetName('data_obs')
    
    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, 'TightOS'+di)
    embedtfakes = views.SubdirectoryView(embedtotal, 'TauLooseOS'+di)
    embed = SubtractionView(embedall, embedtfakes, restrict_positive=True)
    emb = embed.Get("bdtDiscriminator")
    emb.SetName('embed')

    embtrup = embed.Get("trUp/bdtDiscriminator")
    embtrup.SetName("embed_CMS_Trigger_13TeVUp")
    embtrdown = embed.Get("trDown/bdtDiscriminator")
    embtrdown.SetName("embed_CMS_Trigger_13TeVDown")

    embseltrup = embed.Get("embtrUp/bdtDiscriminator")
    embseltrup.SetName("embed_CMS_selection_mUp")
    embseltrdown = embed.Get("embtrDown/bdtDiscriminator")
    embseltrdown.SetName("embed_CMS_selection_mDown")

    embtrkup = embed.Get("embtrkUp/bdtDiscriminator")
    embtrkup.SetName("embed_CMS_tracking_tauUp")
    embtrkdown = embed.Get("embtrkDown/bdtDiscriminator")
    embtrkdown.SetName("embed_CMS_tracking_tauDown")

    embtes0up = embed.Get("scaletDM0Up/bdtDiscriminator")
    embtes0up.SetName("embed_CMS_scale_t_1prong_13TeVUp")
    embtes0down = embed.Get("scaletDM0Down/bdtDiscriminator")
    embtes0down.SetName("embed_CMS_scale_t_1prong_13TeVDown")
    embtes1up = embed.Get("scaletDM1Up/bdtDiscriminator")
    embtes1up.SetName("embed_CMS_scale_t_1prong1pizero_13TeVUp")
    embtes1down = embed.Get("scaletDM1Down/bdtDiscriminator")
    embtes1down.SetName("embed_CMS_scale_t_1prong1pizero_13TeVDown")
    embtes10up = embed.Get("scaletDM10Up/bdtDiscriminator")
    embtes10up.SetName("embed_CMS_scale_t_3prong_13TeVUp")
    embtes10down = embed.Get("scaletDM10Down/bdtDiscriminator")
    embtes10down.SetName("embed_CMS_scale_t_3prong_13TeVDown")

    emball = embedall.Get("bdtDiscriminator")
    embtfakes = embedtfakes.Get("bdtDiscriminator")
    embtfakesup = embedtfakes.Get("TauFakeUp/bdtDiscriminator")
    embtfakesdown = embedtfakes.Get("TauFakeDown/bdtDiscriminator")
    emb1 = emball.Clone()
    emb1t = embtfakesup.Clone()
    emb1.add(emb1t, -1)
    emb1 = positivize(emb1)
    emb1.SetName("embed_CMS_TauFakeRate_13TeVUp")
    emb2 = emball.Clone()
    emb2t = embtfakesdown.Clone()
    emb2.add(emb2t, -1)
    emb2 = positivize(emb2)
    emb2.SetName("embed_CMS_TauFakeRate_13TeVDown")

    emball.Delete()
    emb1t.Delete()
    emb2t.Delete()
    embtfakes.Delete()
    embtfakesup.Delete()
    embtfakesdown.Delete()
    
    Fakes = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    QCD = views.SubdirectoryView(Fakes, 'TauLooseOS'+di)
    qcd = QCD.Get("bdtDiscriminator")
    qcd.SetName('Fakes')
    tfakes = QCD.Get("bdtDiscriminator")
    tfakesup = QCD.Get("TauFakeUp/bdtDiscriminator")
    tfakesdown = QCD.Get("TauFakeDown/bdtDiscriminator")

    f1 = tfakesup.Clone()
    f1 = positivize(f1)
    f1.SetName("Fakes_CMS_TauFakeRate_13TeVUp")
    f2 = tfakesdown.Clone()
    f2 = positivize(f2)
    f2.SetName("Fakes_CMS_TauFakeRate_13TeVDown")

    tfakes.Delete()
    tfakesup.Delete()
    tfakesdown.Delete()

    for i in range(11):
        DYtotal = v[i]
        if (b[i]=='GluGlu125' or b[i]=='VBF125'):
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DY = DYall
            dy = DY.Get("bdtDiscriminator")
        else:
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DY = SubtractionView(DYall, DYtfakes, restrict_positive=True)
            dy = DY.Get("bdtDiscriminator")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/bdtDiscriminator")
        dypuup.SetName(b[i]+"_CMS_Pileup_13TeVUp")
        dypudown = DY.Get("puDown/bdtDiscriminator")
        dypudown.SetName(b[i]+"_CMS_Pileup_13TeVDown")

        dytrup = DY.Get("trUp/bdtDiscriminator")
        dytrup.SetName(b[i]+"_CMS_Trigger_13TeVUp")
        dytrdown = DY.Get("trDown/bdtDiscriminator")
        dytrdown.SetName(b[i]+"_CMS_Trigger_13TeVDown")

        dyrecrespup = DY.Get("recrespUp/bdtDiscriminator")
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = DY.Get("recrespDown/bdtDiscriminator")
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        dyrecresoup = DY.Get("recresoUp/bdtDiscriminator")
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = DY.Get("recresoDown/bdtDiscriminator")
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        dyptup = DY.Get("DYptreweightUp/bdtDiscriminator")
        dyptup.SetName(b[i]+"_CMS_pTreweight_13TeVUp")
        dyptdown = DY.Get("DYptreweightDown/bdtDiscriminator")
        dyptdown.SetName(b[i]+"_CMS_pTreweight_13TeVDown")

        dymtfakeup = DY.Get("mtfakeUp/bdtDiscriminator")
        dymtfakeup.SetName(b[i]+"_CMS_scale_mfaketau_13TeVUp")
        dymtfakedown = DY.Get("mtfakeDown/bdtDiscriminator")
        dymtfakedown.SetName(b[i]+"_CMS_scale_mfaketau_13TeVDown")

        dyetfakeup = DY.Get("etfakeUp/bdtDiscriminator")
        dyetfakeup.SetName(b[i]+"_CMS_scale_efaketau_13TeVUp")
        dyetfakedown = DY.Get("etfakeDown/bdtDiscriminator")
        dyetfakedown.SetName(b[i]+"_CMS_scale_efaketau_13TeVDown")

        dyetefakeup = DY.Get("etefakeUp/bdtDiscriminator")
        dyetefakeup.SetName(b[i]+"_CMS_scale_efaketaues_13TeVUp")
        dyetefakedown = DY.Get("etefakeDown/bdtDiscriminator")
        dyetefakedown.SetName(b[i]+"_CMS_scale_efaketaues_13TeVDown")

        dytes0up = DY.Get("scaletDM0Up/bdtDiscriminator")
        dytes0up.SetName(b[i]+"_CMS_scale_t_1prong_13TeVUp")
        dytes0down = DY.Get("scaletDM0Down/bdtDiscriminator")
        dytes0down.SetName(b[i]+"_CMS_scale_t_1prong_13TeVDown")
        dytes1up = DY.Get("scaletDM1Up/bdtDiscriminator")
        dytes1up.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVUp")
        dytes1down = DY.Get("scaletDM1Down/bdtDiscriminator")
        dytes1down.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVDown")
        dytes10up = DY.Get("scaletDM10Up/bdtDiscriminator")
        dytes10up.SetName(b[i]+"_CMS_scale_t_3prong_13TeVUp")
        dytes10down = DY.Get("scaletDM10Down/bdtDiscriminator")
        dytes10down.SetName(b[i]+"_CMS_scale_t_3prong_13TeVDown")

        dymesup = DY.Get("mesUp/bdtDiscriminator")
        dymesup.SetName(b[i]+"_CMS_MES_13TeVUp")
        dymesdown = DY.Get("mesDown/bdtDiscriminator")
        dymesdown.SetName(b[i]+"_CMS_MES_13TeVDown")

        dyuesup = DY.Get("UnclusteredEnUp/bdtDiscriminator")
        dyuesup.SetName(b[i]+"_CMS_MET_Ues_13TeVUp")
        dyuesdown = DY.Get("UnclusteredEnDown/bdtDiscriminator")
        dyuesdown.SetName(b[i]+"_CMS_MET_Ues_13TeVDown")

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/bdtDiscriminator")
        dyjetAFMup.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/bdtDiscriminator")
        dyjetAFMdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/bdtDiscriminator")
        dyjetAMPFBup.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/bdtDiscriminator")
        dyjetAMPFBdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/bdtDiscriminator")
        dyjetASup.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/bdtDiscriminator")
        dyjetASdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/bdtDiscriminator")
        dyjetAStup.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/bdtDiscriminator")
        dyjetAStdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/bdtDiscriminator")
        dyjetFQCDup.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/bdtDiscriminator")
        dyjetFQCDdown.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown")
        dyjetFup = DY.Get("JetFragmentationUp/bdtDiscriminator")
        dyjetFup.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVUp")
        dyjetFdown = DY.Get("JetFragmentationDown/bdtDiscriminator")
        dyjetFdown.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/bdtDiscriminator")
        dyjetPUDMCup.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/bdtDiscriminator")
        dyjetPUDMCdown.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/bdtDiscriminator")
        dyjetPUPBBup.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/bdtDiscriminator")
        dyjetPUPBBdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/bdtDiscriminator")
        dyjetPUPEC1up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/bdtDiscriminator")
        dyjetPUPEC1down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/bdtDiscriminator")
        dyjetPUPEC2up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/bdtDiscriminator")
        dyjetPUPEC2down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/bdtDiscriminator")
        dyjetPUPHFup.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/bdtDiscriminator")
        dyjetPUPHFdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/bdtDiscriminator")
        dyjetPUPRup.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/bdtDiscriminator")
        dyjetPUPRdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/bdtDiscriminator")
        dyjetRFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/bdtDiscriminator")
        dyjetRFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/bdtDiscriminator")
        dyjetRJEREC1up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/bdtDiscriminator")
        dyjetRJEREC1down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/bdtDiscriminator")
        dyjetRJEREC2up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/bdtDiscriminator")
        dyjetRJEREC2down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/bdtDiscriminator")
        dyjetRJERHFup.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/bdtDiscriminator")
        dyjetRJERHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/bdtDiscriminator")
        dyjetRPBBup.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/bdtDiscriminator")
        dyjetRPBBdown.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/bdtDiscriminator")
        dyjetRPEC1up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/bdtDiscriminator")
        dyjetRPEC1down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/bdtDiscriminator")
        dyjetRPEC2up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/bdtDiscriminator")
        dyjetRPEC2down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/bdtDiscriminator")
        dyjetRPHFup.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/bdtDiscriminator")
        dyjetRPHFdown.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/bdtDiscriminator")
        dyjetRSECup.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/bdtDiscriminator")
        dyjetRSECdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/bdtDiscriminator")
        dyjetRSFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/bdtDiscriminator")
        dyjetRSFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/bdtDiscriminator")
        dyjetRSHFup.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/bdtDiscriminator")
        dyjetRSHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/bdtDiscriminator")
        dyjetSPEup.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/bdtDiscriminator")
        dyjetSPEdown.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/bdtDiscriminator")
        dyjetSPHup.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/bdtDiscriminator")
        dyjetSPHdown.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/bdtDiscriminator")
        dyjetTPEup.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/bdtDiscriminator")
        dyjetTPEdown.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/bdtDiscriminator")
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/bdtDiscriminator")
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/bdtDiscriminator")
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/bdtDiscriminator")
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

        dyall = DYall.Get("bdtDiscriminator")
        dytfakes = DYtfakes.Get("bdtDiscriminator")
        dytfakesup = DYtfakes.Get("TauFakeUp/bdtDiscriminator") 
        dytfakesdown = DYtfakes.Get("TauFakeDown/bdtDiscriminator")

        dy1 = dyall.Clone()
        dy1t = dytfakesup.Clone()
        dy1.add(dy1t, -1)
        dy1 = positivize(dy1)
        dy1.SetName(b[i]+"_CMS_TauFakeRate_13TeVUp")
        dy2 = dyall.Clone()
        dy2t = dytfakesdown.Clone()
        dy2.add(dy2t, -1)
        dy2 = positivize(dy2)
        dy2.SetName(b[i]+"_CMS_TauFakeRate_13TeVDown")

        dyall.Delete()
        dy1t.Delete()
        dy2t.Delete()
        dytfakes.Delete()
        dytfakesup.Delete()
        dytfakesdown.Delete()

        if i==1:
            data.Delete()
            emb.Delete()
            qcd.Delete()
            f1.Delete()
            f2.Delete()
            emb1.Delete()
            emb2.Delete()
            embtrup.Delete()
            embtrdown.Delete()
            embseltrup.Delete()
            embseltrdown.Delete()
            embtrkup.Delete()
            embtrkdown.Delete()
            embtes0up.Delete()
            embtes0down.Delete()
            embtes1up.Delete()
            embtes1down.Delete()
            embtes10up.Delete()
            embtes10down.Delete()
        f.Write()
