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
    files.extend(glob.glob('results/%s/AnalyzeMuTauSys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuTauSys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuTauTFakes.root', 'RECREATE')

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
    data = DataAll.Get("m_t_CollinearMass")
    data.SetName('data_obs')
    
    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, 'TightOS'+di)
    embedtfakes = views.SubdirectoryView(embedtotal, 'TauLooseOS'+di)
    embed = SubtractionView(embedall, embedtfakes, restrict_positive=True)
    emb = embed.Get("m_t_CollinearMass")
    emb.SetName('embed')

    embtrup = embed.Get("trUp/m_t_CollinearMass")
    embtrup.SetName("embed_CMS_Trigger_13TeVUp")
    embtrdown = embed.Get("trDown/m_t_CollinearMass")
    embtrdown.SetName("embed_CMS_Trigger_13TeVDown")

    embseltrup = embed.Get("embtrUp/m_t_CollinearMass")
    embseltrup.SetName("embed_CMS_selection_mUp")
    embseltrdown = embed.Get("embtrDown/m_t_CollinearMass")
    embseltrdown.SetName("embed_CMS_selection_mDown")

    embtrkup = embed.Get("embtrkUp/m_t_CollinearMass")
    embtrkup.SetName("embed_CMS_tracking_tauUp")
    embtrkdown = embed.Get("embtrkDown/m_t_CollinearMass")
    embtrkdown.SetName("embed_CMS_tracking_tauDown")

    embtes0up = embed.Get("scaletDM0Up/m_t_CollinearMass")
    embtes0up.SetName("embed_CMS_scale_t_1prong_13TeVUp")
    embtes0down = embed.Get("scaletDM0Down/m_t_CollinearMass")
    embtes0down.SetName("embed_CMS_scale_t_1prong_13TeVDown")
    embtes1up = embed.Get("scaletDM1Up/m_t_CollinearMass")
    embtes1up.SetName("embed_CMS_scale_t_1prong1pizero_13TeVUp")
    embtes1down = embed.Get("scaletDM1Down/m_t_CollinearMass")
    embtes1down.SetName("embed_CMS_scale_t_1prong1pizero_13TeVDown")
    embtes10up = embed.Get("scaletDM10Up/m_t_CollinearMass")
    embtes10up.SetName("embed_CMS_scale_t_3prong_13TeVUp")
    embtes10down = embed.Get("scaletDM10Down/m_t_CollinearMass")
    embtes10down.SetName("embed_CMS_scale_t_3prong_13TeVDown")

    emball = embedall.Get("m_t_CollinearMass")
    embtfakesup = embedtfakes.Get("TauFakeUp/m_t_CollinearMass")
    embtfakesdown = embedtfakes.Get("TauFakeDown/m_t_CollinearMass")
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
    embtfakesup.Delete()
    embtfakesdown.Delete()
    
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(QCD, 'TauLooseOS'+di)
    qcd = fakesTau.Get("m_t_CollinearMass")
    qcd.SetName('Fakes')
    tfakesup = fakesTau.Get("TauFakeUp/m_t_CollinearMass")
    tfakesdown = fakesTau.Get("TauFakeDown/m_t_CollinearMass")
    tfakesup.SetName("Fakes_CMS_TauFakeRate_13TeVUp")
    tfakesdown.SetName("Fakes_CMS_TauFakeRate_13TeVDown")

    for i in range(11):
        DYtotal = v[i]
        if b[i]=='GluGlu125' or b[i]=='VBF125':                                                                                                                                                                                                                        
            DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)                                                                                                                                                                                                                 
            dy = DY.Get("m_t_CollinearMass")                                                                                                                                                                                                                                   
        else:
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DY = SubtractionView(DYall, DYtfakes, restrict_positive=True)
            dy = DY.Get("m_t_CollinearMass")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/m_t_CollinearMass")
        dypuup.SetName(b[i]+"_CMS_Pileup_13TeVUp")
        dypudown = DY.Get("puDown/m_t_CollinearMass")
        dypudown.SetName(b[i]+"_CMS_Pileup_13TeVDown")

        dytrup = DY.Get("trUp/m_t_CollinearMass")
        dytrup.SetName(b[i]+"_CMS_Trigger_13TeVUp")
        dytrdown = DY.Get("trDown/m_t_CollinearMass")
        dytrdown.SetName(b[i]+"_CMS_Trigger_13TeVDown")

        dytidup = DY.Get("tidUp/m_t_CollinearMass")                                                                                                                                                                                                                           
        dytidup.SetName(b[i]+"_CMS_TauID_13TeVUp")                                                                                                                                                                                                                            
        dytiddown = DY.Get("tidDown/m_t_CollinearMass")                                                                                                                                                                                                               
        dytiddown.SetName(b[i]+"_CMS_TauID_13TeVDown")

        dyrecrespup = DY.Get("recrespUp/m_t_CollinearMass")
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = DY.Get("recrespDown/m_t_CollinearMass")
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        dyrecresoup = DY.Get("recresoUp/m_t_CollinearMass")
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = DY.Get("recresoDown/m_t_CollinearMass")
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        dyptup = DY.Get("DYptreweightUp/m_t_CollinearMass")
        dyptup.SetName(b[i]+"_CMS_DYpTreweight_13TeVUp")
        dyptdown = DY.Get("DYptreweightDown/m_t_CollinearMass")
        dyptdown.SetName(b[i]+"_CMS_DYpTreweight_13TeVDown")

        dytptup = DY.Get("TopptreweightUp/m_t_CollinearMass")                                                                                                                                                                                                         
        dytptup.SetName(b[i]+"_CMS_ToppTreweight_13TeVUp")                                                                                                                                                                                                       
        dytptdown = DY.Get("TopptreweightDown/m_t_CollinearMass")                                                                                                                                                                                      
        dytptdown.SetName(b[i]+"_CMS_ToppTreweight_13TeVDown")

        dymtfakeup = DY.Get("mtfakeUp/m_t_CollinearMass")
        dymtfakeup.SetName(b[i]+"_CMS_scale_mfaketau_13TeVUp")
        dymtfakedown = DY.Get("mtfakeDown/m_t_CollinearMass")
        dymtfakedown.SetName(b[i]+"_CMS_scale_mfaketau_13TeVDown")

        dyetfakeup = DY.Get("etfakeUp/m_t_CollinearMass")
        dyetfakeup.SetName(b[i]+"_CMS_scale_efaketau_13TeVUp")
        dyetfakedown = DY.Get("etfakeDown/m_t_CollinearMass")
        dyetfakedown.SetName(b[i]+"_CMS_scale_efaketau_13TeVDown")

        dyetefakeup = DY.Get("etefakeUp/m_t_CollinearMass")
        dyetefakeup.SetName(b[i]+"_CMS_scale_efaketaues_13TeVUp")
        dyetefakedown = DY.Get("etefakeDown/m_t_CollinearMass")
        dyetefakedown.SetName(b[i]+"_CMS_scale_efaketaues_13TeVDown")

        dytes0up = DY.Get("scaletDM0Up/m_t_CollinearMass")
        dytes0up.SetName(b[i]+"_CMS_scale_t_1prong_13TeVUp")
        dytes0down = DY.Get("scaletDM0Down/m_t_CollinearMass")
        dytes0down.SetName(b[i]+"_CMS_scale_t_1prong_13TeVDown")
        dytes1up = DY.Get("scaletDM1Up/m_t_CollinearMass")
        dytes1up.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVUp")
        dytes1down = DY.Get("scaletDM1Down/m_t_CollinearMass")
        dytes1down.SetName(b[i]+"_CMS_scale_t_1prong1pizero_13TeVDown")
        dytes10up = DY.Get("scaletDM10Up/m_t_CollinearMass")
        dytes10up.SetName(b[i]+"_CMS_scale_t_3prong_13TeVUp")
        dytes10down = DY.Get("scaletDM10Down/m_t_CollinearMass")
        dytes10down.SetName(b[i]+"_CMS_scale_t_3prong_13TeVDown")

        dymesup = DY.Get("mesUp/m_t_CollinearMass")
        dymesup.SetName(b[i]+"_CMS_MES_13TeVUp")
        dymesdown = DY.Get("mesDown/m_t_CollinearMass")
        dymesdown.SetName(b[i]+"_CMS_MES_13TeVDown")

        dyuesup = DY.Get("UnclusteredEnUp/m_t_CollinearMass")
        dyuesup.SetName(b[i]+"_CMS_MET_Ues_13TeVUp")
        dyuesdown = DY.Get("UnclusteredEnDown/m_t_CollinearMass")
        dyuesdown.SetName(b[i]+"_CMS_MET_Ues_13TeVDown")

        dyjet03up = DY.Get("JetEta0to3Up/m_t_CollinearMass")
        dyjet03up.SetName(b[i]+"_CMS_Jes_JetEta0to3_13TeVUp")
        dyjet03down = DY.Get("JetEta0to3Down/m_t_CollinearMass")
        dyjet03down.SetName(b[i]+"_CMS_Jes_JetEta0to3_13TeVDown")
        dyjet05up = DY.Get("JetEta0to5Up/m_t_CollinearMass")
        dyjet05up.SetName(b[i]+"_CMS_Jes_JetEta0to5_13TeVUp")
        dyjet05down = DY.Get("JetEta0to5Down/m_t_CollinearMass")
        dyjet05down.SetName(b[i]+"_CMS_Jes_JetEta0to5_13TeVDown")
        dyjet35up = DY.Get("JetEta3to5Up/m_t_CollinearMass")
        dyjet35up.SetName(b[i]+"_CMS_Jes_JetEta3to5_13TeVUp")
        dyjet35down = DY.Get("JetEta3to5Down/m_t_CollinearMass")
        dyjet35down.SetName(b[i]+"_CMS_Jes_JetEta3to5_13TeVDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/m_t_CollinearMass")
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/m_t_CollinearMass")
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/m_t_CollinearMass")
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/m_t_CollinearMass")
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

        if not b[i]=='GluGlu125' and not b[i]=='VBF125':
            dyall = DYall.Get("m_t_CollinearMass")
            dytfakesup = DYtfakes.Get("TauFakeUp/m_t_CollinearMass") 
            dytfakesdown = DYtfakes.Get("TauFakeDown/m_t_CollinearMass")
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
            dytfakesup.Delete()
            dytfakesdown.Delete()

        if i==1:
            data.Delete()
            emb.Delete()
            qcd.Delete()
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
