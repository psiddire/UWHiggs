dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

samp = ['Zothers', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['vH_htt', 'TT', 'T', 'Diboson']

# Embed
trk = ['/embtrk0Up', '/embtrk0Down', '/embtrk1Up', '/embtrk1Down']

trkNames = [['ZTauTau_CMS_tau_tracking_prong_13TeVUp', 'ZTauTau_CMS_tau_tracking_prong_2018_13TeVUp'], ['ZTauTau_CMS_tau_tracking_prong_13TeVDown', 'ZTauTau_CMS_tau_tracking_prong_2018_13TeVDown'], ['ZTauTau_CMS_tau_tracking_pizero_13TeVUp', 'ZTauTau_CMS_tau_tracking_pizero_2018_13TeVUp'], ['ZTauTau_CMS_tau_tracking_pizero_13TeVDown', 'ZTauTau_CMS_tau_tracking_pizero_2018_13TeVDown']]

tid = ['/tid30Up', '/tid30Down', '/tid35Up', '/tid35Down', '/tid40Up', '/tid40Down']

tidNames = [['ZTauTau_CMS_tauid_pt30to35_2018_13TeVUp', 'ZTauTau_CMS_emb_tauid_pt30to35_2018_13TeVUp'], ['ZTauTau_CMS_tauid_pt30to35_2018_13TeVDown', 'ZTauTau_CMS_emb_tauid_pt30to35_2018_13TeVDown'], ['ZTauTau_CMS_tauid_pt35to40_2018_13TeVUp', 'ZTauTau_CMS_emb_tauid_pt35to40_2018_13TeVUp'], ['ZTauTau_CMS_tauid_pt35to40_2018_13TeVDown', 'ZTauTau_CMS_emb_tauid_pt35to40_2018_13TeVDown'], ['ZTauTau_CMS_tauid_ptgt40_2018_13TeVUp', 'ZTauTau_CMS_emb_tauid_ptgt40_2018_13TeVUp'], ['ZTauTau_CMS_tauid_ptgt40_2018_13TeVDown', 'ZTauTau_CMS_emb_tauid_ptgt40_2018_13TeVDown']]

# Fake Rate
tauFR = ['/TauFakep0EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep0EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep0EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep0EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep0EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep0EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EBDM0Up', '/TauFakep1EBDM0Down', '/TauFakep1EBDM1Up', '/TauFakep1EBDM1Down', '/TauFakep1EBDM10Up', '/TauFakep1EBDM10Down', '/TauFakep1EEDM0Up', '/TauFakep1EEDM0Down', '/TauFakep1EEDM1Up', '/TauFakep1EEDM1Down', '/TauFakep1EEDM10Up', '/TauFakep1EEDM10Down', '/TauFakep0EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep0EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EBDM11Up', '/TauFakep1EBDM11Down', '/TauFakep1EEDM11Up', '/TauFakep1EEDM11Down']

muonFR = ['/MuonFakep0Up', '/MuonFakep0Down', '/MuonFakep1Up', '/MuonFakep1Down']

tauFRNames = ['_CMS_TauFakeRate_p0_dm0_B_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm0_B_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm1_B_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm1_B_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm10_B_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm10_B_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm0_E_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm0_E_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm1_E_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm1_E_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm10_E_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm10_E_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm0_B_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm0_B_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm1_B_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm1_B_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm10_B_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm10_B_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm0_E_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm0_E_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm1_E_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm1_E_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm10_E_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm10_E_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm11_B_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm11_B_2018_13TeVDown', '_CMS_TauFakeRate_p0_dm11_E_2018_13TeVUp', '_CMS_TauFakeRate_p0_dm11_E_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm11_B_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm11_B_2018_13TeVDown', '_CMS_TauFakeRate_p1_dm11_E_2018_13TeVUp', '_CMS_TauFakeRate_p1_dm11_E_2018_13TeVDown']

muonFRNames = ['_CMS_MuonFakeRate_p0_2018_13TeVUp', '_CMS_MuonFakeRate_p0_2018_13TeVDown', '_CMS_MuonFakeRate_p1_2018_13TeVUp', '_CMS_MuonFakeRate_p1_2018_13TeVDown']

# Scale
scaleSys = ['/scaletDM0Up', '/scaletDM0Down', '/scaletDM1Up', '/scaletDM1Down', '/scaletDM10Up', '/scaletDM10Down', '/scaletDM11Up', '/scaletDM11Down']

scaleSysNames = ['_CMS_scale_t_1prong_2018_13TeVUp', '_CMS_scale_t_1prong_2018_13TeVDown', '_CMS_scale_t_1prong1pizero_2018_13TeVUp', '_CMS_scale_t_1prong1pizero_2018_13TeVDown', '_CMS_scale_t_3prong_2018_13TeVUp', '_CMS_scale_t_3prong_2018_13TeVDown', '_CMS_scale_t_3prong1pizero_2018_13TeVUp', '_CMS_scale_t_3prong1pizero_2018_13TeVDown']

embscaleSysNames = [['_CMS_scale_t_1prong_2018_13TeVUp', '_CMS_scale_emb_t_1prong_2018_13TeVUp'], ['_CMS_scale_t_1prong_2018_13TeVDown', '_CMS_scale_emb_t_1prong_2018_13TeVDown'], ['_CMS_scale_t_1prong1pizero_2018_13TeVUp', '_CMS_scale_emb_t_1prong1pizero_2018_13TeVUp'], ['_CMS_scale_t_1prong1pizero_2018_13TeVDown', '_CMS_scale_emb_t_1prong1pizero_2018_13TeVDown'], ['_CMS_scale_t_3prong_2018_13TeVUp', '_CMS_scale_emb_t_3prong_2018_13TeVUp'], ['_CMS_scale_t_3prong_2018_13TeVDown', '_CMS_scale_emb_t_3prong_2018_13TeVDown'], ['_CMS_scale_t_3prong1pizero_2018_13TeVUp', '_CMS_scale_emb_t_3prong1pizero_2018_13TeVUp'], ['_CMS_scale_t_3prong1pizero_2018_13TeVDown', '_CMS_scale_emb_t_3prong1pizero_2018_13TeVDown']]

# MC
mcSys = ['/puUp', '/puDown', '/tid30Up', '/tid30Down', '/tid35Up', '/tid35Down', '/tid40Up', '/tid40Down', '/bTagUp', '/bTagDown', '/mtfake0Up', '/mtfake0Down', '/mtfake0p4Up', '/mtfake0p4Down', '/mtfake0p8Up', '/mtfake0p8Down', '/mtfake1p2Up', '/mtfake1p2Down', '/mtfake1p7Up', '/mtfake1p7Down', '/etfakebUp', '/etfakebDown', '/etfakeeUp', '/etfakeeDown', '/etfakeesbdm0Up', '/etfakeesbdm0Down', '/etfakeesbdm1Up', '/etfakeesbdm1Down', '/etfakeesedm0Up', '/etfakeesedm0Down', '/etfakeesedm1Up', '/etfakeesedm1Down', '/mtfakeesdm0Up', '/mtfakeesdm0Down', '/mtfakeesdm1Up', '/mtfakeesdm1Down', '/mes1p2Up', '/mes1p2Down', '/mes2p1Up', '/mes2p1Down']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_tauid_pt30to35_2018_13TeVUp', '_CMS_tauid_pt30to35_2018_13TeVDown', '_CMS_tauid_pt35to40_2018_13TeVUp', '_CMS_tauid_pt35to40_2018_13TeVDown', '_CMS_tauid_ptgt40_2018_13TeVUp', '_CMS_tauid_ptgt40_2018_13TeVDown', '_CMS_eff_btag_2018_13TeVUp', '_CMS_eff_btag_2018_13TeVDown', '_CMS_mutauFR_etaLt0p4_2018_13TeVUp', '_CMS_mutauFR_etaLt0p4_2018_13TeVDown', '_CMS_mutauFR_eta0p4to0p8_2018_13TeVUp', '_CMS_mutauFR_eta0p4to0p8_2018_13TeVDown', '_CMS_mutauFR_eta0p8to1p2_2018_13TeVUp', '_CMS_mutauFR_eta0p8to1p2_2018_13TeVDown', '_CMS_mutauFR_eta1p2to1p7_2018_13TeVUp', '_CMS_mutauFR_eta1p2to1p7_2018_13TeVDown', '_CMS_mutauFR_etaGt1p7_2018_13TeVUp', '_CMS_mutauFR_etaGt1p7_2018_13TeVUp', '_CMS_etauFR_barrel_2018_13TeVUp', '_CMS_etauFR_barrel_2018_13TeVDown', '_CMS_etauFR_endcap_2018_13TeVUp', '_CMS_etauFR_endcap_2018_13TeVDown', '_CMS_scale_etauFR_barrel_1prong_2018_13TeVUp', '_CMS_scale_etauFR_barrel_1prong_2018_13TeVDown', '_CMS_scale_etauFR_barrel_1prong1pizero_2018_13TeVUp', '_CMS_scale_etauFR_barrel_1prong1pizero_2018_13TeVDown', '_CMS_scale_etauFR_endcap_1prong_2018_13TeVUp', '_CMS_scale_etauFR_endcap_1prong_2018_13TeVDown', '_CMS_scale_etauFR_endcap_1prong1pizero_2018_13TeVUp', '_CMS_scale_etauFR_endcap_1prong1pizero_2018_13TeVDown', '_CMS_scale_mtauFR_1prong_2018_13TeVUp', '_CMS_scale_mtauFR_1prong_2018_13TeVDown', '_CMS_scale_mtauFR_1prong1pizero_2018_13TeVUp', '_CMS_scale_mtauFR_1prong1pizero_2018_13TeVDown', '_CMS_scale_m_etaLt1p2_13TeVUp', '_CMS_scale_m_etaLt1p2_13TeVDown', '_CMS_scale_m_eta1p2to2p1_13TeVUp', '_CMS_scale_m_eta1p2to2p1_13TeVDown']

dyptSys = ['/DYptreweightUp', '/DYptreweightDown']

dyptSysNames = ['_CMS_DYpTreweight_2018_13TeVUp', '_CMS_DYpTreweight_2018_13TeVDown']

# Recoil, JES
recSys = ['/recrespUp', '/recrespDown', '/recresoUp', '/recresoDown']

recSysNames = ['_CMS_RecoilResponse_2018_13TeVUp', '_CMS_RecoilResponse_2018_13TeVDown', '_CMS_RecoilResolution_2018_13TeVUp', '_CMS_RecoilResolution_2018_13TeVDown']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsolute_13TeVUp', '_CMS_Jes_JetAbsolute_13TeVDown', '_CMS_Jes_JetAbsoluteyear_13TeVUp', '_CMS_Jes_JetAbsoluteyear_13TeVDown', '_CMS_Jes_JetBBEC1_13TeVUp', '_CMS_Jes_JetBBEC1_13TeVDown', '_CMS_Jes_JetBBEC1year_13TeVUp', '_CMS_Jes_JetBBEC1year_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetEC2_13TeVUp', '_CMS_Jes_JetEC2_13TeVDown', '_CMS_Jes_JetEC2year_13TeVUp', '_CMS_Jes_JetEC2year_13TeVDown', '_CMS_Jes_JetHF_13TeVUp', '_CMS_Jes_JetHF_13TeVDown', '_CMS_Jes_JetHFyear_13TeVUp', '_CMS_Jes_JetHFyear_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown', '_CMS_Jer_13TeVUp', '_CMS_Jer_13TeVDown']

# Samples
mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*']

mc_samples_W = mc_samples + ['WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*']

histoname = [("mPt", "#mu p_{T} (GeV)", 1), ("tPt", "#tau p_{T} (GeV)", 1), ("mEta", "#mu #eta", 1), ("tEta", "#tau #eta", 1), ("mPhi", "#mu #phi", 1), ("tPhi", "#tau #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("m_t_Mass", "M_{vis}(#mu, #tau) (GeV)", 1), ("m_t_CollinearMass", "M_{col}(#mu, #tau) (GeV)", 1), ("m_t_PZeta", "p_{#zeta}(#mu, #tau) (GeV)", 1), ("numOfJets", "Number Of Jets", 1), ("numOfVtx", "Number of Vertices", 1), ("vbfMass", "VBF Mass", 1), ("dEtaMuTau", "#Delta#eta(#mu, #tau)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiTauMET", "#Delta#phi(#tau, MET)", 1), ("dPhiMuTau", "#Delta#phi(#mu, #tau)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1), ("MTTauMET", "M_{T}(#tau, MET) (GeV)", 1)]

wjhisto = histoname + [("j1Fl", "Jet 1 Flavor", 1), ("j2Fl", "Jet 2 Flavor", 1)]

colhisto = [("m_t_CollinearMass", "M_{col}(#mu, #tau) (GeV)", 1)]

bdthisto = [("bdtDiscriminator", "BDT Discriminator", 1)]

files = []

lumifiles = []

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output
