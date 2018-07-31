from BasePlotter import BasePlotter
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
    'VBF_LFV_HToMuTau*',
    'GluGlu_LFV_HToMuTau*',
    'DYJetsToLL*',
#    'DY1JetsToLL*',
#    'DY2JetsToLL*',
#    'DY3JetsToLL*',
#    'DY4JetsToLL*',
    'WJetsToLNu*',
#    'W1JetsToLNu*',
#    'W2JetsToLNu*',
#    'W3JetsToLNu*',
#    'W4JetsToLNu*',
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
    'data*',
]
files=[]
lumifiles=[]
channel = ['passallselections']
for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/NewAnalyzeMuTau/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/NewAnalyzeMuTau/31July_New/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

#plotter = BasePlotter(files, lumifiles, outputdir, None, 1000.) 
plotter = Plotter(files, lumifiles, outputdir)#, None, 41859.674)

vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))
DY = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DYJetsToLL') or x.startswith('DY1JetsToLL') or x.startswith('DY2JetsToLL') or x.startswith('DY3JetsToLL') or x.startswith('DY4JetsToLL') , mc_samples )]), **remove_name_entry(data_styles['DY*']))
WJ = views.StyleView(
    views.SumView(
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('W1JetsToLNu') or x.startswith('W2JetsToLNu') or x.startswith('W3JetsToLNu') or x.startswith('W4JetsToLNu') or x.startswith('WJetsToLNu') , mc_samples )]
    ), **remove_name_entry(data_styles['W*Jets*'])
)
SMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['*HToTauTau*']))
TT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('TT') or x.startswith('ST'), mc_samples)]), **remove_name_entry(data_styles['TT*']))
#singleT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('ST'), mc_samples)]), **remove_name_entry(data_styles['TT*']))
EWKDiboson = views.StyleView(
    views.SumView( 
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples )]
    ), **remove_name_entry(data_styles['WZ*'])
)

plotter.views['vbfHMT']={'view' : vbfHMT }
plotter.views['ggHMT']={'view' : ggHMT }
plotter.views['WJ']={'view' : WJ }
plotter.views['DY']={'view' : DY }
plotter.views['SMH']={'view' : SMH }
plotter.views['TT']={'view' : TT }
#plotter.views['singleT']={'view' : singleT }
plotter.views['EWKDiboson']={'view' : EWKDiboson }


new_mc_samples = []
new_mc_samples.extend(['WJ', 'DY', 'SMH', 'TT', 'EWKDiboson'])
plotter.mc_samples = new_mc_samples

histoname = [('m_t_Mass','Muon + Tau Mass',1),('m_t_CollinearMass','Muon + Tau Collinear Mass',1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        #plotter.simpleplot_mc(fn, ['VBF_LFV_HToMuTau_M125*','GluGlu_LFV_HToMuTau_M125*'], h[0], rebin=h[2], xaxis=h[1], leftside=False, xrange=None , preprocess=None, sort=True, forceLumi=1000)
        plotter.plot_mc_vs_data(fn, h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.0, sort=True)
        plotter.save(fn+'/'+h[0])

