dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['TT', 'T', 'Diboson']

# QCD
qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_QCD_0JetRate_2016_13TeVUp', 'QCD_CMS_QCD_0JetRate_2016_13TeVDown', 'QCD_CMS_QCD_1JetRate_2016_13TeVUp', 'QCD_CMS_QCD_1JetRate_2016_13TeVDown', 'QCD_CMS_QCD_2JetRate_2016_13TeVUp', 'QCD_CMS_QCD_2JetRate_2016_13TeVDown', 'QCD_CMS_QCD_0JetShape_2016_13TeVUp', 'QCD_CMS_QCD_0JetShape_2016_13TeVDown', 'QCD_CMS_QCD_1JetShape_2016_13TeVUp', 'QCD_CMS_QCD_1JetShape_2016_13TeVDown', 'QCD_CMS_QCD_2JetShape_2016_13TeVUp', 'QCD_CMS_QCD_2JetShape_2016_13TeVDown', 'QCD_CMS_QCD_Extrapolation_13TeVUp', 'QCD_CMS_QCD_Extrapolation_13TeVDown']

# MC
mcSys = ['puUp/', 'puDown/', 'pfUp/', 'pfDown/', 'bTagUp/', 'bTagDown/', 'eesUp/', 'eesDown/', 'mes1p2Up/', 'mes1p2Down/', 'mes2p1Up/', 'mes2p1Down/', 'mes2p4Up/', 'mes2p4Down/']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_Prefiring_13TeVUp', '_CMS_Prefiring_13TeVDown', '_CMS_eff_btag_2016_13TeVUp', '_CMS_eff_btag_2016_13TeVDown', '_CMS_scale_e_13TeVUp', '_CMS_scale_e_13TeVDown', '_CMS_scale_m_etaLt1p2_13TeVUp', '_CMS_scale_m_etaLt1p2_13TeVDown', '_CMS_scale_m_eta1p2to2p1_13TeVUp', '_CMS_scale_m_eta1p2to2p1_13TeVDown', '_CMS_scale_m_eta2p1to2p4_13TeVUp', '_CMS_scale_m_eta2p1to2p4_13TeVDown']

escale = ['eesUp/', 'eesDown/']

escaleNames = ['ZTauTau_CMS_scale_e_emb_13TeVUp', 'ZTauTau_CMS_scale_e_emb_13TeVDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_DYpTreweight_2016_13TeVUp', '_CMS_DYpTreweight_2016_13TeVDown']

# Recoil, JES
recSys = ['recresp0Up/', 'recresp0Down/', 'recreso0Up/', 'recreso0Down/', 'recresp1Up/', 'recresp1Down/', 'recreso1Up/', 'recreso1Down/', 'recresp2Up/', 'recresp2Down/', 'recreso2Up/', 'recreso2Down/']

recSysNames = ['_CMS_scale_met_0Jet_2016_13TeVUp', '_CMS_scale_met_0Jet_2016_13TeVDown', '_CMS_reso_met_0Jet_2016_13TeVUp', '_CMS_reso_met_0Jet_2016_13TeVDown', '_CMS_scale_met_1Jet_2016_13TeVUp', '_CMS_scale_met_1Jet_2016_13TeVDown', '_CMS_reso_met_1Jet_2016_13TeVUp', '_CMS_reso_met_1Jet_2016_13TeVDown', '_CMS_scale_met_2Jet_2016_13TeVUp', '_CMS_scale_met_2Jet_2016_13TeVDown', '_CMS_reso_met_2Jet_2016_13TeVUp', '_CMS_reso_met_2Jet_2016_13TeVDown']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsolute_13TeVUp', '_CMS_Jes_JetAbsolute_13TeVDown', '_CMS_Jes_JetAbsolute_2016_13TeVUp', '_CMS_Jes_JetAbsolute_2016_13TeVDown', '_CMS_Jes_JetBBEC1_13TeVUp', '_CMS_Jes_JetBBEC1_13TeVDown', '_CMS_Jes_JetBBEC1_2016_13TeVUp', '_CMS_Jes_JetBBEC1_2016_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetEC2_13TeVUp', '_CMS_Jes_JetEC2_13TeVDown', '_CMS_Jes_JetEC2_2016_13TeVUp', '_CMS_Jes_JetEC2_2016_13TeVDown', '_CMS_Jes_JetHF_13TeVUp', '_CMS_Jes_JetHF_13TeVDown', '_CMS_Jes_JetHF_2016_13TeVUp', '_CMS_Jes_JetHF_2016_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown', '_CMS_Jer_2016_13TeVUp', '_CMS_Jer_2016_13TeVDown']

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
        integ = [189.666, 190.706, 188.625, 189.666, 189.666, 189.666, 189.666, 184.128, 195.203, 189.666, 189.666, 189.666, 189.666, 219.437, 165.519]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [178.635, 178.635, 178.635, 183.09, 174.181, 178.635, 178.635, 178.635, 178.635, 180.286, 176.985, 178.635, 178.635, 196.025, 164.436]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [138.471, 138.471, 138.471, 138.471, 138.471, 143.265, 133.678, 138.471, 138.471, 138.471, 138.471, 135.645, 141.298, 151.05, 128.581]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [18.355, 18.355, 18.355, 18.355, 18.355, 18.987, 17.724, 18.355, 18.355, 18.355, 18.355, 17.765, 18.946, 19.724, 17.642]
        qcd.Scale(integ[j]/i)
    return qcd

# def normQCD(histogram, i, j, category):
#     qcd = histogram.Clone()
#     if category=='0Jet':
#         integ = [227.095, 228.807, 225.395, 227.095, 227.095, 227.095, 227.095, 220.392, 233.797, 227.095, 227.095, 227.095, 227.095, 260.901, 200.056]
#         qcd.Scale(integ[j]/i)
#     elif category=='1Jet':
#         integ = [192.645, 192.645, 192.645, 197.351, 187.94, 192.645, 192.645, 192.645, 192.645, 194.107, 191.184, 192.645, 192.645, 213.687, 175.89]
#         qcd.Scale(integ[j]/i)
#     elif category=='2Jet':
#         integ = [149.907, 149.907, 149.907, 149.907, 149.907, 155.097, 144.718, 149.907, 149.907, 149.907, 149.907, 146.886, 152.929, 162.774, 140.729]
#         qcd.Scale(integ[j]/i)
#     elif category=='2JetVBF':
#         integ = [18.355, 18.355, 18.355, 18.355, 18.355, 18.986, 17.723, 18.355, 18.355, 18.355, 18.355, 17.764, 18.945, 19.723, 17.641]
#         qcd.Scale(integ[j]/i)
#     return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [2044.953, 2058.236, 2032.199, 2044.953, 2044.953, 2044.953, 2044.953, 1984.926, 2104.976, 2044.953, 2044.953, 2044.953, 2044.953, 2343.969, 1809.611]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [1307.99, 1307.99, 1307.99, 1339.045, 1276.936, 1307.99, 1307.99, 1307.99, 1307.99, 1315.038, 1300.974, 1307.99, 1307.99, 1489.746, 1157.727]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [557.881, 557.881, 557.881, 557.881, 557.881, 577.308, 538.454, 557.881, 557.881, 557.881, 557.881, 553.264, 562.497, 632.091, 497.828]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [184.028, 184.028, 184.028, 184.028, 184.028, 190.429, 177.626, 184.028, 184.028, 184.028, 184.028, 182.126, 185.935, 190.328, 180.068]
        qcd.Scale(integ[j]/i)
    return qcd

# def normQCDBDT(histogram, i, j, category):
#     qcd = histogram.Clone()
#     if category=='0Jet':
#         integ = [2892.862, 2914.323, 2871.398, 2892.862, 2892.862, 2892.862, 2892.862, 2807.529, 2978.192, 2892.862, 2892.862, 2892.862, 2892.862, 3275.389, 2578.088]
#         qcd.Scale(integ[j]/i)
#     elif category=='1Jet':
#         integ = [1771.48, 1771.48, 1771.48, 1812.979, 1729.981, 1771.48, 1771.48, 1771.48, 1771.48, 1779.219, 1763.74, 1771.48, 1771.48, 1994.527, 1585.442]
#         qcd.Scale(integ[j]/i)
#     elif category=='2Jet':
#         integ = [737.419, 737.419, 737.419, 737.419, 737.419, 763.104, 711.734, 737.419, 737.419, 737.419, 737.419, 731.677, 743.161, 806.501, 682.808]
#         qcd.Scale(integ[j]/i)
#     elif category=='2JetVBF':
#         integ = [192.541, 192.541, 192.541, 192.541, 192.541, 199.238, 185.843, 192.541, 192.541, 192.541, 192.541, 190.514, 194.568, 198.125, 189.46]
#         qcd.Scale(integ[j]/i)
#     return qcd

# d = f.mkdir(Lists.drs[k])
# d.cd()
# if di=='0Jet':
#     binning = array.array('d', [-0.5, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.2])
# elif di=='1Jet':
#     binning = array.array('d', [-0.5, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.2])
# elif di=='2Jet':
#     binning = array.array('d', [-0.55, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.25])
# else:
#     binning = array.array('d', [-0.5, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2])
