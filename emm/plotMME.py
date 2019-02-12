import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
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
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
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
    'DYJetsToLL*',
    'DY1JetsToLL*',
    'DY2JetsToLL*',
    'DY3JetsToLL*',
    'DY4JetsToLL*',
    'WZ*',
    'WW*',
    'ZZ*',
    'data*',
]
files=[]
lumifiles=[]
channel = ['initial', 'elloose', 'eltight']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeEMM/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/AnalyzeEMM/LooseIDIsoRho/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

DY = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY') , mc_samples )]), **remove_name_entry(data_styles['DY*']))
EWKDiboson = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples )]), **remove_name_entry(data_styles['WZ*']))

plotter.views['DY']={'view' : DY }
plotter.views['EWKDiboson']={'view' : EWKDiboson }

new_mc_samples = []
new_mc_samples.extend(['DY', 'EWKDiboson'])
plotter.mc_samples = new_mc_samples

histoname = [("ePt", "Electron Pt", 1), ("eEta", "Electron Eta", 1), ("m1_m2_Mass", "Visible Mass", 1), ("m1Pt", "Muon 1 Pt", 1), ("m1Eta", "Muon 1 Eta", 1), ("m2Pt", "Muon 2 Pt", 1), ("m2Eta", "Muon 2 Eta", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_and_data(fn, h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True)
        plotter.save(fn+'/'+h[0])

