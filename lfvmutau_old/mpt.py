import os
from sys import argv, stdout, stderr
import ROOT
import sys
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0);

outfile = ROOT.TFile("outfile.root","RECREATE")
outfile.cd() 
canvas = ROOT.TCanvas("canvas","canvas",800,800)
legend = ROOT.TLegend(0.1,0.7,0.48,0.9)
title = ROOT.TPaveLabel(.11,.95,.35,.99,"Vis M vs Col M","brndc")
canvas.Draw()   

lfvfilelist = ['results/LFV_mutau/LFVMuTauAnalyserGen/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root','results/LFV_mutau/LFVMuTauAnalyserGen/GluGluHToTauTau_M125_13TeV_powheg_pythia8_v6-v1.root']# , 'results/LFV_mutau/LFVMuTauAnalyserGen/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root']

filepath = 'plots/LFV_mutau/LFVMuTauAnalyserGen/'
histolist = []
for n, file in enumerate(lfvfilelist):
	
	MuTaufile = ROOT.TFile(file)
	gendir = MuTaufile.Get('fromHiggs')#('mt')
	hlist = gendir.GetListOfKeys()

	iter = ROOT.TIter(hlist)

					
	for i in iter:
		if i.GetName()=='mGenPt':
			if n==0:
				lfv_histo = MuTaufile.Get('fromHiggs/'+i.GetName()).Clone()
				lfv_histo.SetName("lfv_histo")
				
				if lfv_histo.Integral() != 0:
					lfv_histo.Scale(1./lfv_histo.Integral())
					lfv_histo.Rebin(2)
					lfv_histo.SetLineWidth(2)
					lfv_histo.SetLineColor(1)
#					lfv_histo.SetMaximum(2.0*lfv_histo.GetMaximum())
#					lfv_histo.GetXaxis().SetRange(10,50)
					lfv_histo.Draw('hist')
					print 'LFV:', lfv_histo.Integral()
				outfile.cd()
				lfv_histo.Write()
				histolist.append(lfv_histo)
				legend.AddEntry(lfv_histo,"H to #mu #tau","l")			
				legend.Draw()

			if n==1:
				histo_sm = MuTaufile.Get('fromHiggs/'+i.GetName()).Clone()
				histo_sm.SetName("histo_sm")
                                if histo_sm.Integral() != 0:
                                        histo_sm.Scale(1./histo_sm.Integral())
                                        histo_sm.Rebin(2)
                                        histo_sm.SetLineWidth(2)
                                        histo_sm.SetLineColor(2)
					histo_sm.Draw("SAME")
					print 'SM:', histo_sm.Integral()
				outfile.cd()
                                histo_sm.Write()
				histolist.append(histo_sm)
				legend.AddEntry(histo_sm,"H to #tau(#mu) #tau","l")			
				legend.Draw()
				canvas.Write()
				canvas.SaveAs(filepath+'mPt_new.png')
canvas1 = ROOT.TCanvas("canvas1","new canvas",800,800)
canvas1.Draw()
histolist[0].Draw()
histolist[1].Draw("SAME")
canvas1.SaveAs(filepath+'mPt_new1.png')
