import ROOT
import PyCintex
from ROOT import gROOT,TStyle,TH1
import libPyROOT

gROOT.ProcessLine('.X rootlogon.C')

#libPyROOT.gROOT.ProcessLine('.L RootUtilsPyROOT.so')
#ROOT.RootUtils.PyROOTTTreePatch.Initialize(ROOT.TTree,
#                                           ROOT.TChain,
#                                           ROOT.TBranch)

#control at finer granularity
TH1.SetDefaultSumw2(False)

#Setup CMS style in moosey init
#gROOT.SetStyle('Plain')

#cmsStyle = TStyle("CMS","CMS approved plots style")
# use plain black on white colors
#cmsStyle.SetFrameBorderMode(0);
#cmsStyle.SetCanvasBorderMode(0);
#cmsStyle.SetPadBorderMode(0);
#cmsStyle.SetPadColor(0);
#cmsStyle.SetCanvasColor(0);
#cmsStyle.SetTitleColor(1);
#cmsStyle.SetStatColor(0);
#cmsStyle.SetFrameFillColor(0);

# set the paper & margin sizes
#cmsStyle.SetPaperSize(20,26);
#cmsStyle.SetPadTopMargin(0.05);
#cmsStyle.SetPadRightMargin(0.10);
#cmsStyle.SetPadBottomMargin(0.17);
#cmsStyle.SetPadLeftMargin(0.17);

# use large Times-Roman fonts
#cmsStyle.SetTextFont(132);
#cmsStyle.SetTextSize(0.08);
#cmsStyle.SetLabelFont(132,"x");
#cmsStyle.SetLabelFont(132,"y");
#cmsStyle.SetLabelFont(132,"z");
#cmsStyle.SetLabelSize(0.05,"x");
#cmsStyle.SetTitleSize(0.06,"x");
#cmsStyle.SetLabelSize(0.05,"y");
#cmsStyle.SetTitleSize(0.06,"y");
#cmsStyle.SetLabelSize(0.05,"z");
#cmsStyle.SetTitleSize(0.06,"z");

# use bold lines and markers
#cmsStyle.SetMarkerStyle(8);
#cmsStyle.SetHistLineWidth(1);
#cmsStyle.SetLineStyleString(2,"[12 12]"); # postscript dashes

# do not display any of the standard histogram decorations
#cmsStyle.SetOptTitle(1);
#cmsStyle.SetOptStat(1);
#cmsStyle.SetOptFit(1);

# put tick marks on top and RHS of plots
#cmsStyle.SetPadTickX(1);
#cmsStyle.SetPadTickY(1);

#print
#print "    For approved plots use: gROOT.SetStyle(\"CMS\");"
#print "  To add a CMS label use: CMSLabel();"
#print
#print

# restore the plain style
#gROOT.SetStyle("Plain");
#gROOT.SetStyle("CMS");

