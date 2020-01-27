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

ROOT.gROOT.SetStyle("Plain")
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
    files.extend(glob.glob('../results/%s/AnalyzeMuTauSysBDT/%s' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

period = '13TeV'
sqrts = 13

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

for j in jet:
    s1 = 'TightOS'+j
    s2 = 'TauLooseOS'+j
    s3 = 'MuonLooseOS'+j
    s4 = 'MuonLooseTauLooseOS'+j
     
    outputdir = 'plots/%s/AnalyzeMuTauSysBDT/2017SelectionsEmbedSysBDT/%s/' % (jobid, s1)
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = Plotter(files, lumifiles, outputdir)

    DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50'), mc_samples)])
    DYall = views.SubdirectoryView(DYtotal, s1)
    DYtfakes = views.SubdirectoryView(DYtotal, s2)
    DYmfakes = views.SubdirectoryView(DYtotal, s3)
    DYmtfakes = views.SubdirectoryView(DYtotal, s4)
    DYmt = views.SumView(DYtfakes, DYmfakes)
    DYfakes = SubtractionView(DYmt, DYmtfakes, restrict_positive=True)
    DY = views.StyleView(SubtractionView(DYall, DYfakes, restrict_positive=True), **remove_name_entry(data_styles['DY*']))
    DY = views.TitleView(DY, "Z#rightarrow#mu#mu/ee")

    embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('embed') , mc_samples)])
    embedall = views.SubdirectoryView(embedtotal, s1)
    embedtfakes = views.SubdirectoryView(embedtotal, s2)
    embedmfakes = views.SubdirectoryView(embedtotal, s3)
    embedmtfakes = views.SubdirectoryView(embedtotal, s4)
    embedmt = views.SumView(embedtfakes, embedmfakes)
    embedfakes = SubtractionView(embedmt, embedmtfakes, restrict_positive=True)
    embed = views.StyleView(SubtractionView(embedall, embedfakes, restrict_positive=True), **remove_name_entry(data_styles['DYTT*']))
    embed = views.TitleView(embed, "Z#rightarrow#tau#tau")

    EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , mc_samples)])
    EWKall = views.SubdirectoryView(EWKtotal, s1)
    EWKtfakes = views.SubdirectoryView(EWKtotal, s2)
    EWKmfakes = views.SubdirectoryView(EWKtotal, s3)
    EWKmtfakes = views.SubdirectoryView(EWKtotal, s4)
    EWKmt = views.SumView(EWKtfakes, EWKmfakes)
    EWKfakes = SubtractionView(EWKmt, EWKmtfakes, restrict_positive=True)
    EWK = views.StyleView(SubtractionView(EWKall, EWKfakes, restrict_positive=True), **remove_name_entry(data_styles['W*Jets*']))
    EWK = views.TitleView(EWK, "EWKW/Z")

    SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , mc_samples)])
    SMHall = views.SubdirectoryView(SMHtotal, s1)
    SMHtfakes = views.SubdirectoryView(SMHtotal, s2)
    SMHmfakes = views.SubdirectoryView(SMHtotal, s3)
    SMHmtfakes = views.SubdirectoryView(SMHtotal, s4)
    SMHmt = views.SumView(SMHtfakes, SMHmfakes)
    SMHfakes = SubtractionView(SMHmt, SMHmtfakes, restrict_positive=True)
    SMH = views.StyleView(SubtractionView(SMHall, SMHfakes, restrict_positive=True), **remove_name_entry(data_styles['*HToTauTau*']))
    SMH = views.TitleView(SMH, "SM Higgs")

    TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), mc_samples)])
    TTall = views.SubdirectoryView(TTtotal, s1)
    TTtfakes = views.SubdirectoryView(TTtotal, s2)
    TTmfakes = views.SubdirectoryView(TTtotal, s3)
    TTmtfakes = views.SubdirectoryView(TTtotal, s4)
    TTmt = views.SumView(TTtfakes, TTmfakes)
    TTfakes = SubtractionView(TTmt, TTmtfakes, restrict_positive=True)
    TT = views.StyleView(SubtractionView(TTall, TTfakes, restrict_positive=True), **remove_name_entry(data_styles['TT*']))
    TT = views.TitleView(TT, "t#bar{t},t+jets")

    Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)])
    Dibosonall = views.SubdirectoryView(Dibosontotal, s1)
    Dibosontfakes = views.SubdirectoryView(Dibosontotal, s2)
    Dibosonmfakes = views.SubdirectoryView(Dibosontotal, s3)
    Dibosonmtfakes = views.SubdirectoryView(Dibosontotal, s4)
    Dibosonmt = views.SumView(Dibosontfakes, Dibosonmfakes)
    Dibosonfakes = SubtractionView(Dibosonmt, Dibosonmtfakes, restrict_positive=True)
    Diboson = views.StyleView(SubtractionView(Dibosonall, Dibosonfakes, restrict_positive=True), **remove_name_entry(data_styles['WZ*']))
    Diboson = views.TitleView(Diboson, "Diboson")

    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    fakesTau = views.SubdirectoryView(data_view, s2)
    fakesMuon = views.SubdirectoryView(data_view, s3)
    fakesTauMuon = views.SubdirectoryView(data_view, s4)
    fakesMT = views.SumView(fakesTau, fakesMuon)
    QCD = views.StyleView(SubtractionView(fakesMT, fakesTauMuon, restrict_positive=True), **remove_name_entry(data_styles['QCD*']))
    QCD = views.TitleView(QCD, "W/QCD")

    vbfHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['VBF_LFV*']))
    ggHMT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToMuTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGlu_LFV*']))

    plotter.views['vbfHMT']={'view' : vbfHMT }
    plotter.views['ggHMT']={'view' : ggHMT }
    plotter.views['DY']={'view' : DY }
    plotter.views['embed']={'view' : embed }
    plotter.views['EWK']={'view' : EWK }
    plotter.views['SMH']={'view' : SMH }
    plotter.views['TT']={'view' : TT }
    plotter.views['QCD']={'view' : QCD }
    plotter.views['Diboson']={'view' : Diboson }

    new_mc_samples = []
    new_mc_samples.extend(['QCD', 'Diboson', 'TT', 'EWK', 'DY', 'embed', 'SMH'])
    plotter.mc_samples = new_mc_samples

    histoname = [("bdtDiscriminator", "BDT Discriminator", 1)]

    foldername = channel

    for fn in foldername:
        if not os.path.exists(outputdir+'/'+fn):
            os.makedirs(outputdir+'/'+fn)

        for n,h in enumerate(histoname):
            plotter.plot_mc_vs_data(fn, ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 1, xaxis = h[1], leftside=False, xrange=[-0.7,0.4], preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, year='2016', channel='mutauh')
            plotter.save(h[0])
