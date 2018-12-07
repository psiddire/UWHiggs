import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor

################################################################################
#### Fitted fake rate functions ################################################
################################################################################

# Get fitted fake rate functions
frfit_dir = os.path.join('results', os.environ['jobid'], 'fakerate_fits')
#mu_tight_fr = build_roofunctor( #lambda x: 0.1
#    frfit_dir + '/m_zlt_pt10_tightId_muonPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

#e_tight_fr =build_roofunctor( #lambda x: 0.2
#    frfit_dir + '/e_zlt_pt10_tightId_electronPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

#mu_loose_fr = build_roofunctor( #lambda x: 0.1
#    frfit_dir + '/m_zlt_pt10_looseId_muonPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

#e_loose_fr =build_roofunctor( #lambda x: 0.2
#    frfit_dir + '/e_zlt_pt10_looseId_electronPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)


mu_tight_jetpt_fr = build_roofunctor( #lambda x: 0.1
    frfit_dir + '/m_zlt_pt10_tightId_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

#e_tight_jetpt_fr =build_roofunctor( #lambda x: 0.2
#    frfit_dir + '/e_zlt_pt10_tightId_electronJetPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

mu_loose_jetpt_fr = build_roofunctor( #lambda x: 0.1
    frfit_dir + '/m_zlt_pt10_looseId_muonJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

e_loose_jetpt_fr =build_roofunctor( #lambda x: 0.2
    frfit_dir + '/e_zlt_pt10_looseId_electronJetPt.root',
    'fit_efficiency', # workspace name
    'efficiency'
)

## /e_zlt_pt10_looseId_electronJetPt.root
## /m_zlt_pt10_looseId_muonJetPt.root

## tau_loose_fr = build_roofunctor(
##     frfit_dir + '/t_ztt_pt10_LooseIso_tauPt.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

## tau_looseMVA_fr = build_roofunctor(
##     frfit_dir + '/t_ztt_pt10_LooseMVAIso_tauPt.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

#tau_medium_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10_MediumIso_tauPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

## tau_mediumMVA_fr = build_roofunctor(
##     frfit_dir + '/t_ztt_pt10_MediumMVAIso_tauPt.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

#tau_tight_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10_TightIso_tauPt.root',
#    'fit_efficiency', # workspace name
#    'efficiency'
#)

## tau_tightMVA_fr = build_roofunctor(
##     frfit_dir + '/t_ztt_pt10_TightMVAIso_tauPt.root',
##     'fit_efficiency', # workspace name
##     'efficiency'
## )

#tau_medium_jetpt_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10_MediumIso_tauJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)
#tau_tight_jetpt_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10_TightIso_tauJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)
#tau_mvatl_medium_jetpt_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10-antiElMVATight-antiMuLoose_MediumIso_tauJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)
#tau_mm_tight_jetpt_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10-antiElMed-antiMuMed_TightIso_tauJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)
#tau_lt_medium_jetpt_fr = build_roofunctor(
#    frfit_dir + '/t_ztt_pt10-antiElLoose-antiMuTight_MediumIso_tauJetPt.root',
#    'fit_efficiency',
#    'efficiency'
#)
tau_jetpt_fr = build_roofunctor(
    frfit_dir + '/t_ztt_pt10_LooseIso3Hits_tauJetPt.root',
    'fit_efficiency',
    'efficiency'
)
