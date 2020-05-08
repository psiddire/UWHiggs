import BasePlotter
import os
import Lists
import glob

jobid = os.environ['jobid']
basePlotter = BasePlotter.BasePlotter()

for x in Lists.mc_samples:
    print x
    Lists.files.extend(glob.glob('../results/%s/AnalyzeMuTauSysBDT/%s' % (jobid, x)))
    Lists.lumifiles.extend(glob.glob('../inputs/%s/%s.lumicalc.sum' % (jobid, x)))

for j in Lists.jet:
    s1 = 'TightOS'+j
    s2 = 'TauLooseOS'+j
    s3 = 'MuonLooseOS'+j
    s4 = 'MuonLooseTauLooseOS'+j

    s = [s1, s2, s3, s4]

    outputdir = 'plots/%s/AnalyzeMuTauSys/2018SelectionsEmbedBDT/%s/' % (jobid, s[0])
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    plotter = basePlotter.mcInit(Lists.files, Lists.lumifiles, outputdir, s)

    for h in Lists.bdthisto:
        plotter.plot_mc_vs_data('', ['VBF_LFV_HToMuTau_M125*', 'GluGlu_LFV_HToMuTau_M125*'], h[0], 5, xaxis = h[1], leftside=False, xrange=None, preprocess=None, show_ratio=True, ratio_range=1.5, sort=True, blind_region=True, control=s1, jets=j, year='2018', channel='mutauh')
        plotter.save(h[0])
