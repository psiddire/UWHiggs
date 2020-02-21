import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles
import os
import ROOT
import glob
import logging
import sys
import Lists
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

for x in Lists.mc_samples_W:
    print x
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuTauWJets/%s' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

for j in Lists.jet:
    s1 = 'TightWOS'+j
    s2 = 'TauLooseWOS'+j
    s3 = 'MuonLooseWOS'+j
    s4 = 'MuonLooseTauLooseWOS'+j

    outputdir = 'plots/%s/AnalyzeMuTauWJets/2016SelectionsDeepWJets/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY'), Lists.mc_samples_W)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DY = views.StyleView(DYall, **Lists.remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, "Z#rightarrow#tau#tau/#mu#mu/ee")

    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , Lists.mc_samples_W)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWK = views.StyleView(EWKall, **Lists.remove_name_entry(data_styles['W*Jets*']))
    EWK = views.TitleView(EWK, "EWKW/Z")

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , Lists.mc_samples_W)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMH = views.StyleView(SMHall, **Lists.remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, "SM Higgs")

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), Lists.mc_samples_W)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TT = views.StyleView(TTall, **Lists.remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, "t#bar{t},t+jets")

    Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), Lists.mc_samples_W)])
    Dibosonall = views.SubdirectoryView(Dibosontotal, s1)
    Diboson = views.StyleView(Dibosonall, **Lists.remove_name_entry(data_styles['WZ*']))
    Diboson = views.TitleView(Diboson, "Diboson")

    #data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples_W)])
    #fakesTau = views.SubdirectoryView(data_view, s2)
    #fakesMuon = views.SubdirectoryView(data_view, s3)
    #fakesTauMuon = views.SubdirectoryView(data_view, s4)
    #fakesMT = views.SumView(fakesTau, fakesMuon)
    #fakesData = SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True)
    #mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples_W)])
    #fakesMCTau = views.SubdirectoryView(mc_view, s2)
    #fakesMCMuon = views.SubdirectoryView(mc_view, s3)
    #fakesMCTauMuon = views.SubdirectoryView(mc_view, s4)
    #fakesMCMT = views.SumView(fakesMCTau, fakesMCMuon)
    #fakesMC = SubtractionView(fakesMCMT, fakesMCTauMuon, restrict_positive=True)
    #QCD = views.StyleView(SubtractionView(fakesData, fakesMC, restrict_positive=True), **Lists.remove_name_entry(data_styles['QCD*']))
    #QCD = views.TitleView(QCD, "W/QCD")

    Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'JetsToLNu' in x, Lists.mc_samples_W)])
    Wall = views.SubdirectoryView(Wtotal, s1)
    W = views.StyleView(Wall, **Lists.remove_name_entry(data_styles['QCD*']))
    W = views.TitleView(W, "W+Jets")

    vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , Lists.mc_samples_W)]), **Lists.remove_name_entry(data_styles['VBF_LFV*']))
    ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , Lists.mc_samples_W)]), **Lists.remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHMT']={'view' : vbfHMT }
    plotter.views['ggHMT']={'view' : ggHMT }
    plotter.views['DY']={'view' : DY }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    #plotter.views['QCD']={'view' : QCD }
    plotter.views['W']={'view' : W }
    plotter.views['Diboson']={'view' : Diboson }

    #plotter.mc_samples = ['QCD', 'Diboson', 'TT', 'EWK', 'DY', 'SMH']
    plotter.mc_samples = ['W', 'Diboson', 'TT', 'EWK', 'DY', 'SMH']

    foldername = ['']

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)
        for n,h in enumerate(Lists.wjhisto):
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, year='2016', channel='mutauh')
            plotter.save(h[0])
