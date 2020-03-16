import os
from ROOT import TCanvas, Fit, TF1, gROOT, TFile, gStyle, gPad, TGraphErrors, TEfficiency, TBinomialEfficiencyFitter
import sys
from array import array
import numpy as np
import glob
gROOT.SetStyle("Plain")
gStyle.SetOptFit()
gROOT.SetBatch(True)

files = []
files.extend(glob.glob('*.root')) 

canvas = TCanvas('canvas','canvas',800,800)

for f in files:
	file = TFile(f)
	f_title = f.replace('.root', '')
	hdy = file.Get('fakerate')
	title = 'Tau Fake Rate '+ f_title +';Tau Pt (GeV); Fake Rate'
	hdy.SetTitle(title)
        f1 = TF1("f1","[0]+x*[1]",0,200)
        f1.SetLineColor(4)
        fitResult = hdy.Fit(f1, "S")
        hdy.Draw()
        gPad.Update()  
        graph = hdy.GetPaintedGraph()   
        graph.SetMinimum(0)
        graph.SetMaximum(1.5) 
        y = np.array([fitResult.GetParams()[0] + fitResult.GetParams()[1]*graph.GetX()[i] for i in range(graph.GetN())])
        ey = np.array([fitResult.GetErrors()[0] + fitResult.GetErrors()[1]*graph.GetX()[i] for i in range(graph.GetN())])
        zeros = np.zeros(graph.GetN())
        interval = TGraphErrors(graph.GetN(), graph.GetX(), y, zeros, ey)
        interval.SetFillColor(2)
        interval.SetFillStyle(3002)
        interval.Draw("e3 same")
        gPad.Update()
	canvas.SaveAs(f_title + '.png')
