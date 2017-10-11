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
#    'VBF_LFV_HToMuTau_M125*',
    'GluGluHToTauTau_M125*',
#    'VBF_LFV_HToETau_M125*',
#    'GluGluHToWWTo2L2Nu_M125*',
#    'GluGlu_LFV_HToETau_M125*',
#    'WminusHToTauTau_M125*',
#    'GluGlu_LFV_HToMuTau_M125*',
#    'WplusHToTauTau_M125*',
#    'VBFHToTauTau_M125*'
#    'ZHToTauTau_M125*',
#    'VBFHToWWTo2L2Nu_M125*',
#    'ttHJetToTT_M125*'
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


#vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))
#ggSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGluHToTauTau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#vbfHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToETau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))
#ggHWW = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGluHToWWTo2L2Nu_M125' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#ggHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToETau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#vbfHWW = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBFHToWWTo2L2Nu_M125' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))
#ttHTT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'ttHJetToTT_M125' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
ggSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGluHToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluH*']))
#vbfSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBFHToTauTau_M125' in x , mc_samples)]), **remove_name_entry(data_styles['VBFH*']))
#ZSMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'ZHToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['ZH*']))
#WSMH = views.StyleView(
#    views.SumView( 
#        *[ plotter.get_view(regex) for regex in \
#          filter(lambda x : x.startswith('WminusHToTauTau_M125') or x.startswith('WplusHToTauTau_M125') , mc_samples )]
#    ), **remove_name_entry(data_styles['WH*'])
#)

#HTT = views.StyleView(
#    views.SumView( 
#        *[ plotter.get_view(regex) for regex in \
#          filter(lambda x : x.startswith('GluGluHToTauTau') or x.startswith('VBFHToTauTau') , mc_samples )]
#    ), **remove_name_entry(data_styles['VBFH*'])
#)

plotter.views['ggSMH']={'view' : ggSMH }
#plotter.views['vbfSMH']={'view' : vbfSMH }
#plotter.views['ZSMH']={'view' : ZSMH }
#plotter.views['WSMH']={'view' : WSMH }
#plotter.views['ggHET']={'view' : ggHET }
#plotter.views['ggHMT']={'view' : ggHMT }
#plotter.views['vbfHWW']={'view' : vbfHWW }
#plotter.views['ttHTT']={'view' : ttHTT }
#plotter.views['ggHWW']={'view' : ggHWW }
#plotter.views['vbfHET']={'view' : vbfHET }
#plotter.views['vbfHMT']={'view' : vbfHMT }

#plotter.views['HTT']={'view' : HTT}

new_mc_samples = []
#new_mc_samples.extend(['ggSMH', 'vbfSMH', 'ZSMH', 'WSMH', 'ggHET', 'ggHMT', 'vbfHWW', 'ttHTT', 'ggHWW', 'vbfHET', 'vbfHMT'])
#new_mc_samples.extend(['HTT'])
new_mc_samples.extend(['ggSMH'])
plotter.mc_samples = new_mc_samples


histoname = [('tEta','t Eta',1),("tPt", "t Pt",1),("tPhi", "t Phi",1),("mPt", "m Pt",1),("mEta", "m Eta",1),("mPhi", "m Phi",1),("j1pt", "jet1 Pt",1),("j2pt", "jet2 Pt",1),("m_t_Mass", "m t Mass", 1),("vbfNJets20", "# of Jets above 20Gev", 1),("vbfj1pt", "Jet1 Pt", 1),("vbfj1eta", "Jet1 Eta", 1),("vbfj2pt", "Jet2 Pt", 1),("vbfj2eta", "Jet2 Eta", 1),("vbfdijetpt", "Jets Pt", 1),("vbfMass", "Jets Mass", 1),("vbfDeta", "Delta Eta Jets", 1),("vbfDphi", "Delta Phi Jets", 1),("m_t_collinearmass", "Collinear Mass", 1),("tGenPt", "t Gen Pt", 1),("mGenPt", "m Gen Pt", 1),("tGenPhi", "t Gen Phi", 1),("mGenPhi", "m Gen Phi", 1),("tGenEta", "t Gen Eta", 1),("mGenEta", "m Gen Eta", 1),("mGenMotherPdgId", "mGenMotherPdgId", 1),("tGenMotherPdgId", "tGenMotherPdgId", 1)] # list of tuples containing (histoname, xaxis title, rebin)
#histoname = [("m_t_collinearmass", "m t collinear mass", 1)]


foldername = channel#+"/fromHiggs"
if not os.path.exists(outputdir+'/'+foldername):
    os.makedirs(outputdir+'/'+foldername)


for h in histoname:
    print h

#    plotter.simpleplot_mc(foldername, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], rebin=h[2], xaxis=h[1], leftside=False, xrange=None , preprocess=None, sort=True, forceLumi=1000)
    plotter.simpleplot_mc(foldername, ['GluGlu_LFV_HToMuTau_M125*'], h[0], rebin=h[2], xaxis=h[1], leftside=False, xrange=None , preprocess=None, sort=True, forceLumi=1000)
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
