'''

Base class to do WH plotting.

Author: Evan K. Friis, UW

Takes as input a set of ROOT [files] with analysis histgrams, and the
corresponding lumicalc.sum [lumifiles] that hve the effective lumi for each
sample.

If [blind] is true, data in the p1p2p3 region will not be plotted.

'''

import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter        import Plotter
from FinalStateAnalysis.PlotTools.BlindView      import BlindView
from FinalStateAnalysis.PlotTools.PoissonView    import PoissonView
from FinalStateAnalysis.PlotTools.MedianView     import MedianView
from FinalStateAnalysis.PlotTools.ProjectionView import ProjectionView
from FinalStateAnalysis.PlotTools.FixedIntegralView import FixedIntegralView
from FinalStateAnalysis.PlotTools.RebinView  import RebinView
from FinalStateAnalysis.MetaData.data_styles import data_styles, colors
from FinalStateAnalysis.PlotTools.decorators import memo
from FinalStateAnalysis.MetaData.datacommon  import br_w_leptons, br_z_leptons
from optparse import OptionParser
import os
import ROOT
import glob
import math
import logging
from fnmatch import fnmatch
from yellowhiggs import xs, br, xsbr

parser = OptionParser(description=__doc__)
parser.add_option('--dry-run', action='store_true', dest='dry_run', default = False,
                  help='produces only shape file and minimal histograms')
parser.add_option('--prefix', metavar='label', type=str, dest='prefix', default = '',
                  help='prefix to eppend before histogram name o be used to make the shapes' )
parser.add_option('--prefixes', metavar='label', type=str, dest='prefixes', default = '',
                  help='prefix to eppend before histogram name o be used to make the shapes' )

def get_chi_square(hdata, hexp):
    chi2  = 0.
    nbins = 0.
    for i in xrange(1, hdata.GetNbinsX()+1):
        data  = hdata.GetBinContent(i)
        edata = hdata.GetBinError(i)
        exp   = hexp.GetBinContent(i)
        eexp  = hexp.GetBinError(i)
        if data > 0:
            chi2  += (data - exp)**2/(edata**2 + eexp**2)
            nbins += 1
    return chi2, nbins
        

def quad(*xs):
    return math.sqrt(sum(x * x for x in xs))

def create_mapper(mapping):
    def _f(path):
        for key, out in mapping.iteritems():
            if key == path:
                path = path.replace(key,out)
        return path
    return _f

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

class BackgroundErrorView(object):
    ''' Compute the total background error in each bin. '''
    def __init__(self, fakes, wz, zz, charge_fake, wz_error=0.1, zz_error=0.04,
                 fake_error=0.):
        self.fakes = fakes
        self.wz = wz
        self.zz = zz
        self.fake_error = fake_error
        self.wz_error = wz_error
        self.zz_error = zz_error
        self.charge_fake = charge_fake

    def Get(self, path):
        fakes = self.fakes.Get(path)
        wz = self.wz.Get(path)
        zz = self.zz.Get(path)
        charge_fake = self.charge_fake.Get(path)

        bkg_error = wz.Clone()
        bkg_error.SetTitle("Bkg. Unc.")
        bkg_error.Reset()
        for bin in range(1, bkg_error.GetNbinsX() + 1):
            error = quad(
                fakes.GetBinError(bin),
                fakes.GetBinContent(bin) * self.fake_error,
                wz.GetBinContent(bin) * self.wz_error,
                zz.GetBinContent(bin) * self.zz_error,
                charge_fake.GetBinError(bin)
            )
            total = (
                fakes.GetBinContent(bin) +
                wz.GetBinContent(bin) +
                zz.GetBinContent(bin) +
                charge_fake.GetBinContent(bin)
            )
            bkg_error.SetBinContent(bin, total)
            bkg_error.SetBinError(bin, error)
        bkg_error.SetMarkerSize(0)
        bkg_error.SetFillColor(1)
        bkg_error.SetFillStyle(3013)
        bkg_error.legendstyle = 'f'
        return bkg_error


class QCDCorrectionView(object):
    ''' Get the estimate of the fake rate, correcting for QCD contamination

    The amount of QCD contamination "q" in each control region (cr) bin
    is cr_qcd_est/cr.

    The final estimate is then:

        q*cr_qcd_weight + (1-q)*cr_ewk_weight

    '''
    def __init__(self, data_view, cr, cr_qcd_est, cr_ewk_weight,
                 cr_qcd_weight):
        self.cr = views.SubdirectoryView(data_view, cr)
        self.cr_qcd_est = views.SubdirectoryView(data_view, cr_qcd_est)
        self.cr_ewk_weight = views.SubdirectoryView(data_view, cr_ewk_weight)
        self.cr_qcd_weight = views.SubdirectoryView(data_view, cr_qcd_weight)

    def Get(self, path):
        ''' Get the fake est histo corrected for the QCD effect '''

        # Compute the fraction of QCD in each bin
        qcd_fraction = self.cr_qcd_est.Get(path).Clone()
        qcd_fraction.Divide(self.cr.Get(path))
        # A histogram where each bin is initially 1.0
        ewk_fraction = self.cr_qcd_est.Get(path).Clone()
        ewk_fraction.Reset()
        # Make sure each bin is <= 1
        for bin in range(0, qcd_fraction.GetNbinsX() + 1):
            ewk_fraction.SetBinContent(bin, 1)
            ewk_fraction.SetBinError(bin, 0)
            #print bin, qcd_fraction.GetBinContent(bin)
            if qcd_fraction.GetBinContent(bin) > 1:
                qcd_fraction.SetBinContent(bin, 1)

        ewk_fraction.Sumw2()
        ewk_fraction.Add(qcd_fraction, -1)
        for bin in range(0, qcd_fraction.GetNbinsX() + 1):
            pass
            #print ewk_fraction.GetBinContent(bin)
        print "QCD correction in %s" % path

        cr_ewk_weight_corrected = self.cr_ewk_weight.Get(path).Clone()
        print "ewk", cr_ewk_weight_corrected.Integral()
        cr_ewk_weight_corrected.Multiply(ewk_fraction)

        cr_qcd_weight_corrected = self.cr_qcd_weight.Get(path).Clone()
        print "qcd", cr_qcd_weight_corrected.Integral()
        cr_qcd_weight_corrected.Multiply(qcd_fraction)

        total = cr_ewk_weight_corrected.Clone()
        total.Add(cr_qcd_weight_corrected)
        print "total", total.Integral()

        return total


def make_styler(color, format=None):
    def unsuck(x):
        x.SetFillStyle(0)
        x.SetLineColor(color)
        x.SetLineWidth(2)
        x.SetMaximum(1.5*x.GetMaximum())
        if format:
            x.drawstyle = format
    return unsuck


class WHPlotterBase(Plotter):
    def __init__(self, channel, obj1_charge_mapper={}, obj2_charge_mapper={}):
        cwd = os.getcwd()
        os.chdir( os.path.dirname(__file__) )
        self.channel = channel
        jobid = os.environ['jobid']
        print "\nPlotting %s for %s\n" % (channel, jobid)

        # Figure out if we are 7 or 8 TeV
        period = '7TeV' if '7TeV' in jobid else '8TeV'
        self.period = period
        self.sqrts = 7 if '7TeV' in jobid else 8
        samples = [
            'Zjets_M50',
            'WplusJets_madgraph',
            'WZJetsTo3LNu*',
            'ZZ*',
            'VH*',
            'WW*',
            'TTplusJets_madgraph',
            "data_*",
        ]

        files = []
        lumifiles = []

        for x in samples:
            files.extend(glob.glob('results/%s/WHAnalyze%s/%s.root' % (jobid, channel, x)))
            lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))

        self.outputdir = 'results/%s/plots/%s' % (jobid, channel.lower())
        self.base_out_dir = self.outputdir
        if not os.path.exists(self.outputdir):
            os.makedirs(self.outputdir)

        blinder = None
        blind   = 'blind' not in os.environ or os.environ['blind'] == 'YES'
        print '\n\nRunning Blind: %s\n\n' % blind
        self.blind = blind
        self.obj1_charge_mapper=obj1_charge_mapper #maps scaled charge flip histograms to the ones of the normal categories
        self.obj2_charge_mapper=obj2_charge_mapper #maps scaled charge flip histograms to the ones of the normal categories
        if blind:
            # Don't look at the SS all pass region
            blinder = lambda x: BlindView(x, "ss/p1p2p3/.*")
        super(WHPlotterBase, self).__init__(files, lumifiles, self.outputdir,
                                            blinder)
        self.defaults = {} #allows to set some options and avoid repeating them each function call
        os.chdir( cwd )
        #create a fake wiew summing up all HWW
        self.views['VH_hww_sum'] = {
            'unweighted_view' : views.SumView(
                *[item['unweighted_view'] for name, item in self.views.iteritems() if fnmatch(name, 'VH_*_HWW*')]
            )
        }

    def set_subdir(self, folder):
        self.outputdir = '/'.join([self.base_out_dir, folder])

    def apply_to_dict(self, dictionary, viewtype, *args, **kwargs): #project, project_axis, rebin):
        ret = {}
        for key, val in dictionary.iteritems():
            if isinstance(val, dict):
                ret[key] = self.apply_to_dict(val, viewtype, *args, **kwargs) #project, project_axis, rebin)
            else:
                ret[key] = viewtype(val, *args, **kwargs) # self.rebin_view( ProjectionView(val, project_axis, project), rebin )
        return ret

    @memo
    def make_signal_views(self, unblinded=False, qcd_weight_fraction=0):
        ''' Make signal views with FR background estimation '''

        wz_view_tautau = views.SubdirectoryView(
            self.get_view('WZJetsTo3LNu*ZToTauTau*'),
            'ss/p1p2p3/'
        )
        wz_view_3l = views.SubdirectoryView(
            self.get_view('WZJetsTo3LNu_pythia'),
            'ss/p1p2p3/'
        )
        zz_view = views.SubdirectoryView(
            self.get_view('ZZJetsTo4L*'),
            'ss/p1p2p3/'
        )
        all_data_view = self.get_view('data')
        if unblinded:
            all_data_view = self.get_view('data', 'unblinded_view')

        data_view = views.SubdirectoryView(all_data_view, 'ss/p1p2p3/')

        def make_fakes(qcd_fraction):
            def make_fakes_view(weight_type, scale):
                scaled_data = views.ScaleView(all_data_view, scale)
                # View of weighted obj1-fails data
                obj1_view = views.SubdirectoryView(
                    scaled_data, 'ss/f1p2p3/%s1' % weight_type)
                # View of weighted obj2-fails data
                obj2_view = views.SubdirectoryView(
                    scaled_data, 'ss/p1f2p3/%s2' % weight_type)
                # View of weighted obj1&2-fails data
                obj12_view = views.SubdirectoryView(
                    scaled_data, 'ss/f1f2p3/%s12' % weight_type)

                # Give the individual object views nice colors
                obj1_view = views.TitleView(
                    views.StyleView(obj1_view, **remove_name_entry(data_styles['TT*'])),
                    'Reducible bkg. 1')
                obj2_view = views.TitleView(
                    views.StyleView(obj2_view, **remove_name_entry(data_styles['QCD*'])),
                    'Reducible bkg. 2')
                obj12_view = views.TitleView(
                    views.StyleView(obj12_view, **remove_name_entry(data_styles['WW*'])),
                    'Reducible bkg. 12')

                subtract_obj12_view = views.ScaleView(obj12_view, -1)
                return obj1_view, obj2_view, obj12_view, subtract_obj12_view

            qcd1, qcd2, qcd12, negqcd12 = make_fakes_view('q', qcd_fraction)
            wjet1, wjet2, wjet12, negwjet12 = make_fakes_view(
                'w', 1 - qcd_fraction)

            obj1_view = views.SumView(qcd1, wjet1)
            obj2_view = views.SumView(qcd2, wjet2)
            obj12_view = views.SumView(qcd12, wjet12)
            subtract_obj12_view = views.SumView(negqcd12, negwjet12)

            # Corrected fake view
            fakes_view = views.SumView(obj1_view, obj2_view, subtract_obj12_view)
            fakes_view = views.TitleView(
                views.StyleView(fakes_view, **remove_name_entry(data_styles['Zjets*'])), 'Reducible bkg.')
            return obj1_view, obj2_view, obj12_view, fakes_view

        obj1_view, obj2_view, obj12_view, fakes_view = make_fakes(qcd_weight_fraction)
        fakes_view_05 = make_fakes(0.5)[-1]
        fakes_view_0  = make_fakes(0)[-1]
        fakes_view_1  = make_fakes(1)[-1]
 
        charge_fakes = views.TitleView( 
            views.StyleView(
                views.SumView(
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2p3/c1'),
                        create_mapper(self.obj1_charge_mapper)
                        ),
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2p3/c2'),
                        create_mapper(self.obj2_charge_mapper)
                        ),
                    ),
                **remove_name_entry(data_styles['TT*'])),
            'Charge mis-id')

        charge_fakes_sysup = views.TitleView( 
            views.StyleView(
                views.SumView(
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2p3/c1_sysup'),
                        create_mapper(self.obj1_charge_mapper)
                        ),
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2p3/c2_sysup'),
                        create_mapper(self.obj2_charge_mapper)
                        ),
                    ),
                **remove_name_entry(data_styles['TT*'])),
            'Charge mis-id')

        #charge_fakes = MedianView(highv=charge_fakes_sysup, centv=charge_fakes)

        output = {
            'wz': wz_view_tautau,
            'wz_3l': wz_view_3l,
            'zz': zz_view,
            'data': data_view,
            'obj1': obj1_view,
            'obj2': obj2_view,
            'obj12': obj12_view,
            'fakes': fakes_view,
            'weighted_fakes' : {
                0.  : fakes_view_0,
                0.5 : fakes_view_05,
                1.  : fakes_view_1,
            },
            'charge_fakes': {
                'central' : charge_fakes,
                'sys_up'  : charge_fakes_sysup,
                }
        }

        # Add signal
        data_total_lumi = self.views['data']['intlumi']
        for mass in range(110, 165, 5):
            vh_view = views.SubdirectoryView(
                self.get_view('VH_*%i' % mass),
                'ss/p1p2p3/'
            )
            output['vh%i' % mass] = vh_view
            if mass % 10 == 0 and mass < 150:
                # Only have 10 GeV steps for WW
                ww_view = views.SubdirectoryView(
                    self.get_view('VH_%i_HWW*' % mass),
                'ss/p1p2p3/'
                )
                output['vh%i_hww' % mass] = ww_view
                output['signal%i' % mass] = views.SumView(ww_view, vh_view)

        return output

    def make_qcd_proj_views(self, control_region, rebin):
        ''' Make views when obj1 or obj2 fails, projecting QCD in

        QCD comes from the triple fake region
        '''
        all_data_view = self.rebin_view(self.get_view('data'), rebin)

        mapping = {
            1: {
                'obs': 'ss/f1p2p3',
                'qcd': 'ss/f1f2f3/w23',
            },
            2: {
                'obs': 'ss/p1f2p3',
                'qcd': 'ss/f1f2f3/w13',
            },
        }

        data_view = views.TitleView(views.SubdirectoryView(
            all_data_view, mapping[control_region]['obs']),
            "Anti-iso obj %i" % control_region)

        qcd_view = views.TitleView(views.SubdirectoryView(
            all_data_view, mapping[control_region]['qcd']), "QCD")

        qcd_view = views.StyleView(
            qcd_view, drawstyle='hist', linecolor=colors['red'],
            fillstyle=0, legendstyle='l'
        )
        return {'obs': data_view, 'qcd': qcd_view}

    @memo
    def make_obj3_fail_cr_views(self, qcd_correction=False,
                                qcd_weight_fraction=0):
        ''' Make views when obj3 fails, estimating the bkg in obj1 pass using
            f1p2f3 '''
        wz_view = views.SubdirectoryView(
            self.get_view('WZJetsTo3LNu*ZToTauTau*'),
            'ss/p1p2f3/'
        )
        wz_view_3l = views.SubdirectoryView(
            self.get_view('WZJetsTo3LNu_pythia'),
            'ss/p1p2f3/'
        )
        zz_view = views.SubdirectoryView(
            self.get_view('ZZJetsTo4L*'),
            'ss/p1p2f3/'
        )
        all_data_view = self.get_view('data')
        data_view = views.SubdirectoryView(all_data_view, 'ss/p1p2f3/')

        def make_fakes(qcd_fraction):
            def make_fakes_view(weight_type, scale):
                scaled_data = views.ScaleView(all_data_view, scale)
                # View of weighted obj1-fails data
                obj1_view = views.SubdirectoryView(
                    scaled_data, 'ss/f1p2f3/%s1' % weight_type)
                # View of weighted obj2-fails data
                obj2_view = views.SubdirectoryView(
                    scaled_data, 'ss/p1f2f3/%s2' % weight_type)
                # View of weighted obj1&2-fails data
                obj12_view = views.SubdirectoryView(
                    scaled_data, 'ss/f1f2f3/%s12' % weight_type)

                # Give the individual object views nice colors
                obj1_view = views.TitleView(
                    views.StyleView(obj1_view, **remove_name_entry(data_styles['TT*'])),
                    'Reducible bkg. 1')
                obj2_view = views.TitleView(
                    views.StyleView(obj2_view, **remove_name_entry(data_styles['QCD*'])),
                    'Reducible bkg. 2')
                obj12_view = views.TitleView(
                    views.StyleView(obj12_view, **remove_name_entry(data_styles['WW*'])),
                    'Reducible bkg. 12')

                subtract_obj12_view = views.ScaleView(obj12_view, -1)
                return obj1_view, obj2_view, obj12_view, subtract_obj12_view

            qcd1, qcd2, qcd12, negqcd12 = make_fakes_view('q', qcd_fraction)
            wjet1, wjet2, wjet12, negwjet12 = make_fakes_view(
                'w', 1 - qcd_fraction)

            obj1_view  = views.SumView(qcd1, wjet1)
            obj2_view  = views.SumView(qcd2, wjet2)
            obj12_view = views.SumView(qcd12, wjet12)
            subtract_obj12_view = views.SumView(negqcd12, negwjet12)

            # Corrected fake view
            fakes_view = views.SumView(obj1_view, obj2_view, subtract_obj12_view)
            fakes_view = views.TitleView(
                views.StyleView(fakes_view, **remove_name_entry(data_styles['Zjets*'])), 'Reducible bkg.')
            return obj1_view, obj2_view, obj12_view, fakes_view

        obj1_view, obj2_view, obj12_view, fakes_view = make_fakes(qcd_weight_fraction)
        fakes_view_05 = make_fakes(0.5)[-1]
        fakes_view_0  = make_fakes(0)[-1]
        fakes_view_1  = make_fakes(1)[-1]

        style_dict_no_name = remove_name_entry(data_styles['TT*'])
        charge_fakes = views.TitleView( 
            views.StyleView(
                views.SumView(
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2f3/c1'),
                        create_mapper(self.obj1_charge_mapper)
                        ),
                    views.PathModifierView(
                        views.SubdirectoryView(all_data_view, 'os/p1p2f3/c2'),
                        create_mapper(self.obj2_charge_mapper)
                        ),
                    ),
                **style_dict_no_name),
            'Charge mis-id')
        
        charge_fakes_sysup = views.TitleView(
                 views.StyleView(
                     views.SumView(
                         views.PathModifierView(
                             views.SubdirectoryView(all_data_view, 'os/p1p2f3/c1_sysup'),
                             create_mapper(self.obj1_charge_mapper)
                         ),
                         views.PathModifierView(
                             views.SubdirectoryView(all_data_view, 'os/p1p2f3/c2_sysup'),
                             create_mapper(self.obj2_charge_mapper)
                         ),
                     ),
                 **style_dict_no_name),
            'Charge mis-id')

        #charge_fakes = MedianView(highv=charge_fakes_sysup, centv=charge_fakes)
                            
        output = {
            'wz': wz_view,
            'wz_3l': wz_view_3l,
            'zz': zz_view,
            'data': data_view,
            'obj1': obj1_view,
            'obj2': obj2_view,
            'obj12': obj12_view,
            'fakes': fakes_view,
            'weighted_fakes' : {
                0.  : fakes_view_0,
                0.5 : fakes_view_05,
                1.  : fakes_view_1,
            },
            'charge_fakes': {
                'central' : charge_fakes,
                'sys_up'  : charge_fakes_sysup,
                }
        }

        #Add signal @ 120, just mo make bkg fitting easier
        mass = 120
        vh_view = views.SubdirectoryView(
            self.get_view('VH_*%i' % mass),
            'ss/p1p2f3/'
        )
        output['vh%i' % mass] = vh_view
        ww_view = views.SubdirectoryView(
            self.get_view('VH_%i_HWW*' % mass),
            'ss/p1p2f3/'
        )
        output['vh%i_hww' % mass] = ww_view
        output['signal%i' % mass] = views.SumView(ww_view, vh_view)

        return output

    def make_wz_cr_views(self, rebin):
        ''' Make WZ control region views with FR background estimation '''

        wz_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('WZJetsTo3LNu*'), rebin),
            'ss/p1p2p3_enhance_wz/'
        )
        zz_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('ZZJetsTo4L*'), rebin),
            'ss/p1p2p3_enhance_wz/'
        )
        all_data_view = self.rebin_view(self.get_view('data'), rebin)
        data_view = views.SubdirectoryView(
            all_data_view, 'ss/p1p2p3_enhance_wz/')

        # View of weighted obj2-fails data
        fakes_view = views.SubdirectoryView(
            all_data_view, 'ss/p1f2p3_enhance_wz/w2')
        fakes_view = views.StyleView(fakes_view, **remove_name_entry(data_styles['Zjets*']))

        # Correct
        wz_in_fakes_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('WZJetsTo3LNu*'), rebin),
            'ss/p1f2p3_enhance_wz/w2'
        )
        zz_in_fakes_view = views.SubdirectoryView(
            self.rebin_view(self.get_view('ZZJetsTo4L*'), rebin),
            'ss/p1f2p3_enhance_wz/w2'
        )

        diboson_view = views.SumView(wz_in_fakes_view, zz_in_fakes_view)
        inverted_diboson_view = views.ScaleView(diboson_view, -1)

        fakes_view = views.SumView(fakes_view, inverted_diboson_view)

        fakes_view = views.TitleView(fakes_view, 'Reducible bkg.')

        output = {
            'wz': wz_view,
            'zz': zz_view,
            'data': data_view,
            'fakes': fakes_view
        }

        # Add signal
        for mass in [110, 120, 130, 140]:
            vh_view = views.SubdirectoryView(
                self.rebin_view(self.get_view('VH_*%i' % mass, 'unweighted_view'), rebin),
                'ss/p1p2p3/'
            )
            output['vh%i' % mass] = vh_view

        return output

    def write_shapes(self, variable, rebin, outdir,
                     qcd_fraction=0, show_charge_fakes=False,
                     project=None, project_axis=None):
        ''' Write final shapes for [variable] into a TDirectory [outputdir] '''
        show_charge_fakes = show_charge_fakes if 'show_charge_fakes' not in self.defaults else self.defaults['show_charge_fakes']
        sig_view = self.make_signal_views(unblinded=(not self.blind),
                                          qcd_weight_fraction=qcd_fraction)
        
        if project and project_axis:
            sig_view = self.apply_to_dict( sig_view, ProjectionView, project_axis, project )
        sig_view = self.apply_to_dict( sig_view, RebinView, rebin )

        outdir.cd()
        wz = views.SumView(sig_view['wz'], sig_view['wz_3l']).Get(variable)
        zz = sig_view['zz'].Get(variable)
        obs = sig_view['data'].Get(variable)
        fakes = sig_view['fakes'].Get(variable)

        wz.SetName('wz')
        zz.SetName('zz')
        obs.SetName('data_obs')
        fakes.SetName('fakes')
        
        #for mass in [110, 115, 120, 125, 130, 135, 140]:
        for mass in range(110, 165, 5):
            vh = sig_view['vh%i' % mass].Get(variable)
            vh.SetName('WH%i' % mass)
            vh.Write()
            if mass % 10 == 0 and mass < 150:
                # Only have 10 GeV steps for WW
                ww = sig_view['vh%i_hww' % mass].Get(variable)
                ww.SetName('WH_hww%i' % mass)
                ww.Write()

        wz.Write()
        zz.Write()
        obs.Write()
        fakes.Write()
        #charge_fakes_CMS_vhtt_emt_chargeFlip_8TeVUpx
        if show_charge_fakes:
            logging.info('adding charge fakes shape errors')
            charge_fakes          = sig_view['charge_fakes']['central'].Get(variable)
            charge_fakes_sys_up   = sig_view['charge_fakes']['sys_up' ].Get(variable) #shift='up') 
            charge_fakes_sys_down = charge_fakes+charge_fakes - charge_fakes_sys_up
            charge_fakes.SetName('charge_fakes')
            charge_fakes_sys_up.SetName('charge_fakes_CMS_vhtt_%s_chargeFlip_%sTeVUp' % (self.channel.lower(), self.sqrts))
            charge_fakes_sys_down.SetName('charge_fakes_CMS_vhtt_%s_chargeFlip_%sTeVDown' % (self.channel.lower(), self.sqrts))
            charge_fakes.Write()
            charge_fakes_sys_up.Write()
            charge_fakes_sys_down.Write()
        
    def write_cut_and_count(self, variable, outdir):
        ''' Version of write_shapes(...) with only one bin.

        Equivalent to a cut & count analysis.
        '''
        sig_view = self.make_signal_views( unblinded=(not self.blind))
        nbins = sig_view['wz'].Get(variable).GetNbinsX()
        return self.write_shapes(variable, nbins, outdir, unblinded)

    def write_f3_shapes(self, variable, rebin, outdir,
                     qcd_fraction=0, show_charge_fakes=False,
                     project=None, project_axis=None):
        ''' Write final shapes for [variable] into a TDirectory [outputdir] '''
        show_charge_fakes = show_charge_fakes if 'show_charge_fakes' not in self.defaults else self.defaults['show_charge_fakes']
        sig_view = self.make_obj3_fail_cr_views(False, qcd_weight_fraction=qcd_fraction)
        
        if project and project_axis:
            sig_view = self.apply_to_dict( sig_view, ProjectionView, project_axis, project )
        sig_view = self.apply_to_dict( sig_view, RebinView, rebin )

        outdir.cd()
        wz = views.SumView(sig_view['wz'], sig_view['wz_3l']).Get(variable)
        zz = sig_view['zz'].Get(variable)
        obs = sig_view['data'].Get(variable)
        fakes = sig_view['fakes'].Get(variable)

        wz.SetName('wz')
        zz.SetName('zz')
        obs.SetName('data_obs')
        fakes.SetName('fakes')
        
        wz.Write()
        zz.Write()
        obs.Write()
        fakes.Write()

        mass = 120
        vh = sig_view['vh%i' % mass].Get(variable)
        vh.SetName('WH%i' % mass)
        vh.Write()
        # Only have 10 GeV steps for WW
        ww = sig_view['vh%i_hww' % mass].Get(variable)
        ww.SetName('WH_hww%i' % mass)
        ww.Write()

        #charge_fakes_CMS_vhtt_emt_chargeFlip_8TeVUpx
        if show_charge_fakes:
            logging.info('adding charge fakes shape errors')
            charge_fakes          = sig_view['charge_fakes']['central'].Get(variable)
            charge_fakes_sys_up   = sig_view['charge_fakes']['sys_up' ].Get(variable) #shift='up') 
            charge_fakes_sys_down = charge_fakes+charge_fakes - charge_fakes_sys_up
            charge_fakes.SetName('charge_fakes')
            charge_fakes_sys_up.SetName('charge_fakes_CMS_vhtt_%s_chargeFlip_%sTeVUp' % (self.channel.lower(), self.sqrts))
            charge_fakes_sys_down.SetName('charge_fakes_CMS_vhtt_%s_chargeFlip_%sTeVDown' % (self.channel.lower(), self.sqrts))
            charge_fakes.Write()
            charge_fakes_sys_up.Write()
            charge_fakes_sys_down.Write()

    def plot_final(self, variable, rebin=1, xaxis='', maxy=24,
                   show_error=False, qcd_correction=False, stack_higgs=True, 
                   qcd_weight_fraction=0.5, x_range=None, show_charge_fakes=False,
                   leftside_legend=False, higgs_xsec_multiplier=5, project=None, 
                   project_axis=None, **kwargs):
        ''' Plot the final output - with bkg. estimation '''        
        show_charge_fakes = show_charge_fakes if 'show_charge_fakes' not in self.defaults else self.defaults['show_charge_fakes']
        sig_view = self.make_signal_views(unblinded=(not self.blind), 
                                          qcd_weight_fraction=qcd_weight_fraction)
        if project and project_axis:
            sig_view = self.apply_to_dict( sig_view, ProjectionView, project_axis, project ) 
        sig_view = self.apply_to_dict( sig_view, RebinView, rebin ) #Rebin

        vh_10x = views.TitleView(
            views.StyleView(
                views.ScaleView(sig_view['signal120'], higgs_xsec_multiplier),
                **remove_name_entry(data_styles['VH*'])
            ),
            "(%i#times) m_{H} = 125" % higgs_xsec_multiplier
        )
        charge_fakes_view = MedianView(highv=sig_view['charge_fakes']['sys_up'], centv=sig_view['charge_fakes']['central'])

        # Fudge factor to go from 120->125 - change in xsec*BR
        vh_10x = views.ScaleView(vh_10x, .783)
        tostack = [sig_view['wz_3l'], sig_view['zz'], sig_view['wz'], sig_view['fakes'], vh_10x] if stack_higgs else \
            [sig_view['wz_3l'], sig_view['zz'], sig_view['wz'], sig_view['fakes']]
        if show_charge_fakes:
            tostack = tostack[:2]+[charge_fakes_view]+tostack[2:]
        stack = views.StackView( *tostack )
        histo = stack.Get(variable)
        
        histo.Draw()
        histo.GetHistogram().GetXaxis().SetTitle(xaxis)
        if x_range:
            histo.GetHistogram().GetXaxis().SetRangeUser(x_range[0], x_range[1])
        if isinstance(maxy, (int, long, float)):
            #print "setting maxy to %s" % maxy
            histo.SetMaximum(maxy)
            self.canvas.Update()
        else:
            histo.SetMaximum(sum(histo.GetHists()).GetMaximum()*1.2)
        self.keep.append(histo)

        # Add legend
        legend = self.add_legend(histo, leftside=leftside_legend, entries=4)

        if show_error:
            correct_qcd_view = None
            if qcd_weight_fraction == 0:
                fakes05 = sig_view['weighted_fakes'][0.5]
                correct_qcd_view = MedianView(highv=fakes05, centv=sig_view['fakes'])

            elif qcd_weight_fraction == 0.5:
                fakes1 = sig_view['weighted_fakes'][1.]
                correct_qcd_view = MedianView(highv=fakes1, centv=sig_view['fakes'])

            elif qcd_weight_fraction == 1:
                fakes05 = sig_view['weighted_fakes'][0.5]
                correct_qcd_view = MedianView(lowv=fakes05, centv=sig_view['fakes'])

            bkg_error_view = BackgroundErrorView(
                correct_qcd_view, #sig_view['fakes'],
                views.SumView( sig_view['wz'], sig_view['wz_3l']),
                sig_view['zz'],
                charge_fakes_view,
                **kwargs
            )
            bkg_error = bkg_error_view.Get(variable)
            self.keep.append(bkg_error)
            bkg_error.Draw('pe2,same')
            legend.AddEntry(bkg_error)

        # Use poisson error bars on the data
        sig_view['data'] = PoissonView(sig_view['data'], x_err=False)

        data = sig_view['data'].Get(variable)
        if not self.blind:
            data.Draw('pe,same')
        self.keep.append(data)

        if not stack_higgs:
            higgs_plot = vh_10x.Get(variable)
            higgs_plot.Draw('same')
            self.keep.append(higgs_plot)
            
        #legend.AddEntry(data)
        legend.Draw()

    def plot_final_wz(self, variable, rebin=1, xaxis='', maxy=None):
        ''' Plot the final WZ control region - with bkg. estimation '''
        sig_view = self.make_wz_cr_views(rebin)

        stack = views.StackView(
            sig_view['fakes'],
            sig_view['wz'],
            sig_view['zz'],
        )
        histo = stack.Get(variable)
        histo.Draw()
        histo.GetHistogram().GetXaxis().SetTitle(xaxis)
        data = sig_view['data'].Get(variable)
        data.Draw('same')
        if maxy is not None:
            histo.SetMaximum(float(maxy))
        else:
            histo.SetMaximum(1.2 * max(histo.GetMaximum(), data.GetMaximum()))
        self.keep.append(data)
        self.keep.append(histo)

        # Add legend
        self.add_legend(histo, leftside=False, entries=4)

    def plot_final_f3(self, variable, rebin=1, xaxis='', maxy=None,
                      show_error=True, qcd_correction=False,
                      qcd_weight_fraction=0.5, x_range=None, #):
                      show_chi2=False,project=None, 
                      project_axis=None, **kwargs):
        ''' Plot the final F3 control region - with bkg. estimation '''

        sig_view = self.make_obj3_fail_cr_views(
            qcd_correction, qcd_weight_fraction)
        if project and project_axis:
            sig_view = self.apply_to_dict( sig_view, ProjectionView, project_axis, project ) 
        sig_view = self.apply_to_dict( sig_view, RebinView, rebin ) #Rebin

        charge_fakes_view = MedianView(highv=sig_view['charge_fakes']['sys_up'], centv=sig_view['charge_fakes']['central'])

        stack = views.StackView(
            sig_view['zz'],
            charge_fakes_view,
            sig_view['wz_3l'],
            sig_view['wz'],
            sig_view['fakes'],
        )
        histo = stack.Get(variable)
        histo.Draw()
        histo.GetHistogram().GetXaxis().SetTitle(xaxis)
        if x_range:
            histo.GetHistogram().GetXaxis().SetRangeUser(x_range[0], x_range[1])

        data = sig_view['data'].Get(variable)

        # Add legend
        legend  = self.add_legend(histo, leftside=False, entries=4)
        latex   = ROOT.TLatex(0.01, 0.9, "")
        pad     = ROOT.TPad('da','fuq',0.1,0.8,0.5,0.9)
        self.canvas.cd()
        latexit = ''
        if show_error:
            correct_qcd_view = None
            if qcd_weight_fraction == 0:
                fakes05 = sig_view['weighted_fakes'][0.5]
                correct_qcd_view = MedianView(highv=fakes05, centv=sig_view['fakes'])

            elif qcd_weight_fraction == 0.5:
                fakes1 = sig_view['weighted_fakes'][1.]
                correct_qcd_view = MedianView(highv=fakes1, centv=sig_view['fakes'])

            elif qcd_weight_fraction == 1:
                fakes05 = sig_view['weighted_fakes'][0.5]
                correct_qcd_view = MedianView(lowv=fakes05, centv=sig_view['fakes'])

            bkg_error_view = BackgroundErrorView(
                correct_qcd_view, #sig_view['fakes'],
                views.SumView(sig_view['wz'], sig_view['wz_3l']),
                sig_view['zz'],
                charge_fakes_view,
                **kwargs
            )
            bkg_error = bkg_error_view.Get(variable)
            self.keep.append(bkg_error)
            bkg_error.Draw('pe2,same')
            legend.AddEntry(bkg_error)
            if show_chi2:
                chival  = get_chi_square(data, bkg_error)
                latexit = '#chi^{2}/#bins = %.2f / %i' % chival 
                
        data.Draw('same')
        if isinstance(maxy, (int, long, float)):
            histo.SetMaximum(maxy)
        else:
            #histo.SetMaximum(
                #1.2*max(histo.GetHistogram().GetMaximum(), data.GetMaximum()))
            histo.SetMaximum(2 * max(data.GetMaximum(), histo.GetMaximum()))
        self.keep.append(data)
        self.keep.append(histo)
        if latexit:
            pad.cd()
            latex.DrawLatex(0.01, 0.01, latexit)
            self.canvas.cd()
            pad.Draw()
        self.keep.append(latex)
        self.keep.append(pad)
        #legend.AddEntry(data)
        legend.Draw()

    def plot_final_f3_split(self, variable, rebin=1, xaxis='', maxy=None):
        ''' Plot the final F3 control region - with bkg. estimation '''
        sig_view = self.make_obj3_fail_cr_views(
            False, 0.5)
        sig_view = self.apply_to_dict( sig_view, RebinView, rebin ) #Rebin

        stack = views.StackView(
            sig_view['zz'],
            MedianView(highv=sig_view['charge_fakes']['sys_up'], centv=sig_view['charge_fakes']['central']),
            sig_view['wz'],
            sig_view['obj1'],
            sig_view['obj2'],
            sig_view['obj12'],
        )
        histo = stack.Get(variable)
        histo.Draw()
        histo.GetHistogram().GetXaxis().SetTitle(xaxis)

        # Add legend
        legend = self.add_legend(histo, leftside=False, entries=4)

        data = sig_view['data'].Get(variable)
        data.Draw('same')
        if maxy:
            histo.SetMaximum(maxy)
        else:
            histo.SetMaximum(
                1.2 * max(
                    histo.GetHistogram().GetMaximum(), data.GetMaximum()))
        self.keep.append(data)
        self.keep.append(histo)

        #legend.AddEntry(data)
        legend.Draw()

    def plot_qcd_contamination(self, variable, control_region, rebin):
        proj_views = self.make_qcd_proj_views(control_region, rebin)
        data = proj_views['obs'].Get(variable)
        qcd = proj_views['qcd'].Get(variable)

        data.Draw()
        qcd.Draw('same')
        self.keep.append(data)
        self.keep.append(qcd)

        legend = self.add_legend([data, qcd], leftside=False, entries=2)
        legend.Draw()
