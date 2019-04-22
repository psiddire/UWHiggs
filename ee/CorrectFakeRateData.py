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

    samples = ['WZ*', 'WW*', 'ZZ*', 'DY*', 'WJets*', 'TT*', 'ST*', 'EWK*', 'data*'] 
    files = []
    lumifiles = []
    for x in samples:
        files.extend(glob.glob('results/DataFeb1/AnalyzeEEFake/%s' % (x)))
        lumifiles.extend(glob.glob('inputs/DataFeb1/%s.lumicalc.sum' % (x)))

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
    wz_view = get_view('WZ*')
    ww_view = get_view('WW*')
    zz_view = get_view('ZZ*')
    dy_view = get_view('DY*')
    tt_view = get_view('TT*')
    st_view = get_view('ST*')
    ewk_view = get_view('EWK*')
    w_view = get_view('W*Jets*')

    data = rebin_view(the_views['data']['view'])
    
    corrected_view = int_view(
        SubtractionView(data, wz_view, ww_view, zz_view, tt_view, st_view, dy_view, ewk_view, restrict_positive=True))

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

    w_numerator = w_view.Get(args.numerator)
    w_denominator = w_view.Get(args.denom)

    corr_numerator.SetName('numerator')
    corr_denominator.SetName('denominator')

    fakerate = ROOT.TEfficiency(corr_numerator, corr_denominator)
    fakerate.SetName('fakerate')
    fakerate.Draw("ep")

    uncorr_numerator.SetName('numerator_uncorr')
    uncorr_denominator.SetName('denominator_uncorr')

    w_numerator.SetName('numerator_w')
    w_denominator.SetName('denominator_w')

    wfakerate = ROOT.TEfficiency(w_numerator, w_denominator)
    wfakerate.SetName('wfakerate')
    wfakerate.Draw("ep")

    corr_numerator.Write()
    corr_denominator.Write()
    fakerate.Write()
    uncorr_numerator.Write()
    uncorr_denominator.Write()
    w_numerator.Write()
    w_denominator.Write()
    wfakerate.Write()

