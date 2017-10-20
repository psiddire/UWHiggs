from BasePlotter import BasePlotter
import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.RebinView import RebinView
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
#print jobid

mc_samples = [
    'WGstarToLNuEE*',
    'WGstarToLNuMuMu*',
    'ZZTo2L2Q*',
    'ZZTo4L*',
#    'EWKWMinus2Jets*',
    'WminusHToTauTau_M125*',
#    'EWKWPlus2Jets*',
    'WplusHToTauTau_M125*',
#    'EWKZ2Jets_ZToLL*'
#    'EWKZ2Jets_ZToNuNu*',
    'WGToLNuG*',
    'WW_TuneCUETP8M1*',
    'WZ_TuneCUETP8M1*',
    'ZZ_TuneCUETP8M1*',
    'WZJToLLLNu*',
    'WZTo1L1Nu2Q*',
    'WZTo1L3Nu*',
    'WZTo2L2Q*',
    'WWTo1L1Nu2Q*',
    'WWW_4F*',
    'DY1JetsToLL_M-10to50*',
    'DY1JetsToLL_M-50*',
    'DY2JetsToLL_M-10to50*',
    'DY2JetsToLL_M-50*',
    'DY3JetsToLL_M-50*',
    'DY4JetsToLL_M-50*',
    'DYJetsToLL_M-10to50*',
    'DYJetsToLL_M-50*',
    'W1JetsToLNu*',
    'W2JetsToLNu*',
    'W3JetsToLNu*',
    'W4JetsToLNu*',
    'WJetsToLNu*',
    'data*'
]

files=[]
lumifiles=[]
channel = 'mm'
for x in mc_samples:
    if x!='data*':
        files.extend(glob.glob('results/%s/MuMuAnalyserGen/%s' % (jobid, x)))
        lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))
    else:
        files.extend(glob.glob('results/lpairs_data_Oct9/MuMuAnalyser/%s' % (x)))
        lumifiles.extend(glob.glob('inputs/lpairs_data_Oct9/%s.lumicalc.sum' % (x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/MuMuAnalyserGen/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)
#print "outputdir", outputdir
#print "files", files
#print lumifiles    
#plotter = BasePlotter(files, lumifiles, outputdir, None, 1000.) 
plotter = Plotter(files, lumifiles, outputdir) 


WSMH = views.StyleView(
    views.SumView( 
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('WminusHToTauTau_M125') or x.startswith('WplusHToTauTau_M125') , mc_samples )]
    ), **remove_name_entry(data_styles['WH*'])
)

#EWK = views.StyleView(
#    views.SumView(
#        *[ plotter.get_view(regex) for regex in \
#          filter(lambda x : x.startswith('EWKZ2Jets_ZToLL') or x.startswith('EWKZ2Jets_ZToNuNu') , mc_samples )]
#    ), **remove_name_entry(data_styles['EWK*'])
#)

EWKDiboson = views.StyleView(
    views.SumView( 
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('WW') or x.startswith('WZ') or x.startswith('ZZ') or x.startswith('WG'), mc_samples )]
    ), **remove_name_entry(data_styles['WW*'#,'WZ*', 'WG*', 'ZZ*'
])
)

WJ = views.StyleView(
    views.SumView(
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('W1JetsToLNu') or x.startswith('W2JetsToLNu') or x.startswith('W3JetsToLNu') or x.startswith('W4JetsToLNu') or x.startswith('WJetsToLNu') , mc_samples )]# or x.startswith('EWKWMinus2Jets') or x.startswith('EWKWPlus2Jets')
    ), **remove_name_entry(data_styles['WplusJets*'])#'Wplus*Jets*''WplusJets*'
)

DY = views.StyleView(
    views.SumView(
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('DY1JetsToLL_M-10to50') or x.startswith('DY1JetsToLL_M-50') or x.startswith('DY2JetsToLL_M-10to50') or x.startswith('DY2JetsToLL_M-50') or x.startswith('DY3JetsToLL_M-50') or x.startswith('DY4JetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50') or x.startswith('DYJetsToLL_M-50') , mc_samples )]
    ), **remove_name_entry(data_styles['Zjets*'])
)


plotter.views['WSMH']={'view' : WSMH }
plotter.views['EWKDiboson']={'view' : EWKDiboson }
plotter.views['WJ']={'view' : WJ }
plotter.views['DY']={'view' : DY }


new_mc_samples = []
new_mc_samples.extend(['WSMH', 'EWKDiboson', 'WJ', 'DY'])
#new_mc_samples.extend(['ggSMH'])
plotter.mc_samples = new_mc_samples


histoname = ['m1Pt','m2Pt','m1_m2_Mass']#,'m1GenPt','m2GenPt']
axistitle = ['m1 p_{T} (GeV)','m2 p_{T} (GeV)','m1-m2 Inv Mass (GeV)']#,'m1 Gen p_{T} (GeV)','m2 Gen p_{T} (GeV)']

foldername = channel#+"/fromHiggs"
if not os.path.exists(outputdir+'/'+foldername):
    os.makedirs(outputdir+'/'+foldername)

rebins = []
for n in histoname :
    rebins.append(1)

for n,h in enumerate(histoname):
    plotter.pad.SetLogy(True)
    
#    plotter.plot_mc(foldername, h, 1, xaxis= axistitle[n], leftside=False, show_ratio=False, ratio_range=1.5,  sort=False)
    plotter.plot_mc_vs_data(foldername, h, 1, xaxis= axistitle[n], leftside=False, xrange=[0,200], show_ratio=True, ratio_range=1.5, sort=True)
    plotter.save(foldername+'/'+h)
#rebin=rebins[n]


