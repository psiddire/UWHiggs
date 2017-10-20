import rootpy.plotting.views as views
from FinalStateAnalysis.PlotTools.Plotter        import Plotter
from FinalStateAnalysis.PlotTools.BlindView      import BlindView
from FinalStateAnalysis.PlotTools.PoissonView    import PoissonView
from FinalStateAnalysis.PlotTools.MedianView     import MedianView
from FinalStateAnalysis.PlotTools.ProjectionView import ProjectionView
#from FinalStateAnalysis.PlotTools.FixedIntegralView import FixedIntegralView
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

ROOT.gROOT.SetBatch()
ROOT.gStyle.SetOptStat(0)
jobid = os.environ['jobid']

print jobid
mc_samples = [
    'ggHiggsToETau',
    'vbfHiggsToETau',
    'GluGluToHToTauTau_M-125_8TeV-powheg-pythia6',
    'VBF_HToTauTau_M-125_8TeV-powheg-pythia6',
    'Zjets_M50_skimmedLL',
    'Z1jets_M50_skimmedLL',
    'Z2jets_M50_skimmedLL',
    'Z3jets_M50_skimmedLL',
    'Z4jets_M50_skimmedLL',
    'Zjets_M50_skimmedTT',
    'Z1jets_M50_skimmedTT',
    'Z2jets_M50_skimmedTT',
    'Z3jets_M50_skimmedTT',
    'Z4jets_M50_skimmedTT',
    'TTJets*',
    'T_t*',
    'Tbar_t*', 
    'WplusJets_madgraph_skimmed',
    'Wplus1Jets_madgraph',
   # 'Wplus1Jets_madgraph_tapas',
    'Wplus2Jets_madgraph',
   # 'Wplus2Jets_madgraph_tapas',
    'Wplus3Jets_madgraph',
    'Wplus4Jets_madgraph',
    'WWJets*',
    'WZJets*',
    'ZZJets*',
    'data*'
]

files = []
lumifiles = []
channel = 'mm'
for x in mc_samples:
    files.extend(glob.glob('results/%s/MuMuAnalyzer/%s.root' % (jobid, x)))
    lumifiles.extend(glob.glob('inputs/%s/%s.lumicalc.sum' % (jobid, x)))
    


period = '13TeV'
#sqrts = 7 if '7TeV' in jobid else 8

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )


sign = ['os', 'ss']

outputdir = 'plots/%s/MuMuAnalyzer/%s/' % (jobid, channel)
if not os.path.exists(outputdir):
    os.makedirs(outputdir)

plotter = Plotter(files, lumifiles, outputdir) 




EWKDiboson = views.StyleView(
    views.SumView( 
        *[ plotter.get_view(regex) for regex in \
          filter(lambda x : x.startswith('WW') or x.startswith('WZ') or x.startswith('ZZ') or x.startswith('WG'), mc_samples )]
    ), **remove_name_entry(data_styles['WW*'#,'WZ*', 'WG*', 'ZZ*'
])
)
Wplus = views.StyleView(views.SumView(  *[ plotter.get_view(regex) for regex in filter(lambda x :  x.startswith('Wplus'), mc_samples )]), **remove_name_entry(data_styles['Wplus*Jets*']))
DYLL = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.endswith('skimmedLL'), mc_samples )]), **remove_name_entry(data_styles['Z*jets*LL']))
DYTT = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x :  x.endswith('jets_M50_skimmedTT'), mc_samples )]), **remove_name_entry(data_styles['Z*jets*TT']))
TT = views.StyleView(views.SumView(  *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('TT') , mc_samples)]), **remove_name_entry(data_styles['TTJets*']))
singleT = views.StyleView(views.SumView(  *[ plotter.get_view(regex) for regex in  filter(lambda x : x.startswith('T_') or x.startswith('Tbar_'), mc_samples)]), **remove_name_entry(data_styles['T*_t*']))
SMH = views.StyleView(views.SumView( *[ plotter.get_view(regex) for regex in filter(lambda x : 'HToTauTau' in x , mc_samples)]), **remove_name_entry(data_styles['GluGluToHToTauTau*']))


plotter.views['EWKDiboson']={'view' : EWKDiboson }
plotter.views['Wplus']={'view' : Wplus }
plotter.views['DYLL']={'view' : DYLL }
plotter.views['DYTT']={'view' : DYTT }
plotter.views['singleT']={'view' : singleT }
plotter.views['SMH']={'view' : SMH }
plotter.views['TT']={'view' : TT }


new_mc_samples = filter( lambda x : not x.startswith('T_') and not x.startswith('Tbar_') and not  x.endswith('jets_M50_skimmedLL') and not  x.endswith('jets_M50_skimmedTT') and not x.startswith('Wplus') and not  x.startswith('WW') and not x.startswith('WZ') and not  x.startswith('ZZ') and not x.startswith('WG') and not x.endswith('HiggsToETau') and not 'HToTauTau'  and not x.startswith('data') in x, mc_samples)
#new_sigsamples= filter(lambda x: x.endswith('HiggsToETau'), mc_samples)

#print new_sigsamples 
new_mc_samples.extend(['EWKDiboson', 'SMH', 'singleT','Wplus', 'DYLL', 'DYTT' , 'TT'
])
print new_mc_samples

#histoname = ['e1Pt','e1Phi','e1Eta','e2Pt','e2Phi','e2Eta',
#             'e1e2_DeltaPhi','e1e2_DeltaR', 'e1e2Mass',  
#             'type1_pfMetEt', 'pfMetEt', 'type1_pfMetPhi','pfMetPhi', 'mvaMetEt', 'mvaMetPhi', 
#             'pfMetEt_par','pfMetEt_perp', 'type1_pfMetEt_par','type1_pfMetEt_perp', 'mvaMetEt_par','mvaMetEt_perp',
#             'e1PFMET_DeltaPhi','e1PFMET_Mt','e1MVAMET_DeltaPhi','e1MVAMET_Mt','e2PFMET_DeltaPhi','e2PFMET_Mt','e2MVAMET_DeltaPhi','e2MVAMET_Mt']
#axistitle = ['e1 p_{T} (GeV)','e1 #phi','e1 #eta', 'e2 p_{T} (GeV)','e2 #phi','e2 #eta','e1-e2 #Delta#phi','e1-e2 #DeltaR', 'e1-e2 Inv Mass (GeV)', 'type1PF MET (GeV)', 'PF MET (GeV)', 'type1 PF MET #phi', 'PF MET #phi', 'MVA MET (GeV)', 'MVA MET #phi', 'PF MET parallel (GeV)', 'PF MET perpendicular (GeV)', 'type1PF MET parallel (GeV)', 'type1PF MET perpendicular (GeV)', 'MVA MET parallel (GeV)', 'MVA MET perpendicular (GeV)', 
#'e1-type1PFMET #Delta#phi','e1-type1PFMET M_{T} (GeV) ','e1-MVAMET #Delta#phi','e1-MVAMET M_{T} (GeV)','e2-type1PFMET #Delta#phi','e2-type1PFMET M_{T} (GeV)','e2-MVAMET #Delta#phi','e2-MVAMET #M_{T} (GeV)']

histoname = ['m1Pt','m2Pt','m1_m2_Mass','m1GenPt','m2GenPt']
axistitle = ['m1 p_{T} (GeV)','m2 p_{T} (GeV)','m1-m2 Inv Mass (GeV)','m1 Gen p_{T} (GeV)','m2 Gen p_{T} (GeV)']

#rebins = [5, 5, 2, 5, 5, 2, 1, 1, 1,  1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 5, 1, 5, 1, 5, 1, 5]
rebins = []
for n in histoname :
    rebins.append(1)


plotter.mc_samples = new_mc_samples
#plotter.mc_samples = mc_samples
for i in sign :
    for n,h in enumerate(histoname) :
        foldername = i
        #plotter.pad.SetLogy(True)
        
#        plotter.plot_mc(foldername, ['ggHiggsToETau','vbfHiggsToETau'],h, rebin=rebins[n], xaxis= axistitle[n], leftside=False, show_ratio=False, ratio_range=1.5,  rescale=10)
        plotter.plot_mc_vs_data(foldername,h, rebin=rebins[n], xaxis= axistitle[n], leftside=False, show_ratio=True, ratio_range=1.5, sort=True)
         

        if not os.path.exists(outputdir+foldername):
            os.makedirs(outputdir+foldername)
            
        plotter.save(foldername+'/'+h)
