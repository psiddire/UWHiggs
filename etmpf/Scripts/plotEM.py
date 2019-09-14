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

mc_samples = ['DYJetsToLL_M-50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'DYJetsToLL_M-10to50*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'MC*', 'embed*', 'data*']#'WJetsToLNu*'

files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('../results/%s/AnalyzeEMu/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF', '0JetCut', '1JetCut', '2JetCut', '2JetVBFCut']

for j in jet:
    s1 = 'TightOS'+j
    s2 = 'TightSS'+j
    
    outputdir = 'plots/%s/AnalyzeMuE/2017SelectionsEmbedNew/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DYJetsToLL_M-50') or x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-10to50'), mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DY = views.StyleView(DYall, **remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, "Z#rightarrow#mu#mu/ee")

    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('embed') , mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, s1)
    embed = views.StyleView(embedall, **remove_name_entry(data_styles['DYTT*']))
    embed = views.TitleView(embed, "Z#rightarrow#tau#tau")
    
    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWK = views.StyleView(EWKall, **remove_name_entry(data_styles['EWK*']))                                 
    EWK = views.TitleView(EWK, "EWKW/Z")

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x, mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMH = views.StyleView(SMHall, **remove_name_entry(data_styles['*HToTauTau*'])) 
    SMH = views.TitleView(SMH, "SM Higgs")

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TT = views.StyleView(TTall, **remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, "t#bar{t},t+jets")

    #STtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)])
    #STall = views.SubdirectoryView(STtotal, s1)
    #ST = views.StyleView(STall, **remove_name_entry(data_styles['ST*']))
    #ST = views.TitleView(ST, "SingleTop")

    EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, s1)
    EWKDiboson = views.StyleView(EWKDibosonall, **remove_name_entry(data_styles['WZ*']))
    EWKDiboson = views.TitleView(EWKDiboson, "Diboson")

    #Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') or x.startswith('WGToLNuG'), mc_samples)]) # or x.startswith('WJets')
    #Wall = views.SubdirectoryView(Wtotal, s1)
    #W = views.StyleView(Wall, **remove_name_entry(data_styles['W*Jets*']))
    #W = views.TitleView(W, "W+Jets")

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, s2)
    QCDMC = views.SubdirectoryView(mc_view, s2)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4') or x.startswith('WGToLNuG'), mc_samples)])
    W = views.SubdirectoryView(Wtotal, s1)
    QCD = views.StyleView(views.SumView(QCD, W), **remove_name_entry(data_styles['QCD*']))
    QCD = views.TitleView(QCD, "QCD")

    vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
    ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHMT']={'view' : vbfHMT }
    plotter.views['ggHMT']={'view' : ggHMT }
    plotter.views['DY']={'view' : DY }
    #plotter.views['W']={'view' : W }
    plotter.views['embed']={'view' : embed }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    #plotter.views['ST']={'view' : ST }
    plotter.views['QCD']={'view' : QCD }
    plotter.views['EWKDiboson']={'view' : EWKDiboson }

    new_mc_samples = []
    #new_mc_samples.extend(['embed', 'DY', 'TT', 'W', 'ST', 'EWKDiboson', 'EWK', 'SMH', 'QCD']) 
    new_mc_samples.extend(['QCD', 'EWKDiboson', 'TT', 'EWK', 'DY', 'embed', 'SMH']) 
    plotter.mc_samples = new_mc_samples

    histoname = [("mPt", "#mu  p_{T} (GeV)", 1),("ePt", "e p_{T} (Gev)", 1),("mEta", "#mu #eta", 1),("eEta", "e #eta", 1),("mPhi", "#mu #phi", 1),("ePhi", "e #phi", 1),("j2Pt", "Jet 2 p_{T}", 1),("j1Pt", "Jet 1 p_{T}", 1),("j2Eta", "Jet 2 #eta", 1),("j1Eta", "Jet 1 #eta", 1),("j2Phi", "Jet 2 #phi", 1),("j1Phi", "Jet 1 #phi", 1),("type1_pfMetEt", "MET (GeV)", 1),("type1_pfMetPhi", "MET #phi", 1),("e_m_Mass", "M_{vis}(e, #mu) (GeV)", 1),("e_m_CollMass", "M_{col}(e, #mu) (GeV)", 1),("numOfJets", "Number of Jets", 1),("vbfMass", "VBF Mass", 1),("numOfVtx", "Number of Vertices", 1),("dEtaEMu", "#Delta#eta(e, #mu)", 1),("dPhiEMET", "#Delta#phi(e, MET)", 1),("dPhiMuMET", "#Delta#phi(#mu, MET)", 1),("dPhiEMu", "#Delta#phi(e, #mu)", 1),("MTEMET", "M_{T}(e, MET) (GeV)", 1),("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]                                                                                                                                                                                                                                                                             

    foldername = channel

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToETau_M125*', 'GluGlu_LFV_HToETau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, channel='etaumu')
            plotter.save(h[0])
