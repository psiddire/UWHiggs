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

def poisson_error(h):
    h.Sumw2(0)                                                                                                                                                                                                                                                           
    h.SetBinErrorOption(1)                                                                                                                                                                                                                                               
    h.Sumw2(1)
    return h

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuESysHTTJes/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuESys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'shapesMuEJes.root', 'RECREATE')

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
    
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = QCD.Get("m_e_CollinearMass")
    #qcd = poisson_error(qcd)
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

        dyjet03up = DY.Get("JetEta0to3Up/m_e_CollinearMass")
        dyjet03up.SetName(b[i]+"_CMS_Jes_JetEta0to3_13TeVUp")
        dyjet03down = DY.Get("JetEta0to3Down/m_e_CollinearMass")
        dyjet03down.SetName(b[i]+"_CMS_Jes_JetEta0to3_13TeVDown")
        dyjet05up = DY.Get("JetEta0to5Up/m_e_CollinearMass")
        dyjet05up.SetName(b[i]+"_CMS_Jes_JetEta0to5_13TeVUp")
        dyjet05down = DY.Get("JetEta0to5Down/m_e_CollinearMass")
        dyjet05down.SetName(b[i]+"_CMS_Jes_JetEta0to5_13TeVDown")
        dyjet35up = DY.Get("JetEta3to5Up/m_e_CollinearMass")
        dyjet35up.SetName(b[i]+"_CMS_Jes_JetEta3to5_13TeVUp")
        dyjet35down = DY.Get("JetEta3to5Down/m_e_CollinearMass")
        dyjet35down.SetName(b[i]+"_CMS_Jes_JetEta3to5_13TeVDown")
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
