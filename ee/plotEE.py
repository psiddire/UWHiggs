import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'data*']
files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeEE/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

outputdir = 'plots/%s/AnalyzeEE/Mar6NewNew/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

DY = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') , mc_samples)]), 'Initial'), **remove_name_entry(data_styles['DY*']))
DY = views.TitleView(DY, "Zll")

DYlow = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DYJetsToLL_M-10to50') , mc_samples)]), 'Initial'), **remove_name_entry(data_styles['DYlow*']))
DYlow = views.TitleView(DYlow, "ZllLowMass")

EWK = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)]), 'Initial'), **remove_name_entry(data_styles['W*Jets*']))
EWK = views.TitleView(EWK, "EWK")

TT = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]), 'Initial'), **remove_name_entry(data_styles['TT*']))
TT = views.TitleView(TT, "TT")

ST = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]), 'Initial'), **remove_name_entry(data_styles['ST*']))
ST = views.TitleView(ST, "ST")

EWKDiboson = views.StyleView(views.SubdirectoryView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]), 'Initial'), **remove_name_entry(data_styles['WZ*']))
EWKDiboson = views.TitleView(EWKDiboson, "Diboson")

plotter.views['DY']={'view' : DY }
plotter.views['DYlow']={'view' : DYlow }
plotter.views['EWK']={'view' : EWK }
plotter.views['TT']={'view' : TT }
plotter.views['ST']={'view' : ST }
plotter.views['EWKDiboson']={'view' : EWKDiboson }

new_mc_samples = []
new_mc_samples.extend(['DY', 'TT', 'ST', 'EWKDiboson', 'EWK', 'DYlow'])

plotter.mc_samples = new_mc_samples

histoname = [("e1Pt", "Electron 1 Pt (GeV)", 1),("e2Pt", "Electron 2 Pt (GeV)", 1),("e1Eta", "Electron 1 Eta", 1),("e2Eta", "Electron 2 Eta", 1),("e1Phi", "Electron 1 Phi", 1),("e2Phi", "Electron 2 Phi", 1),("e1_e2_Mass", "Dielectron Mass", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_vs_data(fn, [], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=False, control='Initial', jets='')
        plotter.save(h[0])

