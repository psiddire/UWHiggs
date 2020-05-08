dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['TT', 'T', 'Diboson']

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

histoname = [("ePt", "e p_{T} (Gev)", 1), ("mPt", "#mu p_{T} (GeV)", 1), ("eEta", "e #eta", 1), ("mEta", "#mu #eta", 1), ("ePhi", "e #phi", 1), ("mPhi", "#mu #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("e_m_Mass", "M_{vis}(e, #mu) (GeV)", 1), ("e_m_CollMass", "M_{col}(e, #mu) (GeV)", 1), ("e_m_PZeta", "p_{#zeta}(e, #mu) (GeV)", 1), ("e_m_PZetaVis", "p_{#zeta}^{vis}(e, #mu) (GeV)", 1), ("e_m_PZetaSub", "p_{#zeta}^{sub}(e, #mu) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaEMu", "#Delta#eta(e, #mu)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiEMu", "#Delta#phi(e, #mu)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

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
        integ = [2403.257, 2574.637, 2231.877, 2403.257, 2403.257, 2403.257, 2403.257, 2570.992, 2235.521, 2403.257, 2403.257, 2403.257, 2403.257, 2322.993, 2493.94]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [1913.364, 1913.364, 1913.364, 1975.715, 1851.012, 1913.364, 1913.364, 1913.364, 1913.364, 1973.24, 1853.487, 1913.364, 1913.364, 1827.737, 2008.89]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [573.641, 573.641, 573.641, 573.641, 573.641, 601.446, 545.836, 573.641, 573.641, 573.641, 573.641, 591.6, 555.682, 544.179, 606.88]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [56.189, 56.189, 56.189, 56.189, 56.189, 58.912, 53.467, 56.189, 56.189, 56.189, 56.189, 57.945, 54.434, 52.042, 60.914]
        qcd.Scale(integ[j]/i)
    return qcd

# def normQCD(histogram, i, j, category):
#     qcd = histogram.Clone()
#     if category=='0Jet':
#         integ = [6104.596, 6539.11, 5670.081, 6104.596, 6104.596, 6104.596, 6104.596, 6522.146, 5687.044, 6104.596, 6104.596, 6104.596, 6104.596, 5819.735, 6419.592]
#         qcd.Scale(integ[j]/i)
#     elif category=='1Jet':
#         integ = [1923.468, 1923.468, 1923.468, 1986.131, 1860.806, 1923.468, 1923.468, 1923.468, 1923.468, 1983.603, 1863.334, 1923.468, 1923.468, 1831.11, 2026.908]
#         qcd.Scale(integ[j]/i)
#     elif category=='2Jet':
#         integ = [540.994, 540.994, 540.994, 540.994, 540.994, 568.774, 513.23, 540.994, 540.994, 540.994, 540.994, 561.485, 520.606, 510.686, 576.083]
#         qcd.Scale(integ[j]/i)
#     elif category=='2JetVBF':
#         integ = [78.654, 78.654, 78.654, 78.654, 78.654, 82.716, 74.592, 78.654, 78.654, 78.654, 78.654, 81.676, 75.633, 73.057, 85.025]
#         qcd.Scale(integ[j]/i)
#     return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [30372.54, 32524.457, 28220.621, 30372.54, 30372.54, 30372.54, 30372.54, 32345.927, 28399.153, 30372.54, 30372.54, 30372.54, 30372.54, 28773.246, 32136.44]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [13384.796, 13384.796, 13384.796, 13799.198, 12970.394, 13384.796, 13384.796, 13384.796, 13384.796, 13732.643, 13036.949, 13384.796, 13384.796, 12776.161, 14051.968]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [3534.941, 3534.941, 3534.941, 3534.941, 3534.941, 3709.536, 3360.347, 3534.941, 3534.941, 3534.941, 3534.941, 3653.204, 3416.992, 3360.912, 3729.88]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [573.4, 573.4, 573.4, 573.4, 573.4, 600.885, 545.915, 573.4, 573.4, 573.4, 573.4, 590.661, 556.139, 534.473, 617.808]
        qcd.Scale(integ[j]/i)
    return qcd
