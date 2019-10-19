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

mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*', 'data*']

for x in mc_samples:
    files.extend(glob.glob('../results/%s/AnalyzeMuTauSys/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuTauSys/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesMTNoEmbFakes.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY1') or x.startswith('DY2') or x.startswith('DY3') or x.startswith('DY4') or x.startswith('DYJetsToLL_M-50') or x.startswith('DYJetsToLL_M-10to50'), mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV') , mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV') , mc_samples)])
]

for di in Lists.dirs:

    # binning = array.array('d', (range(0, 50, 25) + range(50, 100, 10) + range(100, 150, 5) + range(150, 200, 10) + range(200, 300, 25)))
    if di=='0Jet':
        dr = '0jet'
        binning = array.array('d', range(0, 300, 10))
    elif di=='1Jet':
        dr = '1jet'
        binning = array.array('d', range(0, 300, 10))
    elif di=='2Jet':
        dr = '2jet_gg'
        binning = array.array('d', range(0, 300, 10))
    else:
        dr = '2jet_vbf'
        binning = array.array('d', range(0, 300, 10))

    #Observed
    d = f.mkdir(dr)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    data = positivize(DataTotal.Get('TightOS'+di+'/m_t_CollinearMass'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    #Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    emb = embed.Get('TightOS'+di+'/m_t_CollinearMass')
    embtfakes = embed.Get('TauLooseOS'+di+'/m_t_CollinearMass')
    embmfakes = embed.Get('MuonLooseOS'+di+'/m_t_CollinearMass')
    embmtfakes = embed.Get('MuonLooseTauLooseOS'+di+'/m_t_CollinearMass')
    embfakes = embtfakes.Clone()
    embfakes.Add(embmfakes)
    embfakes.Add(embmtfakes, -1)
    embfakes = positivize(embfakes)
    emb = positivize(emb)
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    #Embed Tracking
    for i, tr in enumerate(Lists.trk):
        emb = embed.Get('TightOS'+di+tr+'/m_t_CollinearMass')
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, Lists.trkNames[i], binning))
    #Tau Scale
    for i, sc in enumerate(Lists.scaleSys):
        emb = embed.Get('TightOS'+di+sc+'/m_t_CollinearMass')
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][1], binning))
    #Write Histograms
    for eSys in embSys:
        eSys.Write()

    #Fakes
    qcdSys = []
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    tfakes = QCD.Get('TauLooseOS'+di+'/m_t_CollinearMass')
    mfakes = QCD.Get('MuonLooseOS'+di+'/m_t_CollinearMass')
    mtfakes = QCD.Get('MuonLooseTauLooseOS'+di+'/m_t_CollinearMass')
    qcd = tfakes.Clone()
    qcd.Add(mfakes)
    qcd.Add(mtfakes, -1)
    qcd.Add(embfakes, -1)
    qcd = positivize(qcd)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes', binning))
    #Tau Fake Rate
    for i, tFR in enumerate(Lists.tauFR):
        qcd = QCD.Get('TauLooseOS'+di+tFR+'/m_t_CollinearMass')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+tFR+'/m_t_CollinearMass')
        qcd.add(mfakes)
        qcd.add(qcdmt, -1)
        embt = embed.Get('TauLooseOS'+di+tFR+'/m_t_CollinearMass')
        embm = embed.Get('MuonLooseOS'+di+'/m_t_CollinearMass')
        embmt = embed.Get('MuonLooseTauLooseOS'+di+tFR+'/m_t_CollinearMass')
        embf = embt.Clone()
        embf.Add(embm)
        embf.Add(embmt, -1)
        embf = positivize(embf)
        qcd.Add(embf, -1)
        qcd = positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.tauFRNames[i], binning))
    #Muon Fake Rate
    for i, mFR in enumerate(Lists.muonFR):
        qcd = QCD.Get('MuonLooseOS'+di+mFR+'/m_t_CollinearMass')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+mFR+'/m_t_CollinearMass')
        qcd.add(tfakes)
        qcd.add(qcdmt, -1)
        embt = embed.Get('TauLooseOS'+di+'/m_t_CollinearMass')
        embm = embed.Get('MuonLooseOS'+di+mFR+'/m_t_CollinearMass')
        embmt = embed.Get('MuonLooseTauLooseOS'+di+mFR+'/m_t_CollinearMass')
        embf = embt.Clone()
        embf.Add(embm)
        embf.Add(embmt, -1)
        embf = positivize(embf)
        qcd.Add(embf, -1)
        qcd = positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.muonFRNames[i], binning))
    #Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    #Monte Carlo
    for i, sam in enumerate(Lists.samp):
        print sam
        DY = v[i]
        dySys = []
        if sam=='LFVGG125' or sam=='LFVVBF125':
            dy = positivize(DY.Get('TightOS'+di+'/m_t_CollinearMass'))
            dySys.append(dy.Rebin(len(binning)-1, sam, binning))
            #Signal Uncertainties
            for j, sSys in enumerate(Lists.sigSys):
                dy = positivize(DY.Get('TightOS'+di+sSys+'/m_t_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.sigSysNames[j], binning))
        else:
            dyall = DY.Get('TightOS'+di+'/m_t_CollinearMass')
            dytfakes = DY.Get('TauLooseOS'+di+'/m_t_CollinearMass')
            dymfakes = DY.Get('MuonLooseOS'+di+'/m_t_CollinearMass')
            dymtfakes = DY.Get('MuonLooseTauLooseOS'+di+'/m_t_CollinearMass')
            dyfakes = dytfakes.Clone()
            dyfakes.Add(dymfakes)
            dyfakes.Add(dymtfakes, -1)
            dyfakes = positivize(dyfakes)
            dy = dyall.Clone()
            dy.Add(dyfakes, -1)
            dy = positivize(dy)
            dySys.append(dy.Rebin(len(binning)-1, sam, binning))
            #Pileup, Prefiring, Lepton Faking Tau, Scale
            for j, bSys in enumerate(Lists.bacSys):
                dy = DY.Get('TightOS'+di+bSys+'/m_t_CollinearMass')
                dy.Add(dyfakes, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.bacSysNames[j], binning))
            #Recoil Uncertainty
            if sam=='Zothers' or sam=='ggH_htt' or sam=='qqH_htt' or sam=='ggH_hww' or sam=='qqH_hww' or sam=='EWK':
                for j, rSys in enumerate(Lists.recSys):
                    dy = DY.Get('TightOS'+di+rSys+'/m_t_CollinearMass')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
            #DY pT Reweighting
            if sam=='Zothers':
                for j, dSys in enumerate(Lists.dyptSys):
                    dy = DY.Get('TightOS'+di+dSys+'/m_t_CollinearMass')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
            #Top pT Reweighting
            if sam=='TT':
                for j, tSys in enumerate(Lists.ttSys):
                    dy = DY.Get('TightOS'+di+tSys+'/m_t_CollinearMass')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.ttSysNames[j], binning))
            #Jet and Unclustered Energy Scale
            if sam=='vH_htt' or sam=='TT' or sam=='T' or sam=='Diboson':
                for j, jSys in enumerate(Lists.jesSys):
                    dy = DY.Get('TightOS'+di+jSys+'/m_t_CollinearMass')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
            #Tau Fake Rate
            for j, tFR in enumerate(Lists.tauFR):
                dy = dyall.Clone()
                dyf = DY.Get('TauLooseOS'+di+tFR+'/m_t_CollinearMass')
                dymt = DY.Get('MuonLooseTauLooseOS'+di+tFR+'/m_t_CollinearMass')
                dyf.add(dymfakes)
                dyf.add(dymt, -1)
                dyf = positivize(dyf)
                dy.add(dyf, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.tauFRNames[j], binning))
            #Muon Fake Rate
            for j, mFR in enumerate(Lists.muonFR):
                dy = dyall.Clone()
                dyf = DY.Get('MuonLooseOS'+di+mFR+'/m_t_CollinearMass')
                dymt = DY.Get('MuonLooseTauLooseOS'+di+mFR+'/m_t_CollinearMass')
                dyf.add(dytfakes)
                dyf.add(dymt, -1)
                dyf = positivize(dyf)
                dy.add(dyf, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.muonFRNames[j], binning))
        #Write Histograms
        for dSys in dySys:
            dSys.Write()
