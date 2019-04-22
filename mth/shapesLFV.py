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
    files.extend(glob.glob('results/%s/AnalyzeMuTauSys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuTauSys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesLFV.root', 'RECREATE')

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
        dy = DY.Get("m_t_CollinearMass")
        dy.SetName(b[i])

        dypuup = DY.Get("puUp/m_t_CollinearMass")
        dypuup.SetName(b[i]+"_PU_UncertaintyUp")
        dypudown = DY.Get("puDown/m_t_CollinearMass")
        dypudown.SetName(b[i]+"_PU_UncertaintyDown")

        dytrup = DY.Get("trUp/m_t_CollinearMass")
        dytrup.SetName(b[i]+"_Trigger_UncertaintyUp")
        dytrdown = DY.Get("trDown/m_t_CollinearMass")
        dytrdown.SetName(b[i]+"_Trigger_UncertaintyDown")

        dyptup = DY.Get("DYptreweightUp/m_t_CollinearMass")
        dyptup.SetName(b[i]+"_pTreweight_UncertaintyUp")
        dyptdown = DY.Get("DYptreweightDown/m_t_CollinearMass")
        dyptdown.SetName(b[i]+"_pTreweight_UncertaintyDown")

        dymtfakeup = DY.Get("mtfakeUp/m_t_CollinearMass")
        dymtfakeup.SetName(b[i]+"_mtfake_UncertaintyUp")
        dymtfakedown = DY.Get("mtfakeDown/m_t_CollinearMass")
        dymtfakedown.SetName(b[i]+"_mtfake_UncertaintyDown")

        dyetfakeup = DY.Get("etfakeUp/m_t_CollinearMass")
        dyetfakeup.SetName(b[i]+"_etfake_UncertaintyUp")
        dyetfakedown = DY.Get("etfakeDown/m_t_CollinearMass")
        dyetfakedown.SetName(b[i]+"_etfake_UncertaintyDown")

        dyetefakeup = DY.Get("etefakeUp/m_t_CollinearMass")
        dyetefakeup.SetName(b[i]+"_etefake_UncertaintyUp")
        dyetefakedown = DY.Get("etefakeDown/m_t_CollinearMass")
        dyetefakedown.SetName(b[i]+"_etefake_UncertaintyDown")

        dytes0up = DY.Get("scaletDM0Up/m_t_CollinearMass")
        dytes0up.SetName(b[i]+"_TESDM0Up")
        dytes0down = DY.Get("scaletDM0Down/m_t_CollinearMass")
        dytes0down.SetName(b[i]+"_TESDM0Down")
        dytes1up = DY.Get("scaletDM1Up/m_t_CollinearMass")
        dytes1up.SetName(b[i]+"_TESDM1Up")
        dytes1down = DY.Get("scaletDM1Down/m_t_CollinearMass")
        dytes1down.SetName(b[i]+"_TESDM1Down")
        dytes10up = DY.Get("scaletDM10Up/m_t_CollinearMass")
        dytes10up.SetName(b[i]+"_TESDM10Up")
        dytes10down = DY.Get("scaletDM10Down/m_t_CollinearMass")
        dytes10down.SetName(b[i]+"_TESDM10Down")

        dymesup = DY.Get("mesUp/m_t_CollinearMass")
        dymesup.SetName(b[i]+"_MESUp")
        dymesdown = DY.Get("mesDown/m_t_CollinearMass")
        dymesdown.SetName(b[i]+"_MESDown")

        dyuesup = DY.Get("UnclusteredEnUp/m_t_CollinearMass")
        dyuesup.SetName(b[i]+"_UnclusteredEnUp")
        dyuesdown = DY.Get("UnclusteredEnDown/m_t_CollinearMass")
        dyuesdown.SetName(b[i]+"_UnclusteredEnDown")

        dyjetAFMup = DY.Get("AbsoluteFlavMapUp/m_t_CollinearMass")
        dyjetAFMup.SetName(b[i]+"_AbsoluteFlavMapUp")
        dyjetAFMdown = DY.Get("AbsoluteFlavMapDown/m_t_CollinearMass")
        dyjetAFMdown.SetName(b[i]+"_AbsoluteFlavMapDown")
        dyjetAMPFBup = DY.Get("AbsoluteMPFBiasUp/m_t_CollinearMass")
        dyjetAMPFBup.SetName(b[i]+"_AbsoluteMPFBiasUp")
        dyjetAMPFBdown = DY.Get("AbsoluteMPFBiasDown/m_t_CollinearMass")
        dyjetAMPFBdown.SetName(b[i]+"_AbsoluteMPFBiasDown")
        dyjetASup = DY.Get("JetAbsoluteScaleUp/m_t_CollinearMass")
        dyjetASup.SetName(b[i]+"_JetAbsoluteScaleUp")
        dyjetASdown = DY.Get("JetAbsoluteScaleDown/m_t_CollinearMass")
        dyjetASdown.SetName(b[i]+"_JetAbsoluteScaleDown")
        dyjetAStup = DY.Get("JetAbsoluteStatUp/m_t_CollinearMass")
        dyjetAStup.SetName(b[i]+"_JetAbsoluteStatUp")
        dyjetAStdown = DY.Get("JetAbsoluteStatDown/m_t_CollinearMass")
        dyjetAStdown.SetName(b[i]+"_JetAbsoluteStatDown")
        dyjetFQCDup = DY.Get("JetFlavorQCDUp/m_t_CollinearMass")
        dyjetFQCDup.SetName(b[i]+"_JetFlavorQCDUp")
        dyjetFQCDdown = DY.Get("JetFlavorQCDDown/m_t_CollinearMass")
        dyjetFQCDdown.SetName(b[i]+"_JetFlavorQCDDown")
        dyjetFup = DY.Get("JetFragmentationUp/m_t_CollinearMass")
        dyjetFup.SetName(b[i]+"_JetFragmentationUp")
        dyjetFdown = DY.Get("JetFragmentationDown/m_t_CollinearMass")
        dyjetFdown.SetName(b[i]+"_JetFragmentationDown")
        dyjetPUDMCup = DY.Get("JetPileUpDataMCUp/m_t_CollinearMass")
        dyjetPUDMCup.SetName(b[i]+"_JetPileUpDataMCUp")
        dyjetPUDMCdown = DY.Get("JetPileUpDataMCDown/m_t_CollinearMass")
        dyjetPUDMCdown.SetName(b[i]+"_JetPileUpDataMCDown")
        dyjetPUPBBup = DY.Get("JetPileUpPtBBUp/m_t_CollinearMass")
        dyjetPUPBBup.SetName(b[i]+"_JetPileUpPtBBUp")
        dyjetPUPBBdown = DY.Get("JetPileUpPtBBDown/m_t_CollinearMass")
        dyjetPUPBBdown.SetName(b[i]+"_JetPileUpPtBBDown")
        dyjetPUPEC1up = DY.Get("JetPileUpPtEC1Up/m_t_CollinearMass")
        dyjetPUPEC1up.SetName(b[i]+"_JetPileUpPtEC1Up")
        dyjetPUPEC1down = DY.Get("JetPileUpPtEC1Down/m_t_CollinearMass")
        dyjetPUPEC1down.SetName(b[i]+"_JetPileUpPtEC1Down")
        dyjetPUPEC2up = DY.Get("JetPileUpPtEC2Up/m_t_CollinearMass")
        dyjetPUPEC2up.SetName(b[i]+"_JetPileUpPtEC2Up")
        dyjetPUPEC2down = DY.Get("JetPileUpPtEC2Down/m_t_CollinearMass")
        dyjetPUPEC2down.SetName(b[i]+"_JetPileUpPtEC2Down")
        dyjetPUPHFup = DY.Get("JetPileUpPtHFUp/m_t_CollinearMass")
        dyjetPUPHFup.SetName(b[i]+"_JetPileUpPtHFUp")
        dyjetPUPHFdown = DY.Get("JetPileUpPtHFDown/m_t_CollinearMass")
        dyjetPUPHFdown.SetName(b[i]+"_JetPileUpPtHFDown")
        dyjetPUPRup = DY.Get("JetPileUpPtRefUp/m_t_CollinearMass")
        dyjetPUPRup.SetName(b[i]+"_JetPileUpPtRefUp")
        dyjetPUPRdown = DY.Get("JetPileUpPtRefDown/m_t_CollinearMass")
        dyjetPUPRdown.SetName(b[i]+"_JetPileUpPtRefDown")
        dyjetRFSRup = DY.Get("JetRelativeFSRUp/m_t_CollinearMass")
        dyjetRFSRup.SetName(b[i]+"_JetRelativeFSRUp")
        dyjetRFSRdown = DY.Get("JetRelativeFSRDown/m_t_CollinearMass")
        dyjetRFSRdown.SetName(b[i]+"_JetRelativeFSRDown")
        dyjetRJEREC1up = DY.Get("JetRelativeJEREC1Up/m_t_CollinearMass")
        dyjetRJEREC1up.SetName(b[i]+"_JetRelativeJEREC1Up")
        dyjetRJEREC1down = DY.Get("JetRelativeJEREC1Down/m_t_CollinearMass")
        dyjetRJEREC1down.SetName(b[i]+"_JetRelativeJEREC1Down")
        dyjetRJEREC2up = DY.Get("JetRelativeJEREC2Up/m_t_CollinearMass")
        dyjetRJEREC2up.SetName(b[i]+"_JetRelativeJEREC2Up")
        dyjetRJEREC2down = DY.Get("JetRelativeJEREC2Down/m_t_CollinearMass")
        dyjetRJEREC2down.SetName(b[i]+"_JetRelativeJEREC2Down")
        dyjetRJERHFup = DY.Get("JetRelativeJERHFUp/m_t_CollinearMass")
        dyjetRJERHFup.SetName(b[i]+"_JetRelativeJERHFUp")
        dyjetRJERHFdown = DY.Get("JetRelativeJERHFDown/m_t_CollinearMass")
        dyjetRJERHFdown.SetName(b[i]+"_JetRelativeJERHFDown")
        dyjetRPBBup = DY.Get("JetRelativePtBBUp/m_t_CollinearMass")
        dyjetRPBBup.SetName(b[i]+"_JetRelativePtBBUp")
        dyjetRPBBdown = DY.Get("JetRelativePtBBDown/m_t_CollinearMass")
        dyjetRPBBdown.SetName(b[i]+"_JetRelativePtBBDown")
        dyjetRPEC1up = DY.Get("JetRelativePtEC1Up/m_t_CollinearMass")
        dyjetRPEC1up.SetName(b[i]+"_JetRelativePtEC1Up")
        dyjetRPEC1down = DY.Get("JetRelativePtEC1Down/m_t_CollinearMass")
        dyjetRPEC1down.SetName(b[i]+"_JetRelativePtEC1Down")
        dyjetRPEC2up = DY.Get("JetRelativePtEC2Up/m_t_CollinearMass")
        dyjetRPEC2up.SetName(b[i]+"_JetRelativePtEC2Up")
        dyjetRPEC2down = DY.Get("JetRelativePtEC2Down/m_t_CollinearMass")
        dyjetRPEC2down.SetName(b[i]+"_JetRelativePtEC2Down")
        dyjetRPHFup = DY.Get("JetRelativePtHFUp/m_t_CollinearMass")
        dyjetRPHFup.SetName(b[i]+"_JetRelativePtHFUp")
        dyjetRPHFdown = DY.Get("JetRelativePtHFDown/m_t_CollinearMass")
        dyjetRPHFdown.SetName(b[i]+"_JetRelativePtHFDown")
        dyjetRSECup = DY.Get("JetRelativeStatECUp/m_t_CollinearMass")
        dyjetRSECup.SetName(b[i]+"_JetRelativeStatECUp")
        dyjetRSECdown = DY.Get("JetRelativeStatECDown/m_t_CollinearMass")
        dyjetRSECdown.SetName(b[i]+"_JetRelativeStatECDown")
        dyjetRSFSRup = DY.Get("JetRelativeStatFSRUp/m_t_CollinearMass")
        dyjetRSFSRup.SetName(b[i]+"_JetRelativeStatFSRUp")
        dyjetRSFSRdown = DY.Get("JetRelativeStatFSRDown/m_t_CollinearMass")
        dyjetRSFSRdown.SetName(b[i]+"_JetRelativeStatFSRDown")
        dyjetRSHFup = DY.Get("JetRelativeStatHFUp/m_t_CollinearMass")
        dyjetRSHFup.SetName(b[i]+"_JetRelativeStatHFUp")
        dyjetRSHFdown = DY.Get("JetRelativeStatHFDown/m_t_CollinearMass")
        dyjetRSHFdown.SetName(b[i]+"_JetRelativeStatHFDown")
        dyjetSPEup = DY.Get("JetSinglePionECALUp/m_t_CollinearMass")
        dyjetSPEup.SetName(b[i]+"_JetSinglePionECALUp")
        dyjetSPEdown = DY.Get("JetSinglePionECALDown/m_t_CollinearMass")
        dyjetSPEdown.SetName(b[i]+"_JetSinglePionECALDown")
        dyjetSPHup = DY.Get("JetSinglePionHCALUp/m_t_CollinearMass")
        dyjetSPHup.SetName(b[i]+"_JetSinglePionHCALUp")
        dyjetSPHdown = DY.Get("JetSinglePionHCALDown/m_t_CollinearMass")
        dyjetSPHdown.SetName(b[i]+"_JetSinglePionHCALDown")
        dyjetTPEup = DY.Get("JetTimePtEtaUp/m_t_CollinearMass")
        dyjetTPEup.SetName(b[i]+"_JetTimePtEtaUp")
        dyjetTPEdown = DY.Get("JetTimePtEtaDown/m_t_CollinearMass")
        dyjetTPEdown.SetName(b[i]+"_JetTimePtEtaDown")
        dyjetRBup = DY.Get("JetRelativeBalUp/m_t_CollinearMass")
        dyjetRBup.SetName(b[i]+"_JetRelativeBalUp")
        dyjetRBdown = DY.Get("JetRelativeBalDown/m_t_CollinearMass")
        dyjetRBdown.SetName(b[i]+"_JetRelativeBalDown")
        dyjetRSup = DY.Get("JetRelativeSampleUp/m_t_CollinearMass")
        dyjetRSup.SetName(b[i]+"_JetRelativeSampleUp")
        dyjetRSdown = DY.Get("JetRelativeSampleDown/m_t_CollinearMass")
        dyjetRSdown.SetName(b[i]+"_JetRelativeSampleDown")

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
