'''

Make inclusive Z->mumu control plots

'''

import os
import glob
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.MedianView import MedianView
import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.HistToTGRaphErrors import HistStackToTGRaphErrors
from FinalStateAnalysis.MetaData.data_styles import data_styles, colors
import ROOT

ROOT.gROOT.SetBatch(True)


class ControlZEEPlotter(Plotter):
    def __init__(self):
        self.jobid = os.environ['jobid']
        self.output_dir = os.path.join('results', self.jobid, 'plots', 'zee')
        samples = [
            'Zjets_M50',
            #'WZ*',
            #'ZZ*',
            #'WW*',
            'TT*',
            #'WplusJets*',
            "data_DoubleE*",
            ]
        files = []
        lumifiles = []
        self.sqrts = 7 if '7TeV' in self.jobid else 8
        for x in samples:
            files.extend(glob.glob('results/%s/ControlZEE/%s.root' % (self.jobid, x)))
            lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (self.jobid, x)))
        super(ControlZEEPlotter, self).__init__(files, lumifiles, self.output_dir)
        self.mc_samples = ['Zjets_M50']

    def get_flip_data(self, rebin=1, xaxis='', data_type='data'):
        data_view = self.get_view(data_type)
        data_view = self.rebin_view(data_view, rebin) if rebin != 1 else data_view
        #Get ss/p1p2 views
        ss_p1p2_view = views.SubdirectoryView( data_view, 'ss/p1p2')
        ss_p1p2_view = views.TitleView( views.StyleView(ss_p1p2_view, **data_styles['data*']), 'observed;%s' % xaxis)

        def make_fakes_view(sign, weight_type):
            # View of weighted obj1-fails data
            obj1_view = views.SubdirectoryView(data_view, '%s/f1p2/%s' % (sign, weight_type))
            # View of weighted obj2-fails data
            obj2_view = views.SubdirectoryView(data_view, '%s/p1f2/%s' % (sign, weight_type))
            # View of weighted obj1&2-fails data
            obj12_view = views.SubdirectoryView(data_view, '%s/f1f2/%s' % (sign, weight_type))
            # Give the individual object views nice colors
            subtract_obj12_view = views.ScaleView(obj12_view, -1)
            return obj1_view, obj2_view, subtract_obj12_view

        #Get fakes according to WJets or QCD
        ss_f1p2_qcd_view, ss_p1f2_qcd_view, ss_f1f2_qcd_view = make_fakes_view('ss','qcd_w')
        ss_f1p2_wje_view, ss_p1f2_wje_view, ss_f1f2_wje_view = make_fakes_view('ss','wjet_w')

        ss_fakes_1   = MedianView(ss_f1p2_qcd_view, ss_f1p2_wje_view)
        ss_fakes_2   = MedianView(ss_p1f2_qcd_view, ss_p1f2_wje_view)
        ss_fakes_12  = MedianView(ss_f1f2_qcd_view, ss_f1f2_wje_view)
        ss_fakes_est = views.SumView(ss_fakes_1, ss_fakes_2, ss_fakes_12)
        ss_fakes_est = views.TitleView( views.StyleView(ss_fakes_est, **data_styles['Zjets*']), 'Fakes;%s' % xaxis)

        ## os_f1p2_qcd_views, os_p1f2_qcd_views, os_f1f2_qcd_views = zip(make_fakes_view('os', 'qcd_w/charge_weightSysUp'), make_fakes_view('os', 'qcd_w/charge_weightSysDwn'))
        ## os_f1p2_wje_views, os_p1f2_wje_views, os_f1f2_wje_views = zip(make_fakes_view('os', 'wjet_w/charge_weightSysUp'),make_fakes_view('os', 'wjet_w/charge_weightSysDwn'))

        ## os_f1p2_qcd_view = MedianView( *os_f1p2_qcd_views )
        ## os_p1f2_qcd_view = MedianView( *os_p1f2_qcd_views )
        ## os_f1f2_qcd_view = MedianView( *os_f1f2_qcd_views )

        ## os_f1p2_wje_view = MedianView( *os_f1p2_wje_views )
        ## os_p1f2_wje_view = MedianView( *os_p1f2_wje_views )
        ## os_f1f2_wje_view = MedianView( *os_f1f2_wje_views )

        ## os_fakes_1   = MedianView(os_f1p2_qcd_view, os_f1p2_wje_view)
        ## os_fakes_2   = MedianView(os_p1f2_qcd_view, os_p1f2_wje_view)
        ## os_fakes_12  = MedianView(os_f1f2_qcd_view, os_f1f2_wje_view)
        ## os_fakes_est = views.SumView(os_fakes_1, os_fakes_2, os_fakes_12)
        ## neg_os_fakes = views.ScaleView(os_fakes_est, -1)

        os_flip_est_up  = views.SubdirectoryView( data_view, 'os/p1p2/charge_weightSysUp')
        os_flip_est     = views.SubdirectoryView( data_view, 'os/p1p2/charge_weight')
        os_flip_est     = MedianView(highv=os_flip_est_up, centv=os_flip_est)
        os_flip_est_nofake = os_flip_est#views.SumView(os_flip_est, neg_os_fakes)
        os_flip_est_nofake = views.TitleView( views.StyleView(os_flip_est_nofake, **data_styles['WZ*']), 'charge-fakes;%s' % xaxis)
        return ss_p1p2_view, ss_fakes_est, os_flip_est_nofake
            
    def make_charge_flip_control_plot(self, variable, xaxis='', rebin=1, legend_on_the_left=False, data_type='data', x_range=None):
        ss_p1p2_view, ss_fakes_est, os_flip_est_nofake = self.get_flip_data(rebin,xaxis,data_type)
        events_estimate = views.StackView( ss_fakes_est,os_flip_est_nofake)
        
        obs_hist       = ss_p1p2_view.Get(variable)
        estimate_hist  = events_estimate.Get(variable)
        estimate_error = HistStackToTGRaphErrors( estimate_hist )
        estimate_error.SetFillStyle(3013)
        estimate_error.SetFillColor(ROOT.EColor.kBlack)
        estimate_error.SetTitle('Error on estimate')

        #from pdb import set_trace; set_trace()
        sum_stack = sum(estimate_hist.hists)
        print "variable %s: data integral: %.1f (%.1f/%.1f), estimate: %.1f (%.1f/%.1f) (under/overflow)" % (variable, \
            obs_hist.Integral(), obs_hist.GetBinContent(0), obs_hist.GetBinContent(obs_hist.GetNbinsX()+1), \
            sum_stack.Integral(), sum_stack.GetBinContent(0), sum_stack.GetBinContent(sum_stack.GetNbinsX()+1) )
        hmax = max( [ estimate_hist.GetMaximum(), max(list(obs_hist)) ] )
        obs_hist.GetYaxis().SetRangeUser(0,hmax*1.3)
        if x_range:
            obs_hist.GetXaxis().SetRangeUser(x_range[0],x_range[1])
        
        obs_hist.Draw()
        estimate_hist.Draw('same')
        self.canvas.Update()
        estimate_error.Draw('2 same')
        obs_hist.Draw('same')
        self.keep.extend([
            estimate_hist,
            estimate_error,
            obs_hist
            ])

        legend = self.add_legend([obs_hist], leftside=legend_on_the_left, entries=4)
        legend.AddEntry(estimate_hist,'f')
        #legend.AddEntry(estimate_error,'f')        
        legend.Draw()
        self.add_cms_blurb(self.sqrts)



plotter = ControlZEEPlotter()

#Charge flip control plots
plotter.make_charge_flip_control_plot('TrkMass','Tracker Inv Mass (GeV)',2)
plotter.save('EE_Charge_Flip_xcheck_trk_invMass')
plotter.canvas.SaveAs('test.root')
#plotter.save('EE_Charge_Flip_xcheck_trk_invMass_log')

plotter.make_charge_flip_control_plot('TrkMass_NOSCALE','Tracker Inv Mass (GeV)',2)
plotter.save('EE_Charge_Flip_xcheck_trk_invMass_NoScale')

plotter.make_charge_flip_control_plot('ePt','electron p_{T}',2,x_range=[0,200])
plotter.save('EE_Charge_Flip_xcheck_ePt')

plotter.make_charge_flip_control_plot('eAbsEta','electron |#eta|',4, legend_on_the_left=True)
plotter.save('EE_Charge_Flip_xcheck_eAbsEta')

plotter.make_charge_flip_control_plot('SCEnergy','Super cluster energy (GeV)',5)
plotter.save('EE_Charge_Flip_xcheck_eSCEnergy')

plotter.make_charge_flip_control_plot('e1Pt','electron p_{T}',2,x_range=[0,200])
plotter.save('EE_Charge_Flip_xcheck_e1Pt')

plotter.make_charge_flip_control_plot('e1AbsEta','electron |#eta|',10, legend_on_the_left=True)
plotter.save('EE_Charge_Flip_xcheck_e1AbsEta')

plotter.make_charge_flip_control_plot('e2Pt','electron p_{T}',2,x_range=[0,200])
plotter.save('EE_Charge_Flip_xcheck_e2Pt')

plotter.make_charge_flip_control_plot('e2AbsEta','electron |#eta|',10, legend_on_the_left=True)
plotter.save('EE_Charge_Flip_xcheck_e2AbsEta')

plotter.make_charge_flip_control_plot('type1_pfMetEt','electron |#eta|',10, legend_on_the_left=True)
plotter.save('EE_Charge_Flip_xcheck_type1_pfMetEt')


#Check same method against DYJets, to see if we screwed the method
print 'cosure tests'
plotter.make_charge_flip_control_plot('TrkMass','Tracker Inv Mass (GeV)',2, data_type='Zjets_M50')
plotter.save('EE_Charge_Flip_closure_trk_invMass')

plotter.make_charge_flip_control_plot('eAbsEta','electron |#eta|',4, legend_on_the_left=True, data_type='Zjets_M50')
plotter.save('EE_Charge_Flip_closure_absEta')

plotter.make_charge_flip_control_plot('ePt','electron p_{T}',2,x_range=[0,200], data_type='Zjets_M50')
plotter.save('EE_Charge_Flip_closure_ePt')
