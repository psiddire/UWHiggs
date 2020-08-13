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
    Lists.files.extend(glob.glob('../results/%s/AnalyzeETauSysBDT/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'Shapes/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesETBDT.root', 'RECREATE')

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

for k, di in enumerate(Lists.dirs):

    binning = array.array('d', [-0.6, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.35])

    # Observed
    d = f.mkdir(Lists.dr[k])
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
    # Electron Energy Scale
    for i, esSys in enumerate(Lists.escale):
        emb = Lists.positivize(embed.Get('TightOS'+di+esSys+'/bdtDiscriminator'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.escaleNames[i], binning))
    # Write Histograms
    for eSys in embSys:
        eSys.Write()

    # Fakes
    qcdSys = []
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    tfakes = QCD.Get('TauLooseOS'+di+'/bdtDiscriminator')
    efakes = QCD.Get('EleLooseOS'+di+'/bdtDiscriminator')
    etfakes = QCD.Get('EleLooseTauLooseOS'+di+'/bdtDiscriminator')
    qcd = tfakes.Clone()
    qcd.Add(efakes)
    qcd.Add(etfakes, -1)
    MC = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    tfakes_mc = MC.Get('TauLooseOS'+di+'/bdtDiscriminator')
    efakes_mc = MC.Get('EleLooseOS'+di+'/bdtDiscriminator')
    etfakes_mc = MC.Get('EleLooseTauLooseOS'+di+'/bdtDiscriminator')
    mc = tfakes_mc.Clone()
    mc.Add(efakes_mc)
    mc.Add(etfakes_mc, -1)
    mc = Lists.positivize(mc)
    qcd.Add(mc, -1)
    qcd = Lists.positivize(qcd)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes', binning))
    # Tau Fake Rate
    for i, tFR in enumerate(Lists.tauFR):
        qcd = QCD.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcdet = QCD.Get('EleLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        qcd.add(efakes)
        qcd.add(qcdet, -1)
        mc = MC.Get('TauLooseOS'+di+tFR+'/bdtDiscriminator')
        mcet = MC.Get('EleLooseTauLooseOS'+di+tFR+'/bdtDiscriminator')
        mc.add(efakes_mc)
        mc.add(mcet, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.tauFRNames[i], binning))
    # Ele Fake Rate
    for i, eFR in enumerate(Lists.eleFR):
        qcd = QCD.Get('EleLooseOS'+di+eFR+'/bdtDiscriminator')
        #qcdet = QCD.Get('EleLooseTauLooseOS'+di+eFR+'/bdtDiscriminator')
        qcdet = QCD.Get('EleLooseTauLooseOS'+di+'/bdtDiscriminator')
        qcd.add(tfakes)
        qcd.add(qcdet, -1)
        mc = MC.Get('EleLooseOS'+di+eFR+'/bdtDiscriminator')
        #mcet = MC.Get('EleLooseTauLooseOS'+di+eFR+'/bdtDiscriminator')
        mcet = MC.Get('EleLooseTauLooseOS'+di+'/bdtDiscriminator')
        mc.add(tfakes_mc)
        mc.add(mcet, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.eleFRNames[i], binning))
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
