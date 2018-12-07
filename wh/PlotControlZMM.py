'''

Make inclusive Z->mumu control plots

'''

import os
import glob
from FinalStateAnalysis.PlotTools.Plotter import Plotter

jobid = os.environ['jobid']

output_dir = os.path.join('results', jobid, 'plots', 'zmm')

samples = [
    'Zjets_M50',
    #'WZ*',
    #'ZZ*',
    #'WW*',
    'TT*',
    #'WplusJets*',
    "data_DoubleMu*",
]

files = []
lumifiles = []

for x in samples:
    files.extend(glob.glob('results/%s/ControlZMM/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

plotter = Plotter(files, lumifiles, output_dir)
plotter.mc_samples = ['Zjets_M50']

sqrts = 7 if '7TeV' in jobid else 8

plotter.plot_mc_vs_data('zmm', 'm1m2Mass', rebin=2, xaxis='m_{#mu#mu} (GeV)')
plotter.add_cms_blurb(sqrts)
plotter.save('mass')

plotter.plot_mc_vs_data('zmm', 'm1m2Mass', rebin=6, xaxis='m_{#mu#mu} (GeV)')
plotter.add_cms_blurb(sqrts)
plotter.save('mass_rebin')

plotter.plot_mc_vs_data('zmm', 'm1Pt')
plotter.save('m1Pt')
plotter.plot_mc_vs_data('zmm', 'm1Pt', 5)
plotter.save('m1Pt_rebin')
plotter.plot_mc_vs_data('zmm', 'm2Pt')
plotter.save('m2Pt')
plotter.plot_mc_vs_data('zmm', 'm2Pt', 5)
plotter.save('m2Pt_rebin')

plotter.plot_mc_vs_data('zmm', 'm1AbsEta')
plotter.save('m1AbsEta')
plotter.plot_mc_vs_data('zmm', 'm2AbsEta')
plotter.save('m2AbsEta')

plotter.plot_mc_vs_data('zmm', 'm1AbsEta', 5)
plotter.save('m1AbsEta_rebin')
plotter.plot_mc_vs_data('zmm', 'm2AbsEta', 5)
plotter.save('m2AbsEta_rebin')

plotter.plot_mc_vs_data('zmm', 'nvtx')
plotter.save('nvtx')
