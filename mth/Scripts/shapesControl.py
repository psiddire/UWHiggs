import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
import argparse
import array
import os
import ROOT
import glob
import Lists

jobid = os.environ['jobid']

parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--i",
    action="store",
    dest="Var",
    default="m_t_CollinearMass",
    help="Which variable")
args = parser.parse_args()

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuTau/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'ControlPlots/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

var = args.Var

f = ROOT.TFile( outputdir+var+'.root', 'RECREATE')

d = 'SS'
#d = 'WOS'
#d = 'OS'

binning = array.array('d', range(0, 300, 10))

#binning = array.array('d', [-0.7, -0.5, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.35])

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

# Observed
DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
data = Lists.positivize(DataTotal.Get('Tight'+d+'/'+var))
data = data.Rebin(len(binning)-1, 'data_obs', binning)
#data.SetName('data_obs')
data.Write()

# Embedded
embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
emb = Lists.positivize(embed.Get('Tight'+d+'/'+var))
emb = emb.Rebin(len(binning)-1, 'ZTauTau', binning)
#emb.SetName('ZTauTau')
emb.Write()

# Fakes
QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
tfakes = QCD.Get('TauLoose'+d+'/'+var)
mfakes = QCD.Get('MuonLoose'+d+'/'+var)
mtfakes = QCD.Get('MuonLooseTauLoose'+d+'/'+var)
qcd = tfakes.Clone()
qcd.Add(mfakes)
qcd.Add(mtfakes, -1)
MC = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
tfakes_mc = MC.Get('TauLoose'+d+'/'+var)
mfakes_mc = MC.Get('MuonLoose'+d+'/'+var)
mtfakes_mc = MC.Get('MuonLooseTauLoose'+d+'/'+var)
mc = tfakes_mc.Clone()
mc.Add(mfakes_mc)
mc.Add(mtfakes_mc, -1)
mc = Lists.positivize(mc)
qcd.Add(mc, -1)
qcd = Lists.positivize(qcd)
qcd = qcd.Rebin(len(binning)-1, 'Fakes', binning)
#qcd.SetName('Fakes')
qcd.Write()

# Monte Carlo
for i, sam in enumerate(Lists.samp):
    print sam
    DY = v[i]
    dy = Lists.positivize(DY.Get('Tight'+d+'/'+var))
    dy = dy.Rebin(len(binning)-1, sam, binning)
    #dy.SetName(sam)
    dy.Write()
