import ROOT

dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'WG', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['WG', 'vH_htt', 'TT', 'T', 'Diboson']

sampdy = ['Zothers', 'ZTauTau', 'W', 'WG', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'vH_htt', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsampdy = ['Zothers', 'ZTauTau', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsampdy = ['WG', 'vH_htt', 'TT', 'T', 'Diboson']

qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_0JetRate_13TeVUp', 'QCD_CMS_0JetRate_13TeVDown', 'QCD_CMS_1JetRate_13TeVUp', 'QCD_CMS_1JetRate_13TeVDown', 'QCD_CMS_2JetRate_13TeVUp', 'QCD_CMS_2JetRate_13TeVDown', 'QCD_CMS_0JetShape_13TeVUp', 'QCD_CMS_0JetShape_13TeVDown', 'QCD_CMS_1JetShape_13TeVUp', 'QCD_CMS_1JetShape_13TeVDown', 'QCD_CMS_2JetShape_13TeVUp', 'QCD_CMS_2JetShape_13TeVDown', 'QCD_CMS_Extrapolation_13TeVUp', 'QCD_CMS_Extrapolation_13TeVDown']

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

jet = ['', '0Jet', '1Jet', '2Jet', '2JetVBF', '0JetCut', '1JetCut', '2JetCut', '2JetVBFCut']

jetc = ['', '0Jet', '1Jet', '2Jet', '2JetVBF']

mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWW*', 'VBFHToWW*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TT*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'MC*', 'data*', 'ZTauTau*', 'Obs*', 'Bac*', 'Embed*'] #'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 

histoname = [("mPt", "#mu p_{T} (GeV)", 1), ("ePt", "e p_{T} (Gev)", 1), ("mEta", "#mu #eta", 1), ("eEta", "e #eta", 1), ("mPhi", "#mu #phi", 1), ("ePhi", "e #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("m_e_Mass", "M_{vis}(#mu, e) (GeV)", 1), ("m_e_CollMass", "M_{col}(#mu, e) (GeV)", 1), ("m_e_PZeta", "p_{#zeta}(#mu, e) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaMuE", "#Delta#eta(#mu, e)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiMuE", "#Delta#phi(#mu, e)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

bdthisto = [("bdtDiscriminator", "BDT Discriminator", 1)]

colhisto = [("m_e_CollinearMass", "M_{col}(#mu, e) (GeV)", 1)]

files = []

lumifiles = []

foldername = ['']

def remove_name_entry(dictionary):
    return dict( [ i for i in dictionary.iteritems() if i[0] != 'name'] )

def positivize(histogram):
    output = histogram.Clone()
    for i in range(output.GetSize()):
        if output.GetArray()[i] < 0:
            output.AddAt(0, i)
    return output

def normQCD(histogram, i, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        qcd.Scale(219.529/i)
    elif category=='1Jet':
        qcd.Scale(190.54/i)
    elif category=='2Jet':
        qcd.Scale(135.133/i)
    elif category=='2JetVBF':
        qcd.Scale(20.236/i)
    return qcd

def normQCDBDT(histogram, i, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        qcd.Scale(2385.42/i)
    elif category=='1Jet':
        qcd.Scale(1559.1/i)
    elif category=='2Jet':
        qcd.Scale(637.657/i)
    elif category=='2JetVBF':
        qcd.Scale(202.737/i)
    return qcd

