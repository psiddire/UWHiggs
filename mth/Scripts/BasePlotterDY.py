import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter import Plotter
from FinalStateAnalysis.PlotTools.SubtractionView import SubtractionView, PositiveView
from FinalStateAnalysis.MetaData.data_styles import data_styles
import ROOT
import logging
import sys
import Lists
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)

ROOT.gROOT.SetStyle('Plain')
ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)

class BasePlotterDY():

    def mcInit(self, files, lumifiles, outputdir, s):

        plotter = Plotter(files, lumifiles, outputdir)

        DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY'), Lists.mc_samples)])
        DYall = views.SubdirectoryView(DYtotal, s[0])
        DY = views.StyleView(DYall, **Lists.remove_name_entry(data_styles['DY*']))
        DY = views.TitleView(DY, 'Z#rightarrow#tau#tau/#mu#mu/ee')

        EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , Lists.mc_samples)])
        EWKall = views.SubdirectoryView(EWKtotal, s[0])
        EWK = views.StyleView(EWKall, **Lists.remove_name_entry(data_styles['W*Jets*']))
        EWK = views.TitleView(EWK, 'EWKW/Z')

        SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , Lists.mc_samples)])
        SMHall = views.SubdirectoryView(SMHtotal, s[0])
        SMH = views.StyleView(SMHall, **Lists.remove_name_entry(data_styles['*HToTauTau*']))
        SMH = views.TitleView(SMH, 'SM Higgs')

        TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), Lists.mc_samples)])
        TTall = views.SubdirectoryView(TTtotal, s[0])
        TT = views.StyleView(TTall, **Lists.remove_name_entry(data_styles['TT*']))
        TT = views.TitleView(TT, 't#bar{t},t+jets')

        Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), Lists.mc_samples)])
        Dibosonall = views.SubdirectoryView(Dibosontotal, s[0])
        Diboson = views.StyleView(Dibosonall, **Lists.remove_name_entry(data_styles['WZ*']))
        Diboson = views.TitleView(Diboson, 'Diboson')

        data_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('QCD'), Lists.mc_samples)])
        fakesTau = views.SubdirectoryView(data_view, s[1])
        fakesEle = views.SubdirectoryView(data_view, s[2])
        fakesTauEle = views.SubdirectoryView(data_view, s[3])
        fakesET = views.SumView(fakesTau, fakesEle)
        fakesData = SubtractionView(fakesET, fakesTauEle, restrict_positive=True)
        mc_view = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('MC'), Lists.mc_samples)])
        fakesMCTau = views.SubdirectoryView(mc_view, s[1])
        fakesMCEle = views.SubdirectoryView(mc_view, s[2])
        fakesMCTauEle = views.SubdirectoryView(mc_view, s[3])
        fakesMCET = views.SumView(fakesMCTau, fakesMCEle)
        fakesMC = SubtractionView(fakesMCET, fakesMCTauEle, restrict_positive=True)
        QCD = views.StyleView(SubtractionView(fakesData, fakesMC, restrict_positive=True), **Lists.remove_name_entry(data_styles['QCD*']))
        QCD = views.TitleView(QCD, 'W/QCD')

        vbfHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToETau' in x , Lists.mc_samples)]), **Lists.remove_name_entry(data_styles['VBF_LFV*']))
        ggHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToETau' in x , Lists.mc_samples)]), **Lists.remove_name_entry(data_styles['GluGlu_LFV*']))

        plotter.views['vbfHET']={'view' : vbfHET }
        plotter.views['ggHET']={'view' : ggHET }
        plotter.views['DY']={'view' : DY }
        plotter.views['EWK']={'view' : EWK }
        plotter.views['SMH']={'view' : SMH }
        plotter.views['TT']={'view' : TT }
        plotter.views['QCD']={'view' : QCD }
        plotter.views['Diboson']={'view' : Diboson }

        plotter.mc_samples = ['QCD', 'Diboson', 'TT', 'EWK', 'DY', 'SMH']

        return plotter
