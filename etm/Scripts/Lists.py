dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

#samp = ['Zothers', 'W', 'WG', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']
samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

#norecsamp = ['WG', 'vH_htt', 'TT', 'T', 'Diboson']
norecsamp = ['vH_htt', 'TT', 'T', 'Diboson']

qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_QCD_0JetRate_13TeVUp', 'QCD_CMS_QCD_0JetRate_13TeVDown', 'QCD_CMS_QCD_1JetRate_13TeVUp', 'QCD_CMS_QCD_1JetRate_13TeVDown', 'QCD_CMS_QCD_2JetRate_13TeVUp', 'QCD_CMS_QCD_2JetRate_13TeVDown', 'QCD_CMS_QCD_0JetShape_13TeVUp', 'QCD_CMS_QCD_0JetShape_13TeVDown', 'QCD_CMS_QCD_1JetShape_13TeVUp', 'QCD_CMS_QCD_1JetShape_13TeVDown', 'QCD_CMS_QCD_2JetShape_13TeVUp', 'QCD_CMS_QCD_2JetShape_13TeVDown', 'QCD_CMS_QCD_Extrapolation_13TeVUp', 'QCD_CMS_QCD_Extrapolation_13TeVDown']

escale = ['eescUp/', 'eescDown/']

escaleNames = [['ZTauTau_CMS_EES_13TeVUp', 'ZTauTau_CMS_EES_emb_13TeVUp'], ['ZTauTau_CMS_EES_13TeVDown', 'ZTauTau_CMS_EES_emb_13TeVDown']]

mcSys = ['puUp/', 'puDown/', 'pfUp/', 'pfDown/', 'bTagUp/', 'bTagDown/', 'eescUp/', 'eescDown/', 'mesUp/', 'mesDown/']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_Prefiring_13TeVUp', '_CMS_Prefiring_13TeVDown', '_CMS_eff_btag_13TeVUp', '_CMS_eff_btag_13TeVDown', '_CMS_EES_13TeVUp', '_CMS_EES_13TeVDown', '_CMS_MES_13TeVUp', '_CMS_MES_13TeVDown']

recSys = ['recrespUp/', 'recrespDown/', 'recresoUp/', 'recresoDown/']

recSysNames = ['_CMS_RecoilResponse_13TeVUp', '_CMS_RecoilResponse_13TeVDown', '_CMS_RecoilResolution_13TeVUp', '_CMS_RecoilResolution_13TeVDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_DYpTreweight_13TeVUp', '_CMS_DYpTreweight_13TeVDown']

ttSys = ['TopptreweightUp/', 'TopptreweightDown/']

ttSysNames = ['_CMS_TTpTreweight_13TeVUp', '_CMS_TTpTreweight_13TeVDown']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteFlavMapUp/', 'JetAbsoluteFlavMapDown/', 'JetAbsoluteMPFBiasUp/', 'JetAbsoluteMPFBiasDown/', 'JetAbsoluteScaleUp/', 'JetAbsoluteScaleDown/', 'JetAbsoluteStatUp/', 'JetAbsoluteStatDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetFragmentationUp/', 'JetFragmentationDown/', 'JetPileUpDataMCUp/', 'JetPileUpDataMCDown/', 'JetPileUpPtBBUp/', 'JetPileUpPtBBDown/', 'JetPileUpPtEC1Up/', 'JetPileUpPtEC1Down/', 'JetPileUpPtEC2Up/', 'JetPileUpPtEC2Down/', 'JetPileUpPtHFUp/', 'JetPileUpPtHFDown/', 'JetPileUpPtRefUp/', 'JetPileUpPtRefDown/', 'JetRelativeFSRUp/', 'JetRelativeFSRDown/', 'JetRelativeJEREC1Up/', 'JetRelativeJEREC1Down/', 'JetRelativeJEREC2Up/', 'JetRelativeJEREC2Down/', 'JetRelativeJERHFUp/', 'JetRelativeJERHFDown/', 'JetRelativePtBBUp/', 'JetRelativePtBBDown/', 'JetRelativePtEC1Up/', 'JetRelativePtEC1Down/', 'JetRelativePtEC2Up/', 'JetRelativePtEC2Down/', 'JetRelativePtHFUp/', 'JetRelativePtHFDown/', 'JetRelativeStatECUp/', 'JetRelativeStatECDown/', 'JetRelativeStatFSRUp/', 'JetRelativeStatFSRDown/', 'JetRelativeStatHFUp/', 'JetRelativeStatHFDown/', 'JetSinglePionECALUp/', 'JetSinglePionECALDown/', 'JetSinglePionHCALUp/', 'JetSinglePionHCALDown/', 'JetTimePtEtaUp/', 'JetTimePtEtaDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsoluteFlavMap_13TeVUp', '_CMS_Jes_JetAbsoluteFlavMap_13TeVDown', '_CMS_Jes_JetAbsoluteMPFBias_13TeVUp', '_CMS_Jes_JetAbsoluteMPFBias_13TeVDown', '_CMS_Jes_JetAbsoluteScale_13TeVUp', '_CMS_Jes_JetAbsoluteScale_13TeVDown', '_CMS_Jes_JetAbsoluteStat_13TeVUp', '_CMS_Jes_JetAbsoluteStat_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetFragmentation_13TeVUp', '_CMS_Jes_JetFragmentation_13TeVDown', '_CMS_Jes_JetPileUpDataMC_13TeVUp', '_CMS_Jes_JetPileUpDataMC_13TeVDown', '_CMS_Jes_JetPileUpPtBB_13TeVUp', '_CMS_Jes_JetPileUpPtBB_13TeVDown', '_CMS_Jes_JetPileUpPtEC1_13TeVUp', '_CMS_Jes_JetPileUpPtEC1_13TeVDown', '_CMS_Jes_JetPileUpPtEC2_13TeVUp', '_CMS_Jes_JetPileUpPtEC2_13TeVDown', '_CMS_Jes_JetPileUpPtHF_13TeVUp', '_CMS_Jes_JetPileUpPtHF_13TeVDown', '_CMS_Jes_JetPileUpPtRef_13TeVUp', '_CMS_Jes_JetPileUpPtRef_13TeVDown', '_CMS_Jes_JetRelativeFSR_13TeVUp', '_CMS_Jes_JetRelativeFSR_13TeVDown', '_CMS_Jes_JetRelativeJEREC1_13TeVUp', '_CMS_Jes_JetRelativeJEREC1_13TeVDown', '_CMS_Jes_JetRelativeJEREC2_13TeVUp', '_CMS_Jes_JetRelativeJEREC2_13TeVDown', '_CMS_Jes_JetRelativeJERHF_13TeVUp', '_CMS_Jes_JetRelativeJERHF_13TeVDown', '_CMS_Jes_JetRelativePtBB_13TeVUp', '_CMS_Jes_JetRelativePtBB_13TeVDown', '_CMS_Jes_JetRelativePtEC1_13TeVUp', '_CMS_Jes_JetRelativePtEC1_13TeVDown', '_CMS_Jes_JetRelativePtEC2_13TeVUp', '_CMS_Jes_JetRelativePtEC2_13TeVDown', '_CMS_Jes_JetRelativePtHF_13TeVUp', '_CMS_Jes_JetRelativePtHF_13TeVDown', '_CMS_Jes_JetRelativeStatEC_13TeVUp', '_CMS_Jes_JetRelativeStatEC_13TeVDown', '_CMS_Jes_JetRelativeStatFSR_13TeVUp', '_CMS_Jes_JetRelativeStatFSR_13TeVDown', '_CMS_Jes_JetRelativeStatHF_13TeVUp', '_CMS_Jes_JetRelativeStatHF_13TeVDown', '_CMS_Jes_JetSinglePionECAL_13TeVUp', '_CMS_Jes_JetSinglePionECAL_13TeVDown', '_CMS_Jes_JetSinglePionHCAL_13TeVUp', '_CMS_Jes_JetSinglePionHCAL_13TeVDown', '_CMS_Jes_JetTimePtEta_13TeVUp', '_CMS_Jes_JetTimePtEta_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown']

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TT*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*', 'Obs*', 'Bac*']

histoname = [("ePt", "e p_{T} (Gev)", 1), ("mPt", "#mu p_{T} (GeV)", 1), ("eEta", "e #eta", 1), ("mEta", "#mu #eta", 1), ("ePhi", "e #phi", 1), ("mPhi", "#mu #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("e_m_Mass", "M_{vis}(e, #mu) (GeV)", 1), ("e_m_CollMass", "M_{col}(e, #mu) (GeV)", 1), ("e_m_PZeta", "p_{#zeta}(e, #mu) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaEMu", "#Delta#eta(e, #mu)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiEMu", "#Delta#phi(e, #mu)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

bdthisto = [("bdtDiscriminator", "BDT Discriminator", 1)]

colhisto = [("e_m_CollinearMass", "M_{col}(e, #mu) (GeV)", 1)]

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
        integ = [1541.072, 1566.148, 1516.024, 1541.072, 1541.072, 1541.072, 1541.072, 1493.484, 1588.659, 1541.072, 1541.072, 1541.072, 1541.072, 1393.232, 1723.95]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [351.496, 351.496, 351.496, 360.469, 342.523, 351.496, 351.496, 351.496, 351.496, 355.413, 347.578, 351.496, 351.496, 319.098, 391.503]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [238.276, 238.276, 238.276, 238.276, 238.276, 246.591, 229.962, 238.276, 238.276, 238.276, 238.276, 237.306, 239.247, 221.447, 259.536]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [36.212, 36.212, 36.212, 36.212, 36.212, 37.473, 34.951, 36.212, 36.212, 36.212, 36.212, 35.906, 36.518, 33.328, 39.634]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [7140.737, 7228.472, 7054.349, 7140.737, 7140.737, 7140.737, 7140.737, 6924.874, 7356.592, 7140.737, 7140.737, 7140.737, 7140.737, 6749.99, 7637.842]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [3334.392, 3334.392, 3334.392, 3410.217, 3258.568, 3334.392, 3334.392, 3334.392, 3334.392, 3341.585, 3327.199, 3334.392, 3334.392, 3104.4, 3622.693]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [955.093, 955.093, 955.093, 955.093, 955.093, 988.373, 921.812, 955.093, 955.093, 955.093, 955.093, 948.582, 961.764, 888.328, 1040.437]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [231.951, 231.951, 231.951, 231.951, 231.951, 240.036, 223.865, 231.951, 231.951, 231.951, 231.951, 230.519, 233.382, 221.822, 247.032]
        qcd.Scale(integ[j]/i)
    return qcd
