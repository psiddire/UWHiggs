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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuTauSysVTight/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuTauSysVTight/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuTauMC.root', 'RECREATE')

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
    
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(QCD, 'TauLooseOS'+di)
    fakesMuon = views.SubdirectoryView(QCD, 'MuonLooseOS'+di)
    fakesTauMuon = views.SubdirectoryView(QCD, 'MuonLooseTauLooseOS'+di)
    fakesMT = views.SumView(fakesTau, fakesMuon)
    QCD = SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True)
    qcd = QCD.Get("m_t_CollinearMass")
    qcd.SetName('Fakes')
    mfakes = fakesMuon.Get("m_t_CollinearMass")
    tfakes = fakesTau.Get("m_t_CollinearMass")
    mtfakes = fakesTauMuon.Get("m_t_CollinearMass")
    tfakesup = fakesTau.Get("TauFakeUp/m_t_CollinearMass")
    tfakesdown = fakesTau.Get("TauFakeDown/m_t_CollinearMass")
    mfakesup = fakesMuon.Get("MuonFakeUp/m_t_CollinearMass")
    mfakesdown = fakesMuon.Get("MuonFakeDown/m_t_CollinearMass")
    mttfakesup = fakesTauMuon.Get("TauFakeUp/m_t_CollinearMass")
    mttfakesdown = fakesTauMuon.Get("TauFakeDown/m_t_CollinearMass")
    mtmfakesup = fakesTauMuon.Get("MuonFakeUp/m_t_CollinearMass")
    mtmfakesdown = fakesTauMuon.Get("MuonFakeDown/m_t_CollinearMass")
    f1 = tfakesup.Clone()
    f1.add(mfakes)
    f1.add(mttfakesup, -1)
    f1 = positivize(f1)
    f1.SetName("Fakes_CMS_TauFakeRate_13TeVUp")
    f2 = tfakesdown.Clone()
    f2.add(mfakes)
    f2.add(mttfakesdown, -1)
    f2 = positivize(f2)
    f2.SetName("Fakes_CMS_TauFakeRate_13TeVDown")
    f3 = tfakes.Clone()
    f3.add(mfakesup)
    f3.add(mtmfakesup, -1)
    f3 = positivize(f3)
    f3.SetName("Fakes_CMS_MuonFakeRate_13TeVUp")
    f4 = tfakes.Clone()
    f4.add(mfakesdown)
    f4.add(mtmfakesdown, -1)
    f4 = positivize(f4)
    f4.SetName("Fakes_CMS_MuonFakeRate_13TeVDown")
    tfakes.Delete()
    mfakes.Delete()
    mtfakes.Delete()
    tfakesup.Delete()
    tfakesdown.Delete()
    mfakesup.Delete()
    mfakesdown.Delete()
    mttfakesup.Delete()
    mttfakesdown.Delete()
    mtmfakesup.Delete()
    mtmfakesdown.Delete()

    for i in range(11):
        DYtotal = v[i]
        if (b[i]=="Zll" or b[i]=="EWK"):
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DYmfakes = views.SubdirectoryView(DYtotal, 'MuonLooseOS'+di)
            DYmtfakes = views.SubdirectoryView(DYtotal, 'MuonLooseTauLooseOS'+di)
            DYmt = views.SumView(DYtfakes, DYmfakes)
            DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
            DY = SubtractionView(DYall, DYfakes, restrict_positive=True)
            dy = DY.Get("m_t_CollinearMass")
            dy.SetName(b[i])
        elif (b[i]=="TT"):
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TTToSemiLeptonic') or x.startswith('TTToHadronic'), mc_samples)]), 'TauLooseOS'+di)
            DYmfakes = views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TTToSemiLeptonic') or x.startswith('TTToHadronic'), mc_samples)]), 'MuonLooseOS'+di)
            DYmtfakes = views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TTToSemiLeptonic') or x.startswith('TTToHadronic'), mc_samples)]), 'MuonLooseTauLooseOS'+di)
            DYmt = views.SumView(DYtfakes, DYmfakes)
            DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
            DY = SubtractionView(DYall, DYfakes, restrict_positive=True)
            dy = DY.Get("m_t_CollinearMass")
            dy.SetName(b[i])
        else:
            DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
            DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
            DYmfakes = views.SubdirectoryView(DYtotal, 'MuonLooseOS'+di)
            DYmtfakes = views.SubdirectoryView(DYtotal, 'MuonLooseTauLooseOS'+di)
            DYmt = views.SumView(DYtfakes, DYmfakes)
            DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
            DY = DYall
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

        dyrecrespup = DY.Get("recrespUp/m_t_CollinearMass")
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = DY.Get("recrespDown/m_t_CollinearMass")
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        dyrecresoup = DY.Get("recresoUp/m_t_CollinearMass")
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = DY.Get("recresoDown/m_t_CollinearMass")
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        dyptup = DY.Get("DYptreweightUp/m_t_CollinearMass")
        dyptup.SetName(b[i]+"_CMS_pTreweight_13TeVUp")
        dyptdown = DY.Get("DYptreweightDown/m_t_CollinearMass")
        dyptdown.SetName(b[i]+"_CMS_pTreweight_13TeVDown")

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

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/m_t_CollinearMass")
        dyjetAFMup.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/m_t_CollinearMass")
        dyjetAFMdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/m_t_CollinearMass")
        dyjetAMPFBup.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/m_t_CollinearMass")
        dyjetAMPFBdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/m_t_CollinearMass")
        dyjetASup.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/m_t_CollinearMass")
        dyjetASdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/m_t_CollinearMass")
        dyjetAStup.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/m_t_CollinearMass")
        dyjetAStdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/m_t_CollinearMass")
        dyjetFQCDup.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/m_t_CollinearMass")
        dyjetFQCDdown.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown")
        dyjetFup = DY.Get("JetFragmentationUp/m_t_CollinearMass")
        dyjetFup.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVUp")
        dyjetFdown = DY.Get("JetFragmentationDown/m_t_CollinearMass")
        dyjetFdown.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/m_t_CollinearMass")
        dyjetPUDMCup.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/m_t_CollinearMass")
        dyjetPUDMCdown.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/m_t_CollinearMass")
        dyjetPUPBBup.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/m_t_CollinearMass")
        dyjetPUPBBdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/m_t_CollinearMass")
        dyjetPUPEC1up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/m_t_CollinearMass")
        dyjetPUPEC1down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/m_t_CollinearMass")
        dyjetPUPEC2up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/m_t_CollinearMass")
        dyjetPUPEC2down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/m_t_CollinearMass")
        dyjetPUPHFup.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/m_t_CollinearMass")
        dyjetPUPHFdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/m_t_CollinearMass")
        dyjetPUPRup.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/m_t_CollinearMass")
        dyjetPUPRdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/m_t_CollinearMass")
        dyjetRFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/m_t_CollinearMass")
        dyjetRFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/m_t_CollinearMass")
        dyjetRJEREC1up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/m_t_CollinearMass")
        dyjetRJEREC1down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/m_t_CollinearMass")
        dyjetRJEREC2up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/m_t_CollinearMass")
        dyjetRJEREC2down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/m_t_CollinearMass")
        dyjetRJERHFup.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/m_t_CollinearMass")
        dyjetRJERHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/m_t_CollinearMass")
        dyjetRPBBup.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/m_t_CollinearMass")
        dyjetRPBBdown.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/m_t_CollinearMass")
        dyjetRPEC1up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/m_t_CollinearMass")
        dyjetRPEC1down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/m_t_CollinearMass")
        dyjetRPEC2up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/m_t_CollinearMass")
        dyjetRPEC2down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/m_t_CollinearMass")
        dyjetRPHFup.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/m_t_CollinearMass")
        dyjetRPHFdown.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/m_t_CollinearMass")
        dyjetRSECup.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/m_t_CollinearMass")
        dyjetRSECdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/m_t_CollinearMass")
        dyjetRSFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/m_t_CollinearMass")
        dyjetRSFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/m_t_CollinearMass")
        dyjetRSHFup.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/m_t_CollinearMass")
        dyjetRSHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/m_t_CollinearMass")
        dyjetSPEup.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/m_t_CollinearMass")
        dyjetSPEdown.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/m_t_CollinearMass")
        dyjetSPHup.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/m_t_CollinearMass")
        dyjetSPHdown.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/m_t_CollinearMass")
        dyjetTPEup.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/m_t_CollinearMass")
        dyjetTPEdown.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/m_t_CollinearMass")
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/m_t_CollinearMass")
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/m_t_CollinearMass")
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/m_t_CollinearMass")
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

        dyall = DYall.Get("m_t_CollinearMass")
        dytfakes = DYtfakes.Get("m_t_CollinearMass")
        dymfakes = DYmfakes.Get("m_t_CollinearMass")
        dymtfakes = DYmtfakes.Get("m_t_CollinearMass")
        dytfakesup = DYtfakes.Get("TauFakeUp/m_t_CollinearMass") 
        dytfakesdown = DYtfakes.Get("TauFakeDown/m_t_CollinearMass")
        dymfakesup = DYmfakes.Get("MuonFakeUp/m_t_CollinearMass")
        dymfakesdown = DYmfakes.Get("MuonFakeDown/m_t_CollinearMass")
        dymttfakesup = DYmtfakes.Get("TauFakeUp/m_t_CollinearMass")
        dymttfakesdown = DYmtfakes.Get("TauFakeDown/m_t_CollinearMass")
        dymtmfakesup = DYmtfakes.Get("MuonFakeUp/m_t_CollinearMass")
        dymtmfakesdown = DYmtfakes.Get("MuonFakeDown/m_t_CollinearMass")
        dy1 = dyall.Clone()
        dy1t = dytfakesup.Clone()
        dy1t.add(dymfakes)
        dy1t.add(dymttfakesup, -1)
        dy1t = positivize(dy1t)
        dy1.add(dy1t, -1)
        dy1 = positivize(dy1)
        dy1.SetName(b[i]+"_CMS_TauFakeRate_13TeVUp")
        dy2 = dyall.Clone()
        dy2t = dytfakesdown.Clone()
        dy2t.add(dymfakes)
        dy2t.add(dymttfakesdown, -1)
        dy2t = positivize(dy2t)
        dy2.add(dy2t, -1)
        dy2 = positivize(dy2)
        dy2.SetName(b[i]+"_CMS_TauFakeRate_13TeVDown")
        dy3 = dyall.Clone()
        dy3t = dytfakes.Clone()
        dy3t.add(dymfakesup)
        dy3t.add(dymtmfakesup, -1)
        dy3t = positivize(dy3t)
        dy3.add(dy3t, -1)
        dy3 = positivize(dy3)
        dy3.SetName(b[i]+"_CMS_MuonFakeRate_13TeVUp")
        dy4 = dyall.Clone()
        dy4t = dytfakes.Clone()
        dy4t.add(dymfakesdown)
        dy4t.add(dymtmfakesdown, -1)
        dy4t = positivize(dy4t)
        dy4.add(dy4t, -1)
        dy4 = positivize(dy4)
        dy4.SetName(b[i]+"_CMS_MuonFakeRate_13TeVDown")
        dyall.Delete()
        dy1t.Delete()
        dy2t.Delete()
        dy3t.Delete()
        dy4t.Delete()
        dytfakes.Delete()
        dymfakes.Delete()
        dymtfakes.Delete()
        dytfakesup.Delete()
        dytfakesdown.Delete()
        dymfakesup.Delete()
        dymfakesdown.Delete()
        dymttfakesup.Delete()
        dymttfakesdown.Delete()
        dymtmfakesup.Delete()
        dymtmfakesdown.Delete()
        if i==1:
            data.Delete()
            qcd.Delete()
            f1.Delete()
            f2.Delete()
            f3.Delete()
            f4.Delete()
        f.Write()
