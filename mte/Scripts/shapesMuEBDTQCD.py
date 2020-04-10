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

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuESysBDT/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'Shapes/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)
f = ROOT.TFile( outputdir+'shapesMuEBDTQCD.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY'), Lists.mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WJ') or x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW') or x.startswith('WG') or x.startswith('Wm') or x.startswith('Wp') or x.startswith('ZH'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV'), Lists.mc_samples)])
]

for k, di in enumerate(Lists.dirs):

    d = f.mkdir(Lists.drs[k])
    d.cd()
    if di=='0Jet':
        binning = array.array('d', [-0.55, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35])
    elif di=='1Jet':
        binning = array.array('d', [-0.55, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.25])
    elif di=='2Jet':
        binning = array.array('d', [-0.55, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.25])
    else:
        binning = array.array('d', [-0.55, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.3])

    # Observed
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    data = Lists.positivize(DataTotal.Get('TightOS'+di+'/bdtDiscriminator'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    # Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
    emball = views.SubdirectoryView(embed, 'TightOS'+di)
    emb = Lists.positivize(emball.Get('bdtDiscriminator'))
    h00 = emb.Clone()
    emb = emb.Rebin(len(binning)-1, 'ZTauTau', binning)
    h01 = emb.Clone()
    nom = emb.Integral()
    embSys.append(emb)
    # Electron Energy Scale
    h10 = Lists.positivize(emball.Get(Lists.escale[0]+'bdtDiscriminator'))
    h20 = Lists.positivize(emball.Get(Lists.escale[1]+'bdtDiscriminator'))
    for i in range(2):
        h11 = h10.Rebin(len(binning)-1, Lists.escaleNames[0][i], binning)
        h21 = h20.Rebin(len(binning)-1, Lists.escaleNames[1][i], binning)
        #h1, h2 = Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[0]), Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[1])
        h11, h21 = Lists.positivize(Lists.normEmb(h11, nom, Lists.escaleNames[0][i])), Lists.positivize(Lists.normEmb(h21, nom, Lists.escaleNames[1][i]))
        embSys.append(h11)
        embSys.append(h21)
    # Write Histograms
    for eSys in embSys:
        eSys.Write()

    # QCD
    qcdSys = []
    if di=='2JetVBF':
        data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
        mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    else:
        data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Obs'), Lists.mc_samples)])
        mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Bac'), Lists.mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = Lists.positivize(QCD.Get('bdtDiscriminator'))
    qcdi = qcd.Integral()
    qcd = Lists.normQCDBDT(qcd, qcdi, 0, di)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'QCD', binning))
    # QCD Systematics
    for i, qSys in enumerate(Lists.qcdSys):
        qcd = Lists.positivize(QCD.Get(qSys+'bdtDiscriminator'))
        qcdi = qcd.Integral()
        qcd = Lists.normQCDBDT(qcd, qcdi, i+1, di)
        qcdSys.append(qcd.Rebin(len(binning)-1, Lists.qcdSysNames[i], binning))
    # Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    for i, sam in enumerate(Lists.samp):
        print sam
        dySys = []
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = DY.Get('bdtDiscriminator')
        dy = Lists.positivize(dy)
        h00 = dy.Clone()
        dy = dy.Rebin(len(binning)-1, sam, binning)
        h01 = dy.Clone()
        nom = dy.Integral()
        dySys.append(dy)
        # Systematics
        for j, mSys in enumerate(Lists.mcSys):
            h10 = Lists.positivize(DY.Get(mSys[0]+'bdtDiscriminator'))
            h20 = Lists.positivize(DY.Get(mSys[1]+'bdtDiscriminator'))
            h11 = h10.Rebin(len(binning)-1, sam+Lists.mcSysNames[j][0], binning)
            h21 = h20.Rebin(len(binning)-1, sam+Lists.mcSysNames[j][1], binning)
            #h1, h2 = Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[0]), Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[1])
            dySys.append(h11)
            dySys.append(h21)
        # Scale
        for j, eSys in enumerate(Lists.esSys):
            h10 = Lists.positivize(DY.Get(eSys[0]+'bdtDiscriminator'))
            h20 = Lists.positivize(DY.Get(eSys[1]+'bdtDiscriminator'))
            h11 = h10.Rebin(len(binning)-1, sam+Lists.esSysNames[j][0], binning)
            h21 = h20.Rebin(len(binning)-1, sam+Lists.esSysNames[j][1], binning)
            h11, h21 = Lists.positivize(Lists.normEmb(h11, nom, Lists.esSysNames[j][0])), Lists.positivize(Lists.normEmb(h21, nom, Lists.esSysNames[j][1]))
            dySys.append(h11)
            dySys.append(h21)
        # Recoil Response and Resolution
        if sam in Lists.recsamp:
            for j, rSys in enumerate(Lists.recSys):
                h10 = Lists.positivize(DY.Get(rSys[0]+'bdtDiscriminator'))
                h20 = Lists.positivize(DY.Get(rSys[1]+'bdtDiscriminator'))
                h11 = h10.Rebin(len(binning)-1, sam+Lists.recSysNames[j][0], binning)
                h21 = h20.Rebin(len(binning)-1, sam+Lists.recSysNames[j][1], binning)
                h1, h2 = Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[0]), Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[1])
                dySys.append(h1)
                dySys.append(h2)
        # DY Pt Reweighting
        if sam=='Zothers':
            for j, dSys in enumerate(Lists.dyptSys):
                dy = Lists.positivize(DY.Get(dSys+'bdtDiscriminator'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
        # Jet and Unclustered Energy Scale
        if sam in Lists.norecsamp:
            for j, jSys in enumerate(Lists.jesSys):
                h10 = Lists.positivize(DY.Get(jSys[0]+'bdtDiscriminator'))
                h20 = Lists.positivize(DY.Get(jSys[1]+'bdtDiscriminator'))
                h11 = h10.Rebin(len(binning)-1, sam+Lists.jesSysNames[j][0], binning)
                h21 = h20.Rebin(len(binning)-1, sam+Lists.jesSysNames[j][1], binning)
                h1, h2 = Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[0]), Lists.positivize(Lists.normHist(h00, h10, h20, h01, h11, h21, binning)[1])
                dySys.append(h1)
                dySys.append(h2)
        # Write Histograms
        for dSys in dySys:
            dSys.Write()