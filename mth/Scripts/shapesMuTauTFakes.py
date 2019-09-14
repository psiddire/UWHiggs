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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuTauSys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuTauSys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapes/shapesMuTauTFakes.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau') or x.startswith('GluGluHToWW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau') or x.startswith('VBFHToWW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau') , mc_samples)]), 
#views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ttHToTauTau') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV') , mc_samples)]), 
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV') , mc_samples)])
]

b = ['Zll', 'EWK', 'GluGluH', 'VBFH', 'VH', 'TT', 'ST', 'EWKDiboson', 'GluGlu125', 'VBF125']

for di in dirs:

    if di=='0Jet' or di=='1Jet':
        binning = array.array('d', (range(0, 100, 25) + range(100, 200, 10) + range(200, 300, 25)))
    else:
        binning = array.array('d', (range(0, 300, 25)))

    d = f.mkdir(di)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    data = DataAll.Get("m_t_CollinearMass")
    data = data.Rebin(len(binning)-1, "data_obs", binning)
    
    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, 'TightOS'+di)
    embedtfakes = views.SubdirectoryView(embedtotal, 'TauLooseOS'+di)
    embed = SubtractionView(embedall, embedtfakes, restrict_positive=True)
    emb = embed.Get("m_t_CollinearMass")
    emb = emb.Rebin(len(binning)-1, "embed", binning)

    embtrup = embed.Get("trUp/m_t_CollinearMass")
    embtrup = embtrup.Rebin(len(binning)-1, "embed_CMS_Trigger_13TeVUp", binning)
    embtrdown = embed.Get("trDown/m_t_CollinearMass")
    embtrdown = embtrdown.Rebin(len(binning)-1, "embed_CMS_Trigger_13TeVDown", binning)

    embseltrup = embed.Get("embtrUp/m_t_CollinearMass")
    embseltrup = embseltrup.Rebin(len(binning)-1, "embed_CMS_selection_mUp", binning)
    embseltrdown = embed.Get("embtrDown/m_t_CollinearMass")
    embseltrdown = embseltrdown.Rebin(len(binning)-1, "embed_CMS_selection_mDown", binning)

    embtrkup = embed.Get("embtrkUp/m_t_CollinearMass")
    embtrkup = embtrkup.Rebin(len(binning)-1, "embed_CMS_tracking_tauUp", binning)
    embtrkdown = embed.Get("embtrkDown/m_t_CollinearMass")
    embtrkdown = embtrkdown.Rebin(len(binning)-1, "embed_CMS_tracking_tauDown", binning)

    embtes0up = embed.Get("scaletDM0Up/m_t_CollinearMass")
    embtes0up = embtes0up.Rebin(len(binning)-1, "embed_CMS_scale_t_1prong_13TeVUp", binning)
    embtes0down = embed.Get("scaletDM0Down/m_t_CollinearMass")
    embtes0down = embtes0down.Rebin(len(binning)-1, "embed_CMS_scale_t_1prong_13TeVDown", binning)

    embtes1up = embed.Get("scaletDM1Up/m_t_CollinearMass")
    embtes1up = embtes1up.Rebin(len(binning)-1, "embed_CMS_scale_t_1prong1pizero_13TeVUp", binning)
    embtes1down = embed.Get("scaletDM1Down/m_t_CollinearMass")
    embtes1down = embtes1down.Rebin(len(binning)-1, "embed_CMS_scale_t_1prong1pizero_13TeVDown", binning)

    embtes10up = embed.Get("scaletDM10Up/m_t_CollinearMass")
    embtes10up = embtes10up.Rebin(len(binning)-1, "embed_CMS_scale_t_3prong_13TeVUp", binning)
    embtes10down = embed.Get("scaletDM10Down/m_t_CollinearMass")
    embtes10down = embtes10down.Rebin(len(binning)-1, "embed_CMS_scale_t_3prong_13TeVDown", binning)

    emball = embedall.Get("m_t_CollinearMass")
    embtfakesup = embedtfakes.Get("TauFakeUp/m_t_CollinearMass")
    embtfakesdown = embedtfakes.Get("TauFakeDown/m_t_CollinearMass")
    emb1 = emball.Clone()
    emb1t = embtfakesup.Clone()
    emb1.add(emb1t, -1)
    emb1 = positivize(emb1)
    emb1 = emb1.Rebin(len(binning)-1, "embed_CMS_TauFakeRate_13TeVUp", binning)
    emb2 = emball.Clone()
    emb2t = embtfakesdown.Clone()
    emb2.add(emb2t, -1)
    emb2 = positivize(emb2)
    emb2 = emb2.Rebin(len(binning)-1, "embed_CMS_TauFakeRate_13TeVDown", binning)

    emball.Delete()
    emb1t.Delete()
    emb2t.Delete()
    embtfakesup.Delete()
    embtfakesdown.Delete()
    
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(QCD, 'TauLooseOS'+di)
    qcd = fakesTau.Get("m_t_CollinearMass")
    qcd = qcd.Rebin(len(binning)-1, "Fakes", binning)
    tfakesup = fakesTau.Get("TauFakeUp/m_t_CollinearMass")
    tfakesdown = fakesTau.Get("TauFakeDown/m_t_CollinearMass")
    tfakesup = tfakesup.Rebin(len(binning)-1, "Fakes_CMS_TauFakeRate_13TeVUp", binning)
    tfakesdown = tfakesdown.Rebin(len(binning)-1, "Fakes_CMS_TauFakeRate_13TeVDown", binning)

    for i in range(10):
        DYtotal = v[i]
        if b[i]=='GluGlu125' or b[i]=='VBF125':
            DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)                                                                                                                                                                                                              
            dy = DY.Get("m_t_CollinearMass")
        else:
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DY = SubtractionView(DYall, DYtfakes, restrict_positive=True)
            dy = DY.Get("m_t_CollinearMass")
        dy = dy.Rebin(len(binning)-1, b[i], binning)

        dypuup = DY.Get("puUp/m_t_CollinearMass")
        dypuup = dypuup.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVUp", binning)
        dypudown = DY.Get("puDown/m_t_CollinearMass")
        dypudown = dypudown.Rebin(len(binning)-1, b[i]+"_CMS_Pileup_13TeVDown", binning)

        dytrup = DY.Get("trUp/m_t_CollinearMass")
        dytrup = dytrup.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVUp", binning)
        dytrdown = DY.Get("trDown/m_t_CollinearMass")
        dytrdown = dytrdown.Rebin(len(binning)-1, b[i]+"_CMS_Trigger_13TeVDown", binning)

        dytidup = DY.Get("tidUp/m_t_CollinearMass")                                                                                                                                                                                                                           
        dytidup = dytidup.Rebin(len(binning)-1, b[i]+"_CMS_TauID_13TeVUp", binning)
        dytiddown = DY.Get("tidDown/m_t_CollinearMass")                                                                                                                                                                                                               
        dytiddown = dytiddown.Rebin(len(binning)-1, b[i]+"_CMS_TauID_13TeVDown", binning)

        dyrecrespup = DY.Get("recrespUp/m_t_CollinearMass")
        dyrecrespup = dyrecrespup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVUp", binning)
        dyrecrespdown = DY.Get("recrespDown/m_t_CollinearMass")
        dyrecrespdown = dyrecrespdown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResponse_13TeVDown", binning)

        dyrecresoup = DY.Get("recresoUp/m_t_CollinearMass")
        dyrecresoup = dyrecresoup.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVUp", binning)
        dyrecresodown = DY.Get("recresoDown/m_t_CollinearMass")
        dyrecresodown = dyrecresodown.Rebin(len(binning)-1, b[i]+"_CMS_RecoilResolution_13TeVDown", binning)

        dyptup = DY.Get("DYptreweightUp/m_t_CollinearMass")
        dyptup = dyptup.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVUp", binning)
        dyptdown = DY.Get("DYptreweightDown/m_t_CollinearMass")
        dyptdown = dyptdown.Rebin(len(binning)-1, b[i]+"_CMS_DYpTreweight_13TeVDown", binning)

        dybtagup = DY.Get("bTagUp/m_t_CollinearMass")
        dybtagup = dybtagup.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVUp", binning)
        dybtagdown = DY.Get("bTagDown/m_t_CollinearMass")
        dybtagdown = dybtagdown.Rebin(len(binning)-1, b[i]+"_CMS_eff_btag_13TeVDown", binning)

        dytptup = DY.Get("TopptreweightUp/m_t_CollinearMass")                                                                                                                                                                                                         
        dytptup = dytptup.Rebin(len(binning)-1, b[i]+"_CMS_ToppTreweight_13TeVUp", binning)
        dytptdown = DY.Get("TopptreweightDown/m_t_CollinearMass")                                                                                                                                                                                      
        dytptdown = dytptdown.Rebin(len(binning)-1, b[i]+"_CMS_ToppTreweight_13TeVDown", binning)

        dymtfakeup = DY.Get("mtfakeUp/m_t_CollinearMass")
        dymtfakeup = dymtfakeup.Rebin(len(binning)-1, b[i]+"_CMS_scale_mfaketau_13TeVUp", binning)
        dymtfakedown = DY.Get("mtfakeDown/m_t_CollinearMass")
        dymtfakedown = dymtfakedown.Rebin(len(binning)-1, b[i]+"_CMS_scale_mfaketau_13TeVDown", binning)

        dyetfakeup = DY.Get("etfakeUp/m_t_CollinearMass")
        dyetfakeup = dyetfakeup.Rebin(len(binning)-1, b[i]+"_CMS_scale_efaketau_13TeVUp", binning)
        dyetfakedown = DY.Get("etfakeDown/m_t_CollinearMass")
        dyetfakedown = dyetfakedown.Rebin(len(binning)-1, b[i]+"_CMS_scale_efaketau_13TeVDown", binning)

        dyetefakeup = DY.Get("etefakeUp/m_t_CollinearMass")
        dyetefakeup = dyetefakeup.Rebin(len(binning)-1, b[i]+"_CMS_scale_efaketaues_13TeVUp", binning)
        dyetefakedown = DY.Get("etefakeDown/m_t_CollinearMass")
        dyetefakedown = dyetefakedown.Rebin(len(binning)-1, b[i]+"_CMS_scale_efaketaues_13TeVDown", binning)

        dytes0up = DY.Get("scaletDM0Up/m_t_CollinearMass")
        dytes0up = dytes0up.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_1prong_13TeVUp", binning)
        dytes0down = DY.Get("scaletDM0Down/m_t_CollinearMass")
        dytes0down = dytes0down.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_1prong_13TeVDown", binning)

        dytes1up = DY.Get("scaletDM1Up/m_t_CollinearMass")
        dytes1up = dytes1up.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_1prong1pizero_13TeVUp", binning)
        dytes1down = DY.Get("scaletDM1Down/m_t_CollinearMass")
        dytes1down = dytes1down.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_1prong1pizero_13TeVDown", binning)

        dytes10up = DY.Get("scaletDM10Up/m_t_CollinearMass")
        dytes10up = dytes10up.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_3prong_13TeVUp", binning)
        dytes10down = DY.Get("scaletDM10Down/m_t_CollinearMass")
        dytes10down = dytes10down.Rebin(len(binning)-1, b[i]+"_CMS_scale_t_3prong_13TeVDown", binning)

        dymesup = DY.Get("mesUp/m_t_CollinearMass")
        dymesup = dymesup.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVUp", binning)
        dymesdown = DY.Get("mesDown/m_t_CollinearMass")
        dymesdown = dymesdown.Rebin(len(binning)-1, b[i]+"_CMS_MES_13TeVDown", binning)

        dyuesup = DY.Get("UnclusteredEnUp/m_t_CollinearMass")
        dyuesup = dyuesup.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVUp", binning)
        dyuesdown = DY.Get("UnclusteredEnDown/m_t_CollinearMass")
        dyuesdown = dyuesdown.Rebin(len(binning)-1, b[i]+"_CMS_MET_Ues_13TeVDown", binning)

        dyjetAFMup = DY.Get("JetAbsoluteFlavMapUp/m_t_CollinearMass")
        dyjetAFMup = dyjetAFMup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp", binning)
        dyjetAFMdown = DY.Get("JetAbsoluteFlavMapDown/m_t_CollinearMass")
        dyjetAFMdown = dyjetAFMdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown", binning)

        dyjetAMPFBup = DY.Get("JetAbsoluteMPFBiasUp/m_t_CollinearMass")
        dyjetAMPFBup = dyjetAMPFBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp", binning)
        dyjetAMPFBdown = DY.Get("JetAbsoluteMPFBiasDown/m_t_CollinearMass")
        dyjetAMPFBdown = dyjetAMPFBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown", binning)

        dyjetASup = DY.Get("JetAbsoluteScaleUp/m_t_CollinearMass")
        dyjetASup = dyjetASup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp", binning)
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/m_t_CollinearMass")
        dyjetASdown = dyjetASdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown", binning)

        dyjetAStup = DY.Get("JetAbsoluteStatUp/m_t_CollinearMass")
        dyjetAStup = dyjetAStup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp", binning)
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/m_t_CollinearMass")
        dyjetAStdown = dyjetAStdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown", binning)

        dyjetFQCDup = DY.Get("JetFlavorQCDUp/m_t_CollinearMass")
        dyjetFQCDup = dyjetFQCDup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp", binning)
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/m_t_CollinearMass")
        dyjetFQCDdown = dyjetFQCDdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown", binning)

        dyjetFup = DY.Get("JetFragmentationUp/m_t_CollinearMass")
        dyjetFup = dyjetFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVUp", binning)
        dyjetFdown = DY.Get("JetFragmentationDown/m_t_CollinearMass")
        dyjetFdown = dyjetFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetFragmentation_13TeVDown", binning)

        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/m_t_CollinearMass")
        dyjetPUDMCup = dyjetPUDMCup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp", binning)
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/m_t_CollinearMass")
        dyjetPUDMCdown = dyjetPUDMCdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown", binning)

        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/m_t_CollinearMass")
        dyjetPUPBBup = dyjetPUPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp", binning)
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/m_t_CollinearMass")
        dyjetPUPBBdown = dyjetPUPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown", binning)

        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/m_t_CollinearMass")
        dyjetPUPEC1up = dyjetPUPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp", binning)
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/m_t_CollinearMass")
        dyjetPUPEC1down = dyjetPUPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown", binning)

        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/m_t_CollinearMass")
        dyjetPUPEC2up = dyjetPUPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp", binning)
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/m_t_CollinearMass")
        dyjetPUPEC2down = dyjetPUPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown", binning)

        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/m_t_CollinearMass")
        dyjetPUPHFup = dyjetPUPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp", binning)
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/m_t_CollinearMass")
        dyjetPUPHFdown = dyjetPUPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown", binning)

        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/m_t_CollinearMass")
        dyjetPUPRup = dyjetPUPRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp", binning)
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/m_t_CollinearMass")
        dyjetPUPRdown = dyjetPUPRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown", binning)

        dyjetRFSRup = DY.Get("JetRelativeFSRUp/m_t_CollinearMass")
        dyjetRFSRup = dyjetRFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp", binning)
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/m_t_CollinearMass")
        dyjetRFSRdown = dyjetRFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown", binning)

        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/m_t_CollinearMass")
        dyjetRJEREC1up = dyjetRJEREC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp", binning)
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/m_t_CollinearMass")
        dyjetRJEREC1down = dyjetRJEREC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown", binning)

        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/m_t_CollinearMass")
        dyjetRJEREC2up = dyjetRJEREC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp", binning)
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/m_t_CollinearMass")
        dyjetRJEREC2down = dyjetRJEREC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown", binning)

        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/m_t_CollinearMass")
        dyjetRJERHFup = dyjetRJERHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp", binning)
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/m_t_CollinearMass")
        dyjetRJERHFdown = dyjetRJERHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown", binning)

        dyjetRPBBup = DY.Get("JetRelativePtBBUp/m_t_CollinearMass")
        dyjetRPBBup = dyjetRPBBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp", binning)
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/m_t_CollinearMass")
        dyjetRPBBdown = dyjetRPBBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown", binning)

        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/m_t_CollinearMass")
        dyjetRPEC1up = dyjetRPEC1up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp", binning)
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/m_t_CollinearMass")
        dyjetRPEC1down = dyjetRPEC1down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown", binning)

        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/m_t_CollinearMass")
        dyjetRPEC2up = dyjetRPEC2up.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp", binning)
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/m_t_CollinearMass")
        dyjetRPEC2down = dyjetRPEC2down.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown", binning)

        dyjetRPHFup = DY.Get("JetRelativePtHFUp/m_t_CollinearMass")
        dyjetRPHFup = dyjetRPHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp", binning)
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/m_t_CollinearMass")
        dyjetRPHFdown = dyjetRPHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown", binning)

        dyjetRSECup = DY.Get("JetRelativeStatECUp/m_t_CollinearMass")
        dyjetRSECup = dyjetRSECup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp", binning)
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/m_t_CollinearMass")
        dyjetRSECdown = dyjetRSECdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown", binning)

        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/m_t_CollinearMass")
        dyjetRSFSRup = dyjetRSFSRup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp", binning)
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/m_t_CollinearMass")
        dyjetRSFSRdown = dyjetRSFSRdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown", binning)

        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/m_t_CollinearMass")
        dyjetRSHFup = dyjetRSHFup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp", binning)
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/m_t_CollinearMass")
        dyjetRSHFdown = dyjetRSHFdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown", binning)

        dyjetSPEup = DY.Get("JetSinglePionECALUp/m_t_CollinearMass")
        dyjetSPEup = dyjetSPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp", binning)
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/m_t_CollinearMass")
        dyjetSPEdown = dyjetSPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown", binning)

        dyjetSPHup = DY.Get("JetSinglePionHCALUp/m_t_CollinearMass")
        dyjetSPHup = dyjetSPHup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp", binning)
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/m_t_CollinearMass")
        dyjetSPHdown = dyjetSPHdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown", binning)

        dyjetTPEup = DY.Get("JetTimePtEtaUp/m_t_CollinearMass")
        dyjetTPEup = dyjetTPEup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp", binning)
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/m_t_CollinearMass")
        dyjetTPEdown = dyjetTPEdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown", binning)

        dyjetRBup = DY.Get("JetRelativeBalUp/m_t_CollinearMass")
        dyjetRBup = dyjetRBup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp", binning)
        dyjetRBdown = DY.Get("JetRelativeBalDown/m_t_CollinearMass")
        dyjetRBdown = dyjetRBdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown", binning)

        dyjetRSup = DY.Get("JetRelativeSampleUp/m_t_CollinearMass")
        dyjetRSup = dyjetRSup.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp", binning)
        dyjetRSdown = DY.Get("JetRelativeSampleDown/m_t_CollinearMass")
        dyjetRSdown = dyjetRSdown.Rebin(len(binning)-1, b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown", binning)

        if not b[i]=='GluGlu125' and not b[i]=='VBF125':
            dyall = DYall.Get("m_t_CollinearMass")
            dytfakesup = DYtfakes.Get("TauFakeUp/m_t_CollinearMass") 
            dytfakesdown = DYtfakes.Get("TauFakeDown/m_t_CollinearMass")
            dy1 = dyall.Clone()
            dy1t = dytfakesup.Clone()
            dy1.add(dy1t, -1)
            dy1 = positivize(dy1)
            dy1 = dy1.Rebin(len(binning)-1, b[i]+"_CMS_TauFakeRate_13TeVUp", binning)
            dy2 = dyall.Clone()
            dy2t = dytfakesdown.Clone()
            dy2.add(dy2t, -1)
            dy2 = positivize(dy2)
            dy2 = dy2.Rebin(len(binning)-1, b[i]+"_CMS_TauFakeRate_13TeVDown", binning)
            dyall.Delete()
            dy1t.Delete()
            dy2t.Delete()
            dytfakesup.Delete()
            dytfakesdown.Delete()

        f.Write()
        if i==0:
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
        dy.Delete()
        dypuup.Delete()
        dypudown.Delete()
        dytrup.Delete()
        dytrdown.Delete()
        dytidup.Delete()
        dytiddown.Delete()
        dyrecrespup.Delete()
        dyrecrespdown.Delete()
        dyrecresoup.Delete()
        dyrecresodown.Delete()
        dyptup.Delete()
        dyptdown.Delete()
        dybtagup.Delete()
        dybtagdown.Delete()
        dytptup.Delete()
        dytptdown.Delete()
        dymtfakeup.Delete()
        dymtfakedown.Delete()
        dyetfakeup.Delete()
        dyetfakedown.Delete()
        dyetefakeup.Delete()
        dyetefakedown.Delete()
        dytes0up.Delete()
        dytes0down.Delete()
        dytes1up.Delete()
        dytes1down.Delete()
        dytes10up.Delete()
        dytes10down.Delete()
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
        if not b[i]=='GluGlu125' and not b[i]=='VBF125':
            dy1.Delete()
            dy2.Delete()
