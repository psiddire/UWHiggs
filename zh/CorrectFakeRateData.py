'''

Subtract expected WZ and ZZ contamination from FR numerator and denominators.

Author: Evan K. Frii

'''

from RecoLuminosity.LumiDB import argparse
import fnmatch
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView
import logging
import glob
import os
import sys

log = logging.getLogger("CorrectFakeRateData")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--files', nargs='+')
    parser.add_argument('--lumifiles', nargs='+')
    parser.add_argument('--outputfile', required=True)
    parser.add_argument('--denom', required=True, help='Path to denom')
    parser.add_argument('--numerator', required=True, help='Path to numerator')
    parser.add_argument('--rebin', type=str, default="1")
    parser.add_argument('--noCorrection', type=bool, default=False)

    args = parser.parse_args()

    from rootpy import io
    import ROOT
    import rootpy.plotting.views as views
    import rootpy.plotting as plotting
    from FinalStateAnalysis.MetaData.data_views import data_views

    logging.basicConfig(stream=sys.stderr, level=logging.INFO)

    files = []
    for pattern in args.files:
        files.extend(glob.glob(pattern))

    log.info("Loading data from %i files", len(files))

    lumifiles = []
    for pattern in args.lumifiles:
        lumifiles.extend(glob.glob(pattern))

    the_views = data_views(files, lumifiles)

    outputdir = os.path.dirname(args.outputfile)
    if outputdir and not os.path.exists(outputdir):
        os.makedirs(outputdir)

    log.info("Rebinning with factor %s", args.rebin)
    def rebin_view(x):
        ''' Make a view which rebins histograms '''
        binning = None
        if ',' in args.rebin:
            binning = tuple(int(x) for x in args.rebin.split(','))
        else:
            binning = int(args.rebin)
        return RebinView(x, binning)

    def round_to_ints(x):
        new = x.Clone()
        new.Reset()
        for bin in range(x.GetNbinsX()+1):
            nentries = ROOT.TMath.Nint(x.GetBinContent(bin))
            center = x.GetBinLowEdge(bin) + 0.5*x.GetBinWidth(bin)
            for _ in range(nentries):
                new.Fill(center)
        return new

    def int_view(x):
        return views.FunctorView(x, round_to_ints)

    def get_view(sample_pattern):
        for sample, sample_info in the_views.iteritems():
            if fnmatch.fnmatch(sample, sample_pattern):
                return rebin_view(sample_info['view'])
        raise KeyError("I can't find a view that matches %s, I have: %s" % (
            sample_pattern, " ".join(the_views.keys())))
   
    data = rebin_view(the_views['data']['view'])

    output = io.open(args.outputfile, 'RECREATE')
    output.cd()

    log.info("numerator = %s",args.numerator)    
    uncorr_numerator = data.Get(args.numerator)
    uncorr_denominator = data.Get(args.denom)

    uncorr_numerator.SetName('numerator_uncorr')
    uncorr_denominator.SetName('denominator_uncorr')

    uncorr_numerator.Write()
    uncorr_denominator.Write()

    log.info("Uncorrected: %0.2f/%0.2f = %0.1f%%",
             uncorr_numerator.Integral(),
             uncorr_denominator.Integral(),
             100*uncorr_numerator.Integral()/uncorr_denominator.Integral()
             if uncorr_denominator.Integral() else 0
            )

    if not args.noCorrection:
        wz_view = get_view('WZ*')
        zz_view = get_view('ZZ*')
        corrected_view = int_view(
            SubtractionView(data, wz_view, zz_view, restrict_positive=True))

        corr_numerator = corrected_view.Get(args.numerator)
        corr_denominator = corrected_view.Get(args.denom)

        log.info("Corrected:   %0.2f/%0.2f = %0.1f%%",
                 corr_numerator.Integral(),
                 corr_denominator.Integral(),
                 100*corr_numerator.Integral()/corr_denominator.Integral()
                 if corr_denominator.Integral() else 0
                )

        corr_numerator.SetName('numerator')
        corr_denominator.SetName('denominator')

        corr_numerator.Write()
        corr_denominator.Write()

     # temporary fix for e/mu fakerates so I can use uncorrected with Rakefile
    #else:
    #    uncorr_numerator.SetName('numerator')
    #    uncorr_denominator.SetName('denominator')
    #
    #    uncorr_numerator.Write()
    #    uncorr_denominator.Write()  
