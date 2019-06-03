import os
from sys import argv, stdout, stderr
from ROOT import TCanvas, TLegend, gROOT, TFile, gPad
import sys
gROOT.SetStyle("Plain")
gROOT.SetBatch(True)

f = sys.argv[-2]
o = sys.argv[-1]

canvas = TCanvas('canvas','canvas',800,800)
legend = TLegend(0.7, 0.8, .9, .9)
file = TFile(f)
hdy = file.Get('dyfakerate')
hdy.SetTitle('Muon Fake Rate')
hdy.SetLineColor(632)
hdata = file.Get('fakerate')
legend.AddEntry(hdy, 'Z+Jets', 'l')
legend.AddEntry(hdata, 'Data', 'l')
hdy.Draw()
hdata.Draw('SAME')
gPad.Update()
graph = hdy.GetPaintedGraph() 
graph.SetMinimum(0)
graph.SetMaximum(1.1) 
graph.GetXaxis().SetTitle("Muon Pt")
graph.GetYaxis().SetTitle("Fake Rate")
gPad.Update()
legend.Draw()
canvas.Draw()
canvas.SaveAs(o)
