import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import os
import ROOT
import glob
import array
import Lists

ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetOptTitle(0)
jobid = os.environ['jobid']
files = []
lumifiles = []

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*',  'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*', 'embed*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuESys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuESys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesMuE.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DYJetsToLL_M-50') or x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WGToLNuG'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV'), mc_samples)])
]

for k, di in enumerate(Lists.dirs):

    #binning = array.array('d', (range(0, 50, 25) + range(50, 100, 10) + range(100, 150, 5) + range(150, 200, 10) + range(200, 300, 25)))
    d = f.mkdir(Lists.drs[k])
    d.cd()
    if di=='0Jet':
        binning = array.array('d', range(0, 300, 10))
    elif di=='1Jet':
        binning = array.array('d', range(0, 300, 10))
    elif di=='2Jet':
        binning = array.array('d', range(0, 300, 10))
    else:
        binning = array.array('d', range(0, 300, 10))

    #Observed
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    data = positivize(DataTotal.Get('TightOS'+di+'/m_e_CollinearMass'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    #Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    emball = views.SubdirectoryView(embed, 'TightOS'+di)
    emb = positivize(emball.Get('m_e_CollinearMass'))
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    #Electron Energy Scale
    for i, esSys in enumerate(Lists.escale):
        emb = positivize(emball.Get(esSys+'m_e_CollinearMass'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.escaleNames[i], binning))
    #Write Histograms
    for eSys in embSys:
        eSys.Write()

    #QCD
    qcdSys = []
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = positivize(QCD.Get('m_e_CollinearMass'))
    qcdSys.append(qcd.Rebin(len(binning)-1, 'QCD', binning))
    #QCD Systematics
    for i, qSys in enumerate(Lists.qcdSys):
        qcd = positivize(QCD.Get(qSys+'m_e_CollinearMass'))
        qcdSys.append(qcd.Rebin(len(binning)-1, Lists.qcdSysNames[i], binning))
    #Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    for i, sam in enumerate(Lists.samp):
        dySys = []
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = DY.Get('m_e_CollinearMass')
        dy = positivize(dy)
        dy = dy.Rebin(len(binning)-1, sam, binning)
        #Systematics
        for j, mSys in enumerate(Lists.mcSys):
            dy = positivize(DY.Get(mSys+'m_e_CollinearMass'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.mcSysNames[j], binning))
        #Recoil Response and Resolution
        if sam=='Zothers' or  sam=='W' or sam=='EWK' or sam=='ggH_htt' or sam=='qqH_htt' or sam=='ggH_hww' or sam=='qqH_hww' or sam=='LFVGG125' or sam=='LFVVBF125':
            for j, rSys in enumerate(Lists.recSys):
                dy = positivize(DY.Get(rSys+'m_e_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
        #DY Pt Reweighting
        if sam=='Zothers':
            for j, dSys in enumerate(Lists.dyptSys):
                dy = positivize(DY.Get(dSys+'m_e_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
        #Top Pt Reweighting
        if sam=='TT':
            for j, tSys in enumerate(Lists.ttSys):
                dy = positivize(DY.Get(tSys+'m_e_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.ttSysNames[j], binning))
        #Jet and Unclustered Energy Scale
        if sam=='WG' or sam=='vH_htt' or sam=='TT' or sam=='T' or sam=='Diboson':
            for j, jSys in enumerate(Lists.jesSys):
                dy = positivize(DY.Get(jSys+'m_e_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
        #Write Histograms
        for dSys in dySys:
            dSys.Write()
