import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import os
import ROOT
import glob
import array
import Lists

jobid = os.environ['jobid']

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuTauSysBDT/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'Shapes/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesMTBDT.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY'), Lists.mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW') or x.startswith('Wm') or x.startswith('Wp') or x.startswith('ZH'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV') , Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV') , Lists.mc_samples)])
]

for di in Lists.dirs:

    if di=='0Jet':
        dr = '0jet'
        binning = array.array('d', [-1.0, -0.65, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.3, 1.0])
    elif di=='1Jet':
        dr = '1jet'
        binning = array.array('d', [-1.0, -0.65, -0.55, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35, 1.0])
    elif di=='2Jet':
        dr = '2jet_gg'
        binning = array.array('d', [-1.0, -0.65, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35, 1.0])
    else:
        dr = '2jet_vbf'
        binning = array.array('d', [-1.0, -0.65, -0.4, -0.3, -0.2, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35, 1.0])

    # Observed
    d = f.mkdir(dr)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    data = Lists.positivize(DataTotal.Get('TightOS'+di+'/bdtDiscriminator'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    # Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
    emb = Lists.positivize(embed.Get('TightOS'+di+'/bdtDiscriminator'))
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    # Tau ID
    for i, tid in enumerate(Lists.tid):
        emb = Lists.positivize(embed.Get('TightOS'+di+tid+'/bdtDiscriminator'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.tidNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, Lists.tidNames[i][1], binning))
    # Tracking
    for i, tr in enumerate(Lists.trk):
        emb = Lists.positivize(embed.Get('TightOS'+di+tr+'/bdtDiscriminator'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.trkNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, Lists.trkNames[i][1], binning))
    # Tau Scale
    for i, sc in enumerate(Lists.scaleSys):
        emb = Lists.positivize(embed.Get('TightOS'+di+sc+'/bdtDiscriminator'))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysNames[i][1], binning))
    # Write Histograms
    for eSys in embSys:
        eSys.Write()

    # Fakes
    qcdSys = []
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    tfakes = QCD.Get('TauLooseOS'+di+'/bdtDiscriminator')
    mfakes = QCD.Get('MuonLooseOS'+di+'/bdtDiscriminator')
    mtfakes = QCD.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
    qcd = tfakes.Clone()
    qcd.Add(mfakes)
    qcd.Add(mtfakes, -1)
    MC = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    tfakes_mc = MC.Get('TauLooseOS'+di+'/bdtDiscriminator')
    mfakes_mc = MC.Get('MuonLooseOS'+di+'/bdtDiscriminator')
    mtfakes_mc = MC.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
    mc = tfakes_mc.Clone()
    mc.Add(mfakes_mc)
    mc.Add(mtfakes_mc, -1)
    mc = Lists.positivize(mc)
    qcd.Add(mc, -1)
    qcd = Lists.positivize(qcd)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes', binning))
    # Tau Fake Rate
    for i, tFR in enumerate(Lists.tauFR):
        qcd = QCD.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcd.add(mfakes)
        qcd.add(qcdmt, -1)
        mc = MC.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        mcmt = MC.Get('MuonLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        mc.add(mfakes_mc)
        mc.add(mcmt, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.tauFRNames[i], binning))
    # Muon Fake Rate
    for i, mFR in enumerate(Lists.muonFR):
        qcd = QCD.Get('MuonLooseOS'+di+mFR+'/bdtDiscriminator')
        #qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+mFR+'/bdtDiscriminator')
        qcdmt = QCD.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
        qcd.add(tfakes)
        qcd.add(qcdmt, -1)
        mc = MC.Get('MuonLooseOS'+di+mFR+'/bdtDiscriminator')
        #mcmt = MC.Get('MuonLooseTauLooseOS'+di+mFR+'/bdtDiscriminator')
        mcmt = MC.Get('MuonLooseTauLooseOS'+di+'/bdtDiscriminator')
        mc.add(tfakes_mc)
        mc.add(mcmt, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.muonFRNames[i], binning))
    # Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    # Monte Carlo
    for i, sam in enumerate(Lists.samp):
        print sam
        DY = v[i]
        dySys = []
        dy = Lists.positivize(DY.Get('TightOS'+di+'/bdtDiscriminator'))
        dySys.append(dy.Rebin(len(binning)-1, sam, binning))
        # Pileup, Prefiring, Lepton Faking Tau, Scale
        for j, mSys in enumerate(Lists.mcSys):
            dy = Lists.positivize(DY.Get('TightOS'+di+mSys+'/bdtDiscriminator'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.mcSysNames[j], binning))
        # Tau Scale
        for j, sc in enumerate(Lists.scaleSys):
            dy = Lists.positivize(DY.Get('TightOS'+di+sc+'/bdtDiscriminator'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.scaleSysNames[j], binning))
        # Recoil Uncertainty
        if sam in Lists.recsamp:
            for j, rSys in enumerate(Lists.recSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+rSys+'/bdtDiscriminator'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
        # DY pT Reweighting
        if sam=='Zothers':
            for j, dSys in enumerate(Lists.dyptSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+dSys+'/bdtDiscriminator'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
        # Jet and Unclustered Energy Scale
        if sam in Lists.norecsamp:
            for j, jSys in enumerate(Lists.jesSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+jSys+'/bdtDiscriminator'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
        # Write Histograms
        for dSys in dySys:
            dSys.Write()
