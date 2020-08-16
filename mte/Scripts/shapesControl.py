import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import argparse
import os
import ROOT
import glob
import array
import Lists

jobid = os.environ['jobid']

parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--i",
    action="store",
    dest="Var",
    default="m_e_CollMass",
    help="Which variable")
args = parser.parse_args()

for x in Lists.mc_samples:
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuETTBDT/%s.root' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

outputdir = 'ControlPlots/'
plotter = Plotter(Lists.files, Lists.lumifiles, outputdir)

var = args.Var

#binning = array.array('d', range(0, 300, 10))

binning = array.array('d', [-0.6, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.35])

f = ROOT.TFile( outputdir+var+'.root', 'RECREATE')

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

# Observed
DataTotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
data = Lists.positivize(DataTotal.Get('TightOS/'+var))
data = data.Rebin(len(binning)-1, 'data_obs', binning)
#data.SetName('data_obs')
data.Write()

# # Embedded
# embed = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('Embed'), Lists.mc_samples)])
# emb = Lists.positivize(embed.Get('TightOS/'+var))
# emb = emb.Rebin(len(binning)-1, 'ZTauTau', binning)
# #emb.SetName('ZTauTau')
# emb.Write()

# QCD
data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
QCDData = views.SubdirectoryView(data_view, 'TightSS')
QCDMC = views.SubdirectoryView(mc_view, 'TightSS')
QCD = SubtractionView(QCDData, QCDMC, restrict_positive=True)
qcd = Lists.positivize(QCD.Get(var))
qcd = qcd.Rebin(len(binning)-1, 'ZTauTau', binning)
#emb.SetName('ZTauTau')
qcd.SetName('QCD')
qcd.Write()

for i, sam in enumerate(Lists.samp):
    print sam
    DY = v[i]
    dy = Lists.positivize(DY.Get('TightOS/'+var))
    dy = dy.Rebin(len(binning)-1, sam, binning)
    #dy.SetName(sam)
    dy.Write()
