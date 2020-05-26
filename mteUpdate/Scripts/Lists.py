dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['vH_htt', 'TT', 'T', 'Diboson']

# QCD
qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_QCD_0JetRate_2018_13TeVUp', 'QCD_CMS_QCD_0JetRate_2018_13TeVDown', 'QCD_CMS_QCD_1JetRate_2018_13TeVUp', 'QCD_CMS_QCD_1JetRate_2018_13TeVDown', 'QCD_CMS_QCD_2JetRate_2018_13TeVUp', 'QCD_CMS_QCD_2JetRate_2018_13TeVDown', 'QCD_CMS_QCD_0JetShape_2018_13TeVUp', 'QCD_CMS_QCD_0JetShape_2018_13TeVDown', 'QCD_CMS_QCD_1JetShape_2018_13TeVUp', 'QCD_CMS_QCD_1JetShape_2018_13TeVDown', 'QCD_CMS_QCD_2JetShape_2018_13TeVUp', 'QCD_CMS_QCD_2JetShape_2018_13TeVDown', 'QCD_CMS_QCD_Extrapolation_13TeVUp', 'QCD_CMS_QCD_Extrapolation_13TeVDown']

# MC
mcSys = ['puUp/', 'puDown/', 'bTagUp/', 'bTagDown/', 'eesUp/', 'eesDown/', 'mes1p2Up/', 'mes1p2Down/', 'mes2p1Up/', 'mes2p1Down/', 'mes2p4Up/', 'mes2p4Down/']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_eff_btag_2018_13TeVUp', '_CMS_eff_btag_2018_13TeVDown', '_CMS_scale_e_13TeVUp', '_CMS_scale_e_13TeVDown', '_CMS_scale_m_etaLt1p2_13TeVUp', '_CMS_scale_m_etaLt1p2_13TeVDown', '_CMS_scale_m_eta1p2to2p1_13TeVUp', '_CMS_scale_m_eta1p2to2p1_13TeVDown', '_CMS_scale_m_eta2p1to2p4_13TeVUp', '_CMS_scale_m_eta2p1to2p4_13TeVDown']

escale = ['eesUp/', 'eesDown/']

escaleNames = ['ZTauTau_CMS_scale_e_emb_13TeVUp', 'ZTauTau_CMS_scale_e_emb_13TeVDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_DYpTreweight_2018_13TeVUp', '_CMS_DYpTreweight_2018_13TeVDown']

# Recoil, JES
recSys = ['recresp0Up/', 'recresp0Down/', 'recreso0Up/', 'recreso0Down/', 'recresp1Up/', 'recresp1Down/', 'recreso1Up/', 'recreso1Down/', 'recresp2Up/', 'recresp2Down/', 'recreso2Up/', 'recreso2Down/']

recSysNames = ['_CMS_scale_met_0Jet_2018_13TeVUp', '_CMS_scale_met_0Jet_2018_13TeVDown', '_CMS_reso_met_0Jet_2018_13TeVUp', '_CMS_reso_met_0Jet_2018_13TeVDown', '_CMS_scale_met_1Jet_2018_13TeVUp', '_CMS_scale_met_1Jet_2018_13TeVDown', '_CMS_reso_met_1Jet_2018_13TeVUp', '_CMS_reso_met_1Jet_2018_13TeVDown', '_CMS_scale_met_2Jet_2018_13TeVUp', '_CMS_scale_met_2Jet_2018_13TeVDown', '_CMS_reso_met_2Jet_2018_13TeVUp', '_CMS_reso_met_2Jet_2018_13TeVDown']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsolute_13TeVUp', '_CMS_Jes_JetAbsolute_13TeVDown', '_CMS_Jes_JetAbsolute_2018_13TeVUp', '_CMS_Jes_JetAbsolute_2018_13TeVDown', '_CMS_Jes_JetBBEC1_13TeVUp', '_CMS_Jes_JetBBEC1_13TeVDown', '_CMS_Jes_JetBBEC1_2018_13TeVUp', '_CMS_Jes_JetBBEC1_2018_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetEC2_13TeVUp', '_CMS_Jes_JetEC2_13TeVDown', '_CMS_Jes_JetEC2_2018_13TeVUp', '_CMS_Jes_JetEC2_2018_13TeVDown', '_CMS_Jes_JetHF_13TeVUp', '_CMS_Jes_JetHF_13TeVDown', '_CMS_Jes_JetHF_2018_13TeVUp', '_CMS_Jes_JetHF_2018_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown', '_CMS_Jer_2018_13TeVUp', '_CMS_Jer_2018_13TeVDown']

# Samples
mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*', 'Obs*', 'Bac*']

histoname = [("mPt", "#mu p_{T} (GeV)", 1), ("ePt", "e p_{T} (Gev)", 1), ("mEta", "#mu #eta", 1), ("eEta", "e #eta", 1), ("mPhi", "#mu #phi", 1), ("ePhi", "e #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("m_e_Mass", "M_{vis}(#mu, e) (GeV)", 1), ("m_e_CollMass", "M_{col}(#mu, e) (GeV)", 1), ("m_e_PZeta", "p_{#zeta}(#mu, e) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaMuE", "#Delta#eta(#mu, e)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiMuE", "#Delta#phi(#mu, e)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

bdthisto = [("bdtDiscriminator", "BDT Discriminator", 1)]

colhisto = [("m_e_CollinearMass", "M_{col}(#mu, e) (GeV)", 1)]

files = []

lumifiles = []

foldername = ['']

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
        integ = [587.661, 629.652, 545.669, 587.661, 587.661, 587.661, 587.661, 629.564, 545.758, 587.661, 587.661, 587.661, 587.661, 516.203, 675.91]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [582.413, 582.413, 582.413, 601.266, 563.56, 582.413, 582.413, 582.413, 582.413, 600.227, 564.598, 582.413, 582.413, 497.739, 686.24]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [244.625, 244.625, 244.625, 244.625, 244.625, 256.051, 233.2, 244.625, 244.625, 244.625, 244.625, 251.318, 237.933, 213.294, 282.385]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [54.295, 54.295, 54.295, 54.295, 54.295, 56.742, 51.848, 54.295, 54.295, 54.295, 54.295, 55.582, 53.008, 47.48, 62.457]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [15037.386, 16104.139, 13970.634, 15037.386, 15037.386, 15037.386, 15037.386, 16028.449, 14046.324, 15037.386, 15037.386, 15037.386, 15037.386, 13228.569, 17170.016]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [6953.048, 6953.048, 6953.048, 7167.876, 6738.219, 6953.048, 6953.048, 6953.048, 6953.048, 7132.301, 6773.794, 6953.048, 6953.048, 6051.082, 8038.547]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [2194.727, 2194.727, 2194.727, 2194.727, 2194.727, 2299.512, 2089.942, 2194.727, 2194.727, 2194.727, 2194.727, 2259.867, 2129.587, 1931.79, 2507.897]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [437.862, 437.862, 437.862, 437.862, 437.862, 458.606, 417.118, 437.862, 437.862, 437.862, 437.862, 450.497, 425.227, 385.047, 500.509]
        qcd.Scale(integ[j]/i)
    return qcd
