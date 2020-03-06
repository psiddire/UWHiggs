dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

samp = ['Zothers', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['vH_htt', 'TT', 'T', 'Diboson']

trk = ['/embtrkUp', '/embtrkDown']

trkNames = ['ZTauTau_CMS_tracking_tauUp', 'ZTauTau_CMS_tracking_tauDown']

tid = ['/tidUp', '/tidDown']

tidNames = [['ZTauTau_CMS_eff_tauUp', 'ZTauTau_CMS_eff_emb_tauUp'], ['ZTauTau_CMS_eff_tauDown', 'ZTauTau_CMS_eff_emb_tauDown']]

escale = ['/eesUp', '/eesDown']

escaleNames = [['ZTauTau_CMS_EES_13TeVUp', 'ZTauTau_CMS_EES_emb_13TeVUp'], ['ZTauTau_CMS_EES_13TeVDown', 'ZTauTau_CMS_EES_emb_13TeVDown']]

tauFR = ['/TauFakep0EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep0EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep0EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep0EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep0EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep0EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EBDM0Up', '/TauFakep1EBDM0Down', '/TauFakep1EBDM1Up', '/TauFakep1EBDM1Down', '/TauFakep1EBDM10Up', '/TauFakep1EBDM10Down', '/TauFakep1EEDM0Up', '/TauFakep1EEDM0Down', '/TauFakep1EEDM1Up', '/TauFakep1EEDM1Down', '/TauFakep1EEDM10Up', '/TauFakep1EEDM10Down']

tauDeepFR = tauFR + ['/TauFakep0EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep0EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EBDM11Up', '/TauFakep1EBDM11Down', '/TauFakep1EEDM11Up', '/TauFakep1EEDM11Down']

tauFRNames = ['_CMS_TauFakeRate_p0_dm0_B_13TeVUp', '_CMS_TauFakeRate_p0_dm0_B_13TeVDown', '_CMS_TauFakeRate_p0_dm1_B_13TeVUp', '_CMS_TauFakeRate_p0_dm1_B_13TeVDown', '_CMS_TauFakeRate_p0_dm10_B_13TeVUp', '_CMS_TauFakeRate_p0_dm10_B_13TeVDown', '_CMS_TauFakeRate_p0_dm0_E_13TeVUp', '_CMS_TauFakeRate_p0_dm0_E_13TeVDown', '_CMS_TauFakeRate_p0_dm1_E_13TeVUp', '_CMS_TauFakeRate_p0_dm1_E_13TeVDown', '_CMS_TauFakeRate_p0_dm10_E_13TeVUp', '_CMS_TauFakeRate_p0_dm10_E_13TeVDown', '_CMS_TauFakeRate_p1_dm0_B_13TeVUp', '_CMS_TauFakeRate_p1_dm0_B_13TeVDown', '_CMS_TauFakeRate_p1_dm1_B_13TeVUp', '_CMS_TauFakeRate_p1_dm1_B_13TeVDown', '_CMS_TauFakeRate_p1_dm10_B_13TeVUp', '_CMS_TauFakeRate_p1_dm10_B_13TeVDown', '_CMS_TauFakeRate_p1_dm0_E_13TeVUp', '_CMS_TauFakeRate_p1_dm0_E_13TeVDown', '_CMS_TauFakeRate_p1_dm1_E_13TeVUp', '_CMS_TauFakeRate_p1_dm1_E_13TeVDown', '_CMS_TauFakeRate_p1_dm10_E_13TeVUp', '_CMS_TauFakeRate_p1_dm10_E_13TeVDown']

tauDeepFRNames = tauFRNames + ['_CMS_TauFakeRate_p0_dm11_B_13TeVUp', '_CMS_TauFakeRate_p0_dm11_B_13TeVDown', '_CMS_TauFakeRate_p0_dm11_E_13TeVUp', '_CMS_TauFakeRate_p0_dm11_E_13TeVDown', '_CMS_TauFakeRate_p1_dm11_B_13TeVUp', '_CMS_TauFakeRate_p1_dm11_B_13TeVDown', '_CMS_TauFakeRate_p1_dm11_E_13TeVUp', '_CMS_TauFakeRate_p1_dm11_E_13TeVDown']

eleFR = ['/EleFakep0Up', '/EleFakep0Down', '/EleFakep1Up', '/EleFakep1Down']

eleFRNames = ['_CMS_EleFakeRate_p0_13TeVUp', '_CMS_EleFakeRate_p0_13TeVDown', '_CMS_EleFakeRate_p1_13TeVUp', '_CMS_EleFakeRate_p1_13TeVDown', '_CMS_EleFakeRate_p2_13TeVUp', '_CMS_EleFakeRate_p2_13TeVDown']

scaleSys = ['/scaletDM0Up', '/scaletDM0Down', '/scaletDM1Up', '/scaletDM1Down', '/scaletDM10Up', '/scaletDM10Down']

scaleSysDeep = scaleSys + ['/scaletDM11Up', '/scaletDM11Down']

scaleSysNames = ['_CMS_scale_t_1prong_13TeVUp', '_CMS_scale_t_1prong_13TeVDown', '_CMS_scale_t_1prong1pizero_13TeVUp', '_CMS_scale_t_1prong1pizero_13TeVDown', '_CMS_scale_t_3prong_13TeVUp', '_CMS_scale_t_3prong_13TeVDown']

scaleSysDeepNames = scaleSysNames + ['_CMS_scale_t_3prong1pizero_13TeVUp', '_CMS_scale_t_3prong1pizero_13TeVDown']

embscaleSysNames = [['_CMS_scale_t_1prong_13TeVUp', '_CMS_scale_emb_t_1prong_13TeVUp'], ['_CMS_scale_t_1prong_13TeVDown', '_CMS_scale_emb_t_1prong_13TeVDown'], ['_CMS_scale_t_1prong1pizero_13TeVUp', '_CMS_scale_emb_t_1prong1pizero_13TeVUp'], ['_CMS_scale_t_1prong1pizero_13TeVDown', '_CMS_scale_emb_t_1prong1pizero_13TeVDown'], ['_CMS_scale_t_3prong_13TeVUp', '_CMS_scale_emb_t_3prong_13TeVUp'], ['_CMS_scale_t_3prong_13TeVDown', '_CMS_scale_emb_t_3prong_13TeVDown']]

embscaleSysDeepNames = embscaleSysNames + [['_CMS_scale_t_3prong1pizero_13TeVUp', '_CMS_scale_emb_t_3prong1pizero_13TeVUp'], ['_CMS_scale_t_3prong1pizero_13TeVDown', '_CMS_scale_emb_t_3prong1pizero_13TeVDown']]

mcSys = ['/puUp', '/puDown', '/pfUp', '/pfDown', '/tidUp', '/tidDown', '/bTagUp', '/bTagDown', '/mtfakeUp', '/mtfakeDown', '/etfakeUp', '/etfakeDown', '/etefakeUp', '/etefakeDown', '/eesUp', '/eesDown']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_Prefiring_13TeVUp', '_CMS_Prefiring_13TeVDown', '_CMS_eff_tauUp', '_CMS_eff_tauDown', '_CMS_eff_btag_13TeVUp', '_CMS_eff_btag_13TeVDown', '_CMS_scale_mfaketau_13TeVUp', '_CMS_scale_mfaketau_13TeVDown', '_CMS_scale_efaketau_13TeVUp', '_CMS_scale_efaketau_13TeVDown', '_CMS_scale_efaketaues_13TeVUp', '_CMS_scale_efaketaues_13TeVDown', '_CMS_EES_13TeVUp', '_CMS_EES_13TeVDown']

recSys = ['/recrespUp', '/recrespDown', '/recresoUp', '/recresoDown']

recSysNames = ['_CMS_RecoilResponse_13TeVUp', '_CMS_RecoilResponse_13TeVDown', '_CMS_RecoilResolution_13TeVUp', '_CMS_RecoilResolution_13TeVDown']

dyptSys = ['/DYptreweightUp', '/DYptreweightDown']

dyptSysNames = ['_CMS_DYpTreweight_13TeVUp', '_CMS_DYpTreweight_13TeVDown']

ttSys = ['/TopptreweightUp', '/TopptreweightDown']

ttSysNames = ['_CMS_TTpTreweight_13TeVUp', '_CMS_TTpTreweight_13TeVDown']

jesSys = ['/UnclusteredEnUp', '/UnclusteredEnDown', '/UesCHARGEDUp', '/UesCHARGEDDown', '/UesECALUp', '/UesECALDown', '/UesHCALUp', '/UesHCALDown', '/UesHFUp', '/UesHFDown', '/JetAbsoluteFlavMapUp', '/JetAbsoluteFlavMapDown', '/JetAbsoluteMPFBiasUp', '/JetAbsoluteMPFBiasDown', '/JetAbsoluteScaleUp', '/JetAbsoluteScaleDown', '/JetAbsoluteStatUp', '/JetAbsoluteStatDown', '/JetFlavorQCDUp', '/JetFlavorQCDDown', '/JetFragmentationUp', '/JetFragmentationDown', '/JetPileUpDataMCUp', '/JetPileUpDataMCDown', '/JetPileUpPtBBUp', '/JetPileUpPtBBDown', '/JetPileUpPtEC1Up', '/JetPileUpPtEC1Down', '/JetPileUpPtEC2Up', '/JetPileUpPtEC2Down', '/JetPileUpPtHFUp', '/JetPileUpPtHFDown', '/JetPileUpPtRefUp', '/JetPileUpPtRefDown', '/JetRelativeFSRUp', '/JetRelativeFSRDown', '/JetRelativeJEREC1Up', '/JetRelativeJEREC1Down', '/JetRelativeJEREC2Up', '/JetRelativeJEREC2Down', '/JetRelativeJERHFUp', '/JetRelativeJERHFDown', '/JetRelativePtBBUp', '/JetRelativePtBBDown', '/JetRelativePtEC1Up', '/JetRelativePtEC1Down', '/JetRelativePtEC2Up', '/JetRelativePtEC2Down', '/JetRelativePtHFUp', '/JetRelativePtHFDown', '/JetRelativeStatECUp', '/JetRelativeStatECDown', '/JetRelativeStatFSRUp', '/JetRelativeStatFSRDown', '/JetRelativeStatHFUp', '/JetRelativeStatHFDown', '/JetSinglePionECALUp', '/JetSinglePionECALDown', '/JetSinglePionHCALUp', '/JetSinglePionHCALDown', '/JetTimePtEtaUp', '/JetTimePtEtaDown', '/JetRelativeBalUp', '/JetRelativeBalDown', '/JetRelativeSampleUp', '/JetRelativeSampleDown']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsoluteFlavMap_13TeVUp', '_CMS_Jes_JetAbsoluteFlavMap_13TeVDown', '_CMS_Jes_JetAbsoluteMPFBias_13TeVUp', '_CMS_Jes_JetAbsoluteMPFBias_13TeVDown', '_CMS_Jes_JetAbsoluteScale_13TeVUp', '_CMS_Jes_JetAbsoluteScale_13TeVDown', '_CMS_Jes_JetAbsoluteStat_13TeVUp', '_CMS_Jes_JetAbsoluteStat_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetFragmentation_13TeVUp', '_CMS_Jes_JetFragmentation_13TeVDown', '_CMS_Jes_JetPileUpDataMC_13TeVUp', '_CMS_Jes_JetPileUpDataMC_13TeVDown', '_CMS_Jes_JetPileUpPtBB_13TeVUp', '_CMS_Jes_JetPileUpPtBB_13TeVDown', '_CMS_Jes_JetPileUpPtEC1_13TeVUp', '_CMS_Jes_JetPileUpPtEC1_13TeVDown', '_CMS_Jes_JetPileUpPtEC2_13TeVUp', '_CMS_Jes_JetPileUpPtEC2_13TeVDown', '_CMS_Jes_JetPileUpPtHF_13TeVUp', '_CMS_Jes_JetPileUpPtHF_13TeVDown', '_CMS_Jes_JetPileUpPtRef_13TeVUp', '_CMS_Jes_JetPileUpPtRef_13TeVDown', '_CMS_Jes_JetRelativeFSR_13TeVUp', '_CMS_Jes_JetRelativeFSR_13TeVDown', '_CMS_Jes_JetRelativeJEREC1_13TeVUp', '_CMS_Jes_JetRelativeJEREC1_13TeVDown', '_CMS_Jes_JetRelativeJEREC2_13TeVUp', '_CMS_Jes_JetRelativeJEREC2_13TeVDown', '_CMS_Jes_JetRelativeJERHF_13TeVUp', '_CMS_Jes_JetRelativeJERHF_13TeVDown', '_CMS_Jes_JetRelativePtBB_13TeVUp', '_CMS_Jes_JetRelativePtBB_13TeVDown', '_CMS_Jes_JetRelativePtEC1_13TeVUp', '_CMS_Jes_JetRelativePtEC1_13TeVDown', '_CMS_Jes_JetRelativePtEC2_13TeVUp', '_CMS_Jes_JetRelativePtEC2_13TeVDown', '_CMS_Jes_JetRelativePtHF_13TeVUp', '_CMS_Jes_JetRelativePtHF_13TeVDown', '_CMS_Jes_JetRelativeStatEC_13TeVUp', '_CMS_Jes_JetRelativeStatEC_13TeVDown', '_CMS_Jes_JetRelativeStatFSR_13TeVUp', '_CMS_Jes_JetRelativeStatFSR_13TeVDown', '_CMS_Jes_JetRelativeStatHF_13TeVUp', '_CMS_Jes_JetRelativeStatHF_13TeVDown', '_CMS_Jes_JetSinglePionECAL_13TeVUp', '_CMS_Jes_JetSinglePionECAL_13TeVDown', '_CMS_Jes_JetSinglePionHCAL_13TeVUp', '_CMS_Jes_JetSinglePionHCAL_13TeVDown', '_CMS_Jes_JetTimePtEta_13TeVUp', '_CMS_Jes_JetTimePtEta_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown']

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*']

mc_samples_W = mc_samples + ['WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*']

histoname = [('ePt', 'e p_{T} (GeV)', 1), ('tPt', '#tau p_{T} (GeV)', 1), ('eEta', 'e #eta', 1), ('tEta', '#tau #eta', 1), ('ePhi', 'e #phi', 1), ('tPhi', '#tau #phi', 1), ('j1Pt', 'Jet 1 p_{T}', 1), ('j2Pt', 'Jet 2 p_{T}', 1), ('j1Eta', 'Jet 1 #eta', 1), ('j2Eta', 'Jet 2 #eta', 1), ('j1Phi', 'Jet 1 #phi', 1), ('j2Phi', 'Jet 2 #phi', 1), ('type1_pfMetEt', 'MET (GeV)', 1), ('type1_pfMetPhi', 'MET #phi', 1), ('e_t_Mass', 'M_{vis}(e, #tau) (GeV)', 1), ('e_t_CollinearMass', 'M_{col}(e, #tau) (GeV)', 1), ('e_t_PZeta', 'p_{#zeta}(e, #tau) (GeV)', 1), ('numOfJets', 'Number Of Jets', 1), ('vbfMass', 'VBF Mass', 1), ('numOfVtx', 'Number of Vertices', 1), ('dEtaETau', '#Delta#eta(e, #tau)', 1), ('dPhiEMET', '#Delta#phi(e, MET)', 1), ('dPhiTauMET', '#Delta#phi(#tau, MET)', 1), ('dPhiETau', '#Delta#phi(e, #tau)', 1), ('MTEMET', 'M_{T}(e, MET) (GeV)', 1), ('MTTauMET', 'M_{T}(#tau, MET) (GeV)', 1)]

colhisto = [("e_t_CollinearMass", "M_{col}(e, #tau) (GeV)", 1)]

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
