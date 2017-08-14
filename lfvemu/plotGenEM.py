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
    'GluGluHToTauTau_M125*'
#    'VBFHToTauTau_M125*',
#    'WminusHToTauTau_M125*',
#    'WplusHToTauTau_M125*',
#    'ZHToTauTau_M125*'
    ]

files=[]
lumifiles=[]
channel = 'em'
for x in mc_samples:
    #print x
    files.extend(glob.glob('results/%s/LFVEMuAnalyserGen/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/LFVEMuAnalyserGen/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)
    
plotter = BasePlotter(files, lumifiles, outputdir, None, 1000.) 


ggSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGluHToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#vbfSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBFHToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))
#ZSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'ZHToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['ZH*']))
#WSMH = views.StyleView(
#    views.SumView( 
#        *[ plotter.get_view(regex) for regex in \
#          filter(lambda x : x.startswith('WminusHToTauTau_M125') or x.startswith('WplusHToTauTau_M125') , mc_samples )]
#    ), **remove_name_entry(data_styles['WH*'])
#)

plotter.views['ggSMH']={'view' : ggSMH }
#plotter.views['vbfSMH']={'view' : vbfSMH }
#plotter.views['ZSMH']={'view' : ZSMH }
#plotter.views['WSMH']={'view' : WSMH }

new_mc_samples = []
new_mc_samples.extend(['ggSMH'])#, 'vbfSMH', 'ZSMH', 'WSMH'])
plotter.mc_samples = new_mc_samples



histoname = [('eGenPdgId', 'e pdgId', 1)] # list of tuples containing (histoname, xaxis title, rebin)


foldername = channel
if not os.path.exists(outputdir+'/'+foldername):
    os.makedirs(outputdir+'/'+foldername)


for h in histoname:
    print h

    plotter.simpleplot_mc(foldername, ['VBF_LFV_HToEMu_M125*'], h[0], rebin=h[2], xaxis=h[1], leftside=False, xrange=None , preprocess=None, sort=True, forceLumi=1000)
    plotter.save(foldername+'/'+h[0])



##canvas = ROOT.TCanvas("canvas","canvas",800,800)
##legend = ROOT.TLegend(0.2,0.8, 0.4, 0.7)
##LFVStack = ROOT.THStack("stack","")
##
##mypath = 'results/%s/LFVEMuAnalyserGen/' %jobid
##filelist = [f for f in listdir(mypath) if (isfile(join(mypath, f)) and 'data' not in f)]
##
###print lfvfilelist
###print smfilelist
##
##files=[]
##lumifiles=[]
##channel = 'em'
##for x in filelist:
##    #print x
##    files.extend(glob.glob('results/%s/LFVEMuAnalyserGen/%s' % (jobid, x)))
##    lumifiles.extend(glob.glob(('inputs/%s/%s' % (jobid, x)).replace('root', 'lumicalc.sum')))
##
###print files
###print lumifiles
##
##
##histolist = ['eGenPdgId'] #add here the histo you want to plot
##xaxilabel = ['e pdgId']
##mydir = channel
##
###create plot directory if doesn't exist
##outputdir = 'plots/%s/LFVEMuAnalyserGen/%s/' % (jobid, mydir)
##if not os.path.exists(outputdir):
##    os.makedirs(outputdir)
##
##canvas.Draw()
##canvas.cd()
##
##
##for histo in histolist:
##    for n,myfilename in enumerate(files):
##
##        myfile = ROOT.TFile(myfilename)        
##        sm_h = myfile.Get('/'.join([mydir,histo]))
##        sm_h.SetName(histo+filelist[n].replace('.root', ''))
##        print sm_h
##        lumi= 1. # put here the value read from lumifile
##
##        #if sm_h.Integral() != 0  : 
##        #    sm_h.Scale(lumi/sm_h.Integral())
##
##
##        if n==0:
##            sm_h.Draw()
##        else:
##            sm_h.Draw("SAME")
##
##        sm_h.SetLineColor(1+n)
##        sm_h.SetLineWidth(2)
##        legend.AddEntry(sm_h, filelist[n].replace('.root', ''), 'l')
##
##
##        
##
##    figurename= outputdir+histo+".pdf"
##    canvas.SaveAs(figurename)
##    canvas.SaveAs(figurename.replace('pdf','png'))
##
##            
##    
##    legend.Clear()
##    canvas.Clear()
