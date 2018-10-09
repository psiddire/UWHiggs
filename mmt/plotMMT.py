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
    'WJetsToLNu*',
    'W1JetsToLNu*',
    'W2JetsToLNu*',
    'W3JetsToLNu*',
    'W4JetsToLNu*',
    'GluGluHToTauTau*',
    'VBFHToTauTau*',
    'WminusHToTauTau*',
    'WplusHToTauTau*',
    'ttHToTauTau*',
    'ZHToTauTau*',
    'TTTo2L2Nu*',
    'TTToSemiLeptonic*',
    'TTToHadronic*',
    'ST_tW_antitop*',
    'ST_tW_top*',
    'ST_t-channel_antitop*',
    'ST_t-channel_top*',
    'WZ*',
    'WW*',
    'ZZ*',
    'QCD*',
    'data*',
]
files=[]
lumifiles=[]
channel = ['initial', 'loose', 'LDM0', 'LDM1', 'LDM10', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'tight', 'TDM0', 'TDM1', 'TDM10', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEEDM0', 'TEEDM1', 'TEEDM10']
#channel = ['initial', 'vloose', 'tight']
for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeMuMuTau/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/AnalyzeMuMuTau/MMTOct5/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))
DY = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY') , mc_samples )]), **remove_name_entry(data_styles['DY*']))
WJ = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'JetsToLNu' in x , mc_samples )] ), **remove_name_entry(data_styles['W*Jets*']))
SMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['*HToTauTau*']))
TT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('TT') or x.startswith('ST'), mc_samples)]), **remove_name_entry(data_styles['TT*']))
QCD = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('QCD'), mc_samples)]), **remove_name_entry(data_styles['QCD*']))
EWKDiboson = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples )]), **remove_name_entry(data_styles['WZ*']))

plotter.views['vbfHMT']={'view' : vbfHMT }
plotter.views['ggHMT']={'view' : ggHMT }
plotter.views['WJ']={'view' : WJ }
plotter.views['DY']={'view' : DY }
plotter.views['SMH']={'view' : SMH }
plotter.views['TT']={'view' : TT }
plotter.views['QCD']={'view' : QCD }
plotter.views['EWKDiboson']={'view' : EWKDiboson }


new_mc_samples = []
new_mc_samples.extend(['WJ', 'DY', 'SMH', 'TT', 'QCD', 'EWKDiboson'])
plotter.mc_samples = new_mc_samples

histoname = [("tPt", "Tau Pt", 1), ("tEta", "Tau Eta", 1), ("tDecayMode", "Tau DecayMode", 1), ("m1_m2_Mass", "Visible Mass", 1), ("m1Pt", "Muon 1 Pt", 1), ("m1Eta", "Muon 1 Eta", 1), ("m2Pt", "Muon 2 Pt", 1), ("m2Eta", "Muon 2 Eta", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_vs_data(fn, [], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True)
        plotter.save(fn+'/'+h[0])

