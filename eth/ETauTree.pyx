

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

    cdef TBranch* DoubleMediumHPSTau35Pass_branch
    cdef float DoubleMediumHPSTau35Pass_value

    cdef TBranch* DoubleMediumHPSTau35TightIDPass_branch
    cdef float DoubleMediumHPSTau35TightIDPass_value

    cdef TBranch* DoubleMediumHPSTau40Pass_branch
    cdef float DoubleMediumHPSTau40Pass_value

    cdef TBranch* DoubleMediumHPSTau40TightIDPass_branch
    cdef float DoubleMediumHPSTau40TightIDPass_value

    cdef TBranch* DoubleMediumTau35Pass_branch
    cdef float DoubleMediumTau35Pass_value

    cdef TBranch* DoubleMediumTau35TightIDPass_branch
    cdef float DoubleMediumTau35TightIDPass_value

    cdef TBranch* DoubleMediumTau40Pass_branch
    cdef float DoubleMediumTau40Pass_value

    cdef TBranch* DoubleMediumTau40TightIDPass_branch
    cdef float DoubleMediumTau40TightIDPass_value

    cdef TBranch* DoubleTightHPSTau35Pass_branch
    cdef float DoubleTightHPSTau35Pass_value

    cdef TBranch* DoubleTightHPSTau35TightIDPass_branch
    cdef float DoubleTightHPSTau35TightIDPass_value

    cdef TBranch* DoubleTightHPSTau40Pass_branch
    cdef float DoubleTightHPSTau40Pass_value

    cdef TBranch* DoubleTightHPSTau40TightIDPass_branch
    cdef float DoubleTightHPSTau40TightIDPass_value

    cdef TBranch* DoubleTightTau35Pass_branch
    cdef float DoubleTightTau35Pass_value

    cdef TBranch* DoubleTightTau35TightIDPass_branch
    cdef float DoubleTightTau35TightIDPass_value

    cdef TBranch* DoubleTightTau40Pass_branch
    cdef float DoubleTightTau40Pass_value

    cdef TBranch* DoubleTightTau40TightIDPass_branch
    cdef float DoubleTightTau40TightIDPass_value

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

    cdef TBranch* Ele38WPTightPass_branch
    cdef float Ele38WPTightPass_value

    cdef TBranch* Ele40WPTightPass_branch
    cdef float Ele40WPTightPass_value

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

    cdef TBranch* Flag_badMuons_branch
    cdef float Flag_badMuons_value

    cdef TBranch* Flag_duplicateMuons_branch
    cdef float Flag_duplicateMuons_value

    cdef TBranch* Flag_ecalBadCalibFilter_branch
    cdef float Flag_ecalBadCalibFilter_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

    cdef TBranch* Flag_globalTightHalo2016Filter_branch
    cdef float Flag_globalTightHalo2016Filter_value

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

    cdef TBranch* Mu20LooseHPSTau27Pass_branch
    cdef float Mu20LooseHPSTau27Pass_value

    cdef TBranch* Mu20LooseHPSTau27TightIDPass_branch
    cdef float Mu20LooseHPSTau27TightIDPass_value

    cdef TBranch* Mu20LooseTau27Pass_branch
    cdef float Mu20LooseTau27Pass_value

    cdef TBranch* Mu20LooseTau27TightIDPass_branch
    cdef float Mu20LooseTau27TightIDPass_value

    cdef TBranch* Mu50Pass_branch
    cdef float Mu50Pass_value

    cdef TBranch* NUP_branch
    cdef float NUP_value

    cdef TBranch* Phi_branch
    cdef float Phi_value

    cdef TBranch* Pt_branch
    cdef float Pt_value

    cdef TBranch* Rivet_VEta_branch
    cdef float Rivet_VEta_value

    cdef TBranch* Rivet_VPt_branch
    cdef float Rivet_VPt_value

    cdef TBranch* Rivet_errorCode_branch
    cdef float Rivet_errorCode_value

    cdef TBranch* Rivet_higgsEta_branch
    cdef float Rivet_higgsEta_value

    cdef TBranch* Rivet_higgsPt_branch
    cdef float Rivet_higgsPt_value

    cdef TBranch* Rivet_nJets25_branch
    cdef float Rivet_nJets25_value

    cdef TBranch* Rivet_nJets30_branch
    cdef float Rivet_nJets30_value

    cdef TBranch* Rivet_p4decay_VEta_branch
    cdef float Rivet_p4decay_VEta_value

    cdef TBranch* Rivet_p4decay_VPt_branch
    cdef float Rivet_p4decay_VPt_value

    cdef TBranch* Rivet_prodMode_branch
    cdef float Rivet_prodMode_value

    cdef TBranch* Rivet_stage0_cat_branch
    cdef float Rivet_stage0_cat_value

    cdef TBranch* Rivet_stage1_cat_pTjet25GeV_branch
    cdef float Rivet_stage1_cat_pTjet25GeV_value

    cdef TBranch* Rivet_stage1_cat_pTjet30GeV_branch
    cdef float Rivet_stage1_cat_pTjet30GeV_value

    cdef TBranch* Rivet_stage1p1_cat_branch
    cdef float Rivet_stage1p1_cat_value

    cdef TBranch* VBFDoubleLooseHPSTau20Pass_branch
    cdef float VBFDoubleLooseHPSTau20Pass_value

    cdef TBranch* VBFDoubleLooseTau20Pass_branch
    cdef float VBFDoubleLooseTau20Pass_value

    cdef TBranch* VBFDoubleMediumHPSTau20Pass_branch
    cdef float VBFDoubleMediumHPSTau20Pass_value

    cdef TBranch* VBFDoubleMediumTau20Pass_branch
    cdef float VBFDoubleMediumTau20Pass_value

    cdef TBranch* VBFDoubleTightHPSTau20Pass_branch
    cdef float VBFDoubleTightHPSTau20Pass_value

    cdef TBranch* VBFDoubleTightTau20Pass_branch
    cdef float VBFDoubleTightTau20Pass_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Loose_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Loose_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_branch
    cdef float bjetDeepCSVVeto20Medium_value

    cdef TBranch* bjetDeepCSVVeto20MediumWoNoisyJets_branch
    cdef float bjetDeepCSVVeto20MediumWoNoisyJets_value

    cdef TBranch* bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0_value

    cdef TBranch* bjetDeepCSVVeto20Medium_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Medium_2018_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2016_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2016_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2017_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2017_DR0p5_value

    cdef TBranch* bjetDeepCSVVeto20Tight_2018_DR0p5_branch
    cdef float bjetDeepCSVVeto20Tight_2018_DR0p5_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimu9ele9Pass_branch
    cdef float dimu9ele9Pass_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* doubleE25Pass_branch
    cdef float doubleE25Pass_value

    cdef TBranch* doubleE33Pass_branch
    cdef float doubleE33Pass_value

    cdef TBranch* doubleE_23_12Pass_branch
    cdef float doubleE_23_12Pass_value

    cdef TBranch* doubleMuDZminMass3p8Pass_branch
    cdef float doubleMuDZminMass3p8Pass_value

    cdef TBranch* doubleMuDZminMass8Pass_branch
    cdef float doubleMuDZminMass8Pass_value

    cdef TBranch* doubleMuSingleEPass_branch
    cdef float doubleMuSingleEPass_value

    cdef TBranch* doubleTau35Pass_branch
    cdef float doubleTau35Pass_value

    cdef TBranch* doubleTauCmbIso35RegPass_branch
    cdef float doubleTauCmbIso35RegPass_value

    cdef TBranch* eCBIDLoose_branch
    cdef float eCBIDLoose_value

    cdef TBranch* eCBIDMedium_branch
    cdef float eCBIDMedium_value

    cdef TBranch* eCBIDTight_branch
    cdef float eCBIDTight_value

    cdef TBranch* eCBIDVeto_branch
    cdef float eCBIDVeto_value

    cdef TBranch* eCharge_branch
    cdef float eCharge_value

    cdef TBranch* eChargeIdLoose_branch
    cdef float eChargeIdLoose_value

    cdef TBranch* eChargeIdMed_branch
    cdef float eChargeIdMed_value

    cdef TBranch* eChargeIdTight_branch
    cdef float eChargeIdTight_value

    cdef TBranch* eComesFromHiggs_branch
    cdef float eComesFromHiggs_value

    cdef TBranch* eCorrectedEt_branch
    cdef float eCorrectedEt_value

    cdef TBranch* eE1x5_branch
    cdef float eE1x5_value

    cdef TBranch* eE2x5Max_branch
    cdef float eE2x5Max_value

    cdef TBranch* eE5x5_branch
    cdef float eE5x5_value

    cdef TBranch* eEcalIsoDR03_branch
    cdef float eEcalIsoDR03_value

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

    cdef TBranch* eHadronicDepth1OverEm_branch
    cdef float eHadronicDepth1OverEm_value

    cdef TBranch* eHadronicDepth2OverEm_branch
    cdef float eHadronicDepth2OverEm_value

    cdef TBranch* eHadronicOverEM_branch
    cdef float eHadronicOverEM_value

    cdef TBranch* eHcalIsoDR03_branch
    cdef float eHcalIsoDR03_value

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

    cdef TBranch* eLowestMll_branch
    cdef float eLowestMll_value

    cdef TBranch* eMVAIsoWP80_branch
    cdef float eMVAIsoWP80_value

    cdef TBranch* eMVAIsoWP90_branch
    cdef float eMVAIsoWP90_value

    cdef TBranch* eMVAIsoWPHZZ_branch
    cdef float eMVAIsoWPHZZ_value

    cdef TBranch* eMVAIsoWPLoose_branch
    cdef float eMVAIsoWPLoose_value

    cdef TBranch* eMVANoisoWP80_branch
    cdef float eMVANoisoWP80_value

    cdef TBranch* eMVANoisoWP90_branch
    cdef float eMVANoisoWP90_value

    cdef TBranch* eMVANoisoWPLoose_branch
    cdef float eMVANoisoWPLoose_value

    cdef TBranch* eMass_branch
    cdef float eMass_value

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

    cdef TBranch* eMissingHits_branch
    cdef float eMissingHits_value

    cdef TBranch* eNearMuonVeto_branch
    cdef float eNearMuonVeto_value

    cdef TBranch* eNearestMuonDR_branch
    cdef float eNearestMuonDR_value

    cdef TBranch* eNearestZMass_branch
    cdef float eNearestZMass_value

    cdef TBranch* ePFChargedIso_branch
    cdef float ePFChargedIso_value

    cdef TBranch* ePFNeutralIso_branch
    cdef float ePFNeutralIso_value

    cdef TBranch* ePFPUChargedIso_branch
    cdef float ePFPUChargedIso_value

    cdef TBranch* ePFPhotonIso_branch
    cdef float ePFPhotonIso_value

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

    cdef TBranch* eRelIso_branch
    cdef float eRelIso_value

    cdef TBranch* eRelPFIsoDB_branch
    cdef float eRelPFIsoDB_value

    cdef TBranch* eRelPFIsoRho_branch
    cdef float eRelPFIsoRho_value

    cdef TBranch* eRho_branch
    cdef float eRho_value

    cdef TBranch* eSCEnergy_branch
    cdef float eSCEnergy_value

    cdef TBranch* eSCEta_branch
    cdef float eSCEta_value

    cdef TBranch* eSCEtaWidth_branch
    cdef float eSCEtaWidth_value

    cdef TBranch* eSCPhi_branch
    cdef float eSCPhi_value

    cdef TBranch* eSCPhiWidth_branch
    cdef float eSCPhiWidth_value

    cdef TBranch* eSCPreshowerEnergy_branch
    cdef float eSCPreshowerEnergy_value

    cdef TBranch* eSCRawEnergy_branch
    cdef float eSCRawEnergy_value

    cdef TBranch* eSIP2D_branch
    cdef float eSIP2D_value

    cdef TBranch* eSIP3D_branch
    cdef float eSIP3D_value

    cdef TBranch* eSigmaIEtaIEta_branch
    cdef float eSigmaIEtaIEta_value

    cdef TBranch* eTrkIsoDR03_branch
    cdef float eTrkIsoDR03_value

    cdef TBranch* eVZ_branch
    cdef float eVZ_value

    cdef TBranch* eVetoHZZPt5_branch
    cdef float eVetoHZZPt5_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eVetoZTTp001dxyzR0_branch
    cdef float eVetoZTTp001dxyzR0_value

    cdef TBranch* eZTTGenDR_branch
    cdef float eZTTGenDR_value

    cdef TBranch* eZTTGenEta_branch
    cdef float eZTTGenEta_value

    cdef TBranch* eZTTGenMatching_branch
    cdef float eZTTGenMatching_value

    cdef TBranch* eZTTGenPhi_branch
    cdef float eZTTGenPhi_value

    cdef TBranch* eZTTGenPt_branch
    cdef float eZTTGenPt_value

    cdef TBranch* e_t_DR_branch
    cdef float e_t_DR_value

    cdef TBranch* e_t_Mass_branch
    cdef float e_t_Mass_value

    cdef TBranch* e_t_PZeta_branch
    cdef float e_t_PZeta_value

    cdef TBranch* e_t_PZetaVis_branch
    cdef float e_t_PZetaVis_value

    cdef TBranch* e_t_doubleL1IsoTauMatch_branch
    cdef float e_t_doubleL1IsoTauMatch_value

    cdef TBranch* edeltaEtaSuperClusterTrackAtVtx_branch
    cdef float edeltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* edeltaPhiSuperClusterTrackAtVtx_branch
    cdef float edeltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* eeSuperClusterOverP_branch
    cdef float eeSuperClusterOverP_value

    cdef TBranch* eecalEnergy_branch
    cdef float eecalEnergy_value

    cdef TBranch* efBrem_branch
    cdef float efBrem_value

    cdef TBranch* etrackMomentumAtVtxP_branch
    cdef float etrackMomentumAtVtxP_value

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

    cdef TBranch* j1ptWoNoisyJets_JetEC2Down_branch
    cdef float j1ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEC2Up_branch
    cdef float j1ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to3Down_branch
    cdef float j1ptWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to3Up_branch
    cdef float j1ptWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to5Down_branch
    cdef float j1ptWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta0to5Up_branch
    cdef float j1ptWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* j1ptWoNoisyJets_JetEta3to5Down_branch
    cdef float j1ptWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* j1ptWoNoisyJets_JetEta3to5Up_branch
    cdef float j1ptWoNoisyJets_JetEta3to5Up_value

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

    cdef TBranch* j2ptWoNoisyJets_JetEC2Down_branch
    cdef float j2ptWoNoisyJets_JetEC2Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEC2Up_branch
    cdef float j2ptWoNoisyJets_JetEC2Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to3Down_branch
    cdef float j2ptWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to3Up_branch
    cdef float j2ptWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to5Down_branch
    cdef float j2ptWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta0to5Up_branch
    cdef float j2ptWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* j2ptWoNoisyJets_JetEta3to5Down_branch
    cdef float j2ptWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* j2ptWoNoisyJets_JetEta3to5Up_branch
    cdef float j2ptWoNoisyJets_JetEta3to5Up_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeBalUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleDown_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* j2ptWoNoisyJets_JetRelativeSampleUp_branch
    cdef float j2ptWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* jb1eta_branch
    cdef float jb1eta_value

    cdef TBranch* jb1eta_2016_branch
    cdef float jb1eta_2016_value

    cdef TBranch* jb1eta_2017_branch
    cdef float jb1eta_2017_value

    cdef TBranch* jb1eta_2018_branch
    cdef float jb1eta_2018_value

    cdef TBranch* jb1hadronflavor_branch
    cdef float jb1hadronflavor_value

    cdef TBranch* jb1hadronflavor_2016_branch
    cdef float jb1hadronflavor_2016_value

    cdef TBranch* jb1hadronflavor_2017_branch
    cdef float jb1hadronflavor_2017_value

    cdef TBranch* jb1hadronflavor_2018_branch
    cdef float jb1hadronflavor_2018_value

    cdef TBranch* jb1phi_branch
    cdef float jb1phi_value

    cdef TBranch* jb1phi_2016_branch
    cdef float jb1phi_2016_value

    cdef TBranch* jb1phi_2017_branch
    cdef float jb1phi_2017_value

    cdef TBranch* jb1phi_2018_branch
    cdef float jb1phi_2018_value

    cdef TBranch* jb1pt_branch
    cdef float jb1pt_value

    cdef TBranch* jb1pt_2016_branch
    cdef float jb1pt_2016_value

    cdef TBranch* jb1pt_2017_branch
    cdef float jb1pt_2017_value

    cdef TBranch* jb1pt_2018_branch
    cdef float jb1pt_2018_value

    cdef TBranch* jb2eta_branch
    cdef float jb2eta_value

    cdef TBranch* jb2eta_2016_branch
    cdef float jb2eta_2016_value

    cdef TBranch* jb2eta_2017_branch
    cdef float jb2eta_2017_value

    cdef TBranch* jb2eta_2018_branch
    cdef float jb2eta_2018_value

    cdef TBranch* jb2hadronflavor_branch
    cdef float jb2hadronflavor_value

    cdef TBranch* jb2hadronflavor_2016_branch
    cdef float jb2hadronflavor_2016_value

    cdef TBranch* jb2hadronflavor_2017_branch
    cdef float jb2hadronflavor_2017_value

    cdef TBranch* jb2hadronflavor_2018_branch
    cdef float jb2hadronflavor_2018_value

    cdef TBranch* jb2phi_branch
    cdef float jb2phi_value

    cdef TBranch* jb2phi_2016_branch
    cdef float jb2phi_2016_value

    cdef TBranch* jb2phi_2017_branch
    cdef float jb2phi_2017_value

    cdef TBranch* jb2phi_2018_branch
    cdef float jb2phi_2018_value

    cdef TBranch* jb2pt_branch
    cdef float jb2pt_value

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

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30WoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteScaleDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteScaleUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteStatDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch
    cdef float jetVeto30WoNoisyJets_JetAbsoluteStatUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetClosureDown_branch
    cdef float jetVeto30WoNoisyJets_JetClosureDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetClosureUp_branch
    cdef float jetVeto30WoNoisyJets_JetClosureUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetEC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to3Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to3Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to3Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to3Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to5Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to5Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta0to5Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta0to5Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta3to5Down_branch
    cdef float jetVeto30WoNoisyJets_JetEta3to5Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEta3to5Up_branch
    cdef float jetVeto30WoNoisyJets_JetEta3to5Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFlavorQCDDown_branch
    cdef float jetVeto30WoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFlavorQCDUp_branch
    cdef float jetVeto30WoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFragmentationDown_branch
    cdef float jetVeto30WoNoisyJets_JetFragmentationDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetFragmentationUp_branch
    cdef float jetVeto30WoNoisyJets_JetFragmentationUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpDataMCDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpDataMCUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtBBDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtBBUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtEC1Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtEC1Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtEC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtEC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtHFDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtHFUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtRefDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch
    cdef float jetVeto30WoNoisyJets_JetPileUpPtRefUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeBalUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeFSRDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeFSRDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeFSRUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeFSRUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJEREC1Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJEREC1Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJEREC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJEREC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJERHFDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeJERHFUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtBBDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtBBDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtBBUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtBBUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtEC1Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtEC1Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtEC2Down_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtEC2Up_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtHFDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtHFDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativePtHFUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativePtHFUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeSampleUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatECDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatECDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatECUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatECUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatFSRDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatFSRUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatHFDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch
    cdef float jetVeto30WoNoisyJets_JetRelativeStatHFUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetSinglePionECALDown_branch
    cdef float jetVeto30WoNoisyJets_JetSinglePionECALDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetSinglePionECALUp_branch
    cdef float jetVeto30WoNoisyJets_JetSinglePionECALUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch
    cdef float jetVeto30WoNoisyJets_JetSinglePionHCALDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch
    cdef float jetVeto30WoNoisyJets_JetSinglePionHCALUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTimePtEtaDown_branch
    cdef float jetVeto30WoNoisyJets_JetTimePtEtaDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTimePtEtaUp_branch
    cdef float jetVeto30WoNoisyJets_JetTimePtEtaUp_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalDown_branch
    cdef float jetVeto30WoNoisyJets_JetTotalDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetTotalUp_branch
    cdef float jetVeto30WoNoisyJets_JetTotalUp_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

    cdef TBranch* mu12e23DZPass_branch
    cdef float mu12e23DZPass_value

    cdef TBranch* mu12e23Pass_branch
    cdef float mu12e23Pass_value

    cdef TBranch* mu23e12DZPass_branch
    cdef float mu23e12DZPass_value

    cdef TBranch* mu23e12Pass_branch
    cdef float mu23e12Pass_value

    cdef TBranch* mu8diele12DZPass_branch
    cdef float mu8diele12DZPass_value

    cdef TBranch* mu8diele12Pass_branch
    cdef float mu8diele12Pass_value

    cdef TBranch* mu8e23DZPass_branch
    cdef float mu8e23DZPass_value

    cdef TBranch* mu8e23Pass_branch
    cdef float mu8e23Pass_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVeto5_branch
    cdef float muVeto5_value

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* muVetoZTTp001dxyzR0_branch
    cdef float muVetoZTTp001dxyzR0_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

    cdef TBranch* npNLO_branch
    cdef float npNLO_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* nvtx_branch
    cdef float nvtx_value

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

    cdef TBranch* raw_pfMetEt_branch
    cdef float raw_pfMetEt_value

    cdef TBranch* raw_pfMetPhi_branch
    cdef float raw_pfMetPhi_value

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

    cdef TBranch* singleIsoMu22Pass_branch
    cdef float singleIsoMu22Pass_value

    cdef TBranch* singleIsoMu22eta2p1Pass_branch
    cdef float singleIsoMu22eta2p1Pass_value

    cdef TBranch* singleIsoTkMu22Pass_branch
    cdef float singleIsoTkMu22Pass_value

    cdef TBranch* singleIsoTkMu22eta2p1Pass_branch
    cdef float singleIsoTkMu22eta2p1Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20Pass_branch
    cdef float singleMu19eta2p1LooseTau20Pass_value

    cdef TBranch* singleMu19eta2p1LooseTau20singleL1Pass_branch
    cdef float singleMu19eta2p1LooseTau20singleL1Pass_value

    cdef TBranch* tAgainstElectronLooseMVA6_branch
    cdef float tAgainstElectronLooseMVA6_value

    cdef TBranch* tAgainstElectronLooseMVA62018_branch
    cdef float tAgainstElectronLooseMVA62018_value

    cdef TBranch* tAgainstElectronMVA6Raw_branch
    cdef float tAgainstElectronMVA6Raw_value

    cdef TBranch* tAgainstElectronMVA6Raw2018_branch
    cdef float tAgainstElectronMVA6Raw2018_value

    cdef TBranch* tAgainstElectronMVA6category_branch
    cdef float tAgainstElectronMVA6category_value

    cdef TBranch* tAgainstElectronMVA6category2018_branch
    cdef float tAgainstElectronMVA6category2018_value

    cdef TBranch* tAgainstElectronMediumMVA6_branch
    cdef float tAgainstElectronMediumMVA6_value

    cdef TBranch* tAgainstElectronMediumMVA62018_branch
    cdef float tAgainstElectronMediumMVA62018_value

    cdef TBranch* tAgainstElectronTightMVA6_branch
    cdef float tAgainstElectronTightMVA6_value

    cdef TBranch* tAgainstElectronTightMVA62018_branch
    cdef float tAgainstElectronTightMVA62018_value

    cdef TBranch* tAgainstElectronVLooseMVA6_branch
    cdef float tAgainstElectronVLooseMVA6_value

    cdef TBranch* tAgainstElectronVLooseMVA62018_branch
    cdef float tAgainstElectronVLooseMVA62018_value

    cdef TBranch* tAgainstElectronVTightMVA6_branch
    cdef float tAgainstElectronVTightMVA6_value

    cdef TBranch* tAgainstElectronVTightMVA62018_branch
    cdef float tAgainstElectronVTightMVA62018_value

    cdef TBranch* tAgainstMuonLoose3_branch
    cdef float tAgainstMuonLoose3_value

    cdef TBranch* tAgainstMuonTight3_branch
    cdef float tAgainstMuonTight3_value

    cdef TBranch* tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch
    cdef float tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    cdef TBranch* tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBnewDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBnewDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBoldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBoldDMwLTraw_value

    cdef TBranch* tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByPhotonPtSumOutsideSignalCone_branch
    cdef float tByPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tByTightCombinedIsolationDeltaBetaCorr3Hits_branch
    cdef float tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    cdef TBranch* tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBnewDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tCharge_branch
    cdef float tCharge_value

    cdef TBranch* tChargedIsoPtSum_branch
    cdef float tChargedIsoPtSum_value

    cdef TBranch* tChargedIsoPtSumdR03_branch
    cdef float tChargedIsoPtSumdR03_value

    cdef TBranch* tComesFromHiggs_branch
    cdef float tComesFromHiggs_value

    cdef TBranch* tDecayMode_branch
    cdef float tDecayMode_value

    cdef TBranch* tDecayModeFinding_branch
    cdef float tDecayModeFinding_value

    cdef TBranch* tDecayModeFindingNewDMs_branch
    cdef float tDecayModeFindingNewDMs_value

    cdef TBranch* tDeepTau2017v1VSeraw_branch
    cdef float tDeepTau2017v1VSeraw_value

    cdef TBranch* tDeepTau2017v1VSjetraw_branch
    cdef float tDeepTau2017v1VSjetraw_value

    cdef TBranch* tDeepTau2017v1VSmuraw_branch
    cdef float tDeepTau2017v1VSmuraw_value

    cdef TBranch* tDpfTau2016v0VSallraw_branch
    cdef float tDpfTau2016v0VSallraw_value

    cdef TBranch* tDpfTau2016v1VSallraw_branch
    cdef float tDpfTau2016v1VSallraw_value

    cdef TBranch* tEta_branch
    cdef float tEta_value

    cdef TBranch* tFootprintCorrection_branch
    cdef float tFootprintCorrection_value

    cdef TBranch* tFootprintCorrectiondR03_branch
    cdef float tFootprintCorrectiondR03_value

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

    cdef TBranch* tLooseDeepTau2017v1VSe_branch
    cdef float tLooseDeepTau2017v1VSe_value

    cdef TBranch* tLooseDeepTau2017v1VSjet_branch
    cdef float tLooseDeepTau2017v1VSjet_value

    cdef TBranch* tLooseDeepTau2017v1VSmu_branch
    cdef float tLooseDeepTau2017v1VSmu_value

    cdef TBranch* tLowestMll_branch
    cdef float tLowestMll_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMatchesDoubleMediumCombinedIsoTau35Path_branch
    cdef float tMatchesDoubleMediumCombinedIsoTau35Path_value

    cdef TBranch* tMatchesDoubleMediumHPSTau35Filter_branch
    cdef float tMatchesDoubleMediumHPSTau35Filter_value

    cdef TBranch* tMatchesDoubleMediumHPSTau35Path_branch
    cdef float tMatchesDoubleMediumHPSTau35Path_value

    cdef TBranch* tMatchesDoubleMediumHPSTau40Filter_branch
    cdef float tMatchesDoubleMediumHPSTau40Filter_value

    cdef TBranch* tMatchesDoubleMediumHPSTau40Path_branch
    cdef float tMatchesDoubleMediumHPSTau40Path_value

    cdef TBranch* tMatchesDoubleMediumIsoTau35Path_branch
    cdef float tMatchesDoubleMediumIsoTau35Path_value

    cdef TBranch* tMatchesDoubleMediumTau35Filter_branch
    cdef float tMatchesDoubleMediumTau35Filter_value

    cdef TBranch* tMatchesDoubleMediumTau35Path_branch
    cdef float tMatchesDoubleMediumTau35Path_value

    cdef TBranch* tMatchesDoubleMediumTau40Filter_branch
    cdef float tMatchesDoubleMediumTau40Filter_value

    cdef TBranch* tMatchesDoubleMediumTau40Path_branch
    cdef float tMatchesDoubleMediumTau40Path_value

    cdef TBranch* tMatchesDoubleTightHPSTau35Filter_branch
    cdef float tMatchesDoubleTightHPSTau35Filter_value

    cdef TBranch* tMatchesDoubleTightHPSTau35Path_branch
    cdef float tMatchesDoubleTightHPSTau35Path_value

    cdef TBranch* tMatchesDoubleTightHPSTau40Filter_branch
    cdef float tMatchesDoubleTightHPSTau40Filter_value

    cdef TBranch* tMatchesDoubleTightHPSTau40Path_branch
    cdef float tMatchesDoubleTightHPSTau40Path_value

    cdef TBranch* tMatchesDoubleTightTau35Filter_branch
    cdef float tMatchesDoubleTightTau35Filter_value

    cdef TBranch* tMatchesDoubleTightTau35Path_branch
    cdef float tMatchesDoubleTightTau35Path_value

    cdef TBranch* tMatchesDoubleTightTau40Filter_branch
    cdef float tMatchesDoubleTightTau40Filter_value

    cdef TBranch* tMatchesDoubleTightTau40Path_branch
    cdef float tMatchesDoubleTightTau40Path_value

    cdef TBranch* tMatchesEle24HPSTau30Filter_branch
    cdef float tMatchesEle24HPSTau30Filter_value

    cdef TBranch* tMatchesEle24HPSTau30Path_branch
    cdef float tMatchesEle24HPSTau30Path_value

    cdef TBranch* tMatchesEle24Tau30Filter_branch
    cdef float tMatchesEle24Tau30Filter_value

    cdef TBranch* tMatchesEle24Tau30Path_branch
    cdef float tMatchesEle24Tau30Path_value

    cdef TBranch* tMatchesIsoMu19Tau20Filter_branch
    cdef float tMatchesIsoMu19Tau20Filter_value

    cdef TBranch* tMatchesIsoMu19Tau20Path_branch
    cdef float tMatchesIsoMu19Tau20Path_value

    cdef TBranch* tMatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float tMatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* tMatchesIsoMu19Tau20SingleL1Path_branch
    cdef float tMatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* tMatchesIsoMu20HPSTau27Filter_branch
    cdef float tMatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* tMatchesIsoMu20HPSTau27Path_branch
    cdef float tMatchesIsoMu20HPSTau27Path_value

    cdef TBranch* tMatchesIsoMu20Tau27Filter_branch
    cdef float tMatchesIsoMu20Tau27Filter_value

    cdef TBranch* tMatchesIsoMu20Tau27Path_branch
    cdef float tMatchesIsoMu20Tau27Path_value

    cdef TBranch* tMediumDeepTau2017v1VSe_branch
    cdef float tMediumDeepTau2017v1VSe_value

    cdef TBranch* tMediumDeepTau2017v1VSjet_branch
    cdef float tMediumDeepTau2017v1VSjet_value

    cdef TBranch* tMediumDeepTau2017v1VSmu_branch
    cdef float tMediumDeepTau2017v1VSmu_value

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

    cdef TBranch* tNeutralIsoPtSum_branch
    cdef float tNeutralIsoPtSum_value

    cdef TBranch* tNeutralIsoPtSumWeight_branch
    cdef float tNeutralIsoPtSumWeight_value

    cdef TBranch* tNeutralIsoPtSumWeightdR03_branch
    cdef float tNeutralIsoPtSumWeightdR03_value

    cdef TBranch* tNeutralIsoPtSumdR03_branch
    cdef float tNeutralIsoPtSumdR03_value

    cdef TBranch* tPVDXY_branch
    cdef float tPVDXY_value

    cdef TBranch* tPVDZ_branch
    cdef float tPVDZ_value

    cdef TBranch* tPhi_branch
    cdef float tPhi_value

    cdef TBranch* tPhotonPtSumOutsideSignalCone_branch
    cdef float tPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tPhotonPtSumOutsideSignalConedR03_branch
    cdef float tPhotonPtSumOutsideSignalConedR03_value

    cdef TBranch* tPt_branch
    cdef float tPt_value

    cdef TBranch* tPuCorrPtSum_branch
    cdef float tPuCorrPtSum_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTLoose_branch
    cdef float tRerunMVArun2v2DBoldDMwLTLoose_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTMedium_branch
    cdef float tRerunMVArun2v2DBoldDMwLTMedium_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTTight_branch
    cdef float tRerunMVArun2v2DBoldDMwLTTight_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTVLoose_branch
    cdef float tRerunMVArun2v2DBoldDMwLTVLoose_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTVTight_branch
    cdef float tRerunMVArun2v2DBoldDMwLTVTight_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTVVLoose_branch
    cdef float tRerunMVArun2v2DBoldDMwLTVVLoose_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTVVTight_branch
    cdef float tRerunMVArun2v2DBoldDMwLTVVTight_value

    cdef TBranch* tRerunMVArun2v2DBoldDMwLTraw_branch
    cdef float tRerunMVArun2v2DBoldDMwLTraw_value

    cdef TBranch* tTightDeepTau2017v1VSe_branch
    cdef float tTightDeepTau2017v1VSe_value

    cdef TBranch* tTightDeepTau2017v1VSjet_branch
    cdef float tTightDeepTau2017v1VSjet_value

    cdef TBranch* tTightDeepTau2017v1VSmu_branch
    cdef float tTightDeepTau2017v1VSmu_value

    cdef TBranch* tTightDpfTau2016v0VSall_branch
    cdef float tTightDpfTau2016v0VSall_value

    cdef TBranch* tTightDpfTau2016v1VSall_branch
    cdef float tTightDpfTau2016v1VSall_value

    cdef TBranch* tVLooseDeepTau2017v1VSe_branch
    cdef float tVLooseDeepTau2017v1VSe_value

    cdef TBranch* tVLooseDeepTau2017v1VSjet_branch
    cdef float tVLooseDeepTau2017v1VSjet_value

    cdef TBranch* tVLooseDeepTau2017v1VSmu_branch
    cdef float tVLooseDeepTau2017v1VSmu_value

    cdef TBranch* tVTightDeepTau2017v1VSe_branch
    cdef float tVTightDeepTau2017v1VSe_value

    cdef TBranch* tVTightDeepTau2017v1VSjet_branch
    cdef float tVTightDeepTau2017v1VSjet_value

    cdef TBranch* tVTightDeepTau2017v1VSmu_branch
    cdef float tVTightDeepTau2017v1VSmu_value

    cdef TBranch* tVVLooseDeepTau2017v1VSe_branch
    cdef float tVVLooseDeepTau2017v1VSe_value

    cdef TBranch* tVVLooseDeepTau2017v1VSjet_branch
    cdef float tVVLooseDeepTau2017v1VSjet_value

    cdef TBranch* tVVLooseDeepTau2017v1VSmu_branch
    cdef float tVVLooseDeepTau2017v1VSmu_value

    cdef TBranch* tVVTightDeepTau2017v1VSe_branch
    cdef float tVVTightDeepTau2017v1VSe_value

    cdef TBranch* tVVTightDeepTau2017v1VSjet_branch
    cdef float tVVTightDeepTau2017v1VSjet_value

    cdef TBranch* tVVTightDeepTau2017v1VSmu_branch
    cdef float tVVTightDeepTau2017v1VSmu_value

    cdef TBranch* tVVVLooseDeepTau2017v1VSe_branch
    cdef float tVVVLooseDeepTau2017v1VSe_value

    cdef TBranch* tVVVLooseDeepTau2017v1VSjet_branch
    cdef float tVVVLooseDeepTau2017v1VSjet_value

    cdef TBranch* tVVVLooseDeepTau2017v1VSmu_branch
    cdef float tVVVLooseDeepTau2017v1VSmu_value

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

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20LooseMVALTVtx_branch
    cdef float tauVetoPt20LooseMVALTVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

    cdef TBranch* tripleEPass_branch
    cdef float tripleEPass_value

    cdef TBranch* tripleMu10_5_5Pass_branch
    cdef float tripleMu10_5_5Pass_value

    cdef TBranch* tripleMu12_10_5Pass_branch
    cdef float tripleMu12_10_5Pass_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch
    cdef float type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetClosureDown_branch
    cdef float type1_pfMet_shiftedPhi_JetClosureDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetClosureUp_branch
    cdef float type1_pfMet_shiftedPhi_JetClosureUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to3Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to3Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to3Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to3Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to5Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to5Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta0to5Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta0to5Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta3to5Down_branch
    cdef float type1_pfMet_shiftedPhi_JetEta3to5Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEta3to5Up_branch
    cdef float type1_pfMet_shiftedPhi_JetEta3to5Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFragmentationDown_branch
    cdef float type1_pfMet_shiftedPhi_JetFragmentationDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetFragmentationUp_branch
    cdef float type1_pfMet_shiftedPhi_JetFragmentationUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch
    cdef float type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativePtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatECDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatECUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch
    cdef float type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResDown_branch
    cdef float type1_pfMet_shiftedPhi_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetResUp_branch
    cdef float type1_pfMet_shiftedPhi_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionECALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionECALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch
    cdef float type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch
    cdef float type1_pfMet_shiftedPhi_JetTimePtEtaDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch
    cdef float type1_pfMet_shiftedPhi_JetTimePtEtaUp_value

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

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteStatDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch
    cdef float type1_pfMet_shiftedPt_JetAbsoluteStatUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetClosureDown_branch
    cdef float type1_pfMet_shiftedPt_JetClosureDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetClosureUp_branch
    cdef float type1_pfMet_shiftedPt_JetClosureUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to3Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to3Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to3Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to3Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to5Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to5Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta0to5Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta0to5Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta3to5Down_branch
    cdef float type1_pfMet_shiftedPt_JetEta3to5Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEta3to5Up_branch
    cdef float type1_pfMet_shiftedPt_JetEta3to5Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDDown_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFlavorQCDUp_branch
    cdef float type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFragmentationDown_branch
    cdef float type1_pfMet_shiftedPt_JetFragmentationDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetFragmentationUp_branch
    cdef float type1_pfMet_shiftedPt_JetFragmentationUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpDataMCDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpDataMCUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtRefDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch
    cdef float type1_pfMet_shiftedPt_JetPileUpPtRefUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeBalUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeBalUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeFSRDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeFSRUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJERHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeJERHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtBBDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtBBDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtBBUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtBBUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC1Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC1Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC2Down_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtEC2Up_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativePtHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativePtHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeSampleUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatECDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatECDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatECUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatECUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatHFDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch
    cdef float type1_pfMet_shiftedPt_JetRelativeStatHFUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResDown_branch
    cdef float type1_pfMet_shiftedPt_JetResDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetResUp_branch
    cdef float type1_pfMet_shiftedPt_JetResUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionECALDown_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionECALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionECALUp_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionECALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionHCALDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch
    cdef float type1_pfMet_shiftedPt_JetSinglePionHCALUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTimePtEtaDown_branch
    cdef float type1_pfMet_shiftedPt_JetTimePtEtaDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetTimePtEtaUp_branch
    cdef float type1_pfMet_shiftedPt_JetTimePtEtaUp_value

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

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteScaleDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteScaleUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteStatDown_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteStatDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetAbsoluteStatUp_branch
    cdef float vbfMassWoNoisyJets_JetAbsoluteStatUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetClosureDown_branch
    cdef float vbfMassWoNoisyJets_JetClosureDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetClosureUp_branch
    cdef float vbfMassWoNoisyJets_JetClosureUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Down_branch
    cdef float vbfMassWoNoisyJets_JetEC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEC2Up_branch
    cdef float vbfMassWoNoisyJets_JetEC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to3Down_branch
    cdef float vbfMassWoNoisyJets_JetEta0to3Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to3Up_branch
    cdef float vbfMassWoNoisyJets_JetEta0to3Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to5Down_branch
    cdef float vbfMassWoNoisyJets_JetEta0to5Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta0to5Up_branch
    cdef float vbfMassWoNoisyJets_JetEta0to5Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta3to5Down_branch
    cdef float vbfMassWoNoisyJets_JetEta3to5Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetEta3to5Up_branch
    cdef float vbfMassWoNoisyJets_JetEta3to5Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetFlavorQCDDown_branch
    cdef float vbfMassWoNoisyJets_JetFlavorQCDDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetFlavorQCDUp_branch
    cdef float vbfMassWoNoisyJets_JetFlavorQCDUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetFragmentationDown_branch
    cdef float vbfMassWoNoisyJets_JetFragmentationDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetFragmentationUp_branch
    cdef float vbfMassWoNoisyJets_JetFragmentationUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpDataMCDown_branch
    cdef float vbfMassWoNoisyJets_JetPileUpDataMCDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpDataMCUp_branch
    cdef float vbfMassWoNoisyJets_JetPileUpDataMCUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtBBDown_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtBBDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtBBUp_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtBBUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtEC1Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtEC1Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtEC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtEC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtHFDown_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtHFDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtHFUp_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtHFUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtRefDown_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtRefDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetPileUpPtRefUp_branch
    cdef float vbfMassWoNoisyJets_JetPileUpPtRefUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeBalUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeBalUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeFSRDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeFSRDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeFSRUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeFSRUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJEREC1Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJEREC1Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJEREC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJEREC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJERHFDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJERHFDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeJERHFUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeJERHFUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtBBDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtBBDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtBBUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtBBUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtEC1Down_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtEC1Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtEC1Up_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtEC1Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtEC2Down_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtEC2Down_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtEC2Up_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtEC2Up_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtHFDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtHFDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativePtHFUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativePtHFUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeSampleUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeSampleUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatECDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatECDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatECUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatECUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatFSRDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatFSRUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatHFDown_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatHFDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetRelativeStatHFUp_branch
    cdef float vbfMassWoNoisyJets_JetRelativeStatHFUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetSinglePionECALDown_branch
    cdef float vbfMassWoNoisyJets_JetSinglePionECALDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetSinglePionECALUp_branch
    cdef float vbfMassWoNoisyJets_JetSinglePionECALUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetSinglePionHCALDown_branch
    cdef float vbfMassWoNoisyJets_JetSinglePionHCALDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetSinglePionHCALUp_branch
    cdef float vbfMassWoNoisyJets_JetSinglePionHCALUp_value

    cdef TBranch* vbfMassWoNoisyJets_JetTimePtEtaDown_branch
    cdef float vbfMassWoNoisyJets_JetTimePtEtaDown_value

    cdef TBranch* vbfMassWoNoisyJets_JetTimePtEtaUp_branch
    cdef float vbfMassWoNoisyJets_JetTimePtEtaUp_value

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

        #print "making DoubleMediumHPSTau35Pass"
        self.DoubleMediumHPSTau35Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau35Pass")
        #if not self.DoubleMediumHPSTau35Pass_branch and "DoubleMediumHPSTau35Pass" not in self.complained:
        if not self.DoubleMediumHPSTau35Pass_branch and "DoubleMediumHPSTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "ETauTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

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

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "ETauTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

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

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "ETauTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "ETauTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "ETauTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

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

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "ETauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

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

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "ETauTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

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

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "ETauTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "ETauTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "ETauTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "ETauTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "ETauTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "ETauTree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "ETauTree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "ETauTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "ETauTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "ETauTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "ETauTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "ETauTree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "ETauTree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making Rivet_stage1p1_cat"
        self.Rivet_stage1p1_cat_branch = the_tree.GetBranch("Rivet_stage1p1_cat")
        #if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat" not in self.complained:
        if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat":
            warnings.warn( "ETauTree: Expected branch Rivet_stage1p1_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1p1_cat")
        else:
            self.Rivet_stage1p1_cat_branch.SetAddress(<void*>&self.Rivet_stage1p1_cat_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "ETauTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "ETauTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "ETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "ETauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "ETauTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "ETauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "ETauTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "ETauTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "ETauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "ETauTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "ETauTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "ETauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "ETauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "ETauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making eCBIDLoose"
        self.eCBIDLoose_branch = the_tree.GetBranch("eCBIDLoose")
        #if not self.eCBIDLoose_branch and "eCBIDLoose" not in self.complained:
        if not self.eCBIDLoose_branch and "eCBIDLoose":
            warnings.warn( "ETauTree: Expected branch eCBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDLoose")
        else:
            self.eCBIDLoose_branch.SetAddress(<void*>&self.eCBIDLoose_value)

        #print "making eCBIDMedium"
        self.eCBIDMedium_branch = the_tree.GetBranch("eCBIDMedium")
        #if not self.eCBIDMedium_branch and "eCBIDMedium" not in self.complained:
        if not self.eCBIDMedium_branch and "eCBIDMedium":
            warnings.warn( "ETauTree: Expected branch eCBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDMedium")
        else:
            self.eCBIDMedium_branch.SetAddress(<void*>&self.eCBIDMedium_value)

        #print "making eCBIDTight"
        self.eCBIDTight_branch = the_tree.GetBranch("eCBIDTight")
        #if not self.eCBIDTight_branch and "eCBIDTight" not in self.complained:
        if not self.eCBIDTight_branch and "eCBIDTight":
            warnings.warn( "ETauTree: Expected branch eCBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDTight")
        else:
            self.eCBIDTight_branch.SetAddress(<void*>&self.eCBIDTight_value)

        #print "making eCBIDVeto"
        self.eCBIDVeto_branch = the_tree.GetBranch("eCBIDVeto")
        #if not self.eCBIDVeto_branch and "eCBIDVeto" not in self.complained:
        if not self.eCBIDVeto_branch and "eCBIDVeto":
            warnings.warn( "ETauTree: Expected branch eCBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCBIDVeto")
        else:
            self.eCBIDVeto_branch.SetAddress(<void*>&self.eCBIDVeto_value)

        #print "making eCharge"
        self.eCharge_branch = the_tree.GetBranch("eCharge")
        #if not self.eCharge_branch and "eCharge" not in self.complained:
        if not self.eCharge_branch and "eCharge":
            warnings.warn( "ETauTree: Expected branch eCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eCharge")
        else:
            self.eCharge_branch.SetAddress(<void*>&self.eCharge_value)

        #print "making eChargeIdLoose"
        self.eChargeIdLoose_branch = the_tree.GetBranch("eChargeIdLoose")
        #if not self.eChargeIdLoose_branch and "eChargeIdLoose" not in self.complained:
        if not self.eChargeIdLoose_branch and "eChargeIdLoose":
            warnings.warn( "ETauTree: Expected branch eChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdLoose")
        else:
            self.eChargeIdLoose_branch.SetAddress(<void*>&self.eChargeIdLoose_value)

        #print "making eChargeIdMed"
        self.eChargeIdMed_branch = the_tree.GetBranch("eChargeIdMed")
        #if not self.eChargeIdMed_branch and "eChargeIdMed" not in self.complained:
        if not self.eChargeIdMed_branch and "eChargeIdMed":
            warnings.warn( "ETauTree: Expected branch eChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdMed")
        else:
            self.eChargeIdMed_branch.SetAddress(<void*>&self.eChargeIdMed_value)

        #print "making eChargeIdTight"
        self.eChargeIdTight_branch = the_tree.GetBranch("eChargeIdTight")
        #if not self.eChargeIdTight_branch and "eChargeIdTight" not in self.complained:
        if not self.eChargeIdTight_branch and "eChargeIdTight":
            warnings.warn( "ETauTree: Expected branch eChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eChargeIdTight")
        else:
            self.eChargeIdTight_branch.SetAddress(<void*>&self.eChargeIdTight_value)

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

        #print "making eE1x5"
        self.eE1x5_branch = the_tree.GetBranch("eE1x5")
        #if not self.eE1x5_branch and "eE1x5" not in self.complained:
        if not self.eE1x5_branch and "eE1x5":
            warnings.warn( "ETauTree: Expected branch eE1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE1x5")
        else:
            self.eE1x5_branch.SetAddress(<void*>&self.eE1x5_value)

        #print "making eE2x5Max"
        self.eE2x5Max_branch = the_tree.GetBranch("eE2x5Max")
        #if not self.eE2x5Max_branch and "eE2x5Max" not in self.complained:
        if not self.eE2x5Max_branch and "eE2x5Max":
            warnings.warn( "ETauTree: Expected branch eE2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE2x5Max")
        else:
            self.eE2x5Max_branch.SetAddress(<void*>&self.eE2x5Max_value)

        #print "making eE5x5"
        self.eE5x5_branch = the_tree.GetBranch("eE5x5")
        #if not self.eE5x5_branch and "eE5x5" not in self.complained:
        if not self.eE5x5_branch and "eE5x5":
            warnings.warn( "ETauTree: Expected branch eE5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eE5x5")
        else:
            self.eE5x5_branch.SetAddress(<void*>&self.eE5x5_value)

        #print "making eEcalIsoDR03"
        self.eEcalIsoDR03_branch = the_tree.GetBranch("eEcalIsoDR03")
        #if not self.eEcalIsoDR03_branch and "eEcalIsoDR03" not in self.complained:
        if not self.eEcalIsoDR03_branch and "eEcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eEcalIsoDR03")
        else:
            self.eEcalIsoDR03_branch.SetAddress(<void*>&self.eEcalIsoDR03_value)

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

        #print "making eHadronicDepth1OverEm"
        self.eHadronicDepth1OverEm_branch = the_tree.GetBranch("eHadronicDepth1OverEm")
        #if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm" not in self.complained:
        if not self.eHadronicDepth1OverEm_branch and "eHadronicDepth1OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth1OverEm")
        else:
            self.eHadronicDepth1OverEm_branch.SetAddress(<void*>&self.eHadronicDepth1OverEm_value)

        #print "making eHadronicDepth2OverEm"
        self.eHadronicDepth2OverEm_branch = the_tree.GetBranch("eHadronicDepth2OverEm")
        #if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm" not in self.complained:
        if not self.eHadronicDepth2OverEm_branch and "eHadronicDepth2OverEm":
            warnings.warn( "ETauTree: Expected branch eHadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicDepth2OverEm")
        else:
            self.eHadronicDepth2OverEm_branch.SetAddress(<void*>&self.eHadronicDepth2OverEm_value)

        #print "making eHadronicOverEM"
        self.eHadronicOverEM_branch = the_tree.GetBranch("eHadronicOverEM")
        #if not self.eHadronicOverEM_branch and "eHadronicOverEM" not in self.complained:
        if not self.eHadronicOverEM_branch and "eHadronicOverEM":
            warnings.warn( "ETauTree: Expected branch eHadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHadronicOverEM")
        else:
            self.eHadronicOverEM_branch.SetAddress(<void*>&self.eHadronicOverEM_value)

        #print "making eHcalIsoDR03"
        self.eHcalIsoDR03_branch = the_tree.GetBranch("eHcalIsoDR03")
        #if not self.eHcalIsoDR03_branch and "eHcalIsoDR03" not in self.complained:
        if not self.eHcalIsoDR03_branch and "eHcalIsoDR03":
            warnings.warn( "ETauTree: Expected branch eHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eHcalIsoDR03")
        else:
            self.eHcalIsoDR03_branch.SetAddress(<void*>&self.eHcalIsoDR03_value)

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

        #print "making eLowestMll"
        self.eLowestMll_branch = the_tree.GetBranch("eLowestMll")
        #if not self.eLowestMll_branch and "eLowestMll" not in self.complained:
        if not self.eLowestMll_branch and "eLowestMll":
            warnings.warn( "ETauTree: Expected branch eLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eLowestMll")
        else:
            self.eLowestMll_branch.SetAddress(<void*>&self.eLowestMll_value)

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

        #print "making eMVAIsoWPHZZ"
        self.eMVAIsoWPHZZ_branch = the_tree.GetBranch("eMVAIsoWPHZZ")
        #if not self.eMVAIsoWPHZZ_branch and "eMVAIsoWPHZZ" not in self.complained:
        if not self.eMVAIsoWPHZZ_branch and "eMVAIsoWPHZZ":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWPHZZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWPHZZ")
        else:
            self.eMVAIsoWPHZZ_branch.SetAddress(<void*>&self.eMVAIsoWPHZZ_value)

        #print "making eMVAIsoWPLoose"
        self.eMVAIsoWPLoose_branch = the_tree.GetBranch("eMVAIsoWPLoose")
        #if not self.eMVAIsoWPLoose_branch and "eMVAIsoWPLoose" not in self.complained:
        if not self.eMVAIsoWPLoose_branch and "eMVAIsoWPLoose":
            warnings.warn( "ETauTree: Expected branch eMVAIsoWPLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVAIsoWPLoose")
        else:
            self.eMVAIsoWPLoose_branch.SetAddress(<void*>&self.eMVAIsoWPLoose_value)

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

        #print "making eMVANoisoWPLoose"
        self.eMVANoisoWPLoose_branch = the_tree.GetBranch("eMVANoisoWPLoose")
        #if not self.eMVANoisoWPLoose_branch and "eMVANoisoWPLoose" not in self.complained:
        if not self.eMVANoisoWPLoose_branch and "eMVANoisoWPLoose":
            warnings.warn( "ETauTree: Expected branch eMVANoisoWPLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMVANoisoWPLoose")
        else:
            self.eMVANoisoWPLoose_branch.SetAddress(<void*>&self.eMVANoisoWPLoose_value)

        #print "making eMass"
        self.eMass_branch = the_tree.GetBranch("eMass")
        #if not self.eMass_branch and "eMass" not in self.complained:
        if not self.eMass_branch and "eMass":
            warnings.warn( "ETauTree: Expected branch eMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMass")
        else:
            self.eMass_branch.SetAddress(<void*>&self.eMass_value)

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

        #print "making eMissingHits"
        self.eMissingHits_branch = the_tree.GetBranch("eMissingHits")
        #if not self.eMissingHits_branch and "eMissingHits" not in self.complained:
        if not self.eMissingHits_branch and "eMissingHits":
            warnings.warn( "ETauTree: Expected branch eMissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eMissingHits")
        else:
            self.eMissingHits_branch.SetAddress(<void*>&self.eMissingHits_value)

        #print "making eNearMuonVeto"
        self.eNearMuonVeto_branch = the_tree.GetBranch("eNearMuonVeto")
        #if not self.eNearMuonVeto_branch and "eNearMuonVeto" not in self.complained:
        if not self.eNearMuonVeto_branch and "eNearMuonVeto":
            warnings.warn( "ETauTree: Expected branch eNearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearMuonVeto")
        else:
            self.eNearMuonVeto_branch.SetAddress(<void*>&self.eNearMuonVeto_value)

        #print "making eNearestMuonDR"
        self.eNearestMuonDR_branch = the_tree.GetBranch("eNearestMuonDR")
        #if not self.eNearestMuonDR_branch and "eNearestMuonDR" not in self.complained:
        if not self.eNearestMuonDR_branch and "eNearestMuonDR":
            warnings.warn( "ETauTree: Expected branch eNearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestMuonDR")
        else:
            self.eNearestMuonDR_branch.SetAddress(<void*>&self.eNearestMuonDR_value)

        #print "making eNearestZMass"
        self.eNearestZMass_branch = the_tree.GetBranch("eNearestZMass")
        #if not self.eNearestZMass_branch and "eNearestZMass" not in self.complained:
        if not self.eNearestZMass_branch and "eNearestZMass":
            warnings.warn( "ETauTree: Expected branch eNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eNearestZMass")
        else:
            self.eNearestZMass_branch.SetAddress(<void*>&self.eNearestZMass_value)

        #print "making ePFChargedIso"
        self.ePFChargedIso_branch = the_tree.GetBranch("ePFChargedIso")
        #if not self.ePFChargedIso_branch and "ePFChargedIso" not in self.complained:
        if not self.ePFChargedIso_branch and "ePFChargedIso":
            warnings.warn( "ETauTree: Expected branch ePFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFChargedIso")
        else:
            self.ePFChargedIso_branch.SetAddress(<void*>&self.ePFChargedIso_value)

        #print "making ePFNeutralIso"
        self.ePFNeutralIso_branch = the_tree.GetBranch("ePFNeutralIso")
        #if not self.ePFNeutralIso_branch and "ePFNeutralIso" not in self.complained:
        if not self.ePFNeutralIso_branch and "ePFNeutralIso":
            warnings.warn( "ETauTree: Expected branch ePFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFNeutralIso")
        else:
            self.ePFNeutralIso_branch.SetAddress(<void*>&self.ePFNeutralIso_value)

        #print "making ePFPUChargedIso"
        self.ePFPUChargedIso_branch = the_tree.GetBranch("ePFPUChargedIso")
        #if not self.ePFPUChargedIso_branch and "ePFPUChargedIso" not in self.complained:
        if not self.ePFPUChargedIso_branch and "ePFPUChargedIso":
            warnings.warn( "ETauTree: Expected branch ePFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPUChargedIso")
        else:
            self.ePFPUChargedIso_branch.SetAddress(<void*>&self.ePFPUChargedIso_value)

        #print "making ePFPhotonIso"
        self.ePFPhotonIso_branch = the_tree.GetBranch("ePFPhotonIso")
        #if not self.ePFPhotonIso_branch and "ePFPhotonIso" not in self.complained:
        if not self.ePFPhotonIso_branch and "ePFPhotonIso":
            warnings.warn( "ETauTree: Expected branch ePFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("ePFPhotonIso")
        else:
            self.ePFPhotonIso_branch.SetAddress(<void*>&self.ePFPhotonIso_value)

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

        #print "making eRelIso"
        self.eRelIso_branch = the_tree.GetBranch("eRelIso")
        #if not self.eRelIso_branch and "eRelIso" not in self.complained:
        if not self.eRelIso_branch and "eRelIso":
            warnings.warn( "ETauTree: Expected branch eRelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelIso")
        else:
            self.eRelIso_branch.SetAddress(<void*>&self.eRelIso_value)

        #print "making eRelPFIsoDB"
        self.eRelPFIsoDB_branch = the_tree.GetBranch("eRelPFIsoDB")
        #if not self.eRelPFIsoDB_branch and "eRelPFIsoDB" not in self.complained:
        if not self.eRelPFIsoDB_branch and "eRelPFIsoDB":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoDB")
        else:
            self.eRelPFIsoDB_branch.SetAddress(<void*>&self.eRelPFIsoDB_value)

        #print "making eRelPFIsoRho"
        self.eRelPFIsoRho_branch = the_tree.GetBranch("eRelPFIsoRho")
        #if not self.eRelPFIsoRho_branch and "eRelPFIsoRho" not in self.complained:
        if not self.eRelPFIsoRho_branch and "eRelPFIsoRho":
            warnings.warn( "ETauTree: Expected branch eRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRelPFIsoRho")
        else:
            self.eRelPFIsoRho_branch.SetAddress(<void*>&self.eRelPFIsoRho_value)

        #print "making eRho"
        self.eRho_branch = the_tree.GetBranch("eRho")
        #if not self.eRho_branch and "eRho" not in self.complained:
        if not self.eRho_branch and "eRho":
            warnings.warn( "ETauTree: Expected branch eRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eRho")
        else:
            self.eRho_branch.SetAddress(<void*>&self.eRho_value)

        #print "making eSCEnergy"
        self.eSCEnergy_branch = the_tree.GetBranch("eSCEnergy")
        #if not self.eSCEnergy_branch and "eSCEnergy" not in self.complained:
        if not self.eSCEnergy_branch and "eSCEnergy":
            warnings.warn( "ETauTree: Expected branch eSCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEnergy")
        else:
            self.eSCEnergy_branch.SetAddress(<void*>&self.eSCEnergy_value)

        #print "making eSCEta"
        self.eSCEta_branch = the_tree.GetBranch("eSCEta")
        #if not self.eSCEta_branch and "eSCEta" not in self.complained:
        if not self.eSCEta_branch and "eSCEta":
            warnings.warn( "ETauTree: Expected branch eSCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEta")
        else:
            self.eSCEta_branch.SetAddress(<void*>&self.eSCEta_value)

        #print "making eSCEtaWidth"
        self.eSCEtaWidth_branch = the_tree.GetBranch("eSCEtaWidth")
        #if not self.eSCEtaWidth_branch and "eSCEtaWidth" not in self.complained:
        if not self.eSCEtaWidth_branch and "eSCEtaWidth":
            warnings.warn( "ETauTree: Expected branch eSCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCEtaWidth")
        else:
            self.eSCEtaWidth_branch.SetAddress(<void*>&self.eSCEtaWidth_value)

        #print "making eSCPhi"
        self.eSCPhi_branch = the_tree.GetBranch("eSCPhi")
        #if not self.eSCPhi_branch and "eSCPhi" not in self.complained:
        if not self.eSCPhi_branch and "eSCPhi":
            warnings.warn( "ETauTree: Expected branch eSCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhi")
        else:
            self.eSCPhi_branch.SetAddress(<void*>&self.eSCPhi_value)

        #print "making eSCPhiWidth"
        self.eSCPhiWidth_branch = the_tree.GetBranch("eSCPhiWidth")
        #if not self.eSCPhiWidth_branch and "eSCPhiWidth" not in self.complained:
        if not self.eSCPhiWidth_branch and "eSCPhiWidth":
            warnings.warn( "ETauTree: Expected branch eSCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPhiWidth")
        else:
            self.eSCPhiWidth_branch.SetAddress(<void*>&self.eSCPhiWidth_value)

        #print "making eSCPreshowerEnergy"
        self.eSCPreshowerEnergy_branch = the_tree.GetBranch("eSCPreshowerEnergy")
        #if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy" not in self.complained:
        if not self.eSCPreshowerEnergy_branch and "eSCPreshowerEnergy":
            warnings.warn( "ETauTree: Expected branch eSCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCPreshowerEnergy")
        else:
            self.eSCPreshowerEnergy_branch.SetAddress(<void*>&self.eSCPreshowerEnergy_value)

        #print "making eSCRawEnergy"
        self.eSCRawEnergy_branch = the_tree.GetBranch("eSCRawEnergy")
        #if not self.eSCRawEnergy_branch and "eSCRawEnergy" not in self.complained:
        if not self.eSCRawEnergy_branch and "eSCRawEnergy":
            warnings.warn( "ETauTree: Expected branch eSCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSCRawEnergy")
        else:
            self.eSCRawEnergy_branch.SetAddress(<void*>&self.eSCRawEnergy_value)

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

        #print "making eSigmaIEtaIEta"
        self.eSigmaIEtaIEta_branch = the_tree.GetBranch("eSigmaIEtaIEta")
        #if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta" not in self.complained:
        if not self.eSigmaIEtaIEta_branch and "eSigmaIEtaIEta":
            warnings.warn( "ETauTree: Expected branch eSigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eSigmaIEtaIEta")
        else:
            self.eSigmaIEtaIEta_branch.SetAddress(<void*>&self.eSigmaIEtaIEta_value)

        #print "making eTrkIsoDR03"
        self.eTrkIsoDR03_branch = the_tree.GetBranch("eTrkIsoDR03")
        #if not self.eTrkIsoDR03_branch and "eTrkIsoDR03" not in self.complained:
        if not self.eTrkIsoDR03_branch and "eTrkIsoDR03":
            warnings.warn( "ETauTree: Expected branch eTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eTrkIsoDR03")
        else:
            self.eTrkIsoDR03_branch.SetAddress(<void*>&self.eTrkIsoDR03_value)

        #print "making eVZ"
        self.eVZ_branch = the_tree.GetBranch("eVZ")
        #if not self.eVZ_branch and "eVZ" not in self.complained:
        if not self.eVZ_branch and "eVZ":
            warnings.warn( "ETauTree: Expected branch eVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVZ")
        else:
            self.eVZ_branch.SetAddress(<void*>&self.eVZ_value)

        #print "making eVetoHZZPt5"
        self.eVetoHZZPt5_branch = the_tree.GetBranch("eVetoHZZPt5")
        #if not self.eVetoHZZPt5_branch and "eVetoHZZPt5" not in self.complained:
        if not self.eVetoHZZPt5_branch and "eVetoHZZPt5":
            warnings.warn( "ETauTree: Expected branch eVetoHZZPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoHZZPt5")
        else:
            self.eVetoHZZPt5_branch.SetAddress(<void*>&self.eVetoHZZPt5_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "ETauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "ETauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making eZTTGenDR"
        self.eZTTGenDR_branch = the_tree.GetBranch("eZTTGenDR")
        #if not self.eZTTGenDR_branch and "eZTTGenDR" not in self.complained:
        if not self.eZTTGenDR_branch and "eZTTGenDR":
            warnings.warn( "ETauTree: Expected branch eZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenDR")
        else:
            self.eZTTGenDR_branch.SetAddress(<void*>&self.eZTTGenDR_value)

        #print "making eZTTGenEta"
        self.eZTTGenEta_branch = the_tree.GetBranch("eZTTGenEta")
        #if not self.eZTTGenEta_branch and "eZTTGenEta" not in self.complained:
        if not self.eZTTGenEta_branch and "eZTTGenEta":
            warnings.warn( "ETauTree: Expected branch eZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenEta")
        else:
            self.eZTTGenEta_branch.SetAddress(<void*>&self.eZTTGenEta_value)

        #print "making eZTTGenMatching"
        self.eZTTGenMatching_branch = the_tree.GetBranch("eZTTGenMatching")
        #if not self.eZTTGenMatching_branch and "eZTTGenMatching" not in self.complained:
        if not self.eZTTGenMatching_branch and "eZTTGenMatching":
            warnings.warn( "ETauTree: Expected branch eZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenMatching")
        else:
            self.eZTTGenMatching_branch.SetAddress(<void*>&self.eZTTGenMatching_value)

        #print "making eZTTGenPhi"
        self.eZTTGenPhi_branch = the_tree.GetBranch("eZTTGenPhi")
        #if not self.eZTTGenPhi_branch and "eZTTGenPhi" not in self.complained:
        if not self.eZTTGenPhi_branch and "eZTTGenPhi":
            warnings.warn( "ETauTree: Expected branch eZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenPhi")
        else:
            self.eZTTGenPhi_branch.SetAddress(<void*>&self.eZTTGenPhi_value)

        #print "making eZTTGenPt"
        self.eZTTGenPt_branch = the_tree.GetBranch("eZTTGenPt")
        #if not self.eZTTGenPt_branch and "eZTTGenPt" not in self.complained:
        if not self.eZTTGenPt_branch and "eZTTGenPt":
            warnings.warn( "ETauTree: Expected branch eZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eZTTGenPt")
        else:
            self.eZTTGenPt_branch.SetAddress(<void*>&self.eZTTGenPt_value)

        #print "making e_t_DR"
        self.e_t_DR_branch = the_tree.GetBranch("e_t_DR")
        #if not self.e_t_DR_branch and "e_t_DR" not in self.complained:
        if not self.e_t_DR_branch and "e_t_DR":
            warnings.warn( "ETauTree: Expected branch e_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_DR")
        else:
            self.e_t_DR_branch.SetAddress(<void*>&self.e_t_DR_value)

        #print "making e_t_Mass"
        self.e_t_Mass_branch = the_tree.GetBranch("e_t_Mass")
        #if not self.e_t_Mass_branch and "e_t_Mass" not in self.complained:
        if not self.e_t_Mass_branch and "e_t_Mass":
            warnings.warn( "ETauTree: Expected branch e_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_t_Mass")
        else:
            self.e_t_Mass_branch.SetAddress(<void*>&self.e_t_Mass_value)

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

        #print "making edeltaEtaSuperClusterTrackAtVtx"
        self.edeltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaEtaSuperClusterTrackAtVtx")
        #if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaEtaSuperClusterTrackAtVtx_branch and "edeltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaEtaSuperClusterTrackAtVtx")
        else:
            self.edeltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaEtaSuperClusterTrackAtVtx_value)

        #print "making edeltaPhiSuperClusterTrackAtVtx"
        self.edeltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("edeltaPhiSuperClusterTrackAtVtx")
        #if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.edeltaPhiSuperClusterTrackAtVtx_branch and "edeltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "ETauTree: Expected branch edeltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("edeltaPhiSuperClusterTrackAtVtx")
        else:
            self.edeltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.edeltaPhiSuperClusterTrackAtVtx_value)

        #print "making eeSuperClusterOverP"
        self.eeSuperClusterOverP_branch = the_tree.GetBranch("eeSuperClusterOverP")
        #if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP" not in self.complained:
        if not self.eeSuperClusterOverP_branch and "eeSuperClusterOverP":
            warnings.warn( "ETauTree: Expected branch eeSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eeSuperClusterOverP")
        else:
            self.eeSuperClusterOverP_branch.SetAddress(<void*>&self.eeSuperClusterOverP_value)

        #print "making eecalEnergy"
        self.eecalEnergy_branch = the_tree.GetBranch("eecalEnergy")
        #if not self.eecalEnergy_branch and "eecalEnergy" not in self.complained:
        if not self.eecalEnergy_branch and "eecalEnergy":
            warnings.warn( "ETauTree: Expected branch eecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eecalEnergy")
        else:
            self.eecalEnergy_branch.SetAddress(<void*>&self.eecalEnergy_value)

        #print "making efBrem"
        self.efBrem_branch = the_tree.GetBranch("efBrem")
        #if not self.efBrem_branch and "efBrem" not in self.complained:
        if not self.efBrem_branch and "efBrem":
            warnings.warn( "ETauTree: Expected branch efBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("efBrem")
        else:
            self.efBrem_branch.SetAddress(<void*>&self.efBrem_value)

        #print "making etrackMomentumAtVtxP"
        self.etrackMomentumAtVtxP_branch = the_tree.GetBranch("etrackMomentumAtVtxP")
        #if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP" not in self.complained:
        if not self.etrackMomentumAtVtxP_branch and "etrackMomentumAtVtxP":
            warnings.warn( "ETauTree: Expected branch etrackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("etrackMomentumAtVtxP")
        else:
            self.etrackMomentumAtVtxP_branch.SetAddress(<void*>&self.etrackMomentumAtVtxP_value)

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

        #print "making j1ptWoNoisyJets_JetEta0to3Down"
        self.j1ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Down")
        #if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Up"
        self.j1ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Up")
        #if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Down"
        self.j1ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Down")
        #if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Up"
        self.j1ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Up")
        #if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Down"
        self.j1ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Down")
        #if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Up"
        self.j1ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Up")
        #if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch j1ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Up_value)

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

        #print "making j2ptWoNoisyJets_JetEta0to3Down"
        self.j2ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Down")
        #if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Up"
        self.j2ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Up")
        #if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Down"
        self.j2ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Down")
        #if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Up"
        self.j2ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Up")
        #if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Down"
        self.j2ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Down")
        #if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Up"
        self.j2ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Up")
        #if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch j2ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Up_value)

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

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "ETauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

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

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "ETauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

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

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "ETauTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

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

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "ETauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

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

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "ETauTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

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

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "ETauTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

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

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "ETauTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

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

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "ETauTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

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

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "ETauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "ETauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

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

        #print "making jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteScaleDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteScaleDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteScaleDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteScaleUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteScaleUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteScaleUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteStatDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteStatDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteStatDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteStatUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteStatUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteStatUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_value)

        #print "making jetVeto30WoNoisyJets_JetClosureDown"
        self.jetVeto30WoNoisyJets_JetClosureDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetClosureDown")
        #if not self.jetVeto30WoNoisyJets_JetClosureDown_branch and "jetVeto30WoNoisyJets_JetClosureDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetClosureDown_branch and "jetVeto30WoNoisyJets_JetClosureDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetClosureDown")
        else:
            self.jetVeto30WoNoisyJets_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetClosureDown_value)

        #print "making jetVeto30WoNoisyJets_JetClosureUp"
        self.jetVeto30WoNoisyJets_JetClosureUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetClosureUp")
        #if not self.jetVeto30WoNoisyJets_JetClosureUp_branch and "jetVeto30WoNoisyJets_JetClosureUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetClosureUp_branch and "jetVeto30WoNoisyJets_JetClosureUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetClosureUp")
        else:
            self.jetVeto30WoNoisyJets_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetClosureUp_value)

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

        #print "making jetVeto30WoNoisyJets_JetEta0to3Down"
        self.jetVeto30WoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Up"
        self.jetVeto30WoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Down"
        self.jetVeto30WoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Up"
        self.jetVeto30WoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Down"
        self.jetVeto30WoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Up"
        self.jetVeto30WoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Up_value)

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

        #print "making jetVeto30WoNoisyJets_JetFragmentationDown"
        self.jetVeto30WoNoisyJets_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFragmentationDown")
        #if not self.jetVeto30WoNoisyJets_JetFragmentationDown_branch and "jetVeto30WoNoisyJets_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFragmentationDown_branch and "jetVeto30WoNoisyJets_JetFragmentationDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFragmentationDown")
        else:
            self.jetVeto30WoNoisyJets_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFragmentationDown_value)

        #print "making jetVeto30WoNoisyJets_JetFragmentationUp"
        self.jetVeto30WoNoisyJets_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFragmentationUp")
        #if not self.jetVeto30WoNoisyJets_JetFragmentationUp_branch and "jetVeto30WoNoisyJets_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFragmentationUp_branch and "jetVeto30WoNoisyJets_JetFragmentationUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFragmentationUp")
        else:
            self.jetVeto30WoNoisyJets_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFragmentationUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpDataMCDown"
        self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpDataMCDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpDataMCDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpDataMCUp"
        self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpDataMCUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpDataMCUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtBBDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtBBDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtBBDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtBBUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtBBUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtBBUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC1Down"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC1Down")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC1Up"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC1Up")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC2Down"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC2Up"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtHFDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtHFDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtHFUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtHFUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtRefDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtRefDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtRefDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtRefUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtRefUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtRefUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalDown"
        self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch and "jetVeto30WoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch and "jetVeto30WoNoisyJets_JetRelativeBalDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalUp"
        self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch and "jetVeto30WoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch and "jetVeto30WoNoisyJets_JetRelativeBalUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeFSRDown"
        self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeFSRDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeFSRDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeFSRDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeFSRDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeFSRUp"
        self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeFSRUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeFSRUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeFSRUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeFSRUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC1Down"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC1Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC1Up"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC1Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC2Down"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC2Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC2Up"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC2Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJERHFDown"
        self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJERHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJERHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJERHFUp"
        self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJERHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJERHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtBBDown"
        self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtBBDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch and "jetVeto30WoNoisyJets_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch and "jetVeto30WoNoisyJets_JetRelativePtBBDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtBBDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtBBDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtBBUp"
        self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtBBUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch and "jetVeto30WoNoisyJets_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch and "jetVeto30WoNoisyJets_JetRelativePtBBUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtBBUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtBBUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC1Down"
        self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC1Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC1Up"
        self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC1Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC2Down"
        self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Down":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC2Up"
        self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Up":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtHFDown"
        self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch and "jetVeto30WoNoisyJets_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch and "jetVeto30WoNoisyJets_JetRelativePtHFDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtHFUp"
        self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch and "jetVeto30WoNoisyJets_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch and "jetVeto30WoNoisyJets_JetRelativePtHFUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtHFUp_value)

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

        #print "making jetVeto30WoNoisyJets_JetRelativeStatECDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatECDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatECDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatECDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatECDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatECUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatECUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatECUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatECUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatECUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatFSRDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatFSRDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatFSRDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatFSRUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatFSRUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatFSRUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatHFDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatHFUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionECALDown"
        self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionECALDown")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionECALDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionECALDown")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionECALDown_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionECALUp"
        self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionECALUp")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionECALUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionECALUp")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionECALUp_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionHCALDown"
        self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionHCALDown")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionHCALDown")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionHCALUp"
        self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionHCALUp")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionHCALUp")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_value)

        #print "making jetVeto30WoNoisyJets_JetTimePtEtaDown"
        self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTimePtEtaDown")
        #if not self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch and "jetVeto30WoNoisyJets_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch and "jetVeto30WoNoisyJets_JetTimePtEtaDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTimePtEtaDown")
        else:
            self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTimePtEtaDown_value)

        #print "making jetVeto30WoNoisyJets_JetTimePtEtaUp"
        self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTimePtEtaUp")
        #if not self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch and "jetVeto30WoNoisyJets_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch and "jetVeto30WoNoisyJets_JetTimePtEtaUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30WoNoisyJets_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTimePtEtaUp")
        else:
            self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTimePtEtaUp_value)

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

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "ETauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "ETauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "ETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "ETauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "ETauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "ETauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "ETauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "ETauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

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

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "ETauTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "ETauTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

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

        #print "making muVeto5"
        self.muVeto5_branch = the_tree.GetBranch("muVeto5")
        #if not self.muVeto5_branch and "muVeto5" not in self.complained:
        if not self.muVeto5_branch and "muVeto5":
            warnings.warn( "ETauTree: Expected branch muVeto5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVeto5")
        else:
            self.muVeto5_branch.SetAddress(<void*>&self.muVeto5_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "ETauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "ETauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

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

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "ETauTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "ETauTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

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

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "ETauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "ETauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "ETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronLooseMVA62018"
        self.tAgainstElectronLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronLooseMVA62018")
        #if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA62018")
        else:
            self.tAgainstElectronLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA62018_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6Raw2018"
        self.tAgainstElectronMVA6Raw2018_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw2018")
        #if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018" not in self.complained:
        if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6Raw2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw2018")
        else:
            self.tAgainstElectronMVA6Raw2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw2018_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMVA6category2018"
        self.tAgainstElectronMVA6category2018_branch = the_tree.GetBranch("tAgainstElectronMVA6category2018")
        #if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018" not in self.complained:
        if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMVA6category2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category2018")
        else:
            self.tAgainstElectronMVA6category2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category2018_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronMediumMVA62018"
        self.tAgainstElectronMediumMVA62018_branch = the_tree.GetBranch("tAgainstElectronMediumMVA62018")
        #if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018" not in self.complained:
        if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronMediumMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA62018")
        else:
            self.tAgainstElectronMediumMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA62018_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronTightMVA62018"
        self.tAgainstElectronTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronTightMVA62018")
        #if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018" not in self.complained:
        if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA62018")
        else:
            self.tAgainstElectronTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA62018_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVLooseMVA62018"
        self.tAgainstElectronVLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA62018")
        #if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA62018")
        else:
            self.tAgainstElectronVLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA62018_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstElectronVTightMVA62018"
        self.tAgainstElectronVTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronVTightMVA62018")
        #if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018" not in self.complained:
        if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018":
            warnings.warn( "ETauTree: Expected branch tAgainstElectronVTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA62018")
        else:
            self.tAgainstElectronVTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA62018_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "ETauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "ETauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "ETauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "ETauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "ETauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "ETauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "ETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "ETauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "ETauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

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

        #print "making tDeepTau2017v1VSeraw"
        self.tDeepTau2017v1VSeraw_branch = the_tree.GetBranch("tDeepTau2017v1VSeraw")
        #if not self.tDeepTau2017v1VSeraw_branch and "tDeepTau2017v1VSeraw" not in self.complained:
        if not self.tDeepTau2017v1VSeraw_branch and "tDeepTau2017v1VSeraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v1VSeraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSeraw")
        else:
            self.tDeepTau2017v1VSeraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSeraw_value)

        #print "making tDeepTau2017v1VSjetraw"
        self.tDeepTau2017v1VSjetraw_branch = the_tree.GetBranch("tDeepTau2017v1VSjetraw")
        #if not self.tDeepTau2017v1VSjetraw_branch and "tDeepTau2017v1VSjetraw" not in self.complained:
        if not self.tDeepTau2017v1VSjetraw_branch and "tDeepTau2017v1VSjetraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v1VSjetraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSjetraw")
        else:
            self.tDeepTau2017v1VSjetraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSjetraw_value)

        #print "making tDeepTau2017v1VSmuraw"
        self.tDeepTau2017v1VSmuraw_branch = the_tree.GetBranch("tDeepTau2017v1VSmuraw")
        #if not self.tDeepTau2017v1VSmuraw_branch and "tDeepTau2017v1VSmuraw" not in self.complained:
        if not self.tDeepTau2017v1VSmuraw_branch and "tDeepTau2017v1VSmuraw":
            warnings.warn( "ETauTree: Expected branch tDeepTau2017v1VSmuraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSmuraw")
        else:
            self.tDeepTau2017v1VSmuraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSmuraw_value)

        #print "making tDpfTau2016v0VSallraw"
        self.tDpfTau2016v0VSallraw_branch = the_tree.GetBranch("tDpfTau2016v0VSallraw")
        #if not self.tDpfTau2016v0VSallraw_branch and "tDpfTau2016v0VSallraw" not in self.complained:
        if not self.tDpfTau2016v0VSallraw_branch and "tDpfTau2016v0VSallraw":
            warnings.warn( "ETauTree: Expected branch tDpfTau2016v0VSallraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDpfTau2016v0VSallraw")
        else:
            self.tDpfTau2016v0VSallraw_branch.SetAddress(<void*>&self.tDpfTau2016v0VSallraw_value)

        #print "making tDpfTau2016v1VSallraw"
        self.tDpfTau2016v1VSallraw_branch = the_tree.GetBranch("tDpfTau2016v1VSallraw")
        #if not self.tDpfTau2016v1VSallraw_branch and "tDpfTau2016v1VSallraw" not in self.complained:
        if not self.tDpfTau2016v1VSallraw_branch and "tDpfTau2016v1VSallraw":
            warnings.warn( "ETauTree: Expected branch tDpfTau2016v1VSallraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDpfTau2016v1VSallraw")
        else:
            self.tDpfTau2016v1VSallraw_branch.SetAddress(<void*>&self.tDpfTau2016v1VSallraw_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "ETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "ETauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "ETauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

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

        #print "making tLooseDeepTau2017v1VSe"
        self.tLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSe")
        #if not self.tLooseDeepTau2017v1VSe_branch and "tLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tLooseDeepTau2017v1VSe_branch and "tLooseDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSe")
        else:
            self.tLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSe_value)

        #print "making tLooseDeepTau2017v1VSjet"
        self.tLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSjet")
        #if not self.tLooseDeepTau2017v1VSjet_branch and "tLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tLooseDeepTau2017v1VSjet_branch and "tLooseDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSjet")
        else:
            self.tLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSjet_value)

        #print "making tLooseDeepTau2017v1VSmu"
        self.tLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSmu")
        #if not self.tLooseDeepTau2017v1VSmu_branch and "tLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tLooseDeepTau2017v1VSmu_branch and "tLooseDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSmu")
        else:
            self.tLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSmu_value)

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

        #print "making tMatchesDoubleMediumCombinedIsoTau35Path"
        self.tMatchesDoubleMediumCombinedIsoTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumCombinedIsoTau35Path")
        #if not self.tMatchesDoubleMediumCombinedIsoTau35Path_branch and "tMatchesDoubleMediumCombinedIsoTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumCombinedIsoTau35Path_branch and "tMatchesDoubleMediumCombinedIsoTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumCombinedIsoTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumCombinedIsoTau35Path")
        else:
            self.tMatchesDoubleMediumCombinedIsoTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumCombinedIsoTau35Path_value)

        #print "making tMatchesDoubleMediumHPSTau35Filter"
        self.tMatchesDoubleMediumHPSTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau35Filter")
        #if not self.tMatchesDoubleMediumHPSTau35Filter_branch and "tMatchesDoubleMediumHPSTau35Filter" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau35Filter_branch and "tMatchesDoubleMediumHPSTau35Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumHPSTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau35Filter")
        else:
            self.tMatchesDoubleMediumHPSTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau35Filter_value)

        #print "making tMatchesDoubleMediumHPSTau35Path"
        self.tMatchesDoubleMediumHPSTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau35Path")
        #if not self.tMatchesDoubleMediumHPSTau35Path_branch and "tMatchesDoubleMediumHPSTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau35Path_branch and "tMatchesDoubleMediumHPSTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumHPSTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau35Path")
        else:
            self.tMatchesDoubleMediumHPSTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau35Path_value)

        #print "making tMatchesDoubleMediumHPSTau40Filter"
        self.tMatchesDoubleMediumHPSTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau40Filter")
        #if not self.tMatchesDoubleMediumHPSTau40Filter_branch and "tMatchesDoubleMediumHPSTau40Filter" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau40Filter_branch and "tMatchesDoubleMediumHPSTau40Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumHPSTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau40Filter")
        else:
            self.tMatchesDoubleMediumHPSTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau40Filter_value)

        #print "making tMatchesDoubleMediumHPSTau40Path"
        self.tMatchesDoubleMediumHPSTau40Path_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau40Path")
        #if not self.tMatchesDoubleMediumHPSTau40Path_branch and "tMatchesDoubleMediumHPSTau40Path" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau40Path_branch and "tMatchesDoubleMediumHPSTau40Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumHPSTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau40Path")
        else:
            self.tMatchesDoubleMediumHPSTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau40Path_value)

        #print "making tMatchesDoubleMediumIsoTau35Path"
        self.tMatchesDoubleMediumIsoTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumIsoTau35Path")
        #if not self.tMatchesDoubleMediumIsoTau35Path_branch and "tMatchesDoubleMediumIsoTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumIsoTau35Path_branch and "tMatchesDoubleMediumIsoTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumIsoTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumIsoTau35Path")
        else:
            self.tMatchesDoubleMediumIsoTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumIsoTau35Path_value)

        #print "making tMatchesDoubleMediumTau35Filter"
        self.tMatchesDoubleMediumTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Filter")
        #if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Filter")
        else:
            self.tMatchesDoubleMediumTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Filter_value)

        #print "making tMatchesDoubleMediumTau35Path"
        self.tMatchesDoubleMediumTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Path")
        #if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Path")
        else:
            self.tMatchesDoubleMediumTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Path_value)

        #print "making tMatchesDoubleMediumTau40Filter"
        self.tMatchesDoubleMediumTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Filter")
        #if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Filter")
        else:
            self.tMatchesDoubleMediumTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Filter_value)

        #print "making tMatchesDoubleMediumTau40Path"
        self.tMatchesDoubleMediumTau40Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Path")
        #if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleMediumTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Path")
        else:
            self.tMatchesDoubleMediumTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Path_value)

        #print "making tMatchesDoubleTightHPSTau35Filter"
        self.tMatchesDoubleTightHPSTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau35Filter")
        #if not self.tMatchesDoubleTightHPSTau35Filter_branch and "tMatchesDoubleTightHPSTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau35Filter_branch and "tMatchesDoubleTightHPSTau35Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightHPSTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau35Filter")
        else:
            self.tMatchesDoubleTightHPSTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau35Filter_value)

        #print "making tMatchesDoubleTightHPSTau35Path"
        self.tMatchesDoubleTightHPSTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau35Path")
        #if not self.tMatchesDoubleTightHPSTau35Path_branch and "tMatchesDoubleTightHPSTau35Path" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau35Path_branch and "tMatchesDoubleTightHPSTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightHPSTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau35Path")
        else:
            self.tMatchesDoubleTightHPSTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau35Path_value)

        #print "making tMatchesDoubleTightHPSTau40Filter"
        self.tMatchesDoubleTightHPSTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau40Filter")
        #if not self.tMatchesDoubleTightHPSTau40Filter_branch and "tMatchesDoubleTightHPSTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau40Filter_branch and "tMatchesDoubleTightHPSTau40Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightHPSTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau40Filter")
        else:
            self.tMatchesDoubleTightHPSTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau40Filter_value)

        #print "making tMatchesDoubleTightHPSTau40Path"
        self.tMatchesDoubleTightHPSTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau40Path")
        #if not self.tMatchesDoubleTightHPSTau40Path_branch and "tMatchesDoubleTightHPSTau40Path" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau40Path_branch and "tMatchesDoubleTightHPSTau40Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightHPSTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau40Path")
        else:
            self.tMatchesDoubleTightHPSTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau40Path_value)

        #print "making tMatchesDoubleTightTau35Filter"
        self.tMatchesDoubleTightTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Filter")
        #if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Filter")
        else:
            self.tMatchesDoubleTightTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Filter_value)

        #print "making tMatchesDoubleTightTau35Path"
        self.tMatchesDoubleTightTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Path")
        #if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path" not in self.complained:
        if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Path")
        else:
            self.tMatchesDoubleTightTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Path_value)

        #print "making tMatchesDoubleTightTau40Filter"
        self.tMatchesDoubleTightTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Filter")
        #if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Filter")
        else:
            self.tMatchesDoubleTightTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Filter_value)

        #print "making tMatchesDoubleTightTau40Path"
        self.tMatchesDoubleTightTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Path")
        #if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path" not in self.complained:
        if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path":
            warnings.warn( "ETauTree: Expected branch tMatchesDoubleTightTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Path")
        else:
            self.tMatchesDoubleTightTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Path_value)

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

        #print "making tMatchesIsoMu19Tau20Filter"
        self.tMatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Filter")
        #if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Filter")
        else:
            self.tMatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Filter_value)

        #print "making tMatchesIsoMu19Tau20Path"
        self.tMatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Path")
        #if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Path")
        else:
            self.tMatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Path_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Filter"
        self.tMatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Filter")
        #if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Path"
        self.tMatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Path")
        #if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Path")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Path_value)

        #print "making tMatchesIsoMu20HPSTau27Filter"
        self.tMatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Filter")
        #if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Filter")
        else:
            self.tMatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Filter_value)

        #print "making tMatchesIsoMu20HPSTau27Path"
        self.tMatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Path")
        #if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Path")
        else:
            self.tMatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Path_value)

        #print "making tMatchesIsoMu20Tau27Filter"
        self.tMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Filter")
        #if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Filter")
        else:
            self.tMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Filter_value)

        #print "making tMatchesIsoMu20Tau27Path"
        self.tMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Path")
        #if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path":
            warnings.warn( "ETauTree: Expected branch tMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Path")
        else:
            self.tMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Path_value)

        #print "making tMediumDeepTau2017v1VSe"
        self.tMediumDeepTau2017v1VSe_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSe")
        #if not self.tMediumDeepTau2017v1VSe_branch and "tMediumDeepTau2017v1VSe" not in self.complained:
        if not self.tMediumDeepTau2017v1VSe_branch and "tMediumDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSe")
        else:
            self.tMediumDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSe_value)

        #print "making tMediumDeepTau2017v1VSjet"
        self.tMediumDeepTau2017v1VSjet_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSjet")
        #if not self.tMediumDeepTau2017v1VSjet_branch and "tMediumDeepTau2017v1VSjet" not in self.complained:
        if not self.tMediumDeepTau2017v1VSjet_branch and "tMediumDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSjet")
        else:
            self.tMediumDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSjet_value)

        #print "making tMediumDeepTau2017v1VSmu"
        self.tMediumDeepTau2017v1VSmu_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSmu")
        #if not self.tMediumDeepTau2017v1VSmu_branch and "tMediumDeepTau2017v1VSmu" not in self.complained:
        if not self.tMediumDeepTau2017v1VSmu_branch and "tMediumDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tMediumDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSmu")
        else:
            self.tMediumDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSmu_value)

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

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "ETauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

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

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "ETauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "ETauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "ETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "ETauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRerunMVArun2v2DBoldDMwLTLoose"
        self.tRerunMVArun2v2DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTMedium"
        self.tRerunMVArun2v2DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v2DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v2DBoldDMwLTTight"
        self.tRerunMVArun2v2DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVTight"
        self.tRerunMVArun2v2DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVTight"
        self.tRerunMVArun2v2DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTraw"
        self.tRerunMVArun2v2DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTraw")
        #if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw":
            warnings.warn( "ETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v2DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTraw_value)

        #print "making tTightDeepTau2017v1VSe"
        self.tTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tTightDeepTau2017v1VSe")
        #if not self.tTightDeepTau2017v1VSe_branch and "tTightDeepTau2017v1VSe" not in self.complained:
        if not self.tTightDeepTau2017v1VSe_branch and "tTightDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSe")
        else:
            self.tTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSe_value)

        #print "making tTightDeepTau2017v1VSjet"
        self.tTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tTightDeepTau2017v1VSjet")
        #if not self.tTightDeepTau2017v1VSjet_branch and "tTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tTightDeepTau2017v1VSjet_branch and "tTightDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSjet")
        else:
            self.tTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSjet_value)

        #print "making tTightDeepTau2017v1VSmu"
        self.tTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tTightDeepTau2017v1VSmu")
        #if not self.tTightDeepTau2017v1VSmu_branch and "tTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tTightDeepTau2017v1VSmu_branch and "tTightDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSmu")
        else:
            self.tTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSmu_value)

        #print "making tTightDpfTau2016v0VSall"
        self.tTightDpfTau2016v0VSall_branch = the_tree.GetBranch("tTightDpfTau2016v0VSall")
        #if not self.tTightDpfTau2016v0VSall_branch and "tTightDpfTau2016v0VSall" not in self.complained:
        if not self.tTightDpfTau2016v0VSall_branch and "tTightDpfTau2016v0VSall":
            warnings.warn( "ETauTree: Expected branch tTightDpfTau2016v0VSall does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDpfTau2016v0VSall")
        else:
            self.tTightDpfTau2016v0VSall_branch.SetAddress(<void*>&self.tTightDpfTau2016v0VSall_value)

        #print "making tTightDpfTau2016v1VSall"
        self.tTightDpfTau2016v1VSall_branch = the_tree.GetBranch("tTightDpfTau2016v1VSall")
        #if not self.tTightDpfTau2016v1VSall_branch and "tTightDpfTau2016v1VSall" not in self.complained:
        if not self.tTightDpfTau2016v1VSall_branch and "tTightDpfTau2016v1VSall":
            warnings.warn( "ETauTree: Expected branch tTightDpfTau2016v1VSall does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDpfTau2016v1VSall")
        else:
            self.tTightDpfTau2016v1VSall_branch.SetAddress(<void*>&self.tTightDpfTau2016v1VSall_value)

        #print "making tVLooseDeepTau2017v1VSe"
        self.tVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSe")
        #if not self.tVLooseDeepTau2017v1VSe_branch and "tVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSe_branch and "tVLooseDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSe")
        else:
            self.tVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSe_value)

        #print "making tVLooseDeepTau2017v1VSjet"
        self.tVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSjet")
        #if not self.tVLooseDeepTau2017v1VSjet_branch and "tVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSjet_branch and "tVLooseDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSjet")
        else:
            self.tVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSjet_value)

        #print "making tVLooseDeepTau2017v1VSmu"
        self.tVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSmu")
        #if not self.tVLooseDeepTau2017v1VSmu_branch and "tVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSmu_branch and "tVLooseDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSmu")
        else:
            self.tVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSmu_value)

        #print "making tVTightDeepTau2017v1VSe"
        self.tVTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSe")
        #if not self.tVTightDeepTau2017v1VSe_branch and "tVTightDeepTau2017v1VSe" not in self.complained:
        if not self.tVTightDeepTau2017v1VSe_branch and "tVTightDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSe")
        else:
            self.tVTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSe_value)

        #print "making tVTightDeepTau2017v1VSjet"
        self.tVTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSjet")
        #if not self.tVTightDeepTau2017v1VSjet_branch and "tVTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tVTightDeepTau2017v1VSjet_branch and "tVTightDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSjet")
        else:
            self.tVTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSjet_value)

        #print "making tVTightDeepTau2017v1VSmu"
        self.tVTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSmu")
        #if not self.tVTightDeepTau2017v1VSmu_branch and "tVTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tVTightDeepTau2017v1VSmu_branch and "tVTightDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tVTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSmu")
        else:
            self.tVTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSmu_value)

        #print "making tVVLooseDeepTau2017v1VSe"
        self.tVVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSe")
        #if not self.tVVLooseDeepTau2017v1VSe_branch and "tVVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSe_branch and "tVVLooseDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tVVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSe")
        else:
            self.tVVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSe_value)

        #print "making tVVLooseDeepTau2017v1VSjet"
        self.tVVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSjet")
        #if not self.tVVLooseDeepTau2017v1VSjet_branch and "tVVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSjet_branch and "tVVLooseDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSjet")
        else:
            self.tVVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSjet_value)

        #print "making tVVLooseDeepTau2017v1VSmu"
        self.tVVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSmu")
        #if not self.tVVLooseDeepTau2017v1VSmu_branch and "tVVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSmu_branch and "tVVLooseDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tVVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSmu")
        else:
            self.tVVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSmu_value)

        #print "making tVVTightDeepTau2017v1VSe"
        self.tVVTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSe")
        #if not self.tVVTightDeepTau2017v1VSe_branch and "tVVTightDeepTau2017v1VSe" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSe_branch and "tVVTightDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSe")
        else:
            self.tVVTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSe_value)

        #print "making tVVTightDeepTau2017v1VSjet"
        self.tVVTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSjet")
        #if not self.tVVTightDeepTau2017v1VSjet_branch and "tVVTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSjet_branch and "tVVTightDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSjet")
        else:
            self.tVVTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSjet_value)

        #print "making tVVTightDeepTau2017v1VSmu"
        self.tVVTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSmu")
        #if not self.tVVTightDeepTau2017v1VSmu_branch and "tVVTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSmu_branch and "tVVTightDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tVVTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSmu")
        else:
            self.tVVTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSmu_value)

        #print "making tVVVLooseDeepTau2017v1VSe"
        self.tVVVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSe")
        #if not self.tVVVLooseDeepTau2017v1VSe_branch and "tVVVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSe_branch and "tVVVLooseDeepTau2017v1VSe":
            warnings.warn( "ETauTree: Expected branch tVVVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSe")
        else:
            self.tVVVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSe_value)

        #print "making tVVVLooseDeepTau2017v1VSjet"
        self.tVVVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSjet")
        #if not self.tVVVLooseDeepTau2017v1VSjet_branch and "tVVVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSjet_branch and "tVVVLooseDeepTau2017v1VSjet":
            warnings.warn( "ETauTree: Expected branch tVVVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSjet")
        else:
            self.tVVVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSjet_value)

        #print "making tVVVLooseDeepTau2017v1VSmu"
        self.tVVVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSmu")
        #if not self.tVVVLooseDeepTau2017v1VSmu_branch and "tVVVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSmu_branch and "tVVVLooseDeepTau2017v1VSmu":
            warnings.warn( "ETauTree: Expected branch tVVVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSmu")
        else:
            self.tVVVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSmu_value)

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

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "ETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

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

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "ETauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "ETauTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "ETauTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

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

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureDown"
        self.type1_pfMet_shiftedPhi_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureDown")
        #if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureUp"
        self.type1_pfMet_shiftedPhi_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureUp")
        #if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Down"
        self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Up"
        self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Down"
        self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Up"
        self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Down"
        self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Up"
        self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Up_value)

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

        #print "making type1_pfMet_shiftedPhi_JetFragmentationDown"
        self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationUp"
        self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value)

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

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPt_JetClosureDown"
        self.type1_pfMet_shiftedPt_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureDown")
        #if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPt_JetClosureUp"
        self.type1_pfMet_shiftedPt_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureUp")
        #if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetEta0to3Down"
        self.type1_pfMet_shiftedPt_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Up"
        self.type1_pfMet_shiftedPt_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Down"
        self.type1_pfMet_shiftedPt_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Up"
        self.type1_pfMet_shiftedPt_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Down"
        self.type1_pfMet_shiftedPt_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Up"
        self.type1_pfMet_shiftedPt_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Up_value)

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

        #print "making type1_pfMet_shiftedPt_JetFragmentationDown"
        self.type1_pfMet_shiftedPt_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationUp"
        self.type1_pfMet_shiftedPt_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value)

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

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp":
            warnings.warn( "ETauTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value)

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

        #print "making vbfMassWoNoisyJets_JetAbsoluteFlavMapDown"
        self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteFlavMapDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteFlavMapDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteFlavMapUp"
        self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteFlavMapUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteFlavMapUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown"
        self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp"
        self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteScaleDown"
        self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteScaleDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteScaleDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteScaleUp"
        self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteScaleUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteScaleUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteStatDown"
        self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteStatDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch and "vbfMassWoNoisyJets_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch and "vbfMassWoNoisyJets_JetAbsoluteStatDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteStatDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteStatDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteStatUp"
        self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteStatUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch and "vbfMassWoNoisyJets_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch and "vbfMassWoNoisyJets_JetAbsoluteStatUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteStatUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteStatUp_value)

        #print "making vbfMassWoNoisyJets_JetClosureDown"
        self.vbfMassWoNoisyJets_JetClosureDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetClosureDown")
        #if not self.vbfMassWoNoisyJets_JetClosureDown_branch and "vbfMassWoNoisyJets_JetClosureDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetClosureDown_branch and "vbfMassWoNoisyJets_JetClosureDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetClosureDown")
        else:
            self.vbfMassWoNoisyJets_JetClosureDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetClosureDown_value)

        #print "making vbfMassWoNoisyJets_JetClosureUp"
        self.vbfMassWoNoisyJets_JetClosureUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetClosureUp")
        #if not self.vbfMassWoNoisyJets_JetClosureUp_branch and "vbfMassWoNoisyJets_JetClosureUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetClosureUp_branch and "vbfMassWoNoisyJets_JetClosureUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetClosureUp")
        else:
            self.vbfMassWoNoisyJets_JetClosureUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetClosureUp_value)

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

        #print "making vbfMassWoNoisyJets_JetEta0to3Down"
        self.vbfMassWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Up"
        self.vbfMassWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Down"
        self.vbfMassWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Up"
        self.vbfMassWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Up_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Down"
        self.vbfMassWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Up"
        self.vbfMassWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Up_value)

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

        #print "making vbfMassWoNoisyJets_JetFragmentationDown"
        self.vbfMassWoNoisyJets_JetFragmentationDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFragmentationDown")
        #if not self.vbfMassWoNoisyJets_JetFragmentationDown_branch and "vbfMassWoNoisyJets_JetFragmentationDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFragmentationDown_branch and "vbfMassWoNoisyJets_JetFragmentationDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFragmentationDown")
        else:
            self.vbfMassWoNoisyJets_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFragmentationDown_value)

        #print "making vbfMassWoNoisyJets_JetFragmentationUp"
        self.vbfMassWoNoisyJets_JetFragmentationUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFragmentationUp")
        #if not self.vbfMassWoNoisyJets_JetFragmentationUp_branch and "vbfMassWoNoisyJets_JetFragmentationUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFragmentationUp_branch and "vbfMassWoNoisyJets_JetFragmentationUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFragmentationUp")
        else:
            self.vbfMassWoNoisyJets_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFragmentationUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpDataMCDown"
        self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpDataMCDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch and "vbfMassWoNoisyJets_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch and "vbfMassWoNoisyJets_JetPileUpDataMCDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpDataMCDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpDataMCDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpDataMCUp"
        self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpDataMCUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch and "vbfMassWoNoisyJets_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch and "vbfMassWoNoisyJets_JetPileUpDataMCUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpDataMCUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpDataMCUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtBBDown"
        self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtBBDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch and "vbfMassWoNoisyJets_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch and "vbfMassWoNoisyJets_JetPileUpPtBBDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtBBDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtBBDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtBBUp"
        self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtBBUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch and "vbfMassWoNoisyJets_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch and "vbfMassWoNoisyJets_JetPileUpPtBBUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtBBUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtBBUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC1Down"
        self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC1Down")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC1Down")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC1Up"
        self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC1Up")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC1Up")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC2Down"
        self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC2Down")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC2Up"
        self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC2Up")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtHFDown"
        self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtHFDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch and "vbfMassWoNoisyJets_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch and "vbfMassWoNoisyJets_JetPileUpPtHFDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtHFDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtHFDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtHFUp"
        self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtHFUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch and "vbfMassWoNoisyJets_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch and "vbfMassWoNoisyJets_JetPileUpPtHFUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtHFUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtHFUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtRefDown"
        self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtRefDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch and "vbfMassWoNoisyJets_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch and "vbfMassWoNoisyJets_JetPileUpPtRefDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtRefDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtRefDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtRefUp"
        self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtRefUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch and "vbfMassWoNoisyJets_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch and "vbfMassWoNoisyJets_JetPileUpPtRefUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtRefUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtRefUp_value)

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

        #print "making vbfMassWoNoisyJets_JetRelativeFSRDown"
        self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeFSRDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeFSRDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeFSRDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeFSRDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeFSRUp"
        self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeFSRUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeFSRUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeFSRUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeFSRUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC1Down"
        self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC1Down")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC1Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC1Up"
        self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC1Up")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC1Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC2Down"
        self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC2Down")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC2Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC2Up"
        self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC2Up")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC2Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJERHFDown"
        self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJERHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch and "vbfMassWoNoisyJets_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch and "vbfMassWoNoisyJets_JetRelativeJERHFDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJERHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJERHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJERHFUp"
        self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJERHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch and "vbfMassWoNoisyJets_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch and "vbfMassWoNoisyJets_JetRelativeJERHFUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJERHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJERHFUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtBBDown"
        self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtBBDown")
        #if not self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch and "vbfMassWoNoisyJets_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch and "vbfMassWoNoisyJets_JetRelativePtBBDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtBBDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtBBDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtBBUp"
        self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtBBUp")
        #if not self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch and "vbfMassWoNoisyJets_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch and "vbfMassWoNoisyJets_JetRelativePtBBUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtBBUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtBBUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC1Down"
        self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC1Down")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC1Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC1Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC1Up"
        self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC1Up")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC1Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC1Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC2Down"
        self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC2Down")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Down":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC2Up"
        self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC2Up")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Up":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtHFDown"
        self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch and "vbfMassWoNoisyJets_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch and "vbfMassWoNoisyJets_JetRelativePtHFDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtHFUp"
        self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch and "vbfMassWoNoisyJets_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch and "vbfMassWoNoisyJets_JetRelativePtHFUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtHFUp_value)

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

        #print "making vbfMassWoNoisyJets_JetRelativeStatECDown"
        self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatECDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch and "vbfMassWoNoisyJets_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch and "vbfMassWoNoisyJets_JetRelativeStatECDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatECDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatECDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatECUp"
        self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatECUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch and "vbfMassWoNoisyJets_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch and "vbfMassWoNoisyJets_JetRelativeStatECUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatECUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatECUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatFSRDown"
        self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatFSRDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatFSRDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatFSRUp"
        self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatFSRUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatFSRUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatHFDown"
        self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch and "vbfMassWoNoisyJets_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch and "vbfMassWoNoisyJets_JetRelativeStatHFDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatHFUp"
        self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch and "vbfMassWoNoisyJets_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch and "vbfMassWoNoisyJets_JetRelativeStatHFUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatHFUp_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionECALDown"
        self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionECALDown")
        #if not self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch and "vbfMassWoNoisyJets_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch and "vbfMassWoNoisyJets_JetSinglePionECALDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionECALDown")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionECALDown_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionECALUp"
        self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionECALUp")
        #if not self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch and "vbfMassWoNoisyJets_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch and "vbfMassWoNoisyJets_JetSinglePionECALUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionECALUp")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionECALUp_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionHCALDown"
        self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionHCALDown")
        #if not self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch and "vbfMassWoNoisyJets_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch and "vbfMassWoNoisyJets_JetSinglePionHCALDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionHCALDown")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionHCALDown_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionHCALUp"
        self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionHCALUp")
        #if not self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch and "vbfMassWoNoisyJets_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch and "vbfMassWoNoisyJets_JetSinglePionHCALUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionHCALUp")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionHCALUp_value)

        #print "making vbfMassWoNoisyJets_JetTimePtEtaDown"
        self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTimePtEtaDown")
        #if not self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch and "vbfMassWoNoisyJets_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch and "vbfMassWoNoisyJets_JetTimePtEtaDown":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTimePtEtaDown")
        else:
            self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTimePtEtaDown_value)

        #print "making vbfMassWoNoisyJets_JetTimePtEtaUp"
        self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTimePtEtaUp")
        #if not self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch and "vbfMassWoNoisyJets_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch and "vbfMassWoNoisyJets_JetTimePtEtaUp":
            warnings.warn( "ETauTree: Expected branch vbfMassWoNoisyJets_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTimePtEtaUp")
        else:
            self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTimePtEtaUp_value)

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

    property DoubleMediumHPSTau35Pass:
        def __get__(self):
            self.DoubleMediumHPSTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau35Pass_value

    property DoubleMediumHPSTau35TightIDPass:
        def __get__(self):
            self.DoubleMediumHPSTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau35TightIDPass_value

    property DoubleMediumHPSTau40Pass:
        def __get__(self):
            self.DoubleMediumHPSTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau40Pass_value

    property DoubleMediumHPSTau40TightIDPass:
        def __get__(self):
            self.DoubleMediumHPSTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumHPSTau40TightIDPass_value

    property DoubleMediumTau35Pass:
        def __get__(self):
            self.DoubleMediumTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35Pass_value

    property DoubleMediumTau35TightIDPass:
        def __get__(self):
            self.DoubleMediumTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35TightIDPass_value

    property DoubleMediumTau40Pass:
        def __get__(self):
            self.DoubleMediumTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40Pass_value

    property DoubleMediumTau40TightIDPass:
        def __get__(self):
            self.DoubleMediumTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40TightIDPass_value

    property DoubleTightHPSTau35Pass:
        def __get__(self):
            self.DoubleTightHPSTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau35Pass_value

    property DoubleTightHPSTau35TightIDPass:
        def __get__(self):
            self.DoubleTightHPSTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau35TightIDPass_value

    property DoubleTightHPSTau40Pass:
        def __get__(self):
            self.DoubleTightHPSTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau40Pass_value

    property DoubleTightHPSTau40TightIDPass:
        def __get__(self):
            self.DoubleTightHPSTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightHPSTau40TightIDPass_value

    property DoubleTightTau35Pass:
        def __get__(self):
            self.DoubleTightTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35Pass_value

    property DoubleTightTau35TightIDPass:
        def __get__(self):
            self.DoubleTightTau35TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35TightIDPass_value

    property DoubleTightTau40Pass:
        def __get__(self):
            self.DoubleTightTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40Pass_value

    property DoubleTightTau40TightIDPass:
        def __get__(self):
            self.DoubleTightTau40TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40TightIDPass_value

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

    property Ele38WPTightPass:
        def __get__(self):
            self.Ele38WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele38WPTightPass_value

    property Ele40WPTightPass:
        def __get__(self):
            self.Ele40WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele40WPTightPass_value

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

    property Flag_badMuons:
        def __get__(self):
            self.Flag_badMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_badMuons_value

    property Flag_duplicateMuons:
        def __get__(self):
            self.Flag_duplicateMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_duplicateMuons_value

    property Flag_ecalBadCalibFilter:
        def __get__(self):
            self.Flag_ecalBadCalibFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibFilter_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_globalSuperTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalSuperTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalSuperTightHalo2016Filter_value

    property Flag_globalTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalTightHalo2016Filter_value

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

    property Mu20LooseHPSTau27Pass:
        def __get__(self):
            self.Mu20LooseHPSTau27Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseHPSTau27Pass_value

    property Mu20LooseHPSTau27TightIDPass:
        def __get__(self):
            self.Mu20LooseHPSTau27TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseHPSTau27TightIDPass_value

    property Mu20LooseTau27Pass:
        def __get__(self):
            self.Mu20LooseTau27Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseTau27Pass_value

    property Mu20LooseTau27TightIDPass:
        def __get__(self):
            self.Mu20LooseTau27TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.Mu20LooseTau27TightIDPass_value

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

    property Rivet_VEta:
        def __get__(self):
            self.Rivet_VEta_branch.GetEntry(self.localentry, 0)
            return self.Rivet_VEta_value

    property Rivet_VPt:
        def __get__(self):
            self.Rivet_VPt_branch.GetEntry(self.localentry, 0)
            return self.Rivet_VPt_value

    property Rivet_errorCode:
        def __get__(self):
            self.Rivet_errorCode_branch.GetEntry(self.localentry, 0)
            return self.Rivet_errorCode_value

    property Rivet_higgsEta:
        def __get__(self):
            self.Rivet_higgsEta_branch.GetEntry(self.localentry, 0)
            return self.Rivet_higgsEta_value

    property Rivet_higgsPt:
        def __get__(self):
            self.Rivet_higgsPt_branch.GetEntry(self.localentry, 0)
            return self.Rivet_higgsPt_value

    property Rivet_nJets25:
        def __get__(self):
            self.Rivet_nJets25_branch.GetEntry(self.localentry, 0)
            return self.Rivet_nJets25_value

    property Rivet_nJets30:
        def __get__(self):
            self.Rivet_nJets30_branch.GetEntry(self.localentry, 0)
            return self.Rivet_nJets30_value

    property Rivet_p4decay_VEta:
        def __get__(self):
            self.Rivet_p4decay_VEta_branch.GetEntry(self.localentry, 0)
            return self.Rivet_p4decay_VEta_value

    property Rivet_p4decay_VPt:
        def __get__(self):
            self.Rivet_p4decay_VPt_branch.GetEntry(self.localentry, 0)
            return self.Rivet_p4decay_VPt_value

    property Rivet_prodMode:
        def __get__(self):
            self.Rivet_prodMode_branch.GetEntry(self.localentry, 0)
            return self.Rivet_prodMode_value

    property Rivet_stage0_cat:
        def __get__(self):
            self.Rivet_stage0_cat_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage0_cat_value

    property Rivet_stage1_cat_pTjet25GeV:
        def __get__(self):
            self.Rivet_stage1_cat_pTjet25GeV_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage1_cat_pTjet25GeV_value

    property Rivet_stage1_cat_pTjet30GeV:
        def __get__(self):
            self.Rivet_stage1_cat_pTjet30GeV_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage1_cat_pTjet30GeV_value

    property Rivet_stage1p1_cat:
        def __get__(self):
            self.Rivet_stage1p1_cat_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage1p1_cat_value

    property VBFDoubleLooseHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleLooseHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleLooseHPSTau20Pass_value

    property VBFDoubleLooseTau20Pass:
        def __get__(self):
            self.VBFDoubleLooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleLooseTau20Pass_value

    property VBFDoubleMediumHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleMediumHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleMediumHPSTau20Pass_value

    property VBFDoubleMediumTau20Pass:
        def __get__(self):
            self.VBFDoubleMediumTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleMediumTau20Pass_value

    property VBFDoubleTightHPSTau20Pass:
        def __get__(self):
            self.VBFDoubleTightHPSTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleTightHPSTau20Pass_value

    property VBFDoubleTightTau20Pass:
        def __get__(self):
            self.VBFDoubleTightTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.VBFDoubleTightTau20Pass_value

    property bjetDeepCSVVeto20Loose_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2016_DR0p5_value

    property bjetDeepCSVVeto20Loose_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2017_DR0p5_value

    property bjetDeepCSVVeto20Loose_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_2018_DR0p5_value

    property bjetDeepCSVVeto20Medium:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_value

    property bjetDeepCSVVeto20MediumWoNoisyJets:
        def __get__(self):
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20MediumWoNoisyJets_value

    property bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2016_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0_value

    property bjetDeepCSVVeto20Medium_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2016_DR0p5_value

    property bjetDeepCSVVeto20Medium_2017_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0_value

    property bjetDeepCSVVeto20Medium_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2017_DR0p5_value

    property bjetDeepCSVVeto20Medium_2018_DR0:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0_value

    property bjetDeepCSVVeto20Medium_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_2018_DR0p5_value

    property bjetDeepCSVVeto20Tight_2016_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2016_DR0p5_value

    property bjetDeepCSVVeto20Tight_2017_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2017_DR0p5_value

    property bjetDeepCSVVeto20Tight_2018_DR0p5:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_2018_DR0p5_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimu9ele9Pass:
        def __get__(self):
            self.dimu9ele9Pass_branch.GetEntry(self.localentry, 0)
            return self.dimu9ele9Pass_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

    property doubleE25Pass:
        def __get__(self):
            self.doubleE25Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE25Pass_value

    property doubleE33Pass:
        def __get__(self):
            self.doubleE33Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE33Pass_value

    property doubleE_23_12Pass:
        def __get__(self):
            self.doubleE_23_12Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Pass_value

    property doubleMuDZminMass3p8Pass:
        def __get__(self):
            self.doubleMuDZminMass3p8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass3p8Pass_value

    property doubleMuDZminMass8Pass:
        def __get__(self):
            self.doubleMuDZminMass8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass8Pass_value

    property doubleMuSingleEPass:
        def __get__(self):
            self.doubleMuSingleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPass_value

    property doubleTau35Pass:
        def __get__(self):
            self.doubleTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Pass_value

    property doubleTauCmbIso35RegPass:
        def __get__(self):
            self.doubleTauCmbIso35RegPass_branch.GetEntry(self.localentry, 0)
            return self.doubleTauCmbIso35RegPass_value

    property eCBIDLoose:
        def __get__(self):
            self.eCBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.eCBIDLoose_value

    property eCBIDMedium:
        def __get__(self):
            self.eCBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.eCBIDMedium_value

    property eCBIDTight:
        def __get__(self):
            self.eCBIDTight_branch.GetEntry(self.localentry, 0)
            return self.eCBIDTight_value

    property eCBIDVeto:
        def __get__(self):
            self.eCBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.eCBIDVeto_value

    property eCharge:
        def __get__(self):
            self.eCharge_branch.GetEntry(self.localentry, 0)
            return self.eCharge_value

    property eChargeIdLoose:
        def __get__(self):
            self.eChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdLoose_value

    property eChargeIdMed:
        def __get__(self):
            self.eChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdMed_value

    property eChargeIdTight:
        def __get__(self):
            self.eChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.eChargeIdTight_value

    property eComesFromHiggs:
        def __get__(self):
            self.eComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.eComesFromHiggs_value

    property eCorrectedEt:
        def __get__(self):
            self.eCorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.eCorrectedEt_value

    property eE1x5:
        def __get__(self):
            self.eE1x5_branch.GetEntry(self.localentry, 0)
            return self.eE1x5_value

    property eE2x5Max:
        def __get__(self):
            self.eE2x5Max_branch.GetEntry(self.localentry, 0)
            return self.eE2x5Max_value

    property eE5x5:
        def __get__(self):
            self.eE5x5_branch.GetEntry(self.localentry, 0)
            return self.eE5x5_value

    property eEcalIsoDR03:
        def __get__(self):
            self.eEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eEcalIsoDR03_value

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

    property eHadronicDepth1OverEm:
        def __get__(self):
            self.eHadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth1OverEm_value

    property eHadronicDepth2OverEm:
        def __get__(self):
            self.eHadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.eHadronicDepth2OverEm_value

    property eHadronicOverEM:
        def __get__(self):
            self.eHadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.eHadronicOverEM_value

    property eHcalIsoDR03:
        def __get__(self):
            self.eHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eHcalIsoDR03_value

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

    property eLowestMll:
        def __get__(self):
            self.eLowestMll_branch.GetEntry(self.localentry, 0)
            return self.eLowestMll_value

    property eMVAIsoWP80:
        def __get__(self):
            self.eMVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP80_value

    property eMVAIsoWP90:
        def __get__(self):
            self.eMVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWP90_value

    property eMVAIsoWPHZZ:
        def __get__(self):
            self.eMVAIsoWPHZZ_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWPHZZ_value

    property eMVAIsoWPLoose:
        def __get__(self):
            self.eMVAIsoWPLoose_branch.GetEntry(self.localentry, 0)
            return self.eMVAIsoWPLoose_value

    property eMVANoisoWP80:
        def __get__(self):
            self.eMVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP80_value

    property eMVANoisoWP90:
        def __get__(self):
            self.eMVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWP90_value

    property eMVANoisoWPLoose:
        def __get__(self):
            self.eMVANoisoWPLoose_branch.GetEntry(self.localentry, 0)
            return self.eMVANoisoWPLoose_value

    property eMass:
        def __get__(self):
            self.eMass_branch.GetEntry(self.localentry, 0)
            return self.eMass_value

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

    property eMissingHits:
        def __get__(self):
            self.eMissingHits_branch.GetEntry(self.localentry, 0)
            return self.eMissingHits_value

    property eNearMuonVeto:
        def __get__(self):
            self.eNearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.eNearMuonVeto_value

    property eNearestMuonDR:
        def __get__(self):
            self.eNearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.eNearestMuonDR_value

    property eNearestZMass:
        def __get__(self):
            self.eNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.eNearestZMass_value

    property ePFChargedIso:
        def __get__(self):
            self.ePFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFChargedIso_value

    property ePFNeutralIso:
        def __get__(self):
            self.ePFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.ePFNeutralIso_value

    property ePFPUChargedIso:
        def __get__(self):
            self.ePFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPUChargedIso_value

    property ePFPhotonIso:
        def __get__(self):
            self.ePFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.ePFPhotonIso_value

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

    property eRelIso:
        def __get__(self):
            self.eRelIso_branch.GetEntry(self.localentry, 0)
            return self.eRelIso_value

    property eRelPFIsoDB:
        def __get__(self):
            self.eRelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoDB_value

    property eRelPFIsoRho:
        def __get__(self):
            self.eRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.eRelPFIsoRho_value

    property eRho:
        def __get__(self):
            self.eRho_branch.GetEntry(self.localentry, 0)
            return self.eRho_value

    property eSCEnergy:
        def __get__(self):
            self.eSCEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCEnergy_value

    property eSCEta:
        def __get__(self):
            self.eSCEta_branch.GetEntry(self.localentry, 0)
            return self.eSCEta_value

    property eSCEtaWidth:
        def __get__(self):
            self.eSCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCEtaWidth_value

    property eSCPhi:
        def __get__(self):
            self.eSCPhi_branch.GetEntry(self.localentry, 0)
            return self.eSCPhi_value

    property eSCPhiWidth:
        def __get__(self):
            self.eSCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.eSCPhiWidth_value

    property eSCPreshowerEnergy:
        def __get__(self):
            self.eSCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCPreshowerEnergy_value

    property eSCRawEnergy:
        def __get__(self):
            self.eSCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.eSCRawEnergy_value

    property eSIP2D:
        def __get__(self):
            self.eSIP2D_branch.GetEntry(self.localentry, 0)
            return self.eSIP2D_value

    property eSIP3D:
        def __get__(self):
            self.eSIP3D_branch.GetEntry(self.localentry, 0)
            return self.eSIP3D_value

    property eSigmaIEtaIEta:
        def __get__(self):
            self.eSigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.eSigmaIEtaIEta_value

    property eTrkIsoDR03:
        def __get__(self):
            self.eTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.eTrkIsoDR03_value

    property eVZ:
        def __get__(self):
            self.eVZ_branch.GetEntry(self.localentry, 0)
            return self.eVZ_value

    property eVetoHZZPt5:
        def __get__(self):
            self.eVetoHZZPt5_branch.GetEntry(self.localentry, 0)
            return self.eVetoHZZPt5_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

    property eVetoZTTp001dxyzR0:
        def __get__(self):
            self.eVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyzR0_value

    property eZTTGenDR:
        def __get__(self):
            self.eZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenDR_value

    property eZTTGenEta:
        def __get__(self):
            self.eZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenEta_value

    property eZTTGenMatching:
        def __get__(self):
            self.eZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenMatching_value

    property eZTTGenPhi:
        def __get__(self):
            self.eZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenPhi_value

    property eZTTGenPt:
        def __get__(self):
            self.eZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.eZTTGenPt_value

    property e_t_DR:
        def __get__(self):
            self.e_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e_t_DR_value

    property e_t_Mass:
        def __get__(self):
            self.e_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e_t_Mass_value

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

    property edeltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaEtaSuperClusterTrackAtVtx_value

    property edeltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.edeltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.edeltaPhiSuperClusterTrackAtVtx_value

    property eeSuperClusterOverP:
        def __get__(self):
            self.eeSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.eeSuperClusterOverP_value

    property eecalEnergy:
        def __get__(self):
            self.eecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.eecalEnergy_value

    property efBrem:
        def __get__(self):
            self.efBrem_branch.GetEntry(self.localentry, 0)
            return self.efBrem_value

    property etrackMomentumAtVtxP:
        def __get__(self):
            self.etrackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.etrackMomentumAtVtxP_value

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

    property j1ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Down_value

    property j1ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEC2Up_value

    property j1ptWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to3Down_value

    property j1ptWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to3Up_value

    property j1ptWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to5Down_value

    property j1ptWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta0to5Up_value

    property j1ptWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta3to5Down_value

    property j1ptWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j1ptWoNoisyJets_JetEta3to5Up_value

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

    property j2ptWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Down_value

    property j2ptWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEC2Up_value

    property j2ptWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to3Down_value

    property j2ptWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to3Up_value

    property j2ptWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to5Down_value

    property j2ptWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta0to5Up_value

    property j2ptWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta3to5Down_value

    property j2ptWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.j2ptWoNoisyJets_JetEta3to5Up_value

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

    property jb1eta:
        def __get__(self):
            self.jb1eta_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_value

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

    property jb1hadronflavor:
        def __get__(self):
            self.jb1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_value

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

    property jb1phi:
        def __get__(self):
            self.jb1phi_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_value

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

    property jb1pt:
        def __get__(self):
            self.jb1pt_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_value

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

    property jb2eta:
        def __get__(self):
            self.jb2eta_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_value

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

    property jb2hadronflavor:
        def __get__(self):
            self.jb2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_value

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

    property jb2phi:
        def __get__(self):
            self.jb2phi_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_value

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

    property jb2pt:
        def __get__(self):
            self.jb2pt_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_value

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

    property jetVeto20_JetEnDown:
        def __get__(self):
            self.jetVeto20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnDown_value

    property jetVeto20_JetEnUp:
        def __get__(self):
            self.jetVeto20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_JetEnUp_value

    property jetVeto30:
        def __get__(self):
            self.jetVeto30_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_value

    property jetVeto30WoNoisyJets:
        def __get__(self):
            self.jetVeto30WoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_value

    property jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_value

    property jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_value

    property jetVeto30WoNoisyJets_JetAbsoluteScaleDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteScaleUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_value

    property jetVeto30WoNoisyJets_JetAbsoluteStatDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_value

    property jetVeto30WoNoisyJets_JetAbsoluteStatUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_value

    property jetVeto30WoNoisyJets_JetClosureDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetClosureDown_value

    property jetVeto30WoNoisyJets_JetClosureUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetClosureUp_value

    property jetVeto30WoNoisyJets_JetEC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Down_value

    property jetVeto30WoNoisyJets_JetEC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEC2Up_value

    property jetVeto30WoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to3Down_value

    property jetVeto30WoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to3Up_value

    property jetVeto30WoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to5Down_value

    property jetVeto30WoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta0to5Up_value

    property jetVeto30WoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta3to5Down_value

    property jetVeto30WoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEta3to5Up_value

    property jetVeto30WoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFlavorQCDDown_value

    property jetVeto30WoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFlavorQCDUp_value

    property jetVeto30WoNoisyJets_JetFragmentationDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFragmentationDown_value

    property jetVeto30WoNoisyJets_JetFragmentationUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetFragmentationUp_value

    property jetVeto30WoNoisyJets_JetPileUpDataMCDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_value

    property jetVeto30WoNoisyJets_JetPileUpDataMCUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_value

    property jetVeto30WoNoisyJets_JetPileUpPtBBDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_value

    property jetVeto30WoNoisyJets_JetPileUpPtBBUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_value

    property jetVeto30WoNoisyJets_JetPileUpPtEC1Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_value

    property jetVeto30WoNoisyJets_JetPileUpPtEC1Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_value

    property jetVeto30WoNoisyJets_JetPileUpPtEC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_value

    property jetVeto30WoNoisyJets_JetPileUpPtEC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_value

    property jetVeto30WoNoisyJets_JetPileUpPtHFDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_value

    property jetVeto30WoNoisyJets_JetPileUpPtHFUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_value

    property jetVeto30WoNoisyJets_JetPileUpPtRefDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_value

    property jetVeto30WoNoisyJets_JetPileUpPtRefUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_value

    property jetVeto30WoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalDown_value

    property jetVeto30WoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeBalUp_value

    property jetVeto30WoNoisyJets_JetRelativeFSRDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeFSRDown_value

    property jetVeto30WoNoisyJets_JetRelativeFSRUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeFSRUp_value

    property jetVeto30WoNoisyJets_JetRelativeJEREC1Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_value

    property jetVeto30WoNoisyJets_JetRelativeJEREC1Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_value

    property jetVeto30WoNoisyJets_JetRelativeJEREC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_value

    property jetVeto30WoNoisyJets_JetRelativeJEREC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_value

    property jetVeto30WoNoisyJets_JetRelativeJERHFDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_value

    property jetVeto30WoNoisyJets_JetRelativeJERHFUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_value

    property jetVeto30WoNoisyJets_JetRelativePtBBDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtBBDown_value

    property jetVeto30WoNoisyJets_JetRelativePtBBUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtBBUp_value

    property jetVeto30WoNoisyJets_JetRelativePtEC1Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_value

    property jetVeto30WoNoisyJets_JetRelativePtEC1Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_value

    property jetVeto30WoNoisyJets_JetRelativePtEC2Down:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_value

    property jetVeto30WoNoisyJets_JetRelativePtEC2Up:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_value

    property jetVeto30WoNoisyJets_JetRelativePtHFDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtHFDown_value

    property jetVeto30WoNoisyJets_JetRelativePtHFUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativePtHFUp_value

    property jetVeto30WoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value

    property jetVeto30WoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value

    property jetVeto30WoNoisyJets_JetRelativeStatECDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatECDown_value

    property jetVeto30WoNoisyJets_JetRelativeStatECUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatECUp_value

    property jetVeto30WoNoisyJets_JetRelativeStatFSRDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_value

    property jetVeto30WoNoisyJets_JetRelativeStatFSRUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_value

    property jetVeto30WoNoisyJets_JetRelativeStatHFDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_value

    property jetVeto30WoNoisyJets_JetRelativeStatHFUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_value

    property jetVeto30WoNoisyJets_JetSinglePionECALDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetSinglePionECALDown_value

    property jetVeto30WoNoisyJets_JetSinglePionECALUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetSinglePionECALUp_value

    property jetVeto30WoNoisyJets_JetSinglePionHCALDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_value

    property jetVeto30WoNoisyJets_JetSinglePionHCALUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_value

    property jetVeto30WoNoisyJets_JetTimePtEtaDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTimePtEtaDown_value

    property jetVeto30WoNoisyJets_JetTimePtEtaUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTimePtEtaUp_value

    property jetVeto30WoNoisyJets_JetTotalDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalDown_value

    property jetVeto30WoNoisyJets_JetTotalUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetTotalUp_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property metSig:
        def __get__(self):
            self.metSig_branch.GetEntry(self.localentry, 0)
            return self.metSig_value

    property metcov00:
        def __get__(self):
            self.metcov00_branch.GetEntry(self.localentry, 0)
            return self.metcov00_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

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

    property mu8diele12DZPass:
        def __get__(self):
            self.mu8diele12DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu8diele12DZPass_value

    property mu8diele12Pass:
        def __get__(self):
            self.mu8diele12Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8diele12Pass_value

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

    property muVeto5:
        def __get__(self):
            self.muVeto5_branch.GetEntry(self.localentry, 0)
            return self.muVeto5_value

    property muVetoZTTp001dxyz:
        def __get__(self):
            self.muVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyz_value

    property muVetoZTTp001dxyzR0:
        def __get__(self):
            self.muVetoZTTp001dxyzR0_branch.GetEntry(self.localentry, 0)
            return self.muVetoZTTp001dxyzR0_value

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

    property raw_pfMetEt:
        def __get__(self):
            self.raw_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetEt_value

    property raw_pfMetPhi:
        def __get__(self):
            self.raw_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.raw_pfMetPhi_value

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

    property singleIsoMu22Pass:
        def __get__(self):
            self.singleIsoMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22Pass_value

    property singleIsoMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu22eta2p1Pass_value

    property singleIsoTkMu22Pass:
        def __get__(self):
            self.singleIsoTkMu22Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22Pass_value

    property singleIsoTkMu22eta2p1Pass:
        def __get__(self):
            self.singleIsoTkMu22eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoTkMu22eta2p1Pass_value

    property singleMu19eta2p1LooseTau20Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20Pass_value

    property singleMu19eta2p1LooseTau20singleL1Pass:
        def __get__(self):
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu19eta2p1LooseTau20singleL1Pass_value

    property tAgainstElectronLooseMVA6:
        def __get__(self):
            self.tAgainstElectronLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronLooseMVA6_value

    property tAgainstElectronLooseMVA62018:
        def __get__(self):
            self.tAgainstElectronLooseMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronLooseMVA62018_value

    property tAgainstElectronMVA6Raw:
        def __get__(self):
            self.tAgainstElectronMVA6Raw_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6Raw_value

    property tAgainstElectronMVA6Raw2018:
        def __get__(self):
            self.tAgainstElectronMVA6Raw2018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6Raw2018_value

    property tAgainstElectronMVA6category:
        def __get__(self):
            self.tAgainstElectronMVA6category_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6category_value

    property tAgainstElectronMVA6category2018:
        def __get__(self):
            self.tAgainstElectronMVA6category2018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6category2018_value

    property tAgainstElectronMediumMVA6:
        def __get__(self):
            self.tAgainstElectronMediumMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMediumMVA6_value

    property tAgainstElectronMediumMVA62018:
        def __get__(self):
            self.tAgainstElectronMediumMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMediumMVA62018_value

    property tAgainstElectronTightMVA6:
        def __get__(self):
            self.tAgainstElectronTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA6_value

    property tAgainstElectronTightMVA62018:
        def __get__(self):
            self.tAgainstElectronTightMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA62018_value

    property tAgainstElectronVLooseMVA6:
        def __get__(self):
            self.tAgainstElectronVLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA6_value

    property tAgainstElectronVLooseMVA62018:
        def __get__(self):
            self.tAgainstElectronVLooseMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA62018_value

    property tAgainstElectronVTightMVA6:
        def __get__(self):
            self.tAgainstElectronVTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVTightMVA6_value

    property tAgainstElectronVTightMVA62018:
        def __get__(self):
            self.tAgainstElectronVTightMVA62018_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVTightMVA62018_value

    property tAgainstMuonLoose3:
        def __get__(self):
            self.tAgainstMuonLoose3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonLoose3_value

    property tAgainstMuonTight3:
        def __get__(self):
            self.tAgainstMuonTight3_branch.GetEntry(self.localentry, 0)
            return self.tAgainstMuonTight3_value

    property tByCombinedIsolationDeltaBetaCorrRaw3Hits:
        def __get__(self):
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value

    property tByIsolationMVArun2v1DBdR03oldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    property tByIsolationMVArun2v1DBnewDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBnewDMwLTraw_value

    property tByIsolationMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBoldDMwLTraw_value

    property tByLooseCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value

    property tByLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByMediumCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value

    property tByMediumIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByMediumIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBnewDMwLT_value

    property tByMediumIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBoldDMwLT_value

    property tByPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tByPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tByPhotonPtSumOutsideSignalCone_value

    property tByTightCombinedIsolationDeltaBetaCorr3Hits:
        def __get__(self):
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.GetEntry(self.localentry, 0)
            return self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value

    property tByTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBnewDMwLT_value

    property tByTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value

    property tByVLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBnewDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value

    property tByVVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value

    property tCharge:
        def __get__(self):
            self.tCharge_branch.GetEntry(self.localentry, 0)
            return self.tCharge_value

    property tChargedIsoPtSum:
        def __get__(self):
            self.tChargedIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSum_value

    property tChargedIsoPtSumdR03:
        def __get__(self):
            self.tChargedIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tChargedIsoPtSumdR03_value

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

    property tDeepTau2017v1VSeraw:
        def __get__(self):
            self.tDeepTau2017v1VSeraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v1VSeraw_value

    property tDeepTau2017v1VSjetraw:
        def __get__(self):
            self.tDeepTau2017v1VSjetraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v1VSjetraw_value

    property tDeepTau2017v1VSmuraw:
        def __get__(self):
            self.tDeepTau2017v1VSmuraw_branch.GetEntry(self.localentry, 0)
            return self.tDeepTau2017v1VSmuraw_value

    property tDpfTau2016v0VSallraw:
        def __get__(self):
            self.tDpfTau2016v0VSallraw_branch.GetEntry(self.localentry, 0)
            return self.tDpfTau2016v0VSallraw_value

    property tDpfTau2016v1VSallraw:
        def __get__(self):
            self.tDpfTau2016v1VSallraw_branch.GetEntry(self.localentry, 0)
            return self.tDpfTau2016v1VSallraw_value

    property tEta:
        def __get__(self):
            self.tEta_branch.GetEntry(self.localentry, 0)
            return self.tEta_value

    property tFootprintCorrection:
        def __get__(self):
            self.tFootprintCorrection_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrection_value

    property tFootprintCorrectiondR03:
        def __get__(self):
            self.tFootprintCorrectiondR03_branch.GetEntry(self.localentry, 0)
            return self.tFootprintCorrectiondR03_value

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

    property tLooseDeepTau2017v1VSe:
        def __get__(self):
            self.tLooseDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v1VSe_value

    property tLooseDeepTau2017v1VSjet:
        def __get__(self):
            self.tLooseDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v1VSjet_value

    property tLooseDeepTau2017v1VSmu:
        def __get__(self):
            self.tLooseDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tLooseDeepTau2017v1VSmu_value

    property tLowestMll:
        def __get__(self):
            self.tLowestMll_branch.GetEntry(self.localentry, 0)
            return self.tLowestMll_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

    property tMatchesDoubleMediumCombinedIsoTau35Path:
        def __get__(self):
            self.tMatchesDoubleMediumCombinedIsoTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumCombinedIsoTau35Path_value

    property tMatchesDoubleMediumHPSTau35Filter:
        def __get__(self):
            self.tMatchesDoubleMediumHPSTau35Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumHPSTau35Filter_value

    property tMatchesDoubleMediumHPSTau35Path:
        def __get__(self):
            self.tMatchesDoubleMediumHPSTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumHPSTau35Path_value

    property tMatchesDoubleMediumHPSTau40Filter:
        def __get__(self):
            self.tMatchesDoubleMediumHPSTau40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumHPSTau40Filter_value

    property tMatchesDoubleMediumHPSTau40Path:
        def __get__(self):
            self.tMatchesDoubleMediumHPSTau40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumHPSTau40Path_value

    property tMatchesDoubleMediumIsoTau35Path:
        def __get__(self):
            self.tMatchesDoubleMediumIsoTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumIsoTau35Path_value

    property tMatchesDoubleMediumTau35Filter:
        def __get__(self):
            self.tMatchesDoubleMediumTau35Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumTau35Filter_value

    property tMatchesDoubleMediumTau35Path:
        def __get__(self):
            self.tMatchesDoubleMediumTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumTau35Path_value

    property tMatchesDoubleMediumTau40Filter:
        def __get__(self):
            self.tMatchesDoubleMediumTau40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumTau40Filter_value

    property tMatchesDoubleMediumTau40Path:
        def __get__(self):
            self.tMatchesDoubleMediumTau40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleMediumTau40Path_value

    property tMatchesDoubleTightHPSTau35Filter:
        def __get__(self):
            self.tMatchesDoubleTightHPSTau35Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightHPSTau35Filter_value

    property tMatchesDoubleTightHPSTau35Path:
        def __get__(self):
            self.tMatchesDoubleTightHPSTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightHPSTau35Path_value

    property tMatchesDoubleTightHPSTau40Filter:
        def __get__(self):
            self.tMatchesDoubleTightHPSTau40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightHPSTau40Filter_value

    property tMatchesDoubleTightHPSTau40Path:
        def __get__(self):
            self.tMatchesDoubleTightHPSTau40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightHPSTau40Path_value

    property tMatchesDoubleTightTau35Filter:
        def __get__(self):
            self.tMatchesDoubleTightTau35Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightTau35Filter_value

    property tMatchesDoubleTightTau35Path:
        def __get__(self):
            self.tMatchesDoubleTightTau35Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightTau35Path_value

    property tMatchesDoubleTightTau40Filter:
        def __get__(self):
            self.tMatchesDoubleTightTau40Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightTau40Filter_value

    property tMatchesDoubleTightTau40Path:
        def __get__(self):
            self.tMatchesDoubleTightTau40Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesDoubleTightTau40Path_value

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

    property tMatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.tMatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu19Tau20Filter_value

    property tMatchesIsoMu19Tau20Path:
        def __get__(self):
            self.tMatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu19Tau20Path_value

    property tMatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.tMatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu19Tau20SingleL1Filter_value

    property tMatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.tMatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu19Tau20SingleL1Path_value

    property tMatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.tMatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20HPSTau27Filter_value

    property tMatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.tMatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20HPSTau27Path_value

    property tMatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.tMatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20Tau27Filter_value

    property tMatchesIsoMu20Tau27Path:
        def __get__(self):
            self.tMatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20Tau27Path_value

    property tMediumDeepTau2017v1VSe:
        def __get__(self):
            self.tMediumDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v1VSe_value

    property tMediumDeepTau2017v1VSjet:
        def __get__(self):
            self.tMediumDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v1VSjet_value

    property tMediumDeepTau2017v1VSmu:
        def __get__(self):
            self.tMediumDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tMediumDeepTau2017v1VSmu_value

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

    property tNeutralIsoPtSum:
        def __get__(self):
            self.tNeutralIsoPtSum_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSum_value

    property tNeutralIsoPtSumWeight:
        def __get__(self):
            self.tNeutralIsoPtSumWeight_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeight_value

    property tNeutralIsoPtSumWeightdR03:
        def __get__(self):
            self.tNeutralIsoPtSumWeightdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumWeightdR03_value

    property tNeutralIsoPtSumdR03:
        def __get__(self):
            self.tNeutralIsoPtSumdR03_branch.GetEntry(self.localentry, 0)
            return self.tNeutralIsoPtSumdR03_value

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

    property tPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalCone_value

    property tPhotonPtSumOutsideSignalConedR03:
        def __get__(self):
            self.tPhotonPtSumOutsideSignalConedR03_branch.GetEntry(self.localentry, 0)
            return self.tPhotonPtSumOutsideSignalConedR03_value

    property tPt:
        def __get__(self):
            self.tPt_branch.GetEntry(self.localentry, 0)
            return self.tPt_value

    property tPuCorrPtSum:
        def __get__(self):
            self.tPuCorrPtSum_branch.GetEntry(self.localentry, 0)
            return self.tPuCorrPtSum_value

    property tRerunMVArun2v2DBoldDMwLTLoose:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTLoose_value

    property tRerunMVArun2v2DBoldDMwLTMedium:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTMedium_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTMedium_value

    property tRerunMVArun2v2DBoldDMwLTTight:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTTight_value

    property tRerunMVArun2v2DBoldDMwLTVLoose:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTVLoose_value

    property tRerunMVArun2v2DBoldDMwLTVTight:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTVTight_value

    property tRerunMVArun2v2DBoldDMwLTVVLoose:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTVVLoose_value

    property tRerunMVArun2v2DBoldDMwLTVVTight:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTVVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTVVTight_value

    property tRerunMVArun2v2DBoldDMwLTraw:
        def __get__(self):
            self.tRerunMVArun2v2DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v2DBoldDMwLTraw_value

    property tTightDeepTau2017v1VSe:
        def __get__(self):
            self.tTightDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v1VSe_value

    property tTightDeepTau2017v1VSjet:
        def __get__(self):
            self.tTightDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v1VSjet_value

    property tTightDeepTau2017v1VSmu:
        def __get__(self):
            self.tTightDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tTightDeepTau2017v1VSmu_value

    property tTightDpfTau2016v0VSall:
        def __get__(self):
            self.tTightDpfTau2016v0VSall_branch.GetEntry(self.localentry, 0)
            return self.tTightDpfTau2016v0VSall_value

    property tTightDpfTau2016v1VSall:
        def __get__(self):
            self.tTightDpfTau2016v1VSall_branch.GetEntry(self.localentry, 0)
            return self.tTightDpfTau2016v1VSall_value

    property tVLooseDeepTau2017v1VSe:
        def __get__(self):
            self.tVLooseDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v1VSe_value

    property tVLooseDeepTau2017v1VSjet:
        def __get__(self):
            self.tVLooseDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v1VSjet_value

    property tVLooseDeepTau2017v1VSmu:
        def __get__(self):
            self.tVLooseDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVLooseDeepTau2017v1VSmu_value

    property tVTightDeepTau2017v1VSe:
        def __get__(self):
            self.tVTightDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v1VSe_value

    property tVTightDeepTau2017v1VSjet:
        def __get__(self):
            self.tVTightDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v1VSjet_value

    property tVTightDeepTau2017v1VSmu:
        def __get__(self):
            self.tVTightDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVTightDeepTau2017v1VSmu_value

    property tVVLooseDeepTau2017v1VSe:
        def __get__(self):
            self.tVVLooseDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v1VSe_value

    property tVVLooseDeepTau2017v1VSjet:
        def __get__(self):
            self.tVVLooseDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v1VSjet_value

    property tVVLooseDeepTau2017v1VSmu:
        def __get__(self):
            self.tVVLooseDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v1VSmu_value

    property tVVTightDeepTau2017v1VSe:
        def __get__(self):
            self.tVVTightDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v1VSe_value

    property tVVTightDeepTau2017v1VSjet:
        def __get__(self):
            self.tVVTightDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v1VSjet_value

    property tVVTightDeepTau2017v1VSmu:
        def __get__(self):
            self.tVVTightDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVTightDeepTau2017v1VSmu_value

    property tVVVLooseDeepTau2017v1VSe:
        def __get__(self):
            self.tVVVLooseDeepTau2017v1VSe_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v1VSe_value

    property tVVVLooseDeepTau2017v1VSjet:
        def __get__(self):
            self.tVVVLooseDeepTau2017v1VSjet_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v1VSjet_value

    property tVVVLooseDeepTau2017v1VSmu:
        def __get__(self):
            self.tVVVLooseDeepTau2017v1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v1VSmu_value

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

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

    property tauVetoPt20LooseMVALTVtx:
        def __get__(self):
            self.tauVetoPt20LooseMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20LooseMVALTVtx_value

    property tauVetoPt20TightMVALTVtx:
        def __get__(self):
            self.tauVetoPt20TightMVALTVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20TightMVALTVtx_value

    property topQuarkPt1:
        def __get__(self):
            self.topQuarkPt1_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt1_value

    property topQuarkPt2:
        def __get__(self):
            self.topQuarkPt2_branch.GetEntry(self.localentry, 0)
            return self.topQuarkPt2_value

    property tripleEPass:
        def __get__(self):
            self.tripleEPass_branch.GetEntry(self.localentry, 0)
            return self.tripleEPass_value

    property tripleMu10_5_5Pass:
        def __get__(self):
            self.tripleMu10_5_5Pass_branch.GetEntry(self.localentry, 0)
            return self.tripleMu10_5_5Pass_value

    property tripleMu12_10_5Pass:
        def __get__(self):
            self.tripleMu12_10_5Pass_branch.GetEntry(self.localentry, 0)
            return self.tripleMu12_10_5Pass_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteScaleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteScaleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value

    property type1_pfMet_shiftedPhi_JetAbsoluteStatDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value

    property type1_pfMet_shiftedPhi_JetAbsoluteStatUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value

    property type1_pfMet_shiftedPhi_JetClosureDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetClosureDown_value

    property type1_pfMet_shiftedPhi_JetClosureUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetClosureUp_value

    property type1_pfMet_shiftedPhi_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnDown_value

    property type1_pfMet_shiftedPhi_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEnUp_value

    property type1_pfMet_shiftedPhi_JetEta0to3Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to3Down_value

    property type1_pfMet_shiftedPhi_JetEta0to3Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to3Up_value

    property type1_pfMet_shiftedPhi_JetEta0to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to5Down_value

    property type1_pfMet_shiftedPhi_JetEta0to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta0to5Up_value

    property type1_pfMet_shiftedPhi_JetEta3to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta3to5Down_value

    property type1_pfMet_shiftedPhi_JetEta3to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetEta3to5Up_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPhi_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPhi_JetFragmentationDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFragmentationDown_value

    property type1_pfMet_shiftedPhi_JetFragmentationUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetFragmentationUp_value

    property type1_pfMet_shiftedPhi_JetPileUpDataMCDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value

    property type1_pfMet_shiftedPhi_JetPileUpDataMCUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value

    property type1_pfMet_shiftedPhi_JetPileUpPtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value

    property type1_pfMet_shiftedPhi_JetPileUpPtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value

    property type1_pfMet_shiftedPhi_JetPileUpPtRefDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value

    property type1_pfMet_shiftedPhi_JetPileUpPtRefUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value

    property type1_pfMet_shiftedPhi_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value

    property type1_pfMet_shiftedPhi_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value

    property type1_pfMet_shiftedPhi_JetRelativeFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value

    property type1_pfMet_shiftedPhi_JetRelativeFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value

    property type1_pfMet_shiftedPhi_JetRelativeJEREC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value

    property type1_pfMet_shiftedPhi_JetRelativeJERHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativeJERHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value

    property type1_pfMet_shiftedPhi_JetRelativePtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value

    property type1_pfMet_shiftedPhi_JetRelativePtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value

    property type1_pfMet_shiftedPhi_JetRelativePtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value

    property type1_pfMet_shiftedPhi_JetRelativePtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativePtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPhi_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatECDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatECUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value

    property type1_pfMet_shiftedPhi_JetRelativeStatHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value

    property type1_pfMet_shiftedPhi_JetRelativeStatHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value

    property type1_pfMet_shiftedPhi_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResDown_value

    property type1_pfMet_shiftedPhi_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetResUp_value

    property type1_pfMet_shiftedPhi_JetSinglePionECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value

    property type1_pfMet_shiftedPhi_JetSinglePionECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value

    property type1_pfMet_shiftedPhi_JetSinglePionHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value

    property type1_pfMet_shiftedPhi_JetSinglePionHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value

    property type1_pfMet_shiftedPhi_JetTimePtEtaDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value

    property type1_pfMet_shiftedPhi_JetTimePtEtaUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value

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

    property type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteScaleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteScaleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value

    property type1_pfMet_shiftedPt_JetAbsoluteStatDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value

    property type1_pfMet_shiftedPt_JetAbsoluteStatUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value

    property type1_pfMet_shiftedPt_JetClosureDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetClosureDown_value

    property type1_pfMet_shiftedPt_JetClosureUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetClosureUp_value

    property type1_pfMet_shiftedPt_JetEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnDown_value

    property type1_pfMet_shiftedPt_JetEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEnUp_value

    property type1_pfMet_shiftedPt_JetEta0to3Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to3Down_value

    property type1_pfMet_shiftedPt_JetEta0to3Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to3Up_value

    property type1_pfMet_shiftedPt_JetEta0to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to5Down_value

    property type1_pfMet_shiftedPt_JetEta0to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta0to5Up_value

    property type1_pfMet_shiftedPt_JetEta3to5Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta3to5Down_value

    property type1_pfMet_shiftedPt_JetEta3to5Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetEta3to5Up_value

    property type1_pfMet_shiftedPt_JetFlavorQCDDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value

    property type1_pfMet_shiftedPt_JetFlavorQCDUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value

    property type1_pfMet_shiftedPt_JetFragmentationDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFragmentationDown_value

    property type1_pfMet_shiftedPt_JetFragmentationUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetFragmentationUp_value

    property type1_pfMet_shiftedPt_JetPileUpDataMCDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value

    property type1_pfMet_shiftedPt_JetPileUpDataMCUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value

    property type1_pfMet_shiftedPt_JetPileUpPtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value

    property type1_pfMet_shiftedPt_JetPileUpPtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value

    property type1_pfMet_shiftedPt_JetPileUpPtRefDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value

    property type1_pfMet_shiftedPt_JetPileUpPtRefUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value

    property type1_pfMet_shiftedPt_JetRelativeBalDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalDown_value

    property type1_pfMet_shiftedPt_JetRelativeBalUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeBalUp_value

    property type1_pfMet_shiftedPt_JetRelativeFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value

    property type1_pfMet_shiftedPt_JetRelativeFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value

    property type1_pfMet_shiftedPt_JetRelativeJEREC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value

    property type1_pfMet_shiftedPt_JetRelativeJERHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value

    property type1_pfMet_shiftedPt_JetRelativeJERHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value

    property type1_pfMet_shiftedPt_JetRelativePtBBDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value

    property type1_pfMet_shiftedPt_JetRelativePtBBUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value

    property type1_pfMet_shiftedPt_JetRelativePtEC1Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value

    property type1_pfMet_shiftedPt_JetRelativePtEC1Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value

    property type1_pfMet_shiftedPt_JetRelativePtEC2Down:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value

    property type1_pfMet_shiftedPt_JetRelativePtEC2Up:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value

    property type1_pfMet_shiftedPt_JetRelativePtHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value

    property type1_pfMet_shiftedPt_JetRelativePtHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value

    property type1_pfMet_shiftedPt_JetRelativeSampleDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value

    property type1_pfMet_shiftedPt_JetRelativeSampleUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatECDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatECUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatFSRDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatFSRUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value

    property type1_pfMet_shiftedPt_JetRelativeStatHFDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value

    property type1_pfMet_shiftedPt_JetRelativeStatHFUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value

    property type1_pfMet_shiftedPt_JetResDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResDown_value

    property type1_pfMet_shiftedPt_JetResUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetResUp_value

    property type1_pfMet_shiftedPt_JetSinglePionECALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value

    property type1_pfMet_shiftedPt_JetSinglePionECALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value

    property type1_pfMet_shiftedPt_JetSinglePionHCALDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value

    property type1_pfMet_shiftedPt_JetSinglePionHCALUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value

    property type1_pfMet_shiftedPt_JetTimePtEtaDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value

    property type1_pfMet_shiftedPt_JetTimePtEtaUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value

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

    property vbfMassWoNoisyJets_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_value

    property vbfMassWoNoisyJets_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_value

    property vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_value

    property vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_value

    property vbfMassWoNoisyJets_JetAbsoluteScaleDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_value

    property vbfMassWoNoisyJets_JetAbsoluteScaleUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_value

    property vbfMassWoNoisyJets_JetAbsoluteStatDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteStatDown_value

    property vbfMassWoNoisyJets_JetAbsoluteStatUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetAbsoluteStatUp_value

    property vbfMassWoNoisyJets_JetClosureDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetClosureDown_value

    property vbfMassWoNoisyJets_JetClosureUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetClosureUp_value

    property vbfMassWoNoisyJets_JetEC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Down_value

    property vbfMassWoNoisyJets_JetEC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEC2Up_value

    property vbfMassWoNoisyJets_JetEta0to3Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to3Down_value

    property vbfMassWoNoisyJets_JetEta0to3Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to3Up_value

    property vbfMassWoNoisyJets_JetEta0to5Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to5Down_value

    property vbfMassWoNoisyJets_JetEta0to5Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta0to5Up_value

    property vbfMassWoNoisyJets_JetEta3to5Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta3to5Down_value

    property vbfMassWoNoisyJets_JetEta3to5Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetEta3to5Up_value

    property vbfMassWoNoisyJets_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFlavorQCDDown_value

    property vbfMassWoNoisyJets_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFlavorQCDUp_value

    property vbfMassWoNoisyJets_JetFragmentationDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFragmentationDown_value

    property vbfMassWoNoisyJets_JetFragmentationUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetFragmentationUp_value

    property vbfMassWoNoisyJets_JetPileUpDataMCDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpDataMCDown_value

    property vbfMassWoNoisyJets_JetPileUpDataMCUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpDataMCUp_value

    property vbfMassWoNoisyJets_JetPileUpPtBBDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtBBDown_value

    property vbfMassWoNoisyJets_JetPileUpPtBBUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtBBUp_value

    property vbfMassWoNoisyJets_JetPileUpPtEC1Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_value

    property vbfMassWoNoisyJets_JetPileUpPtEC1Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_value

    property vbfMassWoNoisyJets_JetPileUpPtEC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_value

    property vbfMassWoNoisyJets_JetPileUpPtEC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_value

    property vbfMassWoNoisyJets_JetPileUpPtHFDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtHFDown_value

    property vbfMassWoNoisyJets_JetPileUpPtHFUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtHFUp_value

    property vbfMassWoNoisyJets_JetPileUpPtRefDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtRefDown_value

    property vbfMassWoNoisyJets_JetPileUpPtRefUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetPileUpPtRefUp_value

    property vbfMassWoNoisyJets_JetRelativeBalDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalDown_value

    property vbfMassWoNoisyJets_JetRelativeBalUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeBalUp_value

    property vbfMassWoNoisyJets_JetRelativeFSRDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeFSRDown_value

    property vbfMassWoNoisyJets_JetRelativeFSRUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeFSRUp_value

    property vbfMassWoNoisyJets_JetRelativeJEREC1Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_value

    property vbfMassWoNoisyJets_JetRelativeJEREC1Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_value

    property vbfMassWoNoisyJets_JetRelativeJEREC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_value

    property vbfMassWoNoisyJets_JetRelativeJEREC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_value

    property vbfMassWoNoisyJets_JetRelativeJERHFDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJERHFDown_value

    property vbfMassWoNoisyJets_JetRelativeJERHFUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeJERHFUp_value

    property vbfMassWoNoisyJets_JetRelativePtBBDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtBBDown_value

    property vbfMassWoNoisyJets_JetRelativePtBBUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtBBUp_value

    property vbfMassWoNoisyJets_JetRelativePtEC1Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtEC1Down_value

    property vbfMassWoNoisyJets_JetRelativePtEC1Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtEC1Up_value

    property vbfMassWoNoisyJets_JetRelativePtEC2Down:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtEC2Down_value

    property vbfMassWoNoisyJets_JetRelativePtEC2Up:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtEC2Up_value

    property vbfMassWoNoisyJets_JetRelativePtHFDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtHFDown_value

    property vbfMassWoNoisyJets_JetRelativePtHFUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativePtHFUp_value

    property vbfMassWoNoisyJets_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleDown_value

    property vbfMassWoNoisyJets_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeSampleUp_value

    property vbfMassWoNoisyJets_JetRelativeStatECDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatECDown_value

    property vbfMassWoNoisyJets_JetRelativeStatECUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatECUp_value

    property vbfMassWoNoisyJets_JetRelativeStatFSRDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_value

    property vbfMassWoNoisyJets_JetRelativeStatFSRUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_value

    property vbfMassWoNoisyJets_JetRelativeStatHFDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatHFDown_value

    property vbfMassWoNoisyJets_JetRelativeStatHFUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetRelativeStatHFUp_value

    property vbfMassWoNoisyJets_JetSinglePionECALDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetSinglePionECALDown_value

    property vbfMassWoNoisyJets_JetSinglePionECALUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetSinglePionECALUp_value

    property vbfMassWoNoisyJets_JetSinglePionHCALDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetSinglePionHCALDown_value

    property vbfMassWoNoisyJets_JetSinglePionHCALUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetSinglePionHCALUp_value

    property vbfMassWoNoisyJets_JetTimePtEtaDown:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTimePtEtaDown_value

    property vbfMassWoNoisyJets_JetTimePtEtaUp:
        def __get__(self):
            self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMassWoNoisyJets_JetTimePtEtaUp_value

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

