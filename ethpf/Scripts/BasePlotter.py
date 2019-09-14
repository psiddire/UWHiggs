'''

Base class which makes nice plots.

Author: Evan K. Friis, UW

'''

import fnmatch
import re
import os
import math
import rootpy.plotting.views as views
from pdb import set_trace
from rootpy.plotting.hist import HistStack
import rootpy.plotting as plotting
from FinalStateAnalysis.MetaData.data_views import data_views
from FinalStateAnalysis.PlotTools.RebinView import RebinView
from FinalStateAnalysis.PlotTools.BlindView import BlindView,  blind_in_range
from FinalStateAnalysis.Utilities.struct import struct
import FinalStateAnalysis.Utilities.prettyjson as prettyjson
from FinalStateAnalysis.MetaData.data_styles import data_styles
from FinalStateAnalysis.PlotTools.Plotter  import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView      import SubtractionView, PositiveView
from FinalStateAnalysis.PlotTools.MedianView     import MedianView
from FinalStateAnalysis.PlotTools.SystematicsView     import SystematicsView
from FinalStateAnalysis.StatTools.quad     import quad
import ROOT
import glob
from pdb import set_trace
from FinalStateAnalysis.PlotTools.THBin import zipBins
import datetime

DEBUG = False

def create_mapper(mapping):
    def _f(path):
        for key, out in mapping.iteritems():
            if key == path:
                path = path.replace(key,out)
                print 'path', path
        return path
    return _f

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

def remove_negative_bins(hist):
    for ibin in range(0,hist.GetNbinsX()):
        if hist.GetBinContent(ibin)<0:
            hist.SetBinContent(ibin,0)
    return hist
        


def histo_diff_quad(mc_err, *systematics):
    nbins = mc_err.GetNbinsX()
    clone = mc_err.Clone()
    sys_up = [i for i, _ in systematics]
    sys_dw = [i for _, i in systematics]
    #bin loop
    for ibin in range(nbins+2): #from uflow to oflow
        content = clone.GetBinContent(ibin)
        error   = clone.GetBinError(ibin)

        shifts_up = [abs(i.GetBinContent(ibin) - content) for i in sys_up]
        shifts_dw = [abs(i.GetBinContent(ibin) - content) for i in sys_dw]
        max_shift = [max(i, j) for i, j in zip(shifts_up, shifts_dw)]
        #print shifts_up, shifts_dw, max_shift, error, content
        new_err = quad(error, *max_shift)
        #print clone.GetTitle(), ibin, new_err, clone.GetBinContent(ibin)
        clone.SetBinError(ibin, new_err)

    return clone

def mean(histo):
    '''compute histogram mean because root is not able to'''
    nbins = histo.GetNbinsX()
    wsum = sum( histo.GetBinCenter(i)*histo.GetBinContent(i) for i in xrange(1, nbins+1))
    entries = sum(histo.GetBinContent(i) for i in xrange(1, nbins+1))
    #print histo.GetTitle(), wsum, entries, nbins, histo.GetEntries(), histo.Integral()
    return float(wsum)/entries

def name_systematic(name):
    '''makes functor that makes a name systematic (with postfix)'''
    return lambda x: x+name

def dir_systematic(name):
    '''makes functor that makes a directory systematic'''
    return lambda x: os.path.join(name,x)

def parse_cgs_groups(file_path):
    if not os.path.isfile(file_path):
        raise NameError('%s is not a file!' % file_path)
    
    groups = {}
    regex = re.compile('$ GROUP (?P<groupname>\w+) (?P<includes>[a-zA-Z\_\, ]+)')
    with open(file_path) as infile:
        for line in infile:
            match = regex.match(line)
            if match:
                groups[match.group('groupname')] = [ i.strip() for i in match.group('includes').split(',') ]
    return groups

def remove_empty_bins(histogram, weight, first = 0, last = 0):
    ret  = histogram.Clone()
    last = last if last else ret.GetNbinsX() + 1
    for i in range(first, last+1):
        if ret.GetBinContent(i) <= 0:
            ret.SetBinContent(i, 0.9200*weight) #MEAN WEIGHT
            ret.SetBinError(i, 1.8*weight)
    return ret     
           
def change_histo_nbins(histogram, first = 0, last = 0):
    nbins = int((last - first)/histogram.GetBinWidth(2))
    if nbins == histogram.GetNbinsX(): 
        return histogram
    else:
        name = "" 
        title =""
        name = histogram.GetName() + 'xrange'
        title = histogram.GetTitle()
        newH = ROOT.TH1F(name, title, nbins , first, last)
        for i in range (1, nbins+1):
            newH.SetBinContent(i, histogram.GetBinContent(i))
            newH.SetBinError(i, histogram.GetBinError(i))
        return newH

def find_fill_range(histo):
    first, last = (0, 0)
    for i in range(histo.GetNbinsX() + 1):
        if histo.GetBinContent(i) > 0:
            if first:
                last = i
            else:
                first = i
    return first, last

class BasePlotter(Plotter):
    def __init__ (self, blind_region=None, forceLumi=-1, use_embedded=False): 
        cwd = os.getcwd()
        self.period = '8TeV'
        self.sqrts  = 8
        jobid = os.environ['jobid']
        self.use_embedded = use_embedded
        self.forceLumi=forceLumi
        print "\nPlotting mu tau for %s\n" % jobid

        self.files     = glob.glob('results/%s/MuTauAnalyzer/*.root' % jobid)
        self.lumifiles = glob.glob('inputs/%s/*.lumicalc.sum' % jobid)

        self.outputdir = 'plots/%s/MuTauAnalyzer' % jobid
        if not os.path.exists(self.outputdir):
            os.makedirs(self.outputdir)
            
        samples = [os.path.basename(i).split('.')[0] for i in self.files]
        
        self.blind_region=blind_region
        blinder=None
        super(BasePlotter, self).__init__(self.files, self.lumifiles, self.outputdir, blinder, forceLumi=self.forceLumi)

        self.mc_samples = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ttHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'embed*']
        
        if use_embedded:            
            self.mc_samples.pop()
            embedded_view, weight = self.make_embedded('os/gg/ept30/h_collmass_pfmet')
            self.views['ZetauEmbedded'] = {
                'view' : embedded_view,
                'weight' : weight
                }

        self.views['fakes'] = {'view' : self.make_fakes('t')}
        self.datacard_names = {
            'SMH' : 'SMH',
            'TT' : 'ttbar',
            'ST' : 'singlet',
            'EWKDiboson' : 'EWKDiboson',
            'DY' : 'DY',
            'DYlow' : 'DYlow',
            'embed' : 'ztautau',
            'GluGlu_LFV_HToMuTau_M125*' : 'GluGlu',
            'VBF_LFV_HToMuTau_M125*' : 'VBF',
            'fakes' : 'fakes',
        }
        self.sample_groups = {#parse_cgs_groups('card_config/cgs.0.conf')
            'fullsimbkg' : ['SMH', 'ttbar', 'singlet', 'EWKDiboson', 'DYTT', 'DY', 'LFV200', 'LFV300', 'LFV450', 'LFV600', 'LFV750', 'LFV900'],
            'simbkg' : ['SMH', 'ttbar', 'singlet', 'EWKDiboson', 'DYTT', 'DY', 'LFV200', 'LFV300', 'LFV450', 'LFV600', 'LFV750', 'LFV900'],
            'realtau' : ['SMH', 'EWKDiboson', 'DYTT', 'LFV200', 'LFV300', 'LFV450', 'LFV600', 'LFV750', 'LFV900'],
            'Zll' : ['DY']
        }
        self.systematics = {
            'PU_Uncertainty' : {
               'type' : 'shape',
               '+' : dir_systematic('puUp'),
               '-' : dir_systematic('puDown'),
               'apply_to' : ['fullsimbkg'],
            },
            'MES' : {
               'type' : 'shape',
               '+' : dir_systematic('mesUp'),
               '-' : dir_systematic('mesDown'),
               'apply_to' : ['fullsimbkg'],
            },
            'TES1p' : {
                'type' : 'shape',
                '+' : dir_systematic('scale_t_1prong_13TeVUp'),
                '-' : dir_systematic('scale_t_1prong_13TeVDown'),
                'apply_to' : ['fullsimbkg'],
            },
            'TES1p10' : {
                'type' : 'shape',
                '+' : dir_systematic('scale_t_1prong1pizero_13TeVUp'),
                '-' : dir_systematic('scale_t_1prong1pizero_13TeVDown'),
                'apply_to' : ['fullsimbkg'],
            },
            'TES3p' : {
                'type' : 'shape',
                '+' : dir_systematic('scale_t_3prong_13TeVUp'),
                '-' : dir_systematic('scale_t_3prong_13TeVDown'),
                'apply_to' : ['fullsimbkg'],
            },
            'uesEnergy' : {
                'type' : 'shape',
                '+' : dir_systematic('ues_UnclusteredEnUp'),
                '-' : dir_systematic('ues_UnclusteredEnDown'),
                'apply_to' : ['fullsimbkg'],
            },
            'jesJetRes' : {  
                'type' : 'shape',
                '+' : dir_systematic('jes_JetResUp'),
                '-' : dir_systematic('jes_JetResDown'),
                'apply_to' : ['fullsimbkg'],
            },
            'jesJetEn' :{
                'type' : 'shape',
                '+' : dir_systematic('jes_JetEnUp'),
                '-' : dir_systematic('jes_JetEnDown'),
                'apply_to' : ['fullsimbkg'],
            },
            #'etfakeES' :{
            #    'type' : 'shape',
            #    '+' : dir_systematic('etfakeESUp'),
            #    '-' : dir_systematic('etfakeESDown'),
            #    'apply_to' : ['Zll'],
            #},
            'shape_FAKES' : {
                'type' : 'shape',
                '+' : dir_systematic('Up'),
                '-' : dir_systematic('Down'),
                'apply_to' : ['fakes']#,'efakes','etfakes'],
            },
        }

        
    def make_fakes(self, obj='t'):
        '''Sets up the fakes view'''
        print 'making fakes for %s' %obj
        data_view = self.get_view('data')
        tfakes = views.SubdirectoryView(data_view, 'TauLoose')
        mfakes = views.SubdirectoryView(data_view, 'MuonLoose')
        mtfakes = views.SubdirectoryView(data_view, 'MuonLooseTauLoose')
        central_fakes = SubtractionView(views.SumView(tfakes, mfakes), mtfakes, restrict_positive=True)
        mc_views = self.mc_views()
        if self.use_embedded:            
            mc_views.append(self.get_view('ZetauEmbedded'))
        mc_sum = views.SumView(*mc_views)
        mc_sum_t = views.SubdirectoryView(mc_sum, 'TauLoose')
        fakes_view = SubtractionView(tfakes, mc_sum_t, restrict_positive=True)
        style = data_styles['fakes']
        return views.TitleView(
            views.StyleView(
                fakes_view,
                **remove_name_entry(style)
            ),
            style['name']
        )
        
    def make_embedded(self, normalization_path):
        '''Configures the embedded view'''
        embedded_view = self.get_view('ZetauEmbedded_Run2012*', 'unweighted_view')
        zjets_view = self.get_view('Z*jets_M50_skimmedTT')

        embedded_histo = embedded_view.Get(normalization_path)
        zjets_histo = zjets_view.Get(normalization_path)

        embed_int = embedded_histo.Integral()
        zjets_int = zjets_histo.Integral()
        

        scale_factor = zjets_int / embed_int
        
        scaled_view = views.TitleView(
            views.StyleView(views.ScaleView(embedded_view, scale_factor),
                **remove_name_entry(data_styles['ZetauEmbedded'])
            ),
            'Z #rightarrow #tau#tau (embedded)'
        )
        return scaled_view, scale_factor


    def simple_mcSignal (self, folder, variable, rebin=1, xaxis='',
                         leftside=True, xrange=None, preprocess=None, sort=True,forceLumi=-1):
        'plot only mc signal'
        signalview=[]
        mymax=0
        for n,sig in enumerate(self.mc_samples):
            signal_view=self.get_view(sig)
            if preprocess:
                signal_view=preprocess(signal_view)
            signal_view=self.get_wild_dir(
                self.rebin_view(signal_view,rebin),folder)
            signal=signal_view.Get(variable)
            signalview.append(signal)
            signal.Draw("SAME") if n!=0 else signal.Draw()
            if n==0:
                signal.GetXaxis().SetTitle(xaxis)
                if xrange: signal.GetXaxis().SetRangeUser(xrange[0], xrange[1])
                                        
            if signal.GetBinContent(signal.GetMaximumBin()) > mymax:
                mymax = signal.GetBinContent(signal.GetMaximumBin())
                signal.GetYaxis().SetRangeUser(0, mymax*1.2)
            self.keep.append(signal)
            
        all_var=[]
        all_var.extend(signalview) 
            
        self.add_legend(all_var, leftside, entries=len(signalview))

        
    def simpleplot_mc(self, folder, signal, variable, rebin=1, xaxis='',
                      leftside=True, xrange=None, preprocess=None, sort=True,forceLumi=-1,inflateSig=[1.]):
        ''' Compare Monte Carlo signal to bkg '''
        #path = os.path.join(folder, variable)
        #is_not_signal = lambda x: x is not signame
        #set_trace()

        mc_stack_view = self.make_stack(rebin, preprocess, folder)
        mc_stack=mc_stack_view.Get(variable)
        fakes_view = self.get_view('fakes')
        if preprocess:
            fakes_view = preprocess(fakes_view)
        fakes_view = RebinView(fakes_view, rebin)
        path = os.path.join(folder,variable)
        fakes = fakes_view.Get(path)

        mc_stack.Add(fakes)
        
        self.canvas.SetLogy(True)
        mc_stack.SetTitle('')
        mc_stack.Draw()
        
        mc_stack.GetHistogram().GetXaxis().SetTitle(xaxis)

        if xrange:
            mc_stack.GetXaxis().SetRangeUser(xrange[0], xrange[1])
            mc_stack.Draw()

        signalview=[]
        mymax=0
        for n,sig in enumerate(signal):
                signal_view=self.get_view(sig)
                if preprocess:
                    signal_view=preprocess(signal_view)
                signal_view=self.get_wild_dir(
                    self.rebin_view(signal_view,rebin),folder)
                signal_view=views.ScaleView(signal_view, inflateSig[n])
                signal=signal_view.Get(variable)

                signalview.append(signal)
                signal.Draw("SAME")
                if signal.GetBinContent(signal.GetMaximumBin()) > mymax:
                    mymax = signal.GetBinContent(signal.GetMaximumBin())
                    
                self.keep.append(signal)
        if mymax > mc_stack.GetMaximum():
            mc_stack.SetMaximum(mymax*1.2)

        self.keep.append(mc_stack)
        
        all_var=[]
        all_var.extend([mc_stack]) 
        all_var.extend(signalview) 
            
        self.add_legend(all_var, leftside, entries=len(mc_stack)+len(signalview))

 
    def plot_data(self, folder, variable, rebin=1, xaxis='',
                  leftside=True, xrange=None, preprocess=None):
        ''' Compare Monte Carlo signal to bkg '''
        #path = os.path.join(folder, variable)
        #is_not_signal = lambda x: x is not signame
        #set_trace()
        data_view = self.get_view('data')
        if preprocess:
            data_view = preprocess( data_view )
        data_view = self.get_wild_dir(
            self.rebin_view(data_view, rebin),
            folder
            )
        data = data_view.Get(variable)
        data.Draw()
         
        data.GetXaxis().SetTitle(xaxis)

        if xrange:
            data.GetXaxis().SetRangeUser(xrange[0], xrange[1])
            data.Draw()
        self.keep.append(data)
                
        
    def compare_data(self, folder, variable, folder2, rebin=1, xaxis='',
                     leftside=True, xrange=None, preprocess=None, show_ratio=False, ratio_range=0.2,rescale=1. ):
        ''' Compare Monte Carlo signal to bkg '''
        #path = os.path.join(folder, variable)
        #is_not_signal = lambda x: x is not signame
        #set_trace()
        data_view = self.get_view('data')
        data_view2 = self.get_view('data')
        if preprocess:
            data_view = preprocess( data_view )
        data_view = self.get_wild_dir(
            self.rebin_view(data_view, rebin),
            folder
            )
        data_view2 = self.get_wild_dir(
            self.rebin_view(data_view2, rebin),
            folder2
            )
        data = data_view.Get(variable)
        data2 = data_view2.Get(variable)
         
        data.GetXaxis().SetTitle(xaxis)
        #if (data.Integral()!=0 and data2.Integral()!=0) :
        #    data.Scale(1./data.Integral())
        #    data2.Scale(1./data2.Integral())
        data.Draw()
        data.GetYaxis().SetRangeUser(0, data.GetBinContent(data.GetMaximumBin())*1.2)
        if xrange:
            data.GetXaxis().SetRangeUser(xrange[0], xrange[1])
            data.Draw()

        data2.Draw("SAME")
        data2.SetMarkerColor(2)
        data2.Draw("SAME")
       

        if show_ratio:
            self.add_sn_ratio_plot(data2, data, xrange, ratio_range)

        self.keep.append(data)
        self.keep.append(data2)
        
        
    def add_ratio_bandplot(self, data_hist, mc_stack, err_hist,  x_range=None, ratio_range=0.2):
        #resize the canvas and the pad to fit the second pad
        self.canvas.SetCanvasSize( self.canvas.GetWw(), int(self.canvas.GetWh()*1.3) )
        self.canvas.cd()
        self.pad.SetPad(0, 0.33, 1., 1.)
        self.pad.SetName('HigherPad')
        self.pad.Draw()
        self.canvas.cd()
        #create lower pad
        self.lower_pad = plotting.Pad(0, 0., 1., 0.33)
        self.lower_pad.SetName('LowerPad')
        self.lower_pad.Draw()
        self.lower_pad.cd()

        data_hist.Sumw2()
        
        mc_hist    = None
        if isinstance(mc_stack, plotting.HistStack):
            mc_hist = sum(mc_stack.GetHists())
        else:
            mc_hist = mc_stack
        data_clone = data_hist.Clone()
        data_clone.SetName("dataratio")
        data_clone.Sumw2()
        mc_hist.Sumw2()
        data_clone.Divide(mc_hist)
        data_clone.SetLineColor(1)
        data_clone.SetMarkerStyle(20)
        for ibin in range(0,data_clone.GetXaxis().GetNbins()+1):
            if mc_hist.GetBinContent(ibin)<> 0:
                print ibin, data_hist.GetBinError(ibin), data_hist.GetBinContent(ibin)
                data_clone.SetBinError(ibin,data_hist.GetBinError(ibin)/mc_hist.GetBinContent(ibin))
        band = err_hist.Clone()
        band.SetName("bandplot")
        
        err = []
        ibin =1 
        while ibin < band.GetXaxis().GetNbins()+1:
            if mc_hist.GetBinContent(ibin) <> 0 : 
                err.append((ibin, band.GetBinError(ibin)/band.GetBinContent(ibin)))
            ibin+=1
        band.Sumw2()
        band.Divide(mc_hist.Clone())
        band.SetFillStyle(0)
        #print err
        for ibin in err:
            #print ibin[0], ibin[1]
            band.SetBinError(ibin[0], ibin[1])

        if not x_range:
            nbins = data_clone.GetNbinsX()
            x_range = (data_clone.GetBinLowEdge(1), 
                       data_clone.GetBinLowEdge(nbins)+data_clone.GetBinWidth(nbins))
        else:
            data_clone.GetXaxis().SetRangeUser(*x_range)


        ref_function = ROOT.TF1('f', "1.", *x_range)
        ref_function.SetLineWidth(2)
        ref_function.SetLineStyle(2)
        
        data_clone.Draw()
        
        if ratio_range:
            data_clone.GetYaxis().SetRangeUser(1-ratio_range, 1+ratio_range)

        ref_function.Draw('same')
        band.SetMarkerStyle(0)
        band.SetLineColor(1)
        band.SetFillStyle('3002')
        band.SetFillColor(1)

        band.Draw('psamee2')
       
        self.keep.append(data_clone)
        self.keep.append(band)
        self.keep.append(ref_function)
        self.pad.cd()
        return data_clone

 
    def add_ratio_diff(self, data_hist, mc_stack, err_hist,  x_range=None, ratio_range=0.2):
        #resize the canvas and the pad to fit the second pad
        self.canvas.SetCanvasSize( self.canvas.GetWw(), int(self.canvas.GetWh()) )
        self.canvas.cd()
        self.pad.SetPad(0, 0.33, 1., 1.)
        self.pad.Draw()
        self.canvas.cd()
        #create lower pad
        self.lower_pad = plotting.Pad(0, 0., 1., 0.33)
        self.lower_pad.Draw()
        self.lower_pad.cd()

        
        mc_hist    = None
        if isinstance(mc_stack, plotting.HistStack):
            mc_hist = sum(mc_stack.GetHists())
        else:
            mc_hist = mc_stack
        data_clone = data_hist.Clone()
        data_clone.Sumw2()
        data_clone.Add(mc_hist, -1)
        data_clone.Divide(mc_hist)
        
        band = err_hist.Clone()
        
        err = []
        ibin =1 
        while ibin < band.GetXaxis().GetNbins()+1:
            if mc_hist.GetBinContent(ibin) <> 0 : 
                err.append((ibin, band.GetBinError(ibin)/band.GetBinContent(ibin)))
                #print ibin, band.GetBinError(ibin), band.GetBinContent(ibin), band.GetBinError(ibin)/band.GetBinContent(ibin)
                
            ibin+=1

        #band.Divide(mc_hist.Clone())
        #print band
        for ibin in err:
            band.SetBinError(ibin[0], ibin[1])
            band.SetBinContent(ibin[0], 0. )

        #if self.blind_region:
        #    for ibin in err:
        #        if ibin >= band.FindBin(self.blind_region[0]) and ibin <= band.FindBin(self.blind_region[1]):
        #            band.SetBinError(ibin, 10)

        if not x_range:
            nbins = data_clone.GetNbinsX()
            x_range = (data_clone.GetBinLowEdge(1), 
                       data_clone.GetBinLowEdge(nbins)+data_clone.GetBinWidth(nbins))
        else:
            data_clone.GetXaxis().SetRangeUser(*x_range)


        ref_function = ROOT.TF1('f', "0.", *x_range)
        ref_function.SetLineWidth(2)
        ref_function.SetLineStyle(2)
        
        data_clone.Draw()
 
        if ratio_range:
            data_clone.GetYaxis().SetRangeUser(-ratio_range, +ratio_range)
        ref_function.Draw('same')
        band.SetMarkerStyle(0)
        band.SetLineColor(1)
        band.SetFillStyle('x')
        band.SetFillColor(1)

        band.Draw('samee2')
       
        self.keep.append(data_clone)
        self.keep.append(band)
        self.keep.append(ref_function)
        self.pad.cd()
        return data_clone


    def add_shape_systematics(self, histo, path, view, folder_systematics = [], name_systematics = []):
        '''Adds shape systematics
        add_shape_systematics(self, histo, path, view, folder_systematics = [], name_systematics = []) --> histo
        histo is the central value 
        path is the path if the central value histo
        view contains all the systematics. 
        folder_systematics is a list of tuples with the folders containing shifts (up, down)
        name_systematics is a list of tuples containing the postfix to obtain the shifts (up, down)
        '''
         
        systematics = []
        for sys_up, sys_dw in folder_systematics:
            h_up = view.Get(os.path.join(sys_up, path))
            h_dw = view.Get(os.path.join(sys_dw, path))
            systematics.append(
                (h_up, h_dw)
                )

        #check if we have to apply met uncertainties
        for sys_up, sys_dw in name_systematics:
            h_up = view.Get(path + sys_up)
            h_dw = view.Get(path + sys_dw)
            systematics.append(
                (h_up, h_dw)
            )
        
        #ADD systematics
        return histo_diff_quad(histo, *systematics)
        

    def add_histo_error(self, histo, histoerr):
        clone = histo.GetStack().Last().Clone('errhist')
        for bin in range(1,clone.GetXaxis().GetNbins()):
            error = histoerr.GetBinError(bin)*clone.GetBinContent(bin)/histoerr.GetBinContent(bin) if histoerr.GetBinContent(bin) <>0 else histoerr.GetBinError(bin)
            clone.SetBinError(bin, error )
        return clone


    def plot_simple (self, folder, variable, rebin=1, xaxis='',
                     leftside=True, xrange=None, preprocess=None,
                     show_ratio=False, ratio_range=0.2, sort=True, obj=['e1', 'e2'], plot_data=False):
        path = os.path.join(folder,variable)

        mc_views = self.mc_views(rebin, preprocess)
        mc_stack_view = views.StackView(*mc_views, sorted=sort) 
        mc_stack = mc_stack_view.Get( path )

        #make histo clone for err computation
        mc_sum_view = views.SumView(*mc_views)
        mc_err = mc_sum_view.Get( path )

        mc_sum_view = views.SumView(*mc_views)
        mc_err = mc_sum_view.Get( path )
        

    def plot_with_bkg_uncert (self, folder, variable, rebin=1, xaxis='',
                              leftside=True, xrange=None, preprocess=None,
                              show_ratio=False, ratio_range=0.2, sort=True, obj=['e1', 'e2'], plot_data=False):

        if DEBUG: print 'start plotting', datetime.datetime.now()
        #xsection uncertainties
        #names must match with what defined in self.mc_samples
        xsec_unc_mapper = {
            'TTJets*' : 0.15,
            'T*_t*' : 0.05,
            '[WZ][WZ]' : 0.05, #diboson
            'W*Jets*' : 0.035, #WJets
            'DY*' : 0.10, # theoretical 0.032
            'DYTT*' : 0.10, # theoretical 0.032
         }

        path = os.path.join(folder,variable)
        mc_views_nosys = self.mc_views(rebin, preprocess)
        
        #print self.mc_samples, self.datacard_names
        #make MC views with xsec error
        bkg_views  = dict(
            [(self.datacard_names[i], j) for i, j in zip(self.mc_samples,  mc_views_nosys)]
        )
        
        #get fakes
        fakes_view = self.get_view('fakes')
        if preprocess:
            fakes_view = preprocess(fakes_view)
        fakes_view = RebinView(fakes_view, rebin)
        fakes = fakes_view.Get(path)
        fakes.SetName("fakes")
        
        fakes = SystematicsView.add_error(fakes, 0.30) 

        #add them to backgrounds
        #set_trace()
        if DEBUG: print  'fakes', datetime.datetime.now()    

        mc_views_nosys = self.mc_views(rebin, preprocess)
        mc_views = []
        for view, name in zip(mc_views_nosys, self.mc_samples):
            new = SystematicsView(
                view,
                xsec_unc_mapper.get(name, 0.) #default to 0
            )
            mc_views.append(new)
            
        #make MC views with xsec error

        mc_stack_view =views.StackView(*mc_views, sorted=sort) 
        mc_stack = mc_stack_view.Get(path)
        mc_stack.SetName("mc_stack")
        mc_sum_view = views.SumView(*mc_views_nosys )
        mc_err = mc_sum_view.Get( path )
        mc_err.Sumw2()

        mc_stack.Add(fakes)
        mc_err.Add(fakes)
        
        if DEBUG: print 'mc_sum_view',  datetime.datetime.now()

        mc_err = SystematicsView.add_error( mc_err,  0.025)
        
        self.canvas.SetLogy(True)
        #draw stack
        mc_stack.Draw()
        ##self.keep.append(mc_stack)
        
        #set cosmetics
        self.canvas.SetLogy(True)
        ##self.canvas.SetGridx(True)
        ##self.canvas.SetGridy(True)
        ##self.pad.SetGridx(True)
        ##self.pad.SetGridy(True)
        
        mc_stack.GetHistogram().GetXaxis().SetTitle(xaxis)
        if xrange:
            mc_stack.GetXaxis().SetRangeUser(xrange[0], xrange[1])
            ##mc_stack.Draw()
              
        #set cosmetics 
        mc_err.SetMarkerStyle(0)
        mc_err.SetLineColor(1)
        mc_err.SetFillStyle('x')
        mc_err.SetFillColor(1)
        mc_err.Draw('pe2 same')
        mc_err.SetName('error')
        ##self.keep.append(mc_err)
        if DEBUG: print  'draw mc', datetime.datetime.now()
        #Get signal
        signals = ['GluGlu_LFV_HToMuTau_M125*', 'VBF_LFV_HToMuTau_M125*']
        sig = []
        for name in signals:
            sig_view = self.get_view(name)
            if preprocess:
                sig_view = preprocess(sig_view)
            sig_view = RebinView(sig_view, rebin)
            #if not plot_data:
            #    sig_view = views.ScaleView(sig_view, 100)
            
            histogram = sig_view.Get(path)
            histogram.SetName(name.replace('*', ''))
            histogram.Draw('same')
            #print name, histogram.Integral()
            ##self.keep.append(histogram)
            sig.append(histogram)
        if DEBUG: print  'signal', datetime.datetime.now()
        for lfvh in sig:
            if lfvh.GetMaximum() > mc_stack.GetMaximum():
                mc_stack.SetMaximum(1.2*lfvh.GetMaximum())
        mc_stack.SetMinimum(0.1)
        if plot_data==True:
            # Draw data
            data_view = self.get_view('data')
            if preprocess:
                data_view = preprocess( data_view )
            data_view = self.rebin_view(data_view, rebin)
            data = data_view.Get(path)
            data.SetName("data")

            if self.blind_region and not path.startswith('ss'):
                for bin in range(data.GetNbinsX()+1):
                    bg_count=mc_stack.GetStack().Last().GetBinContent(bin)
                    if bg_count<=0 : bg_count=0
                    sig_count=0
                    for histo in sig:
                        sig_count=histo.GetBinContent(bin)
                        if sig_count<=0: continue
                        #print path, bin,  histo.GetXaxis().GetBinCenter(bin), bg_count, sig_count, float(sig_count)/float(sig_count+bg_count)
                        if bool(bg_count<0.1 and sig_count>0) or ((float(sig_count)/float(sig_count+bg_count))>0.01):
                            data.SetBinContent(bin,0.)
                            data.SetBinError(bin,0.)

            data.Draw('same')
            #print 'data', data.Integral()
            ##self.keep.append(data)
            if DEBUG: print  'data', datetime.datetime.now()
            ## Make sure we can see everything
            if data.GetMaximum() > mc_stack.GetMaximum():
                mc_stack.SetMaximum(1.2*data.GetMaximum()) 
                if lfvh.GetMaximum() > mc_stack.GetMaximum():
                    mc_stack.SetMaximum(1.2*lfvh.GetMaximum()) 
                    
        if plot_data:
            #self.add_legend([data, mc_stack], leftside, entries=len(mc_stack.GetHists())+1)
            self.add_legend([data, sig[0], sig[1], mc_stack], leftside, entries = len(mc_stack.GetHists())+3)
        else:
            self.add_legend([sig[0], sig[1], mc_stack], leftside, entries=len(mc_stack.GetHists())+2)
        if show_ratio and plot_data:
            #self.add_ratio_diff(data, mc_stack, mc_err, xrange, ratio_range)
            self.add_ratio_bandplot(data, mc_stack, mc_err,  xrange, ratio_range) # add_ratio_diff(data, mc_stack, mc_err, xrange, ratio_range)

        if DEBUG: print  'ratio', datetime.datetime.now()
     
  
        #print ROOT.gROOT.ls()
##        for myfile in  ROOT.gROOT.GetListOfFiles():
##            print myfile.GetName()
##            myfile.Close()
##            myfile.delete()
##            

                       
##-----

    def plot_without_uncert (self, folder, variable, rebin=1, xaxis='',
                        leftside=True, xrange=None, preprocess=None,
                              show_ratio=False, ratio_range=0.2, sort=True):
        
        

        mc_stack_view = self.make_stack(rebin, preprocess, folder, sort)

        mc_stack = mc_stack_view.Get(variable)
        mc_stack.Draw()
        
        self.canvas.SetLogy(True)
        mc_stack.GetHistogram().GetXaxis().SetTitle(xaxis)
        if xrange:
            mc_stack.GetXaxis().SetRangeUser(xrange[0], xrange[1])
            mc_stack.Draw()
        self.keep.append(mc_stack)
        

        finalhisto= mc_stack.GetStack().Last().Clone()
        finalhisto.Sumw2()

        histlist = mc_stack.GetHists();
        bkg_stack = mc_stack_view.Get(variable)
        bkg_stack.GetStack().RemoveLast()## mettere il check se c'e` il fake altirmenti histo=mc_stack.GetStack().Last().Clone()
        histo=bkg_stack.GetStack().Last().Clone()
        histo.Sumw2()
        
        fake_p1s_histo=None
      
        if not folder.startswith('tLoose') and not folder.startswith('eLoose') and not folder.startswith('etLoose') :
            isFakesIn= False
            ##isEFakesIn=False
            isETFakesIn=False
            if 'Fakes' in self.mc_samples:
                self.mc_samples.remove('Fakes')  
                if 'finalDYLL' in self.mc_samples: self.mc_samples.remove('finalDYLL')
                isFakesIn=True
            ##if 'eFakes' in self.mc_samples:
            ##    self.mc_samples.remove('eFakes')  
            ##    if 'finalDYLL' in self.mc_samples:  self.mc_samples.remove('finalDYLL')
            ##    isEFakesIn=True
            ##if 'etFakes' in self.mc_samples:
            ##    self.mc_samples.remove('etFakes')  
            ##    if 'finalDYLL' in self.mc_samples:  self.mc_samples.remove('finalDYLL')
            ##    isETFakesIn=True
                

        ibin =1
            
        if isFakesIn:
            self.mc_samples.append('Fakes')
           # self.mc_samples.append('etFakes')
           # self.mc_samples.append('finalDYLL')
       ## if isEFakesIn:
       ##     self.mc_samples.append('eFakes')
       ##     if not 'finalDYLL' in self.mc_samples:  self.mc_samples.append('finalDYLL')
       ## if isETFakesIn:
       ##     self.mc_samples.append('etFakes')
       ##     if not 'finalDYLL' in self.mc_samples:  self.mc_samples.append('finalDYLL')


        finalhisto.Draw('samee2')
        finalhisto.SetMarkerStyle(0)
        finalhisto.SetLineColor(1)
        finalhisto.SetFillStyle(3001)
        finalhisto.SetFillColor(1)

        
        self.keep.append(finalhisto)
        # Draw data
        data_view = self.get_view('data')
        if preprocess:
            data_view = preprocess( data_view )
        data_view = self.get_wild_dir(
            self.rebin_view(data_view, rebin),
            folder
            )
        data = data_view.Get(variable)
        data.Draw('same')
        #print 'data', data.Integral()
        self.keep.append(data)
        ## Make sure we can see everything
        if data.GetMaximum() > mc_stack.GetMaximum():
            mc_stack.SetMaximum(1.2*data.GetMaximum()) 
            
            # # Add legend
        self.add_legend([data, mc_stack], leftside, entries=len(mc_stack.GetHists())+1)
        if show_ratio:
            self.add_ratio_diff(data, mc_stack, finalhisto, xrange, ratio_range)
            
    def write_shapes(self, folder, variable, output_dir, br_strenght=1,
                     rebin=1, last = None,  preprocess=None): #, systematics):
        '''Makes shapes for computing the limit and returns a list of systematic effects to be added to unc.vals/conf 
        make_shapes(folder, variable, output_dir, [rebin=1, preprocess=None) --> unc_conf_lines (list), unc_vals_lines (list)
        '''
        output_dir.cd()
        path = os.path.join(folder,variable)

        # Draw data
        data_view = self.get_view('data')
        if preprocess:
            data_view = preprocess( data_view )
        data_view = self.rebin_view(data_view, rebin)

        data = data_view.Get(path)
       
        if last : data=change_histo_nbins(data, 0, last)
        first_filled, last_filled = find_fill_range(data)
        data.SetName('data_obs')
        data.Write()
        mc_views_nosys = self.mc_views(rebin, preprocess)
        
        mc_subt_view=[]
        for view in mc_views_nosys:
            new = SubtractionView(view,
                                  views.SubdirectoryView(view, 'tLoose'),
                                  restrict_positive=True)
            
            mc_subt_view.append(new)
        

        #make MC views with xsec error
        bkg_views  = dict(
            [(self.datacard_names[i], j) for i, j in zip(self.mc_samples,  mc_subt_view)]
        )
        bkg_histos = {}
        for name, view in bkg_views.iteritems():
            if DEBUG : print name, path
            mc_histo = view.Get(path)
            if DEBUG : print name, path
            if last : mc_histo = change_histo_nbins(mc_histo, 0, last)
            if DEBUG : print name, path
            first_filled_bkg, last_filled_bkg= find_fill_range(mc_histo)
            if DEBUG : print name, path
            bkg_histos[name] = mc_histo.Clone()
            mc_histo.SetName(name)
            if DEBUG : print name, mc_histo.GetName()
            mc_histo.Write()

        if self.use_embedded:            
            view = self.get_view('ZetauEmbedded')
            if preprocess:
                view = preprocess(view)
            view = self.rebin_view(view, rebin)
            name = self.datacard_names['ZetauEmbedded']
            bkg_views[name] = view
            mc_histo = view.Get(path)
            if last : mc_histo = change_histo_nbins(mc_histo, 0, last)
            first_filled_bkg, last_filled_bkg= find_fill_range(mc_histo)
            bkg_histos[name] = mc_histo.Clone()
            ##mc_histo = remove_empty_bins(
            ##    mc_histo, weight,
            ##    first_filled_bkg, last_filled_bkg)
            mc_histo.SetName(name)
            mc_histo.Write()
          
        fakes_view = self.get_view('fakes') 
        d_view = self.get_view('data')
        ##weights_view = views.SumView(
        ##    views.SubdirectoryView(d_view, 'tLoose'),
        ##    #views.SubdirectoryView(d_view, 'eLoose'),
        ##    #views.SubdirectoryView(d_view, 'etLoose')
        ##    )
        if preprocess:
            fakes_view = preprocess(fakes_view)    
            ##weights_view = preprocess(weights_view)
        ##weights = weights_view.Get(os.path.join(folder,'weight'))
        #print folder
        fakes_view = self.rebin_view(fakes_view, rebin)
        bkg_views['fakes'] = fakes_view
        ##bkg_weights['fakes'] = mean(weights)
        fake_shape = bkg_views['fakes'].Get(path)
        if last : fake_shape = change_histo_nbins(fake_shape, 0, last)
        bkg_histos['fakes'] = fake_shape.Clone()
        if last : bkg_histos['fakes'] =change_histo_nbins(bkg_histos['fakes'] , 0, last)
        first_filled_bkg, last_filled_bkg = find_fill_range(bkg_histos['fakes'])
        ##fake_shape = remove_empty_bins(
        ##    fake_shape, bkg_weights['fakes'],
        ##    first_filled_bkg, last_filled_bkg)
        fake_shape.SetName('fakes')
        fake_shape.Write()
        if DEBUG : print 'fakes', fake_shape.GetName()

        #Get signal
        signals = [
            'GluGlu_LFV_HToETau_M200*',
            'GluGlu_LFV_HToETau_M300*',
            'GluGlu_LFV_HToETau_M450*',
            'GluGlu_LFV_HToETau_M600*',
            'GluGlu_LFV_HToETau_M750*',
            'GluGlu_LFV_HToETau_M900*'#'ggM300ETau', 'ggM450ETau', 'ggM600ETau', 'ggM750ETau', 'ggM900ETau'
        ]
        for name in signals:
            sig_view = self.get_view(name)
            card_name = self.datacard_names[name]
            if preprocess:
                sig_view = preprocess(sig_view)
            sig_view = views.ScaleView(
                RebinView(sig_view, rebin),
                br_strenght
                )
            ##weights = self.get_view(name, 'weight')
            bkg_views[card_name] = sig_view
            ##bkg_weights[card_name] = weights
            histogram = sig_view.Get(path)
            if last : histogram = change_histo_nbins(histogram, 0, last)
            bkg_histos[card_name] = histogram.Clone()
            first_filled_bkg, last_filled_bkg = find_fill_range(bkg_histos[card_name])
            ##histogram = remove_empty_bins(
            ##    histogram, bkg_weights[card_name],
            ##    first_filled_bkg, last_filled_bkg)
            histogram.SetName(card_name)
            histogram.Write()
            if DEBUG : print name, histogram.GetName()


        unc_conf_lines = []
        unc_vals_lines = []


        
        
        return unc_conf_lines, unc_vals_lines
   
##----- 
  
    def write_shapes_with_syst(self, folder, variable, output_dir, br_strenght=1,
                                rebin=1, last=None, preprocess=None): #, systematics):
        '''Makes shapes for computing the limit and returns a list of systematic effects to be added to unc.vals/conf 
        make_shapes(folder, variable, output_dir, [rebin=1, preprocess=None) --> unc_conf_lines (list), unc_vals_lines (list)
        '''
        output_dir.cd()
        path = os.path.join(folder,variable)

        mc_views_nosys = self.mc_views(rebin, preprocess)
        mc_subt_view=[]
        
        #print self.mc_samples, self.datacard_names
        #make MC views with xsec error
        bkg_views  = dict(
            [(self.datacard_names[i], j) for i, j in zip(self.mc_samples,  mc_views_nosys)]
        )
        bkg_histos = {}

        mc_stack_view = self.make_stack(rebin, preprocess, folder)

        mc_stack = mc_stack_view.Get(variable)

        
        for name, view in bkg_views.iteritems():
            if DEBUG : print name, path
            mc_histo = view.Get(path)
            if DEBUG : print name, path
            if last : mc_histo = change_histo_nbins(mc_histo, 0, last)
            if DEBUG : print name, path
            first_filled_bkg, last_filled_bkg= find_fill_range(mc_histo)
            if DEBUG : print name, path
            bkg_histos[name] = mc_histo.Clone()
            mc_histo.SetName(name)
            if DEBUG : print name, mc_histo.GetName()
            mc_histo.Write()

      
        if self.use_embedded:            
            view = self.get_view('ZetauEmbedded')
            if preprocess:
                view = preprocess(view)
            view = self.rebin_view(view, rebin)
            name = self.datacard_names['ZetauEmbedded']
            bkg_views[name] = view
            mc_histo = view.Get(path)
            if last : mc_histo = change_histo_nbins(mc_histo, 0, last)
            first_filled_bkg, last_filled_bkg= find_fill_range(mc_histo)
            bkg_histos[name] = mc_histo.Clone()
            ##mc_histo = remove_empty_bins(
            ##    mc_histo, weight,
            ##    first_filled_bkg, last_filled_bkg)
            mc_histo.SetName(name)
            mc_histo.Write()
          
        fakes_view = self.get_view('fakes') 

        if preprocess:
            fakes_view = preprocess(fakes_view)    
        fakes_view = self.rebin_view(fakes_view, rebin)
        bkg_views['fakes'] = fakes_view
        ##bkg_weights['fakes'] = mean(weights)
        fake_shape = bkg_views['fakes'].Get(path)
        if last : fake_shape = change_histo_nbins(fake_shape, 0, last)
        bkg_histos['fakes'] = fake_shape.Clone()
        if last : bkg_histos['fakes'] =change_histo_nbins(bkg_histos['fakes'] , 0, last)
        first_filled_bkg, last_filled_bkg = find_fill_range(bkg_histos['fakes'])
        ##fake_shape = remove_empty_bins(
        ##    fake_shape, bkg_weights['fakes'],
        ##    first_filled_bkg, last_filled_bkg)
        fake_shape.SetName('fakes')
        fake_shape.Write()
        
        
        if DEBUG : print 'fakes', fake_shape.GetName()

        #Get signal
        signals = [
            'GluGlu_LFV_HToETau_M200*',
            'GluGlu_LFV_HToETau_M300*',
            'GluGlu_LFV_HToETau_M450*',
            'GluGlu_LFV_HToETau_M600*',
            'GluGlu_LFV_HToETau_M750*',
            'GluGlu_LFV_HToETau_M900*'#'ggM300ETau', 'ggM450ETau', 'ggM600ETau', 'ggM750ETau', 'ggM900ETau'
        ]
        sig=[]
        for name in signals:
            sig_view = self.get_view(name)
            card_name = self.datacard_names[name]
            if preprocess:
                sig_view = preprocess(sig_view)
            sig_view = views.ScaleView(
                RebinView(sig_view, rebin),
                br_strenght
                )
            ##weights = self.get_view(name, 'weight')
            bkg_views[card_name] = sig_view
            ##bkg_weights[card_name] = weights
            histogram = sig_view.Get(path)
            if last : histogram = change_histo_nbins(histogram, 0, last)
            bkg_histos[card_name] = histogram.Clone()
            first_filled_bkg, last_filled_bkg = find_fill_range(bkg_histos[card_name])
            ##histogram = remove_empty_bins(
            ##    histogram, bkg_weights[card_name],
            ##    first_filled_bkg, last_filled_bkg)
            histogram.SetName(card_name)
            #print name, histogram.Integral()
            histogram.Write()
            if DEBUG : print name, histogram.GetName()
            sig.append(histogram)
            
       # Draw data
        data_view = self.get_view('data')
        if preprocess:
            data_view = preprocess( data_view )
        data_view = self.rebin_view(data_view, rebin)

        data = data_view.Get(path)
       
        if last : data=change_histo_nbins(data, 0, last)
        first_filled, last_filled = find_fill_range(data)
        data.SetName('data_obs')
        if self.blind_region:
            for bin in range(data.GetNbinsX()+1):
                bg_count=mc_stack.GetStack().Last().GetBinContent(bin)
                if bg_count<=0 : bg_count=0
                sig_count=0.0001
                for histo in sig:
                    sig_count=histo.GetBinContent(bin)
                    if sig_count<=0: sig_count=0
                    #print path, bin,  histo.GetXaxis().GetBinCenter(bin), bg_count, sig_count, float(sig_count)/float(sig_count+bg_count)
                    if bg_count==0 or (float(sig_count)/float(sig_count+bg_count)>0.01):
                        data.SetBinContent(bin,0.)
                        data.SetBinError(bin,0.)

        data.Write()

 
  
        unc_conf_lines = []
        unc_vals_lines = []
        category_name  = output_dir.GetName()
        for unc_name, info in self.systematics.iteritems():
            targets = []
            #print info['apply_to']
            for target in info['apply_to']:
                if target in self.sample_groups:
                    targets.extend(self.sample_groups[target])
                else:
                    targets.append(target)

            shift = 0.
            path_up = info['+'](path)
            path_dw = info['-'](path)
            if DEBUG: print path_up, path_dw
            for target in targets:
                #print target
                up      = bkg_views[target].Get(
                    path_up
                )
                down    = bkg_views[target].Get(
                    path_dw
                )
                pathlist = [ path_up, path_dw]
                histolist = [up, down]
                    
                if info['type'] == 'yield':
                    central = bkg_histos[target]
                    integral = central.Integral()
                    integral_up = up.Integral()
                    integral_down = down.Integral()
                    if integral == 0  and integral_up == 0 and integral_down ==0 :
                        shift=shift
                    else:
                        shift = max(
                            shift,
                            (integral_up - integral) / integral,
                            (integral - integral_down) / integral
                        )
                elif info['type'] == 'shape':
                    #remove empty bins also for shapes 
                    #(but not in general to not spoil the stat uncertainties)
                    #up = remove_empty_bins(up, bkg_weights[target])
                    #down = remove_empty_bins(down, bkg_weights[target])
                    up.SetName('%s_%sUp' % (target, unc_name))
                    down.SetName('%s_%sDown' % (target, unc_name))
                    up.Write()
                    down.Write()
                elif info['type'] == 'stat':
                    nbins = up.GetNbinsX()
                    up.Rebin(nbins)
                    yield_val = up.GetBinContent(1)
                    yield_err = up.GetBinError(1)
                    #print target, yield_val, yield_err, 
                    if yield_val==0:
                        unc_value = 0.
                    else:
                        unc_value = 1. + (yield_err / yield_val)
                    #stat_unc_name = '%s_%s_%s' % (target, category_name, unc_name)
                    #unc_conf_lines.append('%s %s' % (stat_unc_name, unc_conf))
                    #unc_vals_lines.append(
                    #    '%s %s %s %.2f' % (category_name, target, stat_unc_name, unc_value)
                    #)
                else:
                    raise ValueError('systematic uncertainty type:"%s" not recognised!' % info['type'])

        return unc_conf_lines, unc_vals_lines
    
 
