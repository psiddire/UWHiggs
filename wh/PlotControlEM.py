'''

Make inclusive e-mu (Z + ttbar) control plots

'''

import os
import glob
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.MetaData.data_styles import data_styles

jobid = os.environ['jobid']

output_dir = os.path.join('results', jobid, 'plots', 'em')

samples = [
    'Zjets_M50',
    'WZ*',
    'WW*',
    'ZZ*',
    'TT*',
    'WplusJets*',
    "data_MuEG*",
]

files = []
lumifiles = []

for x in samples:
    files.extend(glob.glob('results/%s/ControlEM/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

plotter = Plotter(files, lumifiles, output_dir)

# Define how we estimate QCD - just take SS data.
import rootpy.plotting.views as views


def get_ss(x):
    return x.replace('em/', 'em/ss/')

mc_view = views.SumView(
    *[views.PathModifierView(plotter.get_view(x), get_ss) for x in [
        'WZJetsTo3LNu*',
        'ZZJetsTo4L*',
        'WW*',
        'WplusJets_madgraph',
        'TTplusJets_madgraph',
        'Zjets_M50',
    ]]
)

#mc_inverted = views.ScaleView(mc_view, -1)
mc_inverted = views.ScaleView(mc_view, -1)

sqrts = 7 if '7TeV' in jobid else 8

qcd_view = views.StyleView(
    views.TitleView(
        views.ScaleView(
            views.SumView(views.PathModifierView(plotter.data, get_ss),
                          mc_inverted),
            1.4 if sqrts == 8 else 1.28  # OS/SS from Valentina
        ),
        'QCD'),
    **data_styles['WZ*'])


def get_fakes(x):
    return x.replace('em/', 'em/f2/w2/')

fakes_view = views.StyleView(
    views.TitleView(
        views.PathModifierView(plotter.data, get_fakes), 'Fakes'),
    **data_styles['WZ*']
)


def correct_for_contrib_in_fakes(x, fudge_factor=1.0):
    ''' Make a view of MC which corrects for the contribution in the fakes '''
    fakes_view = views.PathModifierView(x, get_fakes)
    invert_view = views.ScaleView(fakes_view, -1)
    output = views.SumView(x, invert_view)
    # Fudge factor from Zmumu (from H2TAu inclusive)
    fudge = views.ScaleView(output, fudge_factor)
    return fudge

plotter.views['QCD'] = {'view': qcd_view}
plotter.views['Fakes'] = {'view': fakes_view}
plotter.views['Zjets_M50-no-fakes'] = {
    'view': correct_for_contrib_in_fakes(plotter.views['Zjets_M50']['view'],
                                         0.95 if sqrts == 7 else 1.0)
}

print plotter.views.keys()
ww_name = 'WWJetsTo2L2Nu' if sqrts == 7 else 'WWJetsTo2L2Nu_TuneZ2_8TeV'
plotter.views['WWJetsTo2L2Nu-no-fakes'] = {
    'view': correct_for_contrib_in_fakes(plotter.views[ww_name]['view'])
}

plotter.views['TTplusJets_madgraph-no-fakes'] = {
    'view': correct_for_contrib_in_fakes(
        plotter.views['TTplusJets_madgraph']['view'],
        0.95 if sqrts == 7 else 1)
}
# Override ordering
os_ss_samples = [
    'WZJetsTo3LNu*',
    'ZZJetsTo4L*',
    'QCD',
    'WW*',
    'WplusJets_madgraph',
    'TTplusJets_madgraph',
    'Zjets_M50',
]

fakes_samples = [
    'Fakes',
    'WWJetsTo2L2Nu-no-fakes',
    #'WW*',
    'TTplusJets_madgraph-no-fakes',
    #'TTplusJets_madgraph',
    #'WZJetsTo3LNu*',
    #'ZZJetsTo4L*',
    'Zjets_M50-no-fakes',
    #'Zjets_M50',
]

for suffix, samples in [('', os_ss_samples), ('-fakes', fakes_samples)]:
    plotter.mc_samples = samples

    plotter.plot_mc_vs_data('em', 'emMass', rebin=5, leftside=False,
                            xaxis='m_{e#mu} (GeV)')
    plotter.add_cms_blurb(sqrts)
    plotter.save('mass' + suffix)

    plotter.plot_mc_vs_data('em', 'emMass', rebin=10, leftside=False,
                            xaxis='m_{e#mu} (GeV)')
    plotter.add_cms_blurb(sqrts)
    plotter.save('mass_rebin' + suffix)

    plotter.plot_mc_vs_data('em', 'mPt', rebin=10)
    plotter.save('mPt' + suffix)
    plotter.plot_mc_vs_data('em', 'ePt', rebin=10)
    plotter.save('ePt' + suffix)

    plotter.plot_mc_vs_data('em', 'mAbsEta', rebin=5)
    plotter.save('mAbsEta' + suffix)
    plotter.plot_mc_vs_data('em', 'eAbsEta', rebin=5)
    plotter.save('eAbsEta' + suffix)

    plotter.plot_mc_vs_data('em', 'nvtx')
    plotter.save('nvtx' + suffix)

    plotter.plot_mc_vs_data('em', 'bjetCSVVeto')
    plotter.save('bjetCSVVeto' + suffix)

    plotter.plot_mc_vs_data('em', 'bjetVeto')
    plotter.save('bjetVeto' + suffix)
