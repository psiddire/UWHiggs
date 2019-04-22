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
    files.extend(glob.glob('results/%s/AnalyzeETauSys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeETauSys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesETau.root', 'RECREATE')

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
    data = DataAll.Get("e_t_CollinearMass")
    data.SetName('data_obs')
    
    # embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    # embedall = views.SubdirectoryView(embedtotal, 'TightOS'+di)
    # embedtfakes = views.SubdirectoryView(embedtotal, 'TauLooseOS'+di)
    # embed = SubtractionView(embedall, embedtfakes, restrict_positive=True)
    # emb = embed.Get("e_t_CollinearMass")
    # emb.SetName('embed')

    # embtrup = embed.Get("trUp/e_t_CollinearMass")
    # embtrup.SetName("embed_CMS_Trigger_13TeVUp")
    # embtrdown = embed.Get("trDown/e_t_CollinearMass")
    # embtrdown.SetName("embed_CMS_Trigger_13TeVDown")

    # embseltrup = embed.Get("embtrUp/e_t_CollinearMass")
    # embseltrup.SetName("embed_CMS_selection_mUp")
    # embseltrdown = embed.Get("embtrDown/e_t_CollinearMass")
    # embseltrdown.SetName("embed_CMS_selection_mDown")

    # embtrkup = embed.Get("embtrkUp/e_t_CollinearMass")
    # embtrkup.SetName("embed_CMS_tracking_tauUp")
    # embtrkdown = embed.Get("embtrkDown/e_t_CollinearMass")
    # embtrkdown.SetName("embed_CMS_tracking_tauDown")

    # embtes0up = embed.Get("scaletDM0Up/e_t_CollinearMass")
    # embtes0up.SetName("embed_CMS_scale_t_1prong_13TeVUp")
    # embtes0down = embed.Get("scaletDM0Down/e_t_CollinearMass")
    # embtes0down.SetName("embed_CMS_scale_t_1prong_13TeVDown")
    # embtes1up = embed.Get("scaletDM1Up/e_t_CollinearMass")
    # embtes1up.SetName("embed_CMS_scale_t_1prong1pizero_13TeVUp")
    # embtes1down = embed.Get("scaletDM1Down/e_t_CollinearMass")
    # embtes1down.SetName("embed_CMS_scale_t_1prong1pizero_13TeVDown")
    # embtes10up = embed.Get("scaletDM10Up/e_t_CollinearMass")
    # embtes10up.SetName("embed_CMS_scale_t_3prong_13TeVUp")
    # embtes10down = embed.Get("scaletDM10Down/e_t_CollinearMass")
    # embtes10down.SetName("embed_CMS_scale_t_3prong_13TeVDown")

    # emball = embedall.Get("e_t_CollinearMass")
    # embtfakes = embedtfakes.Get("e_t_CollinearMass")
    # embtfakesup = embedtfakes.Get("TauFakeUp/e_t_CollinearMass")
    # embtfakesdown = embedtfakes.Get("TauFakeDown/e_t_CollinearMass")
    # emb1 = emball.Clone()
    # emb1t = embtfakesup.Clone()
    # emb1.add(emb1t, -1)
    # emb1 = positivize(emb1)
    # emb1.SetName("embed_CMS_TauFakeRate_13TeVUp")
    # emb2 = emball.Clone()
    # emb2t = embtfakesdown.Clone()
    # emb2.add(emb2t, -1)
    # emb2 = positivize(emb2)
    # emb2.SetName("embed_CMS_TauFakeRate_13TeVDown")

    # emball.Delete()
    # emb1t.Delete()
    # emb2t.Delete()
    # embtfakes.Delete()
    # embtfakesup.Delete()
    # embtfakesdown.Delete()
    
    Fakes = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    QCD = views.SubdirectoryView(Fakes, 'TauLooseOS'+di)
    qcd = QCD.Get("e_t_CollinearMass")
    qcd.SetName('Fakes')
    tfakes = QCD.Get("e_t_CollinearMass")
    tfakesup = QCD.Get("TauFakeUp/e_t_CollinearMass")
    tfakesdown = QCD.Get("TauFakeDown/e_t_CollinearMass")

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
            dy = DY.Get("e_t_CollinearMass")
        else:
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DY = SubtractionView(DYall, DYtfakes, restrict_positive=True)
            dy = DY.Get("e_t_CollinearMass")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/e_t_CollinearMass")
        dypuup.SetName(b[i]+"_CMS_Pileup_13TeVUp")
        dypudown = DY.Get("puDown/e_t_CollinearMass")
        dypudown.SetName(b[i]+"_CMS_Pileup_13TeVDown")

        dytrup = DY.Get("trUp/e_t_CollinearMass")
        dytrup.SetName(b[i]+"_CMS_Trigger_13TeVUp")
        dytrdown = DY.Get("trDown/e_t_CollinearMass")
        dytrdown.SetName(b[i]+"_CMS_Trigger_13TeVDown")

        dyrecrespup = DY.Get("recrespUp/e_t_CollinearMass")
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = DY.Get("recrespDown/e_t_CollinearMass")
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        dyrecresoup = DY.Get("recresoUp/e_t_CollinearMass")
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = DY.Get("recresoDown/e_t_CollinearMass")
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        dyptup = DY.Get("DYptreweightUp/e_t_CollinearMass")
        dyptup.SetName(b[i]+"_CMS_pTreweight_13TeVUp")
        dyptdown = DY.Get("DYptreweightDown/e_t_CollinearMass")
        dyptdown.SetName(b[i]+"_CMS_pTreweight_13TeVDown")

        dymtfakeup = DY.Get("mtfakeUp/e_t_CollinearMass")
        dymtfakeup.SetName(b[i]+"_CMS_scale_mfaketau_13TeVUp")
        dymtfakedown = DY.Get("mtfakeDown/e_t_CollinearMass")
        dymtfakedown.SetName(b[i]+"_CMS_scale_mfaketau_13TeVDown")

        dyetfakeup = DY.Get("etfakeUp/e_t_CollinearMass")
        dyetfakeup.SetName(b[i]+"_CMS_scale_efaketau_13TeVUp")
        dyetfakedown = DY.Get("etfakeDown/e_t_CollinearMass")
        dyetfakedown.SetName(b[i]+"_CMS_scale_efaketau_13TeVDown")

        dyetefakeup = DY.Get("etefakeUp/e_t_CollinearMass")
        dyetefakeup.SetName(b[i]+"_CMS_scale_efaketaues_13TeVUp")
        dyetefakedown = DY.Get("etefakeDown/e_t_CollinearMass")
        dyetefakedown.SetName(b[i]+"_CMS_scale_efaketaues_13TeVDown")

        dytes0up = DY.Get("scaletDM0Up/e_t_CollinearMass")
        dytes0up.SetName(b[i]+"_CMS_scale_t_1prong_13TeVUp")
        dytes0down = DY.Get("scaletDM0Down/e_t_CollinearMass")
        dytes0down.SetName(b[i]+"_CMS_scale_t_1prong_13TeVDown")
        dytes1up = DY.Get("scaletDM1Up/e_t_CollinearMass")
        dytes1up.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVUp")
        dytes1down = DY.Get("scaletDM1Down/e_t_CollinearMass")
        dytes1down.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVDown")
        dytes10up = DY.Get("scaletDM10Up/e_t_CollinearMass")
        dytes10up.SetName(b[i]+"_CMS_scale_t_3prong_13TeVUp")
        dytes10down = DY.Get("scaletDM10Down/e_t_CollinearMass")
        dytes10down.SetName(b[i]+"_CMS_scale_t_3prong_13TeVDown")

        dyeesup = DY.Get("eesUp/e_t_CollinearMass")
        dyeesup.SetName(b[i]+"_CMS_EES_13TeVUp")
        dyeesdown = DY.Get("eesDown/e_t_CollinearMass")
        dyeesdown.SetName(b[i]+"_CMS_EES_13TeVDown")

        dyuesup = DY.Get("UnclusteredEnUp/e_t_CollinearMass")
        dyuesup.SetName(b[i]+"_CMS_MET_Ues_13TeVUp")
        dyuesdown = DY.Get("UnclusteredEnDown/e_t_CollinearMass")
        dyuesdown.SetName(b[i]+"_CMS_MET_Ues_13TeVDown")

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/e_t_CollinearMass")
        dyjetAFMup.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/e_t_CollinearMass")
        dyjetAFMdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/e_t_CollinearMass")
        dyjetAMPFBup.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/e_t_CollinearMass")
        dyjetAMPFBdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/e_t_CollinearMass")
        dyjetASup.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/e_t_CollinearMass")
        dyjetASdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/e_t_CollinearMass")
        dyjetAStup.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/e_t_CollinearMass")
        dyjetAStdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/e_t_CollinearMass")
        dyjetFQCDup.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/e_t_CollinearMass")
        dyjetFQCDdown.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown")
        dyjetFup = DY.Get("JetFragmentationUp/e_t_CollinearMass")
        dyjetFup.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVUp")
        dyjetFdown = DY.Get("JetFragmentationDown/e_t_CollinearMass")
        dyjetFdown.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/e_t_CollinearMass")
        dyjetPUDMCup.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/e_t_CollinearMass")
        dyjetPUDMCdown.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/e_t_CollinearMass")
        dyjetPUPBBup.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/e_t_CollinearMass")
        dyjetPUPBBdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/e_t_CollinearMass")
        dyjetPUPEC1up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/e_t_CollinearMass")
        dyjetPUPEC1down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/e_t_CollinearMass")
        dyjetPUPEC2up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/e_t_CollinearMass")
        dyjetPUPEC2down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/e_t_CollinearMass")
        dyjetPUPHFup.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/e_t_CollinearMass")
        dyjetPUPHFdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/e_t_CollinearMass")
        dyjetPUPRup.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/e_t_CollinearMass")
        dyjetPUPRdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/e_t_CollinearMass")
        dyjetRFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/e_t_CollinearMass")
        dyjetRFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/e_t_CollinearMass")
        dyjetRJEREC1up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/e_t_CollinearMass")
        dyjetRJEREC1down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/e_t_CollinearMass")
        dyjetRJEREC2up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/e_t_CollinearMass")
        dyjetRJEREC2down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/e_t_CollinearMass")
        dyjetRJERHFup.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/e_t_CollinearMass")
        dyjetRJERHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/e_t_CollinearMass")
        dyjetRPBBup.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/e_t_CollinearMass")
        dyjetRPBBdown.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/e_t_CollinearMass")
        dyjetRPEC1up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/e_t_CollinearMass")
        dyjetRPEC1down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/e_t_CollinearMass")
        dyjetRPEC2up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/e_t_CollinearMass")
        dyjetRPEC2down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/e_t_CollinearMass")
        dyjetRPHFup.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/e_t_CollinearMass")
        dyjetRPHFdown.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/e_t_CollinearMass")
        dyjetRSECup.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/e_t_CollinearMass")
        dyjetRSECdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/e_t_CollinearMass")
        dyjetRSFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/e_t_CollinearMass")
        dyjetRSFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/e_t_CollinearMass")
        dyjetRSHFup.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/e_t_CollinearMass")
        dyjetRSHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/e_t_CollinearMass")
        dyjetSPEup.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/e_t_CollinearMass")
        dyjetSPEdown.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/e_t_CollinearMass")
        dyjetSPHup.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/e_t_CollinearMass")
        dyjetSPHdown.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/e_t_CollinearMass")
        dyjetTPEup.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/e_t_CollinearMass")
        dyjetTPEdown.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/e_t_CollinearMass")
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/e_t_CollinearMass")
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/e_t_CollinearMass")
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/e_t_CollinearMass")
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

        dyall = DYall.Get("e_t_CollinearMass")
        dytfakes = DYtfakes.Get("e_t_CollinearMass")
        dytfakesup = DYtfakes.Get("TauFakeUp/e_t_CollinearMass") 
        dytfakesdown = DYtfakes.Get("TauFakeDown/e_t_CollinearMass")

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
            #emb.Delete()
            qcd.Delete()
            f1.Delete()
            f2.Delete()
            #emb1.Delete()
            #emb2.Delete()
            #embtrup.Delete()
            #embtrdown.Delete()
            #embseltrup.Delete()
            #embseltrdown.Delete()
            #embtrkup.Delete()
            #embtrkdown.Delete()
            #embtes0up.Delete()
            #embtes0down.Delete()
            #embtes1up.Delete()
            #embtes1down.Delete()
            #embtes10up.Delete()
            #embtes10down.Delete()
        f.Write()
