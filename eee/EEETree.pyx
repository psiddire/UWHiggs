

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

cdef class EEETree:
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

    cdef TBranch* SingleTau180MediumPass_branch
    cdef float SingleTau180MediumPass_value

    cdef TBranch* SingleTau200MediumPass_branch
    cdef float SingleTau200MediumPass_value

    cdef TBranch* SingleTau220MediumPass_branch
    cdef float SingleTau220MediumPass_value

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

    cdef TBranch* e1_e3_DR_branch
    cdef float e1_e3_DR_value

    cdef TBranch* e1_e3_Mass_branch
    cdef float e1_e3_Mass_value

    cdef TBranch* e1_e3_PZeta_branch
    cdef float e1_e3_PZeta_value

    cdef TBranch* e1_e3_PZetaVis_branch
    cdef float e1_e3_PZetaVis_value

    cdef TBranch* e1_e3_doubleL1IsoTauMatch_branch
    cdef float e1_e3_doubleL1IsoTauMatch_value

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

    cdef TBranch* e2_e3_DR_branch
    cdef float e2_e3_DR_value

    cdef TBranch* e2_e3_Mass_branch
    cdef float e2_e3_Mass_value

    cdef TBranch* e2_e3_PZeta_branch
    cdef float e2_e3_PZeta_value

    cdef TBranch* e2_e3_PZetaVis_branch
    cdef float e2_e3_PZetaVis_value

    cdef TBranch* e2_e3_doubleL1IsoTauMatch_branch
    cdef float e2_e3_doubleL1IsoTauMatch_value

    cdef TBranch* e2ecalEnergy_branch
    cdef float e2ecalEnergy_value

    cdef TBranch* e3Charge_branch
    cdef float e3Charge_value

    cdef TBranch* e3ChargeIdLoose_branch
    cdef float e3ChargeIdLoose_value

    cdef TBranch* e3ChargeIdMed_branch
    cdef float e3ChargeIdMed_value

    cdef TBranch* e3ChargeIdTight_branch
    cdef float e3ChargeIdTight_value

    cdef TBranch* e3ComesFromHiggs_branch
    cdef float e3ComesFromHiggs_value

    cdef TBranch* e3CorrectedEt_branch
    cdef float e3CorrectedEt_value

    cdef TBranch* e3EcalIsoDR03_branch
    cdef float e3EcalIsoDR03_value

    cdef TBranch* e3EnergyError_branch
    cdef float e3EnergyError_value

    cdef TBranch* e3EnergyScaleDown_branch
    cdef float e3EnergyScaleDown_value

    cdef TBranch* e3EnergyScaleGainDown_branch
    cdef float e3EnergyScaleGainDown_value

    cdef TBranch* e3EnergyScaleGainUp_branch
    cdef float e3EnergyScaleGainUp_value

    cdef TBranch* e3EnergyScaleStatDown_branch
    cdef float e3EnergyScaleStatDown_value

    cdef TBranch* e3EnergyScaleStatUp_branch
    cdef float e3EnergyScaleStatUp_value

    cdef TBranch* e3EnergyScaleSystDown_branch
    cdef float e3EnergyScaleSystDown_value

    cdef TBranch* e3EnergyScaleSystUp_branch
    cdef float e3EnergyScaleSystUp_value

    cdef TBranch* e3EnergyScaleUp_branch
    cdef float e3EnergyScaleUp_value

    cdef TBranch* e3EnergySigmaDown_branch
    cdef float e3EnergySigmaDown_value

    cdef TBranch* e3EnergySigmaPhiDown_branch
    cdef float e3EnergySigmaPhiDown_value

    cdef TBranch* e3EnergySigmaPhiUp_branch
    cdef float e3EnergySigmaPhiUp_value

    cdef TBranch* e3EnergySigmaRhoDown_branch
    cdef float e3EnergySigmaRhoDown_value

    cdef TBranch* e3EnergySigmaRhoUp_branch
    cdef float e3EnergySigmaRhoUp_value

    cdef TBranch* e3EnergySigmaUp_branch
    cdef float e3EnergySigmaUp_value

    cdef TBranch* e3Eta_branch
    cdef float e3Eta_value

    cdef TBranch* e3GenCharge_branch
    cdef float e3GenCharge_value

    cdef TBranch* e3GenDirectPromptTauDecay_branch
    cdef float e3GenDirectPromptTauDecay_value

    cdef TBranch* e3GenEnergy_branch
    cdef float e3GenEnergy_value

    cdef TBranch* e3GenEta_branch
    cdef float e3GenEta_value

    cdef TBranch* e3GenIsPrompt_branch
    cdef float e3GenIsPrompt_value

    cdef TBranch* e3GenMotherPdgId_branch
    cdef float e3GenMotherPdgId_value

    cdef TBranch* e3GenParticle_branch
    cdef float e3GenParticle_value

    cdef TBranch* e3GenPdgId_branch
    cdef float e3GenPdgId_value

    cdef TBranch* e3GenPhi_branch
    cdef float e3GenPhi_value

    cdef TBranch* e3GenPrompt_branch
    cdef float e3GenPrompt_value

    cdef TBranch* e3GenPromptTauDecay_branch
    cdef float e3GenPromptTauDecay_value

    cdef TBranch* e3GenPt_branch
    cdef float e3GenPt_value

    cdef TBranch* e3GenTauDecay_branch
    cdef float e3GenTauDecay_value

    cdef TBranch* e3GenVZ_branch
    cdef float e3GenVZ_value

    cdef TBranch* e3GenVtxPVMatch_branch
    cdef float e3GenVtxPVMatch_value

    cdef TBranch* e3HcalIsoDR03_branch
    cdef float e3HcalIsoDR03_value

    cdef TBranch* e3IP3D_branch
    cdef float e3IP3D_value

    cdef TBranch* e3IP3DErr_branch
    cdef float e3IP3DErr_value

    cdef TBranch* e3IsoDB03_branch
    cdef float e3IsoDB03_value

    cdef TBranch* e3JetArea_branch
    cdef float e3JetArea_value

    cdef TBranch* e3JetBtag_branch
    cdef float e3JetBtag_value

    cdef TBranch* e3JetDR_branch
    cdef float e3JetDR_value

    cdef TBranch* e3JetEtaEtaMoment_branch
    cdef float e3JetEtaEtaMoment_value

    cdef TBranch* e3JetEtaPhiMoment_branch
    cdef float e3JetEtaPhiMoment_value

    cdef TBranch* e3JetEtaPhiSpread_branch
    cdef float e3JetEtaPhiSpread_value

    cdef TBranch* e3JetHadronFlavour_branch
    cdef float e3JetHadronFlavour_value

    cdef TBranch* e3JetPFCISVBtag_branch
    cdef float e3JetPFCISVBtag_value

    cdef TBranch* e3JetPartonFlavour_branch
    cdef float e3JetPartonFlavour_value

    cdef TBranch* e3JetPhiPhiMoment_branch
    cdef float e3JetPhiPhiMoment_value

    cdef TBranch* e3JetPt_branch
    cdef float e3JetPt_value

    cdef TBranch* e3LowestMll_branch
    cdef float e3LowestMll_value

    cdef TBranch* e3MVAIsoWP80_branch
    cdef float e3MVAIsoWP80_value

    cdef TBranch* e3MVAIsoWP90_branch
    cdef float e3MVAIsoWP90_value

    cdef TBranch* e3MVANoisoWP80_branch
    cdef float e3MVANoisoWP80_value

    cdef TBranch* e3MVANoisoWP90_branch
    cdef float e3MVANoisoWP90_value

    cdef TBranch* e3Mass_branch
    cdef float e3Mass_value

    cdef TBranch* e3MatchEmbeddedFilterEle24Tau30_branch
    cdef float e3MatchEmbeddedFilterEle24Tau30_value

    cdef TBranch* e3MatchEmbeddedFilterEle27_branch
    cdef float e3MatchEmbeddedFilterEle27_value

    cdef TBranch* e3MatchEmbeddedFilterEle32_branch
    cdef float e3MatchEmbeddedFilterEle32_value

    cdef TBranch* e3MatchEmbeddedFilterEle32DoubleL1_v1_branch
    cdef float e3MatchEmbeddedFilterEle32DoubleL1_v1_value

    cdef TBranch* e3MatchEmbeddedFilterEle32DoubleL1_v2_branch
    cdef float e3MatchEmbeddedFilterEle32DoubleL1_v2_value

    cdef TBranch* e3MatchEmbeddedFilterEle35_branch
    cdef float e3MatchEmbeddedFilterEle35_value

    cdef TBranch* e3MatchesEle24HPSTau30Filter_branch
    cdef float e3MatchesEle24HPSTau30Filter_value

    cdef TBranch* e3MatchesEle24HPSTau30Path_branch
    cdef float e3MatchesEle24HPSTau30Path_value

    cdef TBranch* e3MatchesEle24Tau30Filter_branch
    cdef float e3MatchesEle24Tau30Filter_value

    cdef TBranch* e3MatchesEle24Tau30Path_branch
    cdef float e3MatchesEle24Tau30Path_value

    cdef TBranch* e3MatchesEle25Filter_branch
    cdef float e3MatchesEle25Filter_value

    cdef TBranch* e3MatchesEle25Path_branch
    cdef float e3MatchesEle25Path_value

    cdef TBranch* e3MatchesEle27Filter_branch
    cdef float e3MatchesEle27Filter_value

    cdef TBranch* e3MatchesEle27Path_branch
    cdef float e3MatchesEle27Path_value

    cdef TBranch* e3MatchesEle32Filter_branch
    cdef float e3MatchesEle32Filter_value

    cdef TBranch* e3MatchesEle32Path_branch
    cdef float e3MatchesEle32Path_value

    cdef TBranch* e3MatchesEle35Filter_branch
    cdef float e3MatchesEle35Filter_value

    cdef TBranch* e3MatchesEle35Path_branch
    cdef float e3MatchesEle35Path_value

    cdef TBranch* e3MatchesMu23e12DZFilter_branch
    cdef float e3MatchesMu23e12DZFilter_value

    cdef TBranch* e3MatchesMu23e12DZPath_branch
    cdef float e3MatchesMu23e12DZPath_value

    cdef TBranch* e3MatchesMu23e12Filter_branch
    cdef float e3MatchesMu23e12Filter_value

    cdef TBranch* e3MatchesMu23e12Path_branch
    cdef float e3MatchesMu23e12Path_value

    cdef TBranch* e3MatchesMu8e23DZFilter_branch
    cdef float e3MatchesMu8e23DZFilter_value

    cdef TBranch* e3MatchesMu8e23DZPath_branch
    cdef float e3MatchesMu8e23DZPath_value

    cdef TBranch* e3MatchesMu8e23Filter_branch
    cdef float e3MatchesMu8e23Filter_value

    cdef TBranch* e3MatchesMu8e23Path_branch
    cdef float e3MatchesMu8e23Path_value

    cdef TBranch* e3MissingHits_branch
    cdef float e3MissingHits_value

    cdef TBranch* e3NearMuonVeto_branch
    cdef float e3NearMuonVeto_value

    cdef TBranch* e3NearestMuonDR_branch
    cdef float e3NearestMuonDR_value

    cdef TBranch* e3NearestZMass_branch
    cdef float e3NearestZMass_value

    cdef TBranch* e3PFChargedIso_branch
    cdef float e3PFChargedIso_value

    cdef TBranch* e3PFNeutralIso_branch
    cdef float e3PFNeutralIso_value

    cdef TBranch* e3PFPUChargedIso_branch
    cdef float e3PFPUChargedIso_value

    cdef TBranch* e3PFPhotonIso_branch
    cdef float e3PFPhotonIso_value

    cdef TBranch* e3PVDXY_branch
    cdef float e3PVDXY_value

    cdef TBranch* e3PVDZ_branch
    cdef float e3PVDZ_value

    cdef TBranch* e3PassesConversionVeto_branch
    cdef float e3PassesConversionVeto_value

    cdef TBranch* e3Phi_branch
    cdef float e3Phi_value

    cdef TBranch* e3Pt_branch
    cdef float e3Pt_value

    cdef TBranch* e3RelIso_branch
    cdef float e3RelIso_value

    cdef TBranch* e3RelPFIsoDB_branch
    cdef float e3RelPFIsoDB_value

    cdef TBranch* e3RelPFIsoRho_branch
    cdef float e3RelPFIsoRho_value

    cdef TBranch* e3Rho_branch
    cdef float e3Rho_value

    cdef TBranch* e3SIP2D_branch
    cdef float e3SIP2D_value

    cdef TBranch* e3SIP3D_branch
    cdef float e3SIP3D_value

    cdef TBranch* e3TrkIsoDR03_branch
    cdef float e3TrkIsoDR03_value

    cdef TBranch* e3VZ_branch
    cdef float e3VZ_value

    cdef TBranch* e3ZTTGenMatching_branch
    cdef float e3ZTTGenMatching_value

    cdef TBranch* e3ecalEnergy_branch
    cdef float e3ecalEnergy_value

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
            warnings.warn( "EEETree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "EEETree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "EEETree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "EEETree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "EEETree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "EEETree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "EEETree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "EEETree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "EEETree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "EEETree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "EEETree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "EEETree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "EEETree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "EEETree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "EEETree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "EEETree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "EEETree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "EEETree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EEETree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EEETree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EEETree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EEETree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EEETree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EEETree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EEETree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EEETree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "EEETree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EEETree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "EEETree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "EEETree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EEETree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "EEETree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "EEETree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "EEETree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "EEETree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "EEETree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "EEETree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "EEETree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "EEETree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "EEETree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "EEETree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "EEETree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "EEETree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "EEETree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "EEETree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "EEETree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "EEETree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "EEETree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "EEETree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "EEETree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "EEETree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making SingleTau180MediumPass"
        self.SingleTau180MediumPass_branch = the_tree.GetBranch("SingleTau180MediumPass")
        #if not self.SingleTau180MediumPass_branch and "SingleTau180MediumPass" not in self.complained:
        if not self.SingleTau180MediumPass_branch and "SingleTau180MediumPass":
            warnings.warn( "EEETree: Expected branch SingleTau180MediumPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("SingleTau180MediumPass")
        else:
            self.SingleTau180MediumPass_branch.SetAddress(<void*>&self.SingleTau180MediumPass_value)

        #print "making SingleTau200MediumPass"
        self.SingleTau200MediumPass_branch = the_tree.GetBranch("SingleTau200MediumPass")
        #if not self.SingleTau200MediumPass_branch and "SingleTau200MediumPass" not in self.complained:
        if not self.SingleTau200MediumPass_branch and "SingleTau200MediumPass":
            warnings.warn( "EEETree: Expected branch SingleTau200MediumPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("SingleTau200MediumPass")
        else:
            self.SingleTau200MediumPass_branch.SetAddress(<void*>&self.SingleTau200MediumPass_value)

        #print "making SingleTau220MediumPass"
        self.SingleTau220MediumPass_branch = the_tree.GetBranch("SingleTau220MediumPass")
        #if not self.SingleTau220MediumPass_branch and "SingleTau220MediumPass" not in self.complained:
        if not self.SingleTau220MediumPass_branch and "SingleTau220MediumPass":
            warnings.warn( "EEETree: Expected branch SingleTau220MediumPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("SingleTau220MediumPass")
        else:
            self.SingleTau220MediumPass_branch.SetAddress(<void*>&self.SingleTau220MediumPass_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "EEETree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "EEETree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making bweight_2016"
        self.bweight_2016_branch = the_tree.GetBranch("bweight_2016")
        #if not self.bweight_2016_branch and "bweight_2016" not in self.complained:
        if not self.bweight_2016_branch and "bweight_2016":
            warnings.warn( "EEETree: Expected branch bweight_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2016")
        else:
            self.bweight_2016_branch.SetAddress(<void*>&self.bweight_2016_value)

        #print "making bweight_2017"
        self.bweight_2017_branch = the_tree.GetBranch("bweight_2017")
        #if not self.bweight_2017_branch and "bweight_2017" not in self.complained:
        if not self.bweight_2017_branch and "bweight_2017":
            warnings.warn( "EEETree: Expected branch bweight_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2017")
        else:
            self.bweight_2017_branch.SetAddress(<void*>&self.bweight_2017_value)

        #print "making bweight_2018"
        self.bweight_2018_branch = the_tree.GetBranch("bweight_2018")
        #if not self.bweight_2018_branch and "bweight_2018" not in self.complained:
        if not self.bweight_2018_branch and "bweight_2018":
            warnings.warn( "EEETree: Expected branch bweight_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2018")
        else:
            self.bweight_2018_branch.SetAddress(<void*>&self.bweight_2018_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "EEETree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "EEETree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "EEETree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "EEETree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "EEETree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "EEETree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "EEETree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "EEETree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "EEETree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "EEETree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "EEETree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "EEETree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making e1Charge"
        self.e1Charge_branch = the_tree.GetBranch("e1Charge")
        #if not self.e1Charge_branch and "e1Charge" not in self.complained:
        if not self.e1Charge_branch and "e1Charge":
            warnings.warn( "EEETree: Expected branch e1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Charge")
        else:
            self.e1Charge_branch.SetAddress(<void*>&self.e1Charge_value)

        #print "making e1ChargeIdLoose"
        self.e1ChargeIdLoose_branch = the_tree.GetBranch("e1ChargeIdLoose")
        #if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose" not in self.complained:
        if not self.e1ChargeIdLoose_branch and "e1ChargeIdLoose":
            warnings.warn( "EEETree: Expected branch e1ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdLoose")
        else:
            self.e1ChargeIdLoose_branch.SetAddress(<void*>&self.e1ChargeIdLoose_value)

        #print "making e1ChargeIdMed"
        self.e1ChargeIdMed_branch = the_tree.GetBranch("e1ChargeIdMed")
        #if not self.e1ChargeIdMed_branch and "e1ChargeIdMed" not in self.complained:
        if not self.e1ChargeIdMed_branch and "e1ChargeIdMed":
            warnings.warn( "EEETree: Expected branch e1ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdMed")
        else:
            self.e1ChargeIdMed_branch.SetAddress(<void*>&self.e1ChargeIdMed_value)

        #print "making e1ChargeIdTight"
        self.e1ChargeIdTight_branch = the_tree.GetBranch("e1ChargeIdTight")
        #if not self.e1ChargeIdTight_branch and "e1ChargeIdTight" not in self.complained:
        if not self.e1ChargeIdTight_branch and "e1ChargeIdTight":
            warnings.warn( "EEETree: Expected branch e1ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ChargeIdTight")
        else:
            self.e1ChargeIdTight_branch.SetAddress(<void*>&self.e1ChargeIdTight_value)

        #print "making e1ComesFromHiggs"
        self.e1ComesFromHiggs_branch = the_tree.GetBranch("e1ComesFromHiggs")
        #if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs" not in self.complained:
        if not self.e1ComesFromHiggs_branch and "e1ComesFromHiggs":
            warnings.warn( "EEETree: Expected branch e1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ComesFromHiggs")
        else:
            self.e1ComesFromHiggs_branch.SetAddress(<void*>&self.e1ComesFromHiggs_value)

        #print "making e1CorrectedEt"
        self.e1CorrectedEt_branch = the_tree.GetBranch("e1CorrectedEt")
        #if not self.e1CorrectedEt_branch and "e1CorrectedEt" not in self.complained:
        if not self.e1CorrectedEt_branch and "e1CorrectedEt":
            warnings.warn( "EEETree: Expected branch e1CorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1CorrectedEt")
        else:
            self.e1CorrectedEt_branch.SetAddress(<void*>&self.e1CorrectedEt_value)

        #print "making e1EcalIsoDR03"
        self.e1EcalIsoDR03_branch = the_tree.GetBranch("e1EcalIsoDR03")
        #if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03" not in self.complained:
        if not self.e1EcalIsoDR03_branch and "e1EcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EcalIsoDR03")
        else:
            self.e1EcalIsoDR03_branch.SetAddress(<void*>&self.e1EcalIsoDR03_value)

        #print "making e1EnergyError"
        self.e1EnergyError_branch = the_tree.GetBranch("e1EnergyError")
        #if not self.e1EnergyError_branch and "e1EnergyError" not in self.complained:
        if not self.e1EnergyError_branch and "e1EnergyError":
            warnings.warn( "EEETree: Expected branch e1EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyError")
        else:
            self.e1EnergyError_branch.SetAddress(<void*>&self.e1EnergyError_value)

        #print "making e1EnergyScaleDown"
        self.e1EnergyScaleDown_branch = the_tree.GetBranch("e1EnergyScaleDown")
        #if not self.e1EnergyScaleDown_branch and "e1EnergyScaleDown" not in self.complained:
        if not self.e1EnergyScaleDown_branch and "e1EnergyScaleDown":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleDown")
        else:
            self.e1EnergyScaleDown_branch.SetAddress(<void*>&self.e1EnergyScaleDown_value)

        #print "making e1EnergyScaleGainDown"
        self.e1EnergyScaleGainDown_branch = the_tree.GetBranch("e1EnergyScaleGainDown")
        #if not self.e1EnergyScaleGainDown_branch and "e1EnergyScaleGainDown" not in self.complained:
        if not self.e1EnergyScaleGainDown_branch and "e1EnergyScaleGainDown":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleGainDown")
        else:
            self.e1EnergyScaleGainDown_branch.SetAddress(<void*>&self.e1EnergyScaleGainDown_value)

        #print "making e1EnergyScaleGainUp"
        self.e1EnergyScaleGainUp_branch = the_tree.GetBranch("e1EnergyScaleGainUp")
        #if not self.e1EnergyScaleGainUp_branch and "e1EnergyScaleGainUp" not in self.complained:
        if not self.e1EnergyScaleGainUp_branch and "e1EnergyScaleGainUp":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleGainUp")
        else:
            self.e1EnergyScaleGainUp_branch.SetAddress(<void*>&self.e1EnergyScaleGainUp_value)

        #print "making e1EnergyScaleStatDown"
        self.e1EnergyScaleStatDown_branch = the_tree.GetBranch("e1EnergyScaleStatDown")
        #if not self.e1EnergyScaleStatDown_branch and "e1EnergyScaleStatDown" not in self.complained:
        if not self.e1EnergyScaleStatDown_branch and "e1EnergyScaleStatDown":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleStatDown")
        else:
            self.e1EnergyScaleStatDown_branch.SetAddress(<void*>&self.e1EnergyScaleStatDown_value)

        #print "making e1EnergyScaleStatUp"
        self.e1EnergyScaleStatUp_branch = the_tree.GetBranch("e1EnergyScaleStatUp")
        #if not self.e1EnergyScaleStatUp_branch and "e1EnergyScaleStatUp" not in self.complained:
        if not self.e1EnergyScaleStatUp_branch and "e1EnergyScaleStatUp":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleStatUp")
        else:
            self.e1EnergyScaleStatUp_branch.SetAddress(<void*>&self.e1EnergyScaleStatUp_value)

        #print "making e1EnergyScaleSystDown"
        self.e1EnergyScaleSystDown_branch = the_tree.GetBranch("e1EnergyScaleSystDown")
        #if not self.e1EnergyScaleSystDown_branch and "e1EnergyScaleSystDown" not in self.complained:
        if not self.e1EnergyScaleSystDown_branch and "e1EnergyScaleSystDown":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleSystDown")
        else:
            self.e1EnergyScaleSystDown_branch.SetAddress(<void*>&self.e1EnergyScaleSystDown_value)

        #print "making e1EnergyScaleSystUp"
        self.e1EnergyScaleSystUp_branch = the_tree.GetBranch("e1EnergyScaleSystUp")
        #if not self.e1EnergyScaleSystUp_branch and "e1EnergyScaleSystUp" not in self.complained:
        if not self.e1EnergyScaleSystUp_branch and "e1EnergyScaleSystUp":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleSystUp")
        else:
            self.e1EnergyScaleSystUp_branch.SetAddress(<void*>&self.e1EnergyScaleSystUp_value)

        #print "making e1EnergyScaleUp"
        self.e1EnergyScaleUp_branch = the_tree.GetBranch("e1EnergyScaleUp")
        #if not self.e1EnergyScaleUp_branch and "e1EnergyScaleUp" not in self.complained:
        if not self.e1EnergyScaleUp_branch and "e1EnergyScaleUp":
            warnings.warn( "EEETree: Expected branch e1EnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergyScaleUp")
        else:
            self.e1EnergyScaleUp_branch.SetAddress(<void*>&self.e1EnergyScaleUp_value)

        #print "making e1EnergySigmaDown"
        self.e1EnergySigmaDown_branch = the_tree.GetBranch("e1EnergySigmaDown")
        #if not self.e1EnergySigmaDown_branch and "e1EnergySigmaDown" not in self.complained:
        if not self.e1EnergySigmaDown_branch and "e1EnergySigmaDown":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaDown")
        else:
            self.e1EnergySigmaDown_branch.SetAddress(<void*>&self.e1EnergySigmaDown_value)

        #print "making e1EnergySigmaPhiDown"
        self.e1EnergySigmaPhiDown_branch = the_tree.GetBranch("e1EnergySigmaPhiDown")
        #if not self.e1EnergySigmaPhiDown_branch and "e1EnergySigmaPhiDown" not in self.complained:
        if not self.e1EnergySigmaPhiDown_branch and "e1EnergySigmaPhiDown":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaPhiDown")
        else:
            self.e1EnergySigmaPhiDown_branch.SetAddress(<void*>&self.e1EnergySigmaPhiDown_value)

        #print "making e1EnergySigmaPhiUp"
        self.e1EnergySigmaPhiUp_branch = the_tree.GetBranch("e1EnergySigmaPhiUp")
        #if not self.e1EnergySigmaPhiUp_branch and "e1EnergySigmaPhiUp" not in self.complained:
        if not self.e1EnergySigmaPhiUp_branch and "e1EnergySigmaPhiUp":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaPhiUp")
        else:
            self.e1EnergySigmaPhiUp_branch.SetAddress(<void*>&self.e1EnergySigmaPhiUp_value)

        #print "making e1EnergySigmaRhoDown"
        self.e1EnergySigmaRhoDown_branch = the_tree.GetBranch("e1EnergySigmaRhoDown")
        #if not self.e1EnergySigmaRhoDown_branch and "e1EnergySigmaRhoDown" not in self.complained:
        if not self.e1EnergySigmaRhoDown_branch and "e1EnergySigmaRhoDown":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaRhoDown")
        else:
            self.e1EnergySigmaRhoDown_branch.SetAddress(<void*>&self.e1EnergySigmaRhoDown_value)

        #print "making e1EnergySigmaRhoUp"
        self.e1EnergySigmaRhoUp_branch = the_tree.GetBranch("e1EnergySigmaRhoUp")
        #if not self.e1EnergySigmaRhoUp_branch and "e1EnergySigmaRhoUp" not in self.complained:
        if not self.e1EnergySigmaRhoUp_branch and "e1EnergySigmaRhoUp":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaRhoUp")
        else:
            self.e1EnergySigmaRhoUp_branch.SetAddress(<void*>&self.e1EnergySigmaRhoUp_value)

        #print "making e1EnergySigmaUp"
        self.e1EnergySigmaUp_branch = the_tree.GetBranch("e1EnergySigmaUp")
        #if not self.e1EnergySigmaUp_branch and "e1EnergySigmaUp" not in self.complained:
        if not self.e1EnergySigmaUp_branch and "e1EnergySigmaUp":
            warnings.warn( "EEETree: Expected branch e1EnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1EnergySigmaUp")
        else:
            self.e1EnergySigmaUp_branch.SetAddress(<void*>&self.e1EnergySigmaUp_value)

        #print "making e1Eta"
        self.e1Eta_branch = the_tree.GetBranch("e1Eta")
        #if not self.e1Eta_branch and "e1Eta" not in self.complained:
        if not self.e1Eta_branch and "e1Eta":
            warnings.warn( "EEETree: Expected branch e1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Eta")
        else:
            self.e1Eta_branch.SetAddress(<void*>&self.e1Eta_value)

        #print "making e1GenCharge"
        self.e1GenCharge_branch = the_tree.GetBranch("e1GenCharge")
        #if not self.e1GenCharge_branch and "e1GenCharge" not in self.complained:
        if not self.e1GenCharge_branch and "e1GenCharge":
            warnings.warn( "EEETree: Expected branch e1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenCharge")
        else:
            self.e1GenCharge_branch.SetAddress(<void*>&self.e1GenCharge_value)

        #print "making e1GenDirectPromptTauDecay"
        self.e1GenDirectPromptTauDecay_branch = the_tree.GetBranch("e1GenDirectPromptTauDecay")
        #if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay" not in self.complained:
        if not self.e1GenDirectPromptTauDecay_branch and "e1GenDirectPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e1GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenDirectPromptTauDecay")
        else:
            self.e1GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e1GenDirectPromptTauDecay_value)

        #print "making e1GenEnergy"
        self.e1GenEnergy_branch = the_tree.GetBranch("e1GenEnergy")
        #if not self.e1GenEnergy_branch and "e1GenEnergy" not in self.complained:
        if not self.e1GenEnergy_branch and "e1GenEnergy":
            warnings.warn( "EEETree: Expected branch e1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEnergy")
        else:
            self.e1GenEnergy_branch.SetAddress(<void*>&self.e1GenEnergy_value)

        #print "making e1GenEta"
        self.e1GenEta_branch = the_tree.GetBranch("e1GenEta")
        #if not self.e1GenEta_branch and "e1GenEta" not in self.complained:
        if not self.e1GenEta_branch and "e1GenEta":
            warnings.warn( "EEETree: Expected branch e1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenEta")
        else:
            self.e1GenEta_branch.SetAddress(<void*>&self.e1GenEta_value)

        #print "making e1GenIsPrompt"
        self.e1GenIsPrompt_branch = the_tree.GetBranch("e1GenIsPrompt")
        #if not self.e1GenIsPrompt_branch and "e1GenIsPrompt" not in self.complained:
        if not self.e1GenIsPrompt_branch and "e1GenIsPrompt":
            warnings.warn( "EEETree: Expected branch e1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenIsPrompt")
        else:
            self.e1GenIsPrompt_branch.SetAddress(<void*>&self.e1GenIsPrompt_value)

        #print "making e1GenMotherPdgId"
        self.e1GenMotherPdgId_branch = the_tree.GetBranch("e1GenMotherPdgId")
        #if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId" not in self.complained:
        if not self.e1GenMotherPdgId_branch and "e1GenMotherPdgId":
            warnings.warn( "EEETree: Expected branch e1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenMotherPdgId")
        else:
            self.e1GenMotherPdgId_branch.SetAddress(<void*>&self.e1GenMotherPdgId_value)

        #print "making e1GenParticle"
        self.e1GenParticle_branch = the_tree.GetBranch("e1GenParticle")
        #if not self.e1GenParticle_branch and "e1GenParticle" not in self.complained:
        if not self.e1GenParticle_branch and "e1GenParticle":
            warnings.warn( "EEETree: Expected branch e1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenParticle")
        else:
            self.e1GenParticle_branch.SetAddress(<void*>&self.e1GenParticle_value)

        #print "making e1GenPdgId"
        self.e1GenPdgId_branch = the_tree.GetBranch("e1GenPdgId")
        #if not self.e1GenPdgId_branch and "e1GenPdgId" not in self.complained:
        if not self.e1GenPdgId_branch and "e1GenPdgId":
            warnings.warn( "EEETree: Expected branch e1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPdgId")
        else:
            self.e1GenPdgId_branch.SetAddress(<void*>&self.e1GenPdgId_value)

        #print "making e1GenPhi"
        self.e1GenPhi_branch = the_tree.GetBranch("e1GenPhi")
        #if not self.e1GenPhi_branch and "e1GenPhi" not in self.complained:
        if not self.e1GenPhi_branch and "e1GenPhi":
            warnings.warn( "EEETree: Expected branch e1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPhi")
        else:
            self.e1GenPhi_branch.SetAddress(<void*>&self.e1GenPhi_value)

        #print "making e1GenPrompt"
        self.e1GenPrompt_branch = the_tree.GetBranch("e1GenPrompt")
        #if not self.e1GenPrompt_branch and "e1GenPrompt" not in self.complained:
        if not self.e1GenPrompt_branch and "e1GenPrompt":
            warnings.warn( "EEETree: Expected branch e1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPrompt")
        else:
            self.e1GenPrompt_branch.SetAddress(<void*>&self.e1GenPrompt_value)

        #print "making e1GenPromptTauDecay"
        self.e1GenPromptTauDecay_branch = the_tree.GetBranch("e1GenPromptTauDecay")
        #if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay" not in self.complained:
        if not self.e1GenPromptTauDecay_branch and "e1GenPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPromptTauDecay")
        else:
            self.e1GenPromptTauDecay_branch.SetAddress(<void*>&self.e1GenPromptTauDecay_value)

        #print "making e1GenPt"
        self.e1GenPt_branch = the_tree.GetBranch("e1GenPt")
        #if not self.e1GenPt_branch and "e1GenPt" not in self.complained:
        if not self.e1GenPt_branch and "e1GenPt":
            warnings.warn( "EEETree: Expected branch e1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenPt")
        else:
            self.e1GenPt_branch.SetAddress(<void*>&self.e1GenPt_value)

        #print "making e1GenTauDecay"
        self.e1GenTauDecay_branch = the_tree.GetBranch("e1GenTauDecay")
        #if not self.e1GenTauDecay_branch and "e1GenTauDecay" not in self.complained:
        if not self.e1GenTauDecay_branch and "e1GenTauDecay":
            warnings.warn( "EEETree: Expected branch e1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenTauDecay")
        else:
            self.e1GenTauDecay_branch.SetAddress(<void*>&self.e1GenTauDecay_value)

        #print "making e1GenVZ"
        self.e1GenVZ_branch = the_tree.GetBranch("e1GenVZ")
        #if not self.e1GenVZ_branch and "e1GenVZ" not in self.complained:
        if not self.e1GenVZ_branch and "e1GenVZ":
            warnings.warn( "EEETree: Expected branch e1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVZ")
        else:
            self.e1GenVZ_branch.SetAddress(<void*>&self.e1GenVZ_value)

        #print "making e1GenVtxPVMatch"
        self.e1GenVtxPVMatch_branch = the_tree.GetBranch("e1GenVtxPVMatch")
        #if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch" not in self.complained:
        if not self.e1GenVtxPVMatch_branch and "e1GenVtxPVMatch":
            warnings.warn( "EEETree: Expected branch e1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1GenVtxPVMatch")
        else:
            self.e1GenVtxPVMatch_branch.SetAddress(<void*>&self.e1GenVtxPVMatch_value)

        #print "making e1HcalIsoDR03"
        self.e1HcalIsoDR03_branch = the_tree.GetBranch("e1HcalIsoDR03")
        #if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03" not in self.complained:
        if not self.e1HcalIsoDR03_branch and "e1HcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1HcalIsoDR03")
        else:
            self.e1HcalIsoDR03_branch.SetAddress(<void*>&self.e1HcalIsoDR03_value)

        #print "making e1IP3D"
        self.e1IP3D_branch = the_tree.GetBranch("e1IP3D")
        #if not self.e1IP3D_branch and "e1IP3D" not in self.complained:
        if not self.e1IP3D_branch and "e1IP3D":
            warnings.warn( "EEETree: Expected branch e1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3D")
        else:
            self.e1IP3D_branch.SetAddress(<void*>&self.e1IP3D_value)

        #print "making e1IP3DErr"
        self.e1IP3DErr_branch = the_tree.GetBranch("e1IP3DErr")
        #if not self.e1IP3DErr_branch and "e1IP3DErr" not in self.complained:
        if not self.e1IP3DErr_branch and "e1IP3DErr":
            warnings.warn( "EEETree: Expected branch e1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IP3DErr")
        else:
            self.e1IP3DErr_branch.SetAddress(<void*>&self.e1IP3DErr_value)

        #print "making e1IsoDB03"
        self.e1IsoDB03_branch = the_tree.GetBranch("e1IsoDB03")
        #if not self.e1IsoDB03_branch and "e1IsoDB03" not in self.complained:
        if not self.e1IsoDB03_branch and "e1IsoDB03":
            warnings.warn( "EEETree: Expected branch e1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1IsoDB03")
        else:
            self.e1IsoDB03_branch.SetAddress(<void*>&self.e1IsoDB03_value)

        #print "making e1JetArea"
        self.e1JetArea_branch = the_tree.GetBranch("e1JetArea")
        #if not self.e1JetArea_branch and "e1JetArea" not in self.complained:
        if not self.e1JetArea_branch and "e1JetArea":
            warnings.warn( "EEETree: Expected branch e1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetArea")
        else:
            self.e1JetArea_branch.SetAddress(<void*>&self.e1JetArea_value)

        #print "making e1JetBtag"
        self.e1JetBtag_branch = the_tree.GetBranch("e1JetBtag")
        #if not self.e1JetBtag_branch and "e1JetBtag" not in self.complained:
        if not self.e1JetBtag_branch and "e1JetBtag":
            warnings.warn( "EEETree: Expected branch e1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetBtag")
        else:
            self.e1JetBtag_branch.SetAddress(<void*>&self.e1JetBtag_value)

        #print "making e1JetDR"
        self.e1JetDR_branch = the_tree.GetBranch("e1JetDR")
        #if not self.e1JetDR_branch and "e1JetDR" not in self.complained:
        if not self.e1JetDR_branch and "e1JetDR":
            warnings.warn( "EEETree: Expected branch e1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetDR")
        else:
            self.e1JetDR_branch.SetAddress(<void*>&self.e1JetDR_value)

        #print "making e1JetEtaEtaMoment"
        self.e1JetEtaEtaMoment_branch = the_tree.GetBranch("e1JetEtaEtaMoment")
        #if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment" not in self.complained:
        if not self.e1JetEtaEtaMoment_branch and "e1JetEtaEtaMoment":
            warnings.warn( "EEETree: Expected branch e1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaEtaMoment")
        else:
            self.e1JetEtaEtaMoment_branch.SetAddress(<void*>&self.e1JetEtaEtaMoment_value)

        #print "making e1JetEtaPhiMoment"
        self.e1JetEtaPhiMoment_branch = the_tree.GetBranch("e1JetEtaPhiMoment")
        #if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment" not in self.complained:
        if not self.e1JetEtaPhiMoment_branch and "e1JetEtaPhiMoment":
            warnings.warn( "EEETree: Expected branch e1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiMoment")
        else:
            self.e1JetEtaPhiMoment_branch.SetAddress(<void*>&self.e1JetEtaPhiMoment_value)

        #print "making e1JetEtaPhiSpread"
        self.e1JetEtaPhiSpread_branch = the_tree.GetBranch("e1JetEtaPhiSpread")
        #if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread" not in self.complained:
        if not self.e1JetEtaPhiSpread_branch and "e1JetEtaPhiSpread":
            warnings.warn( "EEETree: Expected branch e1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetEtaPhiSpread")
        else:
            self.e1JetEtaPhiSpread_branch.SetAddress(<void*>&self.e1JetEtaPhiSpread_value)

        #print "making e1JetHadronFlavour"
        self.e1JetHadronFlavour_branch = the_tree.GetBranch("e1JetHadronFlavour")
        #if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour" not in self.complained:
        if not self.e1JetHadronFlavour_branch and "e1JetHadronFlavour":
            warnings.warn( "EEETree: Expected branch e1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetHadronFlavour")
        else:
            self.e1JetHadronFlavour_branch.SetAddress(<void*>&self.e1JetHadronFlavour_value)

        #print "making e1JetPFCISVBtag"
        self.e1JetPFCISVBtag_branch = the_tree.GetBranch("e1JetPFCISVBtag")
        #if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag" not in self.complained:
        if not self.e1JetPFCISVBtag_branch and "e1JetPFCISVBtag":
            warnings.warn( "EEETree: Expected branch e1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPFCISVBtag")
        else:
            self.e1JetPFCISVBtag_branch.SetAddress(<void*>&self.e1JetPFCISVBtag_value)

        #print "making e1JetPartonFlavour"
        self.e1JetPartonFlavour_branch = the_tree.GetBranch("e1JetPartonFlavour")
        #if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour" not in self.complained:
        if not self.e1JetPartonFlavour_branch and "e1JetPartonFlavour":
            warnings.warn( "EEETree: Expected branch e1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPartonFlavour")
        else:
            self.e1JetPartonFlavour_branch.SetAddress(<void*>&self.e1JetPartonFlavour_value)

        #print "making e1JetPhiPhiMoment"
        self.e1JetPhiPhiMoment_branch = the_tree.GetBranch("e1JetPhiPhiMoment")
        #if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment" not in self.complained:
        if not self.e1JetPhiPhiMoment_branch and "e1JetPhiPhiMoment":
            warnings.warn( "EEETree: Expected branch e1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPhiPhiMoment")
        else:
            self.e1JetPhiPhiMoment_branch.SetAddress(<void*>&self.e1JetPhiPhiMoment_value)

        #print "making e1JetPt"
        self.e1JetPt_branch = the_tree.GetBranch("e1JetPt")
        #if not self.e1JetPt_branch and "e1JetPt" not in self.complained:
        if not self.e1JetPt_branch and "e1JetPt":
            warnings.warn( "EEETree: Expected branch e1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1JetPt")
        else:
            self.e1JetPt_branch.SetAddress(<void*>&self.e1JetPt_value)

        #print "making e1LowestMll"
        self.e1LowestMll_branch = the_tree.GetBranch("e1LowestMll")
        #if not self.e1LowestMll_branch and "e1LowestMll" not in self.complained:
        if not self.e1LowestMll_branch and "e1LowestMll":
            warnings.warn( "EEETree: Expected branch e1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1LowestMll")
        else:
            self.e1LowestMll_branch.SetAddress(<void*>&self.e1LowestMll_value)

        #print "making e1MVAIsoWP80"
        self.e1MVAIsoWP80_branch = the_tree.GetBranch("e1MVAIsoWP80")
        #if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80" not in self.complained:
        if not self.e1MVAIsoWP80_branch and "e1MVAIsoWP80":
            warnings.warn( "EEETree: Expected branch e1MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP80")
        else:
            self.e1MVAIsoWP80_branch.SetAddress(<void*>&self.e1MVAIsoWP80_value)

        #print "making e1MVAIsoWP90"
        self.e1MVAIsoWP90_branch = the_tree.GetBranch("e1MVAIsoWP90")
        #if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90" not in self.complained:
        if not self.e1MVAIsoWP90_branch and "e1MVAIsoWP90":
            warnings.warn( "EEETree: Expected branch e1MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVAIsoWP90")
        else:
            self.e1MVAIsoWP90_branch.SetAddress(<void*>&self.e1MVAIsoWP90_value)

        #print "making e1MVANoisoWP80"
        self.e1MVANoisoWP80_branch = the_tree.GetBranch("e1MVANoisoWP80")
        #if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80" not in self.complained:
        if not self.e1MVANoisoWP80_branch and "e1MVANoisoWP80":
            warnings.warn( "EEETree: Expected branch e1MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP80")
        else:
            self.e1MVANoisoWP80_branch.SetAddress(<void*>&self.e1MVANoisoWP80_value)

        #print "making e1MVANoisoWP90"
        self.e1MVANoisoWP90_branch = the_tree.GetBranch("e1MVANoisoWP90")
        #if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90" not in self.complained:
        if not self.e1MVANoisoWP90_branch and "e1MVANoisoWP90":
            warnings.warn( "EEETree: Expected branch e1MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MVANoisoWP90")
        else:
            self.e1MVANoisoWP90_branch.SetAddress(<void*>&self.e1MVANoisoWP90_value)

        #print "making e1Mass"
        self.e1Mass_branch = the_tree.GetBranch("e1Mass")
        #if not self.e1Mass_branch and "e1Mass" not in self.complained:
        if not self.e1Mass_branch and "e1Mass":
            warnings.warn( "EEETree: Expected branch e1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Mass")
        else:
            self.e1Mass_branch.SetAddress(<void*>&self.e1Mass_value)

        #print "making e1MatchEmbeddedFilterEle24Tau30"
        self.e1MatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle24Tau30")
        #if not self.e1MatchEmbeddedFilterEle24Tau30_branch and "e1MatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle24Tau30_branch and "e1MatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle24Tau30")
        else:
            self.e1MatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle24Tau30_value)

        #print "making e1MatchEmbeddedFilterEle27"
        self.e1MatchEmbeddedFilterEle27_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle27")
        #if not self.e1MatchEmbeddedFilterEle27_branch and "e1MatchEmbeddedFilterEle27" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle27_branch and "e1MatchEmbeddedFilterEle27":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle27")
        else:
            self.e1MatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle27_value)

        #print "making e1MatchEmbeddedFilterEle32"
        self.e1MatchEmbeddedFilterEle32_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32")
        #if not self.e1MatchEmbeddedFilterEle32_branch and "e1MatchEmbeddedFilterEle32" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32_branch and "e1MatchEmbeddedFilterEle32":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32")
        else:
            self.e1MatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32_value)

        #print "making e1MatchEmbeddedFilterEle32DoubleL1_v1"
        self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.e1MatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making e1MatchEmbeddedFilterEle32DoubleL1_v2"
        self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e1MatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.e1MatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making e1MatchEmbeddedFilterEle35"
        self.e1MatchEmbeddedFilterEle35_branch = the_tree.GetBranch("e1MatchEmbeddedFilterEle35")
        #if not self.e1MatchEmbeddedFilterEle35_branch and "e1MatchEmbeddedFilterEle35" not in self.complained:
        if not self.e1MatchEmbeddedFilterEle35_branch and "e1MatchEmbeddedFilterEle35":
            warnings.warn( "EEETree: Expected branch e1MatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchEmbeddedFilterEle35")
        else:
            self.e1MatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.e1MatchEmbeddedFilterEle35_value)

        #print "making e1MatchesEle24HPSTau30Filter"
        self.e1MatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("e1MatchesEle24HPSTau30Filter")
        #if not self.e1MatchesEle24HPSTau30Filter_branch and "e1MatchesEle24HPSTau30Filter" not in self.complained:
        if not self.e1MatchesEle24HPSTau30Filter_branch and "e1MatchesEle24HPSTau30Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24HPSTau30Filter")
        else:
            self.e1MatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24HPSTau30Filter_value)

        #print "making e1MatchesEle24HPSTau30Path"
        self.e1MatchesEle24HPSTau30Path_branch = the_tree.GetBranch("e1MatchesEle24HPSTau30Path")
        #if not self.e1MatchesEle24HPSTau30Path_branch and "e1MatchesEle24HPSTau30Path" not in self.complained:
        if not self.e1MatchesEle24HPSTau30Path_branch and "e1MatchesEle24HPSTau30Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24HPSTau30Path")
        else:
            self.e1MatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24HPSTau30Path_value)

        #print "making e1MatchesEle24Tau30Filter"
        self.e1MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e1MatchesEle24Tau30Filter")
        #if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter" not in self.complained:
        if not self.e1MatchesEle24Tau30Filter_branch and "e1MatchesEle24Tau30Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Filter")
        else:
            self.e1MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Filter_value)

        #print "making e1MatchesEle24Tau30Path"
        self.e1MatchesEle24Tau30Path_branch = the_tree.GetBranch("e1MatchesEle24Tau30Path")
        #if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path" not in self.complained:
        if not self.e1MatchesEle24Tau30Path_branch and "e1MatchesEle24Tau30Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle24Tau30Path")
        else:
            self.e1MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e1MatchesEle24Tau30Path_value)

        #print "making e1MatchesEle25Filter"
        self.e1MatchesEle25Filter_branch = the_tree.GetBranch("e1MatchesEle25Filter")
        #if not self.e1MatchesEle25Filter_branch and "e1MatchesEle25Filter" not in self.complained:
        if not self.e1MatchesEle25Filter_branch and "e1MatchesEle25Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25Filter")
        else:
            self.e1MatchesEle25Filter_branch.SetAddress(<void*>&self.e1MatchesEle25Filter_value)

        #print "making e1MatchesEle25Path"
        self.e1MatchesEle25Path_branch = the_tree.GetBranch("e1MatchesEle25Path")
        #if not self.e1MatchesEle25Path_branch and "e1MatchesEle25Path" not in self.complained:
        if not self.e1MatchesEle25Path_branch and "e1MatchesEle25Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle25Path")
        else:
            self.e1MatchesEle25Path_branch.SetAddress(<void*>&self.e1MatchesEle25Path_value)

        #print "making e1MatchesEle27Filter"
        self.e1MatchesEle27Filter_branch = the_tree.GetBranch("e1MatchesEle27Filter")
        #if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter" not in self.complained:
        if not self.e1MatchesEle27Filter_branch and "e1MatchesEle27Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Filter")
        else:
            self.e1MatchesEle27Filter_branch.SetAddress(<void*>&self.e1MatchesEle27Filter_value)

        #print "making e1MatchesEle27Path"
        self.e1MatchesEle27Path_branch = the_tree.GetBranch("e1MatchesEle27Path")
        #if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path" not in self.complained:
        if not self.e1MatchesEle27Path_branch and "e1MatchesEle27Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle27Path")
        else:
            self.e1MatchesEle27Path_branch.SetAddress(<void*>&self.e1MatchesEle27Path_value)

        #print "making e1MatchesEle32Filter"
        self.e1MatchesEle32Filter_branch = the_tree.GetBranch("e1MatchesEle32Filter")
        #if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter" not in self.complained:
        if not self.e1MatchesEle32Filter_branch and "e1MatchesEle32Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Filter")
        else:
            self.e1MatchesEle32Filter_branch.SetAddress(<void*>&self.e1MatchesEle32Filter_value)

        #print "making e1MatchesEle32Path"
        self.e1MatchesEle32Path_branch = the_tree.GetBranch("e1MatchesEle32Path")
        #if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path" not in self.complained:
        if not self.e1MatchesEle32Path_branch and "e1MatchesEle32Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle32Path")
        else:
            self.e1MatchesEle32Path_branch.SetAddress(<void*>&self.e1MatchesEle32Path_value)

        #print "making e1MatchesEle35Filter"
        self.e1MatchesEle35Filter_branch = the_tree.GetBranch("e1MatchesEle35Filter")
        #if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter" not in self.complained:
        if not self.e1MatchesEle35Filter_branch and "e1MatchesEle35Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Filter")
        else:
            self.e1MatchesEle35Filter_branch.SetAddress(<void*>&self.e1MatchesEle35Filter_value)

        #print "making e1MatchesEle35Path"
        self.e1MatchesEle35Path_branch = the_tree.GetBranch("e1MatchesEle35Path")
        #if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path" not in self.complained:
        if not self.e1MatchesEle35Path_branch and "e1MatchesEle35Path":
            warnings.warn( "EEETree: Expected branch e1MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesEle35Path")
        else:
            self.e1MatchesEle35Path_branch.SetAddress(<void*>&self.e1MatchesEle35Path_value)

        #print "making e1MatchesMu23e12DZFilter"
        self.e1MatchesMu23e12DZFilter_branch = the_tree.GetBranch("e1MatchesMu23e12DZFilter")
        #if not self.e1MatchesMu23e12DZFilter_branch and "e1MatchesMu23e12DZFilter" not in self.complained:
        if not self.e1MatchesMu23e12DZFilter_branch and "e1MatchesMu23e12DZFilter":
            warnings.warn( "EEETree: Expected branch e1MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12DZFilter")
        else:
            self.e1MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu23e12DZFilter_value)

        #print "making e1MatchesMu23e12DZPath"
        self.e1MatchesMu23e12DZPath_branch = the_tree.GetBranch("e1MatchesMu23e12DZPath")
        #if not self.e1MatchesMu23e12DZPath_branch and "e1MatchesMu23e12DZPath" not in self.complained:
        if not self.e1MatchesMu23e12DZPath_branch and "e1MatchesMu23e12DZPath":
            warnings.warn( "EEETree: Expected branch e1MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12DZPath")
        else:
            self.e1MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.e1MatchesMu23e12DZPath_value)

        #print "making e1MatchesMu23e12Filter"
        self.e1MatchesMu23e12Filter_branch = the_tree.GetBranch("e1MatchesMu23e12Filter")
        #if not self.e1MatchesMu23e12Filter_branch and "e1MatchesMu23e12Filter" not in self.complained:
        if not self.e1MatchesMu23e12Filter_branch and "e1MatchesMu23e12Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12Filter")
        else:
            self.e1MatchesMu23e12Filter_branch.SetAddress(<void*>&self.e1MatchesMu23e12Filter_value)

        #print "making e1MatchesMu23e12Path"
        self.e1MatchesMu23e12Path_branch = the_tree.GetBranch("e1MatchesMu23e12Path")
        #if not self.e1MatchesMu23e12Path_branch and "e1MatchesMu23e12Path" not in self.complained:
        if not self.e1MatchesMu23e12Path_branch and "e1MatchesMu23e12Path":
            warnings.warn( "EEETree: Expected branch e1MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu23e12Path")
        else:
            self.e1MatchesMu23e12Path_branch.SetAddress(<void*>&self.e1MatchesMu23e12Path_value)

        #print "making e1MatchesMu8e23DZFilter"
        self.e1MatchesMu8e23DZFilter_branch = the_tree.GetBranch("e1MatchesMu8e23DZFilter")
        #if not self.e1MatchesMu8e23DZFilter_branch and "e1MatchesMu8e23DZFilter" not in self.complained:
        if not self.e1MatchesMu8e23DZFilter_branch and "e1MatchesMu8e23DZFilter":
            warnings.warn( "EEETree: Expected branch e1MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23DZFilter")
        else:
            self.e1MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.e1MatchesMu8e23DZFilter_value)

        #print "making e1MatchesMu8e23DZPath"
        self.e1MatchesMu8e23DZPath_branch = the_tree.GetBranch("e1MatchesMu8e23DZPath")
        #if not self.e1MatchesMu8e23DZPath_branch and "e1MatchesMu8e23DZPath" not in self.complained:
        if not self.e1MatchesMu8e23DZPath_branch and "e1MatchesMu8e23DZPath":
            warnings.warn( "EEETree: Expected branch e1MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23DZPath")
        else:
            self.e1MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.e1MatchesMu8e23DZPath_value)

        #print "making e1MatchesMu8e23Filter"
        self.e1MatchesMu8e23Filter_branch = the_tree.GetBranch("e1MatchesMu8e23Filter")
        #if not self.e1MatchesMu8e23Filter_branch and "e1MatchesMu8e23Filter" not in self.complained:
        if not self.e1MatchesMu8e23Filter_branch and "e1MatchesMu8e23Filter":
            warnings.warn( "EEETree: Expected branch e1MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23Filter")
        else:
            self.e1MatchesMu8e23Filter_branch.SetAddress(<void*>&self.e1MatchesMu8e23Filter_value)

        #print "making e1MatchesMu8e23Path"
        self.e1MatchesMu8e23Path_branch = the_tree.GetBranch("e1MatchesMu8e23Path")
        #if not self.e1MatchesMu8e23Path_branch and "e1MatchesMu8e23Path" not in self.complained:
        if not self.e1MatchesMu8e23Path_branch and "e1MatchesMu8e23Path":
            warnings.warn( "EEETree: Expected branch e1MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MatchesMu8e23Path")
        else:
            self.e1MatchesMu8e23Path_branch.SetAddress(<void*>&self.e1MatchesMu8e23Path_value)

        #print "making e1MissingHits"
        self.e1MissingHits_branch = the_tree.GetBranch("e1MissingHits")
        #if not self.e1MissingHits_branch and "e1MissingHits" not in self.complained:
        if not self.e1MissingHits_branch and "e1MissingHits":
            warnings.warn( "EEETree: Expected branch e1MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1MissingHits")
        else:
            self.e1MissingHits_branch.SetAddress(<void*>&self.e1MissingHits_value)

        #print "making e1NearMuonVeto"
        self.e1NearMuonVeto_branch = the_tree.GetBranch("e1NearMuonVeto")
        #if not self.e1NearMuonVeto_branch and "e1NearMuonVeto" not in self.complained:
        if not self.e1NearMuonVeto_branch and "e1NearMuonVeto":
            warnings.warn( "EEETree: Expected branch e1NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearMuonVeto")
        else:
            self.e1NearMuonVeto_branch.SetAddress(<void*>&self.e1NearMuonVeto_value)

        #print "making e1NearestMuonDR"
        self.e1NearestMuonDR_branch = the_tree.GetBranch("e1NearestMuonDR")
        #if not self.e1NearestMuonDR_branch and "e1NearestMuonDR" not in self.complained:
        if not self.e1NearestMuonDR_branch and "e1NearestMuonDR":
            warnings.warn( "EEETree: Expected branch e1NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestMuonDR")
        else:
            self.e1NearestMuonDR_branch.SetAddress(<void*>&self.e1NearestMuonDR_value)

        #print "making e1NearestZMass"
        self.e1NearestZMass_branch = the_tree.GetBranch("e1NearestZMass")
        #if not self.e1NearestZMass_branch and "e1NearestZMass" not in self.complained:
        if not self.e1NearestZMass_branch and "e1NearestZMass":
            warnings.warn( "EEETree: Expected branch e1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1NearestZMass")
        else:
            self.e1NearestZMass_branch.SetAddress(<void*>&self.e1NearestZMass_value)

        #print "making e1PFChargedIso"
        self.e1PFChargedIso_branch = the_tree.GetBranch("e1PFChargedIso")
        #if not self.e1PFChargedIso_branch and "e1PFChargedIso" not in self.complained:
        if not self.e1PFChargedIso_branch and "e1PFChargedIso":
            warnings.warn( "EEETree: Expected branch e1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFChargedIso")
        else:
            self.e1PFChargedIso_branch.SetAddress(<void*>&self.e1PFChargedIso_value)

        #print "making e1PFNeutralIso"
        self.e1PFNeutralIso_branch = the_tree.GetBranch("e1PFNeutralIso")
        #if not self.e1PFNeutralIso_branch and "e1PFNeutralIso" not in self.complained:
        if not self.e1PFNeutralIso_branch and "e1PFNeutralIso":
            warnings.warn( "EEETree: Expected branch e1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFNeutralIso")
        else:
            self.e1PFNeutralIso_branch.SetAddress(<void*>&self.e1PFNeutralIso_value)

        #print "making e1PFPUChargedIso"
        self.e1PFPUChargedIso_branch = the_tree.GetBranch("e1PFPUChargedIso")
        #if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso" not in self.complained:
        if not self.e1PFPUChargedIso_branch and "e1PFPUChargedIso":
            warnings.warn( "EEETree: Expected branch e1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPUChargedIso")
        else:
            self.e1PFPUChargedIso_branch.SetAddress(<void*>&self.e1PFPUChargedIso_value)

        #print "making e1PFPhotonIso"
        self.e1PFPhotonIso_branch = the_tree.GetBranch("e1PFPhotonIso")
        #if not self.e1PFPhotonIso_branch and "e1PFPhotonIso" not in self.complained:
        if not self.e1PFPhotonIso_branch and "e1PFPhotonIso":
            warnings.warn( "EEETree: Expected branch e1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PFPhotonIso")
        else:
            self.e1PFPhotonIso_branch.SetAddress(<void*>&self.e1PFPhotonIso_value)

        #print "making e1PVDXY"
        self.e1PVDXY_branch = the_tree.GetBranch("e1PVDXY")
        #if not self.e1PVDXY_branch and "e1PVDXY" not in self.complained:
        if not self.e1PVDXY_branch and "e1PVDXY":
            warnings.warn( "EEETree: Expected branch e1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDXY")
        else:
            self.e1PVDXY_branch.SetAddress(<void*>&self.e1PVDXY_value)

        #print "making e1PVDZ"
        self.e1PVDZ_branch = the_tree.GetBranch("e1PVDZ")
        #if not self.e1PVDZ_branch and "e1PVDZ" not in self.complained:
        if not self.e1PVDZ_branch and "e1PVDZ":
            warnings.warn( "EEETree: Expected branch e1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PVDZ")
        else:
            self.e1PVDZ_branch.SetAddress(<void*>&self.e1PVDZ_value)

        #print "making e1PassesConversionVeto"
        self.e1PassesConversionVeto_branch = the_tree.GetBranch("e1PassesConversionVeto")
        #if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto" not in self.complained:
        if not self.e1PassesConversionVeto_branch and "e1PassesConversionVeto":
            warnings.warn( "EEETree: Expected branch e1PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1PassesConversionVeto")
        else:
            self.e1PassesConversionVeto_branch.SetAddress(<void*>&self.e1PassesConversionVeto_value)

        #print "making e1Phi"
        self.e1Phi_branch = the_tree.GetBranch("e1Phi")
        #if not self.e1Phi_branch and "e1Phi" not in self.complained:
        if not self.e1Phi_branch and "e1Phi":
            warnings.warn( "EEETree: Expected branch e1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Phi")
        else:
            self.e1Phi_branch.SetAddress(<void*>&self.e1Phi_value)

        #print "making e1Pt"
        self.e1Pt_branch = the_tree.GetBranch("e1Pt")
        #if not self.e1Pt_branch and "e1Pt" not in self.complained:
        if not self.e1Pt_branch and "e1Pt":
            warnings.warn( "EEETree: Expected branch e1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Pt")
        else:
            self.e1Pt_branch.SetAddress(<void*>&self.e1Pt_value)

        #print "making e1RelIso"
        self.e1RelIso_branch = the_tree.GetBranch("e1RelIso")
        #if not self.e1RelIso_branch and "e1RelIso" not in self.complained:
        if not self.e1RelIso_branch and "e1RelIso":
            warnings.warn( "EEETree: Expected branch e1RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelIso")
        else:
            self.e1RelIso_branch.SetAddress(<void*>&self.e1RelIso_value)

        #print "making e1RelPFIsoDB"
        self.e1RelPFIsoDB_branch = the_tree.GetBranch("e1RelPFIsoDB")
        #if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB" not in self.complained:
        if not self.e1RelPFIsoDB_branch and "e1RelPFIsoDB":
            warnings.warn( "EEETree: Expected branch e1RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoDB")
        else:
            self.e1RelPFIsoDB_branch.SetAddress(<void*>&self.e1RelPFIsoDB_value)

        #print "making e1RelPFIsoRho"
        self.e1RelPFIsoRho_branch = the_tree.GetBranch("e1RelPFIsoRho")
        #if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho" not in self.complained:
        if not self.e1RelPFIsoRho_branch and "e1RelPFIsoRho":
            warnings.warn( "EEETree: Expected branch e1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1RelPFIsoRho")
        else:
            self.e1RelPFIsoRho_branch.SetAddress(<void*>&self.e1RelPFIsoRho_value)

        #print "making e1Rho"
        self.e1Rho_branch = the_tree.GetBranch("e1Rho")
        #if not self.e1Rho_branch and "e1Rho" not in self.complained:
        if not self.e1Rho_branch and "e1Rho":
            warnings.warn( "EEETree: Expected branch e1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1Rho")
        else:
            self.e1Rho_branch.SetAddress(<void*>&self.e1Rho_value)

        #print "making e1SIP2D"
        self.e1SIP2D_branch = the_tree.GetBranch("e1SIP2D")
        #if not self.e1SIP2D_branch and "e1SIP2D" not in self.complained:
        if not self.e1SIP2D_branch and "e1SIP2D":
            warnings.warn( "EEETree: Expected branch e1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP2D")
        else:
            self.e1SIP2D_branch.SetAddress(<void*>&self.e1SIP2D_value)

        #print "making e1SIP3D"
        self.e1SIP3D_branch = the_tree.GetBranch("e1SIP3D")
        #if not self.e1SIP3D_branch and "e1SIP3D" not in self.complained:
        if not self.e1SIP3D_branch and "e1SIP3D":
            warnings.warn( "EEETree: Expected branch e1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1SIP3D")
        else:
            self.e1SIP3D_branch.SetAddress(<void*>&self.e1SIP3D_value)

        #print "making e1TrkIsoDR03"
        self.e1TrkIsoDR03_branch = the_tree.GetBranch("e1TrkIsoDR03")
        #if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03" not in self.complained:
        if not self.e1TrkIsoDR03_branch and "e1TrkIsoDR03":
            warnings.warn( "EEETree: Expected branch e1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1TrkIsoDR03")
        else:
            self.e1TrkIsoDR03_branch.SetAddress(<void*>&self.e1TrkIsoDR03_value)

        #print "making e1VZ"
        self.e1VZ_branch = the_tree.GetBranch("e1VZ")
        #if not self.e1VZ_branch and "e1VZ" not in self.complained:
        if not self.e1VZ_branch and "e1VZ":
            warnings.warn( "EEETree: Expected branch e1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1VZ")
        else:
            self.e1VZ_branch.SetAddress(<void*>&self.e1VZ_value)

        #print "making e1ZTTGenMatching"
        self.e1ZTTGenMatching_branch = the_tree.GetBranch("e1ZTTGenMatching")
        #if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching" not in self.complained:
        if not self.e1ZTTGenMatching_branch and "e1ZTTGenMatching":
            warnings.warn( "EEETree: Expected branch e1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ZTTGenMatching")
        else:
            self.e1ZTTGenMatching_branch.SetAddress(<void*>&self.e1ZTTGenMatching_value)

        #print "making e1_e2_DR"
        self.e1_e2_DR_branch = the_tree.GetBranch("e1_e2_DR")
        #if not self.e1_e2_DR_branch and "e1_e2_DR" not in self.complained:
        if not self.e1_e2_DR_branch and "e1_e2_DR":
            warnings.warn( "EEETree: Expected branch e1_e2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_DR")
        else:
            self.e1_e2_DR_branch.SetAddress(<void*>&self.e1_e2_DR_value)

        #print "making e1_e2_Mass"
        self.e1_e2_Mass_branch = the_tree.GetBranch("e1_e2_Mass")
        #if not self.e1_e2_Mass_branch and "e1_e2_Mass" not in self.complained:
        if not self.e1_e2_Mass_branch and "e1_e2_Mass":
            warnings.warn( "EEETree: Expected branch e1_e2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_Mass")
        else:
            self.e1_e2_Mass_branch.SetAddress(<void*>&self.e1_e2_Mass_value)

        #print "making e1_e2_PZeta"
        self.e1_e2_PZeta_branch = the_tree.GetBranch("e1_e2_PZeta")
        #if not self.e1_e2_PZeta_branch and "e1_e2_PZeta" not in self.complained:
        if not self.e1_e2_PZeta_branch and "e1_e2_PZeta":
            warnings.warn( "EEETree: Expected branch e1_e2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZeta")
        else:
            self.e1_e2_PZeta_branch.SetAddress(<void*>&self.e1_e2_PZeta_value)

        #print "making e1_e2_PZetaVis"
        self.e1_e2_PZetaVis_branch = the_tree.GetBranch("e1_e2_PZetaVis")
        #if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis" not in self.complained:
        if not self.e1_e2_PZetaVis_branch and "e1_e2_PZetaVis":
            warnings.warn( "EEETree: Expected branch e1_e2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_PZetaVis")
        else:
            self.e1_e2_PZetaVis_branch.SetAddress(<void*>&self.e1_e2_PZetaVis_value)

        #print "making e1_e2_doubleL1IsoTauMatch"
        self.e1_e2_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e1_e2_doubleL1IsoTauMatch")
        #if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch" not in self.complained:
        if not self.e1_e2_doubleL1IsoTauMatch_branch and "e1_e2_doubleL1IsoTauMatch":
            warnings.warn( "EEETree: Expected branch e1_e2_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e2_doubleL1IsoTauMatch")
        else:
            self.e1_e2_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e1_e2_doubleL1IsoTauMatch_value)

        #print "making e1_e3_DR"
        self.e1_e3_DR_branch = the_tree.GetBranch("e1_e3_DR")
        #if not self.e1_e3_DR_branch and "e1_e3_DR" not in self.complained:
        if not self.e1_e3_DR_branch and "e1_e3_DR":
            warnings.warn( "EEETree: Expected branch e1_e3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_DR")
        else:
            self.e1_e3_DR_branch.SetAddress(<void*>&self.e1_e3_DR_value)

        #print "making e1_e3_Mass"
        self.e1_e3_Mass_branch = the_tree.GetBranch("e1_e3_Mass")
        #if not self.e1_e3_Mass_branch and "e1_e3_Mass" not in self.complained:
        if not self.e1_e3_Mass_branch and "e1_e3_Mass":
            warnings.warn( "EEETree: Expected branch e1_e3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_Mass")
        else:
            self.e1_e3_Mass_branch.SetAddress(<void*>&self.e1_e3_Mass_value)

        #print "making e1_e3_PZeta"
        self.e1_e3_PZeta_branch = the_tree.GetBranch("e1_e3_PZeta")
        #if not self.e1_e3_PZeta_branch and "e1_e3_PZeta" not in self.complained:
        if not self.e1_e3_PZeta_branch and "e1_e3_PZeta":
            warnings.warn( "EEETree: Expected branch e1_e3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_PZeta")
        else:
            self.e1_e3_PZeta_branch.SetAddress(<void*>&self.e1_e3_PZeta_value)

        #print "making e1_e3_PZetaVis"
        self.e1_e3_PZetaVis_branch = the_tree.GetBranch("e1_e3_PZetaVis")
        #if not self.e1_e3_PZetaVis_branch and "e1_e3_PZetaVis" not in self.complained:
        if not self.e1_e3_PZetaVis_branch and "e1_e3_PZetaVis":
            warnings.warn( "EEETree: Expected branch e1_e3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_PZetaVis")
        else:
            self.e1_e3_PZetaVis_branch.SetAddress(<void*>&self.e1_e3_PZetaVis_value)

        #print "making e1_e3_doubleL1IsoTauMatch"
        self.e1_e3_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e1_e3_doubleL1IsoTauMatch")
        #if not self.e1_e3_doubleL1IsoTauMatch_branch and "e1_e3_doubleL1IsoTauMatch" not in self.complained:
        if not self.e1_e3_doubleL1IsoTauMatch_branch and "e1_e3_doubleL1IsoTauMatch":
            warnings.warn( "EEETree: Expected branch e1_e3_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1_e3_doubleL1IsoTauMatch")
        else:
            self.e1_e3_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e1_e3_doubleL1IsoTauMatch_value)

        #print "making e1ecalEnergy"
        self.e1ecalEnergy_branch = the_tree.GetBranch("e1ecalEnergy")
        #if not self.e1ecalEnergy_branch and "e1ecalEnergy" not in self.complained:
        if not self.e1ecalEnergy_branch and "e1ecalEnergy":
            warnings.warn( "EEETree: Expected branch e1ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e1ecalEnergy")
        else:
            self.e1ecalEnergy_branch.SetAddress(<void*>&self.e1ecalEnergy_value)

        #print "making e2Charge"
        self.e2Charge_branch = the_tree.GetBranch("e2Charge")
        #if not self.e2Charge_branch and "e2Charge" not in self.complained:
        if not self.e2Charge_branch and "e2Charge":
            warnings.warn( "EEETree: Expected branch e2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Charge")
        else:
            self.e2Charge_branch.SetAddress(<void*>&self.e2Charge_value)

        #print "making e2ChargeIdLoose"
        self.e2ChargeIdLoose_branch = the_tree.GetBranch("e2ChargeIdLoose")
        #if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose" not in self.complained:
        if not self.e2ChargeIdLoose_branch and "e2ChargeIdLoose":
            warnings.warn( "EEETree: Expected branch e2ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdLoose")
        else:
            self.e2ChargeIdLoose_branch.SetAddress(<void*>&self.e2ChargeIdLoose_value)

        #print "making e2ChargeIdMed"
        self.e2ChargeIdMed_branch = the_tree.GetBranch("e2ChargeIdMed")
        #if not self.e2ChargeIdMed_branch and "e2ChargeIdMed" not in self.complained:
        if not self.e2ChargeIdMed_branch and "e2ChargeIdMed":
            warnings.warn( "EEETree: Expected branch e2ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdMed")
        else:
            self.e2ChargeIdMed_branch.SetAddress(<void*>&self.e2ChargeIdMed_value)

        #print "making e2ChargeIdTight"
        self.e2ChargeIdTight_branch = the_tree.GetBranch("e2ChargeIdTight")
        #if not self.e2ChargeIdTight_branch and "e2ChargeIdTight" not in self.complained:
        if not self.e2ChargeIdTight_branch and "e2ChargeIdTight":
            warnings.warn( "EEETree: Expected branch e2ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ChargeIdTight")
        else:
            self.e2ChargeIdTight_branch.SetAddress(<void*>&self.e2ChargeIdTight_value)

        #print "making e2ComesFromHiggs"
        self.e2ComesFromHiggs_branch = the_tree.GetBranch("e2ComesFromHiggs")
        #if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs" not in self.complained:
        if not self.e2ComesFromHiggs_branch and "e2ComesFromHiggs":
            warnings.warn( "EEETree: Expected branch e2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ComesFromHiggs")
        else:
            self.e2ComesFromHiggs_branch.SetAddress(<void*>&self.e2ComesFromHiggs_value)

        #print "making e2CorrectedEt"
        self.e2CorrectedEt_branch = the_tree.GetBranch("e2CorrectedEt")
        #if not self.e2CorrectedEt_branch and "e2CorrectedEt" not in self.complained:
        if not self.e2CorrectedEt_branch and "e2CorrectedEt":
            warnings.warn( "EEETree: Expected branch e2CorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2CorrectedEt")
        else:
            self.e2CorrectedEt_branch.SetAddress(<void*>&self.e2CorrectedEt_value)

        #print "making e2EcalIsoDR03"
        self.e2EcalIsoDR03_branch = the_tree.GetBranch("e2EcalIsoDR03")
        #if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03" not in self.complained:
        if not self.e2EcalIsoDR03_branch and "e2EcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EcalIsoDR03")
        else:
            self.e2EcalIsoDR03_branch.SetAddress(<void*>&self.e2EcalIsoDR03_value)

        #print "making e2EnergyError"
        self.e2EnergyError_branch = the_tree.GetBranch("e2EnergyError")
        #if not self.e2EnergyError_branch and "e2EnergyError" not in self.complained:
        if not self.e2EnergyError_branch and "e2EnergyError":
            warnings.warn( "EEETree: Expected branch e2EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyError")
        else:
            self.e2EnergyError_branch.SetAddress(<void*>&self.e2EnergyError_value)

        #print "making e2EnergyScaleDown"
        self.e2EnergyScaleDown_branch = the_tree.GetBranch("e2EnergyScaleDown")
        #if not self.e2EnergyScaleDown_branch and "e2EnergyScaleDown" not in self.complained:
        if not self.e2EnergyScaleDown_branch and "e2EnergyScaleDown":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleDown")
        else:
            self.e2EnergyScaleDown_branch.SetAddress(<void*>&self.e2EnergyScaleDown_value)

        #print "making e2EnergyScaleGainDown"
        self.e2EnergyScaleGainDown_branch = the_tree.GetBranch("e2EnergyScaleGainDown")
        #if not self.e2EnergyScaleGainDown_branch and "e2EnergyScaleGainDown" not in self.complained:
        if not self.e2EnergyScaleGainDown_branch and "e2EnergyScaleGainDown":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleGainDown")
        else:
            self.e2EnergyScaleGainDown_branch.SetAddress(<void*>&self.e2EnergyScaleGainDown_value)

        #print "making e2EnergyScaleGainUp"
        self.e2EnergyScaleGainUp_branch = the_tree.GetBranch("e2EnergyScaleGainUp")
        #if not self.e2EnergyScaleGainUp_branch and "e2EnergyScaleGainUp" not in self.complained:
        if not self.e2EnergyScaleGainUp_branch and "e2EnergyScaleGainUp":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleGainUp")
        else:
            self.e2EnergyScaleGainUp_branch.SetAddress(<void*>&self.e2EnergyScaleGainUp_value)

        #print "making e2EnergyScaleStatDown"
        self.e2EnergyScaleStatDown_branch = the_tree.GetBranch("e2EnergyScaleStatDown")
        #if not self.e2EnergyScaleStatDown_branch and "e2EnergyScaleStatDown" not in self.complained:
        if not self.e2EnergyScaleStatDown_branch and "e2EnergyScaleStatDown":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleStatDown")
        else:
            self.e2EnergyScaleStatDown_branch.SetAddress(<void*>&self.e2EnergyScaleStatDown_value)

        #print "making e2EnergyScaleStatUp"
        self.e2EnergyScaleStatUp_branch = the_tree.GetBranch("e2EnergyScaleStatUp")
        #if not self.e2EnergyScaleStatUp_branch and "e2EnergyScaleStatUp" not in self.complained:
        if not self.e2EnergyScaleStatUp_branch and "e2EnergyScaleStatUp":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleStatUp")
        else:
            self.e2EnergyScaleStatUp_branch.SetAddress(<void*>&self.e2EnergyScaleStatUp_value)

        #print "making e2EnergyScaleSystDown"
        self.e2EnergyScaleSystDown_branch = the_tree.GetBranch("e2EnergyScaleSystDown")
        #if not self.e2EnergyScaleSystDown_branch and "e2EnergyScaleSystDown" not in self.complained:
        if not self.e2EnergyScaleSystDown_branch and "e2EnergyScaleSystDown":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleSystDown")
        else:
            self.e2EnergyScaleSystDown_branch.SetAddress(<void*>&self.e2EnergyScaleSystDown_value)

        #print "making e2EnergyScaleSystUp"
        self.e2EnergyScaleSystUp_branch = the_tree.GetBranch("e2EnergyScaleSystUp")
        #if not self.e2EnergyScaleSystUp_branch and "e2EnergyScaleSystUp" not in self.complained:
        if not self.e2EnergyScaleSystUp_branch and "e2EnergyScaleSystUp":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleSystUp")
        else:
            self.e2EnergyScaleSystUp_branch.SetAddress(<void*>&self.e2EnergyScaleSystUp_value)

        #print "making e2EnergyScaleUp"
        self.e2EnergyScaleUp_branch = the_tree.GetBranch("e2EnergyScaleUp")
        #if not self.e2EnergyScaleUp_branch and "e2EnergyScaleUp" not in self.complained:
        if not self.e2EnergyScaleUp_branch and "e2EnergyScaleUp":
            warnings.warn( "EEETree: Expected branch e2EnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergyScaleUp")
        else:
            self.e2EnergyScaleUp_branch.SetAddress(<void*>&self.e2EnergyScaleUp_value)

        #print "making e2EnergySigmaDown"
        self.e2EnergySigmaDown_branch = the_tree.GetBranch("e2EnergySigmaDown")
        #if not self.e2EnergySigmaDown_branch and "e2EnergySigmaDown" not in self.complained:
        if not self.e2EnergySigmaDown_branch and "e2EnergySigmaDown":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaDown")
        else:
            self.e2EnergySigmaDown_branch.SetAddress(<void*>&self.e2EnergySigmaDown_value)

        #print "making e2EnergySigmaPhiDown"
        self.e2EnergySigmaPhiDown_branch = the_tree.GetBranch("e2EnergySigmaPhiDown")
        #if not self.e2EnergySigmaPhiDown_branch and "e2EnergySigmaPhiDown" not in self.complained:
        if not self.e2EnergySigmaPhiDown_branch and "e2EnergySigmaPhiDown":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaPhiDown")
        else:
            self.e2EnergySigmaPhiDown_branch.SetAddress(<void*>&self.e2EnergySigmaPhiDown_value)

        #print "making e2EnergySigmaPhiUp"
        self.e2EnergySigmaPhiUp_branch = the_tree.GetBranch("e2EnergySigmaPhiUp")
        #if not self.e2EnergySigmaPhiUp_branch and "e2EnergySigmaPhiUp" not in self.complained:
        if not self.e2EnergySigmaPhiUp_branch and "e2EnergySigmaPhiUp":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaPhiUp")
        else:
            self.e2EnergySigmaPhiUp_branch.SetAddress(<void*>&self.e2EnergySigmaPhiUp_value)

        #print "making e2EnergySigmaRhoDown"
        self.e2EnergySigmaRhoDown_branch = the_tree.GetBranch("e2EnergySigmaRhoDown")
        #if not self.e2EnergySigmaRhoDown_branch and "e2EnergySigmaRhoDown" not in self.complained:
        if not self.e2EnergySigmaRhoDown_branch and "e2EnergySigmaRhoDown":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaRhoDown")
        else:
            self.e2EnergySigmaRhoDown_branch.SetAddress(<void*>&self.e2EnergySigmaRhoDown_value)

        #print "making e2EnergySigmaRhoUp"
        self.e2EnergySigmaRhoUp_branch = the_tree.GetBranch("e2EnergySigmaRhoUp")
        #if not self.e2EnergySigmaRhoUp_branch and "e2EnergySigmaRhoUp" not in self.complained:
        if not self.e2EnergySigmaRhoUp_branch and "e2EnergySigmaRhoUp":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaRhoUp")
        else:
            self.e2EnergySigmaRhoUp_branch.SetAddress(<void*>&self.e2EnergySigmaRhoUp_value)

        #print "making e2EnergySigmaUp"
        self.e2EnergySigmaUp_branch = the_tree.GetBranch("e2EnergySigmaUp")
        #if not self.e2EnergySigmaUp_branch and "e2EnergySigmaUp" not in self.complained:
        if not self.e2EnergySigmaUp_branch and "e2EnergySigmaUp":
            warnings.warn( "EEETree: Expected branch e2EnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2EnergySigmaUp")
        else:
            self.e2EnergySigmaUp_branch.SetAddress(<void*>&self.e2EnergySigmaUp_value)

        #print "making e2Eta"
        self.e2Eta_branch = the_tree.GetBranch("e2Eta")
        #if not self.e2Eta_branch and "e2Eta" not in self.complained:
        if not self.e2Eta_branch and "e2Eta":
            warnings.warn( "EEETree: Expected branch e2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Eta")
        else:
            self.e2Eta_branch.SetAddress(<void*>&self.e2Eta_value)

        #print "making e2GenCharge"
        self.e2GenCharge_branch = the_tree.GetBranch("e2GenCharge")
        #if not self.e2GenCharge_branch and "e2GenCharge" not in self.complained:
        if not self.e2GenCharge_branch and "e2GenCharge":
            warnings.warn( "EEETree: Expected branch e2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenCharge")
        else:
            self.e2GenCharge_branch.SetAddress(<void*>&self.e2GenCharge_value)

        #print "making e2GenDirectPromptTauDecay"
        self.e2GenDirectPromptTauDecay_branch = the_tree.GetBranch("e2GenDirectPromptTauDecay")
        #if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay" not in self.complained:
        if not self.e2GenDirectPromptTauDecay_branch and "e2GenDirectPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e2GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenDirectPromptTauDecay")
        else:
            self.e2GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e2GenDirectPromptTauDecay_value)

        #print "making e2GenEnergy"
        self.e2GenEnergy_branch = the_tree.GetBranch("e2GenEnergy")
        #if not self.e2GenEnergy_branch and "e2GenEnergy" not in self.complained:
        if not self.e2GenEnergy_branch and "e2GenEnergy":
            warnings.warn( "EEETree: Expected branch e2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEnergy")
        else:
            self.e2GenEnergy_branch.SetAddress(<void*>&self.e2GenEnergy_value)

        #print "making e2GenEta"
        self.e2GenEta_branch = the_tree.GetBranch("e2GenEta")
        #if not self.e2GenEta_branch and "e2GenEta" not in self.complained:
        if not self.e2GenEta_branch and "e2GenEta":
            warnings.warn( "EEETree: Expected branch e2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenEta")
        else:
            self.e2GenEta_branch.SetAddress(<void*>&self.e2GenEta_value)

        #print "making e2GenIsPrompt"
        self.e2GenIsPrompt_branch = the_tree.GetBranch("e2GenIsPrompt")
        #if not self.e2GenIsPrompt_branch and "e2GenIsPrompt" not in self.complained:
        if not self.e2GenIsPrompt_branch and "e2GenIsPrompt":
            warnings.warn( "EEETree: Expected branch e2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenIsPrompt")
        else:
            self.e2GenIsPrompt_branch.SetAddress(<void*>&self.e2GenIsPrompt_value)

        #print "making e2GenMotherPdgId"
        self.e2GenMotherPdgId_branch = the_tree.GetBranch("e2GenMotherPdgId")
        #if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId" not in self.complained:
        if not self.e2GenMotherPdgId_branch and "e2GenMotherPdgId":
            warnings.warn( "EEETree: Expected branch e2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenMotherPdgId")
        else:
            self.e2GenMotherPdgId_branch.SetAddress(<void*>&self.e2GenMotherPdgId_value)

        #print "making e2GenParticle"
        self.e2GenParticle_branch = the_tree.GetBranch("e2GenParticle")
        #if not self.e2GenParticle_branch and "e2GenParticle" not in self.complained:
        if not self.e2GenParticle_branch and "e2GenParticle":
            warnings.warn( "EEETree: Expected branch e2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenParticle")
        else:
            self.e2GenParticle_branch.SetAddress(<void*>&self.e2GenParticle_value)

        #print "making e2GenPdgId"
        self.e2GenPdgId_branch = the_tree.GetBranch("e2GenPdgId")
        #if not self.e2GenPdgId_branch and "e2GenPdgId" not in self.complained:
        if not self.e2GenPdgId_branch and "e2GenPdgId":
            warnings.warn( "EEETree: Expected branch e2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPdgId")
        else:
            self.e2GenPdgId_branch.SetAddress(<void*>&self.e2GenPdgId_value)

        #print "making e2GenPhi"
        self.e2GenPhi_branch = the_tree.GetBranch("e2GenPhi")
        #if not self.e2GenPhi_branch and "e2GenPhi" not in self.complained:
        if not self.e2GenPhi_branch and "e2GenPhi":
            warnings.warn( "EEETree: Expected branch e2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPhi")
        else:
            self.e2GenPhi_branch.SetAddress(<void*>&self.e2GenPhi_value)

        #print "making e2GenPrompt"
        self.e2GenPrompt_branch = the_tree.GetBranch("e2GenPrompt")
        #if not self.e2GenPrompt_branch and "e2GenPrompt" not in self.complained:
        if not self.e2GenPrompt_branch and "e2GenPrompt":
            warnings.warn( "EEETree: Expected branch e2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPrompt")
        else:
            self.e2GenPrompt_branch.SetAddress(<void*>&self.e2GenPrompt_value)

        #print "making e2GenPromptTauDecay"
        self.e2GenPromptTauDecay_branch = the_tree.GetBranch("e2GenPromptTauDecay")
        #if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay" not in self.complained:
        if not self.e2GenPromptTauDecay_branch and "e2GenPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPromptTauDecay")
        else:
            self.e2GenPromptTauDecay_branch.SetAddress(<void*>&self.e2GenPromptTauDecay_value)

        #print "making e2GenPt"
        self.e2GenPt_branch = the_tree.GetBranch("e2GenPt")
        #if not self.e2GenPt_branch and "e2GenPt" not in self.complained:
        if not self.e2GenPt_branch and "e2GenPt":
            warnings.warn( "EEETree: Expected branch e2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenPt")
        else:
            self.e2GenPt_branch.SetAddress(<void*>&self.e2GenPt_value)

        #print "making e2GenTauDecay"
        self.e2GenTauDecay_branch = the_tree.GetBranch("e2GenTauDecay")
        #if not self.e2GenTauDecay_branch and "e2GenTauDecay" not in self.complained:
        if not self.e2GenTauDecay_branch and "e2GenTauDecay":
            warnings.warn( "EEETree: Expected branch e2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenTauDecay")
        else:
            self.e2GenTauDecay_branch.SetAddress(<void*>&self.e2GenTauDecay_value)

        #print "making e2GenVZ"
        self.e2GenVZ_branch = the_tree.GetBranch("e2GenVZ")
        #if not self.e2GenVZ_branch and "e2GenVZ" not in self.complained:
        if not self.e2GenVZ_branch and "e2GenVZ":
            warnings.warn( "EEETree: Expected branch e2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVZ")
        else:
            self.e2GenVZ_branch.SetAddress(<void*>&self.e2GenVZ_value)

        #print "making e2GenVtxPVMatch"
        self.e2GenVtxPVMatch_branch = the_tree.GetBranch("e2GenVtxPVMatch")
        #if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch" not in self.complained:
        if not self.e2GenVtxPVMatch_branch and "e2GenVtxPVMatch":
            warnings.warn( "EEETree: Expected branch e2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2GenVtxPVMatch")
        else:
            self.e2GenVtxPVMatch_branch.SetAddress(<void*>&self.e2GenVtxPVMatch_value)

        #print "making e2HcalIsoDR03"
        self.e2HcalIsoDR03_branch = the_tree.GetBranch("e2HcalIsoDR03")
        #if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03" not in self.complained:
        if not self.e2HcalIsoDR03_branch and "e2HcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2HcalIsoDR03")
        else:
            self.e2HcalIsoDR03_branch.SetAddress(<void*>&self.e2HcalIsoDR03_value)

        #print "making e2IP3D"
        self.e2IP3D_branch = the_tree.GetBranch("e2IP3D")
        #if not self.e2IP3D_branch and "e2IP3D" not in self.complained:
        if not self.e2IP3D_branch and "e2IP3D":
            warnings.warn( "EEETree: Expected branch e2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3D")
        else:
            self.e2IP3D_branch.SetAddress(<void*>&self.e2IP3D_value)

        #print "making e2IP3DErr"
        self.e2IP3DErr_branch = the_tree.GetBranch("e2IP3DErr")
        #if not self.e2IP3DErr_branch and "e2IP3DErr" not in self.complained:
        if not self.e2IP3DErr_branch and "e2IP3DErr":
            warnings.warn( "EEETree: Expected branch e2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IP3DErr")
        else:
            self.e2IP3DErr_branch.SetAddress(<void*>&self.e2IP3DErr_value)

        #print "making e2IsoDB03"
        self.e2IsoDB03_branch = the_tree.GetBranch("e2IsoDB03")
        #if not self.e2IsoDB03_branch and "e2IsoDB03" not in self.complained:
        if not self.e2IsoDB03_branch and "e2IsoDB03":
            warnings.warn( "EEETree: Expected branch e2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2IsoDB03")
        else:
            self.e2IsoDB03_branch.SetAddress(<void*>&self.e2IsoDB03_value)

        #print "making e2JetArea"
        self.e2JetArea_branch = the_tree.GetBranch("e2JetArea")
        #if not self.e2JetArea_branch and "e2JetArea" not in self.complained:
        if not self.e2JetArea_branch and "e2JetArea":
            warnings.warn( "EEETree: Expected branch e2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetArea")
        else:
            self.e2JetArea_branch.SetAddress(<void*>&self.e2JetArea_value)

        #print "making e2JetBtag"
        self.e2JetBtag_branch = the_tree.GetBranch("e2JetBtag")
        #if not self.e2JetBtag_branch and "e2JetBtag" not in self.complained:
        if not self.e2JetBtag_branch and "e2JetBtag":
            warnings.warn( "EEETree: Expected branch e2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetBtag")
        else:
            self.e2JetBtag_branch.SetAddress(<void*>&self.e2JetBtag_value)

        #print "making e2JetDR"
        self.e2JetDR_branch = the_tree.GetBranch("e2JetDR")
        #if not self.e2JetDR_branch and "e2JetDR" not in self.complained:
        if not self.e2JetDR_branch and "e2JetDR":
            warnings.warn( "EEETree: Expected branch e2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetDR")
        else:
            self.e2JetDR_branch.SetAddress(<void*>&self.e2JetDR_value)

        #print "making e2JetEtaEtaMoment"
        self.e2JetEtaEtaMoment_branch = the_tree.GetBranch("e2JetEtaEtaMoment")
        #if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment" not in self.complained:
        if not self.e2JetEtaEtaMoment_branch and "e2JetEtaEtaMoment":
            warnings.warn( "EEETree: Expected branch e2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaEtaMoment")
        else:
            self.e2JetEtaEtaMoment_branch.SetAddress(<void*>&self.e2JetEtaEtaMoment_value)

        #print "making e2JetEtaPhiMoment"
        self.e2JetEtaPhiMoment_branch = the_tree.GetBranch("e2JetEtaPhiMoment")
        #if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment" not in self.complained:
        if not self.e2JetEtaPhiMoment_branch and "e2JetEtaPhiMoment":
            warnings.warn( "EEETree: Expected branch e2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiMoment")
        else:
            self.e2JetEtaPhiMoment_branch.SetAddress(<void*>&self.e2JetEtaPhiMoment_value)

        #print "making e2JetEtaPhiSpread"
        self.e2JetEtaPhiSpread_branch = the_tree.GetBranch("e2JetEtaPhiSpread")
        #if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread" not in self.complained:
        if not self.e2JetEtaPhiSpread_branch and "e2JetEtaPhiSpread":
            warnings.warn( "EEETree: Expected branch e2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetEtaPhiSpread")
        else:
            self.e2JetEtaPhiSpread_branch.SetAddress(<void*>&self.e2JetEtaPhiSpread_value)

        #print "making e2JetHadronFlavour"
        self.e2JetHadronFlavour_branch = the_tree.GetBranch("e2JetHadronFlavour")
        #if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour" not in self.complained:
        if not self.e2JetHadronFlavour_branch and "e2JetHadronFlavour":
            warnings.warn( "EEETree: Expected branch e2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetHadronFlavour")
        else:
            self.e2JetHadronFlavour_branch.SetAddress(<void*>&self.e2JetHadronFlavour_value)

        #print "making e2JetPFCISVBtag"
        self.e2JetPFCISVBtag_branch = the_tree.GetBranch("e2JetPFCISVBtag")
        #if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag" not in self.complained:
        if not self.e2JetPFCISVBtag_branch and "e2JetPFCISVBtag":
            warnings.warn( "EEETree: Expected branch e2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPFCISVBtag")
        else:
            self.e2JetPFCISVBtag_branch.SetAddress(<void*>&self.e2JetPFCISVBtag_value)

        #print "making e2JetPartonFlavour"
        self.e2JetPartonFlavour_branch = the_tree.GetBranch("e2JetPartonFlavour")
        #if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour" not in self.complained:
        if not self.e2JetPartonFlavour_branch and "e2JetPartonFlavour":
            warnings.warn( "EEETree: Expected branch e2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPartonFlavour")
        else:
            self.e2JetPartonFlavour_branch.SetAddress(<void*>&self.e2JetPartonFlavour_value)

        #print "making e2JetPhiPhiMoment"
        self.e2JetPhiPhiMoment_branch = the_tree.GetBranch("e2JetPhiPhiMoment")
        #if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment" not in self.complained:
        if not self.e2JetPhiPhiMoment_branch and "e2JetPhiPhiMoment":
            warnings.warn( "EEETree: Expected branch e2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPhiPhiMoment")
        else:
            self.e2JetPhiPhiMoment_branch.SetAddress(<void*>&self.e2JetPhiPhiMoment_value)

        #print "making e2JetPt"
        self.e2JetPt_branch = the_tree.GetBranch("e2JetPt")
        #if not self.e2JetPt_branch and "e2JetPt" not in self.complained:
        if not self.e2JetPt_branch and "e2JetPt":
            warnings.warn( "EEETree: Expected branch e2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2JetPt")
        else:
            self.e2JetPt_branch.SetAddress(<void*>&self.e2JetPt_value)

        #print "making e2LowestMll"
        self.e2LowestMll_branch = the_tree.GetBranch("e2LowestMll")
        #if not self.e2LowestMll_branch and "e2LowestMll" not in self.complained:
        if not self.e2LowestMll_branch and "e2LowestMll":
            warnings.warn( "EEETree: Expected branch e2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2LowestMll")
        else:
            self.e2LowestMll_branch.SetAddress(<void*>&self.e2LowestMll_value)

        #print "making e2MVAIsoWP80"
        self.e2MVAIsoWP80_branch = the_tree.GetBranch("e2MVAIsoWP80")
        #if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80" not in self.complained:
        if not self.e2MVAIsoWP80_branch and "e2MVAIsoWP80":
            warnings.warn( "EEETree: Expected branch e2MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP80")
        else:
            self.e2MVAIsoWP80_branch.SetAddress(<void*>&self.e2MVAIsoWP80_value)

        #print "making e2MVAIsoWP90"
        self.e2MVAIsoWP90_branch = the_tree.GetBranch("e2MVAIsoWP90")
        #if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90" not in self.complained:
        if not self.e2MVAIsoWP90_branch and "e2MVAIsoWP90":
            warnings.warn( "EEETree: Expected branch e2MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVAIsoWP90")
        else:
            self.e2MVAIsoWP90_branch.SetAddress(<void*>&self.e2MVAIsoWP90_value)

        #print "making e2MVANoisoWP80"
        self.e2MVANoisoWP80_branch = the_tree.GetBranch("e2MVANoisoWP80")
        #if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80" not in self.complained:
        if not self.e2MVANoisoWP80_branch and "e2MVANoisoWP80":
            warnings.warn( "EEETree: Expected branch e2MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP80")
        else:
            self.e2MVANoisoWP80_branch.SetAddress(<void*>&self.e2MVANoisoWP80_value)

        #print "making e2MVANoisoWP90"
        self.e2MVANoisoWP90_branch = the_tree.GetBranch("e2MVANoisoWP90")
        #if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90" not in self.complained:
        if not self.e2MVANoisoWP90_branch and "e2MVANoisoWP90":
            warnings.warn( "EEETree: Expected branch e2MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MVANoisoWP90")
        else:
            self.e2MVANoisoWP90_branch.SetAddress(<void*>&self.e2MVANoisoWP90_value)

        #print "making e2Mass"
        self.e2Mass_branch = the_tree.GetBranch("e2Mass")
        #if not self.e2Mass_branch and "e2Mass" not in self.complained:
        if not self.e2Mass_branch and "e2Mass":
            warnings.warn( "EEETree: Expected branch e2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Mass")
        else:
            self.e2Mass_branch.SetAddress(<void*>&self.e2Mass_value)

        #print "making e2MatchEmbeddedFilterEle24Tau30"
        self.e2MatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle24Tau30")
        #if not self.e2MatchEmbeddedFilterEle24Tau30_branch and "e2MatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle24Tau30_branch and "e2MatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle24Tau30")
        else:
            self.e2MatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle24Tau30_value)

        #print "making e2MatchEmbeddedFilterEle27"
        self.e2MatchEmbeddedFilterEle27_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle27")
        #if not self.e2MatchEmbeddedFilterEle27_branch and "e2MatchEmbeddedFilterEle27" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle27_branch and "e2MatchEmbeddedFilterEle27":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle27")
        else:
            self.e2MatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle27_value)

        #print "making e2MatchEmbeddedFilterEle32"
        self.e2MatchEmbeddedFilterEle32_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32")
        #if not self.e2MatchEmbeddedFilterEle32_branch and "e2MatchEmbeddedFilterEle32" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32_branch and "e2MatchEmbeddedFilterEle32":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32")
        else:
            self.e2MatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32_value)

        #print "making e2MatchEmbeddedFilterEle32DoubleL1_v1"
        self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.e2MatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making e2MatchEmbeddedFilterEle32DoubleL1_v2"
        self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e2MatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.e2MatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making e2MatchEmbeddedFilterEle35"
        self.e2MatchEmbeddedFilterEle35_branch = the_tree.GetBranch("e2MatchEmbeddedFilterEle35")
        #if not self.e2MatchEmbeddedFilterEle35_branch and "e2MatchEmbeddedFilterEle35" not in self.complained:
        if not self.e2MatchEmbeddedFilterEle35_branch and "e2MatchEmbeddedFilterEle35":
            warnings.warn( "EEETree: Expected branch e2MatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchEmbeddedFilterEle35")
        else:
            self.e2MatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.e2MatchEmbeddedFilterEle35_value)

        #print "making e2MatchesEle24HPSTau30Filter"
        self.e2MatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("e2MatchesEle24HPSTau30Filter")
        #if not self.e2MatchesEle24HPSTau30Filter_branch and "e2MatchesEle24HPSTau30Filter" not in self.complained:
        if not self.e2MatchesEle24HPSTau30Filter_branch and "e2MatchesEle24HPSTau30Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24HPSTau30Filter")
        else:
            self.e2MatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24HPSTau30Filter_value)

        #print "making e2MatchesEle24HPSTau30Path"
        self.e2MatchesEle24HPSTau30Path_branch = the_tree.GetBranch("e2MatchesEle24HPSTau30Path")
        #if not self.e2MatchesEle24HPSTau30Path_branch and "e2MatchesEle24HPSTau30Path" not in self.complained:
        if not self.e2MatchesEle24HPSTau30Path_branch and "e2MatchesEle24HPSTau30Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24HPSTau30Path")
        else:
            self.e2MatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24HPSTau30Path_value)

        #print "making e2MatchesEle24Tau30Filter"
        self.e2MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e2MatchesEle24Tau30Filter")
        #if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter" not in self.complained:
        if not self.e2MatchesEle24Tau30Filter_branch and "e2MatchesEle24Tau30Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Filter")
        else:
            self.e2MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Filter_value)

        #print "making e2MatchesEle24Tau30Path"
        self.e2MatchesEle24Tau30Path_branch = the_tree.GetBranch("e2MatchesEle24Tau30Path")
        #if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path" not in self.complained:
        if not self.e2MatchesEle24Tau30Path_branch and "e2MatchesEle24Tau30Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle24Tau30Path")
        else:
            self.e2MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e2MatchesEle24Tau30Path_value)

        #print "making e2MatchesEle25Filter"
        self.e2MatchesEle25Filter_branch = the_tree.GetBranch("e2MatchesEle25Filter")
        #if not self.e2MatchesEle25Filter_branch and "e2MatchesEle25Filter" not in self.complained:
        if not self.e2MatchesEle25Filter_branch and "e2MatchesEle25Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25Filter")
        else:
            self.e2MatchesEle25Filter_branch.SetAddress(<void*>&self.e2MatchesEle25Filter_value)

        #print "making e2MatchesEle25Path"
        self.e2MatchesEle25Path_branch = the_tree.GetBranch("e2MatchesEle25Path")
        #if not self.e2MatchesEle25Path_branch and "e2MatchesEle25Path" not in self.complained:
        if not self.e2MatchesEle25Path_branch and "e2MatchesEle25Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle25Path")
        else:
            self.e2MatchesEle25Path_branch.SetAddress(<void*>&self.e2MatchesEle25Path_value)

        #print "making e2MatchesEle27Filter"
        self.e2MatchesEle27Filter_branch = the_tree.GetBranch("e2MatchesEle27Filter")
        #if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter" not in self.complained:
        if not self.e2MatchesEle27Filter_branch and "e2MatchesEle27Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Filter")
        else:
            self.e2MatchesEle27Filter_branch.SetAddress(<void*>&self.e2MatchesEle27Filter_value)

        #print "making e2MatchesEle27Path"
        self.e2MatchesEle27Path_branch = the_tree.GetBranch("e2MatchesEle27Path")
        #if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path" not in self.complained:
        if not self.e2MatchesEle27Path_branch and "e2MatchesEle27Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle27Path")
        else:
            self.e2MatchesEle27Path_branch.SetAddress(<void*>&self.e2MatchesEle27Path_value)

        #print "making e2MatchesEle32Filter"
        self.e2MatchesEle32Filter_branch = the_tree.GetBranch("e2MatchesEle32Filter")
        #if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter" not in self.complained:
        if not self.e2MatchesEle32Filter_branch and "e2MatchesEle32Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Filter")
        else:
            self.e2MatchesEle32Filter_branch.SetAddress(<void*>&self.e2MatchesEle32Filter_value)

        #print "making e2MatchesEle32Path"
        self.e2MatchesEle32Path_branch = the_tree.GetBranch("e2MatchesEle32Path")
        #if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path" not in self.complained:
        if not self.e2MatchesEle32Path_branch and "e2MatchesEle32Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle32Path")
        else:
            self.e2MatchesEle32Path_branch.SetAddress(<void*>&self.e2MatchesEle32Path_value)

        #print "making e2MatchesEle35Filter"
        self.e2MatchesEle35Filter_branch = the_tree.GetBranch("e2MatchesEle35Filter")
        #if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter" not in self.complained:
        if not self.e2MatchesEle35Filter_branch and "e2MatchesEle35Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Filter")
        else:
            self.e2MatchesEle35Filter_branch.SetAddress(<void*>&self.e2MatchesEle35Filter_value)

        #print "making e2MatchesEle35Path"
        self.e2MatchesEle35Path_branch = the_tree.GetBranch("e2MatchesEle35Path")
        #if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path" not in self.complained:
        if not self.e2MatchesEle35Path_branch and "e2MatchesEle35Path":
            warnings.warn( "EEETree: Expected branch e2MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesEle35Path")
        else:
            self.e2MatchesEle35Path_branch.SetAddress(<void*>&self.e2MatchesEle35Path_value)

        #print "making e2MatchesMu23e12DZFilter"
        self.e2MatchesMu23e12DZFilter_branch = the_tree.GetBranch("e2MatchesMu23e12DZFilter")
        #if not self.e2MatchesMu23e12DZFilter_branch and "e2MatchesMu23e12DZFilter" not in self.complained:
        if not self.e2MatchesMu23e12DZFilter_branch and "e2MatchesMu23e12DZFilter":
            warnings.warn( "EEETree: Expected branch e2MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12DZFilter")
        else:
            self.e2MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu23e12DZFilter_value)

        #print "making e2MatchesMu23e12DZPath"
        self.e2MatchesMu23e12DZPath_branch = the_tree.GetBranch("e2MatchesMu23e12DZPath")
        #if not self.e2MatchesMu23e12DZPath_branch and "e2MatchesMu23e12DZPath" not in self.complained:
        if not self.e2MatchesMu23e12DZPath_branch and "e2MatchesMu23e12DZPath":
            warnings.warn( "EEETree: Expected branch e2MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12DZPath")
        else:
            self.e2MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.e2MatchesMu23e12DZPath_value)

        #print "making e2MatchesMu23e12Filter"
        self.e2MatchesMu23e12Filter_branch = the_tree.GetBranch("e2MatchesMu23e12Filter")
        #if not self.e2MatchesMu23e12Filter_branch and "e2MatchesMu23e12Filter" not in self.complained:
        if not self.e2MatchesMu23e12Filter_branch and "e2MatchesMu23e12Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12Filter")
        else:
            self.e2MatchesMu23e12Filter_branch.SetAddress(<void*>&self.e2MatchesMu23e12Filter_value)

        #print "making e2MatchesMu23e12Path"
        self.e2MatchesMu23e12Path_branch = the_tree.GetBranch("e2MatchesMu23e12Path")
        #if not self.e2MatchesMu23e12Path_branch and "e2MatchesMu23e12Path" not in self.complained:
        if not self.e2MatchesMu23e12Path_branch and "e2MatchesMu23e12Path":
            warnings.warn( "EEETree: Expected branch e2MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu23e12Path")
        else:
            self.e2MatchesMu23e12Path_branch.SetAddress(<void*>&self.e2MatchesMu23e12Path_value)

        #print "making e2MatchesMu8e23DZFilter"
        self.e2MatchesMu8e23DZFilter_branch = the_tree.GetBranch("e2MatchesMu8e23DZFilter")
        #if not self.e2MatchesMu8e23DZFilter_branch and "e2MatchesMu8e23DZFilter" not in self.complained:
        if not self.e2MatchesMu8e23DZFilter_branch and "e2MatchesMu8e23DZFilter":
            warnings.warn( "EEETree: Expected branch e2MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23DZFilter")
        else:
            self.e2MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.e2MatchesMu8e23DZFilter_value)

        #print "making e2MatchesMu8e23DZPath"
        self.e2MatchesMu8e23DZPath_branch = the_tree.GetBranch("e2MatchesMu8e23DZPath")
        #if not self.e2MatchesMu8e23DZPath_branch and "e2MatchesMu8e23DZPath" not in self.complained:
        if not self.e2MatchesMu8e23DZPath_branch and "e2MatchesMu8e23DZPath":
            warnings.warn( "EEETree: Expected branch e2MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23DZPath")
        else:
            self.e2MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.e2MatchesMu8e23DZPath_value)

        #print "making e2MatchesMu8e23Filter"
        self.e2MatchesMu8e23Filter_branch = the_tree.GetBranch("e2MatchesMu8e23Filter")
        #if not self.e2MatchesMu8e23Filter_branch and "e2MatchesMu8e23Filter" not in self.complained:
        if not self.e2MatchesMu8e23Filter_branch and "e2MatchesMu8e23Filter":
            warnings.warn( "EEETree: Expected branch e2MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23Filter")
        else:
            self.e2MatchesMu8e23Filter_branch.SetAddress(<void*>&self.e2MatchesMu8e23Filter_value)

        #print "making e2MatchesMu8e23Path"
        self.e2MatchesMu8e23Path_branch = the_tree.GetBranch("e2MatchesMu8e23Path")
        #if not self.e2MatchesMu8e23Path_branch and "e2MatchesMu8e23Path" not in self.complained:
        if not self.e2MatchesMu8e23Path_branch and "e2MatchesMu8e23Path":
            warnings.warn( "EEETree: Expected branch e2MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MatchesMu8e23Path")
        else:
            self.e2MatchesMu8e23Path_branch.SetAddress(<void*>&self.e2MatchesMu8e23Path_value)

        #print "making e2MissingHits"
        self.e2MissingHits_branch = the_tree.GetBranch("e2MissingHits")
        #if not self.e2MissingHits_branch and "e2MissingHits" not in self.complained:
        if not self.e2MissingHits_branch and "e2MissingHits":
            warnings.warn( "EEETree: Expected branch e2MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2MissingHits")
        else:
            self.e2MissingHits_branch.SetAddress(<void*>&self.e2MissingHits_value)

        #print "making e2NearMuonVeto"
        self.e2NearMuonVeto_branch = the_tree.GetBranch("e2NearMuonVeto")
        #if not self.e2NearMuonVeto_branch and "e2NearMuonVeto" not in self.complained:
        if not self.e2NearMuonVeto_branch and "e2NearMuonVeto":
            warnings.warn( "EEETree: Expected branch e2NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearMuonVeto")
        else:
            self.e2NearMuonVeto_branch.SetAddress(<void*>&self.e2NearMuonVeto_value)

        #print "making e2NearestMuonDR"
        self.e2NearestMuonDR_branch = the_tree.GetBranch("e2NearestMuonDR")
        #if not self.e2NearestMuonDR_branch and "e2NearestMuonDR" not in self.complained:
        if not self.e2NearestMuonDR_branch and "e2NearestMuonDR":
            warnings.warn( "EEETree: Expected branch e2NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestMuonDR")
        else:
            self.e2NearestMuonDR_branch.SetAddress(<void*>&self.e2NearestMuonDR_value)

        #print "making e2NearestZMass"
        self.e2NearestZMass_branch = the_tree.GetBranch("e2NearestZMass")
        #if not self.e2NearestZMass_branch and "e2NearestZMass" not in self.complained:
        if not self.e2NearestZMass_branch and "e2NearestZMass":
            warnings.warn( "EEETree: Expected branch e2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2NearestZMass")
        else:
            self.e2NearestZMass_branch.SetAddress(<void*>&self.e2NearestZMass_value)

        #print "making e2PFChargedIso"
        self.e2PFChargedIso_branch = the_tree.GetBranch("e2PFChargedIso")
        #if not self.e2PFChargedIso_branch and "e2PFChargedIso" not in self.complained:
        if not self.e2PFChargedIso_branch and "e2PFChargedIso":
            warnings.warn( "EEETree: Expected branch e2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFChargedIso")
        else:
            self.e2PFChargedIso_branch.SetAddress(<void*>&self.e2PFChargedIso_value)

        #print "making e2PFNeutralIso"
        self.e2PFNeutralIso_branch = the_tree.GetBranch("e2PFNeutralIso")
        #if not self.e2PFNeutralIso_branch and "e2PFNeutralIso" not in self.complained:
        if not self.e2PFNeutralIso_branch and "e2PFNeutralIso":
            warnings.warn( "EEETree: Expected branch e2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFNeutralIso")
        else:
            self.e2PFNeutralIso_branch.SetAddress(<void*>&self.e2PFNeutralIso_value)

        #print "making e2PFPUChargedIso"
        self.e2PFPUChargedIso_branch = the_tree.GetBranch("e2PFPUChargedIso")
        #if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso" not in self.complained:
        if not self.e2PFPUChargedIso_branch and "e2PFPUChargedIso":
            warnings.warn( "EEETree: Expected branch e2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPUChargedIso")
        else:
            self.e2PFPUChargedIso_branch.SetAddress(<void*>&self.e2PFPUChargedIso_value)

        #print "making e2PFPhotonIso"
        self.e2PFPhotonIso_branch = the_tree.GetBranch("e2PFPhotonIso")
        #if not self.e2PFPhotonIso_branch and "e2PFPhotonIso" not in self.complained:
        if not self.e2PFPhotonIso_branch and "e2PFPhotonIso":
            warnings.warn( "EEETree: Expected branch e2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PFPhotonIso")
        else:
            self.e2PFPhotonIso_branch.SetAddress(<void*>&self.e2PFPhotonIso_value)

        #print "making e2PVDXY"
        self.e2PVDXY_branch = the_tree.GetBranch("e2PVDXY")
        #if not self.e2PVDXY_branch and "e2PVDXY" not in self.complained:
        if not self.e2PVDXY_branch and "e2PVDXY":
            warnings.warn( "EEETree: Expected branch e2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDXY")
        else:
            self.e2PVDXY_branch.SetAddress(<void*>&self.e2PVDXY_value)

        #print "making e2PVDZ"
        self.e2PVDZ_branch = the_tree.GetBranch("e2PVDZ")
        #if not self.e2PVDZ_branch and "e2PVDZ" not in self.complained:
        if not self.e2PVDZ_branch and "e2PVDZ":
            warnings.warn( "EEETree: Expected branch e2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PVDZ")
        else:
            self.e2PVDZ_branch.SetAddress(<void*>&self.e2PVDZ_value)

        #print "making e2PassesConversionVeto"
        self.e2PassesConversionVeto_branch = the_tree.GetBranch("e2PassesConversionVeto")
        #if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto" not in self.complained:
        if not self.e2PassesConversionVeto_branch and "e2PassesConversionVeto":
            warnings.warn( "EEETree: Expected branch e2PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2PassesConversionVeto")
        else:
            self.e2PassesConversionVeto_branch.SetAddress(<void*>&self.e2PassesConversionVeto_value)

        #print "making e2Phi"
        self.e2Phi_branch = the_tree.GetBranch("e2Phi")
        #if not self.e2Phi_branch and "e2Phi" not in self.complained:
        if not self.e2Phi_branch and "e2Phi":
            warnings.warn( "EEETree: Expected branch e2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Phi")
        else:
            self.e2Phi_branch.SetAddress(<void*>&self.e2Phi_value)

        #print "making e2Pt"
        self.e2Pt_branch = the_tree.GetBranch("e2Pt")
        #if not self.e2Pt_branch and "e2Pt" not in self.complained:
        if not self.e2Pt_branch and "e2Pt":
            warnings.warn( "EEETree: Expected branch e2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Pt")
        else:
            self.e2Pt_branch.SetAddress(<void*>&self.e2Pt_value)

        #print "making e2RelIso"
        self.e2RelIso_branch = the_tree.GetBranch("e2RelIso")
        #if not self.e2RelIso_branch and "e2RelIso" not in self.complained:
        if not self.e2RelIso_branch and "e2RelIso":
            warnings.warn( "EEETree: Expected branch e2RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelIso")
        else:
            self.e2RelIso_branch.SetAddress(<void*>&self.e2RelIso_value)

        #print "making e2RelPFIsoDB"
        self.e2RelPFIsoDB_branch = the_tree.GetBranch("e2RelPFIsoDB")
        #if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB" not in self.complained:
        if not self.e2RelPFIsoDB_branch and "e2RelPFIsoDB":
            warnings.warn( "EEETree: Expected branch e2RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoDB")
        else:
            self.e2RelPFIsoDB_branch.SetAddress(<void*>&self.e2RelPFIsoDB_value)

        #print "making e2RelPFIsoRho"
        self.e2RelPFIsoRho_branch = the_tree.GetBranch("e2RelPFIsoRho")
        #if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho" not in self.complained:
        if not self.e2RelPFIsoRho_branch and "e2RelPFIsoRho":
            warnings.warn( "EEETree: Expected branch e2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2RelPFIsoRho")
        else:
            self.e2RelPFIsoRho_branch.SetAddress(<void*>&self.e2RelPFIsoRho_value)

        #print "making e2Rho"
        self.e2Rho_branch = the_tree.GetBranch("e2Rho")
        #if not self.e2Rho_branch and "e2Rho" not in self.complained:
        if not self.e2Rho_branch and "e2Rho":
            warnings.warn( "EEETree: Expected branch e2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2Rho")
        else:
            self.e2Rho_branch.SetAddress(<void*>&self.e2Rho_value)

        #print "making e2SIP2D"
        self.e2SIP2D_branch = the_tree.GetBranch("e2SIP2D")
        #if not self.e2SIP2D_branch and "e2SIP2D" not in self.complained:
        if not self.e2SIP2D_branch and "e2SIP2D":
            warnings.warn( "EEETree: Expected branch e2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP2D")
        else:
            self.e2SIP2D_branch.SetAddress(<void*>&self.e2SIP2D_value)

        #print "making e2SIP3D"
        self.e2SIP3D_branch = the_tree.GetBranch("e2SIP3D")
        #if not self.e2SIP3D_branch and "e2SIP3D" not in self.complained:
        if not self.e2SIP3D_branch and "e2SIP3D":
            warnings.warn( "EEETree: Expected branch e2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2SIP3D")
        else:
            self.e2SIP3D_branch.SetAddress(<void*>&self.e2SIP3D_value)

        #print "making e2TrkIsoDR03"
        self.e2TrkIsoDR03_branch = the_tree.GetBranch("e2TrkIsoDR03")
        #if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03" not in self.complained:
        if not self.e2TrkIsoDR03_branch and "e2TrkIsoDR03":
            warnings.warn( "EEETree: Expected branch e2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2TrkIsoDR03")
        else:
            self.e2TrkIsoDR03_branch.SetAddress(<void*>&self.e2TrkIsoDR03_value)

        #print "making e2VZ"
        self.e2VZ_branch = the_tree.GetBranch("e2VZ")
        #if not self.e2VZ_branch and "e2VZ" not in self.complained:
        if not self.e2VZ_branch and "e2VZ":
            warnings.warn( "EEETree: Expected branch e2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2VZ")
        else:
            self.e2VZ_branch.SetAddress(<void*>&self.e2VZ_value)

        #print "making e2ZTTGenMatching"
        self.e2ZTTGenMatching_branch = the_tree.GetBranch("e2ZTTGenMatching")
        #if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching" not in self.complained:
        if not self.e2ZTTGenMatching_branch and "e2ZTTGenMatching":
            warnings.warn( "EEETree: Expected branch e2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ZTTGenMatching")
        else:
            self.e2ZTTGenMatching_branch.SetAddress(<void*>&self.e2ZTTGenMatching_value)

        #print "making e2_e3_DR"
        self.e2_e3_DR_branch = the_tree.GetBranch("e2_e3_DR")
        #if not self.e2_e3_DR_branch and "e2_e3_DR" not in self.complained:
        if not self.e2_e3_DR_branch and "e2_e3_DR":
            warnings.warn( "EEETree: Expected branch e2_e3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_DR")
        else:
            self.e2_e3_DR_branch.SetAddress(<void*>&self.e2_e3_DR_value)

        #print "making e2_e3_Mass"
        self.e2_e3_Mass_branch = the_tree.GetBranch("e2_e3_Mass")
        #if not self.e2_e3_Mass_branch and "e2_e3_Mass" not in self.complained:
        if not self.e2_e3_Mass_branch and "e2_e3_Mass":
            warnings.warn( "EEETree: Expected branch e2_e3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_Mass")
        else:
            self.e2_e3_Mass_branch.SetAddress(<void*>&self.e2_e3_Mass_value)

        #print "making e2_e3_PZeta"
        self.e2_e3_PZeta_branch = the_tree.GetBranch("e2_e3_PZeta")
        #if not self.e2_e3_PZeta_branch and "e2_e3_PZeta" not in self.complained:
        if not self.e2_e3_PZeta_branch and "e2_e3_PZeta":
            warnings.warn( "EEETree: Expected branch e2_e3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_PZeta")
        else:
            self.e2_e3_PZeta_branch.SetAddress(<void*>&self.e2_e3_PZeta_value)

        #print "making e2_e3_PZetaVis"
        self.e2_e3_PZetaVis_branch = the_tree.GetBranch("e2_e3_PZetaVis")
        #if not self.e2_e3_PZetaVis_branch and "e2_e3_PZetaVis" not in self.complained:
        if not self.e2_e3_PZetaVis_branch and "e2_e3_PZetaVis":
            warnings.warn( "EEETree: Expected branch e2_e3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_PZetaVis")
        else:
            self.e2_e3_PZetaVis_branch.SetAddress(<void*>&self.e2_e3_PZetaVis_value)

        #print "making e2_e3_doubleL1IsoTauMatch"
        self.e2_e3_doubleL1IsoTauMatch_branch = the_tree.GetBranch("e2_e3_doubleL1IsoTauMatch")
        #if not self.e2_e3_doubleL1IsoTauMatch_branch and "e2_e3_doubleL1IsoTauMatch" not in self.complained:
        if not self.e2_e3_doubleL1IsoTauMatch_branch and "e2_e3_doubleL1IsoTauMatch":
            warnings.warn( "EEETree: Expected branch e2_e3_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2_e3_doubleL1IsoTauMatch")
        else:
            self.e2_e3_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.e2_e3_doubleL1IsoTauMatch_value)

        #print "making e2ecalEnergy"
        self.e2ecalEnergy_branch = the_tree.GetBranch("e2ecalEnergy")
        #if not self.e2ecalEnergy_branch and "e2ecalEnergy" not in self.complained:
        if not self.e2ecalEnergy_branch and "e2ecalEnergy":
            warnings.warn( "EEETree: Expected branch e2ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e2ecalEnergy")
        else:
            self.e2ecalEnergy_branch.SetAddress(<void*>&self.e2ecalEnergy_value)

        #print "making e3Charge"
        self.e3Charge_branch = the_tree.GetBranch("e3Charge")
        #if not self.e3Charge_branch and "e3Charge" not in self.complained:
        if not self.e3Charge_branch and "e3Charge":
            warnings.warn( "EEETree: Expected branch e3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Charge")
        else:
            self.e3Charge_branch.SetAddress(<void*>&self.e3Charge_value)

        #print "making e3ChargeIdLoose"
        self.e3ChargeIdLoose_branch = the_tree.GetBranch("e3ChargeIdLoose")
        #if not self.e3ChargeIdLoose_branch and "e3ChargeIdLoose" not in self.complained:
        if not self.e3ChargeIdLoose_branch and "e3ChargeIdLoose":
            warnings.warn( "EEETree: Expected branch e3ChargeIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdLoose")
        else:
            self.e3ChargeIdLoose_branch.SetAddress(<void*>&self.e3ChargeIdLoose_value)

        #print "making e3ChargeIdMed"
        self.e3ChargeIdMed_branch = the_tree.GetBranch("e3ChargeIdMed")
        #if not self.e3ChargeIdMed_branch and "e3ChargeIdMed" not in self.complained:
        if not self.e3ChargeIdMed_branch and "e3ChargeIdMed":
            warnings.warn( "EEETree: Expected branch e3ChargeIdMed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdMed")
        else:
            self.e3ChargeIdMed_branch.SetAddress(<void*>&self.e3ChargeIdMed_value)

        #print "making e3ChargeIdTight"
        self.e3ChargeIdTight_branch = the_tree.GetBranch("e3ChargeIdTight")
        #if not self.e3ChargeIdTight_branch and "e3ChargeIdTight" not in self.complained:
        if not self.e3ChargeIdTight_branch and "e3ChargeIdTight":
            warnings.warn( "EEETree: Expected branch e3ChargeIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ChargeIdTight")
        else:
            self.e3ChargeIdTight_branch.SetAddress(<void*>&self.e3ChargeIdTight_value)

        #print "making e3ComesFromHiggs"
        self.e3ComesFromHiggs_branch = the_tree.GetBranch("e3ComesFromHiggs")
        #if not self.e3ComesFromHiggs_branch and "e3ComesFromHiggs" not in self.complained:
        if not self.e3ComesFromHiggs_branch and "e3ComesFromHiggs":
            warnings.warn( "EEETree: Expected branch e3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ComesFromHiggs")
        else:
            self.e3ComesFromHiggs_branch.SetAddress(<void*>&self.e3ComesFromHiggs_value)

        #print "making e3CorrectedEt"
        self.e3CorrectedEt_branch = the_tree.GetBranch("e3CorrectedEt")
        #if not self.e3CorrectedEt_branch and "e3CorrectedEt" not in self.complained:
        if not self.e3CorrectedEt_branch and "e3CorrectedEt":
            warnings.warn( "EEETree: Expected branch e3CorrectedEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3CorrectedEt")
        else:
            self.e3CorrectedEt_branch.SetAddress(<void*>&self.e3CorrectedEt_value)

        #print "making e3EcalIsoDR03"
        self.e3EcalIsoDR03_branch = the_tree.GetBranch("e3EcalIsoDR03")
        #if not self.e3EcalIsoDR03_branch and "e3EcalIsoDR03" not in self.complained:
        if not self.e3EcalIsoDR03_branch and "e3EcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e3EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EcalIsoDR03")
        else:
            self.e3EcalIsoDR03_branch.SetAddress(<void*>&self.e3EcalIsoDR03_value)

        #print "making e3EnergyError"
        self.e3EnergyError_branch = the_tree.GetBranch("e3EnergyError")
        #if not self.e3EnergyError_branch and "e3EnergyError" not in self.complained:
        if not self.e3EnergyError_branch and "e3EnergyError":
            warnings.warn( "EEETree: Expected branch e3EnergyError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyError")
        else:
            self.e3EnergyError_branch.SetAddress(<void*>&self.e3EnergyError_value)

        #print "making e3EnergyScaleDown"
        self.e3EnergyScaleDown_branch = the_tree.GetBranch("e3EnergyScaleDown")
        #if not self.e3EnergyScaleDown_branch and "e3EnergyScaleDown" not in self.complained:
        if not self.e3EnergyScaleDown_branch and "e3EnergyScaleDown":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleDown")
        else:
            self.e3EnergyScaleDown_branch.SetAddress(<void*>&self.e3EnergyScaleDown_value)

        #print "making e3EnergyScaleGainDown"
        self.e3EnergyScaleGainDown_branch = the_tree.GetBranch("e3EnergyScaleGainDown")
        #if not self.e3EnergyScaleGainDown_branch and "e3EnergyScaleGainDown" not in self.complained:
        if not self.e3EnergyScaleGainDown_branch and "e3EnergyScaleGainDown":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleGainDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleGainDown")
        else:
            self.e3EnergyScaleGainDown_branch.SetAddress(<void*>&self.e3EnergyScaleGainDown_value)

        #print "making e3EnergyScaleGainUp"
        self.e3EnergyScaleGainUp_branch = the_tree.GetBranch("e3EnergyScaleGainUp")
        #if not self.e3EnergyScaleGainUp_branch and "e3EnergyScaleGainUp" not in self.complained:
        if not self.e3EnergyScaleGainUp_branch and "e3EnergyScaleGainUp":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleGainUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleGainUp")
        else:
            self.e3EnergyScaleGainUp_branch.SetAddress(<void*>&self.e3EnergyScaleGainUp_value)

        #print "making e3EnergyScaleStatDown"
        self.e3EnergyScaleStatDown_branch = the_tree.GetBranch("e3EnergyScaleStatDown")
        #if not self.e3EnergyScaleStatDown_branch and "e3EnergyScaleStatDown" not in self.complained:
        if not self.e3EnergyScaleStatDown_branch and "e3EnergyScaleStatDown":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleStatDown")
        else:
            self.e3EnergyScaleStatDown_branch.SetAddress(<void*>&self.e3EnergyScaleStatDown_value)

        #print "making e3EnergyScaleStatUp"
        self.e3EnergyScaleStatUp_branch = the_tree.GetBranch("e3EnergyScaleStatUp")
        #if not self.e3EnergyScaleStatUp_branch and "e3EnergyScaleStatUp" not in self.complained:
        if not self.e3EnergyScaleStatUp_branch and "e3EnergyScaleStatUp":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleStatUp")
        else:
            self.e3EnergyScaleStatUp_branch.SetAddress(<void*>&self.e3EnergyScaleStatUp_value)

        #print "making e3EnergyScaleSystDown"
        self.e3EnergyScaleSystDown_branch = the_tree.GetBranch("e3EnergyScaleSystDown")
        #if not self.e3EnergyScaleSystDown_branch and "e3EnergyScaleSystDown" not in self.complained:
        if not self.e3EnergyScaleSystDown_branch and "e3EnergyScaleSystDown":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleSystDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleSystDown")
        else:
            self.e3EnergyScaleSystDown_branch.SetAddress(<void*>&self.e3EnergyScaleSystDown_value)

        #print "making e3EnergyScaleSystUp"
        self.e3EnergyScaleSystUp_branch = the_tree.GetBranch("e3EnergyScaleSystUp")
        #if not self.e3EnergyScaleSystUp_branch and "e3EnergyScaleSystUp" not in self.complained:
        if not self.e3EnergyScaleSystUp_branch and "e3EnergyScaleSystUp":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleSystUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleSystUp")
        else:
            self.e3EnergyScaleSystUp_branch.SetAddress(<void*>&self.e3EnergyScaleSystUp_value)

        #print "making e3EnergyScaleUp"
        self.e3EnergyScaleUp_branch = the_tree.GetBranch("e3EnergyScaleUp")
        #if not self.e3EnergyScaleUp_branch and "e3EnergyScaleUp" not in self.complained:
        if not self.e3EnergyScaleUp_branch and "e3EnergyScaleUp":
            warnings.warn( "EEETree: Expected branch e3EnergyScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergyScaleUp")
        else:
            self.e3EnergyScaleUp_branch.SetAddress(<void*>&self.e3EnergyScaleUp_value)

        #print "making e3EnergySigmaDown"
        self.e3EnergySigmaDown_branch = the_tree.GetBranch("e3EnergySigmaDown")
        #if not self.e3EnergySigmaDown_branch and "e3EnergySigmaDown" not in self.complained:
        if not self.e3EnergySigmaDown_branch and "e3EnergySigmaDown":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaDown")
        else:
            self.e3EnergySigmaDown_branch.SetAddress(<void*>&self.e3EnergySigmaDown_value)

        #print "making e3EnergySigmaPhiDown"
        self.e3EnergySigmaPhiDown_branch = the_tree.GetBranch("e3EnergySigmaPhiDown")
        #if not self.e3EnergySigmaPhiDown_branch and "e3EnergySigmaPhiDown" not in self.complained:
        if not self.e3EnergySigmaPhiDown_branch and "e3EnergySigmaPhiDown":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaPhiDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaPhiDown")
        else:
            self.e3EnergySigmaPhiDown_branch.SetAddress(<void*>&self.e3EnergySigmaPhiDown_value)

        #print "making e3EnergySigmaPhiUp"
        self.e3EnergySigmaPhiUp_branch = the_tree.GetBranch("e3EnergySigmaPhiUp")
        #if not self.e3EnergySigmaPhiUp_branch and "e3EnergySigmaPhiUp" not in self.complained:
        if not self.e3EnergySigmaPhiUp_branch and "e3EnergySigmaPhiUp":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaPhiUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaPhiUp")
        else:
            self.e3EnergySigmaPhiUp_branch.SetAddress(<void*>&self.e3EnergySigmaPhiUp_value)

        #print "making e3EnergySigmaRhoDown"
        self.e3EnergySigmaRhoDown_branch = the_tree.GetBranch("e3EnergySigmaRhoDown")
        #if not self.e3EnergySigmaRhoDown_branch and "e3EnergySigmaRhoDown" not in self.complained:
        if not self.e3EnergySigmaRhoDown_branch and "e3EnergySigmaRhoDown":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaRhoDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaRhoDown")
        else:
            self.e3EnergySigmaRhoDown_branch.SetAddress(<void*>&self.e3EnergySigmaRhoDown_value)

        #print "making e3EnergySigmaRhoUp"
        self.e3EnergySigmaRhoUp_branch = the_tree.GetBranch("e3EnergySigmaRhoUp")
        #if not self.e3EnergySigmaRhoUp_branch and "e3EnergySigmaRhoUp" not in self.complained:
        if not self.e3EnergySigmaRhoUp_branch and "e3EnergySigmaRhoUp":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaRhoUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaRhoUp")
        else:
            self.e3EnergySigmaRhoUp_branch.SetAddress(<void*>&self.e3EnergySigmaRhoUp_value)

        #print "making e3EnergySigmaUp"
        self.e3EnergySigmaUp_branch = the_tree.GetBranch("e3EnergySigmaUp")
        #if not self.e3EnergySigmaUp_branch and "e3EnergySigmaUp" not in self.complained:
        if not self.e3EnergySigmaUp_branch and "e3EnergySigmaUp":
            warnings.warn( "EEETree: Expected branch e3EnergySigmaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3EnergySigmaUp")
        else:
            self.e3EnergySigmaUp_branch.SetAddress(<void*>&self.e3EnergySigmaUp_value)

        #print "making e3Eta"
        self.e3Eta_branch = the_tree.GetBranch("e3Eta")
        #if not self.e3Eta_branch and "e3Eta" not in self.complained:
        if not self.e3Eta_branch and "e3Eta":
            warnings.warn( "EEETree: Expected branch e3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Eta")
        else:
            self.e3Eta_branch.SetAddress(<void*>&self.e3Eta_value)

        #print "making e3GenCharge"
        self.e3GenCharge_branch = the_tree.GetBranch("e3GenCharge")
        #if not self.e3GenCharge_branch and "e3GenCharge" not in self.complained:
        if not self.e3GenCharge_branch and "e3GenCharge":
            warnings.warn( "EEETree: Expected branch e3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenCharge")
        else:
            self.e3GenCharge_branch.SetAddress(<void*>&self.e3GenCharge_value)

        #print "making e3GenDirectPromptTauDecay"
        self.e3GenDirectPromptTauDecay_branch = the_tree.GetBranch("e3GenDirectPromptTauDecay")
        #if not self.e3GenDirectPromptTauDecay_branch and "e3GenDirectPromptTauDecay" not in self.complained:
        if not self.e3GenDirectPromptTauDecay_branch and "e3GenDirectPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e3GenDirectPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenDirectPromptTauDecay")
        else:
            self.e3GenDirectPromptTauDecay_branch.SetAddress(<void*>&self.e3GenDirectPromptTauDecay_value)

        #print "making e3GenEnergy"
        self.e3GenEnergy_branch = the_tree.GetBranch("e3GenEnergy")
        #if not self.e3GenEnergy_branch and "e3GenEnergy" not in self.complained:
        if not self.e3GenEnergy_branch and "e3GenEnergy":
            warnings.warn( "EEETree: Expected branch e3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenEnergy")
        else:
            self.e3GenEnergy_branch.SetAddress(<void*>&self.e3GenEnergy_value)

        #print "making e3GenEta"
        self.e3GenEta_branch = the_tree.GetBranch("e3GenEta")
        #if not self.e3GenEta_branch and "e3GenEta" not in self.complained:
        if not self.e3GenEta_branch and "e3GenEta":
            warnings.warn( "EEETree: Expected branch e3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenEta")
        else:
            self.e3GenEta_branch.SetAddress(<void*>&self.e3GenEta_value)

        #print "making e3GenIsPrompt"
        self.e3GenIsPrompt_branch = the_tree.GetBranch("e3GenIsPrompt")
        #if not self.e3GenIsPrompt_branch and "e3GenIsPrompt" not in self.complained:
        if not self.e3GenIsPrompt_branch and "e3GenIsPrompt":
            warnings.warn( "EEETree: Expected branch e3GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenIsPrompt")
        else:
            self.e3GenIsPrompt_branch.SetAddress(<void*>&self.e3GenIsPrompt_value)

        #print "making e3GenMotherPdgId"
        self.e3GenMotherPdgId_branch = the_tree.GetBranch("e3GenMotherPdgId")
        #if not self.e3GenMotherPdgId_branch and "e3GenMotherPdgId" not in self.complained:
        if not self.e3GenMotherPdgId_branch and "e3GenMotherPdgId":
            warnings.warn( "EEETree: Expected branch e3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenMotherPdgId")
        else:
            self.e3GenMotherPdgId_branch.SetAddress(<void*>&self.e3GenMotherPdgId_value)

        #print "making e3GenParticle"
        self.e3GenParticle_branch = the_tree.GetBranch("e3GenParticle")
        #if not self.e3GenParticle_branch and "e3GenParticle" not in self.complained:
        if not self.e3GenParticle_branch and "e3GenParticle":
            warnings.warn( "EEETree: Expected branch e3GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenParticle")
        else:
            self.e3GenParticle_branch.SetAddress(<void*>&self.e3GenParticle_value)

        #print "making e3GenPdgId"
        self.e3GenPdgId_branch = the_tree.GetBranch("e3GenPdgId")
        #if not self.e3GenPdgId_branch and "e3GenPdgId" not in self.complained:
        if not self.e3GenPdgId_branch and "e3GenPdgId":
            warnings.warn( "EEETree: Expected branch e3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPdgId")
        else:
            self.e3GenPdgId_branch.SetAddress(<void*>&self.e3GenPdgId_value)

        #print "making e3GenPhi"
        self.e3GenPhi_branch = the_tree.GetBranch("e3GenPhi")
        #if not self.e3GenPhi_branch and "e3GenPhi" not in self.complained:
        if not self.e3GenPhi_branch and "e3GenPhi":
            warnings.warn( "EEETree: Expected branch e3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPhi")
        else:
            self.e3GenPhi_branch.SetAddress(<void*>&self.e3GenPhi_value)

        #print "making e3GenPrompt"
        self.e3GenPrompt_branch = the_tree.GetBranch("e3GenPrompt")
        #if not self.e3GenPrompt_branch and "e3GenPrompt" not in self.complained:
        if not self.e3GenPrompt_branch and "e3GenPrompt":
            warnings.warn( "EEETree: Expected branch e3GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPrompt")
        else:
            self.e3GenPrompt_branch.SetAddress(<void*>&self.e3GenPrompt_value)

        #print "making e3GenPromptTauDecay"
        self.e3GenPromptTauDecay_branch = the_tree.GetBranch("e3GenPromptTauDecay")
        #if not self.e3GenPromptTauDecay_branch and "e3GenPromptTauDecay" not in self.complained:
        if not self.e3GenPromptTauDecay_branch and "e3GenPromptTauDecay":
            warnings.warn( "EEETree: Expected branch e3GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPromptTauDecay")
        else:
            self.e3GenPromptTauDecay_branch.SetAddress(<void*>&self.e3GenPromptTauDecay_value)

        #print "making e3GenPt"
        self.e3GenPt_branch = the_tree.GetBranch("e3GenPt")
        #if not self.e3GenPt_branch and "e3GenPt" not in self.complained:
        if not self.e3GenPt_branch and "e3GenPt":
            warnings.warn( "EEETree: Expected branch e3GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenPt")
        else:
            self.e3GenPt_branch.SetAddress(<void*>&self.e3GenPt_value)

        #print "making e3GenTauDecay"
        self.e3GenTauDecay_branch = the_tree.GetBranch("e3GenTauDecay")
        #if not self.e3GenTauDecay_branch and "e3GenTauDecay" not in self.complained:
        if not self.e3GenTauDecay_branch and "e3GenTauDecay":
            warnings.warn( "EEETree: Expected branch e3GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenTauDecay")
        else:
            self.e3GenTauDecay_branch.SetAddress(<void*>&self.e3GenTauDecay_value)

        #print "making e3GenVZ"
        self.e3GenVZ_branch = the_tree.GetBranch("e3GenVZ")
        #if not self.e3GenVZ_branch and "e3GenVZ" not in self.complained:
        if not self.e3GenVZ_branch and "e3GenVZ":
            warnings.warn( "EEETree: Expected branch e3GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenVZ")
        else:
            self.e3GenVZ_branch.SetAddress(<void*>&self.e3GenVZ_value)

        #print "making e3GenVtxPVMatch"
        self.e3GenVtxPVMatch_branch = the_tree.GetBranch("e3GenVtxPVMatch")
        #if not self.e3GenVtxPVMatch_branch and "e3GenVtxPVMatch" not in self.complained:
        if not self.e3GenVtxPVMatch_branch and "e3GenVtxPVMatch":
            warnings.warn( "EEETree: Expected branch e3GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3GenVtxPVMatch")
        else:
            self.e3GenVtxPVMatch_branch.SetAddress(<void*>&self.e3GenVtxPVMatch_value)

        #print "making e3HcalIsoDR03"
        self.e3HcalIsoDR03_branch = the_tree.GetBranch("e3HcalIsoDR03")
        #if not self.e3HcalIsoDR03_branch and "e3HcalIsoDR03" not in self.complained:
        if not self.e3HcalIsoDR03_branch and "e3HcalIsoDR03":
            warnings.warn( "EEETree: Expected branch e3HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3HcalIsoDR03")
        else:
            self.e3HcalIsoDR03_branch.SetAddress(<void*>&self.e3HcalIsoDR03_value)

        #print "making e3IP3D"
        self.e3IP3D_branch = the_tree.GetBranch("e3IP3D")
        #if not self.e3IP3D_branch and "e3IP3D" not in self.complained:
        if not self.e3IP3D_branch and "e3IP3D":
            warnings.warn( "EEETree: Expected branch e3IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3IP3D")
        else:
            self.e3IP3D_branch.SetAddress(<void*>&self.e3IP3D_value)

        #print "making e3IP3DErr"
        self.e3IP3DErr_branch = the_tree.GetBranch("e3IP3DErr")
        #if not self.e3IP3DErr_branch and "e3IP3DErr" not in self.complained:
        if not self.e3IP3DErr_branch and "e3IP3DErr":
            warnings.warn( "EEETree: Expected branch e3IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3IP3DErr")
        else:
            self.e3IP3DErr_branch.SetAddress(<void*>&self.e3IP3DErr_value)

        #print "making e3IsoDB03"
        self.e3IsoDB03_branch = the_tree.GetBranch("e3IsoDB03")
        #if not self.e3IsoDB03_branch and "e3IsoDB03" not in self.complained:
        if not self.e3IsoDB03_branch and "e3IsoDB03":
            warnings.warn( "EEETree: Expected branch e3IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3IsoDB03")
        else:
            self.e3IsoDB03_branch.SetAddress(<void*>&self.e3IsoDB03_value)

        #print "making e3JetArea"
        self.e3JetArea_branch = the_tree.GetBranch("e3JetArea")
        #if not self.e3JetArea_branch and "e3JetArea" not in self.complained:
        if not self.e3JetArea_branch and "e3JetArea":
            warnings.warn( "EEETree: Expected branch e3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetArea")
        else:
            self.e3JetArea_branch.SetAddress(<void*>&self.e3JetArea_value)

        #print "making e3JetBtag"
        self.e3JetBtag_branch = the_tree.GetBranch("e3JetBtag")
        #if not self.e3JetBtag_branch and "e3JetBtag" not in self.complained:
        if not self.e3JetBtag_branch and "e3JetBtag":
            warnings.warn( "EEETree: Expected branch e3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetBtag")
        else:
            self.e3JetBtag_branch.SetAddress(<void*>&self.e3JetBtag_value)

        #print "making e3JetDR"
        self.e3JetDR_branch = the_tree.GetBranch("e3JetDR")
        #if not self.e3JetDR_branch and "e3JetDR" not in self.complained:
        if not self.e3JetDR_branch and "e3JetDR":
            warnings.warn( "EEETree: Expected branch e3JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetDR")
        else:
            self.e3JetDR_branch.SetAddress(<void*>&self.e3JetDR_value)

        #print "making e3JetEtaEtaMoment"
        self.e3JetEtaEtaMoment_branch = the_tree.GetBranch("e3JetEtaEtaMoment")
        #if not self.e3JetEtaEtaMoment_branch and "e3JetEtaEtaMoment" not in self.complained:
        if not self.e3JetEtaEtaMoment_branch and "e3JetEtaEtaMoment":
            warnings.warn( "EEETree: Expected branch e3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaEtaMoment")
        else:
            self.e3JetEtaEtaMoment_branch.SetAddress(<void*>&self.e3JetEtaEtaMoment_value)

        #print "making e3JetEtaPhiMoment"
        self.e3JetEtaPhiMoment_branch = the_tree.GetBranch("e3JetEtaPhiMoment")
        #if not self.e3JetEtaPhiMoment_branch and "e3JetEtaPhiMoment" not in self.complained:
        if not self.e3JetEtaPhiMoment_branch and "e3JetEtaPhiMoment":
            warnings.warn( "EEETree: Expected branch e3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaPhiMoment")
        else:
            self.e3JetEtaPhiMoment_branch.SetAddress(<void*>&self.e3JetEtaPhiMoment_value)

        #print "making e3JetEtaPhiSpread"
        self.e3JetEtaPhiSpread_branch = the_tree.GetBranch("e3JetEtaPhiSpread")
        #if not self.e3JetEtaPhiSpread_branch and "e3JetEtaPhiSpread" not in self.complained:
        if not self.e3JetEtaPhiSpread_branch and "e3JetEtaPhiSpread":
            warnings.warn( "EEETree: Expected branch e3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetEtaPhiSpread")
        else:
            self.e3JetEtaPhiSpread_branch.SetAddress(<void*>&self.e3JetEtaPhiSpread_value)

        #print "making e3JetHadronFlavour"
        self.e3JetHadronFlavour_branch = the_tree.GetBranch("e3JetHadronFlavour")
        #if not self.e3JetHadronFlavour_branch and "e3JetHadronFlavour" not in self.complained:
        if not self.e3JetHadronFlavour_branch and "e3JetHadronFlavour":
            warnings.warn( "EEETree: Expected branch e3JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetHadronFlavour")
        else:
            self.e3JetHadronFlavour_branch.SetAddress(<void*>&self.e3JetHadronFlavour_value)

        #print "making e3JetPFCISVBtag"
        self.e3JetPFCISVBtag_branch = the_tree.GetBranch("e3JetPFCISVBtag")
        #if not self.e3JetPFCISVBtag_branch and "e3JetPFCISVBtag" not in self.complained:
        if not self.e3JetPFCISVBtag_branch and "e3JetPFCISVBtag":
            warnings.warn( "EEETree: Expected branch e3JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPFCISVBtag")
        else:
            self.e3JetPFCISVBtag_branch.SetAddress(<void*>&self.e3JetPFCISVBtag_value)

        #print "making e3JetPartonFlavour"
        self.e3JetPartonFlavour_branch = the_tree.GetBranch("e3JetPartonFlavour")
        #if not self.e3JetPartonFlavour_branch and "e3JetPartonFlavour" not in self.complained:
        if not self.e3JetPartonFlavour_branch and "e3JetPartonFlavour":
            warnings.warn( "EEETree: Expected branch e3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPartonFlavour")
        else:
            self.e3JetPartonFlavour_branch.SetAddress(<void*>&self.e3JetPartonFlavour_value)

        #print "making e3JetPhiPhiMoment"
        self.e3JetPhiPhiMoment_branch = the_tree.GetBranch("e3JetPhiPhiMoment")
        #if not self.e3JetPhiPhiMoment_branch and "e3JetPhiPhiMoment" not in self.complained:
        if not self.e3JetPhiPhiMoment_branch and "e3JetPhiPhiMoment":
            warnings.warn( "EEETree: Expected branch e3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPhiPhiMoment")
        else:
            self.e3JetPhiPhiMoment_branch.SetAddress(<void*>&self.e3JetPhiPhiMoment_value)

        #print "making e3JetPt"
        self.e3JetPt_branch = the_tree.GetBranch("e3JetPt")
        #if not self.e3JetPt_branch and "e3JetPt" not in self.complained:
        if not self.e3JetPt_branch and "e3JetPt":
            warnings.warn( "EEETree: Expected branch e3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3JetPt")
        else:
            self.e3JetPt_branch.SetAddress(<void*>&self.e3JetPt_value)

        #print "making e3LowestMll"
        self.e3LowestMll_branch = the_tree.GetBranch("e3LowestMll")
        #if not self.e3LowestMll_branch and "e3LowestMll" not in self.complained:
        if not self.e3LowestMll_branch and "e3LowestMll":
            warnings.warn( "EEETree: Expected branch e3LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3LowestMll")
        else:
            self.e3LowestMll_branch.SetAddress(<void*>&self.e3LowestMll_value)

        #print "making e3MVAIsoWP80"
        self.e3MVAIsoWP80_branch = the_tree.GetBranch("e3MVAIsoWP80")
        #if not self.e3MVAIsoWP80_branch and "e3MVAIsoWP80" not in self.complained:
        if not self.e3MVAIsoWP80_branch and "e3MVAIsoWP80":
            warnings.warn( "EEETree: Expected branch e3MVAIsoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVAIsoWP80")
        else:
            self.e3MVAIsoWP80_branch.SetAddress(<void*>&self.e3MVAIsoWP80_value)

        #print "making e3MVAIsoWP90"
        self.e3MVAIsoWP90_branch = the_tree.GetBranch("e3MVAIsoWP90")
        #if not self.e3MVAIsoWP90_branch and "e3MVAIsoWP90" not in self.complained:
        if not self.e3MVAIsoWP90_branch and "e3MVAIsoWP90":
            warnings.warn( "EEETree: Expected branch e3MVAIsoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVAIsoWP90")
        else:
            self.e3MVAIsoWP90_branch.SetAddress(<void*>&self.e3MVAIsoWP90_value)

        #print "making e3MVANoisoWP80"
        self.e3MVANoisoWP80_branch = the_tree.GetBranch("e3MVANoisoWP80")
        #if not self.e3MVANoisoWP80_branch and "e3MVANoisoWP80" not in self.complained:
        if not self.e3MVANoisoWP80_branch and "e3MVANoisoWP80":
            warnings.warn( "EEETree: Expected branch e3MVANoisoWP80 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVANoisoWP80")
        else:
            self.e3MVANoisoWP80_branch.SetAddress(<void*>&self.e3MVANoisoWP80_value)

        #print "making e3MVANoisoWP90"
        self.e3MVANoisoWP90_branch = the_tree.GetBranch("e3MVANoisoWP90")
        #if not self.e3MVANoisoWP90_branch and "e3MVANoisoWP90" not in self.complained:
        if not self.e3MVANoisoWP90_branch and "e3MVANoisoWP90":
            warnings.warn( "EEETree: Expected branch e3MVANoisoWP90 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MVANoisoWP90")
        else:
            self.e3MVANoisoWP90_branch.SetAddress(<void*>&self.e3MVANoisoWP90_value)

        #print "making e3Mass"
        self.e3Mass_branch = the_tree.GetBranch("e3Mass")
        #if not self.e3Mass_branch and "e3Mass" not in self.complained:
        if not self.e3Mass_branch and "e3Mass":
            warnings.warn( "EEETree: Expected branch e3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Mass")
        else:
            self.e3Mass_branch.SetAddress(<void*>&self.e3Mass_value)

        #print "making e3MatchEmbeddedFilterEle24Tau30"
        self.e3MatchEmbeddedFilterEle24Tau30_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle24Tau30")
        #if not self.e3MatchEmbeddedFilterEle24Tau30_branch and "e3MatchEmbeddedFilterEle24Tau30" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle24Tau30_branch and "e3MatchEmbeddedFilterEle24Tau30":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle24Tau30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle24Tau30")
        else:
            self.e3MatchEmbeddedFilterEle24Tau30_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle24Tau30_value)

        #print "making e3MatchEmbeddedFilterEle27"
        self.e3MatchEmbeddedFilterEle27_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle27")
        #if not self.e3MatchEmbeddedFilterEle27_branch and "e3MatchEmbeddedFilterEle27" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle27_branch and "e3MatchEmbeddedFilterEle27":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle27 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle27")
        else:
            self.e3MatchEmbeddedFilterEle27_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle27_value)

        #print "making e3MatchEmbeddedFilterEle32"
        self.e3MatchEmbeddedFilterEle32_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle32")
        #if not self.e3MatchEmbeddedFilterEle32_branch and "e3MatchEmbeddedFilterEle32" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle32_branch and "e3MatchEmbeddedFilterEle32":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle32 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle32")
        else:
            self.e3MatchEmbeddedFilterEle32_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle32_value)

        #print "making e3MatchEmbeddedFilterEle32DoubleL1_v1"
        self.e3MatchEmbeddedFilterEle32DoubleL1_v1_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle32DoubleL1_v1")
        #if not self.e3MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e3MatchEmbeddedFilterEle32DoubleL1_v1" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle32DoubleL1_v1_branch and "e3MatchEmbeddedFilterEle32DoubleL1_v1":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle32DoubleL1_v1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle32DoubleL1_v1")
        else:
            self.e3MatchEmbeddedFilterEle32DoubleL1_v1_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle32DoubleL1_v1_value)

        #print "making e3MatchEmbeddedFilterEle32DoubleL1_v2"
        self.e3MatchEmbeddedFilterEle32DoubleL1_v2_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle32DoubleL1_v2")
        #if not self.e3MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e3MatchEmbeddedFilterEle32DoubleL1_v2" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle32DoubleL1_v2_branch and "e3MatchEmbeddedFilterEle32DoubleL1_v2":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle32DoubleL1_v2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle32DoubleL1_v2")
        else:
            self.e3MatchEmbeddedFilterEle32DoubleL1_v2_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle32DoubleL1_v2_value)

        #print "making e3MatchEmbeddedFilterEle35"
        self.e3MatchEmbeddedFilterEle35_branch = the_tree.GetBranch("e3MatchEmbeddedFilterEle35")
        #if not self.e3MatchEmbeddedFilterEle35_branch and "e3MatchEmbeddedFilterEle35" not in self.complained:
        if not self.e3MatchEmbeddedFilterEle35_branch and "e3MatchEmbeddedFilterEle35":
            warnings.warn( "EEETree: Expected branch e3MatchEmbeddedFilterEle35 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchEmbeddedFilterEle35")
        else:
            self.e3MatchEmbeddedFilterEle35_branch.SetAddress(<void*>&self.e3MatchEmbeddedFilterEle35_value)

        #print "making e3MatchesEle24HPSTau30Filter"
        self.e3MatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("e3MatchesEle24HPSTau30Filter")
        #if not self.e3MatchesEle24HPSTau30Filter_branch and "e3MatchesEle24HPSTau30Filter" not in self.complained:
        if not self.e3MatchesEle24HPSTau30Filter_branch and "e3MatchesEle24HPSTau30Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle24HPSTau30Filter")
        else:
            self.e3MatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.e3MatchesEle24HPSTau30Filter_value)

        #print "making e3MatchesEle24HPSTau30Path"
        self.e3MatchesEle24HPSTau30Path_branch = the_tree.GetBranch("e3MatchesEle24HPSTau30Path")
        #if not self.e3MatchesEle24HPSTau30Path_branch and "e3MatchesEle24HPSTau30Path" not in self.complained:
        if not self.e3MatchesEle24HPSTau30Path_branch and "e3MatchesEle24HPSTau30Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle24HPSTau30Path")
        else:
            self.e3MatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.e3MatchesEle24HPSTau30Path_value)

        #print "making e3MatchesEle24Tau30Filter"
        self.e3MatchesEle24Tau30Filter_branch = the_tree.GetBranch("e3MatchesEle24Tau30Filter")
        #if not self.e3MatchesEle24Tau30Filter_branch and "e3MatchesEle24Tau30Filter" not in self.complained:
        if not self.e3MatchesEle24Tau30Filter_branch and "e3MatchesEle24Tau30Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle24Tau30Filter")
        else:
            self.e3MatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.e3MatchesEle24Tau30Filter_value)

        #print "making e3MatchesEle24Tau30Path"
        self.e3MatchesEle24Tau30Path_branch = the_tree.GetBranch("e3MatchesEle24Tau30Path")
        #if not self.e3MatchesEle24Tau30Path_branch and "e3MatchesEle24Tau30Path" not in self.complained:
        if not self.e3MatchesEle24Tau30Path_branch and "e3MatchesEle24Tau30Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle24Tau30Path")
        else:
            self.e3MatchesEle24Tau30Path_branch.SetAddress(<void*>&self.e3MatchesEle24Tau30Path_value)

        #print "making e3MatchesEle25Filter"
        self.e3MatchesEle25Filter_branch = the_tree.GetBranch("e3MatchesEle25Filter")
        #if not self.e3MatchesEle25Filter_branch and "e3MatchesEle25Filter" not in self.complained:
        if not self.e3MatchesEle25Filter_branch and "e3MatchesEle25Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle25Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle25Filter")
        else:
            self.e3MatchesEle25Filter_branch.SetAddress(<void*>&self.e3MatchesEle25Filter_value)

        #print "making e3MatchesEle25Path"
        self.e3MatchesEle25Path_branch = the_tree.GetBranch("e3MatchesEle25Path")
        #if not self.e3MatchesEle25Path_branch and "e3MatchesEle25Path" not in self.complained:
        if not self.e3MatchesEle25Path_branch and "e3MatchesEle25Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle25Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle25Path")
        else:
            self.e3MatchesEle25Path_branch.SetAddress(<void*>&self.e3MatchesEle25Path_value)

        #print "making e3MatchesEle27Filter"
        self.e3MatchesEle27Filter_branch = the_tree.GetBranch("e3MatchesEle27Filter")
        #if not self.e3MatchesEle27Filter_branch and "e3MatchesEle27Filter" not in self.complained:
        if not self.e3MatchesEle27Filter_branch and "e3MatchesEle27Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle27Filter")
        else:
            self.e3MatchesEle27Filter_branch.SetAddress(<void*>&self.e3MatchesEle27Filter_value)

        #print "making e3MatchesEle27Path"
        self.e3MatchesEle27Path_branch = the_tree.GetBranch("e3MatchesEle27Path")
        #if not self.e3MatchesEle27Path_branch and "e3MatchesEle27Path" not in self.complained:
        if not self.e3MatchesEle27Path_branch and "e3MatchesEle27Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle27Path")
        else:
            self.e3MatchesEle27Path_branch.SetAddress(<void*>&self.e3MatchesEle27Path_value)

        #print "making e3MatchesEle32Filter"
        self.e3MatchesEle32Filter_branch = the_tree.GetBranch("e3MatchesEle32Filter")
        #if not self.e3MatchesEle32Filter_branch and "e3MatchesEle32Filter" not in self.complained:
        if not self.e3MatchesEle32Filter_branch and "e3MatchesEle32Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle32Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle32Filter")
        else:
            self.e3MatchesEle32Filter_branch.SetAddress(<void*>&self.e3MatchesEle32Filter_value)

        #print "making e3MatchesEle32Path"
        self.e3MatchesEle32Path_branch = the_tree.GetBranch("e3MatchesEle32Path")
        #if not self.e3MatchesEle32Path_branch and "e3MatchesEle32Path" not in self.complained:
        if not self.e3MatchesEle32Path_branch and "e3MatchesEle32Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle32Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle32Path")
        else:
            self.e3MatchesEle32Path_branch.SetAddress(<void*>&self.e3MatchesEle32Path_value)

        #print "making e3MatchesEle35Filter"
        self.e3MatchesEle35Filter_branch = the_tree.GetBranch("e3MatchesEle35Filter")
        #if not self.e3MatchesEle35Filter_branch and "e3MatchesEle35Filter" not in self.complained:
        if not self.e3MatchesEle35Filter_branch and "e3MatchesEle35Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesEle35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle35Filter")
        else:
            self.e3MatchesEle35Filter_branch.SetAddress(<void*>&self.e3MatchesEle35Filter_value)

        #print "making e3MatchesEle35Path"
        self.e3MatchesEle35Path_branch = the_tree.GetBranch("e3MatchesEle35Path")
        #if not self.e3MatchesEle35Path_branch and "e3MatchesEle35Path" not in self.complained:
        if not self.e3MatchesEle35Path_branch and "e3MatchesEle35Path":
            warnings.warn( "EEETree: Expected branch e3MatchesEle35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesEle35Path")
        else:
            self.e3MatchesEle35Path_branch.SetAddress(<void*>&self.e3MatchesEle35Path_value)

        #print "making e3MatchesMu23e12DZFilter"
        self.e3MatchesMu23e12DZFilter_branch = the_tree.GetBranch("e3MatchesMu23e12DZFilter")
        #if not self.e3MatchesMu23e12DZFilter_branch and "e3MatchesMu23e12DZFilter" not in self.complained:
        if not self.e3MatchesMu23e12DZFilter_branch and "e3MatchesMu23e12DZFilter":
            warnings.warn( "EEETree: Expected branch e3MatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu23e12DZFilter")
        else:
            self.e3MatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.e3MatchesMu23e12DZFilter_value)

        #print "making e3MatchesMu23e12DZPath"
        self.e3MatchesMu23e12DZPath_branch = the_tree.GetBranch("e3MatchesMu23e12DZPath")
        #if not self.e3MatchesMu23e12DZPath_branch and "e3MatchesMu23e12DZPath" not in self.complained:
        if not self.e3MatchesMu23e12DZPath_branch and "e3MatchesMu23e12DZPath":
            warnings.warn( "EEETree: Expected branch e3MatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu23e12DZPath")
        else:
            self.e3MatchesMu23e12DZPath_branch.SetAddress(<void*>&self.e3MatchesMu23e12DZPath_value)

        #print "making e3MatchesMu23e12Filter"
        self.e3MatchesMu23e12Filter_branch = the_tree.GetBranch("e3MatchesMu23e12Filter")
        #if not self.e3MatchesMu23e12Filter_branch and "e3MatchesMu23e12Filter" not in self.complained:
        if not self.e3MatchesMu23e12Filter_branch and "e3MatchesMu23e12Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu23e12Filter")
        else:
            self.e3MatchesMu23e12Filter_branch.SetAddress(<void*>&self.e3MatchesMu23e12Filter_value)

        #print "making e3MatchesMu23e12Path"
        self.e3MatchesMu23e12Path_branch = the_tree.GetBranch("e3MatchesMu23e12Path")
        #if not self.e3MatchesMu23e12Path_branch and "e3MatchesMu23e12Path" not in self.complained:
        if not self.e3MatchesMu23e12Path_branch and "e3MatchesMu23e12Path":
            warnings.warn( "EEETree: Expected branch e3MatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu23e12Path")
        else:
            self.e3MatchesMu23e12Path_branch.SetAddress(<void*>&self.e3MatchesMu23e12Path_value)

        #print "making e3MatchesMu8e23DZFilter"
        self.e3MatchesMu8e23DZFilter_branch = the_tree.GetBranch("e3MatchesMu8e23DZFilter")
        #if not self.e3MatchesMu8e23DZFilter_branch and "e3MatchesMu8e23DZFilter" not in self.complained:
        if not self.e3MatchesMu8e23DZFilter_branch and "e3MatchesMu8e23DZFilter":
            warnings.warn( "EEETree: Expected branch e3MatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8e23DZFilter")
        else:
            self.e3MatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.e3MatchesMu8e23DZFilter_value)

        #print "making e3MatchesMu8e23DZPath"
        self.e3MatchesMu8e23DZPath_branch = the_tree.GetBranch("e3MatchesMu8e23DZPath")
        #if not self.e3MatchesMu8e23DZPath_branch and "e3MatchesMu8e23DZPath" not in self.complained:
        if not self.e3MatchesMu8e23DZPath_branch and "e3MatchesMu8e23DZPath":
            warnings.warn( "EEETree: Expected branch e3MatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8e23DZPath")
        else:
            self.e3MatchesMu8e23DZPath_branch.SetAddress(<void*>&self.e3MatchesMu8e23DZPath_value)

        #print "making e3MatchesMu8e23Filter"
        self.e3MatchesMu8e23Filter_branch = the_tree.GetBranch("e3MatchesMu8e23Filter")
        #if not self.e3MatchesMu8e23Filter_branch and "e3MatchesMu8e23Filter" not in self.complained:
        if not self.e3MatchesMu8e23Filter_branch and "e3MatchesMu8e23Filter":
            warnings.warn( "EEETree: Expected branch e3MatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8e23Filter")
        else:
            self.e3MatchesMu8e23Filter_branch.SetAddress(<void*>&self.e3MatchesMu8e23Filter_value)

        #print "making e3MatchesMu8e23Path"
        self.e3MatchesMu8e23Path_branch = the_tree.GetBranch("e3MatchesMu8e23Path")
        #if not self.e3MatchesMu8e23Path_branch and "e3MatchesMu8e23Path" not in self.complained:
        if not self.e3MatchesMu8e23Path_branch and "e3MatchesMu8e23Path":
            warnings.warn( "EEETree: Expected branch e3MatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MatchesMu8e23Path")
        else:
            self.e3MatchesMu8e23Path_branch.SetAddress(<void*>&self.e3MatchesMu8e23Path_value)

        #print "making e3MissingHits"
        self.e3MissingHits_branch = the_tree.GetBranch("e3MissingHits")
        #if not self.e3MissingHits_branch and "e3MissingHits" not in self.complained:
        if not self.e3MissingHits_branch and "e3MissingHits":
            warnings.warn( "EEETree: Expected branch e3MissingHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3MissingHits")
        else:
            self.e3MissingHits_branch.SetAddress(<void*>&self.e3MissingHits_value)

        #print "making e3NearMuonVeto"
        self.e3NearMuonVeto_branch = the_tree.GetBranch("e3NearMuonVeto")
        #if not self.e3NearMuonVeto_branch and "e3NearMuonVeto" not in self.complained:
        if not self.e3NearMuonVeto_branch and "e3NearMuonVeto":
            warnings.warn( "EEETree: Expected branch e3NearMuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3NearMuonVeto")
        else:
            self.e3NearMuonVeto_branch.SetAddress(<void*>&self.e3NearMuonVeto_value)

        #print "making e3NearestMuonDR"
        self.e3NearestMuonDR_branch = the_tree.GetBranch("e3NearestMuonDR")
        #if not self.e3NearestMuonDR_branch and "e3NearestMuonDR" not in self.complained:
        if not self.e3NearestMuonDR_branch and "e3NearestMuonDR":
            warnings.warn( "EEETree: Expected branch e3NearestMuonDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3NearestMuonDR")
        else:
            self.e3NearestMuonDR_branch.SetAddress(<void*>&self.e3NearestMuonDR_value)

        #print "making e3NearestZMass"
        self.e3NearestZMass_branch = the_tree.GetBranch("e3NearestZMass")
        #if not self.e3NearestZMass_branch and "e3NearestZMass" not in self.complained:
        if not self.e3NearestZMass_branch and "e3NearestZMass":
            warnings.warn( "EEETree: Expected branch e3NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3NearestZMass")
        else:
            self.e3NearestZMass_branch.SetAddress(<void*>&self.e3NearestZMass_value)

        #print "making e3PFChargedIso"
        self.e3PFChargedIso_branch = the_tree.GetBranch("e3PFChargedIso")
        #if not self.e3PFChargedIso_branch and "e3PFChargedIso" not in self.complained:
        if not self.e3PFChargedIso_branch and "e3PFChargedIso":
            warnings.warn( "EEETree: Expected branch e3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFChargedIso")
        else:
            self.e3PFChargedIso_branch.SetAddress(<void*>&self.e3PFChargedIso_value)

        #print "making e3PFNeutralIso"
        self.e3PFNeutralIso_branch = the_tree.GetBranch("e3PFNeutralIso")
        #if not self.e3PFNeutralIso_branch and "e3PFNeutralIso" not in self.complained:
        if not self.e3PFNeutralIso_branch and "e3PFNeutralIso":
            warnings.warn( "EEETree: Expected branch e3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFNeutralIso")
        else:
            self.e3PFNeutralIso_branch.SetAddress(<void*>&self.e3PFNeutralIso_value)

        #print "making e3PFPUChargedIso"
        self.e3PFPUChargedIso_branch = the_tree.GetBranch("e3PFPUChargedIso")
        #if not self.e3PFPUChargedIso_branch and "e3PFPUChargedIso" not in self.complained:
        if not self.e3PFPUChargedIso_branch and "e3PFPUChargedIso":
            warnings.warn( "EEETree: Expected branch e3PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFPUChargedIso")
        else:
            self.e3PFPUChargedIso_branch.SetAddress(<void*>&self.e3PFPUChargedIso_value)

        #print "making e3PFPhotonIso"
        self.e3PFPhotonIso_branch = the_tree.GetBranch("e3PFPhotonIso")
        #if not self.e3PFPhotonIso_branch and "e3PFPhotonIso" not in self.complained:
        if not self.e3PFPhotonIso_branch and "e3PFPhotonIso":
            warnings.warn( "EEETree: Expected branch e3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PFPhotonIso")
        else:
            self.e3PFPhotonIso_branch.SetAddress(<void*>&self.e3PFPhotonIso_value)

        #print "making e3PVDXY"
        self.e3PVDXY_branch = the_tree.GetBranch("e3PVDXY")
        #if not self.e3PVDXY_branch and "e3PVDXY" not in self.complained:
        if not self.e3PVDXY_branch and "e3PVDXY":
            warnings.warn( "EEETree: Expected branch e3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PVDXY")
        else:
            self.e3PVDXY_branch.SetAddress(<void*>&self.e3PVDXY_value)

        #print "making e3PVDZ"
        self.e3PVDZ_branch = the_tree.GetBranch("e3PVDZ")
        #if not self.e3PVDZ_branch and "e3PVDZ" not in self.complained:
        if not self.e3PVDZ_branch and "e3PVDZ":
            warnings.warn( "EEETree: Expected branch e3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PVDZ")
        else:
            self.e3PVDZ_branch.SetAddress(<void*>&self.e3PVDZ_value)

        #print "making e3PassesConversionVeto"
        self.e3PassesConversionVeto_branch = the_tree.GetBranch("e3PassesConversionVeto")
        #if not self.e3PassesConversionVeto_branch and "e3PassesConversionVeto" not in self.complained:
        if not self.e3PassesConversionVeto_branch and "e3PassesConversionVeto":
            warnings.warn( "EEETree: Expected branch e3PassesConversionVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3PassesConversionVeto")
        else:
            self.e3PassesConversionVeto_branch.SetAddress(<void*>&self.e3PassesConversionVeto_value)

        #print "making e3Phi"
        self.e3Phi_branch = the_tree.GetBranch("e3Phi")
        #if not self.e3Phi_branch and "e3Phi" not in self.complained:
        if not self.e3Phi_branch and "e3Phi":
            warnings.warn( "EEETree: Expected branch e3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Phi")
        else:
            self.e3Phi_branch.SetAddress(<void*>&self.e3Phi_value)

        #print "making e3Pt"
        self.e3Pt_branch = the_tree.GetBranch("e3Pt")
        #if not self.e3Pt_branch and "e3Pt" not in self.complained:
        if not self.e3Pt_branch and "e3Pt":
            warnings.warn( "EEETree: Expected branch e3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Pt")
        else:
            self.e3Pt_branch.SetAddress(<void*>&self.e3Pt_value)

        #print "making e3RelIso"
        self.e3RelIso_branch = the_tree.GetBranch("e3RelIso")
        #if not self.e3RelIso_branch and "e3RelIso" not in self.complained:
        if not self.e3RelIso_branch and "e3RelIso":
            warnings.warn( "EEETree: Expected branch e3RelIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelIso")
        else:
            self.e3RelIso_branch.SetAddress(<void*>&self.e3RelIso_value)

        #print "making e3RelPFIsoDB"
        self.e3RelPFIsoDB_branch = the_tree.GetBranch("e3RelPFIsoDB")
        #if not self.e3RelPFIsoDB_branch and "e3RelPFIsoDB" not in self.complained:
        if not self.e3RelPFIsoDB_branch and "e3RelPFIsoDB":
            warnings.warn( "EEETree: Expected branch e3RelPFIsoDB does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelPFIsoDB")
        else:
            self.e3RelPFIsoDB_branch.SetAddress(<void*>&self.e3RelPFIsoDB_value)

        #print "making e3RelPFIsoRho"
        self.e3RelPFIsoRho_branch = the_tree.GetBranch("e3RelPFIsoRho")
        #if not self.e3RelPFIsoRho_branch and "e3RelPFIsoRho" not in self.complained:
        if not self.e3RelPFIsoRho_branch and "e3RelPFIsoRho":
            warnings.warn( "EEETree: Expected branch e3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3RelPFIsoRho")
        else:
            self.e3RelPFIsoRho_branch.SetAddress(<void*>&self.e3RelPFIsoRho_value)

        #print "making e3Rho"
        self.e3Rho_branch = the_tree.GetBranch("e3Rho")
        #if not self.e3Rho_branch and "e3Rho" not in self.complained:
        if not self.e3Rho_branch and "e3Rho":
            warnings.warn( "EEETree: Expected branch e3Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3Rho")
        else:
            self.e3Rho_branch.SetAddress(<void*>&self.e3Rho_value)

        #print "making e3SIP2D"
        self.e3SIP2D_branch = the_tree.GetBranch("e3SIP2D")
        #if not self.e3SIP2D_branch and "e3SIP2D" not in self.complained:
        if not self.e3SIP2D_branch and "e3SIP2D":
            warnings.warn( "EEETree: Expected branch e3SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SIP2D")
        else:
            self.e3SIP2D_branch.SetAddress(<void*>&self.e3SIP2D_value)

        #print "making e3SIP3D"
        self.e3SIP3D_branch = the_tree.GetBranch("e3SIP3D")
        #if not self.e3SIP3D_branch and "e3SIP3D" not in self.complained:
        if not self.e3SIP3D_branch and "e3SIP3D":
            warnings.warn( "EEETree: Expected branch e3SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3SIP3D")
        else:
            self.e3SIP3D_branch.SetAddress(<void*>&self.e3SIP3D_value)

        #print "making e3TrkIsoDR03"
        self.e3TrkIsoDR03_branch = the_tree.GetBranch("e3TrkIsoDR03")
        #if not self.e3TrkIsoDR03_branch and "e3TrkIsoDR03" not in self.complained:
        if not self.e3TrkIsoDR03_branch and "e3TrkIsoDR03":
            warnings.warn( "EEETree: Expected branch e3TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3TrkIsoDR03")
        else:
            self.e3TrkIsoDR03_branch.SetAddress(<void*>&self.e3TrkIsoDR03_value)

        #print "making e3VZ"
        self.e3VZ_branch = the_tree.GetBranch("e3VZ")
        #if not self.e3VZ_branch and "e3VZ" not in self.complained:
        if not self.e3VZ_branch and "e3VZ":
            warnings.warn( "EEETree: Expected branch e3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3VZ")
        else:
            self.e3VZ_branch.SetAddress(<void*>&self.e3VZ_value)

        #print "making e3ZTTGenMatching"
        self.e3ZTTGenMatching_branch = the_tree.GetBranch("e3ZTTGenMatching")
        #if not self.e3ZTTGenMatching_branch and "e3ZTTGenMatching" not in self.complained:
        if not self.e3ZTTGenMatching_branch and "e3ZTTGenMatching":
            warnings.warn( "EEETree: Expected branch e3ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ZTTGenMatching")
        else:
            self.e3ZTTGenMatching_branch.SetAddress(<void*>&self.e3ZTTGenMatching_value)

        #print "making e3ecalEnergy"
        self.e3ecalEnergy_branch = the_tree.GetBranch("e3ecalEnergy")
        #if not self.e3ecalEnergy_branch and "e3ecalEnergy" not in self.complained:
        if not self.e3ecalEnergy_branch and "e3ecalEnergy":
            warnings.warn( "EEETree: Expected branch e3ecalEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e3ecalEnergy")
        else:
            self.e3ecalEnergy_branch.SetAddress(<void*>&self.e3ecalEnergy_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "EEETree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "EEETree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EEETree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "EEETree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "EEETree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EEETree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "EEETree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "EEETree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EEETree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EEETree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EEETree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "EEETree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "EEETree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "EEETree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "EEETree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "EEETree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "EEETree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "EEETree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "EEETree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "EEETree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "EEETree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "EEETree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "EEETree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "EEETree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "EEETree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "EEETree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "EEETree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "EEETree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "EEETree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "EEETree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "EEETree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "EEETree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "EEETree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "EEETree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "EEETree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "EEETree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "EEETree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "EEETree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "EEETree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "EEETree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "EEETree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "EEETree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "EEETree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "EEETree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "EEETree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "EEETree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "EEETree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "EEETree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "EEETree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "EEETree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "EEETree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "EEETree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "EEETree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "EEETree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "EEETree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "EEETree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "EEETree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "EEETree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "EEETree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "EEETree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "EEETree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetEnDown"
        self.jetVeto30WoNoisyJets_JetEnDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnDown")
        #if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown":
            warnings.warn( "EEETree: Expected branch jetVeto30WoNoisyJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnDown")
        else:
            self.jetVeto30WoNoisyJets_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnDown_value)

        #print "making jetVeto30WoNoisyJets_JetEnUp"
        self.jetVeto30WoNoisyJets_JetEnUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnUp")
        #if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp":
            warnings.warn( "EEETree: Expected branch jetVeto30WoNoisyJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnUp")
        else:
            self.jetVeto30WoNoisyJets_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "EEETree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "EEETree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EEETree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EEETree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EEETree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EEETree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EEETree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EEETree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "EEETree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "EEETree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "EEETree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "EEETree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "EEETree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "EEETree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "EEETree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "EEETree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "EEETree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "EEETree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "EEETree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "EEETree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EEETree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "EEETree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "EEETree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making prefiring_weight_down"
        self.prefiring_weight_down_branch = the_tree.GetBranch("prefiring_weight_down")
        #if not self.prefiring_weight_down_branch and "prefiring_weight_down" not in self.complained:
        if not self.prefiring_weight_down_branch and "prefiring_weight_down":
            warnings.warn( "EEETree: Expected branch prefiring_weight_down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_down")
        else:
            self.prefiring_weight_down_branch.SetAddress(<void*>&self.prefiring_weight_down_value)

        #print "making prefiring_weight_up"
        self.prefiring_weight_up_branch = the_tree.GetBranch("prefiring_weight_up")
        #if not self.prefiring_weight_up_branch and "prefiring_weight_up" not in self.complained:
        if not self.prefiring_weight_up_branch and "prefiring_weight_up":
            warnings.warn( "EEETree: Expected branch prefiring_weight_up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_up")
        else:
            self.prefiring_weight_up_branch.SetAddress(<void*>&self.prefiring_weight_up_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "EEETree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "EEETree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "EEETree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "EEETree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "EEETree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "EEETree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "EEETree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "EEETree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "EEETree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "EEETree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "EEETree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "EEETree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "EEETree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "EEETree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "EEETree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "EEETree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "EEETree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "EEETree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EEETree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "EEETree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "EEETree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "EEETree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "EEETree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "EEETree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "EEETree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "EEETree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "EEETree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "EEETree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "EEETree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "EEETree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "EEETree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "EEETree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "EEETree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "EEETree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "EEETree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "EEETree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "EEETree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "EEETree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "EEETree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "EEETree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "EEETree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "EEETree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "EEETree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "EEETree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "EEETree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "EEETree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "EEETree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EEETree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EEETree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "EEETree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property SingleTau180MediumPass:
        def __get__(self):
            self.SingleTau180MediumPass_branch.GetEntry(self.localentry, 0)
            return self.SingleTau180MediumPass_value

    property SingleTau200MediumPass:
        def __get__(self):
            self.SingleTau200MediumPass_branch.GetEntry(self.localentry, 0)
            return self.SingleTau200MediumPass_value

    property SingleTau220MediumPass:
        def __get__(self):
            self.SingleTau220MediumPass_branch.GetEntry(self.localentry, 0)
            return self.SingleTau220MediumPass_value

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

    property e1_e3_DR:
        def __get__(self):
            self.e1_e3_DR_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_DR_value

    property e1_e3_Mass:
        def __get__(self):
            self.e1_e3_Mass_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_Mass_value

    property e1_e3_PZeta:
        def __get__(self):
            self.e1_e3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_PZeta_value

    property e1_e3_PZetaVis:
        def __get__(self):
            self.e1_e3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_PZetaVis_value

    property e1_e3_doubleL1IsoTauMatch:
        def __get__(self):
            self.e1_e3_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e1_e3_doubleL1IsoTauMatch_value

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

    property e2_e3_DR:
        def __get__(self):
            self.e2_e3_DR_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_DR_value

    property e2_e3_Mass:
        def __get__(self):
            self.e2_e3_Mass_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_Mass_value

    property e2_e3_PZeta:
        def __get__(self):
            self.e2_e3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_PZeta_value

    property e2_e3_PZetaVis:
        def __get__(self):
            self.e2_e3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_PZetaVis_value

    property e2_e3_doubleL1IsoTauMatch:
        def __get__(self):
            self.e2_e3_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.e2_e3_doubleL1IsoTauMatch_value

    property e2ecalEnergy:
        def __get__(self):
            self.e2ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e2ecalEnergy_value

    property e3Charge:
        def __get__(self):
            self.e3Charge_branch.GetEntry(self.localentry, 0)
            return self.e3Charge_value

    property e3ChargeIdLoose:
        def __get__(self):
            self.e3ChargeIdLoose_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdLoose_value

    property e3ChargeIdMed:
        def __get__(self):
            self.e3ChargeIdMed_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdMed_value

    property e3ChargeIdTight:
        def __get__(self):
            self.e3ChargeIdTight_branch.GetEntry(self.localentry, 0)
            return self.e3ChargeIdTight_value

    property e3ComesFromHiggs:
        def __get__(self):
            self.e3ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.e3ComesFromHiggs_value

    property e3CorrectedEt:
        def __get__(self):
            self.e3CorrectedEt_branch.GetEntry(self.localentry, 0)
            return self.e3CorrectedEt_value

    property e3EcalIsoDR03:
        def __get__(self):
            self.e3EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3EcalIsoDR03_value

    property e3EnergyError:
        def __get__(self):
            self.e3EnergyError_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyError_value

    property e3EnergyScaleDown:
        def __get__(self):
            self.e3EnergyScaleDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleDown_value

    property e3EnergyScaleGainDown:
        def __get__(self):
            self.e3EnergyScaleGainDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleGainDown_value

    property e3EnergyScaleGainUp:
        def __get__(self):
            self.e3EnergyScaleGainUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleGainUp_value

    property e3EnergyScaleStatDown:
        def __get__(self):
            self.e3EnergyScaleStatDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleStatDown_value

    property e3EnergyScaleStatUp:
        def __get__(self):
            self.e3EnergyScaleStatUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleStatUp_value

    property e3EnergyScaleSystDown:
        def __get__(self):
            self.e3EnergyScaleSystDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleSystDown_value

    property e3EnergyScaleSystUp:
        def __get__(self):
            self.e3EnergyScaleSystUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleSystUp_value

    property e3EnergyScaleUp:
        def __get__(self):
            self.e3EnergyScaleUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergyScaleUp_value

    property e3EnergySigmaDown:
        def __get__(self):
            self.e3EnergySigmaDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaDown_value

    property e3EnergySigmaPhiDown:
        def __get__(self):
            self.e3EnergySigmaPhiDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaPhiDown_value

    property e3EnergySigmaPhiUp:
        def __get__(self):
            self.e3EnergySigmaPhiUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaPhiUp_value

    property e3EnergySigmaRhoDown:
        def __get__(self):
            self.e3EnergySigmaRhoDown_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaRhoDown_value

    property e3EnergySigmaRhoUp:
        def __get__(self):
            self.e3EnergySigmaRhoUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaRhoUp_value

    property e3EnergySigmaUp:
        def __get__(self):
            self.e3EnergySigmaUp_branch.GetEntry(self.localentry, 0)
            return self.e3EnergySigmaUp_value

    property e3Eta:
        def __get__(self):
            self.e3Eta_branch.GetEntry(self.localentry, 0)
            return self.e3Eta_value

    property e3GenCharge:
        def __get__(self):
            self.e3GenCharge_branch.GetEntry(self.localentry, 0)
            return self.e3GenCharge_value

    property e3GenDirectPromptTauDecay:
        def __get__(self):
            self.e3GenDirectPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e3GenDirectPromptTauDecay_value

    property e3GenEnergy:
        def __get__(self):
            self.e3GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3GenEnergy_value

    property e3GenEta:
        def __get__(self):
            self.e3GenEta_branch.GetEntry(self.localentry, 0)
            return self.e3GenEta_value

    property e3GenIsPrompt:
        def __get__(self):
            self.e3GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.e3GenIsPrompt_value

    property e3GenMotherPdgId:
        def __get__(self):
            self.e3GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.e3GenMotherPdgId_value

    property e3GenParticle:
        def __get__(self):
            self.e3GenParticle_branch.GetEntry(self.localentry, 0)
            return self.e3GenParticle_value

    property e3GenPdgId:
        def __get__(self):
            self.e3GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.e3GenPdgId_value

    property e3GenPhi:
        def __get__(self):
            self.e3GenPhi_branch.GetEntry(self.localentry, 0)
            return self.e3GenPhi_value

    property e3GenPrompt:
        def __get__(self):
            self.e3GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.e3GenPrompt_value

    property e3GenPromptTauDecay:
        def __get__(self):
            self.e3GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e3GenPromptTauDecay_value

    property e3GenPt:
        def __get__(self):
            self.e3GenPt_branch.GetEntry(self.localentry, 0)
            return self.e3GenPt_value

    property e3GenTauDecay:
        def __get__(self):
            self.e3GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.e3GenTauDecay_value

    property e3GenVZ:
        def __get__(self):
            self.e3GenVZ_branch.GetEntry(self.localentry, 0)
            return self.e3GenVZ_value

    property e3GenVtxPVMatch:
        def __get__(self):
            self.e3GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.e3GenVtxPVMatch_value

    property e3HcalIsoDR03:
        def __get__(self):
            self.e3HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3HcalIsoDR03_value

    property e3IP3D:
        def __get__(self):
            self.e3IP3D_branch.GetEntry(self.localentry, 0)
            return self.e3IP3D_value

    property e3IP3DErr:
        def __get__(self):
            self.e3IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.e3IP3DErr_value

    property e3IsoDB03:
        def __get__(self):
            self.e3IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.e3IsoDB03_value

    property e3JetArea:
        def __get__(self):
            self.e3JetArea_branch.GetEntry(self.localentry, 0)
            return self.e3JetArea_value

    property e3JetBtag:
        def __get__(self):
            self.e3JetBtag_branch.GetEntry(self.localentry, 0)
            return self.e3JetBtag_value

    property e3JetDR:
        def __get__(self):
            self.e3JetDR_branch.GetEntry(self.localentry, 0)
            return self.e3JetDR_value

    property e3JetEtaEtaMoment:
        def __get__(self):
            self.e3JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaEtaMoment_value

    property e3JetEtaPhiMoment:
        def __get__(self):
            self.e3JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaPhiMoment_value

    property e3JetEtaPhiSpread:
        def __get__(self):
            self.e3JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.e3JetEtaPhiSpread_value

    property e3JetHadronFlavour:
        def __get__(self):
            self.e3JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.e3JetHadronFlavour_value

    property e3JetPFCISVBtag:
        def __get__(self):
            self.e3JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.e3JetPFCISVBtag_value

    property e3JetPartonFlavour:
        def __get__(self):
            self.e3JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.e3JetPartonFlavour_value

    property e3JetPhiPhiMoment:
        def __get__(self):
            self.e3JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.e3JetPhiPhiMoment_value

    property e3JetPt:
        def __get__(self):
            self.e3JetPt_branch.GetEntry(self.localentry, 0)
            return self.e3JetPt_value

    property e3LowestMll:
        def __get__(self):
            self.e3LowestMll_branch.GetEntry(self.localentry, 0)
            return self.e3LowestMll_value

    property e3MVAIsoWP80:
        def __get__(self):
            self.e3MVAIsoWP80_branch.GetEntry(self.localentry, 0)
            return self.e3MVAIsoWP80_value

    property e3MVAIsoWP90:
        def __get__(self):
            self.e3MVAIsoWP90_branch.GetEntry(self.localentry, 0)
            return self.e3MVAIsoWP90_value

    property e3MVANoisoWP80:
        def __get__(self):
            self.e3MVANoisoWP80_branch.GetEntry(self.localentry, 0)
            return self.e3MVANoisoWP80_value

    property e3MVANoisoWP90:
        def __get__(self):
            self.e3MVANoisoWP90_branch.GetEntry(self.localentry, 0)
            return self.e3MVANoisoWP90_value

    property e3Mass:
        def __get__(self):
            self.e3Mass_branch.GetEntry(self.localentry, 0)
            return self.e3Mass_value

    property e3MatchEmbeddedFilterEle24Tau30:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle24Tau30_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle24Tau30_value

    property e3MatchEmbeddedFilterEle27:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle27_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle27_value

    property e3MatchEmbeddedFilterEle32:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle32_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle32_value

    property e3MatchEmbeddedFilterEle32DoubleL1_v1:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle32DoubleL1_v1_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle32DoubleL1_v1_value

    property e3MatchEmbeddedFilterEle32DoubleL1_v2:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle32DoubleL1_v2_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle32DoubleL1_v2_value

    property e3MatchEmbeddedFilterEle35:
        def __get__(self):
            self.e3MatchEmbeddedFilterEle35_branch.GetEntry(self.localentry, 0)
            return self.e3MatchEmbeddedFilterEle35_value

    property e3MatchesEle24HPSTau30Filter:
        def __get__(self):
            self.e3MatchesEle24HPSTau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle24HPSTau30Filter_value

    property e3MatchesEle24HPSTau30Path:
        def __get__(self):
            self.e3MatchesEle24HPSTau30Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle24HPSTau30Path_value

    property e3MatchesEle24Tau30Filter:
        def __get__(self):
            self.e3MatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle24Tau30Filter_value

    property e3MatchesEle24Tau30Path:
        def __get__(self):
            self.e3MatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle24Tau30Path_value

    property e3MatchesEle25Filter:
        def __get__(self):
            self.e3MatchesEle25Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle25Filter_value

    property e3MatchesEle25Path:
        def __get__(self):
            self.e3MatchesEle25Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle25Path_value

    property e3MatchesEle27Filter:
        def __get__(self):
            self.e3MatchesEle27Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle27Filter_value

    property e3MatchesEle27Path:
        def __get__(self):
            self.e3MatchesEle27Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle27Path_value

    property e3MatchesEle32Filter:
        def __get__(self):
            self.e3MatchesEle32Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle32Filter_value

    property e3MatchesEle32Path:
        def __get__(self):
            self.e3MatchesEle32Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle32Path_value

    property e3MatchesEle35Filter:
        def __get__(self):
            self.e3MatchesEle35Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle35Filter_value

    property e3MatchesEle35Path:
        def __get__(self):
            self.e3MatchesEle35Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesEle35Path_value

    property e3MatchesMu23e12DZFilter:
        def __get__(self):
            self.e3MatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu23e12DZFilter_value

    property e3MatchesMu23e12DZPath:
        def __get__(self):
            self.e3MatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu23e12DZPath_value

    property e3MatchesMu23e12Filter:
        def __get__(self):
            self.e3MatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu23e12Filter_value

    property e3MatchesMu23e12Path:
        def __get__(self):
            self.e3MatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu23e12Path_value

    property e3MatchesMu8e23DZFilter:
        def __get__(self):
            self.e3MatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8e23DZFilter_value

    property e3MatchesMu8e23DZPath:
        def __get__(self):
            self.e3MatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8e23DZPath_value

    property e3MatchesMu8e23Filter:
        def __get__(self):
            self.e3MatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8e23Filter_value

    property e3MatchesMu8e23Path:
        def __get__(self):
            self.e3MatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.e3MatchesMu8e23Path_value

    property e3MissingHits:
        def __get__(self):
            self.e3MissingHits_branch.GetEntry(self.localentry, 0)
            return self.e3MissingHits_value

    property e3NearMuonVeto:
        def __get__(self):
            self.e3NearMuonVeto_branch.GetEntry(self.localentry, 0)
            return self.e3NearMuonVeto_value

    property e3NearestMuonDR:
        def __get__(self):
            self.e3NearestMuonDR_branch.GetEntry(self.localentry, 0)
            return self.e3NearestMuonDR_value

    property e3NearestZMass:
        def __get__(self):
            self.e3NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.e3NearestZMass_value

    property e3PFChargedIso:
        def __get__(self):
            self.e3PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFChargedIso_value

    property e3PFNeutralIso:
        def __get__(self):
            self.e3PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFNeutralIso_value

    property e3PFPUChargedIso:
        def __get__(self):
            self.e3PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFPUChargedIso_value

    property e3PFPhotonIso:
        def __get__(self):
            self.e3PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.e3PFPhotonIso_value

    property e3PVDXY:
        def __get__(self):
            self.e3PVDXY_branch.GetEntry(self.localentry, 0)
            return self.e3PVDXY_value

    property e3PVDZ:
        def __get__(self):
            self.e3PVDZ_branch.GetEntry(self.localentry, 0)
            return self.e3PVDZ_value

    property e3PassesConversionVeto:
        def __get__(self):
            self.e3PassesConversionVeto_branch.GetEntry(self.localentry, 0)
            return self.e3PassesConversionVeto_value

    property e3Phi:
        def __get__(self):
            self.e3Phi_branch.GetEntry(self.localentry, 0)
            return self.e3Phi_value

    property e3Pt:
        def __get__(self):
            self.e3Pt_branch.GetEntry(self.localentry, 0)
            return self.e3Pt_value

    property e3RelIso:
        def __get__(self):
            self.e3RelIso_branch.GetEntry(self.localentry, 0)
            return self.e3RelIso_value

    property e3RelPFIsoDB:
        def __get__(self):
            self.e3RelPFIsoDB_branch.GetEntry(self.localentry, 0)
            return self.e3RelPFIsoDB_value

    property e3RelPFIsoRho:
        def __get__(self):
            self.e3RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.e3RelPFIsoRho_value

    property e3Rho:
        def __get__(self):
            self.e3Rho_branch.GetEntry(self.localentry, 0)
            return self.e3Rho_value

    property e3SIP2D:
        def __get__(self):
            self.e3SIP2D_branch.GetEntry(self.localentry, 0)
            return self.e3SIP2D_value

    property e3SIP3D:
        def __get__(self):
            self.e3SIP3D_branch.GetEntry(self.localentry, 0)
            return self.e3SIP3D_value

    property e3TrkIsoDR03:
        def __get__(self):
            self.e3TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.e3TrkIsoDR03_value

    property e3VZ:
        def __get__(self):
            self.e3VZ_branch.GetEntry(self.localentry, 0)
            return self.e3VZ_value

    property e3ZTTGenMatching:
        def __get__(self):
            self.e3ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.e3ZTTGenMatching_value

    property e3ecalEnergy:
        def __get__(self):
            self.e3ecalEnergy_branch.GetEntry(self.localentry, 0)
            return self.e3ecalEnergy_value

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


