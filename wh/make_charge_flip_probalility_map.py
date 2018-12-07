#!/usr/bin/env python

'''

Fit the probability of mismeasuring the charge of an electron. Each histogram contains the dielectron mass spectrum inside a bin

Usage:
    fitElectronChargeFlipProbability.py input.root output.root path/to/os path/to/ss "Z peak functional shape" "background functional shape"

Where [efficiency] is a RooFit factory command.

'''

import array
from RecoLuminosity.LumiDB import argparse
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.THBin import zipBins
import logging
import sys
import os
args = sys.argv[:]
sys.argv = [sys.argv[0]]
from FinalStateAnalysis.Utilities.rootbindings import ROOT
ROOT.gROOT.SetBatch(True)

log = logging.getLogger("make_charge_flip_probability_map")

def get_x_binning(histo):
    bin_edges = []
    for i in range(histo.GetNbinsX()+1):
        bin_edges.append(histo.GetXaxis().GetBinLowEdge(i+1))
    return array.array('d', bin_edges)

def get_y_binning(histo):
    bin_edges = []
    for i in range(histo.GetNbinsY()+1):
        bin_edges.append(histo.GetYaxis().GetBinLowEdge(i+1))
    return array.array('d', bin_edges)

## def rebin2d(histo, rebinx, rebiny):
##     # Just merging bins
##     if isinstance(binning, int):
##         return histo.Rebin2D(rebinx, rebiny, histo.GetName()+'_rebin')
##     bin_arrayx = array.array('d', rebinx)
##     bin_arrayy = array.array('d', rebiny)
##     new_histo  = ROOT.TH2(histo.GetName() + '_rebin', histo.GetTitle(), len(binning)-1) histogram.Rebin(len(binning)-1, histogram.GetName() + 'rebin', bin_array)
    


if __name__ == "__main__":
    #################################
    ###Argparse options  ############
    #################################
    parser = argparse.ArgumentParser()
    parser.add_argument('output', metavar='output.root', help='Output root file')
    parser.add_argument('num', metavar='/path/to/numerator',   help='Path to numerator histogram')
    parser.add_argument('den', metavar='/path/to/denominator', help='Path to denominator histogram')
    parser.add_argument('input', nargs='+', metavar='input.root', help='Input root files - will be summed')
    parser.add_argument('--verbose', action='store_true', help='More log output')
    parser.add_argument('--rebinX', metavar='N', type=int, required=False, help='Rebin histograms before fitting. '
                        #'Can be either an integer or a list of bin edges.'
                        #' If variable binning is used, the numbers should '
                        #' be specified as a comma separated list w/o spaces.'
        )
    parser.add_argument('--rebinY', metavar='N', type=int, required=False, help='Rebin histograms before fitting. '
                        #'Can be either an integer or a list of bin edges.'
                        #' If variable binning is used, the numbers should '
                        #' be specified as a comma separated list w/o spaces.'
        )


    args = parser.parse_args(args[1:])

    if args.verbose:
        logging.basicConfig(level=logging.DEBUG, stream=sys.stderr)
    else:
        logging.basicConfig(level=logging.INFO, stream=sys.stderr)

    #################################
    ###main part         ############
    #################################
    from rootpy.plotting import views
    import rootpy.io as io
    import ROOT
    ROOT.gROOT.SetBatch(True)

    # Build view of input histograms
    log.info("Merging input files")
    input_files = [io.open(x) for x in args.input]
    input_view  = views.SumView(*input_files)
    numerator   = input_view.Get(args.num)
    denominator = input_view.Get(args.den)

    #Checks if rebinning is needed
    if (args.rebinX and args.rebinX > 1) or (args.rebinY and args.rebinY > 1):
        binx = args.rebinX if args.rebinX else 1
        biny = args.rebinY if args.rebinY else 1
        numerator.Rebin2D(binx, biny)
        denominator.Rebin2D(binx, biny) 
        
    eff_map          = numerator.Clone("efficiency_map")
    eff_map_statUp   = numerator.Clone("efficiency_map_statUp")
    eff_map_statDown = numerator.Clone("efficiency_map_statDown")
    worse_rel_err    = numerator.Clone("worse_rel_err")

    eff_map.SetTitle( eff_map.GetName() )
    eff_map_statUp.SetTitle( eff_map_statUp.GetName() )
    eff_map_statDown.SetTitle( eff_map_statDown.GetName() )
    worse_rel_err.SetTitle( worse_rel_err.GetName() )
    
    log.info("Making efficiency map")
    for ibinx in range(1,eff_map.GetNbinsX()+1):
        for ibiny in range(eff_map.GetNbinsY()+1):
            inum      = numerator.GetBinContent(ibinx, ibiny)
            iden      = denominator.GetBinContent(ibinx, ibiny)
            ieff       = inum / iden if iden <> 0 else 0
            statUp    = ROOT.TEfficiency.ClopperPearson( int(iden), int(inum), 0.682689492137, True)
            statDown  = ROOT.TEfficiency.ClopperPearson( int(iden), int(inum), 0.682689492137, False)
            worse_err = (abs(statUp - ieff)/ieff if abs(statUp - ieff) > abs(statDown - ieff) else abs(statDown - ieff)/ieff) if ieff else 0.
            eff_map.SetBinContent(ibinx, ibiny, ieff)
            eff_map.SetBinError(ibinx, ibiny, worse_err*ieff)
            eff_map_statUp.SetBinContent(ibinx, ibiny, statUp)
            eff_map_statDown.SetBinContent(ibinx, ibiny, statDown)
            worse_rel_err.SetBinContent(ibinx, ibiny, worse_err)
            
    canvas = ROOT.TCanvas("asdf", "asdf", 800, 600)
    ROOT.gStyle.SetPalette(53)
    eff_map.Draw('colz')
    canvas.Print(args.output.replace(".root",".png"))
    outFile = ROOT.TFile(args.output,'recreate') #FIXME move to rootpy io
    outFile.cd()
    eff_map.Write()
    eff_map_statUp.Write()
    eff_map_statDown.Write()
    worse_rel_err.Write()
    base_dir   = os.path.dirname(args.num)

    m          = ROOT.RooRealVar('m', 'm', 55,55,200)
    os_trkMass = ROOT.RooDataHist('higgs_data','higgs_data',ROOT.RooArgList(m),input_view.Get(os.path.join(base_dir,'os_trkMass')))
    mean       = ROOT.RooRealVar('mean', 'mean', 90,80,110)
    sigmaL     = ROOT.RooRealVar('sigmaL' ,'sigmaL' ,30 ,0 ,100)
    sigmaR     = ROOT.RooRealVar('sigmaR' ,'sigmaR' ,25 ,0 ,100)
    alphaL     = ROOT.RooRealVar('alphaL' ,'alphaL' ,1  ,0 ,30 )
    alphaR     = ROOT.RooRealVar('alphaR' ,'alphaR' ,1  ,0 ,30 )
    os_func    = ROOT.RooCruijff( 'os_func', 'os_func', m, mean, sigmaL, sigmaR, alphaL, alphaR)

    fit_result = os_func.fitTo(
        os_trkMass,
        ROOT.RooFit.Save(True),
        ROOT.RooFit.PrintLevel(-1),
        #ROOT.RooFit.SumW2Error(True),
        )

    frame = m.frame(ROOT.RooFit.Title("OS Trk Mass distribution"))
    os_trkMass.plotOn(
        frame,
    )
    os_func.plotOn(frame, ROOT.RooFit.LineColor(ROOT.EColor.kAzure))
    frame.Draw()
    canvas.Print(args.output.replace(".root","os_trkMass.png"))
    canvas.Print(args.output.replace(".root","os_trkMass.pdf"))

    #Fizin all the parameters
    #mean.setVal(0)
    mean.setConstant(True)
    sigmaL.setConstant(True)
    sigmaR.setConstant(True)
    alphaL.setConstant(True)
    alphaR.setConstant(True)

    m.setBins(10000,"cache")
    ss_trkMass = ROOT.RooDataHist('ss_trkMass','ss_trkMass',ROOT.RooArgList(m), input_view.Get(os.path.join(base_dir,'ss_trkMass')))
    mass_scale = ROOT.RooRealVar('mass_scale' ,'mass_scale', 1, 0.8,1.2)
    loss_fcn   = ROOT.RooFormulaVar('loss_fcn' ,'fake_width' , '@0 * @1', ROOT.RooArgList(mass_scale,m))
    ss_func    = ROOT.RooCruijff( 'ss_func', 'ss_func', loss_fcn, mean, sigmaL, sigmaR, alphaL, alphaR)

    fit_result = ss_func.fitTo(
        ss_trkMass,
        ROOT.RooFit.Save(True),
        #ROOT.RooFit.PrintLevel(-1),
        #ROOT.RooFit.SumW2Error(True),
        )

    fit_result.Print()
    frame = m.frame(ROOT.RooFit.Title("SS Trk Mass distribution"))
    ss_trkMass.plotOn(
        frame,
    )
    
    ss_func.plotOn(frame, ROOT.RooFit.LineColor(ROOT.EColor.kAzure))
    frame.Draw()
    canvas.Print(args.output.replace(".root","ss_trkMass.png"))
    canvas.Print(args.output.replace(".root","ss_trkMass.pdf"))

    mass_scale.Write()
    outFile.Close()
