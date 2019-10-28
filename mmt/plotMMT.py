import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles
import os
import ROOT
import glob
import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

mc_samples = ['DYJetsToLL*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WZ*', 'WW*', 'ZZ*', 'data*']

files = []
lumifiles = []
channel = ['initial', 'loose', 'LDM0', 'LDM1', 'LDM10', 'LEBDM0', 'LEBDM1', 'LEBDM10', 'LEEDM0', 'LEEDM1', 'LEEDM10', 'tight', 'TDM0', 'TDM1', 'TDM10', 'TEBDM0', 'TEBDM1', 'TEBDM10', 'TEEDM0', 'TEEDM1', 'TEEDM10']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeMMT/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/AnalyzeMMT/InitialPlots/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

DY = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY') , mc_samples )]), **remove_name_entry(data_styles['DY*']))
Diboson = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples )]), **remove_name_entry(data_styles['WZ*']))

plotter.views['DY'] = {'view' : DY}
plotter.views['Diboson'] = {'view' : Diboson}

new_mc_samples = []
new_mc_samples.extend(['DY', 'Diboson'])
plotter.mc_samples = new_mc_samples

histoname = [("tPt", "#tau p_{T} (GeV)", 1), ("tEta", "#tau #eta", 1), ("tDecayMode", "Tau DecayMode", 1), ("m1_m2_Mass", "M_{vis}(#mu, #mu) (GeV)", 1), ("m1Pt", "#mu 1 p_{T} (GeV)", 1), ("m1Eta", "#mu 1 #eta", 1), ("m2Pt", "#mu 2 p_{T} (GeV)", 1), ("m2Eta", "#mu 2 #eta", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_vs_data(fn, [], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, channel='mumutauh')
        plotter.save(fn+'/'+h[0])
