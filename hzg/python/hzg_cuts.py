from UWHiggs.hzg.MOOSEY.OrderedDict import OrderedDict
from UWHiggs.hzg.MOOSEY.cuts import CutflowDecision
from ROOT import TVector3 # for delta R
from math import fabs,pi


#define the selection of a good event
def passes_mumu_trigger_data(HLT_Fired,HLT_Prescale,run):
    trigger_fired = HLT_Fired
    prescale = HLT_Prescale

    return (trigger_fired == 1 and prescale == 1)

#define the selection of a good event
def passes_mumu_trigger_mc(HLT_Fired,HLT_Prescale,evt_frac):
    trigger_fired = HLT_Fired
    prescale = HLT_Prescale
    
    return (trigger_fired == 1 and prescale == 1)

def passes_ee_trigger_data(HLT_Fired,HLT_Prescale,run):
    trigger_fired = HLT_Fired
    prescale = HLT_Prescale
    
    return (trigger_fired == 1 and prescale == 1)

def passes_ee_trigger_mc(HLT_Fired,HLT_Prescale,evt_frac):
    trigger_fired = HLT_Fired
    prescale = HLT_Prescale
    
    return (trigger_fired == 1 and prescale == 1)
    
def good_vtx(nGoodVtx):    
    return nGoodVtx != 0

def no_scraping(IsTracksGood):
    return IsTracksGood != 0

mumu_good_event_data_reqs = OrderedDict([['trigger',
                                          [passes_mumu_trigger_data,
                                           ['doubleMuPass','doubleMuPrescale','run'],
                                           0]],
                                         ['goodvtx',
                                          [good_vtx,
                                           ['nvtx'],
                                           0]]])

mumu_good_event_mc_reqs = OrderedDict([['trigger',
                                        [passes_mumu_trigger_mc,
                                         ['doubleMuPass','doubleMuPrescale','eventFraction'],
                                         0]],
                                       ['goodvtx',
                                        [good_vtx,
                                         ['nvtx'],
                                         0]]])

ee_good_event_data_reqs = OrderedDict([['trigger',
                                        [passes_ee_trigger_data,
                                         ['doubleEPass','doubleEPrescale','run'],
                                         0]],
                                       ['goodvtx',
                                        [good_vtx,
                                         ['nvtx'],
                                         0]]
                                       ])
ee_good_event_mc_reqs = OrderedDict([['trigger',
                                      [passes_ee_trigger_mc,
                                       ['doubleEPass','doubleEPrescale','eventFraction'],
                                       0]],
                                     ['goodvtx',
                                      [good_vtx,
                                       ['nvtx'],
                                       0]]
                                     ])

#single muon selection
def mu_pt(mu):
    return (mu.Pt() > 10)

def mu_eta(mu):
    return (abs(mu.Eta()) < 2.4)

#validated the use of IDHZG2011/2012
#just needs simple converter
def mu_id(the_id):
    bit = (the_id == 1.0)
    return bit

def mu_iso(mu,pfchg,pfneut,pfpho,pfpuchg):        
    eff_iso = max( pfneut + pfpho - 0.5*pfpuchg, 0.0 )
    iso = (pfchg + eff_iso)/mu.Pt()
    return (iso < 0.12)

def mu_iso_2012(mu,pfchg,pfneut,pfpho,pfpuchg):        
    eff_iso = max( pfneut + pfpho - 0.5*pfpuchg, 0.0 )
    iso = (pfchg + eff_iso)/mu.Pt()
    return (iso < 0.4)

def mu_trg_match_data(trigMatches,run):
    hasMatch = True    
    #if run >= 160431 and run <= 163869:
    #    hasMatch = (trigMatches[13] > 0)
    #elif run >= 165088 and run <= 178380:
    #    hasMatch = (trigMatches[14] > 0)
    #elif run >= 178420 and run <= 180252:
    #    hasMatch = (trigMatches[15] > 0)
    return hasMatch

def mu_trg_match_mc(trigMatches,evt_frac):
    hasMatch = True
    #if evt_frac < 0.046:
    #    hasMatch = (trigMatches[13] > 0)
    #elif evt_frac < 0.83:
    #    hasMatch = (trigMatches[14] > 0)
    #else:
    #    hasMatch = (trigMatches[15] > 0)
    return hasMatch

muon_selection_mc_reqs = OrderedDict([['mupt1',
                                       [mu_pt,['ell1'],0]],
                                      ['mueta1',
                                       [mu_eta,['ell1'],0]],
                                      ['mupt2',
                                       [mu_pt,['ell2'],0]],
                                      ['mueta2',
                                       [mu_eta,['ell2'],0]],
                                      ['muid1',
                                       [mu_id,['m1IDHZG2011'],0]],
                                      ['muid2',
                                       [mu_id,['m2IDHZG2011'],0]],
                                      ['muiso1',
                                       [mu_iso,['ell1','m1PFChargedIso','m1PFNeutralIso',
                                                'm1PFPhotonIso','m1PFPUChargedIso'],0]],
                                      ['muiso2',
                                       [mu_iso,['ell2','m2PFChargedIso','m2PFNeutralIso',
                                                'm2PFPhotonIso','m2PFPUChargedIso'],0]],
                                      ['trigger_match',
                                       [mu_trg_match_mc,['metEt','eventFraction'],0]]])

muon_selection_mc_reqs_2012 = OrderedDict([['mupt1',
                                            [mu_pt,['ell1'],0]],
                                           ['mueta1',
                                            [mu_eta,['ell1'],0]],
                                           ['mupt2',
                                            [mu_pt,['ell2'],0]],
                                           ['mueta2',
                                            [mu_eta,['ell2'],0]],
                                           ['muid1',
                                            [mu_id,['m1IDHZG2012'],0]],
                                           ['muid2',
                                            [mu_id,['m2IDHZG2012'],0]],
                                           ['muiso1',
                                            [mu_iso_2012,['ell1','m1PFChargedIso','m1PFNeutralIso',
                                                     'm1PFPhotonIso','m1PFPUChargedIso'],0]],
                                           ['muiso2',
                                            [mu_iso_2012,['ell2','m2PFChargedIso','m2PFNeutralIso',
                                                     'm2PFPhotonIso','m2PFPUChargedIso'],0]],
                                           ['trigger_match',
                                            [mu_trg_match_mc,['metEt','eventFraction'],0]]])

muon_selection_data_reqs = OrderedDict([['mupt1',
                                         [mu_pt,['ell1'],0]],
                                        ['mueta1',
                                         [mu_eta,['ell1'],0]],
                                        ['mupt2',
                                         [mu_pt,['ell2'],0]],
                                        ['mueta2',
                                         [mu_eta,['ell2'],0]],
                                        ['muid1',
                                         [mu_id,['m1IDHZG2011'],0]],
                                        ['muid2',
                                         [mu_id,['m2IDHZG2011'],0]],
                                        ['muiso1',
                                         [mu_iso,['ell1','m1PFChargedIso','m1PFNeutralIso',
                                                  'm1PFPhotonIso','m1PFPUChargedIso'],0]],
                                        ['muiso2',
                                         [mu_iso,['ell2','m2PFChargedIso','m2PFNeutralIso',
                                                  'm2PFPhotonIso','m2PFPUChargedIso'],0]],
                                        ['trigger_match',
                                         [mu_trg_match_data,['metEt','run'],0]]])

muon_selection_data_reqs_2012 = OrderedDict([['mupt1',
                                              [mu_pt,['ell1'],0]],
                                             ['mueta1',
                                              [mu_eta,['ell1'],0]],
                                             ['mupt2',
                                              [mu_pt,['ell2'],0]],
                                             ['mueta2',
                                              [mu_eta,['ell2'],0]],
                                             ['muid1',
                                              [mu_id,['m1IDHZG2012'],0]],
                                             ['muid2',
                                              [mu_id,['m2IDHZG2012'],0]],
                                             ['muiso1',
                                              [mu_iso_2012,['ell1','m1PFChargedIso','m1PFNeutralIso',
                                                       'm1PFPhotonIso','m1PFPUChargedIso'],0]],
                                             ['muiso2',
                                              [mu_iso_2012,['ell2','m2PFChargedIso','m2PFNeutralIso',
                                                       'm2PFPhotonIso','m2PFPUChargedIso'],0]],
                                             ['trigger_match',
                                              [mu_trg_match_data,['metEt','run'],0]]])


def ele_pt(pt):    
    return pt > 10

def ele_eta(eleEta):
    return (abs(eleEta) < 1.4442 or (abs(eleEta) > 1.566 and abs(eleEta) < 2.5))

#2012 LOOSE electron ID
dEtaCut  = [0.007,0.009]
dPhiCut  = [0.15,0.10]
sihihCut = [0.010,0.030]
HoECut   = [0.12,0.10]
d0Cut    = [0.02, 0.02]
dZCut    = [0.2, 0.2]
ooemoopCut  = [0.05,0.05]
hasConvCut  = [False,False]
missHitsCut = [1,1]
nearMuons = [0,0]
def ele_mva_kTrigIDISO_preID(pt, dEtaVtx, dPhiVtx, sihih, HoverE,
                  tkIso, ecalIso, hcalIso):
    idxe = int(abs(ele.Eta()) >= 1.566)
    ecalIsoPrime = ecalIso
    if idxe == 0:
        ecalIsoPrime = max(ecalIsoPrime - 1.0,0.0)

    result = ( abs(dEtaVtx) < dEtaCut[idxe] and
               abs(dPhiVtx) < dPhiCut[idxe] and
               sihih  < sihihCut[idxe] and
               HoverE < HoECut[idxe] and
               tkIso/pt < 0.2 and
               ecalIso/pt < 0.2 and
               hcalIso/pt < 0.2 
               )

mvacuts_kTrigIDISO = [-0.82,-0.98] # pt < 20, pt > 20 
def ele_mva_kTrigIDISO_ID(pt, mva):
    eidx = (pt > 20)
    return (mva > mvacuts_kTrigIDISO[eidx])

#the pieces of the electron MVA id kTrig
sihihCutkTrigMVA = [0.014,0.035]
HoECutkTrigMVA   = [0.15,0.10]
missHitskTrigMVA = [0,0]
def ele_mva_kTrig_preID(pt,SCEta,sihih,HoE,
                        trkIso,ecalIso,hcalIso,
                        missingHits):
    idxe1 = int(abs(SCEta) >= 1.479)
    
    return ( pt > 10 and             
             sihih < sihihCutkTrigMVA[idxe1] and             
             HoE < HoECutkTrigMVA[idxe1] and
             trkIso/pt  < 0.2 and
             ecalIso/pt < 0.2 and
             hcalIso/pt < 0.2 and             
             missingHits <= missHitskTrigMVA[idxe1] )

mvacuts_kTrig = [0.5,0.12,0.6]
def ele_mva_kTrig_id(pt,SCEta,mva):    
    eidx = int(abs(SCEta) > 0.8) + int(abs(SCEta) > 1.479)

    return ( pt > 10 and             
             mva > mvacuts_kTrig[eidx] )

def ele_ID(ele, dEtaVtx, dPhiVtx, sihih, HoverE,
           d0, dZ, EoverP, ecalEnergy, hasMatchedConv,
           missingHits, muonVeto):
    idxe = int(abs(ele.Eta()) >= 1.566)

    result = ( abs(dEtaVtx) < dEtaCut[idxe] and
               abs(dPhiVtx) < dPhiCut[idxe] and
               sihih  < sihihCut[idxe] and
               HoverE < HoECut[idxe] and
               abs(d0)< d0Cut[idxe] and
               abs(dZ)< dZCut[idxe] and
               abs(1.0 - EoverP)/ecalEnergy < ooemoopCut[idxe] and
               hasMatchedConv == int(hasConvCut[idxe]) and
               missingHits <= missHitsCut[idxe] and
               muonVeto <= nearMuons[idxe] )
    
    return (result)

def ele_iso(pt,pfchg,pfneut,pfpho,ea,rho):

    rhoprime = max(rho,0)
    eff_iso = max( pfneut + pfpho - ea*rhoprime, 0.0 )
    iso = (pfchg + eff_iso)/pt
    return (iso < 0.4)


def ele_trg_match_data(trigMatch,run):
    hasMatch = True
    #if run >= 160404 and run <= 167913:
    #    hasMatch = (trigMatch[18] > 0)
    #elif run >= 170249 and run <= 180252:
    #    hasMatch = (trigMatch[21] > 0)
    return hasMatch

def ele_trg_match_mc(trigMatch,evt_frac):
    hasMatch = True
    #if evt_frac < 0.236:
    #    hasMatch = (trigMatch[18] > 0)
    #else:
    #hasMatch = (trigMatch[21] > 0)
    return hasMatch

electron_selection_data_reqs = OrderedDict([['ept1',
                                             [ele_pt,['e1Pt'],0]],
                                            ['eeta1',
                                             [ele_eta,['e1SCEta'],0]],
                                            ['eID1',
                                             [ele_ID,['ell1','e1deltaEtaSuperClusterTrackAtVtx',
                                                      'e1deltaPhiSuperClusterTrackAtVtx','e1SigmaIEtaIEta',
                                                      'e1HadronicOverEM','e1PVDXY','e1PVDZ',
                                                      'e1eSuperClusterOverP','e1ecalEnergy',
                                                      'e1HasMatchedConversion','e1MissingHits',
                                                      'e1NearMuonVeto'],0]],
                                            ['eiso1',
                                             [ele_iso,['e1Pt','e1PFChargedIso',
                                                       'e1PFNeutralIso','e1PFPhotonIso',
                                                       'e1EffectiveArea2012Data','e1RhoHZG2012'],0]],
                                            ['ept2',
                                             [ele_pt,['e2Pt'],0]],
                                            ['eeta2',
                                             [ele_eta,['e2SCEta'],0]],
                                            ['eID2',
                                             [ele_ID,['ell2','e2deltaEtaSuperClusterTrackAtVtx',
                                                      'e2deltaPhiSuperClusterTrackAtVtx','e2SigmaIEtaIEta',
                                                      'e2HadronicOverEM','e2PVDXY','e2PVDZ',
                                                      'e2eSuperClusterOverP','e2ecalEnergy',
                                                      'e2HasMatchedConversion','e2MissingHits',
                                                      'e2NearMuonVeto'],0]],
                                            ['eiso2',
                                             [ele_iso,['e2Pt','e2PFChargedIso',
                                                       'e2PFNeutralIso','e2PFPhotonIso',
                                                       'e2EffectiveArea2012Data','e2RhoHZG2012'],0]],
                                            ['trigger_match',
                                             [ele_trg_match_data,['metEt','run'],0]]])

electron_selection_data_reqs_2012 = OrderedDict([['epreID1',
                                                  [ele_mva_kTrig_preID,['e1Pt','e1SCEta','e1SigmaIEtaIEta',
                                                                        'e1HadronicOverEM','e1TrkIsoDR03','e1EcalIsoDR03',
                                                                        'e1HcalIsoDR03','e1MissingHits'],0]],
                                                 ['e_mvaID1',
                                                  [ele_mva_kTrig_id,['e1Pt','e1SCEta','e1MVATrig'],0]],
                                                 ['eiso1',
                                                  [ele_iso,['e1Pt','e1PFChargedIso',
                                                            'e1PFNeutralIso','e1PFPhotonIso',
                                                            'e1EffectiveArea2012Data','e1RhoHZG2012'],0]],
                                                 ['epreID2',
                                                  [ele_mva_kTrig_preID,['e2Pt','e2SCEta','e2SigmaIEtaIEta',
                                                                        'e2HadronicOverEM','e2TrkIsoDR03',
                                                                        'e2EcalIsoDR03','e2HcalIsoDR03','e2MissingHits'],0]],
                                                 ['e_mvaID2',
                                                  [ele_mva_kTrig_id,['e2Pt','e2SCEta','e2MVATrig'],0]],
                                                 ['eiso2',
                                                  [ele_iso,['e2Pt','e2PFChargedIso',
                                                            'e2PFNeutralIso','e2PFPhotonIso',
                                                            'e2EffectiveArea2012Data','e2RhoHZG2012'],0]],
                                                 ['trigger_match',
                                                  [ele_trg_match_data,['metEt','run'],0]]])

electron_selection_mc_reqs = OrderedDict([['ept1',
                                           [ele_pt,['e1Pt'],0]],
                                          ['eeta1',
                                           [ele_eta,['e1SCEta'],0]],
                                          ['eID1',
                                           [ele_ID,['ell1','e1deltaEtaSuperClusterTrackAtVtx',
                                                    'e1deltaPhiSuperClusterTrackAtVtx','e1SigmaIEtaIEta',
                                                    'e1HadronicOverEM','e1PVDXY','e1PVDZ',
                                                    'e1eSuperClusterOverP','e1ecalEnergy',
                                                    'e1HasMatchedConversion','e1MissingHits',
                                                    'e1NearMuonVeto'],0]],
                                          ['eiso1',
                                           [ele_iso,['e1Pt','e1PFChargedIso',
                                                     'e1PFNeutralIso','e1PFPhotonIso',
                                                     'e1EffectiveArea2012Data','e1RhoHZG2012'],0]],
                                          ['ept2',
                                           [ele_pt,['e2Pt'],0]],
                                          ['eeta2',
                                           [ele_eta,['e2SCEta'],0]],
                                          ['eID2',
                                           [ele_ID,['ell2','e2deltaEtaSuperClusterTrackAtVtx',
                                                    'e2deltaPhiSuperClusterTrackAtVtx','e2SigmaIEtaIEta',
                                                    'e2HadronicOverEM','e2PVDXY','e2PVDZ',
                                                    'e2eSuperClusterOverP','e2ecalEnergy',
                                                    'e2HasMatchedConversion','e2MissingHits',
                                                    'e2NearMuonVeto'],0]],
                                          ['eiso2',
                                           [ele_iso,['e2Pt','e2PFChargedIso',
                                                     'e2PFNeutralIso','e2PFPhotonIso',
                                                     'e2EffectiveArea2012Data','e2RhoHZG2012'],0]],
                                          ['trigger_match',
                                           [ele_trg_match_mc,['metEt','eventFraction'],0]]])

electron_selection_mc_reqs_2012 = OrderedDict([['epreID1',
                                                [ele_mva_kTrig_preID,['e1Pt','e1SCEta','e1SigmaIEtaIEta',
                                                                      'e1HadronicOverEM','e1TrkIsoDR03','e1EcalIsoDR03',
                                                                      'e1HcalIsoDR03','e1MissingHits'],0]],
                                                 ['e_mvaID1',
                                                  [ele_mva_kTrig_id,['e1Pt','e1SCEta','e1MVATrig'],0]],
                                                 ['eiso1',
                                                  [ele_iso,['e1Pt','e1PFChargedIso',
                                                            'e1PFNeutralIso','e1PFPhotonIso',
                                                            'e1EffectiveArea2012Data','e1RhoHZG2012'],0]],
                                                 ['epreID2',
                                                  [ele_mva_kTrig_preID,['e2Pt','e2SCEta','e2SigmaIEtaIEta',
                                                                        'e2HadronicOverEM','e2TrkIsoDR03',
                                                                        'e2EcalIsoDR03','e2HcalIsoDR03','e2MissingHits'],0]],
                                                 ['e_mvaID2',
                                                  [ele_mva_kTrig_id,['e2Pt','e2SCEta','e2MVATrig'],0]],
                                                 ['eiso2',
                                                  [ele_iso,['e2Pt','e2PFChargedIso',
                                                            'e2PFNeutralIso','e2PFPhotonIso',
                                                            'e2EffectiveArea2012Data','e2RhoHZG2012'],0]],
                                                 ['trigger_match',
                                                  [ele_trg_match_mc,['metEt','eventFraction'],0]]])

def z_oneleg20(pt1, pt2):
    return (pt1 > 20 or pt2 > 20)

def z_ss(z_ss):
    return z_ss == 0

def z_mass(z):
    return z.M() > 50

mumu_selection_reqs = OrderedDict([['z_mass',
                                    [z_mass,['Z'],0]],
                                   ['z_ss',
                                    [z_ss,['m1_m2_SS'],0]],
                                   ['z_oneleg20',
                                    [z_oneleg20,['m1Pt','m2Pt'],0]]
                                   ])
ee_selection_reqs = OrderedDict([['z_mass',
                                  [z_mass,['Z'],0]],
                                 ['z_ss',
                                  [z_ss,['e1_e2_SS'],0]],
                                 ['z_oneleg20',
                                  [z_oneleg20,['e1Pt','e2Pt'],0]]
                                 ])

#photon kinematic selection
def photon_et(pho,Zg):    
    return (pho.Pt() > 15 and pho.Pt()/Zg.M() > 15.0/110.0)

def photon_eta(sc_eta):
    return (abs(sc_eta) < 1.4442 or (abs(sc_eta) > 1.566  and abs(sc_eta) < 2.5 ))

photon_kine_reqs = OrderedDict([['phoet',[photon_et,['gam','Zg'],0]],
                                ['phoeta',[photon_eta,['gSCEta'],0]]])

def photon_CBID_MEDIUM(bit):
    return bit == 1.0

def photon_HoE(hoe):
    return (hoe < 0.05)

def photon_pixveto(hasPixelSeed):
    return (hasPixelSeed == 0)

trk_iso_etslope  = [0.0010,0.0010]
trk_iso_rhoslope = [0.0167,0.0320]
def photon_trkiso(trkIso,phEt,sc_eta,rho):
    eta_bin = int(fabs(sc_eta) > 1.566)
    return (trkIso - trk_iso_etslope[eta_bin]*phEt - trk_iso_rhoslope[eta_bin]*rho < 2.0)

ecal_iso_etslope  = [0.0060,0.0060]
ecal_iso_rhoslope = [0.1830,0.0900]
def photon_ecaliso(ecalIso,phEt,sc_eta,rho):
    eta_bin = int(fabs(sc_eta) > 1.566)
    return (ecalIso - ecal_iso_etslope[eta_bin]*phEt - ecal_iso_rhoslope[eta_bin]*rho < 4.2)

hcal_iso_etslope  = [0.0025,0.0025]
hcal_iso_rhoslope = [0.0620,0.1800]
def photon_hcaliso(hcalIso,phEt,sc_eta,rho):
    eta_bin = int(fabs(sc_eta) > 1.566)
    return (hcalIso - hcal_iso_etslope[eta_bin]*phEt - hcal_iso_rhoslope[eta_bin]*rho < 2.2)

def photon_sihih(sihih,sipip,sc_eta):    
    return (((fabs(sc_eta) < 1.4442 and sihih < 0.011 and sihih > 0.001 and sipip > 0.001) or
            (fabs(sc_eta) < 2.5 and fabs(sc_eta) > 1.566 and sihih < 0.030)))

def photon_like_jet(phEt,sc_eta,rho,hasPixelSeed,hoe,sihih,sipip,
                    trkIso,ecalIso,hcalIso):
    eta_bin = int(fabs(sc_eta) > 1.566)
    result = photon_HoE(hoe) #start from common H-over-E cut

    #plj sigma ieta ieta cut
    result *= ( ( not eta_bin and sihih < 0.014) or
                ( eta_bin and sihih < 0.035) )

    #plj isolation selection
    result *= (trkIso  < min(5*(3.5 + trk_iso_ptslope[eta_bin]*phEt  + trk_iso_rhoslope[eta_bin]*rho), phEt*0.2))
    result *= (ecalIso < min(5*(3.5 + ecal_iso_ptslope[eta_bin]*phEt + ecal_iso_rhoslope[eta_bin]*rho),phEt*0.2))
    result *= (hcalIso < min(5*(3.5 + hcal_iso_ptslope[eta_bin]*phEt + hcal_iso_rhoslope[eta_bin]*rho),phEt*0.2))

    #plj photon veto
    return (result and not( photon_sihih(sihih,sipip,sc_eta)        and
                            photon_trkiso(trkIso,phEt,sc_eta,rho)   and
                            photon_ecaliso(ecalIso,phEt,sc_eta,rho) and
                            photon_hcaliso(ecalIso,phEt,sc_eta,rho)     )) 
                           
    
    

charged_leptons = [11,13,15]
weak_bosons = [23,24]
quarks = [1,2,3,4,5,6]
photon = 22
gluon = 21
proton = 2212
def isnotgenmatchifsr(PID,motherPID,gMotherPID):
    #if( abs(PID) != 22 ): return True
    if( abs(motherPID) < 22 and abs(PID) == 22): return False
    #if( abs(motherPID) == proton or abs(gMotherPID) == proton ): return False
    #if( abs(motherPID) in charged_leptons and abs(gMotherPID) in charged_leptons ): return False #secondary radiation from lepton
    #if( abs(motherPID) in charged_leptons and abs(gMotherPID) in weak_bosons ): return False #primary radiation from lepton
    #if( motherPID == photon and abs(gMotherPID) in charged_leptons ): return False #photon had some SMC interaction?
    #if( motherPID == gluon or abs(motherPID) in quarks ): return False #ISR photon or gluon fragmentation
    return True

#runs over MC particles
def event_has_ifsr(PID, gMotherPID):
    if( abs(PID) == photon and abs(gMotherPID) == 23 ): return True
    if( abs(PID) == photon and (abs(gMotherPID) in quarks or abs(gMotherPID) == gluon) ): return True
    return False

photon_not_ifsr = OrderedDict([['ifsr_veto',[isnotgenmatchifsr,['gPdgId','gGenMotherPdgId','gGenGrandMotherPdgId'],0]]])
event_has_ifsr = OrderedDict([['has_ifsr',[event_has_ifsr,['gPdgId','gGenMotherPdgId'],0]]])


photon_idiso_reqs = OrderedDict([['phoCBID_MEDIUM',[photon_CBID_MEDIUM,['gCBID_MEDIUM'],0]]])
#                                         ['phohasPixelSeed',[photon_pixveto,['phohasPixelSeed'],0]],
#                                         ['phoTrkIso',[photon_trkiso,['phoTrkIsoHollowDR04','phoEt','phoSCEta','rho'],0]],
#                                         ['phoEcalIso',[photon_ecaliso,['phoEcalIsoDR04','phoEt','phoSCEta','rho'],0]],
#                                         ['phoHcalIso',[photon_hcaliso,['phoHcalIsoDR04','phoEt','phoSCEta','rho'],0]]])

photon_like_jet_idiso = OrderedDict([['photonLikeJet',[photon_like_jet,['phoCorEt','phoSCEta','rho','phohasPixelSeed',
                                                                        'phoHoverE','phoSigmaIEtaIEta','phoSigmaIPhiIPhi',
                                                                        'phoTrkIsoHollowDR04','phoEcalIsoDR04',
                                                                        'phoHcalIsoDR04']]]])

photon_sihih_req = OrderedDict([['phosihih',[photon_sihih,['phoSigmaIEtaIEta','phoSigmaIPhiIPhi','phoSCEta'],0]]])
photon_mc_sihih_req = OrderedDict([['phosihih',[photon_sihih,['phoCorSigmaIEtaIEta','phoSigmaIPhiIPhi','phoSCEta'],0]]])

photon_idiso_reqs = OrderedDict( photon_idiso_reqs.items() ) #+
#photon_sihih_req.items() )
photon_mc_idiso_reqs = OrderedDict( photon_idiso_reqs.items() )# +
#                                    photon_mc_sihih_req.items() )

def ell_gamma_dr(ell1,ell2,pho):
    mindr = min(pho.DeltaR(ell1),
                pho.DeltaR(ell2))
    return mindr > 0.4


#trigger and eventsel
muon_triggers_data = CutflowDecision(mumu_good_event_data_reqs)
muon_triggers_mc = CutflowDecision(mumu_good_event_mc_reqs)
electron_triggers_data = CutflowDecision(ee_good_event_data_reqs)
electron_triggers_mc = CutflowDecision(ee_good_event_mc_reqs)
event_has_ifsr = CutflowDecision(event_has_ifsr)

#single object IDs
mu_cuts_data = CutflowDecision(muon_selection_data_reqs)
mu_cuts_mc   = CutflowDecision(muon_selection_mc_reqs)
mu_cuts_data_2012 = CutflowDecision(muon_selection_data_reqs_2012)
mu_cuts_mc_2012   = CutflowDecision(muon_selection_mc_reqs_2012)
e_cuts_data  = CutflowDecision(electron_selection_data_reqs)
e_cuts_mc    = CutflowDecision(electron_selection_mc_reqs)
e_cuts_data_2012  = CutflowDecision(electron_selection_data_reqs_2012)
e_cuts_mc_2012    = CutflowDecision(electron_selection_mc_reqs_2012)
photon_cuts_data  = CutflowDecision(photon_kine_reqs.items() +
                                    photon_idiso_reqs.items()
                                    )
photon_cuts_plj   = CutflowDecision(photon_kine_reqs.items() +
                                    photon_like_jet_idiso.items())
photon_cuts_mc  = CutflowDecision(photon_kine_reqs.items() +
                                  photon_mc_idiso_reqs.items()
                                  )
photon_cuts_noifsr = CutflowDecision(photon_kine_reqs.items() +
                                     photon_mc_idiso_reqs.items() +
                                     photon_not_ifsr.items())

#z candidate cuts
mumu_cuts = CutflowDecision(mumu_selection_reqs)
ee_cuts = CutflowDecision(ee_selection_reqs)

#zgamma candidate cuts
#llg_cuts = CutflowDecision(zgamma_selection_reqs)

#mumug gamma total selection
#mumug_cuts = CompositeCutflow()
#mumug_cuts.addCutflow('trigger',muon_triggers)
#mumug_cuts.addCutflow('mu1',mu_cuts)
#mumug_cuts.addCutflow('mu2',mu_cuts)
#mumug_cuts.addCutflow('pho',photon_cuts)
#mumug_cuts.addCutflow('z',mumu_cuts)
#mumug_cuts.addCut('mindr',zgamma_selection_reqs['mindr'])

#eeg candidate cuts
#eeg_cuts = CompositeCutflow()
#eeg_cuts.addCutflow('trigger',electron_triggers)
#eeg_cuts.addCutflow('e1',e_cuts)
#eeg_cuts.addCutflow('e2',e_cuts)
#eeg_cuts.addCutflow('pho',photon_cuts)
#eeg_cuts.addCutflow('z',ee_cuts)
#eeg_cuts.addCut('mindr',zgamma_selection_reqs['mindr'])
