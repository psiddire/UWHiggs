dirs = ['0Jet', '1Jet', '2Jet', '2JetVBF']

drs = ['0jet', '1jet', '2jet_gg', '2jet_vbf']

samp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'TT', 'T', 'Diboson', 'LFVGG125', 'LFVVBF125']

recsamp = ['Zothers', 'W', 'EWK', 'ggH_htt', 'qqH_htt', 'ggH_hww', 'qqH_hww', 'LFVGG125', 'LFVVBF125']

norecsamp = ['TT', 'T', 'Diboson']

# QCD
qcdSys = ['Rate0JetUp/', 'Rate0JetDown/', 'Rate1JetUp/', 'Rate1JetDown/', 'Rate2JetUp/', 'Rate2JetDown/', 'Shape0JetUp/', 'Shape0JetDown/', 'Shape1JetUp/', 'Shape1JetDown/', 'Shape2JetUp/', 'Shape2JetDown/', 'IsoUp/', 'IsoDown/']

qcdSysNames = ['QCD_CMS_QCD_0JetRate_2017_13TeVUp', 'QCD_CMS_QCD_0JetRate_2017_13TeVDown', 'QCD_CMS_QCD_1JetRate_2017_13TeVUp', 'QCD_CMS_QCD_1JetRate_2017_13TeVDown', 'QCD_CMS_QCD_2JetRate_2017_13TeVUp', 'QCD_CMS_QCD_2JetRate_2017_13TeVDown', 'QCD_CMS_QCD_0JetShape_2017_13TeVUp', 'QCD_CMS_QCD_0JetShape_2017_13TeVDown', 'QCD_CMS_QCD_1JetShape_2017_13TeVUp', 'QCD_CMS_QCD_1JetShape_2017_13TeVDown', 'QCD_CMS_QCD_2JetShape_2017_13TeVUp', 'QCD_CMS_QCD_2JetShape_2017_13TeVDown', 'QCD_CMS_QCD_Extrapolation_13TeVUp', 'QCD_CMS_QCD_Extrapolation_13TeVDown']

# MC
mcSys = ['puUp/', 'puDown/', 'pfUp/', 'pfDown/', 'bTagUp/', 'bTagDown/', 'eesUp/', 'eesDown/', 'mes1p2Up/', 'mes1p2Down/', 'mes2p1Up/', 'mes2p1Down/', 'mes2p4Up/', 'mes2p4Down/']

mcSysNames = ['_CMS_Pileup_13TeVUp', '_CMS_Pileup_13TeVDown', '_CMS_Prefiring_13TeVUp', '_CMS_Prefiring_13TeVDown', '_CMS_eff_btag_2017_13TeVUp', '_CMS_eff_btag_2017_13TeVDown', '_CMS_scale_e_13TeVUp', '_CMS_scale_e_13TeVDown', '_CMS_scale_m_etaLt1p2_13TeVUp', '_CMS_scale_m_etaLt1p2_13TeVDown', '_CMS_scale_m_eta1p2to2p1_13TeVUp', '_CMS_scale_m_eta1p2to2p1_13TeVDown', '_CMS_scale_m_eta2p1to2p4_13TeVUp', '_CMS_scale_m_eta2p1to2p4_13TeVDown']

escale = ['eesUp/', 'eesDown/']

escaleNames = ['ZTauTau_CMS_scale_e_emb_13TeVUp', 'ZTauTau_CMS_scale_e_emb_13TeVDown']

dyptSys = ['DYptreweightUp/', 'DYptreweightDown/']

dyptSysNames = ['_CMS_DYpTreweight_2017_13TeVUp', '_CMS_DYpTreweight_2017_13TeVDown']

# Recoil, JES
recSys = ['recresp0Up/', 'recresp0Down/', 'recreso0Up/', 'recreso0Down/', 'recresp1Up/', 'recresp1Down/', 'recreso1Up/', 'recreso1Down/', 'recresp2Up/', 'recresp2Down/', 'recreso2Up/', 'recreso2Down/']

recSysNames = ['_CMS_scale_met_0Jet_2017_13TeVUp', '_CMS_scale_met_0Jet_2017_13TeVDown', '_CMS_reso_met_0Jet_2017_13TeVUp', '_CMS_reso_met_0Jet_2017_13TeVDown', '_CMS_scale_met_1Jet_2017_13TeVUp', '_CMS_scale_met_1Jet_2017_13TeVDown', '_CMS_reso_met_1Jet_2017_13TeVUp', '_CMS_reso_met_1Jet_2017_13TeVDown', '_CMS_scale_met_2Jet_2017_13TeVUp', '_CMS_scale_met_2Jet_2017_13TeVDown', '_CMS_reso_met_2Jet_2017_13TeVUp', '_CMS_reso_met_2Jet_2017_13TeVDown']

jesSys = ['UnclusteredEnUp/', 'UnclusteredEnDown/', 'UesCHARGEDUp/', 'UesCHARGEDDown/', 'UesECALUp/', 'UesECALDown/', 'UesHCALUp/', 'UesHCALDown/', 'UesHFUp/', 'UesHFDown/', 'JetAbsoluteUp/', 'JetAbsoluteDown/', 'JetAbsoluteyearUp/', 'JetAbsoluteyearDown/', 'JetBBEC1Up/', 'JetBBEC1Down/', 'JetBBEC1yearUp/', 'JetBBEC1yearDown/', 'JetFlavorQCDUp/', 'JetFlavorQCDDown/', 'JetEC2Up/', 'JetEC2Down/', 'JetEC2yearUp/', 'JetEC2yearDown/', 'JetHFUp/', 'JetHFDown/', 'JetHFyearUp/', 'JetHFyearDown/', 'JetRelativeBalUp/', 'JetRelativeBalDown/', 'JetRelativeSampleUp/', 'JetRelativeSampleDown/', 'JERUp/', 'JERDown/']

jesSysNames = ['_CMS_MET_Ues_13TeVUp', '_CMS_MET_Ues_13TeVDown', '_CMS_MET_chargedUes_13TeVUp', '_CMS_MET_chargedUes_13TeVDown', '_CMS_MET_ecalUes_13TeVUp', '_CMS_MET_ecalUes_13TeVDown', '_CMS_MET_hcalUes_13TeVUp', '_CMS_MET_hcalUes_13TeVDown', '_CMS_MET_hfUes_13TeVUp', '_CMS_MET_hfUes_13TeVDown', '_CMS_Jes_JetAbsolute_13TeVUp', '_CMS_Jes_JetAbsolute_13TeVDown', '_CMS_Jes_JetAbsolute_2017_13TeVUp', '_CMS_Jes_JetAbsolute_2017_13TeVDown', '_CMS_Jes_JetBBEC1_13TeVUp', '_CMS_Jes_JetBBEC1_13TeVDown', '_CMS_Jes_JetBBEC1_2017_13TeVUp', '_CMS_Jes_JetBBEC1_2017_13TeVDown', '_CMS_Jes_JetFlavorQCD_13TeVUp', '_CMS_Jes_JetFlavorQCD_13TeVDown', '_CMS_Jes_JetEC2_13TeVUp', '_CMS_Jes_JetEC2_13TeVDown', '_CMS_Jes_JetEC2_2017_13TeVUp', '_CMS_Jes_JetEC2_2017_13TeVDown', '_CMS_Jes_JetHF_13TeVUp', '_CMS_Jes_JetHF_13TeVDown', '_CMS_Jes_JetHF_2017_13TeVUp', '_CMS_Jes_JetHF_2017_13TeVDown', '_CMS_Jes_JetRelativeBal_13TeVUp', '_CMS_Jes_JetRelativeBal_13TeVDown', '_CMS_Jes_JetRelativeSample_13TeVUp', '_CMS_Jes_JetRelativeSample_13TeVDown', '_CMS_Jer_2017_13TeVUp', '_CMS_Jer_2017_13TeVDown']

# Samples
mc_samples = ['DYJetsToLL_M-50*', 'DYJetsToLL_M-10to50*', 'DY1JetsToLL*', 'DY2JetsToLL*', 'DY3JetsToLL*', 'DY4JetsToLL*', 'WJetsToLNu*', 'W1JetsToLNu*', 'W2JetsToLNu*', 'W3JetsToLNu*', 'W4JetsToLNu*', 'WGToLNuG*', 'GluGlu_LFV*', 'VBF_LFV*', 'GluGluHToTauTau*', 'VBFHToTauTau*', 'GluGluHToWWTo2L2Nu*', 'VBFHToWWTo2L2Nu*', 'WminusHToTauTau*', 'WplusHToTauTau*', 'ZHToTauTau*', 'TTTo2L2Nu*', 'TTToSemiLeptonic*', 'TTToHadronic*', 'ST_tW_antitop*', 'ST_tW_top*', 'ST_t-channel_antitop*', 'ST_t-channel_top*', 'QCD*', 'WZ*', 'WW*', 'ZZ*', 'EWKWMinus2Jets*', 'EWKWPlus2Jets*', 'EWKZ2Jets_ZToLL*', 'EWKZ2Jets_ZToNuNu*', 'Embed*', 'MC*', 'data*', 'Obs*', 'Bac*']

histoname = [("mPt", "#mu  p_{T} (GeV)", 1), ("ePt", "e p_{T} (Gev)", 1), ("mEta", "#mu #eta", 1), ("eEta", "e #eta", 1), ("mPhi", "#mu #phi", 1), ("ePhi", "e #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("e_m_Mass", "M_{vis}(e, #mu) (GeV)", 1), ("e_m_CollMass", "M_{col}(e, #mu) (GeV)", 1), ("e_m_PZeta", "p_{#zeta}(e, #mu) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaEMu", "#Delta#eta(e, #mu)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiEMu", "#Delta#phi(e, #mu)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

colhisto = [("e_m_CollinearMass", "M_{col}(e, #mu) (GeV)", 1)]

bdthisto = [("bdtDiscriminator", "BDT Discriminator", 1)]

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
        integ = [1893.359, 1915.429, 1871.288, 1893.359, 1893.359, 1893.359, 1893.359, 1832.333, 1954.38, 1893.359, 1893.359, 1893.359, 1893.359, 1567.661, 2305.881]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [1217.285, 1217.285, 1217.285, 1243.021, 1191.55, 1217.285, 1217.285, 1217.285, 1217.285, 1225.83, 1208.741, 1217.285, 1217.285, 1076.992, 1397.193]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [446.599, 446.599, 446.599, 446.599, 446.599, 458.303, 434.894, 446.599, 446.599, 446.599, 446.599, 447.396, 445.801, 402.451, 503.774]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [44.134, 44.134, 44.134, 44.134, 44.134, 45.2, 43.067, 44.134, 44.134, 44.134, 44.134, 43.991, 44.276, 39.798, 49.664]
        qcd.Scale(integ[j]/i)
    return qcd

# def normQCD(histogram, i, j, category):
#     qcd = histogram.Clone()
#     if category=='0Jet':
#         integ = [4196.514, 4252.872, 4140.154, 4196.514, 4196.514, 4196.514, 4196.514, 4060.292, 4332.728, 4196.514, 4196.514, 4196.514, 4196.514, 3754.505, 4769.719]
#         qcd.Scale(integ[j]/i)
#     elif category=='1Jet':
#         integ = [1200.379, 1200.379, 1200.379, 1225.956, 1174.803, 1200.379, 1200.379, 1200.379, 1200.379, 1209.326, 1191.433, 1200.379, 1200.379, 1060.21, 1379.009]
#         qcd.Scale(integ[j]/i)
#     elif category=='2Jet':
#         integ = [394.37, 394.37, 394.37, 394.37, 394.37, 405.394, 383.344, 394.37, 394.37, 394.37, 394.37, 396.767, 391.972, 355.003, 445.6]
#         qcd.Scale(integ[j]/i)
#     elif category=='2JetVBF':
#         integ = [56.645, 56.645, 56.645, 56.645, 56.645, 58.169, 55.12, 56.645, 56.645, 56.645, 56.645, 56.844, 56.445, 53.218, 61.152]
#         qcd.Scale(integ[j]/i)
#     return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [18378.17, 18632.106, 18124.225, 18378.17, 18378.17, 18378.17, 18378.17, 17780.677, 18975.626, 18378.17, 18378.17, 18378.17, 18378.17, 16994.378, 20181.021]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [8075.694, 8075.694, 8075.694, 8230.608, 7920.78, 8075.694, 8075.694, 8075.694, 8075.694, 8090.944, 8060.783, 8075.694, 8075.694, 7305.978, 9070.334]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [2276.235, 2276.235, 2276.235, 2276.235, 2276.235, 2334.24, 2218.226, 2276.235, 2276.235, 2276.235, 2276.235, 2276.243, 2276.227, 2060.414, 2552.509]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [394.433, 394.433, 394.433, 394.433, 394.433, 404.503, 384.382, 394.433, 394.433, 394.433, 394.433, 394.483, 394.433, 376.52, 420.799]
        qcd.Scale(integ[j]/i)
    return qcd

# def normEmb(histogram, nom, name):
#     h = histogram.Clone()
#     inti = h.Integral()
#     if inti==0:
#         return h
#     if 'Up' in name:
#         h.Scale(1.0000001/inti)
#     else:
#         h.Scale(0.9999999/inti)
#     h.Scale(nom)
#     return h

# def normHist(h0, h1, h2):
#     h3 = h1.Clone()
#     h4 = h2.Clone()
#     for i in range(1, h0.GetNbinsX()+1):
#         err = (abs(h1.GetBinContent(i) - h0.GetBinContent(i)) + abs(h2.GetBinContent(i) - h0.GetBinContent(i)))/2
#         if h1.GetBinContent(i) - h0.GetBinContent(i) > 0:
#             h3.SetBinContent(i, h0.GetBinContent(i) + err)
#             h4.SetBinContent(i, h0.GetBinContent(i) - err)
#         else:
#             h3.SetBinContent(i, h0.GetBinContent(i) - err)
#             h4.SetBinContent(i, h0.GetBinContent(i) + err)
#     return [h3, h4]

#def normHist(h0, h1, h2):
#    h4 = h2.Clone()
#    for i in range(1, h0.GetNbinsX()+1):
#        err = h1.GetBinContent(i) - h0.GetBinContent(i)
#        h4.SetBinContent(i, h0.GetBinContent(i) - err)
#    return h4

# d = f.mkdir(Lists.drs[k])
# d.cd()
# if di=='0Jet':
#     binning = array.array('d', [-1.0, -0.55, -0.45, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.2, 0.35, 1.0])
# elif di=='1Jet':
#     binning = array.array('d', [-1.0, -0.55, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.3, 1.0])
# elif di=='2Jet':
#     binning = array.array('d', [-1.0, -0.55, -0.4, -0.35, -0.3, -0.25, -0.2, -0.15, -0.1, -0.05, 0.0, 0.05, 0.1, 0.15, 0.3, 1.0])
# else:
#     binning = array.array('d', [-1.0, -0.55, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.3, 1.0])
