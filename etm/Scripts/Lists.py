dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['TT', 'T', 'Diboson']

# QCD
qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_qcd_0jet_rate_2017Up', 'QCD_CMS_qcd_0jet_rate_2017Down', 'QCD_CMS_qcd_1jet_rate_2017Up', 'QCD_CMS_qcd_1jet_rate_2017Down', 'QCD_CMS_qcd_2jet_rate_2017Up', 'QCD_CMS_qcd_2jet_rate_2017Down', 'QCD_CMS_qcd_0jet_shape_2017Up', 'QCD_CMS_qcd_0jet_shape_2017Down', 'QCD_CMS_qcd_1jet_shape_2017Up', 'QCD_CMS_qcd_1jet_shape_2017Down', 'QCD_CMS_qcd_2jet_shape_2017Up', 'QCD_CMS_qcd_2jet_shape_2017Down', 'QCD_CMS_qcd_extrapolationUp', 'QCD_CMS_qcd_extrapolationDown']

# MC
mcSys = ['puUp/', 'puDown/', 'pfUp/', 'pfDown/', 'bTagUp/', 'bTagDown/', 'eesUp/', 'eesDown/', 'mes1p2Up/', 'mes1p2Down/', 'mes2p1Up/', 'mes2p1Down/', 'mes2p4Up/', 'mes2p4Down/']

mcSysNames = ['_CMS_pileupUp', '_CMS_pileupDown', '_CMS_prefiringUp', '_CMS_prefiringDown', '_CMS_eff_b_2017Up', '_CMS_eff_b_2017Down', '_CMS_scale_eUp', '_CMS_scale_eDown', '_CMS_scale_m_etaLt1p2Up', '_CMS_scale_m_etaLt1p2Down', '_CMS_scale_m_eta1p2to2p1Up', '_CMS_scale_m_eta1p2to2p1Down', '_CMS_scale_m_eta2p1to2p4Up', '_CMS_scale_m_eta2p1to2p4Down']

escale = ['eesUp/', 'eesDown/']

escaleNames = ['ZTauTau_CMS_scale_e_embUp', 'ZTauTau_CMS_scale_e_embDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_dyShape_2017Up', '_CMS_dyShape_2017Down']

# Recoil, JES
recSys = ['recresp0Up/', 'recresp0Down/', 'recreso0Up/', 'recreso0Down/', 'recresp1Up/', 'recresp1Down/', 'recreso1Up/', 'recreso1Down/', 'recresp2Up/', 'recresp2Down/', 'recreso2Up/', 'recreso2Down/']

recSysNames = ['_CMS_scale_met_0Jet_2017Up', '_CMS_scale_met_0Jet_2017Down', '_CMS_res_met_0Jet_2017Up', '_CMS_res_met_0Jet_2017Down', '_CMS_scale_met_1Jet_2017Up', '_CMS_scale_met_1Jet_2017Down', '_CMS_res_met_1Jet_2017Up', '_CMS_res_met_1Jet_2017Down', '_CMS_scale_met_2Jet_2017Up', '_CMS_scale_met_2Jet_2017Down', '_CMS_res_met_2Jet_2017Up', '_CMS_res_met_2Jet_2017Down']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_UesUp', '_CMS_MET_UesDown', '_CMS_scale_met_chargedUp', '_CMS_scale_met_chargedDown', '_CMS_scale_met_ecalUp', '_CMS_scale_met_ecalDown', '_CMS_scale_met_hcalUp', '_CMS_scale_met_hcalDown', '_CMS_scale_met_hfUp', '_CMS_scale_met_hfDown', '_CMS_scale_j_AbsoluteUp', '_CMS_scale_j_AbsoluteDown', '_CMS_scale_j_Absolute_2017Up', '_CMS_scale_j_Absolute_2017Down', '_CMS_scale_j_BBEC1Up', '_CMS_scale_j_BBEC1Down', '_CMS_scale_j_BBEC1_2017Up', '_CMS_scale_j_BBEC1_2017Down', '_CMS_scale_j_FlavorQCDUp', '_CMS_scale_j_FlavorQCDDown', '_CMS_scale_j_EC2Up', '_CMS_scale_j_EC2Down', '_CMS_scale_j_EC2_2017Up', '_CMS_scale_j_EC2_2017Down', '_CMS_scale_j_HFUp', '_CMS_scale_j_HFDown', '_CMS_scale_j_HF_2017Up', '_CMS_scale_j_HF_2017Down', '_CMS_scale_j_RelativeBalUp', '_CMS_scale_j_RelativeBalDown', '_CMS_scale_j_RelativeSample_2017Up', '_CMS_scale_j_RelativeSample_2017Down', '_CMS_res_j_2017Up', '_CMS_res_j_2017Down']

# Samples
mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*', 'Obs*', 'Bac*']

histoname = [('ePt', 'e p_{T} (Gev)', 1), ('mPt', '#mu p_{T} (GeV)', 1), ('eEta', 'e #eta', 1), ('mEta', '#mu #eta', 1), ('ePhi', 'e #phi', 1), ('mPhi', '#mu #phi', 1), ('j1Pt', 'Jet 1 p_{T}', 1), ('j2Pt', 'Jet 2 p_{T}', 1), ('j1Eta', 'Jet 1 #eta', 1), ('j2Eta', 'Jet 2 #eta', 1), ('j1Phi', 'Jet 1 #phi', 1), ('j2Phi', 'Jet 2 #phi', 1), ('type1_pfMetEt', 'MET (GeV)', 1), ('type1_pfMetPhi', 'MET #phi', 1), ('e_m_Mass', 'M_{vis}(e, #mu) (GeV)', 1), ('e_m_CollMass', 'M_{col}(e, #mu) (GeV)', 1), ('e_m_PZeta', 'p_{#zeta}(e, #mu) (GeV)', 1), ('numOfJets', 'Number of Jets', 1), ('vbfMass', 'VBF Mass', 1), ('numOfVtx', 'Number of Vertices', 1), ('dEtaEMu', '#Delta#eta(e, #mu)', 1), ('dPhiEMET', '#Delta#phi(e, MET)', 1), ('dPhiMuMET', '#Delta#phi(#mu, MET)', 1), ('dPhiEMu', '#Delta#phi(e, #mu)', 1), ('MTEMET', 'M_{T}(e, MET) (GeV)', 1), ('MTMuMET', 'M_{T}(#mu, MET) (GeV)', 1)]

bdthisto = [('bdtDiscriminator', 'BDT Discriminator', 1)]

colhisto = [('e_m_CollinearMass', 'M_{col}(e, #mu) (GeV)', 1)]

files = []

lumifiles = []

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

jetc = ['', '0Jet', '1Jet', '2Jet', '2JetVBF', '0JetCut', '1JetCut', '2JetCut', '2JetVBFCut']

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

def normQCD(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [1841.084, 1861.891, 1820.276, 1841.084, 1841.084, 1841.084, 1841.084, 1781.828, 1900.336, 1841.084, 1841.084, 1841.084, 1841.084, 1520.927, 2251.77]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [1124.756, 1124.756, 1124.756, 1148.774, 1100.737, 1124.756, 1124.756, 1124.756, 1124.756, 1133.278, 1116.233, 1124.756, 1124.756, 994.66, 1293.049]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [424.339, 424.339, 424.339, 424.339, 424.339, 435.165, 413.511, 424.339, 424.339, 424.339, 424.339, 424.373, 424.304, 382.762, 479.578]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [43.535, 43.535, 43.535, 43.535, 43.535, 44.584, 42.485, 43.535, 43.535, 43.535, 43.535, 43.387, 43.682, 39.516, 48.661]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [22289.693, 22695.268, 21884.107, 22289.693, 22289.693, 22289.693, 22289.693, 21552.397, 23026.945, 22289.693, 22289.693, 22289.693, 22289.693, 20552.356, 24549.432]
        #integ = [22186.508, 22591.98, 21781.024, 22186.508, 22186.508, 22186.508, 22186.508, 21452.395, 22920.577, 22186.508, 22186.508, 22186.508, 22186.508, 20470.738, 24421.885]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [7931.133, 7931.133, 7931.133, 8081.3, 7780.965, 7931.133, 7931.133, 7931.133, 7931.133, 7940.94, 7921.326, 7931.133, 7931.133, 7184.593, 8898.247]
        #integ = [8001.624, 8001.624, 8001.624, 8152.89, 7850.358, 8001.624, 8001.624, 8001.624, 8001.624, 8010.899, 7992.349, 8001.624, 8001.624, 7262.245, 8961.4]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [2136.911, 2136.911, 2136.911, 2136.911, 2136.911, 2191.16, 2082.66, 2136.911, 2136.911, 2136.911, 2136.911, 2136.412, 2137.54, 1911.575, 2428.207]
        #integ = [2131.888, 2131.888, 2131.888, 2131.888, 2131.888, 2185.899, 2077.874, 2131.888, 2131.888, 2131.888, 2131.888, 2131.216, 2132.656, 1920.804, 2410.496]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [381.08, 381.08, 381.08, 381.08, 381.08, 390.568, 371.592, 381.08, 381.08, 381.08, 381.08, 380.533, 381.636, 361.479, 410.167]
        #integ = [382.261, 382.261, 382.261, 382.261, 382.261, 391.834, 372.688, 382.261, 382.261, 382.261, 382.261, 381.924, 382.674, 362.668, 412.995]
        qcd.Scale(integ[j]/i)
    return qcd
