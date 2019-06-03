

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

cdef class MuMuMuTree:
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

    cdef TBranch* eVetoHZZPt5_branch
    cdef float eVetoHZZPt5_value

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

    cdef TBranch* m1MatchesIsoMu19Tau20Filter_branch
    cdef float m1MatchesIsoMu19Tau20Filter_value

    cdef TBranch* m1MatchesIsoMu19Tau20Path_branch
    cdef float m1MatchesIsoMu19Tau20Path_value

    cdef TBranch* m1MatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float m1MatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* m1MatchesIsoMu19Tau20SingleL1Path_branch
    cdef float m1MatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* m1MatchesIsoMu20HPSTau27Filter_branch
    cdef float m1MatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* m1MatchesIsoMu20HPSTau27Path_branch
    cdef float m1MatchesIsoMu20HPSTau27Path_value

    cdef TBranch* m1MatchesIsoMu20Tau27Filter_branch
    cdef float m1MatchesIsoMu20Tau27Filter_value

    cdef TBranch* m1MatchesIsoMu20Tau27Path_branch
    cdef float m1MatchesIsoMu20Tau27Path_value

    cdef TBranch* m1MatchesIsoMu22Filter_branch
    cdef float m1MatchesIsoMu22Filter_value

    cdef TBranch* m1MatchesIsoMu22Path_branch
    cdef float m1MatchesIsoMu22Path_value

    cdef TBranch* m1MatchesIsoMu22eta2p1Filter_branch
    cdef float m1MatchesIsoMu22eta2p1Filter_value

    cdef TBranch* m1MatchesIsoMu22eta2p1Path_branch
    cdef float m1MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m1MatchesIsoMu24Filter_branch
    cdef float m1MatchesIsoMu24Filter_value

    cdef TBranch* m1MatchesIsoMu24Path_branch
    cdef float m1MatchesIsoMu24Path_value

    cdef TBranch* m1MatchesIsoMu27Filter_branch
    cdef float m1MatchesIsoMu27Filter_value

    cdef TBranch* m1MatchesIsoMu27Path_branch
    cdef float m1MatchesIsoMu27Path_value

    cdef TBranch* m1MatchesIsoTkMu22Filter_branch
    cdef float m1MatchesIsoTkMu22Filter_value

    cdef TBranch* m1MatchesIsoTkMu22Path_branch
    cdef float m1MatchesIsoTkMu22Path_value

    cdef TBranch* m1MatchesIsoTkMu22eta2p1Filter_branch
    cdef float m1MatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* m1MatchesIsoTkMu22eta2p1Path_branch
    cdef float m1MatchesIsoTkMu22eta2p1Path_value

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

    cdef TBranch* m1ZTTGenDR_branch
    cdef float m1ZTTGenDR_value

    cdef TBranch* m1ZTTGenEta_branch
    cdef float m1ZTTGenEta_value

    cdef TBranch* m1ZTTGenMatching_branch
    cdef float m1ZTTGenMatching_value

    cdef TBranch* m1ZTTGenPhi_branch
    cdef float m1ZTTGenPhi_value

    cdef TBranch* m1ZTTGenPt_branch
    cdef float m1ZTTGenPt_value

    cdef TBranch* m1_m2_DR_branch
    cdef float m1_m2_DR_value

    cdef TBranch* m1_m2_Mass_branch
    cdef float m1_m2_Mass_value

    cdef TBranch* m1_m2_PZeta_branch
    cdef float m1_m2_PZeta_value

    cdef TBranch* m1_m2_PZetaVis_branch
    cdef float m1_m2_PZetaVis_value

    cdef TBranch* m1_m2_doubleL1IsoTauMatch_branch
    cdef float m1_m2_doubleL1IsoTauMatch_value

    cdef TBranch* m1_m3_DR_branch
    cdef float m1_m3_DR_value

    cdef TBranch* m1_m3_Mass_branch
    cdef float m1_m3_Mass_value

    cdef TBranch* m1_m3_PZeta_branch
    cdef float m1_m3_PZeta_value

    cdef TBranch* m1_m3_PZetaVis_branch
    cdef float m1_m3_PZetaVis_value

    cdef TBranch* m1_m3_doubleL1IsoTauMatch_branch
    cdef float m1_m3_doubleL1IsoTauMatch_value

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

    cdef TBranch* m2MatchesIsoMu19Tau20Filter_branch
    cdef float m2MatchesIsoMu19Tau20Filter_value

    cdef TBranch* m2MatchesIsoMu19Tau20Path_branch
    cdef float m2MatchesIsoMu19Tau20Path_value

    cdef TBranch* m2MatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float m2MatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* m2MatchesIsoMu19Tau20SingleL1Path_branch
    cdef float m2MatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* m2MatchesIsoMu20HPSTau27Filter_branch
    cdef float m2MatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* m2MatchesIsoMu20HPSTau27Path_branch
    cdef float m2MatchesIsoMu20HPSTau27Path_value

    cdef TBranch* m2MatchesIsoMu20Tau27Filter_branch
    cdef float m2MatchesIsoMu20Tau27Filter_value

    cdef TBranch* m2MatchesIsoMu20Tau27Path_branch
    cdef float m2MatchesIsoMu20Tau27Path_value

    cdef TBranch* m2MatchesIsoMu22Filter_branch
    cdef float m2MatchesIsoMu22Filter_value

    cdef TBranch* m2MatchesIsoMu22Path_branch
    cdef float m2MatchesIsoMu22Path_value

    cdef TBranch* m2MatchesIsoMu22eta2p1Filter_branch
    cdef float m2MatchesIsoMu22eta2p1Filter_value

    cdef TBranch* m2MatchesIsoMu22eta2p1Path_branch
    cdef float m2MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m2MatchesIsoMu24Filter_branch
    cdef float m2MatchesIsoMu24Filter_value

    cdef TBranch* m2MatchesIsoMu24Path_branch
    cdef float m2MatchesIsoMu24Path_value

    cdef TBranch* m2MatchesIsoMu27Filter_branch
    cdef float m2MatchesIsoMu27Filter_value

    cdef TBranch* m2MatchesIsoMu27Path_branch
    cdef float m2MatchesIsoMu27Path_value

    cdef TBranch* m2MatchesIsoTkMu22Filter_branch
    cdef float m2MatchesIsoTkMu22Filter_value

    cdef TBranch* m2MatchesIsoTkMu22Path_branch
    cdef float m2MatchesIsoTkMu22Path_value

    cdef TBranch* m2MatchesIsoTkMu22eta2p1Filter_branch
    cdef float m2MatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* m2MatchesIsoTkMu22eta2p1Path_branch
    cdef float m2MatchesIsoTkMu22eta2p1Path_value

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

    cdef TBranch* m2ZTTGenDR_branch
    cdef float m2ZTTGenDR_value

    cdef TBranch* m2ZTTGenEta_branch
    cdef float m2ZTTGenEta_value

    cdef TBranch* m2ZTTGenMatching_branch
    cdef float m2ZTTGenMatching_value

    cdef TBranch* m2ZTTGenPhi_branch
    cdef float m2ZTTGenPhi_value

    cdef TBranch* m2ZTTGenPt_branch
    cdef float m2ZTTGenPt_value

    cdef TBranch* m2_m3_DR_branch
    cdef float m2_m3_DR_value

    cdef TBranch* m2_m3_Mass_branch
    cdef float m2_m3_Mass_value

    cdef TBranch* m2_m3_PZeta_branch
    cdef float m2_m3_PZeta_value

    cdef TBranch* m2_m3_PZetaVis_branch
    cdef float m2_m3_PZetaVis_value

    cdef TBranch* m2_m3_doubleL1IsoTauMatch_branch
    cdef float m2_m3_doubleL1IsoTauMatch_value

    cdef TBranch* m3BestTrackType_branch
    cdef float m3BestTrackType_value

    cdef TBranch* m3Charge_branch
    cdef float m3Charge_value

    cdef TBranch* m3Chi2LocalPosition_branch
    cdef float m3Chi2LocalPosition_value

    cdef TBranch* m3ComesFromHiggs_branch
    cdef float m3ComesFromHiggs_value

    cdef TBranch* m3CutBasedIdGlobalHighPt_branch
    cdef float m3CutBasedIdGlobalHighPt_value

    cdef TBranch* m3CutBasedIdLoose_branch
    cdef float m3CutBasedIdLoose_value

    cdef TBranch* m3CutBasedIdMedium_branch
    cdef float m3CutBasedIdMedium_value

    cdef TBranch* m3CutBasedIdMediumPrompt_branch
    cdef float m3CutBasedIdMediumPrompt_value

    cdef TBranch* m3CutBasedIdTight_branch
    cdef float m3CutBasedIdTight_value

    cdef TBranch* m3CutBasedIdTrkHighPt_branch
    cdef float m3CutBasedIdTrkHighPt_value

    cdef TBranch* m3EcalIsoDR03_branch
    cdef float m3EcalIsoDR03_value

    cdef TBranch* m3EffectiveArea2011_branch
    cdef float m3EffectiveArea2011_value

    cdef TBranch* m3EffectiveArea2012_branch
    cdef float m3EffectiveArea2012_value

    cdef TBranch* m3Eta_branch
    cdef float m3Eta_value

    cdef TBranch* m3Eta_MuonEnDown_branch
    cdef float m3Eta_MuonEnDown_value

    cdef TBranch* m3Eta_MuonEnUp_branch
    cdef float m3Eta_MuonEnUp_value

    cdef TBranch* m3GenCharge_branch
    cdef float m3GenCharge_value

    cdef TBranch* m3GenDirectPromptTauDecayFinalState_branch
    cdef float m3GenDirectPromptTauDecayFinalState_value

    cdef TBranch* m3GenEnergy_branch
    cdef float m3GenEnergy_value

    cdef TBranch* m3GenEta_branch
    cdef float m3GenEta_value

    cdef TBranch* m3GenIsPrompt_branch
    cdef float m3GenIsPrompt_value

    cdef TBranch* m3GenMotherPdgId_branch
    cdef float m3GenMotherPdgId_value

    cdef TBranch* m3GenParticle_branch
    cdef float m3GenParticle_value

    cdef TBranch* m3GenPdgId_branch
    cdef float m3GenPdgId_value

    cdef TBranch* m3GenPhi_branch
    cdef float m3GenPhi_value

    cdef TBranch* m3GenPrompt_branch
    cdef float m3GenPrompt_value

    cdef TBranch* m3GenPromptFinalState_branch
    cdef float m3GenPromptFinalState_value

    cdef TBranch* m3GenPromptTauDecay_branch
    cdef float m3GenPromptTauDecay_value

    cdef TBranch* m3GenPt_branch
    cdef float m3GenPt_value

    cdef TBranch* m3GenTauDecay_branch
    cdef float m3GenTauDecay_value

    cdef TBranch* m3GenVZ_branch
    cdef float m3GenVZ_value

    cdef TBranch* m3GenVtxPVMatch_branch
    cdef float m3GenVtxPVMatch_value

    cdef TBranch* m3HcalIsoDR03_branch
    cdef float m3HcalIsoDR03_value

    cdef TBranch* m3IP3D_branch
    cdef float m3IP3D_value

    cdef TBranch* m3IP3DErr_branch
    cdef float m3IP3DErr_value

    cdef TBranch* m3IsGlobal_branch
    cdef float m3IsGlobal_value

    cdef TBranch* m3IsPFMuon_branch
    cdef float m3IsPFMuon_value

    cdef TBranch* m3IsTracker_branch
    cdef float m3IsTracker_value

    cdef TBranch* m3IsoDB03_branch
    cdef float m3IsoDB03_value

    cdef TBranch* m3IsoDB04_branch
    cdef float m3IsoDB04_value

    cdef TBranch* m3JetArea_branch
    cdef float m3JetArea_value

    cdef TBranch* m3JetBtag_branch
    cdef float m3JetBtag_value

    cdef TBranch* m3JetDR_branch
    cdef float m3JetDR_value

    cdef TBranch* m3JetEtaEtaMoment_branch
    cdef float m3JetEtaEtaMoment_value

    cdef TBranch* m3JetEtaPhiMoment_branch
    cdef float m3JetEtaPhiMoment_value

    cdef TBranch* m3JetEtaPhiSpread_branch
    cdef float m3JetEtaPhiSpread_value

    cdef TBranch* m3JetHadronFlavour_branch
    cdef float m3JetHadronFlavour_value

    cdef TBranch* m3JetPFCISVBtag_branch
    cdef float m3JetPFCISVBtag_value

    cdef TBranch* m3JetPartonFlavour_branch
    cdef float m3JetPartonFlavour_value

    cdef TBranch* m3JetPhiPhiMoment_branch
    cdef float m3JetPhiPhiMoment_value

    cdef TBranch* m3JetPt_branch
    cdef float m3JetPt_value

    cdef TBranch* m3LowestMll_branch
    cdef float m3LowestMll_value

    cdef TBranch* m3Mass_branch
    cdef float m3Mass_value

    cdef TBranch* m3MatchedStations_branch
    cdef float m3MatchedStations_value

    cdef TBranch* m3MatchesIsoMu19Tau20Filter_branch
    cdef float m3MatchesIsoMu19Tau20Filter_value

    cdef TBranch* m3MatchesIsoMu19Tau20Path_branch
    cdef float m3MatchesIsoMu19Tau20Path_value

    cdef TBranch* m3MatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float m3MatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* m3MatchesIsoMu19Tau20SingleL1Path_branch
    cdef float m3MatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* m3MatchesIsoMu20HPSTau27Filter_branch
    cdef float m3MatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* m3MatchesIsoMu20HPSTau27Path_branch
    cdef float m3MatchesIsoMu20HPSTau27Path_value

    cdef TBranch* m3MatchesIsoMu20Tau27Filter_branch
    cdef float m3MatchesIsoMu20Tau27Filter_value

    cdef TBranch* m3MatchesIsoMu20Tau27Path_branch
    cdef float m3MatchesIsoMu20Tau27Path_value

    cdef TBranch* m3MatchesIsoMu22Filter_branch
    cdef float m3MatchesIsoMu22Filter_value

    cdef TBranch* m3MatchesIsoMu22Path_branch
    cdef float m3MatchesIsoMu22Path_value

    cdef TBranch* m3MatchesIsoMu22eta2p1Filter_branch
    cdef float m3MatchesIsoMu22eta2p1Filter_value

    cdef TBranch* m3MatchesIsoMu22eta2p1Path_branch
    cdef float m3MatchesIsoMu22eta2p1Path_value

    cdef TBranch* m3MatchesIsoMu24Filter_branch
    cdef float m3MatchesIsoMu24Filter_value

    cdef TBranch* m3MatchesIsoMu24Path_branch
    cdef float m3MatchesIsoMu24Path_value

    cdef TBranch* m3MatchesIsoMu27Filter_branch
    cdef float m3MatchesIsoMu27Filter_value

    cdef TBranch* m3MatchesIsoMu27Path_branch
    cdef float m3MatchesIsoMu27Path_value

    cdef TBranch* m3MatchesIsoTkMu22Filter_branch
    cdef float m3MatchesIsoTkMu22Filter_value

    cdef TBranch* m3MatchesIsoTkMu22Path_branch
    cdef float m3MatchesIsoTkMu22Path_value

    cdef TBranch* m3MatchesIsoTkMu22eta2p1Filter_branch
    cdef float m3MatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* m3MatchesIsoTkMu22eta2p1Path_branch
    cdef float m3MatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* m3MiniIsoLoose_branch
    cdef float m3MiniIsoLoose_value

    cdef TBranch* m3MiniIsoMedium_branch
    cdef float m3MiniIsoMedium_value

    cdef TBranch* m3MiniIsoTight_branch
    cdef float m3MiniIsoTight_value

    cdef TBranch* m3MiniIsoVeryTight_branch
    cdef float m3MiniIsoVeryTight_value

    cdef TBranch* m3MuonHits_branch
    cdef float m3MuonHits_value

    cdef TBranch* m3MvaLoose_branch
    cdef float m3MvaLoose_value

    cdef TBranch* m3MvaMedium_branch
    cdef float m3MvaMedium_value

    cdef TBranch* m3MvaTight_branch
    cdef float m3MvaTight_value

    cdef TBranch* m3NearestZMass_branch
    cdef float m3NearestZMass_value

    cdef TBranch* m3NormTrkChi2_branch
    cdef float m3NormTrkChi2_value

    cdef TBranch* m3NormalizedChi2_branch
    cdef float m3NormalizedChi2_value

    cdef TBranch* m3PFChargedHadronIsoR04_branch
    cdef float m3PFChargedHadronIsoR04_value

    cdef TBranch* m3PFChargedIso_branch
    cdef float m3PFChargedIso_value

    cdef TBranch* m3PFIDLoose_branch
    cdef float m3PFIDLoose_value

    cdef TBranch* m3PFIDMedium_branch
    cdef float m3PFIDMedium_value

    cdef TBranch* m3PFIDTight_branch
    cdef float m3PFIDTight_value

    cdef TBranch* m3PFIsoLoose_branch
    cdef float m3PFIsoLoose_value

    cdef TBranch* m3PFIsoMedium_branch
    cdef float m3PFIsoMedium_value

    cdef TBranch* m3PFIsoTight_branch
    cdef float m3PFIsoTight_value

    cdef TBranch* m3PFIsoVeryLoose_branch
    cdef float m3PFIsoVeryLoose_value

    cdef TBranch* m3PFIsoVeryTight_branch
    cdef float m3PFIsoVeryTight_value

    cdef TBranch* m3PFNeutralHadronIsoR04_branch
    cdef float m3PFNeutralHadronIsoR04_value

    cdef TBranch* m3PFNeutralIso_branch
    cdef float m3PFNeutralIso_value

    cdef TBranch* m3PFPUChargedIso_branch
    cdef float m3PFPUChargedIso_value

    cdef TBranch* m3PFPhotonIso_branch
    cdef float m3PFPhotonIso_value

    cdef TBranch* m3PFPhotonIsoR04_branch
    cdef float m3PFPhotonIsoR04_value

    cdef TBranch* m3PFPileupIsoR04_branch
    cdef float m3PFPileupIsoR04_value

    cdef TBranch* m3PVDXY_branch
    cdef float m3PVDXY_value

    cdef TBranch* m3PVDZ_branch
    cdef float m3PVDZ_value

    cdef TBranch* m3Phi_branch
    cdef float m3Phi_value

    cdef TBranch* m3Phi_MuonEnDown_branch
    cdef float m3Phi_MuonEnDown_value

    cdef TBranch* m3Phi_MuonEnUp_branch
    cdef float m3Phi_MuonEnUp_value

    cdef TBranch* m3PixHits_branch
    cdef float m3PixHits_value

    cdef TBranch* m3Pt_branch
    cdef float m3Pt_value

    cdef TBranch* m3Pt_MuonEnDown_branch
    cdef float m3Pt_MuonEnDown_value

    cdef TBranch* m3Pt_MuonEnUp_branch
    cdef float m3Pt_MuonEnUp_value

    cdef TBranch* m3RelPFIsoDBDefault_branch
    cdef float m3RelPFIsoDBDefault_value

    cdef TBranch* m3RelPFIsoDBDefaultR04_branch
    cdef float m3RelPFIsoDBDefaultR04_value

    cdef TBranch* m3RelPFIsoRho_branch
    cdef float m3RelPFIsoRho_value

    cdef TBranch* m3Rho_branch
    cdef float m3Rho_value

    cdef TBranch* m3SIP2D_branch
    cdef float m3SIP2D_value

    cdef TBranch* m3SIP3D_branch
    cdef float m3SIP3D_value

    cdef TBranch* m3SegmentCompatibility_branch
    cdef float m3SegmentCompatibility_value

    cdef TBranch* m3SoftCutBasedId_branch
    cdef float m3SoftCutBasedId_value

    cdef TBranch* m3TkIsoLoose_branch
    cdef float m3TkIsoLoose_value

    cdef TBranch* m3TkIsoTight_branch
    cdef float m3TkIsoTight_value

    cdef TBranch* m3TkLayersWithMeasurement_branch
    cdef float m3TkLayersWithMeasurement_value

    cdef TBranch* m3TrkIsoDR03_branch
    cdef float m3TrkIsoDR03_value

    cdef TBranch* m3TrkKink_branch
    cdef float m3TrkKink_value

    cdef TBranch* m3TypeCode_branch
    cdef int m3TypeCode_value

    cdef TBranch* m3VZ_branch
    cdef float m3VZ_value

    cdef TBranch* m3ValidFraction_branch
    cdef float m3ValidFraction_value

    cdef TBranch* m3ZTTGenDR_branch
    cdef float m3ZTTGenDR_value

    cdef TBranch* m3ZTTGenEta_branch
    cdef float m3ZTTGenEta_value

    cdef TBranch* m3ZTTGenMatching_branch
    cdef float m3ZTTGenMatching_value

    cdef TBranch* m3ZTTGenPhi_branch
    cdef float m3ZTTGenPhi_value

    cdef TBranch* m3ZTTGenPt_branch
    cdef float m3ZTTGenPt_value

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
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "MuMuMuTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "MuMuMuTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "MuMuMuTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuMuMuTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuMuMuTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "MuMuMuTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "MuMuMuTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "MuMuMuTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "MuMuMuTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuMuMuTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuMuMuTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "MuMuMuTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "MuMuMuTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuMuTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuMuTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuMuTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuMuTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuMuMuTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "MuMuMuTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "MuMuMuTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "MuMuMuTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "MuMuMuTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuMuTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuMuMuTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuMuTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making Rivet_stage1p1_cat"
        self.Rivet_stage1p1_cat_branch = the_tree.GetBranch("Rivet_stage1p1_cat")
        #if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat" not in self.complained:
        if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat":
            warnings.warn( "MuMuMuTree: Expected branch Rivet_stage1p1_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1p1_cat")
        else:
            self.Rivet_stage1p1_cat_branch.SetAddress(<void*>&self.Rivet_stage1p1_cat_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "MuMuMuTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuMuTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuMuMuTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "MuMuMuTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuMuMuTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "MuMuMuTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making eVetoHZZPt5"
        self.eVetoHZZPt5_branch = the_tree.GetBranch("eVetoHZZPt5")
        #if not self.eVetoHZZPt5_branch and "eVetoHZZPt5" not in self.complained:
        if not self.eVetoHZZPt5_branch and "eVetoHZZPt5":
            warnings.warn( "MuMuMuTree: Expected branch eVetoHZZPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoHZZPt5")
        else:
            self.eVetoHZZPt5_branch.SetAddress(<void*>&self.eVetoHZZPt5_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuMuTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuMuMuTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuMuMuTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuMuTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuMuMuTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuMuMuTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuMuMuTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuMuMuTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuMuMuTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuMuMuTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuMuMuTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuMuMuTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "MuMuMuTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuMuTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuMuTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "MuMuMuTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "MuMuMuTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuMuTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuMuTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "MuMuMuTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuMuMuTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuMuMuTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuMuMuTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuMuMuTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuMuMuTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuMuMuTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuMuMuTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuMuMuTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "MuMuMuTree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuMuMuTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuMuTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuMuTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1Chi2LocalPosition"
        self.m1Chi2LocalPosition_branch = the_tree.GetBranch("m1Chi2LocalPosition")
        #if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition" not in self.complained:
        if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m1Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Chi2LocalPosition")
        else:
            self.m1Chi2LocalPosition_branch.SetAddress(<void*>&self.m1Chi2LocalPosition_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1CutBasedIdGlobalHighPt"
        self.m1CutBasedIdGlobalHighPt_branch = the_tree.GetBranch("m1CutBasedIdGlobalHighPt")
        #if not self.m1CutBasedIdGlobalHighPt_branch and "m1CutBasedIdGlobalHighPt" not in self.complained:
        if not self.m1CutBasedIdGlobalHighPt_branch and "m1CutBasedIdGlobalHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdGlobalHighPt")
        else:
            self.m1CutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.m1CutBasedIdGlobalHighPt_value)

        #print "making m1CutBasedIdLoose"
        self.m1CutBasedIdLoose_branch = the_tree.GetBranch("m1CutBasedIdLoose")
        #if not self.m1CutBasedIdLoose_branch and "m1CutBasedIdLoose" not in self.complained:
        if not self.m1CutBasedIdLoose_branch and "m1CutBasedIdLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdLoose")
        else:
            self.m1CutBasedIdLoose_branch.SetAddress(<void*>&self.m1CutBasedIdLoose_value)

        #print "making m1CutBasedIdMedium"
        self.m1CutBasedIdMedium_branch = the_tree.GetBranch("m1CutBasedIdMedium")
        #if not self.m1CutBasedIdMedium_branch and "m1CutBasedIdMedium" not in self.complained:
        if not self.m1CutBasedIdMedium_branch and "m1CutBasedIdMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdMedium")
        else:
            self.m1CutBasedIdMedium_branch.SetAddress(<void*>&self.m1CutBasedIdMedium_value)

        #print "making m1CutBasedIdMediumPrompt"
        self.m1CutBasedIdMediumPrompt_branch = the_tree.GetBranch("m1CutBasedIdMediumPrompt")
        #if not self.m1CutBasedIdMediumPrompt_branch and "m1CutBasedIdMediumPrompt" not in self.complained:
        if not self.m1CutBasedIdMediumPrompt_branch and "m1CutBasedIdMediumPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdMediumPrompt")
        else:
            self.m1CutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.m1CutBasedIdMediumPrompt_value)

        #print "making m1CutBasedIdTight"
        self.m1CutBasedIdTight_branch = the_tree.GetBranch("m1CutBasedIdTight")
        #if not self.m1CutBasedIdTight_branch and "m1CutBasedIdTight" not in self.complained:
        if not self.m1CutBasedIdTight_branch and "m1CutBasedIdTight":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdTight")
        else:
            self.m1CutBasedIdTight_branch.SetAddress(<void*>&self.m1CutBasedIdTight_value)

        #print "making m1CutBasedIdTrkHighPt"
        self.m1CutBasedIdTrkHighPt_branch = the_tree.GetBranch("m1CutBasedIdTrkHighPt")
        #if not self.m1CutBasedIdTrkHighPt_branch and "m1CutBasedIdTrkHighPt" not in self.complained:
        if not self.m1CutBasedIdTrkHighPt_branch and "m1CutBasedIdTrkHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m1CutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1CutBasedIdTrkHighPt")
        else:
            self.m1CutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.m1CutBasedIdTrkHighPt_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1Eta_MuonEnDown"
        self.m1Eta_MuonEnDown_branch = the_tree.GetBranch("m1Eta_MuonEnDown")
        #if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown" not in self.complained:
        if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnDown")
        else:
            self.m1Eta_MuonEnDown_branch.SetAddress(<void*>&self.m1Eta_MuonEnDown_value)

        #print "making m1Eta_MuonEnUp"
        self.m1Eta_MuonEnUp_branch = the_tree.GetBranch("m1Eta_MuonEnUp")
        #if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp" not in self.complained:
        if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnUp")
        else:
            self.m1Eta_MuonEnUp_branch.SetAddress(<void*>&self.m1Eta_MuonEnUp_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenDirectPromptTauDecayFinalState"
        self.m1GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m1GenDirectPromptTauDecayFinalState")
        #if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m1GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenDirectPromptTauDecayFinalState")
        else:
            self.m1GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m1GenDirectPromptTauDecayFinalState_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenIsPrompt"
        self.m1GenIsPrompt_branch = the_tree.GetBranch("m1GenIsPrompt")
        #if not self.m1GenIsPrompt_branch and "m1GenIsPrompt" not in self.complained:
        if not self.m1GenIsPrompt_branch and "m1GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenIsPrompt")
        else:
            self.m1GenIsPrompt_branch.SetAddress(<void*>&self.m1GenIsPrompt_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPrompt"
        self.m1GenPrompt_branch = the_tree.GetBranch("m1GenPrompt")
        #if not self.m1GenPrompt_branch and "m1GenPrompt" not in self.complained:
        if not self.m1GenPrompt_branch and "m1GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPrompt")
        else:
            self.m1GenPrompt_branch.SetAddress(<void*>&self.m1GenPrompt_value)

        #print "making m1GenPromptFinalState"
        self.m1GenPromptFinalState_branch = the_tree.GetBranch("m1GenPromptFinalState")
        #if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState" not in self.complained:
        if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptFinalState")
        else:
            self.m1GenPromptFinalState_branch.SetAddress(<void*>&self.m1GenPromptFinalState_value)

        #print "making m1GenPromptTauDecay"
        self.m1GenPromptTauDecay_branch = the_tree.GetBranch("m1GenPromptTauDecay")
        #if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay" not in self.complained:
        if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptTauDecay")
        else:
            self.m1GenPromptTauDecay_branch.SetAddress(<void*>&self.m1GenPromptTauDecay_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenTauDecay"
        self.m1GenTauDecay_branch = the_tree.GetBranch("m1GenTauDecay")
        #if not self.m1GenTauDecay_branch and "m1GenTauDecay" not in self.complained:
        if not self.m1GenTauDecay_branch and "m1GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenTauDecay")
        else:
            self.m1GenTauDecay_branch.SetAddress(<void*>&self.m1GenTauDecay_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1GenVtxPVMatch"
        self.m1GenVtxPVMatch_branch = the_tree.GetBranch("m1GenVtxPVMatch")
        #if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch" not in self.complained:
        if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVtxPVMatch")
        else:
            self.m1GenVtxPVMatch_branch.SetAddress(<void*>&self.m1GenVtxPVMatch_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DErr"
        self.m1IP3DErr_branch = the_tree.GetBranch("m1IP3DErr")
        #if not self.m1IP3DErr_branch and "m1IP3DErr" not in self.complained:
        if not self.m1IP3DErr_branch and "m1IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DErr")
        else:
            self.m1IP3DErr_branch.SetAddress(<void*>&self.m1IP3DErr_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetDR"
        self.m1JetDR_branch = the_tree.GetBranch("m1JetDR")
        #if not self.m1JetDR_branch and "m1JetDR" not in self.complained:
        if not self.m1JetDR_branch and "m1JetDR":
            warnings.warn( "MuMuMuTree: Expected branch m1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetDR")
        else:
            self.m1JetDR_branch.SetAddress(<void*>&self.m1JetDR_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetHadronFlavour"
        self.m1JetHadronFlavour_branch = the_tree.GetBranch("m1JetHadronFlavour")
        #if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour" not in self.complained:
        if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetHadronFlavour")
        else:
            self.m1JetHadronFlavour_branch.SetAddress(<void*>&self.m1JetHadronFlavour_value)

        #print "making m1JetPFCISVBtag"
        self.m1JetPFCISVBtag_branch = the_tree.GetBranch("m1JetPFCISVBtag")
        #if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag" not in self.complained:
        if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPFCISVBtag")
        else:
            self.m1JetPFCISVBtag_branch.SetAddress(<void*>&self.m1JetPFCISVBtag_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1LowestMll"
        self.m1LowestMll_branch = the_tree.GetBranch("m1LowestMll")
        #if not self.m1LowestMll_branch and "m1LowestMll" not in self.complained:
        if not self.m1LowestMll_branch and "m1LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1LowestMll")
        else:
            self.m1LowestMll_branch.SetAddress(<void*>&self.m1LowestMll_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesIsoMu19Tau20Filter"
        self.m1MatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("m1MatchesIsoMu19Tau20Filter")
        #if not self.m1MatchesIsoMu19Tau20Filter_branch and "m1MatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.m1MatchesIsoMu19Tau20Filter_branch and "m1MatchesIsoMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu19Tau20Filter")
        else:
            self.m1MatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu19Tau20Filter_value)

        #print "making m1MatchesIsoMu19Tau20Path"
        self.m1MatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("m1MatchesIsoMu19Tau20Path")
        #if not self.m1MatchesIsoMu19Tau20Path_branch and "m1MatchesIsoMu19Tau20Path" not in self.complained:
        if not self.m1MatchesIsoMu19Tau20Path_branch and "m1MatchesIsoMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu19Tau20Path")
        else:
            self.m1MatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu19Tau20Path_value)

        #print "making m1MatchesIsoMu19Tau20SingleL1Filter"
        self.m1MatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("m1MatchesIsoMu19Tau20SingleL1Filter")
        #if not self.m1MatchesIsoMu19Tau20SingleL1Filter_branch and "m1MatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.m1MatchesIsoMu19Tau20SingleL1Filter_branch and "m1MatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.m1MatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making m1MatchesIsoMu19Tau20SingleL1Path"
        self.m1MatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("m1MatchesIsoMu19Tau20SingleL1Path")
        #if not self.m1MatchesIsoMu19Tau20SingleL1Path_branch and "m1MatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.m1MatchesIsoMu19Tau20SingleL1Path_branch and "m1MatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu19Tau20SingleL1Path")
        else:
            self.m1MatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu19Tau20SingleL1Path_value)

        #print "making m1MatchesIsoMu20HPSTau27Filter"
        self.m1MatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu20HPSTau27Filter")
        #if not self.m1MatchesIsoMu20HPSTau27Filter_branch and "m1MatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.m1MatchesIsoMu20HPSTau27Filter_branch and "m1MatchesIsoMu20HPSTau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20HPSTau27Filter")
        else:
            self.m1MatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu20HPSTau27Filter_value)

        #print "making m1MatchesIsoMu20HPSTau27Path"
        self.m1MatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("m1MatchesIsoMu20HPSTau27Path")
        #if not self.m1MatchesIsoMu20HPSTau27Path_branch and "m1MatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.m1MatchesIsoMu20HPSTau27Path_branch and "m1MatchesIsoMu20HPSTau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20HPSTau27Path")
        else:
            self.m1MatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu20HPSTau27Path_value)

        #print "making m1MatchesIsoMu20Tau27Filter"
        self.m1MatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu20Tau27Filter")
        #if not self.m1MatchesIsoMu20Tau27Filter_branch and "m1MatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.m1MatchesIsoMu20Tau27Filter_branch and "m1MatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Tau27Filter")
        else:
            self.m1MatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Tau27Filter_value)

        #print "making m1MatchesIsoMu20Tau27Path"
        self.m1MatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("m1MatchesIsoMu20Tau27Path")
        #if not self.m1MatchesIsoMu20Tau27Path_branch and "m1MatchesIsoMu20Tau27Path" not in self.complained:
        if not self.m1MatchesIsoMu20Tau27Path_branch and "m1MatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu20Tau27Path")
        else:
            self.m1MatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu20Tau27Path_value)

        #print "making m1MatchesIsoMu22Filter"
        self.m1MatchesIsoMu22Filter_branch = the_tree.GetBranch("m1MatchesIsoMu22Filter")
        #if not self.m1MatchesIsoMu22Filter_branch and "m1MatchesIsoMu22Filter" not in self.complained:
        if not self.m1MatchesIsoMu22Filter_branch and "m1MatchesIsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Filter")
        else:
            self.m1MatchesIsoMu22Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Filter_value)

        #print "making m1MatchesIsoMu22Path"
        self.m1MatchesIsoMu22Path_branch = the_tree.GetBranch("m1MatchesIsoMu22Path")
        #if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path" not in self.complained:
        if not self.m1MatchesIsoMu22Path_branch and "m1MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22Path")
        else:
            self.m1MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22Path_value)

        #print "making m1MatchesIsoMu22eta2p1Filter"
        self.m1MatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Filter")
        #if not self.m1MatchesIsoMu22eta2p1Filter_branch and "m1MatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Filter_branch and "m1MatchesIsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Filter")
        else:
            self.m1MatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Filter_value)

        #print "making m1MatchesIsoMu22eta2p1Path"
        self.m1MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu22eta2p1Path")
        #if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu22eta2p1Path_branch and "m1MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu22eta2p1Path")
        else:
            self.m1MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu22eta2p1Path_value)

        #print "making m1MatchesIsoMu24Filter"
        self.m1MatchesIsoMu24Filter_branch = the_tree.GetBranch("m1MatchesIsoMu24Filter")
        #if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter" not in self.complained:
        if not self.m1MatchesIsoMu24Filter_branch and "m1MatchesIsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Filter")
        else:
            self.m1MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Filter_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu27Filter"
        self.m1MatchesIsoMu27Filter_branch = the_tree.GetBranch("m1MatchesIsoMu27Filter")
        #if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter" not in self.complained:
        if not self.m1MatchesIsoMu27Filter_branch and "m1MatchesIsoMu27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Filter")
        else:
            self.m1MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Filter_value)

        #print "making m1MatchesIsoMu27Path"
        self.m1MatchesIsoMu27Path_branch = the_tree.GetBranch("m1MatchesIsoMu27Path")
        #if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path" not in self.complained:
        if not self.m1MatchesIsoMu27Path_branch and "m1MatchesIsoMu27Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu27Path")
        else:
            self.m1MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu27Path_value)

        #print "making m1MatchesIsoTkMu22Filter"
        self.m1MatchesIsoTkMu22Filter_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Filter")
        #if not self.m1MatchesIsoTkMu22Filter_branch and "m1MatchesIsoTkMu22Filter" not in self.complained:
        if not self.m1MatchesIsoTkMu22Filter_branch and "m1MatchesIsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Filter")
        else:
            self.m1MatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Filter_value)

        #print "making m1MatchesIsoTkMu22Path"
        self.m1MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22Path")
        #if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22Path_branch and "m1MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22Path")
        else:
            self.m1MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22Path_value)

        #print "making m1MatchesIsoTkMu22eta2p1Filter"
        self.m1MatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Filter")
        #if not self.m1MatchesIsoTkMu22eta2p1Filter_branch and "m1MatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Filter_branch and "m1MatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Filter")
        else:
            self.m1MatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Filter_value)

        #print "making m1MatchesIsoTkMu22eta2p1Path"
        self.m1MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoTkMu22eta2p1Path")
        #if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoTkMu22eta2p1Path_branch and "m1MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m1MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoTkMu22eta2p1Path")
        else:
            self.m1MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoTkMu22eta2p1Path_value)

        #print "making m1MiniIsoLoose"
        self.m1MiniIsoLoose_branch = the_tree.GetBranch("m1MiniIsoLoose")
        #if not self.m1MiniIsoLoose_branch and "m1MiniIsoLoose" not in self.complained:
        if not self.m1MiniIsoLoose_branch and "m1MiniIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1MiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoLoose")
        else:
            self.m1MiniIsoLoose_branch.SetAddress(<void*>&self.m1MiniIsoLoose_value)

        #print "making m1MiniIsoMedium"
        self.m1MiniIsoMedium_branch = the_tree.GetBranch("m1MiniIsoMedium")
        #if not self.m1MiniIsoMedium_branch and "m1MiniIsoMedium" not in self.complained:
        if not self.m1MiniIsoMedium_branch and "m1MiniIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1MiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoMedium")
        else:
            self.m1MiniIsoMedium_branch.SetAddress(<void*>&self.m1MiniIsoMedium_value)

        #print "making m1MiniIsoTight"
        self.m1MiniIsoTight_branch = the_tree.GetBranch("m1MiniIsoTight")
        #if not self.m1MiniIsoTight_branch and "m1MiniIsoTight" not in self.complained:
        if not self.m1MiniIsoTight_branch and "m1MiniIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m1MiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoTight")
        else:
            self.m1MiniIsoTight_branch.SetAddress(<void*>&self.m1MiniIsoTight_value)

        #print "making m1MiniIsoVeryTight"
        self.m1MiniIsoVeryTight_branch = the_tree.GetBranch("m1MiniIsoVeryTight")
        #if not self.m1MiniIsoVeryTight_branch and "m1MiniIsoVeryTight" not in self.complained:
        if not self.m1MiniIsoVeryTight_branch and "m1MiniIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m1MiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MiniIsoVeryTight")
        else:
            self.m1MiniIsoVeryTight_branch.SetAddress(<void*>&self.m1MiniIsoVeryTight_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1MvaLoose"
        self.m1MvaLoose_branch = the_tree.GetBranch("m1MvaLoose")
        #if not self.m1MvaLoose_branch and "m1MvaLoose" not in self.complained:
        if not self.m1MvaLoose_branch and "m1MvaLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaLoose")
        else:
            self.m1MvaLoose_branch.SetAddress(<void*>&self.m1MvaLoose_value)

        #print "making m1MvaMedium"
        self.m1MvaMedium_branch = the_tree.GetBranch("m1MvaMedium")
        #if not self.m1MvaMedium_branch and "m1MvaMedium" not in self.complained:
        if not self.m1MvaMedium_branch and "m1MvaMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaMedium")
        else:
            self.m1MvaMedium_branch.SetAddress(<void*>&self.m1MvaMedium_value)

        #print "making m1MvaTight"
        self.m1MvaTight_branch = the_tree.GetBranch("m1MvaTight")
        #if not self.m1MvaTight_branch and "m1MvaTight" not in self.complained:
        if not self.m1MvaTight_branch and "m1MvaTight":
            warnings.warn( "MuMuMuTree: Expected branch m1MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MvaTight")
        else:
            self.m1MvaTight_branch.SetAddress(<void*>&self.m1MvaTight_value)

        #print "making m1NearestZMass"
        self.m1NearestZMass_branch = the_tree.GetBranch("m1NearestZMass")
        #if not self.m1NearestZMass_branch and "m1NearestZMass" not in self.complained:
        if not self.m1NearestZMass_branch and "m1NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NearestZMass")
        else:
            self.m1NearestZMass_branch.SetAddress(<void*>&self.m1NearestZMass_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1NormalizedChi2"
        self.m1NormalizedChi2_branch = the_tree.GetBranch("m1NormalizedChi2")
        #if not self.m1NormalizedChi2_branch and "m1NormalizedChi2" not in self.complained:
        if not self.m1NormalizedChi2_branch and "m1NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m1NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormalizedChi2")
        else:
            self.m1NormalizedChi2_branch.SetAddress(<void*>&self.m1NormalizedChi2_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFIsoLoose"
        self.m1PFIsoLoose_branch = the_tree.GetBranch("m1PFIsoLoose")
        #if not self.m1PFIsoLoose_branch and "m1PFIsoLoose" not in self.complained:
        if not self.m1PFIsoLoose_branch and "m1PFIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoLoose")
        else:
            self.m1PFIsoLoose_branch.SetAddress(<void*>&self.m1PFIsoLoose_value)

        #print "making m1PFIsoMedium"
        self.m1PFIsoMedium_branch = the_tree.GetBranch("m1PFIsoMedium")
        #if not self.m1PFIsoMedium_branch and "m1PFIsoMedium" not in self.complained:
        if not self.m1PFIsoMedium_branch and "m1PFIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoMedium")
        else:
            self.m1PFIsoMedium_branch.SetAddress(<void*>&self.m1PFIsoMedium_value)

        #print "making m1PFIsoTight"
        self.m1PFIsoTight_branch = the_tree.GetBranch("m1PFIsoTight")
        #if not self.m1PFIsoTight_branch and "m1PFIsoTight" not in self.complained:
        if not self.m1PFIsoTight_branch and "m1PFIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoTight")
        else:
            self.m1PFIsoTight_branch.SetAddress(<void*>&self.m1PFIsoTight_value)

        #print "making m1PFIsoVeryLoose"
        self.m1PFIsoVeryLoose_branch = the_tree.GetBranch("m1PFIsoVeryLoose")
        #if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose" not in self.complained:
        if not self.m1PFIsoVeryLoose_branch and "m1PFIsoVeryLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryLoose")
        else:
            self.m1PFIsoVeryLoose_branch.SetAddress(<void*>&self.m1PFIsoVeryLoose_value)

        #print "making m1PFIsoVeryTight"
        self.m1PFIsoVeryTight_branch = the_tree.GetBranch("m1PFIsoVeryTight")
        #if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight" not in self.complained:
        if not self.m1PFIsoVeryTight_branch and "m1PFIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m1PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIsoVeryTight")
        else:
            self.m1PFIsoVeryTight_branch.SetAddress(<void*>&self.m1PFIsoVeryTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Phi_MuonEnDown"
        self.m1Phi_MuonEnDown_branch = the_tree.GetBranch("m1Phi_MuonEnDown")
        #if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown" not in self.complained:
        if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnDown")
        else:
            self.m1Phi_MuonEnDown_branch.SetAddress(<void*>&self.m1Phi_MuonEnDown_value)

        #print "making m1Phi_MuonEnUp"
        self.m1Phi_MuonEnUp_branch = the_tree.GetBranch("m1Phi_MuonEnUp")
        #if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp" not in self.complained:
        if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnUp")
        else:
            self.m1Phi_MuonEnUp_branch.SetAddress(<void*>&self.m1Phi_MuonEnUp_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1Pt_MuonEnDown"
        self.m1Pt_MuonEnDown_branch = the_tree.GetBranch("m1Pt_MuonEnDown")
        #if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown" not in self.complained:
        if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnDown")
        else:
            self.m1Pt_MuonEnDown_branch.SetAddress(<void*>&self.m1Pt_MuonEnDown_value)

        #print "making m1Pt_MuonEnUp"
        self.m1Pt_MuonEnUp_branch = the_tree.GetBranch("m1Pt_MuonEnUp")
        #if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp" not in self.complained:
        if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m1Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnUp")
        else:
            self.m1Pt_MuonEnUp_branch.SetAddress(<void*>&self.m1Pt_MuonEnUp_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1Rho"
        self.m1Rho_branch = the_tree.GetBranch("m1Rho")
        #if not self.m1Rho_branch and "m1Rho" not in self.complained:
        if not self.m1Rho_branch and "m1Rho":
            warnings.warn( "MuMuMuTree: Expected branch m1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rho")
        else:
            self.m1Rho_branch.SetAddress(<void*>&self.m1Rho_value)

        #print "making m1SIP2D"
        self.m1SIP2D_branch = the_tree.GetBranch("m1SIP2D")
        #if not self.m1SIP2D_branch and "m1SIP2D" not in self.complained:
        if not self.m1SIP2D_branch and "m1SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP2D")
        else:
            self.m1SIP2D_branch.SetAddress(<void*>&self.m1SIP2D_value)

        #print "making m1SIP3D"
        self.m1SIP3D_branch = the_tree.GetBranch("m1SIP3D")
        #if not self.m1SIP3D_branch and "m1SIP3D" not in self.complained:
        if not self.m1SIP3D_branch and "m1SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP3D")
        else:
            self.m1SIP3D_branch.SetAddress(<void*>&self.m1SIP3D_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1SoftCutBasedId"
        self.m1SoftCutBasedId_branch = the_tree.GetBranch("m1SoftCutBasedId")
        #if not self.m1SoftCutBasedId_branch and "m1SoftCutBasedId" not in self.complained:
        if not self.m1SoftCutBasedId_branch and "m1SoftCutBasedId":
            warnings.warn( "MuMuMuTree: Expected branch m1SoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SoftCutBasedId")
        else:
            self.m1SoftCutBasedId_branch.SetAddress(<void*>&self.m1SoftCutBasedId_value)

        #print "making m1TkIsoLoose"
        self.m1TkIsoLoose_branch = the_tree.GetBranch("m1TkIsoLoose")
        #if not self.m1TkIsoLoose_branch and "m1TkIsoLoose" not in self.complained:
        if not self.m1TkIsoLoose_branch and "m1TkIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m1TkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkIsoLoose")
        else:
            self.m1TkIsoLoose_branch.SetAddress(<void*>&self.m1TkIsoLoose_value)

        #print "making m1TkIsoTight"
        self.m1TkIsoTight_branch = the_tree.GetBranch("m1TkIsoTight")
        #if not self.m1TkIsoTight_branch and "m1TkIsoTight" not in self.complained:
        if not self.m1TkIsoTight_branch and "m1TkIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m1TkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkIsoTight")
        else:
            self.m1TkIsoTight_branch.SetAddress(<void*>&self.m1TkIsoTight_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TrkKink"
        self.m1TrkKink_branch = the_tree.GetBranch("m1TrkKink")
        #if not self.m1TrkKink_branch and "m1TrkKink" not in self.complained:
        if not self.m1TrkKink_branch and "m1TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m1TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkKink")
        else:
            self.m1TrkKink_branch.SetAddress(<void*>&self.m1TrkKink_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuMuTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1ValidFraction"
        self.m1ValidFraction_branch = the_tree.GetBranch("m1ValidFraction")
        #if not self.m1ValidFraction_branch and "m1ValidFraction" not in self.complained:
        if not self.m1ValidFraction_branch and "m1ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m1ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ValidFraction")
        else:
            self.m1ValidFraction_branch.SetAddress(<void*>&self.m1ValidFraction_value)

        #print "making m1ZTTGenDR"
        self.m1ZTTGenDR_branch = the_tree.GetBranch("m1ZTTGenDR")
        #if not self.m1ZTTGenDR_branch and "m1ZTTGenDR" not in self.complained:
        if not self.m1ZTTGenDR_branch and "m1ZTTGenDR":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenDR")
        else:
            self.m1ZTTGenDR_branch.SetAddress(<void*>&self.m1ZTTGenDR_value)

        #print "making m1ZTTGenEta"
        self.m1ZTTGenEta_branch = the_tree.GetBranch("m1ZTTGenEta")
        #if not self.m1ZTTGenEta_branch and "m1ZTTGenEta" not in self.complained:
        if not self.m1ZTTGenEta_branch and "m1ZTTGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenEta")
        else:
            self.m1ZTTGenEta_branch.SetAddress(<void*>&self.m1ZTTGenEta_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1ZTTGenPhi"
        self.m1ZTTGenPhi_branch = the_tree.GetBranch("m1ZTTGenPhi")
        #if not self.m1ZTTGenPhi_branch and "m1ZTTGenPhi" not in self.complained:
        if not self.m1ZTTGenPhi_branch and "m1ZTTGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenPhi")
        else:
            self.m1ZTTGenPhi_branch.SetAddress(<void*>&self.m1ZTTGenPhi_value)

        #print "making m1ZTTGenPt"
        self.m1ZTTGenPt_branch = the_tree.GetBranch("m1ZTTGenPt")
        #if not self.m1ZTTGenPt_branch and "m1ZTTGenPt" not in self.complained:
        if not self.m1ZTTGenPt_branch and "m1ZTTGenPt":
            warnings.warn( "MuMuMuTree: Expected branch m1ZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenPt")
        else:
            self.m1ZTTGenPt_branch.SetAddress(<void*>&self.m1ZTTGenPt_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_doubleL1IsoTauMatch"
        self.m1_m2_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m1_m2_doubleL1IsoTauMatch")
        #if not self.m1_m2_doubleL1IsoTauMatch_branch and "m1_m2_doubleL1IsoTauMatch" not in self.complained:
        if not self.m1_m2_doubleL1IsoTauMatch_branch and "m1_m2_doubleL1IsoTauMatch":
            warnings.warn( "MuMuMuTree: Expected branch m1_m2_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_doubleL1IsoTauMatch")
        else:
            self.m1_m2_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m1_m2_doubleL1IsoTauMatch_value)

        #print "making m1_m3_DR"
        self.m1_m3_DR_branch = the_tree.GetBranch("m1_m3_DR")
        #if not self.m1_m3_DR_branch and "m1_m3_DR" not in self.complained:
        if not self.m1_m3_DR_branch and "m1_m3_DR":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_DR")
        else:
            self.m1_m3_DR_branch.SetAddress(<void*>&self.m1_m3_DR_value)

        #print "making m1_m3_Mass"
        self.m1_m3_Mass_branch = the_tree.GetBranch("m1_m3_Mass")
        #if not self.m1_m3_Mass_branch and "m1_m3_Mass" not in self.complained:
        if not self.m1_m3_Mass_branch and "m1_m3_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_Mass")
        else:
            self.m1_m3_Mass_branch.SetAddress(<void*>&self.m1_m3_Mass_value)

        #print "making m1_m3_PZeta"
        self.m1_m3_PZeta_branch = the_tree.GetBranch("m1_m3_PZeta")
        #if not self.m1_m3_PZeta_branch and "m1_m3_PZeta" not in self.complained:
        if not self.m1_m3_PZeta_branch and "m1_m3_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZeta")
        else:
            self.m1_m3_PZeta_branch.SetAddress(<void*>&self.m1_m3_PZeta_value)

        #print "making m1_m3_PZetaVis"
        self.m1_m3_PZetaVis_branch = the_tree.GetBranch("m1_m3_PZetaVis")
        #if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis" not in self.complained:
        if not self.m1_m3_PZetaVis_branch and "m1_m3_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_PZetaVis")
        else:
            self.m1_m3_PZetaVis_branch.SetAddress(<void*>&self.m1_m3_PZetaVis_value)

        #print "making m1_m3_doubleL1IsoTauMatch"
        self.m1_m3_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m1_m3_doubleL1IsoTauMatch")
        #if not self.m1_m3_doubleL1IsoTauMatch_branch and "m1_m3_doubleL1IsoTauMatch" not in self.complained:
        if not self.m1_m3_doubleL1IsoTauMatch_branch and "m1_m3_doubleL1IsoTauMatch":
            warnings.warn( "MuMuMuTree: Expected branch m1_m3_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m3_doubleL1IsoTauMatch")
        else:
            self.m1_m3_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m1_m3_doubleL1IsoTauMatch_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuMuTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2Chi2LocalPosition"
        self.m2Chi2LocalPosition_branch = the_tree.GetBranch("m2Chi2LocalPosition")
        #if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition" not in self.complained:
        if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m2Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Chi2LocalPosition")
        else:
            self.m2Chi2LocalPosition_branch.SetAddress(<void*>&self.m2Chi2LocalPosition_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2CutBasedIdGlobalHighPt"
        self.m2CutBasedIdGlobalHighPt_branch = the_tree.GetBranch("m2CutBasedIdGlobalHighPt")
        #if not self.m2CutBasedIdGlobalHighPt_branch and "m2CutBasedIdGlobalHighPt" not in self.complained:
        if not self.m2CutBasedIdGlobalHighPt_branch and "m2CutBasedIdGlobalHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdGlobalHighPt")
        else:
            self.m2CutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.m2CutBasedIdGlobalHighPt_value)

        #print "making m2CutBasedIdLoose"
        self.m2CutBasedIdLoose_branch = the_tree.GetBranch("m2CutBasedIdLoose")
        #if not self.m2CutBasedIdLoose_branch and "m2CutBasedIdLoose" not in self.complained:
        if not self.m2CutBasedIdLoose_branch and "m2CutBasedIdLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdLoose")
        else:
            self.m2CutBasedIdLoose_branch.SetAddress(<void*>&self.m2CutBasedIdLoose_value)

        #print "making m2CutBasedIdMedium"
        self.m2CutBasedIdMedium_branch = the_tree.GetBranch("m2CutBasedIdMedium")
        #if not self.m2CutBasedIdMedium_branch and "m2CutBasedIdMedium" not in self.complained:
        if not self.m2CutBasedIdMedium_branch and "m2CutBasedIdMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdMedium")
        else:
            self.m2CutBasedIdMedium_branch.SetAddress(<void*>&self.m2CutBasedIdMedium_value)

        #print "making m2CutBasedIdMediumPrompt"
        self.m2CutBasedIdMediumPrompt_branch = the_tree.GetBranch("m2CutBasedIdMediumPrompt")
        #if not self.m2CutBasedIdMediumPrompt_branch and "m2CutBasedIdMediumPrompt" not in self.complained:
        if not self.m2CutBasedIdMediumPrompt_branch and "m2CutBasedIdMediumPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdMediumPrompt")
        else:
            self.m2CutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.m2CutBasedIdMediumPrompt_value)

        #print "making m2CutBasedIdTight"
        self.m2CutBasedIdTight_branch = the_tree.GetBranch("m2CutBasedIdTight")
        #if not self.m2CutBasedIdTight_branch and "m2CutBasedIdTight" not in self.complained:
        if not self.m2CutBasedIdTight_branch and "m2CutBasedIdTight":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdTight")
        else:
            self.m2CutBasedIdTight_branch.SetAddress(<void*>&self.m2CutBasedIdTight_value)

        #print "making m2CutBasedIdTrkHighPt"
        self.m2CutBasedIdTrkHighPt_branch = the_tree.GetBranch("m2CutBasedIdTrkHighPt")
        #if not self.m2CutBasedIdTrkHighPt_branch and "m2CutBasedIdTrkHighPt" not in self.complained:
        if not self.m2CutBasedIdTrkHighPt_branch and "m2CutBasedIdTrkHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m2CutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2CutBasedIdTrkHighPt")
        else:
            self.m2CutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.m2CutBasedIdTrkHighPt_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2Eta_MuonEnDown"
        self.m2Eta_MuonEnDown_branch = the_tree.GetBranch("m2Eta_MuonEnDown")
        #if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown" not in self.complained:
        if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnDown")
        else:
            self.m2Eta_MuonEnDown_branch.SetAddress(<void*>&self.m2Eta_MuonEnDown_value)

        #print "making m2Eta_MuonEnUp"
        self.m2Eta_MuonEnUp_branch = the_tree.GetBranch("m2Eta_MuonEnUp")
        #if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp" not in self.complained:
        if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnUp")
        else:
            self.m2Eta_MuonEnUp_branch.SetAddress(<void*>&self.m2Eta_MuonEnUp_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenDirectPromptTauDecayFinalState"
        self.m2GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m2GenDirectPromptTauDecayFinalState")
        #if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m2GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenDirectPromptTauDecayFinalState")
        else:
            self.m2GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m2GenDirectPromptTauDecayFinalState_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenIsPrompt"
        self.m2GenIsPrompt_branch = the_tree.GetBranch("m2GenIsPrompt")
        #if not self.m2GenIsPrompt_branch and "m2GenIsPrompt" not in self.complained:
        if not self.m2GenIsPrompt_branch and "m2GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenIsPrompt")
        else:
            self.m2GenIsPrompt_branch.SetAddress(<void*>&self.m2GenIsPrompt_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPrompt"
        self.m2GenPrompt_branch = the_tree.GetBranch("m2GenPrompt")
        #if not self.m2GenPrompt_branch and "m2GenPrompt" not in self.complained:
        if not self.m2GenPrompt_branch and "m2GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPrompt")
        else:
            self.m2GenPrompt_branch.SetAddress(<void*>&self.m2GenPrompt_value)

        #print "making m2GenPromptFinalState"
        self.m2GenPromptFinalState_branch = the_tree.GetBranch("m2GenPromptFinalState")
        #if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState" not in self.complained:
        if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptFinalState")
        else:
            self.m2GenPromptFinalState_branch.SetAddress(<void*>&self.m2GenPromptFinalState_value)

        #print "making m2GenPromptTauDecay"
        self.m2GenPromptTauDecay_branch = the_tree.GetBranch("m2GenPromptTauDecay")
        #if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay" not in self.complained:
        if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptTauDecay")
        else:
            self.m2GenPromptTauDecay_branch.SetAddress(<void*>&self.m2GenPromptTauDecay_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenTauDecay"
        self.m2GenTauDecay_branch = the_tree.GetBranch("m2GenTauDecay")
        #if not self.m2GenTauDecay_branch and "m2GenTauDecay" not in self.complained:
        if not self.m2GenTauDecay_branch and "m2GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenTauDecay")
        else:
            self.m2GenTauDecay_branch.SetAddress(<void*>&self.m2GenTauDecay_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2GenVtxPVMatch"
        self.m2GenVtxPVMatch_branch = the_tree.GetBranch("m2GenVtxPVMatch")
        #if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch" not in self.complained:
        if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVtxPVMatch")
        else:
            self.m2GenVtxPVMatch_branch.SetAddress(<void*>&self.m2GenVtxPVMatch_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DErr"
        self.m2IP3DErr_branch = the_tree.GetBranch("m2IP3DErr")
        #if not self.m2IP3DErr_branch and "m2IP3DErr" not in self.complained:
        if not self.m2IP3DErr_branch and "m2IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DErr")
        else:
            self.m2IP3DErr_branch.SetAddress(<void*>&self.m2IP3DErr_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetDR"
        self.m2JetDR_branch = the_tree.GetBranch("m2JetDR")
        #if not self.m2JetDR_branch and "m2JetDR" not in self.complained:
        if not self.m2JetDR_branch and "m2JetDR":
            warnings.warn( "MuMuMuTree: Expected branch m2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetDR")
        else:
            self.m2JetDR_branch.SetAddress(<void*>&self.m2JetDR_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetHadronFlavour"
        self.m2JetHadronFlavour_branch = the_tree.GetBranch("m2JetHadronFlavour")
        #if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour" not in self.complained:
        if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetHadronFlavour")
        else:
            self.m2JetHadronFlavour_branch.SetAddress(<void*>&self.m2JetHadronFlavour_value)

        #print "making m2JetPFCISVBtag"
        self.m2JetPFCISVBtag_branch = the_tree.GetBranch("m2JetPFCISVBtag")
        #if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag" not in self.complained:
        if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPFCISVBtag")
        else:
            self.m2JetPFCISVBtag_branch.SetAddress(<void*>&self.m2JetPFCISVBtag_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2LowestMll"
        self.m2LowestMll_branch = the_tree.GetBranch("m2LowestMll")
        #if not self.m2LowestMll_branch and "m2LowestMll" not in self.complained:
        if not self.m2LowestMll_branch and "m2LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2LowestMll")
        else:
            self.m2LowestMll_branch.SetAddress(<void*>&self.m2LowestMll_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuMuTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesIsoMu19Tau20Filter"
        self.m2MatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("m2MatchesIsoMu19Tau20Filter")
        #if not self.m2MatchesIsoMu19Tau20Filter_branch and "m2MatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.m2MatchesIsoMu19Tau20Filter_branch and "m2MatchesIsoMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu19Tau20Filter")
        else:
            self.m2MatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu19Tau20Filter_value)

        #print "making m2MatchesIsoMu19Tau20Path"
        self.m2MatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("m2MatchesIsoMu19Tau20Path")
        #if not self.m2MatchesIsoMu19Tau20Path_branch and "m2MatchesIsoMu19Tau20Path" not in self.complained:
        if not self.m2MatchesIsoMu19Tau20Path_branch and "m2MatchesIsoMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu19Tau20Path")
        else:
            self.m2MatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu19Tau20Path_value)

        #print "making m2MatchesIsoMu19Tau20SingleL1Filter"
        self.m2MatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("m2MatchesIsoMu19Tau20SingleL1Filter")
        #if not self.m2MatchesIsoMu19Tau20SingleL1Filter_branch and "m2MatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.m2MatchesIsoMu19Tau20SingleL1Filter_branch and "m2MatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.m2MatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making m2MatchesIsoMu19Tau20SingleL1Path"
        self.m2MatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("m2MatchesIsoMu19Tau20SingleL1Path")
        #if not self.m2MatchesIsoMu19Tau20SingleL1Path_branch and "m2MatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.m2MatchesIsoMu19Tau20SingleL1Path_branch and "m2MatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu19Tau20SingleL1Path")
        else:
            self.m2MatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu19Tau20SingleL1Path_value)

        #print "making m2MatchesIsoMu20HPSTau27Filter"
        self.m2MatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu20HPSTau27Filter")
        #if not self.m2MatchesIsoMu20HPSTau27Filter_branch and "m2MatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.m2MatchesIsoMu20HPSTau27Filter_branch and "m2MatchesIsoMu20HPSTau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20HPSTau27Filter")
        else:
            self.m2MatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu20HPSTau27Filter_value)

        #print "making m2MatchesIsoMu20HPSTau27Path"
        self.m2MatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("m2MatchesIsoMu20HPSTau27Path")
        #if not self.m2MatchesIsoMu20HPSTau27Path_branch and "m2MatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.m2MatchesIsoMu20HPSTau27Path_branch and "m2MatchesIsoMu20HPSTau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20HPSTau27Path")
        else:
            self.m2MatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu20HPSTau27Path_value)

        #print "making m2MatchesIsoMu20Tau27Filter"
        self.m2MatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu20Tau27Filter")
        #if not self.m2MatchesIsoMu20Tau27Filter_branch and "m2MatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.m2MatchesIsoMu20Tau27Filter_branch and "m2MatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Tau27Filter")
        else:
            self.m2MatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Tau27Filter_value)

        #print "making m2MatchesIsoMu20Tau27Path"
        self.m2MatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("m2MatchesIsoMu20Tau27Path")
        #if not self.m2MatchesIsoMu20Tau27Path_branch and "m2MatchesIsoMu20Tau27Path" not in self.complained:
        if not self.m2MatchesIsoMu20Tau27Path_branch and "m2MatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu20Tau27Path")
        else:
            self.m2MatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu20Tau27Path_value)

        #print "making m2MatchesIsoMu22Filter"
        self.m2MatchesIsoMu22Filter_branch = the_tree.GetBranch("m2MatchesIsoMu22Filter")
        #if not self.m2MatchesIsoMu22Filter_branch and "m2MatchesIsoMu22Filter" not in self.complained:
        if not self.m2MatchesIsoMu22Filter_branch and "m2MatchesIsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Filter")
        else:
            self.m2MatchesIsoMu22Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Filter_value)

        #print "making m2MatchesIsoMu22Path"
        self.m2MatchesIsoMu22Path_branch = the_tree.GetBranch("m2MatchesIsoMu22Path")
        #if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path" not in self.complained:
        if not self.m2MatchesIsoMu22Path_branch and "m2MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22Path")
        else:
            self.m2MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22Path_value)

        #print "making m2MatchesIsoMu22eta2p1Filter"
        self.m2MatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Filter")
        #if not self.m2MatchesIsoMu22eta2p1Filter_branch and "m2MatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Filter_branch and "m2MatchesIsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Filter")
        else:
            self.m2MatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Filter_value)

        #print "making m2MatchesIsoMu22eta2p1Path"
        self.m2MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu22eta2p1Path")
        #if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu22eta2p1Path_branch and "m2MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu22eta2p1Path")
        else:
            self.m2MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu22eta2p1Path_value)

        #print "making m2MatchesIsoMu24Filter"
        self.m2MatchesIsoMu24Filter_branch = the_tree.GetBranch("m2MatchesIsoMu24Filter")
        #if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter" not in self.complained:
        if not self.m2MatchesIsoMu24Filter_branch and "m2MatchesIsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Filter")
        else:
            self.m2MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Filter_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu27Filter"
        self.m2MatchesIsoMu27Filter_branch = the_tree.GetBranch("m2MatchesIsoMu27Filter")
        #if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter" not in self.complained:
        if not self.m2MatchesIsoMu27Filter_branch and "m2MatchesIsoMu27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Filter")
        else:
            self.m2MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Filter_value)

        #print "making m2MatchesIsoMu27Path"
        self.m2MatchesIsoMu27Path_branch = the_tree.GetBranch("m2MatchesIsoMu27Path")
        #if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path" not in self.complained:
        if not self.m2MatchesIsoMu27Path_branch and "m2MatchesIsoMu27Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu27Path")
        else:
            self.m2MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu27Path_value)

        #print "making m2MatchesIsoTkMu22Filter"
        self.m2MatchesIsoTkMu22Filter_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Filter")
        #if not self.m2MatchesIsoTkMu22Filter_branch and "m2MatchesIsoTkMu22Filter" not in self.complained:
        if not self.m2MatchesIsoTkMu22Filter_branch and "m2MatchesIsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Filter")
        else:
            self.m2MatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Filter_value)

        #print "making m2MatchesIsoTkMu22Path"
        self.m2MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22Path")
        #if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22Path_branch and "m2MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22Path")
        else:
            self.m2MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22Path_value)

        #print "making m2MatchesIsoTkMu22eta2p1Filter"
        self.m2MatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Filter")
        #if not self.m2MatchesIsoTkMu22eta2p1Filter_branch and "m2MatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Filter_branch and "m2MatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Filter")
        else:
            self.m2MatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Filter_value)

        #print "making m2MatchesIsoTkMu22eta2p1Path"
        self.m2MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoTkMu22eta2p1Path")
        #if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoTkMu22eta2p1Path_branch and "m2MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m2MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoTkMu22eta2p1Path")
        else:
            self.m2MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoTkMu22eta2p1Path_value)

        #print "making m2MiniIsoLoose"
        self.m2MiniIsoLoose_branch = the_tree.GetBranch("m2MiniIsoLoose")
        #if not self.m2MiniIsoLoose_branch and "m2MiniIsoLoose" not in self.complained:
        if not self.m2MiniIsoLoose_branch and "m2MiniIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2MiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoLoose")
        else:
            self.m2MiniIsoLoose_branch.SetAddress(<void*>&self.m2MiniIsoLoose_value)

        #print "making m2MiniIsoMedium"
        self.m2MiniIsoMedium_branch = the_tree.GetBranch("m2MiniIsoMedium")
        #if not self.m2MiniIsoMedium_branch and "m2MiniIsoMedium" not in self.complained:
        if not self.m2MiniIsoMedium_branch and "m2MiniIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2MiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoMedium")
        else:
            self.m2MiniIsoMedium_branch.SetAddress(<void*>&self.m2MiniIsoMedium_value)

        #print "making m2MiniIsoTight"
        self.m2MiniIsoTight_branch = the_tree.GetBranch("m2MiniIsoTight")
        #if not self.m2MiniIsoTight_branch and "m2MiniIsoTight" not in self.complained:
        if not self.m2MiniIsoTight_branch and "m2MiniIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m2MiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoTight")
        else:
            self.m2MiniIsoTight_branch.SetAddress(<void*>&self.m2MiniIsoTight_value)

        #print "making m2MiniIsoVeryTight"
        self.m2MiniIsoVeryTight_branch = the_tree.GetBranch("m2MiniIsoVeryTight")
        #if not self.m2MiniIsoVeryTight_branch and "m2MiniIsoVeryTight" not in self.complained:
        if not self.m2MiniIsoVeryTight_branch and "m2MiniIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m2MiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MiniIsoVeryTight")
        else:
            self.m2MiniIsoVeryTight_branch.SetAddress(<void*>&self.m2MiniIsoVeryTight_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2MvaLoose"
        self.m2MvaLoose_branch = the_tree.GetBranch("m2MvaLoose")
        #if not self.m2MvaLoose_branch and "m2MvaLoose" not in self.complained:
        if not self.m2MvaLoose_branch and "m2MvaLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaLoose")
        else:
            self.m2MvaLoose_branch.SetAddress(<void*>&self.m2MvaLoose_value)

        #print "making m2MvaMedium"
        self.m2MvaMedium_branch = the_tree.GetBranch("m2MvaMedium")
        #if not self.m2MvaMedium_branch and "m2MvaMedium" not in self.complained:
        if not self.m2MvaMedium_branch and "m2MvaMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaMedium")
        else:
            self.m2MvaMedium_branch.SetAddress(<void*>&self.m2MvaMedium_value)

        #print "making m2MvaTight"
        self.m2MvaTight_branch = the_tree.GetBranch("m2MvaTight")
        #if not self.m2MvaTight_branch and "m2MvaTight" not in self.complained:
        if not self.m2MvaTight_branch and "m2MvaTight":
            warnings.warn( "MuMuMuTree: Expected branch m2MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MvaTight")
        else:
            self.m2MvaTight_branch.SetAddress(<void*>&self.m2MvaTight_value)

        #print "making m2NearestZMass"
        self.m2NearestZMass_branch = the_tree.GetBranch("m2NearestZMass")
        #if not self.m2NearestZMass_branch and "m2NearestZMass" not in self.complained:
        if not self.m2NearestZMass_branch and "m2NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NearestZMass")
        else:
            self.m2NearestZMass_branch.SetAddress(<void*>&self.m2NearestZMass_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2NormalizedChi2"
        self.m2NormalizedChi2_branch = the_tree.GetBranch("m2NormalizedChi2")
        #if not self.m2NormalizedChi2_branch and "m2NormalizedChi2" not in self.complained:
        if not self.m2NormalizedChi2_branch and "m2NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m2NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormalizedChi2")
        else:
            self.m2NormalizedChi2_branch.SetAddress(<void*>&self.m2NormalizedChi2_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFIsoLoose"
        self.m2PFIsoLoose_branch = the_tree.GetBranch("m2PFIsoLoose")
        #if not self.m2PFIsoLoose_branch and "m2PFIsoLoose" not in self.complained:
        if not self.m2PFIsoLoose_branch and "m2PFIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoLoose")
        else:
            self.m2PFIsoLoose_branch.SetAddress(<void*>&self.m2PFIsoLoose_value)

        #print "making m2PFIsoMedium"
        self.m2PFIsoMedium_branch = the_tree.GetBranch("m2PFIsoMedium")
        #if not self.m2PFIsoMedium_branch and "m2PFIsoMedium" not in self.complained:
        if not self.m2PFIsoMedium_branch and "m2PFIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoMedium")
        else:
            self.m2PFIsoMedium_branch.SetAddress(<void*>&self.m2PFIsoMedium_value)

        #print "making m2PFIsoTight"
        self.m2PFIsoTight_branch = the_tree.GetBranch("m2PFIsoTight")
        #if not self.m2PFIsoTight_branch and "m2PFIsoTight" not in self.complained:
        if not self.m2PFIsoTight_branch and "m2PFIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoTight")
        else:
            self.m2PFIsoTight_branch.SetAddress(<void*>&self.m2PFIsoTight_value)

        #print "making m2PFIsoVeryLoose"
        self.m2PFIsoVeryLoose_branch = the_tree.GetBranch("m2PFIsoVeryLoose")
        #if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose" not in self.complained:
        if not self.m2PFIsoVeryLoose_branch and "m2PFIsoVeryLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryLoose")
        else:
            self.m2PFIsoVeryLoose_branch.SetAddress(<void*>&self.m2PFIsoVeryLoose_value)

        #print "making m2PFIsoVeryTight"
        self.m2PFIsoVeryTight_branch = the_tree.GetBranch("m2PFIsoVeryTight")
        #if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight" not in self.complained:
        if not self.m2PFIsoVeryTight_branch and "m2PFIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m2PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIsoVeryTight")
        else:
            self.m2PFIsoVeryTight_branch.SetAddress(<void*>&self.m2PFIsoVeryTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Phi_MuonEnDown"
        self.m2Phi_MuonEnDown_branch = the_tree.GetBranch("m2Phi_MuonEnDown")
        #if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown" not in self.complained:
        if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnDown")
        else:
            self.m2Phi_MuonEnDown_branch.SetAddress(<void*>&self.m2Phi_MuonEnDown_value)

        #print "making m2Phi_MuonEnUp"
        self.m2Phi_MuonEnUp_branch = the_tree.GetBranch("m2Phi_MuonEnUp")
        #if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp" not in self.complained:
        if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnUp")
        else:
            self.m2Phi_MuonEnUp_branch.SetAddress(<void*>&self.m2Phi_MuonEnUp_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2Pt_MuonEnDown"
        self.m2Pt_MuonEnDown_branch = the_tree.GetBranch("m2Pt_MuonEnDown")
        #if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown" not in self.complained:
        if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnDown")
        else:
            self.m2Pt_MuonEnDown_branch.SetAddress(<void*>&self.m2Pt_MuonEnDown_value)

        #print "making m2Pt_MuonEnUp"
        self.m2Pt_MuonEnUp_branch = the_tree.GetBranch("m2Pt_MuonEnUp")
        #if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp" not in self.complained:
        if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m2Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnUp")
        else:
            self.m2Pt_MuonEnUp_branch.SetAddress(<void*>&self.m2Pt_MuonEnUp_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2Rho"
        self.m2Rho_branch = the_tree.GetBranch("m2Rho")
        #if not self.m2Rho_branch and "m2Rho" not in self.complained:
        if not self.m2Rho_branch and "m2Rho":
            warnings.warn( "MuMuMuTree: Expected branch m2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rho")
        else:
            self.m2Rho_branch.SetAddress(<void*>&self.m2Rho_value)

        #print "making m2SIP2D"
        self.m2SIP2D_branch = the_tree.GetBranch("m2SIP2D")
        #if not self.m2SIP2D_branch and "m2SIP2D" not in self.complained:
        if not self.m2SIP2D_branch and "m2SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP2D")
        else:
            self.m2SIP2D_branch.SetAddress(<void*>&self.m2SIP2D_value)

        #print "making m2SIP3D"
        self.m2SIP3D_branch = the_tree.GetBranch("m2SIP3D")
        #if not self.m2SIP3D_branch and "m2SIP3D" not in self.complained:
        if not self.m2SIP3D_branch and "m2SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP3D")
        else:
            self.m2SIP3D_branch.SetAddress(<void*>&self.m2SIP3D_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2SoftCutBasedId"
        self.m2SoftCutBasedId_branch = the_tree.GetBranch("m2SoftCutBasedId")
        #if not self.m2SoftCutBasedId_branch and "m2SoftCutBasedId" not in self.complained:
        if not self.m2SoftCutBasedId_branch and "m2SoftCutBasedId":
            warnings.warn( "MuMuMuTree: Expected branch m2SoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SoftCutBasedId")
        else:
            self.m2SoftCutBasedId_branch.SetAddress(<void*>&self.m2SoftCutBasedId_value)

        #print "making m2TkIsoLoose"
        self.m2TkIsoLoose_branch = the_tree.GetBranch("m2TkIsoLoose")
        #if not self.m2TkIsoLoose_branch and "m2TkIsoLoose" not in self.complained:
        if not self.m2TkIsoLoose_branch and "m2TkIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m2TkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkIsoLoose")
        else:
            self.m2TkIsoLoose_branch.SetAddress(<void*>&self.m2TkIsoLoose_value)

        #print "making m2TkIsoTight"
        self.m2TkIsoTight_branch = the_tree.GetBranch("m2TkIsoTight")
        #if not self.m2TkIsoTight_branch and "m2TkIsoTight" not in self.complained:
        if not self.m2TkIsoTight_branch and "m2TkIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m2TkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkIsoTight")
        else:
            self.m2TkIsoTight_branch.SetAddress(<void*>&self.m2TkIsoTight_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TrkKink"
        self.m2TrkKink_branch = the_tree.GetBranch("m2TrkKink")
        #if not self.m2TrkKink_branch and "m2TrkKink" not in self.complained:
        if not self.m2TrkKink_branch and "m2TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m2TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkKink")
        else:
            self.m2TrkKink_branch.SetAddress(<void*>&self.m2TrkKink_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuMuTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2ValidFraction"
        self.m2ValidFraction_branch = the_tree.GetBranch("m2ValidFraction")
        #if not self.m2ValidFraction_branch and "m2ValidFraction" not in self.complained:
        if not self.m2ValidFraction_branch and "m2ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m2ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ValidFraction")
        else:
            self.m2ValidFraction_branch.SetAddress(<void*>&self.m2ValidFraction_value)

        #print "making m2ZTTGenDR"
        self.m2ZTTGenDR_branch = the_tree.GetBranch("m2ZTTGenDR")
        #if not self.m2ZTTGenDR_branch and "m2ZTTGenDR" not in self.complained:
        if not self.m2ZTTGenDR_branch and "m2ZTTGenDR":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenDR")
        else:
            self.m2ZTTGenDR_branch.SetAddress(<void*>&self.m2ZTTGenDR_value)

        #print "making m2ZTTGenEta"
        self.m2ZTTGenEta_branch = the_tree.GetBranch("m2ZTTGenEta")
        #if not self.m2ZTTGenEta_branch and "m2ZTTGenEta" not in self.complained:
        if not self.m2ZTTGenEta_branch and "m2ZTTGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenEta")
        else:
            self.m2ZTTGenEta_branch.SetAddress(<void*>&self.m2ZTTGenEta_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

        #print "making m2ZTTGenPhi"
        self.m2ZTTGenPhi_branch = the_tree.GetBranch("m2ZTTGenPhi")
        #if not self.m2ZTTGenPhi_branch and "m2ZTTGenPhi" not in self.complained:
        if not self.m2ZTTGenPhi_branch and "m2ZTTGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenPhi")
        else:
            self.m2ZTTGenPhi_branch.SetAddress(<void*>&self.m2ZTTGenPhi_value)

        #print "making m2ZTTGenPt"
        self.m2ZTTGenPt_branch = the_tree.GetBranch("m2ZTTGenPt")
        #if not self.m2ZTTGenPt_branch and "m2ZTTGenPt" not in self.complained:
        if not self.m2ZTTGenPt_branch and "m2ZTTGenPt":
            warnings.warn( "MuMuMuTree: Expected branch m2ZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenPt")
        else:
            self.m2ZTTGenPt_branch.SetAddress(<void*>&self.m2ZTTGenPt_value)

        #print "making m2_m3_DR"
        self.m2_m3_DR_branch = the_tree.GetBranch("m2_m3_DR")
        #if not self.m2_m3_DR_branch and "m2_m3_DR" not in self.complained:
        if not self.m2_m3_DR_branch and "m2_m3_DR":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_DR")
        else:
            self.m2_m3_DR_branch.SetAddress(<void*>&self.m2_m3_DR_value)

        #print "making m2_m3_Mass"
        self.m2_m3_Mass_branch = the_tree.GetBranch("m2_m3_Mass")
        #if not self.m2_m3_Mass_branch and "m2_m3_Mass" not in self.complained:
        if not self.m2_m3_Mass_branch and "m2_m3_Mass":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_Mass")
        else:
            self.m2_m3_Mass_branch.SetAddress(<void*>&self.m2_m3_Mass_value)

        #print "making m2_m3_PZeta"
        self.m2_m3_PZeta_branch = the_tree.GetBranch("m2_m3_PZeta")
        #if not self.m2_m3_PZeta_branch and "m2_m3_PZeta" not in self.complained:
        if not self.m2_m3_PZeta_branch and "m2_m3_PZeta":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZeta")
        else:
            self.m2_m3_PZeta_branch.SetAddress(<void*>&self.m2_m3_PZeta_value)

        #print "making m2_m3_PZetaVis"
        self.m2_m3_PZetaVis_branch = the_tree.GetBranch("m2_m3_PZetaVis")
        #if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis" not in self.complained:
        if not self.m2_m3_PZetaVis_branch and "m2_m3_PZetaVis":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_PZetaVis")
        else:
            self.m2_m3_PZetaVis_branch.SetAddress(<void*>&self.m2_m3_PZetaVis_value)

        #print "making m2_m3_doubleL1IsoTauMatch"
        self.m2_m3_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m2_m3_doubleL1IsoTauMatch")
        #if not self.m2_m3_doubleL1IsoTauMatch_branch and "m2_m3_doubleL1IsoTauMatch" not in self.complained:
        if not self.m2_m3_doubleL1IsoTauMatch_branch and "m2_m3_doubleL1IsoTauMatch":
            warnings.warn( "MuMuMuTree: Expected branch m2_m3_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m3_doubleL1IsoTauMatch")
        else:
            self.m2_m3_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m2_m3_doubleL1IsoTauMatch_value)

        #print "making m3BestTrackType"
        self.m3BestTrackType_branch = the_tree.GetBranch("m3BestTrackType")
        #if not self.m3BestTrackType_branch and "m3BestTrackType" not in self.complained:
        if not self.m3BestTrackType_branch and "m3BestTrackType":
            warnings.warn( "MuMuMuTree: Expected branch m3BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3BestTrackType")
        else:
            self.m3BestTrackType_branch.SetAddress(<void*>&self.m3BestTrackType_value)

        #print "making m3Charge"
        self.m3Charge_branch = the_tree.GetBranch("m3Charge")
        #if not self.m3Charge_branch and "m3Charge" not in self.complained:
        if not self.m3Charge_branch and "m3Charge":
            warnings.warn( "MuMuMuTree: Expected branch m3Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Charge")
        else:
            self.m3Charge_branch.SetAddress(<void*>&self.m3Charge_value)

        #print "making m3Chi2LocalPosition"
        self.m3Chi2LocalPosition_branch = the_tree.GetBranch("m3Chi2LocalPosition")
        #if not self.m3Chi2LocalPosition_branch and "m3Chi2LocalPosition" not in self.complained:
        if not self.m3Chi2LocalPosition_branch and "m3Chi2LocalPosition":
            warnings.warn( "MuMuMuTree: Expected branch m3Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Chi2LocalPosition")
        else:
            self.m3Chi2LocalPosition_branch.SetAddress(<void*>&self.m3Chi2LocalPosition_value)

        #print "making m3ComesFromHiggs"
        self.m3ComesFromHiggs_branch = the_tree.GetBranch("m3ComesFromHiggs")
        #if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs" not in self.complained:
        if not self.m3ComesFromHiggs_branch and "m3ComesFromHiggs":
            warnings.warn( "MuMuMuTree: Expected branch m3ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ComesFromHiggs")
        else:
            self.m3ComesFromHiggs_branch.SetAddress(<void*>&self.m3ComesFromHiggs_value)

        #print "making m3CutBasedIdGlobalHighPt"
        self.m3CutBasedIdGlobalHighPt_branch = the_tree.GetBranch("m3CutBasedIdGlobalHighPt")
        #if not self.m3CutBasedIdGlobalHighPt_branch and "m3CutBasedIdGlobalHighPt" not in self.complained:
        if not self.m3CutBasedIdGlobalHighPt_branch and "m3CutBasedIdGlobalHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdGlobalHighPt")
        else:
            self.m3CutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.m3CutBasedIdGlobalHighPt_value)

        #print "making m3CutBasedIdLoose"
        self.m3CutBasedIdLoose_branch = the_tree.GetBranch("m3CutBasedIdLoose")
        #if not self.m3CutBasedIdLoose_branch and "m3CutBasedIdLoose" not in self.complained:
        if not self.m3CutBasedIdLoose_branch and "m3CutBasedIdLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdLoose")
        else:
            self.m3CutBasedIdLoose_branch.SetAddress(<void*>&self.m3CutBasedIdLoose_value)

        #print "making m3CutBasedIdMedium"
        self.m3CutBasedIdMedium_branch = the_tree.GetBranch("m3CutBasedIdMedium")
        #if not self.m3CutBasedIdMedium_branch and "m3CutBasedIdMedium" not in self.complained:
        if not self.m3CutBasedIdMedium_branch and "m3CutBasedIdMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdMedium")
        else:
            self.m3CutBasedIdMedium_branch.SetAddress(<void*>&self.m3CutBasedIdMedium_value)

        #print "making m3CutBasedIdMediumPrompt"
        self.m3CutBasedIdMediumPrompt_branch = the_tree.GetBranch("m3CutBasedIdMediumPrompt")
        #if not self.m3CutBasedIdMediumPrompt_branch and "m3CutBasedIdMediumPrompt" not in self.complained:
        if not self.m3CutBasedIdMediumPrompt_branch and "m3CutBasedIdMediumPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdMediumPrompt")
        else:
            self.m3CutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.m3CutBasedIdMediumPrompt_value)

        #print "making m3CutBasedIdTight"
        self.m3CutBasedIdTight_branch = the_tree.GetBranch("m3CutBasedIdTight")
        #if not self.m3CutBasedIdTight_branch and "m3CutBasedIdTight" not in self.complained:
        if not self.m3CutBasedIdTight_branch and "m3CutBasedIdTight":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdTight")
        else:
            self.m3CutBasedIdTight_branch.SetAddress(<void*>&self.m3CutBasedIdTight_value)

        #print "making m3CutBasedIdTrkHighPt"
        self.m3CutBasedIdTrkHighPt_branch = the_tree.GetBranch("m3CutBasedIdTrkHighPt")
        #if not self.m3CutBasedIdTrkHighPt_branch and "m3CutBasedIdTrkHighPt" not in self.complained:
        if not self.m3CutBasedIdTrkHighPt_branch and "m3CutBasedIdTrkHighPt":
            warnings.warn( "MuMuMuTree: Expected branch m3CutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3CutBasedIdTrkHighPt")
        else:
            self.m3CutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.m3CutBasedIdTrkHighPt_value)

        #print "making m3EcalIsoDR03"
        self.m3EcalIsoDR03_branch = the_tree.GetBranch("m3EcalIsoDR03")
        #if not self.m3EcalIsoDR03_branch and "m3EcalIsoDR03" not in self.complained:
        if not self.m3EcalIsoDR03_branch and "m3EcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EcalIsoDR03")
        else:
            self.m3EcalIsoDR03_branch.SetAddress(<void*>&self.m3EcalIsoDR03_value)

        #print "making m3EffectiveArea2011"
        self.m3EffectiveArea2011_branch = the_tree.GetBranch("m3EffectiveArea2011")
        #if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011" not in self.complained:
        if not self.m3EffectiveArea2011_branch and "m3EffectiveArea2011":
            warnings.warn( "MuMuMuTree: Expected branch m3EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2011")
        else:
            self.m3EffectiveArea2011_branch.SetAddress(<void*>&self.m3EffectiveArea2011_value)

        #print "making m3EffectiveArea2012"
        self.m3EffectiveArea2012_branch = the_tree.GetBranch("m3EffectiveArea2012")
        #if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012" not in self.complained:
        if not self.m3EffectiveArea2012_branch and "m3EffectiveArea2012":
            warnings.warn( "MuMuMuTree: Expected branch m3EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3EffectiveArea2012")
        else:
            self.m3EffectiveArea2012_branch.SetAddress(<void*>&self.m3EffectiveArea2012_value)

        #print "making m3Eta"
        self.m3Eta_branch = the_tree.GetBranch("m3Eta")
        #if not self.m3Eta_branch and "m3Eta" not in self.complained:
        if not self.m3Eta_branch and "m3Eta":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta")
        else:
            self.m3Eta_branch.SetAddress(<void*>&self.m3Eta_value)

        #print "making m3Eta_MuonEnDown"
        self.m3Eta_MuonEnDown_branch = the_tree.GetBranch("m3Eta_MuonEnDown")
        #if not self.m3Eta_MuonEnDown_branch and "m3Eta_MuonEnDown" not in self.complained:
        if not self.m3Eta_MuonEnDown_branch and "m3Eta_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta_MuonEnDown")
        else:
            self.m3Eta_MuonEnDown_branch.SetAddress(<void*>&self.m3Eta_MuonEnDown_value)

        #print "making m3Eta_MuonEnUp"
        self.m3Eta_MuonEnUp_branch = the_tree.GetBranch("m3Eta_MuonEnUp")
        #if not self.m3Eta_MuonEnUp_branch and "m3Eta_MuonEnUp" not in self.complained:
        if not self.m3Eta_MuonEnUp_branch and "m3Eta_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Eta_MuonEnUp")
        else:
            self.m3Eta_MuonEnUp_branch.SetAddress(<void*>&self.m3Eta_MuonEnUp_value)

        #print "making m3GenCharge"
        self.m3GenCharge_branch = the_tree.GetBranch("m3GenCharge")
        #if not self.m3GenCharge_branch and "m3GenCharge" not in self.complained:
        if not self.m3GenCharge_branch and "m3GenCharge":
            warnings.warn( "MuMuMuTree: Expected branch m3GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenCharge")
        else:
            self.m3GenCharge_branch.SetAddress(<void*>&self.m3GenCharge_value)

        #print "making m3GenDirectPromptTauDecayFinalState"
        self.m3GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m3GenDirectPromptTauDecayFinalState")
        #if not self.m3GenDirectPromptTauDecayFinalState_branch and "m3GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m3GenDirectPromptTauDecayFinalState_branch and "m3GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m3GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenDirectPromptTauDecayFinalState")
        else:
            self.m3GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m3GenDirectPromptTauDecayFinalState_value)

        #print "making m3GenEnergy"
        self.m3GenEnergy_branch = the_tree.GetBranch("m3GenEnergy")
        #if not self.m3GenEnergy_branch and "m3GenEnergy" not in self.complained:
        if not self.m3GenEnergy_branch and "m3GenEnergy":
            warnings.warn( "MuMuMuTree: Expected branch m3GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEnergy")
        else:
            self.m3GenEnergy_branch.SetAddress(<void*>&self.m3GenEnergy_value)

        #print "making m3GenEta"
        self.m3GenEta_branch = the_tree.GetBranch("m3GenEta")
        #if not self.m3GenEta_branch and "m3GenEta" not in self.complained:
        if not self.m3GenEta_branch and "m3GenEta":
            warnings.warn( "MuMuMuTree: Expected branch m3GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenEta")
        else:
            self.m3GenEta_branch.SetAddress(<void*>&self.m3GenEta_value)

        #print "making m3GenIsPrompt"
        self.m3GenIsPrompt_branch = the_tree.GetBranch("m3GenIsPrompt")
        #if not self.m3GenIsPrompt_branch and "m3GenIsPrompt" not in self.complained:
        if not self.m3GenIsPrompt_branch and "m3GenIsPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenIsPrompt")
        else:
            self.m3GenIsPrompt_branch.SetAddress(<void*>&self.m3GenIsPrompt_value)

        #print "making m3GenMotherPdgId"
        self.m3GenMotherPdgId_branch = the_tree.GetBranch("m3GenMotherPdgId")
        #if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId" not in self.complained:
        if not self.m3GenMotherPdgId_branch and "m3GenMotherPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m3GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenMotherPdgId")
        else:
            self.m3GenMotherPdgId_branch.SetAddress(<void*>&self.m3GenMotherPdgId_value)

        #print "making m3GenParticle"
        self.m3GenParticle_branch = the_tree.GetBranch("m3GenParticle")
        #if not self.m3GenParticle_branch and "m3GenParticle" not in self.complained:
        if not self.m3GenParticle_branch and "m3GenParticle":
            warnings.warn( "MuMuMuTree: Expected branch m3GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenParticle")
        else:
            self.m3GenParticle_branch.SetAddress(<void*>&self.m3GenParticle_value)

        #print "making m3GenPdgId"
        self.m3GenPdgId_branch = the_tree.GetBranch("m3GenPdgId")
        #if not self.m3GenPdgId_branch and "m3GenPdgId" not in self.complained:
        if not self.m3GenPdgId_branch and "m3GenPdgId":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPdgId")
        else:
            self.m3GenPdgId_branch.SetAddress(<void*>&self.m3GenPdgId_value)

        #print "making m3GenPhi"
        self.m3GenPhi_branch = the_tree.GetBranch("m3GenPhi")
        #if not self.m3GenPhi_branch and "m3GenPhi" not in self.complained:
        if not self.m3GenPhi_branch and "m3GenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPhi")
        else:
            self.m3GenPhi_branch.SetAddress(<void*>&self.m3GenPhi_value)

        #print "making m3GenPrompt"
        self.m3GenPrompt_branch = the_tree.GetBranch("m3GenPrompt")
        #if not self.m3GenPrompt_branch and "m3GenPrompt" not in self.complained:
        if not self.m3GenPrompt_branch and "m3GenPrompt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPrompt")
        else:
            self.m3GenPrompt_branch.SetAddress(<void*>&self.m3GenPrompt_value)

        #print "making m3GenPromptFinalState"
        self.m3GenPromptFinalState_branch = the_tree.GetBranch("m3GenPromptFinalState")
        #if not self.m3GenPromptFinalState_branch and "m3GenPromptFinalState" not in self.complained:
        if not self.m3GenPromptFinalState_branch and "m3GenPromptFinalState":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPromptFinalState")
        else:
            self.m3GenPromptFinalState_branch.SetAddress(<void*>&self.m3GenPromptFinalState_value)

        #print "making m3GenPromptTauDecay"
        self.m3GenPromptTauDecay_branch = the_tree.GetBranch("m3GenPromptTauDecay")
        #if not self.m3GenPromptTauDecay_branch and "m3GenPromptTauDecay" not in self.complained:
        if not self.m3GenPromptTauDecay_branch and "m3GenPromptTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPromptTauDecay")
        else:
            self.m3GenPromptTauDecay_branch.SetAddress(<void*>&self.m3GenPromptTauDecay_value)

        #print "making m3GenPt"
        self.m3GenPt_branch = the_tree.GetBranch("m3GenPt")
        #if not self.m3GenPt_branch and "m3GenPt" not in self.complained:
        if not self.m3GenPt_branch and "m3GenPt":
            warnings.warn( "MuMuMuTree: Expected branch m3GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenPt")
        else:
            self.m3GenPt_branch.SetAddress(<void*>&self.m3GenPt_value)

        #print "making m3GenTauDecay"
        self.m3GenTauDecay_branch = the_tree.GetBranch("m3GenTauDecay")
        #if not self.m3GenTauDecay_branch and "m3GenTauDecay" not in self.complained:
        if not self.m3GenTauDecay_branch and "m3GenTauDecay":
            warnings.warn( "MuMuMuTree: Expected branch m3GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenTauDecay")
        else:
            self.m3GenTauDecay_branch.SetAddress(<void*>&self.m3GenTauDecay_value)

        #print "making m3GenVZ"
        self.m3GenVZ_branch = the_tree.GetBranch("m3GenVZ")
        #if not self.m3GenVZ_branch and "m3GenVZ" not in self.complained:
        if not self.m3GenVZ_branch and "m3GenVZ":
            warnings.warn( "MuMuMuTree: Expected branch m3GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenVZ")
        else:
            self.m3GenVZ_branch.SetAddress(<void*>&self.m3GenVZ_value)

        #print "making m3GenVtxPVMatch"
        self.m3GenVtxPVMatch_branch = the_tree.GetBranch("m3GenVtxPVMatch")
        #if not self.m3GenVtxPVMatch_branch and "m3GenVtxPVMatch" not in self.complained:
        if not self.m3GenVtxPVMatch_branch and "m3GenVtxPVMatch":
            warnings.warn( "MuMuMuTree: Expected branch m3GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3GenVtxPVMatch")
        else:
            self.m3GenVtxPVMatch_branch.SetAddress(<void*>&self.m3GenVtxPVMatch_value)

        #print "making m3HcalIsoDR03"
        self.m3HcalIsoDR03_branch = the_tree.GetBranch("m3HcalIsoDR03")
        #if not self.m3HcalIsoDR03_branch and "m3HcalIsoDR03" not in self.complained:
        if not self.m3HcalIsoDR03_branch and "m3HcalIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3HcalIsoDR03")
        else:
            self.m3HcalIsoDR03_branch.SetAddress(<void*>&self.m3HcalIsoDR03_value)

        #print "making m3IP3D"
        self.m3IP3D_branch = the_tree.GetBranch("m3IP3D")
        #if not self.m3IP3D_branch and "m3IP3D" not in self.complained:
        if not self.m3IP3D_branch and "m3IP3D":
            warnings.warn( "MuMuMuTree: Expected branch m3IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3D")
        else:
            self.m3IP3D_branch.SetAddress(<void*>&self.m3IP3D_value)

        #print "making m3IP3DErr"
        self.m3IP3DErr_branch = the_tree.GetBranch("m3IP3DErr")
        #if not self.m3IP3DErr_branch and "m3IP3DErr" not in self.complained:
        if not self.m3IP3DErr_branch and "m3IP3DErr":
            warnings.warn( "MuMuMuTree: Expected branch m3IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IP3DErr")
        else:
            self.m3IP3DErr_branch.SetAddress(<void*>&self.m3IP3DErr_value)

        #print "making m3IsGlobal"
        self.m3IsGlobal_branch = the_tree.GetBranch("m3IsGlobal")
        #if not self.m3IsGlobal_branch and "m3IsGlobal" not in self.complained:
        if not self.m3IsGlobal_branch and "m3IsGlobal":
            warnings.warn( "MuMuMuTree: Expected branch m3IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsGlobal")
        else:
            self.m3IsGlobal_branch.SetAddress(<void*>&self.m3IsGlobal_value)

        #print "making m3IsPFMuon"
        self.m3IsPFMuon_branch = the_tree.GetBranch("m3IsPFMuon")
        #if not self.m3IsPFMuon_branch and "m3IsPFMuon" not in self.complained:
        if not self.m3IsPFMuon_branch and "m3IsPFMuon":
            warnings.warn( "MuMuMuTree: Expected branch m3IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsPFMuon")
        else:
            self.m3IsPFMuon_branch.SetAddress(<void*>&self.m3IsPFMuon_value)

        #print "making m3IsTracker"
        self.m3IsTracker_branch = the_tree.GetBranch("m3IsTracker")
        #if not self.m3IsTracker_branch and "m3IsTracker" not in self.complained:
        if not self.m3IsTracker_branch and "m3IsTracker":
            warnings.warn( "MuMuMuTree: Expected branch m3IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsTracker")
        else:
            self.m3IsTracker_branch.SetAddress(<void*>&self.m3IsTracker_value)

        #print "making m3IsoDB03"
        self.m3IsoDB03_branch = the_tree.GetBranch("m3IsoDB03")
        #if not self.m3IsoDB03_branch and "m3IsoDB03" not in self.complained:
        if not self.m3IsoDB03_branch and "m3IsoDB03":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoDB03")
        else:
            self.m3IsoDB03_branch.SetAddress(<void*>&self.m3IsoDB03_value)

        #print "making m3IsoDB04"
        self.m3IsoDB04_branch = the_tree.GetBranch("m3IsoDB04")
        #if not self.m3IsoDB04_branch and "m3IsoDB04" not in self.complained:
        if not self.m3IsoDB04_branch and "m3IsoDB04":
            warnings.warn( "MuMuMuTree: Expected branch m3IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3IsoDB04")
        else:
            self.m3IsoDB04_branch.SetAddress(<void*>&self.m3IsoDB04_value)

        #print "making m3JetArea"
        self.m3JetArea_branch = the_tree.GetBranch("m3JetArea")
        #if not self.m3JetArea_branch and "m3JetArea" not in self.complained:
        if not self.m3JetArea_branch and "m3JetArea":
            warnings.warn( "MuMuMuTree: Expected branch m3JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetArea")
        else:
            self.m3JetArea_branch.SetAddress(<void*>&self.m3JetArea_value)

        #print "making m3JetBtag"
        self.m3JetBtag_branch = the_tree.GetBranch("m3JetBtag")
        #if not self.m3JetBtag_branch and "m3JetBtag" not in self.complained:
        if not self.m3JetBtag_branch and "m3JetBtag":
            warnings.warn( "MuMuMuTree: Expected branch m3JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetBtag")
        else:
            self.m3JetBtag_branch.SetAddress(<void*>&self.m3JetBtag_value)

        #print "making m3JetDR"
        self.m3JetDR_branch = the_tree.GetBranch("m3JetDR")
        #if not self.m3JetDR_branch and "m3JetDR" not in self.complained:
        if not self.m3JetDR_branch and "m3JetDR":
            warnings.warn( "MuMuMuTree: Expected branch m3JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetDR")
        else:
            self.m3JetDR_branch.SetAddress(<void*>&self.m3JetDR_value)

        #print "making m3JetEtaEtaMoment"
        self.m3JetEtaEtaMoment_branch = the_tree.GetBranch("m3JetEtaEtaMoment")
        #if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment" not in self.complained:
        if not self.m3JetEtaEtaMoment_branch and "m3JetEtaEtaMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaEtaMoment")
        else:
            self.m3JetEtaEtaMoment_branch.SetAddress(<void*>&self.m3JetEtaEtaMoment_value)

        #print "making m3JetEtaPhiMoment"
        self.m3JetEtaPhiMoment_branch = the_tree.GetBranch("m3JetEtaPhiMoment")
        #if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment" not in self.complained:
        if not self.m3JetEtaPhiMoment_branch and "m3JetEtaPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiMoment")
        else:
            self.m3JetEtaPhiMoment_branch.SetAddress(<void*>&self.m3JetEtaPhiMoment_value)

        #print "making m3JetEtaPhiSpread"
        self.m3JetEtaPhiSpread_branch = the_tree.GetBranch("m3JetEtaPhiSpread")
        #if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread" not in self.complained:
        if not self.m3JetEtaPhiSpread_branch and "m3JetEtaPhiSpread":
            warnings.warn( "MuMuMuTree: Expected branch m3JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetEtaPhiSpread")
        else:
            self.m3JetEtaPhiSpread_branch.SetAddress(<void*>&self.m3JetEtaPhiSpread_value)

        #print "making m3JetHadronFlavour"
        self.m3JetHadronFlavour_branch = the_tree.GetBranch("m3JetHadronFlavour")
        #if not self.m3JetHadronFlavour_branch and "m3JetHadronFlavour" not in self.complained:
        if not self.m3JetHadronFlavour_branch and "m3JetHadronFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m3JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetHadronFlavour")
        else:
            self.m3JetHadronFlavour_branch.SetAddress(<void*>&self.m3JetHadronFlavour_value)

        #print "making m3JetPFCISVBtag"
        self.m3JetPFCISVBtag_branch = the_tree.GetBranch("m3JetPFCISVBtag")
        #if not self.m3JetPFCISVBtag_branch and "m3JetPFCISVBtag" not in self.complained:
        if not self.m3JetPFCISVBtag_branch and "m3JetPFCISVBtag":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPFCISVBtag")
        else:
            self.m3JetPFCISVBtag_branch.SetAddress(<void*>&self.m3JetPFCISVBtag_value)

        #print "making m3JetPartonFlavour"
        self.m3JetPartonFlavour_branch = the_tree.GetBranch("m3JetPartonFlavour")
        #if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour" not in self.complained:
        if not self.m3JetPartonFlavour_branch and "m3JetPartonFlavour":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPartonFlavour")
        else:
            self.m3JetPartonFlavour_branch.SetAddress(<void*>&self.m3JetPartonFlavour_value)

        #print "making m3JetPhiPhiMoment"
        self.m3JetPhiPhiMoment_branch = the_tree.GetBranch("m3JetPhiPhiMoment")
        #if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment" not in self.complained:
        if not self.m3JetPhiPhiMoment_branch and "m3JetPhiPhiMoment":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPhiPhiMoment")
        else:
            self.m3JetPhiPhiMoment_branch.SetAddress(<void*>&self.m3JetPhiPhiMoment_value)

        #print "making m3JetPt"
        self.m3JetPt_branch = the_tree.GetBranch("m3JetPt")
        #if not self.m3JetPt_branch and "m3JetPt" not in self.complained:
        if not self.m3JetPt_branch and "m3JetPt":
            warnings.warn( "MuMuMuTree: Expected branch m3JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3JetPt")
        else:
            self.m3JetPt_branch.SetAddress(<void*>&self.m3JetPt_value)

        #print "making m3LowestMll"
        self.m3LowestMll_branch = the_tree.GetBranch("m3LowestMll")
        #if not self.m3LowestMll_branch and "m3LowestMll" not in self.complained:
        if not self.m3LowestMll_branch and "m3LowestMll":
            warnings.warn( "MuMuMuTree: Expected branch m3LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3LowestMll")
        else:
            self.m3LowestMll_branch.SetAddress(<void*>&self.m3LowestMll_value)

        #print "making m3Mass"
        self.m3Mass_branch = the_tree.GetBranch("m3Mass")
        #if not self.m3Mass_branch and "m3Mass" not in self.complained:
        if not self.m3Mass_branch and "m3Mass":
            warnings.warn( "MuMuMuTree: Expected branch m3Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Mass")
        else:
            self.m3Mass_branch.SetAddress(<void*>&self.m3Mass_value)

        #print "making m3MatchedStations"
        self.m3MatchedStations_branch = the_tree.GetBranch("m3MatchedStations")
        #if not self.m3MatchedStations_branch and "m3MatchedStations" not in self.complained:
        if not self.m3MatchedStations_branch and "m3MatchedStations":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchedStations")
        else:
            self.m3MatchedStations_branch.SetAddress(<void*>&self.m3MatchedStations_value)

        #print "making m3MatchesIsoMu19Tau20Filter"
        self.m3MatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("m3MatchesIsoMu19Tau20Filter")
        #if not self.m3MatchesIsoMu19Tau20Filter_branch and "m3MatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.m3MatchesIsoMu19Tau20Filter_branch and "m3MatchesIsoMu19Tau20Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu19Tau20Filter")
        else:
            self.m3MatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu19Tau20Filter_value)

        #print "making m3MatchesIsoMu19Tau20Path"
        self.m3MatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("m3MatchesIsoMu19Tau20Path")
        #if not self.m3MatchesIsoMu19Tau20Path_branch and "m3MatchesIsoMu19Tau20Path" not in self.complained:
        if not self.m3MatchesIsoMu19Tau20Path_branch and "m3MatchesIsoMu19Tau20Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu19Tau20Path")
        else:
            self.m3MatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu19Tau20Path_value)

        #print "making m3MatchesIsoMu19Tau20SingleL1Filter"
        self.m3MatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("m3MatchesIsoMu19Tau20SingleL1Filter")
        #if not self.m3MatchesIsoMu19Tau20SingleL1Filter_branch and "m3MatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.m3MatchesIsoMu19Tau20SingleL1Filter_branch and "m3MatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.m3MatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making m3MatchesIsoMu19Tau20SingleL1Path"
        self.m3MatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("m3MatchesIsoMu19Tau20SingleL1Path")
        #if not self.m3MatchesIsoMu19Tau20SingleL1Path_branch and "m3MatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.m3MatchesIsoMu19Tau20SingleL1Path_branch and "m3MatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu19Tau20SingleL1Path")
        else:
            self.m3MatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu19Tau20SingleL1Path_value)

        #print "making m3MatchesIsoMu20HPSTau27Filter"
        self.m3MatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("m3MatchesIsoMu20HPSTau27Filter")
        #if not self.m3MatchesIsoMu20HPSTau27Filter_branch and "m3MatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.m3MatchesIsoMu20HPSTau27Filter_branch and "m3MatchesIsoMu20HPSTau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu20HPSTau27Filter")
        else:
            self.m3MatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu20HPSTau27Filter_value)

        #print "making m3MatchesIsoMu20HPSTau27Path"
        self.m3MatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("m3MatchesIsoMu20HPSTau27Path")
        #if not self.m3MatchesIsoMu20HPSTau27Path_branch and "m3MatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.m3MatchesIsoMu20HPSTau27Path_branch and "m3MatchesIsoMu20HPSTau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu20HPSTau27Path")
        else:
            self.m3MatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu20HPSTau27Path_value)

        #print "making m3MatchesIsoMu20Tau27Filter"
        self.m3MatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("m3MatchesIsoMu20Tau27Filter")
        #if not self.m3MatchesIsoMu20Tau27Filter_branch and "m3MatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.m3MatchesIsoMu20Tau27Filter_branch and "m3MatchesIsoMu20Tau27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu20Tau27Filter")
        else:
            self.m3MatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu20Tau27Filter_value)

        #print "making m3MatchesIsoMu20Tau27Path"
        self.m3MatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("m3MatchesIsoMu20Tau27Path")
        #if not self.m3MatchesIsoMu20Tau27Path_branch and "m3MatchesIsoMu20Tau27Path" not in self.complained:
        if not self.m3MatchesIsoMu20Tau27Path_branch and "m3MatchesIsoMu20Tau27Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu20Tau27Path")
        else:
            self.m3MatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu20Tau27Path_value)

        #print "making m3MatchesIsoMu22Filter"
        self.m3MatchesIsoMu22Filter_branch = the_tree.GetBranch("m3MatchesIsoMu22Filter")
        #if not self.m3MatchesIsoMu22Filter_branch and "m3MatchesIsoMu22Filter" not in self.complained:
        if not self.m3MatchesIsoMu22Filter_branch and "m3MatchesIsoMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22Filter")
        else:
            self.m3MatchesIsoMu22Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu22Filter_value)

        #print "making m3MatchesIsoMu22Path"
        self.m3MatchesIsoMu22Path_branch = the_tree.GetBranch("m3MatchesIsoMu22Path")
        #if not self.m3MatchesIsoMu22Path_branch and "m3MatchesIsoMu22Path" not in self.complained:
        if not self.m3MatchesIsoMu22Path_branch and "m3MatchesIsoMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22Path")
        else:
            self.m3MatchesIsoMu22Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu22Path_value)

        #print "making m3MatchesIsoMu22eta2p1Filter"
        self.m3MatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("m3MatchesIsoMu22eta2p1Filter")
        #if not self.m3MatchesIsoMu22eta2p1Filter_branch and "m3MatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.m3MatchesIsoMu22eta2p1Filter_branch and "m3MatchesIsoMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22eta2p1Filter")
        else:
            self.m3MatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu22eta2p1Filter_value)

        #print "making m3MatchesIsoMu22eta2p1Path"
        self.m3MatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoMu22eta2p1Path")
        #if not self.m3MatchesIsoMu22eta2p1Path_branch and "m3MatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoMu22eta2p1Path_branch and "m3MatchesIsoMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu22eta2p1Path")
        else:
            self.m3MatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu22eta2p1Path_value)

        #print "making m3MatchesIsoMu24Filter"
        self.m3MatchesIsoMu24Filter_branch = the_tree.GetBranch("m3MatchesIsoMu24Filter")
        #if not self.m3MatchesIsoMu24Filter_branch and "m3MatchesIsoMu24Filter" not in self.complained:
        if not self.m3MatchesIsoMu24Filter_branch and "m3MatchesIsoMu24Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24Filter")
        else:
            self.m3MatchesIsoMu24Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu24Filter_value)

        #print "making m3MatchesIsoMu24Path"
        self.m3MatchesIsoMu24Path_branch = the_tree.GetBranch("m3MatchesIsoMu24Path")
        #if not self.m3MatchesIsoMu24Path_branch and "m3MatchesIsoMu24Path" not in self.complained:
        if not self.m3MatchesIsoMu24Path_branch and "m3MatchesIsoMu24Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu24Path")
        else:
            self.m3MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu24Path_value)

        #print "making m3MatchesIsoMu27Filter"
        self.m3MatchesIsoMu27Filter_branch = the_tree.GetBranch("m3MatchesIsoMu27Filter")
        #if not self.m3MatchesIsoMu27Filter_branch and "m3MatchesIsoMu27Filter" not in self.complained:
        if not self.m3MatchesIsoMu27Filter_branch and "m3MatchesIsoMu27Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu27Filter")
        else:
            self.m3MatchesIsoMu27Filter_branch.SetAddress(<void*>&self.m3MatchesIsoMu27Filter_value)

        #print "making m3MatchesIsoMu27Path"
        self.m3MatchesIsoMu27Path_branch = the_tree.GetBranch("m3MatchesIsoMu27Path")
        #if not self.m3MatchesIsoMu27Path_branch and "m3MatchesIsoMu27Path" not in self.complained:
        if not self.m3MatchesIsoMu27Path_branch and "m3MatchesIsoMu27Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoMu27Path")
        else:
            self.m3MatchesIsoMu27Path_branch.SetAddress(<void*>&self.m3MatchesIsoMu27Path_value)

        #print "making m3MatchesIsoTkMu22Filter"
        self.m3MatchesIsoTkMu22Filter_branch = the_tree.GetBranch("m3MatchesIsoTkMu22Filter")
        #if not self.m3MatchesIsoTkMu22Filter_branch and "m3MatchesIsoTkMu22Filter" not in self.complained:
        if not self.m3MatchesIsoTkMu22Filter_branch and "m3MatchesIsoTkMu22Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22Filter")
        else:
            self.m3MatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22Filter_value)

        #print "making m3MatchesIsoTkMu22Path"
        self.m3MatchesIsoTkMu22Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu22Path")
        #if not self.m3MatchesIsoTkMu22Path_branch and "m3MatchesIsoTkMu22Path" not in self.complained:
        if not self.m3MatchesIsoTkMu22Path_branch and "m3MatchesIsoTkMu22Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22Path")
        else:
            self.m3MatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22Path_value)

        #print "making m3MatchesIsoTkMu22eta2p1Filter"
        self.m3MatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("m3MatchesIsoTkMu22eta2p1Filter")
        #if not self.m3MatchesIsoTkMu22eta2p1Filter_branch and "m3MatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.m3MatchesIsoTkMu22eta2p1Filter_branch and "m3MatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22eta2p1Filter")
        else:
            self.m3MatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22eta2p1Filter_value)

        #print "making m3MatchesIsoTkMu22eta2p1Path"
        self.m3MatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("m3MatchesIsoTkMu22eta2p1Path")
        #if not self.m3MatchesIsoTkMu22eta2p1Path_branch and "m3MatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.m3MatchesIsoTkMu22eta2p1Path_branch and "m3MatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuMuMuTree: Expected branch m3MatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MatchesIsoTkMu22eta2p1Path")
        else:
            self.m3MatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.m3MatchesIsoTkMu22eta2p1Path_value)

        #print "making m3MiniIsoLoose"
        self.m3MiniIsoLoose_branch = the_tree.GetBranch("m3MiniIsoLoose")
        #if not self.m3MiniIsoLoose_branch and "m3MiniIsoLoose" not in self.complained:
        if not self.m3MiniIsoLoose_branch and "m3MiniIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3MiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MiniIsoLoose")
        else:
            self.m3MiniIsoLoose_branch.SetAddress(<void*>&self.m3MiniIsoLoose_value)

        #print "making m3MiniIsoMedium"
        self.m3MiniIsoMedium_branch = the_tree.GetBranch("m3MiniIsoMedium")
        #if not self.m3MiniIsoMedium_branch and "m3MiniIsoMedium" not in self.complained:
        if not self.m3MiniIsoMedium_branch and "m3MiniIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3MiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MiniIsoMedium")
        else:
            self.m3MiniIsoMedium_branch.SetAddress(<void*>&self.m3MiniIsoMedium_value)

        #print "making m3MiniIsoTight"
        self.m3MiniIsoTight_branch = the_tree.GetBranch("m3MiniIsoTight")
        #if not self.m3MiniIsoTight_branch and "m3MiniIsoTight" not in self.complained:
        if not self.m3MiniIsoTight_branch and "m3MiniIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m3MiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MiniIsoTight")
        else:
            self.m3MiniIsoTight_branch.SetAddress(<void*>&self.m3MiniIsoTight_value)

        #print "making m3MiniIsoVeryTight"
        self.m3MiniIsoVeryTight_branch = the_tree.GetBranch("m3MiniIsoVeryTight")
        #if not self.m3MiniIsoVeryTight_branch and "m3MiniIsoVeryTight" not in self.complained:
        if not self.m3MiniIsoVeryTight_branch and "m3MiniIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m3MiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MiniIsoVeryTight")
        else:
            self.m3MiniIsoVeryTight_branch.SetAddress(<void*>&self.m3MiniIsoVeryTight_value)

        #print "making m3MuonHits"
        self.m3MuonHits_branch = the_tree.GetBranch("m3MuonHits")
        #if not self.m3MuonHits_branch and "m3MuonHits" not in self.complained:
        if not self.m3MuonHits_branch and "m3MuonHits":
            warnings.warn( "MuMuMuTree: Expected branch m3MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MuonHits")
        else:
            self.m3MuonHits_branch.SetAddress(<void*>&self.m3MuonHits_value)

        #print "making m3MvaLoose"
        self.m3MvaLoose_branch = the_tree.GetBranch("m3MvaLoose")
        #if not self.m3MvaLoose_branch and "m3MvaLoose" not in self.complained:
        if not self.m3MvaLoose_branch and "m3MvaLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3MvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MvaLoose")
        else:
            self.m3MvaLoose_branch.SetAddress(<void*>&self.m3MvaLoose_value)

        #print "making m3MvaMedium"
        self.m3MvaMedium_branch = the_tree.GetBranch("m3MvaMedium")
        #if not self.m3MvaMedium_branch and "m3MvaMedium" not in self.complained:
        if not self.m3MvaMedium_branch and "m3MvaMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3MvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MvaMedium")
        else:
            self.m3MvaMedium_branch.SetAddress(<void*>&self.m3MvaMedium_value)

        #print "making m3MvaTight"
        self.m3MvaTight_branch = the_tree.GetBranch("m3MvaTight")
        #if not self.m3MvaTight_branch and "m3MvaTight" not in self.complained:
        if not self.m3MvaTight_branch and "m3MvaTight":
            warnings.warn( "MuMuMuTree: Expected branch m3MvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3MvaTight")
        else:
            self.m3MvaTight_branch.SetAddress(<void*>&self.m3MvaTight_value)

        #print "making m3NearestZMass"
        self.m3NearestZMass_branch = the_tree.GetBranch("m3NearestZMass")
        #if not self.m3NearestZMass_branch and "m3NearestZMass" not in self.complained:
        if not self.m3NearestZMass_branch and "m3NearestZMass":
            warnings.warn( "MuMuMuTree: Expected branch m3NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NearestZMass")
        else:
            self.m3NearestZMass_branch.SetAddress(<void*>&self.m3NearestZMass_value)

        #print "making m3NormTrkChi2"
        self.m3NormTrkChi2_branch = the_tree.GetBranch("m3NormTrkChi2")
        #if not self.m3NormTrkChi2_branch and "m3NormTrkChi2" not in self.complained:
        if not self.m3NormTrkChi2_branch and "m3NormTrkChi2":
            warnings.warn( "MuMuMuTree: Expected branch m3NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormTrkChi2")
        else:
            self.m3NormTrkChi2_branch.SetAddress(<void*>&self.m3NormTrkChi2_value)

        #print "making m3NormalizedChi2"
        self.m3NormalizedChi2_branch = the_tree.GetBranch("m3NormalizedChi2")
        #if not self.m3NormalizedChi2_branch and "m3NormalizedChi2" not in self.complained:
        if not self.m3NormalizedChi2_branch and "m3NormalizedChi2":
            warnings.warn( "MuMuMuTree: Expected branch m3NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3NormalizedChi2")
        else:
            self.m3NormalizedChi2_branch.SetAddress(<void*>&self.m3NormalizedChi2_value)

        #print "making m3PFChargedHadronIsoR04"
        self.m3PFChargedHadronIsoR04_branch = the_tree.GetBranch("m3PFChargedHadronIsoR04")
        #if not self.m3PFChargedHadronIsoR04_branch and "m3PFChargedHadronIsoR04" not in self.complained:
        if not self.m3PFChargedHadronIsoR04_branch and "m3PFChargedHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedHadronIsoR04")
        else:
            self.m3PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m3PFChargedHadronIsoR04_value)

        #print "making m3PFChargedIso"
        self.m3PFChargedIso_branch = the_tree.GetBranch("m3PFChargedIso")
        #if not self.m3PFChargedIso_branch and "m3PFChargedIso" not in self.complained:
        if not self.m3PFChargedIso_branch and "m3PFChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFChargedIso")
        else:
            self.m3PFChargedIso_branch.SetAddress(<void*>&self.m3PFChargedIso_value)

        #print "making m3PFIDLoose"
        self.m3PFIDLoose_branch = the_tree.GetBranch("m3PFIDLoose")
        #if not self.m3PFIDLoose_branch and "m3PFIDLoose" not in self.complained:
        if not self.m3PFIDLoose_branch and "m3PFIDLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDLoose")
        else:
            self.m3PFIDLoose_branch.SetAddress(<void*>&self.m3PFIDLoose_value)

        #print "making m3PFIDMedium"
        self.m3PFIDMedium_branch = the_tree.GetBranch("m3PFIDMedium")
        #if not self.m3PFIDMedium_branch and "m3PFIDMedium" not in self.complained:
        if not self.m3PFIDMedium_branch and "m3PFIDMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDMedium")
        else:
            self.m3PFIDMedium_branch.SetAddress(<void*>&self.m3PFIDMedium_value)

        #print "making m3PFIDTight"
        self.m3PFIDTight_branch = the_tree.GetBranch("m3PFIDTight")
        #if not self.m3PFIDTight_branch and "m3PFIDTight" not in self.complained:
        if not self.m3PFIDTight_branch and "m3PFIDTight":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIDTight")
        else:
            self.m3PFIDTight_branch.SetAddress(<void*>&self.m3PFIDTight_value)

        #print "making m3PFIsoLoose"
        self.m3PFIsoLoose_branch = the_tree.GetBranch("m3PFIsoLoose")
        #if not self.m3PFIsoLoose_branch and "m3PFIsoLoose" not in self.complained:
        if not self.m3PFIsoLoose_branch and "m3PFIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIsoLoose")
        else:
            self.m3PFIsoLoose_branch.SetAddress(<void*>&self.m3PFIsoLoose_value)

        #print "making m3PFIsoMedium"
        self.m3PFIsoMedium_branch = the_tree.GetBranch("m3PFIsoMedium")
        #if not self.m3PFIsoMedium_branch and "m3PFIsoMedium" not in self.complained:
        if not self.m3PFIsoMedium_branch and "m3PFIsoMedium":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIsoMedium")
        else:
            self.m3PFIsoMedium_branch.SetAddress(<void*>&self.m3PFIsoMedium_value)

        #print "making m3PFIsoTight"
        self.m3PFIsoTight_branch = the_tree.GetBranch("m3PFIsoTight")
        #if not self.m3PFIsoTight_branch and "m3PFIsoTight" not in self.complained:
        if not self.m3PFIsoTight_branch and "m3PFIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIsoTight")
        else:
            self.m3PFIsoTight_branch.SetAddress(<void*>&self.m3PFIsoTight_value)

        #print "making m3PFIsoVeryLoose"
        self.m3PFIsoVeryLoose_branch = the_tree.GetBranch("m3PFIsoVeryLoose")
        #if not self.m3PFIsoVeryLoose_branch and "m3PFIsoVeryLoose" not in self.complained:
        if not self.m3PFIsoVeryLoose_branch and "m3PFIsoVeryLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIsoVeryLoose")
        else:
            self.m3PFIsoVeryLoose_branch.SetAddress(<void*>&self.m3PFIsoVeryLoose_value)

        #print "making m3PFIsoVeryTight"
        self.m3PFIsoVeryTight_branch = the_tree.GetBranch("m3PFIsoVeryTight")
        #if not self.m3PFIsoVeryTight_branch and "m3PFIsoVeryTight" not in self.complained:
        if not self.m3PFIsoVeryTight_branch and "m3PFIsoVeryTight":
            warnings.warn( "MuMuMuTree: Expected branch m3PFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFIsoVeryTight")
        else:
            self.m3PFIsoVeryTight_branch.SetAddress(<void*>&self.m3PFIsoVeryTight_value)

        #print "making m3PFNeutralHadronIsoR04"
        self.m3PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m3PFNeutralHadronIsoR04")
        #if not self.m3PFNeutralHadronIsoR04_branch and "m3PFNeutralHadronIsoR04" not in self.complained:
        if not self.m3PFNeutralHadronIsoR04_branch and "m3PFNeutralHadronIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralHadronIsoR04")
        else:
            self.m3PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m3PFNeutralHadronIsoR04_value)

        #print "making m3PFNeutralIso"
        self.m3PFNeutralIso_branch = the_tree.GetBranch("m3PFNeutralIso")
        #if not self.m3PFNeutralIso_branch and "m3PFNeutralIso" not in self.complained:
        if not self.m3PFNeutralIso_branch and "m3PFNeutralIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFNeutralIso")
        else:
            self.m3PFNeutralIso_branch.SetAddress(<void*>&self.m3PFNeutralIso_value)

        #print "making m3PFPUChargedIso"
        self.m3PFPUChargedIso_branch = the_tree.GetBranch("m3PFPUChargedIso")
        #if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso" not in self.complained:
        if not self.m3PFPUChargedIso_branch and "m3PFPUChargedIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPUChargedIso")
        else:
            self.m3PFPUChargedIso_branch.SetAddress(<void*>&self.m3PFPUChargedIso_value)

        #print "making m3PFPhotonIso"
        self.m3PFPhotonIso_branch = the_tree.GetBranch("m3PFPhotonIso")
        #if not self.m3PFPhotonIso_branch and "m3PFPhotonIso" not in self.complained:
        if not self.m3PFPhotonIso_branch and "m3PFPhotonIso":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIso")
        else:
            self.m3PFPhotonIso_branch.SetAddress(<void*>&self.m3PFPhotonIso_value)

        #print "making m3PFPhotonIsoR04"
        self.m3PFPhotonIsoR04_branch = the_tree.GetBranch("m3PFPhotonIsoR04")
        #if not self.m3PFPhotonIsoR04_branch and "m3PFPhotonIsoR04" not in self.complained:
        if not self.m3PFPhotonIsoR04_branch and "m3PFPhotonIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPhotonIsoR04")
        else:
            self.m3PFPhotonIsoR04_branch.SetAddress(<void*>&self.m3PFPhotonIsoR04_value)

        #print "making m3PFPileupIsoR04"
        self.m3PFPileupIsoR04_branch = the_tree.GetBranch("m3PFPileupIsoR04")
        #if not self.m3PFPileupIsoR04_branch and "m3PFPileupIsoR04" not in self.complained:
        if not self.m3PFPileupIsoR04_branch and "m3PFPileupIsoR04":
            warnings.warn( "MuMuMuTree: Expected branch m3PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PFPileupIsoR04")
        else:
            self.m3PFPileupIsoR04_branch.SetAddress(<void*>&self.m3PFPileupIsoR04_value)

        #print "making m3PVDXY"
        self.m3PVDXY_branch = the_tree.GetBranch("m3PVDXY")
        #if not self.m3PVDXY_branch and "m3PVDXY" not in self.complained:
        if not self.m3PVDXY_branch and "m3PVDXY":
            warnings.warn( "MuMuMuTree: Expected branch m3PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDXY")
        else:
            self.m3PVDXY_branch.SetAddress(<void*>&self.m3PVDXY_value)

        #print "making m3PVDZ"
        self.m3PVDZ_branch = the_tree.GetBranch("m3PVDZ")
        #if not self.m3PVDZ_branch and "m3PVDZ" not in self.complained:
        if not self.m3PVDZ_branch and "m3PVDZ":
            warnings.warn( "MuMuMuTree: Expected branch m3PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PVDZ")
        else:
            self.m3PVDZ_branch.SetAddress(<void*>&self.m3PVDZ_value)

        #print "making m3Phi"
        self.m3Phi_branch = the_tree.GetBranch("m3Phi")
        #if not self.m3Phi_branch and "m3Phi" not in self.complained:
        if not self.m3Phi_branch and "m3Phi":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi")
        else:
            self.m3Phi_branch.SetAddress(<void*>&self.m3Phi_value)

        #print "making m3Phi_MuonEnDown"
        self.m3Phi_MuonEnDown_branch = the_tree.GetBranch("m3Phi_MuonEnDown")
        #if not self.m3Phi_MuonEnDown_branch and "m3Phi_MuonEnDown" not in self.complained:
        if not self.m3Phi_MuonEnDown_branch and "m3Phi_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi_MuonEnDown")
        else:
            self.m3Phi_MuonEnDown_branch.SetAddress(<void*>&self.m3Phi_MuonEnDown_value)

        #print "making m3Phi_MuonEnUp"
        self.m3Phi_MuonEnUp_branch = the_tree.GetBranch("m3Phi_MuonEnUp")
        #if not self.m3Phi_MuonEnUp_branch and "m3Phi_MuonEnUp" not in self.complained:
        if not self.m3Phi_MuonEnUp_branch and "m3Phi_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Phi_MuonEnUp")
        else:
            self.m3Phi_MuonEnUp_branch.SetAddress(<void*>&self.m3Phi_MuonEnUp_value)

        #print "making m3PixHits"
        self.m3PixHits_branch = the_tree.GetBranch("m3PixHits")
        #if not self.m3PixHits_branch and "m3PixHits" not in self.complained:
        if not self.m3PixHits_branch and "m3PixHits":
            warnings.warn( "MuMuMuTree: Expected branch m3PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3PixHits")
        else:
            self.m3PixHits_branch.SetAddress(<void*>&self.m3PixHits_value)

        #print "making m3Pt"
        self.m3Pt_branch = the_tree.GetBranch("m3Pt")
        #if not self.m3Pt_branch and "m3Pt" not in self.complained:
        if not self.m3Pt_branch and "m3Pt":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt")
        else:
            self.m3Pt_branch.SetAddress(<void*>&self.m3Pt_value)

        #print "making m3Pt_MuonEnDown"
        self.m3Pt_MuonEnDown_branch = the_tree.GetBranch("m3Pt_MuonEnDown")
        #if not self.m3Pt_MuonEnDown_branch and "m3Pt_MuonEnDown" not in self.complained:
        if not self.m3Pt_MuonEnDown_branch and "m3Pt_MuonEnDown":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt_MuonEnDown")
        else:
            self.m3Pt_MuonEnDown_branch.SetAddress(<void*>&self.m3Pt_MuonEnDown_value)

        #print "making m3Pt_MuonEnUp"
        self.m3Pt_MuonEnUp_branch = the_tree.GetBranch("m3Pt_MuonEnUp")
        #if not self.m3Pt_MuonEnUp_branch and "m3Pt_MuonEnUp" not in self.complained:
        if not self.m3Pt_MuonEnUp_branch and "m3Pt_MuonEnUp":
            warnings.warn( "MuMuMuTree: Expected branch m3Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Pt_MuonEnUp")
        else:
            self.m3Pt_MuonEnUp_branch.SetAddress(<void*>&self.m3Pt_MuonEnUp_value)

        #print "making m3RelPFIsoDBDefault"
        self.m3RelPFIsoDBDefault_branch = the_tree.GetBranch("m3RelPFIsoDBDefault")
        #if not self.m3RelPFIsoDBDefault_branch and "m3RelPFIsoDBDefault" not in self.complained:
        if not self.m3RelPFIsoDBDefault_branch and "m3RelPFIsoDBDefault":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDBDefault")
        else:
            self.m3RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m3RelPFIsoDBDefault_value)

        #print "making m3RelPFIsoDBDefaultR04"
        self.m3RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m3RelPFIsoDBDefaultR04")
        #if not self.m3RelPFIsoDBDefaultR04_branch and "m3RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m3RelPFIsoDBDefaultR04_branch and "m3RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoDBDefaultR04")
        else:
            self.m3RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m3RelPFIsoDBDefaultR04_value)

        #print "making m3RelPFIsoRho"
        self.m3RelPFIsoRho_branch = the_tree.GetBranch("m3RelPFIsoRho")
        #if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho" not in self.complained:
        if not self.m3RelPFIsoRho_branch and "m3RelPFIsoRho":
            warnings.warn( "MuMuMuTree: Expected branch m3RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3RelPFIsoRho")
        else:
            self.m3RelPFIsoRho_branch.SetAddress(<void*>&self.m3RelPFIsoRho_value)

        #print "making m3Rho"
        self.m3Rho_branch = the_tree.GetBranch("m3Rho")
        #if not self.m3Rho_branch and "m3Rho" not in self.complained:
        if not self.m3Rho_branch and "m3Rho":
            warnings.warn( "MuMuMuTree: Expected branch m3Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3Rho")
        else:
            self.m3Rho_branch.SetAddress(<void*>&self.m3Rho_value)

        #print "making m3SIP2D"
        self.m3SIP2D_branch = the_tree.GetBranch("m3SIP2D")
        #if not self.m3SIP2D_branch and "m3SIP2D" not in self.complained:
        if not self.m3SIP2D_branch and "m3SIP2D":
            warnings.warn( "MuMuMuTree: Expected branch m3SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SIP2D")
        else:
            self.m3SIP2D_branch.SetAddress(<void*>&self.m3SIP2D_value)

        #print "making m3SIP3D"
        self.m3SIP3D_branch = the_tree.GetBranch("m3SIP3D")
        #if not self.m3SIP3D_branch and "m3SIP3D" not in self.complained:
        if not self.m3SIP3D_branch and "m3SIP3D":
            warnings.warn( "MuMuMuTree: Expected branch m3SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SIP3D")
        else:
            self.m3SIP3D_branch.SetAddress(<void*>&self.m3SIP3D_value)

        #print "making m3SegmentCompatibility"
        self.m3SegmentCompatibility_branch = the_tree.GetBranch("m3SegmentCompatibility")
        #if not self.m3SegmentCompatibility_branch and "m3SegmentCompatibility" not in self.complained:
        if not self.m3SegmentCompatibility_branch and "m3SegmentCompatibility":
            warnings.warn( "MuMuMuTree: Expected branch m3SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SegmentCompatibility")
        else:
            self.m3SegmentCompatibility_branch.SetAddress(<void*>&self.m3SegmentCompatibility_value)

        #print "making m3SoftCutBasedId"
        self.m3SoftCutBasedId_branch = the_tree.GetBranch("m3SoftCutBasedId")
        #if not self.m3SoftCutBasedId_branch and "m3SoftCutBasedId" not in self.complained:
        if not self.m3SoftCutBasedId_branch and "m3SoftCutBasedId":
            warnings.warn( "MuMuMuTree: Expected branch m3SoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3SoftCutBasedId")
        else:
            self.m3SoftCutBasedId_branch.SetAddress(<void*>&self.m3SoftCutBasedId_value)

        #print "making m3TkIsoLoose"
        self.m3TkIsoLoose_branch = the_tree.GetBranch("m3TkIsoLoose")
        #if not self.m3TkIsoLoose_branch and "m3TkIsoLoose" not in self.complained:
        if not self.m3TkIsoLoose_branch and "m3TkIsoLoose":
            warnings.warn( "MuMuMuTree: Expected branch m3TkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkIsoLoose")
        else:
            self.m3TkIsoLoose_branch.SetAddress(<void*>&self.m3TkIsoLoose_value)

        #print "making m3TkIsoTight"
        self.m3TkIsoTight_branch = the_tree.GetBranch("m3TkIsoTight")
        #if not self.m3TkIsoTight_branch and "m3TkIsoTight" not in self.complained:
        if not self.m3TkIsoTight_branch and "m3TkIsoTight":
            warnings.warn( "MuMuMuTree: Expected branch m3TkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkIsoTight")
        else:
            self.m3TkIsoTight_branch.SetAddress(<void*>&self.m3TkIsoTight_value)

        #print "making m3TkLayersWithMeasurement"
        self.m3TkLayersWithMeasurement_branch = the_tree.GetBranch("m3TkLayersWithMeasurement")
        #if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement" not in self.complained:
        if not self.m3TkLayersWithMeasurement_branch and "m3TkLayersWithMeasurement":
            warnings.warn( "MuMuMuTree: Expected branch m3TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TkLayersWithMeasurement")
        else:
            self.m3TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m3TkLayersWithMeasurement_value)

        #print "making m3TrkIsoDR03"
        self.m3TrkIsoDR03_branch = the_tree.GetBranch("m3TrkIsoDR03")
        #if not self.m3TrkIsoDR03_branch and "m3TrkIsoDR03" not in self.complained:
        if not self.m3TrkIsoDR03_branch and "m3TrkIsoDR03":
            warnings.warn( "MuMuMuTree: Expected branch m3TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TrkIsoDR03")
        else:
            self.m3TrkIsoDR03_branch.SetAddress(<void*>&self.m3TrkIsoDR03_value)

        #print "making m3TrkKink"
        self.m3TrkKink_branch = the_tree.GetBranch("m3TrkKink")
        #if not self.m3TrkKink_branch and "m3TrkKink" not in self.complained:
        if not self.m3TrkKink_branch and "m3TrkKink":
            warnings.warn( "MuMuMuTree: Expected branch m3TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TrkKink")
        else:
            self.m3TrkKink_branch.SetAddress(<void*>&self.m3TrkKink_value)

        #print "making m3TypeCode"
        self.m3TypeCode_branch = the_tree.GetBranch("m3TypeCode")
        #if not self.m3TypeCode_branch and "m3TypeCode" not in self.complained:
        if not self.m3TypeCode_branch and "m3TypeCode":
            warnings.warn( "MuMuMuTree: Expected branch m3TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3TypeCode")
        else:
            self.m3TypeCode_branch.SetAddress(<void*>&self.m3TypeCode_value)

        #print "making m3VZ"
        self.m3VZ_branch = the_tree.GetBranch("m3VZ")
        #if not self.m3VZ_branch and "m3VZ" not in self.complained:
        if not self.m3VZ_branch and "m3VZ":
            warnings.warn( "MuMuMuTree: Expected branch m3VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3VZ")
        else:
            self.m3VZ_branch.SetAddress(<void*>&self.m3VZ_value)

        #print "making m3ValidFraction"
        self.m3ValidFraction_branch = the_tree.GetBranch("m3ValidFraction")
        #if not self.m3ValidFraction_branch and "m3ValidFraction" not in self.complained:
        if not self.m3ValidFraction_branch and "m3ValidFraction":
            warnings.warn( "MuMuMuTree: Expected branch m3ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ValidFraction")
        else:
            self.m3ValidFraction_branch.SetAddress(<void*>&self.m3ValidFraction_value)

        #print "making m3ZTTGenDR"
        self.m3ZTTGenDR_branch = the_tree.GetBranch("m3ZTTGenDR")
        #if not self.m3ZTTGenDR_branch and "m3ZTTGenDR" not in self.complained:
        if not self.m3ZTTGenDR_branch and "m3ZTTGenDR":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenDR")
        else:
            self.m3ZTTGenDR_branch.SetAddress(<void*>&self.m3ZTTGenDR_value)

        #print "making m3ZTTGenEta"
        self.m3ZTTGenEta_branch = the_tree.GetBranch("m3ZTTGenEta")
        #if not self.m3ZTTGenEta_branch and "m3ZTTGenEta" not in self.complained:
        if not self.m3ZTTGenEta_branch and "m3ZTTGenEta":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenEta")
        else:
            self.m3ZTTGenEta_branch.SetAddress(<void*>&self.m3ZTTGenEta_value)

        #print "making m3ZTTGenMatching"
        self.m3ZTTGenMatching_branch = the_tree.GetBranch("m3ZTTGenMatching")
        #if not self.m3ZTTGenMatching_branch and "m3ZTTGenMatching" not in self.complained:
        if not self.m3ZTTGenMatching_branch and "m3ZTTGenMatching":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenMatching")
        else:
            self.m3ZTTGenMatching_branch.SetAddress(<void*>&self.m3ZTTGenMatching_value)

        #print "making m3ZTTGenPhi"
        self.m3ZTTGenPhi_branch = the_tree.GetBranch("m3ZTTGenPhi")
        #if not self.m3ZTTGenPhi_branch and "m3ZTTGenPhi" not in self.complained:
        if not self.m3ZTTGenPhi_branch and "m3ZTTGenPhi":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenPhi")
        else:
            self.m3ZTTGenPhi_branch.SetAddress(<void*>&self.m3ZTTGenPhi_value)

        #print "making m3ZTTGenPt"
        self.m3ZTTGenPt_branch = the_tree.GetBranch("m3ZTTGenPt")
        #if not self.m3ZTTGenPt_branch and "m3ZTTGenPt" not in self.complained:
        if not self.m3ZTTGenPt_branch and "m3ZTTGenPt":
            warnings.warn( "MuMuMuTree: Expected branch m3ZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m3ZTTGenPt")
        else:
            self.m3ZTTGenPt_branch.SetAddress(<void*>&self.m3ZTTGenPt_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuMuMuTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuMuMuTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuMuMuTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuMuMuTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuMuMuTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "MuMuMuTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "MuMuMuTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "MuMuMuTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "MuMuMuTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "MuMuMuTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "MuMuMuTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "MuMuMuTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "MuMuMuTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuMuTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVeto5"
        self.muVeto5_branch = the_tree.GetBranch("muVeto5")
        #if not self.muVeto5_branch and "muVeto5" not in self.complained:
        if not self.muVeto5_branch and "muVeto5":
            warnings.warn( "MuMuMuTree: Expected branch muVeto5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVeto5")
        else:
            self.muVeto5_branch.SetAddress(<void*>&self.muVeto5_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuMuMuTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuMuMuTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuMuTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "MuMuMuTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuMuMuTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuMuTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuMuTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuMuMuTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuMuTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuMuTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuMuTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuMuTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuMuTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuMuTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuMuTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuMuMuTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuMuTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuMuTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuMuTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuMuTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuMuTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuMuTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuMuTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuMuTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "MuMuMuTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuMuMuTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuMuTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "MuMuMuTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuMuMuTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuMuMuTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuMuMuTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuMuMuTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "MuMuMuTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "MuMuMuTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuMuTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuMuMuTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuMuMuTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuMuMuTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "MuMuMuTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuMuMuTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuMuMuTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuMuMuTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuMuMuTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuMuMuTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuMuTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property m1MatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.m1MatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu19Tau20Filter_value

    property m1MatchesIsoMu19Tau20Path:
        def __get__(self):
            self.m1MatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu19Tau20Path_value

    property m1MatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.m1MatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu19Tau20SingleL1Filter_value

    property m1MatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.m1MatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu19Tau20SingleL1Path_value

    property m1MatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.m1MatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20HPSTau27Filter_value

    property m1MatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.m1MatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20HPSTau27Path_value

    property m1MatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.m1MatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Tau27Filter_value

    property m1MatchesIsoMu20Tau27Path:
        def __get__(self):
            self.m1MatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu20Tau27Path_value

    property m1MatchesIsoMu22Filter:
        def __get__(self):
            self.m1MatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22Filter_value

    property m1MatchesIsoMu22Path:
        def __get__(self):
            self.m1MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22Path_value

    property m1MatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.m1MatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22eta2p1Filter_value

    property m1MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu22eta2p1Path_value

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

    property m1MatchesIsoTkMu22Filter:
        def __get__(self):
            self.m1MatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22Filter_value

    property m1MatchesIsoTkMu22Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22Path_value

    property m1MatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m1MatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22eta2p1Filter_value

    property m1MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoTkMu22eta2p1Path_value

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

    property m1ZTTGenDR:
        def __get__(self):
            self.m1ZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenDR_value

    property m1ZTTGenEta:
        def __get__(self):
            self.m1ZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenEta_value

    property m1ZTTGenMatching:
        def __get__(self):
            self.m1ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenMatching_value

    property m1ZTTGenPhi:
        def __get__(self):
            self.m1ZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenPhi_value

    property m1ZTTGenPt:
        def __get__(self):
            self.m1ZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.m1ZTTGenPt_value

    property m1_m2_DR:
        def __get__(self):
            self.m1_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DR_value

    property m1_m2_Mass:
        def __get__(self):
            self.m1_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_value

    property m1_m2_PZeta:
        def __get__(self):
            self.m1_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZeta_value

    property m1_m2_PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaVis_value

    property m1_m2_doubleL1IsoTauMatch:
        def __get__(self):
            self.m1_m2_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_doubleL1IsoTauMatch_value

    property m1_m3_DR:
        def __get__(self):
            self.m1_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_DR_value

    property m1_m3_Mass:
        def __get__(self):
            self.m1_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_Mass_value

    property m1_m3_PZeta:
        def __get__(self):
            self.m1_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZeta_value

    property m1_m3_PZetaVis:
        def __get__(self):
            self.m1_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_PZetaVis_value

    property m1_m3_doubleL1IsoTauMatch:
        def __get__(self):
            self.m1_m3_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m1_m3_doubleL1IsoTauMatch_value

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

    property m2MatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.m2MatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu19Tau20Filter_value

    property m2MatchesIsoMu19Tau20Path:
        def __get__(self):
            self.m2MatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu19Tau20Path_value

    property m2MatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.m2MatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu19Tau20SingleL1Filter_value

    property m2MatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.m2MatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu19Tau20SingleL1Path_value

    property m2MatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.m2MatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20HPSTau27Filter_value

    property m2MatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.m2MatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20HPSTau27Path_value

    property m2MatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.m2MatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Tau27Filter_value

    property m2MatchesIsoMu20Tau27Path:
        def __get__(self):
            self.m2MatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu20Tau27Path_value

    property m2MatchesIsoMu22Filter:
        def __get__(self):
            self.m2MatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22Filter_value

    property m2MatchesIsoMu22Path:
        def __get__(self):
            self.m2MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22Path_value

    property m2MatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.m2MatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22eta2p1Filter_value

    property m2MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu22eta2p1Path_value

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

    property m2MatchesIsoTkMu22Filter:
        def __get__(self):
            self.m2MatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22Filter_value

    property m2MatchesIsoTkMu22Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22Path_value

    property m2MatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m2MatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22eta2p1Filter_value

    property m2MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoTkMu22eta2p1Path_value

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

    property m2ZTTGenDR:
        def __get__(self):
            self.m2ZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenDR_value

    property m2ZTTGenEta:
        def __get__(self):
            self.m2ZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenEta_value

    property m2ZTTGenMatching:
        def __get__(self):
            self.m2ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenMatching_value

    property m2ZTTGenPhi:
        def __get__(self):
            self.m2ZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenPhi_value

    property m2ZTTGenPt:
        def __get__(self):
            self.m2ZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.m2ZTTGenPt_value

    property m2_m3_DR:
        def __get__(self):
            self.m2_m3_DR_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_DR_value

    property m2_m3_Mass:
        def __get__(self):
            self.m2_m3_Mass_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_Mass_value

    property m2_m3_PZeta:
        def __get__(self):
            self.m2_m3_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZeta_value

    property m2_m3_PZetaVis:
        def __get__(self):
            self.m2_m3_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_PZetaVis_value

    property m2_m3_doubleL1IsoTauMatch:
        def __get__(self):
            self.m2_m3_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m2_m3_doubleL1IsoTauMatch_value

    property m3BestTrackType:
        def __get__(self):
            self.m3BestTrackType_branch.GetEntry(self.localentry, 0)
            return self.m3BestTrackType_value

    property m3Charge:
        def __get__(self):
            self.m3Charge_branch.GetEntry(self.localentry, 0)
            return self.m3Charge_value

    property m3Chi2LocalPosition:
        def __get__(self):
            self.m3Chi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.m3Chi2LocalPosition_value

    property m3ComesFromHiggs:
        def __get__(self):
            self.m3ComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.m3ComesFromHiggs_value

    property m3CutBasedIdGlobalHighPt:
        def __get__(self):
            self.m3CutBasedIdGlobalHighPt_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdGlobalHighPt_value

    property m3CutBasedIdLoose:
        def __get__(self):
            self.m3CutBasedIdLoose_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdLoose_value

    property m3CutBasedIdMedium:
        def __get__(self):
            self.m3CutBasedIdMedium_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdMedium_value

    property m3CutBasedIdMediumPrompt:
        def __get__(self):
            self.m3CutBasedIdMediumPrompt_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdMediumPrompt_value

    property m3CutBasedIdTight:
        def __get__(self):
            self.m3CutBasedIdTight_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdTight_value

    property m3CutBasedIdTrkHighPt:
        def __get__(self):
            self.m3CutBasedIdTrkHighPt_branch.GetEntry(self.localentry, 0)
            return self.m3CutBasedIdTrkHighPt_value

    property m3EcalIsoDR03:
        def __get__(self):
            self.m3EcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3EcalIsoDR03_value

    property m3EffectiveArea2011:
        def __get__(self):
            self.m3EffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2011_value

    property m3EffectiveArea2012:
        def __get__(self):
            self.m3EffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.m3EffectiveArea2012_value

    property m3Eta:
        def __get__(self):
            self.m3Eta_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_value

    property m3Eta_MuonEnDown:
        def __get__(self):
            self.m3Eta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_MuonEnDown_value

    property m3Eta_MuonEnUp:
        def __get__(self):
            self.m3Eta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Eta_MuonEnUp_value

    property m3GenCharge:
        def __get__(self):
            self.m3GenCharge_branch.GetEntry(self.localentry, 0)
            return self.m3GenCharge_value

    property m3GenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.m3GenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.m3GenDirectPromptTauDecayFinalState_value

    property m3GenEnergy:
        def __get__(self):
            self.m3GenEnergy_branch.GetEntry(self.localentry, 0)
            return self.m3GenEnergy_value

    property m3GenEta:
        def __get__(self):
            self.m3GenEta_branch.GetEntry(self.localentry, 0)
            return self.m3GenEta_value

    property m3GenIsPrompt:
        def __get__(self):
            self.m3GenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.m3GenIsPrompt_value

    property m3GenMotherPdgId:
        def __get__(self):
            self.m3GenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenMotherPdgId_value

    property m3GenParticle:
        def __get__(self):
            self.m3GenParticle_branch.GetEntry(self.localentry, 0)
            return self.m3GenParticle_value

    property m3GenPdgId:
        def __get__(self):
            self.m3GenPdgId_branch.GetEntry(self.localentry, 0)
            return self.m3GenPdgId_value

    property m3GenPhi:
        def __get__(self):
            self.m3GenPhi_branch.GetEntry(self.localentry, 0)
            return self.m3GenPhi_value

    property m3GenPrompt:
        def __get__(self):
            self.m3GenPrompt_branch.GetEntry(self.localentry, 0)
            return self.m3GenPrompt_value

    property m3GenPromptFinalState:
        def __get__(self):
            self.m3GenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.m3GenPromptFinalState_value

    property m3GenPromptTauDecay:
        def __get__(self):
            self.m3GenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m3GenPromptTauDecay_value

    property m3GenPt:
        def __get__(self):
            self.m3GenPt_branch.GetEntry(self.localentry, 0)
            return self.m3GenPt_value

    property m3GenTauDecay:
        def __get__(self):
            self.m3GenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.m3GenTauDecay_value

    property m3GenVZ:
        def __get__(self):
            self.m3GenVZ_branch.GetEntry(self.localentry, 0)
            return self.m3GenVZ_value

    property m3GenVtxPVMatch:
        def __get__(self):
            self.m3GenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.m3GenVtxPVMatch_value

    property m3HcalIsoDR03:
        def __get__(self):
            self.m3HcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3HcalIsoDR03_value

    property m3IP3D:
        def __get__(self):
            self.m3IP3D_branch.GetEntry(self.localentry, 0)
            return self.m3IP3D_value

    property m3IP3DErr:
        def __get__(self):
            self.m3IP3DErr_branch.GetEntry(self.localentry, 0)
            return self.m3IP3DErr_value

    property m3IsGlobal:
        def __get__(self):
            self.m3IsGlobal_branch.GetEntry(self.localentry, 0)
            return self.m3IsGlobal_value

    property m3IsPFMuon:
        def __get__(self):
            self.m3IsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.m3IsPFMuon_value

    property m3IsTracker:
        def __get__(self):
            self.m3IsTracker_branch.GetEntry(self.localentry, 0)
            return self.m3IsTracker_value

    property m3IsoDB03:
        def __get__(self):
            self.m3IsoDB03_branch.GetEntry(self.localentry, 0)
            return self.m3IsoDB03_value

    property m3IsoDB04:
        def __get__(self):
            self.m3IsoDB04_branch.GetEntry(self.localentry, 0)
            return self.m3IsoDB04_value

    property m3JetArea:
        def __get__(self):
            self.m3JetArea_branch.GetEntry(self.localentry, 0)
            return self.m3JetArea_value

    property m3JetBtag:
        def __get__(self):
            self.m3JetBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetBtag_value

    property m3JetDR:
        def __get__(self):
            self.m3JetDR_branch.GetEntry(self.localentry, 0)
            return self.m3JetDR_value

    property m3JetEtaEtaMoment:
        def __get__(self):
            self.m3JetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaEtaMoment_value

    property m3JetEtaPhiMoment:
        def __get__(self):
            self.m3JetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiMoment_value

    property m3JetEtaPhiSpread:
        def __get__(self):
            self.m3JetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.m3JetEtaPhiSpread_value

    property m3JetHadronFlavour:
        def __get__(self):
            self.m3JetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.m3JetHadronFlavour_value

    property m3JetPFCISVBtag:
        def __get__(self):
            self.m3JetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.m3JetPFCISVBtag_value

    property m3JetPartonFlavour:
        def __get__(self):
            self.m3JetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.m3JetPartonFlavour_value

    property m3JetPhiPhiMoment:
        def __get__(self):
            self.m3JetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.m3JetPhiPhiMoment_value

    property m3JetPt:
        def __get__(self):
            self.m3JetPt_branch.GetEntry(self.localentry, 0)
            return self.m3JetPt_value

    property m3LowestMll:
        def __get__(self):
            self.m3LowestMll_branch.GetEntry(self.localentry, 0)
            return self.m3LowestMll_value

    property m3Mass:
        def __get__(self):
            self.m3Mass_branch.GetEntry(self.localentry, 0)
            return self.m3Mass_value

    property m3MatchedStations:
        def __get__(self):
            self.m3MatchedStations_branch.GetEntry(self.localentry, 0)
            return self.m3MatchedStations_value

    property m3MatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.m3MatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu19Tau20Filter_value

    property m3MatchesIsoMu19Tau20Path:
        def __get__(self):
            self.m3MatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu19Tau20Path_value

    property m3MatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.m3MatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu19Tau20SingleL1Filter_value

    property m3MatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.m3MatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu19Tau20SingleL1Path_value

    property m3MatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.m3MatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu20HPSTau27Filter_value

    property m3MatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.m3MatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu20HPSTau27Path_value

    property m3MatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.m3MatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu20Tau27Filter_value

    property m3MatchesIsoMu20Tau27Path:
        def __get__(self):
            self.m3MatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu20Tau27Path_value

    property m3MatchesIsoMu22Filter:
        def __get__(self):
            self.m3MatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22Filter_value

    property m3MatchesIsoMu22Path:
        def __get__(self):
            self.m3MatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22Path_value

    property m3MatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.m3MatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22eta2p1Filter_value

    property m3MatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu22eta2p1Path_value

    property m3MatchesIsoMu24Filter:
        def __get__(self):
            self.m3MatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu24Filter_value

    property m3MatchesIsoMu24Path:
        def __get__(self):
            self.m3MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu24Path_value

    property m3MatchesIsoMu27Filter:
        def __get__(self):
            self.m3MatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu27Filter_value

    property m3MatchesIsoMu27Path:
        def __get__(self):
            self.m3MatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoMu27Path_value

    property m3MatchesIsoTkMu22Filter:
        def __get__(self):
            self.m3MatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22Filter_value

    property m3MatchesIsoTkMu22Path:
        def __get__(self):
            self.m3MatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22Path_value

    property m3MatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.m3MatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22eta2p1Filter_value

    property m3MatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.m3MatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m3MatchesIsoTkMu22eta2p1Path_value

    property m3MiniIsoLoose:
        def __get__(self):
            self.m3MiniIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m3MiniIsoLoose_value

    property m3MiniIsoMedium:
        def __get__(self):
            self.m3MiniIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m3MiniIsoMedium_value

    property m3MiniIsoTight:
        def __get__(self):
            self.m3MiniIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m3MiniIsoTight_value

    property m3MiniIsoVeryTight:
        def __get__(self):
            self.m3MiniIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m3MiniIsoVeryTight_value

    property m3MuonHits:
        def __get__(self):
            self.m3MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m3MuonHits_value

    property m3MvaLoose:
        def __get__(self):
            self.m3MvaLoose_branch.GetEntry(self.localentry, 0)
            return self.m3MvaLoose_value

    property m3MvaMedium:
        def __get__(self):
            self.m3MvaMedium_branch.GetEntry(self.localentry, 0)
            return self.m3MvaMedium_value

    property m3MvaTight:
        def __get__(self):
            self.m3MvaTight_branch.GetEntry(self.localentry, 0)
            return self.m3MvaTight_value

    property m3NearestZMass:
        def __get__(self):
            self.m3NearestZMass_branch.GetEntry(self.localentry, 0)
            return self.m3NearestZMass_value

    property m3NormTrkChi2:
        def __get__(self):
            self.m3NormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.m3NormTrkChi2_value

    property m3NormalizedChi2:
        def __get__(self):
            self.m3NormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.m3NormalizedChi2_value

    property m3PFChargedHadronIsoR04:
        def __get__(self):
            self.m3PFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFChargedHadronIsoR04_value

    property m3PFChargedIso:
        def __get__(self):
            self.m3PFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFChargedIso_value

    property m3PFIDLoose:
        def __get__(self):
            self.m3PFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDLoose_value

    property m3PFIDMedium:
        def __get__(self):
            self.m3PFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDMedium_value

    property m3PFIDTight:
        def __get__(self):
            self.m3PFIDTight_branch.GetEntry(self.localentry, 0)
            return self.m3PFIDTight_value

    property m3PFIsoLoose:
        def __get__(self):
            self.m3PFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m3PFIsoLoose_value

    property m3PFIsoMedium:
        def __get__(self):
            self.m3PFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.m3PFIsoMedium_value

    property m3PFIsoTight:
        def __get__(self):
            self.m3PFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m3PFIsoTight_value

    property m3PFIsoVeryLoose:
        def __get__(self):
            self.m3PFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.m3PFIsoVeryLoose_value

    property m3PFIsoVeryTight:
        def __get__(self):
            self.m3PFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.m3PFIsoVeryTight_value

    property m3PFNeutralHadronIsoR04:
        def __get__(self):
            self.m3PFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFNeutralHadronIsoR04_value

    property m3PFNeutralIso:
        def __get__(self):
            self.m3PFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFNeutralIso_value

    property m3PFPUChargedIso:
        def __get__(self):
            self.m3PFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPUChargedIso_value

    property m3PFPhotonIso:
        def __get__(self):
            self.m3PFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.m3PFPhotonIso_value

    property m3PFPhotonIsoR04:
        def __get__(self):
            self.m3PFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFPhotonIsoR04_value

    property m3PFPileupIsoR04:
        def __get__(self):
            self.m3PFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.m3PFPileupIsoR04_value

    property m3PVDXY:
        def __get__(self):
            self.m3PVDXY_branch.GetEntry(self.localentry, 0)
            return self.m3PVDXY_value

    property m3PVDZ:
        def __get__(self):
            self.m3PVDZ_branch.GetEntry(self.localentry, 0)
            return self.m3PVDZ_value

    property m3Phi:
        def __get__(self):
            self.m3Phi_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_value

    property m3Phi_MuonEnDown:
        def __get__(self):
            self.m3Phi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_MuonEnDown_value

    property m3Phi_MuonEnUp:
        def __get__(self):
            self.m3Phi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Phi_MuonEnUp_value

    property m3PixHits:
        def __get__(self):
            self.m3PixHits_branch.GetEntry(self.localentry, 0)
            return self.m3PixHits_value

    property m3Pt:
        def __get__(self):
            self.m3Pt_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_value

    property m3Pt_MuonEnDown:
        def __get__(self):
            self.m3Pt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_MuonEnDown_value

    property m3Pt_MuonEnUp:
        def __get__(self):
            self.m3Pt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m3Pt_MuonEnUp_value

    property m3RelPFIsoDBDefault:
        def __get__(self):
            self.m3RelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoDBDefault_value

    property m3RelPFIsoDBDefaultR04:
        def __get__(self):
            self.m3RelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoDBDefaultR04_value

    property m3RelPFIsoRho:
        def __get__(self):
            self.m3RelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.m3RelPFIsoRho_value

    property m3Rho:
        def __get__(self):
            self.m3Rho_branch.GetEntry(self.localentry, 0)
            return self.m3Rho_value

    property m3SIP2D:
        def __get__(self):
            self.m3SIP2D_branch.GetEntry(self.localentry, 0)
            return self.m3SIP2D_value

    property m3SIP3D:
        def __get__(self):
            self.m3SIP3D_branch.GetEntry(self.localentry, 0)
            return self.m3SIP3D_value

    property m3SegmentCompatibility:
        def __get__(self):
            self.m3SegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.m3SegmentCompatibility_value

    property m3SoftCutBasedId:
        def __get__(self):
            self.m3SoftCutBasedId_branch.GetEntry(self.localentry, 0)
            return self.m3SoftCutBasedId_value

    property m3TkIsoLoose:
        def __get__(self):
            self.m3TkIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.m3TkIsoLoose_value

    property m3TkIsoTight:
        def __get__(self):
            self.m3TkIsoTight_branch.GetEntry(self.localentry, 0)
            return self.m3TkIsoTight_value

    property m3TkLayersWithMeasurement:
        def __get__(self):
            self.m3TkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.m3TkLayersWithMeasurement_value

    property m3TrkIsoDR03:
        def __get__(self):
            self.m3TrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.m3TrkIsoDR03_value

    property m3TrkKink:
        def __get__(self):
            self.m3TrkKink_branch.GetEntry(self.localentry, 0)
            return self.m3TrkKink_value

    property m3TypeCode:
        def __get__(self):
            self.m3TypeCode_branch.GetEntry(self.localentry, 0)
            return self.m3TypeCode_value

    property m3VZ:
        def __get__(self):
            self.m3VZ_branch.GetEntry(self.localentry, 0)
            return self.m3VZ_value

    property m3ValidFraction:
        def __get__(self):
            self.m3ValidFraction_branch.GetEntry(self.localentry, 0)
            return self.m3ValidFraction_value

    property m3ZTTGenDR:
        def __get__(self):
            self.m3ZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenDR_value

    property m3ZTTGenEta:
        def __get__(self):
            self.m3ZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenEta_value

    property m3ZTTGenMatching:
        def __get__(self):
            self.m3ZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenMatching_value

    property m3ZTTGenPhi:
        def __get__(self):
            self.m3ZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenPhi_value

    property m3ZTTGenPt:
        def __get__(self):
            self.m3ZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.m3ZTTGenPt_value

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


