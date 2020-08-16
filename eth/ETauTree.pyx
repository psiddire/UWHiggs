

# Load relevant ROOT C++ headers
cdef extern from "TObject.h":
    cdef cppclass TObject:
        pass

cdef extern from "TBranch.h":
    cdef cppclass TBranch:
        int GetEntry(long, int)
        void SetAddress(void*)

cdef extern from "TTree.h":
    cdef cppclass TTree:
        TTree()
        int GetEntry(long, int)
        long LoadTree(long)
        long GetEntries()
        TTree* GetTree()
        int GetTreeNumber()
        TBranch* GetBranch(char*)

cdef extern from "TFile.h":
    cdef cppclass TFile:
        TFile(char*, char*, char*, int)
        TObject* Get(char*)

# Used for filtering with a string
cdef extern from "TTreeFormula.h":
    cdef cppclass TTreeFormula:
        TTreeFormula(char*, char*, TTree*)
        double EvalInstance(int, char**)
        void UpdateFormulaLeaves()
        void SetTree(TTree*)

from cpython cimport PyCObject_AsVoidPtr
import warnings
def my_warning_format(message, category, filename, lineno, line=""):
    return "%s:%s\n" % (category.__name__, message)
warnings.formatwarning = my_warning_format

cdef class ETauTree:
    # Pointers to tree (may be a chain), current active tree, and current entry
    # localentry is the entry in the current tree of the chain
    cdef TTree* tree
    cdef TTree* currentTree
    cdef int currentTreeNumber
    cdef long ientry
    cdef long localentry
    # Keep track of missing branches we have complained about.
    cdef public set complained

    # Branches and address for all

    cdef TBranch* Ele24LooseHPSTau30Pass_branch
    cdef float Ele24LooseHPSTau30Pass_value

    cdef TBranch* Ele24LooseHPSTau30TightIDPass_branch
    cdef float Ele24LooseHPSTau30TightIDPass_value

    cdef TBranch* Ele24LooseTau30Pass_branch
    cdef float Ele24LooseTau30Pass_value

    cdef TBranch* Ele24LooseTau30TightIDPass_branch
    cdef float Ele24LooseTau30TightIDPass_value

    cdef TBranch* Ele27WPTightPass_branch
    cdef float Ele27WPTightPass_value

    cdef TBranch* Ele32WPTightPass_branch
    cdef float Ele32WPTightPass_value

    cdef TBranch* Ele35WPTightPass_branch
    cdef float Ele35WPTightPass_value

    cdef TBranch* EmbPtWeight_branch
    cdef float EmbPtWeight_value

    cdef TBranch* Eta_branch
    cdef float Eta_value

    cdef TBranch* Flag_BadChargedCandidateFilter_branch
    cdef float Flag_BadChargedCandidateFilter_value

    cdef TBranch* Flag_BadPFMuonFilter_branch
    cdef float Flag_BadPFMuonFilter_value

    cdef TBranch* Flag_EcalDeadCellTriggerPrimitiveFilter_branch
    cdef float Flag_EcalDeadCellTriggerPrimitiveFilter_value

    cdef TBranch* Flag_HBHENoiseFilter_branch
    cdef float Flag_HBHENoiseFilter_value

    cdef TBranch* Flag_HBHENoiseIsoFilter_branch
    cdef float Flag_HBHENoiseIsoFilter_value

    cdef TBranch* Flag_ecalBadCalibReducedMINIAODFilter_branch
    cdef float Flag_ecalBadCalibReducedMINIAODFilter_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* GenWeight_branch
    cdef float GenWeight_value

    cdef TBranch* Ht_branch
    cdef float Ht_value

    cdef TBranch* IsoMu24Pass_branch
    cdef float IsoMu24Pass_value

    cdef TBranch* IsoMu27Pass_branch
    cdef float IsoMu27Pass_value

    cdef TBranch* LT_branch
    cdef float LT_value

    cdef TBranch* Mass_branch
    cdef float Mass_value

    cdef TBranch* MassError_branch
    cdef float MassError_value

    cdef TBranch* MassErrord1_branch
    cdef float MassErrord1_value

    cdef TBranch* MassErrord2_branch
    cdef float MassErrord2_value

    cdef TBranch* MassErrord3_branch
    cdef float MassErrord3_value

    cdef TBranch* MassErrord4_branch
    cdef float MassErrord4_value

    cdef TBranch* Mt_branch
    cdef float Mt_value

    cdef TBranch* Mu50Pass_branch
    cdef float Mu50Pass_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Phi_branch
    cdef float Phi_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto30Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto30Medium_2018_DR0p5_value

    cdef TBranch* bweight_2016_branch
    cdef float bweight_2016_value

    cdef TBranch* bweight_2017_branch
    cdef float bweight_2017_value

    cdef TBranch* bweight_2018_branch
    cdef float bweight_2018_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* deepcsvb1_btagscore_branch
    cdef float deepcsvb1_btagscore_value

    cdef TBranch* deepcsvb1_eta_branch
    cdef float deepcsvb1_eta_value

    cdef TBranch* deepcsvb1_hadronflavour_branch
    cdef float deepcsvb1_hadronflavour_value

    cdef TBranch* deepcsvb1_m_branch
    cdef float deepcsvb1_m_value

    cdef TBranch* deepcsvb1_phi_branch
    cdef float deepcsvb1_phi_value

    cdef TBranch* deepcsvb1_pt_branch
    cdef float deepcsvb1_pt_value

    cdef TBranch* deepcsvb2_btagscore_branch
    cdef float deepcsvb2_btagscore_value

    cdef TBranch* deepcsvb2_eta_branch
    cdef float deepcsvb2_eta_value

    cdef TBranch* deepcsvb2_hadronflavour_branch
    cdef float deepcsvb2_hadronflavour_value

    cdef TBranch* deepcsvb2_m_branch
    cdef float deepcsvb2_m_value

    cdef TBranch* deepcsvb2_phi_branch
    cdef float deepcsvb2_phi_value

    cdef TBranch* deepcsvb2_pt_branch
    cdef float deepcsvb2_pt_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eCorrectedEt_branch
    cdef float eCorrectedEt_value

    cdef TBranch* eEnergyError_branch
    cdef float eEnergyError_value

    cdef TBranch* eEnergyScaleDown_branch
    cdef float eEnergyScaleDown_value

    cdef TBranch* eEnergyScaleGainDown_branch
    cdef float eEnergyScaleGainDown_value

    cdef TBranch* eEnergyScaleGainUp_branch
    cdef float eEnergyScaleGainUp_value

    cdef TBranch* eEnergyScaleStatDown_branch
    cdef float eEnergyScaleStatDown_value

    cdef TBranch* eEnergyScaleStatUp_branch
    cdef float eEnergyScaleStatUp_value

    cdef TBranch* eEnergyScaleSystDown_branch
    cdef float eEnergyScaleSystDown_value

    cdef TBranch* eEnergyScaleSystUp_branch
    cdef float eEnergyScaleSystUp_value

    cdef TBranch* eEnergyScaleUp_branch
    cdef float eEnergyScaleUp_value

    cdef TBranch* eEnergySigmaDown_branch
    cdef float eEnergySigmaDown_value

    cdef TBranch* eEnergySigmaPhiDown_branch
    cdef float eEnergySigmaPhiDown_value

    cdef TBranch* eEnergySigmaPhiUp_branch
    cdef float eEnergySigmaPhiUp_value

    cdef TBranch* eEnergySigmaRhoDown_branch
    cdef float eEnergySigmaRhoDown_value

    cdef TBranch* eEnergySigmaRhoUp_branch
    cdef float eEnergySigmaRhoUp_value

    cdef TBranch* eEnergySigmaUp_branch
    cdef float eEnergySigmaUp_value

    cdef TBranch* eEta_branch
    cdef float eEta_value

    cdef TBranch* eGenCharge_branch
    cdef float eGenCharge_value

    cdef TBranch* eGenDirectPromptTauDecay_branch
    cdef float eGenDirectPromptTauDecay_value

    cdef TBranch* eGenEnergy_branch
    cdef float eGenEnergy_value

    cdef TBranch* eGenEta_branch
    cdef float eGenEta_value

    cdef TBranch* eGenIsPrompt_branch
    cdef float eGenIsPrompt_value

    cdef TBranch* eGenMotherPdgId_branch
    cdef float eGenMotherPdgId_value

    cdef TBranch* eGenParticle_branch
    cdef float eGenParticle_value

    cdef TBranch* eGenPdgId_branch
    cdef float eGenPdgId_value

    cdef TBranch* eGenPhi_branch
    cdef float eGenPhi_value

    cdef TBranch* eGenPrompt_branch
    cdef float eGenPrompt_value

    cdef TBranch* eGenPromptTauDecay_branch
    cdef float eGenPromptTauDecay_value

    cdef TBranch* eGenPt_branch
    cdef float eGenPt_value

    cdef TBranch* eGenTauDecay_branch
    cdef float eGenTauDecay_value

    cdef TBranch* eGenVZ_branch
    cdef float eGenVZ_value

    cdef TBranch* eGenVtxPVMatch_branch
    cdef float eGenVtxPVMatch_value

    cdef TBranch* eIP3D_branch
    cdef float eIP3D_value

    cdef TBranch* eIP3DErr_branch
    cdef float eIP3DErr_value

    cdef TBranch* eIsoDB03_branch
    cdef float eIsoDB03_value

    cdef TBranch* eJetArea_branch
    cdef float eJetArea_value

    cdef TBranch* eJetBtag_branch
    cdef float eJetBtag_value

    cdef TBranch* eJetDR_branch
    cdef float eJetDR_value

    cdef TBranch* eJetEtaEtaMoment_branch
    cdef float eJetEtaEtaMoment_value

    cdef TBranch* eJetEtaPhiMoment_branch
    cdef float eJetEtaPhiMoment_value

    cdef TBranch* eJetEtaPhiSpread_branch
    cdef float eJetEtaPhiSpread_value

    cdef TBranch* eJetHadronFlavour_branch
    cdef float eJetHadronFlavour_value

    cdef TBranch* eJetPFCISVBtag_branch
    cdef float eJetPFCISVBtag_value

    cdef TBranch* eJetPartonFlavour_branch
    cdef float eJetPartonFlavour_value

    cdef TBranch* eJetPhiPhiMoment_branch
    cdef float eJetPhiPhiMoment_value

    cdef TBranch* eJetPt_branch
    cdef float eJetPt_value

    cdef TBranch* eMVAIsoWP80_branch
    cdef float eMVAIsoWP80_value

    cdef TBranch* eMVAIsoWP90_branch
    cdef float eMVAIsoWP90_value

    cdef TBranch* eMVANoisoWP80_branch
    cdef float eMVANoisoWP80_value

    cdef TBranch* eMVANoisoWP90_branch
    cdef float eMVANoisoWP90_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

    cdef TBranch* eMatchEmbeddedFilterEle24Tau30_branch
    cdef float eMatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* eMatchEmbeddedFilterEle27_branch
    cdef float eMatchEmbeddedFilterEle27_value

    cdef TBranch* eMatchEmbeddedFilterEle32_branch
    cdef float eMatchEmbeddedFilterEle32_value

    cdef TBranch* eMatchEmbeddedFilterEle32DoubleL1_v1_branch
    cdef float eMatchEmbeddedFilterEle32DoubleL1_v1_value

    cdef TBranch* eMatchEmbeddedFilterEle32DoubleL1_v2_branch
    cdef float eMatchEmbeddedFilterEle32DoubleL1_v2_value

    cdef TBranch* eMatchEmbeddedFilterEle35_branch
    cdef float eMatchEmbeddedFilterEle35_value

    cdef TBranch* eMatchesEle24HPSTau30Filter_branch
    cdef float eMatchesEle24HPSTau30Filter_value

    cdef TBranch* eMatchesEle24HPSTau30Path_branch
    cdef float eMatchesEle24HPSTau30Path_value

    cdef TBranch* eMatchesEle24Tau30Filter_branch
    cdef float eMatchesEle24Tau30Filter_value

    cdef TBranch* eMatchesEle24Tau30Path_branch
    cdef float eMatchesEle24Tau30Path_value

    cdef TBranch* eMatchesEle25Filter_branch
    cdef float eMatchesEle25Filter_value

    cdef TBranch* eMatchesEle25Path_branch
    cdef float eMatchesEle25Path_value

    cdef TBranch* eMatchesEle27Filter_branch
    cdef float eMatchesEle27Filter_value

    cdef TBranch* eMatchesEle27Path_branch
    cdef float eMatchesEle27Path_value

    cdef TBranch* eMatchesEle32Filter_branch
    cdef float eMatchesEle32Filter_value

    cdef TBranch* eMatchesEle32Path_branch
    cdef float eMatchesEle32Path_value

    cdef TBranch* eMatchesEle35Filter_branch
    cdef float eMatchesEle35Filter_value

    cdef TBranch* eMatchesEle35Path_branch
    cdef float eMatchesEle35Path_value

    cdef TBranch* eMatchesMu23e12DZFilter_branch
    cdef float eMatchesMu23e12DZFilter_value

    cdef TBranch* eMatchesMu23e12DZPath_branch
    cdef float eMatchesMu23e12DZPath_value

    cdef TBranch* eMatchesMu23e12Filter_branch
    cdef float eMatchesMu23e12Filter_value

    cdef TBranch* eMatchesMu23e12Path_branch
    cdef float eMatchesMu23e12Path_value

    cdef TBranch* eMatchesMu8e23DZFilter_branch
    cdef float eMatchesMu8e23DZFilter_value

    cdef TBranch* eMatchesMu8e23DZPath_branch
    cdef float eMatchesMu8e23DZPath_value

    cdef TBranch* eMatchesMu8e23Filter_branch
    cdef float eMatchesMu8e23Filter_value

    cdef TBranch* eMatchesMu8e23Path_branch
    cdef float eMatchesMu8e23Path_value

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* ePVDXY_branch
    cdef float ePVDXY_value

    cdef TBranch* ePVDZ_branch
    cdef float ePVDZ_value

    cdef TBranch* ePassesConversionVeto_branch
    cdef float ePassesConversionVeto_value

    cdef TBranch* ePhi_branch
    cdef float ePhi_value

    cdef TBranch* ePt_branch
    cdef float ePt_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* e_t_PZeta_branch
    cdef float e_t_PZeta_value

    cdef TBranch* e_t_PZetaVis_branch
    cdef float e_t_PZetaVis_value

    cdef TBranch* e_t_doubleL1IsoTauMatch_branch
    cdef float e_t_doubleL1IsoTauMatch_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

    cdef TBranch* evt_branch
    cdef unsigned long evt_value

    cdef TBranch* genEta_branch
    cdef float genEta_value

    cdef TBranch* genHTT_branch
    cdef float genHTT_value

    cdef TBranch* genM_branch
    cdef float genM_value

    cdef TBranch* genMass_branch
    cdef float genMass_value

    cdef TBranch* genPhi_branch
    cdef float genPhi_value

    cdef TBranch* genpT_branch
    cdef float genpT_value

    cdef TBranch* genpX_branch
    cdef float genpX_value

    cdef TBranch* genpY_branch
    cdef float genpY_value

    cdef TBranch* isGtautau_branch
    cdef float isGtautau_value

    cdef TBranch* isWenu_branch
    cdef float isWenu_value

    cdef TBranch* isWmunu_branch
    cdef float isWmunu_value

    cdef TBranch* isWtaunu_branch
    cdef float isWtaunu_value

    cdef TBranch* isZee_branch
    cdef float isZee_value

    cdef TBranch* isZmumu_branch
    cdef float isZmumu_value

    cdef TBranch* isZtautau_branch
    cdef float isZtautau_value

    cdef TBranch* isdata_branch
    cdef int isdata_value

    cdef TBranch* isembed_branch
    cdef int isembed_value

    cdef TBranch* j1csv_branch
    cdef float j1csv_value

    cdef TBranch* j1csvWoNoisyJets_branch
    cdef float j1csvWoNoisyJets_value

    cdef TBranch* j1eta_branch
    cdef float j1eta_value

    cdef TBranch* j1etaWoNoisyJets_branch
    cdef float j1etaWoNoisyJets_value

    cdef TBranch* j1hadronflavor_branch
    cdef float j1hadronflavor_value

    cdef TBranch* j1hadronflavorWoNoisyJets_branch
    cdef float j1hadronflavorWoNoisyJets_value

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

    cdef TBranch* j1phiWoNoisyJets_branch
    cdef float j1phiWoNoisyJets_value

    cdef TBranch* j1pt_branch
    cdef float j1pt_value

    cdef TBranch* j1ptWoNoisyJets_branch
    cdef float j1ptWoNoisyJets_value

    cdef TBranch* j1ptWoNoisyJets_JERDown_branch
    cdef float j1ptWoNoisyJets_JERDown_value

    cdef TBranch* j1ptWoNoisyJets_JERUp_branch
    cdef float j1ptWoNoisyJets_JERUp_value

    cdef TBranch* j1ptWoNoisyJets_JetAbsoluteDown_branch
    cdef float j1ptWoNoisyJets_JetAbsoluteDown_value

    cdef TBranch* j1ptWoNoisyJets_JetAbsoluteUp_branch
    cdef float j1ptWoNoisyJets_JetAbsoluteUp_value

    cdef TBranch* j1ptWoNoisyJets_JetAbsoluteyearDown_branch
    cdef float j1ptWoNoisyJets_JetAbsoluteyearDown_value

    cdef TBranch* j1ptWoNoisyJets_JetAbsoluteyearUp_branch
    cdef float j1ptWoNoisyJets_JetAbsoluteyearUp_value

    cdef TBranch* j1ptWoNoisyJets_JetBBEC1Down_branch
    cdef float j1ptWoNoisyJets_JetBBEC1Down_value

    cdef TBranch* j1ptWoNoisyJets_JetBBEC1Up_branch
    cdef float j1ptWoNoisyJets_JetBBEC1Up_value

    cdef TBranch* j1ptWoNoisyJets_JetBBEC1yearDown_branch
    cdef float j1ptWoNoisyJets_JetBBEC1yearDown_value

    cdef TBranch* j1ptWoNoisyJets_JetBBEC1yearUp_branch
    cdef float j1ptWoNoisyJets_JetBBEC1yearUp_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2Down_branch
    cdef float j1ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2Up_branch
    cdef float j1ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2yearDown_branch
    cdef float j1ptWoNoisyJets_JetEC2yearDown_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2yearUp_branch
    cdef float j1ptWoNoisyJets_JetEC2yearUp_value

    cdef TBranch* j1ptWoNoisyJets_JetFlavorQCDDown_branch
    cdef float j1ptWoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* j1ptWoNoisyJets_JetFlavorQCDUp_branch
    cdef float j1ptWoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* j1ptWoNoisyJets_JetHFDown_branch
    cdef float j1ptWoNoisyJets_JetHFDown_value

    cdef TBranch* j1ptWoNoisyJets_JetHFUp_branch
    cdef float j1ptWoNoisyJets_JetHFUp_value

    cdef TBranch* j1ptWoNoisyJets_JetHFyearDown_branch
    cdef float j1ptWoNoisyJets_JetHFyearDown_value

    cdef TBranch* j1ptWoNoisyJets_JetHFyearUp_branch
    cdef float j1ptWoNoisyJets_JetHFyearUp_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeBalDown_branch
    cdef float j1ptWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeBalUp_branch
    cdef float j1ptWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeSampleDown_branch
    cdef float j1ptWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* j1ptWoNoisyJets_JetRelativeSampleUp_branch
    cdef float j1ptWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* j2csv_branch
    cdef float j2csv_value

    cdef TBranch* j2csvWoNoisyJets_branch
    cdef float j2csvWoNoisyJets_value

    cdef TBranch* j2eta_branch
    cdef float j2eta_value

    cdef TBranch* j2etaWoNoisyJets_branch
    cdef float j2etaWoNoisyJets_value

    cdef TBranch* j2hadronflavor_branch
    cdef float j2hadronflavor_value

    cdef TBranch* j2hadronflavorWoNoisyJets_branch
    cdef float j2hadronflavorWoNoisyJets_value

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

    cdef TBranch* j2phiWoNoisyJets_branch
    cdef float j2phiWoNoisyJets_value

    cdef TBranch* j2pt_branch
    cdef float j2pt_value

    cdef TBranch* j2ptWoNoisyJets_branch
    cdef float j2ptWoNoisyJets_value

    cdef TBranch* j2ptWoNoisyJets_JERDown_branch
    cdef float j2ptWoNoisyJets_JERDown_value

    cdef TBranch* j2ptWoNoisyJets_JERUp_branch
    cdef float j2ptWoNoisyJets_JERUp_value

    cdef TBranch* j2ptWoNoisyJets_JetAbsoluteDown_branch
    cdef float j2ptWoNoisyJets_JetAbsoluteDown_value

    cdef TBranch* j2ptWoNoisyJets_JetAbsoluteUp_branch
    cdef float j2ptWoNoisyJets_JetAbsoluteUp_value

    cdef TBranch* j2ptWoNoisyJets_JetAbsoluteyearDown_branch
    cdef float j2ptWoNoisyJets_JetAbsoluteyearDown_value

    cdef TBranch* j2ptWoNoisyJets_JetAbsoluteyearUp_branch
    cdef float j2ptWoNoisyJets_JetAbsoluteyearUp_value

    cdef TBranch* j2ptWoNoisyJets_JetBBEC1Down_branch
    cdef float j2ptWoNoisyJets_JetBBEC1Down_value

    cdef TBranch* j2ptWoNoisyJets_JetBBEC1Up_branch
    cdef float j2ptWoNoisyJets_JetBBEC1Up_value

    cdef TBranch* j2ptWoNoisyJets_JetBBEC1yearDown_branch
    cdef float j2ptWoNoisyJets_JetBBEC1yearDown_value

    cdef TBranch* j2ptWoNoisyJets_JetBBEC1yearUp_branch
    cdef float j2ptWoNoisyJets_JetBBEC1yearUp_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2Down_branch
    cdef float j2ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2Up_branch
    cdef float j2ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2yearDown_branch
    cdef float j2ptWoNoisyJets_JetEC2yearDown_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2yearUp_branch
    cdef float j2ptWoNoisyJets_JetEC2yearUp_value

    cdef TBranch* j2ptWoNoisyJets_JetFlavorQCDDown_branch
    cdef float j2ptWoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* j2ptWoNoisyJets_JetFlavorQCDUp_branch
    cdef float j2ptWoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* j2ptWoNoisyJets_JetHFDown_branch
    cdef float j2ptWoNoisyJets_JetHFDown_value

    cdef TBranch* j2ptWoNoisyJets_JetHFUp_branch
    cdef float j2ptWoNoisyJets_JetHFUp_value

    cdef TBranch* j2ptWoNoisyJets_JetHFyearDown_branch
    cdef float j2ptWoNoisyJets_JetHFyearDown_value

    cdef TBranch* j2ptWoNoisyJets_JetHFyearUp_branch
    cdef float j2ptWoNoisyJets_JetHFyearUp_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* jb1eta_2016_branch
    cdef float jb1eta_2016_value

    cdef TBranch* jb1eta_2017_branch
    cdef float jb1eta_2017_value

    cdef TBranch* jb1eta_2018_branch
    cdef float jb1eta_2018_value

    cdef TBranch* jb1hadronflavor_2016_branch
    cdef float jb1hadronflavor_2016_value

    cdef TBranch* jb1hadronflavor_2017_branch
    cdef float jb1hadronflavor_2017_value

    cdef TBranch* jb1hadronflavor_2018_branch
    cdef float jb1hadronflavor_2018_value

    cdef TBranch* jb1phi_2016_branch
    cdef float jb1phi_2016_value

    cdef TBranch* jb1phi_2017_branch
    cdef float jb1phi_2017_value

    cdef TBranch* jb1phi_2018_branch
    cdef float jb1phi_2018_value

    cdef TBranch* jb1pt_2016_branch
    cdef float jb1pt_2016_value

    cdef TBranch* jb1pt_2017_branch
    cdef float jb1pt_2017_value

    cdef TBranch* jb1pt_2018_branch
    cdef float jb1pt_2018_value

    cdef TBranch* jb2eta_2016_branch
    cdef float jb2eta_2016_value

    cdef TBranch* jb2eta_2017_branch
    cdef float jb2eta_2017_value

    cdef TBranch* jb2eta_2018_branch
    cdef float jb2eta_2018_value

    cdef TBranch* jb2hadronflavor_2016_branch
    cdef float jb2hadronflavor_2016_value

    cdef TBranch* jb2hadronflavor_2017_branch
    cdef float jb2hadronflavor_2017_value

    cdef TBranch* jb2hadronflavor_2018_branch
    cdef float jb2hadronflavor_2018_value

    cdef TBranch* jb2phi_2016_branch
    cdef float jb2phi_2016_value

    cdef TBranch* jb2phi_2017_branch
    cdef float jb2phi_2017_value

    cdef TBranch* jb2phi_2018_branch
    cdef float jb2phi_2018_value

    cdef TBranch* jb2pt_2016_branch
    cdef float jb2pt_2016_value

    cdef TBranch* jb2pt_2017_branch
    cdef float jb2pt_2017_value

    cdef TBranch* jb2pt_2018_branch
    cdef float jb2pt_2018_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20WoNoisyJets_branch
    cdef float jetVeto20WoNoisyJets_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30WoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JERDown_branch
    cdef float jetVeto30WoNoisyJets_JERDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JERUp_branch
    cdef float jetVeto30WoNoisyJets_JERUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteyearDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteyearUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetBBEC1Down_branch
    cdef float jetVeto30WoNoisyJets_JetBBEC1Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetBBEC1Up_branch
    cdef float jetVeto30WoNoisyJets_JetBBEC1Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetBBEC1yearDown_branch
    cdef float jetVeto30WoNoisyJets_JetBBEC1yearDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetBBEC1yearUp_branch
    cdef float jetVeto30WoNoisyJets_JetBBEC1yearUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2yearDown_branch
    cdef float jetVeto30WoNoisyJets_JetEC2yearDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2yearUp_branch
    cdef float jetVeto30WoNoisyJets_JetEC2yearUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFlavorQCDDown_branch
    cdef float jetVeto30WoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFlavorQCDUp_branch
    cdef float jetVeto30WoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetHFDown_branch
    cdef float jetVeto30WoNoisyJets_JetHFDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetHFUp_branch
    cdef float jetVeto30WoNoisyJets_JetHFUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetHFyearDown_branch
    cdef float jetVeto30WoNoisyJets_JetHFyearDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetHFyearUp_branch
    cdef float jetVeto30WoNoisyJets_JetHFyearUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalDown_branch
    cdef float jetVeto30WoNoisyJets_JetTotalDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalUp_branch
    cdef float jetVeto30WoNoisyJets_JetTotalUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* mu12e23DZPass_branch
    cdef float mu12e23DZPass_value

    cdef TBranch* mu12e23Pass_branch
    cdef float mu12e23Pass_value

    cdef TBranch* mu23e12DZPass_branch
    cdef float mu23e12DZPass_value

    cdef TBranch* mu23e12Pass_branch
    cdef float mu23e12Pass_value

    cdef TBranch* mu8e23DZPass_branch
    cdef float mu8e23DZPass_value

    cdef TBranch* mu8e23Pass_branch
    cdef float mu8e23Pass_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* npNLO_branch
    cdef float npNLO_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

    cdef TBranch* prefiring_weight_branch
    cdef float prefiring_weight_value

    cdef TBranch* prefiring_weight_down_branch
    cdef float prefiring_weight_down_value

    cdef TBranch* prefiring_weight_up_branch
    cdef float prefiring_weight_up_value

    cdef TBranch* processID_branch
    cdef float processID_value

    cdef TBranch* puppiMetEt_branch
    cdef float puppiMetEt_value

    cdef TBranch* puppiMetPhi_branch
    cdef float puppiMetPhi_value

    cdef TBranch* pvChi2_branch
    cdef float pvChi2_value

    cdef TBranch* pvDX_branch
    cdef float pvDX_value

    cdef TBranch* pvDY_branch
    cdef float pvDY_value

    cdef TBranch* pvDZ_branch
    cdef float pvDZ_value

    cdef TBranch* pvIsFake_branch
    cdef int pvIsFake_value

    cdef TBranch* pvIsValid_branch
    cdef int pvIsValid_value

    cdef TBranch* pvNormChi2_branch
    cdef float pvNormChi2_value

    cdef TBranch* pvRho_branch
    cdef float pvRho_value

    cdef TBranch* pvX_branch
    cdef float pvX_value

    cdef TBranch* pvY_branch
    cdef float pvY_value

    cdef TBranch* pvZ_branch
    cdef float pvZ_value

    cdef TBranch* pvndof_branch
    cdef float pvndof_value

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* singleE25eta2p1TightPass_branch
    cdef float singleE25eta2p1TightPass_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tComesFromHiggs_branch
    cdef float tComesFromHiggs_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tDecayModeFinding_branch
    cdef float tDecayModeFinding_value

    cdef TBranch* tDecayModeFindingNewDMs_branch
    cdef float tDecayModeFindingNewDMs_value

    cdef TBranch* tDeepTau2017v2p1VSeraw_branch
    cdef float tDeepTau2017v2p1VSeraw_value

    cdef TBranch* tDeepTau2017v2p1VSjetraw_branch
    cdef float tDeepTau2017v2p1VSjetraw_value

    cdef TBranch* tDeepTau2017v2p1VSmuraw_branch
    cdef float tDeepTau2017v2p1VSmuraw_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tGenCharge_branch
    cdef float tGenCharge_value

    cdef TBranch* tGenDecayMode_branch
    cdef float tGenDecayMode_value

    cdef TBranch* tGenEnergy_branch
    cdef float tGenEnergy_value

    cdef TBranch* tGenEta_branch
    cdef float tGenEta_value

    cdef TBranch* tGenJetEta_branch
    cdef float tGenJetEta_value

    cdef TBranch* tGenJetPt_branch
    cdef float tGenJetPt_value

    cdef TBranch* tGenMotherEnergy_branch
    cdef float tGenMotherEnergy_value

    cdef TBranch* tGenMotherEta_branch
    cdef float tGenMotherEta_value

    cdef TBranch* tGenMotherPdgId_branch
    cdef float tGenMotherPdgId_value

    cdef TBranch* tGenMotherPhi_branch
    cdef float tGenMotherPhi_value

    cdef TBranch* tGenMotherPt_branch
    cdef float tGenMotherPt_value

    cdef TBranch* tGenPdgId_branch
    cdef float tGenPdgId_value

    cdef TBranch* tGenPhi_branch
    cdef float tGenPhi_value

    cdef TBranch* tGenPt_branch
    cdef float tGenPt_value

    cdef TBranch* tGenStatus_branch
    cdef float tGenStatus_value

    cdef TBranch* tJetArea_branch
    cdef float tJetArea_value

    cdef TBranch* tJetBtag_branch
    cdef float tJetBtag_value

    cdef TBranch* tJetDR_branch
    cdef float tJetDR_value

    cdef TBranch* tJetEtaEtaMoment_branch
    cdef float tJetEtaEtaMoment_value

    cdef TBranch* tJetEtaPhiMoment_branch
    cdef float tJetEtaPhiMoment_value

    cdef TBranch* tJetEtaPhiSpread_branch
    cdef float tJetEtaPhiSpread_value

    cdef TBranch* tJetHadronFlavour_branch
    cdef float tJetHadronFlavour_value

    cdef TBranch* tJetPFCISVBtag_branch
    cdef float tJetPFCISVBtag_value

    cdef TBranch* tJetPartonFlavour_branch
    cdef float tJetPartonFlavour_value

    cdef TBranch* tJetPhiPhiMoment_branch
    cdef float tJetPhiPhiMoment_value

    cdef TBranch* tJetPt_branch
    cdef float tJetPt_value

    cdef TBranch* tL1IsoTauMatch_branch
    cdef float tL1IsoTauMatch_value

    cdef TBranch* tL1IsoTauPt_branch
    cdef float tL1IsoTauPt_value

    cdef TBranch* tLeadTrackPt_branch
    cdef float tLeadTrackPt_value

    cdef TBranch* tLooseDeepTau2017v2p1VSe_branch
    cdef float tLooseDeepTau2017v2p1VSe_value

    cdef TBranch* tLooseDeepTau2017v2p1VSjet_branch
    cdef float tLooseDeepTau2017v2p1VSjet_value

    cdef TBranch* tLooseDeepTau2017v2p1VSmu_branch
    cdef float tLooseDeepTau2017v2p1VSmu_value

    cdef TBranch* tLowestMll_branch
    cdef float tLowestMll_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMatchEmbeddedFilterEle24Tau30_branch
    cdef float tMatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* tMatchesEle24HPSTau30Filter_branch
    cdef float tMatchesEle24HPSTau30Filter_value

    cdef TBranch* tMatchesEle24HPSTau30Path_branch
    cdef float tMatchesEle24HPSTau30Path_value

    cdef TBranch* tMatchesEle24Tau30Filter_branch
    cdef float tMatchesEle24Tau30Filter_value

    cdef TBranch* tMatchesEle24Tau30Path_branch
    cdef float tMatchesEle24Tau30Path_value

    cdef TBranch* tMediumDeepTau2017v2p1VSe_branch
    cdef float tMediumDeepTau2017v2p1VSe_value

    cdef TBranch* tMediumDeepTau2017v2p1VSjet_branch
    cdef float tMediumDeepTau2017v2p1VSjet_value

    cdef TBranch* tMediumDeepTau2017v2p1VSmu_branch
    cdef float tMediumDeepTau2017v2p1VSmu_value

    cdef TBranch* tNChrgHadrIsolationCands_branch
    cdef float tNChrgHadrIsolationCands_value

    cdef TBranch* tNChrgHadrSignalCands_branch
    cdef float tNChrgHadrSignalCands_value

    cdef TBranch* tNGammaSignalCands_branch
    cdef float tNGammaSignalCands_value

    cdef TBranch* tNNeutralHadrSignalCands_branch
    cdef float tNNeutralHadrSignalCands_value

    cdef TBranch* tNSignalCands_branch
    cdef float tNSignalCands_value

    cdef TBranch* tNearestZMass_branch
    cdef float tNearestZMass_value

    cdef TBranch* tPVDXY_branch
    cdef float tPVDXY_value

    cdef TBranch* tPVDZ_branch
    cdef float tPVDZ_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tTightDeepTau2017v2p1VSe_branch
    cdef float tTightDeepTau2017v2p1VSe_value

    cdef TBranch* tTightDeepTau2017v2p1VSjet_branch
    cdef float tTightDeepTau2017v2p1VSjet_value

    cdef TBranch* tTightDeepTau2017v2p1VSmu_branch
    cdef float tTightDeepTau2017v2p1VSmu_value

    cdef TBranch* tVLooseDeepTau2017v2p1VSe_branch
    cdef float tVLooseDeepTau2017v2p1VSe_value

    cdef TBranch* tVLooseDeepTau2017v2p1VSjet_branch
    cdef float tVLooseDeepTau2017v2p1VSjet_value

    cdef TBranch* tVLooseDeepTau2017v2p1VSmu_branch
    cdef float tVLooseDeepTau2017v2p1VSmu_value

    cdef TBranch* tVTightDeepTau2017v2p1VSe_branch
    cdef float tVTightDeepTau2017v2p1VSe_value

    cdef TBranch* tVTightDeepTau2017v2p1VSjet_branch
    cdef float tVTightDeepTau2017v2p1VSjet_value

    cdef TBranch* tVTightDeepTau2017v2p1VSmu_branch
    cdef float tVTightDeepTau2017v2p1VSmu_value

    cdef TBranch* tVVLooseDeepTau2017v2p1VSe_branch
    cdef float tVVLooseDeepTau2017v2p1VSe_value

    cdef TBranch* tVVLooseDeepTau2017v2p1VSjet_branch
    cdef float tVVLooseDeepTau2017v2p1VSjet_value

    cdef TBranch* tVVTightDeepTau2017v2p1VSe_branch
    cdef float tVVTightDeepTau2017v2p1VSe_value

    cdef TBranch* tVVTightDeepTau2017v2p1VSjet_branch
    cdef float tVVTightDeepTau2017v2p1VSjet_value

    cdef TBranch* tVVTightDeepTau2017v2p1VSmu_branch
    cdef float tVVTightDeepTau2017v2p1VSmu_value

    cdef TBranch* tVVVLooseDeepTau2017v2p1VSe_branch
    cdef float tVVVLooseDeepTau2017v2p1VSe_value

    cdef TBranch* tVVVLooseDeepTau2017v2p1VSjet_branch
    cdef float tVVVLooseDeepTau2017v2p1VSjet_value

    cdef TBranch* tVZ_branch
    cdef float tVZ_value

    cdef TBranch* tZTTGenDR_branch
    cdef float tZTTGenDR_value

    cdef TBranch* tZTTGenEta_branch
    cdef float tZTTGenEta_value

    cdef TBranch* tZTTGenMatching_branch
    cdef float tZTTGenMatching_value

    cdef TBranch* tZTTGenPhi_branch
    cdef float tZTTGenPhi_value

    cdef TBranch* tZTTGenPt_branch
    cdef float tZTTGenPt_value

    cdef TBranch* tauVetoPt20LooseMVALTVtx_branch
    cdef float tauVetoPt20LooseMVALTVtx_value

    cdef TBranch* tauVetoPtDeepVtx_branch
    cdef float tauVetoPtDeepVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_JERDown_branch
    cdef float type1_pfMet_shiftedPhi_JERDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JERUp_branch
    cdef float type1_pfMet_shiftedPhi_JERUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1yearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetBBEC1yearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2yearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2yearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEC2yearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEC2yearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFyearDown_branch
    cdef float type1_pfMet_shiftedPhi_JetHFyearDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetHFyearUp_branch
    cdef float type1_pfMet_shiftedPhi_JetHFyearUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResDown_branch
    cdef float type1_pfMet_shiftedPhi_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResUp_branch
    cdef float type1_pfMet_shiftedPhi_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTotalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetTotalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTotalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetTotalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesCHARGEDDown_branch
    cdef float type1_pfMet_shiftedPhi_UesCHARGEDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesCHARGEDUp_branch
    cdef float type1_pfMet_shiftedPhi_UesCHARGEDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesECALDown_branch
    cdef float type1_pfMet_shiftedPhi_UesECALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesECALUp_branch
    cdef float type1_pfMet_shiftedPhi_UesECALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHCALDown_branch
    cdef float type1_pfMet_shiftedPhi_UesHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHCALUp_branch
    cdef float type1_pfMet_shiftedPhi_UesHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHFDown_branch
    cdef float type1_pfMet_shiftedPhi_UesHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UesHFUp_branch
    cdef float type1_pfMet_shiftedPhi_UesHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JERDown_branch
    cdef float type1_pfMet_shiftedPt_JERDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JERUp_branch
    cdef float type1_pfMet_shiftedPt_JERUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteyearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteyearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1yearDown_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1yearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetBBEC1yearUp_branch
    cdef float type1_pfMet_shiftedPt_JetBBEC1yearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2yearDown_branch
    cdef float type1_pfMet_shiftedPt_JetEC2yearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEC2yearUp_branch
    cdef float type1_pfMet_shiftedPt_JetEC2yearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFyearDown_branch
    cdef float type1_pfMet_shiftedPt_JetHFyearDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetHFyearUp_branch
    cdef float type1_pfMet_shiftedPt_JetHFyearUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResDown_branch
    cdef float type1_pfMet_shiftedPt_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResUp_branch
    cdef float type1_pfMet_shiftedPt_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTotalDown_branch
    cdef float type1_pfMet_shiftedPt_JetTotalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTotalUp_branch
    cdef float type1_pfMet_shiftedPt_JetTotalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesCHARGEDDown_branch
    cdef float type1_pfMet_shiftedPt_UesCHARGEDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesCHARGEDUp_branch
    cdef float type1_pfMet_shiftedPt_UesCHARGEDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesECALDown_branch
    cdef float type1_pfMet_shiftedPt_UesECALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesECALUp_branch
    cdef float type1_pfMet_shiftedPt_UesECALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHCALDown_branch
    cdef float type1_pfMet_shiftedPt_UesHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHCALUp_branch
    cdef float type1_pfMet_shiftedPt_UesHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHFDown_branch
    cdef float type1_pfMet_shiftedPt_UesHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UesHFUp_branch
    cdef float type1_pfMet_shiftedPt_UesHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnUp_value

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

    cdef TBranch* vbfJetVeto20_branch
    cdef float vbfJetVeto20_value

    cdef TBranch* vbfJetVeto30_branch
    cdef float vbfJetVeto30_value

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

    cdef TBranch* vbfMassWoNoisyJets_branch
    cdef float vbfMassWoNoisyJets_value

    cdef TBranch* vbfMassWoNoisyJets_JERDown_branch
    cdef float vbfMassWoNoisyJets_JERDown_value

    cdef TBranch* vbfMassWoNoisyJets_JERUp_branch
    cdef float vbfMassWoNoisyJets_JERUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteyearDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteyearDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteyearUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteyearUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetBBEC1Down_branch
    cdef float vbfMassWoNoisyJets_JetBBEC1Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetBBEC1Up_branch
    cdef float vbfMassWoNoisyJets_JetBBEC1Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetBBEC1yearDown_branch
    cdef float vbfMassWoNoisyJets_JetBBEC1yearDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetBBEC1yearUp_branch
    cdef float vbfMassWoNoisyJets_JetBBEC1yearUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Down_branch
    cdef float vbfMassWoNoisyJets_JetEC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Up_branch
    cdef float vbfMassWoNoisyJets_JetEC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2yearDown_branch
    cdef float vbfMassWoNoisyJets_JetEC2yearDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2yearUp_branch
    cdef float vbfMassWoNoisyJets_JetEC2yearUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetFlavorQCDDown_branch
    cdef float vbfMassWoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetFlavorQCDUp_branch
    cdef float vbfMassWoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetHFDown_branch
    cdef float vbfMassWoNoisyJets_JetHFDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetHFUp_branch
    cdef float vbfMassWoNoisyJets_JetHFUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetHFyearDown_branch
    cdef float vbfMassWoNoisyJets_JetHFyearDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetHFyearUp_branch
    cdef float vbfMassWoNoisyJets_JetHFyearUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetTotalDown_branch
    cdef float vbfMassWoNoisyJets_JetTotalDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetTotalUp_branch
    cdef float vbfMassWoNoisyJets_JetTotalUp_value

    cdef TBranch* vbfNJets20_branch
    cdef float vbfNJets20_value

    cdef TBranch* vbfNJets30_branch
    cdef float vbfNJets30_value

    cdef TBranch* vbfj1eta_branch
    cdef float vbfj1eta_value

    cdef TBranch* vbfj1pt_branch
    cdef float vbfj1pt_value

    cdef TBranch* vbfj2eta_branch
    cdef float vbfj2eta_value

    cdef TBranch* vbfj2pt_branch
    cdef float vbfj2pt_value

    cdef TBranch* vispX_branch
    cdef float vispX_value

    cdef TBranch* vispY_branch
    cdef float vispY_value

    cdef TBranch* idx_branch
    cdef int idx_value


    def __cinit__(self, ttree):
        #print "cinit"
        # Constructor from a ROOT.TTree
        from ROOT import AsCObject
        self.tree = <TTree*>PyCObject_AsVoidPtr(AsCObject(ttree))
        self.ientry = 0
        self.currentTreeNumber = -1
        #print self.tree.GetEntries()
        #self.load_entry(0)
        self.complained = set([])

    cdef load_entry(self, long i):
        #print "load", i
        # Load the correct tree and setup the branches
        self.localentry = self.tree.LoadTree(i)
        #print "local", self.localentry
        new_tree = self.tree.GetTree()
        #print "tree", <long>(new_tree)
        treenum = self.tree.GetTreeNumber()
        #print "num", treenum
        if treenum != self.currentTreeNumber or new_tree != self.currentTree:
            #print "New tree!"
            self.currentTree = new_tree
            self.currentTreeNumber = treenum
            self.setup_branches(new_tree)

    cdef setup_branches(self, TTree* the_tree):
        #print "setup"

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "ETauTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "ETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "ETauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "ETauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "ETauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "ETauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "ETauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "ETauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "ETauTree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "ETauTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "ETauTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "ETauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "ETauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "ETauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "ETauTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "ETauTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "ETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "ETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "ETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "ETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "ETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "ETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "ETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "ETauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "ETauTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "ETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "ETauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "ETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2016_DR0p5"
        self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch and "bjetDeepCSVVeto30Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch and "bjetDeepCSVVeto30Medium_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto30Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2017_DR0p5"
        self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch and "bjetDeepCSVVeto30Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch and "bjetDeepCSVVeto30Medium_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto30Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto30Medium_2018_DR0p5"
        self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch and "bjetDeepCSVVeto30Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch and "bjetDeepCSVVeto30Medium_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto30Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_2018_DR0p5_value)

        #print "making bweight_2016"
        self.bweight_2016_branch = the_tree.GetBranch("bweight_2016")
        #if not self.bweight_2016_branch and "bweight_2016" not in self.complained:
        if not self.bweight_2016_branch and "bweight_2016":
            warnings.warn( "ETauTree: Expected branch bweight_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2016")
        else:
            self.bweight_2016_branch.SetAddress(<void*>&self.bweight_2016_value)

        #print "making bweight_2017"
        self.bweight_2017_branch = the_tree.GetBranch("bweight_2017")
        #if not self.bweight_2017_branch and "bweight_2017" not in self.complained:
        if not self.bweight_2017_branch and "bweight_2017":
            warnings.warn( "ETauTree: Expected branch bweight_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2017")
        else:
            self.bweight_2017_branch.SetAddress(<void*>&self.bweight_2017_value)

        #print "making bweight_2018"
        self.bweight_2018_branch = the_tree.GetBranch("bweight_2018")
        #if not self.bweight_2018_branch and "bweight_2018" not in self.complained:
        if not self.bweight_2018_branch and "bweight_2018":
            warnings.warn( "ETauTree: Expected branch bweight_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2018")
        else:
            self.bweight_2018_branch.SetAddress(<void*>&self.bweight_2018_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "ETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making deepcsvb1_btagscore"
        self.deepcsvb1_btagscore_branch = the_tree.GetBranch("deepcsvb1_btagscore")
        #if not self.deepcsvb1_btagscore_branch and "deepcsvb1_btagscore" not in self.complained:
        if not self.deepcsvb1_btagscore_branch and "deepcsvb1_btagscore":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_btagscore does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_btagscore")
        else:
            self.deepcsvb1_btagscore_branch.SetAddress(<void*>&self.deepcsvb1_btagscore_value)

        #print "making deepcsvb1_eta"
        self.deepcsvb1_eta_branch = the_tree.GetBranch("deepcsvb1_eta")
        #if not self.deepcsvb1_eta_branch and "deepcsvb1_eta" not in self.complained:
        if not self.deepcsvb1_eta_branch and "deepcsvb1_eta":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_eta")
        else:
            self.deepcsvb1_eta_branch.SetAddress(<void*>&self.deepcsvb1_eta_value)

        #print "making deepcsvb1_hadronflavour"
        self.deepcsvb1_hadronflavour_branch = the_tree.GetBranch("deepcsvb1_hadronflavour")
        #if not self.deepcsvb1_hadronflavour_branch and "deepcsvb1_hadronflavour" not in self.complained:
        if not self.deepcsvb1_hadronflavour_branch and "deepcsvb1_hadronflavour":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_hadronflavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_hadronflavour")
        else:
            self.deepcsvb1_hadronflavour_branch.SetAddress(<void*>&self.deepcsvb1_hadronflavour_value)

        #print "making deepcsvb1_m"
        self.deepcsvb1_m_branch = the_tree.GetBranch("deepcsvb1_m")
        #if not self.deepcsvb1_m_branch and "deepcsvb1_m" not in self.complained:
        if not self.deepcsvb1_m_branch and "deepcsvb1_m":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_m does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_m")
        else:
            self.deepcsvb1_m_branch.SetAddress(<void*>&self.deepcsvb1_m_value)

        #print "making deepcsvb1_phi"
        self.deepcsvb1_phi_branch = the_tree.GetBranch("deepcsvb1_phi")
        #if not self.deepcsvb1_phi_branch and "deepcsvb1_phi" not in self.complained:
        if not self.deepcsvb1_phi_branch and "deepcsvb1_phi":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_phi")
        else:
            self.deepcsvb1_phi_branch.SetAddress(<void*>&self.deepcsvb1_phi_value)

        #print "making deepcsvb1_pt"
        self.deepcsvb1_pt_branch = the_tree.GetBranch("deepcsvb1_pt")
        #if not self.deepcsvb1_pt_branch and "deepcsvb1_pt" not in self.complained:
        if not self.deepcsvb1_pt_branch and "deepcsvb1_pt":
            warnings.warn( "ETauTree: Expected branch deepcsvb1_pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb1_pt")
        else:
            self.deepcsvb1_pt_branch.SetAddress(<void*>&self.deepcsvb1_pt_value)

        #print "making deepcsvb2_btagscore"
        self.deepcsvb2_btagscore_branch = the_tree.GetBranch("deepcsvb2_btagscore")
        #if not self.deepcsvb2_btagscore_branch and "deepcsvb2_btagscore" not in self.complained:
        if not self.deepcsvb2_btagscore_branch and "deepcsvb2_btagscore":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_btagscore does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_btagscore")
        else:
            self.deepcsvb2_btagscore_branch.SetAddress(<void*>&self.deepcsvb2_btagscore_value)

        #print "making deepcsvb2_eta"
        self.deepcsvb2_eta_branch = the_tree.GetBranch("deepcsvb2_eta")
        #if not self.deepcsvb2_eta_branch and "deepcsvb2_eta" not in self.complained:
        if not self.deepcsvb2_eta_branch and "deepcsvb2_eta":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_eta")
        else:
            self.deepcsvb2_eta_branch.SetAddress(<void*>&self.deepcsvb2_eta_value)

        #print "making deepcsvb2_hadronflavour"
        self.deepcsvb2_hadronflavour_branch = the_tree.GetBranch("deepcsvb2_hadronflavour")
        #if not self.deepcsvb2_hadronflavour_branch and "deepcsvb2_hadronflavour" not in self.complained:
        if not self.deepcsvb2_hadronflavour_branch and "deepcsvb2_hadronflavour":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_hadronflavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_hadronflavour")
        else:
            self.deepcsvb2_hadronflavour_branch.SetAddress(<void*>&self.deepcsvb2_hadronflavour_value)

        #print "making deepcsvb2_m"
        self.deepcsvb2_m_branch = the_tree.GetBranch("deepcsvb2_m")
        #if not self.deepcsvb2_m_branch and "deepcsvb2_m" not in self.complained:
        if not self.deepcsvb2_m_branch and "deepcsvb2_m":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_m does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_m")
        else:
            self.deepcsvb2_m_branch.SetAddress(<void*>&self.deepcsvb2_m_value)

        #print "making deepcsvb2_phi"
        self.deepcsvb2_phi_branch = the_tree.GetBranch("deepcsvb2_phi")
        #if not self.deepcsvb2_phi_branch and "deepcsvb2_phi" not in self.complained:
        if not self.deepcsvb2_phi_branch and "deepcsvb2_phi":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_phi")
        else:
            self.deepcsvb2_phi_branch.SetAddress(<void*>&self.deepcsvb2_phi_value)

        #print "making deepcsvb2_pt"
        self.deepcsvb2_pt_branch = the_tree.GetBranch("deepcsvb2_pt")
        #if not self.deepcsvb2_pt_branch and "deepcsvb2_pt" not in self.complained:
        if not self.deepcsvb2_pt_branch and "deepcsvb2_pt":
            warnings.warn( "ETauTree: Expected branch deepcsvb2_pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("deepcsvb2_pt")
        else:
            self.deepcsvb2_pt_branch.SetAddress(<void*>&self.deepcsvb2_pt_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "ETauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "ETauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "ETauTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eComesFromHiggs"
        self.eComesFromHiggs_branch = the_tree.GetBranch("eComesFromHiggs")
        #if not self.eComesFromHiggs_branch and "eComesFromHiggs" not in self.complained:
        if not self.eComesFromHiggs_branch and "eComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch eComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eComesFromHiggs")
        else:
            self.eComesFromHiggs_branch.SetAddress(<void*>&self.eComesFromHiggs_value)

        #print "making eCorrectedEt"
        self.eCorrectedEt_branch = the_tree.GetBranch("eCorrectedEt")
        #if not self.eCorrectedEt_branch and "eCorrectedEt" not in self.complained:
        if not self.eCorrectedEt_branch and "eCorrectedEt":
            warnings.warn( "ETauTree: Expected branch eCorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCorrectedEt")
        else:
            self.eCorrectedEt_branch.SetAddress(<void*>&self.eCorrectedEt_value)

        #print "making eEnergyError"
        self.eEnergyError_branch = the_tree.GetBranch("eEnergyError")
        #if not self.eEnergyError_branch and "eEnergyError" not in self.complained:
        if not self.eEnergyError_branch and "eEnergyError":
            warnings.warn( "ETauTree: Expected branch eEnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyError")
        else:
            self.eEnergyError_branch.SetAddress(<void*>&self.eEnergyError_value)

        #print "making eEnergyScaleDown"
        self.eEnergyScaleDown_branch = the_tree.GetBranch("eEnergyScaleDown")
        #if not self.eEnergyScaleDown_branch and "eEnergyScaleDown" not in self.complained:
        if not self.eEnergyScaleDown_branch and "eEnergyScaleDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleDown")
        else:
            self.eEnergyScaleDown_branch.SetAddress(<void*>&self.eEnergyScaleDown_value)

        #print "making eEnergyScaleGainDown"
        self.eEnergyScaleGainDown_branch = the_tree.GetBranch("eEnergyScaleGainDown")
        #if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown" not in self.complained:
        if not self.eEnergyScaleGainDown_branch and "eEnergyScaleGainDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainDown")
        else:
            self.eEnergyScaleGainDown_branch.SetAddress(<void*>&self.eEnergyScaleGainDown_value)

        #print "making eEnergyScaleGainUp"
        self.eEnergyScaleGainUp_branch = the_tree.GetBranch("eEnergyScaleGainUp")
        #if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp" not in self.complained:
        if not self.eEnergyScaleGainUp_branch and "eEnergyScaleGainUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleGainUp")
        else:
            self.eEnergyScaleGainUp_branch.SetAddress(<void*>&self.eEnergyScaleGainUp_value)

        #print "making eEnergyScaleStatDown"
        self.eEnergyScaleStatDown_branch = the_tree.GetBranch("eEnergyScaleStatDown")
        #if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown" not in self.complained:
        if not self.eEnergyScaleStatDown_branch and "eEnergyScaleStatDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatDown")
        else:
            self.eEnergyScaleStatDown_branch.SetAddress(<void*>&self.eEnergyScaleStatDown_value)

        #print "making eEnergyScaleStatUp"
        self.eEnergyScaleStatUp_branch = the_tree.GetBranch("eEnergyScaleStatUp")
        #if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp" not in self.complained:
        if not self.eEnergyScaleStatUp_branch and "eEnergyScaleStatUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleStatUp")
        else:
            self.eEnergyScaleStatUp_branch.SetAddress(<void*>&self.eEnergyScaleStatUp_value)

        #print "making eEnergyScaleSystDown"
        self.eEnergyScaleSystDown_branch = the_tree.GetBranch("eEnergyScaleSystDown")
        #if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown" not in self.complained:
        if not self.eEnergyScaleSystDown_branch and "eEnergyScaleSystDown":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystDown")
        else:
            self.eEnergyScaleSystDown_branch.SetAddress(<void*>&self.eEnergyScaleSystDown_value)

        #print "making eEnergyScaleSystUp"
        self.eEnergyScaleSystUp_branch = the_tree.GetBranch("eEnergyScaleSystUp")
        #if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp" not in self.complained:
        if not self.eEnergyScaleSystUp_branch and "eEnergyScaleSystUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleSystUp")
        else:
            self.eEnergyScaleSystUp_branch.SetAddress(<void*>&self.eEnergyScaleSystUp_value)

        #print "making eEnergyScaleUp"
        self.eEnergyScaleUp_branch = the_tree.GetBranch("eEnergyScaleUp")
        #if not self.eEnergyScaleUp_branch and "eEnergyScaleUp" not in self.complained:
        if not self.eEnergyScaleUp_branch and "eEnergyScaleUp":
            warnings.warn( "ETauTree: Expected branch eEnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergyScaleUp")
        else:
            self.eEnergyScaleUp_branch.SetAddress(<void*>&self.eEnergyScaleUp_value)

        #print "making eEnergySigmaDown"
        self.eEnergySigmaDown_branch = the_tree.GetBranch("eEnergySigmaDown")
        #if not self.eEnergySigmaDown_branch and "eEnergySigmaDown" not in self.complained:
        if not self.eEnergySigmaDown_branch and "eEnergySigmaDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaDown")
        else:
            self.eEnergySigmaDown_branch.SetAddress(<void*>&self.eEnergySigmaDown_value)

        #print "making eEnergySigmaPhiDown"
        self.eEnergySigmaPhiDown_branch = the_tree.GetBranch("eEnergySigmaPhiDown")
        #if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown" not in self.complained:
        if not self.eEnergySigmaPhiDown_branch and "eEnergySigmaPhiDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiDown")
        else:
            self.eEnergySigmaPhiDown_branch.SetAddress(<void*>&self.eEnergySigmaPhiDown_value)

        #print "making eEnergySigmaPhiUp"
        self.eEnergySigmaPhiUp_branch = the_tree.GetBranch("eEnergySigmaPhiUp")
        #if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp" not in self.complained:
        if not self.eEnergySigmaPhiUp_branch and "eEnergySigmaPhiUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaPhiUp")
        else:
            self.eEnergySigmaPhiUp_branch.SetAddress(<void*>&self.eEnergySigmaPhiUp_value)

        #print "making eEnergySigmaRhoDown"
        self.eEnergySigmaRhoDown_branch = the_tree.GetBranch("eEnergySigmaRhoDown")
        #if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown" not in self.complained:
        if not self.eEnergySigmaRhoDown_branch and "eEnergySigmaRhoDown":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoDown")
        else:
            self.eEnergySigmaRhoDown_branch.SetAddress(<void*>&self.eEnergySigmaRhoDown_value)

        #print "making eEnergySigmaRhoUp"
        self.eEnergySigmaRhoUp_branch = the_tree.GetBranch("eEnergySigmaRhoUp")
        #if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp" not in self.complained:
        if not self.eEnergySigmaRhoUp_branch and "eEnergySigmaRhoUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaRhoUp")
        else:
            self.eEnergySigmaRhoUp_branch.SetAddress(<void*>&self.eEnergySigmaRhoUp_value)

        #print "making eEnergySigmaUp"
        self.eEnergySigmaUp_branch = the_tree.GetBranch("eEnergySigmaUp")
        #if not self.eEnergySigmaUp_branch and "eEnergySigmaUp" not in self.complained:
        if not self.eEnergySigmaUp_branch and "eEnergySigmaUp":
            warnings.warn( "ETauTree: Expected branch eEnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEnergySigmaUp")
        else:
            self.eEnergySigmaUp_branch.SetAddress(<void*>&self.eEnergySigmaUp_value)

        #print "making eEta"
        self.eEta_branch = the_tree.GetBranch("eEta")
        #if not self.eEta_branch and "eEta" not in self.complained:
        if not self.eEta_branch and "eEta":
            warnings.warn( "ETauTree: Expected branch eEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEta")
        else:
            self.eEta_branch.SetAddress(<void*>&self.eEta_value)

        #print "making eGenCharge"
        self.eGenCharge_branch = the_tree.GetBranch("eGenCharge")
        #if not self.eGenCharge_branch and "eGenCharge" not in self.complained:
        if not self.eGenCharge_branch and "eGenCharge":
            warnings.warn( "ETauTree: Expected branch eGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenCharge")
        else:
            self.eGenCharge_branch.SetAddress(<void*>&self.eGenCharge_value)

        #print "making eGenDirectPromptTauDecay"
        self.eGenDirectPromptTauDecay_branch = the_tree.GetBranch("eGenDirectPromptTauDecay")
        #if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay" not in self.complained:
        if not self.eGenDirectPromptTauDecay_branch and "eGenDirectPromptTauDecay":
            warnings.warn( "ETauTree: Expected branch eGenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenDirectPromptTauDecay")
        else:
            self.eGenDirectPromptTauDecay_branch.SetAddress(<void*>&self.eGenDirectPromptTauDecay_value)

        #print "making eGenEnergy"
        self.eGenEnergy_branch = the_tree.GetBranch("eGenEnergy")
        #if not self.eGenEnergy_branch and "eGenEnergy" not in self.complained:
        if not self.eGenEnergy_branch and "eGenEnergy":
            warnings.warn( "ETauTree: Expected branch eGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEnergy")
        else:
            self.eGenEnergy_branch.SetAddress(<void*>&self.eGenEnergy_value)

        #print "making eGenEta"
        self.eGenEta_branch = the_tree.GetBranch("eGenEta")
        #if not self.eGenEta_branch and "eGenEta" not in self.complained:
        if not self.eGenEta_branch and "eGenEta":
            warnings.warn( "ETauTree: Expected branch eGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenEta")
        else:
            self.eGenEta_branch.SetAddress(<void*>&self.eGenEta_value)

        #print "making eGenIsPrompt"
        self.eGenIsPrompt_branch = the_tree.GetBranch("eGenIsPrompt")
        #if not self.eGenIsPrompt_branch and "eGenIsPrompt" not in self.complained:
        if not self.eGenIsPrompt_branch and "eGenIsPrompt":
            warnings.warn( "ETauTree: Expected branch eGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenIsPrompt")
        else:
            self.eGenIsPrompt_branch.SetAddress(<void*>&self.eGenIsPrompt_value)

        #print "making eGenMotherPdgId"
        self.eGenMotherPdgId_branch = the_tree.GetBranch("eGenMotherPdgId")
        #if not self.eGenMotherPdgId_branch and "eGenMotherPdgId" not in self.complained:
        if not self.eGenMotherPdgId_branch and "eGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch eGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenMotherPdgId")
        else:
            self.eGenMotherPdgId_branch.SetAddress(<void*>&self.eGenMotherPdgId_value)

        #print "making eGenParticle"
        self.eGenParticle_branch = the_tree.GetBranch("eGenParticle")
        #if not self.eGenParticle_branch and "eGenParticle" not in self.complained:
        if not self.eGenParticle_branch and "eGenParticle":
            warnings.warn( "ETauTree: Expected branch eGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenParticle")
        else:
            self.eGenParticle_branch.SetAddress(<void*>&self.eGenParticle_value)

        #print "making eGenPdgId"
        self.eGenPdgId_branch = the_tree.GetBranch("eGenPdgId")
        #if not self.eGenPdgId_branch and "eGenPdgId" not in self.complained:
        if not self.eGenPdgId_branch and "eGenPdgId":
            warnings.warn( "ETauTree: Expected branch eGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPdgId")
        else:
            self.eGenPdgId_branch.SetAddress(<void*>&self.eGenPdgId_value)

        #print "making eGenPhi"
        self.eGenPhi_branch = the_tree.GetBranch("eGenPhi")
        #if not self.eGenPhi_branch and "eGenPhi" not in self.complained:
        if not self.eGenPhi_branch and "eGenPhi":
            warnings.warn( "ETauTree: Expected branch eGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPhi")
        else:
            self.eGenPhi_branch.SetAddress(<void*>&self.eGenPhi_value)

        #print "making eGenPrompt"
        self.eGenPrompt_branch = the_tree.GetBranch("eGenPrompt")
        #if not self.eGenPrompt_branch and "eGenPrompt" not in self.complained:
        if not self.eGenPrompt_branch and "eGenPrompt":
            warnings.warn( "ETauTree: Expected branch eGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPrompt")
        else:
            self.eGenPrompt_branch.SetAddress(<void*>&self.eGenPrompt_value)

        #print "making eGenPromptTauDecay"
        self.eGenPromptTauDecay_branch = the_tree.GetBranch("eGenPromptTauDecay")
        #if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay" not in self.complained:
        if not self.eGenPromptTauDecay_branch and "eGenPromptTauDecay":
            warnings.warn( "ETauTree: Expected branch eGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPromptTauDecay")
        else:
            self.eGenPromptTauDecay_branch.SetAddress(<void*>&self.eGenPromptTauDecay_value)

        #print "making eGenPt"
        self.eGenPt_branch = the_tree.GetBranch("eGenPt")
        #if not self.eGenPt_branch and "eGenPt" not in self.complained:
        if not self.eGenPt_branch and "eGenPt":
            warnings.warn( "ETauTree: Expected branch eGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenPt")
        else:
            self.eGenPt_branch.SetAddress(<void*>&self.eGenPt_value)

        #print "making eGenTauDecay"
        self.eGenTauDecay_branch = the_tree.GetBranch("eGenTauDecay")
        #if not self.eGenTauDecay_branch and "eGenTauDecay" not in self.complained:
        if not self.eGenTauDecay_branch and "eGenTauDecay":
            warnings.warn( "ETauTree: Expected branch eGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenTauDecay")
        else:
            self.eGenTauDecay_branch.SetAddress(<void*>&self.eGenTauDecay_value)

        #print "making eGenVZ"
        self.eGenVZ_branch = the_tree.GetBranch("eGenVZ")
        #if not self.eGenVZ_branch and "eGenVZ" not in self.complained:
        if not self.eGenVZ_branch and "eGenVZ":
            warnings.warn( "ETauTree: Expected branch eGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVZ")
        else:
            self.eGenVZ_branch.SetAddress(<void*>&self.eGenVZ_value)

        #print "making eGenVtxPVMatch"
        self.eGenVtxPVMatch_branch = the_tree.GetBranch("eGenVtxPVMatch")
        #if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch" not in self.complained:
        if not self.eGenVtxPVMatch_branch and "eGenVtxPVMatch":
            warnings.warn( "ETauTree: Expected branch eGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eGenVtxPVMatch")
        else:
            self.eGenVtxPVMatch_branch.SetAddress(<void*>&self.eGenVtxPVMatch_value)

        #print "making eIP3D"
        self.eIP3D_branch = the_tree.GetBranch("eIP3D")
        #if not self.eIP3D_branch and "eIP3D" not in self.complained:
        if not self.eIP3D_branch and "eIP3D":
            warnings.warn( "ETauTree: Expected branch eIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3D")
        else:
            self.eIP3D_branch.SetAddress(<void*>&self.eIP3D_value)

        #print "making eIP3DErr"
        self.eIP3DErr_branch = the_tree.GetBranch("eIP3DErr")
        #if not self.eIP3DErr_branch and "eIP3DErr" not in self.complained:
        if not self.eIP3DErr_branch and "eIP3DErr":
            warnings.warn( "ETauTree: Expected branch eIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIP3DErr")
        else:
            self.eIP3DErr_branch.SetAddress(<void*>&self.eIP3DErr_value)

        #print "making eIsoDB03"
        self.eIsoDB03_branch = the_tree.GetBranch("eIsoDB03")
        #if not self.eIsoDB03_branch and "eIsoDB03" not in self.complained:
        if not self.eIsoDB03_branch and "eIsoDB03":
            warnings.warn( "ETauTree: Expected branch eIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eIsoDB03")
        else:
            self.eIsoDB03_branch.SetAddress(<void*>&self.eIsoDB03_value)

        #print "making eJetArea"
        self.eJetArea_branch = the_tree.GetBranch("eJetArea")
        #if not self.eJetArea_branch and "eJetArea" not in self.complained:
        if not self.eJetArea_branch and "eJetArea":
            warnings.warn( "ETauTree: Expected branch eJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetArea")
        else:
            self.eJetArea_branch.SetAddress(<void*>&self.eJetArea_value)

        #print "making eJetBtag"
        self.eJetBtag_branch = the_tree.GetBranch("eJetBtag")
        #if not self.eJetBtag_branch and "eJetBtag" not in self.complained:
        if not self.eJetBtag_branch and "eJetBtag":
            warnings.warn( "ETauTree: Expected branch eJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetBtag")
        else:
            self.eJetBtag_branch.SetAddress(<void*>&self.eJetBtag_value)

        #print "making eJetDR"
        self.eJetDR_branch = the_tree.GetBranch("eJetDR")
        #if not self.eJetDR_branch and "eJetDR" not in self.complained:
        if not self.eJetDR_branch and "eJetDR":
            warnings.warn( "ETauTree: Expected branch eJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetDR")
        else:
            self.eJetDR_branch.SetAddress(<void*>&self.eJetDR_value)

        #print "making eJetEtaEtaMoment"
        self.eJetEtaEtaMoment_branch = the_tree.GetBranch("eJetEtaEtaMoment")
        #if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment" not in self.complained:
        if not self.eJetEtaEtaMoment_branch and "eJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaEtaMoment")
        else:
            self.eJetEtaEtaMoment_branch.SetAddress(<void*>&self.eJetEtaEtaMoment_value)

        #print "making eJetEtaPhiMoment"
        self.eJetEtaPhiMoment_branch = the_tree.GetBranch("eJetEtaPhiMoment")
        #if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment" not in self.complained:
        if not self.eJetEtaPhiMoment_branch and "eJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiMoment")
        else:
            self.eJetEtaPhiMoment_branch.SetAddress(<void*>&self.eJetEtaPhiMoment_value)

        #print "making eJetEtaPhiSpread"
        self.eJetEtaPhiSpread_branch = the_tree.GetBranch("eJetEtaPhiSpread")
        #if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread" not in self.complained:
        if not self.eJetEtaPhiSpread_branch and "eJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch eJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetEtaPhiSpread")
        else:
            self.eJetEtaPhiSpread_branch.SetAddress(<void*>&self.eJetEtaPhiSpread_value)

        #print "making eJetHadronFlavour"
        self.eJetHadronFlavour_branch = the_tree.GetBranch("eJetHadronFlavour")
        #if not self.eJetHadronFlavour_branch and "eJetHadronFlavour" not in self.complained:
        if not self.eJetHadronFlavour_branch and "eJetHadronFlavour":
            warnings.warn( "ETauTree: Expected branch eJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetHadronFlavour")
        else:
            self.eJetHadronFlavour_branch.SetAddress(<void*>&self.eJetHadronFlavour_value)

        #print "making eJetPFCISVBtag"
        self.eJetPFCISVBtag_branch = the_tree.GetBranch("eJetPFCISVBtag")
        #if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag" not in self.complained:
        if not self.eJetPFCISVBtag_branch and "eJetPFCISVBtag":
            warnings.warn( "ETauTree: Expected branch eJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPFCISVBtag")
        else:
            self.eJetPFCISVBtag_branch.SetAddress(<void*>&self.eJetPFCISVBtag_value)

        #print "making eJetPartonFlavour"
        self.eJetPartonFlavour_branch = the_tree.GetBranch("eJetPartonFlavour")
        #if not self.eJetPartonFlavour_branch and "eJetPartonFlavour" not in self.complained:
        if not self.eJetPartonFlavour_branch and "eJetPartonFlavour":
            warnings.warn( "ETauTree: Expected branch eJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPartonFlavour")
        else:
            self.eJetPartonFlavour_branch.SetAddress(<void*>&self.eJetPartonFlavour_value)

        #print "making eJetPhiPhiMoment"
        self.eJetPhiPhiMoment_branch = the_tree.GetBranch("eJetPhiPhiMoment")
        #if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment" not in self.complained:
        if not self.eJetPhiPhiMoment_branch and "eJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch eJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPhiPhiMoment")
        else:
            self.eJetPhiPhiMoment_branch.SetAddress(<void*>&self.eJetPhiPhiMoment_value)

        #print "making eJetPt"
        self.eJetPt_branch = the_tree.GetBranch("eJetPt")
        #if not self.eJetPt_branch and "eJetPt" not in self.complained:
        if not self.eJetPt_branch and "eJetPt":
            warnings.warn( "ETauTree: Expected branch eJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eJetPt")
        else:
            self.eJetPt_branch.SetAddress(<void*>&self.eJetPt_value)

        #print "making eMVAIsoWP80"
        self.eMVAIsoWP80_branch = the_tree.GetBranch("eMVAIsoWP80")
        #if not self.eMVAIsoWP80_branch and "eMVAIsoWP80" not in self.complained:
        if not self.eMVAIsoWP80_branch and "eMVAIsoWP80":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP80")
        else:
            self.eMVAIsoWP80_branch.SetAddress(<void*>&self.eMVAIsoWP80_value)

        #print "making eMVAIsoWP90"
        self.eMVAIsoWP90_branch = the_tree.GetBranch("eMVAIsoWP90")
        #if not self.eMVAIsoWP90_branch and "eMVAIsoWP90" not in self.complained:
        if not self.eMVAIsoWP90_branch and "eMVAIsoWP90":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWP90")
        else:
            self.eMVAIsoWP90_branch.SetAddress(<void*>&self.eMVAIsoWP90_value)

        #print "making eMVANoisoWP80"
        self.eMVANoisoWP80_branch = the_tree.GetBranch("eMVANoisoWP80")
        #if not self.eMVANoisoWP80_branch and "eMVANoisoWP80" not in self.complained:
        if not self.eMVANoisoWP80_branch and "eMVANoisoWP80":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP80")
        else:
            self.eMVANoisoWP80_branch.SetAddress(<void*>&self.eMVANoisoWP80_value)

        #print "making eMVANoisoWP90"
        self.eMVANoisoWP90_branch = the_tree.GetBranch("eMVANoisoWP90")
        #if not self.eMVANoisoWP90_branch and "eMVANoisoWP90" not in self.complained:
        if not self.eMVANoisoWP90_branch and "eMVANoisoWP90":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWP90")
        else:
            self.eMVANoisoWP90_branch.SetAddress(<void*>&self.eMVANoisoWP90_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "ETauTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

        #print "making eMatchEmbeddedFilterEle24Tau30"
        self.eMatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle24Tau30")
        #if not self.eMatchEmbeddedFilterEle24Tau30_branch and "eMatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.eMatchEmbeddedFilterEle24Tau30_branch and "eMatchEmbeddedFilterEle24Tau30":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle24Tau30")
        else:
            self.eMatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle24Tau30_value)

        #print "making eMatchEmbeddedFilterEle27"
        self.eMatchEmbeddedFilterEle27_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle27")
        #if not self.eMatchEmbeddedFilterEle27_branch and "eMatchEmbeddedFilterEle27" not in self.complained:
        if not self.eMatchEmbeddedFilterEle27_branch and "eMatchEmbeddedFilterEle27":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle27")
        else:
            self.eMatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle27_value)

        #print "making eMatchEmbeddedFilterEle32"
        self.eMatchEmbeddedFilterEle32_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32")
        #if not self.eMatchEmbeddedFilterEle32_branch and "eMatchEmbeddedFilterEle32" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32_branch and "eMatchEmbeddedFilterEle32":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32")
        else:
            self.eMatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32_value)

        #print "making eMatchEmbeddedFilterEle32DoubleL1_v1"
        self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch and "eMatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch and "eMatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making eMatchEmbeddedFilterEle32DoubleL1_v2"
        self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch and "eMatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch and "eMatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making eMatchEmbeddedFilterEle35"
        self.eMatchEmbeddedFilterEle35_branch = the_tree.GetBranch("eMatchEmbeddedFilterEle35")
        #if not self.eMatchEmbeddedFilterEle35_branch and "eMatchEmbeddedFilterEle35" not in self.complained:
        if not self.eMatchEmbeddedFilterEle35_branch and "eMatchEmbeddedFilterEle35":
            warnings.warn( "ETauTree: Expected branch eMatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchEmbeddedFilterEle35")
        else:
            self.eMatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.eMatchEmbeddedFilterEle35_value)

        #print "making eMatchesEle24HPSTau30Filter"
        self.eMatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("eMatchesEle24HPSTau30Filter")
        #if not self.eMatchesEle24HPSTau30Filter_branch and "eMatchesEle24HPSTau30Filter" not in self.complained:
        if not self.eMatchesEle24HPSTau30Filter_branch and "eMatchesEle24HPSTau30Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24HPSTau30Filter")
        else:
            self.eMatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24HPSTau30Filter_value)

        #print "making eMatchesEle24HPSTau30Path"
        self.eMatchesEle24HPSTau30Path_branch = the_tree.GetBranch("eMatchesEle24HPSTau30Path")
        #if not self.eMatchesEle24HPSTau30Path_branch and "eMatchesEle24HPSTau30Path" not in self.complained:
        if not self.eMatchesEle24HPSTau30Path_branch and "eMatchesEle24HPSTau30Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24HPSTau30Path")
        else:
            self.eMatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.eMatchesEle24HPSTau30Path_value)

        #print "making eMatchesEle24Tau30Filter"
        self.eMatchesEle24Tau30Filter_branch = the_tree.GetBranch("eMatchesEle24Tau30Filter")
        #if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter" not in self.complained:
        if not self.eMatchesEle24Tau30Filter_branch and "eMatchesEle24Tau30Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Filter")
        else:
            self.eMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Filter_value)

        #print "making eMatchesEle24Tau30Path"
        self.eMatchesEle24Tau30Path_branch = the_tree.GetBranch("eMatchesEle24Tau30Path")
        #if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path" not in self.complained:
        if not self.eMatchesEle24Tau30Path_branch and "eMatchesEle24Tau30Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle24Tau30Path")
        else:
            self.eMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.eMatchesEle24Tau30Path_value)

        #print "making eMatchesEle25Filter"
        self.eMatchesEle25Filter_branch = the_tree.GetBranch("eMatchesEle25Filter")
        #if not self.eMatchesEle25Filter_branch and "eMatchesEle25Filter" not in self.complained:
        if not self.eMatchesEle25Filter_branch and "eMatchesEle25Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25Filter")
        else:
            self.eMatchesEle25Filter_branch.SetAddress(<void*>&self.eMatchesEle25Filter_value)

        #print "making eMatchesEle25Path"
        self.eMatchesEle25Path_branch = the_tree.GetBranch("eMatchesEle25Path")
        #if not self.eMatchesEle25Path_branch and "eMatchesEle25Path" not in self.complained:
        if not self.eMatchesEle25Path_branch and "eMatchesEle25Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle25Path")
        else:
            self.eMatchesEle25Path_branch.SetAddress(<void*>&self.eMatchesEle25Path_value)

        #print "making eMatchesEle27Filter"
        self.eMatchesEle27Filter_branch = the_tree.GetBranch("eMatchesEle27Filter")
        #if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter" not in self.complained:
        if not self.eMatchesEle27Filter_branch and "eMatchesEle27Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Filter")
        else:
            self.eMatchesEle27Filter_branch.SetAddress(<void*>&self.eMatchesEle27Filter_value)

        #print "making eMatchesEle27Path"
        self.eMatchesEle27Path_branch = the_tree.GetBranch("eMatchesEle27Path")
        #if not self.eMatchesEle27Path_branch and "eMatchesEle27Path" not in self.complained:
        if not self.eMatchesEle27Path_branch and "eMatchesEle27Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle27Path")
        else:
            self.eMatchesEle27Path_branch.SetAddress(<void*>&self.eMatchesEle27Path_value)

        #print "making eMatchesEle32Filter"
        self.eMatchesEle32Filter_branch = the_tree.GetBranch("eMatchesEle32Filter")
        #if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter" not in self.complained:
        if not self.eMatchesEle32Filter_branch and "eMatchesEle32Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Filter")
        else:
            self.eMatchesEle32Filter_branch.SetAddress(<void*>&self.eMatchesEle32Filter_value)

        #print "making eMatchesEle32Path"
        self.eMatchesEle32Path_branch = the_tree.GetBranch("eMatchesEle32Path")
        #if not self.eMatchesEle32Path_branch and "eMatchesEle32Path" not in self.complained:
        if not self.eMatchesEle32Path_branch and "eMatchesEle32Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle32Path")
        else:
            self.eMatchesEle32Path_branch.SetAddress(<void*>&self.eMatchesEle32Path_value)

        #print "making eMatchesEle35Filter"
        self.eMatchesEle35Filter_branch = the_tree.GetBranch("eMatchesEle35Filter")
        #if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter" not in self.complained:
        if not self.eMatchesEle35Filter_branch and "eMatchesEle35Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Filter")
        else:
            self.eMatchesEle35Filter_branch.SetAddress(<void*>&self.eMatchesEle35Filter_value)

        #print "making eMatchesEle35Path"
        self.eMatchesEle35Path_branch = the_tree.GetBranch("eMatchesEle35Path")
        #if not self.eMatchesEle35Path_branch and "eMatchesEle35Path" not in self.complained:
        if not self.eMatchesEle35Path_branch and "eMatchesEle35Path":
            warnings.warn( "ETauTree: Expected branch eMatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesEle35Path")
        else:
            self.eMatchesEle35Path_branch.SetAddress(<void*>&self.eMatchesEle35Path_value)

        #print "making eMatchesMu23e12DZFilter"
        self.eMatchesMu23e12DZFilter_branch = the_tree.GetBranch("eMatchesMu23e12DZFilter")
        #if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter" not in self.complained:
        if not self.eMatchesMu23e12DZFilter_branch and "eMatchesMu23e12DZFilter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZFilter")
        else:
            self.eMatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.eMatchesMu23e12DZFilter_value)

        #print "making eMatchesMu23e12DZPath"
        self.eMatchesMu23e12DZPath_branch = the_tree.GetBranch("eMatchesMu23e12DZPath")
        #if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath" not in self.complained:
        if not self.eMatchesMu23e12DZPath_branch and "eMatchesMu23e12DZPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12DZPath")
        else:
            self.eMatchesMu23e12DZPath_branch.SetAddress(<void*>&self.eMatchesMu23e12DZPath_value)

        #print "making eMatchesMu23e12Filter"
        self.eMatchesMu23e12Filter_branch = the_tree.GetBranch("eMatchesMu23e12Filter")
        #if not self.eMatchesMu23e12Filter_branch and "eMatchesMu23e12Filter" not in self.complained:
        if not self.eMatchesMu23e12Filter_branch and "eMatchesMu23e12Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12Filter")
        else:
            self.eMatchesMu23e12Filter_branch.SetAddress(<void*>&self.eMatchesMu23e12Filter_value)

        #print "making eMatchesMu23e12Path"
        self.eMatchesMu23e12Path_branch = the_tree.GetBranch("eMatchesMu23e12Path")
        #if not self.eMatchesMu23e12Path_branch and "eMatchesMu23e12Path" not in self.complained:
        if not self.eMatchesMu23e12Path_branch and "eMatchesMu23e12Path":
            warnings.warn( "ETauTree: Expected branch eMatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu23e12Path")
        else:
            self.eMatchesMu23e12Path_branch.SetAddress(<void*>&self.eMatchesMu23e12Path_value)

        #print "making eMatchesMu8e23DZFilter"
        self.eMatchesMu8e23DZFilter_branch = the_tree.GetBranch("eMatchesMu8e23DZFilter")
        #if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter" not in self.complained:
        if not self.eMatchesMu8e23DZFilter_branch and "eMatchesMu8e23DZFilter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZFilter")
        else:
            self.eMatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.eMatchesMu8e23DZFilter_value)

        #print "making eMatchesMu8e23DZPath"
        self.eMatchesMu8e23DZPath_branch = the_tree.GetBranch("eMatchesMu8e23DZPath")
        #if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath" not in self.complained:
        if not self.eMatchesMu8e23DZPath_branch and "eMatchesMu8e23DZPath":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23DZPath")
        else:
            self.eMatchesMu8e23DZPath_branch.SetAddress(<void*>&self.eMatchesMu8e23DZPath_value)

        #print "making eMatchesMu8e23Filter"
        self.eMatchesMu8e23Filter_branch = the_tree.GetBranch("eMatchesMu8e23Filter")
        #if not self.eMatchesMu8e23Filter_branch and "eMatchesMu8e23Filter" not in self.complained:
        if not self.eMatchesMu8e23Filter_branch and "eMatchesMu8e23Filter":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23Filter")
        else:
            self.eMatchesMu8e23Filter_branch.SetAddress(<void*>&self.eMatchesMu8e23Filter_value)

        #print "making eMatchesMu8e23Path"
        self.eMatchesMu8e23Path_branch = the_tree.GetBranch("eMatchesMu8e23Path")
        #if not self.eMatchesMu8e23Path_branch and "eMatchesMu8e23Path" not in self.complained:
        if not self.eMatchesMu8e23Path_branch and "eMatchesMu8e23Path":
            warnings.warn( "ETauTree: Expected branch eMatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMatchesMu8e23Path")
        else:
            self.eMatchesMu8e23Path_branch.SetAddress(<void*>&self.eMatchesMu8e23Path_value)

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "ETauTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making ePVDXY"
        self.ePVDXY_branch = the_tree.GetBranch("ePVDXY")
        #if not self.ePVDXY_branch and "ePVDXY" not in self.complained:
        if not self.ePVDXY_branch and "ePVDXY":
            warnings.warn( "ETauTree: Expected branch ePVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDXY")
        else:
            self.ePVDXY_branch.SetAddress(<void*>&self.ePVDXY_value)

        #print "making ePVDZ"
        self.ePVDZ_branch = the_tree.GetBranch("ePVDZ")
        #if not self.ePVDZ_branch and "ePVDZ" not in self.complained:
        if not self.ePVDZ_branch and "ePVDZ":
            warnings.warn( "ETauTree: Expected branch ePVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePVDZ")
        else:
            self.ePVDZ_branch.SetAddress(<void*>&self.ePVDZ_value)

        #print "making ePassesConversionVeto"
        self.ePassesConversionVeto_branch = the_tree.GetBranch("ePassesConversionVeto")
        #if not self.ePassesConversionVeto_branch and "ePassesConversionVeto" not in self.complained:
        if not self.ePassesConversionVeto_branch and "ePassesConversionVeto":
            warnings.warn( "ETauTree: Expected branch ePassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePassesConversionVeto")
        else:
            self.ePassesConversionVeto_branch.SetAddress(<void*>&self.ePassesConversionVeto_value)

        #print "making ePhi"
        self.ePhi_branch = the_tree.GetBranch("ePhi")
        #if not self.ePhi_branch and "ePhi" not in self.complained:
        if not self.ePhi_branch and "ePhi":
            warnings.warn( "ETauTree: Expected branch ePhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePhi")
        else:
            self.ePhi_branch.SetAddress(<void*>&self.ePhi_value)

        #print "making ePt"
        self.ePt_branch = the_tree.GetBranch("ePt")
        #if not self.ePt_branch and "ePt" not in self.complained:
        if not self.ePt_branch and "ePt":
            warnings.warn( "ETauTree: Expected branch ePt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePt")
        else:
            self.ePt_branch.SetAddress(<void*>&self.ePt_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eSIP2D"
        self.eSIP2D_branch = the_tree.GetBranch("eSIP2D")
        #if not self.eSIP2D_branch and "eSIP2D" not in self.complained:
        if not self.eSIP2D_branch and "eSIP2D":
            warnings.warn( "ETauTree: Expected branch eSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP2D")
        else:
            self.eSIP2D_branch.SetAddress(<void*>&self.eSIP2D_value)

        #print "making eSIP3D"
        self.eSIP3D_branch = the_tree.GetBranch("eSIP3D")
        #if not self.eSIP3D_branch and "eSIP3D" not in self.complained:
        if not self.eSIP3D_branch and "eSIP3D":
            warnings.warn( "ETauTree: Expected branch eSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSIP3D")
        else:
            self.eSIP3D_branch.SetAddress(<void*>&self.eSIP3D_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "ETauTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "ETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eZTTGenMatching"
        self.eZTTGenMatching_branch = the_tree.GetBranch("eZTTGenMatching")
        #if not self.eZTTGenMatching_branch and "eZTTGenMatching" not in self.complained:
        if not self.eZTTGenMatching_branch and "eZTTGenMatching":
            warnings.warn( "ETauTree: Expected branch eZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenMatching")
        else:
            self.eZTTGenMatching_branch.SetAddress(<void*>&self.eZTTGenMatching_value)

        #print "making e_t_PZeta"
        self.e_t_PZeta_branch = the_tree.GetBranch("e_t_PZeta")
        #if not self.e_t_PZeta_branch and "e_t_PZeta" not in self.complained:
        if not self.e_t_PZeta_branch and "e_t_PZeta":
            warnings.warn( "ETauTree: Expected branch e_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZeta")
        else:
            self.e_t_PZeta_branch.SetAddress(<void*>&self.e_t_PZeta_value)

        #print "making e_t_PZetaVis"
        self.e_t_PZetaVis_branch = the_tree.GetBranch("e_t_PZetaVis")
        #if not self.e_t_PZetaVis_branch and "e_t_PZetaVis" not in self.complained:
        if not self.e_t_PZetaVis_branch and "e_t_PZetaVis":
            warnings.warn( "ETauTree: Expected branch e_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_PZetaVis")
        else:
            self.e_t_PZetaVis_branch.SetAddress(<void*>&self.e_t_PZetaVis_value)

        #print "making e_t_doubleL1IsoTauMatch"
        self.e_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e_t_doubleL1IsoTauMatch")
        #if not self.e_t_doubleL1IsoTauMatch_branch and "e_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.e_t_doubleL1IsoTauMatch_branch and "e_t_doubleL1IsoTauMatch":
            warnings.warn( "ETauTree: Expected branch e_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_doubleL1IsoTauMatch")
        else:
            self.e_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e_t_doubleL1IsoTauMatch_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "ETauTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "ETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "ETauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "ETauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "ETauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "ETauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "ETauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "ETauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "ETauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "ETauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "ETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "ETauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "ETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "ETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "ETauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "ETauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "ETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "ETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "ETauTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "ETauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "ETauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "ETauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "ETauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "ETauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j1ptWoNoisyJets_JERDown"
        self.j1ptWoNoisyJets_JERDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JERDown")
        #if not self.j1ptWoNoisyJets_JERDown_branch and "j1ptWoNoisyJets_JERDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JERDown_branch and "j1ptWoNoisyJets_JERDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JERDown")
        else:
            self.j1ptWoNoisyJets_JERDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JERDown_value)

        #print "making j1ptWoNoisyJets_JERUp"
        self.j1ptWoNoisyJets_JERUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JERUp")
        #if not self.j1ptWoNoisyJets_JERUp_branch and "j1ptWoNoisyJets_JERUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JERUp_branch and "j1ptWoNoisyJets_JERUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JERUp")
        else:
            self.j1ptWoNoisyJets_JERUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JERUp_value)

        #print "making j1ptWoNoisyJets_JetAbsoluteDown"
        self.j1ptWoNoisyJets_JetAbsoluteDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetAbsoluteDown")
        #if not self.j1ptWoNoisyJets_JetAbsoluteDown_branch and "j1ptWoNoisyJets_JetAbsoluteDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetAbsoluteDown_branch and "j1ptWoNoisyJets_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetAbsoluteDown")
        else:
            self.j1ptWoNoisyJets_JetAbsoluteDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetAbsoluteDown_value)

        #print "making j1ptWoNoisyJets_JetAbsoluteUp"
        self.j1ptWoNoisyJets_JetAbsoluteUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetAbsoluteUp")
        #if not self.j1ptWoNoisyJets_JetAbsoluteUp_branch and "j1ptWoNoisyJets_JetAbsoluteUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetAbsoluteUp_branch and "j1ptWoNoisyJets_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetAbsoluteUp")
        else:
            self.j1ptWoNoisyJets_JetAbsoluteUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetAbsoluteUp_value)

        #print "making j1ptWoNoisyJets_JetAbsoluteyearDown"
        self.j1ptWoNoisyJets_JetAbsoluteyearDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetAbsoluteyearDown")
        #if not self.j1ptWoNoisyJets_JetAbsoluteyearDown_branch and "j1ptWoNoisyJets_JetAbsoluteyearDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetAbsoluteyearDown_branch and "j1ptWoNoisyJets_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetAbsoluteyearDown")
        else:
            self.j1ptWoNoisyJets_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetAbsoluteyearDown_value)

        #print "making j1ptWoNoisyJets_JetAbsoluteyearUp"
        self.j1ptWoNoisyJets_JetAbsoluteyearUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetAbsoluteyearUp")
        #if not self.j1ptWoNoisyJets_JetAbsoluteyearUp_branch and "j1ptWoNoisyJets_JetAbsoluteyearUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetAbsoluteyearUp_branch and "j1ptWoNoisyJets_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetAbsoluteyearUp")
        else:
            self.j1ptWoNoisyJets_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetAbsoluteyearUp_value)

        #print "making j1ptWoNoisyJets_JetBBEC1Down"
        self.j1ptWoNoisyJets_JetBBEC1Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetBBEC1Down")
        #if not self.j1ptWoNoisyJets_JetBBEC1Down_branch and "j1ptWoNoisyJets_JetBBEC1Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetBBEC1Down_branch and "j1ptWoNoisyJets_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetBBEC1Down")
        else:
            self.j1ptWoNoisyJets_JetBBEC1Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetBBEC1Down_value)

        #print "making j1ptWoNoisyJets_JetBBEC1Up"
        self.j1ptWoNoisyJets_JetBBEC1Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetBBEC1Up")
        #if not self.j1ptWoNoisyJets_JetBBEC1Up_branch and "j1ptWoNoisyJets_JetBBEC1Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetBBEC1Up_branch and "j1ptWoNoisyJets_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetBBEC1Up")
        else:
            self.j1ptWoNoisyJets_JetBBEC1Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetBBEC1Up_value)

        #print "making j1ptWoNoisyJets_JetBBEC1yearDown"
        self.j1ptWoNoisyJets_JetBBEC1yearDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetBBEC1yearDown")
        #if not self.j1ptWoNoisyJets_JetBBEC1yearDown_branch and "j1ptWoNoisyJets_JetBBEC1yearDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetBBEC1yearDown_branch and "j1ptWoNoisyJets_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetBBEC1yearDown")
        else:
            self.j1ptWoNoisyJets_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetBBEC1yearDown_value)

        #print "making j1ptWoNoisyJets_JetBBEC1yearUp"
        self.j1ptWoNoisyJets_JetBBEC1yearUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetBBEC1yearUp")
        #if not self.j1ptWoNoisyJets_JetBBEC1yearUp_branch and "j1ptWoNoisyJets_JetBBEC1yearUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetBBEC1yearUp_branch and "j1ptWoNoisyJets_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetBBEC1yearUp")
        else:
            self.j1ptWoNoisyJets_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetBBEC1yearUp_value)

        #print "making j1ptWoNoisyJets_JetEC2Down"
        self.j1ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Down")
        #if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Down")
        else:
            self.j1ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Down_value)

        #print "making j1ptWoNoisyJets_JetEC2Up"
        self.j1ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Up")
        #if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Up")
        else:
            self.j1ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Up_value)

        #print "making j1ptWoNoisyJets_JetEC2yearDown"
        self.j1ptWoNoisyJets_JetEC2yearDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2yearDown")
        #if not self.j1ptWoNoisyJets_JetEC2yearDown_branch and "j1ptWoNoisyJets_JetEC2yearDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2yearDown_branch and "j1ptWoNoisyJets_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2yearDown")
        else:
            self.j1ptWoNoisyJets_JetEC2yearDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2yearDown_value)

        #print "making j1ptWoNoisyJets_JetEC2yearUp"
        self.j1ptWoNoisyJets_JetEC2yearUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2yearUp")
        #if not self.j1ptWoNoisyJets_JetEC2yearUp_branch and "j1ptWoNoisyJets_JetEC2yearUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2yearUp_branch and "j1ptWoNoisyJets_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2yearUp")
        else:
            self.j1ptWoNoisyJets_JetEC2yearUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2yearUp_value)

        #print "making j1ptWoNoisyJets_JetFlavorQCDDown"
        self.j1ptWoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetFlavorQCDDown")
        #if not self.j1ptWoNoisyJets_JetFlavorQCDDown_branch and "j1ptWoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetFlavorQCDDown_branch and "j1ptWoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetFlavorQCDDown")
        else:
            self.j1ptWoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetFlavorQCDDown_value)

        #print "making j1ptWoNoisyJets_JetFlavorQCDUp"
        self.j1ptWoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetFlavorQCDUp")
        #if not self.j1ptWoNoisyJets_JetFlavorQCDUp_branch and "j1ptWoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetFlavorQCDUp_branch and "j1ptWoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetFlavorQCDUp")
        else:
            self.j1ptWoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetFlavorQCDUp_value)

        #print "making j1ptWoNoisyJets_JetHFDown"
        self.j1ptWoNoisyJets_JetHFDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetHFDown")
        #if not self.j1ptWoNoisyJets_JetHFDown_branch and "j1ptWoNoisyJets_JetHFDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetHFDown_branch and "j1ptWoNoisyJets_JetHFDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetHFDown")
        else:
            self.j1ptWoNoisyJets_JetHFDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetHFDown_value)

        #print "making j1ptWoNoisyJets_JetHFUp"
        self.j1ptWoNoisyJets_JetHFUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetHFUp")
        #if not self.j1ptWoNoisyJets_JetHFUp_branch and "j1ptWoNoisyJets_JetHFUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetHFUp_branch and "j1ptWoNoisyJets_JetHFUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetHFUp")
        else:
            self.j1ptWoNoisyJets_JetHFUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetHFUp_value)

        #print "making j1ptWoNoisyJets_JetHFyearDown"
        self.j1ptWoNoisyJets_JetHFyearDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetHFyearDown")
        #if not self.j1ptWoNoisyJets_JetHFyearDown_branch and "j1ptWoNoisyJets_JetHFyearDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetHFyearDown_branch and "j1ptWoNoisyJets_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetHFyearDown")
        else:
            self.j1ptWoNoisyJets_JetHFyearDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetHFyearDown_value)

        #print "making j1ptWoNoisyJets_JetHFyearUp"
        self.j1ptWoNoisyJets_JetHFyearUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetHFyearUp")
        #if not self.j1ptWoNoisyJets_JetHFyearUp_branch and "j1ptWoNoisyJets_JetHFyearUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetHFyearUp_branch and "j1ptWoNoisyJets_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetHFyearUp")
        else:
            self.j1ptWoNoisyJets_JetHFyearUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetHFyearUp_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalDown"
        self.j1ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalUp"
        self.j1ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleDown"
        self.j1ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleUp"
        self.j1ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "ETauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "ETauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "ETauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "ETauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "ETauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making j2ptWoNoisyJets_JERDown"
        self.j2ptWoNoisyJets_JERDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JERDown")
        #if not self.j2ptWoNoisyJets_JERDown_branch and "j2ptWoNoisyJets_JERDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JERDown_branch and "j2ptWoNoisyJets_JERDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JERDown")
        else:
            self.j2ptWoNoisyJets_JERDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JERDown_value)

        #print "making j2ptWoNoisyJets_JERUp"
        self.j2ptWoNoisyJets_JERUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JERUp")
        #if not self.j2ptWoNoisyJets_JERUp_branch and "j2ptWoNoisyJets_JERUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JERUp_branch and "j2ptWoNoisyJets_JERUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JERUp")
        else:
            self.j2ptWoNoisyJets_JERUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JERUp_value)

        #print "making j2ptWoNoisyJets_JetAbsoluteDown"
        self.j2ptWoNoisyJets_JetAbsoluteDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetAbsoluteDown")
        #if not self.j2ptWoNoisyJets_JetAbsoluteDown_branch and "j2ptWoNoisyJets_JetAbsoluteDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetAbsoluteDown_branch and "j2ptWoNoisyJets_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetAbsoluteDown")
        else:
            self.j2ptWoNoisyJets_JetAbsoluteDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetAbsoluteDown_value)

        #print "making j2ptWoNoisyJets_JetAbsoluteUp"
        self.j2ptWoNoisyJets_JetAbsoluteUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetAbsoluteUp")
        #if not self.j2ptWoNoisyJets_JetAbsoluteUp_branch and "j2ptWoNoisyJets_JetAbsoluteUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetAbsoluteUp_branch and "j2ptWoNoisyJets_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetAbsoluteUp")
        else:
            self.j2ptWoNoisyJets_JetAbsoluteUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetAbsoluteUp_value)

        #print "making j2ptWoNoisyJets_JetAbsoluteyearDown"
        self.j2ptWoNoisyJets_JetAbsoluteyearDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetAbsoluteyearDown")
        #if not self.j2ptWoNoisyJets_JetAbsoluteyearDown_branch and "j2ptWoNoisyJets_JetAbsoluteyearDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetAbsoluteyearDown_branch and "j2ptWoNoisyJets_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetAbsoluteyearDown")
        else:
            self.j2ptWoNoisyJets_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetAbsoluteyearDown_value)

        #print "making j2ptWoNoisyJets_JetAbsoluteyearUp"
        self.j2ptWoNoisyJets_JetAbsoluteyearUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetAbsoluteyearUp")
        #if not self.j2ptWoNoisyJets_JetAbsoluteyearUp_branch and "j2ptWoNoisyJets_JetAbsoluteyearUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetAbsoluteyearUp_branch and "j2ptWoNoisyJets_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetAbsoluteyearUp")
        else:
            self.j2ptWoNoisyJets_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetAbsoluteyearUp_value)

        #print "making j2ptWoNoisyJets_JetBBEC1Down"
        self.j2ptWoNoisyJets_JetBBEC1Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetBBEC1Down")
        #if not self.j2ptWoNoisyJets_JetBBEC1Down_branch and "j2ptWoNoisyJets_JetBBEC1Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetBBEC1Down_branch and "j2ptWoNoisyJets_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetBBEC1Down")
        else:
            self.j2ptWoNoisyJets_JetBBEC1Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetBBEC1Down_value)

        #print "making j2ptWoNoisyJets_JetBBEC1Up"
        self.j2ptWoNoisyJets_JetBBEC1Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetBBEC1Up")
        #if not self.j2ptWoNoisyJets_JetBBEC1Up_branch and "j2ptWoNoisyJets_JetBBEC1Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetBBEC1Up_branch and "j2ptWoNoisyJets_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetBBEC1Up")
        else:
            self.j2ptWoNoisyJets_JetBBEC1Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetBBEC1Up_value)

        #print "making j2ptWoNoisyJets_JetBBEC1yearDown"
        self.j2ptWoNoisyJets_JetBBEC1yearDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetBBEC1yearDown")
        #if not self.j2ptWoNoisyJets_JetBBEC1yearDown_branch and "j2ptWoNoisyJets_JetBBEC1yearDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetBBEC1yearDown_branch and "j2ptWoNoisyJets_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetBBEC1yearDown")
        else:
            self.j2ptWoNoisyJets_JetBBEC1yearDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetBBEC1yearDown_value)

        #print "making j2ptWoNoisyJets_JetBBEC1yearUp"
        self.j2ptWoNoisyJets_JetBBEC1yearUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetBBEC1yearUp")
        #if not self.j2ptWoNoisyJets_JetBBEC1yearUp_branch and "j2ptWoNoisyJets_JetBBEC1yearUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetBBEC1yearUp_branch and "j2ptWoNoisyJets_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetBBEC1yearUp")
        else:
            self.j2ptWoNoisyJets_JetBBEC1yearUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetBBEC1yearUp_value)

        #print "making j2ptWoNoisyJets_JetEC2Down"
        self.j2ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Down")
        #if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Down")
        else:
            self.j2ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Down_value)

        #print "making j2ptWoNoisyJets_JetEC2Up"
        self.j2ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Up")
        #if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Up")
        else:
            self.j2ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Up_value)

        #print "making j2ptWoNoisyJets_JetEC2yearDown"
        self.j2ptWoNoisyJets_JetEC2yearDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2yearDown")
        #if not self.j2ptWoNoisyJets_JetEC2yearDown_branch and "j2ptWoNoisyJets_JetEC2yearDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2yearDown_branch and "j2ptWoNoisyJets_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2yearDown")
        else:
            self.j2ptWoNoisyJets_JetEC2yearDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2yearDown_value)

        #print "making j2ptWoNoisyJets_JetEC2yearUp"
        self.j2ptWoNoisyJets_JetEC2yearUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2yearUp")
        #if not self.j2ptWoNoisyJets_JetEC2yearUp_branch and "j2ptWoNoisyJets_JetEC2yearUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2yearUp_branch and "j2ptWoNoisyJets_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2yearUp")
        else:
            self.j2ptWoNoisyJets_JetEC2yearUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2yearUp_value)

        #print "making j2ptWoNoisyJets_JetFlavorQCDDown"
        self.j2ptWoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetFlavorQCDDown")
        #if not self.j2ptWoNoisyJets_JetFlavorQCDDown_branch and "j2ptWoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetFlavorQCDDown_branch and "j2ptWoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetFlavorQCDDown")
        else:
            self.j2ptWoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetFlavorQCDDown_value)

        #print "making j2ptWoNoisyJets_JetFlavorQCDUp"
        self.j2ptWoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetFlavorQCDUp")
        #if not self.j2ptWoNoisyJets_JetFlavorQCDUp_branch and "j2ptWoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetFlavorQCDUp_branch and "j2ptWoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetFlavorQCDUp")
        else:
            self.j2ptWoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetFlavorQCDUp_value)

        #print "making j2ptWoNoisyJets_JetHFDown"
        self.j2ptWoNoisyJets_JetHFDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetHFDown")
        #if not self.j2ptWoNoisyJets_JetHFDown_branch and "j2ptWoNoisyJets_JetHFDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetHFDown_branch and "j2ptWoNoisyJets_JetHFDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetHFDown")
        else:
            self.j2ptWoNoisyJets_JetHFDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetHFDown_value)

        #print "making j2ptWoNoisyJets_JetHFUp"
        self.j2ptWoNoisyJets_JetHFUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetHFUp")
        #if not self.j2ptWoNoisyJets_JetHFUp_branch and "j2ptWoNoisyJets_JetHFUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetHFUp_branch and "j2ptWoNoisyJets_JetHFUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetHFUp")
        else:
            self.j2ptWoNoisyJets_JetHFUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetHFUp_value)

        #print "making j2ptWoNoisyJets_JetHFyearDown"
        self.j2ptWoNoisyJets_JetHFyearDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetHFyearDown")
        #if not self.j2ptWoNoisyJets_JetHFyearDown_branch and "j2ptWoNoisyJets_JetHFyearDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetHFyearDown_branch and "j2ptWoNoisyJets_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetHFyearDown")
        else:
            self.j2ptWoNoisyJets_JetHFyearDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetHFyearDown_value)

        #print "making j2ptWoNoisyJets_JetHFyearUp"
        self.j2ptWoNoisyJets_JetHFyearUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetHFyearUp")
        #if not self.j2ptWoNoisyJets_JetHFyearUp_branch and "j2ptWoNoisyJets_JetHFyearUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetHFyearUp_branch and "j2ptWoNoisyJets_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetHFyearUp")
        else:
            self.j2ptWoNoisyJets_JetHFyearUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetHFyearUp_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalDown"
        self.j2ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalUp"
        self.j2ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleDown"
        self.j2ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleUp"
        self.j2ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "ETauTree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "ETauTree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "ETauTree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "ETauTree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "ETauTree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "ETauTree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "ETauTree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "ETauTree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "ETauTree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "ETauTree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "ETauTree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "ETauTree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "ETauTree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "ETauTree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "ETauTree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "ETauTree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "ETauTree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "ETauTree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "ETauTree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "ETauTree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "ETauTree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "ETauTree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "ETauTree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "ETauTree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "ETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "ETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JERDown"
        self.jetVeto30WoNoisyJets_JERDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JERDown")
        #if not self.jetVeto30WoNoisyJets_JERDown_branch and "jetVeto30WoNoisyJets_JERDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JERDown_branch and "jetVeto30WoNoisyJets_JERDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JERDown")
        else:
            self.jetVeto30WoNoisyJets_JERDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JERDown_value)

        #print "making jetVeto30WoNoisyJets_JERUp"
        self.jetVeto30WoNoisyJets_JERUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JERUp")
        #if not self.jetVeto30WoNoisyJets_JERUp_branch and "jetVeto30WoNoisyJets_JERUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JERUp_branch and "jetVeto30WoNoisyJets_JERUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JERUp")
        else:
            self.jetVeto30WoNoisyJets_JERUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JERUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteyearDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteyearDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteyearDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteyearDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteyearUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteyearUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteyearUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteyearUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_value)

        #print "making jetVeto30WoNoisyJets_JetBBEC1Down"
        self.jetVeto30WoNoisyJets_JetBBEC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetBBEC1Down")
        #if not self.jetVeto30WoNoisyJets_JetBBEC1Down_branch and "jetVeto30WoNoisyJets_JetBBEC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetBBEC1Down_branch and "jetVeto30WoNoisyJets_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetBBEC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetBBEC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetBBEC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetBBEC1Up"
        self.jetVeto30WoNoisyJets_JetBBEC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetBBEC1Up")
        #if not self.jetVeto30WoNoisyJets_JetBBEC1Up_branch and "jetVeto30WoNoisyJets_JetBBEC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetBBEC1Up_branch and "jetVeto30WoNoisyJets_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetBBEC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetBBEC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetBBEC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetBBEC1yearDown"
        self.jetVeto30WoNoisyJets_JetBBEC1yearDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetBBEC1yearDown")
        #if not self.jetVeto30WoNoisyJets_JetBBEC1yearDown_branch and "jetVeto30WoNoisyJets_JetBBEC1yearDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetBBEC1yearDown_branch and "jetVeto30WoNoisyJets_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetBBEC1yearDown")
        else:
            self.jetVeto30WoNoisyJets_JetBBEC1yearDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetBBEC1yearDown_value)

        #print "making jetVeto30WoNoisyJets_JetBBEC1yearUp"
        self.jetVeto30WoNoisyJets_JetBBEC1yearUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetBBEC1yearUp")
        #if not self.jetVeto30WoNoisyJets_JetBBEC1yearUp_branch and "jetVeto30WoNoisyJets_JetBBEC1yearUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetBBEC1yearUp_branch and "jetVeto30WoNoisyJets_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetBBEC1yearUp")
        else:
            self.jetVeto30WoNoisyJets_JetBBEC1yearUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetBBEC1yearUp_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Down"
        self.jetVeto30WoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Up"
        self.jetVeto30WoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetEC2yearDown"
        self.jetVeto30WoNoisyJets_JetEC2yearDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2yearDown")
        #if not self.jetVeto30WoNoisyJets_JetEC2yearDown_branch and "jetVeto30WoNoisyJets_JetEC2yearDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2yearDown_branch and "jetVeto30WoNoisyJets_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2yearDown")
        else:
            self.jetVeto30WoNoisyJets_JetEC2yearDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2yearDown_value)

        #print "making jetVeto30WoNoisyJets_JetEC2yearUp"
        self.jetVeto30WoNoisyJets_JetEC2yearUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2yearUp")
        #if not self.jetVeto30WoNoisyJets_JetEC2yearUp_branch and "jetVeto30WoNoisyJets_JetEC2yearUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2yearUp_branch and "jetVeto30WoNoisyJets_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2yearUp")
        else:
            self.jetVeto30WoNoisyJets_JetEC2yearUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2yearUp_value)

        #print "making jetVeto30WoNoisyJets_JetFlavorQCDDown"
        self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFlavorQCDDown")
        #if not self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch and "jetVeto30WoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch and "jetVeto30WoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFlavorQCDDown")
        else:
            self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFlavorQCDDown_value)

        #print "making jetVeto30WoNoisyJets_JetFlavorQCDUp"
        self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFlavorQCDUp")
        #if not self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch and "jetVeto30WoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch and "jetVeto30WoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFlavorQCDUp")
        else:
            self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFlavorQCDUp_value)

        #print "making jetVeto30WoNoisyJets_JetHFDown"
        self.jetVeto30WoNoisyJets_JetHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetHFDown")
        #if not self.jetVeto30WoNoisyJets_JetHFDown_branch and "jetVeto30WoNoisyJets_JetHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetHFDown_branch and "jetVeto30WoNoisyJets_JetHFDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetHFUp"
        self.jetVeto30WoNoisyJets_JetHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetHFUp")
        #if not self.jetVeto30WoNoisyJets_JetHFUp_branch and "jetVeto30WoNoisyJets_JetHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetHFUp_branch and "jetVeto30WoNoisyJets_JetHFUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetHFyearDown"
        self.jetVeto30WoNoisyJets_JetHFyearDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetHFyearDown")
        #if not self.jetVeto30WoNoisyJets_JetHFyearDown_branch and "jetVeto30WoNoisyJets_JetHFyearDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetHFyearDown_branch and "jetVeto30WoNoisyJets_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetHFyearDown")
        else:
            self.jetVeto30WoNoisyJets_JetHFyearDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetHFyearDown_value)

        #print "making jetVeto30WoNoisyJets_JetHFyearUp"
        self.jetVeto30WoNoisyJets_JetHFyearUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetHFyearUp")
        #if not self.jetVeto30WoNoisyJets_JetHFyearUp_branch and "jetVeto30WoNoisyJets_JetHFyearUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetHFyearUp_branch and "jetVeto30WoNoisyJets_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetHFyearUp")
        else:
            self.jetVeto30WoNoisyJets_JetHFyearUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetHFyearUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleDown"
        self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleUp"
        self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value)

        #print "making jetVeto30WoNoisyJets_JetTotalDown"
        self.jetVeto30WoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalDown")
        #if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalDown")
        else:
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalDown_value)

        #print "making jetVeto30WoNoisyJets_JetTotalUp"
        self.jetVeto30WoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalUp")
        #if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalUp")
        else:
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "ETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "ETauTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "ETauTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "ETauTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "ETauTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "ETauTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "ETauTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "ETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "ETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "ETauTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "ETauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "ETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "ETauTree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making prefiring_weight_down"
        self.prefiring_weight_down_branch = the_tree.GetBranch("prefiring_weight_down")
        #if not self.prefiring_weight_down_branch and "prefiring_weight_down" not in self.complained:
        if not self.prefiring_weight_down_branch and "prefiring_weight_down":
            warnings.warn( "ETauTree: Expected branch prefiring_weight_down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_down")
        else:
            self.prefiring_weight_down_branch.SetAddress(<void*>&self.prefiring_weight_down_value)

        #print "making prefiring_weight_up"
        self.prefiring_weight_up_branch = the_tree.GetBranch("prefiring_weight_up")
        #if not self.prefiring_weight_up_branch and "prefiring_weight_up" not in self.complained:
        if not self.prefiring_weight_up_branch and "prefiring_weight_up":
            warnings.warn( "ETauTree: Expected branch prefiring_weight_up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_up")
        else:
            self.prefiring_weight_up_branch.SetAddress(<void*>&self.prefiring_weight_up_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "ETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "ETauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "ETauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "ETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "ETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "ETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "ETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "ETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "ETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "ETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "ETauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "ETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "ETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "ETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "ETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "ETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "ETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "ETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "ETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "ETauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "ETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "ETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "ETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "ETauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "ETauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tDeepTau2017v2p1VSeraw"
        self.tDeepTau2017v2p1VSeraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSeraw")
        #if not self.tDeepTau2017v2p1VSeraw_branch and "tDeepTau2017v2p1VSeraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSeraw_branch and "tDeepTau2017v2p1VSeraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v2p1VSeraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSeraw")
        else:
            self.tDeepTau2017v2p1VSeraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSeraw_value)

        #print "making tDeepTau2017v2p1VSjetraw"
        self.tDeepTau2017v2p1VSjetraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSjetraw")
        #if not self.tDeepTau2017v2p1VSjetraw_branch and "tDeepTau2017v2p1VSjetraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSjetraw_branch and "tDeepTau2017v2p1VSjetraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v2p1VSjetraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSjetraw")
        else:
            self.tDeepTau2017v2p1VSjetraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSjetraw_value)

        #print "making tDeepTau2017v2p1VSmuraw"
        self.tDeepTau2017v2p1VSmuraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSmuraw")
        #if not self.tDeepTau2017v2p1VSmuraw_branch and "tDeepTau2017v2p1VSmuraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSmuraw_branch and "tDeepTau2017v2p1VSmuraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v2p1VSmuraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSmuraw")
        else:
            self.tDeepTau2017v2p1VSmuraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSmuraw_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "ETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "ETauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "ETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "ETauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "ETauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "ETauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "ETauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "ETauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "ETauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "ETauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "ETauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "ETauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "ETauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "ETauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "ETauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "ETauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "ETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "ETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetDR"
        self.tJetDR_branch = the_tree.GetBranch("tJetDR")
        #if not self.tJetDR_branch and "tJetDR" not in self.complained:
        if not self.tJetDR_branch and "tJetDR":
            warnings.warn( "ETauTree: Expected branch tJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetDR")
        else:
            self.tJetDR_branch.SetAddress(<void*>&self.tJetDR_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "ETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "ETauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "ETauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "ETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "ETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "ETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tL1IsoTauMatch"
        self.tL1IsoTauMatch_branch = the_tree.GetBranch("tL1IsoTauMatch")
        #if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch" not in self.complained:
        if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch":
            warnings.warn( "ETauTree: Expected branch tL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauMatch")
        else:
            self.tL1IsoTauMatch_branch.SetAddress(<void*>&self.tL1IsoTauMatch_value)

        #print "making tL1IsoTauPt"
        self.tL1IsoTauPt_branch = the_tree.GetBranch("tL1IsoTauPt")
        #if not self.tL1IsoTauPt_branch and "tL1IsoTauPt" not in self.complained:
        if not self.tL1IsoTauPt_branch and "tL1IsoTauPt":
            warnings.warn( "ETauTree: Expected branch tL1IsoTauPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauPt")
        else:
            self.tL1IsoTauPt_branch.SetAddress(<void*>&self.tL1IsoTauPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "ETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseDeepTau2017v2p1VSe"
        self.tLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSe")
        #if not self.tLooseDeepTau2017v2p1VSe_branch and "tLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSe_branch and "tLooseDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSe")
        else:
            self.tLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSe_value)

        #print "making tLooseDeepTau2017v2p1VSjet"
        self.tLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSjet")
        #if not self.tLooseDeepTau2017v2p1VSjet_branch and "tLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSjet_branch and "tLooseDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSjet")
        else:
            self.tLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSjet_value)

        #print "making tLooseDeepTau2017v2p1VSmu"
        self.tLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSmu")
        #if not self.tLooseDeepTau2017v2p1VSmu_branch and "tLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSmu_branch and "tLooseDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSmu")
        else:
            self.tLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSmu_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "ETauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "ETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMatchEmbeddedFilterEle24Tau30"
        self.tMatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("tMatchEmbeddedFilterEle24Tau30")
        #if not self.tMatchEmbeddedFilterEle24Tau30_branch and "tMatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.tMatchEmbeddedFilterEle24Tau30_branch and "tMatchEmbeddedFilterEle24Tau30":
            warnings.warn( "ETauTree: Expected branch tMatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchEmbeddedFilterEle24Tau30")
        else:
            self.tMatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.tMatchEmbeddedFilterEle24Tau30_value)

        #print "making tMatchesEle24HPSTau30Filter"
        self.tMatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Filter")
        #if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter" not in self.complained:
        if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Filter")
        else:
            self.tMatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Filter_value)

        #print "making tMatchesEle24HPSTau30Path"
        self.tMatchesEle24HPSTau30Path_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Path")
        #if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path" not in self.complained:
        if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Path")
        else:
            self.tMatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Path_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "ETauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMediumDeepTau2017v2p1VSe"
        self.tMediumDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSe")
        #if not self.tMediumDeepTau2017v2p1VSe_branch and "tMediumDeepTau2017v2p1VSe" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSe_branch and "tMediumDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSe")
        else:
            self.tMediumDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSe_value)

        #print "making tMediumDeepTau2017v2p1VSjet"
        self.tMediumDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSjet")
        #if not self.tMediumDeepTau2017v2p1VSjet_branch and "tMediumDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSjet_branch and "tMediumDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSjet")
        else:
            self.tMediumDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSjet_value)

        #print "making tMediumDeepTau2017v2p1VSmu"
        self.tMediumDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSmu")
        #if not self.tMediumDeepTau2017v2p1VSmu_branch and "tMediumDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSmu_branch and "tMediumDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSmu")
        else:
            self.tMediumDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSmu_value)

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "ETauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "ETauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "ETauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "ETauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "ETauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "ETauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "ETauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "ETauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "ETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "ETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tTightDeepTau2017v2p1VSe"
        self.tTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSe")
        #if not self.tTightDeepTau2017v2p1VSe_branch and "tTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSe_branch and "tTightDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSe")
        else:
            self.tTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSe_value)

        #print "making tTightDeepTau2017v2p1VSjet"
        self.tTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSjet")
        #if not self.tTightDeepTau2017v2p1VSjet_branch and "tTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSjet_branch and "tTightDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSjet")
        else:
            self.tTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSjet_value)

        #print "making tTightDeepTau2017v2p1VSmu"
        self.tTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSmu")
        #if not self.tTightDeepTau2017v2p1VSmu_branch and "tTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSmu_branch and "tTightDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSmu")
        else:
            self.tTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSmu_value)

        #print "making tVLooseDeepTau2017v2p1VSe"
        self.tVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSe")
        #if not self.tVLooseDeepTau2017v2p1VSe_branch and "tVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSe_branch and "tVLooseDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSe")
        else:
            self.tVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSe_value)

        #print "making tVLooseDeepTau2017v2p1VSjet"
        self.tVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSjet")
        #if not self.tVLooseDeepTau2017v2p1VSjet_branch and "tVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSjet_branch and "tVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVLooseDeepTau2017v2p1VSmu"
        self.tVLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSmu")
        #if not self.tVLooseDeepTau2017v2p1VSmu_branch and "tVLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSmu_branch and "tVLooseDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSmu")
        else:
            self.tVLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSmu_value)

        #print "making tVTightDeepTau2017v2p1VSe"
        self.tVTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSe")
        #if not self.tVTightDeepTau2017v2p1VSe_branch and "tVTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSe_branch and "tVTightDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSe")
        else:
            self.tVTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSe_value)

        #print "making tVTightDeepTau2017v2p1VSjet"
        self.tVTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSjet")
        #if not self.tVTightDeepTau2017v2p1VSjet_branch and "tVTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSjet_branch and "tVTightDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSjet")
        else:
            self.tVTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSjet_value)

        #print "making tVTightDeepTau2017v2p1VSmu"
        self.tVTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSmu")
        #if not self.tVTightDeepTau2017v2p1VSmu_branch and "tVTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSmu_branch and "tVTightDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSmu")
        else:
            self.tVTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSmu_value)

        #print "making tVVLooseDeepTau2017v2p1VSe"
        self.tVVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVLooseDeepTau2017v2p1VSe")
        #if not self.tVVLooseDeepTau2017v2p1VSe_branch and "tVVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVLooseDeepTau2017v2p1VSe_branch and "tVVLooseDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tVVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v2p1VSe")
        else:
            self.tVVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v2p1VSe_value)

        #print "making tVVLooseDeepTau2017v2p1VSjet"
        self.tVVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVLooseDeepTau2017v2p1VSjet")
        #if not self.tVVLooseDeepTau2017v2p1VSjet_branch and "tVVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVLooseDeepTau2017v2p1VSjet_branch and "tVVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVVTightDeepTau2017v2p1VSe"
        self.tVVTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSe")
        #if not self.tVVTightDeepTau2017v2p1VSe_branch and "tVVTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSe_branch and "tVVTightDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSe")
        else:
            self.tVVTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSe_value)

        #print "making tVVTightDeepTau2017v2p1VSjet"
        self.tVVTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSjet")
        #if not self.tVVTightDeepTau2017v2p1VSjet_branch and "tVVTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSjet_branch and "tVVTightDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSjet")
        else:
            self.tVVTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSjet_value)

        #print "making tVVTightDeepTau2017v2p1VSmu"
        self.tVVTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSmu")
        #if not self.tVVTightDeepTau2017v2p1VSmu_branch and "tVVTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSmu_branch and "tVVTightDeepTau2017v2p1VSmu":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSmu")
        else:
            self.tVVTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSmu_value)

        #print "making tVVVLooseDeepTau2017v2p1VSe"
        self.tVVVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v2p1VSe")
        #if not self.tVVVLooseDeepTau2017v2p1VSe_branch and "tVVVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVVLooseDeepTau2017v2p1VSe_branch and "tVVVLooseDeepTau2017v2p1VSe":
            warnings.warn( "ETauTree: Expected branch tVVVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v2p1VSe")
        else:
            self.tVVVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v2p1VSe_value)

        #print "making tVVVLooseDeepTau2017v2p1VSjet"
        self.tVVVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v2p1VSjet")
        #if not self.tVVVLooseDeepTau2017v2p1VSjet_branch and "tVVVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVVLooseDeepTau2017v2p1VSjet_branch and "tVVVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVVVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "ETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "ETauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "ETauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "ETauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "ETauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "ETauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPtDeepVtx"
        self.tauVetoPtDeepVtx_branch = the_tree.GetBranch("tauVetoPtDeepVtx")
        #if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx" not in self.complained:
        if not self.tauVetoPtDeepVtx_branch and "tauVetoPtDeepVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPtDeepVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPtDeepVtx")
        else:
            self.tauVetoPtDeepVtx_branch.SetAddress(<void*>&self.tauVetoPtDeepVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "ETauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "ETauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "ETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "ETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_JERDown"
        self.type1_pfMet_shiftedPhi_JERDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JERDown")
        #if not self.type1_pfMet_shiftedPhi_JERDown_branch and "type1_pfMet_shiftedPhi_JERDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JERDown_branch and "type1_pfMet_shiftedPhi_JERDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JERDown")
        else:
            self.type1_pfMet_shiftedPhi_JERDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JERDown_value)

        #print "making type1_pfMet_shiftedPhi_JERUp"
        self.type1_pfMet_shiftedPhi_JERUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JERUp")
        #if not self.type1_pfMet_shiftedPhi_JERUp_branch and "type1_pfMet_shiftedPhi_JERUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JERUp_branch and "type1_pfMet_shiftedPhi_JERUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JERUp")
        else:
            self.type1_pfMet_shiftedPhi_JERUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JERUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteyearDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteyearDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteyearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteyearUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteyearUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteyearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1Down"
        self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch and "type1_pfMet_shiftedPhi_JetBBEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch and "type1_pfMet_shiftedPhi_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1Up"
        self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch and "type1_pfMet_shiftedPhi_JetBBEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch and "type1_pfMet_shiftedPhi_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1yearDown"
        self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1yearDown")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1yearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetBBEC1yearUp"
        self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetBBEC1yearUp")
        #if not self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPhi_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetBBEC1yearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2Down"
        self.type1_pfMet_shiftedPhi_JetEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetEC2Down_branch and "type1_pfMet_shiftedPhi_JetEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2Down_branch and "type1_pfMet_shiftedPhi_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2Up"
        self.type1_pfMet_shiftedPhi_JetEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetEC2Up_branch and "type1_pfMet_shiftedPhi_JetEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2Up_branch and "type1_pfMet_shiftedPhi_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2yearDown"
        self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2yearDown")
        #if not self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch and "type1_pfMet_shiftedPhi_JetEC2yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch and "type1_pfMet_shiftedPhi_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2yearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2yearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEC2yearUp"
        self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEC2yearUp")
        #if not self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch and "type1_pfMet_shiftedPhi_JetEC2yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch and "type1_pfMet_shiftedPhi_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEC2yearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEC2yearUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPhi_JetHFDown"
        self.type1_pfMet_shiftedPhi_JetHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetHFDown_branch and "type1_pfMet_shiftedPhi_JetHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFDown_branch and "type1_pfMet_shiftedPhi_JetHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetHFUp"
        self.type1_pfMet_shiftedPhi_JetHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetHFUp_branch and "type1_pfMet_shiftedPhi_JetHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFUp_branch and "type1_pfMet_shiftedPhi_JetHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetHFyearDown"
        self.type1_pfMet_shiftedPhi_JetHFyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFyearDown")
        #if not self.type1_pfMet_shiftedPhi_JetHFyearDown_branch and "type1_pfMet_shiftedPhi_JetHFyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFyearDown_branch and "type1_pfMet_shiftedPhi_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFyearDown")
        else:
            self.type1_pfMet_shiftedPhi_JetHFyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFyearDown_value)

        #print "making type1_pfMet_shiftedPhi_JetHFyearUp"
        self.type1_pfMet_shiftedPhi_JetHFyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetHFyearUp")
        #if not self.type1_pfMet_shiftedPhi_JetHFyearUp_branch and "type1_pfMet_shiftedPhi_JetHFyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetHFyearUp_branch and "type1_pfMet_shiftedPhi_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetHFyearUp")
        else:
            self.type1_pfMet_shiftedPhi_JetHFyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetHFyearUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalDown"
        self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalUp"
        self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalDown"
        self.type1_pfMet_shiftedPhi_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalDown")
        #if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalUp"
        self.type1_pfMet_shiftedPhi_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalUp")
        #if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDDown"
        self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDUp"
        self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPhi_UesECALDown"
        self.type1_pfMet_shiftedPhi_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALDown")
        #if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesECALUp"
        self.type1_pfMet_shiftedPhi_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALUp")
        #if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALDown"
        self.type1_pfMet_shiftedPhi_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALDown")
        #if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALUp"
        self.type1_pfMet_shiftedPhi_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALUp")
        #if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHFDown"
        self.type1_pfMet_shiftedPhi_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFDown")
        #if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHFUp"
        self.type1_pfMet_shiftedPhi_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFUp")
        #if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_JERDown"
        self.type1_pfMet_shiftedPt_JERDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JERDown")
        #if not self.type1_pfMet_shiftedPt_JERDown_branch and "type1_pfMet_shiftedPt_JERDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JERDown_branch and "type1_pfMet_shiftedPt_JERDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JERDown")
        else:
            self.type1_pfMet_shiftedPt_JERDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JERDown_value)

        #print "making type1_pfMet_shiftedPt_JERUp"
        self.type1_pfMet_shiftedPt_JERUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JERUp")
        #if not self.type1_pfMet_shiftedPt_JERUp_branch and "type1_pfMet_shiftedPt_JERUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JERUp_branch and "type1_pfMet_shiftedPt_JERUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JERUp")
        else:
            self.type1_pfMet_shiftedPt_JERUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JERUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteyearDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteyearDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteyearDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteyearUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteyearUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteyearUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1Down"
        self.type1_pfMet_shiftedPt_JetBBEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1Down_branch and "type1_pfMet_shiftedPt_JetBBEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1Down_branch and "type1_pfMet_shiftedPt_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1Up"
        self.type1_pfMet_shiftedPt_JetBBEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1Up_branch and "type1_pfMet_shiftedPt_JetBBEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1Up_branch and "type1_pfMet_shiftedPt_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1yearDown"
        self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1yearDown")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPt_JetBBEC1yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch and "type1_pfMet_shiftedPt_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1yearDown")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1yearDown_value)

        #print "making type1_pfMet_shiftedPt_JetBBEC1yearUp"
        self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetBBEC1yearUp")
        #if not self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPt_JetBBEC1yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch and "type1_pfMet_shiftedPt_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetBBEC1yearUp")
        else:
            self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetBBEC1yearUp_value)

        #print "making type1_pfMet_shiftedPt_JetEC2Down"
        self.type1_pfMet_shiftedPt_JetEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetEC2Down_branch and "type1_pfMet_shiftedPt_JetEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2Down_branch and "type1_pfMet_shiftedPt_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetEC2Up"
        self.type1_pfMet_shiftedPt_JetEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetEC2Up_branch and "type1_pfMet_shiftedPt_JetEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2Up_branch and "type1_pfMet_shiftedPt_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetEC2yearDown"
        self.type1_pfMet_shiftedPt_JetEC2yearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2yearDown")
        #if not self.type1_pfMet_shiftedPt_JetEC2yearDown_branch and "type1_pfMet_shiftedPt_JetEC2yearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2yearDown_branch and "type1_pfMet_shiftedPt_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2yearDown")
        else:
            self.type1_pfMet_shiftedPt_JetEC2yearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2yearDown_value)

        #print "making type1_pfMet_shiftedPt_JetEC2yearUp"
        self.type1_pfMet_shiftedPt_JetEC2yearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEC2yearUp")
        #if not self.type1_pfMet_shiftedPt_JetEC2yearUp_branch and "type1_pfMet_shiftedPt_JetEC2yearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEC2yearUp_branch and "type1_pfMet_shiftedPt_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEC2yearUp")
        else:
            self.type1_pfMet_shiftedPt_JetEC2yearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEC2yearUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPt_JetHFDown"
        self.type1_pfMet_shiftedPt_JetHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFDown")
        #if not self.type1_pfMet_shiftedPt_JetHFDown_branch and "type1_pfMet_shiftedPt_JetHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFDown_branch and "type1_pfMet_shiftedPt_JetHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetHFUp"
        self.type1_pfMet_shiftedPt_JetHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFUp")
        #if not self.type1_pfMet_shiftedPt_JetHFUp_branch and "type1_pfMet_shiftedPt_JetHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFUp_branch and "type1_pfMet_shiftedPt_JetHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetHFyearDown"
        self.type1_pfMet_shiftedPt_JetHFyearDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFyearDown")
        #if not self.type1_pfMet_shiftedPt_JetHFyearDown_branch and "type1_pfMet_shiftedPt_JetHFyearDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFyearDown_branch and "type1_pfMet_shiftedPt_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFyearDown")
        else:
            self.type1_pfMet_shiftedPt_JetHFyearDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFyearDown_value)

        #print "making type1_pfMet_shiftedPt_JetHFyearUp"
        self.type1_pfMet_shiftedPt_JetHFyearUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetHFyearUp")
        #if not self.type1_pfMet_shiftedPt_JetHFyearUp_branch and "type1_pfMet_shiftedPt_JetHFyearUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetHFyearUp_branch and "type1_pfMet_shiftedPt_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetHFyearUp")
        else:
            self.type1_pfMet_shiftedPt_JetHFyearUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetHFyearUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalDown"
        self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalUp"
        self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_JetTotalDown"
        self.type1_pfMet_shiftedPt_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalDown")
        #if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPt_JetTotalUp"
        self.type1_pfMet_shiftedPt_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalUp")
        #if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDDown"
        self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDUp"
        self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPt_UesECALDown"
        self.type1_pfMet_shiftedPt_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALDown")
        #if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALDown")
        else:
            self.type1_pfMet_shiftedPt_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALDown_value)

        #print "making type1_pfMet_shiftedPt_UesECALUp"
        self.type1_pfMet_shiftedPt_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALUp")
        #if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALUp")
        else:
            self.type1_pfMet_shiftedPt_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHCALDown"
        self.type1_pfMet_shiftedPt_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALDown")
        #if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPt_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPt_UesHCALUp"
        self.type1_pfMet_shiftedPt_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALUp")
        #if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPt_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHFDown"
        self.type1_pfMet_shiftedPt_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFDown")
        #if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFDown")
        else:
            self.type1_pfMet_shiftedPt_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFDown_value)

        #print "making type1_pfMet_shiftedPt_UesHFUp"
        self.type1_pfMet_shiftedPt_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFUp")
        #if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFUp")
        else:
            self.type1_pfMet_shiftedPt_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "ETauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "ETauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "ETauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfMassWoNoisyJets_JERDown"
        self.vbfMassWoNoisyJets_JERDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JERDown")
        #if not self.vbfMassWoNoisyJets_JERDown_branch and "vbfMassWoNoisyJets_JERDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JERDown_branch and "vbfMassWoNoisyJets_JERDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JERDown")
        else:
            self.vbfMassWoNoisyJets_JERDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JERDown_value)

        #print "making vbfMassWoNoisyJets_JERUp"
        self.vbfMassWoNoisyJets_JERUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JERUp")
        #if not self.vbfMassWoNoisyJets_JERUp_branch and "vbfMassWoNoisyJets_JERUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JERUp_branch and "vbfMassWoNoisyJets_JERUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JERUp")
        else:
            self.vbfMassWoNoisyJets_JERUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JERUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteDown"
        self.vbfMassWoNoisyJets_JetAbsoluteDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteDown_branch and "vbfMassWoNoisyJets_JetAbsoluteDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteDown_branch and "vbfMassWoNoisyJets_JetAbsoluteDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteUp"
        self.vbfMassWoNoisyJets_JetAbsoluteUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteUp_branch and "vbfMassWoNoisyJets_JetAbsoluteUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteUp_branch and "vbfMassWoNoisyJets_JetAbsoluteUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteyearDown"
        self.vbfMassWoNoisyJets_JetAbsoluteyearDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteyearDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteyearDown_branch and "vbfMassWoNoisyJets_JetAbsoluteyearDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteyearDown_branch and "vbfMassWoNoisyJets_JetAbsoluteyearDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteyearDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteyearDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteyearUp"
        self.vbfMassWoNoisyJets_JetAbsoluteyearUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteyearUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteyearUp_branch and "vbfMassWoNoisyJets_JetAbsoluteyearUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteyearUp_branch and "vbfMassWoNoisyJets_JetAbsoluteyearUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteyearUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteyearUp_value)

        #print "making vbfMassWoNoisyJets_JetBBEC1Down"
        self.vbfMassWoNoisyJets_JetBBEC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetBBEC1Down")
        #if not self.vbfMassWoNoisyJets_JetBBEC1Down_branch and "vbfMassWoNoisyJets_JetBBEC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetBBEC1Down_branch and "vbfMassWoNoisyJets_JetBBEC1Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetBBEC1Down")
        else:
            self.vbfMassWoNoisyJets_JetBBEC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetBBEC1Down_value)

        #print "making vbfMassWoNoisyJets_JetBBEC1Up"
        self.vbfMassWoNoisyJets_JetBBEC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetBBEC1Up")
        #if not self.vbfMassWoNoisyJets_JetBBEC1Up_branch and "vbfMassWoNoisyJets_JetBBEC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetBBEC1Up_branch and "vbfMassWoNoisyJets_JetBBEC1Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetBBEC1Up")
        else:
            self.vbfMassWoNoisyJets_JetBBEC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetBBEC1Up_value)

        #print "making vbfMassWoNoisyJets_JetBBEC1yearDown"
        self.vbfMassWoNoisyJets_JetBBEC1yearDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetBBEC1yearDown")
        #if not self.vbfMassWoNoisyJets_JetBBEC1yearDown_branch and "vbfMassWoNoisyJets_JetBBEC1yearDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetBBEC1yearDown_branch and "vbfMassWoNoisyJets_JetBBEC1yearDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetBBEC1yearDown")
        else:
            self.vbfMassWoNoisyJets_JetBBEC1yearDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetBBEC1yearDown_value)

        #print "making vbfMassWoNoisyJets_JetBBEC1yearUp"
        self.vbfMassWoNoisyJets_JetBBEC1yearUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetBBEC1yearUp")
        #if not self.vbfMassWoNoisyJets_JetBBEC1yearUp_branch and "vbfMassWoNoisyJets_JetBBEC1yearUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetBBEC1yearUp_branch and "vbfMassWoNoisyJets_JetBBEC1yearUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetBBEC1yearUp")
        else:
            self.vbfMassWoNoisyJets_JetBBEC1yearUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetBBEC1yearUp_value)

        #print "making vbfMassWoNoisyJets_JetEC2Down"
        self.vbfMassWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Down")
        #if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetEC2Up"
        self.vbfMassWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Up")
        #if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetEC2yearDown"
        self.vbfMassWoNoisyJets_JetEC2yearDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2yearDown")
        #if not self.vbfMassWoNoisyJets_JetEC2yearDown_branch and "vbfMassWoNoisyJets_JetEC2yearDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2yearDown_branch and "vbfMassWoNoisyJets_JetEC2yearDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2yearDown")
        else:
            self.vbfMassWoNoisyJets_JetEC2yearDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2yearDown_value)

        #print "making vbfMassWoNoisyJets_JetEC2yearUp"
        self.vbfMassWoNoisyJets_JetEC2yearUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2yearUp")
        #if not self.vbfMassWoNoisyJets_JetEC2yearUp_branch and "vbfMassWoNoisyJets_JetEC2yearUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2yearUp_branch and "vbfMassWoNoisyJets_JetEC2yearUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2yearUp")
        else:
            self.vbfMassWoNoisyJets_JetEC2yearUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2yearUp_value)

        #print "making vbfMassWoNoisyJets_JetFlavorQCDDown"
        self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFlavorQCDDown")
        #if not self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch and "vbfMassWoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch and "vbfMassWoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFlavorQCDDown")
        else:
            self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFlavorQCDDown_value)

        #print "making vbfMassWoNoisyJets_JetFlavorQCDUp"
        self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFlavorQCDUp")
        #if not self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch and "vbfMassWoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch and "vbfMassWoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFlavorQCDUp")
        else:
            self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFlavorQCDUp_value)

        #print "making vbfMassWoNoisyJets_JetHFDown"
        self.vbfMassWoNoisyJets_JetHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetHFDown")
        #if not self.vbfMassWoNoisyJets_JetHFDown_branch and "vbfMassWoNoisyJets_JetHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetHFDown_branch and "vbfMassWoNoisyJets_JetHFDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetHFDown")
        else:
            self.vbfMassWoNoisyJets_JetHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetHFDown_value)

        #print "making vbfMassWoNoisyJets_JetHFUp"
        self.vbfMassWoNoisyJets_JetHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetHFUp")
        #if not self.vbfMassWoNoisyJets_JetHFUp_branch and "vbfMassWoNoisyJets_JetHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetHFUp_branch and "vbfMassWoNoisyJets_JetHFUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetHFUp")
        else:
            self.vbfMassWoNoisyJets_JetHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetHFUp_value)

        #print "making vbfMassWoNoisyJets_JetHFyearDown"
        self.vbfMassWoNoisyJets_JetHFyearDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetHFyearDown")
        #if not self.vbfMassWoNoisyJets_JetHFyearDown_branch and "vbfMassWoNoisyJets_JetHFyearDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetHFyearDown_branch and "vbfMassWoNoisyJets_JetHFyearDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetHFyearDown")
        else:
            self.vbfMassWoNoisyJets_JetHFyearDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetHFyearDown_value)

        #print "making vbfMassWoNoisyJets_JetHFyearUp"
        self.vbfMassWoNoisyJets_JetHFyearUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetHFyearUp")
        #if not self.vbfMassWoNoisyJets_JetHFyearUp_branch and "vbfMassWoNoisyJets_JetHFyearUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetHFyearUp_branch and "vbfMassWoNoisyJets_JetHFyearUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetHFyearUp")
        else:
            self.vbfMassWoNoisyJets_JetHFyearUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetHFyearUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalDown"
        self.vbfMassWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalUp"
        self.vbfMassWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleDown"
        self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleUp"
        self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleUp_value)

        #print "making vbfMassWoNoisyJets_JetTotalDown"
        self.vbfMassWoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalDown")
        #if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalDown")
        else:
            self.vbfMassWoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalDown_value)

        #print "making vbfMassWoNoisyJets_JetTotalUp"
        self.vbfMassWoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalUp")
        #if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalUp")
        else:
            self.vbfMassWoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "ETauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "ETauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "ETauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "ETauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "ETauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "ETauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "ETauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "ETauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "ETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("idx")
        else:
            self.idx_branch.SetAddress(<void*>&self.idx_value)


    # Iterating over the tree
    def __iter__(self):
        self.ientry = 0
        while self.ientry < self.tree.GetEntries():
            self.load_entry(self.ientry)
            yield self
            self.ientry += 1

    # Iterate over rows which pass the filter
    def where(self, filter):
        print "where"
        cdef TTreeFormula* formula = new TTreeFormula(
            "cyiter", filter, self.tree)
        self.ientry = 0
        cdef TTree* currentTree = self.tree.GetTree()
        while self.ientry < self.tree.GetEntries():
            self.tree.LoadTree(self.ientry)
            if currentTree != self.tree.GetTree():
                currentTree = self.tree.GetTree()
                formula.SetTree(currentTree)
                formula.UpdateFormulaLeaves()
            if formula.EvalInstance(0, NULL):
                yield self
            self.ientry += 1
        del formula

    # Getting/setting the Tree entry number
    property entry:
        def __get__(self):
            return self.ientry
        def __set__(self, int i):
            print i
            self.ientry = i
            self.load_entry(i)

    # Access to the current branch values

    property Ele24LooseHPSTau30Pass:
        def __get__(self):
            self.Ele24LooseHPSTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseHPSTau30Pass_value

    property Ele24LooseHPSTau30TightIDPass:
        def __get__(self):
            self.Ele24LooseHPSTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseHPSTau30TightIDPass_value

    property Ele24LooseTau30Pass:
        def __get__(self):
            self.Ele24LooseTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseTau30Pass_value

    property Ele24LooseTau30TightIDPass:
        def __get__(self):
            self.Ele24LooseTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Ele24LooseTau30TightIDPass_value

    property Ele27WPTightPass:
        def __get__(self):
            self.Ele27WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele27WPTightPass_value

    property Ele32WPTightPass:
        def __get__(self):
            self.Ele32WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele32WPTightPass_value

    property Ele35WPTightPass:
        def __get__(self):
            self.Ele35WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele35WPTightPass_value

    property EmbPtWeight:
        def __get__(self):
            self.EmbPtWeight_branch.GetEntry(self.localentry, 0)
            return self.EmbPtWeight_value

    property Eta:
        def __get__(self):
            self.Eta_branch.GetEntry(self.localentry, 0)
            return self.Eta_value

    property Flag_BadChargedCandidateFilter:
        def __get__(self):
            self.Flag_BadChargedCandidateFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadChargedCandidateFilter_value

    property Flag_BadPFMuonFilter:
        def __get__(self):
            self.Flag_BadPFMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadPFMuonFilter_value

    property Flag_EcalDeadCellTriggerPrimitiveFilter:
        def __get__(self):
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_EcalDeadCellTriggerPrimitiveFilter_value

    property Flag_HBHENoiseFilter:
        def __get__(self):
            self.Flag_HBHENoiseFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseFilter_value

    property Flag_HBHENoiseIsoFilter:
        def __get__(self):
            self.Flag_HBHENoiseIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseIsoFilter_value

    property Flag_ecalBadCalibReducedMINIAODFilter:
        def __get__(self):
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibReducedMINIAODFilter_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_globalSuperTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalSuperTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalSuperTightHalo2016Filter_value

    property Flag_goodVertices:
        def __get__(self):
            self.Flag_goodVertices_branch.GetEntry(self.localentry, 0)
            return self.Flag_goodVertices_value

    property GenWeight:
        def __get__(self):
            self.GenWeight_branch.GetEntry(self.localentry, 0)
            return self.GenWeight_value

    property Ht:
        def __get__(self):
            self.Ht_branch.GetEntry(self.localentry, 0)
            return self.Ht_value

    property IsoMu24Pass:
        def __get__(self):
            self.IsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Pass_value

    property IsoMu27Pass:
        def __get__(self):
            self.IsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Pass_value

    property LT:
        def __get__(self):
            self.LT_branch.GetEntry(self.localentry, 0)
            return self.LT_value

    property Mass:
        def __get__(self):
            self.Mass_branch.GetEntry(self.localentry, 0)
            return self.Mass_value

    property MassError:
        def __get__(self):
            self.MassError_branch.GetEntry(self.localentry, 0)
            return self.MassError_value

    property MassErrord1:
        def __get__(self):
            self.MassErrord1_branch.GetEntry(self.localentry, 0)
            return self.MassErrord1_value

    property MassErrord2:
        def __get__(self):
            self.MassErrord2_branch.GetEntry(self.localentry, 0)
            return self.MassErrord2_value

    property MassErrord3:
        def __get__(self):
            self.MassErrord3_branch.GetEntry(self.localentry, 0)
            return self.MassErrord3_value

    property MassErrord4:
        def __get__(self):
            self.MassErrord4_branch.GetEntry(self.localentry, 0)
            return self.MassErrord4_value

    property Mt:
        def __get__(self):
            self.Mt_branch.GetEntry(self.localentry, 0)
            return self.Mt_value

    property Mu50Pass:
        def __get__(self):
            self.Mu50Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu50Pass_value

    property NUP:
        def __get__(self):
            self.NUP_branch.GetEntry(self.localentry, 0)
            return self.NUP_value

    property Phi:
        def __get__(self):
            self.Phi_branch.GetEntry(self.localentry, 0)
            return self.Phi_value

    property Pt:
        def __get__(self):
            self.Pt_branch.GetEntry(self.localentry, 0)
            return self.Pt_value

    property bjetDeepCSVVeto20Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0p5_value

    property bjetDeepCSVVeto20Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0p5_value

    property bjetDeepCSVVeto30Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2016_DR0p5_value

    property bjetDeepCSVVeto30Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2017_DR0p5_value

    property bjetDeepCSVVeto30Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_2018_DR0p5_value

    property bweight_2016:
        def __get__(self):
            self.bweight_2016_branch.GetEntry(self.localentry, 0)
            return self.bweight_2016_value

    property bweight_2017:
        def __get__(self):
            self.bweight_2017_branch.GetEntry(self.localentry, 0)
            return self.bweight_2017_value

    property bweight_2018:
        def __get__(self):
            self.bweight_2018_branch.GetEntry(self.localentry, 0)
            return self.bweight_2018_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property deepcsvb1_btagscore:
        def __get__(self):
            self.deepcsvb1_btagscore_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_btagscore_value

    property deepcsvb1_eta:
        def __get__(self):
            self.deepcsvb1_eta_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_eta_value

    property deepcsvb1_hadronflavour:
        def __get__(self):
            self.deepcsvb1_hadronflavour_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_hadronflavour_value

    property deepcsvb1_m:
        def __get__(self):
            self.deepcsvb1_m_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_m_value

    property deepcsvb1_phi:
        def __get__(self):
            self.deepcsvb1_phi_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_phi_value

    property deepcsvb1_pt:
        def __get__(self):
            self.deepcsvb1_pt_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb1_pt_value

    property deepcsvb2_btagscore:
        def __get__(self):
            self.deepcsvb2_btagscore_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_btagscore_value

    property deepcsvb2_eta:
        def __get__(self):
            self.deepcsvb2_eta_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_eta_value

    property deepcsvb2_hadronflavour:
        def __get__(self):
            self.deepcsvb2_hadronflavour_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_hadronflavour_value

    property deepcsvb2_m:
        def __get__(self):
            self.deepcsvb2_m_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_m_value

    property deepcsvb2_phi:
        def __get__(self):
            self.deepcsvb2_phi_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_phi_value

    property deepcsvb2_pt:
        def __get__(self):
            self.deepcsvb2_pt_branch.GetEntry(self.localentry, 0)
            return self.deepcsvb2_pt_value

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eCorrectedEt:
        def __get__(self):
            self.eCorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.eCorrectedEt_value

    property eEnergyError:
        def __get__(self):
            self.eEnergyError_branch.GetEntry(self.localentry, 0)
            return self.eEnergyError_value

    property eEnergyScaleDown:
        def __get__(self):
            self.eEnergyScaleDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleDown_value

    property eEnergyScaleGainDown:
        def __get__(self):
            self.eEnergyScaleGainDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleGainDown_value

    property eEnergyScaleGainUp:
        def __get__(self):
            self.eEnergyScaleGainUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleGainUp_value

    property eEnergyScaleStatDown:
        def __get__(self):
            self.eEnergyScaleStatDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleStatDown_value

    property eEnergyScaleStatUp:
        def __get__(self):
            self.eEnergyScaleStatUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleStatUp_value

    property eEnergyScaleSystDown:
        def __get__(self):
            self.eEnergyScaleSystDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleSystDown_value

    property eEnergyScaleSystUp:
        def __get__(self):
            self.eEnergyScaleSystUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleSystUp_value

    property eEnergyScaleUp:
        def __get__(self):
            self.eEnergyScaleUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergyScaleUp_value

    property eEnergySigmaDown:
        def __get__(self):
            self.eEnergySigmaDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaDown_value

    property eEnergySigmaPhiDown:
        def __get__(self):
            self.eEnergySigmaPhiDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaPhiDown_value

    property eEnergySigmaPhiUp:
        def __get__(self):
            self.eEnergySigmaPhiUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaPhiUp_value

    property eEnergySigmaRhoDown:
        def __get__(self):
            self.eEnergySigmaRhoDown_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaRhoDown_value

    property eEnergySigmaRhoUp:
        def __get__(self):
            self.eEnergySigmaRhoUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaRhoUp_value

    property eEnergySigmaUp:
        def __get__(self):
            self.eEnergySigmaUp_branch.GetEntry(self.localentry, 0)
            return self.eEnergySigmaUp_value

    property eEta:
        def __get__(self):
            self.eEta_branch.GetEntry(self.localentry, 0)
            return self.eEta_value

    property eGenCharge:
        def __get__(self):
            self.eGenCharge_branch.GetEntry(self.localentry, 0)
            return self.eGenCharge_value

    property eGenDirectPromptTauDecay:
        def __get__(self):
            self.eGenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenDirectPromptTauDecay_value

    property eGenEnergy:
        def __get__(self):
            self.eGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.eGenEnergy_value

    property eGenEta:
        def __get__(self):
            self.eGenEta_branch.GetEntry(self.localentry, 0)
            return self.eGenEta_value

    property eGenIsPrompt:
        def __get__(self):
            self.eGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenIsPrompt_value

    property eGenMotherPdgId:
        def __get__(self):
            self.eGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenMotherPdgId_value

    property eGenParticle:
        def __get__(self):
            self.eGenParticle_branch.GetEntry(self.localentry, 0)
            return self.eGenParticle_value

    property eGenPdgId:
        def __get__(self):
            self.eGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.eGenPdgId_value

    property eGenPhi:
        def __get__(self):
            self.eGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eGenPhi_value

    property eGenPrompt:
        def __get__(self):
            self.eGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.eGenPrompt_value

    property eGenPromptTauDecay:
        def __get__(self):
            self.eGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenPromptTauDecay_value

    property eGenPt:
        def __get__(self):
            self.eGenPt_branch.GetEntry(self.localentry, 0)
            return self.eGenPt_value

    property eGenTauDecay:
        def __get__(self):
            self.eGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.eGenTauDecay_value

    property eGenVZ:
        def __get__(self):
            self.eGenVZ_branch.GetEntry(self.localentry, 0)
            return self.eGenVZ_value

    property eGenVtxPVMatch:
        def __get__(self):
            self.eGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.eGenVtxPVMatch_value

    property eIP3D:
        def __get__(self):
            self.eIP3D_branch.GetEntry(self.localentry, 0)
            return self.eIP3D_value

    property eIP3DErr:
        def __get__(self):
            self.eIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.eIP3DErr_value

    property eIsoDB03:
        def __get__(self):
            self.eIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.eIsoDB03_value

    property eJetArea:
        def __get__(self):
            self.eJetArea_branch.GetEntry(self.localentry, 0)
            return self.eJetArea_value

    property eJetBtag:
        def __get__(self):
            self.eJetBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetBtag_value

    property eJetDR:
        def __get__(self):
            self.eJetDR_branch.GetEntry(self.localentry, 0)
            return self.eJetDR_value

    property eJetEtaEtaMoment:
        def __get__(self):
            self.eJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaEtaMoment_value

    property eJetEtaPhiMoment:
        def __get__(self):
            self.eJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiMoment_value

    property eJetEtaPhiSpread:
        def __get__(self):
            self.eJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.eJetEtaPhiSpread_value

    property eJetHadronFlavour:
        def __get__(self):
            self.eJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetHadronFlavour_value

    property eJetPFCISVBtag:
        def __get__(self):
            self.eJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.eJetPFCISVBtag_value

    property eJetPartonFlavour:
        def __get__(self):
            self.eJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.eJetPartonFlavour_value

    property eJetPhiPhiMoment:
        def __get__(self):
            self.eJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.eJetPhiPhiMoment_value

    property eJetPt:
        def __get__(self):
            self.eJetPt_branch.GetEntry(self.localentry, 0)
            return self.eJetPt_value

    property eMVAIsoWP80:
        def __get__(self):
            self.eMVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP80_value

    property eMVAIsoWP90:
        def __get__(self):
            self.eMVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP90_value

    property eMVANoisoWP80:
        def __get__(self):
            self.eMVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP80_value

    property eMVANoisoWP90:
        def __get__(self):
            self.eMVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP90_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

    property eMatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.eMatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle24Tau30_value

    property eMatchEmbeddedFilterEle27:
        def __get__(self):
            self.eMatchEmbeddedFilterEle27_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle27_value

    property eMatchEmbeddedFilterEle32:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32_value

    property eMatchEmbeddedFilterEle32DoubleL1_v1:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32DoubleL1_v1_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32DoubleL1_v1_value

    property eMatchEmbeddedFilterEle32DoubleL1_v2:
        def __get__(self):
            self.eMatchEmbeddedFilterEle32DoubleL1_v2_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle32DoubleL1_v2_value

    property eMatchEmbeddedFilterEle35:
        def __get__(self):
            self.eMatchEmbeddedFilterEle35_branch.GetEntry(self.localentry, 0)
            return self.eMatchEmbeddedFilterEle35_value

    property eMatchesEle24HPSTau30Filter:
        def __get__(self):
            self.eMatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24HPSTau30Filter_value

    property eMatchesEle24HPSTau30Path:
        def __get__(self):
            self.eMatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24HPSTau30Path_value

    property eMatchesEle24Tau30Filter:
        def __get__(self):
            self.eMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Filter_value

    property eMatchesEle24Tau30Path:
        def __get__(self):
            self.eMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle24Tau30Path_value

    property eMatchesEle25Filter:
        def __get__(self):
            self.eMatchesEle25Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25Filter_value

    property eMatchesEle25Path:
        def __get__(self):
            self.eMatchesEle25Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle25Path_value

    property eMatchesEle27Filter:
        def __get__(self):
            self.eMatchesEle27Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27Filter_value

    property eMatchesEle27Path:
        def __get__(self):
            self.eMatchesEle27Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle27Path_value

    property eMatchesEle32Filter:
        def __get__(self):
            self.eMatchesEle32Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle32Filter_value

    property eMatchesEle32Path:
        def __get__(self):
            self.eMatchesEle32Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle32Path_value

    property eMatchesEle35Filter:
        def __get__(self):
            self.eMatchesEle35Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle35Filter_value

    property eMatchesEle35Path:
        def __get__(self):
            self.eMatchesEle35Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesEle35Path_value

    property eMatchesMu23e12DZFilter:
        def __get__(self):
            self.eMatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12DZFilter_value

    property eMatchesMu23e12DZPath:
        def __get__(self):
            self.eMatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12DZPath_value

    property eMatchesMu23e12Filter:
        def __get__(self):
            self.eMatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12Filter_value

    property eMatchesMu23e12Path:
        def __get__(self):
            self.eMatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu23e12Path_value

    property eMatchesMu8e23DZFilter:
        def __get__(self):
            self.eMatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZFilter_value

    property eMatchesMu8e23DZPath:
        def __get__(self):
            self.eMatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23DZPath_value

    property eMatchesMu8e23Filter:
        def __get__(self):
            self.eMatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23Filter_value

    property eMatchesMu8e23Path:
        def __get__(self):
            self.eMatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.eMatchesMu8e23Path_value

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property ePVDXY:
        def __get__(self):
            self.ePVDXY_branch.GetEntry(self.localentry, 0)
            return self.ePVDXY_value

    property ePVDZ:
        def __get__(self):
            self.ePVDZ_branch.GetEntry(self.localentry, 0)
            return self.ePVDZ_value

    property ePassesConversionVeto:
        def __get__(self):
            self.ePassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.ePassesConversionVeto_value

    property ePhi:
        def __get__(self):
            self.ePhi_branch.GetEntry(self.localentry, 0)
            return self.ePhi_value

    property ePt:
        def __get__(self):
            self.ePt_branch.GetEntry(self.localentry, 0)
            return self.ePt_value

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

    property eZTTGenMatching:
        def __get__(self):
            self.eZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenMatching_value

    property e_t_PZeta:
        def __get__(self):
            self.e_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZeta_value

    property e_t_PZetaVis:
        def __get__(self):
            self.e_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e_t_PZetaVis_value

    property e_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.e_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e_t_doubleL1IsoTauMatch_value

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property genEta:
        def __get__(self):
            self.genEta_branch.GetEntry(self.localentry, 0)
            return self.genEta_value

    property genHTT:
        def __get__(self):
            self.genHTT_branch.GetEntry(self.localentry, 0)
            return self.genHTT_value

    property genM:
        def __get__(self):
            self.genM_branch.GetEntry(self.localentry, 0)
            return self.genM_value

    property genMass:
        def __get__(self):
            self.genMass_branch.GetEntry(self.localentry, 0)
            return self.genMass_value

    property genPhi:
        def __get__(self):
            self.genPhi_branch.GetEntry(self.localentry, 0)
            return self.genPhi_value

    property genpT:
        def __get__(self):
            self.genpT_branch.GetEntry(self.localentry, 0)
            return self.genpT_value

    property genpX:
        def __get__(self):
            self.genpX_branch.GetEntry(self.localentry, 0)
            return self.genpX_value

    property genpY:
        def __get__(self):
            self.genpY_branch.GetEntry(self.localentry, 0)
            return self.genpY_value

    property isGtautau:
        def __get__(self):
            self.isGtautau_branch.GetEntry(self.localentry, 0)
            return self.isGtautau_value

    property isWenu:
        def __get__(self):
            self.isWenu_branch.GetEntry(self.localentry, 0)
            return self.isWenu_value

    property isWmunu:
        def __get__(self):
            self.isWmunu_branch.GetEntry(self.localentry, 0)
            return self.isWmunu_value

    property isWtaunu:
        def __get__(self):
            self.isWtaunu_branch.GetEntry(self.localentry, 0)
            return self.isWtaunu_value

    property isZee:
        def __get__(self):
            self.isZee_branch.GetEntry(self.localentry, 0)
            return self.isZee_value

    property isZmumu:
        def __get__(self):
            self.isZmumu_branch.GetEntry(self.localentry, 0)
            return self.isZmumu_value

    property isZtautau:
        def __get__(self):
            self.isZtautau_branch.GetEntry(self.localentry, 0)
            return self.isZtautau_value

    property isdata:
        def __get__(self):
            self.isdata_branch.GetEntry(self.localentry, 0)
            return self.isdata_value

    property isembed:
        def __get__(self):
            self.isembed_branch.GetEntry(self.localentry, 0)
            return self.isembed_value

    property j1csv:
        def __get__(self):
            self.j1csv_branch.GetEntry(self.localentry, 0)
            return self.j1csv_value

    property j1csvWoNoisyJets:
        def __get__(self):
            self.j1csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1csvWoNoisyJets_value

    property j1eta:
        def __get__(self):
            self.j1eta_branch.GetEntry(self.localentry, 0)
            return self.j1eta_value

    property j1etaWoNoisyJets:
        def __get__(self):
            self.j1etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1etaWoNoisyJets_value

    property j1hadronflavor:
        def __get__(self):
            self.j1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavor_value

    property j1hadronflavorWoNoisyJets:
        def __get__(self):
            self.j1hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavorWoNoisyJets_value

    property j1phi:
        def __get__(self):
            self.j1phi_branch.GetEntry(self.localentry, 0)
            return self.j1phi_value

    property j1phiWoNoisyJets:
        def __get__(self):
            self.j1phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1phiWoNoisyJets_value

    property j1pt:
        def __get__(self):
            self.j1pt_branch.GetEntry(self.localentry, 0)
            return self.j1pt_value

    property j1ptWoNoisyJets:
        def __get__(self):
            self.j1ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_value

    property j1ptWoNoisyJets_JERDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JERDown_value

    property j1ptWoNoisyJets_JERUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JERUp_value

    property j1ptWoNoisyJets_JetAbsoluteDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetAbsoluteDown_value

    property j1ptWoNoisyJets_JetAbsoluteUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetAbsoluteUp_value

    property j1ptWoNoisyJets_JetAbsoluteyearDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetAbsoluteyearDown_value

    property j1ptWoNoisyJets_JetAbsoluteyearUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetAbsoluteyearUp_value

    property j1ptWoNoisyJets_JetBBEC1Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetBBEC1Down_value

    property j1ptWoNoisyJets_JetBBEC1Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetBBEC1Up_value

    property j1ptWoNoisyJets_JetBBEC1yearDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetBBEC1yearDown_value

    property j1ptWoNoisyJets_JetBBEC1yearUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetBBEC1yearUp_value

    property j1ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Down_value

    property j1ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Up_value

    property j1ptWoNoisyJets_JetEC2yearDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2yearDown_value

    property j1ptWoNoisyJets_JetEC2yearUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2yearUp_value

    property j1ptWoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetFlavorQCDDown_value

    property j1ptWoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetFlavorQCDUp_value

    property j1ptWoNoisyJets_JetHFDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetHFDown_value

    property j1ptWoNoisyJets_JetHFUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetHFUp_value

    property j1ptWoNoisyJets_JetHFyearDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetHFyearDown_value

    property j1ptWoNoisyJets_JetHFyearUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetHFyearUp_value

    property j1ptWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeBalDown_value

    property j1ptWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeBalUp_value

    property j1ptWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeSampleDown_value

    property j1ptWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetRelativeSampleUp_value

    property j2csv:
        def __get__(self):
            self.j2csv_branch.GetEntry(self.localentry, 0)
            return self.j2csv_value

    property j2csvWoNoisyJets:
        def __get__(self):
            self.j2csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2csvWoNoisyJets_value

    property j2eta:
        def __get__(self):
            self.j2eta_branch.GetEntry(self.localentry, 0)
            return self.j2eta_value

    property j2etaWoNoisyJets:
        def __get__(self):
            self.j2etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2etaWoNoisyJets_value

    property j2hadronflavor:
        def __get__(self):
            self.j2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavor_value

    property j2hadronflavorWoNoisyJets:
        def __get__(self):
            self.j2hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavorWoNoisyJets_value

    property j2phi:
        def __get__(self):
            self.j2phi_branch.GetEntry(self.localentry, 0)
            return self.j2phi_value

    property j2phiWoNoisyJets:
        def __get__(self):
            self.j2phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2phiWoNoisyJets_value

    property j2pt:
        def __get__(self):
            self.j2pt_branch.GetEntry(self.localentry, 0)
            return self.j2pt_value

    property j2ptWoNoisyJets:
        def __get__(self):
            self.j2ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_value

    property j2ptWoNoisyJets_JERDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JERDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JERDown_value

    property j2ptWoNoisyJets_JERUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JERUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JERUp_value

    property j2ptWoNoisyJets_JetAbsoluteDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetAbsoluteDown_value

    property j2ptWoNoisyJets_JetAbsoluteUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetAbsoluteUp_value

    property j2ptWoNoisyJets_JetAbsoluteyearDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetAbsoluteyearDown_value

    property j2ptWoNoisyJets_JetAbsoluteyearUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetAbsoluteyearUp_value

    property j2ptWoNoisyJets_JetBBEC1Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetBBEC1Down_value

    property j2ptWoNoisyJets_JetBBEC1Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetBBEC1Up_value

    property j2ptWoNoisyJets_JetBBEC1yearDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetBBEC1yearDown_value

    property j2ptWoNoisyJets_JetBBEC1yearUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetBBEC1yearUp_value

    property j2ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Down_value

    property j2ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Up_value

    property j2ptWoNoisyJets_JetEC2yearDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2yearDown_value

    property j2ptWoNoisyJets_JetEC2yearUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2yearUp_value

    property j2ptWoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetFlavorQCDDown_value

    property j2ptWoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetFlavorQCDUp_value

    property j2ptWoNoisyJets_JetHFDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetHFDown_value

    property j2ptWoNoisyJets_JetHFUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetHFUp_value

    property j2ptWoNoisyJets_JetHFyearDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetHFyearDown_value

    property j2ptWoNoisyJets_JetHFyearUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetHFyearUp_value

    property j2ptWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeBalDown_value

    property j2ptWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeBalUp_value

    property j2ptWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeSampleDown_value

    property j2ptWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetRelativeSampleUp_value

    property jb1eta_2016:
        def __get__(self):
            self.jb1eta_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2016_value

    property jb1eta_2017:
        def __get__(self):
            self.jb1eta_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2017_value

    property jb1eta_2018:
        def __get__(self):
            self.jb1eta_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_2018_value

    property jb1hadronflavor_2016:
        def __get__(self):
            self.jb1hadronflavor_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2016_value

    property jb1hadronflavor_2017:
        def __get__(self):
            self.jb1hadronflavor_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2017_value

    property jb1hadronflavor_2018:
        def __get__(self):
            self.jb1hadronflavor_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_2018_value

    property jb1phi_2016:
        def __get__(self):
            self.jb1phi_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2016_value

    property jb1phi_2017:
        def __get__(self):
            self.jb1phi_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2017_value

    property jb1phi_2018:
        def __get__(self):
            self.jb1phi_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_2018_value

    property jb1pt_2016:
        def __get__(self):
            self.jb1pt_2016_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2016_value

    property jb1pt_2017:
        def __get__(self):
            self.jb1pt_2017_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2017_value

    property jb1pt_2018:
        def __get__(self):
            self.jb1pt_2018_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_2018_value

    property jb2eta_2016:
        def __get__(self):
            self.jb2eta_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2016_value

    property jb2eta_2017:
        def __get__(self):
            self.jb2eta_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2017_value

    property jb2eta_2018:
        def __get__(self):
            self.jb2eta_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_2018_value

    property jb2hadronflavor_2016:
        def __get__(self):
            self.jb2hadronflavor_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2016_value

    property jb2hadronflavor_2017:
        def __get__(self):
            self.jb2hadronflavor_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2017_value

    property jb2hadronflavor_2018:
        def __get__(self):
            self.jb2hadronflavor_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_2018_value

    property jb2phi_2016:
        def __get__(self):
            self.jb2phi_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2016_value

    property jb2phi_2017:
        def __get__(self):
            self.jb2phi_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2017_value

    property jb2phi_2018:
        def __get__(self):
            self.jb2phi_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_2018_value

    property jb2pt_2016:
        def __get__(self):
            self.jb2pt_2016_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2016_value

    property jb2pt_2017:
        def __get__(self):
            self.jb2pt_2017_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2017_value

    property jb2pt_2018:
        def __get__(self):
            self.jb2pt_2018_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_2018_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

    property jetVeto20WoNoisyJets:
        def __get__(self):
            self.jetVeto20WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20WoNoisyJets_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30WoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_value

    property jetVeto30WoNoisyJets_JERDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JERDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JERDown_value

    property jetVeto30WoNoisyJets_JERUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JERUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JERUp_value

    property jetVeto30WoNoisyJets_JetAbsoluteDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteUp_value

    property jetVeto30WoNoisyJets_JetAbsoluteyearDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteyearDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteyearUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteyearUp_value

    property jetVeto30WoNoisyJets_JetBBEC1Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetBBEC1Down_value

    property jetVeto30WoNoisyJets_JetBBEC1Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetBBEC1Up_value

    property jetVeto30WoNoisyJets_JetBBEC1yearDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetBBEC1yearDown_value

    property jetVeto30WoNoisyJets_JetBBEC1yearUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetBBEC1yearUp_value

    property jetVeto30WoNoisyJets_JetEC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Down_value

    property jetVeto30WoNoisyJets_JetEC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Up_value

    property jetVeto30WoNoisyJets_JetEC2yearDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2yearDown_value

    property jetVeto30WoNoisyJets_JetEC2yearUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2yearUp_value

    property jetVeto30WoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFlavorQCDDown_value

    property jetVeto30WoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFlavorQCDUp_value

    property jetVeto30WoNoisyJets_JetHFDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetHFDown_value

    property jetVeto30WoNoisyJets_JetHFUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetHFUp_value

    property jetVeto30WoNoisyJets_JetHFyearDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetHFyearDown_value

    property jetVeto30WoNoisyJets_JetHFyearUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetHFyearUp_value

    property jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value

    property jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value

    property jetVeto30WoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    property jetVeto30WoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    property jetVeto30WoNoisyJets_JetTotalDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalDown_value

    property jetVeto30WoNoisyJets_JetTotalUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalUp_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property mu12e23DZPass:
        def __get__(self):
            self.mu12e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23DZPass_value

    property mu12e23Pass:
        def __get__(self):
            self.mu12e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23Pass_value

    property mu23e12DZPass:
        def __get__(self):
            self.mu23e12DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12DZPass_value

    property mu23e12Pass:
        def __get__(self):
            self.mu23e12Pass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12Pass_value

    property mu8e23DZPass:
        def __get__(self):
            self.mu8e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23DZPass_value

    property mu8e23Pass:
        def __get__(self):
            self.mu8e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23Pass_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muVetoZTTp001dxyz:
        def __get__(self):
            self.muVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyz_value

    property nTruePU:
        def __get__(self):
            self.nTruePU_branch.GetEntry(self.localentry, 0)
            return self.nTruePU_value

    property npNLO:
        def __get__(self):
            self.npNLO_branch.GetEntry(self.localentry, 0)
            return self.npNLO_value

    property numGenJets:
        def __get__(self):
            self.numGenJets_branch.GetEntry(self.localentry, 0)
            return self.numGenJets_value

    property nvtx:
        def __get__(self):
            self.nvtx_branch.GetEntry(self.localentry, 0)
            return self.nvtx_value

    property prefiring_weight:
        def __get__(self):
            self.prefiring_weight_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_value

    property prefiring_weight_down:
        def __get__(self):
            self.prefiring_weight_down_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_down_value

    property prefiring_weight_up:
        def __get__(self):
            self.prefiring_weight_up_branch.GetEntry(self.localentry, 0)
            return self.prefiring_weight_up_value

    property processID:
        def __get__(self):
            self.processID_branch.GetEntry(self.localentry, 0)
            return self.processID_value

    property puppiMetEt:
        def __get__(self):
            self.puppiMetEt_branch.GetEntry(self.localentry, 0)
            return self.puppiMetEt_value

    property puppiMetPhi:
        def __get__(self):
            self.puppiMetPhi_branch.GetEntry(self.localentry, 0)
            return self.puppiMetPhi_value

    property pvChi2:
        def __get__(self):
            self.pvChi2_branch.GetEntry(self.localentry, 0)
            return self.pvChi2_value

    property pvDX:
        def __get__(self):
            self.pvDX_branch.GetEntry(self.localentry, 0)
            return self.pvDX_value

    property pvDY:
        def __get__(self):
            self.pvDY_branch.GetEntry(self.localentry, 0)
            return self.pvDY_value

    property pvDZ:
        def __get__(self):
            self.pvDZ_branch.GetEntry(self.localentry, 0)
            return self.pvDZ_value

    property pvIsFake:
        def __get__(self):
            self.pvIsFake_branch.GetEntry(self.localentry, 0)
            return self.pvIsFake_value

    property pvIsValid:
        def __get__(self):
            self.pvIsValid_branch.GetEntry(self.localentry, 0)
            return self.pvIsValid_value

    property pvNormChi2:
        def __get__(self):
            self.pvNormChi2_branch.GetEntry(self.localentry, 0)
            return self.pvNormChi2_value

    property pvRho:
        def __get__(self):
            self.pvRho_branch.GetEntry(self.localentry, 0)
            return self.pvRho_value

    property pvX:
        def __get__(self):
            self.pvX_branch.GetEntry(self.localentry, 0)
            return self.pvX_value

    property pvY:
        def __get__(self):
            self.pvY_branch.GetEntry(self.localentry, 0)
            return self.pvY_value

    property pvZ:
        def __get__(self):
            self.pvZ_branch.GetEntry(self.localentry, 0)
            return self.pvZ_value

    property pvndof:
        def __get__(self):
            self.pvndof_branch.GetEntry(self.localentry, 0)
            return self.pvndof_value

    property recoilDaught:
        def __get__(self):
            self.recoilDaught_branch.GetEntry(self.localentry, 0)
            return self.recoilDaught_value

    property recoilWithMet:
        def __get__(self):
            self.recoilWithMet_branch.GetEntry(self.localentry, 0)
            return self.recoilWithMet_value

    property rho:
        def __get__(self):
            self.rho_branch.GetEntry(self.localentry, 0)
            return self.rho_value

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property singleE25eta2p1TightPass:
        def __get__(self):
            self.singleE25eta2p1TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE25eta2p1TightPass_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tComesFromHiggs:
        def __get__(self):
            self.tComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.tComesFromHiggs_value

    property tDecayMode:
        def __get__(self):
            self.tDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tDecayMode_value

    property tDecayModeFinding:
        def __get__(self):
            self.tDecayModeFinding_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFinding_value

    property tDecayModeFindingNewDMs:
        def __get__(self):
            self.tDecayModeFindingNewDMs_branch.GetEntry(self.localentry, 0)
            return self.tDecayModeFindingNewDMs_value

    property tDeepTau2017v2p1VSeraw:
        def __get__(self):
            self.tDeepTau2017v2p1VSeraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v2p1VSeraw_value

    property tDeepTau2017v2p1VSjetraw:
        def __get__(self):
            self.tDeepTau2017v2p1VSjetraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v2p1VSjetraw_value

    property tDeepTau2017v2p1VSmuraw:
        def __get__(self):
            self.tDeepTau2017v2p1VSmuraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v2p1VSmuraw_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

    property tGenCharge:
        def __get__(self):
            self.tGenCharge_branch.GetEntry(self.localentry, 0)
            return self.tGenCharge_value

    property tGenDecayMode:
        def __get__(self):
            self.tGenDecayMode_branch.GetEntry(self.localentry, 0)
            return self.tGenDecayMode_value

    property tGenEnergy:
        def __get__(self):
            self.tGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenEnergy_value

    property tGenEta:
        def __get__(self):
            self.tGenEta_branch.GetEntry(self.localentry, 0)
            return self.tGenEta_value

    property tGenJetEta:
        def __get__(self):
            self.tGenJetEta_branch.GetEntry(self.localentry, 0)
            return self.tGenJetEta_value

    property tGenJetPt:
        def __get__(self):
            self.tGenJetPt_branch.GetEntry(self.localentry, 0)
            return self.tGenJetPt_value

    property tGenMotherEnergy:
        def __get__(self):
            self.tGenMotherEnergy_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEnergy_value

    property tGenMotherEta:
        def __get__(self):
            self.tGenMotherEta_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherEta_value

    property tGenMotherPdgId:
        def __get__(self):
            self.tGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPdgId_value

    property tGenMotherPhi:
        def __get__(self):
            self.tGenMotherPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPhi_value

    property tGenMotherPt:
        def __get__(self):
            self.tGenMotherPt_branch.GetEntry(self.localentry, 0)
            return self.tGenMotherPt_value

    property tGenPdgId:
        def __get__(self):
            self.tGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.tGenPdgId_value

    property tGenPhi:
        def __get__(self):
            self.tGenPhi_branch.GetEntry(self.localentry, 0)
            return self.tGenPhi_value

    property tGenPt:
        def __get__(self):
            self.tGenPt_branch.GetEntry(self.localentry, 0)
            return self.tGenPt_value

    property tGenStatus:
        def __get__(self):
            self.tGenStatus_branch.GetEntry(self.localentry, 0)
            return self.tGenStatus_value

    property tJetArea:
        def __get__(self):
            self.tJetArea_branch.GetEntry(self.localentry, 0)
            return self.tJetArea_value

    property tJetBtag:
        def __get__(self):
            self.tJetBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetBtag_value

    property tJetDR:
        def __get__(self):
            self.tJetDR_branch.GetEntry(self.localentry, 0)
            return self.tJetDR_value

    property tJetEtaEtaMoment:
        def __get__(self):
            self.tJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaEtaMoment_value

    property tJetEtaPhiMoment:
        def __get__(self):
            self.tJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiMoment_value

    property tJetEtaPhiSpread:
        def __get__(self):
            self.tJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.tJetEtaPhiSpread_value

    property tJetHadronFlavour:
        def __get__(self):
            self.tJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetHadronFlavour_value

    property tJetPFCISVBtag:
        def __get__(self):
            self.tJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.tJetPFCISVBtag_value

    property tJetPartonFlavour:
        def __get__(self):
            self.tJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.tJetPartonFlavour_value

    property tJetPhiPhiMoment:
        def __get__(self):
            self.tJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.tJetPhiPhiMoment_value

    property tJetPt:
        def __get__(self):
            self.tJetPt_branch.GetEntry(self.localentry, 0)
            return self.tJetPt_value

    property tL1IsoTauMatch:
        def __get__(self):
            self.tL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.tL1IsoTauMatch_value

    property tL1IsoTauPt:
        def __get__(self):
            self.tL1IsoTauPt_branch.GetEntry(self.localentry, 0)
            return self.tL1IsoTauPt_value

    property tLeadTrackPt:
        def __get__(self):
            self.tLeadTrackPt_branch.GetEntry(self.localentry, 0)
            return self.tLeadTrackPt_value

    property tLooseDeepTau2017v2p1VSe:
        def __get__(self):
            self.tLooseDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v2p1VSe_value

    property tLooseDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tLooseDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v2p1VSjet_value

    property tLooseDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tLooseDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v2p1VSmu_value

    property tLowestMll:
        def __get__(self):
            self.tLowestMll_branch.GetEntry(self.localentry, 0)
            return self.tLowestMll_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.tMatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.tMatchEmbeddedFilterEle24Tau30_value

    property tMatchesEle24HPSTau30Filter:
        def __get__(self):
            self.tMatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24HPSTau30Filter_value

    property tMatchesEle24HPSTau30Path:
        def __get__(self):
            self.tMatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24HPSTau30Path_value

    property tMatchesEle24Tau30Filter:
        def __get__(self):
            self.tMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Filter_value

    property tMatchesEle24Tau30Path:
        def __get__(self):
            self.tMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Path_value

    property tMediumDeepTau2017v2p1VSe:
        def __get__(self):
            self.tMediumDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v2p1VSe_value

    property tMediumDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tMediumDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v2p1VSjet_value

    property tMediumDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tMediumDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v2p1VSmu_value

    property tNChrgHadrIsolationCands:
        def __get__(self):
            self.tNChrgHadrIsolationCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrIsolationCands_value

    property tNChrgHadrSignalCands:
        def __get__(self):
            self.tNChrgHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNChrgHadrSignalCands_value

    property tNGammaSignalCands:
        def __get__(self):
            self.tNGammaSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNGammaSignalCands_value

    property tNNeutralHadrSignalCands:
        def __get__(self):
            self.tNNeutralHadrSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNNeutralHadrSignalCands_value

    property tNSignalCands:
        def __get__(self):
            self.tNSignalCands_branch.GetEntry(self.localentry, 0)
            return self.tNSignalCands_value

    property tNearestZMass:
        def __get__(self):
            self.tNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.tNearestZMass_value

    property tPVDXY:
        def __get__(self):
            self.tPVDXY_branch.GetEntry(self.localentry, 0)
            return self.tPVDXY_value

    property tPVDZ:
        def __get__(self):
            self.tPVDZ_branch.GetEntry(self.localentry, 0)
            return self.tPVDZ_value

    property tPhi:
        def __get__(self):
            self.tPhi_branch.GetEntry(self.localentry, 0)
            return self.tPhi_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tTightDeepTau2017v2p1VSe:
        def __get__(self):
            self.tTightDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v2p1VSe_value

    property tTightDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tTightDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v2p1VSjet_value

    property tTightDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tTightDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v2p1VSmu_value

    property tVLooseDeepTau2017v2p1VSe:
        def __get__(self):
            self.tVLooseDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v2p1VSe_value

    property tVLooseDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tVLooseDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v2p1VSjet_value

    property tVLooseDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tVLooseDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v2p1VSmu_value

    property tVTightDeepTau2017v2p1VSe:
        def __get__(self):
            self.tVTightDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v2p1VSe_value

    property tVTightDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tVTightDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v2p1VSjet_value

    property tVTightDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tVTightDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v2p1VSmu_value

    property tVVLooseDeepTau2017v2p1VSe:
        def __get__(self):
            self.tVVLooseDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v2p1VSe_value

    property tVVLooseDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tVVLooseDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v2p1VSjet_value

    property tVVTightDeepTau2017v2p1VSe:
        def __get__(self):
            self.tVVTightDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v2p1VSe_value

    property tVVTightDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tVVTightDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v2p1VSjet_value

    property tVVTightDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tVVTightDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v2p1VSmu_value

    property tVVVLooseDeepTau2017v2p1VSe:
        def __get__(self):
            self.tVVVLooseDeepTau2017v2p1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v2p1VSe_value

    property tVVVLooseDeepTau2017v2p1VSjet:
        def __get__(self):
            self.tVVVLooseDeepTau2017v2p1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v2p1VSjet_value

    property tVZ:
        def __get__(self):
            self.tVZ_branch.GetEntry(self.localentry, 0)
            return self.tVZ_value

    property tZTTGenDR:
        def __get__(self):
            self.tZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenDR_value

    property tZTTGenEta:
        def __get__(self):
            self.tZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenEta_value

    property tZTTGenMatching:
        def __get__(self):
            self.tZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenMatching_value

    property tZTTGenPhi:
        def __get__(self):
            self.tZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenPhi_value

    property tZTTGenPt:
        def __get__(self):
            self.tZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.tZTTGenPt_value

    property tauVetoPt20LooseMVALTVtx:
        def __get__(self):
            self.tauVetoPt20LooseMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVALTVtx_value

    property tauVetoPtDeepVtx:
        def __get__(self):
            self.tauVetoPtDeepVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPtDeepVtx_value

    property topQuarkPt1:
        def __get__(self):
            self.topQuarkPt1_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt1_value

    property topQuarkPt2:
        def __get__(self):
            self.topQuarkPt2_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt2_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_JERDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JERDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JERDown_value

    property type1_pfMet_shiftedPhi_JERUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JERUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JERUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteyearDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteyearUp_value

    property type1_pfMet_shiftedPhi_JetBBEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1Down_value

    property type1_pfMet_shiftedPhi_JetBBEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1Up_value

    property type1_pfMet_shiftedPhi_JetBBEC1yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1yearDown_value

    property type1_pfMet_shiftedPhi_JetBBEC1yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetBBEC1yearUp_value

    property type1_pfMet_shiftedPhi_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Down_value

    property type1_pfMet_shiftedPhi_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2Up_value

    property type1_pfMet_shiftedPhi_JetEC2yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2yearDown_value

    property type1_pfMet_shiftedPhi_JetEC2yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEC2yearUp_value

    property type1_pfMet_shiftedPhi_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnDown_value

    property type1_pfMet_shiftedPhi_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnUp_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPhi_JetHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFDown_value

    property type1_pfMet_shiftedPhi_JetHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFUp_value

    property type1_pfMet_shiftedPhi_JetHFyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFyearDown_value

    property type1_pfMet_shiftedPhi_JetHFyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetHFyearUp_value

    property type1_pfMet_shiftedPhi_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    property type1_pfMet_shiftedPhi_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPhi_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResDown_value

    property type1_pfMet_shiftedPhi_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResUp_value

    property type1_pfMet_shiftedPhi_JetTotalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTotalDown_value

    property type1_pfMet_shiftedPhi_JetTotalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTotalUp_value

    property type1_pfMet_shiftedPhi_UesCHARGEDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesCHARGEDDown_value

    property type1_pfMet_shiftedPhi_UesCHARGEDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesCHARGEDUp_value

    property type1_pfMet_shiftedPhi_UesECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesECALDown_value

    property type1_pfMet_shiftedPhi_UesECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesECALUp_value

    property type1_pfMet_shiftedPhi_UesHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHCALDown_value

    property type1_pfMet_shiftedPhi_UesHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHCALUp_value

    property type1_pfMet_shiftedPhi_UesHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHFDown_value

    property type1_pfMet_shiftedPhi_UesHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UesHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UesHFUp_value

    property type1_pfMet_shiftedPhi_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    property type1_pfMet_shiftedPhi_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    property type1_pfMet_shiftedPt_JERDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JERDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JERDown_value

    property type1_pfMet_shiftedPt_JERUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JERUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JERUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteyearDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteyearUp_value

    property type1_pfMet_shiftedPt_JetBBEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1Down_value

    property type1_pfMet_shiftedPt_JetBBEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1Up_value

    property type1_pfMet_shiftedPt_JetBBEC1yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1yearDown_value

    property type1_pfMet_shiftedPt_JetBBEC1yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetBBEC1yearUp_value

    property type1_pfMet_shiftedPt_JetEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Down_value

    property type1_pfMet_shiftedPt_JetEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2Up_value

    property type1_pfMet_shiftedPt_JetEC2yearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2yearDown_value

    property type1_pfMet_shiftedPt_JetEC2yearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEC2yearUp_value

    property type1_pfMet_shiftedPt_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnDown_value

    property type1_pfMet_shiftedPt_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnUp_value

    property type1_pfMet_shiftedPt_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPt_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPt_JetHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFDown_value

    property type1_pfMet_shiftedPt_JetHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFUp_value

    property type1_pfMet_shiftedPt_JetHFyearDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFyearDown_value

    property type1_pfMet_shiftedPt_JetHFyearUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetHFyearUp_value

    property type1_pfMet_shiftedPt_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalDown_value

    property type1_pfMet_shiftedPt_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalUp_value

    property type1_pfMet_shiftedPt_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPt_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPt_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResDown_value

    property type1_pfMet_shiftedPt_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResUp_value

    property type1_pfMet_shiftedPt_JetTotalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTotalDown_value

    property type1_pfMet_shiftedPt_JetTotalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTotalUp_value

    property type1_pfMet_shiftedPt_UesCHARGEDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesCHARGEDDown_value

    property type1_pfMet_shiftedPt_UesCHARGEDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesCHARGEDUp_value

    property type1_pfMet_shiftedPt_UesECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesECALDown_value

    property type1_pfMet_shiftedPt_UesECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesECALUp_value

    property type1_pfMet_shiftedPt_UesHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHCALDown_value

    property type1_pfMet_shiftedPt_UesHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHCALUp_value

    property type1_pfMet_shiftedPt_UesHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHFDown_value

    property type1_pfMet_shiftedPt_UesHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UesHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UesHFUp_value

    property type1_pfMet_shiftedPt_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnDown_value

    property type1_pfMet_shiftedPt_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_UnclusteredEnUp_value

    property vbfDeta:
        def __get__(self):
            self.vbfDeta_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_value

    property vbfJetVeto20:
        def __get__(self):
            self.vbfJetVeto20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_value

    property vbfJetVeto30:
        def __get__(self):
            self.vbfJetVeto30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_value

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

    property vbfMassWoNoisyJets:
        def __get__(self):
            self.vbfMassWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_value

    property vbfMassWoNoisyJets_JERDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JERDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JERDown_value

    property vbfMassWoNoisyJets_JERUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JERUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JERUp_value

    property vbfMassWoNoisyJets_JetAbsoluteDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteDown_value

    property vbfMassWoNoisyJets_JetAbsoluteUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteUp_value

    property vbfMassWoNoisyJets_JetAbsoluteyearDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteyearDown_value

    property vbfMassWoNoisyJets_JetAbsoluteyearUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteyearUp_value

    property vbfMassWoNoisyJets_JetBBEC1Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetBBEC1Down_value

    property vbfMassWoNoisyJets_JetBBEC1Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetBBEC1Up_value

    property vbfMassWoNoisyJets_JetBBEC1yearDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetBBEC1yearDown_value

    property vbfMassWoNoisyJets_JetBBEC1yearUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetBBEC1yearUp_value

    property vbfMassWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Down_value

    property vbfMassWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Up_value

    property vbfMassWoNoisyJets_JetEC2yearDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2yearDown_value

    property vbfMassWoNoisyJets_JetEC2yearUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2yearUp_value

    property vbfMassWoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFlavorQCDDown_value

    property vbfMassWoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFlavorQCDUp_value

    property vbfMassWoNoisyJets_JetHFDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetHFDown_value

    property vbfMassWoNoisyJets_JetHFUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetHFUp_value

    property vbfMassWoNoisyJets_JetHFyearDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetHFyearDown_value

    property vbfMassWoNoisyJets_JetHFyearUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetHFyearUp_value

    property vbfMassWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalDown_value

    property vbfMassWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalUp_value

    property vbfMassWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleDown_value

    property vbfMassWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleUp_value

    property vbfMassWoNoisyJets_JetTotalDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTotalDown_value

    property vbfMassWoNoisyJets_JetTotalUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTotalUp_value

    property vbfNJets20:
        def __get__(self):
            self.vbfNJets20_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_value

    property vbfNJets30:
        def __get__(self):
            self.vbfNJets30_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_value

    property vbfj1eta:
        def __get__(self):
            self.vbfj1eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_value

    property vbfj1pt:
        def __get__(self):
            self.vbfj1pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_value

    property vbfj2eta:
        def __get__(self):
            self.vbfj2eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_value

    property vbfj2pt:
        def __get__(self):
            self.vbfj2pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_value

    property vispX:
        def __get__(self):
            self.vispX_branch.GetEntry(self.localentry, 0)
            return self.vispX_value

    property vispY:
        def __get__(self):
            self.vispY_branch.GetEntry(self.localentry, 0)
            return self.vispY_value

    property idx:
        def __get__(self):
            self.idx_branch.GetEntry(self.localentry, 0)
            return self.idx_value


