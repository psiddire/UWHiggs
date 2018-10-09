import os
from sys import argv, stdout, stderr
from ROOT import TCanvas, TLegend, gROOT, TFile
import sys
gROOT.SetStyle("Plain")
gROOT.SetBatch(True)

canvas = TCanvas('canvas','canvas',800,800)
legend = TLegend(0.7, 0.8, .9, .9)
file = TFile('frMuonEta.root')
hdy = file.Get('dyfakerate')
hdy.SetTitle('Muon Fake Rate')
#hdy.GetXaxis().SetTitle("Muon Pt (GeV)")
hdy.GetXaxis().SetTitle("Muon Eta") 
hdy.GetYaxis().SetTitle("Fake Rate")
hdy.SetLineColor(632)
hdata = file.Get('fakerate')
legend.AddEntry(hdy, 'Z+Jets', 'l')
legend.AddEntry(hdata, 'Data', 'l')
hdy.Draw()
hdata.Draw('SAME')
legend.Draw()
canvas.Draw()
canvas.SaveAs('MuonFREta.png')