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

histoname = [("mPt", "#mu  p_{T} (GeV)", 1), ("ePt", "e p_{T} (Gev)", 1), ("mEta", "#mu #eta", 1), ("eEta", "e #eta", 1), ("mPhi", "#mu #phi", 1), ("ePhi", "e #phi", 1), ("j1Pt", "Jet 1 p_{T}", 1), ("j2Pt", "Jet 2 p_{T}", 1), ("j1Eta", "Jet 1 #eta", 1), ("j2Eta", "Jet 2 #eta", 1), ("j1Phi", "Jet 1 #phi", 1), ("j2Phi", "Jet 2 #phi", 1), ("type1_pfMetEt", "MET (GeV)", 1), ("type1_pfMetPhi", "MET #phi", 1), ("m_e_Mass", "M_{vis}(#mu, e) (GeV)", 1), ("m_e_CollMass", "M_{col}(#mu, e) (GeV)", 1), ("m_e_PZeta", "p_{#zeta}(#mu, e) (GeV)", 1), ("numOfJets", "Number of Jets", 1), ("vbfMass", "VBF Mass", 1), ("numOfVtx", "Number of Vertices", 1), ("dEtaMuE", "#Delta#eta(#mu, e)", 1), ("dPhiEMET", "#Delta#phi(e, MET)", 1), ("dPhiMuMET", "#Delta#phi(#mu, MET)", 1), ("dPhiMuE", "#Delta#phi(#mu, e)", 1), ("MTEMET", "M_{T}(e, MET) (GeV)", 1), ("MTMuMET", "M_{T}(#mu, MET) (GeV)", 1)]

colhisto = [("m_e_CollinearMass", "M_{col}(#mu, e) (GeV)", 1)]

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
        integ = [610.469, 616.777, 604.161, 610.469, 610.469, 610.469, 610.469, 590.897, 630.039, 610.469, 610.469, 610.469, 610.469, 680.468, 548.887]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [568.536, 568.536, 568.536, 580.41, 556.663, 568.536, 568.536, 568.536, 568.536, 572.143, 564.929, 568.536, 568.536, 641.598, 506.468]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [254.416, 254.416, 254.416, 254.416, 254.416, 260.754, 248.078, 254.416, 254.416, 254.416, 254.416, 254.06, 254.773, 283.371, 229.983]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [41.736, 41.736, 41.736, 41.736, 41.736, 42.745, 40.726, 41.736, 41.736, 41.736, 41.736, 41.603, 41.869, 45.794, 38.405]
        qcd.Scale(integ[j]/i)
    return qcd

def normQCDBDT(histogram, i, j, category):
    qcd = histogram.Clone()
    if category=='0Jet':
        integ = [9594.453, 9717.6, 9471.301, 9594.453, 9594.453, 9594.453, 9594.453, 9283.747, 9905.139, 9594.453, 9594.453, 9594.453, 9594.453, 11083.194, 8353.082]
        qcd.Scale(integ[j]/i)
    elif category=='1Jet':
        integ = [4746.836, 4746.836, 4746.836, 4836.949, 4656.722, 4746.836, 4746.836, 4746.836, 4746.836, 4753.326, 4740.345, 4746.836, 4746.836, 5467.31, 4142.483]
        qcd.Scale(integ[j]/i)
    elif category=='2Jet':
        integ = [1673.765, 1673.765, 1673.765, 1673.765, 1673.765, 1714.55, 1632.979, 1673.765, 1673.765, 1673.765, 1673.765, 1669.179, 1678.351, 1875.703, 1503.758]
        qcd.Scale(integ[j]/i)
    elif category=='2JetVBF':
        integ = [278.034, 278.034, 278.034, 278.034, 278.034, 284.969, 271.1, 278.034, 278.034, 278.034, 278.034, 277.664, 278.404, 303.92, 256.137]
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

# def normHist(h0, h1, h2):
#     h3 = h1.Clone()
#     h4 = h2.Clone()
#     for i in range(1, h0.GetNbinsX()+1):
#         if abs(h1.GetBinContent(i) - h0.GetBinContent(i)) > abs(h2.GetBinContent(i) - h0.GetBinContent(i)):
#             err = h1.GetBinContent(i) - h0.GetBinContent(i)
#             h4.SetBinContent(i, h0.GetBinContent(i) - err)
#         else:
#             err = h2.GetBinContent(i) - h0.GetBinContent(i)
#             h3.SetBinContent(i, h0.GetBinContent(i) - err)
#     return [h3, h4]

# def normHist(h0, h1, h2):
#     h3 = h1.Clone()
#     h4 = h2.Clone()
#     for i in range(1, h0.GetNbinsX()+1):
#         err = math.sqrt((pow(h1.GetBinContent(i) - h0.GetBinContent(i), 2) + pow(h2.GetBinContent(i) - h0.GetBinContent(i), 2))/2)
#         if h1.GetBinContent(i) - h0.GetBinContent(i) > 0:
#             h3.SetBinContent(i, h0.GetBinContent(i) + err)
#             h4.SetBinContent(i, h0.GetBinContent(i) - err)
#         else:
#             h3.SetBinContent(i, h0.GetBinContent(i) - err)
#             h4.SetBinContent(i, h0.GetBinContent(i) + err)
#     return [h3, h4]

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
