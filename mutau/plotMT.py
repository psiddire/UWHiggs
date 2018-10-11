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
outputdir = 'plots/%s/AnalyzeMuTau/Oct11/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

s1 = 'TightWOS'
s2 = 'TauLooseWOS'
s3 = 'MuonLooseWOS'
s4 = 'MuonLooseTauLooseWOS'
#s1 = 'TightSS'
#s2 = 'TauLooseSS'
#s3 = 'MuonLooseSS'
#s4 = 'MuonLooseTauLooseSS'
#s1 = 'TightOS'
#s2 = 'TauLooseOS'
#s3 = 'MuonLooseOS'
#s4 = 'MuonLooseTauLooseOS' 

DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY') , mc_samples)])
DYall = views.SubdirectoryView(DYtotal, s1)
DYtfakes = views.SubdirectoryView(DYtotal, s2)
DYmfakes = views.SubdirectoryView(DYtotal, s3)
DYmtfakes = views.SubdirectoryView(DYtotal, s4)
DYmt = views.SumView(DYtfakes, DYmfakes)
DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
DY = views.StyleView(SubtractionView(DYall, DYfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))
DY = views.TitleView(DY, "DY")

SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)])
SMHall = views.SubdirectoryView(SMHtotal, s1)
SMHtfakes = views.SubdirectoryView(SMHtotal, s2)
SMHmfakes = views.SubdirectoryView(SMHtotal, s3)
SMHmtfakes = views.SubdirectoryView(SMHtotal, s4)
SMHmt = views.SumView(SMHtfakes, SMHmfakes)
SMHfakes = SubtractionView(SMHmt, SMHmtfakes, restrict_positive=True)
SMH = views.StyleView(SubtractionView(SMHall, SMHfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
SMH = views.TitleView(SMH, "HTT")

TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)])
TTall = views.SubdirectoryView(TTtotal, s1)
TTtfakes = views.SubdirectoryView(TTtotal, s2)
TTmfakes = views.SubdirectoryView(TTtotal, s3)
TTmtfakes = views.SubdirectoryView(TTtotal, s4)
TTmt = views.SumView(TTtfakes, TTmfakes)
TTfakes = SubtractionView(TTmt, TTmtfakes, restrict_positive=True)
TT = views.StyleView(SubtractionView(TTall, TTfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))
TT = views.TitleView(TT, "TTbar")

STtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)])
STall = views.SubdirectoryView(STtotal, s1)
STtfakes = views.SubdirectoryView(STtotal, s2)
STmfakes = views.SubdirectoryView(STtotal, s3)
STmtfakes = views.SubdirectoryView(STtotal, s4)
STmt = views.SumView(STtfakes, STmfakes)
STfakes = SubtractionView(STmt, STmtfakes, restrict_positive=True)
ST = views.StyleView(SubtractionView(STall, STfakes, restrict_positive=True), **remove_name_entry(data_styles['ST*']))
ST = views.TitleView(ST, "SingleTop")

EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, s1)
EWKDibosontfakes = views.SubdirectoryView(EWKDibosontotal, s2)
EWKDibosonmfakes = views.SubdirectoryView(EWKDibosontotal, s3)
EWKDibosonmtfakes = views.SubdirectoryView(EWKDibosontotal, s4)
EWKDibosonmt = views.SumView(EWKDibosontfakes, EWKDibosonmfakes)
EWKDibosonfakes = SubtractionView(EWKDibosonmt, EWKDibosonmtfakes, restrict_positive=True)
EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosonfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))
EWKDiboson = views.TitleView(EWKDiboson, "DiBoson")

data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('data'), mc_samples)])
fakesTau = views.SubdirectoryView(data_view, s2)
fakesMuon = views.SubdirectoryView(data_view, s3)
fakesTauMuon = views.SubdirectoryView(data_view, s4)
fakesMT = views.SumView(fakesTau, fakesMuon)
QCD = views.StyleView(SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
QCD = views.TitleView(QCD, "Fakes")

vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))
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

new_mc_samples = []
new_mc_samples.extend(['QCD', 'TT', 'ST', 'EWKDiboson', 'DY', 'SMH'])
plotter.mc_samples = new_mc_samples

histoname = [("mPt", "Muon Pt (GeV)", 1),("tPt", "Tau Pt (GeV)", 1),("mEta", "Muon Eta", 1),("tEta", "Tau Eta", 1),("mPhi", "Muon Phi", 1),("tPhi", "Tau Phi", 1),("puppiMetEt", "Puppi MET Et (GeV)", 1),("type1_pfMetEt", "Type1 MET Et (GeV)", 1),("puppiMetPhi", "Puppi MET Phi", 1),("type1_pfMetPhi", "Type1 MET Phi", 1),("m_t_Mass", "Muon + Tau Mass (GeV)", 1),("m_t_CollinearMass", "Muon + Tau Collinear Mass (GeV)", 1),("numOfJets", "Number of Jets", 1),("numOfVtx", "Number of Vertices", 1),("deltaPhiMuMET", "Delta Phi Mu MET", 1),("deltaPhiTauMET", "Delta Phi Tau MET", 1),("MTMuMET", "Muon MET Transverse Mass (GeV)", 1),("MTTauMET", "Tau MET Transverse Mass (GeV)", 1)]

foldername = channel

for fn in foldername:
    if not os.path.exists(outputdir+'/'+fn):
        os.makedirs(outputdir+'/'+fn)

    for n,h in enumerate(histoname):
        plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=False, control=s1)
        #plotter.save(fn+'/'+h[0])
        plotter.save(h[0])

