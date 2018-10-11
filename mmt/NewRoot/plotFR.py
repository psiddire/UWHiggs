import os
from sys import argv, stdout, stderr
from ROOT import TCanvas, TLegend, gROOT, TFile, gPad
import rootpy.plotting as plotting
import sys
gROOT.SetStyle("Plain")
gROOT.SetBatch(True)

canvas = TCanvas('canvas','canvas',800,800)
pad = plotting.Pad( 0, 0., 1., 1.)
pad.SetGridx(True)
pad.SetGridy(True)
legend = TLegend(0.7, 0.8, .9, .9)
file = TFile('fakerate.root')
hdy = file.Get('dyfakerate')
hdy.SetTitle('Tau Fake Rate')
hdy.SetLineColor(632)
hdata = file.Get('fakerate')
legend.AddEntry(hdy, 'Z+Jets', 'l')
legend.AddEntry(hdata, 'Data', 'l')
hdy.Draw()
hdata.Draw('SAME')
gPad.Update()
graph = hdy.GetPaintedGraph() 
graph.GetXaxis().SetTitle("Tau pT (GeV)")
graph.GetXaxis().SetTitle("Fake Rate")
graph.SetMinimum(0)
graph.SetMaximum(1.0) 
gPad.Update()
legend.Draw()
canvas.Draw()
canvas.SaveAs('TauFRPt.png')
