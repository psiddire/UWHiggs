import os
from sys import argv, stdout, stderr
import ROOT
import sys
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

canvas = ROOT.TCanvas("canvas","canvas",800,800)
#LFVStack = ROOT.THStack("stack","")

lfvfilelist = ['results/LFV_mutau/LFVMuTauAnalyserGen/GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root', 'results/LFV_mutau/LFVMuTauAnalyserGen/VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1.root']
smfilelist = ['results/LFV_mutau/LFVMuTauAnalyserGen/GluGluHToTauTau_M125_13TeV_powheg_pythia8_v6-v1.root', 'results/LFV_mutau/LFVMuTauAnalyserGen/VBFHToTauTau_M125_13TeV_powheg_pythia8_v6-v1.root']

filepath = 'plots/LFV_mutau/LFVMuTauAnalyserGen/'

for n, file in enumerate(lfvfilelist):

        MuTaufile = ROOT.TFile(file)
        SMHTauTaufile = ROOT.TFile(smfilelist[n])
        gendir = MuTaufile.Get('mt')
        hlist = gendir.GetListOfKeys()

        iter = ROOT.TIter(hlist)

#        if not os.exists.path(filepath):os.mkdirs(filepath)   
#	continue
        for i in iter:
                lfv_histo = MuTaufile.Get('mt/'+i.GetName())
                sm_histo = SMHTauTaufile.Get('mt/'+i.GetName())
                
                if lfv_histo.Integral() != 0 and sm_histo.Integral() != 0  : 
                        lfv_histo.Scale(1./lfv_histo.Integral())
                        sm_histo.Scale(1./sm_histo.Integral())

#			maxlfv = lfv_histo.GetBinContent(lfv_histo.GetMaximumBin())
#                       maxsm  = sm_histo.GetBinContent(sm_histo.GetMaximumBin())
#			maxlfv = lfv_histo.GetMaximumBin()
#                       maxsm  = sm_histo.GetMaximumBin()
#			if maxlfv > maxsm :
#				lfv_histo.GetYaxis().SetRangeUser(0, maxlfv*1.3)
#			else :
#				lfv_histo.GetYaxis().SetRangeUser(0, maxsm*1.3)

			lfv_histo.SetLineWidth(2)
                        sm_histo.SetLineColor(2)
                        sm_histo.SetLineWidth(2)
                                           
			sm_histo.SetMaximum(1.2*max(sm_histo.GetMaximum(),lfv_histo.GetMaximum()))
                        sm_histo.Draw("E") 
			lfv_histo.Draw("ESAME")
                        
                       
                        canvas.Update()
                        canvas.SaveAs(filepath+'/gen_'+i.GetName()+'.png')
