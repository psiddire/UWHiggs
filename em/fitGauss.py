import os
from ROOT import TCanvas, TF1, gROOT, TFile, gStyle, gPad, TLatex
import sys
import glob
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('results/Data2017JEC/AnalyzeEM/*.root')) 

canvas = TCanvas('canvas','canvas',800,800)

for f in files:
        print f
	file = TFile(f)
	file.cd()
	for f in file.GetListOfKeys():
		f = f.ReadObj()
		f.cd()
		for h in f.GetListOfKeys():
			if h.GetName() == 'e_m_Mass':
				hm = h. ReadObj()
				f1 = TF1('f1', 'gaus')
				hm.Fit(f1, 'Q')
				print  f.GetName(),', Mean:', f1.GetParameter('Mean'), ', Sigma: ', f1.GetParameter('Sigma'), ', % to mean: ', f1.GetParameter('Sigma')*100/f1.GetParameter('Mean')
