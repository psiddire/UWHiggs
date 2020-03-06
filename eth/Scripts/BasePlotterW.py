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

class BasePlotterW():

    def mcInit(self, files, lumifiles, outputdir, s):

        plotter = Plotter(files, lumifiles, outputdir)

        DYtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('DY'), Lists.mc_samples_W)])
        DYall = views.SubdirectoryView(DYtotal, s[0])
        DY = views.StyleView(DYall, **Lists.remove_name_entry(data_styles['DY*']))
        DY = views.TitleView(DY, 'Z#rightarrow#mu#mu/ee')

        embedtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('Embed') , Lists.mc_samples_W)])
        embedall = views.SubdirectoryView(embedtotal, s[0])
        embed = views.StyleView(embedall, **Lists.remove_name_entry(data_styles['DYTT*']))
        embed = views.TitleView(embed, 'Z#rightarrow#tau#tau')

        EWKtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('EWK') , Lists.mc_samples_W)])
        EWKall = views.SubdirectoryView(EWKtotal, s[0])
        EWK = views.StyleView(EWKall, **Lists.remove_name_entry(data_styles['W*Jets*']))
        EWK = views.TitleView(EWK, 'EWKW/Z')

        SMHtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x or 'HToWW' in x , Lists.mc_samples_W)])
        SMHall = views.SubdirectoryView(SMHtotal, s[0])
        SMH = views.StyleView(SMHall, **Lists.remove_name_entry(data_styles['*HToTauTau*']))
        SMH = views.TitleView(SMH, 'SM Higgs')

        TTtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('TT') or x.startswith('ST'), Lists.mc_samples_W)])
        TTall = views.SubdirectoryView(TTtotal, s[0])
        TT = views.StyleView(TTall, **Lists.remove_name_entry(data_styles['TT*']))
        TT = views.TitleView(TT, 't#bar{t},t+jets')

        Dibosontotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('ZZ') or x.startswith('WZ') or x.startswith('WW'), Lists.mc_samples_W)])
        Dibosonall = views.SubdirectoryView(Dibosontotal, s[0])
        Diboson = views.StyleView(Dibosonall, **Lists.remove_name_entry(data_styles['WZ*']))
        Diboson = views.TitleView(Diboson, 'Diboson')

        Wtotal = views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : x.startswith('WJ') or x.startswith('W1') or x.startswith('W2') or x.startswith('W3') or x.startswith('W4'), Lists.mc_samples_W)])
        Wall = views.SubdirectoryView(Wtotal, s[0])
        QCD = views.StyleView(Wall, **Lists.remove_name_entry(data_styles['QCD*']))
        QCD = views.TitleView(QCD, 'W+Jets')

        vbfHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'VBF_LFV_HToETau' in x , Lists.mc_samples_W)]), **Lists.remove_name_entry(data_styles['VBF_LFV*']))
        ggHET = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'GluGlu_LFV_HToETau' in x , Lists.mc_samples_W)]), **Lists.remove_name_entry(data_styles['GluGlu_LFV*']))

        plotter.views['vbfHET']={'view' : vbfHET }
        plotter.views['ggHET']={'view' : ggHET }
        plotter.views['DY']={'view' : DY }
        plotter.views['embed']={'view' : embed }
        plotter.views['EWK']={'view' : EWK }
        plotter.views['SMH']={'view' : SMH }
        plotter.views['TT']={'view' : TT }
        plotter.views['QCD']={'view' : QCD }
        plotter.views['Diboson']={'view' : Diboson }

        plotter.mc_samples = ['QCD', 'Diboson', 'TT', 'EWK', 'DY', 'embed', 'SMH']

        return plotter
