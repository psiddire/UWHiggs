import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor, make_corrector_from_th2
from FinalStateAnalysis.StatTools.VariableScaler import make_scaler
import FinalStateAnalysis.MetaData.data_views as data_views
import glob
from TwoDimFakeRate import TwoDimFakeRate
import fnmatch
import logging
from baseSelections import currentID
data_views.log.setLevel(logging.INFO)

################################################################################
#### Fitted fake rate functions ################################################
################################################################################

# Get fitted fake rate functions
frfit_dir = os.path.join('results', os.environ['jobid'], 'fakerate_fits')


##################
## 1D Muon Func ##
##################

highpt_mu_fr = build_roofunctor(
    #frfit_dir + '/m_wjets_pt20_pfidiso02_muonJetPt.root',
    frfit_dir + '/m_wjets_pt20_h2taucuts_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)
lowpt_mu_fr = build_roofunctor(
    #frfit_dir + '/m_wjets_pt10_pfidiso02_muonJetPt.root',
    frfit_dir + '/m_wjets_pt10_h2taucuts_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

highpt_mu_qcd_fr = build_roofunctor(
    frfit_dir + '/m_qcd_pt20_h2taucuts_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

lowpt_mu_qcd_fr = build_roofunctor(
    frfit_dir + '/m_qcd_pt10_h2taucuts_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

#######################
## 1D Electrons Func ##
#######################

lowpt_e_qcd_fr = build_roofunctor(
    frfit_dir + '/e_qcd_pt10_h2taucuts_eJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

lowpt_e_fr = build_roofunctor(
    frfit_dir + '/e_wjets_pt10_h2taucuts_eJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

highpt_e_qcd_fr = build_roofunctor(
    frfit_dir + '/e_qcd_pt20_h2taucuts_eJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

highpt_e_fr = build_roofunctor(
    frfit_dir + '/e_wjets_pt20_h2taucuts_eJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

highpt_ee_fr = build_roofunctor(
    frfit_dir + '/ee_wjetsNoZmass_pt20_%s_electronJetPt.root' % currentID.electron,
    'fit_efficiency', # workspace name
    'efficiency'
)

lowpt_ee_fr = build_roofunctor(
    frfit_dir + '/ee_wjetsNoZmass_pt10_%s_electronJetPt.root' % currentID.electron,
    'fit_efficiency', # workspace name
    'efficiency'
)

highpt_ee_qcd_fr = build_roofunctor(
    frfit_dir + '/ee_qcd_pt20_%s_electronJetPt.root' % currentID.electron,
    'fit_efficiency', # workspace name
    'efficiency'
)

lowpt_ee_qcd_fr = build_roofunctor(
    frfit_dir + '/ee_qcd_pt10_%s_electronJetPt.root' % currentID.electron,
    'fit_efficiency', # workspace name
    'efficiency'
)



##################
## 1D Taus Func ##
##################

tau_fr = build_roofunctor(
    frfit_dir + '/t_ztt_pt20_mvaloose_tauPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

tau_qcd_fr = tau_fr ## build_roofunctor(
##     frfit_dir + '/t_ztt_pt20_mvaloose_tauPt.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

## highpt_ee_fr = build_roofunctor(
##     frfit_dir + '/ee_wjets_pt20_mvaidiso01_e2JetPt-data_ee.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

## lowpt_ee_fr = build_roofunctor(
##     frfit_dir + '/ee_wjets_pt10_mvaidiso01_e2JetPt-data_ee.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )


e_charge_flip      = make_corrector_from_th2(frfit_dir+"/charge_flip_prob_map.root", "efficiency_map")         
e_charge_flip_up   = make_corrector_from_th2(frfit_dir+"/charge_flip_prob_map.root", "efficiency_map_statUp")  
e_charge_flip_down = make_corrector_from_th2(frfit_dir+"/charge_flip_prob_map.root", "efficiency_map_statDown")
mass_scaler        = make_scaler(frfit_dir+"/charge_flip_prob_map.root", 'mass_scale')

## highpt_e_charge_flip      = make_corrector_from_th2(frfit_dir+"/e1_flip_prob_map.root", "efficiency_map")         
## highpt_e_charge_flip_up   = make_corrector_from_th2(frfit_dir+"/e1_flip_prob_map.root", "efficiency_map_statUp")  
## highpt_e_charge_flip_down = make_corrector_from_th2(frfit_dir+"/e1_flip_prob_map.root", "efficiency_map_statDown")

## lowpt_e_charge_flip       = make_corrector_from_th2(frfit_dir+"/e2_flip_prob_map.root", "efficiency_map")         
## lowpt_e_charge_flip_up    = make_corrector_from_th2(frfit_dir+"/e2_flip_prob_map.root", "efficiency_map_statUp")  
## lowpt_e_charge_flip_down  = make_corrector_from_th2(frfit_dir+"/e2_flip_prob_map.root", "efficiency_map_statDown")



## w_function = build_roofunctor(frfit_dir + '/mt_shapes.root', 'fit_shapes', 'w_func','mt')      if os.path.isfile(frfit_dir + '/mt_shapes.root') else lambda mt: 0.5
## h_function = build_roofunctor(frfit_dir + '/mt_shapes.root', 'fit_shapes', 'higgs_func', 'mt') if os.path.isfile(frfit_dir + '/mt_shapes.root') else lambda mt: 0.5
## mt_likelihood_ratio = lambda mt: w_function(mt) / h_function(mt)

