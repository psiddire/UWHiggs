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

mc_samples = ['VBF_LFV*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuTauSysBDT/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuTauSysBDT/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesLFVBDT.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'LFV' in x , mc_samples)])]

b = ['LFV125']

for di in dirs:
    d = f.mkdir(di)
    d.cd()

    for i in range(len(v)):
        DYtotal = v[i]
        DYall = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseOS'+di)
        DYmfakes = views.SubdirectoryView(DYtotal, 'MuonLooseOS'+di)
        DYmtfakes = views.SubdirectoryView(DYtotal, 'MuonLooseTauLooseOS'+di)
        DYmt = views.SumView(DYtfakes, DYmfakes)
        DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
        DY = SubtractionView(DYall, DYfakes, restrict_positive=True)
        dy = DY.Get("bdtDiscriminator")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/bdtDiscriminator")
        dypuup.SetName(b[i]+"_PU_UncertaintyUp")
        dypudown = DY.Get("puDown/bdtDiscriminator")
        dypudown.SetName(b[i]+"_PU_UncertaintyDown")

        dytrup = DY.Get("trUp/bdtDiscriminator")
        dytrup.SetName(b[i]+"_Trigger_UncertaintyUp")
        dytrdown = DY.Get("trDown/bdtDiscriminator")
        dytrdown.SetName(b[i]+"_Trigger_UncertaintyDown")

        dyptup = DY.Get("DYptreweightUp/bdtDiscriminator")
        dyptup.SetName(b[i]+"_pTreweight_UncertaintyUp")
        dyptdown = DY.Get("DYptreweightDown/bdtDiscriminator")
        dyptdown.SetName(b[i]+"_pTreweight_UncertaintyDown")

        dymtfakeup = DY.Get("mtfakeUp/bdtDiscriminator")
        dymtfakeup.SetName(b[i]+"_mtfake_UncertaintyUp")
        dymtfakedown = DY.Get("mtfakeDown/bdtDiscriminator")
        dymtfakedown.SetName(b[i]+"_mtfake_UncertaintyDown")

        dyetfakeup = DY.Get("etfakeUp/bdtDiscriminator")
        dyetfakeup.SetName(b[i]+"_etfake_UncertaintyUp")
        dyetfakedown = DY.Get("etfakeDown/bdtDiscriminator")
        dyetfakedown.SetName(b[i]+"_etfake_UncertaintyDown")

        dyetefakeup = DY.Get("etefakeUp/bdtDiscriminator")
        dyetefakeup.SetName(b[i]+"_etefake_UncertaintyUp")
        dyetefakedown = DY.Get("etefakeDown/bdtDiscriminator")
        dyetefakedown.SetName(b[i]+"_etefake_UncertaintyDown")

        dytes0up = DY.Get("scaletDM0Up/bdtDiscriminator")
        dytes0up.SetName(b[i]+"_TESDM0Up")
        dytes0down = DY.Get("scaletDM0Down/bdtDiscriminator")
        dytes0down.SetName(b[i]+"_TESDM0Down")
        dytes1up = DY.Get("scaletDM1Up/bdtDiscriminator")
        dytes1up.SetName(b[i]+"_TESDM1Up")
        dytes1down = DY.Get("scaletDM1Down/bdtDiscriminator")
        dytes1down.SetName(b[i]+"_TESDM1Down")
        dytes10up = DY.Get("scaletDM10Up/bdtDiscriminator")
        dytes10up.SetName(b[i]+"_TESDM10Up")
        dytes10down = DY.Get("scaletDM10Down/bdtDiscriminator")
        dytes10down.SetName(b[i]+"_TESDM10Down")

        dymesup = DY.Get("mesUp/bdtDiscriminator")
        dymesup.SetName(b[i]+"_MESUp")
        dymesdown = DY.Get("mesDown/bdtDiscriminator")
        dymesdown.SetName(b[i]+"_MESDown")

        dyuesup = DY.Get("UnclusteredEnUp/bdtDiscriminator")
        dyuesup.SetName(b[i]+"_UnclusteredEnUp")
        dyuesdown = DY.Get("UnclusteredEnDown/bdtDiscriminator")
        dyuesdown.SetName(b[i]+"_UnclusteredEnDown")

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/bdtDiscriminator")
        dyjetAFMup.SetName(b[i]+"_AbsoluteFlavMapUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/bdtDiscriminator")
        dyjetAFMdown.SetName(b[i]+"_AbsoluteFlavMapDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/bdtDiscriminator")
        dyjetAMPFBup.SetName(b[i]+"_AbsoluteMPFBiasUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/bdtDiscriminator")
        dyjetAMPFBdown.SetName(b[i]+"_AbsoluteMPFBiasDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/bdtDiscriminator")
        dyjetASup.SetName(b[i]+"_JetAbsoluteScaleUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/bdtDiscriminator")
        dyjetASdown.SetName(b[i]+"_JetAbsoluteScaleDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/bdtDiscriminator")
        dyjetAStup.SetName(b[i]+"_JetAbsoluteStatUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/bdtDiscriminator")
        dyjetAStdown.SetName(b[i]+"_JetAbsoluteStatDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/bdtDiscriminator")
        dyjetFQCDup.SetName(b[i]+"_JetFlavorQCDUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/bdtDiscriminator")
        dyjetFQCDdown.SetName(b[i]+"_JetFlavorQCDDown")
        dyjetFup = DY.Get("JetFragmentationUp/bdtDiscriminator")
        dyjetFup.SetName(b[i]+"_JetFragmentationUp")
        dyjetFdown = DY.Get("JetFragmentationDown/bdtDiscriminator")
        dyjetFdown.SetName(b[i]+"_JetFragmentationDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/bdtDiscriminator")
        dyjetPUDMCup.SetName(b[i]+"_JetPileUpDataMCUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/bdtDiscriminator")
        dyjetPUDMCdown.SetName(b[i]+"_JetPileUpDataMCDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/bdtDiscriminator")
        dyjetPUPBBup.SetName(b[i]+"_JetPileUpPtBBUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/bdtDiscriminator")
        dyjetPUPBBdown.SetName(b[i]+"_JetPileUpPtBBDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/bdtDiscriminator")
        dyjetPUPEC1up.SetName(b[i]+"_JetPileUpPtEC1Up")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/bdtDiscriminator")
        dyjetPUPEC1down.SetName(b[i]+"_JetPileUpPtEC1Down")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/bdtDiscriminator")
        dyjetPUPEC2up.SetName(b[i]+"_JetPileUpPtEC2Up")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/bdtDiscriminator")
        dyjetPUPEC2down.SetName(b[i]+"_JetPileUpPtEC2Down")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/bdtDiscriminator")
        dyjetPUPHFup.SetName(b[i]+"_JetPileUpPtHFUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/bdtDiscriminator")
        dyjetPUPHFdown.SetName(b[i]+"_JetPileUpPtHFDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/bdtDiscriminator")
        dyjetPUPRup.SetName(b[i]+"_JetPileUpPtRefUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/bdtDiscriminator")
        dyjetPUPRdown.SetName(b[i]+"_JetPileUpPtRefDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/bdtDiscriminator")
        dyjetRFSRup.SetName(b[i]+"_JetRelativeFSRUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/bdtDiscriminator")
        dyjetRFSRdown.SetName(b[i]+"_JetRelativeFSRDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/bdtDiscriminator")
        dyjetRJEREC1up.SetName(b[i]+"_JetRelativeJEREC1Up")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/bdtDiscriminator")
        dyjetRJEREC1down.SetName(b[i]+"_JetRelativeJEREC1Down")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/bdtDiscriminator")
        dyjetRJEREC2up.SetName(b[i]+"_JetRelativeJEREC2Up")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/bdtDiscriminator")
        dyjetRJEREC2down.SetName(b[i]+"_JetRelativeJEREC2Down")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/bdtDiscriminator")
        dyjetRJERHFup.SetName(b[i]+"_JetRelativeJERHFUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/bdtDiscriminator")
        dyjetRJERHFdown.SetName(b[i]+"_JetRelativeJERHFDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/bdtDiscriminator")
        dyjetRPBBup.SetName(b[i]+"_JetRelativePtBBUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/bdtDiscriminator")
        dyjetRPBBdown.SetName(b[i]+"_JetRelativePtBBDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/bdtDiscriminator")
        dyjetRPEC1up.SetName(b[i]+"_JetRelativePtEC1Up")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/bdtDiscriminator")
        dyjetRPEC1down.SetName(b[i]+"_JetRelativePtEC1Down")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/bdtDiscriminator")
        dyjetRPEC2up.SetName(b[i]+"_JetRelativePtEC2Up")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/bdtDiscriminator")
        dyjetRPEC2down.SetName(b[i]+"_JetRelativePtEC2Down")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/bdtDiscriminator")
        dyjetRPHFup.SetName(b[i]+"_JetRelativePtHFUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/bdtDiscriminator")
        dyjetRPHFdown.SetName(b[i]+"_JetRelativePtHFDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/bdtDiscriminator")
        dyjetRSECup.SetName(b[i]+"_JetRelativeStatECUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/bdtDiscriminator")
        dyjetRSECdown.SetName(b[i]+"_JetRelativeStatECDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/bdtDiscriminator")
        dyjetRSFSRup.SetName(b[i]+"_JetRelativeStatFSRUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/bdtDiscriminator")
        dyjetRSFSRdown.SetName(b[i]+"_JetRelativeStatFSRDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/bdtDiscriminator")
        dyjetRSHFup.SetName(b[i]+"_JetRelativeStatHFUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/bdtDiscriminator")
        dyjetRSHFdown.SetName(b[i]+"_JetRelativeStatHFDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/bdtDiscriminator")
        dyjetSPEup.SetName(b[i]+"_JetSinglePionECALUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/bdtDiscriminator")
        dyjetSPEdown.SetName(b[i]+"_JetSinglePionECALDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/bdtDiscriminator")
        dyjetSPHup.SetName(b[i]+"_JetSinglePionHCALUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/bdtDiscriminator")
        dyjetSPHdown.SetName(b[i]+"_JetSinglePionHCALDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/bdtDiscriminator")
        dyjetTPEup.SetName(b[i]+"_JetTimePtEtaUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/bdtDiscriminator")
        dyjetTPEdown.SetName(b[i]+"_JetTimePtEtaDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/bdtDiscriminator")
        dyjetRBup.SetName(b[i]+"_JetRelativeBalUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/bdtDiscriminator")
        dyjetRBdown.SetName(b[i]+"_JetRelativeBalDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/bdtDiscriminator")
        dyjetRSup.SetName(b[i]+"_JetRelativeSampleUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/bdtDiscriminator")
        dyjetRSdown.SetName(b[i]+"_JetRelativeSampleDown")

        dyall = DYall.Get("bdtDiscriminator")
        dytfakes = DYtfakes.Get("bdtDiscriminator")
        dymfakes = DYmfakes.Get("bdtDiscriminator")
        dymtfakes = DYmtfakes.Get("bdtDiscriminator")
        dytfakesup = DYtfakes.Get("TauFakeUp/bdtDiscriminator") 
        dytfakesdown = DYtfakes.Get("TauFakeDown/bdtDiscriminator")
        dymfakesup = DYmfakes.Get("MuonFakeUp/bdtDiscriminator")
        dymfakesdown = DYmfakes.Get("MuonFakeDown/bdtDiscriminator")
        dymttfakesup = DYmtfakes.Get("TauFakeUp/bdtDiscriminator")
        dymttfakesdown = DYmtfakes.Get("TauFakeDown/bdtDiscriminator")
        dymtmfakesup = DYmtfakes.Get("MuonFakeUp/bdtDiscriminator")
        dymtmfakesdown = DYmtfakes.Get("MuonFakeDown/bdtDiscriminator")
        dy1 = dyall.Clone()
        dy1t = dytfakesup.Clone()
        dy1t.add(dymfakes)
        dy1t.add(dymttfakesup, -1)
        dy1t = positivize(dy1t)
        dy1.add(dy1t, -1)
        dy1 = positivize(dy1)
        dy1.SetName(b[i]+"_TauFakesUp")
        dy2 = dyall.Clone()
        dy2t = dytfakesdown.Clone()
        dy2t.add(dymfakes)
        dy2t.add(dymttfakesdown, -1)
        dy2t = positivize(dy2t)
        dy2.add(dy2t, -1)
        dy2 = positivize(dy2)
        dy2.SetName(b[i]+"_TauFakesDown")
        dy3 = dyall.Clone()
        dy3t = dytfakes.Clone()
        dy3t.add(dymfakesup)
        dy3t.add(dymtmfakesup, -1)
        dy3t = positivize(dy3t)
        dy3.add(dy3t, -1)
        dy3 = positivize(dy3)
        dy3.SetName(b[i]+"_MuonFakesUp")
        dy4 = dyall.Clone()
        dy4t = dytfakes.Clone()
        dy4t.add(dymfakesdown)
        dy4t.add(dymtmfakesdown, -1)
        dy4t = positivize(dy4t)
        dy4.add(dy4t, -1)
        dy4 = positivize(dy4)
        dy4.SetName(b[i]+"_MuonFakesDown")
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
        f.Write()
