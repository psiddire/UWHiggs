#! /bin/env python
'''

Subtract expected WZ and ZZ contamination from FR numerator and denominators.

Author: Evan K. Frii

'''

import logging
import sys
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
from RecoLuminosity.LumiDB import argparse
import fnmatch
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import glob
import os
import numpy

log = logging.getLogger("CorrectFakeRateData")
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    #parser.add_argument('--files', nargs='+')
    #parser.add_argument('--lumifiles', nargs='+')
    parser.add_argument('--outputfile', required=True)
    parser.add_argument('--denom', required=True, help='Path to denom')
    parser.add_argument('--numerator', required=True, help='Path to numerator')
    parser.add_argument('--rebin', type=str, default="1")

    args = parser.parse_args()

    from rootpy import io
    import ROOT
    import rootpy.plotting.views as views
    import rootpy.plotting as plotting
    from FinalStateAnalysis.MetaData.data_views import data_views

    samples = ['WZ*', 'WW*', 'ZZ*', 'DY*', 'data*']
    files = []
    lumifiles = []
    for x in samples:
        files.extend(glob.glob('results/FakeData2018/AnalyzeMMM/%s' % (x)))
        lumifiles.extend(glob.glob('inputs/FakeData2018/%s.lumicalc.sum' % (x)))

    the_views = data_views(files, lumifiles)

    outputdir = os.path.dirname(args.outputfile)
    if outputdir and not os.path.exists(outputdir):
        os.makedirs(outputdir)

    log.info("Rebinning with factor %s", args.rebin)
    def rebin_view(x):
        ''' Make a view which rebins histograms '''
        binning = None
        if ' ' in args.rebin:
            binning = tuple(eval(x) for x in args.rebin.split(' '))
        else:
            binning = eval(args.rebin)
        return RebinView(x, binning)

    def round_to_ints(x):
        new = x.Clone()
        new.Reset()
        #print x.GetName()
        for bin in range(x.GetNbinsX()+1):
            binsy = range(x.GetNbinsY()+1) if isinstance(x, ROOT.TH2) else [-1]
            
            for biny in binsy:
                
                nentries = x.GetBinContent(bin, biny) \
                    if isinstance(x, ROOT.TH2) else \
                    x.GetBinContent(bin)
                #print nentries, numpy.double(nentries)
                nentries = int(round(nentries))
                   
                if nentries >= 0:
                    nentries= int(nentries + 0.5)
                    if (nentries + 0.5) == numpy.double(nentries) and  (nentries + 0.5) == int(nentries + 0.5) and  (nentries + 0.5)==1:
                        nentries=-1
                else:
                    nentries= int(nentries - 0.5)
                    if (nentries - 0.5) == numpy.double(nentries) and  (nentries - 0.5) == int(nentries - 0.5) and  (nentries - 0.5)==1:
                        nentries=+1
   

                centerx = x.GetXaxis().GetBinCenter(bin)
                centery = x.GetYaxis().GetBinCenter(biny) \
                    if isinstance(x, ROOT.TH2) else \
                    0.
                for _ in range(nentries):
                    if isinstance(x, ROOT.TH2):
                        new.Fill(centerx, centery)
                    else:
                        new.Fill(centerx)
        return new

    def int_view(x):
        return views.FunctorView(x, round_to_ints)

    def get_view(sample_pattern):
        for sample, sample_info in the_views.iteritems():
            if fnmatch.fnmatch(sample, sample_pattern):
                return rebin_view(sample_info['view'])
        raise KeyError("I can't find a view that matches %s, I have: %s" % (
            sample_pattern, " ".join(the_views.keys())))

    #from pdb import set_trace; set_trace()
    wz_view = get_view('WZ_*')
    ww_view = get_view('WW_*')
    zz_view = get_view('ZZ_*')
    dy_view = get_view('DY*')

    data = rebin_view(the_views['data']['view'])
    
    corrected_view = int_view(
        SubtractionView(data, wz_view, ww_view, zz_view, restrict_positive=True))

    log.debug('creating output file')
    output = io.root_open(args.outputfile, 'RECREATE')
    output.cd()

    log.debug('getting from corrected view')
    print args.numerator
    corr_numerator = corrected_view.Get(args.numerator)
    corr_denominator = corrected_view.Get(args.denom)

    log.info("Corrected:   %0.2f/%0.2f = %0.1f%%",
             corr_numerator.Integral(),
             corr_denominator.Integral(),
             100*corr_numerator.Integral()/corr_denominator.Integral()
             if corr_denominator.Integral() else 0
            )

    uncorr_numerator = data.Get(args.numerator)
    uncorr_denominator = data.Get(args.denom)

    dy_numerator = dy_view.Get(args.numerator)
    dy_denominator = dy_view.Get(args.denom)

    wz_integral = wz_view.Get(args.numerator).Integral()
    ww_integral = ww_view.Get(args.numerator).Integral()
    zz_integral = zz_view.Get(args.numerator).Integral()

    wz_integral_den = wz_view.Get(args.denom).Integral()
    ww_integral_den = ww_view.Get(args.denom).Integral()
    zz_integral_den = zz_view.Get(args.denom).Integral()

    log.info("Numerator integrals data: %.2f WW: %.2f WZ: %.2f, ZZ: %.2f. Corrected numerator: %.2f",
             uncorr_numerator.Integral(),
             ww_integral,
             wz_integral,
             zz_integral,
             corr_numerator.Integral()
            )

    log.info("Denominator integrals data: %.2f WW: %.2f WZ: %.2f, ZZ: %.2f. Corrected denominator: %.2f",
             uncorr_denominator.Integral(),
             ww_integral_den,
             wz_integral_den,
             zz_integral_den,
             corr_denominator.Integral()
            )

    log.info("Uncorrected: %0.2f/%0.2f = %0.1f%%",
             uncorr_numerator.Integral(),
             uncorr_denominator.Integral(),
             100*uncorr_numerator.Integral()/uncorr_denominator.Integral()
             if uncorr_denominator.Integral() else 0
            )

    corr_numerator.SetName('numerator')
    corr_denominator.SetName('denominator')

    fakerate = ROOT.TEfficiency(corr_numerator, corr_denominator)
    fakerate.SetName('fakerate')
    fakerate.Draw("ep")

    uncorr_numerator.SetName('numerator_uncorr')
    uncorr_denominator.SetName('denominator_uncorr')

    dy_numerator.SetName('numerator_dy')
    dy_denominator.SetName('denominator_dy')

    dyfakerate = ROOT.TEfficiency(dy_numerator, dy_denominator)
    dyfakerate.SetName('dyfakerate')
    dyfakerate.Draw("ep")

    corr_numerator.Write()
    corr_denominator.Write()
    fakerate.Write()
    uncorr_numerator.Write()
    uncorr_denominator.Write()
    dy_numerator.Write()
    dy_denominator.Write()
    dyfakerate.Write()
