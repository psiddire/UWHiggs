dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['TT', 'T', 'Diboson']

# QCD
qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_qcd_0jet_rate_2016Up', 'QCD_CMS_qcd_0jet_rate_2016Down', 'QCD_CMS_qcd_1jet_rate_2016Up', 'QCD_CMS_qcd_1jet_rate_2016Down', 'QCD_CMS_qcd_2jet_rate_2016Up', 'QCD_CMS_qcd_2jet_rate_2016Down', 'QCD_CMS_qcd_0jet_shape_2016Up', 'QCD_CMS_qcd_0jet_shape_2016Down', 'QCD_CMS_qcd_1jet_shape_2016Up', 'QCD_CMS_qcd_1jet_shape_2016Down', 'QCD_CMS_qcd_2jet_shape_2016Up', 'QCD_CMS_qcd_2jet_shape_2016Down', 'QCD_CMS_qcd_extrapolationUp', 'QCD_CMS_qcd_extrapolationDown']

# MC
mcSys = ['puUp/', 'puDown/', 'pfUp/', 'pfDown/', 'bTagUp/', 'bTagDown/', 'eesUp/', 'eesDown/', 'mes1p2Up/', 'mes1p2Down/', 'mes2p1Up/', 'mes2p1Down/', 'mes2p4Up/', 'mes2p4Down/']

mcSysNames = ['_CMS_pileupUp', '_CMS_pileupDown', '_CMS_prefiringUp', '_CMS_prefiringDown', '_CMS_eff_b_2016Up', '_CMS_eff_b_2016Down', '_CMS_scale_eUp', '_CMS_scale_eDown', '_CMS_scale_m_etaLt1p2Up', '_CMS_scale_m_etaLt1p2Down', '_CMS_scale_m_eta1p2to2p1Up', '_CMS_scale_m_eta1p2to2p1Down', '_CMS_scale_m_eta2p1to2p4Up', '_CMS_scale_m_eta2p1to2p4Down']

escale = ['eesUp/', 'eesDown/']

escaleNames = ['ZTauTau_CMS_scale_e_embUp', 'ZTauTau_CMS_scale_e_embDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_dyShape_2016Up', '_CMS_dyShape_2016Down']

# Recoil, JES
recSys = ['recresp0Up/', 'recresp0Down/', 'recreso0Up/', 'recreso0Down/', 'recresp1Up/', 'recresp1Down/', 'recreso1Up/', 'recreso1Down/', 'recresp2Up/', 'recresp2Down/', 'recreso2Up/', 'recreso2Down/']

recSysNames = ['_CMS_scale_met_0Jet_2016Up', '_CMS_scale_met_0Jet_2016Down', '_CMS_res_met_0Jet_2016Up', '_CMS_res_met_0Jet_2016Down', '_CMS_scale_met_1Jet_2016Up', '_CMS_scale_met_1Jet_2016Down', '_CMS_res_met_1Jet_2016Up', '_CMS_res_met_1Jet_2016Down', '_CMS_scale_met_2Jet_2016Up', '_CMS_scale_met_2Jet_2016Down', '_CMS_res_met_2Jet_2016Up', '_CMS_res_met_2Jet_2016Down']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_UesUp', '_CMS_MET_UesDown', '_CMS_scale_met_chargedUp', '_CMS_scale_met_chargedDown', '_CMS_scale_met_ecalUp', '_CMS_scale_met_ecalDown', '_CMS_scale_met_hcalUp', '_CMS_scale_met_hcalDown', '_CMS_scale_met_hfUp', '_CMS_scale_met_hfDown', '_CMS_scale_j_AbsoluteUp', '_CMS_scale_j_AbsoluteDown', '_CMS_scale_j_Absolute_2016Up', '_CMS_scale_j_Absolute_2016Down', '_CMS_scale_j_BBEC1Up', '_CMS_scale_j_BBEC1Down', '_CMS_scale_j_BBEC1_2016Up', '_CMS_scale_j_BBEC1_2016Down', '_CMS_scale_j_FlavorQCDUp', '_CMS_scale_j_FlavorQCDDown', '_CMS_scale_j_EC2Up', '_CMS_scale_j_EC2Down', '_CMS_scale_j_EC2_2016Up', '_CMS_scale_j_EC2_2016Down', '_CMS_scale_j_HFUp', '_CMS_scale_j_HFDown', '_CMS_scale_j_HF_2016Up', '_CMS_scale_j_HF_2016Down', '_CMS_scale_j_RelativeBalUp', '_CMS_scale_j_RelativeBalDown', '_CMS_scale_j_RelativeSample_2016Up', '_CMS_scale_j_RelativeSample_2016Down', '_CMS_res_j_2016Up', '_CMS_res_j_2016Down']

# Samples
mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*', 'Obs*', 'Bac*']

histoname = [('mPt', '#mu p_{T} (GeV)', 1), ('ePt', 'e p_{T} (Gev)', 1), ('mEta', '#mu #eta', 1), ('eEta', 'e #eta', 1), ('mPhi', '#mu #phi', 1), ('ePhi', 'e #phi', 1), ('j1Pt', 'Jet 1 p_{T}', 1), ('j2Pt', 'Jet 2 p_{T}', 1), ('j1Eta', 'Jet 1 #eta', 1), ('j2Eta', 'Jet 2 #eta', 1), ('j1Phi', 'Jet 1 #phi', 1), ('j2Phi', 'Jet 2 #phi', 1), ('type1_pfMetEt', 'MET (GeV)', 1), ('type1_pfMetPhi', 'MET #phi', 1), ('m_e_Mass', 'M_{vis}(#mu, e) (GeV)', 1), ('m_e_CollMass', 'M_{col}(#mu, e) (GeV)', 1), ('m_e_PZeta', 'p_{#zeta}(#mu, e) (GeV)', 1), ('numOfJets', 'Number of Jets', 1), ('vbfMass', 'VBF Mass', 1), ('numOfVtx', 'Number of Vertices', 1), ('dEtaMuE', '#Delta#eta(#mu, e)', 1), ('dPhiEMET', '#Delta#phi(e, MET)', 1), ('dPhiMuMET', '#Delta#phi(#mu, MET)', 1), ('dPhiMuE', '#Delta#phi(#mu, e)', 1), ('MTEMET', 'M_{T}(e, MET) (GeV)', 1), ('MTMuMET', 'M_{T}(#mu, MET) (GeV)', 1)]

bdthisto = [('bdtDiscriminator', 'BDT Discriminator', 1)]

colhisto = [('m_e_CollinearMass', 'M_{col}(#mu, e) (GeV)', 1)]

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
        integ = [191.995, 193.268, 190.721, 191.995, 191.995, 191.995, 191.995, 186.355, 197.634, 191.995, 191.995, 191.995, 191.995, 224.701, 164.875]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [146.573, 146.573, 146.573, 150.222, 142.925, 146.573, 146.573, 146.573, 146.573, 147.906, 145.24, 146.573, 146.573, 160.65, 135.181]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [103.693, 103.693, 103.693, 103.693, 103.693, 107.288, 100.099, 103.693, 103.693, 103.693, 103.693, 101.884, 105.521, 111.093, 98.203]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [14.627, 14.627, 14.627, 14.627, 14.627, 15.132, 14.123, 14.627, 14.627, 14.627, 14.627, 14.23, 15.024, 14.948, 14.657]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [3730.929, 3780.253, 3682.158, 3730.929, 3730.929, 3730.929, 3730.929, 3617.488, 3844.366, 3730.929, 3730.929, 3730.929, 3730.929, 4242.424, 3299.277]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [1133.177, 1133.177, 1133.177, 1160.261, 1106.16, 1133.177, 1133.177, 1133.177, 1133.177, 1139.863, 1126.789, 1133.177, 1133.177, 1294.76, 999.052]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [481.572, 481.572, 481.572, 481.572, 481.572, 498.311, 464.834, 481.572, 481.572, 481.572, 481.572, 475.752, 487.677, 538.925, 436.42]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [153.074, 153.074, 153.074, 153.074, 153.074, 158.403, 147.745, 153.074, 153.074, 153.074, 153.074, 151.717, 154.444, 157.538, 151.207]
        qcd.Scale(integ[j]/i)
    return qcd

