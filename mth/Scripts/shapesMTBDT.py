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
    files.extend(glob.glob('../results/%s/AnalyzeMuTauSysBDT/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = '../plots/%s/AnalyzeMuTauSysBDT/' % (jobid)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesMTBDT.root', 'RECREATE')

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

    if di=='0Jet':
        dr = '0jet'
        binning = array.array('d', [-0.75, -0.65, -0.60, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.3])
    elif di=='1Jet':
        dr = '1jet'
        binning = array.array('d', [-0.75, -0.65, -0.60, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.3])
    elif di=='2Jet':
        dr = '2jet_gg'
        binning = array.array('d', [-0.75, -0.65, -0.60, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35])
    else:
        dr = '2jet_vbf'
        binning = array.array('d', [-0.70, -0.60, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.35])

#[-0.75, -0.65, -0.60, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.09, -0.08, -0.07, -0.06, -0.05, -0.04, -0.03, -0.02, -0.01, 0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.20, 0.30])

#[-0.55, -0.4, -0.35, -0.3, -0.29, -0.28, -0.27, -0.26, -0.25, -0.24, -0.23, -0.22, -0.21, -0.2, -0.19, -0.18, -0.17, -0.16, -0.15, -0.14, -0.13, -0.12, -0.11, -0.1, -0.09, -0.08, -0.07, -0.06, -0.05, -0.04, -0.03, -0.02, -0.01, 0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.22])

    #Observed
    d = f.mkdir(dr)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    data = positivize(DataTotal.Get('TightOS'+di+'/bdtDiscriminator'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    #Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('embed'), mc_samples)])
    emball = embed.Get('TightOS'+di+'/bdtDiscriminator')
    embtfakes = embed.Get('TauLooseOS'+di+'/bdtDiscriminator')
    embmfakes = embed.Get('MuonLooseOS'+di+'/bdtDiscriminator')
    embmtfakes = embed.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
    embfakes = embtfakes.Clone()
    embfakes.Add(embmfakes)
    embfakes.Add(embmtfakes, -1)
    embfakes = positivize(embfakes)
    emb = emball.Clone()
    emb.Add(embfakes, -1)
    emb = positivize(emb)
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    #Embed Tracking
    for i, tr in enumerate(Lists.trk):
        emb = embed.Get('TightOS'+di+tr+'/bdtDiscriminator')
        emb.Add(embfakes, -1)
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, Lists.trkNames[i], binning))
    #Tau Scale
    for i, sc in enumerate(Lists.scaleSys):
        emb = embed.Get('TightOS'+di+sc+'/bdtDiscriminator')
        emb.Add(embfakes, -1)
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][1], binning))
    #Tau Fake Rate
    for i, tFR in enumerate(Lists.tauFR):
        emb = emball.Clone()
        embf = embed.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        embmt = embed.Get('MuonLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        embf.add(embmfakes)
        embf.add(embmt, -1)
        embf = positivize(embf)
        emb.Add(embf, -1)
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.tauFRNames[i], binning))
    #Muon Fake Rate
    for i, mFR in enumerate(Lists.muonFR):
        emb = emball.Clone()
        embf = embed.Get('MuonLooseOS'+di+mFR+'/bdtDiscriminator')
        embmt = embed.Get('MuonLooseTauLooseOS'+di+mFR+'/bdtDiscriminator')
        embf.add(embtfakes)
        embf.add(embmt, -1)
        embf = positivize(embf)
        emb.add(embf, -1)
        emb = positivize(emb)
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.muonFRNames[i], binning))
    #Write Histograms
    for eSys in embSys:
        eSys.Write()

    #Fakes
    qcdSys = []
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), mc_samples)])
    tfakes = QCD.Get('TauLooseOS'+di+'/bdtDiscriminator')
    mfakes = QCD.Get('MuonLooseOS'+di+'/bdtDiscriminator')
    mtfakes = QCD.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
    qcd = tfakes.Clone()
    qcd.Add(mfakes)
    qcd.Add(mtfakes, -1)
    qcd = positivize(qcd)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes', binning))
    #Tau Fake Rate
    for i, tFR in enumerate(Lists.tauFR):
        qcd = QCD.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcd.add(mfakes)
        qcd.add(qcdmt, -1)
        qcd = positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.tauFRNames[i], binning))
    #Muon Fake Rate
    for i, mFR in enumerate(Lists.muonFR):
        qcd = QCD.Get('MuonLooseOS'+di+mFR+'/bdtDiscriminator')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+mFR+'/bdtDiscriminator')
        qcd.add(tfakes)
        qcd.add(qcdmt, -1)
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
            dy = positivize(DY.Get('TightOS'+di+'/bdtDiscriminator'))
            dySys.append(dy.Rebin(len(binning)-1, sam, binning))
            #Signal Uncertainties
            for j, sSys in enumerate(Lists.sigSys):
                dy = positivize(DY.Get('TightOS'+di+sSys+'/bdtDiscriminator'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.sigSysNames[j], binning))
        else:
            dyall = DY.Get('TightOS'+di+'/bdtDiscriminator')
            dytfakes = DY.Get('TauLooseOS'+di+'/bdtDiscriminator')
            dymfakes = DY.Get('MuonLooseOS'+di+'/bdtDiscriminator')
            dymtfakes = DY.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
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
                dy = DY.Get('TightOS'+di+bSys+'/bdtDiscriminator')
                dy.Add(dyfakes, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.bacSysNames[j], binning))
            #Recoil Uncertainty
            if sam=='Zothers' or sam=='ggH_htt' or sam=='qqH_htt' or sam=='ggH_hww' or sam=='qqH_hww' or sam=='EWK':
                for j, rSys in enumerate(Lists.recSys):
                    dy = DY.Get('TightOS'+di+rSys+'/bdtDiscriminator')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
            #DY pT Reweighting
            if sam=='Zothers':
                for j, dSys in enumerate(Lists.dyptSys):
                    dy = DY.Get('TightOS'+di+dSys+'/bdtDiscriminator')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
            #Top pT Reweighting
            if sam=='TT':
                for j, tSys in enumerate(Lists.ttSys):
                    dy = DY.Get('TightOS'+di+tSys+'/bdtDiscriminator')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.ttSysNames[j], binning))
            #Jet and Unclustered Energy Scale
            if sam=='vH_htt' or sam=='TT' or sam=='T' or sam=='Diboson':
                for j, jSys in enumerate(Lists.jesSys):
                    dy = DY.Get('TightOS'+di+jSys+'/bdtDiscriminator')
                    dy.Add(dyfakes, -1)
                    dy = positivize(dy)
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
            #Tau Fake Rate
            for j, tFR in enumerate(Lists.tauFR):
                dy = dyall.Clone()
                dyf = DY.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
                dymt = DY.Get('MuonLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
                dyf.add(dymfakes)
                dyf.add(dymt, -1)
                dyf = positivize(dyf)
                dy.add(dyf, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.tauFRNames[j], binning))
            #Muon Fake Rate
            for j, mFR in enumerate(Lists.muonFR):
                dy = dyall.Clone()
                dyf = DY.Get('MuonLooseOS'+di+mFR+'/bdtDiscriminator')
                dymt = DY.Get('MuonLooseTauLooseOS'+di+mFR+'/bdtDiscriminator')
                dyf.add(dytfakes)
                dyf.add(dymt, -1)
                dyf = positivize(dyf)
                dy.add(dyf, -1)
                dy = positivize(dy)
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.muonFRNames[j], binning))
        #Write Histograms
        for dSys in dySys:
            dSys.Write()
