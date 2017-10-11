from BasePlotter import BasePlotter
import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.RebinView  import RebinView
from FinalStateAnalysis.MetaData.data_styles import data_styles, colors
from FinalStateAnalysis.PlotTools.decorators import memo
from optparse import OptionParser
import os
import ROOT
import glob
import math
import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.WARNING)
from fnmatch import fnmatch
from yellowhiggs import xs, br, xsbr
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs
from os import listdir
from os.path import isfile, join

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid


mc_samples = [
    'VBFHToTauTau_M125*'
]
files=[]
lumifiles=[]
channel = 'fromHiggs'
for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/LFVMuTauAnalyserGen/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/LFVMuTauAnalyserGen/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)
print outputdir
print files
print lumifiles    
plotter = BasePlotter(files, lumifiles, outputdir, None, 1000.) 


# FinalStateAnalysis/recipe/external/src/rootpy/rootpy/plotting/views.py
vbfSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBFHToTauTau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))

plotter.views['vbfSMH']={'view' : vbfSMH }

new_mc_samples = []
new_mc_samples.extend(['vbfSMH'])
plotter.mc_samples = new_mc_samples


histoname = [('tEta','t Eta',1),("tPt", "t Pt",1),("tPhi", "t Phi",1),("mPt", "m Pt",1),("mEta", "m Eta",1),("mPhi", "m Phi",1),("j1pt", "jet1 Pt",1),("j2pt", "jet2 Pt",1),("m_t_Mass", "m t Mass", 1),("vbfNJets20", "# of Jets above 20Gev", 1),("vbfj1pt", "Jet1 Pt", 1),("vbfj1eta", "Jet1 Eta", 1),("vbfj2pt", "Jet2 Pt", 1),("vbfj2eta", "Jet2 Eta", 1),("vbfdijetpt", "Jets Pt", 1),("vbfMass", "Jets Mass", 1),("vbfDeta", "Delta Eta Jets", 1),("vbfDphi", "Delta Phi Jets", 1),("m_t_collinearmass", "Collinear Mass", 1),("tGenPt", "t Gen Pt", 1),("mGenPt", "m Gen Pt", 1),("tGenPhi", "t Gen Phi", 1),("mGenPhi", "m Gen Phi", 1),("tGenEta", "t Gen Eta", 1),("mGenEta", "m Gen Eta", 1),("mGenMotherPdgId", "mGenMotherPdgId", 1),("tGenMotherPdgId", "tGenMotherPdgId", 1)] # list of tuples containing (histoname, xaxis title, rebin)


foldername = channel
if not os.path.exists(outputdir+'/'+foldername):
    os.makedirs(outputdir+'/'+foldername)


for h in histoname:
    print h

    plotter.simpleplot_mc(foldername, ['VBF_LFV_HToMuTau_M125*'], h[0], rebin=h[2], xaxis=h[1], leftside=False, xrange=None , preprocess=None, sort=True, forceLumi=1000)
    plotter.save(foldername+'/'+h[0])

