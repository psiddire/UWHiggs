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
hdy.SetTitle('Tau Fake Rate')
#hdy.GetXaxis().SetTitle("Tau Pt (GeV)")
#hdy.GetXaxis().SetTitle("Tau Eta") 
#hdy.GetXaxis().SetTitle("Tau Decay Mode") 
#hdy.GetYaxis().SetTitle("Fake Rate")
hdy.SetLineColor(632)
hdata = file.Get('fakerate')
legend.AddEntry(hdy, 'Z+Jets', 'l')
legend.AddEntry(hdata, 'Data', 'l')
hdy.Draw()
hdata.Draw('SAME')
legend.Draw()
canvas.Draw()
canvas.SaveAs(o)
