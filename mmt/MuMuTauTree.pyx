

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

cdef class MuMuTauTree:
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

    cdef TBranch* jetVeto30_JetEnDown_branch
    cdef float jetVeto30_JetEnDown_value

    cdef TBranch* jetVeto30_JetEnUp_branch
    cdef float jetVeto30_JetEnUp_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* m1BestTrackType_branch
    cdef float m1BestTrackType_value

    cdef TBranch* m1Charge_branch
    cdef float m1Charge_value

    cdef TBranch* m1Chi2LocalPosition_branch
    cdef float m1Chi2LocalPosition_value

    cdef TBranch* m1ComesFromHiggs_branch
    cdef float m1ComesFromHiggs_value

    cdef TBranch* m1CutBasedIdGlobalHighPt_branch
    cdef float m1CutBasedIdGlobalHighPt_value

    cdef TBranch* m1CutBasedIdLoose_branch
    cdef float m1CutBasedIdLoose_value

    cdef TBranch* m1CutBasedIdMedium_branch
    cdef float m1CutBasedIdMedium_value

    cdef TBranch* m1CutBasedIdMediumPrompt_branch
    cdef float m1CutBasedIdMediumPrompt_value

    cdef TBranch* m1CutBasedIdTight_branch
    cdef float m1CutBasedIdTight_value

    cdef TBranch* m1CutBasedIdTrkHighPt_branch
    cdef float m1CutBasedIdTrkHighPt_value

    cdef TBranch* m1EcalIsoDR03_branch
    cdef float m1EcalIsoDR03_value

    cdef TBranch* m1EffectiveArea2011_branch
    cdef float m1EffectiveArea2011_value

    cdef TBranch* m1EffectiveArea2012_branch
    cdef float m1EffectiveArea2012_value

    cdef TBranch* m1Eta_branch
    cdef float m1Eta_value

    cdef TBranch* m1Eta_MuonEnDown_branch
    cdef float m1Eta_MuonEnDown_value

    cdef TBranch* m1Eta_MuonEnUp_branch
    cdef float m1Eta_MuonEnUp_value

    cdef TBranch* m1GenCharge_branch
    cdef float m1GenCharge_value

    cdef TBranch* m1GenDirectPromptTauDecayFinalState_branch
    cdef float m1GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m1GenEnergy_branch
    cdef float m1GenEnergy_value

    cdef TBranch* m1GenEta_branch
    cdef float m1GenEta_value

    cdef TBranch* m1GenIsPrompt_branch
    cdef float m1GenIsPrompt_value

    cdef TBranch* m1GenMotherPdgId_branch
    cdef float m1GenMotherPdgId_value

    cdef TBranch* m1GenParticle_branch
    cdef float m1GenParticle_value

    cdef TBranch* m1GenPdgId_branch
    cdef float m1GenPdgId_value

    cdef TBranch* m1GenPhi_branch
    cdef float m1GenPhi_value

    cdef TBranch* m1GenPrompt_branch
    cdef float m1GenPrompt_value

    cdef TBranch* m1GenPromptFinalState_branch
    cdef float m1GenPromptFinalState_value

    cdef TBranch* m1GenPromptTauDecay_branch
    cdef float m1GenPromptTauDecay_value

    cdef TBranch* m1GenPt_branch
    cdef float m1GenPt_value

    cdef TBranch* m1GenTauDecay_branch
    cdef float m1GenTauDecay_value

    cdef TBranch* m1GenVZ_branch
    cdef float m1GenVZ_value

    cdef TBranch* m1GenVtxPVMatch_branch
    cdef float m1GenVtxPVMatch_value

    cdef TBranch* m1HcalIsoDR03_branch
    cdef float m1HcalIsoDR03_value

    cdef TBranch* m1IP3D_branch
    cdef float m1IP3D_value

    cdef TBranch* m1IP3DErr_branch
    cdef float m1IP3DErr_value

    cdef TBranch* m1IsGlobal_branch
    cdef float m1IsGlobal_value

    cdef TBranch* m1IsPFMuon_branch
    cdef float m1IsPFMuon_value

    cdef TBranch* m1IsTracker_branch
    cdef float m1IsTracker_value

    cdef TBranch* m1IsoDB03_branch
    cdef float m1IsoDB03_value

    cdef TBranch* m1IsoDB04_branch
    cdef float m1IsoDB04_value

    cdef TBranch* m1JetArea_branch
    cdef float m1JetArea_value

    cdef TBranch* m1JetBtag_branch
    cdef float m1JetBtag_value

    cdef TBranch* m1JetDR_branch
    cdef float m1JetDR_value

    cdef TBranch* m1JetEtaEtaMoment_branch
    cdef float m1JetEtaEtaMoment_value

    cdef TBranch* m1JetEtaPhiMoment_branch
    cdef float m1JetEtaPhiMoment_value

    cdef TBranch* m1JetEtaPhiSpread_branch
    cdef float m1JetEtaPhiSpread_value

    cdef TBranch* m1JetHadronFlavour_branch
    cdef float m1JetHadronFlavour_value

    cdef TBranch* m1JetPFCISVBtag_branch
    cdef float m1JetPFCISVBtag_value

    cdef TBranch* m1JetPartonFlavour_branch
    cdef float m1JetPartonFlavour_value

    cdef TBranch* m1JetPhiPhiMoment_branch
    cdef float m1JetPhiPhiMoment_value

    cdef TBranch* m1JetPt_branch
    cdef float m1JetPt_value

    cdef TBranch* m1LowestMll_branch
    cdef float m1LowestMll_value

    cdef TBranch* m1Mass_branch
    cdef float m1Mass_value

    cdef TBranch* m1MatchedStations_branch
    cdef float m1MatchedStations_value

    cdef TBranch* m1MatchesIsoMu20Tau27Filter_branch
    cdef float m1MatchesIsoMu20Tau27Filter_value

    cdef TBranch* m1MatchesIsoMu20Tau27Path_branch
    cdef float m1MatchesIsoMu20Tau27Path_value

    cdef TBranch* m1MatchesIsoMu24Filter_branch
    cdef float m1MatchesIsoMu24Filter_value

    cdef TBranch* m1MatchesIsoMu24Path_branch
    cdef float m1MatchesIsoMu24Path_value

    cdef TBranch* m1MatchesIsoMu27Filter_branch
    cdef float m1MatchesIsoMu27Filter_value

    cdef TBranch* m1MatchesIsoMu27Path_branch
    cdef float m1MatchesIsoMu27Path_value

    cdef TBranch* m1MiniIsoLoose_branch
    cdef float m1MiniIsoLoose_value

    cdef TBranch* m1MiniIsoMedium_branch
    cdef float m1MiniIsoMedium_value

    cdef TBranch* m1MiniIsoTight_branch
    cdef float m1MiniIsoTight_value

    cdef TBranch* m1MiniIsoVeryTight_branch
    cdef float m1MiniIsoVeryTight_value

    cdef TBranch* m1MuonHits_branch
    cdef float m1MuonHits_value

    cdef TBranch* m1MvaLoose_branch
    cdef float m1MvaLoose_value

    cdef TBranch* m1MvaMedium_branch
    cdef float m1MvaMedium_value

    cdef TBranch* m1MvaTight_branch
    cdef float m1MvaTight_value

    cdef TBranch* m1NearestZMass_branch
    cdef float m1NearestZMass_value

    cdef TBranch* m1NormTrkChi2_branch
    cdef float m1NormTrkChi2_value

    cdef TBranch* m1NormalizedChi2_branch
    cdef float m1NormalizedChi2_value

    cdef TBranch* m1PFChargedHadronIsoR04_branch
    cdef float m1PFChargedHadronIsoR04_value

    cdef TBranch* m1PFChargedIso_branch
    cdef float m1PFChargedIso_value

    cdef TBranch* m1PFIDLoose_branch
    cdef float m1PFIDLoose_value

    cdef TBranch* m1PFIDMedium_branch
    cdef float m1PFIDMedium_value

    cdef TBranch* m1PFIDTight_branch
    cdef float m1PFIDTight_value

    cdef TBranch* m1PFIsoLoose_branch
    cdef float m1PFIsoLoose_value

    cdef TBranch* m1PFIsoMedium_branch
    cdef float m1PFIsoMedium_value

    cdef TBranch* m1PFIsoTight_branch
    cdef float m1PFIsoTight_value

    cdef TBranch* m1PFIsoVeryLoose_branch
    cdef float m1PFIsoVeryLoose_value

    cdef TBranch* m1PFIsoVeryTight_branch
    cdef float m1PFIsoVeryTight_value

    cdef TBranch* m1PFNeutralHadronIsoR04_branch
    cdef float m1PFNeutralHadronIsoR04_value

    cdef TBranch* m1PFNeutralIso_branch
    cdef float m1PFNeutralIso_value

    cdef TBranch* m1PFPUChargedIso_branch
    cdef float m1PFPUChargedIso_value

    cdef TBranch* m1PFPhotonIso_branch
    cdef float m1PFPhotonIso_value

    cdef TBranch* m1PFPhotonIsoR04_branch
    cdef float m1PFPhotonIsoR04_value

    cdef TBranch* m1PFPileupIsoR04_branch
    cdef float m1PFPileupIsoR04_value

    cdef TBranch* m1PVDXY_branch
    cdef float m1PVDXY_value

    cdef TBranch* m1PVDZ_branch
    cdef float m1PVDZ_value

    cdef TBranch* m1Phi_branch
    cdef float m1Phi_value

    cdef TBranch* m1Phi_MuonEnDown_branch
    cdef float m1Phi_MuonEnDown_value

    cdef TBranch* m1Phi_MuonEnUp_branch
    cdef float m1Phi_MuonEnUp_value

    cdef TBranch* m1PixHits_branch
    cdef float m1PixHits_value

    cdef TBranch* m1Pt_branch
    cdef float m1Pt_value

    cdef TBranch* m1Pt_MuonEnDown_branch
    cdef float m1Pt_MuonEnDown_value

    cdef TBranch* m1Pt_MuonEnUp_branch
    cdef float m1Pt_MuonEnUp_value

    cdef TBranch* m1RelPFIsoDBDefault_branch
    cdef float m1RelPFIsoDBDefault_value

    cdef TBranch* m1RelPFIsoDBDefaultR04_branch
    cdef float m1RelPFIsoDBDefaultR04_value

    cdef TBranch* m1RelPFIsoRho_branch
    cdef float m1RelPFIsoRho_value

    cdef TBranch* m1Rho_branch
    cdef float m1Rho_value

    cdef TBranch* m1SIP2D_branch
    cdef float m1SIP2D_value

    cdef TBranch* m1SIP3D_branch
    cdef float m1SIP3D_value

    cdef TBranch* m1SegmentCompatibility_branch
    cdef float m1SegmentCompatibility_value

    cdef TBranch* m1SoftCutBasedId_branch
    cdef float m1SoftCutBasedId_value

    cdef TBranch* m1TkIsoLoose_branch
    cdef float m1TkIsoLoose_value

    cdef TBranch* m1TkIsoTight_branch
    cdef float m1TkIsoTight_value

    cdef TBranch* m1TkLayersWithMeasurement_branch
    cdef float m1TkLayersWithMeasurement_value

    cdef TBranch* m1TrkIsoDR03_branch
    cdef float m1TrkIsoDR03_value

    cdef TBranch* m1TrkKink_branch
    cdef float m1TrkKink_value

    cdef TBranch* m1TypeCode_branch
    cdef int m1TypeCode_value

    cdef TBranch* m1VZ_branch
    cdef float m1VZ_value

    cdef TBranch* m1ValidFraction_branch
    cdef float m1ValidFraction_value

    cdef TBranch* m1ZTTGenMatching_branch
    cdef float m1ZTTGenMatching_value

    cdef TBranch* m1_m2_doubleL1IsoTauMatch_branch
    cdef float m1_m2_doubleL1IsoTauMatch_value

    cdef TBranch* m1_t_doubleL1IsoTauMatch_branch
    cdef float m1_t_doubleL1IsoTauMatch_value

    cdef TBranch* m2BestTrackType_branch
    cdef float m2BestTrackType_value

    cdef TBranch* m2Charge_branch
    cdef float m2Charge_value

    cdef TBranch* m2Chi2LocalPosition_branch
    cdef float m2Chi2LocalPosition_value

    cdef TBranch* m2ComesFromHiggs_branch
    cdef float m2ComesFromHiggs_value

    cdef TBranch* m2CutBasedIdGlobalHighPt_branch
    cdef float m2CutBasedIdGlobalHighPt_value

    cdef TBranch* m2CutBasedIdLoose_branch
    cdef float m2CutBasedIdLoose_value

    cdef TBranch* m2CutBasedIdMedium_branch
    cdef float m2CutBasedIdMedium_value

    cdef TBranch* m2CutBasedIdMediumPrompt_branch
    cdef float m2CutBasedIdMediumPrompt_value

    cdef TBranch* m2CutBasedIdTight_branch
    cdef float m2CutBasedIdTight_value

    cdef TBranch* m2CutBasedIdTrkHighPt_branch
    cdef float m2CutBasedIdTrkHighPt_value

    cdef TBranch* m2EcalIsoDR03_branch
    cdef float m2EcalIsoDR03_value

    cdef TBranch* m2EffectiveArea2011_branch
    cdef float m2EffectiveArea2011_value

    cdef TBranch* m2EffectiveArea2012_branch
    cdef float m2EffectiveArea2012_value

    cdef TBranch* m2Eta_branch
    cdef float m2Eta_value

    cdef TBranch* m2Eta_MuonEnDown_branch
    cdef float m2Eta_MuonEnDown_value

    cdef TBranch* m2Eta_MuonEnUp_branch
    cdef float m2Eta_MuonEnUp_value

    cdef TBranch* m2GenCharge_branch
    cdef float m2GenCharge_value

    cdef TBranch* m2GenDirectPromptTauDecayFinalState_branch
    cdef float m2GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m2GenEnergy_branch
    cdef float m2GenEnergy_value

    cdef TBranch* m2GenEta_branch
    cdef float m2GenEta_value

    cdef TBranch* m2GenIsPrompt_branch
    cdef float m2GenIsPrompt_value

    cdef TBranch* m2GenMotherPdgId_branch
    cdef float m2GenMotherPdgId_value

    cdef TBranch* m2GenParticle_branch
    cdef float m2GenParticle_value

    cdef TBranch* m2GenPdgId_branch
    cdef float m2GenPdgId_value

    cdef TBranch* m2GenPhi_branch
    cdef float m2GenPhi_value

    cdef TBranch* m2GenPrompt_branch
    cdef float m2GenPrompt_value

    cdef TBranch* m2GenPromptFinalState_branch
    cdef float m2GenPromptFinalState_value

    cdef TBranch* m2GenPromptTauDecay_branch
    cdef float m2GenPromptTauDecay_value

    cdef TBranch* m2GenPt_branch
    cdef float m2GenPt_value

    cdef TBranch* m2GenTauDecay_branch
    cdef float m2GenTauDecay_value

    cdef TBranch* m2GenVZ_branch
    cdef float m2GenVZ_value

    cdef TBranch* m2GenVtxPVMatch_branch
    cdef float m2GenVtxPVMatch_value

    cdef TBranch* m2HcalIsoDR03_branch
    cdef float m2HcalIsoDR03_value

    cdef TBranch* m2IP3D_branch
    cdef float m2IP3D_value

    cdef TBranch* m2IP3DErr_branch
    cdef float m2IP3DErr_value

    cdef TBranch* m2IsGlobal_branch
    cdef float m2IsGlobal_value

    cdef TBranch* m2IsPFMuon_branch
    cdef float m2IsPFMuon_value

    cdef TBranch* m2IsTracker_branch
    cdef float m2IsTracker_value

    cdef TBranch* m2IsoDB03_branch
    cdef float m2IsoDB03_value

    cdef TBranch* m2IsoDB04_branch
    cdef float m2IsoDB04_value

    cdef TBranch* m2JetArea_branch
    cdef float m2JetArea_value

    cdef TBranch* m2JetBtag_branch
    cdef float m2JetBtag_value

    cdef TBranch* m2JetDR_branch
    cdef float m2JetDR_value

    cdef TBranch* m2JetEtaEtaMoment_branch
    cdef float m2JetEtaEtaMoment_value

    cdef TBranch* m2JetEtaPhiMoment_branch
    cdef float m2JetEtaPhiMoment_value

    cdef TBranch* m2JetEtaPhiSpread_branch
    cdef float m2JetEtaPhiSpread_value

    cdef TBranch* m2JetHadronFlavour_branch
    cdef float m2JetHadronFlavour_value

    cdef TBranch* m2JetPFCISVBtag_branch
    cdef float m2JetPFCISVBtag_value

    cdef TBranch* m2JetPartonFlavour_branch
    cdef float m2JetPartonFlavour_value

    cdef TBranch* m2JetPhiPhiMoment_branch
    cdef float m2JetPhiPhiMoment_value

    cdef TBranch* m2JetPt_branch
    cdef float m2JetPt_value

    cdef TBranch* m2LowestMll_branch
    cdef float m2LowestMll_value

    cdef TBranch* m2Mass_branch
    cdef float m2Mass_value

    cdef TBranch* m2MatchedStations_branch
    cdef float m2MatchedStations_value

    cdef TBranch* m2MatchesIsoMu20Tau27Filter_branch
    cdef float m2MatchesIsoMu20Tau27Filter_value

    cdef TBranch* m2MatchesIsoMu20Tau27Path_branch
    cdef float m2MatchesIsoMu20Tau27Path_value

    cdef TBranch* m2MatchesIsoMu24Filter_branch
    cdef float m2MatchesIsoMu24Filter_value

    cdef TBranch* m2MatchesIsoMu24Path_branch
    cdef float m2MatchesIsoMu24Path_value

    cdef TBranch* m2MatchesIsoMu27Filter_branch
    cdef float m2MatchesIsoMu27Filter_value

    cdef TBranch* m2MatchesIsoMu27Path_branch
    cdef float m2MatchesIsoMu27Path_value

    cdef TBranch* m2MiniIsoLoose_branch
    cdef float m2MiniIsoLoose_value

    cdef TBranch* m2MiniIsoMedium_branch
    cdef float m2MiniIsoMedium_value

    cdef TBranch* m2MiniIsoTight_branch
    cdef float m2MiniIsoTight_value

    cdef TBranch* m2MiniIsoVeryTight_branch
    cdef float m2MiniIsoVeryTight_value

    cdef TBranch* m2MuonHits_branch
    cdef float m2MuonHits_value

    cdef TBranch* m2MvaLoose_branch
    cdef float m2MvaLoose_value

    cdef TBranch* m2MvaMedium_branch
    cdef float m2MvaMedium_value

    cdef TBranch* m2MvaTight_branch
    cdef float m2MvaTight_value

    cdef TBranch* m2NearestZMass_branch
    cdef float m2NearestZMass_value

    cdef TBranch* m2NormTrkChi2_branch
    cdef float m2NormTrkChi2_value

    cdef TBranch* m2NormalizedChi2_branch
    cdef float m2NormalizedChi2_value

    cdef TBranch* m2PFChargedHadronIsoR04_branch
    cdef float m2PFChargedHadronIsoR04_value

    cdef TBranch* m2PFChargedIso_branch
    cdef float m2PFChargedIso_value

    cdef TBranch* m2PFIDLoose_branch
    cdef float m2PFIDLoose_value

    cdef TBranch* m2PFIDMedium_branch
    cdef float m2PFIDMedium_value

    cdef TBranch* m2PFIDTight_branch
    cdef float m2PFIDTight_value

    cdef TBranch* m2PFIsoLoose_branch
    cdef float m2PFIsoLoose_value

    cdef TBranch* m2PFIsoMedium_branch
    cdef float m2PFIsoMedium_value

    cdef TBranch* m2PFIsoTight_branch
    cdef float m2PFIsoTight_value

    cdef TBranch* m2PFIsoVeryLoose_branch
    cdef float m2PFIsoVeryLoose_value

    cdef TBranch* m2PFIsoVeryTight_branch
    cdef float m2PFIsoVeryTight_value

    cdef TBranch* m2PFNeutralHadronIsoR04_branch
    cdef float m2PFNeutralHadronIsoR04_value

    cdef TBranch* m2PFNeutralIso_branch
    cdef float m2PFNeutralIso_value

    cdef TBranch* m2PFPUChargedIso_branch
    cdef float m2PFPUChargedIso_value

    cdef TBranch* m2PFPhotonIso_branch
    cdef float m2PFPhotonIso_value

    cdef TBranch* m2PFPhotonIsoR04_branch
    cdef float m2PFPhotonIsoR04_value

    cdef TBranch* m2PFPileupIsoR04_branch
    cdef float m2PFPileupIsoR04_value

    cdef TBranch* m2PVDXY_branch
    cdef float m2PVDXY_value

    cdef TBranch* m2PVDZ_branch
    cdef float m2PVDZ_value

    cdef TBranch* m2Phi_branch
    cdef float m2Phi_value

    cdef TBranch* m2Phi_MuonEnDown_branch
    cdef float m2Phi_MuonEnDown_value

    cdef TBranch* m2Phi_MuonEnUp_branch
    cdef float m2Phi_MuonEnUp_value

    cdef TBranch* m2PixHits_branch
    cdef float m2PixHits_value

    cdef TBranch* m2Pt_branch
    cdef float m2Pt_value

    cdef TBranch* m2Pt_MuonEnDown_branch
    cdef float m2Pt_MuonEnDown_value

    cdef TBranch* m2Pt_MuonEnUp_branch
    cdef float m2Pt_MuonEnUp_value

    cdef TBranch* m2RelPFIsoDBDefault_branch
    cdef float m2RelPFIsoDBDefault_value

    cdef TBranch* m2RelPFIsoDBDefaultR04_branch
    cdef float m2RelPFIsoDBDefaultR04_value

    cdef TBranch* m2RelPFIsoRho_branch
    cdef float m2RelPFIsoRho_value

    cdef TBranch* m2Rho_branch
    cdef float m2Rho_value

    cdef TBranch* m2SIP2D_branch
    cdef float m2SIP2D_value

    cdef TBranch* m2SIP3D_branch
    cdef float m2SIP3D_value

    cdef TBranch* m2SegmentCompatibility_branch
    cdef float m2SegmentCompatibility_value

    cdef TBranch* m2SoftCutBasedId_branch
    cdef float m2SoftCutBasedId_value

    cdef TBranch* m2TkIsoLoose_branch
    cdef float m2TkIsoLoose_value

    cdef TBranch* m2TkIsoTight_branch
    cdef float m2TkIsoTight_value

    cdef TBranch* m2TkLayersWithMeasurement_branch
    cdef float m2TkLayersWithMeasurement_value

    cdef TBranch* m2TrkIsoDR03_branch
    cdef float m2TrkIsoDR03_value

    cdef TBranch* m2TrkKink_branch
    cdef float m2TrkKink_value

    cdef TBranch* m2TypeCode_branch
    cdef int m2TypeCode_value

    cdef TBranch* m2VZ_branch
    cdef float m2VZ_value

    cdef TBranch* m2ValidFraction_branch
    cdef float m2ValidFraction_value

    cdef TBranch* m2ZTTGenMatching_branch
    cdef float m2ZTTGenMatching_value

    cdef TBranch* m2_t_doubleL1IsoTauMatch_branch
    cdef float m2_t_doubleL1IsoTauMatch_value

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

    cdef TBranch* recoilDaught_branch
    cdef float recoilDaught_value

    cdef TBranch* recoilWithMet_branch
    cdef float recoilWithMet_value

    cdef TBranch* rho_branch
    cdef float rho_value

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* tAgainstElectronLooseMVA6_branch
    cdef float tAgainstElectronLooseMVA6_value

    cdef TBranch* tAgainstElectronMVA6Raw_branch
    cdef float tAgainstElectronMVA6Raw_value

    cdef TBranch* tAgainstElectronMVA6category_branch
    cdef float tAgainstElectronMVA6category_value

    cdef TBranch* tAgainstElectronMediumMVA6_branch
    cdef float tAgainstElectronMediumMVA6_value

    cdef TBranch* tAgainstElectronTightMVA6_branch
    cdef float tAgainstElectronTightMVA6_value

    cdef TBranch* tAgainstElectronVLooseMVA6_branch
    cdef float tAgainstElectronVLooseMVA6_value

    cdef TBranch* tAgainstElectronVTightMVA6_branch
    cdef float tAgainstElectronVTightMVA6_value

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

    cdef TBranch* tLowestMll_branch
    cdef float tLowestMll_value

    cdef TBranch* tMass_branch
    cdef float tMass_value

    cdef TBranch* tMatchesDoubleMediumTau35Filter_branch
    cdef float tMatchesDoubleMediumTau35Filter_value

    cdef TBranch* tMatchesDoubleMediumTau35Path_branch
    cdef float tMatchesDoubleMediumTau35Path_value

    cdef TBranch* tMatchesDoubleMediumTau40Filter_branch
    cdef float tMatchesDoubleMediumTau40Filter_value

    cdef TBranch* tMatchesDoubleMediumTau40Path_branch
    cdef float tMatchesDoubleMediumTau40Path_value

    cdef TBranch* tMatchesDoubleTightTau35Filter_branch
    cdef float tMatchesDoubleTightTau35Filter_value

    cdef TBranch* tMatchesDoubleTightTau35Path_branch
    cdef float tMatchesDoubleTightTau35Path_value

    cdef TBranch* tMatchesDoubleTightTau40Filter_branch
    cdef float tMatchesDoubleTightTau40Filter_value

    cdef TBranch* tMatchesDoubleTightTau40Path_branch
    cdef float tMatchesDoubleTightTau40Path_value

    cdef TBranch* tMatchesEle24Tau30Filter_branch
    cdef float tMatchesEle24Tau30Filter_value

    cdef TBranch* tMatchesEle24Tau30Path_branch
    cdef float tMatchesEle24Tau30Path_value

    cdef TBranch* tMatchesIsoMu20Tau27Filter_branch
    cdef float tMatchesIsoMu20Tau27Filter_value

    cdef TBranch* tMatchesIsoMu20Tau27Path_branch
    cdef float tMatchesIsoMu20Tau27Path_value

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

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTLoose_branch
    cdef float tRerunMVArun2v1DBoldDMwLTLoose_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTMedium_branch
    cdef float tRerunMVArun2v1DBoldDMwLTMedium_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVLoose_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVLoose_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTVVTight_branch
    cdef float tRerunMVArun2v1DBoldDMwLTVVTight_value

    cdef TBranch* tRerunMVArun2v1DBoldDMwLTraw_branch
    cdef float tRerunMVArun2v1DBoldDMwLTraw_value

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

        #print "making DoubleMediumTau35Group"
        self.DoubleMediumTau35Group_branch = the_tree.GetBranch("DoubleMediumTau35Group")
        #if not self.DoubleMediumTau35Group_branch and "DoubleMediumTau35Group" not in self.complained:
        if not self.DoubleMediumTau35Group_branch and "DoubleMediumTau35Group":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Group")
        else:
            self.DoubleMediumTau35Group_branch.SetAddress(<void*>&self.DoubleMediumTau35Group_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35Prescale"
        self.DoubleMediumTau35Prescale_branch = the_tree.GetBranch("DoubleMediumTau35Prescale")
        #if not self.DoubleMediumTau35Prescale_branch and "DoubleMediumTau35Prescale" not in self.complained:
        if not self.DoubleMediumTau35Prescale_branch and "DoubleMediumTau35Prescale":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Prescale")
        else:
            self.DoubleMediumTau35Prescale_branch.SetAddress(<void*>&self.DoubleMediumTau35Prescale_value)

        #print "making DoubleMediumTau40Group"
        self.DoubleMediumTau40Group_branch = the_tree.GetBranch("DoubleMediumTau40Group")
        #if not self.DoubleMediumTau40Group_branch and "DoubleMediumTau40Group" not in self.complained:
        if not self.DoubleMediumTau40Group_branch and "DoubleMediumTau40Group":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Group")
        else:
            self.DoubleMediumTau40Group_branch.SetAddress(<void*>&self.DoubleMediumTau40Group_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40Prescale"
        self.DoubleMediumTau40Prescale_branch = the_tree.GetBranch("DoubleMediumTau40Prescale")
        #if not self.DoubleMediumTau40Prescale_branch and "DoubleMediumTau40Prescale" not in self.complained:
        if not self.DoubleMediumTau40Prescale_branch and "DoubleMediumTau40Prescale":
            warnings.warn( "MuMuTauTree: Expected branch DoubleMediumTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Prescale")
        else:
            self.DoubleMediumTau40Prescale_branch.SetAddress(<void*>&self.DoubleMediumTau40Prescale_value)

        #print "making DoubleTightTau35Group"
        self.DoubleTightTau35Group_branch = the_tree.GetBranch("DoubleTightTau35Group")
        #if not self.DoubleTightTau35Group_branch and "DoubleTightTau35Group" not in self.complained:
        if not self.DoubleTightTau35Group_branch and "DoubleTightTau35Group":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Group")
        else:
            self.DoubleTightTau35Group_branch.SetAddress(<void*>&self.DoubleTightTau35Group_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35Prescale"
        self.DoubleTightTau35Prescale_branch = the_tree.GetBranch("DoubleTightTau35Prescale")
        #if not self.DoubleTightTau35Prescale_branch and "DoubleTightTau35Prescale" not in self.complained:
        if not self.DoubleTightTau35Prescale_branch and "DoubleTightTau35Prescale":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Prescale")
        else:
            self.DoubleTightTau35Prescale_branch.SetAddress(<void*>&self.DoubleTightTau35Prescale_value)

        #print "making DoubleTightTau40Group"
        self.DoubleTightTau40Group_branch = the_tree.GetBranch("DoubleTightTau40Group")
        #if not self.DoubleTightTau40Group_branch and "DoubleTightTau40Group" not in self.complained:
        if not self.DoubleTightTau40Group_branch and "DoubleTightTau40Group":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Group")
        else:
            self.DoubleTightTau40Group_branch.SetAddress(<void*>&self.DoubleTightTau40Group_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40Prescale"
        self.DoubleTightTau40Prescale_branch = the_tree.GetBranch("DoubleTightTau40Prescale")
        #if not self.DoubleTightTau40Prescale_branch and "DoubleTightTau40Prescale" not in self.complained:
        if not self.DoubleTightTau40Prescale_branch and "DoubleTightTau40Prescale":
            warnings.warn( "MuMuTauTree: Expected branch DoubleTightTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Prescale")
        else:
            self.DoubleTightTau40Prescale_branch.SetAddress(<void*>&self.DoubleTightTau40Prescale_value)

        #print "making Ele24Tau30Group"
        self.Ele24Tau30Group_branch = the_tree.GetBranch("Ele24Tau30Group")
        #if not self.Ele24Tau30Group_branch and "Ele24Tau30Group" not in self.complained:
        if not self.Ele24Tau30Group_branch and "Ele24Tau30Group":
            warnings.warn( "MuMuTauTree: Expected branch Ele24Tau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Group")
        else:
            self.Ele24Tau30Group_branch.SetAddress(<void*>&self.Ele24Tau30Group_value)

        #print "making Ele24Tau30Pass"
        self.Ele24Tau30Pass_branch = the_tree.GetBranch("Ele24Tau30Pass")
        #if not self.Ele24Tau30Pass_branch and "Ele24Tau30Pass" not in self.complained:
        if not self.Ele24Tau30Pass_branch and "Ele24Tau30Pass":
            warnings.warn( "MuMuTauTree: Expected branch Ele24Tau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Pass")
        else:
            self.Ele24Tau30Pass_branch.SetAddress(<void*>&self.Ele24Tau30Pass_value)

        #print "making Ele24Tau30Prescale"
        self.Ele24Tau30Prescale_branch = the_tree.GetBranch("Ele24Tau30Prescale")
        #if not self.Ele24Tau30Prescale_branch and "Ele24Tau30Prescale" not in self.complained:
        if not self.Ele24Tau30Prescale_branch and "Ele24Tau30Prescale":
            warnings.warn( "MuMuTauTree: Expected branch Ele24Tau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24Tau30Prescale")
        else:
            self.Ele24Tau30Prescale_branch.SetAddress(<void*>&self.Ele24Tau30Prescale_value)

        #print "making Ele27WPTightGroup"
        self.Ele27WPTightGroup_branch = the_tree.GetBranch("Ele27WPTightGroup")
        #if not self.Ele27WPTightGroup_branch and "Ele27WPTightGroup" not in self.complained:
        if not self.Ele27WPTightGroup_branch and "Ele27WPTightGroup":
            warnings.warn( "MuMuTauTree: Expected branch Ele27WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightGroup")
        else:
            self.Ele27WPTightGroup_branch.SetAddress(<void*>&self.Ele27WPTightGroup_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "MuMuTauTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele27WPTightPrescale"
        self.Ele27WPTightPrescale_branch = the_tree.GetBranch("Ele27WPTightPrescale")
        #if not self.Ele27WPTightPrescale_branch and "Ele27WPTightPrescale" not in self.complained:
        if not self.Ele27WPTightPrescale_branch and "Ele27WPTightPrescale":
            warnings.warn( "MuMuTauTree: Expected branch Ele27WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPrescale")
        else:
            self.Ele27WPTightPrescale_branch.SetAddress(<void*>&self.Ele27WPTightPrescale_value)

        #print "making Ele32WPTightGroup"
        self.Ele32WPTightGroup_branch = the_tree.GetBranch("Ele32WPTightGroup")
        #if not self.Ele32WPTightGroup_branch and "Ele32WPTightGroup" not in self.complained:
        if not self.Ele32WPTightGroup_branch and "Ele32WPTightGroup":
            warnings.warn( "MuMuTauTree: Expected branch Ele32WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightGroup")
        else:
            self.Ele32WPTightGroup_branch.SetAddress(<void*>&self.Ele32WPTightGroup_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "MuMuTauTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele32WPTightPrescale"
        self.Ele32WPTightPrescale_branch = the_tree.GetBranch("Ele32WPTightPrescale")
        #if not self.Ele32WPTightPrescale_branch and "Ele32WPTightPrescale" not in self.complained:
        if not self.Ele32WPTightPrescale_branch and "Ele32WPTightPrescale":
            warnings.warn( "MuMuTauTree: Expected branch Ele32WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPrescale")
        else:
            self.Ele32WPTightPrescale_branch.SetAddress(<void*>&self.Ele32WPTightPrescale_value)

        #print "making Ele35WPTightGroup"
        self.Ele35WPTightGroup_branch = the_tree.GetBranch("Ele35WPTightGroup")
        #if not self.Ele35WPTightGroup_branch and "Ele35WPTightGroup" not in self.complained:
        if not self.Ele35WPTightGroup_branch and "Ele35WPTightGroup":
            warnings.warn( "MuMuTauTree: Expected branch Ele35WPTightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightGroup")
        else:
            self.Ele35WPTightGroup_branch.SetAddress(<void*>&self.Ele35WPTightGroup_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "MuMuTauTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele35WPTightPrescale"
        self.Ele35WPTightPrescale_branch = the_tree.GetBranch("Ele35WPTightPrescale")
        #if not self.Ele35WPTightPrescale_branch and "Ele35WPTightPrescale" not in self.complained:
        if not self.Ele35WPTightPrescale_branch and "Ele35WPTightPrescale":
            warnings.warn( "MuMuTauTree: Expected branch Ele35WPTightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPrescale")
        else:
            self.Ele35WPTightPrescale_branch.SetAddress(<void*>&self.Ele35WPTightPrescale_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuMuTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuMuTauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "MuMuTauTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "MuMuTauTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "MuMuTauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "MuMuTauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuMuTauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuMuTauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu20Group"
        self.IsoMu20Group_branch = the_tree.GetBranch("IsoMu20Group")
        #if not self.IsoMu20Group_branch and "IsoMu20Group" not in self.complained:
        if not self.IsoMu20Group_branch and "IsoMu20Group":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Group")
        else:
            self.IsoMu20Group_branch.SetAddress(<void*>&self.IsoMu20Group_value)

        #print "making IsoMu20Pass"
        self.IsoMu20Pass_branch = the_tree.GetBranch("IsoMu20Pass")
        #if not self.IsoMu20Pass_branch and "IsoMu20Pass" not in self.complained:
        if not self.IsoMu20Pass_branch and "IsoMu20Pass":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Pass")
        else:
            self.IsoMu20Pass_branch.SetAddress(<void*>&self.IsoMu20Pass_value)

        #print "making IsoMu20Prescale"
        self.IsoMu20Prescale_branch = the_tree.GetBranch("IsoMu20Prescale")
        #if not self.IsoMu20Prescale_branch and "IsoMu20Prescale" not in self.complained:
        if not self.IsoMu20Prescale_branch and "IsoMu20Prescale":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu20Prescale")
        else:
            self.IsoMu20Prescale_branch.SetAddress(<void*>&self.IsoMu20Prescale_value)

        #print "making IsoMu24Group"
        self.IsoMu24Group_branch = the_tree.GetBranch("IsoMu24Group")
        #if not self.IsoMu24Group_branch and "IsoMu24Group" not in self.complained:
        if not self.IsoMu24Group_branch and "IsoMu24Group":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Group")
        else:
            self.IsoMu24Group_branch.SetAddress(<void*>&self.IsoMu24Group_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu24Prescale"
        self.IsoMu24Prescale_branch = the_tree.GetBranch("IsoMu24Prescale")
        #if not self.IsoMu24Prescale_branch and "IsoMu24Prescale" not in self.complained:
        if not self.IsoMu24Prescale_branch and "IsoMu24Prescale":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Prescale")
        else:
            self.IsoMu24Prescale_branch.SetAddress(<void*>&self.IsoMu24Prescale_value)

        #print "making IsoMu24_eta2p1Group"
        self.IsoMu24_eta2p1Group_branch = the_tree.GetBranch("IsoMu24_eta2p1Group")
        #if not self.IsoMu24_eta2p1Group_branch and "IsoMu24_eta2p1Group" not in self.complained:
        if not self.IsoMu24_eta2p1Group_branch and "IsoMu24_eta2p1Group":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24_eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Group")
        else:
            self.IsoMu24_eta2p1Group_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Group_value)

        #print "making IsoMu24_eta2p1Pass"
        self.IsoMu24_eta2p1Pass_branch = the_tree.GetBranch("IsoMu24_eta2p1Pass")
        #if not self.IsoMu24_eta2p1Pass_branch and "IsoMu24_eta2p1Pass" not in self.complained:
        if not self.IsoMu24_eta2p1Pass_branch and "IsoMu24_eta2p1Pass":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24_eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Pass")
        else:
            self.IsoMu24_eta2p1Pass_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Pass_value)

        #print "making IsoMu24_eta2p1Prescale"
        self.IsoMu24_eta2p1Prescale_branch = the_tree.GetBranch("IsoMu24_eta2p1Prescale")
        #if not self.IsoMu24_eta2p1Prescale_branch and "IsoMu24_eta2p1Prescale" not in self.complained:
        if not self.IsoMu24_eta2p1Prescale_branch and "IsoMu24_eta2p1Prescale":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu24_eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24_eta2p1Prescale")
        else:
            self.IsoMu24_eta2p1Prescale_branch.SetAddress(<void*>&self.IsoMu24_eta2p1Prescale_value)

        #print "making IsoMu27Group"
        self.IsoMu27Group_branch = the_tree.GetBranch("IsoMu27Group")
        #if not self.IsoMu27Group_branch and "IsoMu27Group" not in self.complained:
        if not self.IsoMu27Group_branch and "IsoMu27Group":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Group")
        else:
            self.IsoMu27Group_branch.SetAddress(<void*>&self.IsoMu27Group_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making IsoMu27Prescale"
        self.IsoMu27Prescale_branch = the_tree.GetBranch("IsoMu27Prescale")
        #if not self.IsoMu27Prescale_branch and "IsoMu27Prescale" not in self.complained:
        if not self.IsoMu27Prescale_branch and "IsoMu27Prescale":
            warnings.warn( "MuMuTauTree: Expected branch IsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Prescale")
        else:
            self.IsoMu27Prescale_branch.SetAddress(<void*>&self.IsoMu27Prescale_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuMuTauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20Tau27Group"
        self.Mu20Tau27Group_branch = the_tree.GetBranch("Mu20Tau27Group")
        #if not self.Mu20Tau27Group_branch and "Mu20Tau27Group" not in self.complained:
        if not self.Mu20Tau27Group_branch and "Mu20Tau27Group":
            warnings.warn( "MuMuTauTree: Expected branch Mu20Tau27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Group")
        else:
            self.Mu20Tau27Group_branch.SetAddress(<void*>&self.Mu20Tau27Group_value)

        #print "making Mu20Tau27Pass"
        self.Mu20Tau27Pass_branch = the_tree.GetBranch("Mu20Tau27Pass")
        #if not self.Mu20Tau27Pass_branch and "Mu20Tau27Pass" not in self.complained:
        if not self.Mu20Tau27Pass_branch and "Mu20Tau27Pass":
            warnings.warn( "MuMuTauTree: Expected branch Mu20Tau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Pass")
        else:
            self.Mu20Tau27Pass_branch.SetAddress(<void*>&self.Mu20Tau27Pass_value)

        #print "making Mu20Tau27Prescale"
        self.Mu20Tau27Prescale_branch = the_tree.GetBranch("Mu20Tau27Prescale")
        #if not self.Mu20Tau27Prescale_branch and "Mu20Tau27Prescale" not in self.complained:
        if not self.Mu20Tau27Prescale_branch and "Mu20Tau27Prescale":
            warnings.warn( "MuMuTauTree: Expected branch Mu20Tau27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20Tau27Prescale")
        else:
            self.Mu20Tau27Prescale_branch.SetAddress(<void*>&self.Mu20Tau27Prescale_value)

        #print "making Mu50Group"
        self.Mu50Group_branch = the_tree.GetBranch("Mu50Group")
        #if not self.Mu50Group_branch and "Mu50Group" not in self.complained:
        if not self.Mu50Group_branch and "Mu50Group":
            warnings.warn( "MuMuTauTree: Expected branch Mu50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Group")
        else:
            self.Mu50Group_branch.SetAddress(<void*>&self.Mu50Group_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "MuMuTauTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making Mu50Prescale"
        self.Mu50Prescale_branch = the_tree.GetBranch("Mu50Prescale")
        #if not self.Mu50Prescale_branch and "Mu50Prescale" not in self.complained:
        if not self.Mu50Prescale_branch and "Mu50Prescale":
            warnings.warn( "MuMuTauTree: Expected branch Mu50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Prescale")
        else:
            self.Mu50Prescale_branch.SetAddress(<void*>&self.Mu50Prescale_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuMuTauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "MuMuTauTree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20MediumWoNoisyJets"
        self.bjetCISVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetCISVVeto20MediumWoNoisyJets")
        #if not self.bjetCISVVeto20MediumWoNoisyJets_branch and "bjetCISVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetCISVVeto20MediumWoNoisyJets_branch and "bjetCISVVeto20MediumWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20MediumWoNoisyJets")
        else:
            self.bjetCISVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetCISVVeto20MediumWoNoisyJets_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "MuMuTauTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making bjetDeepCSVVeto20Loose"
        self.bjetDeepCSVVeto20Loose_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose")
        #if not self.bjetDeepCSVVeto20Loose_branch and "bjetDeepCSVVeto20Loose" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_branch and "bjetDeepCSVVeto20Loose":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose")
        else:
            self.bjetDeepCSVVeto20Loose_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20Tight"
        self.bjetDeepCSVVeto20Tight_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight")
        #if not self.bjetDeepCSVVeto20Tight_branch and "bjetDeepCSVVeto20Tight" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_branch and "bjetDeepCSVVeto20Tight":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight")
        else:
            self.bjetDeepCSVVeto20Tight_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_value)

        #print "making bjetDeepCSVVeto30Loose"
        self.bjetDeepCSVVeto30Loose_branch = the_tree.GetBranch("bjetDeepCSVVeto30Loose")
        #if not self.bjetDeepCSVVeto30Loose_branch and "bjetDeepCSVVeto30Loose" not in self.complained:
        if not self.bjetDeepCSVVeto30Loose_branch and "bjetDeepCSVVeto30Loose":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Loose")
        else:
            self.bjetDeepCSVVeto30Loose_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Loose_value)

        #print "making bjetDeepCSVVeto30Medium"
        self.bjetDeepCSVVeto30Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto30Medium")
        #if not self.bjetDeepCSVVeto30Medium_branch and "bjetDeepCSVVeto30Medium" not in self.complained:
        if not self.bjetDeepCSVVeto30Medium_branch and "bjetDeepCSVVeto30Medium":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Medium")
        else:
            self.bjetDeepCSVVeto30Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Medium_value)

        #print "making bjetDeepCSVVeto30Tight"
        self.bjetDeepCSVVeto30Tight_branch = the_tree.GetBranch("bjetDeepCSVVeto30Tight")
        #if not self.bjetDeepCSVVeto30Tight_branch and "bjetDeepCSVVeto30Tight" not in self.complained:
        if not self.bjetDeepCSVVeto30Tight_branch and "bjetDeepCSVVeto30Tight":
            warnings.warn( "MuMuTauTree: Expected branch bjetDeepCSVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto30Tight")
        else:
            self.bjetDeepCSVVeto30Tight_branch.SetAddress(<void*>&self.bjetDeepCSVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuMuTauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuMuTauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleE_23_12_DZGroup"
        self.doubleE_23_12_DZGroup_branch = the_tree.GetBranch("doubleE_23_12_DZGroup")
        #if not self.doubleE_23_12_DZGroup_branch and "doubleE_23_12_DZGroup" not in self.complained:
        if not self.doubleE_23_12_DZGroup_branch and "doubleE_23_12_DZGroup":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12_DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZGroup")
        else:
            self.doubleE_23_12_DZGroup_branch.SetAddress(<void*>&self.doubleE_23_12_DZGroup_value)

        #print "making doubleE_23_12_DZPass"
        self.doubleE_23_12_DZPass_branch = the_tree.GetBranch("doubleE_23_12_DZPass")
        #if not self.doubleE_23_12_DZPass_branch and "doubleE_23_12_DZPass" not in self.complained:
        if not self.doubleE_23_12_DZPass_branch and "doubleE_23_12_DZPass":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12_DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZPass")
        else:
            self.doubleE_23_12_DZPass_branch.SetAddress(<void*>&self.doubleE_23_12_DZPass_value)

        #print "making doubleE_23_12_DZPrescale"
        self.doubleE_23_12_DZPrescale_branch = the_tree.GetBranch("doubleE_23_12_DZPrescale")
        #if not self.doubleE_23_12_DZPrescale_branch and "doubleE_23_12_DZPrescale" not in self.complained:
        if not self.doubleE_23_12_DZPrescale_branch and "doubleE_23_12_DZPrescale":
            warnings.warn( "MuMuTauTree: Expected branch doubleE_23_12_DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12_DZPrescale")
        else:
            self.doubleE_23_12_DZPrescale_branch.SetAddress(<void*>&self.doubleE_23_12_DZPrescale_value)

        #print "making doubleMuDZGroup"
        self.doubleMuDZGroup_branch = the_tree.GetBranch("doubleMuDZGroup")
        #if not self.doubleMuDZGroup_branch and "doubleMuDZGroup" not in self.complained:
        if not self.doubleMuDZGroup_branch and "doubleMuDZGroup":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZGroup")
        else:
            self.doubleMuDZGroup_branch.SetAddress(<void*>&self.doubleMuDZGroup_value)

        #print "making doubleMuDZPass"
        self.doubleMuDZPass_branch = the_tree.GetBranch("doubleMuDZPass")
        #if not self.doubleMuDZPass_branch and "doubleMuDZPass" not in self.complained:
        if not self.doubleMuDZPass_branch and "doubleMuDZPass":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZPass")
        else:
            self.doubleMuDZPass_branch.SetAddress(<void*>&self.doubleMuDZPass_value)

        #print "making doubleMuDZPrescale"
        self.doubleMuDZPrescale_branch = the_tree.GetBranch("doubleMuDZPrescale")
        #if not self.doubleMuDZPrescale_branch and "doubleMuDZPrescale" not in self.complained:
        if not self.doubleMuDZPrescale_branch and "doubleMuDZPrescale":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZPrescale")
        else:
            self.doubleMuDZPrescale_branch.SetAddress(<void*>&self.doubleMuDZPrescale_value)

        #print "making doubleMuDZminMass3p8Group"
        self.doubleMuDZminMass3p8Group_branch = the_tree.GetBranch("doubleMuDZminMass3p8Group")
        #if not self.doubleMuDZminMass3p8Group_branch and "doubleMuDZminMass3p8Group" not in self.complained:
        if not self.doubleMuDZminMass3p8Group_branch and "doubleMuDZminMass3p8Group":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass3p8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Group")
        else:
            self.doubleMuDZminMass3p8Group_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Group_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass3p8Prescale"
        self.doubleMuDZminMass3p8Prescale_branch = the_tree.GetBranch("doubleMuDZminMass3p8Prescale")
        #if not self.doubleMuDZminMass3p8Prescale_branch and "doubleMuDZminMass3p8Prescale" not in self.complained:
        if not self.doubleMuDZminMass3p8Prescale_branch and "doubleMuDZminMass3p8Prescale":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass3p8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Prescale")
        else:
            self.doubleMuDZminMass3p8Prescale_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Prescale_value)

        #print "making doubleMuDZminMass8Group"
        self.doubleMuDZminMass8Group_branch = the_tree.GetBranch("doubleMuDZminMass8Group")
        #if not self.doubleMuDZminMass8Group_branch and "doubleMuDZminMass8Group" not in self.complained:
        if not self.doubleMuDZminMass8Group_branch and "doubleMuDZminMass8Group":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass8Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Group")
        else:
            self.doubleMuDZminMass8Group_branch.SetAddress(<void*>&self.doubleMuDZminMass8Group_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuDZminMass8Prescale"
        self.doubleMuDZminMass8Prescale_branch = the_tree.GetBranch("doubleMuDZminMass8Prescale")
        #if not self.doubleMuDZminMass8Prescale_branch and "doubleMuDZminMass8Prescale" not in self.complained:
        if not self.doubleMuDZminMass8Prescale_branch and "doubleMuDZminMass8Prescale":
            warnings.warn( "MuMuTauTree: Expected branch doubleMuDZminMass8Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Prescale")
        else:
            self.doubleMuDZminMass8Prescale_branch.SetAddress(<void*>&self.doubleMuDZminMass8Prescale_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuMuTauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuMuTauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuMuTauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuMuTauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuMuTauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuMuTauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuMuTauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuMuTauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuMuTauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuMuTauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "MuMuTauTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuMuTauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuMuTauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuMuTauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuMuTauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuMuTauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuMuTauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuMuTauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuMuTauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuMuTauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuMuTauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "MuMuTauTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csvWoNoisyJets"
        self.jb1csvWoNoisyJets_branch = the_tree.GetBranch("jb1csvWoNoisyJets")
        #if not self.jb1csvWoNoisyJets_branch and "jb1csvWoNoisyJets" not in self.complained:
        if not self.jb1csvWoNoisyJets_branch and "jb1csvWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csvWoNoisyJets")
        else:
            self.jb1csvWoNoisyJets_branch.SetAddress(<void*>&self.jb1csvWoNoisyJets_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuMuTauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1etaWoNoisyJets"
        self.jb1etaWoNoisyJets_branch = the_tree.GetBranch("jb1etaWoNoisyJets")
        #if not self.jb1etaWoNoisyJets_branch and "jb1etaWoNoisyJets" not in self.complained:
        if not self.jb1etaWoNoisyJets_branch and "jb1etaWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1etaWoNoisyJets")
        else:
            self.jb1etaWoNoisyJets_branch.SetAddress(<void*>&self.jb1etaWoNoisyJets_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuMuTauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavorWoNoisyJets"
        self.jb1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("jb1hadronflavorWoNoisyJets")
        #if not self.jb1hadronflavorWoNoisyJets_branch and "jb1hadronflavorWoNoisyJets" not in self.complained:
        if not self.jb1hadronflavorWoNoisyJets_branch and "jb1hadronflavorWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavorWoNoisyJets")
        else:
            self.jb1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.jb1hadronflavorWoNoisyJets_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuMuTauTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phiWoNoisyJets"
        self.jb1phiWoNoisyJets_branch = the_tree.GetBranch("jb1phiWoNoisyJets")
        #if not self.jb1phiWoNoisyJets_branch and "jb1phiWoNoisyJets" not in self.complained:
        if not self.jb1phiWoNoisyJets_branch and "jb1phiWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phiWoNoisyJets")
        else:
            self.jb1phiWoNoisyJets_branch.SetAddress(<void*>&self.jb1phiWoNoisyJets_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuMuTauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptWoNoisyJets"
        self.jb1ptWoNoisyJets_branch = the_tree.GetBranch("jb1ptWoNoisyJets")
        #if not self.jb1ptWoNoisyJets_branch and "jb1ptWoNoisyJets" not in self.complained:
        if not self.jb1ptWoNoisyJets_branch and "jb1ptWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptWoNoisyJets")
        else:
            self.jb1ptWoNoisyJets_branch.SetAddress(<void*>&self.jb1ptWoNoisyJets_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "MuMuTauTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csvWoNoisyJets"
        self.jb2csvWoNoisyJets_branch = the_tree.GetBranch("jb2csvWoNoisyJets")
        #if not self.jb2csvWoNoisyJets_branch and "jb2csvWoNoisyJets" not in self.complained:
        if not self.jb2csvWoNoisyJets_branch and "jb2csvWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csvWoNoisyJets")
        else:
            self.jb2csvWoNoisyJets_branch.SetAddress(<void*>&self.jb2csvWoNoisyJets_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuMuTauTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2etaWoNoisyJets"
        self.jb2etaWoNoisyJets_branch = the_tree.GetBranch("jb2etaWoNoisyJets")
        #if not self.jb2etaWoNoisyJets_branch and "jb2etaWoNoisyJets" not in self.complained:
        if not self.jb2etaWoNoisyJets_branch and "jb2etaWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2etaWoNoisyJets")
        else:
            self.jb2etaWoNoisyJets_branch.SetAddress(<void*>&self.jb2etaWoNoisyJets_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuMuTauTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavorWoNoisyJets"
        self.jb2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("jb2hadronflavorWoNoisyJets")
        #if not self.jb2hadronflavorWoNoisyJets_branch and "jb2hadronflavorWoNoisyJets" not in self.complained:
        if not self.jb2hadronflavorWoNoisyJets_branch and "jb2hadronflavorWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavorWoNoisyJets")
        else:
            self.jb2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.jb2hadronflavorWoNoisyJets_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuMuTauTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phiWoNoisyJets"
        self.jb2phiWoNoisyJets_branch = the_tree.GetBranch("jb2phiWoNoisyJets")
        #if not self.jb2phiWoNoisyJets_branch and "jb2phiWoNoisyJets" not in self.complained:
        if not self.jb2phiWoNoisyJets_branch and "jb2phiWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phiWoNoisyJets")
        else:
            self.jb2phiWoNoisyJets_branch.SetAddress(<void*>&self.jb2phiWoNoisyJets_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuMuTauTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptWoNoisyJets"
        self.jb2ptWoNoisyJets_branch = the_tree.GetBranch("jb2ptWoNoisyJets")
        #if not self.jb2ptWoNoisyJets_branch and "jb2ptWoNoisyJets" not in self.complained:
        if not self.jb2ptWoNoisyJets_branch and "jb2ptWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jb2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptWoNoisyJets")
        else:
            self.jb2ptWoNoisyJets_branch.SetAddress(<void*>&self.jb2ptWoNoisyJets_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuMuTauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "MuMuTauTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuTauTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1Chi2LocalPosition"
        self.m1Chi2LocalPosition_branch = the_tree.GetBranch("m1Chi2LocalPosition")
        #if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition" not in self.complained:
        if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition":
            warnings.warn( "MuMuTauTree: Expected branch m1Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Chi2LocalPosition")
        else:
            self.m1Chi2LocalPosition_branch.SetAddress(<void*>&self.m1Chi2LocalPosition_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuTauTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1CutBasedIdGlobalHighPt"
        self.m1CutBasedIdGlobalHighPt_branch = the_tree.GetBranch("m1CutBasedIdGlobalHighPt")
        #if not self.m1CutBasedIdGlobalHighPt_branch and "m1CutBasedIdGlobalHighPt" not in self.complained:
        if not self.m1CutBasedIdGlobalHighPt_branch and "m1CutBasedIdGlobalHighPt":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdGlobalHighPt")
        else:
            self.m1CutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.m1CutBasedIdGlobalHighPt_value)

        #print "making m1CutBasedIdLoose"
        self.m1CutBasedIdLoose_branch = the_tree.GetBranch("m1CutBasedIdLoose")
        #if not self.m1CutBasedIdLoose_branch and "m1CutBasedIdLoose" not in self.complained:
        if not self.m1CutBasedIdLoose_branch and "m1CutBasedIdLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdLoose")
        else:
            self.m1CutBasedIdLoose_branch.SetAddress(<void*>&self.m1CutBasedIdLoose_value)

        #print "making m1CutBasedIdMedium"
        self.m1CutBasedIdMedium_branch = the_tree.GetBranch("m1CutBasedIdMedium")
        #if not self.m1CutBasedIdMedium_branch and "m1CutBasedIdMedium" not in self.complained:
        if not self.m1CutBasedIdMedium_branch and "m1CutBasedIdMedium":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdMedium")
        else:
            self.m1CutBasedIdMedium_branch.SetAddress(<void*>&self.m1CutBasedIdMedium_value)

        #print "making m1CutBasedIdMediumPrompt"
        self.m1CutBasedIdMediumPrompt_branch = the_tree.GetBranch("m1CutBasedIdMediumPrompt")
        #if not self.m1CutBasedIdMediumPrompt_branch and "m1CutBasedIdMediumPrompt" not in self.complained:
        if not self.m1CutBasedIdMediumPrompt_branch and "m1CutBasedIdMediumPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdMediumPrompt")
        else:
            self.m1CutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.m1CutBasedIdMediumPrompt_value)

        #print "making m1CutBasedIdTight"
        self.m1CutBasedIdTight_branch = the_tree.GetBranch("m1CutBasedIdTight")
        #if not self.m1CutBasedIdTight_branch and "m1CutBasedIdTight" not in self.complained:
        if not self.m1CutBasedIdTight_branch and "m1CutBasedIdTight":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdTight")
        else:
            self.m1CutBasedIdTight_branch.SetAddress(<void*>&self.m1CutBasedIdTight_value)

        #print "making m1CutBasedIdTrkHighPt"
        self.m1CutBasedIdTrkHighPt_branch = the_tree.GetBranch("m1CutBasedIdTrkHighPt")
        #if not self.m1CutBasedIdTrkHighPt_branch and "m1CutBasedIdTrkHighPt" not in self.complained:
        if not self.m1CutBasedIdTrkHighPt_branch and "m1CutBasedIdTrkHighPt":
            warnings.warn( "MuMuTauTree: Expected branch m1CutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdTrkHighPt")
        else:
            self.m1CutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.m1CutBasedIdTrkHighPt_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuTauTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuTauTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuTauTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1Eta_MuonEnDown"
        self.m1Eta_MuonEnDown_branch = the_tree.GetBranch("m1Eta_MuonEnDown")
        #if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown" not in self.complained:
        if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m1Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnDown")
        else:
            self.m1Eta_MuonEnDown_branch.SetAddress(<void*>&self.m1Eta_MuonEnDown_value)

        #print "making m1Eta_MuonEnUp"
        self.m1Eta_MuonEnUp_branch = the_tree.GetBranch("m1Eta_MuonEnUp")
        #if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp" not in self.complained:
        if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m1Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnUp")
        else:
            self.m1Eta_MuonEnUp_branch.SetAddress(<void*>&self.m1Eta_MuonEnUp_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuTauTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenDirectPromptTauDecayFinalState"
        self.m1GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m1GenDirectPromptTauDecayFinalState")
        #if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuTauTree: Expected branch m1GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenDirectPromptTauDecayFinalState")
        else:
            self.m1GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m1GenDirectPromptTauDecayFinalState_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuTauTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuTauTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenIsPrompt"
        self.m1GenIsPrompt_branch = the_tree.GetBranch("m1GenIsPrompt")
        #if not self.m1GenIsPrompt_branch and "m1GenIsPrompt" not in self.complained:
        if not self.m1GenIsPrompt_branch and "m1GenIsPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenIsPrompt")
        else:
            self.m1GenIsPrompt_branch.SetAddress(<void*>&self.m1GenIsPrompt_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuTauTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "MuMuTauTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPrompt"
        self.m1GenPrompt_branch = the_tree.GetBranch("m1GenPrompt")
        #if not self.m1GenPrompt_branch and "m1GenPrompt" not in self.complained:
        if not self.m1GenPrompt_branch and "m1GenPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPrompt")
        else:
            self.m1GenPrompt_branch.SetAddress(<void*>&self.m1GenPrompt_value)

        #print "making m1GenPromptFinalState"
        self.m1GenPromptFinalState_branch = the_tree.GetBranch("m1GenPromptFinalState")
        #if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState" not in self.complained:
        if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptFinalState")
        else:
            self.m1GenPromptFinalState_branch.SetAddress(<void*>&self.m1GenPromptFinalState_value)

        #print "making m1GenPromptTauDecay"
        self.m1GenPromptTauDecay_branch = the_tree.GetBranch("m1GenPromptTauDecay")
        #if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay" not in self.complained:
        if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptTauDecay")
        else:
            self.m1GenPromptTauDecay_branch.SetAddress(<void*>&self.m1GenPromptTauDecay_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "MuMuTauTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenTauDecay"
        self.m1GenTauDecay_branch = the_tree.GetBranch("m1GenTauDecay")
        #if not self.m1GenTauDecay_branch and "m1GenTauDecay" not in self.complained:
        if not self.m1GenTauDecay_branch and "m1GenTauDecay":
            warnings.warn( "MuMuTauTree: Expected branch m1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenTauDecay")
        else:
            self.m1GenTauDecay_branch.SetAddress(<void*>&self.m1GenTauDecay_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "MuMuTauTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1GenVtxPVMatch"
        self.m1GenVtxPVMatch_branch = the_tree.GetBranch("m1GenVtxPVMatch")
        #if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch" not in self.complained:
        if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch":
            warnings.warn( "MuMuTauTree: Expected branch m1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVtxPVMatch")
        else:
            self.m1GenVtxPVMatch_branch.SetAddress(<void*>&self.m1GenVtxPVMatch_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "MuMuTauTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DErr"
        self.m1IP3DErr_branch = the_tree.GetBranch("m1IP3DErr")
        #if not self.m1IP3DErr_branch and "m1IP3DErr" not in self.complained:
        if not self.m1IP3DErr_branch and "m1IP3DErr":
            warnings.warn( "MuMuTauTree: Expected branch m1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DErr")
        else:
            self.m1IP3DErr_branch.SetAddress(<void*>&self.m1IP3DErr_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuTauTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuTauTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuTauTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "MuMuTauTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "MuMuTauTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuTauTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuTauTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetDR"
        self.m1JetDR_branch = the_tree.GetBranch("m1JetDR")
        #if not self.m1JetDR_branch and "m1JetDR" not in self.complained:
        if not self.m1JetDR_branch and "m1JetDR":
            warnings.warn( "MuMuTauTree: Expected branch m1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetDR")
        else:
            self.m1JetDR_branch.SetAddress(<void*>&self.m1JetDR_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuTauTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuTauTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetHadronFlavour"
        self.m1JetHadronFlavour_branch = the_tree.GetBranch("m1JetHadronFlavour")
        #if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour" not in self.complained:
        if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour":
            warnings.warn( "MuMuTauTree: Expected branch m1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetHadronFlavour")
        else:
            self.m1JetHadronFlavour_branch.SetAddress(<void*>&self.m1JetHadronFlavour_value)

        #print "making m1JetPFCISVBtag"
        self.m1JetPFCISVBtag_branch = the_tree.GetBranch("m1JetPFCISVBtag")
        #if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag" not in self.complained:
        if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag":
            warnings.warn( "MuMuTauTree: Expected branch m1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPFCISVBtag")
        else:
            self.m1JetPFCISVBtag_branch.SetAddress(<void*>&self.m1JetPFCISVBtag_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuTauTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuTauTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1LowestMll"
        self.m1LowestMll_branch = the_tree.GetBranch("m1LowestMll")
        #if not self.m1LowestMll_branch and "m1LowestMll" not in self.complained:
        if not self.m1LowestMll_branch and "m1LowestMll":
            warnings.warn( "MuMuTauTree: Expected branch m1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1LowestMll")
        else:
            self.m1LowestMll_branch.SetAddress(<void*>&self.m1LowestMll_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuTauTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesIsoMu20Tau27Filter"
        self.m1MatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu20Tau27Filter")
        #if not self.m1MatchesIsoMu20Tau27Filter_branch and "m1MatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.m1MatchesIsoMu20Tau27Filter_branch and "m1MatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Tau27Filter")
        else:
            self.m1MatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Tau27Filter_value)

        #print "making m1MatchesIsoMu20Tau27Path"
        self.m1MatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("m1MatchesIsoMu20Tau27Path")
        #if not self.m1MatchesIsoMu20Tau27Path_branch and "m1MatchesIsoMu20Tau27Path" not in self.complained:
        if not self.m1MatchesIsoMu20Tau27Path_branch and "m1MatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Tau27Path")
        else:
            self.m1MatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Tau27Path_value)

        #print "making m1MatchesIsoMu24Filter"
        self.m1MatchesIsoMu24Filter_branch = the_tree.GetBranch("m1MatchesIsoMu24Filter")
        #if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter" not in self.complained:
        if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Filter")
        else:
            self.m1MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Filter_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu27Filter"
        self.m1MatchesIsoMu27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu27Filter")
        #if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter" not in self.complained:
        if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Filter")
        else:
            self.m1MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Filter_value)

        #print "making m1MatchesIsoMu27Path"
        self.m1MatchesIsoMu27Path_branch = the_tree.GetBranch("m1MatchesIsoMu27Path")
        #if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path" not in self.complained:
        if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path":
            warnings.warn( "MuMuTauTree: Expected branch m1MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Path")
        else:
            self.m1MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Path_value)

        #print "making m1MiniIsoLoose"
        self.m1MiniIsoLoose_branch = the_tree.GetBranch("m1MiniIsoLoose")
        #if not self.m1MiniIsoLoose_branch and "m1MiniIsoLoose" not in self.complained:
        if not self.m1MiniIsoLoose_branch and "m1MiniIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1MiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoLoose")
        else:
            self.m1MiniIsoLoose_branch.SetAddress(<void*>&self.m1MiniIsoLoose_value)

        #print "making m1MiniIsoMedium"
        self.m1MiniIsoMedium_branch = the_tree.GetBranch("m1MiniIsoMedium")
        #if not self.m1MiniIsoMedium_branch and "m1MiniIsoMedium" not in self.complained:
        if not self.m1MiniIsoMedium_branch and "m1MiniIsoMedium":
            warnings.warn( "MuMuTauTree: Expected branch m1MiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoMedium")
        else:
            self.m1MiniIsoMedium_branch.SetAddress(<void*>&self.m1MiniIsoMedium_value)

        #print "making m1MiniIsoTight"
        self.m1MiniIsoTight_branch = the_tree.GetBranch("m1MiniIsoTight")
        #if not self.m1MiniIsoTight_branch and "m1MiniIsoTight" not in self.complained:
        if not self.m1MiniIsoTight_branch and "m1MiniIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m1MiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoTight")
        else:
            self.m1MiniIsoTight_branch.SetAddress(<void*>&self.m1MiniIsoTight_value)

        #print "making m1MiniIsoVeryTight"
        self.m1MiniIsoVeryTight_branch = the_tree.GetBranch("m1MiniIsoVeryTight")
        #if not self.m1MiniIsoVeryTight_branch and "m1MiniIsoVeryTight" not in self.complained:
        if not self.m1MiniIsoVeryTight_branch and "m1MiniIsoVeryTight":
            warnings.warn( "MuMuTauTree: Expected branch m1MiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoVeryTight")
        else:
            self.m1MiniIsoVeryTight_branch.SetAddress(<void*>&self.m1MiniIsoVeryTight_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuTauTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1MvaLoose"
        self.m1MvaLoose_branch = the_tree.GetBranch("m1MvaLoose")
        #if not self.m1MvaLoose_branch and "m1MvaLoose" not in self.complained:
        if not self.m1MvaLoose_branch and "m1MvaLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaLoose")
        else:
            self.m1MvaLoose_branch.SetAddress(<void*>&self.m1MvaLoose_value)

        #print "making m1MvaMedium"
        self.m1MvaMedium_branch = the_tree.GetBranch("m1MvaMedium")
        #if not self.m1MvaMedium_branch and "m1MvaMedium" not in self.complained:
        if not self.m1MvaMedium_branch and "m1MvaMedium":
            warnings.warn( "MuMuTauTree: Expected branch m1MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaMedium")
        else:
            self.m1MvaMedium_branch.SetAddress(<void*>&self.m1MvaMedium_value)

        #print "making m1MvaTight"
        self.m1MvaTight_branch = the_tree.GetBranch("m1MvaTight")
        #if not self.m1MvaTight_branch and "m1MvaTight" not in self.complained:
        if not self.m1MvaTight_branch and "m1MvaTight":
            warnings.warn( "MuMuTauTree: Expected branch m1MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaTight")
        else:
            self.m1MvaTight_branch.SetAddress(<void*>&self.m1MvaTight_value)

        #print "making m1NearestZMass"
        self.m1NearestZMass_branch = the_tree.GetBranch("m1NearestZMass")
        #if not self.m1NearestZMass_branch and "m1NearestZMass" not in self.complained:
        if not self.m1NearestZMass_branch and "m1NearestZMass":
            warnings.warn( "MuMuTauTree: Expected branch m1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NearestZMass")
        else:
            self.m1NearestZMass_branch.SetAddress(<void*>&self.m1NearestZMass_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuTauTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1NormalizedChi2"
        self.m1NormalizedChi2_branch = the_tree.GetBranch("m1NormalizedChi2")
        #if not self.m1NormalizedChi2_branch and "m1NormalizedChi2" not in self.complained:
        if not self.m1NormalizedChi2_branch and "m1NormalizedChi2":
            warnings.warn( "MuMuTauTree: Expected branch m1NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormalizedChi2")
        else:
            self.m1NormalizedChi2_branch.SetAddress(<void*>&self.m1NormalizedChi2_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuTauTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFIsoLoose"
        self.m1PFIsoLoose_branch = the_tree.GetBranch("m1PFIsoLoose")
        #if not self.m1PFIsoLoose_branch and "m1PFIsoLoose" not in self.complained:
        if not self.m1PFIsoLoose_branch and "m1PFIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoLoose")
        else:
            self.m1PFIsoLoose_branch.SetAddress(<void*>&self.m1PFIsoLoose_value)

        #print "making m1PFIsoMedium"
        self.m1PFIsoMedium_branch = the_tree.GetBranch("m1PFIsoMedium")
        #if not self.m1PFIsoMedium_branch and "m1PFIsoMedium" not in self.complained:
        if not self.m1PFIsoMedium_branch and "m1PFIsoMedium":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoMedium")
        else:
            self.m1PFIsoMedium_branch.SetAddress(<void*>&self.m1PFIsoMedium_value)

        #print "making m1PFIsoTight"
        self.m1PFIsoTight_branch = the_tree.GetBranch("m1PFIsoTight")
        #if not self.m1PFIsoTight_branch and "m1PFIsoTight" not in self.complained:
        if not self.m1PFIsoTight_branch and "m1PFIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoTight")
        else:
            self.m1PFIsoTight_branch.SetAddress(<void*>&self.m1PFIsoTight_value)

        #print "making m1PFIsoVeryLoose"
        self.m1PFIsoVeryLoose_branch = the_tree.GetBranch("m1PFIsoVeryLoose")
        #if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose" not in self.complained:
        if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryLoose")
        else:
            self.m1PFIsoVeryLoose_branch.SetAddress(<void*>&self.m1PFIsoVeryLoose_value)

        #print "making m1PFIsoVeryTight"
        self.m1PFIsoVeryTight_branch = the_tree.GetBranch("m1PFIsoVeryTight")
        #if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight" not in self.complained:
        if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight":
            warnings.warn( "MuMuTauTree: Expected branch m1PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryTight")
        else:
            self.m1PFIsoVeryTight_branch.SetAddress(<void*>&self.m1PFIsoVeryTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuTauTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuTauTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuTauTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuTauTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuTauTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuTauTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Phi_MuonEnDown"
        self.m1Phi_MuonEnDown_branch = the_tree.GetBranch("m1Phi_MuonEnDown")
        #if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown" not in self.complained:
        if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m1Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnDown")
        else:
            self.m1Phi_MuonEnDown_branch.SetAddress(<void*>&self.m1Phi_MuonEnDown_value)

        #print "making m1Phi_MuonEnUp"
        self.m1Phi_MuonEnUp_branch = the_tree.GetBranch("m1Phi_MuonEnUp")
        #if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp" not in self.complained:
        if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m1Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnUp")
        else:
            self.m1Phi_MuonEnUp_branch.SetAddress(<void*>&self.m1Phi_MuonEnUp_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuTauTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuTauTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1Pt_MuonEnDown"
        self.m1Pt_MuonEnDown_branch = the_tree.GetBranch("m1Pt_MuonEnDown")
        #if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown" not in self.complained:
        if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m1Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnDown")
        else:
            self.m1Pt_MuonEnDown_branch.SetAddress(<void*>&self.m1Pt_MuonEnDown_value)

        #print "making m1Pt_MuonEnUp"
        self.m1Pt_MuonEnUp_branch = the_tree.GetBranch("m1Pt_MuonEnUp")
        #if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp" not in self.complained:
        if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m1Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnUp")
        else:
            self.m1Pt_MuonEnUp_branch.SetAddress(<void*>&self.m1Pt_MuonEnUp_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "MuMuTauTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuTauTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuTauTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1Rho"
        self.m1Rho_branch = the_tree.GetBranch("m1Rho")
        #if not self.m1Rho_branch and "m1Rho" not in self.complained:
        if not self.m1Rho_branch and "m1Rho":
            warnings.warn( "MuMuTauTree: Expected branch m1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rho")
        else:
            self.m1Rho_branch.SetAddress(<void*>&self.m1Rho_value)

        #print "making m1SIP2D"
        self.m1SIP2D_branch = the_tree.GetBranch("m1SIP2D")
        #if not self.m1SIP2D_branch and "m1SIP2D" not in self.complained:
        if not self.m1SIP2D_branch and "m1SIP2D":
            warnings.warn( "MuMuTauTree: Expected branch m1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP2D")
        else:
            self.m1SIP2D_branch.SetAddress(<void*>&self.m1SIP2D_value)

        #print "making m1SIP3D"
        self.m1SIP3D_branch = the_tree.GetBranch("m1SIP3D")
        #if not self.m1SIP3D_branch and "m1SIP3D" not in self.complained:
        if not self.m1SIP3D_branch and "m1SIP3D":
            warnings.warn( "MuMuTauTree: Expected branch m1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP3D")
        else:
            self.m1SIP3D_branch.SetAddress(<void*>&self.m1SIP3D_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "MuMuTauTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1SoftCutBasedId"
        self.m1SoftCutBasedId_branch = the_tree.GetBranch("m1SoftCutBasedId")
        #if not self.m1SoftCutBasedId_branch and "m1SoftCutBasedId" not in self.complained:
        if not self.m1SoftCutBasedId_branch and "m1SoftCutBasedId":
            warnings.warn( "MuMuTauTree: Expected branch m1SoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SoftCutBasedId")
        else:
            self.m1SoftCutBasedId_branch.SetAddress(<void*>&self.m1SoftCutBasedId_value)

        #print "making m1TkIsoLoose"
        self.m1TkIsoLoose_branch = the_tree.GetBranch("m1TkIsoLoose")
        #if not self.m1TkIsoLoose_branch and "m1TkIsoLoose" not in self.complained:
        if not self.m1TkIsoLoose_branch and "m1TkIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m1TkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkIsoLoose")
        else:
            self.m1TkIsoLoose_branch.SetAddress(<void*>&self.m1TkIsoLoose_value)

        #print "making m1TkIsoTight"
        self.m1TkIsoTight_branch = the_tree.GetBranch("m1TkIsoTight")
        #if not self.m1TkIsoTight_branch and "m1TkIsoTight" not in self.complained:
        if not self.m1TkIsoTight_branch and "m1TkIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m1TkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkIsoTight")
        else:
            self.m1TkIsoTight_branch.SetAddress(<void*>&self.m1TkIsoTight_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuTauTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TrkKink"
        self.m1TrkKink_branch = the_tree.GetBranch("m1TrkKink")
        #if not self.m1TrkKink_branch and "m1TrkKink" not in self.complained:
        if not self.m1TrkKink_branch and "m1TrkKink":
            warnings.warn( "MuMuTauTree: Expected branch m1TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkKink")
        else:
            self.m1TrkKink_branch.SetAddress(<void*>&self.m1TrkKink_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuTauTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuTauTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1ValidFraction"
        self.m1ValidFraction_branch = the_tree.GetBranch("m1ValidFraction")
        #if not self.m1ValidFraction_branch and "m1ValidFraction" not in self.complained:
        if not self.m1ValidFraction_branch and "m1ValidFraction":
            warnings.warn( "MuMuTauTree: Expected branch m1ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ValidFraction")
        else:
            self.m1ValidFraction_branch.SetAddress(<void*>&self.m1ValidFraction_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "MuMuTauTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1_m2_doubleL1IsoTauMatch"
        self.m1_m2_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m1_m2_doubleL1IsoTauMatch")
        #if not self.m1_m2_doubleL1IsoTauMatch_branch and "m1_m2_doubleL1IsoTauMatch" not in self.complained:
        if not self.m1_m2_doubleL1IsoTauMatch_branch and "m1_m2_doubleL1IsoTauMatch":
            warnings.warn( "MuMuTauTree: Expected branch m1_m2_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_doubleL1IsoTauMatch")
        else:
            self.m1_m2_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m1_m2_doubleL1IsoTauMatch_value)

        #print "making m1_t_doubleL1IsoTauMatch"
        self.m1_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m1_t_doubleL1IsoTauMatch")
        #if not self.m1_t_doubleL1IsoTauMatch_branch and "m1_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.m1_t_doubleL1IsoTauMatch_branch and "m1_t_doubleL1IsoTauMatch":
            warnings.warn( "MuMuTauTree: Expected branch m1_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_t_doubleL1IsoTauMatch")
        else:
            self.m1_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m1_t_doubleL1IsoTauMatch_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "MuMuTauTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuTauTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2Chi2LocalPosition"
        self.m2Chi2LocalPosition_branch = the_tree.GetBranch("m2Chi2LocalPosition")
        #if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition" not in self.complained:
        if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition":
            warnings.warn( "MuMuTauTree: Expected branch m2Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Chi2LocalPosition")
        else:
            self.m2Chi2LocalPosition_branch.SetAddress(<void*>&self.m2Chi2LocalPosition_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuTauTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2CutBasedIdGlobalHighPt"
        self.m2CutBasedIdGlobalHighPt_branch = the_tree.GetBranch("m2CutBasedIdGlobalHighPt")
        #if not self.m2CutBasedIdGlobalHighPt_branch and "m2CutBasedIdGlobalHighPt" not in self.complained:
        if not self.m2CutBasedIdGlobalHighPt_branch and "m2CutBasedIdGlobalHighPt":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdGlobalHighPt")
        else:
            self.m2CutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.m2CutBasedIdGlobalHighPt_value)

        #print "making m2CutBasedIdLoose"
        self.m2CutBasedIdLoose_branch = the_tree.GetBranch("m2CutBasedIdLoose")
        #if not self.m2CutBasedIdLoose_branch and "m2CutBasedIdLoose" not in self.complained:
        if not self.m2CutBasedIdLoose_branch and "m2CutBasedIdLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdLoose")
        else:
            self.m2CutBasedIdLoose_branch.SetAddress(<void*>&self.m2CutBasedIdLoose_value)

        #print "making m2CutBasedIdMedium"
        self.m2CutBasedIdMedium_branch = the_tree.GetBranch("m2CutBasedIdMedium")
        #if not self.m2CutBasedIdMedium_branch and "m2CutBasedIdMedium" not in self.complained:
        if not self.m2CutBasedIdMedium_branch and "m2CutBasedIdMedium":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdMedium")
        else:
            self.m2CutBasedIdMedium_branch.SetAddress(<void*>&self.m2CutBasedIdMedium_value)

        #print "making m2CutBasedIdMediumPrompt"
        self.m2CutBasedIdMediumPrompt_branch = the_tree.GetBranch("m2CutBasedIdMediumPrompt")
        #if not self.m2CutBasedIdMediumPrompt_branch and "m2CutBasedIdMediumPrompt" not in self.complained:
        if not self.m2CutBasedIdMediumPrompt_branch and "m2CutBasedIdMediumPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdMediumPrompt")
        else:
            self.m2CutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.m2CutBasedIdMediumPrompt_value)

        #print "making m2CutBasedIdTight"
        self.m2CutBasedIdTight_branch = the_tree.GetBranch("m2CutBasedIdTight")
        #if not self.m2CutBasedIdTight_branch and "m2CutBasedIdTight" not in self.complained:
        if not self.m2CutBasedIdTight_branch and "m2CutBasedIdTight":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdTight")
        else:
            self.m2CutBasedIdTight_branch.SetAddress(<void*>&self.m2CutBasedIdTight_value)

        #print "making m2CutBasedIdTrkHighPt"
        self.m2CutBasedIdTrkHighPt_branch = the_tree.GetBranch("m2CutBasedIdTrkHighPt")
        #if not self.m2CutBasedIdTrkHighPt_branch and "m2CutBasedIdTrkHighPt" not in self.complained:
        if not self.m2CutBasedIdTrkHighPt_branch and "m2CutBasedIdTrkHighPt":
            warnings.warn( "MuMuTauTree: Expected branch m2CutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdTrkHighPt")
        else:
            self.m2CutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.m2CutBasedIdTrkHighPt_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuTauTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuTauTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuTauTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2Eta_MuonEnDown"
        self.m2Eta_MuonEnDown_branch = the_tree.GetBranch("m2Eta_MuonEnDown")
        #if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown" not in self.complained:
        if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m2Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnDown")
        else:
            self.m2Eta_MuonEnDown_branch.SetAddress(<void*>&self.m2Eta_MuonEnDown_value)

        #print "making m2Eta_MuonEnUp"
        self.m2Eta_MuonEnUp_branch = the_tree.GetBranch("m2Eta_MuonEnUp")
        #if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp" not in self.complained:
        if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m2Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnUp")
        else:
            self.m2Eta_MuonEnUp_branch.SetAddress(<void*>&self.m2Eta_MuonEnUp_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuTauTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenDirectPromptTauDecayFinalState"
        self.m2GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m2GenDirectPromptTauDecayFinalState")
        #if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuTauTree: Expected branch m2GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenDirectPromptTauDecayFinalState")
        else:
            self.m2GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m2GenDirectPromptTauDecayFinalState_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuTauTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuTauTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenIsPrompt"
        self.m2GenIsPrompt_branch = the_tree.GetBranch("m2GenIsPrompt")
        #if not self.m2GenIsPrompt_branch and "m2GenIsPrompt" not in self.complained:
        if not self.m2GenIsPrompt_branch and "m2GenIsPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenIsPrompt")
        else:
            self.m2GenIsPrompt_branch.SetAddress(<void*>&self.m2GenIsPrompt_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuTauTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "MuMuTauTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPrompt"
        self.m2GenPrompt_branch = the_tree.GetBranch("m2GenPrompt")
        #if not self.m2GenPrompt_branch and "m2GenPrompt" not in self.complained:
        if not self.m2GenPrompt_branch and "m2GenPrompt":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPrompt")
        else:
            self.m2GenPrompt_branch.SetAddress(<void*>&self.m2GenPrompt_value)

        #print "making m2GenPromptFinalState"
        self.m2GenPromptFinalState_branch = the_tree.GetBranch("m2GenPromptFinalState")
        #if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState" not in self.complained:
        if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptFinalState")
        else:
            self.m2GenPromptFinalState_branch.SetAddress(<void*>&self.m2GenPromptFinalState_value)

        #print "making m2GenPromptTauDecay"
        self.m2GenPromptTauDecay_branch = the_tree.GetBranch("m2GenPromptTauDecay")
        #if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay" not in self.complained:
        if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptTauDecay")
        else:
            self.m2GenPromptTauDecay_branch.SetAddress(<void*>&self.m2GenPromptTauDecay_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "MuMuTauTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenTauDecay"
        self.m2GenTauDecay_branch = the_tree.GetBranch("m2GenTauDecay")
        #if not self.m2GenTauDecay_branch and "m2GenTauDecay" not in self.complained:
        if not self.m2GenTauDecay_branch and "m2GenTauDecay":
            warnings.warn( "MuMuTauTree: Expected branch m2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenTauDecay")
        else:
            self.m2GenTauDecay_branch.SetAddress(<void*>&self.m2GenTauDecay_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "MuMuTauTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2GenVtxPVMatch"
        self.m2GenVtxPVMatch_branch = the_tree.GetBranch("m2GenVtxPVMatch")
        #if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch" not in self.complained:
        if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch":
            warnings.warn( "MuMuTauTree: Expected branch m2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVtxPVMatch")
        else:
            self.m2GenVtxPVMatch_branch.SetAddress(<void*>&self.m2GenVtxPVMatch_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "MuMuTauTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DErr"
        self.m2IP3DErr_branch = the_tree.GetBranch("m2IP3DErr")
        #if not self.m2IP3DErr_branch and "m2IP3DErr" not in self.complained:
        if not self.m2IP3DErr_branch and "m2IP3DErr":
            warnings.warn( "MuMuTauTree: Expected branch m2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DErr")
        else:
            self.m2IP3DErr_branch.SetAddress(<void*>&self.m2IP3DErr_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuTauTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuTauTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuTauTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "MuMuTauTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "MuMuTauTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuTauTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuTauTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetDR"
        self.m2JetDR_branch = the_tree.GetBranch("m2JetDR")
        #if not self.m2JetDR_branch and "m2JetDR" not in self.complained:
        if not self.m2JetDR_branch and "m2JetDR":
            warnings.warn( "MuMuTauTree: Expected branch m2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetDR")
        else:
            self.m2JetDR_branch.SetAddress(<void*>&self.m2JetDR_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuTauTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuTauTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetHadronFlavour"
        self.m2JetHadronFlavour_branch = the_tree.GetBranch("m2JetHadronFlavour")
        #if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour" not in self.complained:
        if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour":
            warnings.warn( "MuMuTauTree: Expected branch m2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetHadronFlavour")
        else:
            self.m2JetHadronFlavour_branch.SetAddress(<void*>&self.m2JetHadronFlavour_value)

        #print "making m2JetPFCISVBtag"
        self.m2JetPFCISVBtag_branch = the_tree.GetBranch("m2JetPFCISVBtag")
        #if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag" not in self.complained:
        if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag":
            warnings.warn( "MuMuTauTree: Expected branch m2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPFCISVBtag")
        else:
            self.m2JetPFCISVBtag_branch.SetAddress(<void*>&self.m2JetPFCISVBtag_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuTauTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuTauTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2LowestMll"
        self.m2LowestMll_branch = the_tree.GetBranch("m2LowestMll")
        #if not self.m2LowestMll_branch and "m2LowestMll" not in self.complained:
        if not self.m2LowestMll_branch and "m2LowestMll":
            warnings.warn( "MuMuTauTree: Expected branch m2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2LowestMll")
        else:
            self.m2LowestMll_branch.SetAddress(<void*>&self.m2LowestMll_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuTauTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesIsoMu20Tau27Filter"
        self.m2MatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu20Tau27Filter")
        #if not self.m2MatchesIsoMu20Tau27Filter_branch and "m2MatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.m2MatchesIsoMu20Tau27Filter_branch and "m2MatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Tau27Filter")
        else:
            self.m2MatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Tau27Filter_value)

        #print "making m2MatchesIsoMu20Tau27Path"
        self.m2MatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("m2MatchesIsoMu20Tau27Path")
        #if not self.m2MatchesIsoMu20Tau27Path_branch and "m2MatchesIsoMu20Tau27Path" not in self.complained:
        if not self.m2MatchesIsoMu20Tau27Path_branch and "m2MatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Tau27Path")
        else:
            self.m2MatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Tau27Path_value)

        #print "making m2MatchesIsoMu24Filter"
        self.m2MatchesIsoMu24Filter_branch = the_tree.GetBranch("m2MatchesIsoMu24Filter")
        #if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter" not in self.complained:
        if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Filter")
        else:
            self.m2MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Filter_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu27Filter"
        self.m2MatchesIsoMu27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu27Filter")
        #if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter" not in self.complained:
        if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Filter")
        else:
            self.m2MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Filter_value)

        #print "making m2MatchesIsoMu27Path"
        self.m2MatchesIsoMu27Path_branch = the_tree.GetBranch("m2MatchesIsoMu27Path")
        #if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path" not in self.complained:
        if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path":
            warnings.warn( "MuMuTauTree: Expected branch m2MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Path")
        else:
            self.m2MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Path_value)

        #print "making m2MiniIsoLoose"
        self.m2MiniIsoLoose_branch = the_tree.GetBranch("m2MiniIsoLoose")
        #if not self.m2MiniIsoLoose_branch and "m2MiniIsoLoose" not in self.complained:
        if not self.m2MiniIsoLoose_branch and "m2MiniIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2MiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoLoose")
        else:
            self.m2MiniIsoLoose_branch.SetAddress(<void*>&self.m2MiniIsoLoose_value)

        #print "making m2MiniIsoMedium"
        self.m2MiniIsoMedium_branch = the_tree.GetBranch("m2MiniIsoMedium")
        #if not self.m2MiniIsoMedium_branch and "m2MiniIsoMedium" not in self.complained:
        if not self.m2MiniIsoMedium_branch and "m2MiniIsoMedium":
            warnings.warn( "MuMuTauTree: Expected branch m2MiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoMedium")
        else:
            self.m2MiniIsoMedium_branch.SetAddress(<void*>&self.m2MiniIsoMedium_value)

        #print "making m2MiniIsoTight"
        self.m2MiniIsoTight_branch = the_tree.GetBranch("m2MiniIsoTight")
        #if not self.m2MiniIsoTight_branch and "m2MiniIsoTight" not in self.complained:
        if not self.m2MiniIsoTight_branch and "m2MiniIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m2MiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoTight")
        else:
            self.m2MiniIsoTight_branch.SetAddress(<void*>&self.m2MiniIsoTight_value)

        #print "making m2MiniIsoVeryTight"
        self.m2MiniIsoVeryTight_branch = the_tree.GetBranch("m2MiniIsoVeryTight")
        #if not self.m2MiniIsoVeryTight_branch and "m2MiniIsoVeryTight" not in self.complained:
        if not self.m2MiniIsoVeryTight_branch and "m2MiniIsoVeryTight":
            warnings.warn( "MuMuTauTree: Expected branch m2MiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoVeryTight")
        else:
            self.m2MiniIsoVeryTight_branch.SetAddress(<void*>&self.m2MiniIsoVeryTight_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuTauTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2MvaLoose"
        self.m2MvaLoose_branch = the_tree.GetBranch("m2MvaLoose")
        #if not self.m2MvaLoose_branch and "m2MvaLoose" not in self.complained:
        if not self.m2MvaLoose_branch and "m2MvaLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaLoose")
        else:
            self.m2MvaLoose_branch.SetAddress(<void*>&self.m2MvaLoose_value)

        #print "making m2MvaMedium"
        self.m2MvaMedium_branch = the_tree.GetBranch("m2MvaMedium")
        #if not self.m2MvaMedium_branch and "m2MvaMedium" not in self.complained:
        if not self.m2MvaMedium_branch and "m2MvaMedium":
            warnings.warn( "MuMuTauTree: Expected branch m2MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaMedium")
        else:
            self.m2MvaMedium_branch.SetAddress(<void*>&self.m2MvaMedium_value)

        #print "making m2MvaTight"
        self.m2MvaTight_branch = the_tree.GetBranch("m2MvaTight")
        #if not self.m2MvaTight_branch and "m2MvaTight" not in self.complained:
        if not self.m2MvaTight_branch and "m2MvaTight":
            warnings.warn( "MuMuTauTree: Expected branch m2MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaTight")
        else:
            self.m2MvaTight_branch.SetAddress(<void*>&self.m2MvaTight_value)

        #print "making m2NearestZMass"
        self.m2NearestZMass_branch = the_tree.GetBranch("m2NearestZMass")
        #if not self.m2NearestZMass_branch and "m2NearestZMass" not in self.complained:
        if not self.m2NearestZMass_branch and "m2NearestZMass":
            warnings.warn( "MuMuTauTree: Expected branch m2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NearestZMass")
        else:
            self.m2NearestZMass_branch.SetAddress(<void*>&self.m2NearestZMass_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuTauTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2NormalizedChi2"
        self.m2NormalizedChi2_branch = the_tree.GetBranch("m2NormalizedChi2")
        #if not self.m2NormalizedChi2_branch and "m2NormalizedChi2" not in self.complained:
        if not self.m2NormalizedChi2_branch and "m2NormalizedChi2":
            warnings.warn( "MuMuTauTree: Expected branch m2NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormalizedChi2")
        else:
            self.m2NormalizedChi2_branch.SetAddress(<void*>&self.m2NormalizedChi2_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuTauTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFIsoLoose"
        self.m2PFIsoLoose_branch = the_tree.GetBranch("m2PFIsoLoose")
        #if not self.m2PFIsoLoose_branch and "m2PFIsoLoose" not in self.complained:
        if not self.m2PFIsoLoose_branch and "m2PFIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoLoose")
        else:
            self.m2PFIsoLoose_branch.SetAddress(<void*>&self.m2PFIsoLoose_value)

        #print "making m2PFIsoMedium"
        self.m2PFIsoMedium_branch = the_tree.GetBranch("m2PFIsoMedium")
        #if not self.m2PFIsoMedium_branch and "m2PFIsoMedium" not in self.complained:
        if not self.m2PFIsoMedium_branch and "m2PFIsoMedium":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoMedium")
        else:
            self.m2PFIsoMedium_branch.SetAddress(<void*>&self.m2PFIsoMedium_value)

        #print "making m2PFIsoTight"
        self.m2PFIsoTight_branch = the_tree.GetBranch("m2PFIsoTight")
        #if not self.m2PFIsoTight_branch and "m2PFIsoTight" not in self.complained:
        if not self.m2PFIsoTight_branch and "m2PFIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoTight")
        else:
            self.m2PFIsoTight_branch.SetAddress(<void*>&self.m2PFIsoTight_value)

        #print "making m2PFIsoVeryLoose"
        self.m2PFIsoVeryLoose_branch = the_tree.GetBranch("m2PFIsoVeryLoose")
        #if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose" not in self.complained:
        if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryLoose")
        else:
            self.m2PFIsoVeryLoose_branch.SetAddress(<void*>&self.m2PFIsoVeryLoose_value)

        #print "making m2PFIsoVeryTight"
        self.m2PFIsoVeryTight_branch = the_tree.GetBranch("m2PFIsoVeryTight")
        #if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight" not in self.complained:
        if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight":
            warnings.warn( "MuMuTauTree: Expected branch m2PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryTight")
        else:
            self.m2PFIsoVeryTight_branch.SetAddress(<void*>&self.m2PFIsoVeryTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuTauTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuTauTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuTauTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "MuMuTauTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuTauTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuTauTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuTauTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Phi_MuonEnDown"
        self.m2Phi_MuonEnDown_branch = the_tree.GetBranch("m2Phi_MuonEnDown")
        #if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown" not in self.complained:
        if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m2Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnDown")
        else:
            self.m2Phi_MuonEnDown_branch.SetAddress(<void*>&self.m2Phi_MuonEnDown_value)

        #print "making m2Phi_MuonEnUp"
        self.m2Phi_MuonEnUp_branch = the_tree.GetBranch("m2Phi_MuonEnUp")
        #if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp" not in self.complained:
        if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m2Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnUp")
        else:
            self.m2Phi_MuonEnUp_branch.SetAddress(<void*>&self.m2Phi_MuonEnUp_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuTauTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuTauTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2Pt_MuonEnDown"
        self.m2Pt_MuonEnDown_branch = the_tree.GetBranch("m2Pt_MuonEnDown")
        #if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown" not in self.complained:
        if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown":
            warnings.warn( "MuMuTauTree: Expected branch m2Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnDown")
        else:
            self.m2Pt_MuonEnDown_branch.SetAddress(<void*>&self.m2Pt_MuonEnDown_value)

        #print "making m2Pt_MuonEnUp"
        self.m2Pt_MuonEnUp_branch = the_tree.GetBranch("m2Pt_MuonEnUp")
        #if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp" not in self.complained:
        if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp":
            warnings.warn( "MuMuTauTree: Expected branch m2Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnUp")
        else:
            self.m2Pt_MuonEnUp_branch.SetAddress(<void*>&self.m2Pt_MuonEnUp_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "MuMuTauTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuTauTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuTauTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2Rho"
        self.m2Rho_branch = the_tree.GetBranch("m2Rho")
        #if not self.m2Rho_branch and "m2Rho" not in self.complained:
        if not self.m2Rho_branch and "m2Rho":
            warnings.warn( "MuMuTauTree: Expected branch m2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rho")
        else:
            self.m2Rho_branch.SetAddress(<void*>&self.m2Rho_value)

        #print "making m2SIP2D"
        self.m2SIP2D_branch = the_tree.GetBranch("m2SIP2D")
        #if not self.m2SIP2D_branch and "m2SIP2D" not in self.complained:
        if not self.m2SIP2D_branch and "m2SIP2D":
            warnings.warn( "MuMuTauTree: Expected branch m2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP2D")
        else:
            self.m2SIP2D_branch.SetAddress(<void*>&self.m2SIP2D_value)

        #print "making m2SIP3D"
        self.m2SIP3D_branch = the_tree.GetBranch("m2SIP3D")
        #if not self.m2SIP3D_branch and "m2SIP3D" not in self.complained:
        if not self.m2SIP3D_branch and "m2SIP3D":
            warnings.warn( "MuMuTauTree: Expected branch m2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP3D")
        else:
            self.m2SIP3D_branch.SetAddress(<void*>&self.m2SIP3D_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "MuMuTauTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2SoftCutBasedId"
        self.m2SoftCutBasedId_branch = the_tree.GetBranch("m2SoftCutBasedId")
        #if not self.m2SoftCutBasedId_branch and "m2SoftCutBasedId" not in self.complained:
        if not self.m2SoftCutBasedId_branch and "m2SoftCutBasedId":
            warnings.warn( "MuMuTauTree: Expected branch m2SoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SoftCutBasedId")
        else:
            self.m2SoftCutBasedId_branch.SetAddress(<void*>&self.m2SoftCutBasedId_value)

        #print "making m2TkIsoLoose"
        self.m2TkIsoLoose_branch = the_tree.GetBranch("m2TkIsoLoose")
        #if not self.m2TkIsoLoose_branch and "m2TkIsoLoose" not in self.complained:
        if not self.m2TkIsoLoose_branch and "m2TkIsoLoose":
            warnings.warn( "MuMuTauTree: Expected branch m2TkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkIsoLoose")
        else:
            self.m2TkIsoLoose_branch.SetAddress(<void*>&self.m2TkIsoLoose_value)

        #print "making m2TkIsoTight"
        self.m2TkIsoTight_branch = the_tree.GetBranch("m2TkIsoTight")
        #if not self.m2TkIsoTight_branch and "m2TkIsoTight" not in self.complained:
        if not self.m2TkIsoTight_branch and "m2TkIsoTight":
            warnings.warn( "MuMuTauTree: Expected branch m2TkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkIsoTight")
        else:
            self.m2TkIsoTight_branch.SetAddress(<void*>&self.m2TkIsoTight_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuTauTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "MuMuTauTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TrkKink"
        self.m2TrkKink_branch = the_tree.GetBranch("m2TrkKink")
        #if not self.m2TrkKink_branch and "m2TrkKink" not in self.complained:
        if not self.m2TrkKink_branch and "m2TrkKink":
            warnings.warn( "MuMuTauTree: Expected branch m2TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkKink")
        else:
            self.m2TrkKink_branch.SetAddress(<void*>&self.m2TrkKink_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuTauTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuTauTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2ValidFraction"
        self.m2ValidFraction_branch = the_tree.GetBranch("m2ValidFraction")
        #if not self.m2ValidFraction_branch and "m2ValidFraction" not in self.complained:
        if not self.m2ValidFraction_branch and "m2ValidFraction":
            warnings.warn( "MuMuTauTree: Expected branch m2ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ValidFraction")
        else:
            self.m2ValidFraction_branch.SetAddress(<void*>&self.m2ValidFraction_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "MuMuTauTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

        #print "making m2_t_doubleL1IsoTauMatch"
        self.m2_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m2_t_doubleL1IsoTauMatch")
        #if not self.m2_t_doubleL1IsoTauMatch_branch and "m2_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.m2_t_doubleL1IsoTauMatch_branch and "m2_t_doubleL1IsoTauMatch":
            warnings.warn( "MuMuTauTree: Expected branch m2_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_t_doubleL1IsoTauMatch")
        else:
            self.m2_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m2_t_doubleL1IsoTauMatch_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuMuTauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuMuTauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov00_DESYlike"
        self.metcov00_DESYlike_branch = the_tree.GetBranch("metcov00_DESYlike")
        #if not self.metcov00_DESYlike_branch and "metcov00_DESYlike" not in self.complained:
        if not self.metcov00_DESYlike_branch and "metcov00_DESYlike":
            warnings.warn( "MuMuTauTree: Expected branch metcov00_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00_DESYlike")
        else:
            self.metcov00_DESYlike_branch.SetAddress(<void*>&self.metcov00_DESYlike_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuMuTauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov01_DESYlike"
        self.metcov01_DESYlike_branch = the_tree.GetBranch("metcov01_DESYlike")
        #if not self.metcov01_DESYlike_branch and "metcov01_DESYlike" not in self.complained:
        if not self.metcov01_DESYlike_branch and "metcov01_DESYlike":
            warnings.warn( "MuMuTauTree: Expected branch metcov01_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01_DESYlike")
        else:
            self.metcov01_DESYlike_branch.SetAddress(<void*>&self.metcov01_DESYlike_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuMuTauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov10_DESYlike"
        self.metcov10_DESYlike_branch = the_tree.GetBranch("metcov10_DESYlike")
        #if not self.metcov10_DESYlike_branch and "metcov10_DESYlike" not in self.complained:
        if not self.metcov10_DESYlike_branch and "metcov10_DESYlike":
            warnings.warn( "MuMuTauTree: Expected branch metcov10_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10_DESYlike")
        else:
            self.metcov10_DESYlike_branch.SetAddress(<void*>&self.metcov10_DESYlike_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuMuTauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov11_DESYlike"
        self.metcov11_DESYlike_branch = the_tree.GetBranch("metcov11_DESYlike")
        #if not self.metcov11_DESYlike_branch and "metcov11_DESYlike" not in self.complained:
        if not self.metcov11_DESYlike_branch and "metcov11_DESYlike":
            warnings.warn( "MuMuTauTree: Expected branch metcov11_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11_DESYlike")
        else:
            self.metcov11_DESYlike_branch.SetAddress(<void*>&self.metcov11_DESYlike_value)

        #print "making mu12e23DZGroup"
        self.mu12e23DZGroup_branch = the_tree.GetBranch("mu12e23DZGroup")
        #if not self.mu12e23DZGroup_branch and "mu12e23DZGroup" not in self.complained:
        if not self.mu12e23DZGroup_branch and "mu12e23DZGroup":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZGroup")
        else:
            self.mu12e23DZGroup_branch.SetAddress(<void*>&self.mu12e23DZGroup_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23DZPrescale"
        self.mu12e23DZPrescale_branch = the_tree.GetBranch("mu12e23DZPrescale")
        #if not self.mu12e23DZPrescale_branch and "mu12e23DZPrescale" not in self.complained:
        if not self.mu12e23DZPrescale_branch and "mu12e23DZPrescale":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPrescale")
        else:
            self.mu12e23DZPrescale_branch.SetAddress(<void*>&self.mu12e23DZPrescale_value)

        #print "making mu12e23Group"
        self.mu12e23Group_branch = the_tree.GetBranch("mu12e23Group")
        #if not self.mu12e23Group_branch and "mu12e23Group" not in self.complained:
        if not self.mu12e23Group_branch and "mu12e23Group":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Group")
        else:
            self.mu12e23Group_branch.SetAddress(<void*>&self.mu12e23Group_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu12e23Prescale"
        self.mu12e23Prescale_branch = the_tree.GetBranch("mu12e23Prescale")
        #if not self.mu12e23Prescale_branch and "mu12e23Prescale" not in self.complained:
        if not self.mu12e23Prescale_branch and "mu12e23Prescale":
            warnings.warn( "MuMuTauTree: Expected branch mu12e23Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Prescale")
        else:
            self.mu12e23Prescale_branch.SetAddress(<void*>&self.mu12e23Prescale_value)

        #print "making mu23e12DZGroup"
        self.mu23e12DZGroup_branch = the_tree.GetBranch("mu23e12DZGroup")
        #if not self.mu23e12DZGroup_branch and "mu23e12DZGroup" not in self.complained:
        if not self.mu23e12DZGroup_branch and "mu23e12DZGroup":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZGroup")
        else:
            self.mu23e12DZGroup_branch.SetAddress(<void*>&self.mu23e12DZGroup_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12DZPrescale"
        self.mu23e12DZPrescale_branch = the_tree.GetBranch("mu23e12DZPrescale")
        #if not self.mu23e12DZPrescale_branch and "mu23e12DZPrescale" not in self.complained:
        if not self.mu23e12DZPrescale_branch and "mu23e12DZPrescale":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPrescale")
        else:
            self.mu23e12DZPrescale_branch.SetAddress(<void*>&self.mu23e12DZPrescale_value)

        #print "making mu23e12Group"
        self.mu23e12Group_branch = the_tree.GetBranch("mu23e12Group")
        #if not self.mu23e12Group_branch and "mu23e12Group" not in self.complained:
        if not self.mu23e12Group_branch and "mu23e12Group":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Group")
        else:
            self.mu23e12Group_branch.SetAddress(<void*>&self.mu23e12Group_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu23e12Prescale"
        self.mu23e12Prescale_branch = the_tree.GetBranch("mu23e12Prescale")
        #if not self.mu23e12Prescale_branch and "mu23e12Prescale" not in self.complained:
        if not self.mu23e12Prescale_branch and "mu23e12Prescale":
            warnings.warn( "MuMuTauTree: Expected branch mu23e12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Prescale")
        else:
            self.mu23e12Prescale_branch.SetAddress(<void*>&self.mu23e12Prescale_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuMuTauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuMuTauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "MuMuTauTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuMuTauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuMuTauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuMuTauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuMuTauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "MuMuTauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "MuMuTauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "MuMuTauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "MuMuTauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "MuMuTauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuMuTauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuMuTauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuMuTauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuMuTauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuMuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "MuMuTauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "MuMuTauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "MuMuTauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "MuMuTauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "MuMuTauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "MuMuTauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "MuMuTauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "MuMuTauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "MuMuTauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "MuMuTauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "MuMuTauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "MuMuTauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "MuMuTauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "MuMuTauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "MuMuTauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "MuMuTauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "MuMuTauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "MuMuTauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "MuMuTauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "MuMuTauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "MuMuTauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "MuMuTauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "MuMuTauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "MuMuTauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "MuMuTauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "MuMuTauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "MuMuTauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetDR"
        self.tJetDR_branch = the_tree.GetBranch("tJetDR")
        #if not self.tJetDR_branch and "tJetDR" not in self.complained:
        if not self.tJetDR_branch and "tJetDR":
            warnings.warn( "MuMuTauTree: Expected branch tJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetDR")
        else:
            self.tJetDR_branch.SetAddress(<void*>&self.tJetDR_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "MuMuTauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "MuMuTauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "MuMuTauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "MuMuTauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "MuMuTauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "MuMuTauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "MuMuTauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tL1IsoTauMatch"
        self.tL1IsoTauMatch_branch = the_tree.GetBranch("tL1IsoTauMatch")
        #if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch" not in self.complained:
        if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch":
            warnings.warn( "MuMuTauTree: Expected branch tL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauMatch")
        else:
            self.tL1IsoTauMatch_branch.SetAddress(<void*>&self.tL1IsoTauMatch_value)

        #print "making tL1IsoTauPt"
        self.tL1IsoTauPt_branch = the_tree.GetBranch("tL1IsoTauPt")
        #if not self.tL1IsoTauPt_branch and "tL1IsoTauPt" not in self.complained:
        if not self.tL1IsoTauPt_branch and "tL1IsoTauPt":
            warnings.warn( "MuMuTauTree: Expected branch tL1IsoTauPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauPt")
        else:
            self.tL1IsoTauPt_branch.SetAddress(<void*>&self.tL1IsoTauPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "MuMuTauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "MuMuTauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "MuMuTauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMatchesDoubleMediumTau35Filter"
        self.tMatchesDoubleMediumTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Filter")
        #if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleMediumTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Filter")
        else:
            self.tMatchesDoubleMediumTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Filter_value)

        #print "making tMatchesDoubleMediumTau35Path"
        self.tMatchesDoubleMediumTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Path")
        #if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleMediumTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Path")
        else:
            self.tMatchesDoubleMediumTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Path_value)

        #print "making tMatchesDoubleMediumTau40Filter"
        self.tMatchesDoubleMediumTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Filter")
        #if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleMediumTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Filter")
        else:
            self.tMatchesDoubleMediumTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Filter_value)

        #print "making tMatchesDoubleMediumTau40Path"
        self.tMatchesDoubleMediumTau40Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Path")
        #if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleMediumTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Path")
        else:
            self.tMatchesDoubleMediumTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Path_value)

        #print "making tMatchesDoubleTightTau35Filter"
        self.tMatchesDoubleTightTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Filter")
        #if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleTightTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Filter")
        else:
            self.tMatchesDoubleTightTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Filter_value)

        #print "making tMatchesDoubleTightTau35Path"
        self.tMatchesDoubleTightTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Path")
        #if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path" not in self.complained:
        if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleTightTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Path")
        else:
            self.tMatchesDoubleTightTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Path_value)

        #print "making tMatchesDoubleTightTau40Filter"
        self.tMatchesDoubleTightTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Filter")
        #if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleTightTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Filter")
        else:
            self.tMatchesDoubleTightTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Filter_value)

        #print "making tMatchesDoubleTightTau40Path"
        self.tMatchesDoubleTightTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Path")
        #if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path" not in self.complained:
        if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesDoubleTightTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Path")
        else:
            self.tMatchesDoubleTightTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Path_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMatchesIsoMu20Tau27Filter"
        self.tMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Filter")
        #if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Filter")
        else:
            self.tMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Filter_value)

        #print "making tMatchesIsoMu20Tau27Path"
        self.tMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Path")
        #if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuTauTree: Expected branch tMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Path")
        else:
            self.tMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Path_value)

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "MuMuTauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "MuMuTauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "MuMuTauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "MuMuTauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "MuMuTauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "MuMuTauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "MuMuTauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "MuMuTauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "MuMuTauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "MuMuTauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "MuMuTauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "MuMuTauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "MuMuTauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuMuTauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "MuMuTauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "MuMuTauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "MuMuTauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRerunMVArun2v1DBoldDMwLTLoose"
        self.tRerunMVArun2v1DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v1DBoldDMwLTLoose_branch and "tRerunMVArun2v1DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTLoose_branch and "tRerunMVArun2v1DBoldDMwLTLoose":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v1DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v1DBoldDMwLTMedium"
        self.tRerunMVArun2v1DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v1DBoldDMwLTMedium_branch and "tRerunMVArun2v1DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTMedium_branch and "tRerunMVArun2v1DBoldDMwLTMedium":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v1DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v1DBoldDMwLTTight"
        self.tRerunMVArun2v1DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTTight_branch and "tRerunMVArun2v1DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTTight_branch and "tRerunMVArun2v1DBoldDMwLTTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVLoose"
        self.tRerunMVArun2v1DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v1DBoldDMwLTVLoose_branch and "tRerunMVArun2v1DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVLoose_branch and "tRerunMVArun2v1DBoldDMwLTVLoose":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVTight"
        self.tRerunMVArun2v1DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTVTight_branch and "tRerunMVArun2v1DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVTight_branch and "tRerunMVArun2v1DBoldDMwLTVTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTVVTight"
        self.tRerunMVArun2v1DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v1DBoldDMwLTVVTight_branch and "tRerunMVArun2v1DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTVVTight_branch and "tRerunMVArun2v1DBoldDMwLTVVTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v1DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v1DBoldDMwLTraw"
        self.tRerunMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v1DBoldDMwLTraw")
        #if not self.tRerunMVArun2v1DBoldDMwLTraw_branch and "tRerunMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v1DBoldDMwLTraw_branch and "tRerunMVArun2v1DBoldDMwLTraw":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v1DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v1DBoldDMwLTraw_value)

        #print "making tRerunMVArun2v2DBoldDMwLTLoose"
        self.tRerunMVArun2v2DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTMedium"
        self.tRerunMVArun2v2DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v2DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v2DBoldDMwLTTight"
        self.tRerunMVArun2v2DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVTight"
        self.tRerunMVArun2v2DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVTight"
        self.tRerunMVArun2v2DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTraw"
        self.tRerunMVArun2v2DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTraw")
        #if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw":
            warnings.warn( "MuMuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v2DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTraw_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "MuMuTauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "MuMuTauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "MuMuTauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "MuMuTauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "MuMuTauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "MuMuTauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuMuTauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuMuTauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuMuTauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "MuMuTauTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuMuTauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "MuMuTauTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMu12_10_5Group"
        self.tripleMu12_10_5Group_branch = the_tree.GetBranch("tripleMu12_10_5Group")
        #if not self.tripleMu12_10_5Group_branch and "tripleMu12_10_5Group" not in self.complained:
        if not self.tripleMu12_10_5Group_branch and "tripleMu12_10_5Group":
            warnings.warn( "MuMuTauTree: Expected branch tripleMu12_10_5Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Group")
        else:
            self.tripleMu12_10_5Group_branch.SetAddress(<void*>&self.tripleMu12_10_5Group_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "MuMuTauTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making tripleMu12_10_5Prescale"
        self.tripleMu12_10_5Prescale_branch = the_tree.GetBranch("tripleMu12_10_5Prescale")
        #if not self.tripleMu12_10_5Prescale_branch and "tripleMu12_10_5Prescale" not in self.complained:
        if not self.tripleMu12_10_5Prescale_branch and "tripleMu12_10_5Prescale":
            warnings.warn( "MuMuTauTree: Expected branch tripleMu12_10_5Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Prescale")
        else:
            self.tripleMu12_10_5Prescale_branch.SetAddress(<void*>&self.tripleMu12_10_5Prescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuMuTauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuMuTauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuMuTauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuMuTauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "MuMuTauTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuMuTauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuMuTauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuMuTauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuMuTauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuMuTauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuMuTauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuMuTauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuMuTauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property m1BestTrackType:
        def __get__(self):
            self.m1BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m1BestTrackType_value

    property m1Charge:
        def __get__(self):
            self.m1Charge_branch.GetEntry(self.localentry, 0)
            return self.m1Charge_value

    property m1Chi2LocalPosition:
        def __get__(self):
            self.m1Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m1Chi2LocalPosition_value

    property m1ComesFromHiggs:
        def __get__(self):
            self.m1ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m1ComesFromHiggs_value

    property m1CutBasedIdGlobalHighPt:
        def __get__(self):
            self.m1CutBasedIdGlobalHighPt_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdGlobalHighPt_value

    property m1CutBasedIdLoose:
        def __get__(self):
            self.m1CutBasedIdLoose_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdLoose_value

    property m1CutBasedIdMedium:
        def __get__(self):
            self.m1CutBasedIdMedium_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdMedium_value

    property m1CutBasedIdMediumPrompt:
        def __get__(self):
            self.m1CutBasedIdMediumPrompt_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdMediumPrompt_value

    property m1CutBasedIdTight:
        def __get__(self):
            self.m1CutBasedIdTight_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdTight_value

    property m1CutBasedIdTrkHighPt:
        def __get__(self):
            self.m1CutBasedIdTrkHighPt_branch.GetEntry(self.localentry, 0)
            return self.m1CutBasedIdTrkHighPt_value

    property m1EcalIsoDR03:
        def __get__(self):
            self.m1EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1EcalIsoDR03_value

    property m1EffectiveArea2011:
        def __get__(self):
            self.m1EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2011_value

    property m1EffectiveArea2012:
        def __get__(self):
            self.m1EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m1EffectiveArea2012_value

    property m1Eta:
        def __get__(self):
            self.m1Eta_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_value

    property m1Eta_MuonEnDown:
        def __get__(self):
            self.m1Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_MuonEnDown_value

    property m1Eta_MuonEnUp:
        def __get__(self):
            self.m1Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Eta_MuonEnUp_value

    property m1GenCharge:
        def __get__(self):
            self.m1GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m1GenCharge_value

    property m1GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m1GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m1GenDirectPromptTauDecayFinalState_value

    property m1GenEnergy:
        def __get__(self):
            self.m1GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m1GenEnergy_value

    property m1GenEta:
        def __get__(self):
            self.m1GenEta_branch.GetEntry(self.localentry, 0)
            return self.m1GenEta_value

    property m1GenIsPrompt:
        def __get__(self):
            self.m1GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m1GenIsPrompt_value

    property m1GenMotherPdgId:
        def __get__(self):
            self.m1GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenMotherPdgId_value

    property m1GenParticle:
        def __get__(self):
            self.m1GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m1GenParticle_value

    property m1GenPdgId:
        def __get__(self):
            self.m1GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m1GenPdgId_value

    property m1GenPhi:
        def __get__(self):
            self.m1GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1GenPhi_value

    property m1GenPrompt:
        def __get__(self):
            self.m1GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m1GenPrompt_value

    property m1GenPromptFinalState:
        def __get__(self):
            self.m1GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m1GenPromptFinalState_value

    property m1GenPromptTauDecay:
        def __get__(self):
            self.m1GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m1GenPromptTauDecay_value

    property m1GenPt:
        def __get__(self):
            self.m1GenPt_branch.GetEntry(self.localentry, 0)
            return self.m1GenPt_value

    property m1GenTauDecay:
        def __get__(self):
            self.m1GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m1GenTauDecay_value

    property m1GenVZ:
        def __get__(self):
            self.m1GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m1GenVZ_value

    property m1GenVtxPVMatch:
        def __get__(self):
            self.m1GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m1GenVtxPVMatch_value

    property m1HcalIsoDR03:
        def __get__(self):
            self.m1HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1HcalIsoDR03_value

    property m1IP3D:
        def __get__(self):
            self.m1IP3D_branch.GetEntry(self.localentry, 0)
            return self.m1IP3D_value

    property m1IP3DErr:
        def __get__(self):
            self.m1IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m1IP3DErr_value

    property m1IsGlobal:
        def __get__(self):
            self.m1IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m1IsGlobal_value

    property m1IsPFMuon:
        def __get__(self):
            self.m1IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m1IsPFMuon_value

    property m1IsTracker:
        def __get__(self):
            self.m1IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m1IsTracker_value

    property m1IsoDB03:
        def __get__(self):
            self.m1IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB03_value

    property m1IsoDB04:
        def __get__(self):
            self.m1IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m1IsoDB04_value

    property m1JetArea:
        def __get__(self):
            self.m1JetArea_branch.GetEntry(self.localentry, 0)
            return self.m1JetArea_value

    property m1JetBtag:
        def __get__(self):
            self.m1JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetBtag_value

    property m1JetDR:
        def __get__(self):
            self.m1JetDR_branch.GetEntry(self.localentry, 0)
            return self.m1JetDR_value

    property m1JetEtaEtaMoment:
        def __get__(self):
            self.m1JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaEtaMoment_value

    property m1JetEtaPhiMoment:
        def __get__(self):
            self.m1JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiMoment_value

    property m1JetEtaPhiSpread:
        def __get__(self):
            self.m1JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m1JetEtaPhiSpread_value

    property m1JetHadronFlavour:
        def __get__(self):
            self.m1JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m1JetHadronFlavour_value

    property m1JetPFCISVBtag:
        def __get__(self):
            self.m1JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m1JetPFCISVBtag_value

    property m1JetPartonFlavour:
        def __get__(self):
            self.m1JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m1JetPartonFlavour_value

    property m1JetPhiPhiMoment:
        def __get__(self):
            self.m1JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m1JetPhiPhiMoment_value

    property m1JetPt:
        def __get__(self):
            self.m1JetPt_branch.GetEntry(self.localentry, 0)
            return self.m1JetPt_value

    property m1LowestMll:
        def __get__(self):
            self.m1LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m1LowestMll_value

    property m1Mass:
        def __get__(self):
            self.m1Mass_branch.GetEntry(self.localentry, 0)
            return self.m1Mass_value

    property m1MatchedStations:
        def __get__(self):
            self.m1MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m1MatchedStations_value

    property m1MatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.m1MatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Tau27Filter_value

    property m1MatchesIsoMu20Tau27Path:
        def __get__(self):
            self.m1MatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Tau27Path_value

    property m1MatchesIsoMu24Filter:
        def __get__(self):
            self.m1MatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Filter_value

    property m1MatchesIsoMu24Path:
        def __get__(self):
            self.m1MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Path_value

    property m1MatchesIsoMu27Filter:
        def __get__(self):
            self.m1MatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu27Filter_value

    property m1MatchesIsoMu27Path:
        def __get__(self):
            self.m1MatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu27Path_value

    property m1MiniIsoLoose:
        def __get__(self):
            self.m1MiniIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m1MiniIsoLoose_value

    property m1MiniIsoMedium:
        def __get__(self):
            self.m1MiniIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m1MiniIsoMedium_value

    property m1MiniIsoTight:
        def __get__(self):
            self.m1MiniIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m1MiniIsoTight_value

    property m1MiniIsoVeryTight:
        def __get__(self):
            self.m1MiniIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m1MiniIsoVeryTight_value

    property m1MuonHits:
        def __get__(self):
            self.m1MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m1MuonHits_value

    property m1MvaLoose:
        def __get__(self):
            self.m1MvaLoose_branch.GetEntry(self.localentry, 0)
            return self.m1MvaLoose_value

    property m1MvaMedium:
        def __get__(self):
            self.m1MvaMedium_branch.GetEntry(self.localentry, 0)
            return self.m1MvaMedium_value

    property m1MvaTight:
        def __get__(self):
            self.m1MvaTight_branch.GetEntry(self.localentry, 0)
            return self.m1MvaTight_value

    property m1NearestZMass:
        def __get__(self):
            self.m1NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m1NearestZMass_value

    property m1NormTrkChi2:
        def __get__(self):
            self.m1NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m1NormTrkChi2_value

    property m1NormalizedChi2:
        def __get__(self):
            self.m1NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m1NormalizedChi2_value

    property m1PFChargedHadronIsoR04:
        def __get__(self):
            self.m1PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedHadronIsoR04_value

    property m1PFChargedIso:
        def __get__(self):
            self.m1PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFChargedIso_value

    property m1PFIDLoose:
        def __get__(self):
            self.m1PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDLoose_value

    property m1PFIDMedium:
        def __get__(self):
            self.m1PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDMedium_value

    property m1PFIDTight:
        def __get__(self):
            self.m1PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIDTight_value

    property m1PFIsoLoose:
        def __get__(self):
            self.m1PFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoLoose_value

    property m1PFIsoMedium:
        def __get__(self):
            self.m1PFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoMedium_value

    property m1PFIsoTight:
        def __get__(self):
            self.m1PFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoTight_value

    property m1PFIsoVeryLoose:
        def __get__(self):
            self.m1PFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoVeryLoose_value

    property m1PFIsoVeryTight:
        def __get__(self):
            self.m1PFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m1PFIsoVeryTight_value

    property m1PFNeutralHadronIsoR04:
        def __get__(self):
            self.m1PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralHadronIsoR04_value

    property m1PFNeutralIso:
        def __get__(self):
            self.m1PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFNeutralIso_value

    property m1PFPUChargedIso:
        def __get__(self):
            self.m1PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPUChargedIso_value

    property m1PFPhotonIso:
        def __get__(self):
            self.m1PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIso_value

    property m1PFPhotonIsoR04:
        def __get__(self):
            self.m1PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPhotonIsoR04_value

    property m1PFPileupIsoR04:
        def __get__(self):
            self.m1PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m1PFPileupIsoR04_value

    property m1PVDXY:
        def __get__(self):
            self.m1PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m1PVDXY_value

    property m1PVDZ:
        def __get__(self):
            self.m1PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m1PVDZ_value

    property m1Phi:
        def __get__(self):
            self.m1Phi_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_value

    property m1Phi_MuonEnDown:
        def __get__(self):
            self.m1Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_MuonEnDown_value

    property m1Phi_MuonEnUp:
        def __get__(self):
            self.m1Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Phi_MuonEnUp_value

    property m1PixHits:
        def __get__(self):
            self.m1PixHits_branch.GetEntry(self.localentry, 0)
            return self.m1PixHits_value

    property m1Pt:
        def __get__(self):
            self.m1Pt_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_value

    property m1Pt_MuonEnDown:
        def __get__(self):
            self.m1Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_MuonEnDown_value

    property m1Pt_MuonEnUp:
        def __get__(self):
            self.m1Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1Pt_MuonEnUp_value

    property m1RelPFIsoDBDefault:
        def __get__(self):
            self.m1RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefault_value

    property m1RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m1RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoDBDefaultR04_value

    property m1RelPFIsoRho:
        def __get__(self):
            self.m1RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m1RelPFIsoRho_value

    property m1Rho:
        def __get__(self):
            self.m1Rho_branch.GetEntry(self.localentry, 0)
            return self.m1Rho_value

    property m1SIP2D:
        def __get__(self):
            self.m1SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m1SIP2D_value

    property m1SIP3D:
        def __get__(self):
            self.m1SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m1SIP3D_value

    property m1SegmentCompatibility:
        def __get__(self):
            self.m1SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m1SegmentCompatibility_value

    property m1SoftCutBasedId:
        def __get__(self):
            self.m1SoftCutBasedId_branch.GetEntry(self.localentry, 0)
            return self.m1SoftCutBasedId_value

    property m1TkIsoLoose:
        def __get__(self):
            self.m1TkIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m1TkIsoLoose_value

    property m1TkIsoTight:
        def __get__(self):
            self.m1TkIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m1TkIsoTight_value

    property m1TkLayersWithMeasurement:
        def __get__(self):
            self.m1TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m1TkLayersWithMeasurement_value

    property m1TrkIsoDR03:
        def __get__(self):
            self.m1TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m1TrkIsoDR03_value

    property m1TrkKink:
        def __get__(self):
            self.m1TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m1TrkKink_value

    property m1TypeCode:
        def __get__(self):
            self.m1TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m1TypeCode_value

    property m1VZ:
        def __get__(self):
            self.m1VZ_branch.GetEntry(self.localentry, 0)
            return self.m1VZ_value

    property m1ValidFraction:
        def __get__(self):
            self.m1ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m1ValidFraction_value

    property m1ZTTGenMatching:
        def __get__(self):
            self.m1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenMatching_value

    property m1_m2_doubleL1IsoTauMatch:
        def __get__(self):
            self.m1_m2_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_doubleL1IsoTauMatch_value

    property m1_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.m1_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m1_t_doubleL1IsoTauMatch_value

    property m2BestTrackType:
        def __get__(self):
            self.m2BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m2BestTrackType_value

    property m2Charge:
        def __get__(self):
            self.m2Charge_branch.GetEntry(self.localentry, 0)
            return self.m2Charge_value

    property m2Chi2LocalPosition:
        def __get__(self):
            self.m2Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m2Chi2LocalPosition_value

    property m2ComesFromHiggs:
        def __get__(self):
            self.m2ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m2ComesFromHiggs_value

    property m2CutBasedIdGlobalHighPt:
        def __get__(self):
            self.m2CutBasedIdGlobalHighPt_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdGlobalHighPt_value

    property m2CutBasedIdLoose:
        def __get__(self):
            self.m2CutBasedIdLoose_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdLoose_value

    property m2CutBasedIdMedium:
        def __get__(self):
            self.m2CutBasedIdMedium_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdMedium_value

    property m2CutBasedIdMediumPrompt:
        def __get__(self):
            self.m2CutBasedIdMediumPrompt_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdMediumPrompt_value

    property m2CutBasedIdTight:
        def __get__(self):
            self.m2CutBasedIdTight_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdTight_value

    property m2CutBasedIdTrkHighPt:
        def __get__(self):
            self.m2CutBasedIdTrkHighPt_branch.GetEntry(self.localentry, 0)
            return self.m2CutBasedIdTrkHighPt_value

    property m2EcalIsoDR03:
        def __get__(self):
            self.m2EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2EcalIsoDR03_value

    property m2EffectiveArea2011:
        def __get__(self):
            self.m2EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2011_value

    property m2EffectiveArea2012:
        def __get__(self):
            self.m2EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m2EffectiveArea2012_value

    property m2Eta:
        def __get__(self):
            self.m2Eta_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_value

    property m2Eta_MuonEnDown:
        def __get__(self):
            self.m2Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_MuonEnDown_value

    property m2Eta_MuonEnUp:
        def __get__(self):
            self.m2Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Eta_MuonEnUp_value

    property m2GenCharge:
        def __get__(self):
            self.m2GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m2GenCharge_value

    property m2GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m2GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m2GenDirectPromptTauDecayFinalState_value

    property m2GenEnergy:
        def __get__(self):
            self.m2GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m2GenEnergy_value

    property m2GenEta:
        def __get__(self):
            self.m2GenEta_branch.GetEntry(self.localentry, 0)
            return self.m2GenEta_value

    property m2GenIsPrompt:
        def __get__(self):
            self.m2GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m2GenIsPrompt_value

    property m2GenMotherPdgId:
        def __get__(self):
            self.m2GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenMotherPdgId_value

    property m2GenParticle:
        def __get__(self):
            self.m2GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m2GenParticle_value

    property m2GenPdgId:
        def __get__(self):
            self.m2GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m2GenPdgId_value

    property m2GenPhi:
        def __get__(self):
            self.m2GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2GenPhi_value

    property m2GenPrompt:
        def __get__(self):
            self.m2GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m2GenPrompt_value

    property m2GenPromptFinalState:
        def __get__(self):
            self.m2GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m2GenPromptFinalState_value

    property m2GenPromptTauDecay:
        def __get__(self):
            self.m2GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m2GenPromptTauDecay_value

    property m2GenPt:
        def __get__(self):
            self.m2GenPt_branch.GetEntry(self.localentry, 0)
            return self.m2GenPt_value

    property m2GenTauDecay:
        def __get__(self):
            self.m2GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m2GenTauDecay_value

    property m2GenVZ:
        def __get__(self):
            self.m2GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m2GenVZ_value

    property m2GenVtxPVMatch:
        def __get__(self):
            self.m2GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m2GenVtxPVMatch_value

    property m2HcalIsoDR03:
        def __get__(self):
            self.m2HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2HcalIsoDR03_value

    property m2IP3D:
        def __get__(self):
            self.m2IP3D_branch.GetEntry(self.localentry, 0)
            return self.m2IP3D_value

    property m2IP3DErr:
        def __get__(self):
            self.m2IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m2IP3DErr_value

    property m2IsGlobal:
        def __get__(self):
            self.m2IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m2IsGlobal_value

    property m2IsPFMuon:
        def __get__(self):
            self.m2IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m2IsPFMuon_value

    property m2IsTracker:
        def __get__(self):
            self.m2IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m2IsTracker_value

    property m2IsoDB03:
        def __get__(self):
            self.m2IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB03_value

    property m2IsoDB04:
        def __get__(self):
            self.m2IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m2IsoDB04_value

    property m2JetArea:
        def __get__(self):
            self.m2JetArea_branch.GetEntry(self.localentry, 0)
            return self.m2JetArea_value

    property m2JetBtag:
        def __get__(self):
            self.m2JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetBtag_value

    property m2JetDR:
        def __get__(self):
            self.m2JetDR_branch.GetEntry(self.localentry, 0)
            return self.m2JetDR_value

    property m2JetEtaEtaMoment:
        def __get__(self):
            self.m2JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaEtaMoment_value

    property m2JetEtaPhiMoment:
        def __get__(self):
            self.m2JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiMoment_value

    property m2JetEtaPhiSpread:
        def __get__(self):
            self.m2JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m2JetEtaPhiSpread_value

    property m2JetHadronFlavour:
        def __get__(self):
            self.m2JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m2JetHadronFlavour_value

    property m2JetPFCISVBtag:
        def __get__(self):
            self.m2JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m2JetPFCISVBtag_value

    property m2JetPartonFlavour:
        def __get__(self):
            self.m2JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m2JetPartonFlavour_value

    property m2JetPhiPhiMoment:
        def __get__(self):
            self.m2JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m2JetPhiPhiMoment_value

    property m2JetPt:
        def __get__(self):
            self.m2JetPt_branch.GetEntry(self.localentry, 0)
            return self.m2JetPt_value

    property m2LowestMll:
        def __get__(self):
            self.m2LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m2LowestMll_value

    property m2Mass:
        def __get__(self):
            self.m2Mass_branch.GetEntry(self.localentry, 0)
            return self.m2Mass_value

    property m2MatchedStations:
        def __get__(self):
            self.m2MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m2MatchedStations_value

    property m2MatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.m2MatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Tau27Filter_value

    property m2MatchesIsoMu20Tau27Path:
        def __get__(self):
            self.m2MatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Tau27Path_value

    property m2MatchesIsoMu24Filter:
        def __get__(self):
            self.m2MatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Filter_value

    property m2MatchesIsoMu24Path:
        def __get__(self):
            self.m2MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Path_value

    property m2MatchesIsoMu27Filter:
        def __get__(self):
            self.m2MatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu27Filter_value

    property m2MatchesIsoMu27Path:
        def __get__(self):
            self.m2MatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu27Path_value

    property m2MiniIsoLoose:
        def __get__(self):
            self.m2MiniIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m2MiniIsoLoose_value

    property m2MiniIsoMedium:
        def __get__(self):
            self.m2MiniIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m2MiniIsoMedium_value

    property m2MiniIsoTight:
        def __get__(self):
            self.m2MiniIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m2MiniIsoTight_value

    property m2MiniIsoVeryTight:
        def __get__(self):
            self.m2MiniIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m2MiniIsoVeryTight_value

    property m2MuonHits:
        def __get__(self):
            self.m2MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m2MuonHits_value

    property m2MvaLoose:
        def __get__(self):
            self.m2MvaLoose_branch.GetEntry(self.localentry, 0)
            return self.m2MvaLoose_value

    property m2MvaMedium:
        def __get__(self):
            self.m2MvaMedium_branch.GetEntry(self.localentry, 0)
            return self.m2MvaMedium_value

    property m2MvaTight:
        def __get__(self):
            self.m2MvaTight_branch.GetEntry(self.localentry, 0)
            return self.m2MvaTight_value

    property m2NearestZMass:
        def __get__(self):
            self.m2NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m2NearestZMass_value

    property m2NormTrkChi2:
        def __get__(self):
            self.m2NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m2NormTrkChi2_value

    property m2NormalizedChi2:
        def __get__(self):
            self.m2NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m2NormalizedChi2_value

    property m2PFChargedHadronIsoR04:
        def __get__(self):
            self.m2PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedHadronIsoR04_value

    property m2PFChargedIso:
        def __get__(self):
            self.m2PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFChargedIso_value

    property m2PFIDLoose:
        def __get__(self):
            self.m2PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDLoose_value

    property m2PFIDMedium:
        def __get__(self):
            self.m2PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDMedium_value

    property m2PFIDTight:
        def __get__(self):
            self.m2PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIDTight_value

    property m2PFIsoLoose:
        def __get__(self):
            self.m2PFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoLoose_value

    property m2PFIsoMedium:
        def __get__(self):
            self.m2PFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoMedium_value

    property m2PFIsoTight:
        def __get__(self):
            self.m2PFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoTight_value

    property m2PFIsoVeryLoose:
        def __get__(self):
            self.m2PFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoVeryLoose_value

    property m2PFIsoVeryTight:
        def __get__(self):
            self.m2PFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m2PFIsoVeryTight_value

    property m2PFNeutralHadronIsoR04:
        def __get__(self):
            self.m2PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralHadronIsoR04_value

    property m2PFNeutralIso:
        def __get__(self):
            self.m2PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFNeutralIso_value

    property m2PFPUChargedIso:
        def __get__(self):
            self.m2PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPUChargedIso_value

    property m2PFPhotonIso:
        def __get__(self):
            self.m2PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIso_value

    property m2PFPhotonIsoR04:
        def __get__(self):
            self.m2PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPhotonIsoR04_value

    property m2PFPileupIsoR04:
        def __get__(self):
            self.m2PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m2PFPileupIsoR04_value

    property m2PVDXY:
        def __get__(self):
            self.m2PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m2PVDXY_value

    property m2PVDZ:
        def __get__(self):
            self.m2PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m2PVDZ_value

    property m2Phi:
        def __get__(self):
            self.m2Phi_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_value

    property m2Phi_MuonEnDown:
        def __get__(self):
            self.m2Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_MuonEnDown_value

    property m2Phi_MuonEnUp:
        def __get__(self):
            self.m2Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Phi_MuonEnUp_value

    property m2PixHits:
        def __get__(self):
            self.m2PixHits_branch.GetEntry(self.localentry, 0)
            return self.m2PixHits_value

    property m2Pt:
        def __get__(self):
            self.m2Pt_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_value

    property m2Pt_MuonEnDown:
        def __get__(self):
            self.m2Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_MuonEnDown_value

    property m2Pt_MuonEnUp:
        def __get__(self):
            self.m2Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2Pt_MuonEnUp_value

    property m2RelPFIsoDBDefault:
        def __get__(self):
            self.m2RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefault_value

    property m2RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m2RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoDBDefaultR04_value

    property m2RelPFIsoRho:
        def __get__(self):
            self.m2RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m2RelPFIsoRho_value

    property m2Rho:
        def __get__(self):
            self.m2Rho_branch.GetEntry(self.localentry, 0)
            return self.m2Rho_value

    property m2SIP2D:
        def __get__(self):
            self.m2SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m2SIP2D_value

    property m2SIP3D:
        def __get__(self):
            self.m2SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m2SIP3D_value

    property m2SegmentCompatibility:
        def __get__(self):
            self.m2SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m2SegmentCompatibility_value

    property m2SoftCutBasedId:
        def __get__(self):
            self.m2SoftCutBasedId_branch.GetEntry(self.localentry, 0)
            return self.m2SoftCutBasedId_value

    property m2TkIsoLoose:
        def __get__(self):
            self.m2TkIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m2TkIsoLoose_value

    property m2TkIsoTight:
        def __get__(self):
            self.m2TkIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m2TkIsoTight_value

    property m2TkLayersWithMeasurement:
        def __get__(self):
            self.m2TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m2TkLayersWithMeasurement_value

    property m2TrkIsoDR03:
        def __get__(self):
            self.m2TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m2TrkIsoDR03_value

    property m2TrkKink:
        def __get__(self):
            self.m2TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m2TrkKink_value

    property m2TypeCode:
        def __get__(self):
            self.m2TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m2TypeCode_value

    property m2VZ:
        def __get__(self):
            self.m2VZ_branch.GetEntry(self.localentry, 0)
            return self.m2VZ_value

    property m2ValidFraction:
        def __get__(self):
            self.m2ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m2ValidFraction_value

    property m2ZTTGenMatching:
        def __get__(self):
            self.m2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenMatching_value

    property m2_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.m2_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m2_t_doubleL1IsoTauMatch_value

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

    property tAgainstElectronLooseMVA6:
        def __get__(self):
            self.tAgainstElectronLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronLooseMVA6_value

    property tAgainstElectronMVA6Raw:
        def __get__(self):
            self.tAgainstElectronMVA6Raw_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6Raw_value

    property tAgainstElectronMVA6category:
        def __get__(self):
            self.tAgainstElectronMVA6category_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMVA6category_value

    property tAgainstElectronMediumMVA6:
        def __get__(self):
            self.tAgainstElectronMediumMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronMediumMVA6_value

    property tAgainstElectronTightMVA6:
        def __get__(self):
            self.tAgainstElectronTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronTightMVA6_value

    property tAgainstElectronVLooseMVA6:
        def __get__(self):
            self.tAgainstElectronVLooseMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVLooseMVA6_value

    property tAgainstElectronVTightMVA6:
        def __get__(self):
            self.tAgainstElectronVTightMVA6_branch.GetEntry(self.localentry, 0)
            return self.tAgainstElectronVTightMVA6_value

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

    property tLowestMll:
        def __get__(self):
            self.tLowestMll_branch.GetEntry(self.localentry, 0)
            return self.tLowestMll_value

    property tMass:
        def __get__(self):
            self.tMass_branch.GetEntry(self.localentry, 0)
            return self.tMass_value

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

    property tMatchesEle24Tau30Filter:
        def __get__(self):
            self.tMatchesEle24Tau30Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Filter_value

    property tMatchesEle24Tau30Path:
        def __get__(self):
            self.tMatchesEle24Tau30Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesEle24Tau30Path_value

    property tMatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.tMatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20Tau27Filter_value

    property tMatchesIsoMu20Tau27Path:
        def __get__(self):
            self.tMatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.tMatchesIsoMu20Tau27Path_value

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

    property tRerunMVArun2v1DBoldDMwLTLoose:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTLoose_value

    property tRerunMVArun2v1DBoldDMwLTMedium:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTMedium_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTMedium_value

    property tRerunMVArun2v1DBoldDMwLTTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTTight_value

    property tRerunMVArun2v1DBoldDMwLTVLoose:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVLoose_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVLoose_value

    property tRerunMVArun2v1DBoldDMwLTVTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVTight_value

    property tRerunMVArun2v1DBoldDMwLTVVTight:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTVVTight_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTVVTight_value

    property tRerunMVArun2v1DBoldDMwLTraw:
        def __get__(self):
            self.tRerunMVArun2v1DBoldDMwLTraw_branch.GetEntry(self.localentry, 0)
            return self.tRerunMVArun2v1DBoldDMwLTraw_value

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


