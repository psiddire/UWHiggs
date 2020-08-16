import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
import argparse
import os
import array
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
    default="mPt",
    help="Which variable")
parser.add_argument(
    "--f",
    action="store",
    dest="Folder",
    default="",
    help="Which folder")
args = parser.parse_args()

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuTau/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'InputPlots/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

var = args.Var
fol = args.Folder

binning = array.array('d', range(0, 550, 50))

f = ROOT.TFile( outputdir+var+'.root', 'RECREATE')

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
data = Lists.positivize(DataTotal.Get('TightOS'+fol+'/'+var))
#data = data.Rebin(len(binning)-1, 'data_obs', binning)
data.SetName('data_obs')
data.Write()

# Embedded
embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
emb = Lists.positivize(embed.Get('TightOS'+fol+'/'+var))
#emb = emb.Rebin(len(binning)-1, 'ZTauTau', binning)
emb.SetName('ZTauTau')
emb.Write()

# Fakes
QCD = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
tfakes = QCD.Get('TauLooseOS'+fol+'/'+var)
mfakes = QCD.Get('MuonLooseOS'+fol+'/'+var)
mtfakes = QCD.Get('MuonLooseTauLooseOS'+fol+'/'+var)
qcd = tfakes.Clone()
qcd.Add(mfakes)
qcd.Add(mtfakes, -1)
MC = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
tfakes_mc = MC.Get('TauLooseOS'+fol+'/'+var)
mfakes_mc = MC.Get('MuonLooseOS'+fol+'/'+var)
mtfakes_mc = MC.Get('MuonLooseTauLooseOS'+fol+'/'+var)
mc = tfakes_mc.Clone()
mc.Add(mfakes_mc)
mc.Add(mtfakes_mc, -1)
mc = Lists.positivize(mc)
qcd.Add(mc, -1)
qcd = Lists.positivize(qcd)
#qcd = qcd.Rebin(len(binning)-1, 'Fakes', binning)
qcd.SetName('Fakes')
qcd.Write()

# Monte Carlo
for i, sam in enumerate(Lists.samp):
    print sam
    DY = v[i]
    dy = Lists.positivize(DY.Get('TightOS'+fol+'/'+var))
    #dy = dy.Rebin(len(binning)-1, sam, binning)
    dy.SetName(sam)
    dy.Write()
