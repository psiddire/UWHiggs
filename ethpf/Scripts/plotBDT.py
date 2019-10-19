import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles
import os
import ROOT
import glob
import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
from FinalStateAnalysis.PlotTools.MegaBase import make_dirs

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

ROOT.gROOT.SetStyle('Plain')
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

jobid = os.environ['jobid']
print jobid

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*', 'data*']
files=[]
lumifiles=[]
channel = ['']

for x in mc_samples:
    print x
    files.extend(glob.glob('../results/%s/AnalyzeETauFitBDT/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

for j in jet:
    s1 = 'TightOS'+j
    s2 = 'TauLooseOS'+j
    s3 = 'EleLooseOS'+j
    s4 = 'EleLooseTauLooseOS'+j
    s1 = 'TightSS'+j
    s2 = 'TauLooseSS'+j
    s3 = 'EleLooseSS'+j
    s4 = 'EleLooseTauLooseSS'+j
    s1 = 'TightWOS'+j
    s2 = 'TauLooseWOS'+j
    s3 = 'EleLooseWOS'+j
    s4 = 'EleLooseTauLooseWOS'+j
    
    outputdir = 'plots/%s/AnalyzeETau/2017SelectionsEmbedBDTNewFake/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50'), mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DYtfakes = views.SubdirectoryView(DYtotal, s2)
    DYefakes = views.SubdirectoryView(DYtotal, s3)
    DYetfakes = views.SubdirectoryView(DYtotal, s4)
    DYet = views.SumView(DYtfakes, DYefakes)
    DYfakes = SubtractionView(DYet, DYetfakes, restrict_positive=True)
    DY = views.StyleView(SubtractionView(DYall, DYfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, 'Z#rightarrow#mu#mu/ee')

    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('embed') , mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, s1)
    embedtfakes = views.SubdirectoryView(embedtotal, s2)
    embedefakes = views.SubdirectoryView(embedtotal, s3)
    embedetfakes = views.SubdirectoryView(embedtotal, s4)
    embedet = views.SumView(embedtfakes, embedefakes)
    embedfakes = SubtractionView(embedet, embedetfakes, restrict_positive=True)
    embed = views.StyleView(SubtractionView(embedall, embedfakes, restrict_positive=True), **remove_name_entry(data_styles['DYTT*']))
    embed = views.TitleView(embed, 'Z#rightarrow#tau#tau')

    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWKtfakes = views.SubdirectoryView(EWKtotal, s2)
    EWKefakes = views.SubdirectoryView(EWKtotal, s3)
    EWKetfakes = views.SubdirectoryView(EWKtotal, s4)
    EWKet = views.SumView(EWKtfakes, EWKefakes)
    EWKfakes = SubtractionView(EWKet, EWKetfakes, restrict_positive=True)
    EWK = views.StyleView(SubtractionView(EWKall, EWKfakes, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*']))
    EWK = views.TitleView(EWK, 'EWKW/Z')

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMHtfakes = views.SubdirectoryView(SMHtotal, s2)
    SMHefakes = views.SubdirectoryView(SMHtotal, s3)
    SMHetfakes = views.SubdirectoryView(SMHtotal, s4)
    SMHet = views.SumView(SMHtfakes, SMHefakes)
    SMHfakes = SubtractionView(SMHet, SMHetfakes, restrict_positive=True)
    SMH = views.StyleView(SubtractionView(SMHall, SMHfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, 'SM Higgs')

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TTtfakes = views.SubdirectoryView(TTtotal, s2)
    TTefakes = views.SubdirectoryView(TTtotal, s3)
    TTetfakes = views.SubdirectoryView(TTtotal, s4)
    TTet = views.SumView(TTtfakes, TTefakes)
    TTfakes = SubtractionView(TTet, TTetfakes, restrict_positive=True)
    TT = views.StyleView(SubtractionView(TTall, TTfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, 't#bar{t},t+jets')

    EWKDibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    EWKDibosonall = views.SubdirectoryView(EWKDibosontotal, s1)
    EWKDibosontfakes = views.SubdirectoryView(EWKDibosontotal, s2)
    EWKDibosonefakes = views.SubdirectoryView(EWKDibosontotal, s3)
    EWKDibosonetfakes = views.SubdirectoryView(EWKDibosontotal, s4)
    EWKDibosonet = views.SumView(EWKDibosontfakes, EWKDibosonefakes)
    EWKDibosonfakes = SubtractionView(EWKDibosonet, EWKDibosonetfakes, restrict_positive=True)
    EWKDiboson = views.StyleView(SubtractionView(EWKDibosonall, EWKDibosonfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))
    EWKDiboson = views.TitleView(EWKDiboson, 'Diboson')

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(data_view, s2)
    fakesEle = views.SubdirectoryView(data_view, s3)
    fakesTauEle = views.SubdirectoryView(data_view, s4)
    fakesET = views.SumView(fakesTau, fakesEle)
    QCD = views.StyleView(SubtractionView(fakesET, fakesTauEle, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
    QCD = views.TitleView(QCD, 'W/QCD')

    vbfHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToETau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
    ggHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToETau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHET']={'view' : vbfHET }
    plotter.views['ggHET']={'view' : ggHET }
    plotter.views['DY']={'view' : DY }
    plotter.views['embed']={'view' : embed }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    plotter.views['QCD']={'view' : QCD }
    plotter.views['EWKDiboson']={'view' : EWKDiboson }

    new_mc_samples = []
    new_mc_samples.extend(['QCD', 'EWKDiboson', 'TT', 'EWK', 'DY', 'embed', 'SMH'])
    plotter.mc_samples = new_mc_samples

    histoname = [('bdtDiscriminator', 'BDT Discriminator', 1)]

    foldername = channel

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            #plotter.pad.SetLogy(True)
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToETau_M125*', 'GluGlu_LFV_HToETau_M125*'], h[0], 5, xaxis = h[1], leftside=False, xrange=[-1.0,1.0], preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, channel='etauh')
            plotter.save(h[0])
