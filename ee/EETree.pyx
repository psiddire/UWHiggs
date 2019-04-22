

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

cdef class EETree:
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

    cdef TBranch* DoubleMediumTau35Group_branch
    cdef float DoubleMediumTau35Group_value

    cdef TBranch* DoubleMediumTau35Pass_branch
    cdef float DoubleMediumTau35Pass_value

    cdef TBranch* DoubleMediumTau35Prescale_branch
    cdef float DoubleMediumTau35Prescale_value

    cdef TBranch* DoubleMediumTau40Group_branch
    cdef float DoubleMediumTau40Group_value

    cdef TBranch* DoubleMediumTau40Pass_branch
    cdef float DoubleMediumTau40Pass_value

    cdef TBranch* DoubleMediumTau40Prescale_branch
    cdef float DoubleMediumTau40Prescale_value

    cdef TBranch* DoubleTightTau35Group_branch
    cdef float DoubleTightTau35Group_value

    cdef TBranch* DoubleTightTau35Pass_branch
    cdef float DoubleTightTau35Pass_value

    cdef TBranch* DoubleTightTau35Prescale_branch
    cdef float DoubleTightTau35Prescale_value

    cdef TBranch* DoubleTightTau40Group_branch
    cdef float DoubleTightTau40Group_value

    cdef TBranch* DoubleTightTau40Pass_branch
    cdef float DoubleTightTau40Pass_value

    cdef TBranch* DoubleTightTau40Prescale_branch
    cdef float DoubleTightTau40Prescale_value

    cdef TBranch* Ele24Tau30Group_branch
    cdef float Ele24Tau30Group_value

    cdef TBranch* Ele24Tau30Pass_branch
    cdef float Ele24Tau30Pass_value

    cdef TBranch* Ele24Tau30Prescale_branch
    cdef float Ele24Tau30Prescale_value

    cdef TBranch* Ele27WPTightGroup_branch
    cdef float Ele27WPTightGroup_value

    cdef TBranch* Ele27WPTightPass_branch
    cdef float Ele27WPTightPass_value

    cdef TBranch* Ele27WPTightPrescale_branch
    cdef float Ele27WPTightPrescale_value

    cdef TBranch* Ele32WPTightGroup_branch
    cdef float Ele32WPTightGroup_value

    cdef TBranch* Ele32WPTightPass_branch
    cdef float Ele32WPTightPass_value

    cdef TBranch* Ele32WPTightPrescale_branch
    cdef float Ele32WPTightPrescale_value

    cdef TBranch* Ele35WPTightGroup_branch
    cdef float Ele35WPTightGroup_value

    cdef TBranch* Ele35WPTightPass_branch
    cdef float Ele35WPTightPass_value

    cdef TBranch* Ele35WPTightPrescale_branch
    cdef float Ele35WPTightPrescale_value

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

    cdef TBranch* IsoMu20Group_branch
    cdef float IsoMu20Group_value

    cdef TBranch* IsoMu20Pass_branch
    cdef float IsoMu20Pass_value

    cdef TBranch* IsoMu20Prescale_branch
    cdef float IsoMu20Prescale_value

    cdef TBranch* IsoMu24Group_branch
    cdef float IsoMu24Group_value

    cdef TBranch* IsoMu24Pass_branch
    cdef float IsoMu24Pass_value

    cdef TBranch* IsoMu24Prescale_branch
    cdef float IsoMu24Prescale_value

    cdef TBranch* IsoMu24_eta2p1Group_branch
    cdef float IsoMu24_eta2p1Group_value

    cdef TBranch* IsoMu24_eta2p1Pass_branch
    cdef float IsoMu24_eta2p1Pass_value

    cdef TBranch* IsoMu24_eta2p1Prescale_branch
    cdef float IsoMu24_eta2p1Prescale_value

    cdef TBranch* IsoMu27Group_branch
    cdef float IsoMu27Group_value

    cdef TBranch* IsoMu27Pass_branch
    cdef float IsoMu27Pass_value

    cdef TBranch* IsoMu27Prescale_branch
    cdef float IsoMu27Prescale_value

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

    cdef TBranch* Mu20Tau27Group_branch
    cdef float Mu20Tau27Group_value

    cdef TBranch* Mu20Tau27Pass_branch
    cdef float Mu20Tau27Pass_value

    cdef TBranch* Mu20Tau27Prescale_branch
    cdef float Mu20Tau27Prescale_value

    cdef TBranch* Mu50Group_branch
    cdef float Mu50Group_value

    cdef TBranch* Mu50Pass_branch
    cdef float Mu50Pass_value

    cdef TBranch* Mu50Prescale_branch
    cdef float Mu50Prescale_value

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

    cdef TBranch* bjetCISVVeto20Loose_branch
    cdef float bjetCISVVeto20Loose_value

    cdef TBranch* bjetCISVVeto20Medium_branch
    cdef float bjetCISVVeto20Medium_value

    cdef TBranch* bjetCISVVeto20MediumWoNoisyJets_branch
    cdef float bjetCISVVeto20MediumWoNoisyJets_value

    cdef TBranch* bjetCISVVeto20Tight_branch
    cdef float bjetCISVVeto20Tight_value

    cdef TBranch* bjetCISVVeto30Loose_branch
    cdef float bjetCISVVeto30Loose_value

    cdef TBranch* bjetCISVVeto30Medium_branch
    cdef float bjetCISVVeto30Medium_value

    cdef TBranch* bjetCISVVeto30Tight_branch
    cdef float bjetCISVVeto30Tight_value

    cdef TBranch* bjetDeepCSVVeto20Loose_branch
    cdef float bjetDeepCSVVeto20Loose_value

    cdef TBranch* bjetDeepCSVVeto20Medium_branch
    cdef float bjetDeepCSVVeto20Medium_value

    cdef TBranch* bjetDeepCSVVeto20MediumWoNoisyJets_branch
    cdef float bjetDeepCSVVeto20MediumWoNoisyJets_value

    cdef TBranch* bjetDeepCSVVeto20Tight_branch
    cdef float bjetDeepCSVVeto20Tight_value

    cdef TBranch* bjetDeepCSVVeto30Loose_branch
    cdef float bjetDeepCSVVeto30Loose_value

    cdef TBranch* bjetDeepCSVVeto30Medium_branch
    cdef float bjetDeepCSVVeto30Medium_value

    cdef TBranch* bjetDeepCSVVeto30Tight_branch
    cdef float bjetDeepCSVVeto30Tight_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* doubleE_23_12Group_branch
    cdef float doubleE_23_12Group_value

    cdef TBranch* doubleE_23_12Pass_branch
    cdef float doubleE_23_12Pass_value

    cdef TBranch* doubleE_23_12Prescale_branch
    cdef float doubleE_23_12Prescale_value

    cdef TBranch* doubleE_23_12_DZGroup_branch
    cdef float doubleE_23_12_DZGroup_value

    cdef TBranch* doubleE_23_12_DZPass_branch
    cdef float doubleE_23_12_DZPass_value

    cdef TBranch* doubleE_23_12_DZPrescale_branch
    cdef float doubleE_23_12_DZPrescale_value

    cdef TBranch* doubleMuDZGroup_branch
    cdef float doubleMuDZGroup_value

    cdef TBranch* doubleMuDZPass_branch
    cdef float doubleMuDZPass_value

    cdef TBranch* doubleMuDZPrescale_branch
    cdef float doubleMuDZPrescale_value

    cdef TBranch* doubleMuDZminMass3p8Group_branch
    cdef float doubleMuDZminMass3p8Group_value

    cdef TBranch* doubleMuDZminMass3p8Pass_branch
    cdef float doubleMuDZminMass3p8Pass_value

    cdef TBranch* doubleMuDZminMass3p8Prescale_branch
    cdef float doubleMuDZminMass3p8Prescale_value

    cdef TBranch* doubleMuDZminMass8Group_branch
    cdef float doubleMuDZminMass8Group_value

    cdef TBranch* doubleMuDZminMass8Pass_branch
    cdef float doubleMuDZminMass8Pass_value

    cdef TBranch* doubleMuDZminMass8Prescale_branch
    cdef float doubleMuDZminMass8Prescale_value

    cdef TBranch* e1CBIDLoose_branch
    cdef float e1CBIDLoose_value

    cdef TBranch* e1CBIDMedium_branch
    cdef float e1CBIDMedium_value

    cdef TBranch* e1CBIDTight_branch
    cdef float e1CBIDTight_value

    cdef TBranch* e1CBIDVeto_branch
    cdef float e1CBIDVeto_value

    cdef TBranch* e1Charge_branch
    cdef float e1Charge_value

    cdef TBranch* e1ChargeIdLoose_branch
    cdef float e1ChargeIdLoose_value

    cdef TBranch* e1ChargeIdMed_branch
    cdef float e1ChargeIdMed_value

    cdef TBranch* e1ChargeIdTight_branch
    cdef float e1ChargeIdTight_value

    cdef TBranch* e1ComesFromHiggs_branch
    cdef float e1ComesFromHiggs_value

    cdef TBranch* e1DPhiToPfMet_type1_branch
    cdef float e1DPhiToPfMet_type1_value

    cdef TBranch* e1E1x5_branch
    cdef float e1E1x5_value

    cdef TBranch* e1E2x5Max_branch
    cdef float e1E2x5Max_value

    cdef TBranch* e1E5x5_branch
    cdef float e1E5x5_value

    cdef TBranch* e1EcalIsoDR03_branch
    cdef float e1EcalIsoDR03_value

    cdef TBranch* e1EffectiveAreaFall17_branch
    cdef float e1EffectiveAreaFall17_value

    cdef TBranch* e1EnergyError_branch
    cdef float e1EnergyError_value

    cdef TBranch* e1Eta_branch
    cdef float e1Eta_value

    cdef TBranch* e1GenCharge_branch
    cdef float e1GenCharge_value

    cdef TBranch* e1GenDirectPromptTauDecay_branch
    cdef float e1GenDirectPromptTauDecay_value

    cdef TBranch* e1GenEnergy_branch
    cdef float e1GenEnergy_value

    cdef TBranch* e1GenEta_branch
    cdef float e1GenEta_value

    cdef TBranch* e1GenIsPrompt_branch
    cdef float e1GenIsPrompt_value

    cdef TBranch* e1GenMotherPdgId_branch
    cdef float e1GenMotherPdgId_value

    cdef TBranch* e1GenParticle_branch
    cdef float e1GenParticle_value

    cdef TBranch* e1GenPdgId_branch
    cdef float e1GenPdgId_value

    cdef TBranch* e1GenPhi_branch
    cdef float e1GenPhi_value

    cdef TBranch* e1GenPrompt_branch
    cdef float e1GenPrompt_value

    cdef TBranch* e1GenPromptTauDecay_branch
    cdef float e1GenPromptTauDecay_value

    cdef TBranch* e1GenPt_branch
    cdef float e1GenPt_value

    cdef TBranch* e1GenTauDecay_branch
    cdef float e1GenTauDecay_value

    cdef TBranch* e1GenVZ_branch
    cdef float e1GenVZ_value

    cdef TBranch* e1GenVtxPVMatch_branch
    cdef float e1GenVtxPVMatch_value

    cdef TBranch* e1HadronicDepth1OverEm_branch
    cdef float e1HadronicDepth1OverEm_value

    cdef TBranch* e1HadronicDepth2OverEm_branch
    cdef float e1HadronicDepth2OverEm_value

    cdef TBranch* e1HadronicOverEM_branch
    cdef float e1HadronicOverEM_value

    cdef TBranch* e1HcalIsoDR03_branch
    cdef float e1HcalIsoDR03_value

    cdef TBranch* e1IP3D_branch
    cdef float e1IP3D_value

    cdef TBranch* e1IP3DErr_branch
    cdef float e1IP3DErr_value

    cdef TBranch* e1IsoDB03_branch
    cdef float e1IsoDB03_value

    cdef TBranch* e1JetArea_branch
    cdef float e1JetArea_value

    cdef TBranch* e1JetBtag_branch
    cdef float e1JetBtag_value

    cdef TBranch* e1JetDR_branch
    cdef float e1JetDR_value

    cdef TBranch* e1JetEtaEtaMoment_branch
    cdef float e1JetEtaEtaMoment_value

    cdef TBranch* e1JetEtaPhiMoment_branch
    cdef float e1JetEtaPhiMoment_value

    cdef TBranch* e1JetEtaPhiSpread_branch
    cdef float e1JetEtaPhiSpread_value

    cdef TBranch* e1JetHadronFlavour_branch
    cdef float e1JetHadronFlavour_value

    cdef TBranch* e1JetPFCISVBtag_branch
    cdef float e1JetPFCISVBtag_value

    cdef TBranch* e1JetPartonFlavour_branch
    cdef float e1JetPartonFlavour_value

    cdef TBranch* e1JetPhiPhiMoment_branch
    cdef float e1JetPhiPhiMoment_value

    cdef TBranch* e1JetPt_branch
    cdef float e1JetPt_value

    cdef TBranch* e1LowestMll_branch
    cdef float e1LowestMll_value

    cdef TBranch* e1MVAIsoLoose_branch
    cdef float e1MVAIsoLoose_value

    cdef TBranch* e1MVAIsoWP80_branch
    cdef float e1MVAIsoWP80_value

    cdef TBranch* e1MVAIsoWP90_branch
    cdef float e1MVAIsoWP90_value

    cdef TBranch* e1MVANoisoLoose_branch
    cdef float e1MVANoisoLoose_value

    cdef TBranch* e1MVANoisoWP80_branch
    cdef float e1MVANoisoWP80_value

    cdef TBranch* e1MVANoisoWP90_branch
    cdef float e1MVANoisoWP90_value

    cdef TBranch* e1Mass_branch
    cdef float e1Mass_value

    cdef TBranch* e1MatchesEle24Tau30Filter_branch
    cdef float e1MatchesEle24Tau30Filter_value

    cdef TBranch* e1MatchesEle24Tau30Path_branch
    cdef float e1MatchesEle24Tau30Path_value

    cdef TBranch* e1MatchesEle27Filter_branch
    cdef float e1MatchesEle27Filter_value

    cdef TBranch* e1MatchesEle27Path_branch
    cdef float e1MatchesEle27Path_value

    cdef TBranch* e1MatchesEle32Filter_branch
    cdef float e1MatchesEle32Filter_value

    cdef TBranch* e1MatchesEle32Path_branch
    cdef float e1MatchesEle32Path_value

    cdef TBranch* e1MatchesEle35Filter_branch
    cdef float e1MatchesEle35Filter_value

    cdef TBranch* e1MatchesEle35Path_branch
    cdef float e1MatchesEle35Path_value

    cdef TBranch* e1MissingHits_branch
    cdef float e1MissingHits_value

    cdef TBranch* e1MtToPfMet_type1_branch
    cdef float e1MtToPfMet_type1_value

    cdef TBranch* e1NearMuonVeto_branch
    cdef float e1NearMuonVeto_value

    cdef TBranch* e1NearestMuonDR_branch
    cdef float e1NearestMuonDR_value

    cdef TBranch* e1NearestZMass_branch
    cdef float e1NearestZMass_value

    cdef TBranch* e1PFChargedIso_branch
    cdef float e1PFChargedIso_value

    cdef TBranch* e1PFNeutralIso_branch
    cdef float e1PFNeutralIso_value

    cdef TBranch* e1PFPUChargedIso_branch
    cdef float e1PFPUChargedIso_value

    cdef TBranch* e1PFPhotonIso_branch
    cdef float e1PFPhotonIso_value

    cdef TBranch* e1PVDXY_branch
    cdef float e1PVDXY_value

    cdef TBranch* e1PVDZ_branch
    cdef float e1PVDZ_value

    cdef TBranch* e1PassesConversionVeto_branch
    cdef float e1PassesConversionVeto_value

    cdef TBranch* e1Phi_branch
    cdef float e1Phi_value

    cdef TBranch* e1Pt_branch
    cdef float e1Pt_value

    cdef TBranch* e1RelIso_branch
    cdef float e1RelIso_value

    cdef TBranch* e1RelPFIsoDB_branch
    cdef float e1RelPFIsoDB_value

    cdef TBranch* e1RelPFIsoRho_branch
    cdef float e1RelPFIsoRho_value

    cdef TBranch* e1Rho_branch
    cdef float e1Rho_value

    cdef TBranch* e1SCEnergy_branch
    cdef float e1SCEnergy_value

    cdef TBranch* e1SCEta_branch
    cdef float e1SCEta_value

    cdef TBranch* e1SCEtaWidth_branch
    cdef float e1SCEtaWidth_value

    cdef TBranch* e1SCPhi_branch
    cdef float e1SCPhi_value

    cdef TBranch* e1SCPhiWidth_branch
    cdef float e1SCPhiWidth_value

    cdef TBranch* e1SCPreshowerEnergy_branch
    cdef float e1SCPreshowerEnergy_value

    cdef TBranch* e1SCRawEnergy_branch
    cdef float e1SCRawEnergy_value

    cdef TBranch* e1SIP2D_branch
    cdef float e1SIP2D_value

    cdef TBranch* e1SIP3D_branch
    cdef float e1SIP3D_value

    cdef TBranch* e1SigmaIEtaIEta_branch
    cdef float e1SigmaIEtaIEta_value

    cdef TBranch* e1TrkIsoDR03_branch
    cdef float e1TrkIsoDR03_value

    cdef TBranch* e1VZ_branch
    cdef float e1VZ_value

    cdef TBranch* e1ZTTGenMatching_branch
    cdef float e1ZTTGenMatching_value

    cdef TBranch* e1_e2_CosThetaStar_branch
    cdef float e1_e2_CosThetaStar_value

    cdef TBranch* e1_e2_DPhi_branch
    cdef float e1_e2_DPhi_value

    cdef TBranch* e1_e2_DR_branch
    cdef float e1_e2_DR_value

    cdef TBranch* e1_e2_Eta_branch
    cdef float e1_e2_Eta_value

    cdef TBranch* e1_e2_Mass_branch
    cdef float e1_e2_Mass_value

    cdef TBranch* e1_e2_Mt_branch
    cdef float e1_e2_Mt_value

    cdef TBranch* e1_e2_PZeta_branch
    cdef float e1_e2_PZeta_value

    cdef TBranch* e1_e2_PZetaVis_branch
    cdef float e1_e2_PZetaVis_value

    cdef TBranch* e1_e2_Phi_branch
    cdef float e1_e2_Phi_value

    cdef TBranch* e1_e2_Pt_branch
    cdef float e1_e2_Pt_value

    cdef TBranch* e1_e2_SS_branch
    cdef float e1_e2_SS_value

    cdef TBranch* e1_e2_collinearmass_branch
    cdef float e1_e2_collinearmass_value

    cdef TBranch* e1_e2_doubleL1IsoTauMatch_branch
    cdef float e1_e2_doubleL1IsoTauMatch_value

    cdef TBranch* e1deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e1deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e1deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e1deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e1eSuperClusterOverP_branch
    cdef float e1eSuperClusterOverP_value

    cdef TBranch* e1ecalEnergy_branch
    cdef float e1ecalEnergy_value

    cdef TBranch* e1fBrem_branch
    cdef float e1fBrem_value

    cdef TBranch* e1trackMomentumAtVtxP_branch
    cdef float e1trackMomentumAtVtxP_value

    cdef TBranch* e2CBIDLoose_branch
    cdef float e2CBIDLoose_value

    cdef TBranch* e2CBIDMedium_branch
    cdef float e2CBIDMedium_value

    cdef TBranch* e2CBIDTight_branch
    cdef float e2CBIDTight_value

    cdef TBranch* e2CBIDVeto_branch
    cdef float e2CBIDVeto_value

    cdef TBranch* e2Charge_branch
    cdef float e2Charge_value

    cdef TBranch* e2ChargeIdLoose_branch
    cdef float e2ChargeIdLoose_value

    cdef TBranch* e2ChargeIdMed_branch
    cdef float e2ChargeIdMed_value

    cdef TBranch* e2ChargeIdTight_branch
    cdef float e2ChargeIdTight_value

    cdef TBranch* e2ComesFromHiggs_branch
    cdef float e2ComesFromHiggs_value

    cdef TBranch* e2DPhiToPfMet_type1_branch
    cdef float e2DPhiToPfMet_type1_value

    cdef TBranch* e2E1x5_branch
    cdef float e2E1x5_value

    cdef TBranch* e2E2x5Max_branch
    cdef float e2E2x5Max_value

    cdef TBranch* e2E5x5_branch
    cdef float e2E5x5_value

    cdef TBranch* e2EcalIsoDR03_branch
    cdef float e2EcalIsoDR03_value

    cdef TBranch* e2EffectiveAreaFall17_branch
    cdef float e2EffectiveAreaFall17_value

    cdef TBranch* e2EnergyError_branch
    cdef float e2EnergyError_value

    cdef TBranch* e2Eta_branch
    cdef float e2Eta_value

    cdef TBranch* e2GenCharge_branch
    cdef float e2GenCharge_value

    cdef TBranch* e2GenDirectPromptTauDecay_branch
    cdef float e2GenDirectPromptTauDecay_value

    cdef TBranch* e2GenEnergy_branch
    cdef float e2GenEnergy_value

    cdef TBranch* e2GenEta_branch
    cdef float e2GenEta_value

    cdef TBranch* e2GenIsPrompt_branch
    cdef float e2GenIsPrompt_value

    cdef TBranch* e2GenMotherPdgId_branch
    cdef float e2GenMotherPdgId_value

    cdef TBranch* e2GenParticle_branch
    cdef float e2GenParticle_value

    cdef TBranch* e2GenPdgId_branch
    cdef float e2GenPdgId_value

    cdef TBranch* e2GenPhi_branch
    cdef float e2GenPhi_value

    cdef TBranch* e2GenPrompt_branch
    cdef float e2GenPrompt_value

    cdef TBranch* e2GenPromptTauDecay_branch
    cdef float e2GenPromptTauDecay_value

    cdef TBranch* e2GenPt_branch
    cdef float e2GenPt_value

    cdef TBranch* e2GenTauDecay_branch
    cdef float e2GenTauDecay_value

    cdef TBranch* e2GenVZ_branch
    cdef float e2GenVZ_value

    cdef TBranch* e2GenVtxPVMatch_branch
    cdef float e2GenVtxPVMatch_value

    cdef TBranch* e2HadronicDepth1OverEm_branch
    cdef float e2HadronicDepth1OverEm_value

    cdef TBranch* e2HadronicDepth2OverEm_branch
    cdef float e2HadronicDepth2OverEm_value

    cdef TBranch* e2HadronicOverEM_branch
    cdef float e2HadronicOverEM_value

    cdef TBranch* e2HcalIsoDR03_branch
    cdef float e2HcalIsoDR03_value

    cdef TBranch* e2IP3D_branch
    cdef float e2IP3D_value

    cdef TBranch* e2IP3DErr_branch
    cdef float e2IP3DErr_value

    cdef TBranch* e2IsoDB03_branch
    cdef float e2IsoDB03_value

    cdef TBranch* e2JetArea_branch
    cdef float e2JetArea_value

    cdef TBranch* e2JetBtag_branch
    cdef float e2JetBtag_value

    cdef TBranch* e2JetDR_branch
    cdef float e2JetDR_value

    cdef TBranch* e2JetEtaEtaMoment_branch
    cdef float e2JetEtaEtaMoment_value

    cdef TBranch* e2JetEtaPhiMoment_branch
    cdef float e2JetEtaPhiMoment_value

    cdef TBranch* e2JetEtaPhiSpread_branch
    cdef float e2JetEtaPhiSpread_value

    cdef TBranch* e2JetHadronFlavour_branch
    cdef float e2JetHadronFlavour_value

    cdef TBranch* e2JetPFCISVBtag_branch
    cdef float e2JetPFCISVBtag_value

    cdef TBranch* e2JetPartonFlavour_branch
    cdef float e2JetPartonFlavour_value

    cdef TBranch* e2JetPhiPhiMoment_branch
    cdef float e2JetPhiPhiMoment_value

    cdef TBranch* e2JetPt_branch
    cdef float e2JetPt_value

    cdef TBranch* e2LowestMll_branch
    cdef float e2LowestMll_value

    cdef TBranch* e2MVAIsoLoose_branch
    cdef float e2MVAIsoLoose_value

    cdef TBranch* e2MVAIsoWP80_branch
    cdef float e2MVAIsoWP80_value

    cdef TBranch* e2MVAIsoWP90_branch
    cdef float e2MVAIsoWP90_value

    cdef TBranch* e2MVANoisoLoose_branch
    cdef float e2MVANoisoLoose_value

    cdef TBranch* e2MVANoisoWP80_branch
    cdef float e2MVANoisoWP80_value

    cdef TBranch* e2MVANoisoWP90_branch
    cdef float e2MVANoisoWP90_value

    cdef TBranch* e2Mass_branch
    cdef float e2Mass_value

    cdef TBranch* e2MatchesEle24Tau30Filter_branch
    cdef float e2MatchesEle24Tau30Filter_value

    cdef TBranch* e2MatchesEle24Tau30Path_branch
    cdef float e2MatchesEle24Tau30Path_value

    cdef TBranch* e2MatchesEle27Filter_branch
    cdef float e2MatchesEle27Filter_value

    cdef TBranch* e2MatchesEle27Path_branch
    cdef float e2MatchesEle27Path_value

    cdef TBranch* e2MatchesEle32Filter_branch
    cdef float e2MatchesEle32Filter_value

    cdef TBranch* e2MatchesEle32Path_branch
    cdef float e2MatchesEle32Path_value

    cdef TBranch* e2MatchesEle35Filter_branch
    cdef float e2MatchesEle35Filter_value

    cdef TBranch* e2MatchesEle35Path_branch
    cdef float e2MatchesEle35Path_value

    cdef TBranch* e2MissingHits_branch
    cdef float e2MissingHits_value

    cdef TBranch* e2MtToPfMet_type1_branch
    cdef float e2MtToPfMet_type1_value

    cdef TBranch* e2NearMuonVeto_branch
    cdef float e2NearMuonVeto_value

    cdef TBranch* e2NearestMuonDR_branch
    cdef float e2NearestMuonDR_value

    cdef TBranch* e2NearestZMass_branch
    cdef float e2NearestZMass_value

    cdef TBranch* e2PFChargedIso_branch
    cdef float e2PFChargedIso_value

    cdef TBranch* e2PFNeutralIso_branch
    cdef float e2PFNeutralIso_value

    cdef TBranch* e2PFPUChargedIso_branch
    cdef float e2PFPUChargedIso_value

    cdef TBranch* e2PFPhotonIso_branch
    cdef float e2PFPhotonIso_value

    cdef TBranch* e2PVDXY_branch
    cdef float e2PVDXY_value

    cdef TBranch* e2PVDZ_branch
    cdef float e2PVDZ_value

    cdef TBranch* e2PassesConversionVeto_branch
    cdef float e2PassesConversionVeto_value

    cdef TBranch* e2Phi_branch
    cdef float e2Phi_value

    cdef TBranch* e2Pt_branch
    cdef float e2Pt_value

    cdef TBranch* e2RelIso_branch
    cdef float e2RelIso_value

    cdef TBranch* e2RelPFIsoDB_branch
    cdef float e2RelPFIsoDB_value

    cdef TBranch* e2RelPFIsoRho_branch
    cdef float e2RelPFIsoRho_value

    cdef TBranch* e2Rho_branch
    cdef float e2Rho_value

    cdef TBranch* e2SCEnergy_branch
    cdef float e2SCEnergy_value

    cdef TBranch* e2SCEta_branch
    cdef float e2SCEta_value

    cdef TBranch* e2SCEtaWidth_branch
    cdef float e2SCEtaWidth_value

    cdef TBranch* e2SCPhi_branch
    cdef float e2SCPhi_value

    cdef TBranch* e2SCPhiWidth_branch
    cdef float e2SCPhiWidth_value

    cdef TBranch* e2SCPreshowerEnergy_branch
    cdef float e2SCPreshowerEnergy_value

    cdef TBranch* e2SCRawEnergy_branch
    cdef float e2SCRawEnergy_value

    cdef TBranch* e2SIP2D_branch
    cdef float e2SIP2D_value

    cdef TBranch* e2SIP3D_branch
    cdef float e2SIP3D_value

    cdef TBranch* e2SigmaIEtaIEta_branch
    cdef float e2SigmaIEtaIEta_value

    cdef TBranch* e2TrkIsoDR03_branch
    cdef float e2TrkIsoDR03_value

    cdef TBranch* e2VZ_branch
    cdef float e2VZ_value

    cdef TBranch* e2ZTTGenMatching_branch
    cdef float e2ZTTGenMatching_value

    cdef TBranch* e2_e1_collinearmass_branch
    cdef float e2_e1_collinearmass_value

    cdef TBranch* e2deltaEtaSuperClusterTrackAtVtx_branch
    cdef float e2deltaEtaSuperClusterTrackAtVtx_value

    cdef TBranch* e2deltaPhiSuperClusterTrackAtVtx_branch
    cdef float e2deltaPhiSuperClusterTrackAtVtx_value

    cdef TBranch* e2eSuperClusterOverP_branch
    cdef float e2eSuperClusterOverP_value

    cdef TBranch* e2ecalEnergy_branch
    cdef float e2ecalEnergy_value

    cdef TBranch* e2fBrem_branch
    cdef float e2fBrem_value

    cdef TBranch* e2trackMomentumAtVtxP_branch
    cdef float e2trackMomentumAtVtxP_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

    cdef TBranch* eVetoZTTp001dxyzR0_branch
    cdef float eVetoZTTp001dxyzR0_value

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

    cdef TBranch* jb1csv_branch
    cdef float jb1csv_value

    cdef TBranch* jb1csvWoNoisyJets_branch
    cdef float jb1csvWoNoisyJets_value

    cdef TBranch* jb1eta_branch
    cdef float jb1eta_value

    cdef TBranch* jb1etaWoNoisyJets_branch
    cdef float jb1etaWoNoisyJets_value

    cdef TBranch* jb1hadronflavor_branch
    cdef float jb1hadronflavor_value

    cdef TBranch* jb1hadronflavorWoNoisyJets_branch
    cdef float jb1hadronflavorWoNoisyJets_value

    cdef TBranch* jb1phi_branch
    cdef float jb1phi_value

    cdef TBranch* jb1phiWoNoisyJets_branch
    cdef float jb1phiWoNoisyJets_value

    cdef TBranch* jb1pt_branch
    cdef float jb1pt_value

    cdef TBranch* jb1ptWoNoisyJets_branch
    cdef float jb1ptWoNoisyJets_value

    cdef TBranch* jb2csv_branch
    cdef float jb2csv_value

    cdef TBranch* jb2csvWoNoisyJets_branch
    cdef float jb2csvWoNoisyJets_value

    cdef TBranch* jb2eta_branch
    cdef float jb2eta_value

    cdef TBranch* jb2etaWoNoisyJets_branch
    cdef float jb2etaWoNoisyJets_value

    cdef TBranch* jb2hadronflavor_branch
    cdef float jb2hadronflavor_value

    cdef TBranch* jb2hadronflavorWoNoisyJets_branch
    cdef float jb2hadronflavorWoNoisyJets_value

    cdef TBranch* jb2phi_branch
    cdef float jb2phi_value

    cdef TBranch* jb2phiWoNoisyJets_branch
    cdef float jb2phiWoNoisyJets_value

    cdef TBranch* jb2pt_branch
    cdef float jb2pt_value

    cdef TBranch* jb2ptWoNoisyJets_branch
    cdef float jb2ptWoNoisyJets_value

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

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapDown_branch
    cdef float jetVeto30_JetAbsoluteFlavMapDown_value

    cdef TBranch* jetVeto30_JetAbsoluteFlavMapUp_branch
    cdef float jetVeto30_JetAbsoluteFlavMapUp_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasDown_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasDown_value

    cdef TBranch* jetVeto30_JetAbsoluteMPFBiasUp_branch
    cdef float jetVeto30_JetAbsoluteMPFBiasUp_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleDown_branch
    cdef float jetVeto30_JetAbsoluteScaleDown_value

    cdef TBranch* jetVeto30_JetAbsoluteScaleUp_branch
    cdef float jetVeto30_JetAbsoluteScaleUp_value

    cdef TBranch* jetVeto30_JetAbsoluteStatDown_branch
    cdef float jetVeto30_JetAbsoluteStatDown_value

    cdef TBranch* jetVeto30_JetAbsoluteStatUp_branch
    cdef float jetVeto30_JetAbsoluteStatUp_value

    cdef TBranch* jetVeto30_JetClosureDown_branch
    cdef float jetVeto30_JetClosureDown_value

    cdef TBranch* jetVeto30_JetClosureUp_branch
    cdef float jetVeto30_JetClosureUp_value

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* jetVeto30_JetEta0to3Down_branch
    cdef float jetVeto30_JetEta0to3Down_value

    cdef TBranch* jetVeto30_JetEta0to3Up_branch
    cdef float jetVeto30_JetEta0to3Up_value

    cdef TBranch* jetVeto30_JetEta0to5Down_branch
    cdef float jetVeto30_JetEta0to5Down_value

    cdef TBranch* jetVeto30_JetEta0to5Up_branch
    cdef float jetVeto30_JetEta0to5Up_value

    cdef TBranch* jetVeto30_JetEta3to5Down_branch
    cdef float jetVeto30_JetEta3to5Down_value

    cdef TBranch* jetVeto30_JetEta3to5Up_branch
    cdef float jetVeto30_JetEta3to5Up_value

    cdef TBranch* jetVeto30_JetFlavorQCDDown_branch
    cdef float jetVeto30_JetFlavorQCDDown_value

    cdef TBranch* jetVeto30_JetFlavorQCDUp_branch
    cdef float jetVeto30_JetFlavorQCDUp_value

    cdef TBranch* jetVeto30_JetFragmentationDown_branch
    cdef float jetVeto30_JetFragmentationDown_value

    cdef TBranch* jetVeto30_JetFragmentationUp_branch
    cdef float jetVeto30_JetFragmentationUp_value

    cdef TBranch* jetVeto30_JetPileUpDataMCDown_branch
    cdef float jetVeto30_JetPileUpDataMCDown_value

    cdef TBranch* jetVeto30_JetPileUpDataMCUp_branch
    cdef float jetVeto30_JetPileUpDataMCUp_value

    cdef TBranch* jetVeto30_JetPileUpPtBBDown_branch
    cdef float jetVeto30_JetPileUpPtBBDown_value

    cdef TBranch* jetVeto30_JetPileUpPtBBUp_branch
    cdef float jetVeto30_JetPileUpPtBBUp_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Down_branch
    cdef float jetVeto30_JetPileUpPtEC1Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC1Up_branch
    cdef float jetVeto30_JetPileUpPtEC1Up_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Down_branch
    cdef float jetVeto30_JetPileUpPtEC2Down_value

    cdef TBranch* jetVeto30_JetPileUpPtEC2Up_branch
    cdef float jetVeto30_JetPileUpPtEC2Up_value

    cdef TBranch* jetVeto30_JetPileUpPtHFDown_branch
    cdef float jetVeto30_JetPileUpPtHFDown_value

    cdef TBranch* jetVeto30_JetPileUpPtHFUp_branch
    cdef float jetVeto30_JetPileUpPtHFUp_value

    cdef TBranch* jetVeto30_JetPileUpPtRefDown_branch
    cdef float jetVeto30_JetPileUpPtRefDown_value

    cdef TBranch* jetVeto30_JetPileUpPtRefUp_branch
    cdef float jetVeto30_JetPileUpPtRefUp_value

    cdef TBranch* jetVeto30_JetRelativeBalDown_branch
    cdef float jetVeto30_JetRelativeBalDown_value

    cdef TBranch* jetVeto30_JetRelativeBalUp_branch
    cdef float jetVeto30_JetRelativeBalUp_value

    cdef TBranch* jetVeto30_JetRelativeFSRDown_branch
    cdef float jetVeto30_JetRelativeFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeFSRUp_branch
    cdef float jetVeto30_JetRelativeFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Down_branch
    cdef float jetVeto30_JetRelativeJEREC1Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC1Up_branch
    cdef float jetVeto30_JetRelativeJEREC1Up_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Down_branch
    cdef float jetVeto30_JetRelativeJEREC2Down_value

    cdef TBranch* jetVeto30_JetRelativeJEREC2Up_branch
    cdef float jetVeto30_JetRelativeJEREC2Up_value

    cdef TBranch* jetVeto30_JetRelativeJERHFDown_branch
    cdef float jetVeto30_JetRelativeJERHFDown_value

    cdef TBranch* jetVeto30_JetRelativeJERHFUp_branch
    cdef float jetVeto30_JetRelativeJERHFUp_value

    cdef TBranch* jetVeto30_JetRelativePtBBDown_branch
    cdef float jetVeto30_JetRelativePtBBDown_value

    cdef TBranch* jetVeto30_JetRelativePtBBUp_branch
    cdef float jetVeto30_JetRelativePtBBUp_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Down_branch
    cdef float jetVeto30_JetRelativePtEC1Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC1Up_branch
    cdef float jetVeto30_JetRelativePtEC1Up_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Down_branch
    cdef float jetVeto30_JetRelativePtEC2Down_value

    cdef TBranch* jetVeto30_JetRelativePtEC2Up_branch
    cdef float jetVeto30_JetRelativePtEC2Up_value

    cdef TBranch* jetVeto30_JetRelativePtHFDown_branch
    cdef float jetVeto30_JetRelativePtHFDown_value

    cdef TBranch* jetVeto30_JetRelativePtHFUp_branch
    cdef float jetVeto30_JetRelativePtHFUp_value

    cdef TBranch* jetVeto30_JetRelativeSampleDown_branch
    cdef float jetVeto30_JetRelativeSampleDown_value

    cdef TBranch* jetVeto30_JetRelativeSampleUp_branch
    cdef float jetVeto30_JetRelativeSampleUp_value

    cdef TBranch* jetVeto30_JetRelativeStatECDown_branch
    cdef float jetVeto30_JetRelativeStatECDown_value

    cdef TBranch* jetVeto30_JetRelativeStatECUp_branch
    cdef float jetVeto30_JetRelativeStatECUp_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRDown_branch
    cdef float jetVeto30_JetRelativeStatFSRDown_value

    cdef TBranch* jetVeto30_JetRelativeStatFSRUp_branch
    cdef float jetVeto30_JetRelativeStatFSRUp_value

    cdef TBranch* jetVeto30_JetRelativeStatHFDown_branch
    cdef float jetVeto30_JetRelativeStatHFDown_value

    cdef TBranch* jetVeto30_JetRelativeStatHFUp_branch
    cdef float jetVeto30_JetRelativeStatHFUp_value

    cdef TBranch* jetVeto30_JetSinglePionECALDown_branch
    cdef float jetVeto30_JetSinglePionECALDown_value

    cdef TBranch* jetVeto30_JetSinglePionECALUp_branch
    cdef float jetVeto30_JetSinglePionECALUp_value

    cdef TBranch* jetVeto30_JetSinglePionHCALDown_branch
    cdef float jetVeto30_JetSinglePionHCALDown_value

    cdef TBranch* jetVeto30_JetSinglePionHCALUp_branch
    cdef float jetVeto30_JetSinglePionHCALUp_value

    cdef TBranch* jetVeto30_JetTimePtEtaDown_branch
    cdef float jetVeto30_JetTimePtEtaDown_value

    cdef TBranch* jetVeto30_JetTimePtEtaUp_branch
    cdef float jetVeto30_JetTimePtEtaUp_value

    cdef TBranch* jetVeto30_JetTotalDown_branch
    cdef float jetVeto30_JetTotalDown_value

    cdef TBranch* jetVeto30_JetTotalUp_branch
    cdef float jetVeto30_JetTotalUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov00_DESYlike_branch
    cdef float metcov00_DESYlike_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metcov01_DESYlike_branch
    cdef float metcov01_DESYlike_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov10_DESYlike_branch
    cdef float metcov10_DESYlike_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

    cdef TBranch* metcov11_DESYlike_branch
    cdef float metcov11_DESYlike_value

    cdef TBranch* mu12e23DZGroup_branch
    cdef float mu12e23DZGroup_value

    cdef TBranch* mu12e23DZPass_branch
    cdef float mu12e23DZPass_value

    cdef TBranch* mu12e23DZPrescale_branch
    cdef float mu12e23DZPrescale_value

    cdef TBranch* mu12e23Group_branch
    cdef float mu12e23Group_value

    cdef TBranch* mu12e23Pass_branch
    cdef float mu12e23Pass_value

    cdef TBranch* mu12e23Prescale_branch
    cdef float mu12e23Prescale_value

    cdef TBranch* mu23e12DZGroup_branch
    cdef float mu23e12DZGroup_value

    cdef TBranch* mu23e12DZPass_branch
    cdef float mu23e12DZPass_value

    cdef TBranch* mu23e12DZPrescale_branch
    cdef float mu23e12DZPrescale_value

    cdef TBranch* mu23e12Group_branch
    cdef float mu23e12Group_value

    cdef TBranch* mu23e12Pass_branch
    cdef float mu23e12Pass_value

    cdef TBranch* mu23e12Prescale_branch
    cdef float mu23e12Prescale_value

    cdef TBranch* mu8e23DZGroup_branch
    cdef float mu8e23DZGroup_value

    cdef TBranch* mu8e23DZPass_branch
    cdef float mu8e23DZPass_value

    cdef TBranch* mu8e23DZPrescale_branch
    cdef float mu8e23DZPrescale_value

    cdef TBranch* mu8e23Group_branch
    cdef float mu8e23Group_value

    cdef TBranch* mu8e23Pass_branch
    cdef float mu8e23Pass_value

    cdef TBranch* mu8e23Prescale_branch
    cdef float mu8e23Prescale_value

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

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

    cdef TBranch* tauVetoPt20Loose3HitsVtx_branch
    cdef float tauVetoPt20Loose3HitsVtx_value

    cdef TBranch* tauVetoPt20TightMVALTVtx_branch
    cdef float tauVetoPt20TightMVALTVtx_value

    cdef TBranch* topQuarkPt1_branch
    cdef float topQuarkPt1_value

    cdef TBranch* topQuarkPt2_branch
    cdef float topQuarkPt2_value

    cdef TBranch* tripleEGroup_branch
    cdef float tripleEGroup_value

    cdef TBranch* tripleEPass_branch
    cdef float tripleEPass_value

    cdef TBranch* tripleEPrescale_branch
    cdef float tripleEPrescale_value

    cdef TBranch* tripleMu12_10_5Group_branch
    cdef float tripleMu12_10_5Group_value

    cdef TBranch* tripleMu12_10_5Pass_branch
    cdef float tripleMu12_10_5Pass_value

    cdef TBranch* tripleMu12_10_5Prescale_branch
    cdef float tripleMu12_10_5Prescale_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_value

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

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch
    cdef float type1_pfMet_shiftedPt_AbsoluteFlavMapDown_value

    cdef TBranch* type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch
    cdef float type1_pfMet_shiftedPt_AbsoluteFlavMapUp_value

    cdef TBranch* type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch
    cdef float type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_value

    cdef TBranch* type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch
    cdef float type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_value

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

    cdef TBranch* vbfMass_JetAbsoluteFlavMapDown_branch
    cdef float vbfMass_JetAbsoluteFlavMapDown_value

    cdef TBranch* vbfMass_JetAbsoluteFlavMapUp_branch
    cdef float vbfMass_JetAbsoluteFlavMapUp_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasDown_branch
    cdef float vbfMass_JetAbsoluteMPFBiasDown_value

    cdef TBranch* vbfMass_JetAbsoluteMPFBiasUp_branch
    cdef float vbfMass_JetAbsoluteMPFBiasUp_value

    cdef TBranch* vbfMass_JetAbsoluteScaleDown_branch
    cdef float vbfMass_JetAbsoluteScaleDown_value

    cdef TBranch* vbfMass_JetAbsoluteScaleUp_branch
    cdef float vbfMass_JetAbsoluteScaleUp_value

    cdef TBranch* vbfMass_JetAbsoluteStatDown_branch
    cdef float vbfMass_JetAbsoluteStatDown_value

    cdef TBranch* vbfMass_JetAbsoluteStatUp_branch
    cdef float vbfMass_JetAbsoluteStatUp_value

    cdef TBranch* vbfMass_JetClosureDown_branch
    cdef float vbfMass_JetClosureDown_value

    cdef TBranch* vbfMass_JetClosureUp_branch
    cdef float vbfMass_JetClosureUp_value

    cdef TBranch* vbfMass_JetEta0to3Down_branch
    cdef float vbfMass_JetEta0to3Down_value

    cdef TBranch* vbfMass_JetEta0to3Up_branch
    cdef float vbfMass_JetEta0to3Up_value

    cdef TBranch* vbfMass_JetEta0to5Down_branch
    cdef float vbfMass_JetEta0to5Down_value

    cdef TBranch* vbfMass_JetEta0to5Up_branch
    cdef float vbfMass_JetEta0to5Up_value

    cdef TBranch* vbfMass_JetEta3to5Down_branch
    cdef float vbfMass_JetEta3to5Down_value

    cdef TBranch* vbfMass_JetEta3to5Up_branch
    cdef float vbfMass_JetEta3to5Up_value

    cdef TBranch* vbfMass_JetFlavorQCDDown_branch
    cdef float vbfMass_JetFlavorQCDDown_value

    cdef TBranch* vbfMass_JetFlavorQCDUp_branch
    cdef float vbfMass_JetFlavorQCDUp_value

    cdef TBranch* vbfMass_JetFragmentationDown_branch
    cdef float vbfMass_JetFragmentationDown_value

    cdef TBranch* vbfMass_JetFragmentationUp_branch
    cdef float vbfMass_JetFragmentationUp_value

    cdef TBranch* vbfMass_JetPileUpDataMCDown_branch
    cdef float vbfMass_JetPileUpDataMCDown_value

    cdef TBranch* vbfMass_JetPileUpDataMCUp_branch
    cdef float vbfMass_JetPileUpDataMCUp_value

    cdef TBranch* vbfMass_JetPileUpPtBBDown_branch
    cdef float vbfMass_JetPileUpPtBBDown_value

    cdef TBranch* vbfMass_JetPileUpPtBBUp_branch
    cdef float vbfMass_JetPileUpPtBBUp_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Down_branch
    cdef float vbfMass_JetPileUpPtEC1Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC1Up_branch
    cdef float vbfMass_JetPileUpPtEC1Up_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Down_branch
    cdef float vbfMass_JetPileUpPtEC2Down_value

    cdef TBranch* vbfMass_JetPileUpPtEC2Up_branch
    cdef float vbfMass_JetPileUpPtEC2Up_value

    cdef TBranch* vbfMass_JetPileUpPtHFDown_branch
    cdef float vbfMass_JetPileUpPtHFDown_value

    cdef TBranch* vbfMass_JetPileUpPtHFUp_branch
    cdef float vbfMass_JetPileUpPtHFUp_value

    cdef TBranch* vbfMass_JetPileUpPtRefDown_branch
    cdef float vbfMass_JetPileUpPtRefDown_value

    cdef TBranch* vbfMass_JetPileUpPtRefUp_branch
    cdef float vbfMass_JetPileUpPtRefUp_value

    cdef TBranch* vbfMass_JetRelativeBalDown_branch
    cdef float vbfMass_JetRelativeBalDown_value

    cdef TBranch* vbfMass_JetRelativeBalUp_branch
    cdef float vbfMass_JetRelativeBalUp_value

    cdef TBranch* vbfMass_JetRelativeFSRDown_branch
    cdef float vbfMass_JetRelativeFSRDown_value

    cdef TBranch* vbfMass_JetRelativeFSRUp_branch
    cdef float vbfMass_JetRelativeFSRUp_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Down_branch
    cdef float vbfMass_JetRelativeJEREC1Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC1Up_branch
    cdef float vbfMass_JetRelativeJEREC1Up_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Down_branch
    cdef float vbfMass_JetRelativeJEREC2Down_value

    cdef TBranch* vbfMass_JetRelativeJEREC2Up_branch
    cdef float vbfMass_JetRelativeJEREC2Up_value

    cdef TBranch* vbfMass_JetRelativeJERHFDown_branch
    cdef float vbfMass_JetRelativeJERHFDown_value

    cdef TBranch* vbfMass_JetRelativeJERHFUp_branch
    cdef float vbfMass_JetRelativeJERHFUp_value

    cdef TBranch* vbfMass_JetRelativePtBBDown_branch
    cdef float vbfMass_JetRelativePtBBDown_value

    cdef TBranch* vbfMass_JetRelativePtBBUp_branch
    cdef float vbfMass_JetRelativePtBBUp_value

    cdef TBranch* vbfMass_JetRelativePtEC1Down_branch
    cdef float vbfMass_JetRelativePtEC1Down_value

    cdef TBranch* vbfMass_JetRelativePtEC1Up_branch
    cdef float vbfMass_JetRelativePtEC1Up_value

    cdef TBranch* vbfMass_JetRelativePtEC2Down_branch
    cdef float vbfMass_JetRelativePtEC2Down_value

    cdef TBranch* vbfMass_JetRelativePtEC2Up_branch
    cdef float vbfMass_JetRelativePtEC2Up_value

    cdef TBranch* vbfMass_JetRelativePtHFDown_branch
    cdef float vbfMass_JetRelativePtHFDown_value

    cdef TBranch* vbfMass_JetRelativePtHFUp_branch
    cdef float vbfMass_JetRelativePtHFUp_value

    cdef TBranch* vbfMass_JetRelativeSampleDown_branch
    cdef float vbfMass_JetRelativeSampleDown_value

    cdef TBranch* vbfMass_JetRelativeSampleUp_branch
    cdef float vbfMass_JetRelativeSampleUp_value

    cdef TBranch* vbfMass_JetRelativeStatECDown_branch
    cdef float vbfMass_JetRelativeStatECDown_value

    cdef TBranch* vbfMass_JetRelativeStatECUp_branch
    cdef float vbfMass_JetRelativeStatECUp_value

    cdef TBranch* vbfMass_JetRelativeStatFSRDown_branch
    cdef float vbfMass_JetRelativeStatFSRDown_value

    cdef TBranch* vbfMass_JetRelativeStatFSRUp_branch
    cdef float vbfMass_JetRelativeStatFSRUp_value

    cdef TBranch* vbfMass_JetRelativeStatHFDown_branch
    cdef float vbfMass_JetRelativeStatHFDown_value

    cdef TBranch* vbfMass_JetRelativeStatHFUp_branch
    cdef float vbfMass_JetRelativeStatHFUp_value

    cdef TBranch* vbfMass_JetSinglePionECALDown_branch
    cdef float vbfMass_JetSinglePionECALDown_value

    cdef TBranch* vbfMass_JetSinglePionECALUp_branch
    cdef float vbfMass_JetSinglePionECALUp_value

    cdef TBranch* vbfMass_JetSinglePionHCALDown_branch
    cdef float vbfMass_JetSinglePionHCALDown_value

    cdef TBranch* vbfMass_JetSinglePionHCALUp_branch
    cdef float vbfMass_JetSinglePionHCALUp_value

    cdef TBranch* vbfMass_JetTimePtEtaDown_branch
    cdef float vbfMass_JetTimePtEtaDown_value

    cdef TBranch* vbfMass_JetTimePtEtaUp_branch
    cdef float vbfMass_JetTimePtEtaUp_value

    cdef TBranch* vbfMass_JetTotalDown_branch
    cdef float vbfMass_JetTotalDown_value

    cdef TBranch* vbfMass_JetTotalUp_branch
    cdef float vbfMass_JetTotalUp_value

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

        #print "making DoubleMediumTau35Group"
        self.DoubleMediumTau35Group_branch = the_tree.GetBranch("DoubleMediumTau35Group")
        #if not self.DoubleMediumTau35Group_branch and "DoubleMediumTau35Group" not in self.complained:
        if not self.DoubleMediumTau35Group_branch and "DoubleMediumTau35Group":
            warnings.warn( "EETree: Expected branch DoubleMediumTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Group")
        else:
            self.DoubleMediumTau35Group_branch.SetAddress(<void*>&self.DoubleMediumTau35Group_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "EETree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35Prescale"
        self.DoubleMediumTau35Prescale_branch = the_tree.GetBranch("DoubleMediumTau35Prescale")
        #if not self.DoubleMediumTau35Prescale_branch and "DoubleMediumTau35Prescale" not in self.complained:
        if not self.DoubleMediumTau35Prescale_branch and "DoubleMediumTau35Prescale":
            warnings.warn( "EETree: Expected branch DoubleMediumTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Prescale")
        else:
            self.DoubleMediumTau35Prescale_branch.SetAddress(<void*>&self.DoubleMediumTau35Prescale_value)

        #print "making DoubleMediumTau40Group"
        self.DoubleMediumTau40Group_branch = the_tree.GetBranch("DoubleMediumTau40Group")
        #if not self.DoubleMediumTau40Group_branch and "DoubleMediumTau40Group" not in self.complained:
        if not self.DoubleMediumTau40Group_branch and "DoubleMediumTau40Group":
            warnings.warn( "EETree: Expected branch DoubleMediumTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Group")
        else:
            self.DoubleMediumTau40Group_branch.SetAddress(<void*>&self.DoubleMediumTau40Group_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "EETree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40Prescale"
        self.DoubleMediumTau40Prescale_branch = the_tree.GetBranch("DoubleMediumTau40Prescale")
        #if not self.DoubleMediumTau40Prescale_branch and "DoubleMediumTau40Prescale" not in self.complained:
        if not self.DoubleMediumTau40Prescale_branch and "DoubleMediumTau40Prescale":
            warnings.warn( "EETree: Expected branch DoubleMediumTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Prescale")
        else:
            self.DoubleMediumTau40Prescale_branch.SetAddress(<void*>&self.DoubleMediumTau40Prescale_value)

        #print "making DoubleTightTau35Group"
        self.DoubleTightTau35Group_branch = the_tree.GetBranch("DoubleTightTau35Group")
        #if not self.DoubleTightTau35Group_branch and "DoubleTightTau35Group" not in self.complained:
        if not self.DoubleTightTau35Group_branch and "DoubleTightTau35Group":
            warnings.warn( "EETree: Expected branch DoubleTightTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Group")
        else:
            self.DoubleTightTau35Group_branch.SetAddress(<void*>&self.DoubleTightTau35Group_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "EETree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35Prescale"
        self.DoubleTightTau35Prescale_branch = the_tree.GetBranch("DoubleTightTau35Prescale")
        #if not self.DoubleTightTau35Prescale_branch and "DoubleTightTau35Prescale" not in self.complained:
        if not self.DoubleTightTau35Prescale_branch and "DoubleTightTau35Prescale":
            warnings.warn( "EETree: Expected branch DoubleTightTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Prescale")
        else:
            self.DoubleTightTau35Prescale_branch.SetAddress(<void*>&self.DoubleTightTau35Prescale_value)

        #print "making DoubleTightTau40Group"
        self.DoubleTightTau40Group_branch = the_tree.GetBranch("DoubleTightTau40Group")
        #if not self.DoubleTightTau40Group_branch and "DoubleTightTau40Group" not in self.complained:
        if not self.DoubleTightTau40Group_branch and "DoubleTightTau40Group":
            warnings.warn( "EETree: Expected branch DoubleTightTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Group")
        else:
            self.DoubleTightTau40Group_branch.SetAddress(<void*>&self.DoubleTightTau40Group_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "EETree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40Prescale"
        self.DoubleTightTau40Prescale_branch = the_tree.GetBranch("DoubleTightTau40Prescale")
        #if not self.DoubleTightTau40Prescale_branch and "DoubleTightTau40Prescale" not in self.complained:
        if not self.DoubleTightTau40Prescale_branch and "DoubleTightTau40Prescale":
            warnings.warn( "EETree: Expected branch DoubleTightTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Prescale")
        else:
            self.DoubleTightTau40Prescale_branch.SetAddress(<void*>&self.DoubleTightTau40Prescale_value)

        #print "making Ele24Tau30Group"
        self.Ele24Tau30Group_branch = the_tree.GetBranch("Ele24Tau30Group")
        #if not self.Ele24Tau30Group_branch and "Ele24Tau30Group" not in self.complained:
        if not self.Ele24Tau30Group_branch and "Ele24Tau30Group":
            warnings.warn( "EETree: Expected branch Ele24Tau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Group")
        else:
            self.Ele24Tau30Group_branch.SetAddress(<void*>&self.Ele24Tau30Group_value)

        #print "making Ele24Tau30Pass"
        self.Ele24Tau30Pass_branch = the_tree.GetBranch("Ele24Tau30Pass")
        #if not self.Ele24Tau30Pass_branch and "Ele24Tau30Pass" not in self.complained:
        if not self.Ele24Tau30Pass_branch and "Ele24Tau30Pass":
            warnings.warn( "EETree: Expected branch Ele24Tau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Pass")
        else:
            self.Ele24Tau30Pass_branch.SetAddress(<void*>&self.Ele24Tau30Pass_value)

        #print "making Ele24Tau30Prescale"
        self.Ele24Tau30Prescale_branch = the_tree.GetBranch("Ele24Tau30Prescale")
        #if not self.Ele24Tau30Prescale_branch and "Ele24Tau30Prescale" not in self.complained:
        if not self.Ele24Tau30Prescale_branch and "Ele24Tau30Prescale":
            warnings.warn( "EETree: Expected branch Ele24Tau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Prescale")
        else:
            self.Ele24Tau30Prescale_branch.SetAddress(<void*>&self.Ele24Tau30Prescale_value)

        #print "making Ele27WPTightGroup"
        self.Ele27WPTightGroup_branch = the_tree.GetBranch("Ele27WPTightGroup")
        #if not self.Ele27WPTightGroup_branch and "Ele27WPTightGroup" not in self.complained:
        if not self.Ele27WPTightGroup_branch and "Ele27WPTightGroup":
            warnings.warn( "EETree: Expected branch Ele27WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightGroup")
        else:
            self.Ele27WPTightGroup_branch.SetAddress(<void*>&self.Ele27WPTightGroup_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "EETree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele27WPTightPrescale"
        self.Ele27WPTightPrescale_branch = the_tree.GetBranch("Ele27WPTightPrescale")
        #if not self.Ele27WPTightPrescale_branch and "Ele27WPTightPrescale" not in self.complained:
        if not self.Ele27WPTightPrescale_branch and "Ele27WPTightPrescale":
            warnings.warn( "EETree: Expected branch Ele27WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPrescale")
        else:
            self.Ele27WPTightPrescale_branch.SetAddress(<void*>&self.Ele27WPTightPrescale_value)

        #print "making Ele32WPTightGroup"
        self.Ele32WPTightGroup_branch = the_tree.GetBranch("Ele32WPTightGroup")
        #if not self.Ele32WPTightGroup_branch and "Ele32WPTightGroup" not in self.complained:
        if not self.Ele32WPTightGroup_branch and "Ele32WPTightGroup":
            warnings.warn( "EETree: Expected branch Ele32WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightGroup")
        else:
            self.Ele32WPTightGroup_branch.SetAddress(<void*>&self.Ele32WPTightGroup_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "EETree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele32WPTightPrescale"
        self.Ele32WPTightPrescale_branch = the_tree.GetBranch("Ele32WPTightPrescale")
        #if not self.Ele32WPTightPrescale_branch and "Ele32WPTightPrescale" not in self.complained:
        if not self.Ele32WPTightPrescale_branch and "Ele32WPTightPrescale":
            warnings.warn( "EETree: Expected branch Ele32WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPrescale")
        else:
            self.Ele32WPTightPrescale_branch.SetAddress(<void*>&self.Ele32WPTightPrescale_value)

        #print "making Ele35WPTightGroup"
        self.Ele35WPTightGroup_branch = the_tree.GetBranch("Ele35WPTightGroup")
        #if not self.Ele35WPTightGroup_branch and "Ele35WPTightGroup" not in self.complained:
        if not self.Ele35WPTightGroup_branch and "Ele35WPTightGroup":
            warnings.warn( "EETree: Expected branch Ele35WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightGroup")
        else:
            self.Ele35WPTightGroup_branch.SetAddress(<void*>&self.Ele35WPTightGroup_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "EETree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele35WPTightPrescale"
        self.Ele35WPTightPrescale_branch = the_tree.GetBranch("Ele35WPTightPrescale")
        #if not self.Ele35WPTightPrescale_branch and "Ele35WPTightPrescale" not in self.complained:
        if not self.Ele35WPTightPrescale_branch and "Ele35WPTightPrescale":
            warnings.warn( "EETree: Expected branch Ele35WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPrescale")
        else:
            self.Ele35WPTightPrescale_branch.SetAddress(<void*>&self.Ele35WPTightPrescale_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "EETree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EETree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EETree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EETree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EETree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EETree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EETree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EETree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EETree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EETree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EETree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "EETree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EETree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EETree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EETree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EETree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu20Group"
        self.IsoMu20Group_branch = the_tree.GetBranch("IsoMu20Group")
        #if not self.IsoMu20Group_branch and "IsoMu20Group" not in self.complained:
        if not self.IsoMu20Group_branch and "IsoMu20Group":
            warnings.warn( "EETree: Expected branch IsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Group")
        else:
            self.IsoMu20Group_branch.SetAddress(<void*>&self.IsoMu20Group_value)

        #print "making IsoMu20Pass"
        self.IsoMu20Pass_branch = the_tree.GetBranch("IsoMu20Pass")
        #if not self.IsoMu20Pass_branch and "IsoMu20Pass" not in self.complained:
        if not self.IsoMu20Pass_branch and "IsoMu20Pass":
            warnings.warn( "EETree: Expected branch IsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Pass")
        else:
            self.IsoMu20Pass_branch.SetAddress(<void*>&self.IsoMu20Pass_value)

        #print "making IsoMu20Prescale"
        self.IsoMu20Prescale_branch = the_tree.GetBranch("IsoMu20Prescale")
        #if not self.IsoMu20Prescale_branch and "IsoMu20Prescale" not in self.complained:
        if not self.IsoMu20Prescale_branch and "IsoMu20Prescale":
            warnings.warn( "EETree: Expected branch IsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Prescale")
        else:
            self.IsoMu20Prescale_branch.SetAddress(<void*>&self.IsoMu20Prescale_value)

        #print "making IsoMu24Group"
        self.IsoMu24Group_branch = the_tree.GetBranch("IsoMu24Group")
        #if not self.IsoMu24Group_branch and "IsoMu24Group" not in self.complained:
        if not self.IsoMu24Group_branch and "IsoMu24Group":
            warnings.warn( "EETree: Expected branch IsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Group")
        else:
            self.IsoMu24Group_branch.SetAddress(<void*>&self.IsoMu24Group_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "EETree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu24Prescale"
        self.IsoMu24Prescale_branch = the_tree.GetBranch("IsoMu24Prescale")
        #if not self.IsoMu24Prescale_branch and "IsoMu24Prescale" not in self.complained:
        if not self.IsoMu24Prescale_branch and "IsoMu24Prescale":
            warnings.warn( "EETree: Expected branch IsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Prescale")
        else:
            self.IsoMu24Prescale_branch.SetAddress(<void*>&self.IsoMu24Prescale_value)

        #print "making IsoMu24_eta2p1Group"
        self.IsoMu24_eta2p1Group_branch = the_tree.GetBranch("IsoMu24_eta2p1Group")
        #if not self.IsoMu24_eta2p1Group_branch and "IsoMu24_eta2p1Group" not in self.complained:
        if not self.IsoMu24_eta2p1Group_branch and "IsoMu24_eta2p1Group":
            warnings.warn( "EETree: Expected branch IsoMu24_eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Group")
        else:
            self.IsoMu24_eta2p1Group_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Group_value)

        #print "making IsoMu24_eta2p1Pass"
        self.IsoMu24_eta2p1Pass_branch = the_tree.GetBranch("IsoMu24_eta2p1Pass")
        #if not self.IsoMu24_eta2p1Pass_branch and "IsoMu24_eta2p1Pass" not in self.complained:
        if not self.IsoMu24_eta2p1Pass_branch and "IsoMu24_eta2p1Pass":
            warnings.warn( "EETree: Expected branch IsoMu24_eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Pass")
        else:
            self.IsoMu24_eta2p1Pass_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Pass_value)

        #print "making IsoMu24_eta2p1Prescale"
        self.IsoMu24_eta2p1Prescale_branch = the_tree.GetBranch("IsoMu24_eta2p1Prescale")
        #if not self.IsoMu24_eta2p1Prescale_branch and "IsoMu24_eta2p1Prescale" not in self.complained:
        if not self.IsoMu24_eta2p1Prescale_branch and "IsoMu24_eta2p1Prescale":
            warnings.warn( "EETree: Expected branch IsoMu24_eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Prescale")
        else:
            self.IsoMu24_eta2p1Prescale_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Prescale_value)

        #print "making IsoMu27Group"
        self.IsoMu27Group_branch = the_tree.GetBranch("IsoMu27Group")
        #if not self.IsoMu27Group_branch and "IsoMu27Group" not in self.complained:
        if not self.IsoMu27Group_branch and "IsoMu27Group":
            warnings.warn( "EETree: Expected branch IsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Group")
        else:
            self.IsoMu27Group_branch.SetAddress(<void*>&self.IsoMu27Group_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "EETree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making IsoMu27Prescale"
        self.IsoMu27Prescale_branch = the_tree.GetBranch("IsoMu27Prescale")
        #if not self.IsoMu27Prescale_branch and "IsoMu27Prescale" not in self.complained:
        if not self.IsoMu27Prescale_branch and "IsoMu27Prescale":
            warnings.warn( "EETree: Expected branch IsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Prescale")
        else:
            self.IsoMu27Prescale_branch.SetAddress(<void*>&self.IsoMu27Prescale_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EETree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EETree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EETree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EETree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EETree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EETree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EETree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EETree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20Tau27Group"
        self.Mu20Tau27Group_branch = the_tree.GetBranch("Mu20Tau27Group")
        #if not self.Mu20Tau27Group_branch and "Mu20Tau27Group" not in self.complained:
        if not self.Mu20Tau27Group_branch and "Mu20Tau27Group":
            warnings.warn( "EETree: Expected branch Mu20Tau27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Group")
        else:
            self.Mu20Tau27Group_branch.SetAddress(<void*>&self.Mu20Tau27Group_value)

        #print "making Mu20Tau27Pass"
        self.Mu20Tau27Pass_branch = the_tree.GetBranch("Mu20Tau27Pass")
        #if not self.Mu20Tau27Pass_branch and "Mu20Tau27Pass" not in self.complained:
        if not self.Mu20Tau27Pass_branch and "Mu20Tau27Pass":
            warnings.warn( "EETree: Expected branch Mu20Tau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Pass")
        else:
            self.Mu20Tau27Pass_branch.SetAddress(<void*>&self.Mu20Tau27Pass_value)

        #print "making Mu20Tau27Prescale"
        self.Mu20Tau27Prescale_branch = the_tree.GetBranch("Mu20Tau27Prescale")
        #if not self.Mu20Tau27Prescale_branch and "Mu20Tau27Prescale" not in self.complained:
        if not self.Mu20Tau27Prescale_branch and "Mu20Tau27Prescale":
            warnings.warn( "EETree: Expected branch Mu20Tau27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Prescale")
        else:
            self.Mu20Tau27Prescale_branch.SetAddress(<void*>&self.Mu20Tau27Prescale_value)

        #print "making Mu50Group"
        self.Mu50Group_branch = the_tree.GetBranch("Mu50Group")
        #if not self.Mu50Group_branch and "Mu50Group" not in self.complained:
        if not self.Mu50Group_branch and "Mu50Group":
            warnings.warn( "EETree: Expected branch Mu50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Group")
        else:
            self.Mu50Group_branch.SetAddress(<void*>&self.Mu50Group_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "EETree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making Mu50Prescale"
        self.Mu50Prescale_branch = the_tree.GetBranch("Mu50Prescale")
        #if not self.Mu50Prescale_branch and "Mu50Prescale" not in self.complained:
        if not self.Mu50Prescale_branch and "Mu50Prescale":
            warnings.warn( "EETree: Expected branch Mu50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Prescale")
        else:
            self.Mu50Prescale_branch.SetAddress(<void*>&self.Mu50Prescale_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EETree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EETree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EETree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "EETree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "EETree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "EETree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "EETree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "EETree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "EETree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "EETree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "EETree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "EETree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "EETree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "EETree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "EETree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "EETree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "EETree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "EETree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20MediumWoNoisyJets"
        self.bjetCISVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetCISVVeto20MediumWoNoisyJets")
        #if not self.bjetCISVVeto20MediumWoNoisyJets_branch and "bjetCISVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetCISVVeto20MediumWoNoisyJets_branch and "bjetCISVVeto20MediumWoNoisyJets":
            warnings.warn( "EETree: Expected branch bjetCISVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20MediumWoNoisyJets")
        else:
            self.bjetCISVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetCISVVeto20MediumWoNoisyJets_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "EETree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "EETree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "EETree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "EETree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making bjetDeepCSVVeto20Loose"
        self.bjetDeepCSVVeto20Loose_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose")
        #if not self.bjetDeepCSVVeto20Loose_branch and "bjetDeepCSVVeto20Loose" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_branch and "bjetDeepCSVVeto20Loose":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose")
        else:
            self.bjetDeepCSVVeto20Loose_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20Tight"
        self.bjetDeepCSVVeto20Tight_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight")
        #if not self.bjetDeepCSVVeto20Tight_branch and "bjetDeepCSVVeto20Tight" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_branch and "bjetDeepCSVVeto20Tight":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight")
        else:
            self.bjetDeepCSVVeto20Tight_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_value)

        #print "making bjetDeepCSVVeto30Loose"
        self.bjetDeepCSVVeto30Loose_branch = the_tree.GetBranch("bjetDeepCSVVeto30Loose")
        #if not self.bjetDeepCSVVeto30Loose_branch and "bjetDeepCSVVeto30Loose" not in self.complained:
        if not self.bjetDeepCSVVeto30Loose_branch and "bjetDeepCSVVeto30Loose":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Loose")
        else:
            self.bjetDeepCSVVeto30Loose_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Loose_value)

        #print "making bjetDeepCSVVeto30Medium"
        self.bjetDeepCSVVeto30Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium")
        #if not self.bjetDeepCSVVeto30Medium_branch and "bjetDeepCSVVeto30Medium" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_branch and "bjetDeepCSVVeto30Medium":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium")
        else:
            self.bjetDeepCSVVeto30Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_value)

        #print "making bjetDeepCSVVeto30Tight"
        self.bjetDeepCSVVeto30Tight_branch = the_tree.GetBranch("bjetDeepCSVVeto30Tight")
        #if not self.bjetDeepCSVVeto30Tight_branch and "bjetDeepCSVVeto30Tight" not in self.complained:
        if not self.bjetDeepCSVVeto30Tight_branch and "bjetDeepCSVVeto30Tight":
            warnings.warn( "EETree: Expected branch bjetDeepCSVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Tight")
        else:
            self.bjetDeepCSVVeto30Tight_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EETree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EETree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EETree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "EETree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EETree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "EETree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleE_23_12_DZGroup"
        self.doubleE_23_12_DZGroup_branch = the_tree.GetBranch("doubleE_23_12_DZGroup")
        #if not self.doubleE_23_12_DZGroup_branch and "doubleE_23_12_DZGroup" not in self.complained:
        if not self.doubleE_23_12_DZGroup_branch and "doubleE_23_12_DZGroup":
            warnings.warn( "EETree: Expected branch doubleE_23_12_DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZGroup")
        else:
            self.doubleE_23_12_DZGroup_branch.SetAddress(<void*>&self.doubleE_23_12_DZGroup_value)

        #print "making doubleE_23_12_DZPass"
        self.doubleE_23_12_DZPass_branch = the_tree.GetBranch("doubleE_23_12_DZPass")
        #if not self.doubleE_23_12_DZPass_branch and "doubleE_23_12_DZPass" not in self.complained:
        if not self.doubleE_23_12_DZPass_branch and "doubleE_23_12_DZPass":
            warnings.warn( "EETree: Expected branch doubleE_23_12_DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZPass")
        else:
            self.doubleE_23_12_DZPass_branch.SetAddress(<void*>&self.doubleE_23_12_DZPass_value)

        #print "making doubleE_23_12_DZPrescale"
        self.doubleE_23_12_DZPrescale_branch = the_tree.GetBranch("doubleE_23_12_DZPrescale")
        #if not self.doubleE_23_12_DZPrescale_branch and "doubleE_23_12_DZPrescale" not in self.complained:
        if not self.doubleE_23_12_DZPrescale_branch and "doubleE_23_12_DZPrescale":
            warnings.warn( "EETree: Expected branch doubleE_23_12_DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZPrescale")
        else:
            self.doubleE_23_12_DZPrescale_branch.SetAddress(<void*>&self.doubleE_23_12_DZPrescale_value)

        #print "making doubleMuDZGroup"
        self.doubleMuDZGroup_branch = the_tree.GetBranch("doubleMuDZGroup")
        #if not self.doubleMuDZGroup_branch and "doubleMuDZGroup" not in self.complained:
        if not self.doubleMuDZGroup_branch and "doubleMuDZGroup":
            warnings.warn( "EETree: Expected branch doubleMuDZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZGroup")
        else:
            self.doubleMuDZGroup_branch.SetAddress(<void*>&self.doubleMuDZGroup_value)

        #print "making doubleMuDZPass"
        self.doubleMuDZPass_branch = the_tree.GetBranch("doubleMuDZPass")
        #if not self.doubleMuDZPass_branch and "doubleMuDZPass" not in self.complained:
        if not self.doubleMuDZPass_branch and "doubleMuDZPass":
            warnings.warn( "EETree: Expected branch doubleMuDZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZPass")
        else:
            self.doubleMuDZPass_branch.SetAddress(<void*>&self.doubleMuDZPass_value)

        #print "making doubleMuDZPrescale"
        self.doubleMuDZPrescale_branch = the_tree.GetBranch("doubleMuDZPrescale")
        #if not self.doubleMuDZPrescale_branch and "doubleMuDZPrescale" not in self.complained:
        if not self.doubleMuDZPrescale_branch and "doubleMuDZPrescale":
            warnings.warn( "EETree: Expected branch doubleMuDZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZPrescale")
        else:
            self.doubleMuDZPrescale_branch.SetAddress(<void*>&self.doubleMuDZPrescale_value)

        #print "making doubleMuDZminMass3p8Group"
        self.doubleMuDZminMass3p8Group_branch = the_tree.GetBranch("doubleMuDZminMass3p8Group")
        #if not self.doubleMuDZminMass3p8Group_branch and "doubleMuDZminMass3p8Group" not in self.complained:
        if not self.doubleMuDZminMass3p8Group_branch and "doubleMuDZminMass3p8Group":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass3p8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Group")
        else:
            self.doubleMuDZminMass3p8Group_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Group_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass3p8Prescale"
        self.doubleMuDZminMass3p8Prescale_branch = the_tree.GetBranch("doubleMuDZminMass3p8Prescale")
        #if not self.doubleMuDZminMass3p8Prescale_branch and "doubleMuDZminMass3p8Prescale" not in self.complained:
        if not self.doubleMuDZminMass3p8Prescale_branch and "doubleMuDZminMass3p8Prescale":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass3p8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Prescale")
        else:
            self.doubleMuDZminMass3p8Prescale_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Prescale_value)

        #print "making doubleMuDZminMass8Group"
        self.doubleMuDZminMass8Group_branch = the_tree.GetBranch("doubleMuDZminMass8Group")
        #if not self.doubleMuDZminMass8Group_branch and "doubleMuDZminMass8Group" not in self.complained:
        if not self.doubleMuDZminMass8Group_branch and "doubleMuDZminMass8Group":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Group")
        else:
            self.doubleMuDZminMass8Group_branch.SetAddress(<void*>&self.doubleMuDZminMass8Group_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuDZminMass8Prescale"
        self.doubleMuDZminMass8Prescale_branch = the_tree.GetBranch("doubleMuDZminMass8Prescale")
        #if not self.doubleMuDZminMass8Prescale_branch and "doubleMuDZminMass8Prescale" not in self.complained:
        if not self.doubleMuDZminMass8Prescale_branch and "doubleMuDZminMass8Prescale":
            warnings.warn( "EETree: Expected branch doubleMuDZminMass8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Prescale")
        else:
            self.doubleMuDZminMass8Prescale_branch.SetAddress(<void*>&self.doubleMuDZminMass8Prescale_value)

        #print "making e1CBIDLoose"
        self.e1CBIDLoose_branch = the_tree.GetBranch("e1CBIDLoose")
        #if not self.e1CBIDLoose_branch and "e1CBIDLoose" not in self.complained:
        if not self.e1CBIDLoose_branch and "e1CBIDLoose":
            warnings.warn( "EETree: Expected branch e1CBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDLoose")
        else:
            self.e1CBIDLoose_branch.SetAddress(<void*>&self.e1CBIDLoose_value)

        #print "making e1CBIDMedium"
        self.e1CBIDMedium_branch = the_tree.GetBranch("e1CBIDMedium")
        #if not self.e1CBIDMedium_branch and "e1CBIDMedium" not in self.complained:
        if not self.e1CBIDMedium_branch and "e1CBIDMedium":
            warnings.warn( "EETree: Expected branch e1CBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDMedium")
        else:
            self.e1CBIDMedium_branch.SetAddress(<void*>&self.e1CBIDMedium_value)

        #print "making e1CBIDTight"
        self.e1CBIDTight_branch = the_tree.GetBranch("e1CBIDTight")
        #if not self.e1CBIDTight_branch and "e1CBIDTight" not in self.complained:
        if not self.e1CBIDTight_branch and "e1CBIDTight":
            warnings.warn( "EETree: Expected branch e1CBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDTight")
        else:
            self.e1CBIDTight_branch.SetAddress(<void*>&self.e1CBIDTight_value)

        #print "making e1CBIDVeto"
        self.e1CBIDVeto_branch = the_tree.GetBranch("e1CBIDVeto")
        #if not self.e1CBIDVeto_branch and "e1CBIDVeto" not in self.complained:
        if not self.e1CBIDVeto_branch and "e1CBIDVeto":
            warnings.warn( "EETree: Expected branch e1CBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CBIDVeto")
        else:
            self.e1CBIDVeto_branch.SetAddress(<void*>&self.e1CBIDVeto_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EETree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EETree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EETree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EETree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EETree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1DPhiToPfMet_type1"
        self.e1DPhiToPfMet_type1_branch = the_tree.GetBranch("e1DPhiToPfMet_type1")
        #if not self.e1DPhiToPfMet_type1_branch and "e1DPhiToPfMet_type1" not in self.complained:
        if not self.e1DPhiToPfMet_type1_branch and "e1DPhiToPfMet_type1":
            warnings.warn( "EETree: Expected branch e1DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1DPhiToPfMet_type1")
        else:
            self.e1DPhiToPfMet_type1_branch.SetAddress(<void*>&self.e1DPhiToPfMet_type1_value)

        #print "making e1E1x5"
        self.e1E1x5_branch = the_tree.GetBranch("e1E1x5")
        #if not self.e1E1x5_branch and "e1E1x5" not in self.complained:
        if not self.e1E1x5_branch and "e1E1x5":
            warnings.warn( "EETree: Expected branch e1E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E1x5")
        else:
            self.e1E1x5_branch.SetAddress(<void*>&self.e1E1x5_value)

        #print "making e1E2x5Max"
        self.e1E2x5Max_branch = the_tree.GetBranch("e1E2x5Max")
        #if not self.e1E2x5Max_branch and "e1E2x5Max" not in self.complained:
        if not self.e1E2x5Max_branch and "e1E2x5Max":
            warnings.warn( "EETree: Expected branch e1E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E2x5Max")
        else:
            self.e1E2x5Max_branch.SetAddress(<void*>&self.e1E2x5Max_value)

        #print "making e1E5x5"
        self.e1E5x5_branch = the_tree.GetBranch("e1E5x5")
        #if not self.e1E5x5_branch and "e1E5x5" not in self.complained:
        if not self.e1E5x5_branch and "e1E5x5":
            warnings.warn( "EETree: Expected branch e1E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1E5x5")
        else:
            self.e1E5x5_branch.SetAddress(<void*>&self.e1E5x5_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EETree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EffectiveAreaFall17"
        self.e1EffectiveAreaFall17_branch = the_tree.GetBranch("e1EffectiveAreaFall17")
        #if not self.e1EffectiveAreaFall17_branch and "e1EffectiveAreaFall17" not in self.complained:
        if not self.e1EffectiveAreaFall17_branch and "e1EffectiveAreaFall17":
            warnings.warn( "EETree: Expected branch e1EffectiveAreaFall17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EffectiveAreaFall17")
        else:
            self.e1EffectiveAreaFall17_branch.SetAddress(<void*>&self.e1EffectiveAreaFall17_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EETree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EETree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EETree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenDirectPromptTauDecay"
        self.e1GenDirectPromptTauDecay_branch = the_tree.GetBranch("e1GenDirectPromptTauDecay")
        #if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay" not in self.complained:
        if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay":
            warnings.warn( "EETree: Expected branch e1GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenDirectPromptTauDecay")
        else:
            self.e1GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e1GenDirectPromptTauDecay_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EETree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EETree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenIsPrompt"
        self.e1GenIsPrompt_branch = the_tree.GetBranch("e1GenIsPrompt")
        #if not self.e1GenIsPrompt_branch and "e1GenIsPrompt" not in self.complained:
        if not self.e1GenIsPrompt_branch and "e1GenIsPrompt":
            warnings.warn( "EETree: Expected branch e1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenIsPrompt")
        else:
            self.e1GenIsPrompt_branch.SetAddress(<void*>&self.e1GenIsPrompt_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EETree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenParticle"
        self.e1GenParticle_branch = the_tree.GetBranch("e1GenParticle")
        #if not self.e1GenParticle_branch and "e1GenParticle" not in self.complained:
        if not self.e1GenParticle_branch and "e1GenParticle":
            warnings.warn( "EETree: Expected branch e1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenParticle")
        else:
            self.e1GenParticle_branch.SetAddress(<void*>&self.e1GenParticle_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EETree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EETree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1GenPrompt"
        self.e1GenPrompt_branch = the_tree.GetBranch("e1GenPrompt")
        #if not self.e1GenPrompt_branch and "e1GenPrompt" not in self.complained:
        if not self.e1GenPrompt_branch and "e1GenPrompt":
            warnings.warn( "EETree: Expected branch e1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPrompt")
        else:
            self.e1GenPrompt_branch.SetAddress(<void*>&self.e1GenPrompt_value)

        #print "making e1GenPromptTauDecay"
        self.e1GenPromptTauDecay_branch = the_tree.GetBranch("e1GenPromptTauDecay")
        #if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay" not in self.complained:
        if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay":
            warnings.warn( "EETree: Expected branch e1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPromptTauDecay")
        else:
            self.e1GenPromptTauDecay_branch.SetAddress(<void*>&self.e1GenPromptTauDecay_value)

        #print "making e1GenPt"
        self.e1GenPt_branch = the_tree.GetBranch("e1GenPt")
        #if not self.e1GenPt_branch and "e1GenPt" not in self.complained:
        if not self.e1GenPt_branch and "e1GenPt":
            warnings.warn( "EETree: Expected branch e1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPt")
        else:
            self.e1GenPt_branch.SetAddress(<void*>&self.e1GenPt_value)

        #print "making e1GenTauDecay"
        self.e1GenTauDecay_branch = the_tree.GetBranch("e1GenTauDecay")
        #if not self.e1GenTauDecay_branch and "e1GenTauDecay" not in self.complained:
        if not self.e1GenTauDecay_branch and "e1GenTauDecay":
            warnings.warn( "EETree: Expected branch e1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenTauDecay")
        else:
            self.e1GenTauDecay_branch.SetAddress(<void*>&self.e1GenTauDecay_value)

        #print "making e1GenVZ"
        self.e1GenVZ_branch = the_tree.GetBranch("e1GenVZ")
        #if not self.e1GenVZ_branch and "e1GenVZ" not in self.complained:
        if not self.e1GenVZ_branch and "e1GenVZ":
            warnings.warn( "EETree: Expected branch e1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVZ")
        else:
            self.e1GenVZ_branch.SetAddress(<void*>&self.e1GenVZ_value)

        #print "making e1GenVtxPVMatch"
        self.e1GenVtxPVMatch_branch = the_tree.GetBranch("e1GenVtxPVMatch")
        #if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch" not in self.complained:
        if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch":
            warnings.warn( "EETree: Expected branch e1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVtxPVMatch")
        else:
            self.e1GenVtxPVMatch_branch.SetAddress(<void*>&self.e1GenVtxPVMatch_value)

        #print "making e1HadronicDepth1OverEm"
        self.e1HadronicDepth1OverEm_branch = the_tree.GetBranch("e1HadronicDepth1OverEm")
        #if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm" not in self.complained:
        if not self.e1HadronicDepth1OverEm_branch and "e1HadronicDepth1OverEm":
            warnings.warn( "EETree: Expected branch e1HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth1OverEm")
        else:
            self.e1HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth1OverEm_value)

        #print "making e1HadronicDepth2OverEm"
        self.e1HadronicDepth2OverEm_branch = the_tree.GetBranch("e1HadronicDepth2OverEm")
        #if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm" not in self.complained:
        if not self.e1HadronicDepth2OverEm_branch and "e1HadronicDepth2OverEm":
            warnings.warn( "EETree: Expected branch e1HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicDepth2OverEm")
        else:
            self.e1HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e1HadronicDepth2OverEm_value)

        #print "making e1HadronicOverEM"
        self.e1HadronicOverEM_branch = the_tree.GetBranch("e1HadronicOverEM")
        #if not self.e1HadronicOverEM_branch and "e1HadronicOverEM" not in self.complained:
        if not self.e1HadronicOverEM_branch and "e1HadronicOverEM":
            warnings.warn( "EETree: Expected branch e1HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HadronicOverEM")
        else:
            self.e1HadronicOverEM_branch.SetAddress(<void*>&self.e1HadronicOverEM_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EETree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3D"
        self.e1IP3D_branch = the_tree.GetBranch("e1IP3D")
        #if not self.e1IP3D_branch and "e1IP3D" not in self.complained:
        if not self.e1IP3D_branch and "e1IP3D":
            warnings.warn( "EETree: Expected branch e1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3D")
        else:
            self.e1IP3D_branch.SetAddress(<void*>&self.e1IP3D_value)

        #print "making e1IP3DErr"
        self.e1IP3DErr_branch = the_tree.GetBranch("e1IP3DErr")
        #if not self.e1IP3DErr_branch and "e1IP3DErr" not in self.complained:
        if not self.e1IP3DErr_branch and "e1IP3DErr":
            warnings.warn( "EETree: Expected branch e1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DErr")
        else:
            self.e1IP3DErr_branch.SetAddress(<void*>&self.e1IP3DErr_value)

        #print "making e1IsoDB03"
        self.e1IsoDB03_branch = the_tree.GetBranch("e1IsoDB03")
        #if not self.e1IsoDB03_branch and "e1IsoDB03" not in self.complained:
        if not self.e1IsoDB03_branch and "e1IsoDB03":
            warnings.warn( "EETree: Expected branch e1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IsoDB03")
        else:
            self.e1IsoDB03_branch.SetAddress(<void*>&self.e1IsoDB03_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EETree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EETree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetDR"
        self.e1JetDR_branch = the_tree.GetBranch("e1JetDR")
        #if not self.e1JetDR_branch and "e1JetDR" not in self.complained:
        if not self.e1JetDR_branch and "e1JetDR":
            warnings.warn( "EETree: Expected branch e1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetDR")
        else:
            self.e1JetDR_branch.SetAddress(<void*>&self.e1JetDR_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EETree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EETree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EETree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetHadronFlavour"
        self.e1JetHadronFlavour_branch = the_tree.GetBranch("e1JetHadronFlavour")
        #if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour" not in self.complained:
        if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour":
            warnings.warn( "EETree: Expected branch e1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetHadronFlavour")
        else:
            self.e1JetHadronFlavour_branch.SetAddress(<void*>&self.e1JetHadronFlavour_value)

        #print "making e1JetPFCISVBtag"
        self.e1JetPFCISVBtag_branch = the_tree.GetBranch("e1JetPFCISVBtag")
        #if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag" not in self.complained:
        if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag":
            warnings.warn( "EETree: Expected branch e1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPFCISVBtag")
        else:
            self.e1JetPFCISVBtag_branch.SetAddress(<void*>&self.e1JetPFCISVBtag_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EETree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EETree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EETree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1LowestMll"
        self.e1LowestMll_branch = the_tree.GetBranch("e1LowestMll")
        #if not self.e1LowestMll_branch and "e1LowestMll" not in self.complained:
        if not self.e1LowestMll_branch and "e1LowestMll":
            warnings.warn( "EETree: Expected branch e1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1LowestMll")
        else:
            self.e1LowestMll_branch.SetAddress(<void*>&self.e1LowestMll_value)

        #print "making e1MVAIsoLoose"
        self.e1MVAIsoLoose_branch = the_tree.GetBranch("e1MVAIsoLoose")
        #if not self.e1MVAIsoLoose_branch and "e1MVAIsoLoose" not in self.complained:
        if not self.e1MVAIsoLoose_branch and "e1MVAIsoLoose":
            warnings.warn( "EETree: Expected branch e1MVAIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoLoose")
        else:
            self.e1MVAIsoLoose_branch.SetAddress(<void*>&self.e1MVAIsoLoose_value)

        #print "making e1MVAIsoWP80"
        self.e1MVAIsoWP80_branch = the_tree.GetBranch("e1MVAIsoWP80")
        #if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80" not in self.complained:
        if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80":
            warnings.warn( "EETree: Expected branch e1MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP80")
        else:
            self.e1MVAIsoWP80_branch.SetAddress(<void*>&self.e1MVAIsoWP80_value)

        #print "making e1MVAIsoWP90"
        self.e1MVAIsoWP90_branch = the_tree.GetBranch("e1MVAIsoWP90")
        #if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90" not in self.complained:
        if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90":
            warnings.warn( "EETree: Expected branch e1MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP90")
        else:
            self.e1MVAIsoWP90_branch.SetAddress(<void*>&self.e1MVAIsoWP90_value)

        #print "making e1MVANoisoLoose"
        self.e1MVANoisoLoose_branch = the_tree.GetBranch("e1MVANoisoLoose")
        #if not self.e1MVANoisoLoose_branch and "e1MVANoisoLoose" not in self.complained:
        if not self.e1MVANoisoLoose_branch and "e1MVANoisoLoose":
            warnings.warn( "EETree: Expected branch e1MVANoisoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoLoose")
        else:
            self.e1MVANoisoLoose_branch.SetAddress(<void*>&self.e1MVANoisoLoose_value)

        #print "making e1MVANoisoWP80"
        self.e1MVANoisoWP80_branch = the_tree.GetBranch("e1MVANoisoWP80")
        #if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80" not in self.complained:
        if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80":
            warnings.warn( "EETree: Expected branch e1MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP80")
        else:
            self.e1MVANoisoWP80_branch.SetAddress(<void*>&self.e1MVANoisoWP80_value)

        #print "making e1MVANoisoWP90"
        self.e1MVANoisoWP90_branch = the_tree.GetBranch("e1MVANoisoWP90")
        #if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90" not in self.complained:
        if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90":
            warnings.warn( "EETree: Expected branch e1MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP90")
        else:
            self.e1MVANoisoWP90_branch.SetAddress(<void*>&self.e1MVANoisoWP90_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EETree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchesEle24Tau30Filter"
        self.e1MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau30Filter")
        #if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter" not in self.complained:
        if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter":
            warnings.warn( "EETree: Expected branch e1MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Filter")
        else:
            self.e1MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Filter_value)

        #print "making e1MatchesEle24Tau30Path"
        self.e1MatchesEle24Tau30Path_branch = the_tree.GetBranch("e1MatchesEle24Tau30Path")
        #if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path" not in self.complained:
        if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path":
            warnings.warn( "EETree: Expected branch e1MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Path")
        else:
            self.e1MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Path_value)

        #print "making e1MatchesEle27Filter"
        self.e1MatchesEle27Filter_branch = the_tree.GetBranch("e1MatchesEle27Filter")
        #if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter" not in self.complained:
        if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter":
            warnings.warn( "EETree: Expected branch e1MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Filter")
        else:
            self.e1MatchesEle27Filter_branch.SetAddress(<void*>&self.e1MatchesEle27Filter_value)

        #print "making e1MatchesEle27Path"
        self.e1MatchesEle27Path_branch = the_tree.GetBranch("e1MatchesEle27Path")
        #if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path" not in self.complained:
        if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path":
            warnings.warn( "EETree: Expected branch e1MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Path")
        else:
            self.e1MatchesEle27Path_branch.SetAddress(<void*>&self.e1MatchesEle27Path_value)

        #print "making e1MatchesEle32Filter"
        self.e1MatchesEle32Filter_branch = the_tree.GetBranch("e1MatchesEle32Filter")
        #if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter" not in self.complained:
        if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter":
            warnings.warn( "EETree: Expected branch e1MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Filter")
        else:
            self.e1MatchesEle32Filter_branch.SetAddress(<void*>&self.e1MatchesEle32Filter_value)

        #print "making e1MatchesEle32Path"
        self.e1MatchesEle32Path_branch = the_tree.GetBranch("e1MatchesEle32Path")
        #if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path" not in self.complained:
        if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path":
            warnings.warn( "EETree: Expected branch e1MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Path")
        else:
            self.e1MatchesEle32Path_branch.SetAddress(<void*>&self.e1MatchesEle32Path_value)

        #print "making e1MatchesEle35Filter"
        self.e1MatchesEle35Filter_branch = the_tree.GetBranch("e1MatchesEle35Filter")
        #if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter" not in self.complained:
        if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter":
            warnings.warn( "EETree: Expected branch e1MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Filter")
        else:
            self.e1MatchesEle35Filter_branch.SetAddress(<void*>&self.e1MatchesEle35Filter_value)

        #print "making e1MatchesEle35Path"
        self.e1MatchesEle35Path_branch = the_tree.GetBranch("e1MatchesEle35Path")
        #if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path" not in self.complained:
        if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path":
            warnings.warn( "EETree: Expected branch e1MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Path")
        else:
            self.e1MatchesEle35Path_branch.SetAddress(<void*>&self.e1MatchesEle35Path_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EETree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1MtToPfMet_type1"
        self.e1MtToPfMet_type1_branch = the_tree.GetBranch("e1MtToPfMet_type1")
        #if not self.e1MtToPfMet_type1_branch and "e1MtToPfMet_type1" not in self.complained:
        if not self.e1MtToPfMet_type1_branch and "e1MtToPfMet_type1":
            warnings.warn( "EETree: Expected branch e1MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MtToPfMet_type1")
        else:
            self.e1MtToPfMet_type1_branch.SetAddress(<void*>&self.e1MtToPfMet_type1_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EETree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1NearestMuonDR"
        self.e1NearestMuonDR_branch = the_tree.GetBranch("e1NearestMuonDR")
        #if not self.e1NearestMuonDR_branch and "e1NearestMuonDR" not in self.complained:
        if not self.e1NearestMuonDR_branch and "e1NearestMuonDR":
            warnings.warn( "EETree: Expected branch e1NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestMuonDR")
        else:
            self.e1NearestMuonDR_branch.SetAddress(<void*>&self.e1NearestMuonDR_value)

        #print "making e1NearestZMass"
        self.e1NearestZMass_branch = the_tree.GetBranch("e1NearestZMass")
        #if not self.e1NearestZMass_branch and "e1NearestZMass" not in self.complained:
        if not self.e1NearestZMass_branch and "e1NearestZMass":
            warnings.warn( "EETree: Expected branch e1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestZMass")
        else:
            self.e1NearestZMass_branch.SetAddress(<void*>&self.e1NearestZMass_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EETree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EETree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPUChargedIso"
        self.e1PFPUChargedIso_branch = the_tree.GetBranch("e1PFPUChargedIso")
        #if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso" not in self.complained:
        if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso":
            warnings.warn( "EETree: Expected branch e1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPUChargedIso")
        else:
            self.e1PFPUChargedIso_branch.SetAddress(<void*>&self.e1PFPUChargedIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EETree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EETree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EETree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1PassesConversionVeto"
        self.e1PassesConversionVeto_branch = the_tree.GetBranch("e1PassesConversionVeto")
        #if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto" not in self.complained:
        if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto":
            warnings.warn( "EETree: Expected branch e1PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PassesConversionVeto")
        else:
            self.e1PassesConversionVeto_branch.SetAddress(<void*>&self.e1PassesConversionVeto_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EETree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EETree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EETree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EETree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EETree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1Rho"
        self.e1Rho_branch = the_tree.GetBranch("e1Rho")
        #if not self.e1Rho_branch and "e1Rho" not in self.complained:
        if not self.e1Rho_branch and "e1Rho":
            warnings.warn( "EETree: Expected branch e1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rho")
        else:
            self.e1Rho_branch.SetAddress(<void*>&self.e1Rho_value)

        #print "making e1SCEnergy"
        self.e1SCEnergy_branch = the_tree.GetBranch("e1SCEnergy")
        #if not self.e1SCEnergy_branch and "e1SCEnergy" not in self.complained:
        if not self.e1SCEnergy_branch and "e1SCEnergy":
            warnings.warn( "EETree: Expected branch e1SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEnergy")
        else:
            self.e1SCEnergy_branch.SetAddress(<void*>&self.e1SCEnergy_value)

        #print "making e1SCEta"
        self.e1SCEta_branch = the_tree.GetBranch("e1SCEta")
        #if not self.e1SCEta_branch and "e1SCEta" not in self.complained:
        if not self.e1SCEta_branch and "e1SCEta":
            warnings.warn( "EETree: Expected branch e1SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEta")
        else:
            self.e1SCEta_branch.SetAddress(<void*>&self.e1SCEta_value)

        #print "making e1SCEtaWidth"
        self.e1SCEtaWidth_branch = the_tree.GetBranch("e1SCEtaWidth")
        #if not self.e1SCEtaWidth_branch and "e1SCEtaWidth" not in self.complained:
        if not self.e1SCEtaWidth_branch and "e1SCEtaWidth":
            warnings.warn( "EETree: Expected branch e1SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCEtaWidth")
        else:
            self.e1SCEtaWidth_branch.SetAddress(<void*>&self.e1SCEtaWidth_value)

        #print "making e1SCPhi"
        self.e1SCPhi_branch = the_tree.GetBranch("e1SCPhi")
        #if not self.e1SCPhi_branch and "e1SCPhi" not in self.complained:
        if not self.e1SCPhi_branch and "e1SCPhi":
            warnings.warn( "EETree: Expected branch e1SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhi")
        else:
            self.e1SCPhi_branch.SetAddress(<void*>&self.e1SCPhi_value)

        #print "making e1SCPhiWidth"
        self.e1SCPhiWidth_branch = the_tree.GetBranch("e1SCPhiWidth")
        #if not self.e1SCPhiWidth_branch and "e1SCPhiWidth" not in self.complained:
        if not self.e1SCPhiWidth_branch and "e1SCPhiWidth":
            warnings.warn( "EETree: Expected branch e1SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPhiWidth")
        else:
            self.e1SCPhiWidth_branch.SetAddress(<void*>&self.e1SCPhiWidth_value)

        #print "making e1SCPreshowerEnergy"
        self.e1SCPreshowerEnergy_branch = the_tree.GetBranch("e1SCPreshowerEnergy")
        #if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy" not in self.complained:
        if not self.e1SCPreshowerEnergy_branch and "e1SCPreshowerEnergy":
            warnings.warn( "EETree: Expected branch e1SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCPreshowerEnergy")
        else:
            self.e1SCPreshowerEnergy_branch.SetAddress(<void*>&self.e1SCPreshowerEnergy_value)

        #print "making e1SCRawEnergy"
        self.e1SCRawEnergy_branch = the_tree.GetBranch("e1SCRawEnergy")
        #if not self.e1SCRawEnergy_branch and "e1SCRawEnergy" not in self.complained:
        if not self.e1SCRawEnergy_branch and "e1SCRawEnergy":
            warnings.warn( "EETree: Expected branch e1SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SCRawEnergy")
        else:
            self.e1SCRawEnergy_branch.SetAddress(<void*>&self.e1SCRawEnergy_value)

        #print "making e1SIP2D"
        self.e1SIP2D_branch = the_tree.GetBranch("e1SIP2D")
        #if not self.e1SIP2D_branch and "e1SIP2D" not in self.complained:
        if not self.e1SIP2D_branch and "e1SIP2D":
            warnings.warn( "EETree: Expected branch e1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP2D")
        else:
            self.e1SIP2D_branch.SetAddress(<void*>&self.e1SIP2D_value)

        #print "making e1SIP3D"
        self.e1SIP3D_branch = the_tree.GetBranch("e1SIP3D")
        #if not self.e1SIP3D_branch and "e1SIP3D" not in self.complained:
        if not self.e1SIP3D_branch and "e1SIP3D":
            warnings.warn( "EETree: Expected branch e1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP3D")
        else:
            self.e1SIP3D_branch.SetAddress(<void*>&self.e1SIP3D_value)

        #print "making e1SigmaIEtaIEta"
        self.e1SigmaIEtaIEta_branch = the_tree.GetBranch("e1SigmaIEtaIEta")
        #if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta" not in self.complained:
        if not self.e1SigmaIEtaIEta_branch and "e1SigmaIEtaIEta":
            warnings.warn( "EETree: Expected branch e1SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SigmaIEtaIEta")
        else:
            self.e1SigmaIEtaIEta_branch.SetAddress(<void*>&self.e1SigmaIEtaIEta_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EETree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EETree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1ZTTGenMatching"
        self.e1ZTTGenMatching_branch = the_tree.GetBranch("e1ZTTGenMatching")
        #if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching" not in self.complained:
        if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching":
            warnings.warn( "EETree: Expected branch e1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ZTTGenMatching")
        else:
            self.e1ZTTGenMatching_branch.SetAddress(<void*>&self.e1ZTTGenMatching_value)

        #print "making e1_e2_CosThetaStar"
        self.e1_e2_CosThetaStar_branch = the_tree.GetBranch("e1_e2_CosThetaStar")
        #if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar" not in self.complained:
        if not self.e1_e2_CosThetaStar_branch and "e1_e2_CosThetaStar":
            warnings.warn( "EETree: Expected branch e1_e2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_CosThetaStar")
        else:
            self.e1_e2_CosThetaStar_branch.SetAddress(<void*>&self.e1_e2_CosThetaStar_value)

        #print "making e1_e2_DPhi"
        self.e1_e2_DPhi_branch = the_tree.GetBranch("e1_e2_DPhi")
        #if not self.e1_e2_DPhi_branch and "e1_e2_DPhi" not in self.complained:
        if not self.e1_e2_DPhi_branch and "e1_e2_DPhi":
            warnings.warn( "EETree: Expected branch e1_e2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DPhi")
        else:
            self.e1_e2_DPhi_branch.SetAddress(<void*>&self.e1_e2_DPhi_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EETree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Eta"
        self.e1_e2_Eta_branch = the_tree.GetBranch("e1_e2_Eta")
        #if not self.e1_e2_Eta_branch and "e1_e2_Eta" not in self.complained:
        if not self.e1_e2_Eta_branch and "e1_e2_Eta":
            warnings.warn( "EETree: Expected branch e1_e2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Eta")
        else:
            self.e1_e2_Eta_branch.SetAddress(<void*>&self.e1_e2_Eta_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EETree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_Mt"
        self.e1_e2_Mt_branch = the_tree.GetBranch("e1_e2_Mt")
        #if not self.e1_e2_Mt_branch and "e1_e2_Mt" not in self.complained:
        if not self.e1_e2_Mt_branch and "e1_e2_Mt":
            warnings.warn( "EETree: Expected branch e1_e2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mt")
        else:
            self.e1_e2_Mt_branch.SetAddress(<void*>&self.e1_e2_Mt_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EETree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EETree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_Phi"
        self.e1_e2_Phi_branch = the_tree.GetBranch("e1_e2_Phi")
        #if not self.e1_e2_Phi_branch and "e1_e2_Phi" not in self.complained:
        if not self.e1_e2_Phi_branch and "e1_e2_Phi":
            warnings.warn( "EETree: Expected branch e1_e2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Phi")
        else:
            self.e1_e2_Phi_branch.SetAddress(<void*>&self.e1_e2_Phi_value)

        #print "making e1_e2_Pt"
        self.e1_e2_Pt_branch = the_tree.GetBranch("e1_e2_Pt")
        #if not self.e1_e2_Pt_branch and "e1_e2_Pt" not in self.complained:
        if not self.e1_e2_Pt_branch and "e1_e2_Pt":
            warnings.warn( "EETree: Expected branch e1_e2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Pt")
        else:
            self.e1_e2_Pt_branch.SetAddress(<void*>&self.e1_e2_Pt_value)

        #print "making e1_e2_SS"
        self.e1_e2_SS_branch = the_tree.GetBranch("e1_e2_SS")
        #if not self.e1_e2_SS_branch and "e1_e2_SS" not in self.complained:
        if not self.e1_e2_SS_branch and "e1_e2_SS":
            warnings.warn( "EETree: Expected branch e1_e2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_SS")
        else:
            self.e1_e2_SS_branch.SetAddress(<void*>&self.e1_e2_SS_value)

        #print "making e1_e2_collinearmass"
        self.e1_e2_collinearmass_branch = the_tree.GetBranch("e1_e2_collinearmass")
        #if not self.e1_e2_collinearmass_branch and "e1_e2_collinearmass" not in self.complained:
        if not self.e1_e2_collinearmass_branch and "e1_e2_collinearmass":
            warnings.warn( "EETree: Expected branch e1_e2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_collinearmass")
        else:
            self.e1_e2_collinearmass_branch.SetAddress(<void*>&self.e1_e2_collinearmass_value)

        #print "making e1_e2_doubleL1IsoTauMatch"
        self.e1_e2_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e1_e2_doubleL1IsoTauMatch")
        #if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch" not in self.complained:
        if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch":
            warnings.warn( "EETree: Expected branch e1_e2_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_doubleL1IsoTauMatch")
        else:
            self.e1_e2_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e1_e2_doubleL1IsoTauMatch_value)

        #print "making e1deltaEtaSuperClusterTrackAtVtx"
        self.e1deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaEtaSuperClusterTrackAtVtx")
        #if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaEtaSuperClusterTrackAtVtx_branch and "e1deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETree: Expected branch e1deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e1deltaPhiSuperClusterTrackAtVtx"
        self.e1deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e1deltaPhiSuperClusterTrackAtVtx")
        #if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e1deltaPhiSuperClusterTrackAtVtx_branch and "e1deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETree: Expected branch e1deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e1deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e1eSuperClusterOverP"
        self.e1eSuperClusterOverP_branch = the_tree.GetBranch("e1eSuperClusterOverP")
        #if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP" not in self.complained:
        if not self.e1eSuperClusterOverP_branch and "e1eSuperClusterOverP":
            warnings.warn( "EETree: Expected branch e1eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1eSuperClusterOverP")
        else:
            self.e1eSuperClusterOverP_branch.SetAddress(<void*>&self.e1eSuperClusterOverP_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EETree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e1fBrem"
        self.e1fBrem_branch = the_tree.GetBranch("e1fBrem")
        #if not self.e1fBrem_branch and "e1fBrem" not in self.complained:
        if not self.e1fBrem_branch and "e1fBrem":
            warnings.warn( "EETree: Expected branch e1fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1fBrem")
        else:
            self.e1fBrem_branch.SetAddress(<void*>&self.e1fBrem_value)

        #print "making e1trackMomentumAtVtxP"
        self.e1trackMomentumAtVtxP_branch = the_tree.GetBranch("e1trackMomentumAtVtxP")
        #if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP" not in self.complained:
        if not self.e1trackMomentumAtVtxP_branch and "e1trackMomentumAtVtxP":
            warnings.warn( "EETree: Expected branch e1trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1trackMomentumAtVtxP")
        else:
            self.e1trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e1trackMomentumAtVtxP_value)

        #print "making e2CBIDLoose"
        self.e2CBIDLoose_branch = the_tree.GetBranch("e2CBIDLoose")
        #if not self.e2CBIDLoose_branch and "e2CBIDLoose" not in self.complained:
        if not self.e2CBIDLoose_branch and "e2CBIDLoose":
            warnings.warn( "EETree: Expected branch e2CBIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDLoose")
        else:
            self.e2CBIDLoose_branch.SetAddress(<void*>&self.e2CBIDLoose_value)

        #print "making e2CBIDMedium"
        self.e2CBIDMedium_branch = the_tree.GetBranch("e2CBIDMedium")
        #if not self.e2CBIDMedium_branch and "e2CBIDMedium" not in self.complained:
        if not self.e2CBIDMedium_branch and "e2CBIDMedium":
            warnings.warn( "EETree: Expected branch e2CBIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDMedium")
        else:
            self.e2CBIDMedium_branch.SetAddress(<void*>&self.e2CBIDMedium_value)

        #print "making e2CBIDTight"
        self.e2CBIDTight_branch = the_tree.GetBranch("e2CBIDTight")
        #if not self.e2CBIDTight_branch and "e2CBIDTight" not in self.complained:
        if not self.e2CBIDTight_branch and "e2CBIDTight":
            warnings.warn( "EETree: Expected branch e2CBIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDTight")
        else:
            self.e2CBIDTight_branch.SetAddress(<void*>&self.e2CBIDTight_value)

        #print "making e2CBIDVeto"
        self.e2CBIDVeto_branch = the_tree.GetBranch("e2CBIDVeto")
        #if not self.e2CBIDVeto_branch and "e2CBIDVeto" not in self.complained:
        if not self.e2CBIDVeto_branch and "e2CBIDVeto":
            warnings.warn( "EETree: Expected branch e2CBIDVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CBIDVeto")
        else:
            self.e2CBIDVeto_branch.SetAddress(<void*>&self.e2CBIDVeto_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EETree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EETree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EETree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EETree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EETree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2DPhiToPfMet_type1"
        self.e2DPhiToPfMet_type1_branch = the_tree.GetBranch("e2DPhiToPfMet_type1")
        #if not self.e2DPhiToPfMet_type1_branch and "e2DPhiToPfMet_type1" not in self.complained:
        if not self.e2DPhiToPfMet_type1_branch and "e2DPhiToPfMet_type1":
            warnings.warn( "EETree: Expected branch e2DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2DPhiToPfMet_type1")
        else:
            self.e2DPhiToPfMet_type1_branch.SetAddress(<void*>&self.e2DPhiToPfMet_type1_value)

        #print "making e2E1x5"
        self.e2E1x5_branch = the_tree.GetBranch("e2E1x5")
        #if not self.e2E1x5_branch and "e2E1x5" not in self.complained:
        if not self.e2E1x5_branch and "e2E1x5":
            warnings.warn( "EETree: Expected branch e2E1x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E1x5")
        else:
            self.e2E1x5_branch.SetAddress(<void*>&self.e2E1x5_value)

        #print "making e2E2x5Max"
        self.e2E2x5Max_branch = the_tree.GetBranch("e2E2x5Max")
        #if not self.e2E2x5Max_branch and "e2E2x5Max" not in self.complained:
        if not self.e2E2x5Max_branch and "e2E2x5Max":
            warnings.warn( "EETree: Expected branch e2E2x5Max does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E2x5Max")
        else:
            self.e2E2x5Max_branch.SetAddress(<void*>&self.e2E2x5Max_value)

        #print "making e2E5x5"
        self.e2E5x5_branch = the_tree.GetBranch("e2E5x5")
        #if not self.e2E5x5_branch and "e2E5x5" not in self.complained:
        if not self.e2E5x5_branch and "e2E5x5":
            warnings.warn( "EETree: Expected branch e2E5x5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2E5x5")
        else:
            self.e2E5x5_branch.SetAddress(<void*>&self.e2E5x5_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EETree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EffectiveAreaFall17"
        self.e2EffectiveAreaFall17_branch = the_tree.GetBranch("e2EffectiveAreaFall17")
        #if not self.e2EffectiveAreaFall17_branch and "e2EffectiveAreaFall17" not in self.complained:
        if not self.e2EffectiveAreaFall17_branch and "e2EffectiveAreaFall17":
            warnings.warn( "EETree: Expected branch e2EffectiveAreaFall17 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EffectiveAreaFall17")
        else:
            self.e2EffectiveAreaFall17_branch.SetAddress(<void*>&self.e2EffectiveAreaFall17_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EETree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EETree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EETree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenDirectPromptTauDecay"
        self.e2GenDirectPromptTauDecay_branch = the_tree.GetBranch("e2GenDirectPromptTauDecay")
        #if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay" not in self.complained:
        if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay":
            warnings.warn( "EETree: Expected branch e2GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenDirectPromptTauDecay")
        else:
            self.e2GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e2GenDirectPromptTauDecay_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EETree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EETree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenIsPrompt"
        self.e2GenIsPrompt_branch = the_tree.GetBranch("e2GenIsPrompt")
        #if not self.e2GenIsPrompt_branch and "e2GenIsPrompt" not in self.complained:
        if not self.e2GenIsPrompt_branch and "e2GenIsPrompt":
            warnings.warn( "EETree: Expected branch e2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenIsPrompt")
        else:
            self.e2GenIsPrompt_branch.SetAddress(<void*>&self.e2GenIsPrompt_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EETree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenParticle"
        self.e2GenParticle_branch = the_tree.GetBranch("e2GenParticle")
        #if not self.e2GenParticle_branch and "e2GenParticle" not in self.complained:
        if not self.e2GenParticle_branch and "e2GenParticle":
            warnings.warn( "EETree: Expected branch e2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenParticle")
        else:
            self.e2GenParticle_branch.SetAddress(<void*>&self.e2GenParticle_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EETree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EETree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2GenPrompt"
        self.e2GenPrompt_branch = the_tree.GetBranch("e2GenPrompt")
        #if not self.e2GenPrompt_branch and "e2GenPrompt" not in self.complained:
        if not self.e2GenPrompt_branch and "e2GenPrompt":
            warnings.warn( "EETree: Expected branch e2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPrompt")
        else:
            self.e2GenPrompt_branch.SetAddress(<void*>&self.e2GenPrompt_value)

        #print "making e2GenPromptTauDecay"
        self.e2GenPromptTauDecay_branch = the_tree.GetBranch("e2GenPromptTauDecay")
        #if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay" not in self.complained:
        if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay":
            warnings.warn( "EETree: Expected branch e2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPromptTauDecay")
        else:
            self.e2GenPromptTauDecay_branch.SetAddress(<void*>&self.e2GenPromptTauDecay_value)

        #print "making e2GenPt"
        self.e2GenPt_branch = the_tree.GetBranch("e2GenPt")
        #if not self.e2GenPt_branch and "e2GenPt" not in self.complained:
        if not self.e2GenPt_branch and "e2GenPt":
            warnings.warn( "EETree: Expected branch e2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPt")
        else:
            self.e2GenPt_branch.SetAddress(<void*>&self.e2GenPt_value)

        #print "making e2GenTauDecay"
        self.e2GenTauDecay_branch = the_tree.GetBranch("e2GenTauDecay")
        #if not self.e2GenTauDecay_branch and "e2GenTauDecay" not in self.complained:
        if not self.e2GenTauDecay_branch and "e2GenTauDecay":
            warnings.warn( "EETree: Expected branch e2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenTauDecay")
        else:
            self.e2GenTauDecay_branch.SetAddress(<void*>&self.e2GenTauDecay_value)

        #print "making e2GenVZ"
        self.e2GenVZ_branch = the_tree.GetBranch("e2GenVZ")
        #if not self.e2GenVZ_branch and "e2GenVZ" not in self.complained:
        if not self.e2GenVZ_branch and "e2GenVZ":
            warnings.warn( "EETree: Expected branch e2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVZ")
        else:
            self.e2GenVZ_branch.SetAddress(<void*>&self.e2GenVZ_value)

        #print "making e2GenVtxPVMatch"
        self.e2GenVtxPVMatch_branch = the_tree.GetBranch("e2GenVtxPVMatch")
        #if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch" not in self.complained:
        if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch":
            warnings.warn( "EETree: Expected branch e2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVtxPVMatch")
        else:
            self.e2GenVtxPVMatch_branch.SetAddress(<void*>&self.e2GenVtxPVMatch_value)

        #print "making e2HadronicDepth1OverEm"
        self.e2HadronicDepth1OverEm_branch = the_tree.GetBranch("e2HadronicDepth1OverEm")
        #if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm" not in self.complained:
        if not self.e2HadronicDepth1OverEm_branch and "e2HadronicDepth1OverEm":
            warnings.warn( "EETree: Expected branch e2HadronicDepth1OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth1OverEm")
        else:
            self.e2HadronicDepth1OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth1OverEm_value)

        #print "making e2HadronicDepth2OverEm"
        self.e2HadronicDepth2OverEm_branch = the_tree.GetBranch("e2HadronicDepth2OverEm")
        #if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm" not in self.complained:
        if not self.e2HadronicDepth2OverEm_branch and "e2HadronicDepth2OverEm":
            warnings.warn( "EETree: Expected branch e2HadronicDepth2OverEm does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicDepth2OverEm")
        else:
            self.e2HadronicDepth2OverEm_branch.SetAddress(<void*>&self.e2HadronicDepth2OverEm_value)

        #print "making e2HadronicOverEM"
        self.e2HadronicOverEM_branch = the_tree.GetBranch("e2HadronicOverEM")
        #if not self.e2HadronicOverEM_branch and "e2HadronicOverEM" not in self.complained:
        if not self.e2HadronicOverEM_branch and "e2HadronicOverEM":
            warnings.warn( "EETree: Expected branch e2HadronicOverEM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HadronicOverEM")
        else:
            self.e2HadronicOverEM_branch.SetAddress(<void*>&self.e2HadronicOverEM_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EETree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3D"
        self.e2IP3D_branch = the_tree.GetBranch("e2IP3D")
        #if not self.e2IP3D_branch and "e2IP3D" not in self.complained:
        if not self.e2IP3D_branch and "e2IP3D":
            warnings.warn( "EETree: Expected branch e2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3D")
        else:
            self.e2IP3D_branch.SetAddress(<void*>&self.e2IP3D_value)

        #print "making e2IP3DErr"
        self.e2IP3DErr_branch = the_tree.GetBranch("e2IP3DErr")
        #if not self.e2IP3DErr_branch and "e2IP3DErr" not in self.complained:
        if not self.e2IP3DErr_branch and "e2IP3DErr":
            warnings.warn( "EETree: Expected branch e2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DErr")
        else:
            self.e2IP3DErr_branch.SetAddress(<void*>&self.e2IP3DErr_value)

        #print "making e2IsoDB03"
        self.e2IsoDB03_branch = the_tree.GetBranch("e2IsoDB03")
        #if not self.e2IsoDB03_branch and "e2IsoDB03" not in self.complained:
        if not self.e2IsoDB03_branch and "e2IsoDB03":
            warnings.warn( "EETree: Expected branch e2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IsoDB03")
        else:
            self.e2IsoDB03_branch.SetAddress(<void*>&self.e2IsoDB03_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EETree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EETree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetDR"
        self.e2JetDR_branch = the_tree.GetBranch("e2JetDR")
        #if not self.e2JetDR_branch and "e2JetDR" not in self.complained:
        if not self.e2JetDR_branch and "e2JetDR":
            warnings.warn( "EETree: Expected branch e2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetDR")
        else:
            self.e2JetDR_branch.SetAddress(<void*>&self.e2JetDR_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EETree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EETree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EETree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetHadronFlavour"
        self.e2JetHadronFlavour_branch = the_tree.GetBranch("e2JetHadronFlavour")
        #if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour" not in self.complained:
        if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour":
            warnings.warn( "EETree: Expected branch e2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetHadronFlavour")
        else:
            self.e2JetHadronFlavour_branch.SetAddress(<void*>&self.e2JetHadronFlavour_value)

        #print "making e2JetPFCISVBtag"
        self.e2JetPFCISVBtag_branch = the_tree.GetBranch("e2JetPFCISVBtag")
        #if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag" not in self.complained:
        if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag":
            warnings.warn( "EETree: Expected branch e2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPFCISVBtag")
        else:
            self.e2JetPFCISVBtag_branch.SetAddress(<void*>&self.e2JetPFCISVBtag_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EETree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EETree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EETree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2LowestMll"
        self.e2LowestMll_branch = the_tree.GetBranch("e2LowestMll")
        #if not self.e2LowestMll_branch and "e2LowestMll" not in self.complained:
        if not self.e2LowestMll_branch and "e2LowestMll":
            warnings.warn( "EETree: Expected branch e2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2LowestMll")
        else:
            self.e2LowestMll_branch.SetAddress(<void*>&self.e2LowestMll_value)

        #print "making e2MVAIsoLoose"
        self.e2MVAIsoLoose_branch = the_tree.GetBranch("e2MVAIsoLoose")
        #if not self.e2MVAIsoLoose_branch and "e2MVAIsoLoose" not in self.complained:
        if not self.e2MVAIsoLoose_branch and "e2MVAIsoLoose":
            warnings.warn( "EETree: Expected branch e2MVAIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoLoose")
        else:
            self.e2MVAIsoLoose_branch.SetAddress(<void*>&self.e2MVAIsoLoose_value)

        #print "making e2MVAIsoWP80"
        self.e2MVAIsoWP80_branch = the_tree.GetBranch("e2MVAIsoWP80")
        #if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80" not in self.complained:
        if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80":
            warnings.warn( "EETree: Expected branch e2MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP80")
        else:
            self.e2MVAIsoWP80_branch.SetAddress(<void*>&self.e2MVAIsoWP80_value)

        #print "making e2MVAIsoWP90"
        self.e2MVAIsoWP90_branch = the_tree.GetBranch("e2MVAIsoWP90")
        #if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90" not in self.complained:
        if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90":
            warnings.warn( "EETree: Expected branch e2MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP90")
        else:
            self.e2MVAIsoWP90_branch.SetAddress(<void*>&self.e2MVAIsoWP90_value)

        #print "making e2MVANoisoLoose"
        self.e2MVANoisoLoose_branch = the_tree.GetBranch("e2MVANoisoLoose")
        #if not self.e2MVANoisoLoose_branch and "e2MVANoisoLoose" not in self.complained:
        if not self.e2MVANoisoLoose_branch and "e2MVANoisoLoose":
            warnings.warn( "EETree: Expected branch e2MVANoisoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoLoose")
        else:
            self.e2MVANoisoLoose_branch.SetAddress(<void*>&self.e2MVANoisoLoose_value)

        #print "making e2MVANoisoWP80"
        self.e2MVANoisoWP80_branch = the_tree.GetBranch("e2MVANoisoWP80")
        #if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80" not in self.complained:
        if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80":
            warnings.warn( "EETree: Expected branch e2MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP80")
        else:
            self.e2MVANoisoWP80_branch.SetAddress(<void*>&self.e2MVANoisoWP80_value)

        #print "making e2MVANoisoWP90"
        self.e2MVANoisoWP90_branch = the_tree.GetBranch("e2MVANoisoWP90")
        #if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90" not in self.complained:
        if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90":
            warnings.warn( "EETree: Expected branch e2MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP90")
        else:
            self.e2MVANoisoWP90_branch.SetAddress(<void*>&self.e2MVANoisoWP90_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EETree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchesEle24Tau30Filter"
        self.e2MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau30Filter")
        #if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter" not in self.complained:
        if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter":
            warnings.warn( "EETree: Expected branch e2MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Filter")
        else:
            self.e2MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Filter_value)

        #print "making e2MatchesEle24Tau30Path"
        self.e2MatchesEle24Tau30Path_branch = the_tree.GetBranch("e2MatchesEle24Tau30Path")
        #if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path" not in self.complained:
        if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path":
            warnings.warn( "EETree: Expected branch e2MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Path")
        else:
            self.e2MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Path_value)

        #print "making e2MatchesEle27Filter"
        self.e2MatchesEle27Filter_branch = the_tree.GetBranch("e2MatchesEle27Filter")
        #if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter" not in self.complained:
        if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter":
            warnings.warn( "EETree: Expected branch e2MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Filter")
        else:
            self.e2MatchesEle27Filter_branch.SetAddress(<void*>&self.e2MatchesEle27Filter_value)

        #print "making e2MatchesEle27Path"
        self.e2MatchesEle27Path_branch = the_tree.GetBranch("e2MatchesEle27Path")
        #if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path" not in self.complained:
        if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path":
            warnings.warn( "EETree: Expected branch e2MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Path")
        else:
            self.e2MatchesEle27Path_branch.SetAddress(<void*>&self.e2MatchesEle27Path_value)

        #print "making e2MatchesEle32Filter"
        self.e2MatchesEle32Filter_branch = the_tree.GetBranch("e2MatchesEle32Filter")
        #if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter" not in self.complained:
        if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter":
            warnings.warn( "EETree: Expected branch e2MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Filter")
        else:
            self.e2MatchesEle32Filter_branch.SetAddress(<void*>&self.e2MatchesEle32Filter_value)

        #print "making e2MatchesEle32Path"
        self.e2MatchesEle32Path_branch = the_tree.GetBranch("e2MatchesEle32Path")
        #if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path" not in self.complained:
        if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path":
            warnings.warn( "EETree: Expected branch e2MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Path")
        else:
            self.e2MatchesEle32Path_branch.SetAddress(<void*>&self.e2MatchesEle32Path_value)

        #print "making e2MatchesEle35Filter"
        self.e2MatchesEle35Filter_branch = the_tree.GetBranch("e2MatchesEle35Filter")
        #if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter" not in self.complained:
        if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter":
            warnings.warn( "EETree: Expected branch e2MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Filter")
        else:
            self.e2MatchesEle35Filter_branch.SetAddress(<void*>&self.e2MatchesEle35Filter_value)

        #print "making e2MatchesEle35Path"
        self.e2MatchesEle35Path_branch = the_tree.GetBranch("e2MatchesEle35Path")
        #if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path" not in self.complained:
        if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path":
            warnings.warn( "EETree: Expected branch e2MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Path")
        else:
            self.e2MatchesEle35Path_branch.SetAddress(<void*>&self.e2MatchesEle35Path_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EETree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2MtToPfMet_type1"
        self.e2MtToPfMet_type1_branch = the_tree.GetBranch("e2MtToPfMet_type1")
        #if not self.e2MtToPfMet_type1_branch and "e2MtToPfMet_type1" not in self.complained:
        if not self.e2MtToPfMet_type1_branch and "e2MtToPfMet_type1":
            warnings.warn( "EETree: Expected branch e2MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MtToPfMet_type1")
        else:
            self.e2MtToPfMet_type1_branch.SetAddress(<void*>&self.e2MtToPfMet_type1_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EETree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2NearestMuonDR"
        self.e2NearestMuonDR_branch = the_tree.GetBranch("e2NearestMuonDR")
        #if not self.e2NearestMuonDR_branch and "e2NearestMuonDR" not in self.complained:
        if not self.e2NearestMuonDR_branch and "e2NearestMuonDR":
            warnings.warn( "EETree: Expected branch e2NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestMuonDR")
        else:
            self.e2NearestMuonDR_branch.SetAddress(<void*>&self.e2NearestMuonDR_value)

        #print "making e2NearestZMass"
        self.e2NearestZMass_branch = the_tree.GetBranch("e2NearestZMass")
        #if not self.e2NearestZMass_branch and "e2NearestZMass" not in self.complained:
        if not self.e2NearestZMass_branch and "e2NearestZMass":
            warnings.warn( "EETree: Expected branch e2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestZMass")
        else:
            self.e2NearestZMass_branch.SetAddress(<void*>&self.e2NearestZMass_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EETree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EETree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPUChargedIso"
        self.e2PFPUChargedIso_branch = the_tree.GetBranch("e2PFPUChargedIso")
        #if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso" not in self.complained:
        if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso":
            warnings.warn( "EETree: Expected branch e2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPUChargedIso")
        else:
            self.e2PFPUChargedIso_branch.SetAddress(<void*>&self.e2PFPUChargedIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EETree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EETree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EETree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2PassesConversionVeto"
        self.e2PassesConversionVeto_branch = the_tree.GetBranch("e2PassesConversionVeto")
        #if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto" not in self.complained:
        if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto":
            warnings.warn( "EETree: Expected branch e2PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PassesConversionVeto")
        else:
            self.e2PassesConversionVeto_branch.SetAddress(<void*>&self.e2PassesConversionVeto_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EETree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EETree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EETree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EETree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EETree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2Rho"
        self.e2Rho_branch = the_tree.GetBranch("e2Rho")
        #if not self.e2Rho_branch and "e2Rho" not in self.complained:
        if not self.e2Rho_branch and "e2Rho":
            warnings.warn( "EETree: Expected branch e2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rho")
        else:
            self.e2Rho_branch.SetAddress(<void*>&self.e2Rho_value)

        #print "making e2SCEnergy"
        self.e2SCEnergy_branch = the_tree.GetBranch("e2SCEnergy")
        #if not self.e2SCEnergy_branch and "e2SCEnergy" not in self.complained:
        if not self.e2SCEnergy_branch and "e2SCEnergy":
            warnings.warn( "EETree: Expected branch e2SCEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEnergy")
        else:
            self.e2SCEnergy_branch.SetAddress(<void*>&self.e2SCEnergy_value)

        #print "making e2SCEta"
        self.e2SCEta_branch = the_tree.GetBranch("e2SCEta")
        #if not self.e2SCEta_branch and "e2SCEta" not in self.complained:
        if not self.e2SCEta_branch and "e2SCEta":
            warnings.warn( "EETree: Expected branch e2SCEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEta")
        else:
            self.e2SCEta_branch.SetAddress(<void*>&self.e2SCEta_value)

        #print "making e2SCEtaWidth"
        self.e2SCEtaWidth_branch = the_tree.GetBranch("e2SCEtaWidth")
        #if not self.e2SCEtaWidth_branch and "e2SCEtaWidth" not in self.complained:
        if not self.e2SCEtaWidth_branch and "e2SCEtaWidth":
            warnings.warn( "EETree: Expected branch e2SCEtaWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCEtaWidth")
        else:
            self.e2SCEtaWidth_branch.SetAddress(<void*>&self.e2SCEtaWidth_value)

        #print "making e2SCPhi"
        self.e2SCPhi_branch = the_tree.GetBranch("e2SCPhi")
        #if not self.e2SCPhi_branch and "e2SCPhi" not in self.complained:
        if not self.e2SCPhi_branch and "e2SCPhi":
            warnings.warn( "EETree: Expected branch e2SCPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhi")
        else:
            self.e2SCPhi_branch.SetAddress(<void*>&self.e2SCPhi_value)

        #print "making e2SCPhiWidth"
        self.e2SCPhiWidth_branch = the_tree.GetBranch("e2SCPhiWidth")
        #if not self.e2SCPhiWidth_branch and "e2SCPhiWidth" not in self.complained:
        if not self.e2SCPhiWidth_branch and "e2SCPhiWidth":
            warnings.warn( "EETree: Expected branch e2SCPhiWidth does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPhiWidth")
        else:
            self.e2SCPhiWidth_branch.SetAddress(<void*>&self.e2SCPhiWidth_value)

        #print "making e2SCPreshowerEnergy"
        self.e2SCPreshowerEnergy_branch = the_tree.GetBranch("e2SCPreshowerEnergy")
        #if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy" not in self.complained:
        if not self.e2SCPreshowerEnergy_branch and "e2SCPreshowerEnergy":
            warnings.warn( "EETree: Expected branch e2SCPreshowerEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCPreshowerEnergy")
        else:
            self.e2SCPreshowerEnergy_branch.SetAddress(<void*>&self.e2SCPreshowerEnergy_value)

        #print "making e2SCRawEnergy"
        self.e2SCRawEnergy_branch = the_tree.GetBranch("e2SCRawEnergy")
        #if not self.e2SCRawEnergy_branch and "e2SCRawEnergy" not in self.complained:
        if not self.e2SCRawEnergy_branch and "e2SCRawEnergy":
            warnings.warn( "EETree: Expected branch e2SCRawEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SCRawEnergy")
        else:
            self.e2SCRawEnergy_branch.SetAddress(<void*>&self.e2SCRawEnergy_value)

        #print "making e2SIP2D"
        self.e2SIP2D_branch = the_tree.GetBranch("e2SIP2D")
        #if not self.e2SIP2D_branch and "e2SIP2D" not in self.complained:
        if not self.e2SIP2D_branch and "e2SIP2D":
            warnings.warn( "EETree: Expected branch e2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP2D")
        else:
            self.e2SIP2D_branch.SetAddress(<void*>&self.e2SIP2D_value)

        #print "making e2SIP3D"
        self.e2SIP3D_branch = the_tree.GetBranch("e2SIP3D")
        #if not self.e2SIP3D_branch and "e2SIP3D" not in self.complained:
        if not self.e2SIP3D_branch and "e2SIP3D":
            warnings.warn( "EETree: Expected branch e2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP3D")
        else:
            self.e2SIP3D_branch.SetAddress(<void*>&self.e2SIP3D_value)

        #print "making e2SigmaIEtaIEta"
        self.e2SigmaIEtaIEta_branch = the_tree.GetBranch("e2SigmaIEtaIEta")
        #if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta" not in self.complained:
        if not self.e2SigmaIEtaIEta_branch and "e2SigmaIEtaIEta":
            warnings.warn( "EETree: Expected branch e2SigmaIEtaIEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SigmaIEtaIEta")
        else:
            self.e2SigmaIEtaIEta_branch.SetAddress(<void*>&self.e2SigmaIEtaIEta_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EETree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EETree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2ZTTGenMatching"
        self.e2ZTTGenMatching_branch = the_tree.GetBranch("e2ZTTGenMatching")
        #if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching" not in self.complained:
        if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching":
            warnings.warn( "EETree: Expected branch e2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ZTTGenMatching")
        else:
            self.e2ZTTGenMatching_branch.SetAddress(<void*>&self.e2ZTTGenMatching_value)

        #print "making e2_e1_collinearmass"
        self.e2_e1_collinearmass_branch = the_tree.GetBranch("e2_e1_collinearmass")
        #if not self.e2_e1_collinearmass_branch and "e2_e1_collinearmass" not in self.complained:
        if not self.e2_e1_collinearmass_branch and "e2_e1_collinearmass":
            warnings.warn( "EETree: Expected branch e2_e1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e1_collinearmass")
        else:
            self.e2_e1_collinearmass_branch.SetAddress(<void*>&self.e2_e1_collinearmass_value)

        #print "making e2deltaEtaSuperClusterTrackAtVtx"
        self.e2deltaEtaSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaEtaSuperClusterTrackAtVtx")
        #if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaEtaSuperClusterTrackAtVtx_branch and "e2deltaEtaSuperClusterTrackAtVtx":
            warnings.warn( "EETree: Expected branch e2deltaEtaSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaEtaSuperClusterTrackAtVtx")
        else:
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaEtaSuperClusterTrackAtVtx_value)

        #print "making e2deltaPhiSuperClusterTrackAtVtx"
        self.e2deltaPhiSuperClusterTrackAtVtx_branch = the_tree.GetBranch("e2deltaPhiSuperClusterTrackAtVtx")
        #if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx" not in self.complained:
        if not self.e2deltaPhiSuperClusterTrackAtVtx_branch and "e2deltaPhiSuperClusterTrackAtVtx":
            warnings.warn( "EETree: Expected branch e2deltaPhiSuperClusterTrackAtVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2deltaPhiSuperClusterTrackAtVtx")
        else:
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.SetAddress(<void*>&self.e2deltaPhiSuperClusterTrackAtVtx_value)

        #print "making e2eSuperClusterOverP"
        self.e2eSuperClusterOverP_branch = the_tree.GetBranch("e2eSuperClusterOverP")
        #if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP" not in self.complained:
        if not self.e2eSuperClusterOverP_branch and "e2eSuperClusterOverP":
            warnings.warn( "EETree: Expected branch e2eSuperClusterOverP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2eSuperClusterOverP")
        else:
            self.e2eSuperClusterOverP_branch.SetAddress(<void*>&self.e2eSuperClusterOverP_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EETree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making e2fBrem"
        self.e2fBrem_branch = the_tree.GetBranch("e2fBrem")
        #if not self.e2fBrem_branch and "e2fBrem" not in self.complained:
        if not self.e2fBrem_branch and "e2fBrem":
            warnings.warn( "EETree: Expected branch e2fBrem does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2fBrem")
        else:
            self.e2fBrem_branch.SetAddress(<void*>&self.e2fBrem_value)

        #print "making e2trackMomentumAtVtxP"
        self.e2trackMomentumAtVtxP_branch = the_tree.GetBranch("e2trackMomentumAtVtxP")
        #if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP" not in self.complained:
        if not self.e2trackMomentumAtVtxP_branch and "e2trackMomentumAtVtxP":
            warnings.warn( "EETree: Expected branch e2trackMomentumAtVtxP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2trackMomentumAtVtxP")
        else:
            self.e2trackMomentumAtVtxP_branch.SetAddress(<void*>&self.e2trackMomentumAtVtxP_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "EETree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EETree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "EETree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EETree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EETree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EETree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EETree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EETree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EETree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EETree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EETree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EETree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EETree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EETree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EETree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EETree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "EETree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EETree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "EETree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EETree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "EETree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EETree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "EETree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EETree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "EETree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EETree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Down"
        self.j1ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Down")
        #if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Up"
        self.j1ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Up")
        #if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Down"
        self.j1ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Down")
        #if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Up"
        self.j1ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Up")
        #if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Down"
        self.j1ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Down")
        #if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Up"
        self.j1ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Up")
        #if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalDown"
        self.j1ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalUp"
        self.j1ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleDown"
        self.j1ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleUp"
        self.j1ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch j1ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EETree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "EETree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EETree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "EETree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EETree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "EETree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EETree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "EETree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EETree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Down"
        self.j2ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Down")
        #if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Up"
        self.j2ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Up")
        #if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Down"
        self.j2ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Down")
        #if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Up"
        self.j2ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Up")
        #if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Down"
        self.j2ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Down")
        #if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Up"
        self.j2ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Up")
        #if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalDown"
        self.j2ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalUp"
        self.j2ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleDown"
        self.j2ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleUp"
        self.j2ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch j2ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "EETree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csvWoNoisyJets"
        self.jb1csvWoNoisyJets_branch = the_tree.GetBranch("jb1csvWoNoisyJets")
        #if not self.jb1csvWoNoisyJets_branch and "jb1csvWoNoisyJets" not in self.complained:
        if not self.jb1csvWoNoisyJets_branch and "jb1csvWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csvWoNoisyJets")
        else:
            self.jb1csvWoNoisyJets_branch.SetAddress(<void*>&self.jb1csvWoNoisyJets_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "EETree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1etaWoNoisyJets"
        self.jb1etaWoNoisyJets_branch = the_tree.GetBranch("jb1etaWoNoisyJets")
        #if not self.jb1etaWoNoisyJets_branch and "jb1etaWoNoisyJets" not in self.complained:
        if not self.jb1etaWoNoisyJets_branch and "jb1etaWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1etaWoNoisyJets")
        else:
            self.jb1etaWoNoisyJets_branch.SetAddress(<void*>&self.jb1etaWoNoisyJets_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "EETree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavorWoNoisyJets"
        self.jb1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("jb1hadronflavorWoNoisyJets")
        #if not self.jb1hadronflavorWoNoisyJets_branch and "jb1hadronflavorWoNoisyJets" not in self.complained:
        if not self.jb1hadronflavorWoNoisyJets_branch and "jb1hadronflavorWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavorWoNoisyJets")
        else:
            self.jb1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.jb1hadronflavorWoNoisyJets_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "EETree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phiWoNoisyJets"
        self.jb1phiWoNoisyJets_branch = the_tree.GetBranch("jb1phiWoNoisyJets")
        #if not self.jb1phiWoNoisyJets_branch and "jb1phiWoNoisyJets" not in self.complained:
        if not self.jb1phiWoNoisyJets_branch and "jb1phiWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phiWoNoisyJets")
        else:
            self.jb1phiWoNoisyJets_branch.SetAddress(<void*>&self.jb1phiWoNoisyJets_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "EETree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptWoNoisyJets"
        self.jb1ptWoNoisyJets_branch = the_tree.GetBranch("jb1ptWoNoisyJets")
        #if not self.jb1ptWoNoisyJets_branch and "jb1ptWoNoisyJets" not in self.complained:
        if not self.jb1ptWoNoisyJets_branch and "jb1ptWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptWoNoisyJets")
        else:
            self.jb1ptWoNoisyJets_branch.SetAddress(<void*>&self.jb1ptWoNoisyJets_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "EETree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csvWoNoisyJets"
        self.jb2csvWoNoisyJets_branch = the_tree.GetBranch("jb2csvWoNoisyJets")
        #if not self.jb2csvWoNoisyJets_branch and "jb2csvWoNoisyJets" not in self.complained:
        if not self.jb2csvWoNoisyJets_branch and "jb2csvWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csvWoNoisyJets")
        else:
            self.jb2csvWoNoisyJets_branch.SetAddress(<void*>&self.jb2csvWoNoisyJets_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "EETree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2etaWoNoisyJets"
        self.jb2etaWoNoisyJets_branch = the_tree.GetBranch("jb2etaWoNoisyJets")
        #if not self.jb2etaWoNoisyJets_branch and "jb2etaWoNoisyJets" not in self.complained:
        if not self.jb2etaWoNoisyJets_branch and "jb2etaWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2etaWoNoisyJets")
        else:
            self.jb2etaWoNoisyJets_branch.SetAddress(<void*>&self.jb2etaWoNoisyJets_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "EETree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavorWoNoisyJets"
        self.jb2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("jb2hadronflavorWoNoisyJets")
        #if not self.jb2hadronflavorWoNoisyJets_branch and "jb2hadronflavorWoNoisyJets" not in self.complained:
        if not self.jb2hadronflavorWoNoisyJets_branch and "jb2hadronflavorWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavorWoNoisyJets")
        else:
            self.jb2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.jb2hadronflavorWoNoisyJets_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "EETree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phiWoNoisyJets"
        self.jb2phiWoNoisyJets_branch = the_tree.GetBranch("jb2phiWoNoisyJets")
        #if not self.jb2phiWoNoisyJets_branch and "jb2phiWoNoisyJets" not in self.complained:
        if not self.jb2phiWoNoisyJets_branch and "jb2phiWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phiWoNoisyJets")
        else:
            self.jb2phiWoNoisyJets_branch.SetAddress(<void*>&self.jb2phiWoNoisyJets_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "EETree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptWoNoisyJets"
        self.jb2ptWoNoisyJets_branch = the_tree.GetBranch("jb2ptWoNoisyJets")
        #if not self.jb2ptWoNoisyJets_branch and "jb2ptWoNoisyJets" not in self.complained:
        if not self.jb2ptWoNoisyJets_branch and "jb2ptWoNoisyJets":
            warnings.warn( "EETree: Expected branch jb2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptWoNoisyJets")
        else:
            self.jb2ptWoNoisyJets_branch.SetAddress(<void*>&self.jb2ptWoNoisyJets_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EETree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "EETree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EETree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EETree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EETree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Down"
        self.jetVeto30WoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Up"
        self.jetVeto30WoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Down"
        self.jetVeto30WoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Up"
        self.jetVeto30WoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Down"
        self.jetVeto30WoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Up"
        self.jetVeto30WoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalDownWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets"
        self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch and "jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalUpWoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleDown"
        self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleUp"
        self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value)

        #print "making jetVeto30WoNoisyJets_JetTotalDown"
        self.jetVeto30WoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalDown")
        #if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalDown")
        else:
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalDown_value)

        #print "making jetVeto30WoNoisyJets_JetTotalUp"
        self.jetVeto30WoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalUp")
        #if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp":
            warnings.warn( "EETree: Expected branch jetVeto30WoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalUp")
        else:
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalUp_value)

        #print "making jetVeto30_JetAbsoluteFlavMapDown"
        self.jetVeto30_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30_JetAbsoluteFlavMapUp"
        self.jetVeto30_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasDown"
        self.jetVeto30_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasUp"
        self.jetVeto30_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30_JetAbsoluteScaleDown"
        self.jetVeto30_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleDown")
        #if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleDown")
        else:
            self.jetVeto30_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleDown_value)

        #print "making jetVeto30_JetAbsoluteScaleUp"
        self.jetVeto30_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleUp")
        #if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleUp")
        else:
            self.jetVeto30_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleUp_value)

        #print "making jetVeto30_JetAbsoluteStatDown"
        self.jetVeto30_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatDown")
        #if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatDown")
        else:
            self.jetVeto30_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatDown_value)

        #print "making jetVeto30_JetAbsoluteStatUp"
        self.jetVeto30_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatUp")
        #if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatUp")
        else:
            self.jetVeto30_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatUp_value)

        #print "making jetVeto30_JetClosureDown"
        self.jetVeto30_JetClosureDown_branch = the_tree.GetBranch("jetVeto30_JetClosureDown")
        #if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown" not in self.complained:
        if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureDown")
        else:
            self.jetVeto30_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30_JetClosureDown_value)

        #print "making jetVeto30_JetClosureUp"
        self.jetVeto30_JetClosureUp_branch = the_tree.GetBranch("jetVeto30_JetClosureUp")
        #if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp" not in self.complained:
        if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureUp")
        else:
            self.jetVeto30_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30_JetClosureUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making jetVeto30_JetEta0to3Down"
        self.jetVeto30_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30_JetEta0to3Down")
        #if not self.jetVeto30_JetEta0to3Down_branch and "jetVeto30_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30_JetEta0to3Down_branch and "jetVeto30_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to3Down")
        else:
            self.jetVeto30_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to3Down_value)

        #print "making jetVeto30_JetEta0to3Up"
        self.jetVeto30_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30_JetEta0to3Up")
        #if not self.jetVeto30_JetEta0to3Up_branch and "jetVeto30_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30_JetEta0to3Up_branch and "jetVeto30_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to3Up")
        else:
            self.jetVeto30_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to3Up_value)

        #print "making jetVeto30_JetEta0to5Down"
        self.jetVeto30_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30_JetEta0to5Down")
        #if not self.jetVeto30_JetEta0to5Down_branch and "jetVeto30_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30_JetEta0to5Down_branch and "jetVeto30_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to5Down")
        else:
            self.jetVeto30_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to5Down_value)

        #print "making jetVeto30_JetEta0to5Up"
        self.jetVeto30_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30_JetEta0to5Up")
        #if not self.jetVeto30_JetEta0to5Up_branch and "jetVeto30_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30_JetEta0to5Up_branch and "jetVeto30_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta0to5Up")
        else:
            self.jetVeto30_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta0to5Up_value)

        #print "making jetVeto30_JetEta3to5Down"
        self.jetVeto30_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30_JetEta3to5Down")
        #if not self.jetVeto30_JetEta3to5Down_branch and "jetVeto30_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30_JetEta3to5Down_branch and "jetVeto30_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta3to5Down")
        else:
            self.jetVeto30_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30_JetEta3to5Down_value)

        #print "making jetVeto30_JetEta3to5Up"
        self.jetVeto30_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30_JetEta3to5Up")
        #if not self.jetVeto30_JetEta3to5Up_branch and "jetVeto30_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30_JetEta3to5Up_branch and "jetVeto30_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEta3to5Up")
        else:
            self.jetVeto30_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30_JetEta3to5Up_value)

        #print "making jetVeto30_JetFlavorQCDDown"
        self.jetVeto30_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDDown")
        #if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDDown")
        else:
            self.jetVeto30_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDDown_value)

        #print "making jetVeto30_JetFlavorQCDUp"
        self.jetVeto30_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDUp")
        #if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDUp")
        else:
            self.jetVeto30_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDUp_value)

        #print "making jetVeto30_JetFragmentationDown"
        self.jetVeto30_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30_JetFragmentationDown")
        #if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationDown")
        else:
            self.jetVeto30_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationDown_value)

        #print "making jetVeto30_JetFragmentationUp"
        self.jetVeto30_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30_JetFragmentationUp")
        #if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationUp")
        else:
            self.jetVeto30_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationUp_value)

        #print "making jetVeto30_JetPileUpDataMCDown"
        self.jetVeto30_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCDown")
        #if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCDown")
        else:
            self.jetVeto30_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCDown_value)

        #print "making jetVeto30_JetPileUpDataMCUp"
        self.jetVeto30_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCUp")
        #if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCUp")
        else:
            self.jetVeto30_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCUp_value)

        #print "making jetVeto30_JetPileUpPtBBDown"
        self.jetVeto30_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBDown")
        #if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBDown")
        else:
            self.jetVeto30_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBDown_value)

        #print "making jetVeto30_JetPileUpPtBBUp"
        self.jetVeto30_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBUp")
        #if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBUp")
        else:
            self.jetVeto30_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBUp_value)

        #print "making jetVeto30_JetPileUpPtEC1Down"
        self.jetVeto30_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Down")
        #if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Down")
        else:
            self.jetVeto30_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Down_value)

        #print "making jetVeto30_JetPileUpPtEC1Up"
        self.jetVeto30_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Up")
        #if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Up")
        else:
            self.jetVeto30_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Up_value)

        #print "making jetVeto30_JetPileUpPtEC2Down"
        self.jetVeto30_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Down")
        #if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Down")
        else:
            self.jetVeto30_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Down_value)

        #print "making jetVeto30_JetPileUpPtEC2Up"
        self.jetVeto30_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Up")
        #if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Up")
        else:
            self.jetVeto30_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Up_value)

        #print "making jetVeto30_JetPileUpPtHFDown"
        self.jetVeto30_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFDown")
        #if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFDown")
        else:
            self.jetVeto30_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFDown_value)

        #print "making jetVeto30_JetPileUpPtHFUp"
        self.jetVeto30_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFUp")
        #if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFUp")
        else:
            self.jetVeto30_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFUp_value)

        #print "making jetVeto30_JetPileUpPtRefDown"
        self.jetVeto30_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefDown")
        #if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefDown")
        else:
            self.jetVeto30_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefDown_value)

        #print "making jetVeto30_JetPileUpPtRefUp"
        self.jetVeto30_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefUp")
        #if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefUp")
        else:
            self.jetVeto30_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefUp_value)

        #print "making jetVeto30_JetRelativeBalDown"
        self.jetVeto30_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalDown")
        #if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalDown")
        else:
            self.jetVeto30_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalDown_value)

        #print "making jetVeto30_JetRelativeBalUp"
        self.jetVeto30_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalUp")
        #if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalUp")
        else:
            self.jetVeto30_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalUp_value)

        #print "making jetVeto30_JetRelativeFSRDown"
        self.jetVeto30_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRDown")
        #if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRDown")
        else:
            self.jetVeto30_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRDown_value)

        #print "making jetVeto30_JetRelativeFSRUp"
        self.jetVeto30_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRUp")
        #if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRUp")
        else:
            self.jetVeto30_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRUp_value)

        #print "making jetVeto30_JetRelativeJEREC1Down"
        self.jetVeto30_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Down")
        #if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Down")
        else:
            self.jetVeto30_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Down_value)

        #print "making jetVeto30_JetRelativeJEREC1Up"
        self.jetVeto30_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Up")
        #if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Up")
        else:
            self.jetVeto30_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Up_value)

        #print "making jetVeto30_JetRelativeJEREC2Down"
        self.jetVeto30_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Down")
        #if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Down")
        else:
            self.jetVeto30_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Down_value)

        #print "making jetVeto30_JetRelativeJEREC2Up"
        self.jetVeto30_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Up")
        #if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Up")
        else:
            self.jetVeto30_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Up_value)

        #print "making jetVeto30_JetRelativeJERHFDown"
        self.jetVeto30_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFDown")
        #if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFDown")
        else:
            self.jetVeto30_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFDown_value)

        #print "making jetVeto30_JetRelativeJERHFUp"
        self.jetVeto30_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFUp")
        #if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFUp")
        else:
            self.jetVeto30_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFUp_value)

        #print "making jetVeto30_JetRelativePtBBDown"
        self.jetVeto30_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBDown")
        #if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBDown")
        else:
            self.jetVeto30_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBDown_value)

        #print "making jetVeto30_JetRelativePtBBUp"
        self.jetVeto30_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBUp")
        #if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBUp")
        else:
            self.jetVeto30_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBUp_value)

        #print "making jetVeto30_JetRelativePtEC1Down"
        self.jetVeto30_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Down")
        #if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Down")
        else:
            self.jetVeto30_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Down_value)

        #print "making jetVeto30_JetRelativePtEC1Up"
        self.jetVeto30_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Up")
        #if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Up")
        else:
            self.jetVeto30_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Up_value)

        #print "making jetVeto30_JetRelativePtEC2Down"
        self.jetVeto30_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Down")
        #if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Down")
        else:
            self.jetVeto30_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Down_value)

        #print "making jetVeto30_JetRelativePtEC2Up"
        self.jetVeto30_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Up")
        #if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Up")
        else:
            self.jetVeto30_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Up_value)

        #print "making jetVeto30_JetRelativePtHFDown"
        self.jetVeto30_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFDown")
        #if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFDown")
        else:
            self.jetVeto30_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFDown_value)

        #print "making jetVeto30_JetRelativePtHFUp"
        self.jetVeto30_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFUp")
        #if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFUp")
        else:
            self.jetVeto30_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFUp_value)

        #print "making jetVeto30_JetRelativeSampleDown"
        self.jetVeto30_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeSampleDown")
        #if not self.jetVeto30_JetRelativeSampleDown_branch and "jetVeto30_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30_JetRelativeSampleDown_branch and "jetVeto30_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeSampleDown")
        else:
            self.jetVeto30_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeSampleDown_value)

        #print "making jetVeto30_JetRelativeSampleUp"
        self.jetVeto30_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeSampleUp")
        #if not self.jetVeto30_JetRelativeSampleUp_branch and "jetVeto30_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30_JetRelativeSampleUp_branch and "jetVeto30_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeSampleUp")
        else:
            self.jetVeto30_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeSampleUp_value)

        #print "making jetVeto30_JetRelativeStatECDown"
        self.jetVeto30_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECDown")
        #if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECDown")
        else:
            self.jetVeto30_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECDown_value)

        #print "making jetVeto30_JetRelativeStatECUp"
        self.jetVeto30_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECUp")
        #if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECUp")
        else:
            self.jetVeto30_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECUp_value)

        #print "making jetVeto30_JetRelativeStatFSRDown"
        self.jetVeto30_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRDown")
        #if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRDown")
        else:
            self.jetVeto30_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRDown_value)

        #print "making jetVeto30_JetRelativeStatFSRUp"
        self.jetVeto30_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRUp")
        #if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRUp")
        else:
            self.jetVeto30_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRUp_value)

        #print "making jetVeto30_JetRelativeStatHFDown"
        self.jetVeto30_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFDown")
        #if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFDown")
        else:
            self.jetVeto30_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFDown_value)

        #print "making jetVeto30_JetRelativeStatHFUp"
        self.jetVeto30_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFUp")
        #if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFUp")
        else:
            self.jetVeto30_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFUp_value)

        #print "making jetVeto30_JetSinglePionECALDown"
        self.jetVeto30_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALDown")
        #if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALDown")
        else:
            self.jetVeto30_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALDown_value)

        #print "making jetVeto30_JetSinglePionECALUp"
        self.jetVeto30_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALUp")
        #if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALUp")
        else:
            self.jetVeto30_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALUp_value)

        #print "making jetVeto30_JetSinglePionHCALDown"
        self.jetVeto30_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALDown")
        #if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALDown")
        else:
            self.jetVeto30_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALDown_value)

        #print "making jetVeto30_JetSinglePionHCALUp"
        self.jetVeto30_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALUp")
        #if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALUp")
        else:
            self.jetVeto30_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALUp_value)

        #print "making jetVeto30_JetTimePtEtaDown"
        self.jetVeto30_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaDown")
        #if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaDown")
        else:
            self.jetVeto30_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaDown_value)

        #print "making jetVeto30_JetTimePtEtaUp"
        self.jetVeto30_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaUp")
        #if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaUp")
        else:
            self.jetVeto30_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaUp_value)

        #print "making jetVeto30_JetTotalDown"
        self.jetVeto30_JetTotalDown_branch = the_tree.GetBranch("jetVeto30_JetTotalDown")
        #if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown" not in self.complained:
        if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown":
            warnings.warn( "EETree: Expected branch jetVeto30_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalDown")
        else:
            self.jetVeto30_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30_JetTotalDown_value)

        #print "making jetVeto30_JetTotalUp"
        self.jetVeto30_JetTotalUp_branch = the_tree.GetBranch("jetVeto30_JetTotalUp")
        #if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp" not in self.complained:
        if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp":
            warnings.warn( "EETree: Expected branch jetVeto30_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalUp")
        else:
            self.jetVeto30_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30_JetTotalUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EETree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EETree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EETree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov00_DESYlike"
        self.metcov00_DESYlike_branch = the_tree.GetBranch("metcov00_DESYlike")
        #if not self.metcov00_DESYlike_branch and "metcov00_DESYlike" not in self.complained:
        if not self.metcov00_DESYlike_branch and "metcov00_DESYlike":
            warnings.warn( "EETree: Expected branch metcov00_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00_DESYlike")
        else:
            self.metcov00_DESYlike_branch.SetAddress(<void*>&self.metcov00_DESYlike_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EETree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov01_DESYlike"
        self.metcov01_DESYlike_branch = the_tree.GetBranch("metcov01_DESYlike")
        #if not self.metcov01_DESYlike_branch and "metcov01_DESYlike" not in self.complained:
        if not self.metcov01_DESYlike_branch and "metcov01_DESYlike":
            warnings.warn( "EETree: Expected branch metcov01_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01_DESYlike")
        else:
            self.metcov01_DESYlike_branch.SetAddress(<void*>&self.metcov01_DESYlike_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EETree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov10_DESYlike"
        self.metcov10_DESYlike_branch = the_tree.GetBranch("metcov10_DESYlike")
        #if not self.metcov10_DESYlike_branch and "metcov10_DESYlike" not in self.complained:
        if not self.metcov10_DESYlike_branch and "metcov10_DESYlike":
            warnings.warn( "EETree: Expected branch metcov10_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10_DESYlike")
        else:
            self.metcov10_DESYlike_branch.SetAddress(<void*>&self.metcov10_DESYlike_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EETree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov11_DESYlike"
        self.metcov11_DESYlike_branch = the_tree.GetBranch("metcov11_DESYlike")
        #if not self.metcov11_DESYlike_branch and "metcov11_DESYlike" not in self.complained:
        if not self.metcov11_DESYlike_branch and "metcov11_DESYlike":
            warnings.warn( "EETree: Expected branch metcov11_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11_DESYlike")
        else:
            self.metcov11_DESYlike_branch.SetAddress(<void*>&self.metcov11_DESYlike_value)

        #print "making mu12e23DZGroup"
        self.mu12e23DZGroup_branch = the_tree.GetBranch("mu12e23DZGroup")
        #if not self.mu12e23DZGroup_branch and "mu12e23DZGroup" not in self.complained:
        if not self.mu12e23DZGroup_branch and "mu12e23DZGroup":
            warnings.warn( "EETree: Expected branch mu12e23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZGroup")
        else:
            self.mu12e23DZGroup_branch.SetAddress(<void*>&self.mu12e23DZGroup_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "EETree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23DZPrescale"
        self.mu12e23DZPrescale_branch = the_tree.GetBranch("mu12e23DZPrescale")
        #if not self.mu12e23DZPrescale_branch and "mu12e23DZPrescale" not in self.complained:
        if not self.mu12e23DZPrescale_branch and "mu12e23DZPrescale":
            warnings.warn( "EETree: Expected branch mu12e23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPrescale")
        else:
            self.mu12e23DZPrescale_branch.SetAddress(<void*>&self.mu12e23DZPrescale_value)

        #print "making mu12e23Group"
        self.mu12e23Group_branch = the_tree.GetBranch("mu12e23Group")
        #if not self.mu12e23Group_branch and "mu12e23Group" not in self.complained:
        if not self.mu12e23Group_branch and "mu12e23Group":
            warnings.warn( "EETree: Expected branch mu12e23Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Group")
        else:
            self.mu12e23Group_branch.SetAddress(<void*>&self.mu12e23Group_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "EETree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu12e23Prescale"
        self.mu12e23Prescale_branch = the_tree.GetBranch("mu12e23Prescale")
        #if not self.mu12e23Prescale_branch and "mu12e23Prescale" not in self.complained:
        if not self.mu12e23Prescale_branch and "mu12e23Prescale":
            warnings.warn( "EETree: Expected branch mu12e23Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Prescale")
        else:
            self.mu12e23Prescale_branch.SetAddress(<void*>&self.mu12e23Prescale_value)

        #print "making mu23e12DZGroup"
        self.mu23e12DZGroup_branch = the_tree.GetBranch("mu23e12DZGroup")
        #if not self.mu23e12DZGroup_branch and "mu23e12DZGroup" not in self.complained:
        if not self.mu23e12DZGroup_branch and "mu23e12DZGroup":
            warnings.warn( "EETree: Expected branch mu23e12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZGroup")
        else:
            self.mu23e12DZGroup_branch.SetAddress(<void*>&self.mu23e12DZGroup_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "EETree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12DZPrescale"
        self.mu23e12DZPrescale_branch = the_tree.GetBranch("mu23e12DZPrescale")
        #if not self.mu23e12DZPrescale_branch and "mu23e12DZPrescale" not in self.complained:
        if not self.mu23e12DZPrescale_branch and "mu23e12DZPrescale":
            warnings.warn( "EETree: Expected branch mu23e12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPrescale")
        else:
            self.mu23e12DZPrescale_branch.SetAddress(<void*>&self.mu23e12DZPrescale_value)

        #print "making mu23e12Group"
        self.mu23e12Group_branch = the_tree.GetBranch("mu23e12Group")
        #if not self.mu23e12Group_branch and "mu23e12Group" not in self.complained:
        if not self.mu23e12Group_branch and "mu23e12Group":
            warnings.warn( "EETree: Expected branch mu23e12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Group")
        else:
            self.mu23e12Group_branch.SetAddress(<void*>&self.mu23e12Group_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "EETree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu23e12Prescale"
        self.mu23e12Prescale_branch = the_tree.GetBranch("mu23e12Prescale")
        #if not self.mu23e12Prescale_branch and "mu23e12Prescale" not in self.complained:
        if not self.mu23e12Prescale_branch and "mu23e12Prescale":
            warnings.warn( "EETree: Expected branch mu23e12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Prescale")
        else:
            self.mu23e12Prescale_branch.SetAddress(<void*>&self.mu23e12Prescale_value)

        #print "making mu8e23DZGroup"
        self.mu8e23DZGroup_branch = the_tree.GetBranch("mu8e23DZGroup")
        #if not self.mu8e23DZGroup_branch and "mu8e23DZGroup" not in self.complained:
        if not self.mu8e23DZGroup_branch and "mu8e23DZGroup":
            warnings.warn( "EETree: Expected branch mu8e23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZGroup")
        else:
            self.mu8e23DZGroup_branch.SetAddress(<void*>&self.mu8e23DZGroup_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "EETree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23DZPrescale"
        self.mu8e23DZPrescale_branch = the_tree.GetBranch("mu8e23DZPrescale")
        #if not self.mu8e23DZPrescale_branch and "mu8e23DZPrescale" not in self.complained:
        if not self.mu8e23DZPrescale_branch and "mu8e23DZPrescale":
            warnings.warn( "EETree: Expected branch mu8e23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPrescale")
        else:
            self.mu8e23DZPrescale_branch.SetAddress(<void*>&self.mu8e23DZPrescale_value)

        #print "making mu8e23Group"
        self.mu8e23Group_branch = the_tree.GetBranch("mu8e23Group")
        #if not self.mu8e23Group_branch and "mu8e23Group" not in self.complained:
        if not self.mu8e23Group_branch and "mu8e23Group":
            warnings.warn( "EETree: Expected branch mu8e23Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Group")
        else:
            self.mu8e23Group_branch.SetAddress(<void*>&self.mu8e23Group_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "EETree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making mu8e23Prescale"
        self.mu8e23Prescale_branch = the_tree.GetBranch("mu8e23Prescale")
        #if not self.mu8e23Prescale_branch and "mu8e23Prescale" not in self.complained:
        if not self.mu8e23Prescale_branch and "mu8e23Prescale":
            warnings.warn( "EETree: Expected branch mu8e23Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Prescale")
        else:
            self.mu8e23Prescale_branch.SetAddress(<void*>&self.mu8e23Prescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EETree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EETree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "EETree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EETree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "EETree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EETree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EETree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EETree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EETree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EETree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EETree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EETree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EETree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EETree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EETree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EETree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EETree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EETree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EETree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EETree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EETree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EETree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "EETree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "EETree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EETree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EETree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EETree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EETree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EETree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EETree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EETree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EETree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "EETree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EETree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "EETree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMu12_10_5Group"
        self.tripleMu12_10_5Group_branch = the_tree.GetBranch("tripleMu12_10_5Group")
        #if not self.tripleMu12_10_5Group_branch and "tripleMu12_10_5Group" not in self.complained:
        if not self.tripleMu12_10_5Group_branch and "tripleMu12_10_5Group":
            warnings.warn( "EETree: Expected branch tripleMu12_10_5Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Group")
        else:
            self.tripleMu12_10_5Group_branch.SetAddress(<void*>&self.tripleMu12_10_5Group_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "EETree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making tripleMu12_10_5Prescale"
        self.tripleMu12_10_5Prescale_branch = the_tree.GetBranch("tripleMu12_10_5Prescale")
        #if not self.tripleMu12_10_5Prescale_branch and "tripleMu12_10_5Prescale" not in self.complained:
        if not self.tripleMu12_10_5Prescale_branch and "tripleMu12_10_5Prescale":
            warnings.warn( "EETree: Expected branch tripleMu12_10_5Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Prescale")
        else:
            self.tripleMu12_10_5Prescale_branch.SetAddress(<void*>&self.tripleMu12_10_5Prescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EETree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EETree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_AbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_AbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_AbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_AbsoluteFlavMapDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_AbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_AbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPhi_AbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_AbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_AbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_AbsoluteFlavMapUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_AbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_AbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureDown"
        self.type1_pfMet_shiftedPhi_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureDown")
        #if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureUp"
        self.type1_pfMet_shiftedPhi_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureUp")
        #if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Down"
        self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Up"
        self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Down"
        self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Up"
        self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Down"
        self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Up"
        self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationDown"
        self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationUp"
        self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalDown"
        self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalUp"
        self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalDown"
        self.type1_pfMet_shiftedPhi_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalDown")
        #if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalUp"
        self.type1_pfMet_shiftedPhi_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalUp")
        #if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_AbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_AbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_AbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_AbsoluteFlavMapDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_AbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_AbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPt_AbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_AbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_AbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_AbsoluteFlavMapUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_AbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_AbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPt_AbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_AbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_AbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_AbsoluteMPFBiasDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_AbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_AbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPt_AbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_AbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_AbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_AbsoluteMPFBiasUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_AbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_AbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPt_JetClosureDown"
        self.type1_pfMet_shiftedPt_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureDown")
        #if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPt_JetClosureUp"
        self.type1_pfMet_shiftedPt_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureUp")
        #if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Down"
        self.type1_pfMet_shiftedPt_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Up"
        self.type1_pfMet_shiftedPt_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Down"
        self.type1_pfMet_shiftedPt_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Up"
        self.type1_pfMet_shiftedPt_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Down"
        self.type1_pfMet_shiftedPt_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Up"
        self.type1_pfMet_shiftedPt_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationDown"
        self.type1_pfMet_shiftedPt_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationUp"
        self.type1_pfMet_shiftedPt_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalDown"
        self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalUp"
        self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPt_JetTotalDown"
        self.type1_pfMet_shiftedPt_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalDown")
        #if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPt_JetTotalUp"
        self.type1_pfMet_shiftedPt_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalUp")
        #if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "EETree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EETree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EETree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EETree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EETree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Down"
        self.vbfMassWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Up"
        self.vbfMassWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Down"
        self.vbfMassWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Up"
        self.vbfMassWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Up_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Down"
        self.vbfMassWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Up"
        self.vbfMassWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalDown"
        self.vbfMassWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalUp"
        self.vbfMassWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleDown"
        self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleUp"
        self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleUp_value)

        #print "making vbfMassWoNoisyJets_JetTotalDown"
        self.vbfMassWoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalDown")
        #if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalDown")
        else:
            self.vbfMassWoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalDown_value)

        #print "making vbfMassWoNoisyJets_JetTotalUp"
        self.vbfMassWoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalUp")
        #if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp":
            warnings.warn( "EETree: Expected branch vbfMassWoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalUp")
        else:
            self.vbfMassWoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalUp_value)

        #print "making vbfMass_JetAbsoluteFlavMapDown"
        self.vbfMass_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapDown")
        #if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapDown")
        else:
            self.vbfMass_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapDown_value)

        #print "making vbfMass_JetAbsoluteFlavMapUp"
        self.vbfMass_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapUp")
        #if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapUp")
        else:
            self.vbfMass_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapUp_value)

        #print "making vbfMass_JetAbsoluteMPFBiasDown"
        self.vbfMass_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasDown")
        #if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMass_JetAbsoluteMPFBiasUp"
        self.vbfMass_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasUp")
        #if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMass_JetAbsoluteScaleDown"
        self.vbfMass_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleDown")
        #if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleDown")
        else:
            self.vbfMass_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleDown_value)

        #print "making vbfMass_JetAbsoluteScaleUp"
        self.vbfMass_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleUp")
        #if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleUp")
        else:
            self.vbfMass_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleUp_value)

        #print "making vbfMass_JetAbsoluteStatDown"
        self.vbfMass_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatDown")
        #if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatDown")
        else:
            self.vbfMass_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatDown_value)

        #print "making vbfMass_JetAbsoluteStatUp"
        self.vbfMass_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatUp")
        #if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatUp")
        else:
            self.vbfMass_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatUp_value)

        #print "making vbfMass_JetClosureDown"
        self.vbfMass_JetClosureDown_branch = the_tree.GetBranch("vbfMass_JetClosureDown")
        #if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown" not in self.complained:
        if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureDown")
        else:
            self.vbfMass_JetClosureDown_branch.SetAddress(<void*>&self.vbfMass_JetClosureDown_value)

        #print "making vbfMass_JetClosureUp"
        self.vbfMass_JetClosureUp_branch = the_tree.GetBranch("vbfMass_JetClosureUp")
        #if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp" not in self.complained:
        if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureUp")
        else:
            self.vbfMass_JetClosureUp_branch.SetAddress(<void*>&self.vbfMass_JetClosureUp_value)

        #print "making vbfMass_JetEta0to3Down"
        self.vbfMass_JetEta0to3Down_branch = the_tree.GetBranch("vbfMass_JetEta0to3Down")
        #if not self.vbfMass_JetEta0to3Down_branch and "vbfMass_JetEta0to3Down" not in self.complained:
        if not self.vbfMass_JetEta0to3Down_branch and "vbfMass_JetEta0to3Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to3Down")
        else:
            self.vbfMass_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMass_JetEta0to3Down_value)

        #print "making vbfMass_JetEta0to3Up"
        self.vbfMass_JetEta0to3Up_branch = the_tree.GetBranch("vbfMass_JetEta0to3Up")
        #if not self.vbfMass_JetEta0to3Up_branch and "vbfMass_JetEta0to3Up" not in self.complained:
        if not self.vbfMass_JetEta0to3Up_branch and "vbfMass_JetEta0to3Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to3Up")
        else:
            self.vbfMass_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMass_JetEta0to3Up_value)

        #print "making vbfMass_JetEta0to5Down"
        self.vbfMass_JetEta0to5Down_branch = the_tree.GetBranch("vbfMass_JetEta0to5Down")
        #if not self.vbfMass_JetEta0to5Down_branch and "vbfMass_JetEta0to5Down" not in self.complained:
        if not self.vbfMass_JetEta0to5Down_branch and "vbfMass_JetEta0to5Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to5Down")
        else:
            self.vbfMass_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMass_JetEta0to5Down_value)

        #print "making vbfMass_JetEta0to5Up"
        self.vbfMass_JetEta0to5Up_branch = the_tree.GetBranch("vbfMass_JetEta0to5Up")
        #if not self.vbfMass_JetEta0to5Up_branch and "vbfMass_JetEta0to5Up" not in self.complained:
        if not self.vbfMass_JetEta0to5Up_branch and "vbfMass_JetEta0to5Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta0to5Up")
        else:
            self.vbfMass_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMass_JetEta0to5Up_value)

        #print "making vbfMass_JetEta3to5Down"
        self.vbfMass_JetEta3to5Down_branch = the_tree.GetBranch("vbfMass_JetEta3to5Down")
        #if not self.vbfMass_JetEta3to5Down_branch and "vbfMass_JetEta3to5Down" not in self.complained:
        if not self.vbfMass_JetEta3to5Down_branch and "vbfMass_JetEta3to5Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta3to5Down")
        else:
            self.vbfMass_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMass_JetEta3to5Down_value)

        #print "making vbfMass_JetEta3to5Up"
        self.vbfMass_JetEta3to5Up_branch = the_tree.GetBranch("vbfMass_JetEta3to5Up")
        #if not self.vbfMass_JetEta3to5Up_branch and "vbfMass_JetEta3to5Up" not in self.complained:
        if not self.vbfMass_JetEta3to5Up_branch and "vbfMass_JetEta3to5Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEta3to5Up")
        else:
            self.vbfMass_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMass_JetEta3to5Up_value)

        #print "making vbfMass_JetFlavorQCDDown"
        self.vbfMass_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDDown")
        #if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDDown")
        else:
            self.vbfMass_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDDown_value)

        #print "making vbfMass_JetFlavorQCDUp"
        self.vbfMass_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDUp")
        #if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDUp")
        else:
            self.vbfMass_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDUp_value)

        #print "making vbfMass_JetFragmentationDown"
        self.vbfMass_JetFragmentationDown_branch = the_tree.GetBranch("vbfMass_JetFragmentationDown")
        #if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown" not in self.complained:
        if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationDown")
        else:
            self.vbfMass_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationDown_value)

        #print "making vbfMass_JetFragmentationUp"
        self.vbfMass_JetFragmentationUp_branch = the_tree.GetBranch("vbfMass_JetFragmentationUp")
        #if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp" not in self.complained:
        if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationUp")
        else:
            self.vbfMass_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationUp_value)

        #print "making vbfMass_JetPileUpDataMCDown"
        self.vbfMass_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCDown")
        #if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCDown")
        else:
            self.vbfMass_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCDown_value)

        #print "making vbfMass_JetPileUpDataMCUp"
        self.vbfMass_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCUp")
        #if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCUp")
        else:
            self.vbfMass_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCUp_value)

        #print "making vbfMass_JetPileUpPtBBDown"
        self.vbfMass_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBDown")
        #if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBDown")
        else:
            self.vbfMass_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBDown_value)

        #print "making vbfMass_JetPileUpPtBBUp"
        self.vbfMass_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBUp")
        #if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBUp")
        else:
            self.vbfMass_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBUp_value)

        #print "making vbfMass_JetPileUpPtEC1Down"
        self.vbfMass_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Down")
        #if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Down")
        else:
            self.vbfMass_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Down_value)

        #print "making vbfMass_JetPileUpPtEC1Up"
        self.vbfMass_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Up")
        #if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Up")
        else:
            self.vbfMass_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Up_value)

        #print "making vbfMass_JetPileUpPtEC2Down"
        self.vbfMass_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Down")
        #if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Down")
        else:
            self.vbfMass_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Down_value)

        #print "making vbfMass_JetPileUpPtEC2Up"
        self.vbfMass_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Up")
        #if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Up")
        else:
            self.vbfMass_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Up_value)

        #print "making vbfMass_JetPileUpPtHFDown"
        self.vbfMass_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFDown")
        #if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFDown")
        else:
            self.vbfMass_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFDown_value)

        #print "making vbfMass_JetPileUpPtHFUp"
        self.vbfMass_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFUp")
        #if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFUp")
        else:
            self.vbfMass_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFUp_value)

        #print "making vbfMass_JetPileUpPtRefDown"
        self.vbfMass_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefDown")
        #if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefDown")
        else:
            self.vbfMass_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefDown_value)

        #print "making vbfMass_JetPileUpPtRefUp"
        self.vbfMass_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefUp")
        #if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefUp")
        else:
            self.vbfMass_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefUp_value)

        #print "making vbfMass_JetRelativeBalDown"
        self.vbfMass_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMass_JetRelativeBalDown")
        #if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown" not in self.complained:
        if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalDown")
        else:
            self.vbfMass_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalDown_value)

        #print "making vbfMass_JetRelativeBalUp"
        self.vbfMass_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMass_JetRelativeBalUp")
        #if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp" not in self.complained:
        if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalUp")
        else:
            self.vbfMass_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalUp_value)

        #print "making vbfMass_JetRelativeFSRDown"
        self.vbfMass_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRDown")
        #if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRDown")
        else:
            self.vbfMass_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRDown_value)

        #print "making vbfMass_JetRelativeFSRUp"
        self.vbfMass_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRUp")
        #if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRUp")
        else:
            self.vbfMass_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRUp_value)

        #print "making vbfMass_JetRelativeJEREC1Down"
        self.vbfMass_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Down")
        #if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Down")
        else:
            self.vbfMass_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Down_value)

        #print "making vbfMass_JetRelativeJEREC1Up"
        self.vbfMass_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Up")
        #if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Up")
        else:
            self.vbfMass_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Up_value)

        #print "making vbfMass_JetRelativeJEREC2Down"
        self.vbfMass_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Down")
        #if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Down")
        else:
            self.vbfMass_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Down_value)

        #print "making vbfMass_JetRelativeJEREC2Up"
        self.vbfMass_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Up")
        #if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Up")
        else:
            self.vbfMass_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Up_value)

        #print "making vbfMass_JetRelativeJERHFDown"
        self.vbfMass_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFDown")
        #if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFDown")
        else:
            self.vbfMass_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFDown_value)

        #print "making vbfMass_JetRelativeJERHFUp"
        self.vbfMass_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFUp")
        #if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFUp")
        else:
            self.vbfMass_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFUp_value)

        #print "making vbfMass_JetRelativePtBBDown"
        self.vbfMass_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBDown")
        #if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBDown")
        else:
            self.vbfMass_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBDown_value)

        #print "making vbfMass_JetRelativePtBBUp"
        self.vbfMass_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBUp")
        #if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBUp")
        else:
            self.vbfMass_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBUp_value)

        #print "making vbfMass_JetRelativePtEC1Down"
        self.vbfMass_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Down")
        #if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Down")
        else:
            self.vbfMass_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Down_value)

        #print "making vbfMass_JetRelativePtEC1Up"
        self.vbfMass_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Up")
        #if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Up")
        else:
            self.vbfMass_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Up_value)

        #print "making vbfMass_JetRelativePtEC2Down"
        self.vbfMass_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Down")
        #if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Down")
        else:
            self.vbfMass_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Down_value)

        #print "making vbfMass_JetRelativePtEC2Up"
        self.vbfMass_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Up")
        #if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Up")
        else:
            self.vbfMass_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Up_value)

        #print "making vbfMass_JetRelativePtHFDown"
        self.vbfMass_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFDown")
        #if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFDown")
        else:
            self.vbfMass_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFDown_value)

        #print "making vbfMass_JetRelativePtHFUp"
        self.vbfMass_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFUp")
        #if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFUp")
        else:
            self.vbfMass_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFUp_value)

        #print "making vbfMass_JetRelativeSampleDown"
        self.vbfMass_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMass_JetRelativeSampleDown")
        #if not self.vbfMass_JetRelativeSampleDown_branch and "vbfMass_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMass_JetRelativeSampleDown_branch and "vbfMass_JetRelativeSampleDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeSampleDown")
        else:
            self.vbfMass_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeSampleDown_value)

        #print "making vbfMass_JetRelativeSampleUp"
        self.vbfMass_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMass_JetRelativeSampleUp")
        #if not self.vbfMass_JetRelativeSampleUp_branch and "vbfMass_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMass_JetRelativeSampleUp_branch and "vbfMass_JetRelativeSampleUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeSampleUp")
        else:
            self.vbfMass_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeSampleUp_value)

        #print "making vbfMass_JetRelativeStatECDown"
        self.vbfMass_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECDown")
        #if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECDown")
        else:
            self.vbfMass_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECDown_value)

        #print "making vbfMass_JetRelativeStatECUp"
        self.vbfMass_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECUp")
        #if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECUp")
        else:
            self.vbfMass_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECUp_value)

        #print "making vbfMass_JetRelativeStatFSRDown"
        self.vbfMass_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRDown")
        #if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRDown")
        else:
            self.vbfMass_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRDown_value)

        #print "making vbfMass_JetRelativeStatFSRUp"
        self.vbfMass_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRUp")
        #if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRUp")
        else:
            self.vbfMass_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRUp_value)

        #print "making vbfMass_JetRelativeStatHFDown"
        self.vbfMass_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFDown")
        #if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFDown")
        else:
            self.vbfMass_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFDown_value)

        #print "making vbfMass_JetRelativeStatHFUp"
        self.vbfMass_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFUp")
        #if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFUp")
        else:
            self.vbfMass_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFUp_value)

        #print "making vbfMass_JetSinglePionECALDown"
        self.vbfMass_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALDown")
        #if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALDown")
        else:
            self.vbfMass_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALDown_value)

        #print "making vbfMass_JetSinglePionECALUp"
        self.vbfMass_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALUp")
        #if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALUp")
        else:
            self.vbfMass_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALUp_value)

        #print "making vbfMass_JetSinglePionHCALDown"
        self.vbfMass_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALDown")
        #if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALDown")
        else:
            self.vbfMass_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALDown_value)

        #print "making vbfMass_JetSinglePionHCALUp"
        self.vbfMass_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALUp")
        #if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALUp")
        else:
            self.vbfMass_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALUp_value)

        #print "making vbfMass_JetTimePtEtaDown"
        self.vbfMass_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaDown")
        #if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaDown")
        else:
            self.vbfMass_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaDown_value)

        #print "making vbfMass_JetTimePtEtaUp"
        self.vbfMass_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaUp")
        #if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaUp")
        else:
            self.vbfMass_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaUp_value)

        #print "making vbfMass_JetTotalDown"
        self.vbfMass_JetTotalDown_branch = the_tree.GetBranch("vbfMass_JetTotalDown")
        #if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown" not in self.complained:
        if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown":
            warnings.warn( "EETree: Expected branch vbfMass_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalDown")
        else:
            self.vbfMass_JetTotalDown_branch.SetAddress(<void*>&self.vbfMass_JetTotalDown_value)

        #print "making vbfMass_JetTotalUp"
        self.vbfMass_JetTotalUp_branch = the_tree.GetBranch("vbfMass_JetTotalUp")
        #if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp" not in self.complained:
        if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp":
            warnings.warn( "EETree: Expected branch vbfMass_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalUp")
        else:
            self.vbfMass_JetTotalUp_branch.SetAddress(<void*>&self.vbfMass_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EETree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EETree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EETree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EETree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EETree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EETree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EETree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EETree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EETree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property DoubleMediumTau35Group:
        def __get__(self):
            self.DoubleMediumTau35Group_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35Group_value

    property DoubleMediumTau35Pass:
        def __get__(self):
            self.DoubleMediumTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35Pass_value

    property DoubleMediumTau35Prescale:
        def __get__(self):
            self.DoubleMediumTau35Prescale_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau35Prescale_value

    property DoubleMediumTau40Group:
        def __get__(self):
            self.DoubleMediumTau40Group_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40Group_value

    property DoubleMediumTau40Pass:
        def __get__(self):
            self.DoubleMediumTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40Pass_value

    property DoubleMediumTau40Prescale:
        def __get__(self):
            self.DoubleMediumTau40Prescale_branch.GetEntry(self.localentry, 0)
            return self.DoubleMediumTau40Prescale_value

    property DoubleTightTau35Group:
        def __get__(self):
            self.DoubleTightTau35Group_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35Group_value

    property DoubleTightTau35Pass:
        def __get__(self):
            self.DoubleTightTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35Pass_value

    property DoubleTightTau35Prescale:
        def __get__(self):
            self.DoubleTightTau35Prescale_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau35Prescale_value

    property DoubleTightTau40Group:
        def __get__(self):
            self.DoubleTightTau40Group_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40Group_value

    property DoubleTightTau40Pass:
        def __get__(self):
            self.DoubleTightTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40Pass_value

    property DoubleTightTau40Prescale:
        def __get__(self):
            self.DoubleTightTau40Prescale_branch.GetEntry(self.localentry, 0)
            return self.DoubleTightTau40Prescale_value

    property Ele24Tau30Group:
        def __get__(self):
            self.Ele24Tau30Group_branch.GetEntry(self.localentry, 0)
            return self.Ele24Tau30Group_value

    property Ele24Tau30Pass:
        def __get__(self):
            self.Ele24Tau30Pass_branch.GetEntry(self.localentry, 0)
            return self.Ele24Tau30Pass_value

    property Ele24Tau30Prescale:
        def __get__(self):
            self.Ele24Tau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.Ele24Tau30Prescale_value

    property Ele27WPTightGroup:
        def __get__(self):
            self.Ele27WPTightGroup_branch.GetEntry(self.localentry, 0)
            return self.Ele27WPTightGroup_value

    property Ele27WPTightPass:
        def __get__(self):
            self.Ele27WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele27WPTightPass_value

    property Ele27WPTightPrescale:
        def __get__(self):
            self.Ele27WPTightPrescale_branch.GetEntry(self.localentry, 0)
            return self.Ele27WPTightPrescale_value

    property Ele32WPTightGroup:
        def __get__(self):
            self.Ele32WPTightGroup_branch.GetEntry(self.localentry, 0)
            return self.Ele32WPTightGroup_value

    property Ele32WPTightPass:
        def __get__(self):
            self.Ele32WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele32WPTightPass_value

    property Ele32WPTightPrescale:
        def __get__(self):
            self.Ele32WPTightPrescale_branch.GetEntry(self.localentry, 0)
            return self.Ele32WPTightPrescale_value

    property Ele35WPTightGroup:
        def __get__(self):
            self.Ele35WPTightGroup_branch.GetEntry(self.localentry, 0)
            return self.Ele35WPTightGroup_value

    property Ele35WPTightPass:
        def __get__(self):
            self.Ele35WPTightPass_branch.GetEntry(self.localentry, 0)
            return self.Ele35WPTightPass_value

    property Ele35WPTightPrescale:
        def __get__(self):
            self.Ele35WPTightPrescale_branch.GetEntry(self.localentry, 0)
            return self.Ele35WPTightPrescale_value

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

    property IsoMu20Group:
        def __get__(self):
            self.IsoMu20Group_branch.GetEntry(self.localentry, 0)
            return self.IsoMu20Group_value

    property IsoMu20Pass:
        def __get__(self):
            self.IsoMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu20Pass_value

    property IsoMu20Prescale:
        def __get__(self):
            self.IsoMu20Prescale_branch.GetEntry(self.localentry, 0)
            return self.IsoMu20Prescale_value

    property IsoMu24Group:
        def __get__(self):
            self.IsoMu24Group_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Group_value

    property IsoMu24Pass:
        def __get__(self):
            self.IsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Pass_value

    property IsoMu24Prescale:
        def __get__(self):
            self.IsoMu24Prescale_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24Prescale_value

    property IsoMu24_eta2p1Group:
        def __get__(self):
            self.IsoMu24_eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24_eta2p1Group_value

    property IsoMu24_eta2p1Pass:
        def __get__(self):
            self.IsoMu24_eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24_eta2p1Pass_value

    property IsoMu24_eta2p1Prescale:
        def __get__(self):
            self.IsoMu24_eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.IsoMu24_eta2p1Prescale_value

    property IsoMu27Group:
        def __get__(self):
            self.IsoMu27Group_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Group_value

    property IsoMu27Pass:
        def __get__(self):
            self.IsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Pass_value

    property IsoMu27Prescale:
        def __get__(self):
            self.IsoMu27Prescale_branch.GetEntry(self.localentry, 0)
            return self.IsoMu27Prescale_value

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

    property Mu20Tau27Group:
        def __get__(self):
            self.Mu20Tau27Group_branch.GetEntry(self.localentry, 0)
            return self.Mu20Tau27Group_value

    property Mu20Tau27Pass:
        def __get__(self):
            self.Mu20Tau27Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu20Tau27Pass_value

    property Mu20Tau27Prescale:
        def __get__(self):
            self.Mu20Tau27Prescale_branch.GetEntry(self.localentry, 0)
            return self.Mu20Tau27Prescale_value

    property Mu50Group:
        def __get__(self):
            self.Mu50Group_branch.GetEntry(self.localentry, 0)
            return self.Mu50Group_value

    property Mu50Pass:
        def __get__(self):
            self.Mu50Pass_branch.GetEntry(self.localentry, 0)
            return self.Mu50Pass_value

    property Mu50Prescale:
        def __get__(self):
            self.Mu50Prescale_branch.GetEntry(self.localentry, 0)
            return self.Mu50Prescale_value

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

    property bjetCISVVeto20Loose:
        def __get__(self):
            self.bjetCISVVeto20Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Loose_value

    property bjetCISVVeto20Medium:
        def __get__(self):
            self.bjetCISVVeto20Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Medium_value

    property bjetCISVVeto20MediumWoNoisyJets:
        def __get__(self):
            self.bjetCISVVeto20MediumWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20MediumWoNoisyJets_value

    property bjetCISVVeto20Tight:
        def __get__(self):
            self.bjetCISVVeto20Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto20Tight_value

    property bjetCISVVeto30Loose:
        def __get__(self):
            self.bjetCISVVeto30Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Loose_value

    property bjetCISVVeto30Medium:
        def __get__(self):
            self.bjetCISVVeto30Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Medium_value

    property bjetCISVVeto30Tight:
        def __get__(self):
            self.bjetCISVVeto30Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetCISVVeto30Tight_value

    property bjetDeepCSVVeto20Loose:
        def __get__(self):
            self.bjetDeepCSVVeto20Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Loose_value

    property bjetDeepCSVVeto20Medium:
        def __get__(self):
            self.bjetDeepCSVVeto20Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Medium_value

    property bjetDeepCSVVeto20MediumWoNoisyJets:
        def __get__(self):
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20MediumWoNoisyJets_value

    property bjetDeepCSVVeto20Tight:
        def __get__(self):
            self.bjetDeepCSVVeto20Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto20Tight_value

    property bjetDeepCSVVeto30Loose:
        def __get__(self):
            self.bjetDeepCSVVeto30Loose_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Loose_value

    property bjetDeepCSVVeto30Medium:
        def __get__(self):
            self.bjetDeepCSVVeto30Medium_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Medium_value

    property bjetDeepCSVVeto30Tight:
        def __get__(self):
            self.bjetDeepCSVVeto30Tight_branch.GetEntry(self.localentry, 0)
            return self.bjetDeepCSVVeto30Tight_value

    property charge:
        def __get__(self):
            self.charge_branch.GetEntry(self.localentry, 0)
            return self.charge_value

    property dielectronVeto:
        def __get__(self):
            self.dielectronVeto_branch.GetEntry(self.localentry, 0)
            return self.dielectronVeto_value

    property dimuonVeto:
        def __get__(self):
            self.dimuonVeto_branch.GetEntry(self.localentry, 0)
            return self.dimuonVeto_value

    property doubleE_23_12Group:
        def __get__(self):
            self.doubleE_23_12Group_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Group_value

    property doubleE_23_12Pass:
        def __get__(self):
            self.doubleE_23_12Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Pass_value

    property doubleE_23_12Prescale:
        def __get__(self):
            self.doubleE_23_12Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12Prescale_value

    property doubleE_23_12_DZGroup:
        def __get__(self):
            self.doubleE_23_12_DZGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12_DZGroup_value

    property doubleE_23_12_DZPass:
        def __get__(self):
            self.doubleE_23_12_DZPass_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12_DZPass_value

    property doubleE_23_12_DZPrescale:
        def __get__(self):
            self.doubleE_23_12_DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleE_23_12_DZPrescale_value

    property doubleMuDZGroup:
        def __get__(self):
            self.doubleMuDZGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZGroup_value

    property doubleMuDZPass:
        def __get__(self):
            self.doubleMuDZPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZPass_value

    property doubleMuDZPrescale:
        def __get__(self):
            self.doubleMuDZPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZPrescale_value

    property doubleMuDZminMass3p8Group:
        def __get__(self):
            self.doubleMuDZminMass3p8Group_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass3p8Group_value

    property doubleMuDZminMass3p8Pass:
        def __get__(self):
            self.doubleMuDZminMass3p8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass3p8Pass_value

    property doubleMuDZminMass3p8Prescale:
        def __get__(self):
            self.doubleMuDZminMass3p8Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass3p8Prescale_value

    property doubleMuDZminMass8Group:
        def __get__(self):
            self.doubleMuDZminMass8Group_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass8Group_value

    property doubleMuDZminMass8Pass:
        def __get__(self):
            self.doubleMuDZminMass8Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass8Pass_value

    property doubleMuDZminMass8Prescale:
        def __get__(self):
            self.doubleMuDZminMass8Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuDZminMass8Prescale_value

    property e1CBIDLoose:
        def __get__(self):
            self.e1CBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDLoose_value

    property e1CBIDMedium:
        def __get__(self):
            self.e1CBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDMedium_value

    property e1CBIDTight:
        def __get__(self):
            self.e1CBIDTight_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDTight_value

    property e1CBIDVeto:
        def __get__(self):
            self.e1CBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.e1CBIDVeto_value

    property e1Charge:
        def __get__(self):
            self.e1Charge_branch.GetEntry(self.localentry, 0)
            return self.e1Charge_value

    property e1ChargeIdLoose:
        def __get__(self):
            self.e1ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdLoose_value

    property e1ChargeIdMed:
        def __get__(self):
            self.e1ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdMed_value

    property e1ChargeIdTight:
        def __get__(self):
            self.e1ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e1ChargeIdTight_value

    property e1ComesFromHiggs:
        def __get__(self):
            self.e1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e1ComesFromHiggs_value

    property e1DPhiToPfMet_type1:
        def __get__(self):
            self.e1DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e1DPhiToPfMet_type1_value

    property e1E1x5:
        def __get__(self):
            self.e1E1x5_branch.GetEntry(self.localentry, 0)
            return self.e1E1x5_value

    property e1E2x5Max:
        def __get__(self):
            self.e1E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e1E2x5Max_value

    property e1E5x5:
        def __get__(self):
            self.e1E5x5_branch.GetEntry(self.localentry, 0)
            return self.e1E5x5_value

    property e1EcalIsoDR03:
        def __get__(self):
            self.e1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1EcalIsoDR03_value

    property e1EffectiveAreaFall17:
        def __get__(self):
            self.e1EffectiveAreaFall17_branch.GetEntry(self.localentry, 0)
            return self.e1EffectiveAreaFall17_value

    property e1EnergyError:
        def __get__(self):
            self.e1EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyError_value

    property e1Eta:
        def __get__(self):
            self.e1Eta_branch.GetEntry(self.localentry, 0)
            return self.e1Eta_value

    property e1GenCharge:
        def __get__(self):
            self.e1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e1GenCharge_value

    property e1GenDirectPromptTauDecay:
        def __get__(self):
            self.e1GenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenDirectPromptTauDecay_value

    property e1GenEnergy:
        def __get__(self):
            self.e1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1GenEnergy_value

    property e1GenEta:
        def __get__(self):
            self.e1GenEta_branch.GetEntry(self.localentry, 0)
            return self.e1GenEta_value

    property e1GenIsPrompt:
        def __get__(self):
            self.e1GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.e1GenIsPrompt_value

    property e1GenMotherPdgId:
        def __get__(self):
            self.e1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenMotherPdgId_value

    property e1GenParticle:
        def __get__(self):
            self.e1GenParticle_branch.GetEntry(self.localentry, 0)
            return self.e1GenParticle_value

    property e1GenPdgId:
        def __get__(self):
            self.e1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e1GenPdgId_value

    property e1GenPhi:
        def __get__(self):
            self.e1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e1GenPhi_value

    property e1GenPrompt:
        def __get__(self):
            self.e1GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.e1GenPrompt_value

    property e1GenPromptTauDecay:
        def __get__(self):
            self.e1GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenPromptTauDecay_value

    property e1GenPt:
        def __get__(self):
            self.e1GenPt_branch.GetEntry(self.localentry, 0)
            return self.e1GenPt_value

    property e1GenTauDecay:
        def __get__(self):
            self.e1GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e1GenTauDecay_value

    property e1GenVZ:
        def __get__(self):
            self.e1GenVZ_branch.GetEntry(self.localentry, 0)
            return self.e1GenVZ_value

    property e1GenVtxPVMatch:
        def __get__(self):
            self.e1GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.e1GenVtxPVMatch_value

    property e1HadronicDepth1OverEm:
        def __get__(self):
            self.e1HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth1OverEm_value

    property e1HadronicDepth2OverEm:
        def __get__(self):
            self.e1HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicDepth2OverEm_value

    property e1HadronicOverEM:
        def __get__(self):
            self.e1HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e1HadronicOverEM_value

    property e1HcalIsoDR03:
        def __get__(self):
            self.e1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1HcalIsoDR03_value

    property e1IP3D:
        def __get__(self):
            self.e1IP3D_branch.GetEntry(self.localentry, 0)
            return self.e1IP3D_value

    property e1IP3DErr:
        def __get__(self):
            self.e1IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.e1IP3DErr_value

    property e1IsoDB03:
        def __get__(self):
            self.e1IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.e1IsoDB03_value

    property e1JetArea:
        def __get__(self):
            self.e1JetArea_branch.GetEntry(self.localentry, 0)
            return self.e1JetArea_value

    property e1JetBtag:
        def __get__(self):
            self.e1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetBtag_value

    property e1JetDR:
        def __get__(self):
            self.e1JetDR_branch.GetEntry(self.localentry, 0)
            return self.e1JetDR_value

    property e1JetEtaEtaMoment:
        def __get__(self):
            self.e1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaEtaMoment_value

    property e1JetEtaPhiMoment:
        def __get__(self):
            self.e1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiMoment_value

    property e1JetEtaPhiSpread:
        def __get__(self):
            self.e1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e1JetEtaPhiSpread_value

    property e1JetHadronFlavour:
        def __get__(self):
            self.e1JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.e1JetHadronFlavour_value

    property e1JetPFCISVBtag:
        def __get__(self):
            self.e1JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.e1JetPFCISVBtag_value

    property e1JetPartonFlavour:
        def __get__(self):
            self.e1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e1JetPartonFlavour_value

    property e1JetPhiPhiMoment:
        def __get__(self):
            self.e1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e1JetPhiPhiMoment_value

    property e1JetPt:
        def __get__(self):
            self.e1JetPt_branch.GetEntry(self.localentry, 0)
            return self.e1JetPt_value

    property e1LowestMll:
        def __get__(self):
            self.e1LowestMll_branch.GetEntry(self.localentry, 0)
            return self.e1LowestMll_value

    property e1MVAIsoLoose:
        def __get__(self):
            self.e1MVAIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIsoLoose_value

    property e1MVAIsoWP80:
        def __get__(self):
            self.e1MVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIsoWP80_value

    property e1MVAIsoWP90:
        def __get__(self):
            self.e1MVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIsoWP90_value

    property e1MVANoisoLoose:
        def __get__(self):
            self.e1MVANoisoLoose_branch.GetEntry(self.localentry, 0)
            return self.e1MVANoisoLoose_value

    property e1MVANoisoWP80:
        def __get__(self):
            self.e1MVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.e1MVANoisoWP80_value

    property e1MVANoisoWP90:
        def __get__(self):
            self.e1MVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.e1MVANoisoWP90_value

    property e1Mass:
        def __get__(self):
            self.e1Mass_branch.GetEntry(self.localentry, 0)
            return self.e1Mass_value

    property e1MatchesEle24Tau30Filter:
        def __get__(self):
            self.e1MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Filter_value

    property e1MatchesEle24Tau30Path:
        def __get__(self):
            self.e1MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Path_value

    property e1MatchesEle27Filter:
        def __get__(self):
            self.e1MatchesEle27Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27Filter_value

    property e1MatchesEle27Path:
        def __get__(self):
            self.e1MatchesEle27Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle27Path_value

    property e1MatchesEle32Filter:
        def __get__(self):
            self.e1MatchesEle32Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle32Filter_value

    property e1MatchesEle32Path:
        def __get__(self):
            self.e1MatchesEle32Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle32Path_value

    property e1MatchesEle35Filter:
        def __get__(self):
            self.e1MatchesEle35Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle35Filter_value

    property e1MatchesEle35Path:
        def __get__(self):
            self.e1MatchesEle35Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle35Path_value

    property e1MissingHits:
        def __get__(self):
            self.e1MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e1MissingHits_value

    property e1MtToPfMet_type1:
        def __get__(self):
            self.e1MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e1MtToPfMet_type1_value

    property e1NearMuonVeto:
        def __get__(self):
            self.e1NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e1NearMuonVeto_value

    property e1NearestMuonDR:
        def __get__(self):
            self.e1NearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.e1NearestMuonDR_value

    property e1NearestZMass:
        def __get__(self):
            self.e1NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.e1NearestZMass_value

    property e1PFChargedIso:
        def __get__(self):
            self.e1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFChargedIso_value

    property e1PFNeutralIso:
        def __get__(self):
            self.e1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFNeutralIso_value

    property e1PFPUChargedIso:
        def __get__(self):
            self.e1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFPUChargedIso_value

    property e1PFPhotonIso:
        def __get__(self):
            self.e1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e1PFPhotonIso_value

    property e1PVDXY:
        def __get__(self):
            self.e1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e1PVDXY_value

    property e1PVDZ:
        def __get__(self):
            self.e1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e1PVDZ_value

    property e1PassesConversionVeto:
        def __get__(self):
            self.e1PassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.e1PassesConversionVeto_value

    property e1Phi:
        def __get__(self):
            self.e1Phi_branch.GetEntry(self.localentry, 0)
            return self.e1Phi_value

    property e1Pt:
        def __get__(self):
            self.e1Pt_branch.GetEntry(self.localentry, 0)
            return self.e1Pt_value

    property e1RelIso:
        def __get__(self):
            self.e1RelIso_branch.GetEntry(self.localentry, 0)
            return self.e1RelIso_value

    property e1RelPFIsoDB:
        def __get__(self):
            self.e1RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoDB_value

    property e1RelPFIsoRho:
        def __get__(self):
            self.e1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e1RelPFIsoRho_value

    property e1Rho:
        def __get__(self):
            self.e1Rho_branch.GetEntry(self.localentry, 0)
            return self.e1Rho_value

    property e1SCEnergy:
        def __get__(self):
            self.e1SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCEnergy_value

    property e1SCEta:
        def __get__(self):
            self.e1SCEta_branch.GetEntry(self.localentry, 0)
            return self.e1SCEta_value

    property e1SCEtaWidth:
        def __get__(self):
            self.e1SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCEtaWidth_value

    property e1SCPhi:
        def __get__(self):
            self.e1SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhi_value

    property e1SCPhiWidth:
        def __get__(self):
            self.e1SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e1SCPhiWidth_value

    property e1SCPreshowerEnergy:
        def __get__(self):
            self.e1SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCPreshowerEnergy_value

    property e1SCRawEnergy:
        def __get__(self):
            self.e1SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1SCRawEnergy_value

    property e1SIP2D:
        def __get__(self):
            self.e1SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP2D_value

    property e1SIP3D:
        def __get__(self):
            self.e1SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP3D_value

    property e1SigmaIEtaIEta:
        def __get__(self):
            self.e1SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e1SigmaIEtaIEta_value

    property e1TrkIsoDR03:
        def __get__(self):
            self.e1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1TrkIsoDR03_value

    property e1VZ:
        def __get__(self):
            self.e1VZ_branch.GetEntry(self.localentry, 0)
            return self.e1VZ_value

    property e1ZTTGenMatching:
        def __get__(self):
            self.e1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.e1ZTTGenMatching_value

    property e1_e2_CosThetaStar:
        def __get__(self):
            self.e1_e2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_CosThetaStar_value

    property e1_e2_DPhi:
        def __get__(self):
            self.e1_e2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DPhi_value

    property e1_e2_DR:
        def __get__(self):
            self.e1_e2_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DR_value

    property e1_e2_Eta:
        def __get__(self):
            self.e1_e2_Eta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Eta_value

    property e1_e2_Mass:
        def __get__(self):
            self.e1_e2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_value

    property e1_e2_Mt:
        def __get__(self):
            self.e1_e2_Mt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mt_value

    property e1_e2_PZeta:
        def __get__(self):
            self.e1_e2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZeta_value

    property e1_e2_PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaVis_value

    property e1_e2_Phi:
        def __get__(self):
            self.e1_e2_Phi_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Phi_value

    property e1_e2_Pt:
        def __get__(self):
            self.e1_e2_Pt_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Pt_value

    property e1_e2_SS:
        def __get__(self):
            self.e1_e2_SS_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_SS_value

    property e1_e2_collinearmass:
        def __get__(self):
            self.e1_e2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_collinearmass_value

    property e1_e2_doubleL1IsoTauMatch:
        def __get__(self):
            self.e1_e2_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_doubleL1IsoTauMatch_value

    property e1deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaEtaSuperClusterTrackAtVtx_value

    property e1deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e1deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e1deltaPhiSuperClusterTrackAtVtx_value

    property e1eSuperClusterOverP:
        def __get__(self):
            self.e1eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e1eSuperClusterOverP_value

    property e1ecalEnergy:
        def __get__(self):
            self.e1ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1ecalEnergy_value

    property e1fBrem:
        def __get__(self):
            self.e1fBrem_branch.GetEntry(self.localentry, 0)
            return self.e1fBrem_value

    property e1trackMomentumAtVtxP:
        def __get__(self):
            self.e1trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e1trackMomentumAtVtxP_value

    property e2CBIDLoose:
        def __get__(self):
            self.e2CBIDLoose_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDLoose_value

    property e2CBIDMedium:
        def __get__(self):
            self.e2CBIDMedium_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDMedium_value

    property e2CBIDTight:
        def __get__(self):
            self.e2CBIDTight_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDTight_value

    property e2CBIDVeto:
        def __get__(self):
            self.e2CBIDVeto_branch.GetEntry(self.localentry, 0)
            return self.e2CBIDVeto_value

    property e2Charge:
        def __get__(self):
            self.e2Charge_branch.GetEntry(self.localentry, 0)
            return self.e2Charge_value

    property e2ChargeIdLoose:
        def __get__(self):
            self.e2ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdLoose_value

    property e2ChargeIdMed:
        def __get__(self):
            self.e2ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdMed_value

    property e2ChargeIdTight:
        def __get__(self):
            self.e2ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e2ChargeIdTight_value

    property e2ComesFromHiggs:
        def __get__(self):
            self.e2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e2ComesFromHiggs_value

    property e2DPhiToPfMet_type1:
        def __get__(self):
            self.e2DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e2DPhiToPfMet_type1_value

    property e2E1x5:
        def __get__(self):
            self.e2E1x5_branch.GetEntry(self.localentry, 0)
            return self.e2E1x5_value

    property e2E2x5Max:
        def __get__(self):
            self.e2E2x5Max_branch.GetEntry(self.localentry, 0)
            return self.e2E2x5Max_value

    property e2E5x5:
        def __get__(self):
            self.e2E5x5_branch.GetEntry(self.localentry, 0)
            return self.e2E5x5_value

    property e2EcalIsoDR03:
        def __get__(self):
            self.e2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2EcalIsoDR03_value

    property e2EffectiveAreaFall17:
        def __get__(self):
            self.e2EffectiveAreaFall17_branch.GetEntry(self.localentry, 0)
            return self.e2EffectiveAreaFall17_value

    property e2EnergyError:
        def __get__(self):
            self.e2EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyError_value

    property e2Eta:
        def __get__(self):
            self.e2Eta_branch.GetEntry(self.localentry, 0)
            return self.e2Eta_value

    property e2GenCharge:
        def __get__(self):
            self.e2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e2GenCharge_value

    property e2GenDirectPromptTauDecay:
        def __get__(self):
            self.e2GenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenDirectPromptTauDecay_value

    property e2GenEnergy:
        def __get__(self):
            self.e2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2GenEnergy_value

    property e2GenEta:
        def __get__(self):
            self.e2GenEta_branch.GetEntry(self.localentry, 0)
            return self.e2GenEta_value

    property e2GenIsPrompt:
        def __get__(self):
            self.e2GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.e2GenIsPrompt_value

    property e2GenMotherPdgId:
        def __get__(self):
            self.e2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenMotherPdgId_value

    property e2GenParticle:
        def __get__(self):
            self.e2GenParticle_branch.GetEntry(self.localentry, 0)
            return self.e2GenParticle_value

    property e2GenPdgId:
        def __get__(self):
            self.e2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e2GenPdgId_value

    property e2GenPhi:
        def __get__(self):
            self.e2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e2GenPhi_value

    property e2GenPrompt:
        def __get__(self):
            self.e2GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.e2GenPrompt_value

    property e2GenPromptTauDecay:
        def __get__(self):
            self.e2GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenPromptTauDecay_value

    property e2GenPt:
        def __get__(self):
            self.e2GenPt_branch.GetEntry(self.localentry, 0)
            return self.e2GenPt_value

    property e2GenTauDecay:
        def __get__(self):
            self.e2GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e2GenTauDecay_value

    property e2GenVZ:
        def __get__(self):
            self.e2GenVZ_branch.GetEntry(self.localentry, 0)
            return self.e2GenVZ_value

    property e2GenVtxPVMatch:
        def __get__(self):
            self.e2GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.e2GenVtxPVMatch_value

    property e2HadronicDepth1OverEm:
        def __get__(self):
            self.e2HadronicDepth1OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth1OverEm_value

    property e2HadronicDepth2OverEm:
        def __get__(self):
            self.e2HadronicDepth2OverEm_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicDepth2OverEm_value

    property e2HadronicOverEM:
        def __get__(self):
            self.e2HadronicOverEM_branch.GetEntry(self.localentry, 0)
            return self.e2HadronicOverEM_value

    property e2HcalIsoDR03:
        def __get__(self):
            self.e2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2HcalIsoDR03_value

    property e2IP3D:
        def __get__(self):
            self.e2IP3D_branch.GetEntry(self.localentry, 0)
            return self.e2IP3D_value

    property e2IP3DErr:
        def __get__(self):
            self.e2IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.e2IP3DErr_value

    property e2IsoDB03:
        def __get__(self):
            self.e2IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.e2IsoDB03_value

    property e2JetArea:
        def __get__(self):
            self.e2JetArea_branch.GetEntry(self.localentry, 0)
            return self.e2JetArea_value

    property e2JetBtag:
        def __get__(self):
            self.e2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetBtag_value

    property e2JetDR:
        def __get__(self):
            self.e2JetDR_branch.GetEntry(self.localentry, 0)
            return self.e2JetDR_value

    property e2JetEtaEtaMoment:
        def __get__(self):
            self.e2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaEtaMoment_value

    property e2JetEtaPhiMoment:
        def __get__(self):
            self.e2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiMoment_value

    property e2JetEtaPhiSpread:
        def __get__(self):
            self.e2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e2JetEtaPhiSpread_value

    property e2JetHadronFlavour:
        def __get__(self):
            self.e2JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.e2JetHadronFlavour_value

    property e2JetPFCISVBtag:
        def __get__(self):
            self.e2JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.e2JetPFCISVBtag_value

    property e2JetPartonFlavour:
        def __get__(self):
            self.e2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e2JetPartonFlavour_value

    property e2JetPhiPhiMoment:
        def __get__(self):
            self.e2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e2JetPhiPhiMoment_value

    property e2JetPt:
        def __get__(self):
            self.e2JetPt_branch.GetEntry(self.localentry, 0)
            return self.e2JetPt_value

    property e2LowestMll:
        def __get__(self):
            self.e2LowestMll_branch.GetEntry(self.localentry, 0)
            return self.e2LowestMll_value

    property e2MVAIsoLoose:
        def __get__(self):
            self.e2MVAIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIsoLoose_value

    property e2MVAIsoWP80:
        def __get__(self):
            self.e2MVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIsoWP80_value

    property e2MVAIsoWP90:
        def __get__(self):
            self.e2MVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIsoWP90_value

    property e2MVANoisoLoose:
        def __get__(self):
            self.e2MVANoisoLoose_branch.GetEntry(self.localentry, 0)
            return self.e2MVANoisoLoose_value

    property e2MVANoisoWP80:
        def __get__(self):
            self.e2MVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.e2MVANoisoWP80_value

    property e2MVANoisoWP90:
        def __get__(self):
            self.e2MVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.e2MVANoisoWP90_value

    property e2Mass:
        def __get__(self):
            self.e2Mass_branch.GetEntry(self.localentry, 0)
            return self.e2Mass_value

    property e2MatchesEle24Tau30Filter:
        def __get__(self):
            self.e2MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Filter_value

    property e2MatchesEle24Tau30Path:
        def __get__(self):
            self.e2MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Path_value

    property e2MatchesEle27Filter:
        def __get__(self):
            self.e2MatchesEle27Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27Filter_value

    property e2MatchesEle27Path:
        def __get__(self):
            self.e2MatchesEle27Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle27Path_value

    property e2MatchesEle32Filter:
        def __get__(self):
            self.e2MatchesEle32Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle32Filter_value

    property e2MatchesEle32Path:
        def __get__(self):
            self.e2MatchesEle32Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle32Path_value

    property e2MatchesEle35Filter:
        def __get__(self):
            self.e2MatchesEle35Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle35Filter_value

    property e2MatchesEle35Path:
        def __get__(self):
            self.e2MatchesEle35Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle35Path_value

    property e2MissingHits:
        def __get__(self):
            self.e2MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e2MissingHits_value

    property e2MtToPfMet_type1:
        def __get__(self):
            self.e2MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.e2MtToPfMet_type1_value

    property e2NearMuonVeto:
        def __get__(self):
            self.e2NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e2NearMuonVeto_value

    property e2NearestMuonDR:
        def __get__(self):
            self.e2NearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.e2NearestMuonDR_value

    property e2NearestZMass:
        def __get__(self):
            self.e2NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.e2NearestZMass_value

    property e2PFChargedIso:
        def __get__(self):
            self.e2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFChargedIso_value

    property e2PFNeutralIso:
        def __get__(self):
            self.e2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFNeutralIso_value

    property e2PFPUChargedIso:
        def __get__(self):
            self.e2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFPUChargedIso_value

    property e2PFPhotonIso:
        def __get__(self):
            self.e2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e2PFPhotonIso_value

    property e2PVDXY:
        def __get__(self):
            self.e2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e2PVDXY_value

    property e2PVDZ:
        def __get__(self):
            self.e2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e2PVDZ_value

    property e2PassesConversionVeto:
        def __get__(self):
            self.e2PassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.e2PassesConversionVeto_value

    property e2Phi:
        def __get__(self):
            self.e2Phi_branch.GetEntry(self.localentry, 0)
            return self.e2Phi_value

    property e2Pt:
        def __get__(self):
            self.e2Pt_branch.GetEntry(self.localentry, 0)
            return self.e2Pt_value

    property e2RelIso:
        def __get__(self):
            self.e2RelIso_branch.GetEntry(self.localentry, 0)
            return self.e2RelIso_value

    property e2RelPFIsoDB:
        def __get__(self):
            self.e2RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoDB_value

    property e2RelPFIsoRho:
        def __get__(self):
            self.e2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e2RelPFIsoRho_value

    property e2Rho:
        def __get__(self):
            self.e2Rho_branch.GetEntry(self.localentry, 0)
            return self.e2Rho_value

    property e2SCEnergy:
        def __get__(self):
            self.e2SCEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCEnergy_value

    property e2SCEta:
        def __get__(self):
            self.e2SCEta_branch.GetEntry(self.localentry, 0)
            return self.e2SCEta_value

    property e2SCEtaWidth:
        def __get__(self):
            self.e2SCEtaWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCEtaWidth_value

    property e2SCPhi:
        def __get__(self):
            self.e2SCPhi_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhi_value

    property e2SCPhiWidth:
        def __get__(self):
            self.e2SCPhiWidth_branch.GetEntry(self.localentry, 0)
            return self.e2SCPhiWidth_value

    property e2SCPreshowerEnergy:
        def __get__(self):
            self.e2SCPreshowerEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCPreshowerEnergy_value

    property e2SCRawEnergy:
        def __get__(self):
            self.e2SCRawEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2SCRawEnergy_value

    property e2SIP2D:
        def __get__(self):
            self.e2SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP2D_value

    property e2SIP3D:
        def __get__(self):
            self.e2SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP3D_value

    property e2SigmaIEtaIEta:
        def __get__(self):
            self.e2SigmaIEtaIEta_branch.GetEntry(self.localentry, 0)
            return self.e2SigmaIEtaIEta_value

    property e2TrkIsoDR03:
        def __get__(self):
            self.e2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2TrkIsoDR03_value

    property e2VZ:
        def __get__(self):
            self.e2VZ_branch.GetEntry(self.localentry, 0)
            return self.e2VZ_value

    property e2ZTTGenMatching:
        def __get__(self):
            self.e2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.e2ZTTGenMatching_value

    property e2_e1_collinearmass:
        def __get__(self):
            self.e2_e1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.e2_e1_collinearmass_value

    property e2deltaEtaSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaEtaSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaEtaSuperClusterTrackAtVtx_value

    property e2deltaPhiSuperClusterTrackAtVtx:
        def __get__(self):
            self.e2deltaPhiSuperClusterTrackAtVtx_branch.GetEntry(self.localentry, 0)
            return self.e2deltaPhiSuperClusterTrackAtVtx_value

    property e2eSuperClusterOverP:
        def __get__(self):
            self.e2eSuperClusterOverP_branch.GetEntry(self.localentry, 0)
            return self.e2eSuperClusterOverP_value

    property e2ecalEnergy:
        def __get__(self):
            self.e2ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2ecalEnergy_value

    property e2fBrem:
        def __get__(self):
            self.e2fBrem_branch.GetEntry(self.localentry, 0)
            return self.e2fBrem_value

    property e2trackMomentumAtVtxP:
        def __get__(self):
            self.e2trackMomentumAtVtxP_branch.GetEntry(self.localentry, 0)
            return self.e2trackMomentumAtVtxP_value

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

    property jb1csv:
        def __get__(self):
            self.jb1csv_branch.GetEntry(self.localentry, 0)
            return self.jb1csv_value

    property jb1csvWoNoisyJets:
        def __get__(self):
            self.jb1csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb1csvWoNoisyJets_value

    property jb1eta:
        def __get__(self):
            self.jb1eta_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_value

    property jb1etaWoNoisyJets:
        def __get__(self):
            self.jb1etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb1etaWoNoisyJets_value

    property jb1hadronflavor:
        def __get__(self):
            self.jb1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_value

    property jb1hadronflavorWoNoisyJets:
        def __get__(self):
            self.jb1hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavorWoNoisyJets_value

    property jb1phi:
        def __get__(self):
            self.jb1phi_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_value

    property jb1phiWoNoisyJets:
        def __get__(self):
            self.jb1phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb1phiWoNoisyJets_value

    property jb1pt:
        def __get__(self):
            self.jb1pt_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_value

    property jb1ptWoNoisyJets:
        def __get__(self):
            self.jb1ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb1ptWoNoisyJets_value

    property jb2csv:
        def __get__(self):
            self.jb2csv_branch.GetEntry(self.localentry, 0)
            return self.jb2csv_value

    property jb2csvWoNoisyJets:
        def __get__(self):
            self.jb2csvWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb2csvWoNoisyJets_value

    property jb2eta:
        def __get__(self):
            self.jb2eta_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_value

    property jb2etaWoNoisyJets:
        def __get__(self):
            self.jb2etaWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb2etaWoNoisyJets_value

    property jb2hadronflavor:
        def __get__(self):
            self.jb2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_value

    property jb2hadronflavorWoNoisyJets:
        def __get__(self):
            self.jb2hadronflavorWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavorWoNoisyJets_value

    property jb2phi:
        def __get__(self):
            self.jb2phi_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_value

    property jb2phiWoNoisyJets:
        def __get__(self):
            self.jb2phiWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb2phiWoNoisyJets_value

    property jb2pt:
        def __get__(self):
            self.jb2pt_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_value

    property jb2ptWoNoisyJets:
        def __get__(self):
            self.jb2ptWoNoisyJets_branch.GetEntry(self.localentry, 0)
            return self.jb2ptWoNoisyJets_value

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

    property jetVeto30_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapDown_value

    property jetVeto30_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteFlavMapUp_value

    property jetVeto30_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasDown_value

    property jetVeto30_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteMPFBiasUp_value

    property jetVeto30_JetAbsoluteScaleDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleDown_value

    property jetVeto30_JetAbsoluteScaleUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteScaleUp_value

    property jetVeto30_JetAbsoluteStatDown:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatDown_value

    property jetVeto30_JetAbsoluteStatUp:
        def __get__(self):
            self.jetVeto30_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetAbsoluteStatUp_value

    property jetVeto30_JetClosureDown:
        def __get__(self):
            self.jetVeto30_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureDown_value

    property jetVeto30_JetClosureUp:
        def __get__(self):
            self.jetVeto30_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetClosureUp_value

    property jetVeto30_JetEnDown:
        def __get__(self):
            self.jetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnDown_value

    property jetVeto30_JetEnUp:
        def __get__(self):
            self.jetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEnUp_value

    property jetVeto30_JetEta0to3Down:
        def __get__(self):
            self.jetVeto30_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to3Down_value

    property jetVeto30_JetEta0to3Up:
        def __get__(self):
            self.jetVeto30_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to3Up_value

    property jetVeto30_JetEta0to5Down:
        def __get__(self):
            self.jetVeto30_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to5Down_value

    property jetVeto30_JetEta0to5Up:
        def __get__(self):
            self.jetVeto30_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta0to5Up_value

    property jetVeto30_JetEta3to5Down:
        def __get__(self):
            self.jetVeto30_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta3to5Down_value

    property jetVeto30_JetEta3to5Up:
        def __get__(self):
            self.jetVeto30_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetEta3to5Up_value

    property jetVeto30_JetFlavorQCDDown:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDDown_value

    property jetVeto30_JetFlavorQCDUp:
        def __get__(self):
            self.jetVeto30_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFlavorQCDUp_value

    property jetVeto30_JetFragmentationDown:
        def __get__(self):
            self.jetVeto30_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationDown_value

    property jetVeto30_JetFragmentationUp:
        def __get__(self):
            self.jetVeto30_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetFragmentationUp_value

    property jetVeto30_JetPileUpDataMCDown:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCDown_value

    property jetVeto30_JetPileUpDataMCUp:
        def __get__(self):
            self.jetVeto30_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpDataMCUp_value

    property jetVeto30_JetPileUpPtBBDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBDown_value

    property jetVeto30_JetPileUpPtBBUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtBBUp_value

    property jetVeto30_JetPileUpPtEC1Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Down_value

    property jetVeto30_JetPileUpPtEC1Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC1Up_value

    property jetVeto30_JetPileUpPtEC2Down:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Down_value

    property jetVeto30_JetPileUpPtEC2Up:
        def __get__(self):
            self.jetVeto30_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtEC2Up_value

    property jetVeto30_JetPileUpPtHFDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFDown_value

    property jetVeto30_JetPileUpPtHFUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtHFUp_value

    property jetVeto30_JetPileUpPtRefDown:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefDown_value

    property jetVeto30_JetPileUpPtRefUp:
        def __get__(self):
            self.jetVeto30_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetPileUpPtRefUp_value

    property jetVeto30_JetRelativeBalDown:
        def __get__(self):
            self.jetVeto30_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalDown_value

    property jetVeto30_JetRelativeBalUp:
        def __get__(self):
            self.jetVeto30_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeBalUp_value

    property jetVeto30_JetRelativeFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRDown_value

    property jetVeto30_JetRelativeFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeFSRUp_value

    property jetVeto30_JetRelativeJEREC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Down_value

    property jetVeto30_JetRelativeJEREC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC1Up_value

    property jetVeto30_JetRelativeJEREC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Down_value

    property jetVeto30_JetRelativeJEREC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJEREC2Up_value

    property jetVeto30_JetRelativeJERHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFDown_value

    property jetVeto30_JetRelativeJERHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeJERHFUp_value

    property jetVeto30_JetRelativePtBBDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBDown_value

    property jetVeto30_JetRelativePtBBUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtBBUp_value

    property jetVeto30_JetRelativePtEC1Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Down_value

    property jetVeto30_JetRelativePtEC1Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC1Up_value

    property jetVeto30_JetRelativePtEC2Down:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Down_value

    property jetVeto30_JetRelativePtEC2Up:
        def __get__(self):
            self.jetVeto30_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtEC2Up_value

    property jetVeto30_JetRelativePtHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFDown_value

    property jetVeto30_JetRelativePtHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativePtHFUp_value

    property jetVeto30_JetRelativeSampleDown:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleDown_value

    property jetVeto30_JetRelativeSampleUp:
        def __get__(self):
            self.jetVeto30_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeSampleUp_value

    property jetVeto30_JetRelativeStatECDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECDown_value

    property jetVeto30_JetRelativeStatECUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatECUp_value

    property jetVeto30_JetRelativeStatFSRDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRDown_value

    property jetVeto30_JetRelativeStatFSRUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatFSRUp_value

    property jetVeto30_JetRelativeStatHFDown:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFDown_value

    property jetVeto30_JetRelativeStatHFUp:
        def __get__(self):
            self.jetVeto30_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetRelativeStatHFUp_value

    property jetVeto30_JetSinglePionECALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALDown_value

    property jetVeto30_JetSinglePionECALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionECALUp_value

    property jetVeto30_JetSinglePionHCALDown:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALDown_value

    property jetVeto30_JetSinglePionHCALUp:
        def __get__(self):
            self.jetVeto30_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSinglePionHCALUp_value

    property jetVeto30_JetTimePtEtaDown:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaDown_value

    property jetVeto30_JetTimePtEtaUp:
        def __get__(self):
            self.jetVeto30_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTimePtEtaUp_value

    property jetVeto30_JetTotalDown:
        def __get__(self):
            self.jetVeto30_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalDown_value

    property jetVeto30_JetTotalUp:
        def __get__(self):
            self.jetVeto30_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetTotalUp_value

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

    property metcov00_DESYlike:
        def __get__(self):
            self.metcov00_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov00_DESYlike_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metcov01_DESYlike:
        def __get__(self):
            self.metcov01_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov01_DESYlike_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov10_DESYlike:
        def __get__(self):
            self.metcov10_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov10_DESYlike_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

    property metcov11_DESYlike:
        def __get__(self):
            self.metcov11_DESYlike_branch.GetEntry(self.localentry, 0)
            return self.metcov11_DESYlike_value

    property mu12e23DZGroup:
        def __get__(self):
            self.mu12e23DZGroup_branch.GetEntry(self.localentry, 0)
            return self.mu12e23DZGroup_value

    property mu12e23DZPass:
        def __get__(self):
            self.mu12e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23DZPass_value

    property mu12e23DZPrescale:
        def __get__(self):
            self.mu12e23DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu12e23DZPrescale_value

    property mu12e23Group:
        def __get__(self):
            self.mu12e23Group_branch.GetEntry(self.localentry, 0)
            return self.mu12e23Group_value

    property mu12e23Pass:
        def __get__(self):
            self.mu12e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu12e23Pass_value

    property mu12e23Prescale:
        def __get__(self):
            self.mu12e23Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu12e23Prescale_value

    property mu23e12DZGroup:
        def __get__(self):
            self.mu23e12DZGroup_branch.GetEntry(self.localentry, 0)
            return self.mu23e12DZGroup_value

    property mu23e12DZPass:
        def __get__(self):
            self.mu23e12DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12DZPass_value

    property mu23e12DZPrescale:
        def __get__(self):
            self.mu23e12DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu23e12DZPrescale_value

    property mu23e12Group:
        def __get__(self):
            self.mu23e12Group_branch.GetEntry(self.localentry, 0)
            return self.mu23e12Group_value

    property mu23e12Pass:
        def __get__(self):
            self.mu23e12Pass_branch.GetEntry(self.localentry, 0)
            return self.mu23e12Pass_value

    property mu23e12Prescale:
        def __get__(self):
            self.mu23e12Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu23e12Prescale_value

    property mu8e23DZGroup:
        def __get__(self):
            self.mu8e23DZGroup_branch.GetEntry(self.localentry, 0)
            return self.mu8e23DZGroup_value

    property mu8e23DZPass:
        def __get__(self):
            self.mu8e23DZPass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23DZPass_value

    property mu8e23DZPrescale:
        def __get__(self):
            self.mu8e23DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.mu8e23DZPrescale_value

    property mu8e23Group:
        def __get__(self):
            self.mu8e23Group_branch.GetEntry(self.localentry, 0)
            return self.mu8e23Group_value

    property mu8e23Pass:
        def __get__(self):
            self.mu8e23Pass_branch.GetEntry(self.localentry, 0)
            return self.mu8e23Pass_value

    property mu8e23Prescale:
        def __get__(self):
            self.mu8e23Prescale_branch.GetEntry(self.localentry, 0)
            return self.mu8e23Prescale_value

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

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

    property tauVetoPt20Loose3HitsVtx:
        def __get__(self):
            self.tauVetoPt20Loose3HitsVtx_branch.GetEntry(self.localentry, 0)
            return self.tauVetoPt20Loose3HitsVtx_value

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

    property tripleEGroup:
        def __get__(self):
            self.tripleEGroup_branch.GetEntry(self.localentry, 0)
            return self.tripleEGroup_value

    property tripleEPass:
        def __get__(self):
            self.tripleEPass_branch.GetEntry(self.localentry, 0)
            return self.tripleEPass_value

    property tripleEPrescale:
        def __get__(self):
            self.tripleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.tripleEPrescale_value

    property tripleMu12_10_5Group:
        def __get__(self):
            self.tripleMu12_10_5Group_branch.GetEntry(self.localentry, 0)
            return self.tripleMu12_10_5Group_value

    property tripleMu12_10_5Pass:
        def __get__(self):
            self.tripleMu12_10_5Pass_branch.GetEntry(self.localentry, 0)
            return self.tripleMu12_10_5Pass_value

    property tripleMu12_10_5Prescale:
        def __get__(self):
            self.tripleMu12_10_5Prescale_branch.GetEntry(self.localentry, 0)
            return self.tripleMu12_10_5Prescale_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_AbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_AbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPhi_AbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_AbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_AbsoluteMPFBiasUp_value

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

    property type1_pfMet_shiftedPhi_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    property type1_pfMet_shiftedPhi_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    property type1_pfMet_shiftedPt_AbsoluteFlavMapDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_AbsoluteFlavMapDown_value

    property type1_pfMet_shiftedPt_AbsoluteFlavMapUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_AbsoluteFlavMapUp_value

    property type1_pfMet_shiftedPt_AbsoluteMPFBiasDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_AbsoluteMPFBiasDown_value

    property type1_pfMet_shiftedPt_AbsoluteMPFBiasUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_AbsoluteMPFBiasUp_value

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

    property vbfMass_JetAbsoluteFlavMapDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapDown_value

    property vbfMass_JetAbsoluteFlavMapUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteFlavMapUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteFlavMapUp_value

    property vbfMass_JetAbsoluteMPFBiasDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasDown_value

    property vbfMass_JetAbsoluteMPFBiasUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteMPFBiasUp_value

    property vbfMass_JetAbsoluteScaleDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleDown_value

    property vbfMass_JetAbsoluteScaleUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteScaleUp_value

    property vbfMass_JetAbsoluteStatDown:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatDown_value

    property vbfMass_JetAbsoluteStatUp:
        def __get__(self):
            self.vbfMass_JetAbsoluteStatUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetAbsoluteStatUp_value

    property vbfMass_JetClosureDown:
        def __get__(self):
            self.vbfMass_JetClosureDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureDown_value

    property vbfMass_JetClosureUp:
        def __get__(self):
            self.vbfMass_JetClosureUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetClosureUp_value

    property vbfMass_JetEta0to3Down:
        def __get__(self):
            self.vbfMass_JetEta0to3Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to3Down_value

    property vbfMass_JetEta0to3Up:
        def __get__(self):
            self.vbfMass_JetEta0to3Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to3Up_value

    property vbfMass_JetEta0to5Down:
        def __get__(self):
            self.vbfMass_JetEta0to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to5Down_value

    property vbfMass_JetEta0to5Up:
        def __get__(self):
            self.vbfMass_JetEta0to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta0to5Up_value

    property vbfMass_JetEta3to5Down:
        def __get__(self):
            self.vbfMass_JetEta3to5Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta3to5Down_value

    property vbfMass_JetEta3to5Up:
        def __get__(self):
            self.vbfMass_JetEta3to5Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEta3to5Up_value

    property vbfMass_JetFlavorQCDDown:
        def __get__(self):
            self.vbfMass_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDDown_value

    property vbfMass_JetFlavorQCDUp:
        def __get__(self):
            self.vbfMass_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFlavorQCDUp_value

    property vbfMass_JetFragmentationDown:
        def __get__(self):
            self.vbfMass_JetFragmentationDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationDown_value

    property vbfMass_JetFragmentationUp:
        def __get__(self):
            self.vbfMass_JetFragmentationUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetFragmentationUp_value

    property vbfMass_JetPileUpDataMCDown:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCDown_value

    property vbfMass_JetPileUpDataMCUp:
        def __get__(self):
            self.vbfMass_JetPileUpDataMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpDataMCUp_value

    property vbfMass_JetPileUpPtBBDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBDown_value

    property vbfMass_JetPileUpPtBBUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtBBUp_value

    property vbfMass_JetPileUpPtEC1Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Down_value

    property vbfMass_JetPileUpPtEC1Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC1Up_value

    property vbfMass_JetPileUpPtEC2Down:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Down_value

    property vbfMass_JetPileUpPtEC2Up:
        def __get__(self):
            self.vbfMass_JetPileUpPtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtEC2Up_value

    property vbfMass_JetPileUpPtHFDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFDown_value

    property vbfMass_JetPileUpPtHFUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtHFUp_value

    property vbfMass_JetPileUpPtRefDown:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefDown_value

    property vbfMass_JetPileUpPtRefUp:
        def __get__(self):
            self.vbfMass_JetPileUpPtRefUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetPileUpPtRefUp_value

    property vbfMass_JetRelativeBalDown:
        def __get__(self):
            self.vbfMass_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalDown_value

    property vbfMass_JetRelativeBalUp:
        def __get__(self):
            self.vbfMass_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeBalUp_value

    property vbfMass_JetRelativeFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRDown_value

    property vbfMass_JetRelativeFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeFSRUp_value

    property vbfMass_JetRelativeJEREC1Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Down_value

    property vbfMass_JetRelativeJEREC1Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC1Up_value

    property vbfMass_JetRelativeJEREC2Down:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Down_value

    property vbfMass_JetRelativeJEREC2Up:
        def __get__(self):
            self.vbfMass_JetRelativeJEREC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJEREC2Up_value

    property vbfMass_JetRelativeJERHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFDown_value

    property vbfMass_JetRelativeJERHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeJERHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeJERHFUp_value

    property vbfMass_JetRelativePtBBDown:
        def __get__(self):
            self.vbfMass_JetRelativePtBBDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBDown_value

    property vbfMass_JetRelativePtBBUp:
        def __get__(self):
            self.vbfMass_JetRelativePtBBUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtBBUp_value

    property vbfMass_JetRelativePtEC1Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Down_value

    property vbfMass_JetRelativePtEC1Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC1Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC1Up_value

    property vbfMass_JetRelativePtEC2Down:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Down_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Down_value

    property vbfMass_JetRelativePtEC2Up:
        def __get__(self):
            self.vbfMass_JetRelativePtEC2Up_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtEC2Up_value

    property vbfMass_JetRelativePtHFDown:
        def __get__(self):
            self.vbfMass_JetRelativePtHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFDown_value

    property vbfMass_JetRelativePtHFUp:
        def __get__(self):
            self.vbfMass_JetRelativePtHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativePtHFUp_value

    property vbfMass_JetRelativeSampleDown:
        def __get__(self):
            self.vbfMass_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleDown_value

    property vbfMass_JetRelativeSampleUp:
        def __get__(self):
            self.vbfMass_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeSampleUp_value

    property vbfMass_JetRelativeStatECDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatECDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECDown_value

    property vbfMass_JetRelativeStatECUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatECUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatECUp_value

    property vbfMass_JetRelativeStatFSRDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRDown_value

    property vbfMass_JetRelativeStatFSRUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatFSRUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatFSRUp_value

    property vbfMass_JetRelativeStatHFDown:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFDown_value

    property vbfMass_JetRelativeStatHFUp:
        def __get__(self):
            self.vbfMass_JetRelativeStatHFUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetRelativeStatHFUp_value

    property vbfMass_JetSinglePionECALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionECALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALDown_value

    property vbfMass_JetSinglePionECALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionECALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionECALUp_value

    property vbfMass_JetSinglePionHCALDown:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALDown_value

    property vbfMass_JetSinglePionHCALUp:
        def __get__(self):
            self.vbfMass_JetSinglePionHCALUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSinglePionHCALUp_value

    property vbfMass_JetTimePtEtaDown:
        def __get__(self):
            self.vbfMass_JetTimePtEtaDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaDown_value

    property vbfMass_JetTimePtEtaUp:
        def __get__(self):
            self.vbfMass_JetTimePtEtaUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTimePtEtaUp_value

    property vbfMass_JetTotalDown:
        def __get__(self):
            self.vbfMass_JetTotalDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalDown_value

    property vbfMass_JetTotalUp:
        def __get__(self):
            self.vbfMass_JetTotalUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetTotalUp_value

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


