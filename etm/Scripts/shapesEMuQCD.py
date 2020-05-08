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
    Lists.files.extend(glob.glob('../results/%s/AnalyzeEMuSys/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'Shapes/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)
f = ROOT.TFile( outputdir+'shapesEMuQCD.root', 'RECREATE')

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
        binning = array.array('d', range(0, 300, 10))
    elif di=='1Jet':
        binning = array.array('d', range(0, 300, 10))
    elif di=='2Jet':
        binning = array.array('d', range(0, 300, 25))
    else:
        binning = array.array('d', [0.0, 50.0, 75.0, 100.0, 125.0, 150.0, 175.0, 200.0, 225.0, 250.0, 275.0, 300.0])

    # Observed
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    data = Lists.positivize(DataTotal.Get('TightOS'+di+'/e_m_CollinearMass'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    # Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
    emball = views.SubdirectoryView(embed, 'TightOS'+di)
    emb = Lists.positivize(emball.Get('e_m_CollinearMass'))
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    # Electron Energy Scale
    for i, esSys in enumerate(Lists.escale):
        emb = Lists.positivize(emball.Get(esSys+'e_m_CollinearMass'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.escaleNames[i], binning))
    # Write Histograms
    for eSys in embSys:
        eSys.Write()

    # QCD
    qcdSys = []
    # if di=='2JetVBF':
    #     data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    #     mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    # else:
    data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Obs'), Lists.mc_samples)])
    mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Bac'), Lists.mc_samples)])
    QCDData = views.SubdirectoryView(data_view, 'TightSS'+di)
    QCDMC = views.SubdirectoryView(mc_view, 'TightSS'+di)
    QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
    qcd = Lists.positivize(QCD.Get('e_m_CollinearMass'))
    qcdi = qcd.Integral()
    qcd = Lists.normQCD(qcd, qcdi, 0, di)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'QCD', binning))
    # QCD Systematics
    for i, qSys in enumerate(Lists.qcdSys):
        qcd = Lists.positivize(QCD.Get(qSys+'e_m_CollinearMass'))
        qcdi = qcd.Integral()
        qcd = Lists.normQCD(qcd, qcdi, i+1, di)
        qcdSys.append(qcd.Rebin(len(binning)-1, Lists.qcdSysNames[i], binning))
    # Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    for i, sam in enumerate(Lists.samp):
        print sam
        dySys = []
        DYtotal = v[i]
        DY = views.SubdirectoryView(DYtotal, 'TightOS'+di)
        dy = DY.Get('e_m_CollinearMass')
        dy = Lists.positivize(dy)
        dySys.append(dy.Rebin(len(binning)-1, sam, binning))
        # Systematics
        for j, mSys in enumerate(Lists.mcSys):
            dy = Lists.positivize(DY.Get(mSys+'e_m_CollinearMass'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.mcSysNames[j], binning))
        # Recoil Response and Resolution
        if sam in Lists.recsamp:
            if di=='2JetVBF':
                for j, rSys in enumerate(Lists.recSys):
                    dy = Lists.positivize(DY.Get('e_m_CollinearMass'))
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
            else:
                for j, rSys in enumerate(Lists.recSys):
                    dy = Lists.positivize(DY.Get(rSys+'e_m_CollinearMass'))
                    dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
        # DY Pt Reweighting
        if sam=='Zothers':
            for j, dSys in enumerate(Lists.dyptSys):
                dy = Lists.positivize(DY.Get(dSys+'e_m_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
        # Jet and Unclustered Energy Scale
        if sam in Lists.norecsamp:
            for j, jSys in enumerate(Lists.jesSys):
                dy = Lists.positivize(DY.Get(jSys+'e_m_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
        # Write Histograms
        for dSys in dySys:
            dSys.Write()
