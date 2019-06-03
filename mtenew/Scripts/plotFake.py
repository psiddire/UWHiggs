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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*', 'data*']
files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('results/%s/AnalyzeMuEFake/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

for j in jet:
    #s1 = 'TightSS'+j
    #s2 = 'EleLooseSS'+j
    #s3 = 'MuonLooseSS'+j
    #s4 = 'MuonLooseEleLooseSS'+j
    s1 = 'TightOS'+j
    s2 = 'EleLooseOS'+j
    s3 = 'MuonLooseOS'+j
    s4 = 'MuonLooseEleLooseOS'+j 
    
    outputdir = 'plots/%s/AnalyzeMuEFake/ElFakesNewIso/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') , mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DYefakes = views.SubdirectoryView(DYtotal, s2)
    #DYmfakes = views.SubdirectoryView(DYtotal, s3)
    #DYmefakes = views.SubdirectoryView(DYtotal, s4)
    #DYme = views.SumView(DYefakes, DYmfakes)
    #DYfakes = SubtractionView(DYme, DYmefakes, restrict_positive=True)
    #DY = views.StyleView(SubtractionView(DYall, DYfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))
    DY = views.StyleView(SubtractionView(DYall, DYefakes, restrict_positive=True), **remove_name_entry(data_styles['DY*'])) 
    DY = views.TitleView(DY, "Zll")

    DYlowtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DYJetsToLL_M-10to50') , mc_samples)])
    DYlowall = views.SubdirectoryView(DYlowtotal, s1)
    DYlowefakes = views.SubdirectoryView(DYlowtotal, s2)
    #DYlowmfakes = views.SubdirectoryView(DYlowtotal, s3)
    #DYlowmefakes = views.SubdirectoryView(DYlowtotal, s4)
    #DYlowme = views.SumView(DYlowefakes, DYlowmfakes)
    #DYlowfakes = SubtractionView(DYlowme, DYlowmefakes, restrict_positive=True)
    #DYlow = views.StyleView(SubtractionView(DYlowall, DYlowfakes, restrict_positive=True), **remove_name_entry(data_styles['DYlow*']))
    DYlow = views.StyleView(SubtractionView(DYlowall, DYlowefakes, restrict_positive=True), **remove_name_entry(data_styles['DYlow*']))  
    DYlow = views.TitleView(DYlow, "ZllLowMass")
    
    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWKefakes = views.SubdirectoryView(EWKtotal, s2)
    #EWKmfakes = views.SubdirectoryView(EWKtotal, s3)
    #EWKmefakes = views.SubdirectoryView(EWKtotal, s4)
    #EWKme = views.SumView(EWKefakes, EWKmfakes)
    #EWKfakes = SubtractionView(EWKme, EWKmefakes, restrict_positive=True)
    #EWK = views.StyleView(SubtractionView(EWKall, EWKfakes, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*']))
    EWK = views.StyleView(SubtractionView(EWKall, EWKefakes, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*'])) 
    EWK = views.TitleView(EWK, "EWK")

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMHefakes = views.SubdirectoryView(SMHtotal, s2)
    #SMHmfakes = views.SubdirectoryView(SMHtotal, s3)
    #SMHmefakes = views.SubdirectoryView(SMHtotal, s4)
    #SMHme = views.SumView(SMHefakes, SMHmfakes)
    #SMHfakes = SubtractionView(SMHme, SMHmefakes, restrict_positive=True)
    #SMH = views.StyleView(SubtractionView(SMHall, SMHfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.StyleView(SubtractionView(SMHall, SMHefakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, "SMH")

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TTefakes = views.SubdirectoryView(TTtotal, s2)
    #TTmfakes = views.SubdirectoryView(TTtotal, s3)
    #TTmefakes = views.SubdirectoryView(TTtotal, s4)
    #TTme = views.SumView(TTefakes, TTmfakes)
    #TTfakes = SubtractionView(TTme, TTmefakes, restrict_positive=True)
    #TT = views.StyleView(SubtractionView(TTall, TTfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))
    TT = views.StyleView(SubtractionView(TTall, TTefakes, restrict_positive=True), **remove_name_entry(data_styles['TT*'])) 
    TT = views.TitleView(TT, "TTbar")

    STtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)])
    STall = views.SubdirectoryView(STtotal, s1)
    STefakes = views.SubdirectoryView(STtotal, s2)
    #STmfakes = views.SubdirectoryView(STtotal, s3)
    #STmefakes = views.SubdirectoryView(STtotal, s4)
    #STme = views.SumView(STefakes, STmfakes)
    #STfakes = SubtractionView(STme, STmefakes, restrict_positive=True)
    #ST = views.StyleView(SubtractionView(STall, STfakes, restrict_positive=True), **remove_name_entry(data_styles['ST*']))
    ST = views.StyleView(SubtractionView(STall, STefakes, restrict_positive=True), **remove_name_entry(data_styles['ST*']))
    ST = views.TitleView(ST, "SingleTop")

    EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, s1)
    EWKDibosonefakes = views.SubdirectoryView(EWKDibosontotal, s2)
    #EWKDibosonmfakes = views.SubdirectoryView(EWKDibosontotal, s3)
    #EWKDibosonmefakes = views.SubdirectoryView(EWKDibosontotal, s4)
    #EWKDibosonme = views.SumView(EWKDibosonefakes, EWKDibosonmfakes)
    #EWKDibosonfakes = SubtractionView(EWKDibosonme, EWKDibosonmefakes, restrict_positive=True)
    #EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosonfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))
    EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosonefakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*'])) 
    EWKDiboson = views.TitleView(EWKDiboson, "DiBoson")

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesEle = views.SubdirectoryView(data_view, s2)
    #fakesMuon = views.SubdirectoryView(data_view, s3)
    #fakesEleMuon = views.SubdirectoryView(data_view, s4)
    #fakesME = views.SumView(fakesEle, fakesMuon)
    #QCD = views.StyleView(SubtractionView(fakesME, fakesEleMuon, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
    QCD = views.StyleView(SubtractionView(fakesEle, restrict_positive=True), **remove_name_entry(data_styles['QCD*'])) 
    QCD = views.TitleView(QCD, "Fakes")

    vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
    ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHMT']={'view' : vbfHMT }
    plotter.views['ggHMT']={'view' : ggHMT }
    plotter.views['DY']={'view' : DY }
    plotter.views['DYlow']={'view' : DYlow }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    plotter.views['ST']={'view' : ST }
    plotter.views['QCD']={'view' : QCD }
    plotter.views['EWKDiboson']={'view' : EWKDiboson }

    new_mc_samples = []
    new_mc_samples.extend(['QCD', 'DY', 'TT', 'ST', 'EWKDiboson', 'EWK', 'DYlow', 'SMH'])
    plotter.mc_samples = new_mc_samples

    histoname = [("mPt", "Muon  Pt (GeV)", 1),("ePt", "Electron Pt (Gev)", 1),("mEta", "Muon Eta", 1),("eEta", "Electron Eta", 1),("mPhi", "Muon Phi", 2),("ePhi", "Electron Phi", 1),("type1_pfMetEt", "Type1 MET Et", 1),("type1_pfMetPhi", "Type1 MET Phi", 1),("m_e_Mass", "Muon + Electron Mass (GeV)", 1),("m_e_CollinearMass", "Muon + Electron Collinear Mass (GeV)", 1),("numOfJets", "Number of Jets", 1),("numOfVtx", "Number of Vertices", 1),("dEtaMuE", "Delta Eta Mu E", 1),("dPhiEMET", "Delta Phi E MET", 1),("dPhiMuMET", "Delta Phi Mu MET", 1),("dPhiMuE", "Delta Phi Mu E", 1),("MTEMET", "Electron MET Transverse Mass (GeV)", 1),("MTMuMET", "Mu MET Transverse Mass (GeV)", 1)]

    foldername = channel

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            #plotter.pad.SetLogy(True)
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, channel='e')
            plotter.save(h[0])

