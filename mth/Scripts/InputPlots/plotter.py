#!/usr/bin/env python
import ROOT
import re
from array import array
from collections import OrderedDict
import varCfgPlotter
import argparse
import os
from FinalStateAnalysis.PlotTools.SystematicsView import SystematicsView
import ROOT as rt
import CMS_lumi, tdrstyle
import array

#set the tdr style
tdrstyle.setTDRStyle()

parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--isLog",
    type=int,
    action="store",
    dest="isLog",
    default=0,
    help="Plot Log Y? (Integers 0, false, 1 true)")
parser.add_argument(
    "--channel",
    action="store",
    dest="channel",
    default="et",
    help="Which channel to run over? (et, mt, em, me)")
parser.add_argument(
    "--prefix",
    action="store",
    dest="prefix",
    default="prefit",
    help="Provide prefix for TDirectory holding histograms such as 'prefit_' or postfin_'.  Default is '' and will search in CHANNEL_0jet, CHANNEL_boosted, CHANNEL_VBF")
parser.add_argument(
    "--var",
    type=str,
    action="store",
    dest="variable",
    default="m_t_CollinearMass",
    help="Which variable")
parser.add_argument(
    "--higgsSF",
    type=int,
    action="store",
    dest="higgsSF",
    default=10,
    help="Provide the Scale Factor for the SM-Higgs signals.  10x is default")
parser.add_argument(
    "--higgsSFSM",
    type=int,
    action="store",
    dest="higgsSFSM",
    default=1,
    help="Provide the Scale Factor for the SM-Higgs signals.  10x is default")
parser.add_argument(
    "--inputFile",
    action="store",
    dest="inputFile",
    help="Provide the relative path to the target input file")
parser.add_argument(
    "--blind",
    type=int,
    action="store",
    dest="blind",
    default=1,
    help="Do you want to force blinding?")
args = parser.parse_args()


varnames={}
varnames['mPt']='#mu p_{T} [GeV]'
varnames['tPt']='#tau p_{T} [GeV]'
varnames['dPhiMuTau']='#Delta#phi[#mu, #tau]'
varnames['dEtaMuTau']='#Delta#eta[#mu, #tau]'
varnames['type1_pfMetEt']='E_{T}^{miss} [GeV]'
varnames['m_t_CollinearMass']='M_{col} [GeV]'
varnames['MTTauMET']='M_{T}[#tau, MET] [GeV]'
varnames['dPhiTauMET']='#Delta#phi[#tau, MET]'
varnames['j1Pt']='Jet 1 p_{T} [GeV]'
varnames['j2Pt']='Jet 2 p_{T} [GeV]'
varnames['dRMuTau']='#Delta R[#mu, #tau]'
varnames['numOfJets']='N_{jets}'
varnames['m_t_Mass']='M_{vis} [GeV]'
varnames['numOfVtx']='N_{vtx}'
varnames['vbfMass']='M_{jj} [GeV]'
varnames['MTMuMET']='M_{T}[#mu, MET] [GeV]'

variable = args.variable
channel = args.channel
higgsSF = args.higgsSF
isLog = args.isLog
prefix = args.prefix
categories = varCfgPlotter.getCategories( channel, prefix )
fileName = args.variable + '.root'
forceBlinding = args.blind

if fileName == None :
    fileName = varCfgPlotter.getFile( channel )
assert (fileName != None), "Please provide a file name"

print "\nPlotting for:"
print " -- Channel:",channel
print " -- Plot", "Log" if isLog else "Linear"
print " -- Plotting for categories:"

for cat in categories :
    print "     -- ",cat
print " -- Using Higgs Scale Factor:",higgsSF
print " -- Target file:",fileName,"\n"


file = ROOT.TFile( fileName, "r" )
print file

# Category map for the LaTeX naming of histograms
catMap = {
    "em" : "e#tau_{#mu}",
    "et" : "e#tau_{h}",
    "mt" : "#mu#tau_{h}",
    "me" : "#mu#tau_{e}",
}


def add_lumi():
    lowX=0.67
    lowY=0.855
    lumi  = ROOT.TPaveText(lowX,lowY, lowX+0.3, lowY+0.2, "NDC")
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.SetTextSize(0.06*0.65)
    lumi.SetTextFont (   42 )
    lumi.AddText("41.5 fb^{-1} (13 TeV)")
    return lumi

def add_CMS():
    lowX=0.17
    lowY=0.755
    lumi  = ROOT.TPaveText(lowX, lowY+0.06, lowX+0.15, lowY+0.16, "NDC")
    lumi.SetTextFont(61)
    lumi.SetTextSize(0.08*0.65)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("CMS")
    return lumi

def add_Preliminary():
    lowX=0.28
    lowY=0.755
    lumi  = ROOT.TPaveText(lowX, lowY+0.05, lowX+0.15, lowY+0.15, "NDC")
    lumi.SetTextFont(52)
    lumi.SetTextSize(0.08*0.8*0.76*0.65)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("Preliminary")
    return lumi

def make_legend():
    if isLog and 'dPhi' in variable and 'MET' in variable:
        output = ROOT.TLegend(0.12, 0.05, 0.92, 0.25, "", "brNDC")
        output.SetNColumns(5)
    else:
        output = ROOT.TLegend(0.42, 0.60, 0.92, 0.90, "", "brNDC")
        output.SetNColumns(2)
    output.SetLineWidth(0)
    output.SetLineStyle(0)
    output.SetFillStyle(0)
    #output.SetFillColor(0)
    output.SetBorderSize(0)
    output.SetTextFont(62)
    return output

# Can use to return all hists in a dir
def get_Keys_Of_Class( file_, class_ ) :
    keys = []
    allKeys = file_.GetListOfKeys()

    for k in allKeys :
        if k.GetClassName() == class_ :
            keys.append( k )

    return keys

# Make systematic error
def make_syserr(hists, bkgs):
    hist_int = {}
    tot_int = 0
    sys_err = 0
    errorBand = hists["ZTT"].Clone()
    for bkg in bkgs :
        tot_int = tot_int + hists[bkg].Integral()
        hist_int[bkg] = hists[bkg].Integral()
        if bkg == "SMH" :
             hists[ bkg ].Scale(higgsSFSM)
        if bkg == "ZTT" : continue
        errorBand.Add(hists[bkg])

    for bkg in bkgs :
        if bkg!='QCD':
            errorBand = SystematicsView.add_error(errorBand, 0.02) # Trigger uncertainty
        if bkg=='ZJ' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.04) # DY x-sec uncertainty
        elif bkg=='Diboson' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.05) # Diboson x-sec uncertainty
        elif bkg=='TT' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.06) # TTbar x-sec uncertainty
        elif bkg=='EWK' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.04) # EWK x-sec uncertainty
        elif bkg=='QCD' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.30) # QCD uncertainty
        elif bkg=='ZTT' and tot_int!=0:
            errorBand = SystematicsView.add_error(errorBand, (hist_int[bkg]/tot_int)*0.04) # Embed Selection uncertainty
        else:
            errorBand = SystematicsView.add_error(errorBand, 0)
    return errorBand


ROOT.gStyle.SetFrameLineWidth(3)
ROOT.gStyle.SetLineWidth(3)
ROOT.gStyle.SetOptStat(0)
ROOT.gROOT.SetBatch(True)
ROOT.TGaxis.SetMaxDigits(3)

c = ROOT.TCanvas("canvas","",0,0,800,800)
c.cd()

adapt = ROOT.gROOT.GetColor(12)
new_idx = ROOT.gROOT.GetListOfColors().GetSize() + 1
trans = ROOT.TColor(new_idx, adapt.GetRed(), adapt.GetGreen(),adapt.GetBlue(), "", 0.5)

infoMap = varCfgPlotter.getInfoMap( higgsSF, channel, "" )
print "infomap ", infoMap
bkgs = varCfgPlotter.getBackgrounds(channel)
print "bg ", bkgs
signals = varCfgPlotter.getSignals()
print "sig ", signals
higgsSFSM = 1

# Get list of the keys to hists in our category directory
histKeys = get_Keys_Of_Class( file, "TH1F" )

# Get nominal shapes for all processes
initHists = {}
for key in histKeys :
    if "_CMS_" in key.GetName() : continue
    # skip the higgs mass +/-
    if "120" in key.GetName() or "130" in key.GetName() : continue
    initHists[ key.GetName() ] = key.ReadObj()

# Check for a few fundamental histos
assert (initHists["data_obs"] != None), "Where's your data hist?!"

nBins = initHists["data_obs"].GetXaxis().GetNbins()
binWidth = initHists["data_obs"].GetBinWidth(1)
print nBins, binWidth

# Make the final hists, some initial shapes need to be merged
hists = {}
for name, val in infoMap.iteritems() :
    print name, val
    #hists[ name ] = ROOT.TH1F( name+cat, val[1], nBins, 0, nBins*binWidth )
    hists[ name ] = initHists["data_obs"].Clone()
    hists[ name ].Scale(0)
    #hists[ name ].Sumw2()
    for toAdd in val[0] :
        print toAdd
        if not toAdd in initHists :
            print toAdd," not in your file: %s, directory, %s" % (file, cat)
            continue
        hists[ name ].Add( initHists[ toAdd ] )

    if name not in signals :
        hists[ name ].SetFillColor(ROOT.TColor.GetColor( val[3] ) )
        hists[ name ].SetLineColor(1)

# Set aesthetics
hists["data_obs"].GetXaxis().SetTitle("")
hists["data_obs"].GetXaxis().SetTitleSize(0)
hists["data_obs"].GetXaxis().SetNdivisions(505)
hists["data_obs"].GetYaxis().SetLabelFont(42)
hists["data_obs"].GetYaxis().SetLabelOffset(0.01)
hists["data_obs"].GetYaxis().SetLabelSize(0.06*0.65)
hists["data_obs"].GetYaxis().SetTitleSize(0.09*0.65)
hists["data_obs"].GetYaxis().SetTitleOffset(0.7/0.65)
hists["data_obs"].SetTitle("")
hists["data_obs"].GetYaxis().SetTitle("Events/bin")
hists["data_obs"].SetMarkerStyle(20)
hists["data_obs"].SetMarkerSize(1)
hists["data_obs"].SetLineWidth(1)

print "data", hists["data_obs"].GetXaxis().GetXmax()
for sig in signals :
    print sig
    hists[ sig ].SetLineColor(ROOT.TColor.GetColor( infoMap[ sig ][3] ))
    hists[ sig ].SetLineWidth(5)
    #hists[ sig ].SetLineStyle(2)
    print sig, hists[sig].GetXaxis().GetXmax()

errorBand = make_syserr(hists, bkgs)

# Build our stack
stack = ROOT.THStack("stack","stack")
for bkg in bkgs :
    stack.Add( hists[bkg] )

errorBand.SetMarkerSize(0)
errorBand.SetFillColor(new_idx)
errorBand.SetFillStyle(3001)
errorBand.SetLineWidth(1)

pad1 = ROOT.TPad("pad1", "pad1", 0, 0, 1, 1)
pad1.Draw()
pad1.cd()
pad1.SetFillColor(0)
pad1.SetBorderMode(0)
pad1.SetBorderSize(10)
pad1.SetTickx(1)
pad1.SetTicky(1)
pad1.SetLeftMargin(0.14)
pad1.SetRightMargin(0.05)
pad1.SetTopMargin(0.122*0.65)
pad1.SetBottomMargin(0.35*0.35)
pad1.SetFrameFillStyle(0)
pad1.SetFrameLineStyle(0)
pad1.SetFrameLineWidth(3)
pad1.SetFrameBorderMode(0)
pad1.SetFrameBorderSize(10)
if isLog:
    pad1.SetLogy()

hists["data_obs"].GetXaxis().SetLabelSize(0)
hists["data_obs"].SetMaximum(2*max(stack.GetMaximum(),hists["data_obs"].GetMaximum()))
print stack.GetMaximum()
hists["data_obs"].SetMinimum(0.0)
if isLog:
    hists["data_obs"].SetMaximum(hists["data_obs"].GetMaximum()*5.35)
    hists["data_obs"].SetMinimum(0.01)
for k in range(1,hists["data_obs"].GetSize()-1):
    s = 0.0
    for sig in signals :
        s += hists[sig].GetBinContent(k)
    b = 0.0
    for bkg in bkgs :
        b += hists[bkg].GetBinContent(k)
    if (forceBlinding>0 and s/(0.0000001+s+b)**0.5 > 0.2):
        hists["data_obs"].SetBinContent(k,100000000)
        hists["data_obs"].SetBinError(k,100000000)

hists["data_obs"].Draw("ep")
stack.Draw("histsame")
errorBand.Draw("e2same")
for sig in signals :
    hists[ sig ].Scale(higgsSF)
    hists[ sig ].Draw("esame")

hists["data_obs"].GetXaxis().SetTitle(varnames[variable])
hists["data_obs"].GetXaxis().SetLabelSize(0.08*0.35)
hists["data_obs"].GetXaxis().SetNdivisions(505)
hists["data_obs"].GetXaxis().SetTitleSize(0.16*0.35)
hists["data_obs"].GetXaxis().SetTitleOffset(1.04)
hists["data_obs"].GetXaxis().SetLabelSize(0.11*0.35)
hists["data_obs"].GetXaxis().SetTitleFont(42)

hists["data_obs"].Draw("esame")

legend = make_legend()
for name, val in infoMap.iteritems() :
    legend.AddEntry(hists[name], val[1], val[2])
legend.AddEntry(errorBand,"Bkg. unc.","f")
legend.Draw()

l1 = add_lumi()
l1.Draw("same")
l2 = add_CMS()
l2.Draw("same")
l3 = add_Preliminary()
l3.Draw("same")

pad1.RedrawAxis()

categ  = ROOT.TPaveText(0.17, 0.73, 0.45, 0.73+0.155, "NDC")
categ.SetBorderSize(   0 )
categ.SetFillStyle(    0 )
categ.SetTextAlign(   12 )
categ.SetTextSize ( 0.06*0.65 )
categ.SetTextColor(    1 )
categ.SetTextFont (   42 )
categ.AddText(catMap[channel])
categ.Draw("same")

c.cd()
pad1.Draw()

ROOT.gPad.RedrawAxis()

c.Modified()
if not os.path.exists( 'plots' ) : os.makedirs( 'plots' )
if isLog:
    c.SaveAs("plots/log_"+cat+".pdf")
    c.SaveAs("plots/log_"+cat+".png")
else:
    c.SaveAs("plots/"+variable+".pdf")
    c.SaveAs("plots/"+variable+".png")


for bkg in bkgs:
    print bkg,hists[bkg].Integral()

for sig in signals:
    print sig,hists[sig].Integral()
