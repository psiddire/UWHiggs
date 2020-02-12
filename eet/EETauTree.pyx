

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

cdef class EETauTree:
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

    cdef TBranch* Flag_ecalBadCalibReducedMINIAODFilter_branch
    cdef float Flag_ecalBadCalibReducedMINIAODFilter_value

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

    cdef TBranch* bweight_2016_branch
    cdef float bweight_2016_value

    cdef TBranch* bweight_2017_branch
    cdef float bweight_2017_value

    cdef TBranch* bweight_2018_branch
    cdef float bweight_2018_value

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

    cdef TBranch* e1CorrectedEt_branch
    cdef float e1CorrectedEt_value

    cdef TBranch* e1EcalIsoDR03_branch
    cdef float e1EcalIsoDR03_value

    cdef TBranch* e1EnergyError_branch
    cdef float e1EnergyError_value

    cdef TBranch* e1EnergyScaleDown_branch
    cdef float e1EnergyScaleDown_value

    cdef TBranch* e1EnergyScaleGainDown_branch
    cdef float e1EnergyScaleGainDown_value

    cdef TBranch* e1EnergyScaleGainUp_branch
    cdef float e1EnergyScaleGainUp_value

    cdef TBranch* e1EnergyScaleStatDown_branch
    cdef float e1EnergyScaleStatDown_value

    cdef TBranch* e1EnergyScaleStatUp_branch
    cdef float e1EnergyScaleStatUp_value

    cdef TBranch* e1EnergyScaleSystDown_branch
    cdef float e1EnergyScaleSystDown_value

    cdef TBranch* e1EnergyScaleSystUp_branch
    cdef float e1EnergyScaleSystUp_value

    cdef TBranch* e1EnergyScaleUp_branch
    cdef float e1EnergyScaleUp_value

    cdef TBranch* e1EnergySigmaDown_branch
    cdef float e1EnergySigmaDown_value

    cdef TBranch* e1EnergySigmaPhiDown_branch
    cdef float e1EnergySigmaPhiDown_value

    cdef TBranch* e1EnergySigmaPhiUp_branch
    cdef float e1EnergySigmaPhiUp_value

    cdef TBranch* e1EnergySigmaRhoDown_branch
    cdef float e1EnergySigmaRhoDown_value

    cdef TBranch* e1EnergySigmaRhoUp_branch
    cdef float e1EnergySigmaRhoUp_value

    cdef TBranch* e1EnergySigmaUp_branch
    cdef float e1EnergySigmaUp_value

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

    cdef TBranch* e1MVAIsoWP80_branch
    cdef float e1MVAIsoWP80_value

    cdef TBranch* e1MVAIsoWP90_branch
    cdef float e1MVAIsoWP90_value

    cdef TBranch* e1MVANoisoWP80_branch
    cdef float e1MVANoisoWP80_value

    cdef TBranch* e1MVANoisoWP90_branch
    cdef float e1MVANoisoWP90_value

    cdef TBranch* e1Mass_branch
    cdef float e1Mass_value

    cdef TBranch* e1MatchEmbeddedFilterEle24Tau30_branch
    cdef float e1MatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* e1MatchEmbeddedFilterEle27_branch
    cdef float e1MatchEmbeddedFilterEle27_value

    cdef TBranch* e1MatchEmbeddedFilterEle32_branch
    cdef float e1MatchEmbeddedFilterEle32_value

    cdef TBranch* e1MatchEmbeddedFilterEle32DoubleL1_v1_branch
    cdef float e1MatchEmbeddedFilterEle32DoubleL1_v1_value

    cdef TBranch* e1MatchEmbeddedFilterEle32DoubleL1_v2_branch
    cdef float e1MatchEmbeddedFilterEle32DoubleL1_v2_value

    cdef TBranch* e1MatchEmbeddedFilterEle35_branch
    cdef float e1MatchEmbeddedFilterEle35_value

    cdef TBranch* e1MatchesEle24HPSTau30Filter_branch
    cdef float e1MatchesEle24HPSTau30Filter_value

    cdef TBranch* e1MatchesEle24HPSTau30Path_branch
    cdef float e1MatchesEle24HPSTau30Path_value

    cdef TBranch* e1MatchesEle24Tau30Filter_branch
    cdef float e1MatchesEle24Tau30Filter_value

    cdef TBranch* e1MatchesEle24Tau30Path_branch
    cdef float e1MatchesEle24Tau30Path_value

    cdef TBranch* e1MatchesEle25Filter_branch
    cdef float e1MatchesEle25Filter_value

    cdef TBranch* e1MatchesEle25Path_branch
    cdef float e1MatchesEle25Path_value

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

    cdef TBranch* e1MatchesMu23e12DZFilter_branch
    cdef float e1MatchesMu23e12DZFilter_value

    cdef TBranch* e1MatchesMu23e12DZPath_branch
    cdef float e1MatchesMu23e12DZPath_value

    cdef TBranch* e1MatchesMu23e12Filter_branch
    cdef float e1MatchesMu23e12Filter_value

    cdef TBranch* e1MatchesMu23e12Path_branch
    cdef float e1MatchesMu23e12Path_value

    cdef TBranch* e1MatchesMu8e23DZFilter_branch
    cdef float e1MatchesMu8e23DZFilter_value

    cdef TBranch* e1MatchesMu8e23DZPath_branch
    cdef float e1MatchesMu8e23DZPath_value

    cdef TBranch* e1MatchesMu8e23Filter_branch
    cdef float e1MatchesMu8e23Filter_value

    cdef TBranch* e1MatchesMu8e23Path_branch
    cdef float e1MatchesMu8e23Path_value

    cdef TBranch* e1MissingHits_branch
    cdef float e1MissingHits_value

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

    cdef TBranch* e1SIP2D_branch
    cdef float e1SIP2D_value

    cdef TBranch* e1SIP3D_branch
    cdef float e1SIP3D_value

    cdef TBranch* e1TrkIsoDR03_branch
    cdef float e1TrkIsoDR03_value

    cdef TBranch* e1VZ_branch
    cdef float e1VZ_value

    cdef TBranch* e1ZTTGenMatching_branch
    cdef float e1ZTTGenMatching_value

    cdef TBranch* e1_e2_DR_branch
    cdef float e1_e2_DR_value

    cdef TBranch* e1_e2_Mass_branch
    cdef float e1_e2_Mass_value

    cdef TBranch* e1_e2_PZeta_branch
    cdef float e1_e2_PZeta_value

    cdef TBranch* e1_e2_PZetaVis_branch
    cdef float e1_e2_PZetaVis_value

    cdef TBranch* e1_e2_doubleL1IsoTauMatch_branch
    cdef float e1_e2_doubleL1IsoTauMatch_value

    cdef TBranch* e1_t_DR_branch
    cdef float e1_t_DR_value

    cdef TBranch* e1_t_Mass_branch
    cdef float e1_t_Mass_value

    cdef TBranch* e1_t_PZeta_branch
    cdef float e1_t_PZeta_value

    cdef TBranch* e1_t_PZetaVis_branch
    cdef float e1_t_PZetaVis_value

    cdef TBranch* e1_t_doubleL1IsoTauMatch_branch
    cdef float e1_t_doubleL1IsoTauMatch_value

    cdef TBranch* e1ecalEnergy_branch
    cdef float e1ecalEnergy_value

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

    cdef TBranch* e2CorrectedEt_branch
    cdef float e2CorrectedEt_value

    cdef TBranch* e2EcalIsoDR03_branch
    cdef float e2EcalIsoDR03_value

    cdef TBranch* e2EnergyError_branch
    cdef float e2EnergyError_value

    cdef TBranch* e2EnergyScaleDown_branch
    cdef float e2EnergyScaleDown_value

    cdef TBranch* e2EnergyScaleGainDown_branch
    cdef float e2EnergyScaleGainDown_value

    cdef TBranch* e2EnergyScaleGainUp_branch
    cdef float e2EnergyScaleGainUp_value

    cdef TBranch* e2EnergyScaleStatDown_branch
    cdef float e2EnergyScaleStatDown_value

    cdef TBranch* e2EnergyScaleStatUp_branch
    cdef float e2EnergyScaleStatUp_value

    cdef TBranch* e2EnergyScaleSystDown_branch
    cdef float e2EnergyScaleSystDown_value

    cdef TBranch* e2EnergyScaleSystUp_branch
    cdef float e2EnergyScaleSystUp_value

    cdef TBranch* e2EnergyScaleUp_branch
    cdef float e2EnergyScaleUp_value

    cdef TBranch* e2EnergySigmaDown_branch
    cdef float e2EnergySigmaDown_value

    cdef TBranch* e2EnergySigmaPhiDown_branch
    cdef float e2EnergySigmaPhiDown_value

    cdef TBranch* e2EnergySigmaPhiUp_branch
    cdef float e2EnergySigmaPhiUp_value

    cdef TBranch* e2EnergySigmaRhoDown_branch
    cdef float e2EnergySigmaRhoDown_value

    cdef TBranch* e2EnergySigmaRhoUp_branch
    cdef float e2EnergySigmaRhoUp_value

    cdef TBranch* e2EnergySigmaUp_branch
    cdef float e2EnergySigmaUp_value

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

    cdef TBranch* e2MVAIsoWP80_branch
    cdef float e2MVAIsoWP80_value

    cdef TBranch* e2MVAIsoWP90_branch
    cdef float e2MVAIsoWP90_value

    cdef TBranch* e2MVANoisoWP80_branch
    cdef float e2MVANoisoWP80_value

    cdef TBranch* e2MVANoisoWP90_branch
    cdef float e2MVANoisoWP90_value

    cdef TBranch* e2Mass_branch
    cdef float e2Mass_value

    cdef TBranch* e2MatchEmbeddedFilterEle24Tau30_branch
    cdef float e2MatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* e2MatchEmbeddedFilterEle27_branch
    cdef float e2MatchEmbeddedFilterEle27_value

    cdef TBranch* e2MatchEmbeddedFilterEle32_branch
    cdef float e2MatchEmbeddedFilterEle32_value

    cdef TBranch* e2MatchEmbeddedFilterEle32DoubleL1_v1_branch
    cdef float e2MatchEmbeddedFilterEle32DoubleL1_v1_value

    cdef TBranch* e2MatchEmbeddedFilterEle32DoubleL1_v2_branch
    cdef float e2MatchEmbeddedFilterEle32DoubleL1_v2_value

    cdef TBranch* e2MatchEmbeddedFilterEle35_branch
    cdef float e2MatchEmbeddedFilterEle35_value

    cdef TBranch* e2MatchesEle24HPSTau30Filter_branch
    cdef float e2MatchesEle24HPSTau30Filter_value

    cdef TBranch* e2MatchesEle24HPSTau30Path_branch
    cdef float e2MatchesEle24HPSTau30Path_value

    cdef TBranch* e2MatchesEle24Tau30Filter_branch
    cdef float e2MatchesEle24Tau30Filter_value

    cdef TBranch* e2MatchesEle24Tau30Path_branch
    cdef float e2MatchesEle24Tau30Path_value

    cdef TBranch* e2MatchesEle25Filter_branch
    cdef float e2MatchesEle25Filter_value

    cdef TBranch* e2MatchesEle25Path_branch
    cdef float e2MatchesEle25Path_value

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

    cdef TBranch* e2MatchesMu23e12DZFilter_branch
    cdef float e2MatchesMu23e12DZFilter_value

    cdef TBranch* e2MatchesMu23e12DZPath_branch
    cdef float e2MatchesMu23e12DZPath_value

    cdef TBranch* e2MatchesMu23e12Filter_branch
    cdef float e2MatchesMu23e12Filter_value

    cdef TBranch* e2MatchesMu23e12Path_branch
    cdef float e2MatchesMu23e12Path_value

    cdef TBranch* e2MatchesMu8e23DZFilter_branch
    cdef float e2MatchesMu8e23DZFilter_value

    cdef TBranch* e2MatchesMu8e23DZPath_branch
    cdef float e2MatchesMu8e23DZPath_value

    cdef TBranch* e2MatchesMu8e23Filter_branch
    cdef float e2MatchesMu8e23Filter_value

    cdef TBranch* e2MatchesMu8e23Path_branch
    cdef float e2MatchesMu8e23Path_value

    cdef TBranch* e2MissingHits_branch
    cdef float e2MissingHits_value

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

    cdef TBranch* e2SIP2D_branch
    cdef float e2SIP2D_value

    cdef TBranch* e2SIP3D_branch
    cdef float e2SIP3D_value

    cdef TBranch* e2TrkIsoDR03_branch
    cdef float e2TrkIsoDR03_value

    cdef TBranch* e2VZ_branch
    cdef float e2VZ_value

    cdef TBranch* e2ZTTGenMatching_branch
    cdef float e2ZTTGenMatching_value

    cdef TBranch* e2_t_DR_branch
    cdef float e2_t_DR_value

    cdef TBranch* e2_t_Mass_branch
    cdef float e2_t_Mass_value

    cdef TBranch* e2_t_PZeta_branch
    cdef float e2_t_PZeta_value

    cdef TBranch* e2_t_PZetaVis_branch
    cdef float e2_t_PZetaVis_value

    cdef TBranch* e2_t_doubleL1IsoTauMatch_branch
    cdef float e2_t_doubleL1IsoTauMatch_value

    cdef TBranch* e2ecalEnergy_branch
    cdef float e2ecalEnergy_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

    cdef TBranch* eVetoZTTp001dxyz_branch
    cdef float eVetoZTTp001dxyz_value

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

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

    cdef TBranch* jetVeto30WoNoisyJets_branch
    cdef float jetVeto30WoNoisyJets_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnDown_branch
    cdef float jetVeto30WoNoisyJets_JetEnDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnUp_branch
    cdef float jetVeto30WoNoisyJets_JetEnUp_value

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

    cdef TBranch* tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    cdef TBranch* tByIsolationMVArun2v1DBoldDMwLTraw_branch
    cdef float tByIsolationMVArun2v1DBoldDMwLTraw_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByMediumIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByMediumIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByPhotonPtSumOutsideSignalCone_branch
    cdef float tByPhotonPtSumOutsideSignalCone_value

    cdef TBranch* tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVLooseIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    cdef TBranch* tByVTightIsolationMVArun2v1DBoldDMwLT_branch
    cdef float tByVTightIsolationMVArun2v1DBoldDMwLT_value

    cdef TBranch* tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch
    cdef float tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

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

    cdef TBranch* tDeepTau2017v2p1VSeraw_branch
    cdef float tDeepTau2017v2p1VSeraw_value

    cdef TBranch* tDeepTau2017v2p1VSjetraw_branch
    cdef float tDeepTau2017v2p1VSjetraw_value

    cdef TBranch* tDeepTau2017v2p1VSmuraw_branch
    cdef float tDeepTau2017v2p1VSmuraw_value

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

    cdef TBranch* tMatchEmbeddedFilterMu19Tau20_branch
    cdef float tMatchEmbeddedFilterMu19Tau20_value

    cdef TBranch* tMatchEmbeddedFilterMu20HPSTau27_branch
    cdef float tMatchEmbeddedFilterMu20HPSTau27_value

    cdef TBranch* tMatchEmbeddedFilterMu20Tau27_branch
    cdef float tMatchEmbeddedFilterMu20Tau27_value

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

    cdef TBranch* tVVLooseDeepTau2017v2p1VSmu_branch
    cdef float tVVLooseDeepTau2017v2p1VSmu_value

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

    cdef TBranch* tVVVLooseDeepTau2017v2p1VSmu_branch
    cdef float tVVVLooseDeepTau2017v2p1VSmu_value

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
            warnings.warn( "EETauTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "EETauTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "EETauTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "EETauTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "EETauTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "EETauTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "EETauTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "EETauTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "EETauTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "EETauTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "EETauTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "EETauTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "EETauTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "EETauTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "EETauTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "EETauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EETauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EETauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EETauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EETauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EETauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EETauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EETauTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EETauTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EETauTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "EETauTree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EETauTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "EETauTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EETauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EETauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EETauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EETauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "EETauTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "EETauTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EETauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EETauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EETauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EETauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EETauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EETauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EETauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EETauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "EETauTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "EETauTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "EETauTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "EETauTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "EETauTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EETauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EETauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EETauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "EETauTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "EETauTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making bweight_2016"
        self.bweight_2016_branch = the_tree.GetBranch("bweight_2016")
        #if not self.bweight_2016_branch and "bweight_2016" not in self.complained:
        if not self.bweight_2016_branch and "bweight_2016":
            warnings.warn( "EETauTree: Expected branch bweight_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2016")
        else:
            self.bweight_2016_branch.SetAddress(<void*>&self.bweight_2016_value)

        #print "making bweight_2017"
        self.bweight_2017_branch = the_tree.GetBranch("bweight_2017")
        #if not self.bweight_2017_branch and "bweight_2017" not in self.complained:
        if not self.bweight_2017_branch and "bweight_2017":
            warnings.warn( "EETauTree: Expected branch bweight_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2017")
        else:
            self.bweight_2017_branch.SetAddress(<void*>&self.bweight_2017_value)

        #print "making bweight_2018"
        self.bweight_2018_branch = the_tree.GetBranch("bweight_2018")
        #if not self.bweight_2018_branch and "bweight_2018" not in self.complained:
        if not self.bweight_2018_branch and "bweight_2018":
            warnings.warn( "EETauTree: Expected branch bweight_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2018")
        else:
            self.bweight_2018_branch.SetAddress(<void*>&self.bweight_2018_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EETauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EETauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "EETauTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EETauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "EETauTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "EETauTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EETauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "EETauTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "EETauTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "EETauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "EETauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "EETauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EETauTree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EETauTree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1CorrectedEt"
        self.e1CorrectedEt_branch = the_tree.GetBranch("e1CorrectedEt")
        #if not self.e1CorrectedEt_branch and "e1CorrectedEt" not in self.complained:
        if not self.e1CorrectedEt_branch and "e1CorrectedEt":
            warnings.warn( "EETauTree: Expected branch e1CorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CorrectedEt")
        else:
            self.e1CorrectedEt_branch.SetAddress(<void*>&self.e1CorrectedEt_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EETauTree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1EnergyScaleDown"
        self.e1EnergyScaleDown_branch = the_tree.GetBranch("e1EnergyScaleDown")
        #if not self.e1EnergyScaleDown_branch and "e1EnergyScaleDown" not in self.complained:
        if not self.e1EnergyScaleDown_branch and "e1EnergyScaleDown":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleDown")
        else:
            self.e1EnergyScaleDown_branch.SetAddress(<void*>&self.e1EnergyScaleDown_value)

        #print "making e1EnergyScaleGainDown"
        self.e1EnergyScaleGainDown_branch = the_tree.GetBranch("e1EnergyScaleGainDown")
        #if not self.e1EnergyScaleGainDown_branch and "e1EnergyScaleGainDown" not in self.complained:
        if not self.e1EnergyScaleGainDown_branch and "e1EnergyScaleGainDown":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleGainDown")
        else:
            self.e1EnergyScaleGainDown_branch.SetAddress(<void*>&self.e1EnergyScaleGainDown_value)

        #print "making e1EnergyScaleGainUp"
        self.e1EnergyScaleGainUp_branch = the_tree.GetBranch("e1EnergyScaleGainUp")
        #if not self.e1EnergyScaleGainUp_branch and "e1EnergyScaleGainUp" not in self.complained:
        if not self.e1EnergyScaleGainUp_branch and "e1EnergyScaleGainUp":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleGainUp")
        else:
            self.e1EnergyScaleGainUp_branch.SetAddress(<void*>&self.e1EnergyScaleGainUp_value)

        #print "making e1EnergyScaleStatDown"
        self.e1EnergyScaleStatDown_branch = the_tree.GetBranch("e1EnergyScaleStatDown")
        #if not self.e1EnergyScaleStatDown_branch and "e1EnergyScaleStatDown" not in self.complained:
        if not self.e1EnergyScaleStatDown_branch and "e1EnergyScaleStatDown":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleStatDown")
        else:
            self.e1EnergyScaleStatDown_branch.SetAddress(<void*>&self.e1EnergyScaleStatDown_value)

        #print "making e1EnergyScaleStatUp"
        self.e1EnergyScaleStatUp_branch = the_tree.GetBranch("e1EnergyScaleStatUp")
        #if not self.e1EnergyScaleStatUp_branch and "e1EnergyScaleStatUp" not in self.complained:
        if not self.e1EnergyScaleStatUp_branch and "e1EnergyScaleStatUp":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleStatUp")
        else:
            self.e1EnergyScaleStatUp_branch.SetAddress(<void*>&self.e1EnergyScaleStatUp_value)

        #print "making e1EnergyScaleSystDown"
        self.e1EnergyScaleSystDown_branch = the_tree.GetBranch("e1EnergyScaleSystDown")
        #if not self.e1EnergyScaleSystDown_branch and "e1EnergyScaleSystDown" not in self.complained:
        if not self.e1EnergyScaleSystDown_branch and "e1EnergyScaleSystDown":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleSystDown")
        else:
            self.e1EnergyScaleSystDown_branch.SetAddress(<void*>&self.e1EnergyScaleSystDown_value)

        #print "making e1EnergyScaleSystUp"
        self.e1EnergyScaleSystUp_branch = the_tree.GetBranch("e1EnergyScaleSystUp")
        #if not self.e1EnergyScaleSystUp_branch and "e1EnergyScaleSystUp" not in self.complained:
        if not self.e1EnergyScaleSystUp_branch and "e1EnergyScaleSystUp":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleSystUp")
        else:
            self.e1EnergyScaleSystUp_branch.SetAddress(<void*>&self.e1EnergyScaleSystUp_value)

        #print "making e1EnergyScaleUp"
        self.e1EnergyScaleUp_branch = the_tree.GetBranch("e1EnergyScaleUp")
        #if not self.e1EnergyScaleUp_branch and "e1EnergyScaleUp" not in self.complained:
        if not self.e1EnergyScaleUp_branch and "e1EnergyScaleUp":
            warnings.warn( "EETauTree: Expected branch e1EnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleUp")
        else:
            self.e1EnergyScaleUp_branch.SetAddress(<void*>&self.e1EnergyScaleUp_value)

        #print "making e1EnergySigmaDown"
        self.e1EnergySigmaDown_branch = the_tree.GetBranch("e1EnergySigmaDown")
        #if not self.e1EnergySigmaDown_branch and "e1EnergySigmaDown" not in self.complained:
        if not self.e1EnergySigmaDown_branch and "e1EnergySigmaDown":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaDown")
        else:
            self.e1EnergySigmaDown_branch.SetAddress(<void*>&self.e1EnergySigmaDown_value)

        #print "making e1EnergySigmaPhiDown"
        self.e1EnergySigmaPhiDown_branch = the_tree.GetBranch("e1EnergySigmaPhiDown")
        #if not self.e1EnergySigmaPhiDown_branch and "e1EnergySigmaPhiDown" not in self.complained:
        if not self.e1EnergySigmaPhiDown_branch and "e1EnergySigmaPhiDown":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaPhiDown")
        else:
            self.e1EnergySigmaPhiDown_branch.SetAddress(<void*>&self.e1EnergySigmaPhiDown_value)

        #print "making e1EnergySigmaPhiUp"
        self.e1EnergySigmaPhiUp_branch = the_tree.GetBranch("e1EnergySigmaPhiUp")
        #if not self.e1EnergySigmaPhiUp_branch and "e1EnergySigmaPhiUp" not in self.complained:
        if not self.e1EnergySigmaPhiUp_branch and "e1EnergySigmaPhiUp":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaPhiUp")
        else:
            self.e1EnergySigmaPhiUp_branch.SetAddress(<void*>&self.e1EnergySigmaPhiUp_value)

        #print "making e1EnergySigmaRhoDown"
        self.e1EnergySigmaRhoDown_branch = the_tree.GetBranch("e1EnergySigmaRhoDown")
        #if not self.e1EnergySigmaRhoDown_branch and "e1EnergySigmaRhoDown" not in self.complained:
        if not self.e1EnergySigmaRhoDown_branch and "e1EnergySigmaRhoDown":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaRhoDown")
        else:
            self.e1EnergySigmaRhoDown_branch.SetAddress(<void*>&self.e1EnergySigmaRhoDown_value)

        #print "making e1EnergySigmaRhoUp"
        self.e1EnergySigmaRhoUp_branch = the_tree.GetBranch("e1EnergySigmaRhoUp")
        #if not self.e1EnergySigmaRhoUp_branch and "e1EnergySigmaRhoUp" not in self.complained:
        if not self.e1EnergySigmaRhoUp_branch and "e1EnergySigmaRhoUp":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaRhoUp")
        else:
            self.e1EnergySigmaRhoUp_branch.SetAddress(<void*>&self.e1EnergySigmaRhoUp_value)

        #print "making e1EnergySigmaUp"
        self.e1EnergySigmaUp_branch = the_tree.GetBranch("e1EnergySigmaUp")
        #if not self.e1EnergySigmaUp_branch and "e1EnergySigmaUp" not in self.complained:
        if not self.e1EnergySigmaUp_branch and "e1EnergySigmaUp":
            warnings.warn( "EETauTree: Expected branch e1EnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaUp")
        else:
            self.e1EnergySigmaUp_branch.SetAddress(<void*>&self.e1EnergySigmaUp_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EETauTree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EETauTree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenDirectPromptTauDecay"
        self.e1GenDirectPromptTauDecay_branch = the_tree.GetBranch("e1GenDirectPromptTauDecay")
        #if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay" not in self.complained:
        if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenDirectPromptTauDecay")
        else:
            self.e1GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e1GenDirectPromptTauDecay_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EETauTree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EETauTree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenIsPrompt"
        self.e1GenIsPrompt_branch = the_tree.GetBranch("e1GenIsPrompt")
        #if not self.e1GenIsPrompt_branch and "e1GenIsPrompt" not in self.complained:
        if not self.e1GenIsPrompt_branch and "e1GenIsPrompt":
            warnings.warn( "EETauTree: Expected branch e1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenIsPrompt")
        else:
            self.e1GenIsPrompt_branch.SetAddress(<void*>&self.e1GenIsPrompt_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenParticle"
        self.e1GenParticle_branch = the_tree.GetBranch("e1GenParticle")
        #if not self.e1GenParticle_branch and "e1GenParticle" not in self.complained:
        if not self.e1GenParticle_branch and "e1GenParticle":
            warnings.warn( "EETauTree: Expected branch e1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenParticle")
        else:
            self.e1GenParticle_branch.SetAddress(<void*>&self.e1GenParticle_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EETauTree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EETauTree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1GenPrompt"
        self.e1GenPrompt_branch = the_tree.GetBranch("e1GenPrompt")
        #if not self.e1GenPrompt_branch and "e1GenPrompt" not in self.complained:
        if not self.e1GenPrompt_branch and "e1GenPrompt":
            warnings.warn( "EETauTree: Expected branch e1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPrompt")
        else:
            self.e1GenPrompt_branch.SetAddress(<void*>&self.e1GenPrompt_value)

        #print "making e1GenPromptTauDecay"
        self.e1GenPromptTauDecay_branch = the_tree.GetBranch("e1GenPromptTauDecay")
        #if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay" not in self.complained:
        if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPromptTauDecay")
        else:
            self.e1GenPromptTauDecay_branch.SetAddress(<void*>&self.e1GenPromptTauDecay_value)

        #print "making e1GenPt"
        self.e1GenPt_branch = the_tree.GetBranch("e1GenPt")
        #if not self.e1GenPt_branch and "e1GenPt" not in self.complained:
        if not self.e1GenPt_branch and "e1GenPt":
            warnings.warn( "EETauTree: Expected branch e1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPt")
        else:
            self.e1GenPt_branch.SetAddress(<void*>&self.e1GenPt_value)

        #print "making e1GenTauDecay"
        self.e1GenTauDecay_branch = the_tree.GetBranch("e1GenTauDecay")
        #if not self.e1GenTauDecay_branch and "e1GenTauDecay" not in self.complained:
        if not self.e1GenTauDecay_branch and "e1GenTauDecay":
            warnings.warn( "EETauTree: Expected branch e1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenTauDecay")
        else:
            self.e1GenTauDecay_branch.SetAddress(<void*>&self.e1GenTauDecay_value)

        #print "making e1GenVZ"
        self.e1GenVZ_branch = the_tree.GetBranch("e1GenVZ")
        #if not self.e1GenVZ_branch and "e1GenVZ" not in self.complained:
        if not self.e1GenVZ_branch and "e1GenVZ":
            warnings.warn( "EETauTree: Expected branch e1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVZ")
        else:
            self.e1GenVZ_branch.SetAddress(<void*>&self.e1GenVZ_value)

        #print "making e1GenVtxPVMatch"
        self.e1GenVtxPVMatch_branch = the_tree.GetBranch("e1GenVtxPVMatch")
        #if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch" not in self.complained:
        if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch":
            warnings.warn( "EETauTree: Expected branch e1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVtxPVMatch")
        else:
            self.e1GenVtxPVMatch_branch.SetAddress(<void*>&self.e1GenVtxPVMatch_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3D"
        self.e1IP3D_branch = the_tree.GetBranch("e1IP3D")
        #if not self.e1IP3D_branch and "e1IP3D" not in self.complained:
        if not self.e1IP3D_branch and "e1IP3D":
            warnings.warn( "EETauTree: Expected branch e1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3D")
        else:
            self.e1IP3D_branch.SetAddress(<void*>&self.e1IP3D_value)

        #print "making e1IP3DErr"
        self.e1IP3DErr_branch = the_tree.GetBranch("e1IP3DErr")
        #if not self.e1IP3DErr_branch and "e1IP3DErr" not in self.complained:
        if not self.e1IP3DErr_branch and "e1IP3DErr":
            warnings.warn( "EETauTree: Expected branch e1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DErr")
        else:
            self.e1IP3DErr_branch.SetAddress(<void*>&self.e1IP3DErr_value)

        #print "making e1IsoDB03"
        self.e1IsoDB03_branch = the_tree.GetBranch("e1IsoDB03")
        #if not self.e1IsoDB03_branch and "e1IsoDB03" not in self.complained:
        if not self.e1IsoDB03_branch and "e1IsoDB03":
            warnings.warn( "EETauTree: Expected branch e1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IsoDB03")
        else:
            self.e1IsoDB03_branch.SetAddress(<void*>&self.e1IsoDB03_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EETauTree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EETauTree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetDR"
        self.e1JetDR_branch = the_tree.GetBranch("e1JetDR")
        #if not self.e1JetDR_branch and "e1JetDR" not in self.complained:
        if not self.e1JetDR_branch and "e1JetDR":
            warnings.warn( "EETauTree: Expected branch e1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetDR")
        else:
            self.e1JetDR_branch.SetAddress(<void*>&self.e1JetDR_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetHadronFlavour"
        self.e1JetHadronFlavour_branch = the_tree.GetBranch("e1JetHadronFlavour")
        #if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour" not in self.complained:
        if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch e1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetHadronFlavour")
        else:
            self.e1JetHadronFlavour_branch.SetAddress(<void*>&self.e1JetHadronFlavour_value)

        #print "making e1JetPFCISVBtag"
        self.e1JetPFCISVBtag_branch = the_tree.GetBranch("e1JetPFCISVBtag")
        #if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag" not in self.complained:
        if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch e1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPFCISVBtag")
        else:
            self.e1JetPFCISVBtag_branch.SetAddress(<void*>&self.e1JetPFCISVBtag_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EETauTree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1LowestMll"
        self.e1LowestMll_branch = the_tree.GetBranch("e1LowestMll")
        #if not self.e1LowestMll_branch and "e1LowestMll" not in self.complained:
        if not self.e1LowestMll_branch and "e1LowestMll":
            warnings.warn( "EETauTree: Expected branch e1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1LowestMll")
        else:
            self.e1LowestMll_branch.SetAddress(<void*>&self.e1LowestMll_value)

        #print "making e1MVAIsoWP80"
        self.e1MVAIsoWP80_branch = the_tree.GetBranch("e1MVAIsoWP80")
        #if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80" not in self.complained:
        if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80":
            warnings.warn( "EETauTree: Expected branch e1MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP80")
        else:
            self.e1MVAIsoWP80_branch.SetAddress(<void*>&self.e1MVAIsoWP80_value)

        #print "making e1MVAIsoWP90"
        self.e1MVAIsoWP90_branch = the_tree.GetBranch("e1MVAIsoWP90")
        #if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90" not in self.complained:
        if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90":
            warnings.warn( "EETauTree: Expected branch e1MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP90")
        else:
            self.e1MVAIsoWP90_branch.SetAddress(<void*>&self.e1MVAIsoWP90_value)

        #print "making e1MVANoisoWP80"
        self.e1MVANoisoWP80_branch = the_tree.GetBranch("e1MVANoisoWP80")
        #if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80" not in self.complained:
        if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80":
            warnings.warn( "EETauTree: Expected branch e1MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP80")
        else:
            self.e1MVANoisoWP80_branch.SetAddress(<void*>&self.e1MVANoisoWP80_value)

        #print "making e1MVANoisoWP90"
        self.e1MVANoisoWP90_branch = the_tree.GetBranch("e1MVANoisoWP90")
        #if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90" not in self.complained:
        if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90":
            warnings.warn( "EETauTree: Expected branch e1MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP90")
        else:
            self.e1MVANoisoWP90_branch.SetAddress(<void*>&self.e1MVANoisoWP90_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EETauTree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchEmbeddedFilterEle24Tau30"
        self.e1MatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle24Tau30")
        #if not self.e1MatchEmbeddedFilterEle24Tau30_branch and "e1MatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle24Tau30_branch and "e1MatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle24Tau30")
        else:
            self.e1MatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle24Tau30_value)

        #print "making e1MatchEmbeddedFilterEle27"
        self.e1MatchEmbeddedFilterEle27_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle27")
        #if not self.e1MatchEmbeddedFilterEle27_branch and "e1MatchEmbeddedFilterEle27" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle27_branch and "e1MatchEmbeddedFilterEle27":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle27")
        else:
            self.e1MatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle27_value)

        #print "making e1MatchEmbeddedFilterEle32"
        self.e1MatchEmbeddedFilterEle32_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32")
        #if not self.e1MatchEmbeddedFilterEle32_branch and "e1MatchEmbeddedFilterEle32" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32_branch and "e1MatchEmbeddedFilterEle32":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32")
        else:
            self.e1MatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32_value)

        #print "making e1MatchEmbeddedFilterEle32DoubleL1_v1"
        self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making e1MatchEmbeddedFilterEle32DoubleL1_v2"
        self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making e1MatchEmbeddedFilterEle35"
        self.e1MatchEmbeddedFilterEle35_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle35")
        #if not self.e1MatchEmbeddedFilterEle35_branch and "e1MatchEmbeddedFilterEle35" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle35_branch and "e1MatchEmbeddedFilterEle35":
            warnings.warn( "EETauTree: Expected branch e1MatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle35")
        else:
            self.e1MatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle35_value)

        #print "making e1MatchesEle24HPSTau30Filter"
        self.e1MatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("e1MatchesEle24HPSTau30Filter")
        #if not self.e1MatchesEle24HPSTau30Filter_branch and "e1MatchesEle24HPSTau30Filter" not in self.complained:
        if not self.e1MatchesEle24HPSTau30Filter_branch and "e1MatchesEle24HPSTau30Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24HPSTau30Filter")
        else:
            self.e1MatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24HPSTau30Filter_value)

        #print "making e1MatchesEle24HPSTau30Path"
        self.e1MatchesEle24HPSTau30Path_branch = the_tree.GetBranch("e1MatchesEle24HPSTau30Path")
        #if not self.e1MatchesEle24HPSTau30Path_branch and "e1MatchesEle24HPSTau30Path" not in self.complained:
        if not self.e1MatchesEle24HPSTau30Path_branch and "e1MatchesEle24HPSTau30Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24HPSTau30Path")
        else:
            self.e1MatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24HPSTau30Path_value)

        #print "making e1MatchesEle24Tau30Filter"
        self.e1MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau30Filter")
        #if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter" not in self.complained:
        if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Filter")
        else:
            self.e1MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Filter_value)

        #print "making e1MatchesEle24Tau30Path"
        self.e1MatchesEle24Tau30Path_branch = the_tree.GetBranch("e1MatchesEle24Tau30Path")
        #if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path" not in self.complained:
        if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Path")
        else:
            self.e1MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Path_value)

        #print "making e1MatchesEle25Filter"
        self.e1MatchesEle25Filter_branch = the_tree.GetBranch("e1MatchesEle25Filter")
        #if not self.e1MatchesEle25Filter_branch and "e1MatchesEle25Filter" not in self.complained:
        if not self.e1MatchesEle25Filter_branch and "e1MatchesEle25Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25Filter")
        else:
            self.e1MatchesEle25Filter_branch.SetAddress(<void*>&self.e1MatchesEle25Filter_value)

        #print "making e1MatchesEle25Path"
        self.e1MatchesEle25Path_branch = the_tree.GetBranch("e1MatchesEle25Path")
        #if not self.e1MatchesEle25Path_branch and "e1MatchesEle25Path" not in self.complained:
        if not self.e1MatchesEle25Path_branch and "e1MatchesEle25Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25Path")
        else:
            self.e1MatchesEle25Path_branch.SetAddress(<void*>&self.e1MatchesEle25Path_value)

        #print "making e1MatchesEle27Filter"
        self.e1MatchesEle27Filter_branch = the_tree.GetBranch("e1MatchesEle27Filter")
        #if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter" not in self.complained:
        if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Filter")
        else:
            self.e1MatchesEle27Filter_branch.SetAddress(<void*>&self.e1MatchesEle27Filter_value)

        #print "making e1MatchesEle27Path"
        self.e1MatchesEle27Path_branch = the_tree.GetBranch("e1MatchesEle27Path")
        #if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path" not in self.complained:
        if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Path")
        else:
            self.e1MatchesEle27Path_branch.SetAddress(<void*>&self.e1MatchesEle27Path_value)

        #print "making e1MatchesEle32Filter"
        self.e1MatchesEle32Filter_branch = the_tree.GetBranch("e1MatchesEle32Filter")
        #if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter" not in self.complained:
        if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Filter")
        else:
            self.e1MatchesEle32Filter_branch.SetAddress(<void*>&self.e1MatchesEle32Filter_value)

        #print "making e1MatchesEle32Path"
        self.e1MatchesEle32Path_branch = the_tree.GetBranch("e1MatchesEle32Path")
        #if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path" not in self.complained:
        if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Path")
        else:
            self.e1MatchesEle32Path_branch.SetAddress(<void*>&self.e1MatchesEle32Path_value)

        #print "making e1MatchesEle35Filter"
        self.e1MatchesEle35Filter_branch = the_tree.GetBranch("e1MatchesEle35Filter")
        #if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter" not in self.complained:
        if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Filter")
        else:
            self.e1MatchesEle35Filter_branch.SetAddress(<void*>&self.e1MatchesEle35Filter_value)

        #print "making e1MatchesEle35Path"
        self.e1MatchesEle35Path_branch = the_tree.GetBranch("e1MatchesEle35Path")
        #if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path" not in self.complained:
        if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Path")
        else:
            self.e1MatchesEle35Path_branch.SetAddress(<void*>&self.e1MatchesEle35Path_value)

        #print "making e1MatchesMu23e12DZFilter"
        self.e1MatchesMu23e12DZFilter_branch = the_tree.GetBranch("e1MatchesMu23e12DZFilter")
        #if not self.e1MatchesMu23e12DZFilter_branch and "e1MatchesMu23e12DZFilter" not in self.complained:
        if not self.e1MatchesMu23e12DZFilter_branch and "e1MatchesMu23e12DZFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12DZFilter")
        else:
            self.e1MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu23e12DZFilter_value)

        #print "making e1MatchesMu23e12DZPath"
        self.e1MatchesMu23e12DZPath_branch = the_tree.GetBranch("e1MatchesMu23e12DZPath")
        #if not self.e1MatchesMu23e12DZPath_branch and "e1MatchesMu23e12DZPath" not in self.complained:
        if not self.e1MatchesMu23e12DZPath_branch and "e1MatchesMu23e12DZPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12DZPath")
        else:
            self.e1MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.e1MatchesMu23e12DZPath_value)

        #print "making e1MatchesMu23e12Filter"
        self.e1MatchesMu23e12Filter_branch = the_tree.GetBranch("e1MatchesMu23e12Filter")
        #if not self.e1MatchesMu23e12Filter_branch and "e1MatchesMu23e12Filter" not in self.complained:
        if not self.e1MatchesMu23e12Filter_branch and "e1MatchesMu23e12Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12Filter")
        else:
            self.e1MatchesMu23e12Filter_branch.SetAddress(<void*>&self.e1MatchesMu23e12Filter_value)

        #print "making e1MatchesMu23e12Path"
        self.e1MatchesMu23e12Path_branch = the_tree.GetBranch("e1MatchesMu23e12Path")
        #if not self.e1MatchesMu23e12Path_branch and "e1MatchesMu23e12Path" not in self.complained:
        if not self.e1MatchesMu23e12Path_branch and "e1MatchesMu23e12Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12Path")
        else:
            self.e1MatchesMu23e12Path_branch.SetAddress(<void*>&self.e1MatchesMu23e12Path_value)

        #print "making e1MatchesMu8e23DZFilter"
        self.e1MatchesMu8e23DZFilter_branch = the_tree.GetBranch("e1MatchesMu8e23DZFilter")
        #if not self.e1MatchesMu8e23DZFilter_branch and "e1MatchesMu8e23DZFilter" not in self.complained:
        if not self.e1MatchesMu8e23DZFilter_branch and "e1MatchesMu8e23DZFilter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23DZFilter")
        else:
            self.e1MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu8e23DZFilter_value)

        #print "making e1MatchesMu8e23DZPath"
        self.e1MatchesMu8e23DZPath_branch = the_tree.GetBranch("e1MatchesMu8e23DZPath")
        #if not self.e1MatchesMu8e23DZPath_branch and "e1MatchesMu8e23DZPath" not in self.complained:
        if not self.e1MatchesMu8e23DZPath_branch and "e1MatchesMu8e23DZPath":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23DZPath")
        else:
            self.e1MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.e1MatchesMu8e23DZPath_value)

        #print "making e1MatchesMu8e23Filter"
        self.e1MatchesMu8e23Filter_branch = the_tree.GetBranch("e1MatchesMu8e23Filter")
        #if not self.e1MatchesMu8e23Filter_branch and "e1MatchesMu8e23Filter" not in self.complained:
        if not self.e1MatchesMu8e23Filter_branch and "e1MatchesMu8e23Filter":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23Filter")
        else:
            self.e1MatchesMu8e23Filter_branch.SetAddress(<void*>&self.e1MatchesMu8e23Filter_value)

        #print "making e1MatchesMu8e23Path"
        self.e1MatchesMu8e23Path_branch = the_tree.GetBranch("e1MatchesMu8e23Path")
        #if not self.e1MatchesMu8e23Path_branch and "e1MatchesMu8e23Path" not in self.complained:
        if not self.e1MatchesMu8e23Path_branch and "e1MatchesMu8e23Path":
            warnings.warn( "EETauTree: Expected branch e1MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23Path")
        else:
            self.e1MatchesMu8e23Path_branch.SetAddress(<void*>&self.e1MatchesMu8e23Path_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EETauTree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1NearestMuonDR"
        self.e1NearestMuonDR_branch = the_tree.GetBranch("e1NearestMuonDR")
        #if not self.e1NearestMuonDR_branch and "e1NearestMuonDR" not in self.complained:
        if not self.e1NearestMuonDR_branch and "e1NearestMuonDR":
            warnings.warn( "EETauTree: Expected branch e1NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestMuonDR")
        else:
            self.e1NearestMuonDR_branch.SetAddress(<void*>&self.e1NearestMuonDR_value)

        #print "making e1NearestZMass"
        self.e1NearestZMass_branch = the_tree.GetBranch("e1NearestZMass")
        #if not self.e1NearestZMass_branch and "e1NearestZMass" not in self.complained:
        if not self.e1NearestZMass_branch and "e1NearestZMass":
            warnings.warn( "EETauTree: Expected branch e1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestZMass")
        else:
            self.e1NearestZMass_branch.SetAddress(<void*>&self.e1NearestZMass_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EETauTree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EETauTree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPUChargedIso"
        self.e1PFPUChargedIso_branch = the_tree.GetBranch("e1PFPUChargedIso")
        #if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso" not in self.complained:
        if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso":
            warnings.warn( "EETauTree: Expected branch e1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPUChargedIso")
        else:
            self.e1PFPUChargedIso_branch.SetAddress(<void*>&self.e1PFPUChargedIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EETauTree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EETauTree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EETauTree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1PassesConversionVeto"
        self.e1PassesConversionVeto_branch = the_tree.GetBranch("e1PassesConversionVeto")
        #if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto" not in self.complained:
        if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto":
            warnings.warn( "EETauTree: Expected branch e1PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PassesConversionVeto")
        else:
            self.e1PassesConversionVeto_branch.SetAddress(<void*>&self.e1PassesConversionVeto_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EETauTree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EETauTree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EETauTree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EETauTree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EETauTree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1Rho"
        self.e1Rho_branch = the_tree.GetBranch("e1Rho")
        #if not self.e1Rho_branch and "e1Rho" not in self.complained:
        if not self.e1Rho_branch and "e1Rho":
            warnings.warn( "EETauTree: Expected branch e1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rho")
        else:
            self.e1Rho_branch.SetAddress(<void*>&self.e1Rho_value)

        #print "making e1SIP2D"
        self.e1SIP2D_branch = the_tree.GetBranch("e1SIP2D")
        #if not self.e1SIP2D_branch and "e1SIP2D" not in self.complained:
        if not self.e1SIP2D_branch and "e1SIP2D":
            warnings.warn( "EETauTree: Expected branch e1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP2D")
        else:
            self.e1SIP2D_branch.SetAddress(<void*>&self.e1SIP2D_value)

        #print "making e1SIP3D"
        self.e1SIP3D_branch = the_tree.GetBranch("e1SIP3D")
        #if not self.e1SIP3D_branch and "e1SIP3D" not in self.complained:
        if not self.e1SIP3D_branch and "e1SIP3D":
            warnings.warn( "EETauTree: Expected branch e1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP3D")
        else:
            self.e1SIP3D_branch.SetAddress(<void*>&self.e1SIP3D_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EETauTree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EETauTree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1ZTTGenMatching"
        self.e1ZTTGenMatching_branch = the_tree.GetBranch("e1ZTTGenMatching")
        #if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching" not in self.complained:
        if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch e1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ZTTGenMatching")
        else:
            self.e1ZTTGenMatching_branch.SetAddress(<void*>&self.e1ZTTGenMatching_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EETauTree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EETauTree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_doubleL1IsoTauMatch"
        self.e1_e2_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e1_e2_doubleL1IsoTauMatch")
        #if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch" not in self.complained:
        if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch":
            warnings.warn( "EETauTree: Expected branch e1_e2_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_doubleL1IsoTauMatch")
        else:
            self.e1_e2_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e1_e2_doubleL1IsoTauMatch_value)

        #print "making e1_t_DR"
        self.e1_t_DR_branch = the_tree.GetBranch("e1_t_DR")
        #if not self.e1_t_DR_branch and "e1_t_DR" not in self.complained:
        if not self.e1_t_DR_branch and "e1_t_DR":
            warnings.warn( "EETauTree: Expected branch e1_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_DR")
        else:
            self.e1_t_DR_branch.SetAddress(<void*>&self.e1_t_DR_value)

        #print "making e1_t_Mass"
        self.e1_t_Mass_branch = the_tree.GetBranch("e1_t_Mass")
        #if not self.e1_t_Mass_branch and "e1_t_Mass" not in self.complained:
        if not self.e1_t_Mass_branch and "e1_t_Mass":
            warnings.warn( "EETauTree: Expected branch e1_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_Mass")
        else:
            self.e1_t_Mass_branch.SetAddress(<void*>&self.e1_t_Mass_value)

        #print "making e1_t_PZeta"
        self.e1_t_PZeta_branch = the_tree.GetBranch("e1_t_PZeta")
        #if not self.e1_t_PZeta_branch and "e1_t_PZeta" not in self.complained:
        if not self.e1_t_PZeta_branch and "e1_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e1_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZeta")
        else:
            self.e1_t_PZeta_branch.SetAddress(<void*>&self.e1_t_PZeta_value)

        #print "making e1_t_PZetaVis"
        self.e1_t_PZetaVis_branch = the_tree.GetBranch("e1_t_PZetaVis")
        #if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis" not in self.complained:
        if not self.e1_t_PZetaVis_branch and "e1_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e1_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_PZetaVis")
        else:
            self.e1_t_PZetaVis_branch.SetAddress(<void*>&self.e1_t_PZetaVis_value)

        #print "making e1_t_doubleL1IsoTauMatch"
        self.e1_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e1_t_doubleL1IsoTauMatch")
        #if not self.e1_t_doubleL1IsoTauMatch_branch and "e1_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.e1_t_doubleL1IsoTauMatch_branch and "e1_t_doubleL1IsoTauMatch":
            warnings.warn( "EETauTree: Expected branch e1_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_t_doubleL1IsoTauMatch")
        else:
            self.e1_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e1_t_doubleL1IsoTauMatch_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EETauTree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EETauTree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EETauTree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2CorrectedEt"
        self.e2CorrectedEt_branch = the_tree.GetBranch("e2CorrectedEt")
        #if not self.e2CorrectedEt_branch and "e2CorrectedEt" not in self.complained:
        if not self.e2CorrectedEt_branch and "e2CorrectedEt":
            warnings.warn( "EETauTree: Expected branch e2CorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CorrectedEt")
        else:
            self.e2CorrectedEt_branch.SetAddress(<void*>&self.e2CorrectedEt_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EETauTree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2EnergyScaleDown"
        self.e2EnergyScaleDown_branch = the_tree.GetBranch("e2EnergyScaleDown")
        #if not self.e2EnergyScaleDown_branch and "e2EnergyScaleDown" not in self.complained:
        if not self.e2EnergyScaleDown_branch and "e2EnergyScaleDown":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleDown")
        else:
            self.e2EnergyScaleDown_branch.SetAddress(<void*>&self.e2EnergyScaleDown_value)

        #print "making e2EnergyScaleGainDown"
        self.e2EnergyScaleGainDown_branch = the_tree.GetBranch("e2EnergyScaleGainDown")
        #if not self.e2EnergyScaleGainDown_branch and "e2EnergyScaleGainDown" not in self.complained:
        if not self.e2EnergyScaleGainDown_branch and "e2EnergyScaleGainDown":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleGainDown")
        else:
            self.e2EnergyScaleGainDown_branch.SetAddress(<void*>&self.e2EnergyScaleGainDown_value)

        #print "making e2EnergyScaleGainUp"
        self.e2EnergyScaleGainUp_branch = the_tree.GetBranch("e2EnergyScaleGainUp")
        #if not self.e2EnergyScaleGainUp_branch and "e2EnergyScaleGainUp" not in self.complained:
        if not self.e2EnergyScaleGainUp_branch and "e2EnergyScaleGainUp":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleGainUp")
        else:
            self.e2EnergyScaleGainUp_branch.SetAddress(<void*>&self.e2EnergyScaleGainUp_value)

        #print "making e2EnergyScaleStatDown"
        self.e2EnergyScaleStatDown_branch = the_tree.GetBranch("e2EnergyScaleStatDown")
        #if not self.e2EnergyScaleStatDown_branch and "e2EnergyScaleStatDown" not in self.complained:
        if not self.e2EnergyScaleStatDown_branch and "e2EnergyScaleStatDown":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleStatDown")
        else:
            self.e2EnergyScaleStatDown_branch.SetAddress(<void*>&self.e2EnergyScaleStatDown_value)

        #print "making e2EnergyScaleStatUp"
        self.e2EnergyScaleStatUp_branch = the_tree.GetBranch("e2EnergyScaleStatUp")
        #if not self.e2EnergyScaleStatUp_branch and "e2EnergyScaleStatUp" not in self.complained:
        if not self.e2EnergyScaleStatUp_branch and "e2EnergyScaleStatUp":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleStatUp")
        else:
            self.e2EnergyScaleStatUp_branch.SetAddress(<void*>&self.e2EnergyScaleStatUp_value)

        #print "making e2EnergyScaleSystDown"
        self.e2EnergyScaleSystDown_branch = the_tree.GetBranch("e2EnergyScaleSystDown")
        #if not self.e2EnergyScaleSystDown_branch and "e2EnergyScaleSystDown" not in self.complained:
        if not self.e2EnergyScaleSystDown_branch and "e2EnergyScaleSystDown":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleSystDown")
        else:
            self.e2EnergyScaleSystDown_branch.SetAddress(<void*>&self.e2EnergyScaleSystDown_value)

        #print "making e2EnergyScaleSystUp"
        self.e2EnergyScaleSystUp_branch = the_tree.GetBranch("e2EnergyScaleSystUp")
        #if not self.e2EnergyScaleSystUp_branch and "e2EnergyScaleSystUp" not in self.complained:
        if not self.e2EnergyScaleSystUp_branch and "e2EnergyScaleSystUp":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleSystUp")
        else:
            self.e2EnergyScaleSystUp_branch.SetAddress(<void*>&self.e2EnergyScaleSystUp_value)

        #print "making e2EnergyScaleUp"
        self.e2EnergyScaleUp_branch = the_tree.GetBranch("e2EnergyScaleUp")
        #if not self.e2EnergyScaleUp_branch and "e2EnergyScaleUp" not in self.complained:
        if not self.e2EnergyScaleUp_branch and "e2EnergyScaleUp":
            warnings.warn( "EETauTree: Expected branch e2EnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleUp")
        else:
            self.e2EnergyScaleUp_branch.SetAddress(<void*>&self.e2EnergyScaleUp_value)

        #print "making e2EnergySigmaDown"
        self.e2EnergySigmaDown_branch = the_tree.GetBranch("e2EnergySigmaDown")
        #if not self.e2EnergySigmaDown_branch and "e2EnergySigmaDown" not in self.complained:
        if not self.e2EnergySigmaDown_branch and "e2EnergySigmaDown":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaDown")
        else:
            self.e2EnergySigmaDown_branch.SetAddress(<void*>&self.e2EnergySigmaDown_value)

        #print "making e2EnergySigmaPhiDown"
        self.e2EnergySigmaPhiDown_branch = the_tree.GetBranch("e2EnergySigmaPhiDown")
        #if not self.e2EnergySigmaPhiDown_branch and "e2EnergySigmaPhiDown" not in self.complained:
        if not self.e2EnergySigmaPhiDown_branch and "e2EnergySigmaPhiDown":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaPhiDown")
        else:
            self.e2EnergySigmaPhiDown_branch.SetAddress(<void*>&self.e2EnergySigmaPhiDown_value)

        #print "making e2EnergySigmaPhiUp"
        self.e2EnergySigmaPhiUp_branch = the_tree.GetBranch("e2EnergySigmaPhiUp")
        #if not self.e2EnergySigmaPhiUp_branch and "e2EnergySigmaPhiUp" not in self.complained:
        if not self.e2EnergySigmaPhiUp_branch and "e2EnergySigmaPhiUp":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaPhiUp")
        else:
            self.e2EnergySigmaPhiUp_branch.SetAddress(<void*>&self.e2EnergySigmaPhiUp_value)

        #print "making e2EnergySigmaRhoDown"
        self.e2EnergySigmaRhoDown_branch = the_tree.GetBranch("e2EnergySigmaRhoDown")
        #if not self.e2EnergySigmaRhoDown_branch and "e2EnergySigmaRhoDown" not in self.complained:
        if not self.e2EnergySigmaRhoDown_branch and "e2EnergySigmaRhoDown":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaRhoDown")
        else:
            self.e2EnergySigmaRhoDown_branch.SetAddress(<void*>&self.e2EnergySigmaRhoDown_value)

        #print "making e2EnergySigmaRhoUp"
        self.e2EnergySigmaRhoUp_branch = the_tree.GetBranch("e2EnergySigmaRhoUp")
        #if not self.e2EnergySigmaRhoUp_branch and "e2EnergySigmaRhoUp" not in self.complained:
        if not self.e2EnergySigmaRhoUp_branch and "e2EnergySigmaRhoUp":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaRhoUp")
        else:
            self.e2EnergySigmaRhoUp_branch.SetAddress(<void*>&self.e2EnergySigmaRhoUp_value)

        #print "making e2EnergySigmaUp"
        self.e2EnergySigmaUp_branch = the_tree.GetBranch("e2EnergySigmaUp")
        #if not self.e2EnergySigmaUp_branch and "e2EnergySigmaUp" not in self.complained:
        if not self.e2EnergySigmaUp_branch and "e2EnergySigmaUp":
            warnings.warn( "EETauTree: Expected branch e2EnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaUp")
        else:
            self.e2EnergySigmaUp_branch.SetAddress(<void*>&self.e2EnergySigmaUp_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EETauTree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EETauTree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenDirectPromptTauDecay"
        self.e2GenDirectPromptTauDecay_branch = the_tree.GetBranch("e2GenDirectPromptTauDecay")
        #if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay" not in self.complained:
        if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenDirectPromptTauDecay")
        else:
            self.e2GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e2GenDirectPromptTauDecay_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EETauTree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EETauTree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenIsPrompt"
        self.e2GenIsPrompt_branch = the_tree.GetBranch("e2GenIsPrompt")
        #if not self.e2GenIsPrompt_branch and "e2GenIsPrompt" not in self.complained:
        if not self.e2GenIsPrompt_branch and "e2GenIsPrompt":
            warnings.warn( "EETauTree: Expected branch e2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenIsPrompt")
        else:
            self.e2GenIsPrompt_branch.SetAddress(<void*>&self.e2GenIsPrompt_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenParticle"
        self.e2GenParticle_branch = the_tree.GetBranch("e2GenParticle")
        #if not self.e2GenParticle_branch and "e2GenParticle" not in self.complained:
        if not self.e2GenParticle_branch and "e2GenParticle":
            warnings.warn( "EETauTree: Expected branch e2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenParticle")
        else:
            self.e2GenParticle_branch.SetAddress(<void*>&self.e2GenParticle_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EETauTree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EETauTree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2GenPrompt"
        self.e2GenPrompt_branch = the_tree.GetBranch("e2GenPrompt")
        #if not self.e2GenPrompt_branch and "e2GenPrompt" not in self.complained:
        if not self.e2GenPrompt_branch and "e2GenPrompt":
            warnings.warn( "EETauTree: Expected branch e2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPrompt")
        else:
            self.e2GenPrompt_branch.SetAddress(<void*>&self.e2GenPrompt_value)

        #print "making e2GenPromptTauDecay"
        self.e2GenPromptTauDecay_branch = the_tree.GetBranch("e2GenPromptTauDecay")
        #if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay" not in self.complained:
        if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPromptTauDecay")
        else:
            self.e2GenPromptTauDecay_branch.SetAddress(<void*>&self.e2GenPromptTauDecay_value)

        #print "making e2GenPt"
        self.e2GenPt_branch = the_tree.GetBranch("e2GenPt")
        #if not self.e2GenPt_branch and "e2GenPt" not in self.complained:
        if not self.e2GenPt_branch and "e2GenPt":
            warnings.warn( "EETauTree: Expected branch e2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPt")
        else:
            self.e2GenPt_branch.SetAddress(<void*>&self.e2GenPt_value)

        #print "making e2GenTauDecay"
        self.e2GenTauDecay_branch = the_tree.GetBranch("e2GenTauDecay")
        #if not self.e2GenTauDecay_branch and "e2GenTauDecay" not in self.complained:
        if not self.e2GenTauDecay_branch and "e2GenTauDecay":
            warnings.warn( "EETauTree: Expected branch e2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenTauDecay")
        else:
            self.e2GenTauDecay_branch.SetAddress(<void*>&self.e2GenTauDecay_value)

        #print "making e2GenVZ"
        self.e2GenVZ_branch = the_tree.GetBranch("e2GenVZ")
        #if not self.e2GenVZ_branch and "e2GenVZ" not in self.complained:
        if not self.e2GenVZ_branch and "e2GenVZ":
            warnings.warn( "EETauTree: Expected branch e2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVZ")
        else:
            self.e2GenVZ_branch.SetAddress(<void*>&self.e2GenVZ_value)

        #print "making e2GenVtxPVMatch"
        self.e2GenVtxPVMatch_branch = the_tree.GetBranch("e2GenVtxPVMatch")
        #if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch" not in self.complained:
        if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch":
            warnings.warn( "EETauTree: Expected branch e2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVtxPVMatch")
        else:
            self.e2GenVtxPVMatch_branch.SetAddress(<void*>&self.e2GenVtxPVMatch_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3D"
        self.e2IP3D_branch = the_tree.GetBranch("e2IP3D")
        #if not self.e2IP3D_branch and "e2IP3D" not in self.complained:
        if not self.e2IP3D_branch and "e2IP3D":
            warnings.warn( "EETauTree: Expected branch e2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3D")
        else:
            self.e2IP3D_branch.SetAddress(<void*>&self.e2IP3D_value)

        #print "making e2IP3DErr"
        self.e2IP3DErr_branch = the_tree.GetBranch("e2IP3DErr")
        #if not self.e2IP3DErr_branch and "e2IP3DErr" not in self.complained:
        if not self.e2IP3DErr_branch and "e2IP3DErr":
            warnings.warn( "EETauTree: Expected branch e2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DErr")
        else:
            self.e2IP3DErr_branch.SetAddress(<void*>&self.e2IP3DErr_value)

        #print "making e2IsoDB03"
        self.e2IsoDB03_branch = the_tree.GetBranch("e2IsoDB03")
        #if not self.e2IsoDB03_branch and "e2IsoDB03" not in self.complained:
        if not self.e2IsoDB03_branch and "e2IsoDB03":
            warnings.warn( "EETauTree: Expected branch e2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IsoDB03")
        else:
            self.e2IsoDB03_branch.SetAddress(<void*>&self.e2IsoDB03_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EETauTree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EETauTree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetDR"
        self.e2JetDR_branch = the_tree.GetBranch("e2JetDR")
        #if not self.e2JetDR_branch and "e2JetDR" not in self.complained:
        if not self.e2JetDR_branch and "e2JetDR":
            warnings.warn( "EETauTree: Expected branch e2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetDR")
        else:
            self.e2JetDR_branch.SetAddress(<void*>&self.e2JetDR_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetHadronFlavour"
        self.e2JetHadronFlavour_branch = the_tree.GetBranch("e2JetHadronFlavour")
        #if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour" not in self.complained:
        if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch e2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetHadronFlavour")
        else:
            self.e2JetHadronFlavour_branch.SetAddress(<void*>&self.e2JetHadronFlavour_value)

        #print "making e2JetPFCISVBtag"
        self.e2JetPFCISVBtag_branch = the_tree.GetBranch("e2JetPFCISVBtag")
        #if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag" not in self.complained:
        if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch e2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPFCISVBtag")
        else:
            self.e2JetPFCISVBtag_branch.SetAddress(<void*>&self.e2JetPFCISVBtag_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EETauTree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2LowestMll"
        self.e2LowestMll_branch = the_tree.GetBranch("e2LowestMll")
        #if not self.e2LowestMll_branch and "e2LowestMll" not in self.complained:
        if not self.e2LowestMll_branch and "e2LowestMll":
            warnings.warn( "EETauTree: Expected branch e2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2LowestMll")
        else:
            self.e2LowestMll_branch.SetAddress(<void*>&self.e2LowestMll_value)

        #print "making e2MVAIsoWP80"
        self.e2MVAIsoWP80_branch = the_tree.GetBranch("e2MVAIsoWP80")
        #if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80" not in self.complained:
        if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80":
            warnings.warn( "EETauTree: Expected branch e2MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP80")
        else:
            self.e2MVAIsoWP80_branch.SetAddress(<void*>&self.e2MVAIsoWP80_value)

        #print "making e2MVAIsoWP90"
        self.e2MVAIsoWP90_branch = the_tree.GetBranch("e2MVAIsoWP90")
        #if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90" not in self.complained:
        if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90":
            warnings.warn( "EETauTree: Expected branch e2MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP90")
        else:
            self.e2MVAIsoWP90_branch.SetAddress(<void*>&self.e2MVAIsoWP90_value)

        #print "making e2MVANoisoWP80"
        self.e2MVANoisoWP80_branch = the_tree.GetBranch("e2MVANoisoWP80")
        #if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80" not in self.complained:
        if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80":
            warnings.warn( "EETauTree: Expected branch e2MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP80")
        else:
            self.e2MVANoisoWP80_branch.SetAddress(<void*>&self.e2MVANoisoWP80_value)

        #print "making e2MVANoisoWP90"
        self.e2MVANoisoWP90_branch = the_tree.GetBranch("e2MVANoisoWP90")
        #if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90" not in self.complained:
        if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90":
            warnings.warn( "EETauTree: Expected branch e2MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP90")
        else:
            self.e2MVANoisoWP90_branch.SetAddress(<void*>&self.e2MVANoisoWP90_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EETauTree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchEmbeddedFilterEle24Tau30"
        self.e2MatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle24Tau30")
        #if not self.e2MatchEmbeddedFilterEle24Tau30_branch and "e2MatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle24Tau30_branch and "e2MatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle24Tau30")
        else:
            self.e2MatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle24Tau30_value)

        #print "making e2MatchEmbeddedFilterEle27"
        self.e2MatchEmbeddedFilterEle27_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle27")
        #if not self.e2MatchEmbeddedFilterEle27_branch and "e2MatchEmbeddedFilterEle27" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle27_branch and "e2MatchEmbeddedFilterEle27":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle27")
        else:
            self.e2MatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle27_value)

        #print "making e2MatchEmbeddedFilterEle32"
        self.e2MatchEmbeddedFilterEle32_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32")
        #if not self.e2MatchEmbeddedFilterEle32_branch and "e2MatchEmbeddedFilterEle32" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32_branch and "e2MatchEmbeddedFilterEle32":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32")
        else:
            self.e2MatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32_value)

        #print "making e2MatchEmbeddedFilterEle32DoubleL1_v1"
        self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making e2MatchEmbeddedFilterEle32DoubleL1_v2"
        self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making e2MatchEmbeddedFilterEle35"
        self.e2MatchEmbeddedFilterEle35_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle35")
        #if not self.e2MatchEmbeddedFilterEle35_branch and "e2MatchEmbeddedFilterEle35" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle35_branch and "e2MatchEmbeddedFilterEle35":
            warnings.warn( "EETauTree: Expected branch e2MatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle35")
        else:
            self.e2MatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle35_value)

        #print "making e2MatchesEle24HPSTau30Filter"
        self.e2MatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("e2MatchesEle24HPSTau30Filter")
        #if not self.e2MatchesEle24HPSTau30Filter_branch and "e2MatchesEle24HPSTau30Filter" not in self.complained:
        if not self.e2MatchesEle24HPSTau30Filter_branch and "e2MatchesEle24HPSTau30Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24HPSTau30Filter")
        else:
            self.e2MatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24HPSTau30Filter_value)

        #print "making e2MatchesEle24HPSTau30Path"
        self.e2MatchesEle24HPSTau30Path_branch = the_tree.GetBranch("e2MatchesEle24HPSTau30Path")
        #if not self.e2MatchesEle24HPSTau30Path_branch and "e2MatchesEle24HPSTau30Path" not in self.complained:
        if not self.e2MatchesEle24HPSTau30Path_branch and "e2MatchesEle24HPSTau30Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24HPSTau30Path")
        else:
            self.e2MatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24HPSTau30Path_value)

        #print "making e2MatchesEle24Tau30Filter"
        self.e2MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau30Filter")
        #if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter" not in self.complained:
        if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Filter")
        else:
            self.e2MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Filter_value)

        #print "making e2MatchesEle24Tau30Path"
        self.e2MatchesEle24Tau30Path_branch = the_tree.GetBranch("e2MatchesEle24Tau30Path")
        #if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path" not in self.complained:
        if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Path")
        else:
            self.e2MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Path_value)

        #print "making e2MatchesEle25Filter"
        self.e2MatchesEle25Filter_branch = the_tree.GetBranch("e2MatchesEle25Filter")
        #if not self.e2MatchesEle25Filter_branch and "e2MatchesEle25Filter" not in self.complained:
        if not self.e2MatchesEle25Filter_branch and "e2MatchesEle25Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25Filter")
        else:
            self.e2MatchesEle25Filter_branch.SetAddress(<void*>&self.e2MatchesEle25Filter_value)

        #print "making e2MatchesEle25Path"
        self.e2MatchesEle25Path_branch = the_tree.GetBranch("e2MatchesEle25Path")
        #if not self.e2MatchesEle25Path_branch and "e2MatchesEle25Path" not in self.complained:
        if not self.e2MatchesEle25Path_branch and "e2MatchesEle25Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25Path")
        else:
            self.e2MatchesEle25Path_branch.SetAddress(<void*>&self.e2MatchesEle25Path_value)

        #print "making e2MatchesEle27Filter"
        self.e2MatchesEle27Filter_branch = the_tree.GetBranch("e2MatchesEle27Filter")
        #if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter" not in self.complained:
        if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Filter")
        else:
            self.e2MatchesEle27Filter_branch.SetAddress(<void*>&self.e2MatchesEle27Filter_value)

        #print "making e2MatchesEle27Path"
        self.e2MatchesEle27Path_branch = the_tree.GetBranch("e2MatchesEle27Path")
        #if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path" not in self.complained:
        if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Path")
        else:
            self.e2MatchesEle27Path_branch.SetAddress(<void*>&self.e2MatchesEle27Path_value)

        #print "making e2MatchesEle32Filter"
        self.e2MatchesEle32Filter_branch = the_tree.GetBranch("e2MatchesEle32Filter")
        #if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter" not in self.complained:
        if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Filter")
        else:
            self.e2MatchesEle32Filter_branch.SetAddress(<void*>&self.e2MatchesEle32Filter_value)

        #print "making e2MatchesEle32Path"
        self.e2MatchesEle32Path_branch = the_tree.GetBranch("e2MatchesEle32Path")
        #if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path" not in self.complained:
        if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Path")
        else:
            self.e2MatchesEle32Path_branch.SetAddress(<void*>&self.e2MatchesEle32Path_value)

        #print "making e2MatchesEle35Filter"
        self.e2MatchesEle35Filter_branch = the_tree.GetBranch("e2MatchesEle35Filter")
        #if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter" not in self.complained:
        if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Filter")
        else:
            self.e2MatchesEle35Filter_branch.SetAddress(<void*>&self.e2MatchesEle35Filter_value)

        #print "making e2MatchesEle35Path"
        self.e2MatchesEle35Path_branch = the_tree.GetBranch("e2MatchesEle35Path")
        #if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path" not in self.complained:
        if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Path")
        else:
            self.e2MatchesEle35Path_branch.SetAddress(<void*>&self.e2MatchesEle35Path_value)

        #print "making e2MatchesMu23e12DZFilter"
        self.e2MatchesMu23e12DZFilter_branch = the_tree.GetBranch("e2MatchesMu23e12DZFilter")
        #if not self.e2MatchesMu23e12DZFilter_branch and "e2MatchesMu23e12DZFilter" not in self.complained:
        if not self.e2MatchesMu23e12DZFilter_branch and "e2MatchesMu23e12DZFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12DZFilter")
        else:
            self.e2MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu23e12DZFilter_value)

        #print "making e2MatchesMu23e12DZPath"
        self.e2MatchesMu23e12DZPath_branch = the_tree.GetBranch("e2MatchesMu23e12DZPath")
        #if not self.e2MatchesMu23e12DZPath_branch and "e2MatchesMu23e12DZPath" not in self.complained:
        if not self.e2MatchesMu23e12DZPath_branch and "e2MatchesMu23e12DZPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12DZPath")
        else:
            self.e2MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.e2MatchesMu23e12DZPath_value)

        #print "making e2MatchesMu23e12Filter"
        self.e2MatchesMu23e12Filter_branch = the_tree.GetBranch("e2MatchesMu23e12Filter")
        #if not self.e2MatchesMu23e12Filter_branch and "e2MatchesMu23e12Filter" not in self.complained:
        if not self.e2MatchesMu23e12Filter_branch and "e2MatchesMu23e12Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12Filter")
        else:
            self.e2MatchesMu23e12Filter_branch.SetAddress(<void*>&self.e2MatchesMu23e12Filter_value)

        #print "making e2MatchesMu23e12Path"
        self.e2MatchesMu23e12Path_branch = the_tree.GetBranch("e2MatchesMu23e12Path")
        #if not self.e2MatchesMu23e12Path_branch and "e2MatchesMu23e12Path" not in self.complained:
        if not self.e2MatchesMu23e12Path_branch and "e2MatchesMu23e12Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12Path")
        else:
            self.e2MatchesMu23e12Path_branch.SetAddress(<void*>&self.e2MatchesMu23e12Path_value)

        #print "making e2MatchesMu8e23DZFilter"
        self.e2MatchesMu8e23DZFilter_branch = the_tree.GetBranch("e2MatchesMu8e23DZFilter")
        #if not self.e2MatchesMu8e23DZFilter_branch and "e2MatchesMu8e23DZFilter" not in self.complained:
        if not self.e2MatchesMu8e23DZFilter_branch and "e2MatchesMu8e23DZFilter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23DZFilter")
        else:
            self.e2MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu8e23DZFilter_value)

        #print "making e2MatchesMu8e23DZPath"
        self.e2MatchesMu8e23DZPath_branch = the_tree.GetBranch("e2MatchesMu8e23DZPath")
        #if not self.e2MatchesMu8e23DZPath_branch and "e2MatchesMu8e23DZPath" not in self.complained:
        if not self.e2MatchesMu8e23DZPath_branch and "e2MatchesMu8e23DZPath":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23DZPath")
        else:
            self.e2MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.e2MatchesMu8e23DZPath_value)

        #print "making e2MatchesMu8e23Filter"
        self.e2MatchesMu8e23Filter_branch = the_tree.GetBranch("e2MatchesMu8e23Filter")
        #if not self.e2MatchesMu8e23Filter_branch and "e2MatchesMu8e23Filter" not in self.complained:
        if not self.e2MatchesMu8e23Filter_branch and "e2MatchesMu8e23Filter":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23Filter")
        else:
            self.e2MatchesMu8e23Filter_branch.SetAddress(<void*>&self.e2MatchesMu8e23Filter_value)

        #print "making e2MatchesMu8e23Path"
        self.e2MatchesMu8e23Path_branch = the_tree.GetBranch("e2MatchesMu8e23Path")
        #if not self.e2MatchesMu8e23Path_branch and "e2MatchesMu8e23Path" not in self.complained:
        if not self.e2MatchesMu8e23Path_branch and "e2MatchesMu8e23Path":
            warnings.warn( "EETauTree: Expected branch e2MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23Path")
        else:
            self.e2MatchesMu8e23Path_branch.SetAddress(<void*>&self.e2MatchesMu8e23Path_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EETauTree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EETauTree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2NearestMuonDR"
        self.e2NearestMuonDR_branch = the_tree.GetBranch("e2NearestMuonDR")
        #if not self.e2NearestMuonDR_branch and "e2NearestMuonDR" not in self.complained:
        if not self.e2NearestMuonDR_branch and "e2NearestMuonDR":
            warnings.warn( "EETauTree: Expected branch e2NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestMuonDR")
        else:
            self.e2NearestMuonDR_branch.SetAddress(<void*>&self.e2NearestMuonDR_value)

        #print "making e2NearestZMass"
        self.e2NearestZMass_branch = the_tree.GetBranch("e2NearestZMass")
        #if not self.e2NearestZMass_branch and "e2NearestZMass" not in self.complained:
        if not self.e2NearestZMass_branch and "e2NearestZMass":
            warnings.warn( "EETauTree: Expected branch e2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestZMass")
        else:
            self.e2NearestZMass_branch.SetAddress(<void*>&self.e2NearestZMass_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EETauTree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EETauTree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPUChargedIso"
        self.e2PFPUChargedIso_branch = the_tree.GetBranch("e2PFPUChargedIso")
        #if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso" not in self.complained:
        if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso":
            warnings.warn( "EETauTree: Expected branch e2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPUChargedIso")
        else:
            self.e2PFPUChargedIso_branch.SetAddress(<void*>&self.e2PFPUChargedIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EETauTree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EETauTree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EETauTree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2PassesConversionVeto"
        self.e2PassesConversionVeto_branch = the_tree.GetBranch("e2PassesConversionVeto")
        #if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto" not in self.complained:
        if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto":
            warnings.warn( "EETauTree: Expected branch e2PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PassesConversionVeto")
        else:
            self.e2PassesConversionVeto_branch.SetAddress(<void*>&self.e2PassesConversionVeto_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EETauTree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EETauTree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EETauTree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EETauTree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EETauTree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2Rho"
        self.e2Rho_branch = the_tree.GetBranch("e2Rho")
        #if not self.e2Rho_branch and "e2Rho" not in self.complained:
        if not self.e2Rho_branch and "e2Rho":
            warnings.warn( "EETauTree: Expected branch e2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rho")
        else:
            self.e2Rho_branch.SetAddress(<void*>&self.e2Rho_value)

        #print "making e2SIP2D"
        self.e2SIP2D_branch = the_tree.GetBranch("e2SIP2D")
        #if not self.e2SIP2D_branch and "e2SIP2D" not in self.complained:
        if not self.e2SIP2D_branch and "e2SIP2D":
            warnings.warn( "EETauTree: Expected branch e2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP2D")
        else:
            self.e2SIP2D_branch.SetAddress(<void*>&self.e2SIP2D_value)

        #print "making e2SIP3D"
        self.e2SIP3D_branch = the_tree.GetBranch("e2SIP3D")
        #if not self.e2SIP3D_branch and "e2SIP3D" not in self.complained:
        if not self.e2SIP3D_branch and "e2SIP3D":
            warnings.warn( "EETauTree: Expected branch e2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP3D")
        else:
            self.e2SIP3D_branch.SetAddress(<void*>&self.e2SIP3D_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EETauTree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EETauTree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2ZTTGenMatching"
        self.e2ZTTGenMatching_branch = the_tree.GetBranch("e2ZTTGenMatching")
        #if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching" not in self.complained:
        if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch e2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ZTTGenMatching")
        else:
            self.e2ZTTGenMatching_branch.SetAddress(<void*>&self.e2ZTTGenMatching_value)

        #print "making e2_t_DR"
        self.e2_t_DR_branch = the_tree.GetBranch("e2_t_DR")
        #if not self.e2_t_DR_branch and "e2_t_DR" not in self.complained:
        if not self.e2_t_DR_branch and "e2_t_DR":
            warnings.warn( "EETauTree: Expected branch e2_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_DR")
        else:
            self.e2_t_DR_branch.SetAddress(<void*>&self.e2_t_DR_value)

        #print "making e2_t_Mass"
        self.e2_t_Mass_branch = the_tree.GetBranch("e2_t_Mass")
        #if not self.e2_t_Mass_branch and "e2_t_Mass" not in self.complained:
        if not self.e2_t_Mass_branch and "e2_t_Mass":
            warnings.warn( "EETauTree: Expected branch e2_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_Mass")
        else:
            self.e2_t_Mass_branch.SetAddress(<void*>&self.e2_t_Mass_value)

        #print "making e2_t_PZeta"
        self.e2_t_PZeta_branch = the_tree.GetBranch("e2_t_PZeta")
        #if not self.e2_t_PZeta_branch and "e2_t_PZeta" not in self.complained:
        if not self.e2_t_PZeta_branch and "e2_t_PZeta":
            warnings.warn( "EETauTree: Expected branch e2_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZeta")
        else:
            self.e2_t_PZeta_branch.SetAddress(<void*>&self.e2_t_PZeta_value)

        #print "making e2_t_PZetaVis"
        self.e2_t_PZetaVis_branch = the_tree.GetBranch("e2_t_PZetaVis")
        #if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis" not in self.complained:
        if not self.e2_t_PZetaVis_branch and "e2_t_PZetaVis":
            warnings.warn( "EETauTree: Expected branch e2_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_PZetaVis")
        else:
            self.e2_t_PZetaVis_branch.SetAddress(<void*>&self.e2_t_PZetaVis_value)

        #print "making e2_t_doubleL1IsoTauMatch"
        self.e2_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e2_t_doubleL1IsoTauMatch")
        #if not self.e2_t_doubleL1IsoTauMatch_branch and "e2_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.e2_t_doubleL1IsoTauMatch_branch and "e2_t_doubleL1IsoTauMatch":
            warnings.warn( "EETauTree: Expected branch e2_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_t_doubleL1IsoTauMatch")
        else:
            self.e2_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e2_t_doubleL1IsoTauMatch_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EETauTree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EETauTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EETauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EETauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EETauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EETauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EETauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EETauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EETauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EETauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EETauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EETauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EETauTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "EETauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EETauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EETauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EETauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EETauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EETauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EETauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "EETauTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EETauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EETauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EETauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EETauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EETauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EETauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EETauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EETauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EETauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EETauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "EETauTree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "EETauTree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "EETauTree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "EETauTree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "EETauTree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "EETauTree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "EETauTree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "EETauTree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "EETauTree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "EETauTree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "EETauTree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "EETauTree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "EETauTree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "EETauTree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "EETauTree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "EETauTree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "EETauTree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "EETauTree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "EETauTree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "EETauTree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "EETauTree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "EETauTree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "EETauTree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "EETauTree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EETauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "EETauTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EETauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EETauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EETauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "EETauTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetEnDown"
        self.jetVeto30WoNoisyJets_JetEnDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnDown")
        #if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown":
            warnings.warn( "EETauTree: Expected branch jetVeto30WoNoisyJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnDown")
        else:
            self.jetVeto30WoNoisyJets_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnDown_value)

        #print "making jetVeto30WoNoisyJets_JetEnUp"
        self.jetVeto30WoNoisyJets_JetEnUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnUp")
        #if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp":
            warnings.warn( "EETauTree: Expected branch jetVeto30WoNoisyJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnUp")
        else:
            self.jetVeto30WoNoisyJets_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EETauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EETauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EETauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EETauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EETauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EETauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EETauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EETauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "EETauTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "EETauTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "EETauTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "EETauTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "EETauTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "EETauTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "EETauTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "EETauTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EETauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EETauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EETauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "EETauTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EETauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EETauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "EETauTree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making prefiring_weight_down"
        self.prefiring_weight_down_branch = the_tree.GetBranch("prefiring_weight_down")
        #if not self.prefiring_weight_down_branch and "prefiring_weight_down" not in self.complained:
        if not self.prefiring_weight_down_branch and "prefiring_weight_down":
            warnings.warn( "EETauTree: Expected branch prefiring_weight_down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_down")
        else:
            self.prefiring_weight_down_branch.SetAddress(<void*>&self.prefiring_weight_down_value)

        #print "making prefiring_weight_up"
        self.prefiring_weight_up_branch = the_tree.GetBranch("prefiring_weight_up")
        #if not self.prefiring_weight_up_branch and "prefiring_weight_up" not in self.complained:
        if not self.prefiring_weight_up_branch and "prefiring_weight_up":
            warnings.warn( "EETauTree: Expected branch prefiring_weight_up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_up")
        else:
            self.prefiring_weight_up_branch.SetAddress(<void*>&self.prefiring_weight_up_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EETauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EETauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EETauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EETauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EETauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EETauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EETauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EETauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EETauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EETauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EETauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EETauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EETauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EETauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EETauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EETauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EETauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EETauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EETauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "EETauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "EETauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EETauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronLooseMVA62018"
        self.tAgainstElectronLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronLooseMVA62018")
        #if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA62018")
        else:
            self.tAgainstElectronLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA62018_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6Raw2018"
        self.tAgainstElectronMVA6Raw2018_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw2018")
        #if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018" not in self.complained:
        if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6Raw2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw2018")
        else:
            self.tAgainstElectronMVA6Raw2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw2018_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMVA6category2018"
        self.tAgainstElectronMVA6category2018_branch = the_tree.GetBranch("tAgainstElectronMVA6category2018")
        #if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018" not in self.complained:
        if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMVA6category2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category2018")
        else:
            self.tAgainstElectronMVA6category2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category2018_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronMediumMVA62018"
        self.tAgainstElectronMediumMVA62018_branch = the_tree.GetBranch("tAgainstElectronMediumMVA62018")
        #if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018" not in self.complained:
        if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronMediumMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA62018")
        else:
            self.tAgainstElectronMediumMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA62018_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronTightMVA62018"
        self.tAgainstElectronTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronTightMVA62018")
        #if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018" not in self.complained:
        if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA62018")
        else:
            self.tAgainstElectronTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA62018_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVLooseMVA62018"
        self.tAgainstElectronVLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA62018")
        #if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA62018")
        else:
            self.tAgainstElectronVLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA62018_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstElectronVTightMVA62018"
        self.tAgainstElectronVTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronVTightMVA62018")
        #if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018" not in self.complained:
        if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018":
            warnings.warn( "EETauTree: Expected branch tAgainstElectronVTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA62018")
        else:
            self.tAgainstElectronVTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA62018_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "EETauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "EETauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "EETauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "EETauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "EETauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "EETauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "EETauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "EETauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "EETauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "EETauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "EETauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tDeepTau2017v2p1VSeraw"
        self.tDeepTau2017v2p1VSeraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSeraw")
        #if not self.tDeepTau2017v2p1VSeraw_branch and "tDeepTau2017v2p1VSeraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSeraw_branch and "tDeepTau2017v2p1VSeraw":
            warnings.warn( "EETauTree: Expected branch tDeepTau2017v2p1VSeraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSeraw")
        else:
            self.tDeepTau2017v2p1VSeraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSeraw_value)

        #print "making tDeepTau2017v2p1VSjetraw"
        self.tDeepTau2017v2p1VSjetraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSjetraw")
        #if not self.tDeepTau2017v2p1VSjetraw_branch and "tDeepTau2017v2p1VSjetraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSjetraw_branch and "tDeepTau2017v2p1VSjetraw":
            warnings.warn( "EETauTree: Expected branch tDeepTau2017v2p1VSjetraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSjetraw")
        else:
            self.tDeepTau2017v2p1VSjetraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSjetraw_value)

        #print "making tDeepTau2017v2p1VSmuraw"
        self.tDeepTau2017v2p1VSmuraw_branch = the_tree.GetBranch("tDeepTau2017v2p1VSmuraw")
        #if not self.tDeepTau2017v2p1VSmuraw_branch and "tDeepTau2017v2p1VSmuraw" not in self.complained:
        if not self.tDeepTau2017v2p1VSmuraw_branch and "tDeepTau2017v2p1VSmuraw":
            warnings.warn( "EETauTree: Expected branch tDeepTau2017v2p1VSmuraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v2p1VSmuraw")
        else:
            self.tDeepTau2017v2p1VSmuraw_branch.SetAddress(<void*>&self.tDeepTau2017v2p1VSmuraw_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "EETauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "EETauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "EETauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "EETauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "EETauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "EETauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "EETauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "EETauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "EETauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "EETauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "EETauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "EETauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "EETauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "EETauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "EETauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "EETauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "EETauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "EETauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "EETauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "EETauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetDR"
        self.tJetDR_branch = the_tree.GetBranch("tJetDR")
        #if not self.tJetDR_branch and "tJetDR" not in self.complained:
        if not self.tJetDR_branch and "tJetDR":
            warnings.warn( "EETauTree: Expected branch tJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetDR")
        else:
            self.tJetDR_branch.SetAddress(<void*>&self.tJetDR_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "EETauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "EETauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "EETauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "EETauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "EETauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "EETauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "EETauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "EETauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tL1IsoTauMatch"
        self.tL1IsoTauMatch_branch = the_tree.GetBranch("tL1IsoTauMatch")
        #if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch" not in self.complained:
        if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch":
            warnings.warn( "EETauTree: Expected branch tL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauMatch")
        else:
            self.tL1IsoTauMatch_branch.SetAddress(<void*>&self.tL1IsoTauMatch_value)

        #print "making tL1IsoTauPt"
        self.tL1IsoTauPt_branch = the_tree.GetBranch("tL1IsoTauPt")
        #if not self.tL1IsoTauPt_branch and "tL1IsoTauPt" not in self.complained:
        if not self.tL1IsoTauPt_branch and "tL1IsoTauPt":
            warnings.warn( "EETauTree: Expected branch tL1IsoTauPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauPt")
        else:
            self.tL1IsoTauPt_branch.SetAddress(<void*>&self.tL1IsoTauPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "EETauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseDeepTau2017v2p1VSe"
        self.tLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSe")
        #if not self.tLooseDeepTau2017v2p1VSe_branch and "tLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSe_branch and "tLooseDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSe")
        else:
            self.tLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSe_value)

        #print "making tLooseDeepTau2017v2p1VSjet"
        self.tLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSjet")
        #if not self.tLooseDeepTau2017v2p1VSjet_branch and "tLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSjet_branch and "tLooseDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSjet")
        else:
            self.tLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSjet_value)

        #print "making tLooseDeepTau2017v2p1VSmu"
        self.tLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tLooseDeepTau2017v2p1VSmu")
        #if not self.tLooseDeepTau2017v2p1VSmu_branch and "tLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tLooseDeepTau2017v2p1VSmu_branch and "tLooseDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v2p1VSmu")
        else:
            self.tLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tLooseDeepTau2017v2p1VSmu_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "EETauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "EETauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMatchEmbeddedFilterEle24Tau30"
        self.tMatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("tMatchEmbeddedFilterEle24Tau30")
        #if not self.tMatchEmbeddedFilterEle24Tau30_branch and "tMatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.tMatchEmbeddedFilterEle24Tau30_branch and "tMatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EETauTree: Expected branch tMatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchEmbeddedFilterEle24Tau30")
        else:
            self.tMatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.tMatchEmbeddedFilterEle24Tau30_value)

        #print "making tMatchEmbeddedFilterMu19Tau20"
        self.tMatchEmbeddedFilterMu19Tau20_branch = the_tree.GetBranch("tMatchEmbeddedFilterMu19Tau20")
        #if not self.tMatchEmbeddedFilterMu19Tau20_branch and "tMatchEmbeddedFilterMu19Tau20" not in self.complained:
        if not self.tMatchEmbeddedFilterMu19Tau20_branch and "tMatchEmbeddedFilterMu19Tau20":
            warnings.warn( "EETauTree: Expected branch tMatchEmbeddedFilterMu19Tau20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchEmbeddedFilterMu19Tau20")
        else:
            self.tMatchEmbeddedFilterMu19Tau20_branch.SetAddress(<void*>&self.tMatchEmbeddedFilterMu19Tau20_value)

        #print "making tMatchEmbeddedFilterMu20HPSTau27"
        self.tMatchEmbeddedFilterMu20HPSTau27_branch = the_tree.GetBranch("tMatchEmbeddedFilterMu20HPSTau27")
        #if not self.tMatchEmbeddedFilterMu20HPSTau27_branch and "tMatchEmbeddedFilterMu20HPSTau27" not in self.complained:
        if not self.tMatchEmbeddedFilterMu20HPSTau27_branch and "tMatchEmbeddedFilterMu20HPSTau27":
            warnings.warn( "EETauTree: Expected branch tMatchEmbeddedFilterMu20HPSTau27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchEmbeddedFilterMu20HPSTau27")
        else:
            self.tMatchEmbeddedFilterMu20HPSTau27_branch.SetAddress(<void*>&self.tMatchEmbeddedFilterMu20HPSTau27_value)

        #print "making tMatchEmbeddedFilterMu20Tau27"
        self.tMatchEmbeddedFilterMu20Tau27_branch = the_tree.GetBranch("tMatchEmbeddedFilterMu20Tau27")
        #if not self.tMatchEmbeddedFilterMu20Tau27_branch and "tMatchEmbeddedFilterMu20Tau27" not in self.complained:
        if not self.tMatchEmbeddedFilterMu20Tau27_branch and "tMatchEmbeddedFilterMu20Tau27":
            warnings.warn( "EETauTree: Expected branch tMatchEmbeddedFilterMu20Tau27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchEmbeddedFilterMu20Tau27")
        else:
            self.tMatchEmbeddedFilterMu20Tau27_branch.SetAddress(<void*>&self.tMatchEmbeddedFilterMu20Tau27_value)

        #print "making tMatchesEle24HPSTau30Filter"
        self.tMatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Filter")
        #if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter" not in self.complained:
        if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Filter")
        else:
            self.tMatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Filter_value)

        #print "making tMatchesEle24HPSTau30Path"
        self.tMatchesEle24HPSTau30Path_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Path")
        #if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path" not in self.complained:
        if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Path")
        else:
            self.tMatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Path_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "EETauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMatchesIsoMu19Tau20Filter"
        self.tMatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Filter")
        #if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Filter")
        else:
            self.tMatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Filter_value)

        #print "making tMatchesIsoMu19Tau20Path"
        self.tMatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Path")
        #if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Path")
        else:
            self.tMatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Path_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Filter"
        self.tMatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Filter")
        #if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Path"
        self.tMatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Path")
        #if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Path")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Path_value)

        #print "making tMatchesIsoMu20HPSTau27Filter"
        self.tMatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Filter")
        #if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Filter")
        else:
            self.tMatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Filter_value)

        #print "making tMatchesIsoMu20HPSTau27Path"
        self.tMatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Path")
        #if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Path")
        else:
            self.tMatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Path_value)

        #print "making tMatchesIsoMu20Tau27Filter"
        self.tMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Filter")
        #if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Filter")
        else:
            self.tMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Filter_value)

        #print "making tMatchesIsoMu20Tau27Path"
        self.tMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Path")
        #if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path":
            warnings.warn( "EETauTree: Expected branch tMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Path")
        else:
            self.tMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Path_value)

        #print "making tMediumDeepTau2017v2p1VSe"
        self.tMediumDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSe")
        #if not self.tMediumDeepTau2017v2p1VSe_branch and "tMediumDeepTau2017v2p1VSe" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSe_branch and "tMediumDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tMediumDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSe")
        else:
            self.tMediumDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSe_value)

        #print "making tMediumDeepTau2017v2p1VSjet"
        self.tMediumDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSjet")
        #if not self.tMediumDeepTau2017v2p1VSjet_branch and "tMediumDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSjet_branch and "tMediumDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tMediumDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSjet")
        else:
            self.tMediumDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSjet_value)

        #print "making tMediumDeepTau2017v2p1VSmu"
        self.tMediumDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tMediumDeepTau2017v2p1VSmu")
        #if not self.tMediumDeepTau2017v2p1VSmu_branch and "tMediumDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tMediumDeepTau2017v2p1VSmu_branch and "tMediumDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tMediumDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v2p1VSmu")
        else:
            self.tMediumDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tMediumDeepTau2017v2p1VSmu_value)

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "EETauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "EETauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "EETauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "EETauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "EETauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "EETauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "EETauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "EETauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "EETauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "EETauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "EETauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "EETauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "EETauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "EETauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRerunMVArun2v2DBoldDMwLTLoose"
        self.tRerunMVArun2v2DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTMedium"
        self.tRerunMVArun2v2DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v2DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v2DBoldDMwLTTight"
        self.tRerunMVArun2v2DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVTight"
        self.tRerunMVArun2v2DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVTight"
        self.tRerunMVArun2v2DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTraw"
        self.tRerunMVArun2v2DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTraw")
        #if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw":
            warnings.warn( "EETauTree: Expected branch tRerunMVArun2v2DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v2DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTraw_value)

        #print "making tTightDeepTau2017v2p1VSe"
        self.tTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSe")
        #if not self.tTightDeepTau2017v2p1VSe_branch and "tTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSe_branch and "tTightDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSe")
        else:
            self.tTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSe_value)

        #print "making tTightDeepTau2017v2p1VSjet"
        self.tTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSjet")
        #if not self.tTightDeepTau2017v2p1VSjet_branch and "tTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSjet_branch and "tTightDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSjet")
        else:
            self.tTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSjet_value)

        #print "making tTightDeepTau2017v2p1VSmu"
        self.tTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tTightDeepTau2017v2p1VSmu")
        #if not self.tTightDeepTau2017v2p1VSmu_branch and "tTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tTightDeepTau2017v2p1VSmu_branch and "tTightDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v2p1VSmu")
        else:
            self.tTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tTightDeepTau2017v2p1VSmu_value)

        #print "making tVLooseDeepTau2017v2p1VSe"
        self.tVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSe")
        #if not self.tVLooseDeepTau2017v2p1VSe_branch and "tVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSe_branch and "tVLooseDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSe")
        else:
            self.tVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSe_value)

        #print "making tVLooseDeepTau2017v2p1VSjet"
        self.tVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSjet")
        #if not self.tVLooseDeepTau2017v2p1VSjet_branch and "tVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSjet_branch and "tVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVLooseDeepTau2017v2p1VSmu"
        self.tVLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVLooseDeepTau2017v2p1VSmu")
        #if not self.tVLooseDeepTau2017v2p1VSmu_branch and "tVLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVLooseDeepTau2017v2p1VSmu_branch and "tVLooseDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tVLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v2p1VSmu")
        else:
            self.tVLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v2p1VSmu_value)

        #print "making tVTightDeepTau2017v2p1VSe"
        self.tVTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSe")
        #if not self.tVTightDeepTau2017v2p1VSe_branch and "tVTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSe_branch and "tVTightDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tVTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSe")
        else:
            self.tVTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSe_value)

        #print "making tVTightDeepTau2017v2p1VSjet"
        self.tVTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSjet")
        #if not self.tVTightDeepTau2017v2p1VSjet_branch and "tVTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSjet_branch and "tVTightDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tVTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSjet")
        else:
            self.tVTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSjet_value)

        #print "making tVTightDeepTau2017v2p1VSmu"
        self.tVTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVTightDeepTau2017v2p1VSmu")
        #if not self.tVTightDeepTau2017v2p1VSmu_branch and "tVTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVTightDeepTau2017v2p1VSmu_branch and "tVTightDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tVTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v2p1VSmu")
        else:
            self.tVTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVTightDeepTau2017v2p1VSmu_value)

        #print "making tVVLooseDeepTau2017v2p1VSe"
        self.tVVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVLooseDeepTau2017v2p1VSe")
        #if not self.tVVLooseDeepTau2017v2p1VSe_branch and "tVVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVLooseDeepTau2017v2p1VSe_branch and "tVVLooseDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tVVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v2p1VSe")
        else:
            self.tVVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v2p1VSe_value)

        #print "making tVVLooseDeepTau2017v2p1VSjet"
        self.tVVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVLooseDeepTau2017v2p1VSjet")
        #if not self.tVVLooseDeepTau2017v2p1VSjet_branch and "tVVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVLooseDeepTau2017v2p1VSjet_branch and "tVVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tVVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVVLooseDeepTau2017v2p1VSmu"
        self.tVVLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVVLooseDeepTau2017v2p1VSmu")
        #if not self.tVVLooseDeepTau2017v2p1VSmu_branch and "tVVLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVVLooseDeepTau2017v2p1VSmu_branch and "tVVLooseDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tVVLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v2p1VSmu")
        else:
            self.tVVLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v2p1VSmu_value)

        #print "making tVVTightDeepTau2017v2p1VSe"
        self.tVVTightDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSe")
        #if not self.tVVTightDeepTau2017v2p1VSe_branch and "tVVTightDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSe_branch and "tVVTightDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tVVTightDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSe")
        else:
            self.tVVTightDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSe_value)

        #print "making tVVTightDeepTau2017v2p1VSjet"
        self.tVVTightDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSjet")
        #if not self.tVVTightDeepTau2017v2p1VSjet_branch and "tVVTightDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSjet_branch and "tVVTightDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tVVTightDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSjet")
        else:
            self.tVVTightDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSjet_value)

        #print "making tVVTightDeepTau2017v2p1VSmu"
        self.tVVTightDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVVTightDeepTau2017v2p1VSmu")
        #if not self.tVVTightDeepTau2017v2p1VSmu_branch and "tVVTightDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVVTightDeepTau2017v2p1VSmu_branch and "tVVTightDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tVVTightDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v2p1VSmu")
        else:
            self.tVVTightDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v2p1VSmu_value)

        #print "making tVVVLooseDeepTau2017v2p1VSe"
        self.tVVVLooseDeepTau2017v2p1VSe_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v2p1VSe")
        #if not self.tVVVLooseDeepTau2017v2p1VSe_branch and "tVVVLooseDeepTau2017v2p1VSe" not in self.complained:
        if not self.tVVVLooseDeepTau2017v2p1VSe_branch and "tVVVLooseDeepTau2017v2p1VSe":
            warnings.warn( "EETauTree: Expected branch tVVVLooseDeepTau2017v2p1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v2p1VSe")
        else:
            self.tVVVLooseDeepTau2017v2p1VSe_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v2p1VSe_value)

        #print "making tVVVLooseDeepTau2017v2p1VSjet"
        self.tVVVLooseDeepTau2017v2p1VSjet_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v2p1VSjet")
        #if not self.tVVVLooseDeepTau2017v2p1VSjet_branch and "tVVVLooseDeepTau2017v2p1VSjet" not in self.complained:
        if not self.tVVVLooseDeepTau2017v2p1VSjet_branch and "tVVVLooseDeepTau2017v2p1VSjet":
            warnings.warn( "EETauTree: Expected branch tVVVLooseDeepTau2017v2p1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v2p1VSjet")
        else:
            self.tVVVLooseDeepTau2017v2p1VSjet_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v2p1VSjet_value)

        #print "making tVVVLooseDeepTau2017v2p1VSmu"
        self.tVVVLooseDeepTau2017v2p1VSmu_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v2p1VSmu")
        #if not self.tVVVLooseDeepTau2017v2p1VSmu_branch and "tVVVLooseDeepTau2017v2p1VSmu" not in self.complained:
        if not self.tVVVLooseDeepTau2017v2p1VSmu_branch and "tVVVLooseDeepTau2017v2p1VSmu":
            warnings.warn( "EETauTree: Expected branch tVVVLooseDeepTau2017v2p1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v2p1VSmu")
        else:
            self.tVVVLooseDeepTau2017v2p1VSmu_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v2p1VSmu_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "EETauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "EETauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "EETauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "EETauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "EETauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "EETauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EETauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EETauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EETauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EETauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "EETauTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "EETauTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EETauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EETauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EETauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EETauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EETauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "EETauTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EETauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EETauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EETauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EETauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EETauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EETauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EETauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EETauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EETauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property e1CorrectedEt:
        def __get__(self):
            self.e1CorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.e1CorrectedEt_value

    property e1EcalIsoDR03:
        def __get__(self):
            self.e1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e1EcalIsoDR03_value

    property e1EnergyError:
        def __get__(self):
            self.e1EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyError_value

    property e1EnergyScaleDown:
        def __get__(self):
            self.e1EnergyScaleDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleDown_value

    property e1EnergyScaleGainDown:
        def __get__(self):
            self.e1EnergyScaleGainDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleGainDown_value

    property e1EnergyScaleGainUp:
        def __get__(self):
            self.e1EnergyScaleGainUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleGainUp_value

    property e1EnergyScaleStatDown:
        def __get__(self):
            self.e1EnergyScaleStatDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleStatDown_value

    property e1EnergyScaleStatUp:
        def __get__(self):
            self.e1EnergyScaleStatUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleStatUp_value

    property e1EnergyScaleSystDown:
        def __get__(self):
            self.e1EnergyScaleSystDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleSystDown_value

    property e1EnergyScaleSystUp:
        def __get__(self):
            self.e1EnergyScaleSystUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleSystUp_value

    property e1EnergyScaleUp:
        def __get__(self):
            self.e1EnergyScaleUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergyScaleUp_value

    property e1EnergySigmaDown:
        def __get__(self):
            self.e1EnergySigmaDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaDown_value

    property e1EnergySigmaPhiDown:
        def __get__(self):
            self.e1EnergySigmaPhiDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaPhiDown_value

    property e1EnergySigmaPhiUp:
        def __get__(self):
            self.e1EnergySigmaPhiUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaPhiUp_value

    property e1EnergySigmaRhoDown:
        def __get__(self):
            self.e1EnergySigmaRhoDown_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaRhoDown_value

    property e1EnergySigmaRhoUp:
        def __get__(self):
            self.e1EnergySigmaRhoUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaRhoUp_value

    property e1EnergySigmaUp:
        def __get__(self):
            self.e1EnergySigmaUp_branch.GetEntry(self.localentry, 0)
            return self.e1EnergySigmaUp_value

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

    property e1MVAIsoWP80:
        def __get__(self):
            self.e1MVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIsoWP80_value

    property e1MVAIsoWP90:
        def __get__(self):
            self.e1MVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.e1MVAIsoWP90_value

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

    property e1MatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle24Tau30_value

    property e1MatchEmbeddedFilterEle27:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle27_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle27_value

    property e1MatchEmbeddedFilterEle32:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle32_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle32_value

    property e1MatchEmbeddedFilterEle32DoubleL1_v1:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle32DoubleL1_v1_value

    property e1MatchEmbeddedFilterEle32DoubleL1_v2:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle32DoubleL1_v2_value

    property e1MatchEmbeddedFilterEle35:
        def __get__(self):
            self.e1MatchEmbeddedFilterEle35_branch.GetEntry(self.localentry, 0)
            return self.e1MatchEmbeddedFilterEle35_value

    property e1MatchesEle24HPSTau30Filter:
        def __get__(self):
            self.e1MatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24HPSTau30Filter_value

    property e1MatchesEle24HPSTau30Path:
        def __get__(self):
            self.e1MatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24HPSTau30Path_value

    property e1MatchesEle24Tau30Filter:
        def __get__(self):
            self.e1MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Filter_value

    property e1MatchesEle24Tau30Path:
        def __get__(self):
            self.e1MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle24Tau30Path_value

    property e1MatchesEle25Filter:
        def __get__(self):
            self.e1MatchesEle25Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25Filter_value

    property e1MatchesEle25Path:
        def __get__(self):
            self.e1MatchesEle25Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesEle25Path_value

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

    property e1MatchesMu23e12DZFilter:
        def __get__(self):
            self.e1MatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23e12DZFilter_value

    property e1MatchesMu23e12DZPath:
        def __get__(self):
            self.e1MatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23e12DZPath_value

    property e1MatchesMu23e12Filter:
        def __get__(self):
            self.e1MatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23e12Filter_value

    property e1MatchesMu23e12Path:
        def __get__(self):
            self.e1MatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu23e12Path_value

    property e1MatchesMu8e23DZFilter:
        def __get__(self):
            self.e1MatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8e23DZFilter_value

    property e1MatchesMu8e23DZPath:
        def __get__(self):
            self.e1MatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8e23DZPath_value

    property e1MatchesMu8e23Filter:
        def __get__(self):
            self.e1MatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8e23Filter_value

    property e1MatchesMu8e23Path:
        def __get__(self):
            self.e1MatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.e1MatchesMu8e23Path_value

    property e1MissingHits:
        def __get__(self):
            self.e1MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e1MissingHits_value

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

    property e1SIP2D:
        def __get__(self):
            self.e1SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP2D_value

    property e1SIP3D:
        def __get__(self):
            self.e1SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e1SIP3D_value

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

    property e1_e2_DR:
        def __get__(self):
            self.e1_e2_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_DR_value

    property e1_e2_Mass:
        def __get__(self):
            self.e1_e2_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_Mass_value

    property e1_e2_PZeta:
        def __get__(self):
            self.e1_e2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZeta_value

    property e1_e2_PZetaVis:
        def __get__(self):
            self.e1_e2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_PZetaVis_value

    property e1_e2_doubleL1IsoTauMatch:
        def __get__(self):
            self.e1_e2_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e1_e2_doubleL1IsoTauMatch_value

    property e1_t_DR:
        def __get__(self):
            self.e1_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_t_DR_value

    property e1_t_Mass:
        def __get__(self):
            self.e1_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_t_Mass_value

    property e1_t_PZeta:
        def __get__(self):
            self.e1_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZeta_value

    property e1_t_PZetaVis:
        def __get__(self):
            self.e1_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_t_PZetaVis_value

    property e1_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.e1_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e1_t_doubleL1IsoTauMatch_value

    property e1ecalEnergy:
        def __get__(self):
            self.e1ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e1ecalEnergy_value

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

    property e2CorrectedEt:
        def __get__(self):
            self.e2CorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.e2CorrectedEt_value

    property e2EcalIsoDR03:
        def __get__(self):
            self.e2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e2EcalIsoDR03_value

    property e2EnergyError:
        def __get__(self):
            self.e2EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyError_value

    property e2EnergyScaleDown:
        def __get__(self):
            self.e2EnergyScaleDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleDown_value

    property e2EnergyScaleGainDown:
        def __get__(self):
            self.e2EnergyScaleGainDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleGainDown_value

    property e2EnergyScaleGainUp:
        def __get__(self):
            self.e2EnergyScaleGainUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleGainUp_value

    property e2EnergyScaleStatDown:
        def __get__(self):
            self.e2EnergyScaleStatDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleStatDown_value

    property e2EnergyScaleStatUp:
        def __get__(self):
            self.e2EnergyScaleStatUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleStatUp_value

    property e2EnergyScaleSystDown:
        def __get__(self):
            self.e2EnergyScaleSystDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleSystDown_value

    property e2EnergyScaleSystUp:
        def __get__(self):
            self.e2EnergyScaleSystUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleSystUp_value

    property e2EnergyScaleUp:
        def __get__(self):
            self.e2EnergyScaleUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergyScaleUp_value

    property e2EnergySigmaDown:
        def __get__(self):
            self.e2EnergySigmaDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaDown_value

    property e2EnergySigmaPhiDown:
        def __get__(self):
            self.e2EnergySigmaPhiDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaPhiDown_value

    property e2EnergySigmaPhiUp:
        def __get__(self):
            self.e2EnergySigmaPhiUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaPhiUp_value

    property e2EnergySigmaRhoDown:
        def __get__(self):
            self.e2EnergySigmaRhoDown_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaRhoDown_value

    property e2EnergySigmaRhoUp:
        def __get__(self):
            self.e2EnergySigmaRhoUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaRhoUp_value

    property e2EnergySigmaUp:
        def __get__(self):
            self.e2EnergySigmaUp_branch.GetEntry(self.localentry, 0)
            return self.e2EnergySigmaUp_value

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

    property e2MVAIsoWP80:
        def __get__(self):
            self.e2MVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIsoWP80_value

    property e2MVAIsoWP90:
        def __get__(self):
            self.e2MVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.e2MVAIsoWP90_value

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

    property e2MatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle24Tau30_value

    property e2MatchEmbeddedFilterEle27:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle27_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle27_value

    property e2MatchEmbeddedFilterEle32:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle32_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle32_value

    property e2MatchEmbeddedFilterEle32DoubleL1_v1:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle32DoubleL1_v1_value

    property e2MatchEmbeddedFilterEle32DoubleL1_v2:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle32DoubleL1_v2_value

    property e2MatchEmbeddedFilterEle35:
        def __get__(self):
            self.e2MatchEmbeddedFilterEle35_branch.GetEntry(self.localentry, 0)
            return self.e2MatchEmbeddedFilterEle35_value

    property e2MatchesEle24HPSTau30Filter:
        def __get__(self):
            self.e2MatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24HPSTau30Filter_value

    property e2MatchesEle24HPSTau30Path:
        def __get__(self):
            self.e2MatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24HPSTau30Path_value

    property e2MatchesEle24Tau30Filter:
        def __get__(self):
            self.e2MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Filter_value

    property e2MatchesEle24Tau30Path:
        def __get__(self):
            self.e2MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle24Tau30Path_value

    property e2MatchesEle25Filter:
        def __get__(self):
            self.e2MatchesEle25Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25Filter_value

    property e2MatchesEle25Path:
        def __get__(self):
            self.e2MatchesEle25Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesEle25Path_value

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

    property e2MatchesMu23e12DZFilter:
        def __get__(self):
            self.e2MatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23e12DZFilter_value

    property e2MatchesMu23e12DZPath:
        def __get__(self):
            self.e2MatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23e12DZPath_value

    property e2MatchesMu23e12Filter:
        def __get__(self):
            self.e2MatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23e12Filter_value

    property e2MatchesMu23e12Path:
        def __get__(self):
            self.e2MatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu23e12Path_value

    property e2MatchesMu8e23DZFilter:
        def __get__(self):
            self.e2MatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8e23DZFilter_value

    property e2MatchesMu8e23DZPath:
        def __get__(self):
            self.e2MatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8e23DZPath_value

    property e2MatchesMu8e23Filter:
        def __get__(self):
            self.e2MatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8e23Filter_value

    property e2MatchesMu8e23Path:
        def __get__(self):
            self.e2MatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.e2MatchesMu8e23Path_value

    property e2MissingHits:
        def __get__(self):
            self.e2MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e2MissingHits_value

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

    property e2SIP2D:
        def __get__(self):
            self.e2SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP2D_value

    property e2SIP3D:
        def __get__(self):
            self.e2SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e2SIP3D_value

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

    property e2_t_DR:
        def __get__(self):
            self.e2_t_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_t_DR_value

    property e2_t_Mass:
        def __get__(self):
            self.e2_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_t_Mass_value

    property e2_t_PZeta:
        def __get__(self):
            self.e2_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZeta_value

    property e2_t_PZetaVis:
        def __get__(self):
            self.e2_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_t_PZetaVis_value

    property e2_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.e2_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e2_t_doubleL1IsoTauMatch_value

    property e2ecalEnergy:
        def __get__(self):
            self.e2ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2ecalEnergy_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

    property eVetoZTTp001dxyz:
        def __get__(self):
            self.eVetoZTTp001dxyz_branch.GetEntry(self.localentry, 0)
            return self.eVetoZTTp001dxyz_value

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

    property jetVeto30WoNoisyJets_JetEnDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnDown_value

    property jetVeto30WoNoisyJets_JetEnUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnUp_value

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

    property tByIsolationMVArun2v1DBdR03oldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value

    property tByIsolationMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tByIsolationMVArun2v1DBoldDMwLTraw_value

    property tByLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByMediumIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByMediumIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByMediumIsolationMVArun2v1DBoldDMwLT_value

    property tByPhotonPtSumOutsideSignalCone:
        def __get__(self):
            self.tByPhotonPtSumOutsideSignalCone_branch.GetEntry(self.localentry, 0)
            return self.tByPhotonPtSumOutsideSignalCone_value

    property tByTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVLooseIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value

    property tByVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value

    property tByVTightIsolationMVArun2v1DBoldDMwLT:
        def __get__(self):
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVTightIsolationMVArun2v1DBoldDMwLT_value

    property tByVVTightIsolationMVArun2v1DBdR03oldDMwLT:
        def __get__(self):
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.GetEntry(self.localentry, 0)
            return self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value

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

    property tMatchEmbeddedFilterMu19Tau20:
        def __get__(self):
            self.tMatchEmbeddedFilterMu19Tau20_branch.GetEntry(self.localentry, 0)
            return self.tMatchEmbeddedFilterMu19Tau20_value

    property tMatchEmbeddedFilterMu20HPSTau27:
        def __get__(self):
            self.tMatchEmbeddedFilterMu20HPSTau27_branch.GetEntry(self.localentry, 0)
            return self.tMatchEmbeddedFilterMu20HPSTau27_value

    property tMatchEmbeddedFilterMu20Tau27:
        def __get__(self):
            self.tMatchEmbeddedFilterMu20Tau27_branch.GetEntry(self.localentry, 0)
            return self.tMatchEmbeddedFilterMu20Tau27_value

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

    property tVVLooseDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tVVLooseDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVLooseDeepTau2017v2p1VSmu_value

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

    property tVVVLooseDeepTau2017v2p1VSmu:
        def __get__(self):
            self.tVVVLooseDeepTau2017v2p1VSmu_branch.GetEntry(self.localentry, 0)
            return self.tVVVLooseDeepTau2017v2p1VSmu_value

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


