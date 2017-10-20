import os
import ROOT
import glob
import math
import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.WARNING)
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs
from os import listdir
from os.path import isfile, join


ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
ROOT.gStyle.SetTitle("Mass of two muons m1 and m2")
ROOT.gStyle.SetOptTitle(1)
ROOT.TGaxis.SetMaxDigits(2)
 
canvas = ROOT.TCanvas("canvas","canvas",800,800)
legend = ROOT.TLegend(0.52,0.7,0.9,0.9)#(0.1,0.7,0.48,0.9)
#fwhm = ROOT.TLegend(0.52,0.7,0.9,0.9)
#title = ROOT.TPaveLabel(.11,.95,.35,.99,"Vis M vs Col M","brndc")

jobid = os.environ['jobid']
   
files=[]
samples = [
	'data_SingleMuon_Run2017B_PromptReco-v1.root',
	'data_SingleMuon_Run2017B_PromptReco-v2.root',
	'data_SingleMuon_Run2017C_PromptReco-v1.root',
	'data_SingleMuon_Run2017C_PromptReco-v2.root',
	'data_SingleMuon_Run2017C_PromptReco-v3.root',
	'data_SingleMuon_Run2017D_PromptReco-v1.root'
]

for x in samples:
	print x
	files.extend(glob.glob('results/%s/LFVMuTauAnalyser/%s' % (jobid, x)))
	#files.append('results/%s/LFVMuTauAnalyser/%s' % (jobid, x))

print files

outputdir = 'plots/%s/LFVMuTauAnalyser/' % (jobid)
if not os.path.exists(outputdir):
	os.makedirs(outputdir)

#lumi = 514721.021207


for n, file in enumerate(files):

	MuMufile = ROOT.TFile(file)
        gendir = MuMufile.Get('mm')#('mt')
        hlist = gendir.GetListOfKeys()
	
        iter = ROOT.TIter(hlist)
        for i in iter:
		if i.GetName()=='m1_m2_Mass':
			mass_histo = MuMufile.Get('mm/'+i.GetName())#('mt/'+i.GetName())
			if mass_histo.Integral() != 0:
				mass_histo.Scale(1./mass_histo.Integral())
				#bin1 = lfv_histo_vis.FindFirstBinAbove(lfv_histo_vis.GetMaximum()/2)
				#bin2 = lfv_histo_vis.FindLastBinAbove(lfv_histo_vis.GetMaximum()/2)
				#fwhm1 = str(lfv_histo_vis.GetBinCenter(bin2) - lfv_histo_vis.GetBinCenter(bin1))
				#mass_histo.Scale(1/lumifiles[n])
				mass_histo.Rebin(5)
				mass_histo.SetLineWidth(2)
				mass_histo.SetLineColor(2)
				mass_histo.SetMaximum(1.2*mass_histo.GetMaximum())
				mass_histo.GetXaxis().SetTitle("Mass(GeV)")
				mass_histo.GetYaxis().SetTitle("Normalised to histogram integral")
				mass_histo.GetYaxis().SetTitleOffset(1.4)
				#lfv_histo.SetTitle("Mass of two muons m1 and m2")
				mass_histo.Draw('hist')
				#print lfv_histo_vis.GetMaximum() 
				#print lfv_histo_vis.GetBinContent(lfv_histo_vis.GetMaximumBin())
				
	legend.AddEntry(mass_histo,"Mass of m1 and m2","l")
	legend.Draw()
	#fwhm.AddEntry(lfv_histo_vis,"FWHM of Visible Mass:"+fwhm1,"l")
        #fwhm.AddEntry(lfv_histo_col,"FWHM of Collinear Mass:"+fwhm2,"l")
        #fwhm.Draw()
	canvas.SaveAs(outputdir+'zmass'+str(n)+'.png')
	#canvas.SaveAs(outputdir+'zmass.png')
