

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

cdef class MuTauTree:
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

    cdef TBranch* jetVeto30WoNoisyJets_JetEnDown_branch
    cdef float jetVeto30WoNoisyJets_JetEnDown_value

    cdef TBranch* jetVeto30WoNoisyJets_JetEnUp_branch
    cdef float jetVeto30WoNoisyJets_JetEnUp_value

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

    cdef TBranch* mBestTrackType_branch
    cdef float mBestTrackType_value

    cdef TBranch* mCharge_branch
    cdef float mCharge_value

    cdef TBranch* mChi2LocalPosition_branch
    cdef float mChi2LocalPosition_value

    cdef TBranch* mComesFromHiggs_branch
    cdef float mComesFromHiggs_value

    cdef TBranch* mCutBasedIdGlobalHighPt_branch
    cdef float mCutBasedIdGlobalHighPt_value

    cdef TBranch* mCutBasedIdLoose_branch
    cdef float mCutBasedIdLoose_value

    cdef TBranch* mCutBasedIdMedium_branch
    cdef float mCutBasedIdMedium_value

    cdef TBranch* mCutBasedIdMediumPrompt_branch
    cdef float mCutBasedIdMediumPrompt_value

    cdef TBranch* mCutBasedIdTight_branch
    cdef float mCutBasedIdTight_value

    cdef TBranch* mCutBasedIdTrkHighPt_branch
    cdef float mCutBasedIdTrkHighPt_value

    cdef TBranch* mEcalIsoDR03_branch
    cdef float mEcalIsoDR03_value

    cdef TBranch* mEffectiveArea2011_branch
    cdef float mEffectiveArea2011_value

    cdef TBranch* mEffectiveArea2012_branch
    cdef float mEffectiveArea2012_value

    cdef TBranch* mEta_branch
    cdef float mEta_value

    cdef TBranch* mEta_MuonEnDown_branch
    cdef float mEta_MuonEnDown_value

    cdef TBranch* mEta_MuonEnUp_branch
    cdef float mEta_MuonEnUp_value

    cdef TBranch* mGenCharge_branch
    cdef float mGenCharge_value

    cdef TBranch* mGenDirectPromptTauDecayFinalState_branch
    cdef float mGenDirectPromptTauDecayFinalState_value

    cdef TBranch* mGenEnergy_branch
    cdef float mGenEnergy_value

    cdef TBranch* mGenEta_branch
    cdef float mGenEta_value

    cdef TBranch* mGenIsPrompt_branch
    cdef float mGenIsPrompt_value

    cdef TBranch* mGenMotherPdgId_branch
    cdef float mGenMotherPdgId_value

    cdef TBranch* mGenParticle_branch
    cdef float mGenParticle_value

    cdef TBranch* mGenPdgId_branch
    cdef float mGenPdgId_value

    cdef TBranch* mGenPhi_branch
    cdef float mGenPhi_value

    cdef TBranch* mGenPrompt_branch
    cdef float mGenPrompt_value

    cdef TBranch* mGenPromptFinalState_branch
    cdef float mGenPromptFinalState_value

    cdef TBranch* mGenPromptTauDecay_branch
    cdef float mGenPromptTauDecay_value

    cdef TBranch* mGenPt_branch
    cdef float mGenPt_value

    cdef TBranch* mGenTauDecay_branch
    cdef float mGenTauDecay_value

    cdef TBranch* mGenVZ_branch
    cdef float mGenVZ_value

    cdef TBranch* mGenVtxPVMatch_branch
    cdef float mGenVtxPVMatch_value

    cdef TBranch* mHcalIsoDR03_branch
    cdef float mHcalIsoDR03_value

    cdef TBranch* mIP3D_branch
    cdef float mIP3D_value

    cdef TBranch* mIP3DErr_branch
    cdef float mIP3DErr_value

    cdef TBranch* mIsGlobal_branch
    cdef float mIsGlobal_value

    cdef TBranch* mIsPFMuon_branch
    cdef float mIsPFMuon_value

    cdef TBranch* mIsTracker_branch
    cdef float mIsTracker_value

    cdef TBranch* mIsoDB03_branch
    cdef float mIsoDB03_value

    cdef TBranch* mIsoDB04_branch
    cdef float mIsoDB04_value

    cdef TBranch* mJetArea_branch
    cdef float mJetArea_value

    cdef TBranch* mJetBtag_branch
    cdef float mJetBtag_value

    cdef TBranch* mJetDR_branch
    cdef float mJetDR_value

    cdef TBranch* mJetEtaEtaMoment_branch
    cdef float mJetEtaEtaMoment_value

    cdef TBranch* mJetEtaPhiMoment_branch
    cdef float mJetEtaPhiMoment_value

    cdef TBranch* mJetEtaPhiSpread_branch
    cdef float mJetEtaPhiSpread_value

    cdef TBranch* mJetHadronFlavour_branch
    cdef float mJetHadronFlavour_value

    cdef TBranch* mJetPFCISVBtag_branch
    cdef float mJetPFCISVBtag_value

    cdef TBranch* mJetPartonFlavour_branch
    cdef float mJetPartonFlavour_value

    cdef TBranch* mJetPhiPhiMoment_branch
    cdef float mJetPhiPhiMoment_value

    cdef TBranch* mJetPt_branch
    cdef float mJetPt_value

    cdef TBranch* mLowestMll_branch
    cdef float mLowestMll_value

    cdef TBranch* mMass_branch
    cdef float mMass_value

    cdef TBranch* mMatchedStations_branch
    cdef float mMatchedStations_value

    cdef TBranch* mMatchesIsoMu19Tau20Filter_branch
    cdef float mMatchesIsoMu19Tau20Filter_value

    cdef TBranch* mMatchesIsoMu19Tau20Path_branch
    cdef float mMatchesIsoMu19Tau20Path_value

    cdef TBranch* mMatchesIsoMu19Tau20SingleL1Filter_branch
    cdef float mMatchesIsoMu19Tau20SingleL1Filter_value

    cdef TBranch* mMatchesIsoMu19Tau20SingleL1Path_branch
    cdef float mMatchesIsoMu19Tau20SingleL1Path_value

    cdef TBranch* mMatchesIsoMu20HPSTau27Filter_branch
    cdef float mMatchesIsoMu20HPSTau27Filter_value

    cdef TBranch* mMatchesIsoMu20HPSTau27Path_branch
    cdef float mMatchesIsoMu20HPSTau27Path_value

    cdef TBranch* mMatchesIsoMu20Tau27Filter_branch
    cdef float mMatchesIsoMu20Tau27Filter_value

    cdef TBranch* mMatchesIsoMu20Tau27Path_branch
    cdef float mMatchesIsoMu20Tau27Path_value

    cdef TBranch* mMatchesIsoMu22Filter_branch
    cdef float mMatchesIsoMu22Filter_value

    cdef TBranch* mMatchesIsoMu22Path_branch
    cdef float mMatchesIsoMu22Path_value

    cdef TBranch* mMatchesIsoMu22eta2p1Filter_branch
    cdef float mMatchesIsoMu22eta2p1Filter_value

    cdef TBranch* mMatchesIsoMu22eta2p1Path_branch
    cdef float mMatchesIsoMu22eta2p1Path_value

    cdef TBranch* mMatchesIsoMu24Filter_branch
    cdef float mMatchesIsoMu24Filter_value

    cdef TBranch* mMatchesIsoMu24Path_branch
    cdef float mMatchesIsoMu24Path_value

    cdef TBranch* mMatchesIsoMu27Filter_branch
    cdef float mMatchesIsoMu27Filter_value

    cdef TBranch* mMatchesIsoMu27Path_branch
    cdef float mMatchesIsoMu27Path_value

    cdef TBranch* mMatchesIsoTkMu22Filter_branch
    cdef float mMatchesIsoTkMu22Filter_value

    cdef TBranch* mMatchesIsoTkMu22Path_branch
    cdef float mMatchesIsoTkMu22Path_value

    cdef TBranch* mMatchesIsoTkMu22eta2p1Filter_branch
    cdef float mMatchesIsoTkMu22eta2p1Filter_value

    cdef TBranch* mMatchesIsoTkMu22eta2p1Path_branch
    cdef float mMatchesIsoTkMu22eta2p1Path_value

    cdef TBranch* mMatchesMu23e12DZFilter_branch
    cdef float mMatchesMu23e12DZFilter_value

    cdef TBranch* mMatchesMu23e12DZPath_branch
    cdef float mMatchesMu23e12DZPath_value

    cdef TBranch* mMatchesMu23e12Filter_branch
    cdef float mMatchesMu23e12Filter_value

    cdef TBranch* mMatchesMu23e12Path_branch
    cdef float mMatchesMu23e12Path_value

    cdef TBranch* mMatchesMu8e23DZFilter_branch
    cdef float mMatchesMu8e23DZFilter_value

    cdef TBranch* mMatchesMu8e23DZPath_branch
    cdef float mMatchesMu8e23DZPath_value

    cdef TBranch* mMatchesMu8e23Filter_branch
    cdef float mMatchesMu8e23Filter_value

    cdef TBranch* mMatchesMu8e23Path_branch
    cdef float mMatchesMu8e23Path_value

    cdef TBranch* mMiniIsoLoose_branch
    cdef float mMiniIsoLoose_value

    cdef TBranch* mMiniIsoMedium_branch
    cdef float mMiniIsoMedium_value

    cdef TBranch* mMiniIsoTight_branch
    cdef float mMiniIsoTight_value

    cdef TBranch* mMiniIsoVeryTight_branch
    cdef float mMiniIsoVeryTight_value

    cdef TBranch* mMuonHits_branch
    cdef float mMuonHits_value

    cdef TBranch* mMvaLoose_branch
    cdef float mMvaLoose_value

    cdef TBranch* mMvaMedium_branch
    cdef float mMvaMedium_value

    cdef TBranch* mMvaTight_branch
    cdef float mMvaTight_value

    cdef TBranch* mNearestZMass_branch
    cdef float mNearestZMass_value

    cdef TBranch* mNormTrkChi2_branch
    cdef float mNormTrkChi2_value

    cdef TBranch* mNormalizedChi2_branch
    cdef float mNormalizedChi2_value

    cdef TBranch* mPFChargedHadronIsoR04_branch
    cdef float mPFChargedHadronIsoR04_value

    cdef TBranch* mPFChargedIso_branch
    cdef float mPFChargedIso_value

    cdef TBranch* mPFIDLoose_branch
    cdef float mPFIDLoose_value

    cdef TBranch* mPFIDMedium_branch
    cdef float mPFIDMedium_value

    cdef TBranch* mPFIDTight_branch
    cdef float mPFIDTight_value

    cdef TBranch* mPFIsoLoose_branch
    cdef float mPFIsoLoose_value

    cdef TBranch* mPFIsoMedium_branch
    cdef float mPFIsoMedium_value

    cdef TBranch* mPFIsoTight_branch
    cdef float mPFIsoTight_value

    cdef TBranch* mPFIsoVeryLoose_branch
    cdef float mPFIsoVeryLoose_value

    cdef TBranch* mPFIsoVeryTight_branch
    cdef float mPFIsoVeryTight_value

    cdef TBranch* mPFNeutralHadronIsoR04_branch
    cdef float mPFNeutralHadronIsoR04_value

    cdef TBranch* mPFNeutralIso_branch
    cdef float mPFNeutralIso_value

    cdef TBranch* mPFPUChargedIso_branch
    cdef float mPFPUChargedIso_value

    cdef TBranch* mPFPhotonIso_branch
    cdef float mPFPhotonIso_value

    cdef TBranch* mPFPhotonIsoR04_branch
    cdef float mPFPhotonIsoR04_value

    cdef TBranch* mPFPileupIsoR04_branch
    cdef float mPFPileupIsoR04_value

    cdef TBranch* mPVDXY_branch
    cdef float mPVDXY_value

    cdef TBranch* mPVDZ_branch
    cdef float mPVDZ_value

    cdef TBranch* mPhi_branch
    cdef float mPhi_value

    cdef TBranch* mPhi_MuonEnDown_branch
    cdef float mPhi_MuonEnDown_value

    cdef TBranch* mPhi_MuonEnUp_branch
    cdef float mPhi_MuonEnUp_value

    cdef TBranch* mPixHits_branch
    cdef float mPixHits_value

    cdef TBranch* mPt_branch
    cdef float mPt_value

    cdef TBranch* mPt_MuonEnDown_branch
    cdef float mPt_MuonEnDown_value

    cdef TBranch* mPt_MuonEnUp_branch
    cdef float mPt_MuonEnUp_value

    cdef TBranch* mRelPFIsoDBDefault_branch
    cdef float mRelPFIsoDBDefault_value

    cdef TBranch* mRelPFIsoDBDefaultR04_branch
    cdef float mRelPFIsoDBDefaultR04_value

    cdef TBranch* mRelPFIsoRho_branch
    cdef float mRelPFIsoRho_value

    cdef TBranch* mRho_branch
    cdef float mRho_value

    cdef TBranch* mSIP2D_branch
    cdef float mSIP2D_value

    cdef TBranch* mSIP3D_branch
    cdef float mSIP3D_value

    cdef TBranch* mSegmentCompatibility_branch
    cdef float mSegmentCompatibility_value

    cdef TBranch* mSoftCutBasedId_branch
    cdef float mSoftCutBasedId_value

    cdef TBranch* mTkIsoLoose_branch
    cdef float mTkIsoLoose_value

    cdef TBranch* mTkIsoTight_branch
    cdef float mTkIsoTight_value

    cdef TBranch* mTkLayersWithMeasurement_branch
    cdef float mTkLayersWithMeasurement_value

    cdef TBranch* mTrkIsoDR03_branch
    cdef float mTrkIsoDR03_value

    cdef TBranch* mTrkKink_branch
    cdef float mTrkKink_value

    cdef TBranch* mTypeCode_branch
    cdef int mTypeCode_value

    cdef TBranch* mVZ_branch
    cdef float mVZ_value

    cdef TBranch* mValidFraction_branch
    cdef float mValidFraction_value

    cdef TBranch* mZTTGenDR_branch
    cdef float mZTTGenDR_value

    cdef TBranch* mZTTGenEta_branch
    cdef float mZTTGenEta_value

    cdef TBranch* mZTTGenMatching_branch
    cdef float mZTTGenMatching_value

    cdef TBranch* mZTTGenPhi_branch
    cdef float mZTTGenPhi_value

    cdef TBranch* mZTTGenPt_branch
    cdef float mZTTGenPt_value

    cdef TBranch* m_t_DR_branch
    cdef float m_t_DR_value

    cdef TBranch* m_t_Mass_branch
    cdef float m_t_Mass_value

    cdef TBranch* m_t_PZeta_branch
    cdef float m_t_PZeta_value

    cdef TBranch* m_t_PZetaVis_branch
    cdef float m_t_PZetaVis_value

    cdef TBranch* m_t_doubleL1IsoTauMatch_branch
    cdef float m_t_doubleL1IsoTauMatch_value

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
            warnings.warn( "MuTauTree: Expected branch DoubleMediumHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35Pass")
        else:
            self.DoubleMediumHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35Pass_value)

        #print "making DoubleMediumHPSTau35TightIDPass"
        self.DoubleMediumHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau35TightIDPass")
        #if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau35TightIDPass_branch and "DoubleMediumHPSTau35TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau35TightIDPass")
        else:
            self.DoubleMediumHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau35TightIDPass_value)

        #print "making DoubleMediumHPSTau40Pass"
        self.DoubleMediumHPSTau40Pass_branch = the_tree.GetBranch("DoubleMediumHPSTau40Pass")
        #if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass" not in self.complained:
        if not self.DoubleMediumHPSTau40Pass_branch and "DoubleMediumHPSTau40Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40Pass")
        else:
            self.DoubleMediumHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40Pass_value)

        #print "making DoubleMediumHPSTau40TightIDPass"
        self.DoubleMediumHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumHPSTau40TightIDPass")
        #if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumHPSTau40TightIDPass_branch and "DoubleMediumHPSTau40TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumHPSTau40TightIDPass")
        else:
            self.DoubleMediumHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumHPSTau40TightIDPass_value)

        #print "making DoubleMediumTau35Pass"
        self.DoubleMediumTau35Pass_branch = the_tree.GetBranch("DoubleMediumTau35Pass")
        #if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass" not in self.complained:
        if not self.DoubleMediumTau35Pass_branch and "DoubleMediumTau35Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35Pass")
        else:
            self.DoubleMediumTau35Pass_branch.SetAddress(<void*>&self.DoubleMediumTau35Pass_value)

        #print "making DoubleMediumTau35TightIDPass"
        self.DoubleMediumTau35TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau35TightIDPass")
        #if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass" not in self.complained:
        if not self.DoubleMediumTau35TightIDPass_branch and "DoubleMediumTau35TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau35TightIDPass")
        else:
            self.DoubleMediumTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau35TightIDPass_value)

        #print "making DoubleMediumTau40Pass"
        self.DoubleMediumTau40Pass_branch = the_tree.GetBranch("DoubleMediumTau40Pass")
        #if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass" not in self.complained:
        if not self.DoubleMediumTau40Pass_branch and "DoubleMediumTau40Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40Pass")
        else:
            self.DoubleMediumTau40Pass_branch.SetAddress(<void*>&self.DoubleMediumTau40Pass_value)

        #print "making DoubleMediumTau40TightIDPass"
        self.DoubleMediumTau40TightIDPass_branch = the_tree.GetBranch("DoubleMediumTau40TightIDPass")
        #if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass" not in self.complained:
        if not self.DoubleMediumTau40TightIDPass_branch and "DoubleMediumTau40TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleMediumTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleMediumTau40TightIDPass")
        else:
            self.DoubleMediumTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleMediumTau40TightIDPass_value)

        #print "making DoubleTightHPSTau35Pass"
        self.DoubleTightHPSTau35Pass_branch = the_tree.GetBranch("DoubleTightHPSTau35Pass")
        #if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass" not in self.complained:
        if not self.DoubleTightHPSTau35Pass_branch and "DoubleTightHPSTau35Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightHPSTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35Pass")
        else:
            self.DoubleTightHPSTau35Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35Pass_value)

        #print "making DoubleTightHPSTau35TightIDPass"
        self.DoubleTightHPSTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau35TightIDPass")
        #if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau35TightIDPass_branch and "DoubleTightHPSTau35TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightHPSTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau35TightIDPass")
        else:
            self.DoubleTightHPSTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau35TightIDPass_value)

        #print "making DoubleTightHPSTau40Pass"
        self.DoubleTightHPSTau40Pass_branch = the_tree.GetBranch("DoubleTightHPSTau40Pass")
        #if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass" not in self.complained:
        if not self.DoubleTightHPSTau40Pass_branch and "DoubleTightHPSTau40Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightHPSTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40Pass")
        else:
            self.DoubleTightHPSTau40Pass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40Pass_value)

        #print "making DoubleTightHPSTau40TightIDPass"
        self.DoubleTightHPSTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightHPSTau40TightIDPass")
        #if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass" not in self.complained:
        if not self.DoubleTightHPSTau40TightIDPass_branch and "DoubleTightHPSTau40TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightHPSTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightHPSTau40TightIDPass")
        else:
            self.DoubleTightHPSTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightHPSTau40TightIDPass_value)

        #print "making DoubleTightTau35Pass"
        self.DoubleTightTau35Pass_branch = the_tree.GetBranch("DoubleTightTau35Pass")
        #if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass" not in self.complained:
        if not self.DoubleTightTau35Pass_branch and "DoubleTightTau35Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35Pass")
        else:
            self.DoubleTightTau35Pass_branch.SetAddress(<void*>&self.DoubleTightTau35Pass_value)

        #print "making DoubleTightTau35TightIDPass"
        self.DoubleTightTau35TightIDPass_branch = the_tree.GetBranch("DoubleTightTau35TightIDPass")
        #if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass" not in self.complained:
        if not self.DoubleTightTau35TightIDPass_branch and "DoubleTightTau35TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightTau35TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau35TightIDPass")
        else:
            self.DoubleTightTau35TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau35TightIDPass_value)

        #print "making DoubleTightTau40Pass"
        self.DoubleTightTau40Pass_branch = the_tree.GetBranch("DoubleTightTau40Pass")
        #if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass" not in self.complained:
        if not self.DoubleTightTau40Pass_branch and "DoubleTightTau40Pass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40Pass")
        else:
            self.DoubleTightTau40Pass_branch.SetAddress(<void*>&self.DoubleTightTau40Pass_value)

        #print "making DoubleTightTau40TightIDPass"
        self.DoubleTightTau40TightIDPass_branch = the_tree.GetBranch("DoubleTightTau40TightIDPass")
        #if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass" not in self.complained:
        if not self.DoubleTightTau40TightIDPass_branch and "DoubleTightTau40TightIDPass":
            warnings.warn( "MuTauTree: Expected branch DoubleTightTau40TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("DoubleTightTau40TightIDPass")
        else:
            self.DoubleTightTau40TightIDPass_branch.SetAddress(<void*>&self.DoubleTightTau40TightIDPass_value)

        #print "making Ele24LooseHPSTau30Pass"
        self.Ele24LooseHPSTau30Pass_branch = the_tree.GetBranch("Ele24LooseHPSTau30Pass")
        #if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass" not in self.complained:
        if not self.Ele24LooseHPSTau30Pass_branch and "Ele24LooseHPSTau30Pass":
            warnings.warn( "MuTauTree: Expected branch Ele24LooseHPSTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30Pass")
        else:
            self.Ele24LooseHPSTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30Pass_value)

        #print "making Ele24LooseHPSTau30TightIDPass"
        self.Ele24LooseHPSTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseHPSTau30TightIDPass")
        #if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseHPSTau30TightIDPass_branch and "Ele24LooseHPSTau30TightIDPass":
            warnings.warn( "MuTauTree: Expected branch Ele24LooseHPSTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseHPSTau30TightIDPass")
        else:
            self.Ele24LooseHPSTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseHPSTau30TightIDPass_value)

        #print "making Ele24LooseTau30Pass"
        self.Ele24LooseTau30Pass_branch = the_tree.GetBranch("Ele24LooseTau30Pass")
        #if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass" not in self.complained:
        if not self.Ele24LooseTau30Pass_branch and "Ele24LooseTau30Pass":
            warnings.warn( "MuTauTree: Expected branch Ele24LooseTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30Pass")
        else:
            self.Ele24LooseTau30Pass_branch.SetAddress(<void*>&self.Ele24LooseTau30Pass_value)

        #print "making Ele24LooseTau30TightIDPass"
        self.Ele24LooseTau30TightIDPass_branch = the_tree.GetBranch("Ele24LooseTau30TightIDPass")
        #if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass" not in self.complained:
        if not self.Ele24LooseTau30TightIDPass_branch and "Ele24LooseTau30TightIDPass":
            warnings.warn( "MuTauTree: Expected branch Ele24LooseTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele24LooseTau30TightIDPass")
        else:
            self.Ele24LooseTau30TightIDPass_branch.SetAddress(<void*>&self.Ele24LooseTau30TightIDPass_value)

        #print "making Ele27WPTightPass"
        self.Ele27WPTightPass_branch = the_tree.GetBranch("Ele27WPTightPass")
        #if not self.Ele27WPTightPass_branch and "Ele27WPTightPass" not in self.complained:
        if not self.Ele27WPTightPass_branch and "Ele27WPTightPass":
            warnings.warn( "MuTauTree: Expected branch Ele27WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele27WPTightPass")
        else:
            self.Ele27WPTightPass_branch.SetAddress(<void*>&self.Ele27WPTightPass_value)

        #print "making Ele32WPTightPass"
        self.Ele32WPTightPass_branch = the_tree.GetBranch("Ele32WPTightPass")
        #if not self.Ele32WPTightPass_branch and "Ele32WPTightPass" not in self.complained:
        if not self.Ele32WPTightPass_branch and "Ele32WPTightPass":
            warnings.warn( "MuTauTree: Expected branch Ele32WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele32WPTightPass")
        else:
            self.Ele32WPTightPass_branch.SetAddress(<void*>&self.Ele32WPTightPass_value)

        #print "making Ele35WPTightPass"
        self.Ele35WPTightPass_branch = the_tree.GetBranch("Ele35WPTightPass")
        #if not self.Ele35WPTightPass_branch and "Ele35WPTightPass" not in self.complained:
        if not self.Ele35WPTightPass_branch and "Ele35WPTightPass":
            warnings.warn( "MuTauTree: Expected branch Ele35WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele35WPTightPass")
        else:
            self.Ele35WPTightPass_branch.SetAddress(<void*>&self.Ele35WPTightPass_value)

        #print "making Ele38WPTightPass"
        self.Ele38WPTightPass_branch = the_tree.GetBranch("Ele38WPTightPass")
        #if not self.Ele38WPTightPass_branch and "Ele38WPTightPass" not in self.complained:
        if not self.Ele38WPTightPass_branch and "Ele38WPTightPass":
            warnings.warn( "MuTauTree: Expected branch Ele38WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele38WPTightPass")
        else:
            self.Ele38WPTightPass_branch.SetAddress(<void*>&self.Ele38WPTightPass_value)

        #print "making Ele40WPTightPass"
        self.Ele40WPTightPass_branch = the_tree.GetBranch("Ele40WPTightPass")
        #if not self.Ele40WPTightPass_branch and "Ele40WPTightPass" not in self.complained:
        if not self.Ele40WPTightPass_branch and "Ele40WPTightPass":
            warnings.warn( "MuTauTree: Expected branch Ele40WPTightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ele40WPTightPass")
        else:
            self.Ele40WPTightPass_branch.SetAddress(<void*>&self.Ele40WPTightPass_value)

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuTauTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuTauTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "MuTauTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "MuTauTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "MuTauTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "MuTauTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "MuTauTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "MuTauTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuTauTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuTauTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making IsoMu24Pass"
        self.IsoMu24Pass_branch = the_tree.GetBranch("IsoMu24Pass")
        #if not self.IsoMu24Pass_branch and "IsoMu24Pass" not in self.complained:
        if not self.IsoMu24Pass_branch and "IsoMu24Pass":
            warnings.warn( "MuTauTree: Expected branch IsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu24Pass")
        else:
            self.IsoMu24Pass_branch.SetAddress(<void*>&self.IsoMu24Pass_value)

        #print "making IsoMu27Pass"
        self.IsoMu27Pass_branch = the_tree.GetBranch("IsoMu27Pass")
        #if not self.IsoMu27Pass_branch and "IsoMu27Pass" not in self.complained:
        if not self.IsoMu27Pass_branch and "IsoMu27Pass":
            warnings.warn( "MuTauTree: Expected branch IsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("IsoMu27Pass")
        else:
            self.IsoMu27Pass_branch.SetAddress(<void*>&self.IsoMu27Pass_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuTauTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuTauTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuTauTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuTauTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuTauTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuTauTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuTauTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuTauTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making Mu20LooseHPSTau27Pass"
        self.Mu20LooseHPSTau27Pass_branch = the_tree.GetBranch("Mu20LooseHPSTau27Pass")
        #if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass" not in self.complained:
        if not self.Mu20LooseHPSTau27Pass_branch and "Mu20LooseHPSTau27Pass":
            warnings.warn( "MuTauTree: Expected branch Mu20LooseHPSTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27Pass")
        else:
            self.Mu20LooseHPSTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27Pass_value)

        #print "making Mu20LooseHPSTau27TightIDPass"
        self.Mu20LooseHPSTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseHPSTau27TightIDPass")
        #if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseHPSTau27TightIDPass_branch and "Mu20LooseHPSTau27TightIDPass":
            warnings.warn( "MuTauTree: Expected branch Mu20LooseHPSTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseHPSTau27TightIDPass")
        else:
            self.Mu20LooseHPSTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseHPSTau27TightIDPass_value)

        #print "making Mu20LooseTau27Pass"
        self.Mu20LooseTau27Pass_branch = the_tree.GetBranch("Mu20LooseTau27Pass")
        #if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass" not in self.complained:
        if not self.Mu20LooseTau27Pass_branch and "Mu20LooseTau27Pass":
            warnings.warn( "MuTauTree: Expected branch Mu20LooseTau27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27Pass")
        else:
            self.Mu20LooseTau27Pass_branch.SetAddress(<void*>&self.Mu20LooseTau27Pass_value)

        #print "making Mu20LooseTau27TightIDPass"
        self.Mu20LooseTau27TightIDPass_branch = the_tree.GetBranch("Mu20LooseTau27TightIDPass")
        #if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass" not in self.complained:
        if not self.Mu20LooseTau27TightIDPass_branch and "Mu20LooseTau27TightIDPass":
            warnings.warn( "MuTauTree: Expected branch Mu20LooseTau27TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu20LooseTau27TightIDPass")
        else:
            self.Mu20LooseTau27TightIDPass_branch.SetAddress(<void*>&self.Mu20LooseTau27TightIDPass_value)

        #print "making Mu50Pass"
        self.Mu50Pass_branch = the_tree.GetBranch("Mu50Pass")
        #if not self.Mu50Pass_branch and "Mu50Pass" not in self.complained:
        if not self.Mu50Pass_branch and "Mu50Pass":
            warnings.warn( "MuTauTree: Expected branch Mu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mu50Pass")
        else:
            self.Mu50Pass_branch.SetAddress(<void*>&self.Mu50Pass_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuTauTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuTauTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuTauTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "MuTauTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "MuTauTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "MuTauTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "MuTauTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "MuTauTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "MuTauTree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "MuTauTree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "MuTauTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "MuTauTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "MuTauTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "MuTauTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "MuTauTree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "MuTauTree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making Rivet_stage1p1_cat"
        self.Rivet_stage1p1_cat_branch = the_tree.GetBranch("Rivet_stage1p1_cat")
        #if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat" not in self.complained:
        if not self.Rivet_stage1p1_cat_branch and "Rivet_stage1p1_cat":
            warnings.warn( "MuTauTree: Expected branch Rivet_stage1p1_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1p1_cat")
        else:
            self.Rivet_stage1p1_cat_branch.SetAddress(<void*>&self.Rivet_stage1p1_cat_value)

        #print "making VBFDoubleLooseHPSTau20Pass"
        self.VBFDoubleLooseHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseHPSTau20Pass")
        #if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseHPSTau20Pass_branch and "VBFDoubleLooseHPSTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleLooseHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseHPSTau20Pass")
        else:
            self.VBFDoubleLooseHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseHPSTau20Pass_value)

        #print "making VBFDoubleLooseTau20Pass"
        self.VBFDoubleLooseTau20Pass_branch = the_tree.GetBranch("VBFDoubleLooseTau20Pass")
        #if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass" not in self.complained:
        if not self.VBFDoubleLooseTau20Pass_branch and "VBFDoubleLooseTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleLooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleLooseTau20Pass")
        else:
            self.VBFDoubleLooseTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleLooseTau20Pass_value)

        #print "making VBFDoubleMediumHPSTau20Pass"
        self.VBFDoubleMediumHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumHPSTau20Pass")
        #if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumHPSTau20Pass_branch and "VBFDoubleMediumHPSTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleMediumHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumHPSTau20Pass")
        else:
            self.VBFDoubleMediumHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumHPSTau20Pass_value)

        #print "making VBFDoubleMediumTau20Pass"
        self.VBFDoubleMediumTau20Pass_branch = the_tree.GetBranch("VBFDoubleMediumTau20Pass")
        #if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass" not in self.complained:
        if not self.VBFDoubleMediumTau20Pass_branch and "VBFDoubleMediumTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleMediumTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleMediumTau20Pass")
        else:
            self.VBFDoubleMediumTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleMediumTau20Pass_value)

        #print "making VBFDoubleTightHPSTau20Pass"
        self.VBFDoubleTightHPSTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightHPSTau20Pass")
        #if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass" not in self.complained:
        if not self.VBFDoubleTightHPSTau20Pass_branch and "VBFDoubleTightHPSTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleTightHPSTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightHPSTau20Pass")
        else:
            self.VBFDoubleTightHPSTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightHPSTau20Pass_value)

        #print "making VBFDoubleTightTau20Pass"
        self.VBFDoubleTightTau20Pass_branch = the_tree.GetBranch("VBFDoubleTightTau20Pass")
        #if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass" not in self.complained:
        if not self.VBFDoubleTightTau20Pass_branch and "VBFDoubleTightTau20Pass":
            warnings.warn( "MuTauTree: Expected branch VBFDoubleTightTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("VBFDoubleTightTau20Pass")
        else:
            self.VBFDoubleTightTau20Pass_branch.SetAddress(<void*>&self.VBFDoubleTightTau20Pass_value)

        #print "making bjetDeepCSVVeto20Loose_2016_DR0p5"
        self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch and "bjetDeepCSVVeto20Loose_2016_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Loose_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2017_DR0p5"
        self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch and "bjetDeepCSVVeto20Loose_2017_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Loose_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Loose_2018_DR0p5"
        self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Loose_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch and "bjetDeepCSVVeto20Loose_2018_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Loose_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Loose_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Loose_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Loose_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium"
        self.bjetDeepCSVVeto20Medium_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium")
        #if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_branch and "bjetDeepCSVVeto20Medium":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium")
        else:
            self.bjetDeepCSVVeto20Medium_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_branch and "bjetDeepCSVVeto20MediumWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_value)

        #print "making bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5"
        self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch and "bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20MediumWoNoisyJets_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0"
        self.bjetDeepCSVVeto20Medium_2016_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0_branch and "bjetDeepCSVVeto20Medium_2016_DR0":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2016_DR0p5"
        self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch and "bjetDeepCSVVeto20Medium_2016_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0"
        self.bjetDeepCSVVeto20Medium_2017_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0_branch and "bjetDeepCSVVeto20Medium_2017_DR0":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2017_DR0p5"
        self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch and "bjetDeepCSVVeto20Medium_2017_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0"
        self.bjetDeepCSVVeto20Medium_2018_DR0_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0_branch and "bjetDeepCSVVeto20Medium_2018_DR0":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0_value)

        #print "making bjetDeepCSVVeto20Medium_2018_DR0p5"
        self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Medium_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch and "bjetDeepCSVVeto20Medium_2018_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Medium_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Medium_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Medium_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Medium_2018_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2016_DR0p5"
        self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2016_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch and "bjetDeepCSVVeto20Tight_2016_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Tight_2016_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2016_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2016_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2016_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2017_DR0p5"
        self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2017_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch and "bjetDeepCSVVeto20Tight_2017_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Tight_2017_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2017_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2017_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2017_DR0p5_value)

        #print "making bjetDeepCSVVeto20Tight_2018_DR0p5"
        self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch = the_tree.GetBranch("bjetDeepCSVVeto20Tight_2018_DR0p5")
        #if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5" not in self.complained:
        if not self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch and "bjetDeepCSVVeto20Tight_2018_DR0p5":
            warnings.warn( "MuTauTree: Expected branch bjetDeepCSVVeto20Tight_2018_DR0p5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetDeepCSVVeto20Tight_2018_DR0p5")
        else:
            self.bjetDeepCSVVeto20Tight_2018_DR0p5_branch.SetAddress(<void*>&self.bjetDeepCSVVeto20Tight_2018_DR0p5_value)

        #print "making bweight_2016"
        self.bweight_2016_branch = the_tree.GetBranch("bweight_2016")
        #if not self.bweight_2016_branch and "bweight_2016" not in self.complained:
        if not self.bweight_2016_branch and "bweight_2016":
            warnings.warn( "MuTauTree: Expected branch bweight_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2016")
        else:
            self.bweight_2016_branch.SetAddress(<void*>&self.bweight_2016_value)

        #print "making bweight_2017"
        self.bweight_2017_branch = the_tree.GetBranch("bweight_2017")
        #if not self.bweight_2017_branch and "bweight_2017" not in self.complained:
        if not self.bweight_2017_branch and "bweight_2017":
            warnings.warn( "MuTauTree: Expected branch bweight_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2017")
        else:
            self.bweight_2017_branch.SetAddress(<void*>&self.bweight_2017_value)

        #print "making bweight_2018"
        self.bweight_2018_branch = the_tree.GetBranch("bweight_2018")
        #if not self.bweight_2018_branch and "bweight_2018" not in self.complained:
        if not self.bweight_2018_branch and "bweight_2018":
            warnings.warn( "MuTauTree: Expected branch bweight_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight_2018")
        else:
            self.bweight_2018_branch.SetAddress(<void*>&self.bweight_2018_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuTauTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuTauTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimu9ele9Pass"
        self.dimu9ele9Pass_branch = the_tree.GetBranch("dimu9ele9Pass")
        #if not self.dimu9ele9Pass_branch and "dimu9ele9Pass" not in self.complained:
        if not self.dimu9ele9Pass_branch and "dimu9ele9Pass":
            warnings.warn( "MuTauTree: Expected branch dimu9ele9Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimu9ele9Pass")
        else:
            self.dimu9ele9Pass_branch.SetAddress(<void*>&self.dimu9ele9Pass_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuTauTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleE25Pass"
        self.doubleE25Pass_branch = the_tree.GetBranch("doubleE25Pass")
        #if not self.doubleE25Pass_branch and "doubleE25Pass" not in self.complained:
        if not self.doubleE25Pass_branch and "doubleE25Pass":
            warnings.warn( "MuTauTree: Expected branch doubleE25Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE25Pass")
        else:
            self.doubleE25Pass_branch.SetAddress(<void*>&self.doubleE25Pass_value)

        #print "making doubleE33Pass"
        self.doubleE33Pass_branch = the_tree.GetBranch("doubleE33Pass")
        #if not self.doubleE33Pass_branch and "doubleE33Pass" not in self.complained:
        if not self.doubleE33Pass_branch and "doubleE33Pass":
            warnings.warn( "MuTauTree: Expected branch doubleE33Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE33Pass")
        else:
            self.doubleE33Pass_branch.SetAddress(<void*>&self.doubleE33Pass_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuTauTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleMuDZminMass3p8Pass"
        self.doubleMuDZminMass3p8Pass_branch = the_tree.GetBranch("doubleMuDZminMass3p8Pass")
        #if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass" not in self.complained:
        if not self.doubleMuDZminMass3p8Pass_branch and "doubleMuDZminMass3p8Pass":
            warnings.warn( "MuTauTree: Expected branch doubleMuDZminMass3p8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass3p8Pass")
        else:
            self.doubleMuDZminMass3p8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass3p8Pass_value)

        #print "making doubleMuDZminMass8Pass"
        self.doubleMuDZminMass8Pass_branch = the_tree.GetBranch("doubleMuDZminMass8Pass")
        #if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass" not in self.complained:
        if not self.doubleMuDZminMass8Pass_branch and "doubleMuDZminMass8Pass":
            warnings.warn( "MuTauTree: Expected branch doubleMuDZminMass8Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuDZminMass8Pass")
        else:
            self.doubleMuDZminMass8Pass_branch.SetAddress(<void*>&self.doubleMuDZminMass8Pass_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "MuTauTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "MuTauTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTauCmbIso35RegPass"
        self.doubleTauCmbIso35RegPass_branch = the_tree.GetBranch("doubleTauCmbIso35RegPass")
        #if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass" not in self.complained:
        if not self.doubleTauCmbIso35RegPass_branch and "doubleTauCmbIso35RegPass":
            warnings.warn( "MuTauTree: Expected branch doubleTauCmbIso35RegPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTauCmbIso35RegPass")
        else:
            self.doubleTauCmbIso35RegPass_branch.SetAddress(<void*>&self.doubleTauCmbIso35RegPass_value)

        #print "making eVetoHZZPt5"
        self.eVetoHZZPt5_branch = the_tree.GetBranch("eVetoHZZPt5")
        #if not self.eVetoHZZPt5_branch and "eVetoHZZPt5" not in self.complained:
        if not self.eVetoHZZPt5_branch and "eVetoHZZPt5":
            warnings.warn( "MuTauTree: Expected branch eVetoHZZPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoHZZPt5")
        else:
            self.eVetoHZZPt5_branch.SetAddress(<void*>&self.eVetoHZZPt5_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuTauTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuTauTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuTauTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuTauTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuTauTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuTauTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuTauTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuTauTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuTauTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuTauTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuTauTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuTauTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "MuTauTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuTauTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuTauTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "MuTauTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "MuTauTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuTauTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuTauTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making isembed"
        self.isembed_branch = the_tree.GetBranch("isembed")
        #if not self.isembed_branch and "isembed" not in self.complained:
        if not self.isembed_branch and "isembed":
            warnings.warn( "MuTauTree: Expected branch isembed does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isembed")
        else:
            self.isembed_branch.SetAddress(<void*>&self.isembed_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuTauTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1csvWoNoisyJets"
        self.j1csvWoNoisyJets_branch = the_tree.GetBranch("j1csvWoNoisyJets")
        #if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets" not in self.complained:
        if not self.j1csvWoNoisyJets_branch and "j1csvWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j1csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csvWoNoisyJets")
        else:
            self.j1csvWoNoisyJets_branch.SetAddress(<void*>&self.j1csvWoNoisyJets_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuTauTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1etaWoNoisyJets"
        self.j1etaWoNoisyJets_branch = the_tree.GetBranch("j1etaWoNoisyJets")
        #if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets" not in self.complained:
        if not self.j1etaWoNoisyJets_branch and "j1etaWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j1etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1etaWoNoisyJets")
        else:
            self.j1etaWoNoisyJets_branch.SetAddress(<void*>&self.j1etaWoNoisyJets_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuTauTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1hadronflavorWoNoisyJets"
        self.j1hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j1hadronflavorWoNoisyJets")
        #if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets" not in self.complained:
        if not self.j1hadronflavorWoNoisyJets_branch and "j1hadronflavorWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j1hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavorWoNoisyJets")
        else:
            self.j1hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j1hadronflavorWoNoisyJets_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuTauTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1phiWoNoisyJets"
        self.j1phiWoNoisyJets_branch = the_tree.GetBranch("j1phiWoNoisyJets")
        #if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets" not in self.complained:
        if not self.j1phiWoNoisyJets_branch and "j1phiWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j1phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phiWoNoisyJets")
        else:
            self.j1phiWoNoisyJets_branch.SetAddress(<void*>&self.j1phiWoNoisyJets_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuTauTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptWoNoisyJets"
        self.j1ptWoNoisyJets_branch = the_tree.GetBranch("j1ptWoNoisyJets")
        #if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets" not in self.complained:
        if not self.j1ptWoNoisyJets_branch and "j1ptWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets")
        else:
            self.j1ptWoNoisyJets_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_value)

        #print "making j1ptWoNoisyJets_JetEC2Down"
        self.j1ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Down")
        #if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Down_branch and "j1ptWoNoisyJets_JetEC2Down":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Down")
        else:
            self.j1ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Down_value)

        #print "making j1ptWoNoisyJets_JetEC2Up"
        self.j1ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEC2Up")
        #if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEC2Up_branch and "j1ptWoNoisyJets_JetEC2Up":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEC2Up")
        else:
            self.j1ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEC2Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Down"
        self.j1ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Down")
        #if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Down_branch and "j1ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to3Up"
        self.j1ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to3Up")
        #if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to3Up_branch and "j1ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Down"
        self.j1ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Down")
        #if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Down_branch and "j1ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta0to5Up"
        self.j1ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta0to5Up")
        #if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta0to5Up_branch and "j1ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Down"
        self.j1ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Down")
        #if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Down_branch and "j1ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j1ptWoNoisyJets_JetEta3to5Up"
        self.j1ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetEta3to5Up")
        #if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j1ptWoNoisyJets_JetEta3to5Up_branch and "j1ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j1ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalDown"
        self.j1ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalDown_branch and "j1ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeBalUp"
        self.j1ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeBalUp_branch and "j1ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleDown"
        self.j1ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleDown_branch and "j1ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j1ptWoNoisyJets_JetRelativeSampleUp"
        self.j1ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j1ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j1ptWoNoisyJets_JetRelativeSampleUp_branch and "j1ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch j1ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j1ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j1ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuTauTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2csvWoNoisyJets"
        self.j2csvWoNoisyJets_branch = the_tree.GetBranch("j2csvWoNoisyJets")
        #if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets" not in self.complained:
        if not self.j2csvWoNoisyJets_branch and "j2csvWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j2csvWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csvWoNoisyJets")
        else:
            self.j2csvWoNoisyJets_branch.SetAddress(<void*>&self.j2csvWoNoisyJets_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuTauTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2etaWoNoisyJets"
        self.j2etaWoNoisyJets_branch = the_tree.GetBranch("j2etaWoNoisyJets")
        #if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets" not in self.complained:
        if not self.j2etaWoNoisyJets_branch and "j2etaWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j2etaWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2etaWoNoisyJets")
        else:
            self.j2etaWoNoisyJets_branch.SetAddress(<void*>&self.j2etaWoNoisyJets_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuTauTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2hadronflavorWoNoisyJets"
        self.j2hadronflavorWoNoisyJets_branch = the_tree.GetBranch("j2hadronflavorWoNoisyJets")
        #if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets" not in self.complained:
        if not self.j2hadronflavorWoNoisyJets_branch and "j2hadronflavorWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j2hadronflavorWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavorWoNoisyJets")
        else:
            self.j2hadronflavorWoNoisyJets_branch.SetAddress(<void*>&self.j2hadronflavorWoNoisyJets_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuTauTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2phiWoNoisyJets"
        self.j2phiWoNoisyJets_branch = the_tree.GetBranch("j2phiWoNoisyJets")
        #if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets" not in self.complained:
        if not self.j2phiWoNoisyJets_branch and "j2phiWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j2phiWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phiWoNoisyJets")
        else:
            self.j2phiWoNoisyJets_branch.SetAddress(<void*>&self.j2phiWoNoisyJets_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuTauTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptWoNoisyJets"
        self.j2ptWoNoisyJets_branch = the_tree.GetBranch("j2ptWoNoisyJets")
        #if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets" not in self.complained:
        if not self.j2ptWoNoisyJets_branch and "j2ptWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets")
        else:
            self.j2ptWoNoisyJets_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_value)

        #print "making j2ptWoNoisyJets_JetEC2Down"
        self.j2ptWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Down")
        #if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Down_branch and "j2ptWoNoisyJets_JetEC2Down":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Down")
        else:
            self.j2ptWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Down_value)

        #print "making j2ptWoNoisyJets_JetEC2Up"
        self.j2ptWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEC2Up")
        #if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEC2Up_branch and "j2ptWoNoisyJets_JetEC2Up":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEC2Up")
        else:
            self.j2ptWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEC2Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Down"
        self.j2ptWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Down")
        #if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Down_branch and "j2ptWoNoisyJets_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to3Up"
        self.j2ptWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to3Up")
        #if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to3Up_branch and "j2ptWoNoisyJets_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to3Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to3Up_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Down"
        self.j2ptWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Down")
        #if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Down_branch and "j2ptWoNoisyJets_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta0to5Up"
        self.j2ptWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta0to5Up")
        #if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta0to5Up_branch and "j2ptWoNoisyJets_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta0to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta0to5Up_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Down"
        self.j2ptWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Down")
        #if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Down_branch and "j2ptWoNoisyJets_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Down")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Down_value)

        #print "making j2ptWoNoisyJets_JetEta3to5Up"
        self.j2ptWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetEta3to5Up")
        #if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.j2ptWoNoisyJets_JetEta3to5Up_branch and "j2ptWoNoisyJets_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetEta3to5Up")
        else:
            self.j2ptWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetEta3to5Up_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalDown"
        self.j2ptWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalDown")
        #if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalDown_branch and "j2ptWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeBalUp"
        self.j2ptWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeBalUp")
        #if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeBalUp_branch and "j2ptWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeBalUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeBalUp_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleDown"
        self.j2ptWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleDown")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleDown_branch and "j2ptWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleDown")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleDown_value)

        #print "making j2ptWoNoisyJets_JetRelativeSampleUp"
        self.j2ptWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("j2ptWoNoisyJets_JetRelativeSampleUp")
        #if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.j2ptWoNoisyJets_JetRelativeSampleUp_branch and "j2ptWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch j2ptWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptWoNoisyJets_JetRelativeSampleUp")
        else:
            self.j2ptWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.j2ptWoNoisyJets_JetRelativeSampleUp_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuTauTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_2016"
        self.jb1eta_2016_branch = the_tree.GetBranch("jb1eta_2016")
        #if not self.jb1eta_2016_branch and "jb1eta_2016" not in self.complained:
        if not self.jb1eta_2016_branch and "jb1eta_2016":
            warnings.warn( "MuTauTree: Expected branch jb1eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2016")
        else:
            self.jb1eta_2016_branch.SetAddress(<void*>&self.jb1eta_2016_value)

        #print "making jb1eta_2017"
        self.jb1eta_2017_branch = the_tree.GetBranch("jb1eta_2017")
        #if not self.jb1eta_2017_branch and "jb1eta_2017" not in self.complained:
        if not self.jb1eta_2017_branch and "jb1eta_2017":
            warnings.warn( "MuTauTree: Expected branch jb1eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2017")
        else:
            self.jb1eta_2017_branch.SetAddress(<void*>&self.jb1eta_2017_value)

        #print "making jb1eta_2018"
        self.jb1eta_2018_branch = the_tree.GetBranch("jb1eta_2018")
        #if not self.jb1eta_2018_branch and "jb1eta_2018" not in self.complained:
        if not self.jb1eta_2018_branch and "jb1eta_2018":
            warnings.warn( "MuTauTree: Expected branch jb1eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_2018")
        else:
            self.jb1eta_2018_branch.SetAddress(<void*>&self.jb1eta_2018_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_2016"
        self.jb1hadronflavor_2016_branch = the_tree.GetBranch("jb1hadronflavor_2016")
        #if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016" not in self.complained:
        if not self.jb1hadronflavor_2016_branch and "jb1hadronflavor_2016":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2016")
        else:
            self.jb1hadronflavor_2016_branch.SetAddress(<void*>&self.jb1hadronflavor_2016_value)

        #print "making jb1hadronflavor_2017"
        self.jb1hadronflavor_2017_branch = the_tree.GetBranch("jb1hadronflavor_2017")
        #if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017" not in self.complained:
        if not self.jb1hadronflavor_2017_branch and "jb1hadronflavor_2017":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2017")
        else:
            self.jb1hadronflavor_2017_branch.SetAddress(<void*>&self.jb1hadronflavor_2017_value)

        #print "making jb1hadronflavor_2018"
        self.jb1hadronflavor_2018_branch = the_tree.GetBranch("jb1hadronflavor_2018")
        #if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018" not in self.complained:
        if not self.jb1hadronflavor_2018_branch and "jb1hadronflavor_2018":
            warnings.warn( "MuTauTree: Expected branch jb1hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_2018")
        else:
            self.jb1hadronflavor_2018_branch.SetAddress(<void*>&self.jb1hadronflavor_2018_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuTauTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_2016"
        self.jb1phi_2016_branch = the_tree.GetBranch("jb1phi_2016")
        #if not self.jb1phi_2016_branch and "jb1phi_2016" not in self.complained:
        if not self.jb1phi_2016_branch and "jb1phi_2016":
            warnings.warn( "MuTauTree: Expected branch jb1phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2016")
        else:
            self.jb1phi_2016_branch.SetAddress(<void*>&self.jb1phi_2016_value)

        #print "making jb1phi_2017"
        self.jb1phi_2017_branch = the_tree.GetBranch("jb1phi_2017")
        #if not self.jb1phi_2017_branch and "jb1phi_2017" not in self.complained:
        if not self.jb1phi_2017_branch and "jb1phi_2017":
            warnings.warn( "MuTauTree: Expected branch jb1phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2017")
        else:
            self.jb1phi_2017_branch.SetAddress(<void*>&self.jb1phi_2017_value)

        #print "making jb1phi_2018"
        self.jb1phi_2018_branch = the_tree.GetBranch("jb1phi_2018")
        #if not self.jb1phi_2018_branch and "jb1phi_2018" not in self.complained:
        if not self.jb1phi_2018_branch and "jb1phi_2018":
            warnings.warn( "MuTauTree: Expected branch jb1phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_2018")
        else:
            self.jb1phi_2018_branch.SetAddress(<void*>&self.jb1phi_2018_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuTauTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1pt_2016"
        self.jb1pt_2016_branch = the_tree.GetBranch("jb1pt_2016")
        #if not self.jb1pt_2016_branch and "jb1pt_2016" not in self.complained:
        if not self.jb1pt_2016_branch and "jb1pt_2016":
            warnings.warn( "MuTauTree: Expected branch jb1pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2016")
        else:
            self.jb1pt_2016_branch.SetAddress(<void*>&self.jb1pt_2016_value)

        #print "making jb1pt_2017"
        self.jb1pt_2017_branch = the_tree.GetBranch("jb1pt_2017")
        #if not self.jb1pt_2017_branch and "jb1pt_2017" not in self.complained:
        if not self.jb1pt_2017_branch and "jb1pt_2017":
            warnings.warn( "MuTauTree: Expected branch jb1pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2017")
        else:
            self.jb1pt_2017_branch.SetAddress(<void*>&self.jb1pt_2017_value)

        #print "making jb1pt_2018"
        self.jb1pt_2018_branch = the_tree.GetBranch("jb1pt_2018")
        #if not self.jb1pt_2018_branch and "jb1pt_2018" not in self.complained:
        if not self.jb1pt_2018_branch and "jb1pt_2018":
            warnings.warn( "MuTauTree: Expected branch jb1pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_2018")
        else:
            self.jb1pt_2018_branch.SetAddress(<void*>&self.jb1pt_2018_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuTauTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_2016"
        self.jb2eta_2016_branch = the_tree.GetBranch("jb2eta_2016")
        #if not self.jb2eta_2016_branch and "jb2eta_2016" not in self.complained:
        if not self.jb2eta_2016_branch and "jb2eta_2016":
            warnings.warn( "MuTauTree: Expected branch jb2eta_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2016")
        else:
            self.jb2eta_2016_branch.SetAddress(<void*>&self.jb2eta_2016_value)

        #print "making jb2eta_2017"
        self.jb2eta_2017_branch = the_tree.GetBranch("jb2eta_2017")
        #if not self.jb2eta_2017_branch and "jb2eta_2017" not in self.complained:
        if not self.jb2eta_2017_branch and "jb2eta_2017":
            warnings.warn( "MuTauTree: Expected branch jb2eta_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2017")
        else:
            self.jb2eta_2017_branch.SetAddress(<void*>&self.jb2eta_2017_value)

        #print "making jb2eta_2018"
        self.jb2eta_2018_branch = the_tree.GetBranch("jb2eta_2018")
        #if not self.jb2eta_2018_branch and "jb2eta_2018" not in self.complained:
        if not self.jb2eta_2018_branch and "jb2eta_2018":
            warnings.warn( "MuTauTree: Expected branch jb2eta_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_2018")
        else:
            self.jb2eta_2018_branch.SetAddress(<void*>&self.jb2eta_2018_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_2016"
        self.jb2hadronflavor_2016_branch = the_tree.GetBranch("jb2hadronflavor_2016")
        #if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016" not in self.complained:
        if not self.jb2hadronflavor_2016_branch and "jb2hadronflavor_2016":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2016")
        else:
            self.jb2hadronflavor_2016_branch.SetAddress(<void*>&self.jb2hadronflavor_2016_value)

        #print "making jb2hadronflavor_2017"
        self.jb2hadronflavor_2017_branch = the_tree.GetBranch("jb2hadronflavor_2017")
        #if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017" not in self.complained:
        if not self.jb2hadronflavor_2017_branch and "jb2hadronflavor_2017":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2017")
        else:
            self.jb2hadronflavor_2017_branch.SetAddress(<void*>&self.jb2hadronflavor_2017_value)

        #print "making jb2hadronflavor_2018"
        self.jb2hadronflavor_2018_branch = the_tree.GetBranch("jb2hadronflavor_2018")
        #if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018" not in self.complained:
        if not self.jb2hadronflavor_2018_branch and "jb2hadronflavor_2018":
            warnings.warn( "MuTauTree: Expected branch jb2hadronflavor_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_2018")
        else:
            self.jb2hadronflavor_2018_branch.SetAddress(<void*>&self.jb2hadronflavor_2018_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuTauTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_2016"
        self.jb2phi_2016_branch = the_tree.GetBranch("jb2phi_2016")
        #if not self.jb2phi_2016_branch and "jb2phi_2016" not in self.complained:
        if not self.jb2phi_2016_branch and "jb2phi_2016":
            warnings.warn( "MuTauTree: Expected branch jb2phi_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2016")
        else:
            self.jb2phi_2016_branch.SetAddress(<void*>&self.jb2phi_2016_value)

        #print "making jb2phi_2017"
        self.jb2phi_2017_branch = the_tree.GetBranch("jb2phi_2017")
        #if not self.jb2phi_2017_branch and "jb2phi_2017" not in self.complained:
        if not self.jb2phi_2017_branch and "jb2phi_2017":
            warnings.warn( "MuTauTree: Expected branch jb2phi_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2017")
        else:
            self.jb2phi_2017_branch.SetAddress(<void*>&self.jb2phi_2017_value)

        #print "making jb2phi_2018"
        self.jb2phi_2018_branch = the_tree.GetBranch("jb2phi_2018")
        #if not self.jb2phi_2018_branch and "jb2phi_2018" not in self.complained:
        if not self.jb2phi_2018_branch and "jb2phi_2018":
            warnings.warn( "MuTauTree: Expected branch jb2phi_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_2018")
        else:
            self.jb2phi_2018_branch.SetAddress(<void*>&self.jb2phi_2018_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuTauTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2pt_2016"
        self.jb2pt_2016_branch = the_tree.GetBranch("jb2pt_2016")
        #if not self.jb2pt_2016_branch and "jb2pt_2016" not in self.complained:
        if not self.jb2pt_2016_branch and "jb2pt_2016":
            warnings.warn( "MuTauTree: Expected branch jb2pt_2016 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2016")
        else:
            self.jb2pt_2016_branch.SetAddress(<void*>&self.jb2pt_2016_value)

        #print "making jb2pt_2017"
        self.jb2pt_2017_branch = the_tree.GetBranch("jb2pt_2017")
        #if not self.jb2pt_2017_branch and "jb2pt_2017" not in self.complained:
        if not self.jb2pt_2017_branch and "jb2pt_2017":
            warnings.warn( "MuTauTree: Expected branch jb2pt_2017 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2017")
        else:
            self.jb2pt_2017_branch.SetAddress(<void*>&self.jb2pt_2017_value)

        #print "making jb2pt_2018"
        self.jb2pt_2018_branch = the_tree.GetBranch("jb2pt_2018")
        #if not self.jb2pt_2018_branch and "jb2pt_2018" not in self.complained:
        if not self.jb2pt_2018_branch and "jb2pt_2018":
            warnings.warn( "MuTauTree: Expected branch jb2pt_2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_2018")
        else:
            self.jb2pt_2018_branch.SetAddress(<void*>&self.jb2pt_2018_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuTauTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20WoNoisyJets"
        self.jetVeto20WoNoisyJets_branch = the_tree.GetBranch("jetVeto20WoNoisyJets")
        #if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets" not in self.complained:
        if not self.jetVeto20WoNoisyJets_branch and "jetVeto20WoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch jetVeto20WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20WoNoisyJets")
        else:
            self.jetVeto20WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto20WoNoisyJets_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuTauTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30WoNoisyJets"
        self.jetVeto30WoNoisyJets_branch = the_tree.GetBranch("jetVeto30WoNoisyJets")
        #if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets" not in self.complained:
        if not self.jetVeto30WoNoisyJets_branch and "jetVeto30WoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets")
        else:
            self.jetVeto30WoNoisyJets_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteScaleDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteScaleDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteScaleDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteScaleDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteScaleUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteScaleUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteScaleUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteScaleUp_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteStatDown"
        self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteStatDown")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteStatDown")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteStatDown_value)

        #print "making jetVeto30WoNoisyJets_JetAbsoluteStatUp"
        self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetAbsoluteStatUp")
        #if not self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch and "jetVeto30WoNoisyJets_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetAbsoluteStatUp")
        else:
            self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetAbsoluteStatUp_value)

        #print "making jetVeto30WoNoisyJets_JetClosureDown"
        self.jetVeto30WoNoisyJets_JetClosureDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetClosureDown")
        #if not self.jetVeto30WoNoisyJets_JetClosureDown_branch and "jetVeto30WoNoisyJets_JetClosureDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetClosureDown_branch and "jetVeto30WoNoisyJets_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetClosureDown")
        else:
            self.jetVeto30WoNoisyJets_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetClosureDown_value)

        #print "making jetVeto30WoNoisyJets_JetClosureUp"
        self.jetVeto30WoNoisyJets_JetClosureUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetClosureUp")
        #if not self.jetVeto30WoNoisyJets_JetClosureUp_branch and "jetVeto30WoNoisyJets_JetClosureUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetClosureUp_branch and "jetVeto30WoNoisyJets_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetClosureUp")
        else:
            self.jetVeto30WoNoisyJets_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetClosureUp_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Down"
        self.jetVeto30WoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Down_branch and "jetVeto30WoNoisyJets_JetEC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetEC2Up"
        self.jetVeto30WoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEC2Up_branch and "jetVeto30WoNoisyJets_JetEC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetEnDown"
        self.jetVeto30WoNoisyJets_JetEnDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnDown")
        #if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnDown_branch and "jetVeto30WoNoisyJets_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnDown")
        else:
            self.jetVeto30WoNoisyJets_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnDown_value)

        #print "making jetVeto30WoNoisyJets_JetEnUp"
        self.jetVeto30WoNoisyJets_JetEnUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEnUp")
        #if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEnUp_branch and "jetVeto30WoNoisyJets_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEnUp")
        else:
            self.jetVeto30WoNoisyJets_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEnUp_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Down"
        self.jetVeto30WoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Down_branch and "jetVeto30WoNoisyJets_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to3Up"
        self.jetVeto30WoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to3Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to3Up_branch and "jetVeto30WoNoisyJets_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to3Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to3Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Down"
        self.jetVeto30WoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Down_branch and "jetVeto30WoNoisyJets_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta0to5Up"
        self.jetVeto30WoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta0to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta0to5Up_branch and "jetVeto30WoNoisyJets_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta0to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta0to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Down"
        self.jetVeto30WoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Down")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Down_branch and "jetVeto30WoNoisyJets_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Down")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Down_value)

        #print "making jetVeto30WoNoisyJets_JetEta3to5Up"
        self.jetVeto30WoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetEta3to5Up")
        #if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetEta3to5Up_branch and "jetVeto30WoNoisyJets_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetEta3to5Up")
        else:
            self.jetVeto30WoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetEta3to5Up_value)

        #print "making jetVeto30WoNoisyJets_JetFlavorQCDDown"
        self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFlavorQCDDown")
        #if not self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch and "jetVeto30WoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch and "jetVeto30WoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFlavorQCDDown")
        else:
            self.jetVeto30WoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFlavorQCDDown_value)

        #print "making jetVeto30WoNoisyJets_JetFlavorQCDUp"
        self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFlavorQCDUp")
        #if not self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch and "jetVeto30WoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch and "jetVeto30WoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFlavorQCDUp")
        else:
            self.jetVeto30WoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFlavorQCDUp_value)

        #print "making jetVeto30WoNoisyJets_JetFragmentationDown"
        self.jetVeto30WoNoisyJets_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFragmentationDown")
        #if not self.jetVeto30WoNoisyJets_JetFragmentationDown_branch and "jetVeto30WoNoisyJets_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFragmentationDown_branch and "jetVeto30WoNoisyJets_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFragmentationDown")
        else:
            self.jetVeto30WoNoisyJets_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFragmentationDown_value)

        #print "making jetVeto30WoNoisyJets_JetFragmentationUp"
        self.jetVeto30WoNoisyJets_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetFragmentationUp")
        #if not self.jetVeto30WoNoisyJets_JetFragmentationUp_branch and "jetVeto30WoNoisyJets_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetFragmentationUp_branch and "jetVeto30WoNoisyJets_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetFragmentationUp")
        else:
            self.jetVeto30WoNoisyJets_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetFragmentationUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpDataMCDown"
        self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpDataMCDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpDataMCDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpDataMCDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpDataMCUp"
        self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpDataMCUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch and "jetVeto30WoNoisyJets_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpDataMCUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpDataMCUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtBBDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtBBDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtBBDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtBBDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtBBUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtBBUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtBBUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtBBUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC1Down"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC1Down")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC1Up"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC1Up")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC2Down"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtEC2Up"
        self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch and "jetVeto30WoNoisyJets_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtHFDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtHFDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtHFUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtHFUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtRefDown"
        self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtRefDown")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtRefDown")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtRefDown_value)

        #print "making jetVeto30WoNoisyJets_JetPileUpPtRefUp"
        self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetPileUpPtRefUp")
        #if not self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch and "jetVeto30WoNoisyJets_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetPileUpPtRefUp")
        else:
            self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetPileUpPtRefUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalDown"
        self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch and "jetVeto30WoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch and "jetVeto30WoNoisyJets_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeBalUp"
        self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeBalUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch and "jetVeto30WoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch and "jetVeto30WoNoisyJets_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeBalUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeBalUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeFSRDown"
        self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeFSRDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeFSRDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeFSRDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeFSRUp"
        self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeFSRUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeFSRUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeFSRUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC1Down"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC1Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC1Up"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC1Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC2Down"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC2Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJEREC2Up"
        self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJEREC2Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch and "jetVeto30WoNoisyJets_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJEREC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJEREC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJERHFDown"
        self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJERHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJERHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJERHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeJERHFUp"
        self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeJERHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeJERHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeJERHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtBBDown"
        self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtBBDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch and "jetVeto30WoNoisyJets_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch and "jetVeto30WoNoisyJets_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtBBDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtBBDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtBBUp"
        self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtBBUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch and "jetVeto30WoNoisyJets_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch and "jetVeto30WoNoisyJets_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtBBUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtBBUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC1Down"
        self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC1Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC1Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC1Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC1Up"
        self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC1Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC1Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC1Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC2Down"
        self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC2Down")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC2Down")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC2Down_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtEC2Up"
        self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtEC2Up")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch and "jetVeto30WoNoisyJets_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtEC2Up")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtEC2Up_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtHFDown"
        self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch and "jetVeto30WoNoisyJets_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch and "jetVeto30WoNoisyJets_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativePtHFUp"
        self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativePtHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch and "jetVeto30WoNoisyJets_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch and "jetVeto30WoNoisyJets_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativePtHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativePtHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleDown"
        self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch and "jetVeto30WoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeSampleUp"
        self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch and "jetVeto30WoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeSampleUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeSampleUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatECDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatECDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatECDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatECDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatECUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatECUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatECUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatECUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatFSRDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatFSRDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatFSRDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatFSRDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatFSRUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatFSRUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatFSRUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatFSRUp_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatHFDown"
        self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatHFDown")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatHFDown")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatHFDown_value)

        #print "making jetVeto30WoNoisyJets_JetRelativeStatHFUp"
        self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetRelativeStatHFUp")
        #if not self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch and "jetVeto30WoNoisyJets_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetRelativeStatHFUp")
        else:
            self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetRelativeStatHFUp_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionECALDown"
        self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionECALDown")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionECALDown")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionECALDown_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionECALUp"
        self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionECALUp")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionECALUp")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionECALUp_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionHCALDown"
        self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionHCALDown")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionHCALDown")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionHCALDown_value)

        #print "making jetVeto30WoNoisyJets_JetSinglePionHCALUp"
        self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetSinglePionHCALUp")
        #if not self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch and "jetVeto30WoNoisyJets_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetSinglePionHCALUp")
        else:
            self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetSinglePionHCALUp_value)

        #print "making jetVeto30WoNoisyJets_JetTimePtEtaDown"
        self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTimePtEtaDown")
        #if not self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch and "jetVeto30WoNoisyJets_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch and "jetVeto30WoNoisyJets_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTimePtEtaDown")
        else:
            self.jetVeto30WoNoisyJets_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTimePtEtaDown_value)

        #print "making jetVeto30WoNoisyJets_JetTimePtEtaUp"
        self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTimePtEtaUp")
        #if not self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch and "jetVeto30WoNoisyJets_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch and "jetVeto30WoNoisyJets_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTimePtEtaUp")
        else:
            self.jetVeto30WoNoisyJets_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTimePtEtaUp_value)

        #print "making jetVeto30WoNoisyJets_JetTotalDown"
        self.jetVeto30WoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalDown")
        #if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalDown_branch and "jetVeto30WoNoisyJets_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalDown")
        else:
            self.jetVeto30WoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalDown_value)

        #print "making jetVeto30WoNoisyJets_JetTotalUp"
        self.jetVeto30WoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("jetVeto30WoNoisyJets_JetTotalUp")
        #if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp" not in self.complained:
        if not self.jetVeto30WoNoisyJets_JetTotalUp_branch and "jetVeto30WoNoisyJets_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30WoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30WoNoisyJets_JetTotalUp")
        else:
            self.jetVeto30WoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30WoNoisyJets_JetTotalUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuTauTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making mBestTrackType"
        self.mBestTrackType_branch = the_tree.GetBranch("mBestTrackType")
        #if not self.mBestTrackType_branch and "mBestTrackType" not in self.complained:
        if not self.mBestTrackType_branch and "mBestTrackType":
            warnings.warn( "MuTauTree: Expected branch mBestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mBestTrackType")
        else:
            self.mBestTrackType_branch.SetAddress(<void*>&self.mBestTrackType_value)

        #print "making mCharge"
        self.mCharge_branch = the_tree.GetBranch("mCharge")
        #if not self.mCharge_branch and "mCharge" not in self.complained:
        if not self.mCharge_branch and "mCharge":
            warnings.warn( "MuTauTree: Expected branch mCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCharge")
        else:
            self.mCharge_branch.SetAddress(<void*>&self.mCharge_value)

        #print "making mChi2LocalPosition"
        self.mChi2LocalPosition_branch = the_tree.GetBranch("mChi2LocalPosition")
        #if not self.mChi2LocalPosition_branch and "mChi2LocalPosition" not in self.complained:
        if not self.mChi2LocalPosition_branch and "mChi2LocalPosition":
            warnings.warn( "MuTauTree: Expected branch mChi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mChi2LocalPosition")
        else:
            self.mChi2LocalPosition_branch.SetAddress(<void*>&self.mChi2LocalPosition_value)

        #print "making mComesFromHiggs"
        self.mComesFromHiggs_branch = the_tree.GetBranch("mComesFromHiggs")
        #if not self.mComesFromHiggs_branch and "mComesFromHiggs" not in self.complained:
        if not self.mComesFromHiggs_branch and "mComesFromHiggs":
            warnings.warn( "MuTauTree: Expected branch mComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mComesFromHiggs")
        else:
            self.mComesFromHiggs_branch.SetAddress(<void*>&self.mComesFromHiggs_value)

        #print "making mCutBasedIdGlobalHighPt"
        self.mCutBasedIdGlobalHighPt_branch = the_tree.GetBranch("mCutBasedIdGlobalHighPt")
        #if not self.mCutBasedIdGlobalHighPt_branch and "mCutBasedIdGlobalHighPt" not in self.complained:
        if not self.mCutBasedIdGlobalHighPt_branch and "mCutBasedIdGlobalHighPt":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdGlobalHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdGlobalHighPt")
        else:
            self.mCutBasedIdGlobalHighPt_branch.SetAddress(<void*>&self.mCutBasedIdGlobalHighPt_value)

        #print "making mCutBasedIdLoose"
        self.mCutBasedIdLoose_branch = the_tree.GetBranch("mCutBasedIdLoose")
        #if not self.mCutBasedIdLoose_branch and "mCutBasedIdLoose" not in self.complained:
        if not self.mCutBasedIdLoose_branch and "mCutBasedIdLoose":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdLoose")
        else:
            self.mCutBasedIdLoose_branch.SetAddress(<void*>&self.mCutBasedIdLoose_value)

        #print "making mCutBasedIdMedium"
        self.mCutBasedIdMedium_branch = the_tree.GetBranch("mCutBasedIdMedium")
        #if not self.mCutBasedIdMedium_branch and "mCutBasedIdMedium" not in self.complained:
        if not self.mCutBasedIdMedium_branch and "mCutBasedIdMedium":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdMedium")
        else:
            self.mCutBasedIdMedium_branch.SetAddress(<void*>&self.mCutBasedIdMedium_value)

        #print "making mCutBasedIdMediumPrompt"
        self.mCutBasedIdMediumPrompt_branch = the_tree.GetBranch("mCutBasedIdMediumPrompt")
        #if not self.mCutBasedIdMediumPrompt_branch and "mCutBasedIdMediumPrompt" not in self.complained:
        if not self.mCutBasedIdMediumPrompt_branch and "mCutBasedIdMediumPrompt":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdMediumPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdMediumPrompt")
        else:
            self.mCutBasedIdMediumPrompt_branch.SetAddress(<void*>&self.mCutBasedIdMediumPrompt_value)

        #print "making mCutBasedIdTight"
        self.mCutBasedIdTight_branch = the_tree.GetBranch("mCutBasedIdTight")
        #if not self.mCutBasedIdTight_branch and "mCutBasedIdTight" not in self.complained:
        if not self.mCutBasedIdTight_branch and "mCutBasedIdTight":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdTight")
        else:
            self.mCutBasedIdTight_branch.SetAddress(<void*>&self.mCutBasedIdTight_value)

        #print "making mCutBasedIdTrkHighPt"
        self.mCutBasedIdTrkHighPt_branch = the_tree.GetBranch("mCutBasedIdTrkHighPt")
        #if not self.mCutBasedIdTrkHighPt_branch and "mCutBasedIdTrkHighPt" not in self.complained:
        if not self.mCutBasedIdTrkHighPt_branch and "mCutBasedIdTrkHighPt":
            warnings.warn( "MuTauTree: Expected branch mCutBasedIdTrkHighPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mCutBasedIdTrkHighPt")
        else:
            self.mCutBasedIdTrkHighPt_branch.SetAddress(<void*>&self.mCutBasedIdTrkHighPt_value)

        #print "making mEcalIsoDR03"
        self.mEcalIsoDR03_branch = the_tree.GetBranch("mEcalIsoDR03")
        #if not self.mEcalIsoDR03_branch and "mEcalIsoDR03" not in self.complained:
        if not self.mEcalIsoDR03_branch and "mEcalIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mEcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEcalIsoDR03")
        else:
            self.mEcalIsoDR03_branch.SetAddress(<void*>&self.mEcalIsoDR03_value)

        #print "making mEffectiveArea2011"
        self.mEffectiveArea2011_branch = the_tree.GetBranch("mEffectiveArea2011")
        #if not self.mEffectiveArea2011_branch and "mEffectiveArea2011" not in self.complained:
        if not self.mEffectiveArea2011_branch and "mEffectiveArea2011":
            warnings.warn( "MuTauTree: Expected branch mEffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEffectiveArea2011")
        else:
            self.mEffectiveArea2011_branch.SetAddress(<void*>&self.mEffectiveArea2011_value)

        #print "making mEffectiveArea2012"
        self.mEffectiveArea2012_branch = the_tree.GetBranch("mEffectiveArea2012")
        #if not self.mEffectiveArea2012_branch and "mEffectiveArea2012" not in self.complained:
        if not self.mEffectiveArea2012_branch and "mEffectiveArea2012":
            warnings.warn( "MuTauTree: Expected branch mEffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEffectiveArea2012")
        else:
            self.mEffectiveArea2012_branch.SetAddress(<void*>&self.mEffectiveArea2012_value)

        #print "making mEta"
        self.mEta_branch = the_tree.GetBranch("mEta")
        #if not self.mEta_branch and "mEta" not in self.complained:
        if not self.mEta_branch and "mEta":
            warnings.warn( "MuTauTree: Expected branch mEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta")
        else:
            self.mEta_branch.SetAddress(<void*>&self.mEta_value)

        #print "making mEta_MuonEnDown"
        self.mEta_MuonEnDown_branch = the_tree.GetBranch("mEta_MuonEnDown")
        #if not self.mEta_MuonEnDown_branch and "mEta_MuonEnDown" not in self.complained:
        if not self.mEta_MuonEnDown_branch and "mEta_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mEta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta_MuonEnDown")
        else:
            self.mEta_MuonEnDown_branch.SetAddress(<void*>&self.mEta_MuonEnDown_value)

        #print "making mEta_MuonEnUp"
        self.mEta_MuonEnUp_branch = the_tree.GetBranch("mEta_MuonEnUp")
        #if not self.mEta_MuonEnUp_branch and "mEta_MuonEnUp" not in self.complained:
        if not self.mEta_MuonEnUp_branch and "mEta_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mEta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mEta_MuonEnUp")
        else:
            self.mEta_MuonEnUp_branch.SetAddress(<void*>&self.mEta_MuonEnUp_value)

        #print "making mGenCharge"
        self.mGenCharge_branch = the_tree.GetBranch("mGenCharge")
        #if not self.mGenCharge_branch and "mGenCharge" not in self.complained:
        if not self.mGenCharge_branch and "mGenCharge":
            warnings.warn( "MuTauTree: Expected branch mGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenCharge")
        else:
            self.mGenCharge_branch.SetAddress(<void*>&self.mGenCharge_value)

        #print "making mGenDirectPromptTauDecayFinalState"
        self.mGenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("mGenDirectPromptTauDecayFinalState")
        #if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.mGenDirectPromptTauDecayFinalState_branch and "mGenDirectPromptTauDecayFinalState":
            warnings.warn( "MuTauTree: Expected branch mGenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenDirectPromptTauDecayFinalState")
        else:
            self.mGenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.mGenDirectPromptTauDecayFinalState_value)

        #print "making mGenEnergy"
        self.mGenEnergy_branch = the_tree.GetBranch("mGenEnergy")
        #if not self.mGenEnergy_branch and "mGenEnergy" not in self.complained:
        if not self.mGenEnergy_branch and "mGenEnergy":
            warnings.warn( "MuTauTree: Expected branch mGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEnergy")
        else:
            self.mGenEnergy_branch.SetAddress(<void*>&self.mGenEnergy_value)

        #print "making mGenEta"
        self.mGenEta_branch = the_tree.GetBranch("mGenEta")
        #if not self.mGenEta_branch and "mGenEta" not in self.complained:
        if not self.mGenEta_branch and "mGenEta":
            warnings.warn( "MuTauTree: Expected branch mGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenEta")
        else:
            self.mGenEta_branch.SetAddress(<void*>&self.mGenEta_value)

        #print "making mGenIsPrompt"
        self.mGenIsPrompt_branch = the_tree.GetBranch("mGenIsPrompt")
        #if not self.mGenIsPrompt_branch and "mGenIsPrompt" not in self.complained:
        if not self.mGenIsPrompt_branch and "mGenIsPrompt":
            warnings.warn( "MuTauTree: Expected branch mGenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenIsPrompt")
        else:
            self.mGenIsPrompt_branch.SetAddress(<void*>&self.mGenIsPrompt_value)

        #print "making mGenMotherPdgId"
        self.mGenMotherPdgId_branch = the_tree.GetBranch("mGenMotherPdgId")
        #if not self.mGenMotherPdgId_branch and "mGenMotherPdgId" not in self.complained:
        if not self.mGenMotherPdgId_branch and "mGenMotherPdgId":
            warnings.warn( "MuTauTree: Expected branch mGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenMotherPdgId")
        else:
            self.mGenMotherPdgId_branch.SetAddress(<void*>&self.mGenMotherPdgId_value)

        #print "making mGenParticle"
        self.mGenParticle_branch = the_tree.GetBranch("mGenParticle")
        #if not self.mGenParticle_branch and "mGenParticle" not in self.complained:
        if not self.mGenParticle_branch and "mGenParticle":
            warnings.warn( "MuTauTree: Expected branch mGenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenParticle")
        else:
            self.mGenParticle_branch.SetAddress(<void*>&self.mGenParticle_value)

        #print "making mGenPdgId"
        self.mGenPdgId_branch = the_tree.GetBranch("mGenPdgId")
        #if not self.mGenPdgId_branch and "mGenPdgId" not in self.complained:
        if not self.mGenPdgId_branch and "mGenPdgId":
            warnings.warn( "MuTauTree: Expected branch mGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPdgId")
        else:
            self.mGenPdgId_branch.SetAddress(<void*>&self.mGenPdgId_value)

        #print "making mGenPhi"
        self.mGenPhi_branch = the_tree.GetBranch("mGenPhi")
        #if not self.mGenPhi_branch and "mGenPhi" not in self.complained:
        if not self.mGenPhi_branch and "mGenPhi":
            warnings.warn( "MuTauTree: Expected branch mGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPhi")
        else:
            self.mGenPhi_branch.SetAddress(<void*>&self.mGenPhi_value)

        #print "making mGenPrompt"
        self.mGenPrompt_branch = the_tree.GetBranch("mGenPrompt")
        #if not self.mGenPrompt_branch and "mGenPrompt" not in self.complained:
        if not self.mGenPrompt_branch and "mGenPrompt":
            warnings.warn( "MuTauTree: Expected branch mGenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPrompt")
        else:
            self.mGenPrompt_branch.SetAddress(<void*>&self.mGenPrompt_value)

        #print "making mGenPromptFinalState"
        self.mGenPromptFinalState_branch = the_tree.GetBranch("mGenPromptFinalState")
        #if not self.mGenPromptFinalState_branch and "mGenPromptFinalState" not in self.complained:
        if not self.mGenPromptFinalState_branch and "mGenPromptFinalState":
            warnings.warn( "MuTauTree: Expected branch mGenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptFinalState")
        else:
            self.mGenPromptFinalState_branch.SetAddress(<void*>&self.mGenPromptFinalState_value)

        #print "making mGenPromptTauDecay"
        self.mGenPromptTauDecay_branch = the_tree.GetBranch("mGenPromptTauDecay")
        #if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay" not in self.complained:
        if not self.mGenPromptTauDecay_branch and "mGenPromptTauDecay":
            warnings.warn( "MuTauTree: Expected branch mGenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPromptTauDecay")
        else:
            self.mGenPromptTauDecay_branch.SetAddress(<void*>&self.mGenPromptTauDecay_value)

        #print "making mGenPt"
        self.mGenPt_branch = the_tree.GetBranch("mGenPt")
        #if not self.mGenPt_branch and "mGenPt" not in self.complained:
        if not self.mGenPt_branch and "mGenPt":
            warnings.warn( "MuTauTree: Expected branch mGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenPt")
        else:
            self.mGenPt_branch.SetAddress(<void*>&self.mGenPt_value)

        #print "making mGenTauDecay"
        self.mGenTauDecay_branch = the_tree.GetBranch("mGenTauDecay")
        #if not self.mGenTauDecay_branch and "mGenTauDecay" not in self.complained:
        if not self.mGenTauDecay_branch and "mGenTauDecay":
            warnings.warn( "MuTauTree: Expected branch mGenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenTauDecay")
        else:
            self.mGenTauDecay_branch.SetAddress(<void*>&self.mGenTauDecay_value)

        #print "making mGenVZ"
        self.mGenVZ_branch = the_tree.GetBranch("mGenVZ")
        #if not self.mGenVZ_branch and "mGenVZ" not in self.complained:
        if not self.mGenVZ_branch and "mGenVZ":
            warnings.warn( "MuTauTree: Expected branch mGenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVZ")
        else:
            self.mGenVZ_branch.SetAddress(<void*>&self.mGenVZ_value)

        #print "making mGenVtxPVMatch"
        self.mGenVtxPVMatch_branch = the_tree.GetBranch("mGenVtxPVMatch")
        #if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch" not in self.complained:
        if not self.mGenVtxPVMatch_branch and "mGenVtxPVMatch":
            warnings.warn( "MuTauTree: Expected branch mGenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mGenVtxPVMatch")
        else:
            self.mGenVtxPVMatch_branch.SetAddress(<void*>&self.mGenVtxPVMatch_value)

        #print "making mHcalIsoDR03"
        self.mHcalIsoDR03_branch = the_tree.GetBranch("mHcalIsoDR03")
        #if not self.mHcalIsoDR03_branch and "mHcalIsoDR03" not in self.complained:
        if not self.mHcalIsoDR03_branch and "mHcalIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mHcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mHcalIsoDR03")
        else:
            self.mHcalIsoDR03_branch.SetAddress(<void*>&self.mHcalIsoDR03_value)

        #print "making mIP3D"
        self.mIP3D_branch = the_tree.GetBranch("mIP3D")
        #if not self.mIP3D_branch and "mIP3D" not in self.complained:
        if not self.mIP3D_branch and "mIP3D":
            warnings.warn( "MuTauTree: Expected branch mIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3D")
        else:
            self.mIP3D_branch.SetAddress(<void*>&self.mIP3D_value)

        #print "making mIP3DErr"
        self.mIP3DErr_branch = the_tree.GetBranch("mIP3DErr")
        #if not self.mIP3DErr_branch and "mIP3DErr" not in self.complained:
        if not self.mIP3DErr_branch and "mIP3DErr":
            warnings.warn( "MuTauTree: Expected branch mIP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIP3DErr")
        else:
            self.mIP3DErr_branch.SetAddress(<void*>&self.mIP3DErr_value)

        #print "making mIsGlobal"
        self.mIsGlobal_branch = the_tree.GetBranch("mIsGlobal")
        #if not self.mIsGlobal_branch and "mIsGlobal" not in self.complained:
        if not self.mIsGlobal_branch and "mIsGlobal":
            warnings.warn( "MuTauTree: Expected branch mIsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsGlobal")
        else:
            self.mIsGlobal_branch.SetAddress(<void*>&self.mIsGlobal_value)

        #print "making mIsPFMuon"
        self.mIsPFMuon_branch = the_tree.GetBranch("mIsPFMuon")
        #if not self.mIsPFMuon_branch and "mIsPFMuon" not in self.complained:
        if not self.mIsPFMuon_branch and "mIsPFMuon":
            warnings.warn( "MuTauTree: Expected branch mIsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsPFMuon")
        else:
            self.mIsPFMuon_branch.SetAddress(<void*>&self.mIsPFMuon_value)

        #print "making mIsTracker"
        self.mIsTracker_branch = the_tree.GetBranch("mIsTracker")
        #if not self.mIsTracker_branch and "mIsTracker" not in self.complained:
        if not self.mIsTracker_branch and "mIsTracker":
            warnings.warn( "MuTauTree: Expected branch mIsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsTracker")
        else:
            self.mIsTracker_branch.SetAddress(<void*>&self.mIsTracker_value)

        #print "making mIsoDB03"
        self.mIsoDB03_branch = the_tree.GetBranch("mIsoDB03")
        #if not self.mIsoDB03_branch and "mIsoDB03" not in self.complained:
        if not self.mIsoDB03_branch and "mIsoDB03":
            warnings.warn( "MuTauTree: Expected branch mIsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB03")
        else:
            self.mIsoDB03_branch.SetAddress(<void*>&self.mIsoDB03_value)

        #print "making mIsoDB04"
        self.mIsoDB04_branch = the_tree.GetBranch("mIsoDB04")
        #if not self.mIsoDB04_branch and "mIsoDB04" not in self.complained:
        if not self.mIsoDB04_branch and "mIsoDB04":
            warnings.warn( "MuTauTree: Expected branch mIsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mIsoDB04")
        else:
            self.mIsoDB04_branch.SetAddress(<void*>&self.mIsoDB04_value)

        #print "making mJetArea"
        self.mJetArea_branch = the_tree.GetBranch("mJetArea")
        #if not self.mJetArea_branch and "mJetArea" not in self.complained:
        if not self.mJetArea_branch and "mJetArea":
            warnings.warn( "MuTauTree: Expected branch mJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetArea")
        else:
            self.mJetArea_branch.SetAddress(<void*>&self.mJetArea_value)

        #print "making mJetBtag"
        self.mJetBtag_branch = the_tree.GetBranch("mJetBtag")
        #if not self.mJetBtag_branch and "mJetBtag" not in self.complained:
        if not self.mJetBtag_branch and "mJetBtag":
            warnings.warn( "MuTauTree: Expected branch mJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetBtag")
        else:
            self.mJetBtag_branch.SetAddress(<void*>&self.mJetBtag_value)

        #print "making mJetDR"
        self.mJetDR_branch = the_tree.GetBranch("mJetDR")
        #if not self.mJetDR_branch and "mJetDR" not in self.complained:
        if not self.mJetDR_branch and "mJetDR":
            warnings.warn( "MuTauTree: Expected branch mJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetDR")
        else:
            self.mJetDR_branch.SetAddress(<void*>&self.mJetDR_value)

        #print "making mJetEtaEtaMoment"
        self.mJetEtaEtaMoment_branch = the_tree.GetBranch("mJetEtaEtaMoment")
        #if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment" not in self.complained:
        if not self.mJetEtaEtaMoment_branch and "mJetEtaEtaMoment":
            warnings.warn( "MuTauTree: Expected branch mJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaEtaMoment")
        else:
            self.mJetEtaEtaMoment_branch.SetAddress(<void*>&self.mJetEtaEtaMoment_value)

        #print "making mJetEtaPhiMoment"
        self.mJetEtaPhiMoment_branch = the_tree.GetBranch("mJetEtaPhiMoment")
        #if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment" not in self.complained:
        if not self.mJetEtaPhiMoment_branch and "mJetEtaPhiMoment":
            warnings.warn( "MuTauTree: Expected branch mJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiMoment")
        else:
            self.mJetEtaPhiMoment_branch.SetAddress(<void*>&self.mJetEtaPhiMoment_value)

        #print "making mJetEtaPhiSpread"
        self.mJetEtaPhiSpread_branch = the_tree.GetBranch("mJetEtaPhiSpread")
        #if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread" not in self.complained:
        if not self.mJetEtaPhiSpread_branch and "mJetEtaPhiSpread":
            warnings.warn( "MuTauTree: Expected branch mJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetEtaPhiSpread")
        else:
            self.mJetEtaPhiSpread_branch.SetAddress(<void*>&self.mJetEtaPhiSpread_value)

        #print "making mJetHadronFlavour"
        self.mJetHadronFlavour_branch = the_tree.GetBranch("mJetHadronFlavour")
        #if not self.mJetHadronFlavour_branch and "mJetHadronFlavour" not in self.complained:
        if not self.mJetHadronFlavour_branch and "mJetHadronFlavour":
            warnings.warn( "MuTauTree: Expected branch mJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetHadronFlavour")
        else:
            self.mJetHadronFlavour_branch.SetAddress(<void*>&self.mJetHadronFlavour_value)

        #print "making mJetPFCISVBtag"
        self.mJetPFCISVBtag_branch = the_tree.GetBranch("mJetPFCISVBtag")
        #if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag" not in self.complained:
        if not self.mJetPFCISVBtag_branch and "mJetPFCISVBtag":
            warnings.warn( "MuTauTree: Expected branch mJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPFCISVBtag")
        else:
            self.mJetPFCISVBtag_branch.SetAddress(<void*>&self.mJetPFCISVBtag_value)

        #print "making mJetPartonFlavour"
        self.mJetPartonFlavour_branch = the_tree.GetBranch("mJetPartonFlavour")
        #if not self.mJetPartonFlavour_branch and "mJetPartonFlavour" not in self.complained:
        if not self.mJetPartonFlavour_branch and "mJetPartonFlavour":
            warnings.warn( "MuTauTree: Expected branch mJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPartonFlavour")
        else:
            self.mJetPartonFlavour_branch.SetAddress(<void*>&self.mJetPartonFlavour_value)

        #print "making mJetPhiPhiMoment"
        self.mJetPhiPhiMoment_branch = the_tree.GetBranch("mJetPhiPhiMoment")
        #if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment" not in self.complained:
        if not self.mJetPhiPhiMoment_branch and "mJetPhiPhiMoment":
            warnings.warn( "MuTauTree: Expected branch mJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPhiPhiMoment")
        else:
            self.mJetPhiPhiMoment_branch.SetAddress(<void*>&self.mJetPhiPhiMoment_value)

        #print "making mJetPt"
        self.mJetPt_branch = the_tree.GetBranch("mJetPt")
        #if not self.mJetPt_branch and "mJetPt" not in self.complained:
        if not self.mJetPt_branch and "mJetPt":
            warnings.warn( "MuTauTree: Expected branch mJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mJetPt")
        else:
            self.mJetPt_branch.SetAddress(<void*>&self.mJetPt_value)

        #print "making mLowestMll"
        self.mLowestMll_branch = the_tree.GetBranch("mLowestMll")
        #if not self.mLowestMll_branch and "mLowestMll" not in self.complained:
        if not self.mLowestMll_branch and "mLowestMll":
            warnings.warn( "MuTauTree: Expected branch mLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mLowestMll")
        else:
            self.mLowestMll_branch.SetAddress(<void*>&self.mLowestMll_value)

        #print "making mMass"
        self.mMass_branch = the_tree.GetBranch("mMass")
        #if not self.mMass_branch and "mMass" not in self.complained:
        if not self.mMass_branch and "mMass":
            warnings.warn( "MuTauTree: Expected branch mMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMass")
        else:
            self.mMass_branch.SetAddress(<void*>&self.mMass_value)

        #print "making mMatchedStations"
        self.mMatchedStations_branch = the_tree.GetBranch("mMatchedStations")
        #if not self.mMatchedStations_branch and "mMatchedStations" not in self.complained:
        if not self.mMatchedStations_branch and "mMatchedStations":
            warnings.warn( "MuTauTree: Expected branch mMatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchedStations")
        else:
            self.mMatchedStations_branch.SetAddress(<void*>&self.mMatchedStations_value)

        #print "making mMatchesIsoMu19Tau20Filter"
        self.mMatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20Filter")
        #if not self.mMatchesIsoMu19Tau20Filter_branch and "mMatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.mMatchesIsoMu19Tau20Filter_branch and "mMatchesIsoMu19Tau20Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20Filter")
        else:
            self.mMatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20Filter_value)

        #print "making mMatchesIsoMu19Tau20Path"
        self.mMatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20Path")
        #if not self.mMatchesIsoMu19Tau20Path_branch and "mMatchesIsoMu19Tau20Path" not in self.complained:
        if not self.mMatchesIsoMu19Tau20Path_branch and "mMatchesIsoMu19Tau20Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20Path")
        else:
            self.mMatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20Path_value)

        #print "making mMatchesIsoMu19Tau20SingleL1Filter"
        self.mMatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20SingleL1Filter")
        #if not self.mMatchesIsoMu19Tau20SingleL1Filter_branch and "mMatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.mMatchesIsoMu19Tau20SingleL1Filter_branch and "mMatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.mMatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making mMatchesIsoMu19Tau20SingleL1Path"
        self.mMatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("mMatchesIsoMu19Tau20SingleL1Path")
        #if not self.mMatchesIsoMu19Tau20SingleL1Path_branch and "mMatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.mMatchesIsoMu19Tau20SingleL1Path_branch and "mMatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu19Tau20SingleL1Path")
        else:
            self.mMatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.mMatchesIsoMu19Tau20SingleL1Path_value)

        #print "making mMatchesIsoMu20HPSTau27Filter"
        self.mMatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("mMatchesIsoMu20HPSTau27Filter")
        #if not self.mMatchesIsoMu20HPSTau27Filter_branch and "mMatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.mMatchesIsoMu20HPSTau27Filter_branch and "mMatchesIsoMu20HPSTau27Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20HPSTau27Filter")
        else:
            self.mMatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu20HPSTau27Filter_value)

        #print "making mMatchesIsoMu20HPSTau27Path"
        self.mMatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("mMatchesIsoMu20HPSTau27Path")
        #if not self.mMatchesIsoMu20HPSTau27Path_branch and "mMatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.mMatchesIsoMu20HPSTau27Path_branch and "mMatchesIsoMu20HPSTau27Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20HPSTau27Path")
        else:
            self.mMatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu20HPSTau27Path_value)

        #print "making mMatchesIsoMu20Tau27Filter"
        self.mMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("mMatchesIsoMu20Tau27Filter")
        #if not self.mMatchesIsoMu20Tau27Filter_branch and "mMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.mMatchesIsoMu20Tau27Filter_branch and "mMatchesIsoMu20Tau27Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20Tau27Filter")
        else:
            self.mMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu20Tau27Filter_value)

        #print "making mMatchesIsoMu20Tau27Path"
        self.mMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("mMatchesIsoMu20Tau27Path")
        #if not self.mMatchesIsoMu20Tau27Path_branch and "mMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.mMatchesIsoMu20Tau27Path_branch and "mMatchesIsoMu20Tau27Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu20Tau27Path")
        else:
            self.mMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu20Tau27Path_value)

        #print "making mMatchesIsoMu22Filter"
        self.mMatchesIsoMu22Filter_branch = the_tree.GetBranch("mMatchesIsoMu22Filter")
        #if not self.mMatchesIsoMu22Filter_branch and "mMatchesIsoMu22Filter" not in self.complained:
        if not self.mMatchesIsoMu22Filter_branch and "mMatchesIsoMu22Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22Filter")
        else:
            self.mMatchesIsoMu22Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu22Filter_value)

        #print "making mMatchesIsoMu22Path"
        self.mMatchesIsoMu22Path_branch = the_tree.GetBranch("mMatchesIsoMu22Path")
        #if not self.mMatchesIsoMu22Path_branch and "mMatchesIsoMu22Path" not in self.complained:
        if not self.mMatchesIsoMu22Path_branch and "mMatchesIsoMu22Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22Path")
        else:
            self.mMatchesIsoMu22Path_branch.SetAddress(<void*>&self.mMatchesIsoMu22Path_value)

        #print "making mMatchesIsoMu22eta2p1Filter"
        self.mMatchesIsoMu22eta2p1Filter_branch = the_tree.GetBranch("mMatchesIsoMu22eta2p1Filter")
        #if not self.mMatchesIsoMu22eta2p1Filter_branch and "mMatchesIsoMu22eta2p1Filter" not in self.complained:
        if not self.mMatchesIsoMu22eta2p1Filter_branch and "mMatchesIsoMu22eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22eta2p1Filter")
        else:
            self.mMatchesIsoMu22eta2p1Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu22eta2p1Filter_value)

        #print "making mMatchesIsoMu22eta2p1Path"
        self.mMatchesIsoMu22eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoMu22eta2p1Path")
        #if not self.mMatchesIsoMu22eta2p1Path_branch and "mMatchesIsoMu22eta2p1Path" not in self.complained:
        if not self.mMatchesIsoMu22eta2p1Path_branch and "mMatchesIsoMu22eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu22eta2p1Path")
        else:
            self.mMatchesIsoMu22eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoMu22eta2p1Path_value)

        #print "making mMatchesIsoMu24Filter"
        self.mMatchesIsoMu24Filter_branch = the_tree.GetBranch("mMatchesIsoMu24Filter")
        #if not self.mMatchesIsoMu24Filter_branch and "mMatchesIsoMu24Filter" not in self.complained:
        if not self.mMatchesIsoMu24Filter_branch and "mMatchesIsoMu24Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu24Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24Filter")
        else:
            self.mMatchesIsoMu24Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu24Filter_value)

        #print "making mMatchesIsoMu24Path"
        self.mMatchesIsoMu24Path_branch = the_tree.GetBranch("mMatchesIsoMu24Path")
        #if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path" not in self.complained:
        if not self.mMatchesIsoMu24Path_branch and "mMatchesIsoMu24Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu24Path")
        else:
            self.mMatchesIsoMu24Path_branch.SetAddress(<void*>&self.mMatchesIsoMu24Path_value)

        #print "making mMatchesIsoMu27Filter"
        self.mMatchesIsoMu27Filter_branch = the_tree.GetBranch("mMatchesIsoMu27Filter")
        #if not self.mMatchesIsoMu27Filter_branch and "mMatchesIsoMu27Filter" not in self.complained:
        if not self.mMatchesIsoMu27Filter_branch and "mMatchesIsoMu27Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu27Filter")
        else:
            self.mMatchesIsoMu27Filter_branch.SetAddress(<void*>&self.mMatchesIsoMu27Filter_value)

        #print "making mMatchesIsoMu27Path"
        self.mMatchesIsoMu27Path_branch = the_tree.GetBranch("mMatchesIsoMu27Path")
        #if not self.mMatchesIsoMu27Path_branch and "mMatchesIsoMu27Path" not in self.complained:
        if not self.mMatchesIsoMu27Path_branch and "mMatchesIsoMu27Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoMu27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoMu27Path")
        else:
            self.mMatchesIsoMu27Path_branch.SetAddress(<void*>&self.mMatchesIsoMu27Path_value)

        #print "making mMatchesIsoTkMu22Filter"
        self.mMatchesIsoTkMu22Filter_branch = the_tree.GetBranch("mMatchesIsoTkMu22Filter")
        #if not self.mMatchesIsoTkMu22Filter_branch and "mMatchesIsoTkMu22Filter" not in self.complained:
        if not self.mMatchesIsoTkMu22Filter_branch and "mMatchesIsoTkMu22Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22Filter")
        else:
            self.mMatchesIsoTkMu22Filter_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22Filter_value)

        #print "making mMatchesIsoTkMu22Path"
        self.mMatchesIsoTkMu22Path_branch = the_tree.GetBranch("mMatchesIsoTkMu22Path")
        #if not self.mMatchesIsoTkMu22Path_branch and "mMatchesIsoTkMu22Path" not in self.complained:
        if not self.mMatchesIsoTkMu22Path_branch and "mMatchesIsoTkMu22Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22Path")
        else:
            self.mMatchesIsoTkMu22Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22Path_value)

        #print "making mMatchesIsoTkMu22eta2p1Filter"
        self.mMatchesIsoTkMu22eta2p1Filter_branch = the_tree.GetBranch("mMatchesIsoTkMu22eta2p1Filter")
        #if not self.mMatchesIsoTkMu22eta2p1Filter_branch and "mMatchesIsoTkMu22eta2p1Filter" not in self.complained:
        if not self.mMatchesIsoTkMu22eta2p1Filter_branch and "mMatchesIsoTkMu22eta2p1Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22eta2p1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22eta2p1Filter")
        else:
            self.mMatchesIsoTkMu22eta2p1Filter_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22eta2p1Filter_value)

        #print "making mMatchesIsoTkMu22eta2p1Path"
        self.mMatchesIsoTkMu22eta2p1Path_branch = the_tree.GetBranch("mMatchesIsoTkMu22eta2p1Path")
        #if not self.mMatchesIsoTkMu22eta2p1Path_branch and "mMatchesIsoTkMu22eta2p1Path" not in self.complained:
        if not self.mMatchesIsoTkMu22eta2p1Path_branch and "mMatchesIsoTkMu22eta2p1Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesIsoTkMu22eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesIsoTkMu22eta2p1Path")
        else:
            self.mMatchesIsoTkMu22eta2p1Path_branch.SetAddress(<void*>&self.mMatchesIsoTkMu22eta2p1Path_value)

        #print "making mMatchesMu23e12DZFilter"
        self.mMatchesMu23e12DZFilter_branch = the_tree.GetBranch("mMatchesMu23e12DZFilter")
        #if not self.mMatchesMu23e12DZFilter_branch and "mMatchesMu23e12DZFilter" not in self.complained:
        if not self.mMatchesMu23e12DZFilter_branch and "mMatchesMu23e12DZFilter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu23e12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12DZFilter")
        else:
            self.mMatchesMu23e12DZFilter_branch.SetAddress(<void*>&self.mMatchesMu23e12DZFilter_value)

        #print "making mMatchesMu23e12DZPath"
        self.mMatchesMu23e12DZPath_branch = the_tree.GetBranch("mMatchesMu23e12DZPath")
        #if not self.mMatchesMu23e12DZPath_branch and "mMatchesMu23e12DZPath" not in self.complained:
        if not self.mMatchesMu23e12DZPath_branch and "mMatchesMu23e12DZPath":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu23e12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12DZPath")
        else:
            self.mMatchesMu23e12DZPath_branch.SetAddress(<void*>&self.mMatchesMu23e12DZPath_value)

        #print "making mMatchesMu23e12Filter"
        self.mMatchesMu23e12Filter_branch = the_tree.GetBranch("mMatchesMu23e12Filter")
        #if not self.mMatchesMu23e12Filter_branch and "mMatchesMu23e12Filter" not in self.complained:
        if not self.mMatchesMu23e12Filter_branch and "mMatchesMu23e12Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu23e12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12Filter")
        else:
            self.mMatchesMu23e12Filter_branch.SetAddress(<void*>&self.mMatchesMu23e12Filter_value)

        #print "making mMatchesMu23e12Path"
        self.mMatchesMu23e12Path_branch = the_tree.GetBranch("mMatchesMu23e12Path")
        #if not self.mMatchesMu23e12Path_branch and "mMatchesMu23e12Path" not in self.complained:
        if not self.mMatchesMu23e12Path_branch and "mMatchesMu23e12Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu23e12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu23e12Path")
        else:
            self.mMatchesMu23e12Path_branch.SetAddress(<void*>&self.mMatchesMu23e12Path_value)

        #print "making mMatchesMu8e23DZFilter"
        self.mMatchesMu8e23DZFilter_branch = the_tree.GetBranch("mMatchesMu8e23DZFilter")
        #if not self.mMatchesMu8e23DZFilter_branch and "mMatchesMu8e23DZFilter" not in self.complained:
        if not self.mMatchesMu8e23DZFilter_branch and "mMatchesMu8e23DZFilter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu8e23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23DZFilter")
        else:
            self.mMatchesMu8e23DZFilter_branch.SetAddress(<void*>&self.mMatchesMu8e23DZFilter_value)

        #print "making mMatchesMu8e23DZPath"
        self.mMatchesMu8e23DZPath_branch = the_tree.GetBranch("mMatchesMu8e23DZPath")
        #if not self.mMatchesMu8e23DZPath_branch and "mMatchesMu8e23DZPath" not in self.complained:
        if not self.mMatchesMu8e23DZPath_branch and "mMatchesMu8e23DZPath":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu8e23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23DZPath")
        else:
            self.mMatchesMu8e23DZPath_branch.SetAddress(<void*>&self.mMatchesMu8e23DZPath_value)

        #print "making mMatchesMu8e23Filter"
        self.mMatchesMu8e23Filter_branch = the_tree.GetBranch("mMatchesMu8e23Filter")
        #if not self.mMatchesMu8e23Filter_branch and "mMatchesMu8e23Filter" not in self.complained:
        if not self.mMatchesMu8e23Filter_branch and "mMatchesMu8e23Filter":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu8e23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23Filter")
        else:
            self.mMatchesMu8e23Filter_branch.SetAddress(<void*>&self.mMatchesMu8e23Filter_value)

        #print "making mMatchesMu8e23Path"
        self.mMatchesMu8e23Path_branch = the_tree.GetBranch("mMatchesMu8e23Path")
        #if not self.mMatchesMu8e23Path_branch and "mMatchesMu8e23Path" not in self.complained:
        if not self.mMatchesMu8e23Path_branch and "mMatchesMu8e23Path":
            warnings.warn( "MuTauTree: Expected branch mMatchesMu8e23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMatchesMu8e23Path")
        else:
            self.mMatchesMu8e23Path_branch.SetAddress(<void*>&self.mMatchesMu8e23Path_value)

        #print "making mMiniIsoLoose"
        self.mMiniIsoLoose_branch = the_tree.GetBranch("mMiniIsoLoose")
        #if not self.mMiniIsoLoose_branch and "mMiniIsoLoose" not in self.complained:
        if not self.mMiniIsoLoose_branch and "mMiniIsoLoose":
            warnings.warn( "MuTauTree: Expected branch mMiniIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoLoose")
        else:
            self.mMiniIsoLoose_branch.SetAddress(<void*>&self.mMiniIsoLoose_value)

        #print "making mMiniIsoMedium"
        self.mMiniIsoMedium_branch = the_tree.GetBranch("mMiniIsoMedium")
        #if not self.mMiniIsoMedium_branch and "mMiniIsoMedium" not in self.complained:
        if not self.mMiniIsoMedium_branch and "mMiniIsoMedium":
            warnings.warn( "MuTauTree: Expected branch mMiniIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoMedium")
        else:
            self.mMiniIsoMedium_branch.SetAddress(<void*>&self.mMiniIsoMedium_value)

        #print "making mMiniIsoTight"
        self.mMiniIsoTight_branch = the_tree.GetBranch("mMiniIsoTight")
        #if not self.mMiniIsoTight_branch and "mMiniIsoTight" not in self.complained:
        if not self.mMiniIsoTight_branch and "mMiniIsoTight":
            warnings.warn( "MuTauTree: Expected branch mMiniIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoTight")
        else:
            self.mMiniIsoTight_branch.SetAddress(<void*>&self.mMiniIsoTight_value)

        #print "making mMiniIsoVeryTight"
        self.mMiniIsoVeryTight_branch = the_tree.GetBranch("mMiniIsoVeryTight")
        #if not self.mMiniIsoVeryTight_branch and "mMiniIsoVeryTight" not in self.complained:
        if not self.mMiniIsoVeryTight_branch and "mMiniIsoVeryTight":
            warnings.warn( "MuTauTree: Expected branch mMiniIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMiniIsoVeryTight")
        else:
            self.mMiniIsoVeryTight_branch.SetAddress(<void*>&self.mMiniIsoVeryTight_value)

        #print "making mMuonHits"
        self.mMuonHits_branch = the_tree.GetBranch("mMuonHits")
        #if not self.mMuonHits_branch and "mMuonHits" not in self.complained:
        if not self.mMuonHits_branch and "mMuonHits":
            warnings.warn( "MuTauTree: Expected branch mMuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMuonHits")
        else:
            self.mMuonHits_branch.SetAddress(<void*>&self.mMuonHits_value)

        #print "making mMvaLoose"
        self.mMvaLoose_branch = the_tree.GetBranch("mMvaLoose")
        #if not self.mMvaLoose_branch and "mMvaLoose" not in self.complained:
        if not self.mMvaLoose_branch and "mMvaLoose":
            warnings.warn( "MuTauTree: Expected branch mMvaLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaLoose")
        else:
            self.mMvaLoose_branch.SetAddress(<void*>&self.mMvaLoose_value)

        #print "making mMvaMedium"
        self.mMvaMedium_branch = the_tree.GetBranch("mMvaMedium")
        #if not self.mMvaMedium_branch and "mMvaMedium" not in self.complained:
        if not self.mMvaMedium_branch and "mMvaMedium":
            warnings.warn( "MuTauTree: Expected branch mMvaMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaMedium")
        else:
            self.mMvaMedium_branch.SetAddress(<void*>&self.mMvaMedium_value)

        #print "making mMvaTight"
        self.mMvaTight_branch = the_tree.GetBranch("mMvaTight")
        #if not self.mMvaTight_branch and "mMvaTight" not in self.complained:
        if not self.mMvaTight_branch and "mMvaTight":
            warnings.warn( "MuTauTree: Expected branch mMvaTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mMvaTight")
        else:
            self.mMvaTight_branch.SetAddress(<void*>&self.mMvaTight_value)

        #print "making mNearestZMass"
        self.mNearestZMass_branch = the_tree.GetBranch("mNearestZMass")
        #if not self.mNearestZMass_branch and "mNearestZMass" not in self.complained:
        if not self.mNearestZMass_branch and "mNearestZMass":
            warnings.warn( "MuTauTree: Expected branch mNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNearestZMass")
        else:
            self.mNearestZMass_branch.SetAddress(<void*>&self.mNearestZMass_value)

        #print "making mNormTrkChi2"
        self.mNormTrkChi2_branch = the_tree.GetBranch("mNormTrkChi2")
        #if not self.mNormTrkChi2_branch and "mNormTrkChi2" not in self.complained:
        if not self.mNormTrkChi2_branch and "mNormTrkChi2":
            warnings.warn( "MuTauTree: Expected branch mNormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormTrkChi2")
        else:
            self.mNormTrkChi2_branch.SetAddress(<void*>&self.mNormTrkChi2_value)

        #print "making mNormalizedChi2"
        self.mNormalizedChi2_branch = the_tree.GetBranch("mNormalizedChi2")
        #if not self.mNormalizedChi2_branch and "mNormalizedChi2" not in self.complained:
        if not self.mNormalizedChi2_branch and "mNormalizedChi2":
            warnings.warn( "MuTauTree: Expected branch mNormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mNormalizedChi2")
        else:
            self.mNormalizedChi2_branch.SetAddress(<void*>&self.mNormalizedChi2_value)

        #print "making mPFChargedHadronIsoR04"
        self.mPFChargedHadronIsoR04_branch = the_tree.GetBranch("mPFChargedHadronIsoR04")
        #if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04" not in self.complained:
        if not self.mPFChargedHadronIsoR04_branch and "mPFChargedHadronIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedHadronIsoR04")
        else:
            self.mPFChargedHadronIsoR04_branch.SetAddress(<void*>&self.mPFChargedHadronIsoR04_value)

        #print "making mPFChargedIso"
        self.mPFChargedIso_branch = the_tree.GetBranch("mPFChargedIso")
        #if not self.mPFChargedIso_branch and "mPFChargedIso" not in self.complained:
        if not self.mPFChargedIso_branch and "mPFChargedIso":
            warnings.warn( "MuTauTree: Expected branch mPFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFChargedIso")
        else:
            self.mPFChargedIso_branch.SetAddress(<void*>&self.mPFChargedIso_value)

        #print "making mPFIDLoose"
        self.mPFIDLoose_branch = the_tree.GetBranch("mPFIDLoose")
        #if not self.mPFIDLoose_branch and "mPFIDLoose" not in self.complained:
        if not self.mPFIDLoose_branch and "mPFIDLoose":
            warnings.warn( "MuTauTree: Expected branch mPFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDLoose")
        else:
            self.mPFIDLoose_branch.SetAddress(<void*>&self.mPFIDLoose_value)

        #print "making mPFIDMedium"
        self.mPFIDMedium_branch = the_tree.GetBranch("mPFIDMedium")
        #if not self.mPFIDMedium_branch and "mPFIDMedium" not in self.complained:
        if not self.mPFIDMedium_branch and "mPFIDMedium":
            warnings.warn( "MuTauTree: Expected branch mPFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDMedium")
        else:
            self.mPFIDMedium_branch.SetAddress(<void*>&self.mPFIDMedium_value)

        #print "making mPFIDTight"
        self.mPFIDTight_branch = the_tree.GetBranch("mPFIDTight")
        #if not self.mPFIDTight_branch and "mPFIDTight" not in self.complained:
        if not self.mPFIDTight_branch and "mPFIDTight":
            warnings.warn( "MuTauTree: Expected branch mPFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIDTight")
        else:
            self.mPFIDTight_branch.SetAddress(<void*>&self.mPFIDTight_value)

        #print "making mPFIsoLoose"
        self.mPFIsoLoose_branch = the_tree.GetBranch("mPFIsoLoose")
        #if not self.mPFIsoLoose_branch and "mPFIsoLoose" not in self.complained:
        if not self.mPFIsoLoose_branch and "mPFIsoLoose":
            warnings.warn( "MuTauTree: Expected branch mPFIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoLoose")
        else:
            self.mPFIsoLoose_branch.SetAddress(<void*>&self.mPFIsoLoose_value)

        #print "making mPFIsoMedium"
        self.mPFIsoMedium_branch = the_tree.GetBranch("mPFIsoMedium")
        #if not self.mPFIsoMedium_branch and "mPFIsoMedium" not in self.complained:
        if not self.mPFIsoMedium_branch and "mPFIsoMedium":
            warnings.warn( "MuTauTree: Expected branch mPFIsoMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoMedium")
        else:
            self.mPFIsoMedium_branch.SetAddress(<void*>&self.mPFIsoMedium_value)

        #print "making mPFIsoTight"
        self.mPFIsoTight_branch = the_tree.GetBranch("mPFIsoTight")
        #if not self.mPFIsoTight_branch and "mPFIsoTight" not in self.complained:
        if not self.mPFIsoTight_branch and "mPFIsoTight":
            warnings.warn( "MuTauTree: Expected branch mPFIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoTight")
        else:
            self.mPFIsoTight_branch.SetAddress(<void*>&self.mPFIsoTight_value)

        #print "making mPFIsoVeryLoose"
        self.mPFIsoVeryLoose_branch = the_tree.GetBranch("mPFIsoVeryLoose")
        #if not self.mPFIsoVeryLoose_branch and "mPFIsoVeryLoose" not in self.complained:
        if not self.mPFIsoVeryLoose_branch and "mPFIsoVeryLoose":
            warnings.warn( "MuTauTree: Expected branch mPFIsoVeryLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoVeryLoose")
        else:
            self.mPFIsoVeryLoose_branch.SetAddress(<void*>&self.mPFIsoVeryLoose_value)

        #print "making mPFIsoVeryTight"
        self.mPFIsoVeryTight_branch = the_tree.GetBranch("mPFIsoVeryTight")
        #if not self.mPFIsoVeryTight_branch and "mPFIsoVeryTight" not in self.complained:
        if not self.mPFIsoVeryTight_branch and "mPFIsoVeryTight":
            warnings.warn( "MuTauTree: Expected branch mPFIsoVeryTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFIsoVeryTight")
        else:
            self.mPFIsoVeryTight_branch.SetAddress(<void*>&self.mPFIsoVeryTight_value)

        #print "making mPFNeutralHadronIsoR04"
        self.mPFNeutralHadronIsoR04_branch = the_tree.GetBranch("mPFNeutralHadronIsoR04")
        #if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04" not in self.complained:
        if not self.mPFNeutralHadronIsoR04_branch and "mPFNeutralHadronIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralHadronIsoR04")
        else:
            self.mPFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.mPFNeutralHadronIsoR04_value)

        #print "making mPFNeutralIso"
        self.mPFNeutralIso_branch = the_tree.GetBranch("mPFNeutralIso")
        #if not self.mPFNeutralIso_branch and "mPFNeutralIso" not in self.complained:
        if not self.mPFNeutralIso_branch and "mPFNeutralIso":
            warnings.warn( "MuTauTree: Expected branch mPFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFNeutralIso")
        else:
            self.mPFNeutralIso_branch.SetAddress(<void*>&self.mPFNeutralIso_value)

        #print "making mPFPUChargedIso"
        self.mPFPUChargedIso_branch = the_tree.GetBranch("mPFPUChargedIso")
        #if not self.mPFPUChargedIso_branch and "mPFPUChargedIso" not in self.complained:
        if not self.mPFPUChargedIso_branch and "mPFPUChargedIso":
            warnings.warn( "MuTauTree: Expected branch mPFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPUChargedIso")
        else:
            self.mPFPUChargedIso_branch.SetAddress(<void*>&self.mPFPUChargedIso_value)

        #print "making mPFPhotonIso"
        self.mPFPhotonIso_branch = the_tree.GetBranch("mPFPhotonIso")
        #if not self.mPFPhotonIso_branch and "mPFPhotonIso" not in self.complained:
        if not self.mPFPhotonIso_branch and "mPFPhotonIso":
            warnings.warn( "MuTauTree: Expected branch mPFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIso")
        else:
            self.mPFPhotonIso_branch.SetAddress(<void*>&self.mPFPhotonIso_value)

        #print "making mPFPhotonIsoR04"
        self.mPFPhotonIsoR04_branch = the_tree.GetBranch("mPFPhotonIsoR04")
        #if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04" not in self.complained:
        if not self.mPFPhotonIsoR04_branch and "mPFPhotonIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPhotonIsoR04")
        else:
            self.mPFPhotonIsoR04_branch.SetAddress(<void*>&self.mPFPhotonIsoR04_value)

        #print "making mPFPileupIsoR04"
        self.mPFPileupIsoR04_branch = the_tree.GetBranch("mPFPileupIsoR04")
        #if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04" not in self.complained:
        if not self.mPFPileupIsoR04_branch and "mPFPileupIsoR04":
            warnings.warn( "MuTauTree: Expected branch mPFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPFPileupIsoR04")
        else:
            self.mPFPileupIsoR04_branch.SetAddress(<void*>&self.mPFPileupIsoR04_value)

        #print "making mPVDXY"
        self.mPVDXY_branch = the_tree.GetBranch("mPVDXY")
        #if not self.mPVDXY_branch and "mPVDXY" not in self.complained:
        if not self.mPVDXY_branch and "mPVDXY":
            warnings.warn( "MuTauTree: Expected branch mPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDXY")
        else:
            self.mPVDXY_branch.SetAddress(<void*>&self.mPVDXY_value)

        #print "making mPVDZ"
        self.mPVDZ_branch = the_tree.GetBranch("mPVDZ")
        #if not self.mPVDZ_branch and "mPVDZ" not in self.complained:
        if not self.mPVDZ_branch and "mPVDZ":
            warnings.warn( "MuTauTree: Expected branch mPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPVDZ")
        else:
            self.mPVDZ_branch.SetAddress(<void*>&self.mPVDZ_value)

        #print "making mPhi"
        self.mPhi_branch = the_tree.GetBranch("mPhi")
        #if not self.mPhi_branch and "mPhi" not in self.complained:
        if not self.mPhi_branch and "mPhi":
            warnings.warn( "MuTauTree: Expected branch mPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi")
        else:
            self.mPhi_branch.SetAddress(<void*>&self.mPhi_value)

        #print "making mPhi_MuonEnDown"
        self.mPhi_MuonEnDown_branch = the_tree.GetBranch("mPhi_MuonEnDown")
        #if not self.mPhi_MuonEnDown_branch and "mPhi_MuonEnDown" not in self.complained:
        if not self.mPhi_MuonEnDown_branch and "mPhi_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mPhi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi_MuonEnDown")
        else:
            self.mPhi_MuonEnDown_branch.SetAddress(<void*>&self.mPhi_MuonEnDown_value)

        #print "making mPhi_MuonEnUp"
        self.mPhi_MuonEnUp_branch = the_tree.GetBranch("mPhi_MuonEnUp")
        #if not self.mPhi_MuonEnUp_branch and "mPhi_MuonEnUp" not in self.complained:
        if not self.mPhi_MuonEnUp_branch and "mPhi_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mPhi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPhi_MuonEnUp")
        else:
            self.mPhi_MuonEnUp_branch.SetAddress(<void*>&self.mPhi_MuonEnUp_value)

        #print "making mPixHits"
        self.mPixHits_branch = the_tree.GetBranch("mPixHits")
        #if not self.mPixHits_branch and "mPixHits" not in self.complained:
        if not self.mPixHits_branch and "mPixHits":
            warnings.warn( "MuTauTree: Expected branch mPixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPixHits")
        else:
            self.mPixHits_branch.SetAddress(<void*>&self.mPixHits_value)

        #print "making mPt"
        self.mPt_branch = the_tree.GetBranch("mPt")
        #if not self.mPt_branch and "mPt" not in self.complained:
        if not self.mPt_branch and "mPt":
            warnings.warn( "MuTauTree: Expected branch mPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt")
        else:
            self.mPt_branch.SetAddress(<void*>&self.mPt_value)

        #print "making mPt_MuonEnDown"
        self.mPt_MuonEnDown_branch = the_tree.GetBranch("mPt_MuonEnDown")
        #if not self.mPt_MuonEnDown_branch and "mPt_MuonEnDown" not in self.complained:
        if not self.mPt_MuonEnDown_branch and "mPt_MuonEnDown":
            warnings.warn( "MuTauTree: Expected branch mPt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt_MuonEnDown")
        else:
            self.mPt_MuonEnDown_branch.SetAddress(<void*>&self.mPt_MuonEnDown_value)

        #print "making mPt_MuonEnUp"
        self.mPt_MuonEnUp_branch = the_tree.GetBranch("mPt_MuonEnUp")
        #if not self.mPt_MuonEnUp_branch and "mPt_MuonEnUp" not in self.complained:
        if not self.mPt_MuonEnUp_branch and "mPt_MuonEnUp":
            warnings.warn( "MuTauTree: Expected branch mPt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mPt_MuonEnUp")
        else:
            self.mPt_MuonEnUp_branch.SetAddress(<void*>&self.mPt_MuonEnUp_value)

        #print "making mRelPFIsoDBDefault"
        self.mRelPFIsoDBDefault_branch = the_tree.GetBranch("mRelPFIsoDBDefault")
        #if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault" not in self.complained:
        if not self.mRelPFIsoDBDefault_branch and "mRelPFIsoDBDefault":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefault")
        else:
            self.mRelPFIsoDBDefault_branch.SetAddress(<void*>&self.mRelPFIsoDBDefault_value)

        #print "making mRelPFIsoDBDefaultR04"
        self.mRelPFIsoDBDefaultR04_branch = the_tree.GetBranch("mRelPFIsoDBDefaultR04")
        #if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04" not in self.complained:
        if not self.mRelPFIsoDBDefaultR04_branch and "mRelPFIsoDBDefaultR04":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoDBDefaultR04")
        else:
            self.mRelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.mRelPFIsoDBDefaultR04_value)

        #print "making mRelPFIsoRho"
        self.mRelPFIsoRho_branch = the_tree.GetBranch("mRelPFIsoRho")
        #if not self.mRelPFIsoRho_branch and "mRelPFIsoRho" not in self.complained:
        if not self.mRelPFIsoRho_branch and "mRelPFIsoRho":
            warnings.warn( "MuTauTree: Expected branch mRelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRelPFIsoRho")
        else:
            self.mRelPFIsoRho_branch.SetAddress(<void*>&self.mRelPFIsoRho_value)

        #print "making mRho"
        self.mRho_branch = the_tree.GetBranch("mRho")
        #if not self.mRho_branch and "mRho" not in self.complained:
        if not self.mRho_branch and "mRho":
            warnings.warn( "MuTauTree: Expected branch mRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mRho")
        else:
            self.mRho_branch.SetAddress(<void*>&self.mRho_value)

        #print "making mSIP2D"
        self.mSIP2D_branch = the_tree.GetBranch("mSIP2D")
        #if not self.mSIP2D_branch and "mSIP2D" not in self.complained:
        if not self.mSIP2D_branch and "mSIP2D":
            warnings.warn( "MuTauTree: Expected branch mSIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP2D")
        else:
            self.mSIP2D_branch.SetAddress(<void*>&self.mSIP2D_value)

        #print "making mSIP3D"
        self.mSIP3D_branch = the_tree.GetBranch("mSIP3D")
        #if not self.mSIP3D_branch and "mSIP3D" not in self.complained:
        if not self.mSIP3D_branch and "mSIP3D":
            warnings.warn( "MuTauTree: Expected branch mSIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSIP3D")
        else:
            self.mSIP3D_branch.SetAddress(<void*>&self.mSIP3D_value)

        #print "making mSegmentCompatibility"
        self.mSegmentCompatibility_branch = the_tree.GetBranch("mSegmentCompatibility")
        #if not self.mSegmentCompatibility_branch and "mSegmentCompatibility" not in self.complained:
        if not self.mSegmentCompatibility_branch and "mSegmentCompatibility":
            warnings.warn( "MuTauTree: Expected branch mSegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSegmentCompatibility")
        else:
            self.mSegmentCompatibility_branch.SetAddress(<void*>&self.mSegmentCompatibility_value)

        #print "making mSoftCutBasedId"
        self.mSoftCutBasedId_branch = the_tree.GetBranch("mSoftCutBasedId")
        #if not self.mSoftCutBasedId_branch and "mSoftCutBasedId" not in self.complained:
        if not self.mSoftCutBasedId_branch and "mSoftCutBasedId":
            warnings.warn( "MuTauTree: Expected branch mSoftCutBasedId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mSoftCutBasedId")
        else:
            self.mSoftCutBasedId_branch.SetAddress(<void*>&self.mSoftCutBasedId_value)

        #print "making mTkIsoLoose"
        self.mTkIsoLoose_branch = the_tree.GetBranch("mTkIsoLoose")
        #if not self.mTkIsoLoose_branch and "mTkIsoLoose" not in self.complained:
        if not self.mTkIsoLoose_branch and "mTkIsoLoose":
            warnings.warn( "MuTauTree: Expected branch mTkIsoLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTkIsoLoose")
        else:
            self.mTkIsoLoose_branch.SetAddress(<void*>&self.mTkIsoLoose_value)

        #print "making mTkIsoTight"
        self.mTkIsoTight_branch = the_tree.GetBranch("mTkIsoTight")
        #if not self.mTkIsoTight_branch and "mTkIsoTight" not in self.complained:
        if not self.mTkIsoTight_branch and "mTkIsoTight":
            warnings.warn( "MuTauTree: Expected branch mTkIsoTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTkIsoTight")
        else:
            self.mTkIsoTight_branch.SetAddress(<void*>&self.mTkIsoTight_value)

        #print "making mTkLayersWithMeasurement"
        self.mTkLayersWithMeasurement_branch = the_tree.GetBranch("mTkLayersWithMeasurement")
        #if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement" not in self.complained:
        if not self.mTkLayersWithMeasurement_branch and "mTkLayersWithMeasurement":
            warnings.warn( "MuTauTree: Expected branch mTkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTkLayersWithMeasurement")
        else:
            self.mTkLayersWithMeasurement_branch.SetAddress(<void*>&self.mTkLayersWithMeasurement_value)

        #print "making mTrkIsoDR03"
        self.mTrkIsoDR03_branch = the_tree.GetBranch("mTrkIsoDR03")
        #if not self.mTrkIsoDR03_branch and "mTrkIsoDR03" not in self.complained:
        if not self.mTrkIsoDR03_branch and "mTrkIsoDR03":
            warnings.warn( "MuTauTree: Expected branch mTrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkIsoDR03")
        else:
            self.mTrkIsoDR03_branch.SetAddress(<void*>&self.mTrkIsoDR03_value)

        #print "making mTrkKink"
        self.mTrkKink_branch = the_tree.GetBranch("mTrkKink")
        #if not self.mTrkKink_branch and "mTrkKink" not in self.complained:
        if not self.mTrkKink_branch and "mTrkKink":
            warnings.warn( "MuTauTree: Expected branch mTrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTrkKink")
        else:
            self.mTrkKink_branch.SetAddress(<void*>&self.mTrkKink_value)

        #print "making mTypeCode"
        self.mTypeCode_branch = the_tree.GetBranch("mTypeCode")
        #if not self.mTypeCode_branch and "mTypeCode" not in self.complained:
        if not self.mTypeCode_branch and "mTypeCode":
            warnings.warn( "MuTauTree: Expected branch mTypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mTypeCode")
        else:
            self.mTypeCode_branch.SetAddress(<void*>&self.mTypeCode_value)

        #print "making mVZ"
        self.mVZ_branch = the_tree.GetBranch("mVZ")
        #if not self.mVZ_branch and "mVZ" not in self.complained:
        if not self.mVZ_branch and "mVZ":
            warnings.warn( "MuTauTree: Expected branch mVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mVZ")
        else:
            self.mVZ_branch.SetAddress(<void*>&self.mVZ_value)

        #print "making mValidFraction"
        self.mValidFraction_branch = the_tree.GetBranch("mValidFraction")
        #if not self.mValidFraction_branch and "mValidFraction" not in self.complained:
        if not self.mValidFraction_branch and "mValidFraction":
            warnings.warn( "MuTauTree: Expected branch mValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mValidFraction")
        else:
            self.mValidFraction_branch.SetAddress(<void*>&self.mValidFraction_value)

        #print "making mZTTGenDR"
        self.mZTTGenDR_branch = the_tree.GetBranch("mZTTGenDR")
        #if not self.mZTTGenDR_branch and "mZTTGenDR" not in self.complained:
        if not self.mZTTGenDR_branch and "mZTTGenDR":
            warnings.warn( "MuTauTree: Expected branch mZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenDR")
        else:
            self.mZTTGenDR_branch.SetAddress(<void*>&self.mZTTGenDR_value)

        #print "making mZTTGenEta"
        self.mZTTGenEta_branch = the_tree.GetBranch("mZTTGenEta")
        #if not self.mZTTGenEta_branch and "mZTTGenEta" not in self.complained:
        if not self.mZTTGenEta_branch and "mZTTGenEta":
            warnings.warn( "MuTauTree: Expected branch mZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenEta")
        else:
            self.mZTTGenEta_branch.SetAddress(<void*>&self.mZTTGenEta_value)

        #print "making mZTTGenMatching"
        self.mZTTGenMatching_branch = the_tree.GetBranch("mZTTGenMatching")
        #if not self.mZTTGenMatching_branch and "mZTTGenMatching" not in self.complained:
        if not self.mZTTGenMatching_branch and "mZTTGenMatching":
            warnings.warn( "MuTauTree: Expected branch mZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenMatching")
        else:
            self.mZTTGenMatching_branch.SetAddress(<void*>&self.mZTTGenMatching_value)

        #print "making mZTTGenPhi"
        self.mZTTGenPhi_branch = the_tree.GetBranch("mZTTGenPhi")
        #if not self.mZTTGenPhi_branch and "mZTTGenPhi" not in self.complained:
        if not self.mZTTGenPhi_branch and "mZTTGenPhi":
            warnings.warn( "MuTauTree: Expected branch mZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenPhi")
        else:
            self.mZTTGenPhi_branch.SetAddress(<void*>&self.mZTTGenPhi_value)

        #print "making mZTTGenPt"
        self.mZTTGenPt_branch = the_tree.GetBranch("mZTTGenPt")
        #if not self.mZTTGenPt_branch and "mZTTGenPt" not in self.complained:
        if not self.mZTTGenPt_branch and "mZTTGenPt":
            warnings.warn( "MuTauTree: Expected branch mZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mZTTGenPt")
        else:
            self.mZTTGenPt_branch.SetAddress(<void*>&self.mZTTGenPt_value)

        #print "making m_t_DR"
        self.m_t_DR_branch = the_tree.GetBranch("m_t_DR")
        #if not self.m_t_DR_branch and "m_t_DR" not in self.complained:
        if not self.m_t_DR_branch and "m_t_DR":
            warnings.warn( "MuTauTree: Expected branch m_t_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_DR")
        else:
            self.m_t_DR_branch.SetAddress(<void*>&self.m_t_DR_value)

        #print "making m_t_Mass"
        self.m_t_Mass_branch = the_tree.GetBranch("m_t_Mass")
        #if not self.m_t_Mass_branch and "m_t_Mass" not in self.complained:
        if not self.m_t_Mass_branch and "m_t_Mass":
            warnings.warn( "MuTauTree: Expected branch m_t_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_Mass")
        else:
            self.m_t_Mass_branch.SetAddress(<void*>&self.m_t_Mass_value)

        #print "making m_t_PZeta"
        self.m_t_PZeta_branch = the_tree.GetBranch("m_t_PZeta")
        #if not self.m_t_PZeta_branch and "m_t_PZeta" not in self.complained:
        if not self.m_t_PZeta_branch and "m_t_PZeta":
            warnings.warn( "MuTauTree: Expected branch m_t_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZeta")
        else:
            self.m_t_PZeta_branch.SetAddress(<void*>&self.m_t_PZeta_value)

        #print "making m_t_PZetaVis"
        self.m_t_PZetaVis_branch = the_tree.GetBranch("m_t_PZetaVis")
        #if not self.m_t_PZetaVis_branch and "m_t_PZetaVis" not in self.complained:
        if not self.m_t_PZetaVis_branch and "m_t_PZetaVis":
            warnings.warn( "MuTauTree: Expected branch m_t_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_PZetaVis")
        else:
            self.m_t_PZetaVis_branch.SetAddress(<void*>&self.m_t_PZetaVis_value)

        #print "making m_t_doubleL1IsoTauMatch"
        self.m_t_doubleL1IsoTauMatch_branch = the_tree.GetBranch("m_t_doubleL1IsoTauMatch")
        #if not self.m_t_doubleL1IsoTauMatch_branch and "m_t_doubleL1IsoTauMatch" not in self.complained:
        if not self.m_t_doubleL1IsoTauMatch_branch and "m_t_doubleL1IsoTauMatch":
            warnings.warn( "MuTauTree: Expected branch m_t_doubleL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_t_doubleL1IsoTauMatch")
        else:
            self.m_t_doubleL1IsoTauMatch_branch.SetAddress(<void*>&self.m_t_doubleL1IsoTauMatch_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuTauTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuTauTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuTauTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuTauTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuTauTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making mu12e23DZPass"
        self.mu12e23DZPass_branch = the_tree.GetBranch("mu12e23DZPass")
        #if not self.mu12e23DZPass_branch and "mu12e23DZPass" not in self.complained:
        if not self.mu12e23DZPass_branch and "mu12e23DZPass":
            warnings.warn( "MuTauTree: Expected branch mu12e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23DZPass")
        else:
            self.mu12e23DZPass_branch.SetAddress(<void*>&self.mu12e23DZPass_value)

        #print "making mu12e23Pass"
        self.mu12e23Pass_branch = the_tree.GetBranch("mu12e23Pass")
        #if not self.mu12e23Pass_branch and "mu12e23Pass" not in self.complained:
        if not self.mu12e23Pass_branch and "mu12e23Pass":
            warnings.warn( "MuTauTree: Expected branch mu12e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu12e23Pass")
        else:
            self.mu12e23Pass_branch.SetAddress(<void*>&self.mu12e23Pass_value)

        #print "making mu23e12DZPass"
        self.mu23e12DZPass_branch = the_tree.GetBranch("mu23e12DZPass")
        #if not self.mu23e12DZPass_branch and "mu23e12DZPass" not in self.complained:
        if not self.mu23e12DZPass_branch and "mu23e12DZPass":
            warnings.warn( "MuTauTree: Expected branch mu23e12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12DZPass")
        else:
            self.mu23e12DZPass_branch.SetAddress(<void*>&self.mu23e12DZPass_value)

        #print "making mu23e12Pass"
        self.mu23e12Pass_branch = the_tree.GetBranch("mu23e12Pass")
        #if not self.mu23e12Pass_branch and "mu23e12Pass" not in self.complained:
        if not self.mu23e12Pass_branch and "mu23e12Pass":
            warnings.warn( "MuTauTree: Expected branch mu23e12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu23e12Pass")
        else:
            self.mu23e12Pass_branch.SetAddress(<void*>&self.mu23e12Pass_value)

        #print "making mu8diele12DZPass"
        self.mu8diele12DZPass_branch = the_tree.GetBranch("mu8diele12DZPass")
        #if not self.mu8diele12DZPass_branch and "mu8diele12DZPass" not in self.complained:
        if not self.mu8diele12DZPass_branch and "mu8diele12DZPass":
            warnings.warn( "MuTauTree: Expected branch mu8diele12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12DZPass")
        else:
            self.mu8diele12DZPass_branch.SetAddress(<void*>&self.mu8diele12DZPass_value)

        #print "making mu8diele12Pass"
        self.mu8diele12Pass_branch = the_tree.GetBranch("mu8diele12Pass")
        #if not self.mu8diele12Pass_branch and "mu8diele12Pass" not in self.complained:
        if not self.mu8diele12Pass_branch and "mu8diele12Pass":
            warnings.warn( "MuTauTree: Expected branch mu8diele12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8diele12Pass")
        else:
            self.mu8diele12Pass_branch.SetAddress(<void*>&self.mu8diele12Pass_value)

        #print "making mu8e23DZPass"
        self.mu8e23DZPass_branch = the_tree.GetBranch("mu8e23DZPass")
        #if not self.mu8e23DZPass_branch and "mu8e23DZPass" not in self.complained:
        if not self.mu8e23DZPass_branch and "mu8e23DZPass":
            warnings.warn( "MuTauTree: Expected branch mu8e23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23DZPass")
        else:
            self.mu8e23DZPass_branch.SetAddress(<void*>&self.mu8e23DZPass_value)

        #print "making mu8e23Pass"
        self.mu8e23Pass_branch = the_tree.GetBranch("mu8e23Pass")
        #if not self.mu8e23Pass_branch and "mu8e23Pass" not in self.complained:
        if not self.mu8e23Pass_branch and "mu8e23Pass":
            warnings.warn( "MuTauTree: Expected branch mu8e23Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mu8e23Pass")
        else:
            self.mu8e23Pass_branch.SetAddress(<void*>&self.mu8e23Pass_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuTauTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVeto5"
        self.muVeto5_branch = the_tree.GetBranch("muVeto5")
        #if not self.muVeto5_branch and "muVeto5" not in self.complained:
        if not self.muVeto5_branch and "muVeto5":
            warnings.warn( "MuTauTree: Expected branch muVeto5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVeto5")
        else:
            self.muVeto5_branch.SetAddress(<void*>&self.muVeto5_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuTauTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuTauTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuTauTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making npNLO"
        self.npNLO_branch = the_tree.GetBranch("npNLO")
        #if not self.npNLO_branch and "npNLO" not in self.complained:
        if not self.npNLO_branch and "npNLO":
            warnings.warn( "MuTauTree: Expected branch npNLO does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npNLO")
        else:
            self.npNLO_branch.SetAddress(<void*>&self.npNLO_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuTauTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuTauTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making prefiring_weight"
        self.prefiring_weight_branch = the_tree.GetBranch("prefiring_weight")
        #if not self.prefiring_weight_branch and "prefiring_weight" not in self.complained:
        if not self.prefiring_weight_branch and "prefiring_weight":
            warnings.warn( "MuTauTree: Expected branch prefiring_weight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight")
        else:
            self.prefiring_weight_branch.SetAddress(<void*>&self.prefiring_weight_value)

        #print "making prefiring_weight_down"
        self.prefiring_weight_down_branch = the_tree.GetBranch("prefiring_weight_down")
        #if not self.prefiring_weight_down_branch and "prefiring_weight_down" not in self.complained:
        if not self.prefiring_weight_down_branch and "prefiring_weight_down":
            warnings.warn( "MuTauTree: Expected branch prefiring_weight_down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_down")
        else:
            self.prefiring_weight_down_branch.SetAddress(<void*>&self.prefiring_weight_down_value)

        #print "making prefiring_weight_up"
        self.prefiring_weight_up_branch = the_tree.GetBranch("prefiring_weight_up")
        #if not self.prefiring_weight_up_branch and "prefiring_weight_up" not in self.complained:
        if not self.prefiring_weight_up_branch and "prefiring_weight_up":
            warnings.warn( "MuTauTree: Expected branch prefiring_weight_up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("prefiring_weight_up")
        else:
            self.prefiring_weight_up_branch.SetAddress(<void*>&self.prefiring_weight_up_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuTauTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuTauTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuTauTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuTauTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuTauTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuTauTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuTauTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuTauTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuTauTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuTauTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuTauTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuTauTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuTauTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuTauTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuTauTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "MuTauTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "MuTauTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuTauTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuTauTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuTauTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuTauTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE25eta2p1TightPass"
        self.singleE25eta2p1TightPass_branch = the_tree.GetBranch("singleE25eta2p1TightPass")
        #if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass" not in self.complained:
        if not self.singleE25eta2p1TightPass_branch and "singleE25eta2p1TightPass":
            warnings.warn( "MuTauTree: Expected branch singleE25eta2p1TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE25eta2p1TightPass")
        else:
            self.singleE25eta2p1TightPass_branch.SetAddress(<void*>&self.singleE25eta2p1TightPass_value)

        #print "making singleIsoMu22Pass"
        self.singleIsoMu22Pass_branch = the_tree.GetBranch("singleIsoMu22Pass")
        #if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass" not in self.complained:
        if not self.singleIsoMu22Pass_branch and "singleIsoMu22Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22Pass")
        else:
            self.singleIsoMu22Pass_branch.SetAddress(<void*>&self.singleIsoMu22Pass_value)

        #print "making singleIsoMu22eta2p1Pass"
        self.singleIsoMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu22eta2p1Pass")
        #if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoMu22eta2p1Pass_branch and "singleIsoMu22eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu22eta2p1Pass")
        else:
            self.singleIsoMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu22eta2p1Pass_value)

        #print "making singleIsoTkMu22Pass"
        self.singleIsoTkMu22Pass_branch = the_tree.GetBranch("singleIsoTkMu22Pass")
        #if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass" not in self.complained:
        if not self.singleIsoTkMu22Pass_branch and "singleIsoTkMu22Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22Pass")
        else:
            self.singleIsoTkMu22Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22Pass_value)

        #print "making singleIsoTkMu22eta2p1Pass"
        self.singleIsoTkMu22eta2p1Pass_branch = the_tree.GetBranch("singleIsoTkMu22eta2p1Pass")
        #if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass" not in self.complained:
        if not self.singleIsoTkMu22eta2p1Pass_branch and "singleIsoTkMu22eta2p1Pass":
            warnings.warn( "MuTauTree: Expected branch singleIsoTkMu22eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoTkMu22eta2p1Pass")
        else:
            self.singleIsoTkMu22eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoTkMu22eta2p1Pass_value)

        #print "making singleMu19eta2p1LooseTau20Pass"
        self.singleMu19eta2p1LooseTau20Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20Pass")
        #if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20Pass_branch and "singleMu19eta2p1LooseTau20Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20Pass")
        else:
            self.singleMu19eta2p1LooseTau20Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20Pass_value)

        #print "making singleMu19eta2p1LooseTau20singleL1Pass"
        self.singleMu19eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu19eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu19eta2p1LooseTau20singleL1Pass_branch and "singleMu19eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuTauTree: Expected branch singleMu19eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu19eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu19eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu19eta2p1LooseTau20singleL1Pass_value)

        #print "making tAgainstElectronLooseMVA6"
        self.tAgainstElectronLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronLooseMVA6")
        #if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6" not in self.complained:
        if not self.tAgainstElectronLooseMVA6_branch and "tAgainstElectronLooseMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA6")
        else:
            self.tAgainstElectronLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA6_value)

        #print "making tAgainstElectronLooseMVA62018"
        self.tAgainstElectronLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronLooseMVA62018")
        #if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronLooseMVA62018_branch and "tAgainstElectronLooseMVA62018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronLooseMVA62018")
        else:
            self.tAgainstElectronLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronLooseMVA62018_value)

        #print "making tAgainstElectronMVA6Raw"
        self.tAgainstElectronMVA6Raw_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw")
        #if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw" not in self.complained:
        if not self.tAgainstElectronMVA6Raw_branch and "tAgainstElectronMVA6Raw":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw")
        else:
            self.tAgainstElectronMVA6Raw_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw_value)

        #print "making tAgainstElectronMVA6Raw2018"
        self.tAgainstElectronMVA6Raw2018_branch = the_tree.GetBranch("tAgainstElectronMVA6Raw2018")
        #if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018" not in self.complained:
        if not self.tAgainstElectronMVA6Raw2018_branch and "tAgainstElectronMVA6Raw2018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6Raw2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6Raw2018")
        else:
            self.tAgainstElectronMVA6Raw2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6Raw2018_value)

        #print "making tAgainstElectronMVA6category"
        self.tAgainstElectronMVA6category_branch = the_tree.GetBranch("tAgainstElectronMVA6category")
        #if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category" not in self.complained:
        if not self.tAgainstElectronMVA6category_branch and "tAgainstElectronMVA6category":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6category does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category")
        else:
            self.tAgainstElectronMVA6category_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category_value)

        #print "making tAgainstElectronMVA6category2018"
        self.tAgainstElectronMVA6category2018_branch = the_tree.GetBranch("tAgainstElectronMVA6category2018")
        #if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018" not in self.complained:
        if not self.tAgainstElectronMVA6category2018_branch and "tAgainstElectronMVA6category2018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMVA6category2018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMVA6category2018")
        else:
            self.tAgainstElectronMVA6category2018_branch.SetAddress(<void*>&self.tAgainstElectronMVA6category2018_value)

        #print "making tAgainstElectronMediumMVA6"
        self.tAgainstElectronMediumMVA6_branch = the_tree.GetBranch("tAgainstElectronMediumMVA6")
        #if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6" not in self.complained:
        if not self.tAgainstElectronMediumMVA6_branch and "tAgainstElectronMediumMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMediumMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA6")
        else:
            self.tAgainstElectronMediumMVA6_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA6_value)

        #print "making tAgainstElectronMediumMVA62018"
        self.tAgainstElectronMediumMVA62018_branch = the_tree.GetBranch("tAgainstElectronMediumMVA62018")
        #if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018" not in self.complained:
        if not self.tAgainstElectronMediumMVA62018_branch and "tAgainstElectronMediumMVA62018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronMediumMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronMediumMVA62018")
        else:
            self.tAgainstElectronMediumMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronMediumMVA62018_value)

        #print "making tAgainstElectronTightMVA6"
        self.tAgainstElectronTightMVA6_branch = the_tree.GetBranch("tAgainstElectronTightMVA6")
        #if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6" not in self.complained:
        if not self.tAgainstElectronTightMVA6_branch and "tAgainstElectronTightMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA6")
        else:
            self.tAgainstElectronTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA6_value)

        #print "making tAgainstElectronTightMVA62018"
        self.tAgainstElectronTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronTightMVA62018")
        #if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018" not in self.complained:
        if not self.tAgainstElectronTightMVA62018_branch and "tAgainstElectronTightMVA62018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronTightMVA62018")
        else:
            self.tAgainstElectronTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronTightMVA62018_value)

        #print "making tAgainstElectronVLooseMVA6"
        self.tAgainstElectronVLooseMVA6_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA6")
        #if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6" not in self.complained:
        if not self.tAgainstElectronVLooseMVA6_branch and "tAgainstElectronVLooseMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVLooseMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA6")
        else:
            self.tAgainstElectronVLooseMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA6_value)

        #print "making tAgainstElectronVLooseMVA62018"
        self.tAgainstElectronVLooseMVA62018_branch = the_tree.GetBranch("tAgainstElectronVLooseMVA62018")
        #if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018" not in self.complained:
        if not self.tAgainstElectronVLooseMVA62018_branch and "tAgainstElectronVLooseMVA62018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVLooseMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVLooseMVA62018")
        else:
            self.tAgainstElectronVLooseMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVLooseMVA62018_value)

        #print "making tAgainstElectronVTightMVA6"
        self.tAgainstElectronVTightMVA6_branch = the_tree.GetBranch("tAgainstElectronVTightMVA6")
        #if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6" not in self.complained:
        if not self.tAgainstElectronVTightMVA6_branch and "tAgainstElectronVTightMVA6":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVTightMVA6 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA6")
        else:
            self.tAgainstElectronVTightMVA6_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA6_value)

        #print "making tAgainstElectronVTightMVA62018"
        self.tAgainstElectronVTightMVA62018_branch = the_tree.GetBranch("tAgainstElectronVTightMVA62018")
        #if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018" not in self.complained:
        if not self.tAgainstElectronVTightMVA62018_branch and "tAgainstElectronVTightMVA62018":
            warnings.warn( "MuTauTree: Expected branch tAgainstElectronVTightMVA62018 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstElectronVTightMVA62018")
        else:
            self.tAgainstElectronVTightMVA62018_branch.SetAddress(<void*>&self.tAgainstElectronVTightMVA62018_value)

        #print "making tAgainstMuonLoose3"
        self.tAgainstMuonLoose3_branch = the_tree.GetBranch("tAgainstMuonLoose3")
        #if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3" not in self.complained:
        if not self.tAgainstMuonLoose3_branch and "tAgainstMuonLoose3":
            warnings.warn( "MuTauTree: Expected branch tAgainstMuonLoose3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonLoose3")
        else:
            self.tAgainstMuonLoose3_branch.SetAddress(<void*>&self.tAgainstMuonLoose3_value)

        #print "making tAgainstMuonTight3"
        self.tAgainstMuonTight3_branch = the_tree.GetBranch("tAgainstMuonTight3")
        #if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3" not in self.complained:
        if not self.tAgainstMuonTight3_branch and "tAgainstMuonTight3":
            warnings.warn( "MuTauTree: Expected branch tAgainstMuonTight3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tAgainstMuonTight3")
        else:
            self.tAgainstMuonTight3_branch.SetAddress(<void*>&self.tAgainstMuonTight3_value)

        #print "making tByCombinedIsolationDeltaBetaCorrRaw3Hits"
        self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch = the_tree.GetBranch("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        #if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits" not in self.complained:
        if not self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch and "tByCombinedIsolationDeltaBetaCorrRaw3Hits":
            warnings.warn( "MuTauTree: Expected branch tByCombinedIsolationDeltaBetaCorrRaw3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByCombinedIsolationDeltaBetaCorrRaw3Hits")
        else:
            self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_branch.SetAddress(<void*>&self.tByCombinedIsolationDeltaBetaCorrRaw3Hits_value)

        #print "making tByIsolationMVArun2v1DBdR03oldDMwLTraw"
        self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch and "tByIsolationMVArun2v1DBdR03oldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBdR03oldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBdR03oldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBdR03oldDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBnewDMwLTraw"
        self.tByIsolationMVArun2v1DBnewDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBnewDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBnewDMwLTraw_branch and "tByIsolationMVArun2v1DBnewDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBnewDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBnewDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBnewDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBnewDMwLTraw_value)

        #print "making tByIsolationMVArun2v1DBoldDMwLTraw"
        self.tByIsolationMVArun2v1DBoldDMwLTraw_branch = the_tree.GetBranch("tByIsolationMVArun2v1DBoldDMwLTraw")
        #if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw" not in self.complained:
        if not self.tByIsolationMVArun2v1DBoldDMwLTraw_branch and "tByIsolationMVArun2v1DBoldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tByIsolationMVArun2v1DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByIsolationMVArun2v1DBoldDMwLTraw")
        else:
            self.tByIsolationMVArun2v1DBoldDMwLTraw_branch.SetAddress(<void*>&self.tByIsolationMVArun2v1DBoldDMwLTraw_value)

        #print "making tByLooseCombinedIsolationDeltaBetaCorr3Hits"
        self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch and "tByLooseCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByLooseCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByLooseCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByMediumCombinedIsolationDeltaBetaCorr3Hits"
        self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch and "tByMediumCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByMediumCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByMediumCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByMediumIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByMediumIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBnewDMwLT"
        self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch and "tByMediumIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByMediumIsolationMVArun2v1DBoldDMwLT"
        self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByMediumIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch and "tByMediumIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByMediumIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByMediumIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByMediumIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByMediumIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByPhotonPtSumOutsideSignalCone"
        self.tByPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tByPhotonPtSumOutsideSignalCone")
        #if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tByPhotonPtSumOutsideSignalCone_branch and "tByPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuTauTree: Expected branch tByPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByPhotonPtSumOutsideSignalCone")
        else:
            self.tByPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tByPhotonPtSumOutsideSignalCone_value)

        #print "making tByTightCombinedIsolationDeltaBetaCorr3Hits"
        self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch = the_tree.GetBranch("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        #if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits" not in self.complained:
        if not self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch and "tByTightCombinedIsolationDeltaBetaCorr3Hits":
            warnings.warn( "MuTauTree: Expected branch tByTightCombinedIsolationDeltaBetaCorr3Hits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightCombinedIsolationDeltaBetaCorr3Hits")
        else:
            self.tByTightCombinedIsolationDeltaBetaCorr3Hits_branch.SetAddress(<void*>&self.tByTightCombinedIsolationDeltaBetaCorr3Hits_value)

        #print "making tByTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBnewDMwLT"
        self.tByTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBnewDMwLT_branch and "tByTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByTightIsolationMVArun2v1DBoldDMwLT"
        self.tByTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByTightIsolationMVArun2v1DBoldDMwLT_branch and "tByTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBnewDMwLT"
        self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch and "tByVLooseIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVLooseIsolationMVArun2v1DBoldDMwLT"
        self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch and "tByVLooseIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVLooseIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVLooseIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVLooseIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVLooseIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBdR03oldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBdR03oldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBdR03oldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBdR03oldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBdR03oldDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBnewDMwLT"
        self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch and "tByVVTightIsolationMVArun2v1DBnewDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBnewDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBnewDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBnewDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBnewDMwLT_value)

        #print "making tByVVTightIsolationMVArun2v1DBoldDMwLT"
        self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch = the_tree.GetBranch("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        #if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT" not in self.complained:
        if not self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch and "tByVVTightIsolationMVArun2v1DBoldDMwLT":
            warnings.warn( "MuTauTree: Expected branch tByVVTightIsolationMVArun2v1DBoldDMwLT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tByVVTightIsolationMVArun2v1DBoldDMwLT")
        else:
            self.tByVVTightIsolationMVArun2v1DBoldDMwLT_branch.SetAddress(<void*>&self.tByVVTightIsolationMVArun2v1DBoldDMwLT_value)

        #print "making tCharge"
        self.tCharge_branch = the_tree.GetBranch("tCharge")
        #if not self.tCharge_branch and "tCharge" not in self.complained:
        if not self.tCharge_branch and "tCharge":
            warnings.warn( "MuTauTree: Expected branch tCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tCharge")
        else:
            self.tCharge_branch.SetAddress(<void*>&self.tCharge_value)

        #print "making tChargedIsoPtSum"
        self.tChargedIsoPtSum_branch = the_tree.GetBranch("tChargedIsoPtSum")
        #if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum" not in self.complained:
        if not self.tChargedIsoPtSum_branch and "tChargedIsoPtSum":
            warnings.warn( "MuTauTree: Expected branch tChargedIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSum")
        else:
            self.tChargedIsoPtSum_branch.SetAddress(<void*>&self.tChargedIsoPtSum_value)

        #print "making tChargedIsoPtSumdR03"
        self.tChargedIsoPtSumdR03_branch = the_tree.GetBranch("tChargedIsoPtSumdR03")
        #if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03" not in self.complained:
        if not self.tChargedIsoPtSumdR03_branch and "tChargedIsoPtSumdR03":
            warnings.warn( "MuTauTree: Expected branch tChargedIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tChargedIsoPtSumdR03")
        else:
            self.tChargedIsoPtSumdR03_branch.SetAddress(<void*>&self.tChargedIsoPtSumdR03_value)

        #print "making tComesFromHiggs"
        self.tComesFromHiggs_branch = the_tree.GetBranch("tComesFromHiggs")
        #if not self.tComesFromHiggs_branch and "tComesFromHiggs" not in self.complained:
        if not self.tComesFromHiggs_branch and "tComesFromHiggs":
            warnings.warn( "MuTauTree: Expected branch tComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tComesFromHiggs")
        else:
            self.tComesFromHiggs_branch.SetAddress(<void*>&self.tComesFromHiggs_value)

        #print "making tDecayMode"
        self.tDecayMode_branch = the_tree.GetBranch("tDecayMode")
        #if not self.tDecayMode_branch and "tDecayMode" not in self.complained:
        if not self.tDecayMode_branch and "tDecayMode":
            warnings.warn( "MuTauTree: Expected branch tDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayMode")
        else:
            self.tDecayMode_branch.SetAddress(<void*>&self.tDecayMode_value)

        #print "making tDecayModeFinding"
        self.tDecayModeFinding_branch = the_tree.GetBranch("tDecayModeFinding")
        #if not self.tDecayModeFinding_branch and "tDecayModeFinding" not in self.complained:
        if not self.tDecayModeFinding_branch and "tDecayModeFinding":
            warnings.warn( "MuTauTree: Expected branch tDecayModeFinding does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFinding")
        else:
            self.tDecayModeFinding_branch.SetAddress(<void*>&self.tDecayModeFinding_value)

        #print "making tDecayModeFindingNewDMs"
        self.tDecayModeFindingNewDMs_branch = the_tree.GetBranch("tDecayModeFindingNewDMs")
        #if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs" not in self.complained:
        if not self.tDecayModeFindingNewDMs_branch and "tDecayModeFindingNewDMs":
            warnings.warn( "MuTauTree: Expected branch tDecayModeFindingNewDMs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDecayModeFindingNewDMs")
        else:
            self.tDecayModeFindingNewDMs_branch.SetAddress(<void*>&self.tDecayModeFindingNewDMs_value)

        #print "making tDeepTau2017v1VSeraw"
        self.tDeepTau2017v1VSeraw_branch = the_tree.GetBranch("tDeepTau2017v1VSeraw")
        #if not self.tDeepTau2017v1VSeraw_branch and "tDeepTau2017v1VSeraw" not in self.complained:
        if not self.tDeepTau2017v1VSeraw_branch and "tDeepTau2017v1VSeraw":
            warnings.warn( "MuTauTree: Expected branch tDeepTau2017v1VSeraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSeraw")
        else:
            self.tDeepTau2017v1VSeraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSeraw_value)

        #print "making tDeepTau2017v1VSjetraw"
        self.tDeepTau2017v1VSjetraw_branch = the_tree.GetBranch("tDeepTau2017v1VSjetraw")
        #if not self.tDeepTau2017v1VSjetraw_branch and "tDeepTau2017v1VSjetraw" not in self.complained:
        if not self.tDeepTau2017v1VSjetraw_branch and "tDeepTau2017v1VSjetraw":
            warnings.warn( "MuTauTree: Expected branch tDeepTau2017v1VSjetraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSjetraw")
        else:
            self.tDeepTau2017v1VSjetraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSjetraw_value)

        #print "making tDeepTau2017v1VSmuraw"
        self.tDeepTau2017v1VSmuraw_branch = the_tree.GetBranch("tDeepTau2017v1VSmuraw")
        #if not self.tDeepTau2017v1VSmuraw_branch and "tDeepTau2017v1VSmuraw" not in self.complained:
        if not self.tDeepTau2017v1VSmuraw_branch and "tDeepTau2017v1VSmuraw":
            warnings.warn( "MuTauTree: Expected branch tDeepTau2017v1VSmuraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tDeepTau2017v1VSmuraw")
        else:
            self.tDeepTau2017v1VSmuraw_branch.SetAddress(<void*>&self.tDeepTau2017v1VSmuraw_value)

        #print "making tEta"
        self.tEta_branch = the_tree.GetBranch("tEta")
        #if not self.tEta_branch and "tEta" not in self.complained:
        if not self.tEta_branch and "tEta":
            warnings.warn( "MuTauTree: Expected branch tEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tEta")
        else:
            self.tEta_branch.SetAddress(<void*>&self.tEta_value)

        #print "making tFootprintCorrection"
        self.tFootprintCorrection_branch = the_tree.GetBranch("tFootprintCorrection")
        #if not self.tFootprintCorrection_branch and "tFootprintCorrection" not in self.complained:
        if not self.tFootprintCorrection_branch and "tFootprintCorrection":
            warnings.warn( "MuTauTree: Expected branch tFootprintCorrection does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrection")
        else:
            self.tFootprintCorrection_branch.SetAddress(<void*>&self.tFootprintCorrection_value)

        #print "making tFootprintCorrectiondR03"
        self.tFootprintCorrectiondR03_branch = the_tree.GetBranch("tFootprintCorrectiondR03")
        #if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03" not in self.complained:
        if not self.tFootprintCorrectiondR03_branch and "tFootprintCorrectiondR03":
            warnings.warn( "MuTauTree: Expected branch tFootprintCorrectiondR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tFootprintCorrectiondR03")
        else:
            self.tFootprintCorrectiondR03_branch.SetAddress(<void*>&self.tFootprintCorrectiondR03_value)

        #print "making tGenCharge"
        self.tGenCharge_branch = the_tree.GetBranch("tGenCharge")
        #if not self.tGenCharge_branch and "tGenCharge" not in self.complained:
        if not self.tGenCharge_branch and "tGenCharge":
            warnings.warn( "MuTauTree: Expected branch tGenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenCharge")
        else:
            self.tGenCharge_branch.SetAddress(<void*>&self.tGenCharge_value)

        #print "making tGenDecayMode"
        self.tGenDecayMode_branch = the_tree.GetBranch("tGenDecayMode")
        #if not self.tGenDecayMode_branch and "tGenDecayMode" not in self.complained:
        if not self.tGenDecayMode_branch and "tGenDecayMode":
            warnings.warn( "MuTauTree: Expected branch tGenDecayMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenDecayMode")
        else:
            self.tGenDecayMode_branch.SetAddress(<void*>&self.tGenDecayMode_value)

        #print "making tGenEnergy"
        self.tGenEnergy_branch = the_tree.GetBranch("tGenEnergy")
        #if not self.tGenEnergy_branch and "tGenEnergy" not in self.complained:
        if not self.tGenEnergy_branch and "tGenEnergy":
            warnings.warn( "MuTauTree: Expected branch tGenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEnergy")
        else:
            self.tGenEnergy_branch.SetAddress(<void*>&self.tGenEnergy_value)

        #print "making tGenEta"
        self.tGenEta_branch = the_tree.GetBranch("tGenEta")
        #if not self.tGenEta_branch and "tGenEta" not in self.complained:
        if not self.tGenEta_branch and "tGenEta":
            warnings.warn( "MuTauTree: Expected branch tGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenEta")
        else:
            self.tGenEta_branch.SetAddress(<void*>&self.tGenEta_value)

        #print "making tGenJetEta"
        self.tGenJetEta_branch = the_tree.GetBranch("tGenJetEta")
        #if not self.tGenJetEta_branch and "tGenJetEta" not in self.complained:
        if not self.tGenJetEta_branch and "tGenJetEta":
            warnings.warn( "MuTauTree: Expected branch tGenJetEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetEta")
        else:
            self.tGenJetEta_branch.SetAddress(<void*>&self.tGenJetEta_value)

        #print "making tGenJetPt"
        self.tGenJetPt_branch = the_tree.GetBranch("tGenJetPt")
        #if not self.tGenJetPt_branch and "tGenJetPt" not in self.complained:
        if not self.tGenJetPt_branch and "tGenJetPt":
            warnings.warn( "MuTauTree: Expected branch tGenJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenJetPt")
        else:
            self.tGenJetPt_branch.SetAddress(<void*>&self.tGenJetPt_value)

        #print "making tGenMotherEnergy"
        self.tGenMotherEnergy_branch = the_tree.GetBranch("tGenMotherEnergy")
        #if not self.tGenMotherEnergy_branch and "tGenMotherEnergy" not in self.complained:
        if not self.tGenMotherEnergy_branch and "tGenMotherEnergy":
            warnings.warn( "MuTauTree: Expected branch tGenMotherEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEnergy")
        else:
            self.tGenMotherEnergy_branch.SetAddress(<void*>&self.tGenMotherEnergy_value)

        #print "making tGenMotherEta"
        self.tGenMotherEta_branch = the_tree.GetBranch("tGenMotherEta")
        #if not self.tGenMotherEta_branch and "tGenMotherEta" not in self.complained:
        if not self.tGenMotherEta_branch and "tGenMotherEta":
            warnings.warn( "MuTauTree: Expected branch tGenMotherEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherEta")
        else:
            self.tGenMotherEta_branch.SetAddress(<void*>&self.tGenMotherEta_value)

        #print "making tGenMotherPdgId"
        self.tGenMotherPdgId_branch = the_tree.GetBranch("tGenMotherPdgId")
        #if not self.tGenMotherPdgId_branch and "tGenMotherPdgId" not in self.complained:
        if not self.tGenMotherPdgId_branch and "tGenMotherPdgId":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPdgId")
        else:
            self.tGenMotherPdgId_branch.SetAddress(<void*>&self.tGenMotherPdgId_value)

        #print "making tGenMotherPhi"
        self.tGenMotherPhi_branch = the_tree.GetBranch("tGenMotherPhi")
        #if not self.tGenMotherPhi_branch and "tGenMotherPhi" not in self.complained:
        if not self.tGenMotherPhi_branch and "tGenMotherPhi":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPhi")
        else:
            self.tGenMotherPhi_branch.SetAddress(<void*>&self.tGenMotherPhi_value)

        #print "making tGenMotherPt"
        self.tGenMotherPt_branch = the_tree.GetBranch("tGenMotherPt")
        #if not self.tGenMotherPt_branch and "tGenMotherPt" not in self.complained:
        if not self.tGenMotherPt_branch and "tGenMotherPt":
            warnings.warn( "MuTauTree: Expected branch tGenMotherPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenMotherPt")
        else:
            self.tGenMotherPt_branch.SetAddress(<void*>&self.tGenMotherPt_value)

        #print "making tGenPdgId"
        self.tGenPdgId_branch = the_tree.GetBranch("tGenPdgId")
        #if not self.tGenPdgId_branch and "tGenPdgId" not in self.complained:
        if not self.tGenPdgId_branch and "tGenPdgId":
            warnings.warn( "MuTauTree: Expected branch tGenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPdgId")
        else:
            self.tGenPdgId_branch.SetAddress(<void*>&self.tGenPdgId_value)

        #print "making tGenPhi"
        self.tGenPhi_branch = the_tree.GetBranch("tGenPhi")
        #if not self.tGenPhi_branch and "tGenPhi" not in self.complained:
        if not self.tGenPhi_branch and "tGenPhi":
            warnings.warn( "MuTauTree: Expected branch tGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPhi")
        else:
            self.tGenPhi_branch.SetAddress(<void*>&self.tGenPhi_value)

        #print "making tGenPt"
        self.tGenPt_branch = the_tree.GetBranch("tGenPt")
        #if not self.tGenPt_branch and "tGenPt" not in self.complained:
        if not self.tGenPt_branch and "tGenPt":
            warnings.warn( "MuTauTree: Expected branch tGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenPt")
        else:
            self.tGenPt_branch.SetAddress(<void*>&self.tGenPt_value)

        #print "making tGenStatus"
        self.tGenStatus_branch = the_tree.GetBranch("tGenStatus")
        #if not self.tGenStatus_branch and "tGenStatus" not in self.complained:
        if not self.tGenStatus_branch and "tGenStatus":
            warnings.warn( "MuTauTree: Expected branch tGenStatus does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tGenStatus")
        else:
            self.tGenStatus_branch.SetAddress(<void*>&self.tGenStatus_value)

        #print "making tJetArea"
        self.tJetArea_branch = the_tree.GetBranch("tJetArea")
        #if not self.tJetArea_branch and "tJetArea" not in self.complained:
        if not self.tJetArea_branch and "tJetArea":
            warnings.warn( "MuTauTree: Expected branch tJetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetArea")
        else:
            self.tJetArea_branch.SetAddress(<void*>&self.tJetArea_value)

        #print "making tJetBtag"
        self.tJetBtag_branch = the_tree.GetBranch("tJetBtag")
        #if not self.tJetBtag_branch and "tJetBtag" not in self.complained:
        if not self.tJetBtag_branch and "tJetBtag":
            warnings.warn( "MuTauTree: Expected branch tJetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetBtag")
        else:
            self.tJetBtag_branch.SetAddress(<void*>&self.tJetBtag_value)

        #print "making tJetDR"
        self.tJetDR_branch = the_tree.GetBranch("tJetDR")
        #if not self.tJetDR_branch and "tJetDR" not in self.complained:
        if not self.tJetDR_branch and "tJetDR":
            warnings.warn( "MuTauTree: Expected branch tJetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetDR")
        else:
            self.tJetDR_branch.SetAddress(<void*>&self.tJetDR_value)

        #print "making tJetEtaEtaMoment"
        self.tJetEtaEtaMoment_branch = the_tree.GetBranch("tJetEtaEtaMoment")
        #if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment" not in self.complained:
        if not self.tJetEtaEtaMoment_branch and "tJetEtaEtaMoment":
            warnings.warn( "MuTauTree: Expected branch tJetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaEtaMoment")
        else:
            self.tJetEtaEtaMoment_branch.SetAddress(<void*>&self.tJetEtaEtaMoment_value)

        #print "making tJetEtaPhiMoment"
        self.tJetEtaPhiMoment_branch = the_tree.GetBranch("tJetEtaPhiMoment")
        #if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment" not in self.complained:
        if not self.tJetEtaPhiMoment_branch and "tJetEtaPhiMoment":
            warnings.warn( "MuTauTree: Expected branch tJetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiMoment")
        else:
            self.tJetEtaPhiMoment_branch.SetAddress(<void*>&self.tJetEtaPhiMoment_value)

        #print "making tJetEtaPhiSpread"
        self.tJetEtaPhiSpread_branch = the_tree.GetBranch("tJetEtaPhiSpread")
        #if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread" not in self.complained:
        if not self.tJetEtaPhiSpread_branch and "tJetEtaPhiSpread":
            warnings.warn( "MuTauTree: Expected branch tJetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetEtaPhiSpread")
        else:
            self.tJetEtaPhiSpread_branch.SetAddress(<void*>&self.tJetEtaPhiSpread_value)

        #print "making tJetHadronFlavour"
        self.tJetHadronFlavour_branch = the_tree.GetBranch("tJetHadronFlavour")
        #if not self.tJetHadronFlavour_branch and "tJetHadronFlavour" not in self.complained:
        if not self.tJetHadronFlavour_branch and "tJetHadronFlavour":
            warnings.warn( "MuTauTree: Expected branch tJetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetHadronFlavour")
        else:
            self.tJetHadronFlavour_branch.SetAddress(<void*>&self.tJetHadronFlavour_value)

        #print "making tJetPFCISVBtag"
        self.tJetPFCISVBtag_branch = the_tree.GetBranch("tJetPFCISVBtag")
        #if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag" not in self.complained:
        if not self.tJetPFCISVBtag_branch and "tJetPFCISVBtag":
            warnings.warn( "MuTauTree: Expected branch tJetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPFCISVBtag")
        else:
            self.tJetPFCISVBtag_branch.SetAddress(<void*>&self.tJetPFCISVBtag_value)

        #print "making tJetPartonFlavour"
        self.tJetPartonFlavour_branch = the_tree.GetBranch("tJetPartonFlavour")
        #if not self.tJetPartonFlavour_branch and "tJetPartonFlavour" not in self.complained:
        if not self.tJetPartonFlavour_branch and "tJetPartonFlavour":
            warnings.warn( "MuTauTree: Expected branch tJetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPartonFlavour")
        else:
            self.tJetPartonFlavour_branch.SetAddress(<void*>&self.tJetPartonFlavour_value)

        #print "making tJetPhiPhiMoment"
        self.tJetPhiPhiMoment_branch = the_tree.GetBranch("tJetPhiPhiMoment")
        #if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment" not in self.complained:
        if not self.tJetPhiPhiMoment_branch and "tJetPhiPhiMoment":
            warnings.warn( "MuTauTree: Expected branch tJetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPhiPhiMoment")
        else:
            self.tJetPhiPhiMoment_branch.SetAddress(<void*>&self.tJetPhiPhiMoment_value)

        #print "making tJetPt"
        self.tJetPt_branch = the_tree.GetBranch("tJetPt")
        #if not self.tJetPt_branch and "tJetPt" not in self.complained:
        if not self.tJetPt_branch and "tJetPt":
            warnings.warn( "MuTauTree: Expected branch tJetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tJetPt")
        else:
            self.tJetPt_branch.SetAddress(<void*>&self.tJetPt_value)

        #print "making tL1IsoTauMatch"
        self.tL1IsoTauMatch_branch = the_tree.GetBranch("tL1IsoTauMatch")
        #if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch" not in self.complained:
        if not self.tL1IsoTauMatch_branch and "tL1IsoTauMatch":
            warnings.warn( "MuTauTree: Expected branch tL1IsoTauMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauMatch")
        else:
            self.tL1IsoTauMatch_branch.SetAddress(<void*>&self.tL1IsoTauMatch_value)

        #print "making tL1IsoTauPt"
        self.tL1IsoTauPt_branch = the_tree.GetBranch("tL1IsoTauPt")
        #if not self.tL1IsoTauPt_branch and "tL1IsoTauPt" not in self.complained:
        if not self.tL1IsoTauPt_branch and "tL1IsoTauPt":
            warnings.warn( "MuTauTree: Expected branch tL1IsoTauPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tL1IsoTauPt")
        else:
            self.tL1IsoTauPt_branch.SetAddress(<void*>&self.tL1IsoTauPt_value)

        #print "making tLeadTrackPt"
        self.tLeadTrackPt_branch = the_tree.GetBranch("tLeadTrackPt")
        #if not self.tLeadTrackPt_branch and "tLeadTrackPt" not in self.complained:
        if not self.tLeadTrackPt_branch and "tLeadTrackPt":
            warnings.warn( "MuTauTree: Expected branch tLeadTrackPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLeadTrackPt")
        else:
            self.tLeadTrackPt_branch.SetAddress(<void*>&self.tLeadTrackPt_value)

        #print "making tLooseDeepTau2017v1VSe"
        self.tLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSe")
        #if not self.tLooseDeepTau2017v1VSe_branch and "tLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tLooseDeepTau2017v1VSe_branch and "tLooseDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSe")
        else:
            self.tLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSe_value)

        #print "making tLooseDeepTau2017v1VSjet"
        self.tLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSjet")
        #if not self.tLooseDeepTau2017v1VSjet_branch and "tLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tLooseDeepTau2017v1VSjet_branch and "tLooseDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSjet")
        else:
            self.tLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSjet_value)

        #print "making tLooseDeepTau2017v1VSmu"
        self.tLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tLooseDeepTau2017v1VSmu")
        #if not self.tLooseDeepTau2017v1VSmu_branch and "tLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tLooseDeepTau2017v1VSmu_branch and "tLooseDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLooseDeepTau2017v1VSmu")
        else:
            self.tLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tLooseDeepTau2017v1VSmu_value)

        #print "making tLowestMll"
        self.tLowestMll_branch = the_tree.GetBranch("tLowestMll")
        #if not self.tLowestMll_branch and "tLowestMll" not in self.complained:
        if not self.tLowestMll_branch and "tLowestMll":
            warnings.warn( "MuTauTree: Expected branch tLowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tLowestMll")
        else:
            self.tLowestMll_branch.SetAddress(<void*>&self.tLowestMll_value)

        #print "making tMass"
        self.tMass_branch = the_tree.GetBranch("tMass")
        #if not self.tMass_branch and "tMass" not in self.complained:
        if not self.tMass_branch and "tMass":
            warnings.warn( "MuTauTree: Expected branch tMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMass")
        else:
            self.tMass_branch.SetAddress(<void*>&self.tMass_value)

        #print "making tMatchesDoubleMediumCombinedIsoTau35Path"
        self.tMatchesDoubleMediumCombinedIsoTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumCombinedIsoTau35Path")
        #if not self.tMatchesDoubleMediumCombinedIsoTau35Path_branch and "tMatchesDoubleMediumCombinedIsoTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumCombinedIsoTau35Path_branch and "tMatchesDoubleMediumCombinedIsoTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumCombinedIsoTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumCombinedIsoTau35Path")
        else:
            self.tMatchesDoubleMediumCombinedIsoTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumCombinedIsoTau35Path_value)

        #print "making tMatchesDoubleMediumHPSTau35Filter"
        self.tMatchesDoubleMediumHPSTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau35Filter")
        #if not self.tMatchesDoubleMediumHPSTau35Filter_branch and "tMatchesDoubleMediumHPSTau35Filter" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau35Filter_branch and "tMatchesDoubleMediumHPSTau35Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumHPSTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau35Filter")
        else:
            self.tMatchesDoubleMediumHPSTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau35Filter_value)

        #print "making tMatchesDoubleMediumHPSTau35Path"
        self.tMatchesDoubleMediumHPSTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau35Path")
        #if not self.tMatchesDoubleMediumHPSTau35Path_branch and "tMatchesDoubleMediumHPSTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau35Path_branch and "tMatchesDoubleMediumHPSTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumHPSTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau35Path")
        else:
            self.tMatchesDoubleMediumHPSTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau35Path_value)

        #print "making tMatchesDoubleMediumHPSTau40Filter"
        self.tMatchesDoubleMediumHPSTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau40Filter")
        #if not self.tMatchesDoubleMediumHPSTau40Filter_branch and "tMatchesDoubleMediumHPSTau40Filter" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau40Filter_branch and "tMatchesDoubleMediumHPSTau40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumHPSTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau40Filter")
        else:
            self.tMatchesDoubleMediumHPSTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau40Filter_value)

        #print "making tMatchesDoubleMediumHPSTau40Path"
        self.tMatchesDoubleMediumHPSTau40Path_branch = the_tree.GetBranch("tMatchesDoubleMediumHPSTau40Path")
        #if not self.tMatchesDoubleMediumHPSTau40Path_branch and "tMatchesDoubleMediumHPSTau40Path" not in self.complained:
        if not self.tMatchesDoubleMediumHPSTau40Path_branch and "tMatchesDoubleMediumHPSTau40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumHPSTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumHPSTau40Path")
        else:
            self.tMatchesDoubleMediumHPSTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumHPSTau40Path_value)

        #print "making tMatchesDoubleMediumIsoTau35Path"
        self.tMatchesDoubleMediumIsoTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumIsoTau35Path")
        #if not self.tMatchesDoubleMediumIsoTau35Path_branch and "tMatchesDoubleMediumIsoTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumIsoTau35Path_branch and "tMatchesDoubleMediumIsoTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumIsoTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumIsoTau35Path")
        else:
            self.tMatchesDoubleMediumIsoTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumIsoTau35Path_value)

        #print "making tMatchesDoubleMediumTau35Filter"
        self.tMatchesDoubleMediumTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Filter")
        #if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Filter_branch and "tMatchesDoubleMediumTau35Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Filter")
        else:
            self.tMatchesDoubleMediumTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Filter_value)

        #print "making tMatchesDoubleMediumTau35Path"
        self.tMatchesDoubleMediumTau35Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau35Path")
        #if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau35Path_branch and "tMatchesDoubleMediumTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau35Path")
        else:
            self.tMatchesDoubleMediumTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau35Path_value)

        #print "making tMatchesDoubleMediumTau40Filter"
        self.tMatchesDoubleMediumTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Filter")
        #if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Filter_branch and "tMatchesDoubleMediumTau40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Filter")
        else:
            self.tMatchesDoubleMediumTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Filter_value)

        #print "making tMatchesDoubleMediumTau40Path"
        self.tMatchesDoubleMediumTau40Path_branch = the_tree.GetBranch("tMatchesDoubleMediumTau40Path")
        #if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path" not in self.complained:
        if not self.tMatchesDoubleMediumTau40Path_branch and "tMatchesDoubleMediumTau40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleMediumTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleMediumTau40Path")
        else:
            self.tMatchesDoubleMediumTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleMediumTau40Path_value)

        #print "making tMatchesDoubleTightHPSTau35Filter"
        self.tMatchesDoubleTightHPSTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau35Filter")
        #if not self.tMatchesDoubleTightHPSTau35Filter_branch and "tMatchesDoubleTightHPSTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau35Filter_branch and "tMatchesDoubleTightHPSTau35Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightHPSTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau35Filter")
        else:
            self.tMatchesDoubleTightHPSTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau35Filter_value)

        #print "making tMatchesDoubleTightHPSTau35Path"
        self.tMatchesDoubleTightHPSTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau35Path")
        #if not self.tMatchesDoubleTightHPSTau35Path_branch and "tMatchesDoubleTightHPSTau35Path" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau35Path_branch and "tMatchesDoubleTightHPSTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightHPSTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau35Path")
        else:
            self.tMatchesDoubleTightHPSTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau35Path_value)

        #print "making tMatchesDoubleTightHPSTau40Filter"
        self.tMatchesDoubleTightHPSTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau40Filter")
        #if not self.tMatchesDoubleTightHPSTau40Filter_branch and "tMatchesDoubleTightHPSTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau40Filter_branch and "tMatchesDoubleTightHPSTau40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightHPSTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau40Filter")
        else:
            self.tMatchesDoubleTightHPSTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau40Filter_value)

        #print "making tMatchesDoubleTightHPSTau40Path"
        self.tMatchesDoubleTightHPSTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTightHPSTau40Path")
        #if not self.tMatchesDoubleTightHPSTau40Path_branch and "tMatchesDoubleTightHPSTau40Path" not in self.complained:
        if not self.tMatchesDoubleTightHPSTau40Path_branch and "tMatchesDoubleTightHPSTau40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightHPSTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightHPSTau40Path")
        else:
            self.tMatchesDoubleTightHPSTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightHPSTau40Path_value)

        #print "making tMatchesDoubleTightTau35Filter"
        self.tMatchesDoubleTightTau35Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Filter")
        #if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau35Filter_branch and "tMatchesDoubleTightTau35Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightTau35Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Filter")
        else:
            self.tMatchesDoubleTightTau35Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Filter_value)

        #print "making tMatchesDoubleTightTau35Path"
        self.tMatchesDoubleTightTau35Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau35Path")
        #if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path" not in self.complained:
        if not self.tMatchesDoubleTightTau35Path_branch and "tMatchesDoubleTightTau35Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightTau35Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau35Path")
        else:
            self.tMatchesDoubleTightTau35Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau35Path_value)

        #print "making tMatchesDoubleTightTau40Filter"
        self.tMatchesDoubleTightTau40Filter_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Filter")
        #if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter" not in self.complained:
        if not self.tMatchesDoubleTightTau40Filter_branch and "tMatchesDoubleTightTau40Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightTau40Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Filter")
        else:
            self.tMatchesDoubleTightTau40Filter_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Filter_value)

        #print "making tMatchesDoubleTightTau40Path"
        self.tMatchesDoubleTightTau40Path_branch = the_tree.GetBranch("tMatchesDoubleTightTau40Path")
        #if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path" not in self.complained:
        if not self.tMatchesDoubleTightTau40Path_branch and "tMatchesDoubleTightTau40Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesDoubleTightTau40Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesDoubleTightTau40Path")
        else:
            self.tMatchesDoubleTightTau40Path_branch.SetAddress(<void*>&self.tMatchesDoubleTightTau40Path_value)

        #print "making tMatchesEle24HPSTau30Filter"
        self.tMatchesEle24HPSTau30Filter_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Filter")
        #if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter" not in self.complained:
        if not self.tMatchesEle24HPSTau30Filter_branch and "tMatchesEle24HPSTau30Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24HPSTau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Filter")
        else:
            self.tMatchesEle24HPSTau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Filter_value)

        #print "making tMatchesEle24HPSTau30Path"
        self.tMatchesEle24HPSTau30Path_branch = the_tree.GetBranch("tMatchesEle24HPSTau30Path")
        #if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path" not in self.complained:
        if not self.tMatchesEle24HPSTau30Path_branch and "tMatchesEle24HPSTau30Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24HPSTau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24HPSTau30Path")
        else:
            self.tMatchesEle24HPSTau30Path_branch.SetAddress(<void*>&self.tMatchesEle24HPSTau30Path_value)

        #print "making tMatchesEle24Tau30Filter"
        self.tMatchesEle24Tau30Filter_branch = the_tree.GetBranch("tMatchesEle24Tau30Filter")
        #if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter" not in self.complained:
        if not self.tMatchesEle24Tau30Filter_branch and "tMatchesEle24Tau30Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau30Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Filter")
        else:
            self.tMatchesEle24Tau30Filter_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Filter_value)

        #print "making tMatchesEle24Tau30Path"
        self.tMatchesEle24Tau30Path_branch = the_tree.GetBranch("tMatchesEle24Tau30Path")
        #if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path" not in self.complained:
        if not self.tMatchesEle24Tau30Path_branch and "tMatchesEle24Tau30Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesEle24Tau30Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesEle24Tau30Path")
        else:
            self.tMatchesEle24Tau30Path_branch.SetAddress(<void*>&self.tMatchesEle24Tau30Path_value)

        #print "making tMatchesIsoMu19Tau20Filter"
        self.tMatchesIsoMu19Tau20Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Filter")
        #if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Filter_branch and "tMatchesIsoMu19Tau20Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Filter")
        else:
            self.tMatchesIsoMu19Tau20Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Filter_value)

        #print "making tMatchesIsoMu19Tau20Path"
        self.tMatchesIsoMu19Tau20Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20Path")
        #if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20Path_branch and "tMatchesIsoMu19Tau20Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20Path")
        else:
            self.tMatchesIsoMu19Tau20Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20Path_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Filter"
        self.tMatchesIsoMu19Tau20SingleL1Filter_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Filter")
        #if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Filter_branch and "tMatchesIsoMu19Tau20SingleL1Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Filter")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Filter_value)

        #print "making tMatchesIsoMu19Tau20SingleL1Path"
        self.tMatchesIsoMu19Tau20SingleL1Path_branch = the_tree.GetBranch("tMatchesIsoMu19Tau20SingleL1Path")
        #if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path" not in self.complained:
        if not self.tMatchesIsoMu19Tau20SingleL1Path_branch and "tMatchesIsoMu19Tau20SingleL1Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu19Tau20SingleL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu19Tau20SingleL1Path")
        else:
            self.tMatchesIsoMu19Tau20SingleL1Path_branch.SetAddress(<void*>&self.tMatchesIsoMu19Tau20SingleL1Path_value)

        #print "making tMatchesIsoMu20HPSTau27Filter"
        self.tMatchesIsoMu20HPSTau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Filter")
        #if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Filter_branch and "tMatchesIsoMu20HPSTau27Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu20HPSTau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Filter")
        else:
            self.tMatchesIsoMu20HPSTau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Filter_value)

        #print "making tMatchesIsoMu20HPSTau27Path"
        self.tMatchesIsoMu20HPSTau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20HPSTau27Path")
        #if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path" not in self.complained:
        if not self.tMatchesIsoMu20HPSTau27Path_branch and "tMatchesIsoMu20HPSTau27Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu20HPSTau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20HPSTau27Path")
        else:
            self.tMatchesIsoMu20HPSTau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20HPSTau27Path_value)

        #print "making tMatchesIsoMu20Tau27Filter"
        self.tMatchesIsoMu20Tau27Filter_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Filter")
        #if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Filter_branch and "tMatchesIsoMu20Tau27Filter":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu20Tau27Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Filter")
        else:
            self.tMatchesIsoMu20Tau27Filter_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Filter_value)

        #print "making tMatchesIsoMu20Tau27Path"
        self.tMatchesIsoMu20Tau27Path_branch = the_tree.GetBranch("tMatchesIsoMu20Tau27Path")
        #if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path" not in self.complained:
        if not self.tMatchesIsoMu20Tau27Path_branch and "tMatchesIsoMu20Tau27Path":
            warnings.warn( "MuTauTree: Expected branch tMatchesIsoMu20Tau27Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMatchesIsoMu20Tau27Path")
        else:
            self.tMatchesIsoMu20Tau27Path_branch.SetAddress(<void*>&self.tMatchesIsoMu20Tau27Path_value)

        #print "making tMediumDeepTau2017v1VSe"
        self.tMediumDeepTau2017v1VSe_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSe")
        #if not self.tMediumDeepTau2017v1VSe_branch and "tMediumDeepTau2017v1VSe" not in self.complained:
        if not self.tMediumDeepTau2017v1VSe_branch and "tMediumDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tMediumDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSe")
        else:
            self.tMediumDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSe_value)

        #print "making tMediumDeepTau2017v1VSjet"
        self.tMediumDeepTau2017v1VSjet_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSjet")
        #if not self.tMediumDeepTau2017v1VSjet_branch and "tMediumDeepTau2017v1VSjet" not in self.complained:
        if not self.tMediumDeepTau2017v1VSjet_branch and "tMediumDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tMediumDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSjet")
        else:
            self.tMediumDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSjet_value)

        #print "making tMediumDeepTau2017v1VSmu"
        self.tMediumDeepTau2017v1VSmu_branch = the_tree.GetBranch("tMediumDeepTau2017v1VSmu")
        #if not self.tMediumDeepTau2017v1VSmu_branch and "tMediumDeepTau2017v1VSmu" not in self.complained:
        if not self.tMediumDeepTau2017v1VSmu_branch and "tMediumDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tMediumDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tMediumDeepTau2017v1VSmu")
        else:
            self.tMediumDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tMediumDeepTau2017v1VSmu_value)

        #print "making tNChrgHadrIsolationCands"
        self.tNChrgHadrIsolationCands_branch = the_tree.GetBranch("tNChrgHadrIsolationCands")
        #if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands" not in self.complained:
        if not self.tNChrgHadrIsolationCands_branch and "tNChrgHadrIsolationCands":
            warnings.warn( "MuTauTree: Expected branch tNChrgHadrIsolationCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrIsolationCands")
        else:
            self.tNChrgHadrIsolationCands_branch.SetAddress(<void*>&self.tNChrgHadrIsolationCands_value)

        #print "making tNChrgHadrSignalCands"
        self.tNChrgHadrSignalCands_branch = the_tree.GetBranch("tNChrgHadrSignalCands")
        #if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands" not in self.complained:
        if not self.tNChrgHadrSignalCands_branch and "tNChrgHadrSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNChrgHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNChrgHadrSignalCands")
        else:
            self.tNChrgHadrSignalCands_branch.SetAddress(<void*>&self.tNChrgHadrSignalCands_value)

        #print "making tNGammaSignalCands"
        self.tNGammaSignalCands_branch = the_tree.GetBranch("tNGammaSignalCands")
        #if not self.tNGammaSignalCands_branch and "tNGammaSignalCands" not in self.complained:
        if not self.tNGammaSignalCands_branch and "tNGammaSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNGammaSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNGammaSignalCands")
        else:
            self.tNGammaSignalCands_branch.SetAddress(<void*>&self.tNGammaSignalCands_value)

        #print "making tNNeutralHadrSignalCands"
        self.tNNeutralHadrSignalCands_branch = the_tree.GetBranch("tNNeutralHadrSignalCands")
        #if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands" not in self.complained:
        if not self.tNNeutralHadrSignalCands_branch and "tNNeutralHadrSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNNeutralHadrSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNNeutralHadrSignalCands")
        else:
            self.tNNeutralHadrSignalCands_branch.SetAddress(<void*>&self.tNNeutralHadrSignalCands_value)

        #print "making tNSignalCands"
        self.tNSignalCands_branch = the_tree.GetBranch("tNSignalCands")
        #if not self.tNSignalCands_branch and "tNSignalCands" not in self.complained:
        if not self.tNSignalCands_branch and "tNSignalCands":
            warnings.warn( "MuTauTree: Expected branch tNSignalCands does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNSignalCands")
        else:
            self.tNSignalCands_branch.SetAddress(<void*>&self.tNSignalCands_value)

        #print "making tNearestZMass"
        self.tNearestZMass_branch = the_tree.GetBranch("tNearestZMass")
        #if not self.tNearestZMass_branch and "tNearestZMass" not in self.complained:
        if not self.tNearestZMass_branch and "tNearestZMass":
            warnings.warn( "MuTauTree: Expected branch tNearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNearestZMass")
        else:
            self.tNearestZMass_branch.SetAddress(<void*>&self.tNearestZMass_value)

        #print "making tNeutralIsoPtSum"
        self.tNeutralIsoPtSum_branch = the_tree.GetBranch("tNeutralIsoPtSum")
        #if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum" not in self.complained:
        if not self.tNeutralIsoPtSum_branch and "tNeutralIsoPtSum":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSum")
        else:
            self.tNeutralIsoPtSum_branch.SetAddress(<void*>&self.tNeutralIsoPtSum_value)

        #print "making tNeutralIsoPtSumWeight"
        self.tNeutralIsoPtSumWeight_branch = the_tree.GetBranch("tNeutralIsoPtSumWeight")
        #if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight" not in self.complained:
        if not self.tNeutralIsoPtSumWeight_branch and "tNeutralIsoPtSumWeight":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeight")
        else:
            self.tNeutralIsoPtSumWeight_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeight_value)

        #print "making tNeutralIsoPtSumWeightdR03"
        self.tNeutralIsoPtSumWeightdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumWeightdR03")
        #if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03" not in self.complained:
        if not self.tNeutralIsoPtSumWeightdR03_branch and "tNeutralIsoPtSumWeightdR03":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumWeightdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumWeightdR03")
        else:
            self.tNeutralIsoPtSumWeightdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumWeightdR03_value)

        #print "making tNeutralIsoPtSumdR03"
        self.tNeutralIsoPtSumdR03_branch = the_tree.GetBranch("tNeutralIsoPtSumdR03")
        #if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03" not in self.complained:
        if not self.tNeutralIsoPtSumdR03_branch and "tNeutralIsoPtSumdR03":
            warnings.warn( "MuTauTree: Expected branch tNeutralIsoPtSumdR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tNeutralIsoPtSumdR03")
        else:
            self.tNeutralIsoPtSumdR03_branch.SetAddress(<void*>&self.tNeutralIsoPtSumdR03_value)

        #print "making tPVDXY"
        self.tPVDXY_branch = the_tree.GetBranch("tPVDXY")
        #if not self.tPVDXY_branch and "tPVDXY" not in self.complained:
        if not self.tPVDXY_branch and "tPVDXY":
            warnings.warn( "MuTauTree: Expected branch tPVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDXY")
        else:
            self.tPVDXY_branch.SetAddress(<void*>&self.tPVDXY_value)

        #print "making tPVDZ"
        self.tPVDZ_branch = the_tree.GetBranch("tPVDZ")
        #if not self.tPVDZ_branch and "tPVDZ" not in self.complained:
        if not self.tPVDZ_branch and "tPVDZ":
            warnings.warn( "MuTauTree: Expected branch tPVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPVDZ")
        else:
            self.tPVDZ_branch.SetAddress(<void*>&self.tPVDZ_value)

        #print "making tPhi"
        self.tPhi_branch = the_tree.GetBranch("tPhi")
        #if not self.tPhi_branch and "tPhi" not in self.complained:
        if not self.tPhi_branch and "tPhi":
            warnings.warn( "MuTauTree: Expected branch tPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhi")
        else:
            self.tPhi_branch.SetAddress(<void*>&self.tPhi_value)

        #print "making tPhotonPtSumOutsideSignalCone"
        self.tPhotonPtSumOutsideSignalCone_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalCone")
        #if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalCone_branch and "tPhotonPtSumOutsideSignalCone":
            warnings.warn( "MuTauTree: Expected branch tPhotonPtSumOutsideSignalCone does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalCone")
        else:
            self.tPhotonPtSumOutsideSignalCone_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalCone_value)

        #print "making tPhotonPtSumOutsideSignalConedR03"
        self.tPhotonPtSumOutsideSignalConedR03_branch = the_tree.GetBranch("tPhotonPtSumOutsideSignalConedR03")
        #if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03" not in self.complained:
        if not self.tPhotonPtSumOutsideSignalConedR03_branch and "tPhotonPtSumOutsideSignalConedR03":
            warnings.warn( "MuTauTree: Expected branch tPhotonPtSumOutsideSignalConedR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPhotonPtSumOutsideSignalConedR03")
        else:
            self.tPhotonPtSumOutsideSignalConedR03_branch.SetAddress(<void*>&self.tPhotonPtSumOutsideSignalConedR03_value)

        #print "making tPt"
        self.tPt_branch = the_tree.GetBranch("tPt")
        #if not self.tPt_branch and "tPt" not in self.complained:
        if not self.tPt_branch and "tPt":
            warnings.warn( "MuTauTree: Expected branch tPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPt")
        else:
            self.tPt_branch.SetAddress(<void*>&self.tPt_value)

        #print "making tPuCorrPtSum"
        self.tPuCorrPtSum_branch = the_tree.GetBranch("tPuCorrPtSum")
        #if not self.tPuCorrPtSum_branch and "tPuCorrPtSum" not in self.complained:
        if not self.tPuCorrPtSum_branch and "tPuCorrPtSum":
            warnings.warn( "MuTauTree: Expected branch tPuCorrPtSum does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tPuCorrPtSum")
        else:
            self.tPuCorrPtSum_branch.SetAddress(<void*>&self.tPuCorrPtSum_value)

        #print "making tRerunMVArun2v2DBoldDMwLTLoose"
        self.tRerunMVArun2v2DBoldDMwLTLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTLoose_branch and "tRerunMVArun2v2DBoldDMwLTLoose":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTMedium"
        self.tRerunMVArun2v2DBoldDMwLTMedium_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTMedium")
        #if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTMedium_branch and "tRerunMVArun2v2DBoldDMwLTMedium":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTMedium")
        else:
            self.tRerunMVArun2v2DBoldDMwLTMedium_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTMedium_value)

        #print "making tRerunMVArun2v2DBoldDMwLTTight"
        self.tRerunMVArun2v2DBoldDMwLTTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTTight_branch and "tRerunMVArun2v2DBoldDMwLTTight":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVLoose":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVTight"
        self.tRerunMVArun2v2DBoldDMwLTVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVTight_branch and "tRerunMVArun2v2DBoldDMwLTVTight":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVLoose"
        self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVLoose")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch and "tRerunMVArun2v2DBoldDMwLTVVLoose":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVLoose")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVLoose_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVLoose_value)

        #print "making tRerunMVArun2v2DBoldDMwLTVVTight"
        self.tRerunMVArun2v2DBoldDMwLTVVTight_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTVVTight")
        #if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTVVTight_branch and "tRerunMVArun2v2DBoldDMwLTVVTight":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTVVTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTVVTight")
        else:
            self.tRerunMVArun2v2DBoldDMwLTVVTight_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTVVTight_value)

        #print "making tRerunMVArun2v2DBoldDMwLTraw"
        self.tRerunMVArun2v2DBoldDMwLTraw_branch = the_tree.GetBranch("tRerunMVArun2v2DBoldDMwLTraw")
        #if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw" not in self.complained:
        if not self.tRerunMVArun2v2DBoldDMwLTraw_branch and "tRerunMVArun2v2DBoldDMwLTraw":
            warnings.warn( "MuTauTree: Expected branch tRerunMVArun2v2DBoldDMwLTraw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tRerunMVArun2v2DBoldDMwLTraw")
        else:
            self.tRerunMVArun2v2DBoldDMwLTraw_branch.SetAddress(<void*>&self.tRerunMVArun2v2DBoldDMwLTraw_value)

        #print "making tTightDeepTau2017v1VSe"
        self.tTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tTightDeepTau2017v1VSe")
        #if not self.tTightDeepTau2017v1VSe_branch and "tTightDeepTau2017v1VSe" not in self.complained:
        if not self.tTightDeepTau2017v1VSe_branch and "tTightDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSe")
        else:
            self.tTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSe_value)

        #print "making tTightDeepTau2017v1VSjet"
        self.tTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tTightDeepTau2017v1VSjet")
        #if not self.tTightDeepTau2017v1VSjet_branch and "tTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tTightDeepTau2017v1VSjet_branch and "tTightDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSjet")
        else:
            self.tTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSjet_value)

        #print "making tTightDeepTau2017v1VSmu"
        self.tTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tTightDeepTau2017v1VSmu")
        #if not self.tTightDeepTau2017v1VSmu_branch and "tTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tTightDeepTau2017v1VSmu_branch and "tTightDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tTightDeepTau2017v1VSmu")
        else:
            self.tTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tTightDeepTau2017v1VSmu_value)

        #print "making tVLooseDeepTau2017v1VSe"
        self.tVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSe")
        #if not self.tVLooseDeepTau2017v1VSe_branch and "tVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSe_branch and "tVLooseDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSe")
        else:
            self.tVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSe_value)

        #print "making tVLooseDeepTau2017v1VSjet"
        self.tVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSjet")
        #if not self.tVLooseDeepTau2017v1VSjet_branch and "tVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSjet_branch and "tVLooseDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSjet")
        else:
            self.tVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSjet_value)

        #print "making tVLooseDeepTau2017v1VSmu"
        self.tVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVLooseDeepTau2017v1VSmu")
        #if not self.tVLooseDeepTau2017v1VSmu_branch and "tVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVLooseDeepTau2017v1VSmu_branch and "tVLooseDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVLooseDeepTau2017v1VSmu")
        else:
            self.tVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVLooseDeepTau2017v1VSmu_value)

        #print "making tVTightDeepTau2017v1VSe"
        self.tVTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSe")
        #if not self.tVTightDeepTau2017v1VSe_branch and "tVTightDeepTau2017v1VSe" not in self.complained:
        if not self.tVTightDeepTau2017v1VSe_branch and "tVTightDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tVTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSe")
        else:
            self.tVTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSe_value)

        #print "making tVTightDeepTau2017v1VSjet"
        self.tVTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSjet")
        #if not self.tVTightDeepTau2017v1VSjet_branch and "tVTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tVTightDeepTau2017v1VSjet_branch and "tVTightDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tVTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSjet")
        else:
            self.tVTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSjet_value)

        #print "making tVTightDeepTau2017v1VSmu"
        self.tVTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVTightDeepTau2017v1VSmu")
        #if not self.tVTightDeepTau2017v1VSmu_branch and "tVTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tVTightDeepTau2017v1VSmu_branch and "tVTightDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tVTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVTightDeepTau2017v1VSmu")
        else:
            self.tVTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVTightDeepTau2017v1VSmu_value)

        #print "making tVVLooseDeepTau2017v1VSe"
        self.tVVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSe")
        #if not self.tVVLooseDeepTau2017v1VSe_branch and "tVVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSe_branch and "tVVLooseDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tVVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSe")
        else:
            self.tVVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSe_value)

        #print "making tVVLooseDeepTau2017v1VSjet"
        self.tVVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSjet")
        #if not self.tVVLooseDeepTau2017v1VSjet_branch and "tVVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSjet_branch and "tVVLooseDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tVVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSjet")
        else:
            self.tVVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSjet_value)

        #print "making tVVLooseDeepTau2017v1VSmu"
        self.tVVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVLooseDeepTau2017v1VSmu")
        #if not self.tVVLooseDeepTau2017v1VSmu_branch and "tVVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVLooseDeepTau2017v1VSmu_branch and "tVVLooseDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tVVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVLooseDeepTau2017v1VSmu")
        else:
            self.tVVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVLooseDeepTau2017v1VSmu_value)

        #print "making tVVTightDeepTau2017v1VSe"
        self.tVVTightDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSe")
        #if not self.tVVTightDeepTau2017v1VSe_branch and "tVVTightDeepTau2017v1VSe" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSe_branch and "tVVTightDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tVVTightDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSe")
        else:
            self.tVVTightDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSe_value)

        #print "making tVVTightDeepTau2017v1VSjet"
        self.tVVTightDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSjet")
        #if not self.tVVTightDeepTau2017v1VSjet_branch and "tVVTightDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSjet_branch and "tVVTightDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tVVTightDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSjet")
        else:
            self.tVVTightDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSjet_value)

        #print "making tVVTightDeepTau2017v1VSmu"
        self.tVVTightDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVTightDeepTau2017v1VSmu")
        #if not self.tVVTightDeepTau2017v1VSmu_branch and "tVVTightDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVTightDeepTau2017v1VSmu_branch and "tVVTightDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tVVTightDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVTightDeepTau2017v1VSmu")
        else:
            self.tVVTightDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVTightDeepTau2017v1VSmu_value)

        #print "making tVVVLooseDeepTau2017v1VSe"
        self.tVVVLooseDeepTau2017v1VSe_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSe")
        #if not self.tVVVLooseDeepTau2017v1VSe_branch and "tVVVLooseDeepTau2017v1VSe" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSe_branch and "tVVVLooseDeepTau2017v1VSe":
            warnings.warn( "MuTauTree: Expected branch tVVVLooseDeepTau2017v1VSe does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSe")
        else:
            self.tVVVLooseDeepTau2017v1VSe_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSe_value)

        #print "making tVVVLooseDeepTau2017v1VSjet"
        self.tVVVLooseDeepTau2017v1VSjet_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSjet")
        #if not self.tVVVLooseDeepTau2017v1VSjet_branch and "tVVVLooseDeepTau2017v1VSjet" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSjet_branch and "tVVVLooseDeepTau2017v1VSjet":
            warnings.warn( "MuTauTree: Expected branch tVVVLooseDeepTau2017v1VSjet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSjet")
        else:
            self.tVVVLooseDeepTau2017v1VSjet_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSjet_value)

        #print "making tVVVLooseDeepTau2017v1VSmu"
        self.tVVVLooseDeepTau2017v1VSmu_branch = the_tree.GetBranch("tVVVLooseDeepTau2017v1VSmu")
        #if not self.tVVVLooseDeepTau2017v1VSmu_branch and "tVVVLooseDeepTau2017v1VSmu" not in self.complained:
        if not self.tVVVLooseDeepTau2017v1VSmu_branch and "tVVVLooseDeepTau2017v1VSmu":
            warnings.warn( "MuTauTree: Expected branch tVVVLooseDeepTau2017v1VSmu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVVVLooseDeepTau2017v1VSmu")
        else:
            self.tVVVLooseDeepTau2017v1VSmu_branch.SetAddress(<void*>&self.tVVVLooseDeepTau2017v1VSmu_value)

        #print "making tVZ"
        self.tVZ_branch = the_tree.GetBranch("tVZ")
        #if not self.tVZ_branch and "tVZ" not in self.complained:
        if not self.tVZ_branch and "tVZ":
            warnings.warn( "MuTauTree: Expected branch tVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tVZ")
        else:
            self.tVZ_branch.SetAddress(<void*>&self.tVZ_value)

        #print "making tZTTGenDR"
        self.tZTTGenDR_branch = the_tree.GetBranch("tZTTGenDR")
        #if not self.tZTTGenDR_branch and "tZTTGenDR" not in self.complained:
        if not self.tZTTGenDR_branch and "tZTTGenDR":
            warnings.warn( "MuTauTree: Expected branch tZTTGenDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenDR")
        else:
            self.tZTTGenDR_branch.SetAddress(<void*>&self.tZTTGenDR_value)

        #print "making tZTTGenEta"
        self.tZTTGenEta_branch = the_tree.GetBranch("tZTTGenEta")
        #if not self.tZTTGenEta_branch and "tZTTGenEta" not in self.complained:
        if not self.tZTTGenEta_branch and "tZTTGenEta":
            warnings.warn( "MuTauTree: Expected branch tZTTGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenEta")
        else:
            self.tZTTGenEta_branch.SetAddress(<void*>&self.tZTTGenEta_value)

        #print "making tZTTGenMatching"
        self.tZTTGenMatching_branch = the_tree.GetBranch("tZTTGenMatching")
        #if not self.tZTTGenMatching_branch and "tZTTGenMatching" not in self.complained:
        if not self.tZTTGenMatching_branch and "tZTTGenMatching":
            warnings.warn( "MuTauTree: Expected branch tZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenMatching")
        else:
            self.tZTTGenMatching_branch.SetAddress(<void*>&self.tZTTGenMatching_value)

        #print "making tZTTGenPhi"
        self.tZTTGenPhi_branch = the_tree.GetBranch("tZTTGenPhi")
        #if not self.tZTTGenPhi_branch and "tZTTGenPhi" not in self.complained:
        if not self.tZTTGenPhi_branch and "tZTTGenPhi":
            warnings.warn( "MuTauTree: Expected branch tZTTGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPhi")
        else:
            self.tZTTGenPhi_branch.SetAddress(<void*>&self.tZTTGenPhi_value)

        #print "making tZTTGenPt"
        self.tZTTGenPt_branch = the_tree.GetBranch("tZTTGenPt")
        #if not self.tZTTGenPt_branch and "tZTTGenPt" not in self.complained:
        if not self.tZTTGenPt_branch and "tZTTGenPt":
            warnings.warn( "MuTauTree: Expected branch tZTTGenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tZTTGenPt")
        else:
            self.tZTTGenPt_branch.SetAddress(<void*>&self.tZTTGenPt_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20LooseMVALTVtx"
        self.tauVetoPt20LooseMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20LooseMVALTVtx")
        #if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx" not in self.complained:
        if not self.tauVetoPt20LooseMVALTVtx_branch and "tauVetoPt20LooseMVALTVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20LooseMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20LooseMVALTVtx")
        else:
            self.tauVetoPt20LooseMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20LooseMVALTVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuTauTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuTauTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuTauTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuTauTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleMu10_5_5Pass"
        self.tripleMu10_5_5Pass_branch = the_tree.GetBranch("tripleMu10_5_5Pass")
        #if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass" not in self.complained:
        if not self.tripleMu10_5_5Pass_branch and "tripleMu10_5_5Pass":
            warnings.warn( "MuTauTree: Expected branch tripleMu10_5_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu10_5_5Pass")
        else:
            self.tripleMu10_5_5Pass_branch.SetAddress(<void*>&self.tripleMu10_5_5Pass_value)

        #print "making tripleMu12_10_5Pass"
        self.tripleMu12_10_5Pass_branch = the_tree.GetBranch("tripleMu12_10_5Pass")
        #if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass" not in self.complained:
        if not self.tripleMu12_10_5Pass_branch and "tripleMu12_10_5Pass":
            warnings.warn( "MuTauTree: Expected branch tripleMu12_10_5Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMu12_10_5Pass")
        else:
            self.tripleMu12_10_5Pass_branch.SetAddress(<void*>&self.tripleMu12_10_5Pass_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuTauTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuTauTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureDown"
        self.type1_pfMet_shiftedPhi_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureDown")
        #if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureDown_branch and "type1_pfMet_shiftedPhi_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPhi_JetClosureUp"
        self.type1_pfMet_shiftedPhi_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetClosureUp")
        #if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetClosureUp_branch and "type1_pfMet_shiftedPhi_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPhi_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Down"
        self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch and "type1_pfMet_shiftedPhi_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to3Up"
        self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch and "type1_pfMet_shiftedPhi_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Down"
        self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch and "type1_pfMet_shiftedPhi_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta0to5Up"
        self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch and "type1_pfMet_shiftedPhi_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Down"
        self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch and "type1_pfMet_shiftedPhi_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPhi_JetEta3to5Up"
        self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch and "type1_pfMet_shiftedPhi_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPhi_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationDown"
        self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationUp"
        self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalDown"
        self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalUp"
        self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPhi_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalDown"
        self.type1_pfMet_shiftedPhi_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalDown")
        #if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalUp"
        self.type1_pfMet_shiftedPhi_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalUp")
        #if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDDown"
        self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch and "type1_pfMet_shiftedPhi_UesCHARGEDDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPhi_UesCHARGEDUp"
        self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch and "type1_pfMet_shiftedPhi_UesCHARGEDUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPhi_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPhi_UesECALDown"
        self.type1_pfMet_shiftedPhi_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALDown")
        #if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALDown_branch and "type1_pfMet_shiftedPhi_UesECALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesECALUp"
        self.type1_pfMet_shiftedPhi_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesECALUp")
        #if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesECALUp_branch and "type1_pfMet_shiftedPhi_UesECALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesECALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesECALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALDown"
        self.type1_pfMet_shiftedPhi_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALDown")
        #if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALDown_branch and "type1_pfMet_shiftedPhi_UesHCALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHCALUp"
        self.type1_pfMet_shiftedPhi_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHCALUp")
        #if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHCALUp_branch and "type1_pfMet_shiftedPhi_UesHCALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_UesHFDown"
        self.type1_pfMet_shiftedPhi_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFDown")
        #if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFDown_branch and "type1_pfMet_shiftedPhi_UesHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFDown")
        else:
            self.type1_pfMet_shiftedPhi_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFDown_value)

        #print "making type1_pfMet_shiftedPhi_UesHFUp"
        self.type1_pfMet_shiftedPhi_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UesHFUp")
        #if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UesHFUp_branch and "type1_pfMet_shiftedPhi_UesHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UesHFUp")
        else:
            self.type1_pfMet_shiftedPhi_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UesHFUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPt_JetClosureDown"
        self.type1_pfMet_shiftedPt_JetClosureDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureDown")
        #if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureDown_branch and "type1_pfMet_shiftedPt_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureDown")
        else:
            self.type1_pfMet_shiftedPt_JetClosureDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureDown_value)

        #print "making type1_pfMet_shiftedPt_JetClosureUp"
        self.type1_pfMet_shiftedPt_JetClosureUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetClosureUp")
        #if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetClosureUp_branch and "type1_pfMet_shiftedPt_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetClosureUp")
        else:
            self.type1_pfMet_shiftedPt_JetClosureUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetClosureUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Down"
        self.type1_pfMet_shiftedPt_JetEta0to3Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Down_branch and "type1_pfMet_shiftedPt_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to3Up"
        self.type1_pfMet_shiftedPt_JetEta0to3Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to3Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to3Up_branch and "type1_pfMet_shiftedPt_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to3Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to3Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to3Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Down"
        self.type1_pfMet_shiftedPt_JetEta0to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Down_branch and "type1_pfMet_shiftedPt_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta0to5Up"
        self.type1_pfMet_shiftedPt_JetEta0to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta0to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta0to5Up_branch and "type1_pfMet_shiftedPt_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta0to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta0to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta0to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Down"
        self.type1_pfMet_shiftedPt_JetEta3to5Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Down")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Down_branch and "type1_pfMet_shiftedPt_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Down")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Down_value)

        #print "making type1_pfMet_shiftedPt_JetEta3to5Up"
        self.type1_pfMet_shiftedPt_JetEta3to5Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEta3to5Up")
        #if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEta3to5Up_branch and "type1_pfMet_shiftedPt_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEta3to5Up")
        else:
            self.type1_pfMet_shiftedPt_JetEta3to5Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEta3to5Up_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationDown"
        self.type1_pfMet_shiftedPt_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationUp"
        self.type1_pfMet_shiftedPt_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalDown"
        self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalUp"
        self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleDown"
        self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch and "type1_pfMet_shiftedPt_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeSampleUp"
        self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch and "type1_pfMet_shiftedPt_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeSampleUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeSampleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeSampleUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPt_JetTotalDown"
        self.type1_pfMet_shiftedPt_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalDown")
        #if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPt_JetTotalUp"
        self.type1_pfMet_shiftedPt_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalUp")
        #if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDDown"
        self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDDown")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch and "type1_pfMet_shiftedPt_UesCHARGEDDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDDown")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDDown_value)

        #print "making type1_pfMet_shiftedPt_UesCHARGEDUp"
        self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesCHARGEDUp")
        #if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch and "type1_pfMet_shiftedPt_UesCHARGEDUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesCHARGEDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesCHARGEDUp")
        else:
            self.type1_pfMet_shiftedPt_UesCHARGEDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesCHARGEDUp_value)

        #print "making type1_pfMet_shiftedPt_UesECALDown"
        self.type1_pfMet_shiftedPt_UesECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALDown")
        #if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALDown_branch and "type1_pfMet_shiftedPt_UesECALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALDown")
        else:
            self.type1_pfMet_shiftedPt_UesECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALDown_value)

        #print "making type1_pfMet_shiftedPt_UesECALUp"
        self.type1_pfMet_shiftedPt_UesECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesECALUp")
        #if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesECALUp_branch and "type1_pfMet_shiftedPt_UesECALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesECALUp")
        else:
            self.type1_pfMet_shiftedPt_UesECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesECALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHCALDown"
        self.type1_pfMet_shiftedPt_UesHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALDown")
        #if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALDown_branch and "type1_pfMet_shiftedPt_UesHCALDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALDown")
        else:
            self.type1_pfMet_shiftedPt_UesHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALDown_value)

        #print "making type1_pfMet_shiftedPt_UesHCALUp"
        self.type1_pfMet_shiftedPt_UesHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHCALUp")
        #if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHCALUp_branch and "type1_pfMet_shiftedPt_UesHCALUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHCALUp")
        else:
            self.type1_pfMet_shiftedPt_UesHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHCALUp_value)

        #print "making type1_pfMet_shiftedPt_UesHFDown"
        self.type1_pfMet_shiftedPt_UesHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFDown")
        #if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFDown_branch and "type1_pfMet_shiftedPt_UesHFDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFDown")
        else:
            self.type1_pfMet_shiftedPt_UesHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFDown_value)

        #print "making type1_pfMet_shiftedPt_UesHFUp"
        self.type1_pfMet_shiftedPt_UesHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UesHFUp")
        #if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UesHFUp_branch and "type1_pfMet_shiftedPt_UesHFUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UesHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UesHFUp")
        else:
            self.type1_pfMet_shiftedPt_UesHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UesHFUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "MuTauTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuTauTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuTauTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuTauTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMassWoNoisyJets"
        self.vbfMassWoNoisyJets_branch = the_tree.GetBranch("vbfMassWoNoisyJets")
        #if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets" not in self.complained:
        if not self.vbfMassWoNoisyJets_branch and "vbfMassWoNoisyJets":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets")
        else:
            self.vbfMassWoNoisyJets_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteFlavMapDown"
        self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteFlavMapDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteFlavMapDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteFlavMapDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteFlavMapUp"
        self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteFlavMapUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch and "vbfMassWoNoisyJets_JetAbsoluteFlavMapUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteFlavMapUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteFlavMapUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown"
        self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp"
        self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch and "vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteScaleDown"
        self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteScaleDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteScaleDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteScaleDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteScaleUp"
        self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteScaleUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch and "vbfMassWoNoisyJets_JetAbsoluteScaleUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteScaleUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteScaleUp_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteStatDown"
        self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteStatDown")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch and "vbfMassWoNoisyJets_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch and "vbfMassWoNoisyJets_JetAbsoluteStatDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteStatDown")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteStatDown_value)

        #print "making vbfMassWoNoisyJets_JetAbsoluteStatUp"
        self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetAbsoluteStatUp")
        #if not self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch and "vbfMassWoNoisyJets_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch and "vbfMassWoNoisyJets_JetAbsoluteStatUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetAbsoluteStatUp")
        else:
            self.vbfMassWoNoisyJets_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetAbsoluteStatUp_value)

        #print "making vbfMassWoNoisyJets_JetClosureDown"
        self.vbfMassWoNoisyJets_JetClosureDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetClosureDown")
        #if not self.vbfMassWoNoisyJets_JetClosureDown_branch and "vbfMassWoNoisyJets_JetClosureDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetClosureDown_branch and "vbfMassWoNoisyJets_JetClosureDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetClosureDown")
        else:
            self.vbfMassWoNoisyJets_JetClosureDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetClosureDown_value)

        #print "making vbfMassWoNoisyJets_JetClosureUp"
        self.vbfMassWoNoisyJets_JetClosureUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetClosureUp")
        #if not self.vbfMassWoNoisyJets_JetClosureUp_branch and "vbfMassWoNoisyJets_JetClosureUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetClosureUp_branch and "vbfMassWoNoisyJets_JetClosureUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetClosureUp")
        else:
            self.vbfMassWoNoisyJets_JetClosureUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetClosureUp_value)

        #print "making vbfMassWoNoisyJets_JetEC2Down"
        self.vbfMassWoNoisyJets_JetEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Down")
        #if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Down_branch and "vbfMassWoNoisyJets_JetEC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetEC2Up"
        self.vbfMassWoNoisyJets_JetEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEC2Up")
        #if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEC2Up_branch and "vbfMassWoNoisyJets_JetEC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Down"
        self.vbfMassWoNoisyJets_JetEta0to3Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Down_branch and "vbfMassWoNoisyJets_JetEta0to3Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to3Up"
        self.vbfMassWoNoisyJets_JetEta0to3Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to3Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to3Up_branch and "vbfMassWoNoisyJets_JetEta0to3Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta0to3Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to3Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to3Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to3Up_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Down"
        self.vbfMassWoNoisyJets_JetEta0to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Down_branch and "vbfMassWoNoisyJets_JetEta0to5Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta0to5Up"
        self.vbfMassWoNoisyJets_JetEta0to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta0to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta0to5Up_branch and "vbfMassWoNoisyJets_JetEta0to5Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta0to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta0to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta0to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta0to5Up_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Down"
        self.vbfMassWoNoisyJets_JetEta3to5Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Down")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Down_branch and "vbfMassWoNoisyJets_JetEta3to5Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Down")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Down_value)

        #print "making vbfMassWoNoisyJets_JetEta3to5Up"
        self.vbfMassWoNoisyJets_JetEta3to5Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetEta3to5Up")
        #if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetEta3to5Up_branch and "vbfMassWoNoisyJets_JetEta3to5Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetEta3to5Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetEta3to5Up")
        else:
            self.vbfMassWoNoisyJets_JetEta3to5Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetEta3to5Up_value)

        #print "making vbfMassWoNoisyJets_JetFlavorQCDDown"
        self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFlavorQCDDown")
        #if not self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch and "vbfMassWoNoisyJets_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch and "vbfMassWoNoisyJets_JetFlavorQCDDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFlavorQCDDown")
        else:
            self.vbfMassWoNoisyJets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFlavorQCDDown_value)

        #print "making vbfMassWoNoisyJets_JetFlavorQCDUp"
        self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFlavorQCDUp")
        #if not self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch and "vbfMassWoNoisyJets_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch and "vbfMassWoNoisyJets_JetFlavorQCDUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFlavorQCDUp")
        else:
            self.vbfMassWoNoisyJets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFlavorQCDUp_value)

        #print "making vbfMassWoNoisyJets_JetFragmentationDown"
        self.vbfMassWoNoisyJets_JetFragmentationDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFragmentationDown")
        #if not self.vbfMassWoNoisyJets_JetFragmentationDown_branch and "vbfMassWoNoisyJets_JetFragmentationDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFragmentationDown_branch and "vbfMassWoNoisyJets_JetFragmentationDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFragmentationDown")
        else:
            self.vbfMassWoNoisyJets_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFragmentationDown_value)

        #print "making vbfMassWoNoisyJets_JetFragmentationUp"
        self.vbfMassWoNoisyJets_JetFragmentationUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetFragmentationUp")
        #if not self.vbfMassWoNoisyJets_JetFragmentationUp_branch and "vbfMassWoNoisyJets_JetFragmentationUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetFragmentationUp_branch and "vbfMassWoNoisyJets_JetFragmentationUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetFragmentationUp")
        else:
            self.vbfMassWoNoisyJets_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetFragmentationUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpDataMCDown"
        self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpDataMCDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch and "vbfMassWoNoisyJets_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch and "vbfMassWoNoisyJets_JetPileUpDataMCDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpDataMCDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpDataMCDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpDataMCUp"
        self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpDataMCUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch and "vbfMassWoNoisyJets_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch and "vbfMassWoNoisyJets_JetPileUpDataMCUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpDataMCUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpDataMCUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtBBDown"
        self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtBBDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch and "vbfMassWoNoisyJets_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch and "vbfMassWoNoisyJets_JetPileUpPtBBDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtBBDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtBBDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtBBUp"
        self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtBBUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch and "vbfMassWoNoisyJets_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch and "vbfMassWoNoisyJets_JetPileUpPtBBUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtBBUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtBBUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC1Down"
        self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC1Down")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC1Down")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC1Down_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC1Up"
        self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC1Up")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC1Up")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC1Up_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC2Down"
        self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC2Down")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtEC2Up"
        self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtEC2Up")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch and "vbfMassWoNoisyJets_JetPileUpPtEC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtHFDown"
        self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtHFDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch and "vbfMassWoNoisyJets_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch and "vbfMassWoNoisyJets_JetPileUpPtHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtHFDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtHFDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtHFUp"
        self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtHFUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch and "vbfMassWoNoisyJets_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch and "vbfMassWoNoisyJets_JetPileUpPtHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtHFUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtHFUp_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtRefDown"
        self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtRefDown")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch and "vbfMassWoNoisyJets_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch and "vbfMassWoNoisyJets_JetPileUpPtRefDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtRefDown")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtRefDown_value)

        #print "making vbfMassWoNoisyJets_JetPileUpPtRefUp"
        self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetPileUpPtRefUp")
        #if not self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch and "vbfMassWoNoisyJets_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch and "vbfMassWoNoisyJets_JetPileUpPtRefUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetPileUpPtRefUp")
        else:
            self.vbfMassWoNoisyJets_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetPileUpPtRefUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalDown"
        self.vbfMassWoNoisyJets_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalDown_branch and "vbfMassWoNoisyJets_JetRelativeBalDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeBalUp"
        self.vbfMassWoNoisyJets_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeBalUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeBalUp_branch and "vbfMassWoNoisyJets_JetRelativeBalUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeBalUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeBalUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeFSRDown"
        self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeFSRDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeFSRDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeFSRDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeFSRDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeFSRUp"
        self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeFSRUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeFSRUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeFSRUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeFSRUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC1Down"
        self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC1Down")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC1Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC1Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC1Up"
        self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC1Up")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC1Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC1Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC2Down"
        self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC2Down")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC2Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC2Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJEREC2Up"
        self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJEREC2Up")
        #if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch and "vbfMassWoNoisyJets_JetRelativeJEREC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJEREC2Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJEREC2Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJERHFDown"
        self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJERHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch and "vbfMassWoNoisyJets_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch and "vbfMassWoNoisyJets_JetRelativeJERHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJERHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJERHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeJERHFUp"
        self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeJERHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch and "vbfMassWoNoisyJets_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch and "vbfMassWoNoisyJets_JetRelativeJERHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeJERHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeJERHFUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtBBDown"
        self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtBBDown")
        #if not self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch and "vbfMassWoNoisyJets_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch and "vbfMassWoNoisyJets_JetRelativePtBBDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtBBDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtBBDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtBBUp"
        self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtBBUp")
        #if not self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch and "vbfMassWoNoisyJets_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch and "vbfMassWoNoisyJets_JetRelativePtBBUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtBBUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtBBUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC1Down"
        self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC1Down")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC1Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC1Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC1Up"
        self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC1Up")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC1Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC1Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC1Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC2Down"
        self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC2Down")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Down":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC2Down")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC2Down_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtEC2Up"
        self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtEC2Up")
        #if not self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch and "vbfMassWoNoisyJets_JetRelativePtEC2Up":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtEC2Up")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtEC2Up_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtHFDown"
        self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch and "vbfMassWoNoisyJets_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch and "vbfMassWoNoisyJets_JetRelativePtHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativePtHFUp"
        self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativePtHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch and "vbfMassWoNoisyJets_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch and "vbfMassWoNoisyJets_JetRelativePtHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativePtHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativePtHFUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleDown"
        self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch and "vbfMassWoNoisyJets_JetRelativeSampleDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeSampleUp"
        self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeSampleUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch and "vbfMassWoNoisyJets_JetRelativeSampleUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeSampleUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeSampleUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatECDown"
        self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatECDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch and "vbfMassWoNoisyJets_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch and "vbfMassWoNoisyJets_JetRelativeStatECDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatECDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatECDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatECUp"
        self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatECUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch and "vbfMassWoNoisyJets_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch and "vbfMassWoNoisyJets_JetRelativeStatECUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatECUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatECUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatFSRDown"
        self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatFSRDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatFSRDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatFSRDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatFSRUp"
        self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatFSRUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch and "vbfMassWoNoisyJets_JetRelativeStatFSRUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatFSRUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatFSRUp_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatHFDown"
        self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatHFDown")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch and "vbfMassWoNoisyJets_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch and "vbfMassWoNoisyJets_JetRelativeStatHFDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatHFDown")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatHFDown_value)

        #print "making vbfMassWoNoisyJets_JetRelativeStatHFUp"
        self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetRelativeStatHFUp")
        #if not self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch and "vbfMassWoNoisyJets_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch and "vbfMassWoNoisyJets_JetRelativeStatHFUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetRelativeStatHFUp")
        else:
            self.vbfMassWoNoisyJets_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetRelativeStatHFUp_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionECALDown"
        self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionECALDown")
        #if not self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch and "vbfMassWoNoisyJets_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch and "vbfMassWoNoisyJets_JetSinglePionECALDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionECALDown")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionECALDown_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionECALUp"
        self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionECALUp")
        #if not self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch and "vbfMassWoNoisyJets_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch and "vbfMassWoNoisyJets_JetSinglePionECALUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionECALUp")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionECALUp_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionHCALDown"
        self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionHCALDown")
        #if not self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch and "vbfMassWoNoisyJets_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch and "vbfMassWoNoisyJets_JetSinglePionHCALDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionHCALDown")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionHCALDown_value)

        #print "making vbfMassWoNoisyJets_JetSinglePionHCALUp"
        self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetSinglePionHCALUp")
        #if not self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch and "vbfMassWoNoisyJets_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch and "vbfMassWoNoisyJets_JetSinglePionHCALUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetSinglePionHCALUp")
        else:
            self.vbfMassWoNoisyJets_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetSinglePionHCALUp_value)

        #print "making vbfMassWoNoisyJets_JetTimePtEtaDown"
        self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTimePtEtaDown")
        #if not self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch and "vbfMassWoNoisyJets_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch and "vbfMassWoNoisyJets_JetTimePtEtaDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTimePtEtaDown")
        else:
            self.vbfMassWoNoisyJets_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTimePtEtaDown_value)

        #print "making vbfMassWoNoisyJets_JetTimePtEtaUp"
        self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTimePtEtaUp")
        #if not self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch and "vbfMassWoNoisyJets_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch and "vbfMassWoNoisyJets_JetTimePtEtaUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTimePtEtaUp")
        else:
            self.vbfMassWoNoisyJets_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTimePtEtaUp_value)

        #print "making vbfMassWoNoisyJets_JetTotalDown"
        self.vbfMassWoNoisyJets_JetTotalDown_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalDown")
        #if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalDown_branch and "vbfMassWoNoisyJets_JetTotalDown":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalDown")
        else:
            self.vbfMassWoNoisyJets_JetTotalDown_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalDown_value)

        #print "making vbfMassWoNoisyJets_JetTotalUp"
        self.vbfMassWoNoisyJets_JetTotalUp_branch = the_tree.GetBranch("vbfMassWoNoisyJets_JetTotalUp")
        #if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp" not in self.complained:
        if not self.vbfMassWoNoisyJets_JetTotalUp_branch and "vbfMassWoNoisyJets_JetTotalUp":
            warnings.warn( "MuTauTree: Expected branch vbfMassWoNoisyJets_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMassWoNoisyJets_JetTotalUp")
        else:
            self.vbfMassWoNoisyJets_JetTotalUp_branch.SetAddress(<void*>&self.vbfMassWoNoisyJets_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuTauTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuTauTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuTauTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuTauTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuTauTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuTauTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuTauTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuTauTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuTauTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property jetVeto30WoNoisyJets_JetEnDown:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnDown_value

    property jetVeto30WoNoisyJets_JetEnUp:
        def __get__(self):
            self.jetVeto30WoNoisyJets_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30WoNoisyJets_JetEnUp_value

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

    property mBestTrackType:
        def __get__(self):
            self.mBestTrackType_branch.GetEntry(self.localentry, 0)
            return self.mBestTrackType_value

    property mCharge:
        def __get__(self):
            self.mCharge_branch.GetEntry(self.localentry, 0)
            return self.mCharge_value

    property mChi2LocalPosition:
        def __get__(self):
            self.mChi2LocalPosition_branch.GetEntry(self.localentry, 0)
            return self.mChi2LocalPosition_value

    property mComesFromHiggs:
        def __get__(self):
            self.mComesFromHiggs_branch.GetEntry(self.localentry, 0)
            return self.mComesFromHiggs_value

    property mCutBasedIdGlobalHighPt:
        def __get__(self):
            self.mCutBasedIdGlobalHighPt_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdGlobalHighPt_value

    property mCutBasedIdLoose:
        def __get__(self):
            self.mCutBasedIdLoose_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdLoose_value

    property mCutBasedIdMedium:
        def __get__(self):
            self.mCutBasedIdMedium_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdMedium_value

    property mCutBasedIdMediumPrompt:
        def __get__(self):
            self.mCutBasedIdMediumPrompt_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdMediumPrompt_value

    property mCutBasedIdTight:
        def __get__(self):
            self.mCutBasedIdTight_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdTight_value

    property mCutBasedIdTrkHighPt:
        def __get__(self):
            self.mCutBasedIdTrkHighPt_branch.GetEntry(self.localentry, 0)
            return self.mCutBasedIdTrkHighPt_value

    property mEcalIsoDR03:
        def __get__(self):
            self.mEcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mEcalIsoDR03_value

    property mEffectiveArea2011:
        def __get__(self):
            self.mEffectiveArea2011_branch.GetEntry(self.localentry, 0)
            return self.mEffectiveArea2011_value

    property mEffectiveArea2012:
        def __get__(self):
            self.mEffectiveArea2012_branch.GetEntry(self.localentry, 0)
            return self.mEffectiveArea2012_value

    property mEta:
        def __get__(self):
            self.mEta_branch.GetEntry(self.localentry, 0)
            return self.mEta_value

    property mEta_MuonEnDown:
        def __get__(self):
            self.mEta_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mEta_MuonEnDown_value

    property mEta_MuonEnUp:
        def __get__(self):
            self.mEta_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mEta_MuonEnUp_value

    property mGenCharge:
        def __get__(self):
            self.mGenCharge_branch.GetEntry(self.localentry, 0)
            return self.mGenCharge_value

    property mGenDirectPromptTauDecayFinalState:
        def __get__(self):
            self.mGenDirectPromptTauDecayFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenDirectPromptTauDecayFinalState_value

    property mGenEnergy:
        def __get__(self):
            self.mGenEnergy_branch.GetEntry(self.localentry, 0)
            return self.mGenEnergy_value

    property mGenEta:
        def __get__(self):
            self.mGenEta_branch.GetEntry(self.localentry, 0)
            return self.mGenEta_value

    property mGenIsPrompt:
        def __get__(self):
            self.mGenIsPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenIsPrompt_value

    property mGenMotherPdgId:
        def __get__(self):
            self.mGenMotherPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenMotherPdgId_value

    property mGenParticle:
        def __get__(self):
            self.mGenParticle_branch.GetEntry(self.localentry, 0)
            return self.mGenParticle_value

    property mGenPdgId:
        def __get__(self):
            self.mGenPdgId_branch.GetEntry(self.localentry, 0)
            return self.mGenPdgId_value

    property mGenPhi:
        def __get__(self):
            self.mGenPhi_branch.GetEntry(self.localentry, 0)
            return self.mGenPhi_value

    property mGenPrompt:
        def __get__(self):
            self.mGenPrompt_branch.GetEntry(self.localentry, 0)
            return self.mGenPrompt_value

    property mGenPromptFinalState:
        def __get__(self):
            self.mGenPromptFinalState_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptFinalState_value

    property mGenPromptTauDecay:
        def __get__(self):
            self.mGenPromptTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenPromptTauDecay_value

    property mGenPt:
        def __get__(self):
            self.mGenPt_branch.GetEntry(self.localentry, 0)
            return self.mGenPt_value

    property mGenTauDecay:
        def __get__(self):
            self.mGenTauDecay_branch.GetEntry(self.localentry, 0)
            return self.mGenTauDecay_value

    property mGenVZ:
        def __get__(self):
            self.mGenVZ_branch.GetEntry(self.localentry, 0)
            return self.mGenVZ_value

    property mGenVtxPVMatch:
        def __get__(self):
            self.mGenVtxPVMatch_branch.GetEntry(self.localentry, 0)
            return self.mGenVtxPVMatch_value

    property mHcalIsoDR03:
        def __get__(self):
            self.mHcalIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mHcalIsoDR03_value

    property mIP3D:
        def __get__(self):
            self.mIP3D_branch.GetEntry(self.localentry, 0)
            return self.mIP3D_value

    property mIP3DErr:
        def __get__(self):
            self.mIP3DErr_branch.GetEntry(self.localentry, 0)
            return self.mIP3DErr_value

    property mIsGlobal:
        def __get__(self):
            self.mIsGlobal_branch.GetEntry(self.localentry, 0)
            return self.mIsGlobal_value

    property mIsPFMuon:
        def __get__(self):
            self.mIsPFMuon_branch.GetEntry(self.localentry, 0)
            return self.mIsPFMuon_value

    property mIsTracker:
        def __get__(self):
            self.mIsTracker_branch.GetEntry(self.localentry, 0)
            return self.mIsTracker_value

    property mIsoDB03:
        def __get__(self):
            self.mIsoDB03_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB03_value

    property mIsoDB04:
        def __get__(self):
            self.mIsoDB04_branch.GetEntry(self.localentry, 0)
            return self.mIsoDB04_value

    property mJetArea:
        def __get__(self):
            self.mJetArea_branch.GetEntry(self.localentry, 0)
            return self.mJetArea_value

    property mJetBtag:
        def __get__(self):
            self.mJetBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetBtag_value

    property mJetDR:
        def __get__(self):
            self.mJetDR_branch.GetEntry(self.localentry, 0)
            return self.mJetDR_value

    property mJetEtaEtaMoment:
        def __get__(self):
            self.mJetEtaEtaMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaEtaMoment_value

    property mJetEtaPhiMoment:
        def __get__(self):
            self.mJetEtaPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiMoment_value

    property mJetEtaPhiSpread:
        def __get__(self):
            self.mJetEtaPhiSpread_branch.GetEntry(self.localentry, 0)
            return self.mJetEtaPhiSpread_value

    property mJetHadronFlavour:
        def __get__(self):
            self.mJetHadronFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetHadronFlavour_value

    property mJetPFCISVBtag:
        def __get__(self):
            self.mJetPFCISVBtag_branch.GetEntry(self.localentry, 0)
            return self.mJetPFCISVBtag_value

    property mJetPartonFlavour:
        def __get__(self):
            self.mJetPartonFlavour_branch.GetEntry(self.localentry, 0)
            return self.mJetPartonFlavour_value

    property mJetPhiPhiMoment:
        def __get__(self):
            self.mJetPhiPhiMoment_branch.GetEntry(self.localentry, 0)
            return self.mJetPhiPhiMoment_value

    property mJetPt:
        def __get__(self):
            self.mJetPt_branch.GetEntry(self.localentry, 0)
            return self.mJetPt_value

    property mLowestMll:
        def __get__(self):
            self.mLowestMll_branch.GetEntry(self.localentry, 0)
            return self.mLowestMll_value

    property mMass:
        def __get__(self):
            self.mMass_branch.GetEntry(self.localentry, 0)
            return self.mMass_value

    property mMatchedStations:
        def __get__(self):
            self.mMatchedStations_branch.GetEntry(self.localentry, 0)
            return self.mMatchedStations_value

    property mMatchesIsoMu19Tau20Filter:
        def __get__(self):
            self.mMatchesIsoMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20Filter_value

    property mMatchesIsoMu19Tau20Path:
        def __get__(self):
            self.mMatchesIsoMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20Path_value

    property mMatchesIsoMu19Tau20SingleL1Filter:
        def __get__(self):
            self.mMatchesIsoMu19Tau20SingleL1Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20SingleL1Filter_value

    property mMatchesIsoMu19Tau20SingleL1Path:
        def __get__(self):
            self.mMatchesIsoMu19Tau20SingleL1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu19Tau20SingleL1Path_value

    property mMatchesIsoMu20HPSTau27Filter:
        def __get__(self):
            self.mMatchesIsoMu20HPSTau27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20HPSTau27Filter_value

    property mMatchesIsoMu20HPSTau27Path:
        def __get__(self):
            self.mMatchesIsoMu20HPSTau27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20HPSTau27Path_value

    property mMatchesIsoMu20Tau27Filter:
        def __get__(self):
            self.mMatchesIsoMu20Tau27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20Tau27Filter_value

    property mMatchesIsoMu20Tau27Path:
        def __get__(self):
            self.mMatchesIsoMu20Tau27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu20Tau27Path_value

    property mMatchesIsoMu22Filter:
        def __get__(self):
            self.mMatchesIsoMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22Filter_value

    property mMatchesIsoMu22Path:
        def __get__(self):
            self.mMatchesIsoMu22Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22Path_value

    property mMatchesIsoMu22eta2p1Filter:
        def __get__(self):
            self.mMatchesIsoMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22eta2p1Filter_value

    property mMatchesIsoMu22eta2p1Path:
        def __get__(self):
            self.mMatchesIsoMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu22eta2p1Path_value

    property mMatchesIsoMu24Filter:
        def __get__(self):
            self.mMatchesIsoMu24Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24Filter_value

    property mMatchesIsoMu24Path:
        def __get__(self):
            self.mMatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu24Path_value

    property mMatchesIsoMu27Filter:
        def __get__(self):
            self.mMatchesIsoMu27Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu27Filter_value

    property mMatchesIsoMu27Path:
        def __get__(self):
            self.mMatchesIsoMu27Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoMu27Path_value

    property mMatchesIsoTkMu22Filter:
        def __get__(self):
            self.mMatchesIsoTkMu22Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22Filter_value

    property mMatchesIsoTkMu22Path:
        def __get__(self):
            self.mMatchesIsoTkMu22Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22Path_value

    property mMatchesIsoTkMu22eta2p1Filter:
        def __get__(self):
            self.mMatchesIsoTkMu22eta2p1Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22eta2p1Filter_value

    property mMatchesIsoTkMu22eta2p1Path:
        def __get__(self):
            self.mMatchesIsoTkMu22eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesIsoTkMu22eta2p1Path_value

    property mMatchesMu23e12DZFilter:
        def __get__(self):
            self.mMatchesMu23e12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12DZFilter_value

    property mMatchesMu23e12DZPath:
        def __get__(self):
            self.mMatchesMu23e12DZPath_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12DZPath_value

    property mMatchesMu23e12Filter:
        def __get__(self):
            self.mMatchesMu23e12Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12Filter_value

    property mMatchesMu23e12Path:
        def __get__(self):
            self.mMatchesMu23e12Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu23e12Path_value

    property mMatchesMu8e23DZFilter:
        def __get__(self):
            self.mMatchesMu8e23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23DZFilter_value

    property mMatchesMu8e23DZPath:
        def __get__(self):
            self.mMatchesMu8e23DZPath_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23DZPath_value

    property mMatchesMu8e23Filter:
        def __get__(self):
            self.mMatchesMu8e23Filter_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23Filter_value

    property mMatchesMu8e23Path:
        def __get__(self):
            self.mMatchesMu8e23Path_branch.GetEntry(self.localentry, 0)
            return self.mMatchesMu8e23Path_value

    property mMiniIsoLoose:
        def __get__(self):
            self.mMiniIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoLoose_value

    property mMiniIsoMedium:
        def __get__(self):
            self.mMiniIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoMedium_value

    property mMiniIsoTight:
        def __get__(self):
            self.mMiniIsoTight_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoTight_value

    property mMiniIsoVeryTight:
        def __get__(self):
            self.mMiniIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.mMiniIsoVeryTight_value

    property mMuonHits:
        def __get__(self):
            self.mMuonHits_branch.GetEntry(self.localentry, 0)
            return self.mMuonHits_value

    property mMvaLoose:
        def __get__(self):
            self.mMvaLoose_branch.GetEntry(self.localentry, 0)
            return self.mMvaLoose_value

    property mMvaMedium:
        def __get__(self):
            self.mMvaMedium_branch.GetEntry(self.localentry, 0)
            return self.mMvaMedium_value

    property mMvaTight:
        def __get__(self):
            self.mMvaTight_branch.GetEntry(self.localentry, 0)
            return self.mMvaTight_value

    property mNearestZMass:
        def __get__(self):
            self.mNearestZMass_branch.GetEntry(self.localentry, 0)
            return self.mNearestZMass_value

    property mNormTrkChi2:
        def __get__(self):
            self.mNormTrkChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormTrkChi2_value

    property mNormalizedChi2:
        def __get__(self):
            self.mNormalizedChi2_branch.GetEntry(self.localentry, 0)
            return self.mNormalizedChi2_value

    property mPFChargedHadronIsoR04:
        def __get__(self):
            self.mPFChargedHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedHadronIsoR04_value

    property mPFChargedIso:
        def __get__(self):
            self.mPFChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFChargedIso_value

    property mPFIDLoose:
        def __get__(self):
            self.mPFIDLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIDLoose_value

    property mPFIDMedium:
        def __get__(self):
            self.mPFIDMedium_branch.GetEntry(self.localentry, 0)
            return self.mPFIDMedium_value

    property mPFIDTight:
        def __get__(self):
            self.mPFIDTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIDTight_value

    property mPFIsoLoose:
        def __get__(self):
            self.mPFIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoLoose_value

    property mPFIsoMedium:
        def __get__(self):
            self.mPFIsoMedium_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoMedium_value

    property mPFIsoTight:
        def __get__(self):
            self.mPFIsoTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoTight_value

    property mPFIsoVeryLoose:
        def __get__(self):
            self.mPFIsoVeryLoose_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoVeryLoose_value

    property mPFIsoVeryTight:
        def __get__(self):
            self.mPFIsoVeryTight_branch.GetEntry(self.localentry, 0)
            return self.mPFIsoVeryTight_value

    property mPFNeutralHadronIsoR04:
        def __get__(self):
            self.mPFNeutralHadronIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralHadronIsoR04_value

    property mPFNeutralIso:
        def __get__(self):
            self.mPFNeutralIso_branch.GetEntry(self.localentry, 0)
            return self.mPFNeutralIso_value

    property mPFPUChargedIso:
        def __get__(self):
            self.mPFPUChargedIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPUChargedIso_value

    property mPFPhotonIso:
        def __get__(self):
            self.mPFPhotonIso_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIso_value

    property mPFPhotonIsoR04:
        def __get__(self):
            self.mPFPhotonIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPhotonIsoR04_value

    property mPFPileupIsoR04:
        def __get__(self):
            self.mPFPileupIsoR04_branch.GetEntry(self.localentry, 0)
            return self.mPFPileupIsoR04_value

    property mPVDXY:
        def __get__(self):
            self.mPVDXY_branch.GetEntry(self.localentry, 0)
            return self.mPVDXY_value

    property mPVDZ:
        def __get__(self):
            self.mPVDZ_branch.GetEntry(self.localentry, 0)
            return self.mPVDZ_value

    property mPhi:
        def __get__(self):
            self.mPhi_branch.GetEntry(self.localentry, 0)
            return self.mPhi_value

    property mPhi_MuonEnDown:
        def __get__(self):
            self.mPhi_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mPhi_MuonEnDown_value

    property mPhi_MuonEnUp:
        def __get__(self):
            self.mPhi_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mPhi_MuonEnUp_value

    property mPixHits:
        def __get__(self):
            self.mPixHits_branch.GetEntry(self.localentry, 0)
            return self.mPixHits_value

    property mPt:
        def __get__(self):
            self.mPt_branch.GetEntry(self.localentry, 0)
            return self.mPt_value

    property mPt_MuonEnDown:
        def __get__(self):
            self.mPt_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.mPt_MuonEnDown_value

    property mPt_MuonEnUp:
        def __get__(self):
            self.mPt_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.mPt_MuonEnUp_value

    property mRelPFIsoDBDefault:
        def __get__(self):
            self.mRelPFIsoDBDefault_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefault_value

    property mRelPFIsoDBDefaultR04:
        def __get__(self):
            self.mRelPFIsoDBDefaultR04_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoDBDefaultR04_value

    property mRelPFIsoRho:
        def __get__(self):
            self.mRelPFIsoRho_branch.GetEntry(self.localentry, 0)
            return self.mRelPFIsoRho_value

    property mRho:
        def __get__(self):
            self.mRho_branch.GetEntry(self.localentry, 0)
            return self.mRho_value

    property mSIP2D:
        def __get__(self):
            self.mSIP2D_branch.GetEntry(self.localentry, 0)
            return self.mSIP2D_value

    property mSIP3D:
        def __get__(self):
            self.mSIP3D_branch.GetEntry(self.localentry, 0)
            return self.mSIP3D_value

    property mSegmentCompatibility:
        def __get__(self):
            self.mSegmentCompatibility_branch.GetEntry(self.localentry, 0)
            return self.mSegmentCompatibility_value

    property mSoftCutBasedId:
        def __get__(self):
            self.mSoftCutBasedId_branch.GetEntry(self.localentry, 0)
            return self.mSoftCutBasedId_value

    property mTkIsoLoose:
        def __get__(self):
            self.mTkIsoLoose_branch.GetEntry(self.localentry, 0)
            return self.mTkIsoLoose_value

    property mTkIsoTight:
        def __get__(self):
            self.mTkIsoTight_branch.GetEntry(self.localentry, 0)
            return self.mTkIsoTight_value

    property mTkLayersWithMeasurement:
        def __get__(self):
            self.mTkLayersWithMeasurement_branch.GetEntry(self.localentry, 0)
            return self.mTkLayersWithMeasurement_value

    property mTrkIsoDR03:
        def __get__(self):
            self.mTrkIsoDR03_branch.GetEntry(self.localentry, 0)
            return self.mTrkIsoDR03_value

    property mTrkKink:
        def __get__(self):
            self.mTrkKink_branch.GetEntry(self.localentry, 0)
            return self.mTrkKink_value

    property mTypeCode:
        def __get__(self):
            self.mTypeCode_branch.GetEntry(self.localentry, 0)
            return self.mTypeCode_value

    property mVZ:
        def __get__(self):
            self.mVZ_branch.GetEntry(self.localentry, 0)
            return self.mVZ_value

    property mValidFraction:
        def __get__(self):
            self.mValidFraction_branch.GetEntry(self.localentry, 0)
            return self.mValidFraction_value

    property mZTTGenDR:
        def __get__(self):
            self.mZTTGenDR_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenDR_value

    property mZTTGenEta:
        def __get__(self):
            self.mZTTGenEta_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenEta_value

    property mZTTGenMatching:
        def __get__(self):
            self.mZTTGenMatching_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenMatching_value

    property mZTTGenPhi:
        def __get__(self):
            self.mZTTGenPhi_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenPhi_value

    property mZTTGenPt:
        def __get__(self):
            self.mZTTGenPt_branch.GetEntry(self.localentry, 0)
            return self.mZTTGenPt_value

    property m_t_DR:
        def __get__(self):
            self.m_t_DR_branch.GetEntry(self.localentry, 0)
            return self.m_t_DR_value

    property m_t_Mass:
        def __get__(self):
            self.m_t_Mass_branch.GetEntry(self.localentry, 0)
            return self.m_t_Mass_value

    property m_t_PZeta:
        def __get__(self):
            self.m_t_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZeta_value

    property m_t_PZetaVis:
        def __get__(self):
            self.m_t_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m_t_PZetaVis_value

    property m_t_doubleL1IsoTauMatch:
        def __get__(self):
            self.m_t_doubleL1IsoTauMatch_branch.GetEntry(self.localentry, 0)
            return self.m_t_doubleL1IsoTauMatch_value

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


