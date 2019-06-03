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

def normQcd(histogram, i, category):                                                                                                                                                                                                                                      
    qcd = histogram.Clone()                                                                                                                                                                                                                                               
    if category=='0Jet':                                                                                                                                                                                                                                                  
        qcd.Scale(6992.7/i)                                                                                                                                                                                                                                              
    elif category=='1Jet':                                                                                                                                                                                                                                                
        qcd.Scale(2747.62/i)                                                                                                                                                                                                                                              
    elif category=='2Jet':                                                                                                                                                                                                                                                
        qcd.Scale(976.408/i)                                                                                                                                                                                                                                              
    elif category=='2JetVBF':                                                                                                                                                                                                                                             
        qcd.Scale(143.801/i)                                                                                                                                                                                                                                              
    return qcd

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*',  'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*', 'Obs*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuESysBDT/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuESysBDT/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapes/shapesMuEBDT.root', 'RECREATE')

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DYJetsToLL_M-50') or x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WGToLNuG') , mc_samples)]),
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

b = ['Zll', 'W', 'WG', 'EWK', 'GluGluH', 'VBFH', 'VH', 'TT', 'ST', 'EWKDiboson', 'GluGlu125', 'VBF125']#'ttH', 

for di in dirs:

    d = f.mkdir(di)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Obs'), mc_samples)])
    DataAll = views.SubdirectoryView(DataTotal, 'TightOS'+di)
    DataAll = SubtractionView(DataAll, restrict_positive=True)
    data = positivize(DataAll.Get("bdtDiscriminator"))
    data.SetName('data_obs')
    
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = positivize(QCD.Get("bdtDiscriminator"))
    qcdi = qcd.Integral()
    qcd = normQcd(qcd, qcdi, di)
    qcd.SetName('QCD')

    #QCD Systematics
    qcdr0up = positivize(QCD.Get("Rate0JetUp/bdtDiscriminator"))
    qcdr0up = normQcd(qcdr0up, qcdi, di)
    qcdr0up.SetName('QCD_CMS_0JetRate_13TeVUp')
    qcdr0down = positivize(QCD.Get("Rate0JetDown/bdtDiscriminator"))
    qcdr0down = normQcd(qcdr0down, qcdi, di) 
    qcdr0down.SetName('QCD_CMS_0JetRate_13TeVDown')

    qcdr1up = positivize(QCD.Get("Rate1JetUp/bdtDiscriminator"))
    qcdr1up = normQcd(qcdr1up, qcdi, di)
    qcdr1up.SetName('QCD_CMS_1JetRate_13TeVUp')
    qcdr1down = positivize(QCD.Get("Rate1JetDown/bdtDiscriminator"))
    qcdr1down = normQcd(qcdr1down, qcdi, di)
    qcdr1down.SetName('QCD_CMS_1JetRate_13TeVDown')

    qcds0up = positivize(QCD.Get("Shape0JetUp/bdtDiscriminator"))
    qcds0up = normQcd(qcds0up, qcdi, di) 
    qcds0up.SetName('QCD_CMS_0JetShape_13TeVUp')
    qcds0down = positivize(QCD.Get("Shape0JetDown/bdtDiscriminator"))
    qcds0down = normQcd(qcds0down, qcdi, di) 
    qcds0down.SetName('QCD_CMS_0JetShape_13TeVDown')

    qcds1up = positivize(QCD.Get("Shape1JetUp/bdtDiscriminator"))
    qcds1up = normQcd(qcds1up, qcdi, di)
    qcds1up.SetName('QCD_CMS_1JetShape_13TeVUp')
    qcds1down = positivize(QCD.Get("Shape1JetDown/bdtDiscriminator"))
    qcds1down = normQcd(qcds1down, qcdi, di)
    qcds1down.SetName('QCD_CMS_1JetShape_13TeVDown')

    qcdiup = positivize(QCD.Get("IsoUp/bdtDiscriminator"))
    qcdiup = normQcd(qcdiup, qcdi, di)
    qcdiup.SetName('QCD_CMS_Extrapolation_13TeVUp')
    qcdidown = positivize(QCD.Get("IsoDown/bdtDiscriminator"))
    qcdidown = normQcd(qcdidown, qcdi, di) 
    qcdidown.SetName('QCD_CMS_Extrapolation_13TeVDown')

    for i in range(12):
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        DY = SubtractionView(DY, restrict_positive=True) 
        dy = positivize(DY.Get("bdtDiscriminator"))
        dy.SetName(b[i])

        #Pileup
        dypuup = positivize(DY.Get("puUp/bdtDiscriminator"))
        dypuup.SetName(b[i]+"_CMS_Pileup_13TeVUp") 
        dypudown = positivize(DY.Get("puDown/bdtDiscriminator"))
        dypudown.SetName(b[i]+"_CMS_Pileup_13TeVDown")

        #Trigger 
        dytrup = positivize(DY.Get("trUp/bdtDiscriminator"))
        dytrup.SetName(b[i]+"_CMS_Trigger_13TeVUp")
        dytrdown = positivize(DY.Get("trDown/bdtDiscriminator"))
        dytrdown.SetName(b[i]+"_CMS_Trigger_13TeVDown")

        #Recoil Response
        dyrecrespup = positivize(DY.Get("recrespUp/bdtDiscriminator"))
        dyrecrespup.SetName(b[i]+"_CMS_RecoilResponse_13TeVUp")
        dyrecrespdown = positivize(DY.Get("recrespDown/bdtDiscriminator"))
        dyrecrespdown.SetName(b[i]+"_CMS_RecoilResponse_13TeVDown")

        #Recoil Resolution
        dyrecresoup = positivize(DY.Get("recresoUp/bdtDiscriminator"))
        dyrecresoup.SetName(b[i]+"_CMS_RecoilResolution_13TeVUp")
        dyrecresodown = positivize(DY.Get("recresoDown/bdtDiscriminator"))
        dyrecresodown.SetName(b[i]+"_CMS_RecoilResolution_13TeVDown")

        #DY Pt Reweighting
        dyptup = positivize(DY.Get("DYptreweightUp/bdtDiscriminator"))
        dyptup.SetName(b[i]+"_CMS_DYpTreweight_13TeVUp")
        dyptdown = positivize(DY.Get("DYptreweightDown/bdtDiscriminator"))
        dyptdown.SetName(b[i]+"_CMS_DYpTreweight_13TeVDown")

        #Top Pt Reweighting
        dyttptup = positivize(DY.Get("TopptreweightUp/bdtDiscriminator"))
        dyttptup.SetName(b[i]+"_CMS_TTpTreweight_13TeVUp")
        dyttptdown = positivize(DY.Get("TopptreweightDown/bdtDiscriminator"))
        dyttptdown.SetName(b[i]+"_CMS_TTpTreweight_13TeVDown")

        #B-Tag 
        dybtagup = positivize(DY.Get("bTagUp/bdtDiscriminator"))
        dybtagup.SetName(b[i]+"_CMS_eff_btag_13TeVUp")
        dybtagdown = positivize(DY.Get("bTagDown/bdtDiscriminator"))
        dybtagdown.SetName(b[i]+"_CMS_eff_btag_13TeVDown")

        #Electron Energy Scale
        dyeescup = positivize(DY.Get("eescUp/bdtDiscriminator"))
        dyeescup.SetName(b[i]+"_CMS_EEScale_13TeVUp")
        dyeescdown = positivize(DY.Get("eescDown/bdtDiscriminator"))
        dyeescdown.SetName(b[i]+"_CMS_EEScale_13TeVDown")

        #Electron Energy Sigma
        dyeesiup = positivize(DY.Get("eesiUp/bdtDiscriminator"))
        dyeesiup.SetName(b[i]+"_CMS_EESigma_13TeVUp")
        dyeesidown = positivize(DY.Get("eesiDown/bdtDiscriminator"))
        dyeesidown.SetName(b[i]+"_CMS_EESigma_13TeVDown")

        #Muon Energy Scale
        dymesup = positivize(DY.Get("mesUp/bdtDiscriminator"))
        dymesup.SetName(b[i]+"_CMS_MES_13TeVUp")
        dymesdown = positivize(DY.Get("mesDown/bdtDiscriminator"))
        dymesdown.SetName(b[i]+"_CMS_MES_13TeVDown")

        #Unclustered Energy Scale 
        dyuesup = positivize(DY.Get("UnclusteredEnUp/bdtDiscriminator"))
        dyuesup.SetName(b[i]+"_CMS_MET_Ues_13TeVUp")
        dyuesdown = positivize(DY.Get("UnclusteredEnDown/bdtDiscriminator"))
        dyuesdown.SetName(b[i]+"_CMS_MET_Ues_13TeVDown")

        #Jet Energy Scale
        dyjetAFMup = positivize(DY.Get("JetAbsoluteFlavMapUp/bdtDiscriminator"))
        dyjetAFMup.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVUp")
        dyjetAFMdown = positivize(DY.Get("JetAbsoluteFlavMapDown/bdtDiscriminator"))
        dyjetAFMdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteFlavMap_13TeVDown")

        dyjetAMPFBup = positivize(DY.Get("JetAbsoluteMPFBiasUp/bdtDiscriminator"))
        dyjetAMPFBup.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVUp")
        dyjetAMPFBdown = positivize(DY.Get("JetAbsoluteMPFBiasDown/bdtDiscriminator"))
        dyjetAMPFBdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteMPFBias_13TeVDown")

        dyjetASup = positivize(DY.Get("JetAbsoluteScaleUp/bdtDiscriminator"))
        dyjetASup.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVUp")
        dyjetASdown = positivize(DY.Get("JetAbsoluteScaleDown/bdtDiscriminator"))
        dyjetASdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteScale_13TeVDown")

        dyjetAStup = positivize(DY.Get("JetAbsoluteStatUp/bdtDiscriminator"))
        dyjetAStup.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVUp")
        dyjetAStdown = positivize(DY.Get("JetAbsoluteStatDown/bdtDiscriminator"))
        dyjetAStdown.SetName(b[i]+"_CMS_Jes_JetAbsoluteStat_13TeVDown")

        dyjetFQCDup = positivize(DY.Get("JetFlavorQCDUp/bdtDiscriminator"))
        dyjetFQCDup.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVUp")
        dyjetFQCDdown = positivize(DY.Get("JetFlavorQCDDown/bdtDiscriminator"))
        dyjetFQCDdown.SetName(b[i]+"_CMS_Jes_JetFlavorQCD_13TeVDown")

        dyjetFup = positivize(DY.Get("JetFragmentationUp/bdtDiscriminator"))
        dyjetFup.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVUp")
        dyjetFdown = positivize(DY.Get("JetFragmentationDown/bdtDiscriminator"))
        dyjetFdown.SetName(b[i]+"_CMS_Jes_JetFragmentation_13TeVDown")

        dyjetPUDMCup = positivize(DY.Get("JetPileUpDataMCUp/bdtDiscriminator"))
        dyjetPUDMCup.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVUp")
        dyjetPUDMCdown = positivize(DY.Get("JetPileUpDataMCDown/bdtDiscriminator"))
        dyjetPUDMCdown.SetName(b[i]+"_CMS_Jes_JetPileUpDataMC_13TeVDown")

        dyjetPUPBBup = positivize(DY.Get("JetPileUpPtBBUp/bdtDiscriminator"))
        dyjetPUPBBup.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVUp")
        dyjetPUPBBdown = positivize(DY.Get("JetPileUpPtBBDown/bdtDiscriminator"))
        dyjetPUPBBdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtBB_13TeVDown")

        dyjetPUPEC1up = positivize(DY.Get("JetPileUpPtEC1Up/bdtDiscriminator"))
        dyjetPUPEC1up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVUp")
        dyjetPUPEC1down = positivize(DY.Get("JetPileUpPtEC1Down/bdtDiscriminator"))
        dyjetPUPEC1down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC1_13TeVDown")

        dyjetPUPEC2up = positivize(DY.Get("JetPileUpPtEC2Up/bdtDiscriminator"))
        dyjetPUPEC2up.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVUp")
        dyjetPUPEC2down = positivize(DY.Get("JetPileUpPtEC2Down/bdtDiscriminator"))
        dyjetPUPEC2down.SetName(b[i]+"_CMS_Jes_JetPileUpPtEC2_13TeVDown")

        dyjetPUPHFup = positivize(DY.Get("JetPileUpPtHFUp/bdtDiscriminator"))
        dyjetPUPHFup.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVUp")
        dyjetPUPHFdown = positivize(DY.Get("JetPileUpPtHFDown/bdtDiscriminator"))
        dyjetPUPHFdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtHF_13TeVDown")

        dyjetPUPRup = positivize(DY.Get("JetPileUpPtRefUp/bdtDiscriminator"))
        dyjetPUPRup.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVUp")
        dyjetPUPRdown = positivize(DY.Get("JetPileUpPtRefDown/bdtDiscriminator"))
        dyjetPUPRdown.SetName(b[i]+"_CMS_Jes_JetPileUpPtRef_13TeVDown")

        dyjetRFSRup = positivize(DY.Get("JetRelativeFSRUp/bdtDiscriminator"))
        dyjetRFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVUp")
        dyjetRFSRdown = positivize(DY.Get("JetRelativeFSRDown/bdtDiscriminator"))
        dyjetRFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeFSR_13TeVDown")

        dyjetRJEREC1up = positivize(DY.Get("JetRelativeJEREC1Up/bdtDiscriminator"))
        dyjetRJEREC1up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVUp")
        dyjetRJEREC1down = positivize(DY.Get("JetRelativeJEREC1Down/bdtDiscriminator"))
        dyjetRJEREC1down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC1_13TeVDown")

        dyjetRJEREC2up = positivize(DY.Get("JetRelativeJEREC2Up/bdtDiscriminator"))
        dyjetRJEREC2up.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVUp")
        dyjetRJEREC2down = positivize(DY.Get("JetRelativeJEREC2Down/bdtDiscriminator"))
        dyjetRJEREC2down.SetName(b[i]+"_CMS_Jes_JetRelativeJEREC2_13TeVDown")

        dyjetRJERHFup = positivize(DY.Get("JetRelativeJERHFUp/bdtDiscriminator"))
        dyjetRJERHFup.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVUp")
        dyjetRJERHFdown = positivize(DY.Get("JetRelativeJERHFDown/bdtDiscriminator"))
        dyjetRJERHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeJERHF_13TeVDown")

        dyjetRPBBup = positivize(DY.Get("JetRelativePtBBUp/bdtDiscriminator"))
        dyjetRPBBup.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVUp")
        dyjetRPBBdown = positivize(DY.Get("JetRelativePtBBDown/bdtDiscriminator"))
        dyjetRPBBdown.SetName(b[i]+"_CMS_Jes_JetRelativePtBB_13TeVDown")

        dyjetRPEC1up = positivize(DY.Get("JetRelativePtEC1Up/bdtDiscriminator"))
        dyjetRPEC1up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVUp")
        dyjetRPEC1down = positivize(DY.Get("JetRelativePtEC1Down/bdtDiscriminator"))
        dyjetRPEC1down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC1_13TeVDown")

        dyjetRPEC2up = positivize(DY.Get("JetRelativePtEC2Up/bdtDiscriminator"))
        dyjetRPEC2up.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVUp")
        dyjetRPEC2down = positivize(DY.Get("JetRelativePtEC2Down/bdtDiscriminator"))
        dyjetRPEC2down.SetName(b[i]+"_CMS_Jes_JetRelativePtEC2_13TeVDown")

        dyjetRPHFup = positivize(DY.Get("JetRelativePtHFUp/bdtDiscriminator"))
        dyjetRPHFup.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVUp")
        dyjetRPHFdown = positivize(DY.Get("JetRelativePtHFDown/bdtDiscriminator"))
        dyjetRPHFdown.SetName(b[i]+"_CMS_Jes_JetRelativePtHF_13TeVDown")

        dyjetRSECup = positivize(DY.Get("JetRelativeStatECUp/bdtDiscriminator"))
        dyjetRSECup.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVUp")
        dyjetRSECdown = positivize(DY.Get("JetRelativeStatECDown/bdtDiscriminator"))
        dyjetRSECdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatEC_13TeVDown")

        dyjetRSFSRup = positivize(DY.Get("JetRelativeStatFSRUp/bdtDiscriminator"))
        dyjetRSFSRup.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVUp")
        dyjetRSFSRdown = positivize(DY.Get("JetRelativeStatFSRDown/bdtDiscriminator"))
        dyjetRSFSRdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatFSR_13TeVDown")

        dyjetRSHFup = positivize(DY.Get("JetRelativeStatHFUp/bdtDiscriminator"))
        dyjetRSHFup.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVUp")
        dyjetRSHFdown = positivize(DY.Get("JetRelativeStatHFDown/bdtDiscriminator"))
        dyjetRSHFdown.SetName(b[i]+"_CMS_Jes_JetRelativeStatHF_13TeVDown")

        dyjetSPEup = positivize(DY.Get("JetSinglePionECALUp/bdtDiscriminator"))
        dyjetSPEup.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVUp")
        dyjetSPEdown = positivize(DY.Get("JetSinglePionECALDown/bdtDiscriminator"))
        dyjetSPEdown.SetName(b[i]+"_CMS_Jes_JetSinglePionECAL_13TeVDown")

        dyjetSPHup = positivize(DY.Get("JetSinglePionHCALUp/bdtDiscriminator"))
        dyjetSPHup.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVUp")
        dyjetSPHdown = positivize(DY.Get("JetSinglePionHCALDown/bdtDiscriminator"))
        dyjetSPHdown.SetName(b[i]+"_CMS_Jes_JetSinglePionHCAL_13TeVDown")

        dyjetTPEup = positivize(DY.Get("JetTimePtEtaUp/bdtDiscriminator"))
        dyjetTPEup.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVUp")
        dyjetTPEdown = positivize(DY.Get("JetTimePtEtaDown/bdtDiscriminator"))
        dyjetTPEdown.SetName(b[i]+"_CMS_Jes_JetTimePtEta_13TeVDown")

        dyjetRBup = positivize(DY.Get("JetRelativeBalUp/bdtDiscriminator"))
        dyjetRBup.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVUp")
        dyjetRBdown = positivize(DY.Get("JetRelativeBalDown/bdtDiscriminator"))
        dyjetRBdown.SetName(b[i]+"_CMS_Jes_JetRelativeBal_13TeVDown")

        dyjetRSup = positivize(DY.Get("JetRelativeSampleUp/bdtDiscriminator"))
        dyjetRSup.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVUp")
        dyjetRSdown = positivize(DY.Get("JetRelativeSampleDown/bdtDiscriminator"))
        dyjetRSdown.SetName(b[i]+"_CMS_Jes_JetRelativeSample_13TeVDown")

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
