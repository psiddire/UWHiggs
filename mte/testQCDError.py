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

mc_samples = ['MC*', 'QCD*', 'data*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*']

for x in mc_samples:
    files.extend(glob.glob('results/%s/AnalyzeMuESys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'plots/%s/AnalyzeMuESys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
QCDData = views.SubdirectoryView(data_view, 'TightSS0Jet')
QCDMC = views.SubdirectoryView(mc_view, 'TightSS0Jet')
QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
qcddata = QCDData.Get("m_e_CollinearMass") 
qcdmc = QCDMC.Get("m_e_CollinearMass")
qcd = QCD.Get("m_e_CollinearMass")

#print "N Bins: ", qcd.GetNbinsX()
#for i in range(1, qcd.GetNbinsX()+1):
#    qcd.SetBinError(i, math.sqrt(qcd.GetBinContent(i))) 

#for i in range(1, qcd.GetNbinsX()+1):
#    print "My Content: ", qcd.GetBinContent(i) 
#    print "My Error: ", qcd.GetBinError(i)


Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') or x.startswith('WJets') , mc_samples)])
W = views.SubdirectoryView(Wtotal, 'TightOS1Jet')                                                                                                                                                                                                                  
w = W.Get("m_e_CollinearMass")

a = []

for i in range(1, w.GetNbinsX()+1):                                                                                                                                                                                                                                      
#    print "My Content: ", w.GetBinContent(i)
#    print "Sum W2N: ", w.GetSumw2N() 
    a.append(w.GetBinError(i))

w.Sumw2(0)                                                                                                                                                                                                                                   
w.SetBinErrorOption(1) 
w.Sumw2(1) 

for i in range(1, w.GetNbinsX()+1):                                                                                                                                                                                                                                        
    print "Content: ", w.GetBinContent(i)
    print "Error Low: ", w.GetBinErrorLow(i)
    print "Error Up: ", w.GetBinErrorUp(i)
    print "Error: ", w.GetBinError(i) 
    print "Old Error: ", a[i-1]
    print "Sum W2N: ", w.GetSumw2N()
