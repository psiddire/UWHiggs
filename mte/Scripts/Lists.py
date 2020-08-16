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
        integ = [532.346, 537.966, 526.725, 532.346, 532.346, 532.346, 532.346, 515.263, 549.427, 532.346, 532.346, 532.346, 532.346, 594.513, 477.683]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [394.903, 394.903, 394.903, 403.208, 386.601, 394.903, 394.903, 394.903, 394.903, 397.58, 392.254, 394.903, 394.903, 448.771, 349.777]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [235.324, 235.324, 235.324, 235.324, 235.324, 241.095, 229.552, 235.324, 235.324, 235.324, 235.324, 234.77, 235.877, 261.999, 212.789]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [31.296, 31.296, 31.296, 31.296, 31.296, 32.025, 30.567, 31.296, 31.296, 31.296, 31.296, 31.128, 31.464, 34.697, 28.536]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [12009.468, 12222.488, 11796.441, 12009.468, 12009.468, 12009.468, 12009.468, 11612.932, 12405.98, 12009.468, 12009.468, 12009.468, 12009.468, 13833.576, 10489.037]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [4782.842, 4782.842, 4782.842, 4873.159, 4692.526, 4782.842, 4782.842, 4782.842, 4782.842, 4788.125, 4777.56, 4782.842, 4782.842, 5525.862, 4159.876]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [1493.242, 1493.242, 1493.242, 1493.242, 1493.242, 1529.071, 1457.534, 1493.242, 1493.242, 1493.242, 1493.242, 1487.855, 1499.066, 1675.073, 1346.485]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [246.505, 246.505, 246.505, 246.505, 246.505, 252.64, 240.371, 246.505, 246.505, 246.505, 246.505, 246.144, 246.867, 264.85, 230.697]
        qcd.Scale(integ[j]/i)
    return qcd

def normHist(h00, h10, h20, h01, h11, h21, b):
    h3 = h11.Clone()
    nom3 = h3.Integral()
    h4 = h21.Clone()
    nom4 = h4.Integral()
    for i in range(1, h01.GetNbinsX()+1):
        e = 0.0
        for j in range(h00.GetXaxis().FindBin(b[i-1]), h00.GetXaxis().FindBin(b[i]-0.01)):
            e = e + pow(h10.GetBinContent(j) - h00.GetBinContent(j), 2) + pow(h20.GetBinContent(j) - h00.GetBinContent(j), 2)
        w = 2 * (h00.GetXaxis().FindBin(b[i]) - h00.GetXaxis().FindBin(b[i-1]))
        err = math.sqrt(e/w)
        if h11.GetBinContent(i) - h01.GetBinContent(i) > 0:
            h3.SetBinContent(i, h01.GetBinContent(i) + err)
            h4.SetBinContent(i, h01.GetBinContent(i) - err)
        else:
            h3.SetBinContent(i, h01.GetBinContent(i) - err)
            h4.SetBinContent(i, h01.GetBinContent(i) + err)
    h3.Scale(1.0000001/h3.Integral())
    h3.Scale(nom3)
    h4.Scale(0.9999999/h4.Integral())
    h4.Scale(nom4)
    return [h3, h4]
