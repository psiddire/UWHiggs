import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles, colors
from FinalStateAnalysis.PlotTools.decorators import memo
from optparse import OptionParser
import os
import ROOT
import glob
import math
import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
from fnmatch import fnmatch
from yellowhiggs import xs, br, xsbr
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs
from os import listdir
from os.path import isfile, join

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

mc_samples = [
    'DYJetsToLL*',
    'DY1JetsToLL*',
    'DY2JetsToLL*',
    'DY3JetsToLL*',
    'DY4JetsToLL*',
#    'WJetsToLNu*',
#    'W1JetsToLNu*',
#    'W2JetsToLNu*',
#    'W3JetsToLNu*',
#    'W4JetsToLNu*',
    'GluGlu_LFV*',
    'VBF_LFV*',
    'GluGluHToTauTau*',
    'VBFHToTauTau*',
    'WminusHToTauTau*',
    'WplusHToTauTau*',
    'ttHToTauTau*',
    'ZHToTauTau*',
    'TTTo2L2Nu*',
    'TTToSemiLeptonic*',
    'TTToHadronic*',
    'ST_tW_antitop*',
    'ST_tW_top*',
    'ST_t-channel_antitop*',
    'ST_t-channel_top*',
    'QCD*',
    'WZ*',
    'WW*',
    'ZZ*',
    'data*',
]
files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeMuTau/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13
outputdir = 'plots/%s/AnalyzeMuTau/Oct9/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

VBFtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  'VBF_LFV_HToMuTau' in x , mc_samples)])
VBFall = views.SubdirectoryView(VBFtotal, 'TightSS')
VBFfakes = views.SubdirectoryView(VBFtotal, 'TauLooseSS')
vbfHMT = views.StyleView(SubtractionView(VBFall, VBFfakes, restrict_positive=True), **remove_name_entry(data_styles['VBF_LFV*']))

Glutotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  'GluGlu_LFV_HToMuTau' in x , mc_samples)])
Gluall = views.SubdirectoryView(Glutotal, 'TightSS')
Glufakes = views.SubdirectoryView(Glutotal, 'TauLooseSS')
ggHMT = views.StyleView(SubtractionView(Gluall, Glufakes, restrict_positive=True), **remove_name_entry(data_styles['GluGlu_LFV*']))

DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY') , mc_samples)])
DYall = views.SubdirectoryView(DYtotal, 'TightSS')
DYtfakes = views.SubdirectoryView(DYtotal, 'TauLooseSS')
DYmfakes = views.SubdirectoryView(DYtotal, 'MuonLooseSS')
DYmtfakes = views.SubdirectoryView(DYtotal, 'MuonLooseTauLooseSS')
DYmt = views.SumView(DYtfakes, DYmfakes)
DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
DY = views.StyleView(SubtractionView(DYall, DYfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))

SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)])
SMHall = views.SubdirectoryView(SMHtotal, 'TightSS')
SMHtfakes = views.SubdirectoryView(SMHtotal, 'TauLooseSS')
SMHmfakes = views.SubdirectoryView(SMHtotal, 'MuonLooseSS')
SMHmtfakes = views.SubdirectoryView(SMHtotal, 'MuonLooseTauLooseSS')
SMHmt = views.SumView(SMHtfakes, SMHmfakes)
SMHfakes = SubtractionView(SMHmt, SMHmtfakes, restrict_positive=True)
SMH = views.StyleView(SubtractionView(SMHall, SMHfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))

TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)])
TTall = views.SubdirectoryView(TTtotal, 'TightSS')
TTtfakes = views.SubdirectoryView(TTtotal, 'TauLooseSS')
TTmfakes = views.SubdirectoryView(TTtotal, 'MuonLooseSS')
TTmtfakes = views.SubdirectoryView(TTtotal, 'MuonLooseTauLooseSS')
TTmt = views.SumView(TTtfakes, TTmfakes)
TTfakes = SubtractionView(TTmt, TTmtfakes, restrict_positive=True)
TT = views.StyleView(SubtractionView(TTall, TTfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))

STtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)])
STall = views.SubdirectoryView(STtotal, 'TightSS')
STtfakes = views.SubdirectoryView(STtotal, 'TauLooseSS')
STmfakes = views.SubdirectoryView(STtotal, 'MuonLooseSS')
STmtfakes = views.SubdirectoryView(STtotal, 'MuonLooseTauLooseSS')
STmt = views.SumView(STtfakes, STmfakes)
STfakes = SubtractionView(STmt, STmtfakes, restrict_positive=True)
ST = views.StyleView(SubtractionView(STall, STfakes, restrict_positive=True), **remove_name_entry(data_styles['ST*']))

EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, 'TightSS')
EWKDibosontfakes = views.SubdirectoryView(EWKDibosontotal, 'TauLooseSS')
EWKDibosonmfakes = views.SubdirectoryView(EWKDibosontotal, 'MuonLooseSS')
EWKDibosonmtfakes = views.SubdirectoryView(EWKDibosontotal, 'MuonLooseTauLooseSS')
EWKDibosonmt = views.SumView(EWKDibosontfakes, EWKDibosonmfakes)
EWKDibosonfakes = SubtractionView(EWKDibosonmt, EWKDibosonmtfakes, restrict_positive=True)
EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosonfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))

data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('data'), mc_samples)])
fakesTau = views.SubdirectoryView(data_view, 'TauLooseSS')
fakesMuon = views.SubdirectoryView(data_view, 'MuonLooseSS')
fakesTauMuon = views.SubdirectoryView(data_view, 'MuonLooseTauLooseSS')
fakesMT = views.SumView(fakesTau, fakesMuon)
QCD = views.StyleView(SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))


#vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
#ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))
#SMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['*HToTauTau*']))
#TT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('TT'), mc_samples)]), **remove_name_entry(data_styles['TT*']))
#ST = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('ST'), mc_samples)]), **remove_name_entry(data_styles['ST*']))
#EWKDiboson = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples )]), **remove_name_entry(data_styles['WZ*']))
#WJ = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'JetsToLNu' in x , mc_samples )] ), **remove_name_entry(data_styles['W*Jets*']))
#QCD = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('QCD'), mc_samples)]), **remove_name_entry(data_styles['QCD*']))

plotter.views['vbfHMT']={'view' : vbfHMT }
plotter.views['ggHMT']={'view' : ggHMT }
plotter.views['DY']={'view' : DY }
plotter.views['SMH']={'view' : SMH }
plotter.views['TT']={'view' : TT }
plotter.views['ST']={'view' : ST }
plotter.views['QCD']={'view' : QCD }
plotter.views['EWKDiboson']={'view' : EWKDiboson }
#plotter.views['WJ']={'view' : WJ }


new_mc_samples = []
new_mc_samples.extend(['DY', 'SMH', 'TT', 'ST', 'QCD', 'EWKDiboson'])
plotter.mc_samples = new_mc_samples

histoname = [("mPt", "Muon Pt", 1),("tPt", "Tau Pt", 1),("mEta", "Muon Eta", 1),("tEta", "Tau Eta", 1),("mPhi", "Muon Phi", 1),("tPhi", "Tau Phi", 1),("puppiMetEt", "Puppi MET Et", 1),("type1_pfMetEt", "Type1 MET Et", 1),("puppiMetPhi", "Puppi MET Phi", 1),("type1_pfMetPhi", "Type1 MET Phi", 1),("m_t_Mass", "Muon + Tau Mass", 1),("m_t_CollinearMass", "Muon + Tau Collinear Mass", 1),("numOfJets", "Number of Jets", 1),("numOfVtx", "Number of Vertices", 1),("deltaPhiMuMET", "Delta Phi Mu MET", 1),("deltaPhiTauMET", "Delta Phi Tau MET", 1),("MTMuMET", "Muon MET Transverse Mass", 1),("MTTauMET", "Tau MET Transverse Mass", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_vs_data(fn, [], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True)
        #plotter.save(fn+'/'+h[0])
        plotter.save(h[0])
#'VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'
