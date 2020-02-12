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

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

mc_samples = ['DYJ*', 'DY1*', 'DY2*', 'DY3*', 'DY4*', 'WZ*', 'WW*', 'ZZ*', 'data*']

files = []
lumifiles = []

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeEEE/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

dirs = ['initial', 'eleloose', 'eletight']

for d in dirs:

    outputdir = 'plots/%s/AnalyzeEEE/%s/' % (jobid, d)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY'), mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, d)
    DY = views.StyleView(DYall, **remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, "Z#rightarrow ee")
    
    Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    Dibosonall = views.SubdirectoryView(Dibosontotal, d)
    Diboson = views.StyleView(Dibosonall, **remove_name_entry(data_styles['WZ*']))
    Diboson = views.TitleView(Diboson, "Diboson")

    plotter.views['DY'] = {'view' : DY}
    plotter.views['Diboson'] = {'view' : Diboson}

    plotter.mc_samples = ['DY', 'Diboson']

    histoname = [("e3Pt", "Electron 3 p_{T} (GeV)", 1), ("e3Eta", "Ele 3 #eta", 1), ("e1_e2_Mass", "M_{vis}(e, e) (GeV)", 1), ("e1Pt", "Ele 1 p_{T} (GeV)", 1), ("e1Eta", "Ele 1 #eta", 1), ("e2Pt", "Ele 2 p_{T} (GeV)", 1), ("e2Eta", "Ele 2 #eta", 1)]

    foldername = [''] 

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            plotter.plot_mc_vs_data(fn, [], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=d, jets='', year='2017', channel='eee')
            plotter.save(h[0])
