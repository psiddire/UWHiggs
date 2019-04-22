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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'WJetsToLNu*', 'embed*', 'data*']
files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeMuTau/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

for j in jet:
    s1 = 'TightWOS'+j
    s2 = 'TauLooseWOS'+j
    s3 = 'MuonLooseWOS'+j
    s4 = 'MuonLooseTauLooseWOS'+j
    
    outputdir = 'plots/%s/AnalyzeMuTau/Mar21MTFakes/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') , mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DYtfakes = views.SubdirectoryView(DYtotal, s2)
    DY = views.StyleView(SubtractionView(DYall, DYtfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, "Zll")

    #Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WJets') , mc_samples)])
    #Wall = views.SubdirectoryView(Wtotal, s1)
    ##Wtfakes = views.SubdirectoryView(Wtotal, s2)
    ##W = views.StyleView(SubtractionView(Wall, Wtfakes, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*']))
    #W = views.StyleView(SubtractionView(Wall, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*'])) 
    #W = views.TitleView(W, "W+Jets")

    DYlowtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DYJetsToLL_M-10to50') , mc_samples)])
    DYlowall = views.SubdirectoryView(DYlowtotal, s1)
    DYlowtfakes = views.SubdirectoryView(DYlowtotal, s2)
    DYlow = views.StyleView(SubtractionView(DYlowall, DYlowtfakes, restrict_positive=True), **remove_name_entry(data_styles['DYlow*']))
    DYlow = views.TitleView(DYlow, "ZllLowMass")
    
    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('embed') , mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, s1)
    embedtfakes = views.SubdirectoryView(embedtotal, s2)
    embed = views.StyleView(SubtractionView(embedall, embedtfakes, restrict_positive=True), **remove_name_entry(data_styles['DYTT*']))
    embed = views.TitleView(embed, "ZttEmbedded")

    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWKtfakes = views.SubdirectoryView(EWKtotal, s2)
    EWK = views.StyleView(SubtractionView(EWKall, EWKtfakes, restrict_positive=True), **remove_name_entry(data_styles['WG*']))
    EWK = views.TitleView(EWK, "EWK")

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMHtfakes = views.SubdirectoryView(SMHtotal, s2)
    SMH = views.StyleView(SubtractionView(SMHall, SMHtfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, "SMH")

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TTtfakes = views.SubdirectoryView(TTtotal, s2)
    TT = views.StyleView(SubtractionView(TTall, TTtfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, "TTbar")

    STtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)])
    STall = views.SubdirectoryView(STtotal, s1)
    STtfakes = views.SubdirectoryView(STtotal, s2)
    ST = views.StyleView(SubtractionView(STall, STtfakes, restrict_positive=True), **remove_name_entry(data_styles['ST*']))
    ST = views.TitleView(ST, "SingleTop")

    EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, s1)
    EWKDibosontfakes = views.SubdirectoryView(EWKDibosontotal, s2)
    EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosontfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))
    EWKDiboson = views.TitleView(EWKDiboson, "DiBoson")

    #data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    #fakesTau = views.SubdirectoryView(data_view, s2)
    #QCD = views.StyleView(SubtractionView(fakesTau, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
    #QCD = views.TitleView(QCD, "Fakes")

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(data_view, s2)
    fakesMuon = views.SubdirectoryView(data_view, s3)
    fakesTauMuon = views.SubdirectoryView(data_view, s4)
    fakesMT = views.SumView(fakesTau, fakesMuon)
    QCD = views.StyleView(SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
    QCD = views.TitleView(QCD, "Fakes")

    vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
    ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHMT']={'view' : vbfHMT }
    plotter.views['ggHMT']={'view' : ggHMT }
    plotter.views['DY']={'view' : DY }
    plotter.views['DYlow']={'view' : DYlow }
    plotter.views['embed']={'view' : embed }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    plotter.views['ST']={'view' : ST }
    plotter.views['QCD']={'view' : QCD }
    #plotter.views['W']={'view' : W }  
    plotter.views['EWKDiboson']={'view' : EWKDiboson }

    new_mc_samples = []
    new_mc_samples.extend(['QCD', 'embed', 'DY', 'TT', 'ST', 'EWKDiboson', 'EWK', 'DYlow', 'SMH'])
    plotter.mc_samples = new_mc_samples

    histoname = [("mPt", "Muon Pt (GeV)", 1),("tPt", "Tau Pt (GeV)", 1),("mEta", "Muon Eta", 1),("tEta", "Tau Eta", 1),("mPhi", "Muon Phi", 1),("tPhi", "Tau Phi", 1),("puppiMetEt", "Puppi MET Et (GeV)", 1),("type1_pfMetEt", "Type1 MET Et", 1),("puppiMetPhi", "Puppi MET Phi", 1),("type1_pfMetPhi", "Type1 MET Phi", 1),("m_t_Mass", "Muon + Tau Mass (GeV)", 1),("m_t_CollinearMass", "Muon + Tau Collinear Mass (GeV)", 1),("numOfJets", "Number of Jets", 1),("numOfVtx", "Number of Vertices", 1),("dEtaMuTau", "Delta Eta Mu Tau", 1),("dPhiMuMET", "Delta Phi Mu MET", 1),("dPhiTauMET", "Delta Phi Tau MET", 1),("dPhiMuTau", "Delta Phi Mu Tau", 1),("MTMuMET", "Muon MET Transverse Mass (GeV)", 1),("MTTauMET", "Tau MET Transverse Mass (GeV)", 1)]

    foldername = channel

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            #plotter.pad.SetLogy(True)
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=False, control=s1, jets=j)
            plotter.save(h[0])

