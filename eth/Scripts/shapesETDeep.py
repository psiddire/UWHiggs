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
    Lists.files.extend(glob.glob('../results/%s/AnalyzeETauSysDeep/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'Shapes/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

f = ROOT.TFile( 'Shapes/shapesETDeep.root', 'RECREATE')

v = [
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('DY'), Lists.mc_samples )]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('EWK') , Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToTauTau'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGluHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBFHToWW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WminusHToTauTau') or x.startswith('WplusHToTauTau') or x.startswith('ZHToTauTau') , Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ST'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('GluGlu_LFV') , Lists.mc_samples)]),
views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('VBF_LFV') , Lists.mc_samples)])
]

for di in Lists.dirs:

    if di=='0Jet':
        dr = '0jet'
    elif di=='1Jet':
        dr = '1jet'
    elif di=='2Jet':
        dr = '2jet_gg'
    else:
        dr = '2jet_vbf'
    binning = array.array('d', range(0, 300, 10))

    # Observed
    d = f.mkdir(dr)
    d.cd()
    DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    data = Lists.positivize(DataTotal.Get('TightOS'+di+'/e_t_CollinearMass'))
    data = data.Rebin(len(binning)-1, 'data_obs', binning)
    data.Write()

    # Embedded
    embSys = []
    embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
    emb = Lists.positivize(embed.Get('TightOS'+di+'/e_t_CollinearMass'))
    embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau', binning))
    # Tau ID
    for i, tid in enumerate(Lists.tid):
        emb = Lists.positivize(embed.Get('TightOS'+di+tid+'/e_t_CollinearMass'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.tidNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, Lists.tidNames[i][1], binning))
    # Tracking
    for i, tr in enumerate(Lists.trk):
        emb = Lists.positivize(embed.Get('TightOS'+di+tr+'/e_t_CollinearMass'))
        embSys.append(emb.Rebin(len(binning)-1, Lists.trkNames[i], binning))
    # Tau Scale
    for i, sc in enumerate(Lists.scaleSysDeep):
        emb = Lists.positivize(embed.Get('TightOS'+di+sc+'/e_t_CollinearMass'))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysDeepNames[i][0], binning))
        embSys.append(emb.Rebin(len(binning)-1, 'ZTauTau'+Lists.embscaleSysDeepNames[i][1], binning))
    # Write Histograms
    for eSys in embSys:
        eSys.Write()

    # Fakes
    qcdSys = []
    QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
    tfakes = QCD.Get('TauLooseOS'+di+'/e_t_CollinearMass')
    efakes = QCD.Get('EleLooseOS'+di+'/e_t_CollinearMass')
    etfakes = QCD.Get('EleLooseTauLooseOS'+di+'/e_t_CollinearMass')
    qcd = tfakes.Clone()
    qcd.Add(efakes)
    qcd.Add(etfakes, -1)
    MC = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
    tfakes_mc = MC.Get('TauLooseOS'+di+'/e_t_CollinearMass')
    efakes_mc = MC.Get('EleLooseOS'+di+'/e_t_CollinearMass')
    etfakes_mc = MC.Get('EleLooseTauLooseOS'+di+'/e_t_CollinearMass')
    mc = tfakes_mc.Clone()
    mc.Add(efakes_mc)
    mc.Add(etfakes_mc, -1)
    mc = Lists.positivize(mc)
    qcd.Add(mc, -1)
    qcd = Lists.positivize(qcd)
    qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes', binning))
    # Tau Fake Rate
    for i, tFR in enumerate(Lists.tauDeepFR):
        qcd = QCD.Get('TauLooseOS'+di+tFR+'/e_t_CollinearMass')
        qcdet = QCD.Get('EleLooseTauLooseOS'+di+tFR+'/e_t_CollinearMass')
        qcd.add(efakes)
        qcd.add(qcdet, -1)
        mc = MC.Get('TauLooseOS'+di+tFR+'/e_t_CollinearMass')
        mcet = MC.Get('EleLooseTauLooseOS'+di+tFR+'/e_t_CollinearMass')
        mc.add(efakes_mc)
        mc.add(mcet, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.tauDeepFRNames[i], binning))
    # Ele Fake Rate
    for i, eFR in enumerate(Lists.eleFR):
        qcd = QCD.Get('EleLooseOS'+di+eFR+'/e_t_CollinearMass')
        qcdet = QCD.Get('EleLooseTauLooseOS'+di+eFR+'/e_t_CollinearMass')
        qcd.add(tfakes)
        qcd.add(qcdet, -1)
        mc = MC.Get('EleLooseOS'+di+eFR+'/e_t_CollinearMass')
        mcet = MC.Get('EleLooseTauLooseOS'+di+eFR+'/e_t_CollinearMass')
        mc.add(tfakes_mc)
        mc.add(mcet, -1)
        mc = Lists.positivize(mc)
        qcd.Add(mc, -1)
        qcd = Lists.positivize(qcd)
        qcdSys.append(qcd.Rebin(len(binning)-1, 'Fakes'+Lists.eleFRNames[i], binning))
    # Write Histograms
    for qSys in qcdSys:
        qSys.Write()

    #Monte Carlo
    for i, sam in enumerate(Lists.samp):
        print sam
        DY = v[i]
        dySys = []
        dy = Lists.positivize(DY.Get('TightOS'+di+'/e_t_CollinearMass'))
        dySys.append(dy.Rebin(len(binning)-1, sam, binning))
        # Pileup, Prefiring, Lepton Faking Tau, Scale
        for j, bSys in enumerate(Lists.mcSys):
            dy = Lists.positivize(DY.Get('TightOS'+di+bSys+'/e_t_CollinearMass'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.mcSysNames[j], binning))
        # Tau Scale
        for j, sc in enumerate(Lists.scaleSysDeep):
            dy = Lists.positivize(DY.Get('TightOS'+di+sc+'/e_t_CollinearMass'))
            dySys.append(dy.Rebin(len(binning)-1, sam+Lists.scaleSysDeepNames[j], binning))
        # Recoil Uncertainty
        if sam in Lists.recsamp:
            for j, rSys in enumerate(Lists.recSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+rSys+'/e_t_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.recSysNames[j], binning))
        # DY pT Reweighting
        if sam=='Zothers':
            for j, dSys in enumerate(Lists.dyptSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+dSys+'/e_t_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.dyptSysNames[j], binning))
        # Top pT Reweighting
        if sam=='TT':
            for j, tSys in enumerate(Lists.ttSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+tSys+'/e_t_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.ttSysNames[j], binning))
        # Jet and Unclustered Energy Scale
        if sam in Lists.norecsamp:
            for j, jSys in enumerate(Lists.jesSys):
                dy = Lists.positivize(DY.Get('TightOS'+di+jSys+'/e_t_CollinearMass'))
                dySys.append(dy.Rebin(len(binning)-1, sam+Lists.jesSysNames[j], binning))
        # Write Histograms
        for dSys in dySys:
            dSys.Write()
