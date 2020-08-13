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
        integ = [649.212, 657.438, 640.986, 649.212, 649.212, 649.212, 649.212, 629.529, 668.895, 649.212, 649.212, 649.212, 649.212, 548.545, 771.347]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [438.288, 438.288, 438.288, 449.192, 427.385, 438.288, 438.288, 438.288, 438.288, 442.255, 434.322, 438.288, 438.288, 397.985, 490.335]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [169.406, 169.406, 169.406, 169.406, 169.406, 175.295, 163.517, 169.406, 169.406, 169.406, 169.406, 167.398, 171.497, 159.429, 184.955]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [23.035, 23.035, 23.035, 23.035, 23.035, 23.838, 22.233, 23.035, 23.035, 23.035, 23.035, 22.873, 23.197, 22.669, 23.768]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [8645.89, 8812.15, 8479.621, 8645.89, 8645.89, 8645.89, 8645.89, 8374.876, 8916.895, 8645.89, 8645.89, 8645.89, 8645.89, 8140.454, 9286.834]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [3070.228, 3070.228, 3070.228, 3139.928, 3000.528, 3070.228, 3070.228, 3070.228, 3070.228, 3077.173, 3063.982, 3070.228, 3070.228, 2838.47, 3364.103]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [791.154, 791.154, 791.154, 791.154, 791.154, 818.676, 763.632, 791.154, 791.154, 791.154, 791.154, 782.945, 799.363, 742.474, 856.087]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [204.093, 204.093, 204.093, 204.093, 204.093, 211.192, 196.994, 204.093, 204.093, 204.093, 204.093, 201.924, 206.262, 194.9, 217.325]
        qcd.Scale(integ[j]/i)
    return qcd
