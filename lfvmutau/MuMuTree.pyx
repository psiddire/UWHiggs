

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

cdef class MuMuTree:
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

    cdef TBranch* Flag_badCloneMuonFilter_branch
    cdef float Flag_badCloneMuonFilter_value

    cdef TBranch* Flag_badGlobalMuonFilter_branch
    cdef float Flag_badGlobalMuonFilter_value

    cdef TBranch* Flag_badMuons_branch
    cdef float Flag_badMuons_value

    cdef TBranch* Flag_duplicateMuons_branch
    cdef float Flag_duplicateMuons_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_globalTightHalo2016Filter_branch
    cdef float Flag_globalTightHalo2016Filter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* Flag_noBadMuons_branch
    cdef float Flag_noBadMuons_value

    cdef TBranch* GenWeight_branch
    cdef float GenWeight_value

    cdef TBranch* Ht_branch
    cdef float Ht_value

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

    cdef TBranch* bjetCISVVeto20Tight_branch
    cdef float bjetCISVVeto20Tight_value

    cdef TBranch* bjetCISVVeto30Loose_branch
    cdef float bjetCISVVeto30Loose_value

    cdef TBranch* bjetCISVVeto30Medium_branch
    cdef float bjetCISVVeto30Medium_value

    cdef TBranch* bjetCISVVeto30Tight_branch
    cdef float bjetCISVVeto30Tight_value

    cdef TBranch* charge_branch
    cdef float charge_value

    cdef TBranch* dielectronVeto_branch
    cdef float dielectronVeto_value

    cdef TBranch* dimuonVeto_branch
    cdef float dimuonVeto_value

    cdef TBranch* doubleESingleMuGroup_branch
    cdef float doubleESingleMuGroup_value

    cdef TBranch* doubleESingleMuPass_branch
    cdef float doubleESingleMuPass_value

    cdef TBranch* doubleESingleMuPrescale_branch
    cdef float doubleESingleMuPrescale_value

    cdef TBranch* doubleE_23_12Group_branch
    cdef float doubleE_23_12Group_value

    cdef TBranch* doubleE_23_12Pass_branch
    cdef float doubleE_23_12Pass_value

    cdef TBranch* doubleE_23_12Prescale_branch
    cdef float doubleE_23_12Prescale_value

    cdef TBranch* doubleLooseIsoTau35Group_branch
    cdef float doubleLooseIsoTau35Group_value

    cdef TBranch* doubleLooseIsoTau35Pass_branch
    cdef float doubleLooseIsoTau35Pass_value

    cdef TBranch* doubleLooseIsoTau35Prescale_branch
    cdef float doubleLooseIsoTau35Prescale_value

    cdef TBranch* doubleLooseIsoTau40Group_branch
    cdef float doubleLooseIsoTau40Group_value

    cdef TBranch* doubleLooseIsoTau40Pass_branch
    cdef float doubleLooseIsoTau40Pass_value

    cdef TBranch* doubleLooseIsoTau40Prescale_branch
    cdef float doubleLooseIsoTau40Prescale_value

    cdef TBranch* doubleMuGroup_branch
    cdef float doubleMuGroup_value

    cdef TBranch* doubleMuPass_branch
    cdef float doubleMuPass_value

    cdef TBranch* doubleMuPrescale_branch
    cdef float doubleMuPrescale_value

    cdef TBranch* doubleMuSingleEGroup_branch
    cdef float doubleMuSingleEGroup_value

    cdef TBranch* doubleMuSingleEPass_branch
    cdef float doubleMuSingleEPass_value

    cdef TBranch* doubleMuSingleEPrescale_branch
    cdef float doubleMuSingleEPrescale_value

    cdef TBranch* doubleTau35Group_branch
    cdef float doubleTau35Group_value

    cdef TBranch* doubleTau35Pass_branch
    cdef float doubleTau35Pass_value

    cdef TBranch* doubleTau35Prescale_branch
    cdef float doubleTau35Prescale_value

    cdef TBranch* eVetoMVAIso_branch
    cdef float eVetoMVAIso_value

    cdef TBranch* eVetoMVAIsoVtx_branch
    cdef float eVetoMVAIsoVtx_value

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

    cdef TBranch* j1csv_branch
    cdef float j1csv_value

    cdef TBranch* j1eta_branch
    cdef float j1eta_value

    cdef TBranch* j1hadronflavor_branch
    cdef float j1hadronflavor_value

    cdef TBranch* j1partonflavor_branch
    cdef float j1partonflavor_value

    cdef TBranch* j1phi_branch
    cdef float j1phi_value

    cdef TBranch* j1pt_branch
    cdef float j1pt_value

    cdef TBranch* j1ptDown_branch
    cdef float j1ptDown_value

    cdef TBranch* j1ptUp_branch
    cdef float j1ptUp_value

    cdef TBranch* j1pu_branch
    cdef float j1pu_value

    cdef TBranch* j1rawf_branch
    cdef float j1rawf_value

    cdef TBranch* j2csv_branch
    cdef float j2csv_value

    cdef TBranch* j2eta_branch
    cdef float j2eta_value

    cdef TBranch* j2hadronflavor_branch
    cdef float j2hadronflavor_value

    cdef TBranch* j2partonflavor_branch
    cdef float j2partonflavor_value

    cdef TBranch* j2phi_branch
    cdef float j2phi_value

    cdef TBranch* j2pt_branch
    cdef float j2pt_value

    cdef TBranch* j2ptDown_branch
    cdef float j2ptDown_value

    cdef TBranch* j2ptUp_branch
    cdef float j2ptUp_value

    cdef TBranch* j2pu_branch
    cdef float j2pu_value

    cdef TBranch* j2rawf_branch
    cdef float j2rawf_value

    cdef TBranch* jb1csv_branch
    cdef float jb1csv_value

    cdef TBranch* jb1csv_CSVL_branch
    cdef float jb1csv_CSVL_value

    cdef TBranch* jb1eta_branch
    cdef float jb1eta_value

    cdef TBranch* jb1eta_CSVL_branch
    cdef float jb1eta_CSVL_value

    cdef TBranch* jb1hadronflavor_branch
    cdef float jb1hadronflavor_value

    cdef TBranch* jb1hadronflavor_CSVL_branch
    cdef float jb1hadronflavor_CSVL_value

    cdef TBranch* jb1partonflavor_branch
    cdef float jb1partonflavor_value

    cdef TBranch* jb1partonflavor_CSVL_branch
    cdef float jb1partonflavor_CSVL_value

    cdef TBranch* jb1phi_branch
    cdef float jb1phi_value

    cdef TBranch* jb1phi_CSVL_branch
    cdef float jb1phi_CSVL_value

    cdef TBranch* jb1pt_branch
    cdef float jb1pt_value

    cdef TBranch* jb1ptDown_branch
    cdef float jb1ptDown_value

    cdef TBranch* jb1ptDown_CSVL_branch
    cdef float jb1ptDown_CSVL_value

    cdef TBranch* jb1ptUp_branch
    cdef float jb1ptUp_value

    cdef TBranch* jb1ptUp_CSVL_branch
    cdef float jb1ptUp_CSVL_value

    cdef TBranch* jb1pt_CSVL_branch
    cdef float jb1pt_CSVL_value

    cdef TBranch* jb1pu_branch
    cdef float jb1pu_value

    cdef TBranch* jb1pu_CSVL_branch
    cdef float jb1pu_CSVL_value

    cdef TBranch* jb1rawf_branch
    cdef float jb1rawf_value

    cdef TBranch* jb1rawf_CSVL_branch
    cdef float jb1rawf_CSVL_value

    cdef TBranch* jb2csv_branch
    cdef float jb2csv_value

    cdef TBranch* jb2csv_CSVL_branch
    cdef float jb2csv_CSVL_value

    cdef TBranch* jb2eta_branch
    cdef float jb2eta_value

    cdef TBranch* jb2eta_CSVL_branch
    cdef float jb2eta_CSVL_value

    cdef TBranch* jb2hadronflavor_branch
    cdef float jb2hadronflavor_value

    cdef TBranch* jb2hadronflavor_CSVL_branch
    cdef float jb2hadronflavor_CSVL_value

    cdef TBranch* jb2partonflavor_branch
    cdef float jb2partonflavor_value

    cdef TBranch* jb2partonflavor_CSVL_branch
    cdef float jb2partonflavor_CSVL_value

    cdef TBranch* jb2phi_branch
    cdef float jb2phi_value

    cdef TBranch* jb2phi_CSVL_branch
    cdef float jb2phi_CSVL_value

    cdef TBranch* jb2pt_branch
    cdef float jb2pt_value

    cdef TBranch* jb2ptDown_branch
    cdef float jb2ptDown_value

    cdef TBranch* jb2ptDown_CSVL_branch
    cdef float jb2ptDown_CSVL_value

    cdef TBranch* jb2ptUp_branch
    cdef float jb2ptUp_value

    cdef TBranch* jb2ptUp_CSVL_branch
    cdef float jb2ptUp_CSVL_value

    cdef TBranch* jb2pt_CSVL_branch
    cdef float jb2pt_CSVL_value

    cdef TBranch* jb2pu_branch
    cdef float jb2pu_value

    cdef TBranch* jb2pu_CSVL_branch
    cdef float jb2pu_CSVL_value

    cdef TBranch* jb2rawf_branch
    cdef float jb2rawf_value

    cdef TBranch* jb2rawf_CSVL_branch
    cdef float jb2rawf_CSVL_value

    cdef TBranch* jetVeto20_branch
    cdef float jetVeto20_value

    cdef TBranch* jetVeto20_JetEnDown_branch
    cdef float jetVeto20_JetEnDown_value

    cdef TBranch* jetVeto20_JetEnUp_branch
    cdef float jetVeto20_JetEnUp_value

    cdef TBranch* jetVeto30_branch
    cdef float jetVeto30_value

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

    cdef TBranch* jetVeto30_JetSubTotalAbsoluteDown_branch
    cdef float jetVeto30_JetSubTotalAbsoluteDown_value

    cdef TBranch* jetVeto30_JetSubTotalAbsoluteUp_branch
    cdef float jetVeto30_JetSubTotalAbsoluteUp_value

    cdef TBranch* jetVeto30_JetSubTotalMCDown_branch
    cdef float jetVeto30_JetSubTotalMCDown_value

    cdef TBranch* jetVeto30_JetSubTotalMCUp_branch
    cdef float jetVeto30_JetSubTotalMCUp_value

    cdef TBranch* jetVeto30_JetSubTotalPileUpDown_branch
    cdef float jetVeto30_JetSubTotalPileUpDown_value

    cdef TBranch* jetVeto30_JetSubTotalPileUpUp_branch
    cdef float jetVeto30_JetSubTotalPileUpUp_value

    cdef TBranch* jetVeto30_JetSubTotalPtDown_branch
    cdef float jetVeto30_JetSubTotalPtDown_value

    cdef TBranch* jetVeto30_JetSubTotalPtUp_branch
    cdef float jetVeto30_JetSubTotalPtUp_value

    cdef TBranch* jetVeto30_JetSubTotalRelativeDown_branch
    cdef float jetVeto30_JetSubTotalRelativeDown_value

    cdef TBranch* jetVeto30_JetSubTotalRelativeUp_branch
    cdef float jetVeto30_JetSubTotalRelativeUp_value

    cdef TBranch* jetVeto30_JetSubTotalScaleDown_branch
    cdef float jetVeto30_JetSubTotalScaleDown_value

    cdef TBranch* jetVeto30_JetSubTotalScaleUp_branch
    cdef float jetVeto30_JetSubTotalScaleUp_value

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

    cdef TBranch* m1AbsEta_branch
    cdef float m1AbsEta_value

    cdef TBranch* m1BestTrackType_branch
    cdef float m1BestTrackType_value

    cdef TBranch* m1Charge_branch
    cdef float m1Charge_value

    cdef TBranch* m1Chi2LocalPosition_branch
    cdef float m1Chi2LocalPosition_value

    cdef TBranch* m1ComesFromHiggs_branch
    cdef float m1ComesFromHiggs_value

    cdef TBranch* m1DPhiToPfMet_ElectronEnDown_branch
    cdef float m1DPhiToPfMet_ElectronEnDown_value

    cdef TBranch* m1DPhiToPfMet_ElectronEnUp_branch
    cdef float m1DPhiToPfMet_ElectronEnUp_value

    cdef TBranch* m1DPhiToPfMet_JetEnDown_branch
    cdef float m1DPhiToPfMet_JetEnDown_value

    cdef TBranch* m1DPhiToPfMet_JetEnUp_branch
    cdef float m1DPhiToPfMet_JetEnUp_value

    cdef TBranch* m1DPhiToPfMet_JetResDown_branch
    cdef float m1DPhiToPfMet_JetResDown_value

    cdef TBranch* m1DPhiToPfMet_JetResUp_branch
    cdef float m1DPhiToPfMet_JetResUp_value

    cdef TBranch* m1DPhiToPfMet_MuonEnDown_branch
    cdef float m1DPhiToPfMet_MuonEnDown_value

    cdef TBranch* m1DPhiToPfMet_MuonEnUp_branch
    cdef float m1DPhiToPfMet_MuonEnUp_value

    cdef TBranch* m1DPhiToPfMet_PhotonEnDown_branch
    cdef float m1DPhiToPfMet_PhotonEnDown_value

    cdef TBranch* m1DPhiToPfMet_PhotonEnUp_branch
    cdef float m1DPhiToPfMet_PhotonEnUp_value

    cdef TBranch* m1DPhiToPfMet_TauEnDown_branch
    cdef float m1DPhiToPfMet_TauEnDown_value

    cdef TBranch* m1DPhiToPfMet_TauEnUp_branch
    cdef float m1DPhiToPfMet_TauEnUp_value

    cdef TBranch* m1DPhiToPfMet_UnclusteredEnDown_branch
    cdef float m1DPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* m1DPhiToPfMet_UnclusteredEnUp_branch
    cdef float m1DPhiToPfMet_UnclusteredEnUp_value

    cdef TBranch* m1DPhiToPfMet_type1_branch
    cdef float m1DPhiToPfMet_type1_value

    cdef TBranch* m1EcalIsoDR03_branch
    cdef float m1EcalIsoDR03_value

    cdef TBranch* m1EffectiveArea2011_branch
    cdef float m1EffectiveArea2011_value

    cdef TBranch* m1EffectiveArea2012_branch
    cdef float m1EffectiveArea2012_value

    cdef TBranch* m1ErsatzGenEta_branch
    cdef float m1ErsatzGenEta_value

    cdef TBranch* m1ErsatzGenM_branch
    cdef float m1ErsatzGenM_value

    cdef TBranch* m1ErsatzGenPhi_branch
    cdef float m1ErsatzGenPhi_value

    cdef TBranch* m1ErsatzGenpT_branch
    cdef float m1ErsatzGenpT_value

    cdef TBranch* m1ErsatzGenpX_branch
    cdef float m1ErsatzGenpX_value

    cdef TBranch* m1ErsatzGenpY_branch
    cdef float m1ErsatzGenpY_value

    cdef TBranch* m1ErsatzVispX_branch
    cdef float m1ErsatzVispX_value

    cdef TBranch* m1ErsatzVispY_branch
    cdef float m1ErsatzVispY_value

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

    cdef TBranch* m1MatchesDoubleESingleMu_branch
    cdef float m1MatchesDoubleESingleMu_value

    cdef TBranch* m1MatchesDoubleMu_branch
    cdef float m1MatchesDoubleMu_value

    cdef TBranch* m1MatchesDoubleMuSingleE_branch
    cdef float m1MatchesDoubleMuSingleE_value

    cdef TBranch* m1MatchesIsoMu24Path_branch
    cdef float m1MatchesIsoMu24Path_value

    cdef TBranch* m1MatchesIsoMu24eta2p1Path_branch
    cdef float m1MatchesIsoMu24eta2p1Path_value

    cdef TBranch* m1MatchesMu19Tau20Filter_branch
    cdef float m1MatchesMu19Tau20Filter_value

    cdef TBranch* m1MatchesMu19Tau20Path_branch
    cdef float m1MatchesMu19Tau20Path_value

    cdef TBranch* m1MatchesMu19Tau20sL1Filter_branch
    cdef float m1MatchesMu19Tau20sL1Filter_value

    cdef TBranch* m1MatchesMu19Tau20sL1Path_branch
    cdef float m1MatchesMu19Tau20sL1Path_value

    cdef TBranch* m1MatchesMu21Tau20sL1Filter_branch
    cdef float m1MatchesMu21Tau20sL1Filter_value

    cdef TBranch* m1MatchesMu21Tau20sL1Path_branch
    cdef float m1MatchesMu21Tau20sL1Path_value

    cdef TBranch* m1MatchesMu23Ele12DZPath_branch
    cdef float m1MatchesMu23Ele12DZPath_value

    cdef TBranch* m1MatchesMu23Ele12Path_branch
    cdef float m1MatchesMu23Ele12Path_value

    cdef TBranch* m1MatchesMu8Ele23DZPath_branch
    cdef float m1MatchesMu8Ele23DZPath_value

    cdef TBranch* m1MatchesMu8Ele23Path_branch
    cdef float m1MatchesMu8Ele23Path_value

    cdef TBranch* m1MatchesSingleESingleMu_branch
    cdef float m1MatchesSingleESingleMu_value

    cdef TBranch* m1MatchesSingleMu_branch
    cdef float m1MatchesSingleMu_value

    cdef TBranch* m1MatchesSingleMuIso20_branch
    cdef float m1MatchesSingleMuIso20_value

    cdef TBranch* m1MatchesSingleMuIsoTk20_branch
    cdef float m1MatchesSingleMuIsoTk20_value

    cdef TBranch* m1MatchesSingleMuSingleE_branch
    cdef float m1MatchesSingleMuSingleE_value

    cdef TBranch* m1MatchesSingleMu_leg1_branch
    cdef float m1MatchesSingleMu_leg1_value

    cdef TBranch* m1MatchesSingleMu_leg1_noiso_branch
    cdef float m1MatchesSingleMu_leg1_noiso_value

    cdef TBranch* m1MatchesSingleMu_leg2_branch
    cdef float m1MatchesSingleMu_leg2_value

    cdef TBranch* m1MatchesSingleMu_leg2_noiso_branch
    cdef float m1MatchesSingleMu_leg2_noiso_value

    cdef TBranch* m1MatchesTripleMu_branch
    cdef float m1MatchesTripleMu_value

    cdef TBranch* m1MtToPfMet_ElectronEnDown_branch
    cdef float m1MtToPfMet_ElectronEnDown_value

    cdef TBranch* m1MtToPfMet_ElectronEnUp_branch
    cdef float m1MtToPfMet_ElectronEnUp_value

    cdef TBranch* m1MtToPfMet_JetEnDown_branch
    cdef float m1MtToPfMet_JetEnDown_value

    cdef TBranch* m1MtToPfMet_JetEnUp_branch
    cdef float m1MtToPfMet_JetEnUp_value

    cdef TBranch* m1MtToPfMet_JetResDown_branch
    cdef float m1MtToPfMet_JetResDown_value

    cdef TBranch* m1MtToPfMet_JetResUp_branch
    cdef float m1MtToPfMet_JetResUp_value

    cdef TBranch* m1MtToPfMet_MuonEnDown_branch
    cdef float m1MtToPfMet_MuonEnDown_value

    cdef TBranch* m1MtToPfMet_MuonEnUp_branch
    cdef float m1MtToPfMet_MuonEnUp_value

    cdef TBranch* m1MtToPfMet_PhotonEnDown_branch
    cdef float m1MtToPfMet_PhotonEnDown_value

    cdef TBranch* m1MtToPfMet_PhotonEnUp_branch
    cdef float m1MtToPfMet_PhotonEnUp_value

    cdef TBranch* m1MtToPfMet_Raw_branch
    cdef float m1MtToPfMet_Raw_value

    cdef TBranch* m1MtToPfMet_TauEnDown_branch
    cdef float m1MtToPfMet_TauEnDown_value

    cdef TBranch* m1MtToPfMet_TauEnUp_branch
    cdef float m1MtToPfMet_TauEnUp_value

    cdef TBranch* m1MtToPfMet_UnclusteredEnDown_branch
    cdef float m1MtToPfMet_UnclusteredEnDown_value

    cdef TBranch* m1MtToPfMet_UnclusteredEnUp_branch
    cdef float m1MtToPfMet_UnclusteredEnUp_value

    cdef TBranch* m1MtToPfMet_type1_branch
    cdef float m1MtToPfMet_type1_value

    cdef TBranch* m1Mu23Ele12DZFilter_branch
    cdef float m1Mu23Ele12DZFilter_value

    cdef TBranch* m1Mu23Ele12Filter_branch
    cdef float m1Mu23Ele12Filter_value

    cdef TBranch* m1Mu8Ele23DZFilter_branch
    cdef float m1Mu8Ele23DZFilter_value

    cdef TBranch* m1Mu8Ele23Filter_branch
    cdef float m1Mu8Ele23Filter_value

    cdef TBranch* m1MuonHits_branch
    cdef float m1MuonHits_value

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

    cdef TBranch* m1Rank_branch
    cdef float m1Rank_value

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

    cdef TBranch* m1_m2_CosThetaStar_branch
    cdef float m1_m2_CosThetaStar_value

    cdef TBranch* m1_m2_DPhi_branch
    cdef float m1_m2_DPhi_value

    cdef TBranch* m1_m2_DR_branch
    cdef float m1_m2_DR_value

    cdef TBranch* m1_m2_Eta_branch
    cdef float m1_m2_Eta_value

    cdef TBranch* m1_m2_Mass_branch
    cdef float m1_m2_Mass_value

    cdef TBranch* m1_m2_Mass_TauEnDown_branch
    cdef float m1_m2_Mass_TauEnDown_value

    cdef TBranch* m1_m2_Mass_TauEnUp_branch
    cdef float m1_m2_Mass_TauEnUp_value

    cdef TBranch* m1_m2_Mt_branch
    cdef float m1_m2_Mt_value

    cdef TBranch* m1_m2_MtTotal_branch
    cdef float m1_m2_MtTotal_value

    cdef TBranch* m1_m2_Mt_TauEnDown_branch
    cdef float m1_m2_Mt_TauEnDown_value

    cdef TBranch* m1_m2_Mt_TauEnUp_branch
    cdef float m1_m2_Mt_TauEnUp_value

    cdef TBranch* m1_m2_MvaMet_branch
    cdef float m1_m2_MvaMet_value

    cdef TBranch* m1_m2_MvaMetCovMatrix00_branch
    cdef float m1_m2_MvaMetCovMatrix00_value

    cdef TBranch* m1_m2_MvaMetCovMatrix01_branch
    cdef float m1_m2_MvaMetCovMatrix01_value

    cdef TBranch* m1_m2_MvaMetCovMatrix10_branch
    cdef float m1_m2_MvaMetCovMatrix10_value

    cdef TBranch* m1_m2_MvaMetCovMatrix11_branch
    cdef float m1_m2_MvaMetCovMatrix11_value

    cdef TBranch* m1_m2_MvaMetPhi_branch
    cdef float m1_m2_MvaMetPhi_value

    cdef TBranch* m1_m2_PZeta_branch
    cdef float m1_m2_PZeta_value

    cdef TBranch* m1_m2_PZetaLess0p85PZetaVis_branch
    cdef float m1_m2_PZetaLess0p85PZetaVis_value

    cdef TBranch* m1_m2_PZetaVis_branch
    cdef float m1_m2_PZetaVis_value

    cdef TBranch* m1_m2_Phi_branch
    cdef float m1_m2_Phi_value

    cdef TBranch* m1_m2_Pt_branch
    cdef float m1_m2_Pt_value

    cdef TBranch* m1_m2_SS_branch
    cdef float m1_m2_SS_value

    cdef TBranch* m1_m2_ToMETDPhi_Ty1_branch
    cdef float m1_m2_ToMETDPhi_Ty1_value

    cdef TBranch* m1_m2_collinearmass_branch
    cdef float m1_m2_collinearmass_value

    cdef TBranch* m1_m2_collinearmass_CheckUESDown_branch
    cdef float m1_m2_collinearmass_CheckUESDown_value

    cdef TBranch* m1_m2_collinearmass_CheckUESUp_branch
    cdef float m1_m2_collinearmass_CheckUESUp_value

    cdef TBranch* m1_m2_collinearmass_EleEnDown_branch
    cdef float m1_m2_collinearmass_EleEnDown_value

    cdef TBranch* m1_m2_collinearmass_EleEnUp_branch
    cdef float m1_m2_collinearmass_EleEnUp_value

    cdef TBranch* m1_m2_collinearmass_JetCheckTotalDown_branch
    cdef float m1_m2_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m1_m2_collinearmass_JetCheckTotalUp_branch
    cdef float m1_m2_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m1_m2_collinearmass_JetEnDown_branch
    cdef float m1_m2_collinearmass_JetEnDown_value

    cdef TBranch* m1_m2_collinearmass_JetEnUp_branch
    cdef float m1_m2_collinearmass_JetEnUp_value

    cdef TBranch* m1_m2_collinearmass_MuEnDown_branch
    cdef float m1_m2_collinearmass_MuEnDown_value

    cdef TBranch* m1_m2_collinearmass_MuEnUp_branch
    cdef float m1_m2_collinearmass_MuEnUp_value

    cdef TBranch* m1_m2_collinearmass_TauEnDown_branch
    cdef float m1_m2_collinearmass_TauEnDown_value

    cdef TBranch* m1_m2_collinearmass_TauEnUp_branch
    cdef float m1_m2_collinearmass_TauEnUp_value

    cdef TBranch* m1_m2_collinearmass_UnclusteredEnDown_branch
    cdef float m1_m2_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m1_m2_collinearmass_UnclusteredEnUp_branch
    cdef float m1_m2_collinearmass_UnclusteredEnUp_value

    cdef TBranch* m1_m2_pt_tt_branch
    cdef float m1_m2_pt_tt_value

    cdef TBranch* m2AbsEta_branch
    cdef float m2AbsEta_value

    cdef TBranch* m2BestTrackType_branch
    cdef float m2BestTrackType_value

    cdef TBranch* m2Charge_branch
    cdef float m2Charge_value

    cdef TBranch* m2Chi2LocalPosition_branch
    cdef float m2Chi2LocalPosition_value

    cdef TBranch* m2ComesFromHiggs_branch
    cdef float m2ComesFromHiggs_value

    cdef TBranch* m2DPhiToPfMet_ElectronEnDown_branch
    cdef float m2DPhiToPfMet_ElectronEnDown_value

    cdef TBranch* m2DPhiToPfMet_ElectronEnUp_branch
    cdef float m2DPhiToPfMet_ElectronEnUp_value

    cdef TBranch* m2DPhiToPfMet_JetEnDown_branch
    cdef float m2DPhiToPfMet_JetEnDown_value

    cdef TBranch* m2DPhiToPfMet_JetEnUp_branch
    cdef float m2DPhiToPfMet_JetEnUp_value

    cdef TBranch* m2DPhiToPfMet_JetResDown_branch
    cdef float m2DPhiToPfMet_JetResDown_value

    cdef TBranch* m2DPhiToPfMet_JetResUp_branch
    cdef float m2DPhiToPfMet_JetResUp_value

    cdef TBranch* m2DPhiToPfMet_MuonEnDown_branch
    cdef float m2DPhiToPfMet_MuonEnDown_value

    cdef TBranch* m2DPhiToPfMet_MuonEnUp_branch
    cdef float m2DPhiToPfMet_MuonEnUp_value

    cdef TBranch* m2DPhiToPfMet_PhotonEnDown_branch
    cdef float m2DPhiToPfMet_PhotonEnDown_value

    cdef TBranch* m2DPhiToPfMet_PhotonEnUp_branch
    cdef float m2DPhiToPfMet_PhotonEnUp_value

    cdef TBranch* m2DPhiToPfMet_TauEnDown_branch
    cdef float m2DPhiToPfMet_TauEnDown_value

    cdef TBranch* m2DPhiToPfMet_TauEnUp_branch
    cdef float m2DPhiToPfMet_TauEnUp_value

    cdef TBranch* m2DPhiToPfMet_UnclusteredEnDown_branch
    cdef float m2DPhiToPfMet_UnclusteredEnDown_value

    cdef TBranch* m2DPhiToPfMet_UnclusteredEnUp_branch
    cdef float m2DPhiToPfMet_UnclusteredEnUp_value

    cdef TBranch* m2DPhiToPfMet_type1_branch
    cdef float m2DPhiToPfMet_type1_value

    cdef TBranch* m2EcalIsoDR03_branch
    cdef float m2EcalIsoDR03_value

    cdef TBranch* m2EffectiveArea2011_branch
    cdef float m2EffectiveArea2011_value

    cdef TBranch* m2EffectiveArea2012_branch
    cdef float m2EffectiveArea2012_value

    cdef TBranch* m2ErsatzGenEta_branch
    cdef float m2ErsatzGenEta_value

    cdef TBranch* m2ErsatzGenM_branch
    cdef float m2ErsatzGenM_value

    cdef TBranch* m2ErsatzGenPhi_branch
    cdef float m2ErsatzGenPhi_value

    cdef TBranch* m2ErsatzGenpT_branch
    cdef float m2ErsatzGenpT_value

    cdef TBranch* m2ErsatzGenpX_branch
    cdef float m2ErsatzGenpX_value

    cdef TBranch* m2ErsatzGenpY_branch
    cdef float m2ErsatzGenpY_value

    cdef TBranch* m2ErsatzVispX_branch
    cdef float m2ErsatzVispX_value

    cdef TBranch* m2ErsatzVispY_branch
    cdef float m2ErsatzVispY_value

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

    cdef TBranch* m2MatchesDoubleESingleMu_branch
    cdef float m2MatchesDoubleESingleMu_value

    cdef TBranch* m2MatchesDoubleMu_branch
    cdef float m2MatchesDoubleMu_value

    cdef TBranch* m2MatchesDoubleMuSingleE_branch
    cdef float m2MatchesDoubleMuSingleE_value

    cdef TBranch* m2MatchesIsoMu24Path_branch
    cdef float m2MatchesIsoMu24Path_value

    cdef TBranch* m2MatchesIsoMu24eta2p1Path_branch
    cdef float m2MatchesIsoMu24eta2p1Path_value

    cdef TBranch* m2MatchesMu19Tau20Filter_branch
    cdef float m2MatchesMu19Tau20Filter_value

    cdef TBranch* m2MatchesMu19Tau20Path_branch
    cdef float m2MatchesMu19Tau20Path_value

    cdef TBranch* m2MatchesMu19Tau20sL1Filter_branch
    cdef float m2MatchesMu19Tau20sL1Filter_value

    cdef TBranch* m2MatchesMu19Tau20sL1Path_branch
    cdef float m2MatchesMu19Tau20sL1Path_value

    cdef TBranch* m2MatchesMu21Tau20sL1Filter_branch
    cdef float m2MatchesMu21Tau20sL1Filter_value

    cdef TBranch* m2MatchesMu21Tau20sL1Path_branch
    cdef float m2MatchesMu21Tau20sL1Path_value

    cdef TBranch* m2MatchesMu23Ele12DZPath_branch
    cdef float m2MatchesMu23Ele12DZPath_value

    cdef TBranch* m2MatchesMu23Ele12Path_branch
    cdef float m2MatchesMu23Ele12Path_value

    cdef TBranch* m2MatchesMu8Ele23DZPath_branch
    cdef float m2MatchesMu8Ele23DZPath_value

    cdef TBranch* m2MatchesMu8Ele23Path_branch
    cdef float m2MatchesMu8Ele23Path_value

    cdef TBranch* m2MatchesSingleESingleMu_branch
    cdef float m2MatchesSingleESingleMu_value

    cdef TBranch* m2MatchesSingleMu_branch
    cdef float m2MatchesSingleMu_value

    cdef TBranch* m2MatchesSingleMuIso20_branch
    cdef float m2MatchesSingleMuIso20_value

    cdef TBranch* m2MatchesSingleMuIsoTk20_branch
    cdef float m2MatchesSingleMuIsoTk20_value

    cdef TBranch* m2MatchesSingleMuSingleE_branch
    cdef float m2MatchesSingleMuSingleE_value

    cdef TBranch* m2MatchesSingleMu_leg1_branch
    cdef float m2MatchesSingleMu_leg1_value

    cdef TBranch* m2MatchesSingleMu_leg1_noiso_branch
    cdef float m2MatchesSingleMu_leg1_noiso_value

    cdef TBranch* m2MatchesSingleMu_leg2_branch
    cdef float m2MatchesSingleMu_leg2_value

    cdef TBranch* m2MatchesSingleMu_leg2_noiso_branch
    cdef float m2MatchesSingleMu_leg2_noiso_value

    cdef TBranch* m2MatchesTripleMu_branch
    cdef float m2MatchesTripleMu_value

    cdef TBranch* m2MtToPfMet_ElectronEnDown_branch
    cdef float m2MtToPfMet_ElectronEnDown_value

    cdef TBranch* m2MtToPfMet_ElectronEnUp_branch
    cdef float m2MtToPfMet_ElectronEnUp_value

    cdef TBranch* m2MtToPfMet_JetEnDown_branch
    cdef float m2MtToPfMet_JetEnDown_value

    cdef TBranch* m2MtToPfMet_JetEnUp_branch
    cdef float m2MtToPfMet_JetEnUp_value

    cdef TBranch* m2MtToPfMet_JetResDown_branch
    cdef float m2MtToPfMet_JetResDown_value

    cdef TBranch* m2MtToPfMet_JetResUp_branch
    cdef float m2MtToPfMet_JetResUp_value

    cdef TBranch* m2MtToPfMet_MuonEnDown_branch
    cdef float m2MtToPfMet_MuonEnDown_value

    cdef TBranch* m2MtToPfMet_MuonEnUp_branch
    cdef float m2MtToPfMet_MuonEnUp_value

    cdef TBranch* m2MtToPfMet_PhotonEnDown_branch
    cdef float m2MtToPfMet_PhotonEnDown_value

    cdef TBranch* m2MtToPfMet_PhotonEnUp_branch
    cdef float m2MtToPfMet_PhotonEnUp_value

    cdef TBranch* m2MtToPfMet_Raw_branch
    cdef float m2MtToPfMet_Raw_value

    cdef TBranch* m2MtToPfMet_TauEnDown_branch
    cdef float m2MtToPfMet_TauEnDown_value

    cdef TBranch* m2MtToPfMet_TauEnUp_branch
    cdef float m2MtToPfMet_TauEnUp_value

    cdef TBranch* m2MtToPfMet_UnclusteredEnDown_branch
    cdef float m2MtToPfMet_UnclusteredEnDown_value

    cdef TBranch* m2MtToPfMet_UnclusteredEnUp_branch
    cdef float m2MtToPfMet_UnclusteredEnUp_value

    cdef TBranch* m2MtToPfMet_type1_branch
    cdef float m2MtToPfMet_type1_value

    cdef TBranch* m2Mu23Ele12DZFilter_branch
    cdef float m2Mu23Ele12DZFilter_value

    cdef TBranch* m2Mu23Ele12Filter_branch
    cdef float m2Mu23Ele12Filter_value

    cdef TBranch* m2Mu8Ele23DZFilter_branch
    cdef float m2Mu8Ele23DZFilter_value

    cdef TBranch* m2Mu8Ele23Filter_branch
    cdef float m2Mu8Ele23Filter_value

    cdef TBranch* m2MuonHits_branch
    cdef float m2MuonHits_value

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

    cdef TBranch* m2Rank_branch
    cdef float m2Rank_value

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

    cdef TBranch* m2_m1_collinearmass_branch
    cdef float m2_m1_collinearmass_value

    cdef TBranch* m2_m1_collinearmass_CheckUESDown_branch
    cdef float m2_m1_collinearmass_CheckUESDown_value

    cdef TBranch* m2_m1_collinearmass_CheckUESUp_branch
    cdef float m2_m1_collinearmass_CheckUESUp_value

    cdef TBranch* m2_m1_collinearmass_JetCheckTotalDown_branch
    cdef float m2_m1_collinearmass_JetCheckTotalDown_value

    cdef TBranch* m2_m1_collinearmass_JetCheckTotalUp_branch
    cdef float m2_m1_collinearmass_JetCheckTotalUp_value

    cdef TBranch* m2_m1_collinearmass_JetEnDown_branch
    cdef float m2_m1_collinearmass_JetEnDown_value

    cdef TBranch* m2_m1_collinearmass_JetEnUp_branch
    cdef float m2_m1_collinearmass_JetEnUp_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnDown_branch
    cdef float m2_m1_collinearmass_UnclusteredEnDown_value

    cdef TBranch* m2_m1_collinearmass_UnclusteredEnUp_branch
    cdef float m2_m1_collinearmass_UnclusteredEnUp_value

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

    cdef TBranch* muGlbIsoVetoPt10_branch
    cdef float muGlbIsoVetoPt10_value

    cdef TBranch* muVetoPt15IsoIdVtx_branch
    cdef float muVetoPt15IsoIdVtx_value

    cdef TBranch* muVetoPt5_branch
    cdef float muVetoPt5_value

    cdef TBranch* muVetoPt5IsoIdVtx_branch
    cdef float muVetoPt5IsoIdVtx_value

    cdef TBranch* muVetoZTTp001dxyz_branch
    cdef float muVetoZTTp001dxyz_value

    cdef TBranch* muVetoZTTp001dxyzR0_branch
    cdef float muVetoZTTp001dxyzR0_value

    cdef TBranch* nTruePU_branch
    cdef float nTruePU_value

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

    cdef TBranch* singleE24SingleLooseIsoTau30Group_branch
    cdef float singleE24SingleLooseIsoTau30Group_value

    cdef TBranch* singleE24SingleLooseIsoTau30Pass_branch
    cdef float singleE24SingleLooseIsoTau30Pass_value

    cdef TBranch* singleE24SingleLooseIsoTau30Prescale_branch
    cdef float singleE24SingleLooseIsoTau30Prescale_value

    cdef TBranch* singleE24SingleLooseIsoTau30TightIDGroup_branch
    cdef float singleE24SingleLooseIsoTau30TightIDGroup_value

    cdef TBranch* singleE24SingleLooseIsoTau30TightIDPass_branch
    cdef float singleE24SingleLooseIsoTau30TightIDPass_value

    cdef TBranch* singleE24SingleLooseIsoTau30TightIDPrescale_branch
    cdef float singleE24SingleLooseIsoTau30TightIDPrescale_value

    cdef TBranch* singleE24SingleMediumIsoTau30Group_branch
    cdef float singleE24SingleMediumIsoTau30Group_value

    cdef TBranch* singleE24SingleMediumIsoTau30Pass_branch
    cdef float singleE24SingleMediumIsoTau30Pass_value

    cdef TBranch* singleE24SingleMediumIsoTau30Prescale_branch
    cdef float singleE24SingleMediumIsoTau30Prescale_value

    cdef TBranch* singleE24SingleMediumIsoTau30TightIDGroup_branch
    cdef float singleE24SingleMediumIsoTau30TightIDGroup_value

    cdef TBranch* singleE24SingleMediumIsoTau30TightIDPass_branch
    cdef float singleE24SingleMediumIsoTau30TightIDPass_value

    cdef TBranch* singleE24SingleMediumIsoTau30TightIDPrescale_branch
    cdef float singleE24SingleMediumIsoTau30TightIDPrescale_value

    cdef TBranch* singleE24SingleTightIsoTau30Group_branch
    cdef float singleE24SingleTightIsoTau30Group_value

    cdef TBranch* singleE24SingleTightIsoTau30Pass_branch
    cdef float singleE24SingleTightIsoTau30Pass_value

    cdef TBranch* singleE24SingleTightIsoTau30Prescale_branch
    cdef float singleE24SingleTightIsoTau30Prescale_value

    cdef TBranch* singleE24SingleTightIsoTau30TightIDGroup_branch
    cdef float singleE24SingleTightIsoTau30TightIDGroup_value

    cdef TBranch* singleE24SingleTightIsoTau30TightIDPass_branch
    cdef float singleE24SingleTightIsoTau30TightIDPass_value

    cdef TBranch* singleE24SingleTightIsoTau30TightIDPrescale_branch
    cdef float singleE24SingleTightIsoTau30TightIDPrescale_value

    cdef TBranch* singleE27TightGroup_branch
    cdef float singleE27TightGroup_value

    cdef TBranch* singleE27TightPass_branch
    cdef float singleE27TightPass_value

    cdef TBranch* singleE27TightPrescale_branch
    cdef float singleE27TightPrescale_value

    cdef TBranch* singleIsoMu20Group_branch
    cdef float singleIsoMu20Group_value

    cdef TBranch* singleIsoMu20Pass_branch
    cdef float singleIsoMu20Pass_value

    cdef TBranch* singleIsoMu20Prescale_branch
    cdef float singleIsoMu20Prescale_value

    cdef TBranch* singleIsoMu24Group_branch
    cdef float singleIsoMu24Group_value

    cdef TBranch* singleIsoMu24Pass_branch
    cdef float singleIsoMu24Pass_value

    cdef TBranch* singleIsoMu24Prescale_branch
    cdef float singleIsoMu24Prescale_value

    cdef TBranch* singleIsoMu24eta2p1Group_branch
    cdef float singleIsoMu24eta2p1Group_value

    cdef TBranch* singleIsoMu24eta2p1Pass_branch
    cdef float singleIsoMu24eta2p1Pass_value

    cdef TBranch* singleIsoMu24eta2p1Prescale_branch
    cdef float singleIsoMu24eta2p1Prescale_value

    cdef TBranch* singleIsoMu27Group_branch
    cdef float singleIsoMu27Group_value

    cdef TBranch* singleIsoMu27Pass_branch
    cdef float singleIsoMu27Pass_value

    cdef TBranch* singleIsoMu27Prescale_branch
    cdef float singleIsoMu27Prescale_value

    cdef TBranch* singleMu20Group_branch
    cdef float singleMu20Group_value

    cdef TBranch* singleMu20Pass_branch
    cdef float singleMu20Pass_value

    cdef TBranch* singleMu20Prescale_branch
    cdef float singleMu20Prescale_value

    cdef TBranch* singleMu20eta2p1LooseTau27eta2p1Group_branch
    cdef float singleMu20eta2p1LooseTau27eta2p1Group_value

    cdef TBranch* singleMu20eta2p1LooseTau27eta2p1Pass_branch
    cdef float singleMu20eta2p1LooseTau27eta2p1Pass_value

    cdef TBranch* singleMu20eta2p1LooseTau27eta2p1Prescale_branch
    cdef float singleMu20eta2p1LooseTau27eta2p1Prescale_value

    cdef TBranch* singleMu20eta2p1MediumTau27eta2p1Group_branch
    cdef float singleMu20eta2p1MediumTau27eta2p1Group_value

    cdef TBranch* singleMu20eta2p1MediumTau27eta2p1Pass_branch
    cdef float singleMu20eta2p1MediumTau27eta2p1Pass_value

    cdef TBranch* singleMu20eta2p1MediumTau27eta2p1Prescale_branch
    cdef float singleMu20eta2p1MediumTau27eta2p1Prescale_value

    cdef TBranch* singleMu20eta2p1TightTau27eta2p1Group_branch
    cdef float singleMu20eta2p1TightTau27eta2p1Group_value

    cdef TBranch* singleMu20eta2p1TightTau27eta2p1Pass_branch
    cdef float singleMu20eta2p1TightTau27eta2p1Pass_value

    cdef TBranch* singleMu20eta2p1TightTau27eta2p1Prescale_branch
    cdef float singleMu20eta2p1TightTau27eta2p1Prescale_value

    cdef TBranch* singleMu23SingleE12DZGroup_branch
    cdef float singleMu23SingleE12DZGroup_value

    cdef TBranch* singleMu23SingleE12DZPass_branch
    cdef float singleMu23SingleE12DZPass_value

    cdef TBranch* singleMu23SingleE12DZPrescale_branch
    cdef float singleMu23SingleE12DZPrescale_value

    cdef TBranch* singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch
    cdef float singleMu24eta2p1LooseTau20TightIDsingleL1Group_value

    cdef TBranch* singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch
    cdef float singleMu24eta2p1LooseTau20TightIDsingleL1Pass_value

    cdef TBranch* singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch
    cdef float singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_value

    cdef TBranch* singleMu24eta2p1LooseTau20singleL1Group_branch
    cdef float singleMu24eta2p1LooseTau20singleL1Group_value

    cdef TBranch* singleMu24eta2p1LooseTau20singleL1Pass_branch
    cdef float singleMu24eta2p1LooseTau20singleL1Pass_value

    cdef TBranch* singleMu24eta2p1LooseTau20singleL1Prescale_branch
    cdef float singleMu24eta2p1LooseTau20singleL1Prescale_value

    cdef TBranch* singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch
    cdef float singleMu24eta2p1MediumTau20TightIDsingleL1Group_value

    cdef TBranch* singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch
    cdef float singleMu24eta2p1MediumTau20TightIDsingleL1Pass_value

    cdef TBranch* singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch
    cdef float singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_value

    cdef TBranch* singleMu24eta2p1MediumTau20singleL1Group_branch
    cdef float singleMu24eta2p1MediumTau20singleL1Group_value

    cdef TBranch* singleMu24eta2p1MediumTau20singleL1Pass_branch
    cdef float singleMu24eta2p1MediumTau20singleL1Pass_value

    cdef TBranch* singleMu24eta2p1MediumTau20singleL1Prescale_branch
    cdef float singleMu24eta2p1MediumTau20singleL1Prescale_value

    cdef TBranch* singleMu24eta2p1TightTau20TightIDsingleL1Group_branch
    cdef float singleMu24eta2p1TightTau20TightIDsingleL1Group_value

    cdef TBranch* singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch
    cdef float singleMu24eta2p1TightTau20TightIDsingleL1Pass_value

    cdef TBranch* singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch
    cdef float singleMu24eta2p1TightTau20TightIDsingleL1Prescale_value

    cdef TBranch* singleMu24eta2p1TightTau20singleL1Group_branch
    cdef float singleMu24eta2p1TightTau20singleL1Group_value

    cdef TBranch* singleMu24eta2p1TightTau20singleL1Pass_branch
    cdef float singleMu24eta2p1TightTau20singleL1Pass_value

    cdef TBranch* singleMu24eta2p1TightTau20singleL1Prescale_branch
    cdef float singleMu24eta2p1TightTau20singleL1Prescale_value

    cdef TBranch* singleMu27Group_branch
    cdef float singleMu27Group_value

    cdef TBranch* singleMu27Pass_branch
    cdef float singleMu27Pass_value

    cdef TBranch* singleMu27Prescale_branch
    cdef float singleMu27Prescale_value

    cdef TBranch* singleMu50Group_branch
    cdef float singleMu50Group_value

    cdef TBranch* singleMu50Pass_branch
    cdef float singleMu50Pass_value

    cdef TBranch* singleMu50Prescale_branch
    cdef float singleMu50Prescale_value

    cdef TBranch* singleMu8SingleE23DZGroup_branch
    cdef float singleMu8SingleE23DZGroup_value

    cdef TBranch* singleMu8SingleE23DZPass_branch
    cdef float singleMu8SingleE23DZPass_value

    cdef TBranch* singleMu8SingleE23DZPrescale_branch
    cdef float singleMu8SingleE23DZPrescale_value

    cdef TBranch* singleMu_leg1Group_branch
    cdef float singleMu_leg1Group_value

    cdef TBranch* singleMu_leg1Pass_branch
    cdef float singleMu_leg1Pass_value

    cdef TBranch* singleMu_leg1Prescale_branch
    cdef float singleMu_leg1Prescale_value

    cdef TBranch* singleMu_leg1_noisoGroup_branch
    cdef float singleMu_leg1_noisoGroup_value

    cdef TBranch* singleMu_leg1_noisoPass_branch
    cdef float singleMu_leg1_noisoPass_value

    cdef TBranch* singleMu_leg1_noisoPrescale_branch
    cdef float singleMu_leg1_noisoPrescale_value

    cdef TBranch* singleMu_leg2Group_branch
    cdef float singleMu_leg2Group_value

    cdef TBranch* singleMu_leg2Pass_branch
    cdef float singleMu_leg2Pass_value

    cdef TBranch* singleMu_leg2Prescale_branch
    cdef float singleMu_leg2Prescale_value

    cdef TBranch* singleMu_leg2_noisoGroup_branch
    cdef float singleMu_leg2_noisoGroup_value

    cdef TBranch* singleMu_leg2_noisoPass_branch
    cdef float singleMu_leg2_noisoPass_value

    cdef TBranch* singleMu_leg2_noisoPrescale_branch
    cdef float singleMu_leg2_noisoPrescale_value

    cdef TBranch* singleTau140Group_branch
    cdef float singleTau140Group_value

    cdef TBranch* singleTau140Pass_branch
    cdef float singleTau140Pass_value

    cdef TBranch* singleTau140Prescale_branch
    cdef float singleTau140Prescale_value

    cdef TBranch* singleTau140Trk50Group_branch
    cdef float singleTau140Trk50Group_value

    cdef TBranch* singleTau140Trk50Pass_branch
    cdef float singleTau140Trk50Pass_value

    cdef TBranch* singleTau140Trk50Prescale_branch
    cdef float singleTau140Trk50Prescale_value

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

    cdef TBranch* tripleMuGroup_branch
    cdef float tripleMuGroup_value

    cdef TBranch* tripleMuPass_branch
    cdef float tripleMuPass_value

    cdef TBranch* tripleMuPrescale_branch
    cdef float tripleMuPrescale_value

    cdef TBranch* type1_pfMetEt_branch
    cdef float type1_pfMetEt_value

    cdef TBranch* type1_pfMetPhi_branch
    cdef float type1_pfMetPhi_value

    cdef TBranch* type1_pfMet_shiftedPhi_CHARGEDUESDown_branch
    cdef float type1_pfMet_shiftedPhi_CHARGEDUESDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_CHARGEDUESUp_branch
    cdef float type1_pfMet_shiftedPhi_CHARGEDUESUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_ECALUESDown_branch
    cdef float type1_pfMet_shiftedPhi_ECALUESDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_ECALUESUp_branch
    cdef float type1_pfMet_shiftedPhi_ECALUESUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_HCALUESDown_branch
    cdef float type1_pfMet_shiftedPhi_HCALUESDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_HCALUESUp_branch
    cdef float type1_pfMet_shiftedPhi_HCALUESUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_HFUESDown_branch
    cdef float type1_pfMet_shiftedPhi_HFUESDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_HFUESUp_branch
    cdef float type1_pfMet_shiftedPhi_HFUESUp_value

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

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnDown_branch
    cdef float type1_pfMet_shiftedPhi_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_JetEnUp_branch
    cdef float type1_pfMet_shiftedPhi_JetEnUp_value

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

    cdef TBranch* type1_pfMet_shiftedPhi_RunIUESDown_branch
    cdef float type1_pfMet_shiftedPhi_RunIUESDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_RunIUESUp_branch
    cdef float type1_pfMet_shiftedPhi_RunIUESUp_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPhi_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    cdef TBranch* type1_pfMet_shiftedPt_CHARGEDUESDown_branch
    cdef float type1_pfMet_shiftedPt_CHARGEDUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_CHARGEDUESUp_branch
    cdef float type1_pfMet_shiftedPt_CHARGEDUESUp_value

    cdef TBranch* type1_pfMet_shiftedPt_ECALUESDown_branch
    cdef float type1_pfMet_shiftedPt_ECALUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_ECALUESUp_branch
    cdef float type1_pfMet_shiftedPt_ECALUESUp_value

    cdef TBranch* type1_pfMet_shiftedPt_HCALUESDown_branch
    cdef float type1_pfMet_shiftedPt_HCALUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_HCALUESUp_branch
    cdef float type1_pfMet_shiftedPt_HCALUESUp_value

    cdef TBranch* type1_pfMet_shiftedPt_HFUESDown_branch
    cdef float type1_pfMet_shiftedPt_HFUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_HFUESUp_branch
    cdef float type1_pfMet_shiftedPt_HFUESUp_value

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

    cdef TBranch* type1_pfMet_shiftedPt_JetCheckUESDown_branch
    cdef float type1_pfMet_shiftedPt_JetCheckUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetCheckUESUp_branch
    cdef float type1_pfMet_shiftedPt_JetCheckUESUp_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnDown_branch
    cdef float type1_pfMet_shiftedPt_JetEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_JetEnUp_branch
    cdef float type1_pfMet_shiftedPt_JetEnUp_value

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

    cdef TBranch* type1_pfMet_shiftedPt_RunIUESDown_branch
    cdef float type1_pfMet_shiftedPt_RunIUESDown_value

    cdef TBranch* type1_pfMet_shiftedPt_RunIUESUp_branch
    cdef float type1_pfMet_shiftedPt_RunIUESUp_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnDown_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnDown_value

    cdef TBranch* type1_pfMet_shiftedPt_UnclusteredEnUp_branch
    cdef float type1_pfMet_shiftedPt_UnclusteredEnUp_value

    cdef TBranch* vbfDeta_branch
    cdef float vbfDeta_value

    cdef TBranch* vbfDeta_JetEnDown_branch
    cdef float vbfDeta_JetEnDown_value

    cdef TBranch* vbfDeta_JetEnUp_branch
    cdef float vbfDeta_JetEnUp_value

    cdef TBranch* vbfDijetrap_branch
    cdef float vbfDijetrap_value

    cdef TBranch* vbfDijetrap_JetEnDown_branch
    cdef float vbfDijetrap_JetEnDown_value

    cdef TBranch* vbfDijetrap_JetEnUp_branch
    cdef float vbfDijetrap_JetEnUp_value

    cdef TBranch* vbfDphi_branch
    cdef float vbfDphi_value

    cdef TBranch* vbfDphi_JetEnDown_branch
    cdef float vbfDphi_JetEnDown_value

    cdef TBranch* vbfDphi_JetEnUp_branch
    cdef float vbfDphi_JetEnUp_value

    cdef TBranch* vbfDphihj_branch
    cdef float vbfDphihj_value

    cdef TBranch* vbfDphihj_JetEnDown_branch
    cdef float vbfDphihj_JetEnDown_value

    cdef TBranch* vbfDphihj_JetEnUp_branch
    cdef float vbfDphihj_JetEnUp_value

    cdef TBranch* vbfDphihjnomet_branch
    cdef float vbfDphihjnomet_value

    cdef TBranch* vbfDphihjnomet_JetEnDown_branch
    cdef float vbfDphihjnomet_JetEnDown_value

    cdef TBranch* vbfDphihjnomet_JetEnUp_branch
    cdef float vbfDphihjnomet_JetEnUp_value

    cdef TBranch* vbfHrap_branch
    cdef float vbfHrap_value

    cdef TBranch* vbfHrap_JetEnDown_branch
    cdef float vbfHrap_JetEnDown_value

    cdef TBranch* vbfHrap_JetEnUp_branch
    cdef float vbfHrap_JetEnUp_value

    cdef TBranch* vbfJetVeto20_branch
    cdef float vbfJetVeto20_value

    cdef TBranch* vbfJetVeto20_JetEnDown_branch
    cdef float vbfJetVeto20_JetEnDown_value

    cdef TBranch* vbfJetVeto20_JetEnUp_branch
    cdef float vbfJetVeto20_JetEnUp_value

    cdef TBranch* vbfJetVeto30_branch
    cdef float vbfJetVeto30_value

    cdef TBranch* vbfJetVeto30_JetEnDown_branch
    cdef float vbfJetVeto30_JetEnDown_value

    cdef TBranch* vbfJetVeto30_JetEnUp_branch
    cdef float vbfJetVeto30_JetEnUp_value

    cdef TBranch* vbfMVA_branch
    cdef float vbfMVA_value

    cdef TBranch* vbfMVA_JetEnDown_branch
    cdef float vbfMVA_JetEnDown_value

    cdef TBranch* vbfMVA_JetEnUp_branch
    cdef float vbfMVA_JetEnUp_value

    cdef TBranch* vbfMass_branch
    cdef float vbfMass_value

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

    cdef TBranch* vbfMass_JetEnDown_branch
    cdef float vbfMass_JetEnDown_value

    cdef TBranch* vbfMass_JetEnUp_branch
    cdef float vbfMass_JetEnUp_value

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

    cdef TBranch* vbfMass_JetSubTotalAbsoluteDown_branch
    cdef float vbfMass_JetSubTotalAbsoluteDown_value

    cdef TBranch* vbfMass_JetSubTotalAbsoluteUp_branch
    cdef float vbfMass_JetSubTotalAbsoluteUp_value

    cdef TBranch* vbfMass_JetSubTotalMCDown_branch
    cdef float vbfMass_JetSubTotalMCDown_value

    cdef TBranch* vbfMass_JetSubTotalMCUp_branch
    cdef float vbfMass_JetSubTotalMCUp_value

    cdef TBranch* vbfMass_JetSubTotalPileUpDown_branch
    cdef float vbfMass_JetSubTotalPileUpDown_value

    cdef TBranch* vbfMass_JetSubTotalPileUpUp_branch
    cdef float vbfMass_JetSubTotalPileUpUp_value

    cdef TBranch* vbfMass_JetSubTotalPtDown_branch
    cdef float vbfMass_JetSubTotalPtDown_value

    cdef TBranch* vbfMass_JetSubTotalPtUp_branch
    cdef float vbfMass_JetSubTotalPtUp_value

    cdef TBranch* vbfMass_JetSubTotalRelativeDown_branch
    cdef float vbfMass_JetSubTotalRelativeDown_value

    cdef TBranch* vbfMass_JetSubTotalRelativeUp_branch
    cdef float vbfMass_JetSubTotalRelativeUp_value

    cdef TBranch* vbfMass_JetSubTotalScaleDown_branch
    cdef float vbfMass_JetSubTotalScaleDown_value

    cdef TBranch* vbfMass_JetSubTotalScaleUp_branch
    cdef float vbfMass_JetSubTotalScaleUp_value

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

    cdef TBranch* vbfNJets20_JetEnDown_branch
    cdef float vbfNJets20_JetEnDown_value

    cdef TBranch* vbfNJets20_JetEnUp_branch
    cdef float vbfNJets20_JetEnUp_value

    cdef TBranch* vbfNJets30_branch
    cdef float vbfNJets30_value

    cdef TBranch* vbfNJets30_JetEnDown_branch
    cdef float vbfNJets30_JetEnDown_value

    cdef TBranch* vbfNJets30_JetEnUp_branch
    cdef float vbfNJets30_JetEnUp_value

    cdef TBranch* vbfVispt_branch
    cdef float vbfVispt_value

    cdef TBranch* vbfVispt_JetEnDown_branch
    cdef float vbfVispt_JetEnDown_value

    cdef TBranch* vbfVispt_JetEnUp_branch
    cdef float vbfVispt_JetEnUp_value

    cdef TBranch* vbfdijetpt_branch
    cdef float vbfdijetpt_value

    cdef TBranch* vbfdijetpt_JetEnDown_branch
    cdef float vbfdijetpt_JetEnDown_value

    cdef TBranch* vbfdijetpt_JetEnUp_branch
    cdef float vbfdijetpt_JetEnUp_value

    cdef TBranch* vbfj1eta_branch
    cdef float vbfj1eta_value

    cdef TBranch* vbfj1eta_JetEnDown_branch
    cdef float vbfj1eta_JetEnDown_value

    cdef TBranch* vbfj1eta_JetEnUp_branch
    cdef float vbfj1eta_JetEnUp_value

    cdef TBranch* vbfj1pt_branch
    cdef float vbfj1pt_value

    cdef TBranch* vbfj1pt_JetEnDown_branch
    cdef float vbfj1pt_JetEnDown_value

    cdef TBranch* vbfj1pt_JetEnUp_branch
    cdef float vbfj1pt_JetEnUp_value

    cdef TBranch* vbfj2eta_branch
    cdef float vbfj2eta_value

    cdef TBranch* vbfj2eta_JetEnDown_branch
    cdef float vbfj2eta_JetEnDown_value

    cdef TBranch* vbfj2eta_JetEnUp_branch
    cdef float vbfj2eta_JetEnUp_value

    cdef TBranch* vbfj2pt_branch
    cdef float vbfj2pt_value

    cdef TBranch* vbfj2pt_JetEnDown_branch
    cdef float vbfj2pt_JetEnDown_value

    cdef TBranch* vbfj2pt_JetEnUp_branch
    cdef float vbfj2pt_JetEnUp_value

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

        #print "making EmbPtWeight"
        self.EmbPtWeight_branch = the_tree.GetBranch("EmbPtWeight")
        #if not self.EmbPtWeight_branch and "EmbPtWeight" not in self.complained:
        if not self.EmbPtWeight_branch and "EmbPtWeight":
            warnings.warn( "MuMuTree: Expected branch EmbPtWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("EmbPtWeight")
        else:
            self.EmbPtWeight_branch.SetAddress(<void*>&self.EmbPtWeight_value)

        #print "making Eta"
        self.Eta_branch = the_tree.GetBranch("Eta")
        #if not self.Eta_branch and "Eta" not in self.complained:
        if not self.Eta_branch and "Eta":
            warnings.warn( "MuMuTree: Expected branch Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Eta")
        else:
            self.Eta_branch.SetAddress(<void*>&self.Eta_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_badCloneMuonFilter"
        self.Flag_badCloneMuonFilter_branch = the_tree.GetBranch("Flag_badCloneMuonFilter")
        #if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter" not in self.complained:
        if not self.Flag_badCloneMuonFilter_branch and "Flag_badCloneMuonFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_badCloneMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badCloneMuonFilter")
        else:
            self.Flag_badCloneMuonFilter_branch.SetAddress(<void*>&self.Flag_badCloneMuonFilter_value)

        #print "making Flag_badGlobalMuonFilter"
        self.Flag_badGlobalMuonFilter_branch = the_tree.GetBranch("Flag_badGlobalMuonFilter")
        #if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter" not in self.complained:
        if not self.Flag_badGlobalMuonFilter_branch and "Flag_badGlobalMuonFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_badGlobalMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badGlobalMuonFilter")
        else:
            self.Flag_badGlobalMuonFilter_branch.SetAddress(<void*>&self.Flag_badGlobalMuonFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "MuMuTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "MuMuTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "MuMuTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_globalTightHalo2016Filter"
        self.Flag_globalTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalTightHalo2016Filter")
        #if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalTightHalo2016Filter_branch and "Flag_globalTightHalo2016Filter":
            warnings.warn( "MuMuTree: Expected branch Flag_globalTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalTightHalo2016Filter")
        else:
            self.Flag_globalTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalTightHalo2016Filter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "MuMuTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making Flag_noBadMuons"
        self.Flag_noBadMuons_branch = the_tree.GetBranch("Flag_noBadMuons")
        #if not self.Flag_noBadMuons_branch and "Flag_noBadMuons" not in self.complained:
        if not self.Flag_noBadMuons_branch and "Flag_noBadMuons":
            warnings.warn( "MuMuTree: Expected branch Flag_noBadMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_noBadMuons")
        else:
            self.Flag_noBadMuons_branch.SetAddress(<void*>&self.Flag_noBadMuons_value)

        #print "making GenWeight"
        self.GenWeight_branch = the_tree.GetBranch("GenWeight")
        #if not self.GenWeight_branch and "GenWeight" not in self.complained:
        if not self.GenWeight_branch and "GenWeight":
            warnings.warn( "MuMuTree: Expected branch GenWeight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("GenWeight")
        else:
            self.GenWeight_branch.SetAddress(<void*>&self.GenWeight_value)

        #print "making Ht"
        self.Ht_branch = the_tree.GetBranch("Ht")
        #if not self.Ht_branch and "Ht" not in self.complained:
        if not self.Ht_branch and "Ht":
            warnings.warn( "MuMuTree: Expected branch Ht does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Ht")
        else:
            self.Ht_branch.SetAddress(<void*>&self.Ht_value)

        #print "making LT"
        self.LT_branch = the_tree.GetBranch("LT")
        #if not self.LT_branch and "LT" not in self.complained:
        if not self.LT_branch and "LT":
            warnings.warn( "MuMuTree: Expected branch LT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("LT")
        else:
            self.LT_branch.SetAddress(<void*>&self.LT_value)

        #print "making Mass"
        self.Mass_branch = the_tree.GetBranch("Mass")
        #if not self.Mass_branch and "Mass" not in self.complained:
        if not self.Mass_branch and "Mass":
            warnings.warn( "MuMuTree: Expected branch Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mass")
        else:
            self.Mass_branch.SetAddress(<void*>&self.Mass_value)

        #print "making MassError"
        self.MassError_branch = the_tree.GetBranch("MassError")
        #if not self.MassError_branch and "MassError" not in self.complained:
        if not self.MassError_branch and "MassError":
            warnings.warn( "MuMuTree: Expected branch MassError does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassError")
        else:
            self.MassError_branch.SetAddress(<void*>&self.MassError_value)

        #print "making MassErrord1"
        self.MassErrord1_branch = the_tree.GetBranch("MassErrord1")
        #if not self.MassErrord1_branch and "MassErrord1" not in self.complained:
        if not self.MassErrord1_branch and "MassErrord1":
            warnings.warn( "MuMuTree: Expected branch MassErrord1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord1")
        else:
            self.MassErrord1_branch.SetAddress(<void*>&self.MassErrord1_value)

        #print "making MassErrord2"
        self.MassErrord2_branch = the_tree.GetBranch("MassErrord2")
        #if not self.MassErrord2_branch and "MassErrord2" not in self.complained:
        if not self.MassErrord2_branch and "MassErrord2":
            warnings.warn( "MuMuTree: Expected branch MassErrord2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord2")
        else:
            self.MassErrord2_branch.SetAddress(<void*>&self.MassErrord2_value)

        #print "making MassErrord3"
        self.MassErrord3_branch = the_tree.GetBranch("MassErrord3")
        #if not self.MassErrord3_branch and "MassErrord3" not in self.complained:
        if not self.MassErrord3_branch and "MassErrord3":
            warnings.warn( "MuMuTree: Expected branch MassErrord3 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord3")
        else:
            self.MassErrord3_branch.SetAddress(<void*>&self.MassErrord3_value)

        #print "making MassErrord4"
        self.MassErrord4_branch = the_tree.GetBranch("MassErrord4")
        #if not self.MassErrord4_branch and "MassErrord4" not in self.complained:
        if not self.MassErrord4_branch and "MassErrord4":
            warnings.warn( "MuMuTree: Expected branch MassErrord4 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("MassErrord4")
        else:
            self.MassErrord4_branch.SetAddress(<void*>&self.MassErrord4_value)

        #print "making Mt"
        self.Mt_branch = the_tree.GetBranch("Mt")
        #if not self.Mt_branch and "Mt" not in self.complained:
        if not self.Mt_branch and "Mt":
            warnings.warn( "MuMuTree: Expected branch Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Mt")
        else:
            self.Mt_branch.SetAddress(<void*>&self.Mt_value)

        #print "making NUP"
        self.NUP_branch = the_tree.GetBranch("NUP")
        #if not self.NUP_branch and "NUP" not in self.complained:
        if not self.NUP_branch and "NUP":
            warnings.warn( "MuMuTree: Expected branch NUP does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("NUP")
        else:
            self.NUP_branch.SetAddress(<void*>&self.NUP_value)

        #print "making Phi"
        self.Phi_branch = the_tree.GetBranch("Phi")
        #if not self.Phi_branch and "Phi" not in self.complained:
        if not self.Phi_branch and "Phi":
            warnings.warn( "MuMuTree: Expected branch Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Phi")
        else:
            self.Phi_branch.SetAddress(<void*>&self.Phi_value)

        #print "making Pt"
        self.Pt_branch = the_tree.GetBranch("Pt")
        #if not self.Pt_branch and "Pt" not in self.complained:
        if not self.Pt_branch and "Pt":
            warnings.warn( "MuMuTree: Expected branch Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Pt")
        else:
            self.Pt_branch.SetAddress(<void*>&self.Pt_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "MuMuTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "MuMuTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "MuMuTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "MuMuTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "MuMuTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "MuMuTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "MuMuTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "MuMuTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "MuMuTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_cat_pTjet25GeV"
        self.Rivet_stage1_cat_pTjet25GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet25GeV")
        #if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet25GeV_branch and "Rivet_stage1_cat_pTjet25GeV":
            warnings.warn( "MuMuTree: Expected branch Rivet_stage1_cat_pTjet25GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet25GeV")
        else:
            self.Rivet_stage1_cat_pTjet25GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet25GeV_value)

        #print "making Rivet_stage1_cat_pTjet30GeV"
        self.Rivet_stage1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_cat_pTjet30GeV_branch and "Rivet_stage1_cat_pTjet30GeV":
            warnings.warn( "MuMuTree: Expected branch Rivet_stage1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_cat_pTjet30GeV_value)

        #print "making bjetCISVVeto20Loose"
        self.bjetCISVVeto20Loose_branch = the_tree.GetBranch("bjetCISVVeto20Loose")
        #if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose" not in self.complained:
        if not self.bjetCISVVeto20Loose_branch and "bjetCISVVeto20Loose":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto20Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Loose")
        else:
            self.bjetCISVVeto20Loose_branch.SetAddress(<void*>&self.bjetCISVVeto20Loose_value)

        #print "making bjetCISVVeto20Medium"
        self.bjetCISVVeto20Medium_branch = the_tree.GetBranch("bjetCISVVeto20Medium")
        #if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium" not in self.complained:
        if not self.bjetCISVVeto20Medium_branch and "bjetCISVVeto20Medium":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto20Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Medium")
        else:
            self.bjetCISVVeto20Medium_branch.SetAddress(<void*>&self.bjetCISVVeto20Medium_value)

        #print "making bjetCISVVeto20Tight"
        self.bjetCISVVeto20Tight_branch = the_tree.GetBranch("bjetCISVVeto20Tight")
        #if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight" not in self.complained:
        if not self.bjetCISVVeto20Tight_branch and "bjetCISVVeto20Tight":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto20Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto20Tight")
        else:
            self.bjetCISVVeto20Tight_branch.SetAddress(<void*>&self.bjetCISVVeto20Tight_value)

        #print "making bjetCISVVeto30Loose"
        self.bjetCISVVeto30Loose_branch = the_tree.GetBranch("bjetCISVVeto30Loose")
        #if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose" not in self.complained:
        if not self.bjetCISVVeto30Loose_branch and "bjetCISVVeto30Loose":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto30Loose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Loose")
        else:
            self.bjetCISVVeto30Loose_branch.SetAddress(<void*>&self.bjetCISVVeto30Loose_value)

        #print "making bjetCISVVeto30Medium"
        self.bjetCISVVeto30Medium_branch = the_tree.GetBranch("bjetCISVVeto30Medium")
        #if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium" not in self.complained:
        if not self.bjetCISVVeto30Medium_branch and "bjetCISVVeto30Medium":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto30Medium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Medium")
        else:
            self.bjetCISVVeto30Medium_branch.SetAddress(<void*>&self.bjetCISVVeto30Medium_value)

        #print "making bjetCISVVeto30Tight"
        self.bjetCISVVeto30Tight_branch = the_tree.GetBranch("bjetCISVVeto30Tight")
        #if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight" not in self.complained:
        if not self.bjetCISVVeto30Tight_branch and "bjetCISVVeto30Tight":
            warnings.warn( "MuMuTree: Expected branch bjetCISVVeto30Tight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bjetCISVVeto30Tight")
        else:
            self.bjetCISVVeto30Tight_branch.SetAddress(<void*>&self.bjetCISVVeto30Tight_value)

        #print "making charge"
        self.charge_branch = the_tree.GetBranch("charge")
        #if not self.charge_branch and "charge" not in self.complained:
        if not self.charge_branch and "charge":
            warnings.warn( "MuMuTree: Expected branch charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("charge")
        else:
            self.charge_branch.SetAddress(<void*>&self.charge_value)

        #print "making dielectronVeto"
        self.dielectronVeto_branch = the_tree.GetBranch("dielectronVeto")
        #if not self.dielectronVeto_branch and "dielectronVeto" not in self.complained:
        if not self.dielectronVeto_branch and "dielectronVeto":
            warnings.warn( "MuMuTree: Expected branch dielectronVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dielectronVeto")
        else:
            self.dielectronVeto_branch.SetAddress(<void*>&self.dielectronVeto_value)

        #print "making dimuonVeto"
        self.dimuonVeto_branch = the_tree.GetBranch("dimuonVeto")
        #if not self.dimuonVeto_branch and "dimuonVeto" not in self.complained:
        if not self.dimuonVeto_branch and "dimuonVeto":
            warnings.warn( "MuMuTree: Expected branch dimuonVeto does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("dimuonVeto")
        else:
            self.dimuonVeto_branch.SetAddress(<void*>&self.dimuonVeto_value)

        #print "making doubleESingleMuGroup"
        self.doubleESingleMuGroup_branch = the_tree.GetBranch("doubleESingleMuGroup")
        #if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup" not in self.complained:
        if not self.doubleESingleMuGroup_branch and "doubleESingleMuGroup":
            warnings.warn( "MuMuTree: Expected branch doubleESingleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuGroup")
        else:
            self.doubleESingleMuGroup_branch.SetAddress(<void*>&self.doubleESingleMuGroup_value)

        #print "making doubleESingleMuPass"
        self.doubleESingleMuPass_branch = the_tree.GetBranch("doubleESingleMuPass")
        #if not self.doubleESingleMuPass_branch and "doubleESingleMuPass" not in self.complained:
        if not self.doubleESingleMuPass_branch and "doubleESingleMuPass":
            warnings.warn( "MuMuTree: Expected branch doubleESingleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPass")
        else:
            self.doubleESingleMuPass_branch.SetAddress(<void*>&self.doubleESingleMuPass_value)

        #print "making doubleESingleMuPrescale"
        self.doubleESingleMuPrescale_branch = the_tree.GetBranch("doubleESingleMuPrescale")
        #if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale" not in self.complained:
        if not self.doubleESingleMuPrescale_branch and "doubleESingleMuPrescale":
            warnings.warn( "MuMuTree: Expected branch doubleESingleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleESingleMuPrescale")
        else:
            self.doubleESingleMuPrescale_branch.SetAddress(<void*>&self.doubleESingleMuPrescale_value)

        #print "making doubleE_23_12Group"
        self.doubleE_23_12Group_branch = the_tree.GetBranch("doubleE_23_12Group")
        #if not self.doubleE_23_12Group_branch and "doubleE_23_12Group" not in self.complained:
        if not self.doubleE_23_12Group_branch and "doubleE_23_12Group":
            warnings.warn( "MuMuTree: Expected branch doubleE_23_12Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Group")
        else:
            self.doubleE_23_12Group_branch.SetAddress(<void*>&self.doubleE_23_12Group_value)

        #print "making doubleE_23_12Pass"
        self.doubleE_23_12Pass_branch = the_tree.GetBranch("doubleE_23_12Pass")
        #if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass" not in self.complained:
        if not self.doubleE_23_12Pass_branch and "doubleE_23_12Pass":
            warnings.warn( "MuMuTree: Expected branch doubleE_23_12Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Pass")
        else:
            self.doubleE_23_12Pass_branch.SetAddress(<void*>&self.doubleE_23_12Pass_value)

        #print "making doubleE_23_12Prescale"
        self.doubleE_23_12Prescale_branch = the_tree.GetBranch("doubleE_23_12Prescale")
        #if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale" not in self.complained:
        if not self.doubleE_23_12Prescale_branch and "doubleE_23_12Prescale":
            warnings.warn( "MuMuTree: Expected branch doubleE_23_12Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleE_23_12Prescale")
        else:
            self.doubleE_23_12Prescale_branch.SetAddress(<void*>&self.doubleE_23_12Prescale_value)

        #print "making doubleLooseIsoTau35Group"
        self.doubleLooseIsoTau35Group_branch = the_tree.GetBranch("doubleLooseIsoTau35Group")
        #if not self.doubleLooseIsoTau35Group_branch and "doubleLooseIsoTau35Group" not in self.complained:
        if not self.doubleLooseIsoTau35Group_branch and "doubleLooseIsoTau35Group":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau35Group")
        else:
            self.doubleLooseIsoTau35Group_branch.SetAddress(<void*>&self.doubleLooseIsoTau35Group_value)

        #print "making doubleLooseIsoTau35Pass"
        self.doubleLooseIsoTau35Pass_branch = the_tree.GetBranch("doubleLooseIsoTau35Pass")
        #if not self.doubleLooseIsoTau35Pass_branch and "doubleLooseIsoTau35Pass" not in self.complained:
        if not self.doubleLooseIsoTau35Pass_branch and "doubleLooseIsoTau35Pass":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau35Pass")
        else:
            self.doubleLooseIsoTau35Pass_branch.SetAddress(<void*>&self.doubleLooseIsoTau35Pass_value)

        #print "making doubleLooseIsoTau35Prescale"
        self.doubleLooseIsoTau35Prescale_branch = the_tree.GetBranch("doubleLooseIsoTau35Prescale")
        #if not self.doubleLooseIsoTau35Prescale_branch and "doubleLooseIsoTau35Prescale" not in self.complained:
        if not self.doubleLooseIsoTau35Prescale_branch and "doubleLooseIsoTau35Prescale":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau35Prescale")
        else:
            self.doubleLooseIsoTau35Prescale_branch.SetAddress(<void*>&self.doubleLooseIsoTau35Prescale_value)

        #print "making doubleLooseIsoTau40Group"
        self.doubleLooseIsoTau40Group_branch = the_tree.GetBranch("doubleLooseIsoTau40Group")
        #if not self.doubleLooseIsoTau40Group_branch and "doubleLooseIsoTau40Group" not in self.complained:
        if not self.doubleLooseIsoTau40Group_branch and "doubleLooseIsoTau40Group":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau40Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau40Group")
        else:
            self.doubleLooseIsoTau40Group_branch.SetAddress(<void*>&self.doubleLooseIsoTau40Group_value)

        #print "making doubleLooseIsoTau40Pass"
        self.doubleLooseIsoTau40Pass_branch = the_tree.GetBranch("doubleLooseIsoTau40Pass")
        #if not self.doubleLooseIsoTau40Pass_branch and "doubleLooseIsoTau40Pass" not in self.complained:
        if not self.doubleLooseIsoTau40Pass_branch and "doubleLooseIsoTau40Pass":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau40Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau40Pass")
        else:
            self.doubleLooseIsoTau40Pass_branch.SetAddress(<void*>&self.doubleLooseIsoTau40Pass_value)

        #print "making doubleLooseIsoTau40Prescale"
        self.doubleLooseIsoTau40Prescale_branch = the_tree.GetBranch("doubleLooseIsoTau40Prescale")
        #if not self.doubleLooseIsoTau40Prescale_branch and "doubleLooseIsoTau40Prescale" not in self.complained:
        if not self.doubleLooseIsoTau40Prescale_branch and "doubleLooseIsoTau40Prescale":
            warnings.warn( "MuMuTree: Expected branch doubleLooseIsoTau40Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleLooseIsoTau40Prescale")
        else:
            self.doubleLooseIsoTau40Prescale_branch.SetAddress(<void*>&self.doubleLooseIsoTau40Prescale_value)

        #print "making doubleMuGroup"
        self.doubleMuGroup_branch = the_tree.GetBranch("doubleMuGroup")
        #if not self.doubleMuGroup_branch and "doubleMuGroup" not in self.complained:
        if not self.doubleMuGroup_branch and "doubleMuGroup":
            warnings.warn( "MuMuTree: Expected branch doubleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuGroup")
        else:
            self.doubleMuGroup_branch.SetAddress(<void*>&self.doubleMuGroup_value)

        #print "making doubleMuPass"
        self.doubleMuPass_branch = the_tree.GetBranch("doubleMuPass")
        #if not self.doubleMuPass_branch and "doubleMuPass" not in self.complained:
        if not self.doubleMuPass_branch and "doubleMuPass":
            warnings.warn( "MuMuTree: Expected branch doubleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPass")
        else:
            self.doubleMuPass_branch.SetAddress(<void*>&self.doubleMuPass_value)

        #print "making doubleMuPrescale"
        self.doubleMuPrescale_branch = the_tree.GetBranch("doubleMuPrescale")
        #if not self.doubleMuPrescale_branch and "doubleMuPrescale" not in self.complained:
        if not self.doubleMuPrescale_branch and "doubleMuPrescale":
            warnings.warn( "MuMuTree: Expected branch doubleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuPrescale")
        else:
            self.doubleMuPrescale_branch.SetAddress(<void*>&self.doubleMuPrescale_value)

        #print "making doubleMuSingleEGroup"
        self.doubleMuSingleEGroup_branch = the_tree.GetBranch("doubleMuSingleEGroup")
        #if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup" not in self.complained:
        if not self.doubleMuSingleEGroup_branch and "doubleMuSingleEGroup":
            warnings.warn( "MuMuTree: Expected branch doubleMuSingleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEGroup")
        else:
            self.doubleMuSingleEGroup_branch.SetAddress(<void*>&self.doubleMuSingleEGroup_value)

        #print "making doubleMuSingleEPass"
        self.doubleMuSingleEPass_branch = the_tree.GetBranch("doubleMuSingleEPass")
        #if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass" not in self.complained:
        if not self.doubleMuSingleEPass_branch and "doubleMuSingleEPass":
            warnings.warn( "MuMuTree: Expected branch doubleMuSingleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPass")
        else:
            self.doubleMuSingleEPass_branch.SetAddress(<void*>&self.doubleMuSingleEPass_value)

        #print "making doubleMuSingleEPrescale"
        self.doubleMuSingleEPrescale_branch = the_tree.GetBranch("doubleMuSingleEPrescale")
        #if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale" not in self.complained:
        if not self.doubleMuSingleEPrescale_branch and "doubleMuSingleEPrescale":
            warnings.warn( "MuMuTree: Expected branch doubleMuSingleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleMuSingleEPrescale")
        else:
            self.doubleMuSingleEPrescale_branch.SetAddress(<void*>&self.doubleMuSingleEPrescale_value)

        #print "making doubleTau35Group"
        self.doubleTau35Group_branch = the_tree.GetBranch("doubleTau35Group")
        #if not self.doubleTau35Group_branch and "doubleTau35Group" not in self.complained:
        if not self.doubleTau35Group_branch and "doubleTau35Group":
            warnings.warn( "MuMuTree: Expected branch doubleTau35Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Group")
        else:
            self.doubleTau35Group_branch.SetAddress(<void*>&self.doubleTau35Group_value)

        #print "making doubleTau35Pass"
        self.doubleTau35Pass_branch = the_tree.GetBranch("doubleTau35Pass")
        #if not self.doubleTau35Pass_branch and "doubleTau35Pass" not in self.complained:
        if not self.doubleTau35Pass_branch and "doubleTau35Pass":
            warnings.warn( "MuMuTree: Expected branch doubleTau35Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Pass")
        else:
            self.doubleTau35Pass_branch.SetAddress(<void*>&self.doubleTau35Pass_value)

        #print "making doubleTau35Prescale"
        self.doubleTau35Prescale_branch = the_tree.GetBranch("doubleTau35Prescale")
        #if not self.doubleTau35Prescale_branch and "doubleTau35Prescale" not in self.complained:
        if not self.doubleTau35Prescale_branch and "doubleTau35Prescale":
            warnings.warn( "MuMuTree: Expected branch doubleTau35Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("doubleTau35Prescale")
        else:
            self.doubleTau35Prescale_branch.SetAddress(<void*>&self.doubleTau35Prescale_value)

        #print "making eVetoMVAIso"
        self.eVetoMVAIso_branch = the_tree.GetBranch("eVetoMVAIso")
        #if not self.eVetoMVAIso_branch and "eVetoMVAIso" not in self.complained:
        if not self.eVetoMVAIso_branch and "eVetoMVAIso":
            warnings.warn( "MuMuTree: Expected branch eVetoMVAIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIso")
        else:
            self.eVetoMVAIso_branch.SetAddress(<void*>&self.eVetoMVAIso_value)

        #print "making eVetoMVAIsoVtx"
        self.eVetoMVAIsoVtx_branch = the_tree.GetBranch("eVetoMVAIsoVtx")
        #if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx" not in self.complained:
        if not self.eVetoMVAIsoVtx_branch and "eVetoMVAIsoVtx":
            warnings.warn( "MuMuTree: Expected branch eVetoMVAIsoVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoMVAIsoVtx")
        else:
            self.eVetoMVAIsoVtx_branch.SetAddress(<void*>&self.eVetoMVAIsoVtx_value)

        #print "making eVetoZTTp001dxyz"
        self.eVetoZTTp001dxyz_branch = the_tree.GetBranch("eVetoZTTp001dxyz")
        #if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz" not in self.complained:
        if not self.eVetoZTTp001dxyz_branch and "eVetoZTTp001dxyz":
            warnings.warn( "MuMuTree: Expected branch eVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyz")
        else:
            self.eVetoZTTp001dxyz_branch.SetAddress(<void*>&self.eVetoZTTp001dxyz_value)

        #print "making eVetoZTTp001dxyzR0"
        self.eVetoZTTp001dxyzR0_branch = the_tree.GetBranch("eVetoZTTp001dxyzR0")
        #if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0" not in self.complained:
        if not self.eVetoZTTp001dxyzR0_branch and "eVetoZTTp001dxyzR0":
            warnings.warn( "MuMuTree: Expected branch eVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eVetoZTTp001dxyzR0")
        else:
            self.eVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.eVetoZTTp001dxyzR0_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "MuMuTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genEta"
        self.genEta_branch = the_tree.GetBranch("genEta")
        #if not self.genEta_branch and "genEta" not in self.complained:
        if not self.genEta_branch and "genEta":
            warnings.warn( "MuMuTree: Expected branch genEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genEta")
        else:
            self.genEta_branch.SetAddress(<void*>&self.genEta_value)

        #print "making genHTT"
        self.genHTT_branch = the_tree.GetBranch("genHTT")
        #if not self.genHTT_branch and "genHTT" not in self.complained:
        if not self.genHTT_branch and "genHTT":
            warnings.warn( "MuMuTree: Expected branch genHTT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genHTT")
        else:
            self.genHTT_branch.SetAddress(<void*>&self.genHTT_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "MuMuTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genMass"
        self.genMass_branch = the_tree.GetBranch("genMass")
        #if not self.genMass_branch and "genMass" not in self.complained:
        if not self.genMass_branch and "genMass":
            warnings.warn( "MuMuTree: Expected branch genMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genMass")
        else:
            self.genMass_branch.SetAddress(<void*>&self.genMass_value)

        #print "making genPhi"
        self.genPhi_branch = the_tree.GetBranch("genPhi")
        #if not self.genPhi_branch and "genPhi" not in self.complained:
        if not self.genPhi_branch and "genPhi":
            warnings.warn( "MuMuTree: Expected branch genPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genPhi")
        else:
            self.genPhi_branch.SetAddress(<void*>&self.genPhi_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "MuMuTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "MuMuTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "MuMuTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making isGtautau"
        self.isGtautau_branch = the_tree.GetBranch("isGtautau")
        #if not self.isGtautau_branch and "isGtautau" not in self.complained:
        if not self.isGtautau_branch and "isGtautau":
            warnings.warn( "MuMuTree: Expected branch isGtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isGtautau")
        else:
            self.isGtautau_branch.SetAddress(<void*>&self.isGtautau_value)

        #print "making isWenu"
        self.isWenu_branch = the_tree.GetBranch("isWenu")
        #if not self.isWenu_branch and "isWenu" not in self.complained:
        if not self.isWenu_branch and "isWenu":
            warnings.warn( "MuMuTree: Expected branch isWenu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWenu")
        else:
            self.isWenu_branch.SetAddress(<void*>&self.isWenu_value)

        #print "making isWmunu"
        self.isWmunu_branch = the_tree.GetBranch("isWmunu")
        #if not self.isWmunu_branch and "isWmunu" not in self.complained:
        if not self.isWmunu_branch and "isWmunu":
            warnings.warn( "MuMuTree: Expected branch isWmunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWmunu")
        else:
            self.isWmunu_branch.SetAddress(<void*>&self.isWmunu_value)

        #print "making isWtaunu"
        self.isWtaunu_branch = the_tree.GetBranch("isWtaunu")
        #if not self.isWtaunu_branch and "isWtaunu" not in self.complained:
        if not self.isWtaunu_branch and "isWtaunu":
            warnings.warn( "MuMuTree: Expected branch isWtaunu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isWtaunu")
        else:
            self.isWtaunu_branch.SetAddress(<void*>&self.isWtaunu_value)

        #print "making isZee"
        self.isZee_branch = the_tree.GetBranch("isZee")
        #if not self.isZee_branch and "isZee" not in self.complained:
        if not self.isZee_branch and "isZee":
            warnings.warn( "MuMuTree: Expected branch isZee does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZee")
        else:
            self.isZee_branch.SetAddress(<void*>&self.isZee_value)

        #print "making isZmumu"
        self.isZmumu_branch = the_tree.GetBranch("isZmumu")
        #if not self.isZmumu_branch and "isZmumu" not in self.complained:
        if not self.isZmumu_branch and "isZmumu":
            warnings.warn( "MuMuTree: Expected branch isZmumu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZmumu")
        else:
            self.isZmumu_branch.SetAddress(<void*>&self.isZmumu_value)

        #print "making isZtautau"
        self.isZtautau_branch = the_tree.GetBranch("isZtautau")
        #if not self.isZtautau_branch and "isZtautau" not in self.complained:
        if not self.isZtautau_branch and "isZtautau":
            warnings.warn( "MuMuTree: Expected branch isZtautau does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isZtautau")
        else:
            self.isZtautau_branch.SetAddress(<void*>&self.isZtautau_value)

        #print "making isdata"
        self.isdata_branch = the_tree.GetBranch("isdata")
        #if not self.isdata_branch and "isdata" not in self.complained:
        if not self.isdata_branch and "isdata":
            warnings.warn( "MuMuTree: Expected branch isdata does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("isdata")
        else:
            self.isdata_branch.SetAddress(<void*>&self.isdata_value)

        #print "making j1csv"
        self.j1csv_branch = the_tree.GetBranch("j1csv")
        #if not self.j1csv_branch and "j1csv" not in self.complained:
        if not self.j1csv_branch and "j1csv":
            warnings.warn( "MuMuTree: Expected branch j1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1csv")
        else:
            self.j1csv_branch.SetAddress(<void*>&self.j1csv_value)

        #print "making j1eta"
        self.j1eta_branch = the_tree.GetBranch("j1eta")
        #if not self.j1eta_branch and "j1eta" not in self.complained:
        if not self.j1eta_branch and "j1eta":
            warnings.warn( "MuMuTree: Expected branch j1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1eta")
        else:
            self.j1eta_branch.SetAddress(<void*>&self.j1eta_value)

        #print "making j1hadronflavor"
        self.j1hadronflavor_branch = the_tree.GetBranch("j1hadronflavor")
        #if not self.j1hadronflavor_branch and "j1hadronflavor" not in self.complained:
        if not self.j1hadronflavor_branch and "j1hadronflavor":
            warnings.warn( "MuMuTree: Expected branch j1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1hadronflavor")
        else:
            self.j1hadronflavor_branch.SetAddress(<void*>&self.j1hadronflavor_value)

        #print "making j1partonflavor"
        self.j1partonflavor_branch = the_tree.GetBranch("j1partonflavor")
        #if not self.j1partonflavor_branch and "j1partonflavor" not in self.complained:
        if not self.j1partonflavor_branch and "j1partonflavor":
            warnings.warn( "MuMuTree: Expected branch j1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1partonflavor")
        else:
            self.j1partonflavor_branch.SetAddress(<void*>&self.j1partonflavor_value)

        #print "making j1phi"
        self.j1phi_branch = the_tree.GetBranch("j1phi")
        #if not self.j1phi_branch and "j1phi" not in self.complained:
        if not self.j1phi_branch and "j1phi":
            warnings.warn( "MuMuTree: Expected branch j1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1phi")
        else:
            self.j1phi_branch.SetAddress(<void*>&self.j1phi_value)

        #print "making j1pt"
        self.j1pt_branch = the_tree.GetBranch("j1pt")
        #if not self.j1pt_branch and "j1pt" not in self.complained:
        if not self.j1pt_branch and "j1pt":
            warnings.warn( "MuMuTree: Expected branch j1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pt")
        else:
            self.j1pt_branch.SetAddress(<void*>&self.j1pt_value)

        #print "making j1ptDown"
        self.j1ptDown_branch = the_tree.GetBranch("j1ptDown")
        #if not self.j1ptDown_branch and "j1ptDown" not in self.complained:
        if not self.j1ptDown_branch and "j1ptDown":
            warnings.warn( "MuMuTree: Expected branch j1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptDown")
        else:
            self.j1ptDown_branch.SetAddress(<void*>&self.j1ptDown_value)

        #print "making j1ptUp"
        self.j1ptUp_branch = the_tree.GetBranch("j1ptUp")
        #if not self.j1ptUp_branch and "j1ptUp" not in self.complained:
        if not self.j1ptUp_branch and "j1ptUp":
            warnings.warn( "MuMuTree: Expected branch j1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1ptUp")
        else:
            self.j1ptUp_branch.SetAddress(<void*>&self.j1ptUp_value)

        #print "making j1pu"
        self.j1pu_branch = the_tree.GetBranch("j1pu")
        #if not self.j1pu_branch and "j1pu" not in self.complained:
        if not self.j1pu_branch and "j1pu":
            warnings.warn( "MuMuTree: Expected branch j1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1pu")
        else:
            self.j1pu_branch.SetAddress(<void*>&self.j1pu_value)

        #print "making j1rawf"
        self.j1rawf_branch = the_tree.GetBranch("j1rawf")
        #if not self.j1rawf_branch and "j1rawf" not in self.complained:
        if not self.j1rawf_branch and "j1rawf":
            warnings.warn( "MuMuTree: Expected branch j1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j1rawf")
        else:
            self.j1rawf_branch.SetAddress(<void*>&self.j1rawf_value)

        #print "making j2csv"
        self.j2csv_branch = the_tree.GetBranch("j2csv")
        #if not self.j2csv_branch and "j2csv" not in self.complained:
        if not self.j2csv_branch and "j2csv":
            warnings.warn( "MuMuTree: Expected branch j2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2csv")
        else:
            self.j2csv_branch.SetAddress(<void*>&self.j2csv_value)

        #print "making j2eta"
        self.j2eta_branch = the_tree.GetBranch("j2eta")
        #if not self.j2eta_branch and "j2eta" not in self.complained:
        if not self.j2eta_branch and "j2eta":
            warnings.warn( "MuMuTree: Expected branch j2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2eta")
        else:
            self.j2eta_branch.SetAddress(<void*>&self.j2eta_value)

        #print "making j2hadronflavor"
        self.j2hadronflavor_branch = the_tree.GetBranch("j2hadronflavor")
        #if not self.j2hadronflavor_branch and "j2hadronflavor" not in self.complained:
        if not self.j2hadronflavor_branch and "j2hadronflavor":
            warnings.warn( "MuMuTree: Expected branch j2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2hadronflavor")
        else:
            self.j2hadronflavor_branch.SetAddress(<void*>&self.j2hadronflavor_value)

        #print "making j2partonflavor"
        self.j2partonflavor_branch = the_tree.GetBranch("j2partonflavor")
        #if not self.j2partonflavor_branch and "j2partonflavor" not in self.complained:
        if not self.j2partonflavor_branch and "j2partonflavor":
            warnings.warn( "MuMuTree: Expected branch j2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2partonflavor")
        else:
            self.j2partonflavor_branch.SetAddress(<void*>&self.j2partonflavor_value)

        #print "making j2phi"
        self.j2phi_branch = the_tree.GetBranch("j2phi")
        #if not self.j2phi_branch and "j2phi" not in self.complained:
        if not self.j2phi_branch and "j2phi":
            warnings.warn( "MuMuTree: Expected branch j2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2phi")
        else:
            self.j2phi_branch.SetAddress(<void*>&self.j2phi_value)

        #print "making j2pt"
        self.j2pt_branch = the_tree.GetBranch("j2pt")
        #if not self.j2pt_branch and "j2pt" not in self.complained:
        if not self.j2pt_branch and "j2pt":
            warnings.warn( "MuMuTree: Expected branch j2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pt")
        else:
            self.j2pt_branch.SetAddress(<void*>&self.j2pt_value)

        #print "making j2ptDown"
        self.j2ptDown_branch = the_tree.GetBranch("j2ptDown")
        #if not self.j2ptDown_branch and "j2ptDown" not in self.complained:
        if not self.j2ptDown_branch and "j2ptDown":
            warnings.warn( "MuMuTree: Expected branch j2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptDown")
        else:
            self.j2ptDown_branch.SetAddress(<void*>&self.j2ptDown_value)

        #print "making j2ptUp"
        self.j2ptUp_branch = the_tree.GetBranch("j2ptUp")
        #if not self.j2ptUp_branch and "j2ptUp" not in self.complained:
        if not self.j2ptUp_branch and "j2ptUp":
            warnings.warn( "MuMuTree: Expected branch j2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2ptUp")
        else:
            self.j2ptUp_branch.SetAddress(<void*>&self.j2ptUp_value)

        #print "making j2pu"
        self.j2pu_branch = the_tree.GetBranch("j2pu")
        #if not self.j2pu_branch and "j2pu" not in self.complained:
        if not self.j2pu_branch and "j2pu":
            warnings.warn( "MuMuTree: Expected branch j2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2pu")
        else:
            self.j2pu_branch.SetAddress(<void*>&self.j2pu_value)

        #print "making j2rawf"
        self.j2rawf_branch = the_tree.GetBranch("j2rawf")
        #if not self.j2rawf_branch and "j2rawf" not in self.complained:
        if not self.j2rawf_branch and "j2rawf":
            warnings.warn( "MuMuTree: Expected branch j2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("j2rawf")
        else:
            self.j2rawf_branch.SetAddress(<void*>&self.j2rawf_value)

        #print "making jb1csv"
        self.jb1csv_branch = the_tree.GetBranch("jb1csv")
        #if not self.jb1csv_branch and "jb1csv" not in self.complained:
        if not self.jb1csv_branch and "jb1csv":
            warnings.warn( "MuMuTree: Expected branch jb1csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv")
        else:
            self.jb1csv_branch.SetAddress(<void*>&self.jb1csv_value)

        #print "making jb1csv_CSVL"
        self.jb1csv_CSVL_branch = the_tree.GetBranch("jb1csv_CSVL")
        #if not self.jb1csv_CSVL_branch and "jb1csv_CSVL" not in self.complained:
        if not self.jb1csv_CSVL_branch and "jb1csv_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1csv_CSVL")
        else:
            self.jb1csv_CSVL_branch.SetAddress(<void*>&self.jb1csv_CSVL_value)

        #print "making jb1eta"
        self.jb1eta_branch = the_tree.GetBranch("jb1eta")
        #if not self.jb1eta_branch and "jb1eta" not in self.complained:
        if not self.jb1eta_branch and "jb1eta":
            warnings.warn( "MuMuTree: Expected branch jb1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta")
        else:
            self.jb1eta_branch.SetAddress(<void*>&self.jb1eta_value)

        #print "making jb1eta_CSVL"
        self.jb1eta_CSVL_branch = the_tree.GetBranch("jb1eta_CSVL")
        #if not self.jb1eta_CSVL_branch and "jb1eta_CSVL" not in self.complained:
        if not self.jb1eta_CSVL_branch and "jb1eta_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1eta_CSVL")
        else:
            self.jb1eta_CSVL_branch.SetAddress(<void*>&self.jb1eta_CSVL_value)

        #print "making jb1hadronflavor"
        self.jb1hadronflavor_branch = the_tree.GetBranch("jb1hadronflavor")
        #if not self.jb1hadronflavor_branch and "jb1hadronflavor" not in self.complained:
        if not self.jb1hadronflavor_branch and "jb1hadronflavor":
            warnings.warn( "MuMuTree: Expected branch jb1hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor")
        else:
            self.jb1hadronflavor_branch.SetAddress(<void*>&self.jb1hadronflavor_value)

        #print "making jb1hadronflavor_CSVL"
        self.jb1hadronflavor_CSVL_branch = the_tree.GetBranch("jb1hadronflavor_CSVL")
        #if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL" not in self.complained:
        if not self.jb1hadronflavor_CSVL_branch and "jb1hadronflavor_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1hadronflavor_CSVL")
        else:
            self.jb1hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb1hadronflavor_CSVL_value)

        #print "making jb1partonflavor"
        self.jb1partonflavor_branch = the_tree.GetBranch("jb1partonflavor")
        #if not self.jb1partonflavor_branch and "jb1partonflavor" not in self.complained:
        if not self.jb1partonflavor_branch and "jb1partonflavor":
            warnings.warn( "MuMuTree: Expected branch jb1partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor")
        else:
            self.jb1partonflavor_branch.SetAddress(<void*>&self.jb1partonflavor_value)

        #print "making jb1partonflavor_CSVL"
        self.jb1partonflavor_CSVL_branch = the_tree.GetBranch("jb1partonflavor_CSVL")
        #if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL" not in self.complained:
        if not self.jb1partonflavor_CSVL_branch and "jb1partonflavor_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1partonflavor_CSVL")
        else:
            self.jb1partonflavor_CSVL_branch.SetAddress(<void*>&self.jb1partonflavor_CSVL_value)

        #print "making jb1phi"
        self.jb1phi_branch = the_tree.GetBranch("jb1phi")
        #if not self.jb1phi_branch and "jb1phi" not in self.complained:
        if not self.jb1phi_branch and "jb1phi":
            warnings.warn( "MuMuTree: Expected branch jb1phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi")
        else:
            self.jb1phi_branch.SetAddress(<void*>&self.jb1phi_value)

        #print "making jb1phi_CSVL"
        self.jb1phi_CSVL_branch = the_tree.GetBranch("jb1phi_CSVL")
        #if not self.jb1phi_CSVL_branch and "jb1phi_CSVL" not in self.complained:
        if not self.jb1phi_CSVL_branch and "jb1phi_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1phi_CSVL")
        else:
            self.jb1phi_CSVL_branch.SetAddress(<void*>&self.jb1phi_CSVL_value)

        #print "making jb1pt"
        self.jb1pt_branch = the_tree.GetBranch("jb1pt")
        #if not self.jb1pt_branch and "jb1pt" not in self.complained:
        if not self.jb1pt_branch and "jb1pt":
            warnings.warn( "MuMuTree: Expected branch jb1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt")
        else:
            self.jb1pt_branch.SetAddress(<void*>&self.jb1pt_value)

        #print "making jb1ptDown"
        self.jb1ptDown_branch = the_tree.GetBranch("jb1ptDown")
        #if not self.jb1ptDown_branch and "jb1ptDown" not in self.complained:
        if not self.jb1ptDown_branch and "jb1ptDown":
            warnings.warn( "MuMuTree: Expected branch jb1ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown")
        else:
            self.jb1ptDown_branch.SetAddress(<void*>&self.jb1ptDown_value)

        #print "making jb1ptDown_CSVL"
        self.jb1ptDown_CSVL_branch = the_tree.GetBranch("jb1ptDown_CSVL")
        #if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL" not in self.complained:
        if not self.jb1ptDown_CSVL_branch and "jb1ptDown_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptDown_CSVL")
        else:
            self.jb1ptDown_CSVL_branch.SetAddress(<void*>&self.jb1ptDown_CSVL_value)

        #print "making jb1ptUp"
        self.jb1ptUp_branch = the_tree.GetBranch("jb1ptUp")
        #if not self.jb1ptUp_branch and "jb1ptUp" not in self.complained:
        if not self.jb1ptUp_branch and "jb1ptUp":
            warnings.warn( "MuMuTree: Expected branch jb1ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp")
        else:
            self.jb1ptUp_branch.SetAddress(<void*>&self.jb1ptUp_value)

        #print "making jb1ptUp_CSVL"
        self.jb1ptUp_CSVL_branch = the_tree.GetBranch("jb1ptUp_CSVL")
        #if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL" not in self.complained:
        if not self.jb1ptUp_CSVL_branch and "jb1ptUp_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1ptUp_CSVL")
        else:
            self.jb1ptUp_CSVL_branch.SetAddress(<void*>&self.jb1ptUp_CSVL_value)

        #print "making jb1pt_CSVL"
        self.jb1pt_CSVL_branch = the_tree.GetBranch("jb1pt_CSVL")
        #if not self.jb1pt_CSVL_branch and "jb1pt_CSVL" not in self.complained:
        if not self.jb1pt_CSVL_branch and "jb1pt_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pt_CSVL")
        else:
            self.jb1pt_CSVL_branch.SetAddress(<void*>&self.jb1pt_CSVL_value)

        #print "making jb1pu"
        self.jb1pu_branch = the_tree.GetBranch("jb1pu")
        #if not self.jb1pu_branch and "jb1pu" not in self.complained:
        if not self.jb1pu_branch and "jb1pu":
            warnings.warn( "MuMuTree: Expected branch jb1pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu")
        else:
            self.jb1pu_branch.SetAddress(<void*>&self.jb1pu_value)

        #print "making jb1pu_CSVL"
        self.jb1pu_CSVL_branch = the_tree.GetBranch("jb1pu_CSVL")
        #if not self.jb1pu_CSVL_branch and "jb1pu_CSVL" not in self.complained:
        if not self.jb1pu_CSVL_branch and "jb1pu_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1pu_CSVL")
        else:
            self.jb1pu_CSVL_branch.SetAddress(<void*>&self.jb1pu_CSVL_value)

        #print "making jb1rawf"
        self.jb1rawf_branch = the_tree.GetBranch("jb1rawf")
        #if not self.jb1rawf_branch and "jb1rawf" not in self.complained:
        if not self.jb1rawf_branch and "jb1rawf":
            warnings.warn( "MuMuTree: Expected branch jb1rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf")
        else:
            self.jb1rawf_branch.SetAddress(<void*>&self.jb1rawf_value)

        #print "making jb1rawf_CSVL"
        self.jb1rawf_CSVL_branch = the_tree.GetBranch("jb1rawf_CSVL")
        #if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL" not in self.complained:
        if not self.jb1rawf_CSVL_branch and "jb1rawf_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb1rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb1rawf_CSVL")
        else:
            self.jb1rawf_CSVL_branch.SetAddress(<void*>&self.jb1rawf_CSVL_value)

        #print "making jb2csv"
        self.jb2csv_branch = the_tree.GetBranch("jb2csv")
        #if not self.jb2csv_branch and "jb2csv" not in self.complained:
        if not self.jb2csv_branch and "jb2csv":
            warnings.warn( "MuMuTree: Expected branch jb2csv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv")
        else:
            self.jb2csv_branch.SetAddress(<void*>&self.jb2csv_value)

        #print "making jb2csv_CSVL"
        self.jb2csv_CSVL_branch = the_tree.GetBranch("jb2csv_CSVL")
        #if not self.jb2csv_CSVL_branch and "jb2csv_CSVL" not in self.complained:
        if not self.jb2csv_CSVL_branch and "jb2csv_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2csv_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2csv_CSVL")
        else:
            self.jb2csv_CSVL_branch.SetAddress(<void*>&self.jb2csv_CSVL_value)

        #print "making jb2eta"
        self.jb2eta_branch = the_tree.GetBranch("jb2eta")
        #if not self.jb2eta_branch and "jb2eta" not in self.complained:
        if not self.jb2eta_branch and "jb2eta":
            warnings.warn( "MuMuTree: Expected branch jb2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta")
        else:
            self.jb2eta_branch.SetAddress(<void*>&self.jb2eta_value)

        #print "making jb2eta_CSVL"
        self.jb2eta_CSVL_branch = the_tree.GetBranch("jb2eta_CSVL")
        #if not self.jb2eta_CSVL_branch and "jb2eta_CSVL" not in self.complained:
        if not self.jb2eta_CSVL_branch and "jb2eta_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2eta_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2eta_CSVL")
        else:
            self.jb2eta_CSVL_branch.SetAddress(<void*>&self.jb2eta_CSVL_value)

        #print "making jb2hadronflavor"
        self.jb2hadronflavor_branch = the_tree.GetBranch("jb2hadronflavor")
        #if not self.jb2hadronflavor_branch and "jb2hadronflavor" not in self.complained:
        if not self.jb2hadronflavor_branch and "jb2hadronflavor":
            warnings.warn( "MuMuTree: Expected branch jb2hadronflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor")
        else:
            self.jb2hadronflavor_branch.SetAddress(<void*>&self.jb2hadronflavor_value)

        #print "making jb2hadronflavor_CSVL"
        self.jb2hadronflavor_CSVL_branch = the_tree.GetBranch("jb2hadronflavor_CSVL")
        #if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL" not in self.complained:
        if not self.jb2hadronflavor_CSVL_branch and "jb2hadronflavor_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2hadronflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2hadronflavor_CSVL")
        else:
            self.jb2hadronflavor_CSVL_branch.SetAddress(<void*>&self.jb2hadronflavor_CSVL_value)

        #print "making jb2partonflavor"
        self.jb2partonflavor_branch = the_tree.GetBranch("jb2partonflavor")
        #if not self.jb2partonflavor_branch and "jb2partonflavor" not in self.complained:
        if not self.jb2partonflavor_branch and "jb2partonflavor":
            warnings.warn( "MuMuTree: Expected branch jb2partonflavor does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor")
        else:
            self.jb2partonflavor_branch.SetAddress(<void*>&self.jb2partonflavor_value)

        #print "making jb2partonflavor_CSVL"
        self.jb2partonflavor_CSVL_branch = the_tree.GetBranch("jb2partonflavor_CSVL")
        #if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL" not in self.complained:
        if not self.jb2partonflavor_CSVL_branch and "jb2partonflavor_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2partonflavor_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2partonflavor_CSVL")
        else:
            self.jb2partonflavor_CSVL_branch.SetAddress(<void*>&self.jb2partonflavor_CSVL_value)

        #print "making jb2phi"
        self.jb2phi_branch = the_tree.GetBranch("jb2phi")
        #if not self.jb2phi_branch and "jb2phi" not in self.complained:
        if not self.jb2phi_branch and "jb2phi":
            warnings.warn( "MuMuTree: Expected branch jb2phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi")
        else:
            self.jb2phi_branch.SetAddress(<void*>&self.jb2phi_value)

        #print "making jb2phi_CSVL"
        self.jb2phi_CSVL_branch = the_tree.GetBranch("jb2phi_CSVL")
        #if not self.jb2phi_CSVL_branch and "jb2phi_CSVL" not in self.complained:
        if not self.jb2phi_CSVL_branch and "jb2phi_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2phi_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2phi_CSVL")
        else:
            self.jb2phi_CSVL_branch.SetAddress(<void*>&self.jb2phi_CSVL_value)

        #print "making jb2pt"
        self.jb2pt_branch = the_tree.GetBranch("jb2pt")
        #if not self.jb2pt_branch and "jb2pt" not in self.complained:
        if not self.jb2pt_branch and "jb2pt":
            warnings.warn( "MuMuTree: Expected branch jb2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt")
        else:
            self.jb2pt_branch.SetAddress(<void*>&self.jb2pt_value)

        #print "making jb2ptDown"
        self.jb2ptDown_branch = the_tree.GetBranch("jb2ptDown")
        #if not self.jb2ptDown_branch and "jb2ptDown" not in self.complained:
        if not self.jb2ptDown_branch and "jb2ptDown":
            warnings.warn( "MuMuTree: Expected branch jb2ptDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown")
        else:
            self.jb2ptDown_branch.SetAddress(<void*>&self.jb2ptDown_value)

        #print "making jb2ptDown_CSVL"
        self.jb2ptDown_CSVL_branch = the_tree.GetBranch("jb2ptDown_CSVL")
        #if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL" not in self.complained:
        if not self.jb2ptDown_CSVL_branch and "jb2ptDown_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2ptDown_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptDown_CSVL")
        else:
            self.jb2ptDown_CSVL_branch.SetAddress(<void*>&self.jb2ptDown_CSVL_value)

        #print "making jb2ptUp"
        self.jb2ptUp_branch = the_tree.GetBranch("jb2ptUp")
        #if not self.jb2ptUp_branch and "jb2ptUp" not in self.complained:
        if not self.jb2ptUp_branch and "jb2ptUp":
            warnings.warn( "MuMuTree: Expected branch jb2ptUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp")
        else:
            self.jb2ptUp_branch.SetAddress(<void*>&self.jb2ptUp_value)

        #print "making jb2ptUp_CSVL"
        self.jb2ptUp_CSVL_branch = the_tree.GetBranch("jb2ptUp_CSVL")
        #if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL" not in self.complained:
        if not self.jb2ptUp_CSVL_branch and "jb2ptUp_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2ptUp_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2ptUp_CSVL")
        else:
            self.jb2ptUp_CSVL_branch.SetAddress(<void*>&self.jb2ptUp_CSVL_value)

        #print "making jb2pt_CSVL"
        self.jb2pt_CSVL_branch = the_tree.GetBranch("jb2pt_CSVL")
        #if not self.jb2pt_CSVL_branch and "jb2pt_CSVL" not in self.complained:
        if not self.jb2pt_CSVL_branch and "jb2pt_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2pt_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pt_CSVL")
        else:
            self.jb2pt_CSVL_branch.SetAddress(<void*>&self.jb2pt_CSVL_value)

        #print "making jb2pu"
        self.jb2pu_branch = the_tree.GetBranch("jb2pu")
        #if not self.jb2pu_branch and "jb2pu" not in self.complained:
        if not self.jb2pu_branch and "jb2pu":
            warnings.warn( "MuMuTree: Expected branch jb2pu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu")
        else:
            self.jb2pu_branch.SetAddress(<void*>&self.jb2pu_value)

        #print "making jb2pu_CSVL"
        self.jb2pu_CSVL_branch = the_tree.GetBranch("jb2pu_CSVL")
        #if not self.jb2pu_CSVL_branch and "jb2pu_CSVL" not in self.complained:
        if not self.jb2pu_CSVL_branch and "jb2pu_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2pu_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2pu_CSVL")
        else:
            self.jb2pu_CSVL_branch.SetAddress(<void*>&self.jb2pu_CSVL_value)

        #print "making jb2rawf"
        self.jb2rawf_branch = the_tree.GetBranch("jb2rawf")
        #if not self.jb2rawf_branch and "jb2rawf" not in self.complained:
        if not self.jb2rawf_branch and "jb2rawf":
            warnings.warn( "MuMuTree: Expected branch jb2rawf does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf")
        else:
            self.jb2rawf_branch.SetAddress(<void*>&self.jb2rawf_value)

        #print "making jb2rawf_CSVL"
        self.jb2rawf_CSVL_branch = the_tree.GetBranch("jb2rawf_CSVL")
        #if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL" not in self.complained:
        if not self.jb2rawf_CSVL_branch and "jb2rawf_CSVL":
            warnings.warn( "MuMuTree: Expected branch jb2rawf_CSVL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jb2rawf_CSVL")
        else:
            self.jb2rawf_CSVL_branch.SetAddress(<void*>&self.jb2rawf_CSVL_value)

        #print "making jetVeto20"
        self.jetVeto20_branch = the_tree.GetBranch("jetVeto20")
        #if not self.jetVeto20_branch and "jetVeto20" not in self.complained:
        if not self.jetVeto20_branch and "jetVeto20":
            warnings.warn( "MuMuTree: Expected branch jetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20")
        else:
            self.jetVeto20_branch.SetAddress(<void*>&self.jetVeto20_value)

        #print "making jetVeto20_JetEnDown"
        self.jetVeto20_JetEnDown_branch = the_tree.GetBranch("jetVeto20_JetEnDown")
        #if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown" not in self.complained:
        if not self.jetVeto20_JetEnDown_branch and "jetVeto20_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnDown")
        else:
            self.jetVeto20_JetEnDown_branch.SetAddress(<void*>&self.jetVeto20_JetEnDown_value)

        #print "making jetVeto20_JetEnUp"
        self.jetVeto20_JetEnUp_branch = the_tree.GetBranch("jetVeto20_JetEnUp")
        #if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp" not in self.complained:
        if not self.jetVeto20_JetEnUp_branch and "jetVeto20_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto20_JetEnUp")
        else:
            self.jetVeto20_JetEnUp_branch.SetAddress(<void*>&self.jetVeto20_JetEnUp_value)

        #print "making jetVeto30"
        self.jetVeto30_branch = the_tree.GetBranch("jetVeto30")
        #if not self.jetVeto30_branch and "jetVeto30" not in self.complained:
        if not self.jetVeto30_branch and "jetVeto30":
            warnings.warn( "MuMuTree: Expected branch jetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30")
        else:
            self.jetVeto30_branch.SetAddress(<void*>&self.jetVeto30_value)

        #print "making jetVeto30_JetAbsoluteFlavMapDown"
        self.jetVeto30_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapDown")
        #if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapDown_branch and "jetVeto30_JetAbsoluteFlavMapDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapDown")
        else:
            self.jetVeto30_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapDown_value)

        #print "making jetVeto30_JetAbsoluteFlavMapUp"
        self.jetVeto30_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteFlavMapUp")
        #if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteFlavMapUp_branch and "jetVeto30_JetAbsoluteFlavMapUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteFlavMapUp")
        else:
            self.jetVeto30_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteFlavMapUp_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasDown"
        self.jetVeto30_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasDown")
        #if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasDown_branch and "jetVeto30_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasDown")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasDown_value)

        #print "making jetVeto30_JetAbsoluteMPFBiasUp"
        self.jetVeto30_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteMPFBiasUp")
        #if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteMPFBiasUp_branch and "jetVeto30_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteMPFBiasUp")
        else:
            self.jetVeto30_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteMPFBiasUp_value)

        #print "making jetVeto30_JetAbsoluteScaleDown"
        self.jetVeto30_JetAbsoluteScaleDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleDown")
        #if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleDown_branch and "jetVeto30_JetAbsoluteScaleDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleDown")
        else:
            self.jetVeto30_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleDown_value)

        #print "making jetVeto30_JetAbsoluteScaleUp"
        self.jetVeto30_JetAbsoluteScaleUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteScaleUp")
        #if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteScaleUp_branch and "jetVeto30_JetAbsoluteScaleUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteScaleUp")
        else:
            self.jetVeto30_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteScaleUp_value)

        #print "making jetVeto30_JetAbsoluteStatDown"
        self.jetVeto30_JetAbsoluteStatDown_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatDown")
        #if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatDown_branch and "jetVeto30_JetAbsoluteStatDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatDown")
        else:
            self.jetVeto30_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatDown_value)

        #print "making jetVeto30_JetAbsoluteStatUp"
        self.jetVeto30_JetAbsoluteStatUp_branch = the_tree.GetBranch("jetVeto30_JetAbsoluteStatUp")
        #if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp" not in self.complained:
        if not self.jetVeto30_JetAbsoluteStatUp_branch and "jetVeto30_JetAbsoluteStatUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetAbsoluteStatUp")
        else:
            self.jetVeto30_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.jetVeto30_JetAbsoluteStatUp_value)

        #print "making jetVeto30_JetClosureDown"
        self.jetVeto30_JetClosureDown_branch = the_tree.GetBranch("jetVeto30_JetClosureDown")
        #if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown" not in self.complained:
        if not self.jetVeto30_JetClosureDown_branch and "jetVeto30_JetClosureDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureDown")
        else:
            self.jetVeto30_JetClosureDown_branch.SetAddress(<void*>&self.jetVeto30_JetClosureDown_value)

        #print "making jetVeto30_JetClosureUp"
        self.jetVeto30_JetClosureUp_branch = the_tree.GetBranch("jetVeto30_JetClosureUp")
        #if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp" not in self.complained:
        if not self.jetVeto30_JetClosureUp_branch and "jetVeto30_JetClosureUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetClosureUp")
        else:
            self.jetVeto30_JetClosureUp_branch.SetAddress(<void*>&self.jetVeto30_JetClosureUp_value)

        #print "making jetVeto30_JetEnDown"
        self.jetVeto30_JetEnDown_branch = the_tree.GetBranch("jetVeto30_JetEnDown")
        #if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown" not in self.complained:
        if not self.jetVeto30_JetEnDown_branch and "jetVeto30_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnDown")
        else:
            self.jetVeto30_JetEnDown_branch.SetAddress(<void*>&self.jetVeto30_JetEnDown_value)

        #print "making jetVeto30_JetEnUp"
        self.jetVeto30_JetEnUp_branch = the_tree.GetBranch("jetVeto30_JetEnUp")
        #if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp" not in self.complained:
        if not self.jetVeto30_JetEnUp_branch and "jetVeto30_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetEnUp")
        else:
            self.jetVeto30_JetEnUp_branch.SetAddress(<void*>&self.jetVeto30_JetEnUp_value)

        #print "making jetVeto30_JetFlavorQCDDown"
        self.jetVeto30_JetFlavorQCDDown_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDDown")
        #if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDDown_branch and "jetVeto30_JetFlavorQCDDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDDown")
        else:
            self.jetVeto30_JetFlavorQCDDown_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDDown_value)

        #print "making jetVeto30_JetFlavorQCDUp"
        self.jetVeto30_JetFlavorQCDUp_branch = the_tree.GetBranch("jetVeto30_JetFlavorQCDUp")
        #if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp" not in self.complained:
        if not self.jetVeto30_JetFlavorQCDUp_branch and "jetVeto30_JetFlavorQCDUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFlavorQCDUp")
        else:
            self.jetVeto30_JetFlavorQCDUp_branch.SetAddress(<void*>&self.jetVeto30_JetFlavorQCDUp_value)

        #print "making jetVeto30_JetFragmentationDown"
        self.jetVeto30_JetFragmentationDown_branch = the_tree.GetBranch("jetVeto30_JetFragmentationDown")
        #if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown" not in self.complained:
        if not self.jetVeto30_JetFragmentationDown_branch and "jetVeto30_JetFragmentationDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationDown")
        else:
            self.jetVeto30_JetFragmentationDown_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationDown_value)

        #print "making jetVeto30_JetFragmentationUp"
        self.jetVeto30_JetFragmentationUp_branch = the_tree.GetBranch("jetVeto30_JetFragmentationUp")
        #if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp" not in self.complained:
        if not self.jetVeto30_JetFragmentationUp_branch and "jetVeto30_JetFragmentationUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetFragmentationUp")
        else:
            self.jetVeto30_JetFragmentationUp_branch.SetAddress(<void*>&self.jetVeto30_JetFragmentationUp_value)

        #print "making jetVeto30_JetPileUpDataMCDown"
        self.jetVeto30_JetPileUpDataMCDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCDown")
        #if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCDown_branch and "jetVeto30_JetPileUpDataMCDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCDown")
        else:
            self.jetVeto30_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCDown_value)

        #print "making jetVeto30_JetPileUpDataMCUp"
        self.jetVeto30_JetPileUpDataMCUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpDataMCUp")
        #if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp" not in self.complained:
        if not self.jetVeto30_JetPileUpDataMCUp_branch and "jetVeto30_JetPileUpDataMCUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpDataMCUp")
        else:
            self.jetVeto30_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpDataMCUp_value)

        #print "making jetVeto30_JetPileUpPtBBDown"
        self.jetVeto30_JetPileUpPtBBDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBDown")
        #if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBDown_branch and "jetVeto30_JetPileUpPtBBDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBDown")
        else:
            self.jetVeto30_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBDown_value)

        #print "making jetVeto30_JetPileUpPtBBUp"
        self.jetVeto30_JetPileUpPtBBUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtBBUp")
        #if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtBBUp_branch and "jetVeto30_JetPileUpPtBBUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtBBUp")
        else:
            self.jetVeto30_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtBBUp_value)

        #print "making jetVeto30_JetPileUpPtEC1Down"
        self.jetVeto30_JetPileUpPtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Down")
        #if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Down_branch and "jetVeto30_JetPileUpPtEC1Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Down")
        else:
            self.jetVeto30_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Down_value)

        #print "making jetVeto30_JetPileUpPtEC1Up"
        self.jetVeto30_JetPileUpPtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC1Up")
        #if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC1Up_branch and "jetVeto30_JetPileUpPtEC1Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC1Up")
        else:
            self.jetVeto30_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC1Up_value)

        #print "making jetVeto30_JetPileUpPtEC2Down"
        self.jetVeto30_JetPileUpPtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Down")
        #if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Down_branch and "jetVeto30_JetPileUpPtEC2Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Down")
        else:
            self.jetVeto30_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Down_value)

        #print "making jetVeto30_JetPileUpPtEC2Up"
        self.jetVeto30_JetPileUpPtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtEC2Up")
        #if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up" not in self.complained:
        if not self.jetVeto30_JetPileUpPtEC2Up_branch and "jetVeto30_JetPileUpPtEC2Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtEC2Up")
        else:
            self.jetVeto30_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtEC2Up_value)

        #print "making jetVeto30_JetPileUpPtHFDown"
        self.jetVeto30_JetPileUpPtHFDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFDown")
        #if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFDown_branch and "jetVeto30_JetPileUpPtHFDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFDown")
        else:
            self.jetVeto30_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFDown_value)

        #print "making jetVeto30_JetPileUpPtHFUp"
        self.jetVeto30_JetPileUpPtHFUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtHFUp")
        #if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtHFUp_branch and "jetVeto30_JetPileUpPtHFUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtHFUp")
        else:
            self.jetVeto30_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtHFUp_value)

        #print "making jetVeto30_JetPileUpPtRefDown"
        self.jetVeto30_JetPileUpPtRefDown_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefDown")
        #if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefDown_branch and "jetVeto30_JetPileUpPtRefDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefDown")
        else:
            self.jetVeto30_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefDown_value)

        #print "making jetVeto30_JetPileUpPtRefUp"
        self.jetVeto30_JetPileUpPtRefUp_branch = the_tree.GetBranch("jetVeto30_JetPileUpPtRefUp")
        #if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp" not in self.complained:
        if not self.jetVeto30_JetPileUpPtRefUp_branch and "jetVeto30_JetPileUpPtRefUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetPileUpPtRefUp")
        else:
            self.jetVeto30_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.jetVeto30_JetPileUpPtRefUp_value)

        #print "making jetVeto30_JetRelativeBalDown"
        self.jetVeto30_JetRelativeBalDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalDown")
        #if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown" not in self.complained:
        if not self.jetVeto30_JetRelativeBalDown_branch and "jetVeto30_JetRelativeBalDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalDown")
        else:
            self.jetVeto30_JetRelativeBalDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalDown_value)

        #print "making jetVeto30_JetRelativeBalUp"
        self.jetVeto30_JetRelativeBalUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeBalUp")
        #if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp" not in self.complained:
        if not self.jetVeto30_JetRelativeBalUp_branch and "jetVeto30_JetRelativeBalUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeBalUp")
        else:
            self.jetVeto30_JetRelativeBalUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeBalUp_value)

        #print "making jetVeto30_JetRelativeFSRDown"
        self.jetVeto30_JetRelativeFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRDown")
        #if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRDown_branch and "jetVeto30_JetRelativeFSRDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRDown")
        else:
            self.jetVeto30_JetRelativeFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRDown_value)

        #print "making jetVeto30_JetRelativeFSRUp"
        self.jetVeto30_JetRelativeFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeFSRUp")
        #if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeFSRUp_branch and "jetVeto30_JetRelativeFSRUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeFSRUp")
        else:
            self.jetVeto30_JetRelativeFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeFSRUp_value)

        #print "making jetVeto30_JetRelativeJEREC1Down"
        self.jetVeto30_JetRelativeJEREC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Down")
        #if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Down_branch and "jetVeto30_JetRelativeJEREC1Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Down")
        else:
            self.jetVeto30_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Down_value)

        #print "making jetVeto30_JetRelativeJEREC1Up"
        self.jetVeto30_JetRelativeJEREC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC1Up")
        #if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC1Up_branch and "jetVeto30_JetRelativeJEREC1Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC1Up")
        else:
            self.jetVeto30_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC1Up_value)

        #print "making jetVeto30_JetRelativeJEREC2Down"
        self.jetVeto30_JetRelativeJEREC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Down")
        #if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Down_branch and "jetVeto30_JetRelativeJEREC2Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Down")
        else:
            self.jetVeto30_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Down_value)

        #print "making jetVeto30_JetRelativeJEREC2Up"
        self.jetVeto30_JetRelativeJEREC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativeJEREC2Up")
        #if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativeJEREC2Up_branch and "jetVeto30_JetRelativeJEREC2Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJEREC2Up")
        else:
            self.jetVeto30_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJEREC2Up_value)

        #print "making jetVeto30_JetRelativeJERHFDown"
        self.jetVeto30_JetRelativeJERHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFDown")
        #if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFDown_branch and "jetVeto30_JetRelativeJERHFDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFDown")
        else:
            self.jetVeto30_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFDown_value)

        #print "making jetVeto30_JetRelativeJERHFUp"
        self.jetVeto30_JetRelativeJERHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeJERHFUp")
        #if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeJERHFUp_branch and "jetVeto30_JetRelativeJERHFUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeJERHFUp")
        else:
            self.jetVeto30_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeJERHFUp_value)

        #print "making jetVeto30_JetRelativePtBBDown"
        self.jetVeto30_JetRelativePtBBDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBDown")
        #if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBDown_branch and "jetVeto30_JetRelativePtBBDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBDown")
        else:
            self.jetVeto30_JetRelativePtBBDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBDown_value)

        #print "making jetVeto30_JetRelativePtBBUp"
        self.jetVeto30_JetRelativePtBBUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtBBUp")
        #if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtBBUp_branch and "jetVeto30_JetRelativePtBBUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtBBUp")
        else:
            self.jetVeto30_JetRelativePtBBUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtBBUp_value)

        #print "making jetVeto30_JetRelativePtEC1Down"
        self.jetVeto30_JetRelativePtEC1Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Down")
        #if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Down_branch and "jetVeto30_JetRelativePtEC1Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Down")
        else:
            self.jetVeto30_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Down_value)

        #print "making jetVeto30_JetRelativePtEC1Up"
        self.jetVeto30_JetRelativePtEC1Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC1Up")
        #if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC1Up_branch and "jetVeto30_JetRelativePtEC1Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC1Up")
        else:
            self.jetVeto30_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC1Up_value)

        #print "making jetVeto30_JetRelativePtEC2Down"
        self.jetVeto30_JetRelativePtEC2Down_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Down")
        #if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Down_branch and "jetVeto30_JetRelativePtEC2Down":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Down")
        else:
            self.jetVeto30_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Down_value)

        #print "making jetVeto30_JetRelativePtEC2Up"
        self.jetVeto30_JetRelativePtEC2Up_branch = the_tree.GetBranch("jetVeto30_JetRelativePtEC2Up")
        #if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up" not in self.complained:
        if not self.jetVeto30_JetRelativePtEC2Up_branch and "jetVeto30_JetRelativePtEC2Up":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtEC2Up")
        else:
            self.jetVeto30_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtEC2Up_value)

        #print "making jetVeto30_JetRelativePtHFDown"
        self.jetVeto30_JetRelativePtHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFDown")
        #if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFDown_branch and "jetVeto30_JetRelativePtHFDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFDown")
        else:
            self.jetVeto30_JetRelativePtHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFDown_value)

        #print "making jetVeto30_JetRelativePtHFUp"
        self.jetVeto30_JetRelativePtHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativePtHFUp")
        #if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativePtHFUp_branch and "jetVeto30_JetRelativePtHFUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativePtHFUp")
        else:
            self.jetVeto30_JetRelativePtHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativePtHFUp_value)

        #print "making jetVeto30_JetRelativeStatECDown"
        self.jetVeto30_JetRelativeStatECDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECDown")
        #if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECDown_branch and "jetVeto30_JetRelativeStatECDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECDown")
        else:
            self.jetVeto30_JetRelativeStatECDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECDown_value)

        #print "making jetVeto30_JetRelativeStatECUp"
        self.jetVeto30_JetRelativeStatECUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatECUp")
        #if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatECUp_branch and "jetVeto30_JetRelativeStatECUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatECUp")
        else:
            self.jetVeto30_JetRelativeStatECUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatECUp_value)

        #print "making jetVeto30_JetRelativeStatFSRDown"
        self.jetVeto30_JetRelativeStatFSRDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRDown")
        #if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRDown_branch and "jetVeto30_JetRelativeStatFSRDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRDown")
        else:
            self.jetVeto30_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRDown_value)

        #print "making jetVeto30_JetRelativeStatFSRUp"
        self.jetVeto30_JetRelativeStatFSRUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatFSRUp")
        #if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatFSRUp_branch and "jetVeto30_JetRelativeStatFSRUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatFSRUp")
        else:
            self.jetVeto30_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatFSRUp_value)

        #print "making jetVeto30_JetRelativeStatHFDown"
        self.jetVeto30_JetRelativeStatHFDown_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFDown")
        #if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFDown_branch and "jetVeto30_JetRelativeStatHFDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFDown")
        else:
            self.jetVeto30_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFDown_value)

        #print "making jetVeto30_JetRelativeStatHFUp"
        self.jetVeto30_JetRelativeStatHFUp_branch = the_tree.GetBranch("jetVeto30_JetRelativeStatHFUp")
        #if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp" not in self.complained:
        if not self.jetVeto30_JetRelativeStatHFUp_branch and "jetVeto30_JetRelativeStatHFUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetRelativeStatHFUp")
        else:
            self.jetVeto30_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.jetVeto30_JetRelativeStatHFUp_value)

        #print "making jetVeto30_JetSinglePionECALDown"
        self.jetVeto30_JetSinglePionECALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALDown")
        #if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALDown_branch and "jetVeto30_JetSinglePionECALDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALDown")
        else:
            self.jetVeto30_JetSinglePionECALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALDown_value)

        #print "making jetVeto30_JetSinglePionECALUp"
        self.jetVeto30_JetSinglePionECALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionECALUp")
        #if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionECALUp_branch and "jetVeto30_JetSinglePionECALUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionECALUp")
        else:
            self.jetVeto30_JetSinglePionECALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionECALUp_value)

        #print "making jetVeto30_JetSinglePionHCALDown"
        self.jetVeto30_JetSinglePionHCALDown_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALDown")
        #if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALDown_branch and "jetVeto30_JetSinglePionHCALDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALDown")
        else:
            self.jetVeto30_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALDown_value)

        #print "making jetVeto30_JetSinglePionHCALUp"
        self.jetVeto30_JetSinglePionHCALUp_branch = the_tree.GetBranch("jetVeto30_JetSinglePionHCALUp")
        #if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp" not in self.complained:
        if not self.jetVeto30_JetSinglePionHCALUp_branch and "jetVeto30_JetSinglePionHCALUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSinglePionHCALUp")
        else:
            self.jetVeto30_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.jetVeto30_JetSinglePionHCALUp_value)

        #print "making jetVeto30_JetSubTotalAbsoluteDown"
        self.jetVeto30_JetSubTotalAbsoluteDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalAbsoluteDown")
        #if not self.jetVeto30_JetSubTotalAbsoluteDown_branch and "jetVeto30_JetSubTotalAbsoluteDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalAbsoluteDown_branch and "jetVeto30_JetSubTotalAbsoluteDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalAbsoluteDown")
        else:
            self.jetVeto30_JetSubTotalAbsoluteDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalAbsoluteDown_value)

        #print "making jetVeto30_JetSubTotalAbsoluteUp"
        self.jetVeto30_JetSubTotalAbsoluteUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalAbsoluteUp")
        #if not self.jetVeto30_JetSubTotalAbsoluteUp_branch and "jetVeto30_JetSubTotalAbsoluteUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalAbsoluteUp_branch and "jetVeto30_JetSubTotalAbsoluteUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalAbsoluteUp")
        else:
            self.jetVeto30_JetSubTotalAbsoluteUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalAbsoluteUp_value)

        #print "making jetVeto30_JetSubTotalMCDown"
        self.jetVeto30_JetSubTotalMCDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalMCDown")
        #if not self.jetVeto30_JetSubTotalMCDown_branch and "jetVeto30_JetSubTotalMCDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalMCDown_branch and "jetVeto30_JetSubTotalMCDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalMCDown")
        else:
            self.jetVeto30_JetSubTotalMCDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalMCDown_value)

        #print "making jetVeto30_JetSubTotalMCUp"
        self.jetVeto30_JetSubTotalMCUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalMCUp")
        #if not self.jetVeto30_JetSubTotalMCUp_branch and "jetVeto30_JetSubTotalMCUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalMCUp_branch and "jetVeto30_JetSubTotalMCUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalMCUp")
        else:
            self.jetVeto30_JetSubTotalMCUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalMCUp_value)

        #print "making jetVeto30_JetSubTotalPileUpDown"
        self.jetVeto30_JetSubTotalPileUpDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPileUpDown")
        #if not self.jetVeto30_JetSubTotalPileUpDown_branch and "jetVeto30_JetSubTotalPileUpDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalPileUpDown_branch and "jetVeto30_JetSubTotalPileUpDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalPileUpDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPileUpDown")
        else:
            self.jetVeto30_JetSubTotalPileUpDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPileUpDown_value)

        #print "making jetVeto30_JetSubTotalPileUpUp"
        self.jetVeto30_JetSubTotalPileUpUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPileUpUp")
        #if not self.jetVeto30_JetSubTotalPileUpUp_branch and "jetVeto30_JetSubTotalPileUpUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalPileUpUp_branch and "jetVeto30_JetSubTotalPileUpUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalPileUpUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPileUpUp")
        else:
            self.jetVeto30_JetSubTotalPileUpUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPileUpUp_value)

        #print "making jetVeto30_JetSubTotalPtDown"
        self.jetVeto30_JetSubTotalPtDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPtDown")
        #if not self.jetVeto30_JetSubTotalPtDown_branch and "jetVeto30_JetSubTotalPtDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalPtDown_branch and "jetVeto30_JetSubTotalPtDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalPtDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPtDown")
        else:
            self.jetVeto30_JetSubTotalPtDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPtDown_value)

        #print "making jetVeto30_JetSubTotalPtUp"
        self.jetVeto30_JetSubTotalPtUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalPtUp")
        #if not self.jetVeto30_JetSubTotalPtUp_branch and "jetVeto30_JetSubTotalPtUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalPtUp_branch and "jetVeto30_JetSubTotalPtUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalPtUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalPtUp")
        else:
            self.jetVeto30_JetSubTotalPtUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalPtUp_value)

        #print "making jetVeto30_JetSubTotalRelativeDown"
        self.jetVeto30_JetSubTotalRelativeDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalRelativeDown")
        #if not self.jetVeto30_JetSubTotalRelativeDown_branch and "jetVeto30_JetSubTotalRelativeDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalRelativeDown_branch and "jetVeto30_JetSubTotalRelativeDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalRelativeDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalRelativeDown")
        else:
            self.jetVeto30_JetSubTotalRelativeDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalRelativeDown_value)

        #print "making jetVeto30_JetSubTotalRelativeUp"
        self.jetVeto30_JetSubTotalRelativeUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalRelativeUp")
        #if not self.jetVeto30_JetSubTotalRelativeUp_branch and "jetVeto30_JetSubTotalRelativeUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalRelativeUp_branch and "jetVeto30_JetSubTotalRelativeUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalRelativeUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalRelativeUp")
        else:
            self.jetVeto30_JetSubTotalRelativeUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalRelativeUp_value)

        #print "making jetVeto30_JetSubTotalScaleDown"
        self.jetVeto30_JetSubTotalScaleDown_branch = the_tree.GetBranch("jetVeto30_JetSubTotalScaleDown")
        #if not self.jetVeto30_JetSubTotalScaleDown_branch and "jetVeto30_JetSubTotalScaleDown" not in self.complained:
        if not self.jetVeto30_JetSubTotalScaleDown_branch and "jetVeto30_JetSubTotalScaleDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalScaleDown")
        else:
            self.jetVeto30_JetSubTotalScaleDown_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalScaleDown_value)

        #print "making jetVeto30_JetSubTotalScaleUp"
        self.jetVeto30_JetSubTotalScaleUp_branch = the_tree.GetBranch("jetVeto30_JetSubTotalScaleUp")
        #if not self.jetVeto30_JetSubTotalScaleUp_branch and "jetVeto30_JetSubTotalScaleUp" not in self.complained:
        if not self.jetVeto30_JetSubTotalScaleUp_branch and "jetVeto30_JetSubTotalScaleUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetSubTotalScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetSubTotalScaleUp")
        else:
            self.jetVeto30_JetSubTotalScaleUp_branch.SetAddress(<void*>&self.jetVeto30_JetSubTotalScaleUp_value)

        #print "making jetVeto30_JetTimePtEtaDown"
        self.jetVeto30_JetTimePtEtaDown_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaDown")
        #if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaDown_branch and "jetVeto30_JetTimePtEtaDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaDown")
        else:
            self.jetVeto30_JetTimePtEtaDown_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaDown_value)

        #print "making jetVeto30_JetTimePtEtaUp"
        self.jetVeto30_JetTimePtEtaUp_branch = the_tree.GetBranch("jetVeto30_JetTimePtEtaUp")
        #if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp" not in self.complained:
        if not self.jetVeto30_JetTimePtEtaUp_branch and "jetVeto30_JetTimePtEtaUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTimePtEtaUp")
        else:
            self.jetVeto30_JetTimePtEtaUp_branch.SetAddress(<void*>&self.jetVeto30_JetTimePtEtaUp_value)

        #print "making jetVeto30_JetTotalDown"
        self.jetVeto30_JetTotalDown_branch = the_tree.GetBranch("jetVeto30_JetTotalDown")
        #if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown" not in self.complained:
        if not self.jetVeto30_JetTotalDown_branch and "jetVeto30_JetTotalDown":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalDown")
        else:
            self.jetVeto30_JetTotalDown_branch.SetAddress(<void*>&self.jetVeto30_JetTotalDown_value)

        #print "making jetVeto30_JetTotalUp"
        self.jetVeto30_JetTotalUp_branch = the_tree.GetBranch("jetVeto30_JetTotalUp")
        #if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp" not in self.complained:
        if not self.jetVeto30_JetTotalUp_branch and "jetVeto30_JetTotalUp":
            warnings.warn( "MuMuTree: Expected branch jetVeto30_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jetVeto30_JetTotalUp")
        else:
            self.jetVeto30_JetTotalUp_branch.SetAddress(<void*>&self.jetVeto30_JetTotalUp_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "MuMuTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making m1AbsEta"
        self.m1AbsEta_branch = the_tree.GetBranch("m1AbsEta")
        #if not self.m1AbsEta_branch and "m1AbsEta" not in self.complained:
        if not self.m1AbsEta_branch and "m1AbsEta":
            warnings.warn( "MuMuTree: Expected branch m1AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1AbsEta")
        else:
            self.m1AbsEta_branch.SetAddress(<void*>&self.m1AbsEta_value)

        #print "making m1BestTrackType"
        self.m1BestTrackType_branch = the_tree.GetBranch("m1BestTrackType")
        #if not self.m1BestTrackType_branch and "m1BestTrackType" not in self.complained:
        if not self.m1BestTrackType_branch and "m1BestTrackType":
            warnings.warn( "MuMuTree: Expected branch m1BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1BestTrackType")
        else:
            self.m1BestTrackType_branch.SetAddress(<void*>&self.m1BestTrackType_value)

        #print "making m1Charge"
        self.m1Charge_branch = the_tree.GetBranch("m1Charge")
        #if not self.m1Charge_branch and "m1Charge" not in self.complained:
        if not self.m1Charge_branch and "m1Charge":
            warnings.warn( "MuMuTree: Expected branch m1Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Charge")
        else:
            self.m1Charge_branch.SetAddress(<void*>&self.m1Charge_value)

        #print "making m1Chi2LocalPosition"
        self.m1Chi2LocalPosition_branch = the_tree.GetBranch("m1Chi2LocalPosition")
        #if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition" not in self.complained:
        if not self.m1Chi2LocalPosition_branch and "m1Chi2LocalPosition":
            warnings.warn( "MuMuTree: Expected branch m1Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Chi2LocalPosition")
        else:
            self.m1Chi2LocalPosition_branch.SetAddress(<void*>&self.m1Chi2LocalPosition_value)

        #print "making m1ComesFromHiggs"
        self.m1ComesFromHiggs_branch = the_tree.GetBranch("m1ComesFromHiggs")
        #if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs" not in self.complained:
        if not self.m1ComesFromHiggs_branch and "m1ComesFromHiggs":
            warnings.warn( "MuMuTree: Expected branch m1ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ComesFromHiggs")
        else:
            self.m1ComesFromHiggs_branch.SetAddress(<void*>&self.m1ComesFromHiggs_value)

        #print "making m1DPhiToPfMet_ElectronEnDown"
        self.m1DPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_ElectronEnDown")
        #if not self.m1DPhiToPfMet_ElectronEnDown_branch and "m1DPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_ElectronEnDown_branch and "m1DPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_ElectronEnDown")
        else:
            self.m1DPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_ElectronEnDown_value)

        #print "making m1DPhiToPfMet_ElectronEnUp"
        self.m1DPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_ElectronEnUp")
        #if not self.m1DPhiToPfMet_ElectronEnUp_branch and "m1DPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_ElectronEnUp_branch and "m1DPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_ElectronEnUp")
        else:
            self.m1DPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_ElectronEnUp_value)

        #print "making m1DPhiToPfMet_JetEnDown"
        self.m1DPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_JetEnDown")
        #if not self.m1DPhiToPfMet_JetEnDown_branch and "m1DPhiToPfMet_JetEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_JetEnDown_branch and "m1DPhiToPfMet_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetEnDown")
        else:
            self.m1DPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetEnDown_value)

        #print "making m1DPhiToPfMet_JetEnUp"
        self.m1DPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_JetEnUp")
        #if not self.m1DPhiToPfMet_JetEnUp_branch and "m1DPhiToPfMet_JetEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_JetEnUp_branch and "m1DPhiToPfMet_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetEnUp")
        else:
            self.m1DPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetEnUp_value)

        #print "making m1DPhiToPfMet_JetResDown"
        self.m1DPhiToPfMet_JetResDown_branch = the_tree.GetBranch("m1DPhiToPfMet_JetResDown")
        #if not self.m1DPhiToPfMet_JetResDown_branch and "m1DPhiToPfMet_JetResDown" not in self.complained:
        if not self.m1DPhiToPfMet_JetResDown_branch and "m1DPhiToPfMet_JetResDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetResDown")
        else:
            self.m1DPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetResDown_value)

        #print "making m1DPhiToPfMet_JetResUp"
        self.m1DPhiToPfMet_JetResUp_branch = the_tree.GetBranch("m1DPhiToPfMet_JetResUp")
        #if not self.m1DPhiToPfMet_JetResUp_branch and "m1DPhiToPfMet_JetResUp" not in self.complained:
        if not self.m1DPhiToPfMet_JetResUp_branch and "m1DPhiToPfMet_JetResUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_JetResUp")
        else:
            self.m1DPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_JetResUp_value)

        #print "making m1DPhiToPfMet_MuonEnDown"
        self.m1DPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_MuonEnDown")
        #if not self.m1DPhiToPfMet_MuonEnDown_branch and "m1DPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_MuonEnDown_branch and "m1DPhiToPfMet_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_MuonEnDown")
        else:
            self.m1DPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_MuonEnDown_value)

        #print "making m1DPhiToPfMet_MuonEnUp"
        self.m1DPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_MuonEnUp")
        #if not self.m1DPhiToPfMet_MuonEnUp_branch and "m1DPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_MuonEnUp_branch and "m1DPhiToPfMet_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_MuonEnUp")
        else:
            self.m1DPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_MuonEnUp_value)

        #print "making m1DPhiToPfMet_PhotonEnDown"
        self.m1DPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_PhotonEnDown")
        #if not self.m1DPhiToPfMet_PhotonEnDown_branch and "m1DPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_PhotonEnDown_branch and "m1DPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_PhotonEnDown")
        else:
            self.m1DPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_PhotonEnDown_value)

        #print "making m1DPhiToPfMet_PhotonEnUp"
        self.m1DPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_PhotonEnUp")
        #if not self.m1DPhiToPfMet_PhotonEnUp_branch and "m1DPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_PhotonEnUp_branch and "m1DPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_PhotonEnUp")
        else:
            self.m1DPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_PhotonEnUp_value)

        #print "making m1DPhiToPfMet_TauEnDown"
        self.m1DPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_TauEnDown")
        #if not self.m1DPhiToPfMet_TauEnDown_branch and "m1DPhiToPfMet_TauEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_TauEnDown_branch and "m1DPhiToPfMet_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_TauEnDown")
        else:
            self.m1DPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_TauEnDown_value)

        #print "making m1DPhiToPfMet_TauEnUp"
        self.m1DPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_TauEnUp")
        #if not self.m1DPhiToPfMet_TauEnUp_branch and "m1DPhiToPfMet_TauEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_TauEnUp_branch and "m1DPhiToPfMet_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_TauEnUp")
        else:
            self.m1DPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_TauEnUp_value)

        #print "making m1DPhiToPfMet_UnclusteredEnDown"
        self.m1DPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m1DPhiToPfMet_UnclusteredEnDown")
        #if not self.m1DPhiToPfMet_UnclusteredEnDown_branch and "m1DPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m1DPhiToPfMet_UnclusteredEnDown_branch and "m1DPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_UnclusteredEnDown")
        else:
            self.m1DPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1DPhiToPfMet_UnclusteredEnDown_value)

        #print "making m1DPhiToPfMet_UnclusteredEnUp"
        self.m1DPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m1DPhiToPfMet_UnclusteredEnUp")
        #if not self.m1DPhiToPfMet_UnclusteredEnUp_branch and "m1DPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m1DPhiToPfMet_UnclusteredEnUp_branch and "m1DPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_UnclusteredEnUp")
        else:
            self.m1DPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1DPhiToPfMet_UnclusteredEnUp_value)

        #print "making m1DPhiToPfMet_type1"
        self.m1DPhiToPfMet_type1_branch = the_tree.GetBranch("m1DPhiToPfMet_type1")
        #if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1" not in self.complained:
        if not self.m1DPhiToPfMet_type1_branch and "m1DPhiToPfMet_type1":
            warnings.warn( "MuMuTree: Expected branch m1DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1DPhiToPfMet_type1")
        else:
            self.m1DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m1DPhiToPfMet_type1_value)

        #print "making m1EcalIsoDR03"
        self.m1EcalIsoDR03_branch = the_tree.GetBranch("m1EcalIsoDR03")
        #if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03" not in self.complained:
        if not self.m1EcalIsoDR03_branch and "m1EcalIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m1EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EcalIsoDR03")
        else:
            self.m1EcalIsoDR03_branch.SetAddress(<void*>&self.m1EcalIsoDR03_value)

        #print "making m1EffectiveArea2011"
        self.m1EffectiveArea2011_branch = the_tree.GetBranch("m1EffectiveArea2011")
        #if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011" not in self.complained:
        if not self.m1EffectiveArea2011_branch and "m1EffectiveArea2011":
            warnings.warn( "MuMuTree: Expected branch m1EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2011")
        else:
            self.m1EffectiveArea2011_branch.SetAddress(<void*>&self.m1EffectiveArea2011_value)

        #print "making m1EffectiveArea2012"
        self.m1EffectiveArea2012_branch = the_tree.GetBranch("m1EffectiveArea2012")
        #if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012" not in self.complained:
        if not self.m1EffectiveArea2012_branch and "m1EffectiveArea2012":
            warnings.warn( "MuMuTree: Expected branch m1EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1EffectiveArea2012")
        else:
            self.m1EffectiveArea2012_branch.SetAddress(<void*>&self.m1EffectiveArea2012_value)

        #print "making m1ErsatzGenEta"
        self.m1ErsatzGenEta_branch = the_tree.GetBranch("m1ErsatzGenEta")
        #if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta" not in self.complained:
        if not self.m1ErsatzGenEta_branch and "m1ErsatzGenEta":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenEta")
        else:
            self.m1ErsatzGenEta_branch.SetAddress(<void*>&self.m1ErsatzGenEta_value)

        #print "making m1ErsatzGenM"
        self.m1ErsatzGenM_branch = the_tree.GetBranch("m1ErsatzGenM")
        #if not self.m1ErsatzGenM_branch and "m1ErsatzGenM" not in self.complained:
        if not self.m1ErsatzGenM_branch and "m1ErsatzGenM":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenM")
        else:
            self.m1ErsatzGenM_branch.SetAddress(<void*>&self.m1ErsatzGenM_value)

        #print "making m1ErsatzGenPhi"
        self.m1ErsatzGenPhi_branch = the_tree.GetBranch("m1ErsatzGenPhi")
        #if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi" not in self.complained:
        if not self.m1ErsatzGenPhi_branch and "m1ErsatzGenPhi":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenPhi")
        else:
            self.m1ErsatzGenPhi_branch.SetAddress(<void*>&self.m1ErsatzGenPhi_value)

        #print "making m1ErsatzGenpT"
        self.m1ErsatzGenpT_branch = the_tree.GetBranch("m1ErsatzGenpT")
        #if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT" not in self.complained:
        if not self.m1ErsatzGenpT_branch and "m1ErsatzGenpT":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpT")
        else:
            self.m1ErsatzGenpT_branch.SetAddress(<void*>&self.m1ErsatzGenpT_value)

        #print "making m1ErsatzGenpX"
        self.m1ErsatzGenpX_branch = the_tree.GetBranch("m1ErsatzGenpX")
        #if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX" not in self.complained:
        if not self.m1ErsatzGenpX_branch and "m1ErsatzGenpX":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpX")
        else:
            self.m1ErsatzGenpX_branch.SetAddress(<void*>&self.m1ErsatzGenpX_value)

        #print "making m1ErsatzGenpY"
        self.m1ErsatzGenpY_branch = the_tree.GetBranch("m1ErsatzGenpY")
        #if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY" not in self.complained:
        if not self.m1ErsatzGenpY_branch and "m1ErsatzGenpY":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzGenpY")
        else:
            self.m1ErsatzGenpY_branch.SetAddress(<void*>&self.m1ErsatzGenpY_value)

        #print "making m1ErsatzVispX"
        self.m1ErsatzVispX_branch = the_tree.GetBranch("m1ErsatzVispX")
        #if not self.m1ErsatzVispX_branch and "m1ErsatzVispX" not in self.complained:
        if not self.m1ErsatzVispX_branch and "m1ErsatzVispX":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispX")
        else:
            self.m1ErsatzVispX_branch.SetAddress(<void*>&self.m1ErsatzVispX_value)

        #print "making m1ErsatzVispY"
        self.m1ErsatzVispY_branch = the_tree.GetBranch("m1ErsatzVispY")
        #if not self.m1ErsatzVispY_branch and "m1ErsatzVispY" not in self.complained:
        if not self.m1ErsatzVispY_branch and "m1ErsatzVispY":
            warnings.warn( "MuMuTree: Expected branch m1ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ErsatzVispY")
        else:
            self.m1ErsatzVispY_branch.SetAddress(<void*>&self.m1ErsatzVispY_value)

        #print "making m1Eta"
        self.m1Eta_branch = the_tree.GetBranch("m1Eta")
        #if not self.m1Eta_branch and "m1Eta" not in self.complained:
        if not self.m1Eta_branch and "m1Eta":
            warnings.warn( "MuMuTree: Expected branch m1Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta")
        else:
            self.m1Eta_branch.SetAddress(<void*>&self.m1Eta_value)

        #print "making m1Eta_MuonEnDown"
        self.m1Eta_MuonEnDown_branch = the_tree.GetBranch("m1Eta_MuonEnDown")
        #if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown" not in self.complained:
        if not self.m1Eta_MuonEnDown_branch and "m1Eta_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnDown")
        else:
            self.m1Eta_MuonEnDown_branch.SetAddress(<void*>&self.m1Eta_MuonEnDown_value)

        #print "making m1Eta_MuonEnUp"
        self.m1Eta_MuonEnUp_branch = the_tree.GetBranch("m1Eta_MuonEnUp")
        #if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp" not in self.complained:
        if not self.m1Eta_MuonEnUp_branch and "m1Eta_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Eta_MuonEnUp")
        else:
            self.m1Eta_MuonEnUp_branch.SetAddress(<void*>&self.m1Eta_MuonEnUp_value)

        #print "making m1GenCharge"
        self.m1GenCharge_branch = the_tree.GetBranch("m1GenCharge")
        #if not self.m1GenCharge_branch and "m1GenCharge" not in self.complained:
        if not self.m1GenCharge_branch and "m1GenCharge":
            warnings.warn( "MuMuTree: Expected branch m1GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenCharge")
        else:
            self.m1GenCharge_branch.SetAddress(<void*>&self.m1GenCharge_value)

        #print "making m1GenDirectPromptTauDecayFinalState"
        self.m1GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m1GenDirectPromptTauDecayFinalState")
        #if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m1GenDirectPromptTauDecayFinalState_branch and "m1GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuTree: Expected branch m1GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenDirectPromptTauDecayFinalState")
        else:
            self.m1GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m1GenDirectPromptTauDecayFinalState_value)

        #print "making m1GenEnergy"
        self.m1GenEnergy_branch = the_tree.GetBranch("m1GenEnergy")
        #if not self.m1GenEnergy_branch and "m1GenEnergy" not in self.complained:
        if not self.m1GenEnergy_branch and "m1GenEnergy":
            warnings.warn( "MuMuTree: Expected branch m1GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEnergy")
        else:
            self.m1GenEnergy_branch.SetAddress(<void*>&self.m1GenEnergy_value)

        #print "making m1GenEta"
        self.m1GenEta_branch = the_tree.GetBranch("m1GenEta")
        #if not self.m1GenEta_branch and "m1GenEta" not in self.complained:
        if not self.m1GenEta_branch and "m1GenEta":
            warnings.warn( "MuMuTree: Expected branch m1GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenEta")
        else:
            self.m1GenEta_branch.SetAddress(<void*>&self.m1GenEta_value)

        #print "making m1GenIsPrompt"
        self.m1GenIsPrompt_branch = the_tree.GetBranch("m1GenIsPrompt")
        #if not self.m1GenIsPrompt_branch and "m1GenIsPrompt" not in self.complained:
        if not self.m1GenIsPrompt_branch and "m1GenIsPrompt":
            warnings.warn( "MuMuTree: Expected branch m1GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenIsPrompt")
        else:
            self.m1GenIsPrompt_branch.SetAddress(<void*>&self.m1GenIsPrompt_value)

        #print "making m1GenMotherPdgId"
        self.m1GenMotherPdgId_branch = the_tree.GetBranch("m1GenMotherPdgId")
        #if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId" not in self.complained:
        if not self.m1GenMotherPdgId_branch and "m1GenMotherPdgId":
            warnings.warn( "MuMuTree: Expected branch m1GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenMotherPdgId")
        else:
            self.m1GenMotherPdgId_branch.SetAddress(<void*>&self.m1GenMotherPdgId_value)

        #print "making m1GenParticle"
        self.m1GenParticle_branch = the_tree.GetBranch("m1GenParticle")
        #if not self.m1GenParticle_branch and "m1GenParticle" not in self.complained:
        if not self.m1GenParticle_branch and "m1GenParticle":
            warnings.warn( "MuMuTree: Expected branch m1GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenParticle")
        else:
            self.m1GenParticle_branch.SetAddress(<void*>&self.m1GenParticle_value)

        #print "making m1GenPdgId"
        self.m1GenPdgId_branch = the_tree.GetBranch("m1GenPdgId")
        #if not self.m1GenPdgId_branch and "m1GenPdgId" not in self.complained:
        if not self.m1GenPdgId_branch and "m1GenPdgId":
            warnings.warn( "MuMuTree: Expected branch m1GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPdgId")
        else:
            self.m1GenPdgId_branch.SetAddress(<void*>&self.m1GenPdgId_value)

        #print "making m1GenPhi"
        self.m1GenPhi_branch = the_tree.GetBranch("m1GenPhi")
        #if not self.m1GenPhi_branch and "m1GenPhi" not in self.complained:
        if not self.m1GenPhi_branch and "m1GenPhi":
            warnings.warn( "MuMuTree: Expected branch m1GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPhi")
        else:
            self.m1GenPhi_branch.SetAddress(<void*>&self.m1GenPhi_value)

        #print "making m1GenPrompt"
        self.m1GenPrompt_branch = the_tree.GetBranch("m1GenPrompt")
        #if not self.m1GenPrompt_branch and "m1GenPrompt" not in self.complained:
        if not self.m1GenPrompt_branch and "m1GenPrompt":
            warnings.warn( "MuMuTree: Expected branch m1GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPrompt")
        else:
            self.m1GenPrompt_branch.SetAddress(<void*>&self.m1GenPrompt_value)

        #print "making m1GenPromptFinalState"
        self.m1GenPromptFinalState_branch = the_tree.GetBranch("m1GenPromptFinalState")
        #if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState" not in self.complained:
        if not self.m1GenPromptFinalState_branch and "m1GenPromptFinalState":
            warnings.warn( "MuMuTree: Expected branch m1GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptFinalState")
        else:
            self.m1GenPromptFinalState_branch.SetAddress(<void*>&self.m1GenPromptFinalState_value)

        #print "making m1GenPromptTauDecay"
        self.m1GenPromptTauDecay_branch = the_tree.GetBranch("m1GenPromptTauDecay")
        #if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay" not in self.complained:
        if not self.m1GenPromptTauDecay_branch and "m1GenPromptTauDecay":
            warnings.warn( "MuMuTree: Expected branch m1GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPromptTauDecay")
        else:
            self.m1GenPromptTauDecay_branch.SetAddress(<void*>&self.m1GenPromptTauDecay_value)

        #print "making m1GenPt"
        self.m1GenPt_branch = the_tree.GetBranch("m1GenPt")
        #if not self.m1GenPt_branch and "m1GenPt" not in self.complained:
        if not self.m1GenPt_branch and "m1GenPt":
            warnings.warn( "MuMuTree: Expected branch m1GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenPt")
        else:
            self.m1GenPt_branch.SetAddress(<void*>&self.m1GenPt_value)

        #print "making m1GenTauDecay"
        self.m1GenTauDecay_branch = the_tree.GetBranch("m1GenTauDecay")
        #if not self.m1GenTauDecay_branch and "m1GenTauDecay" not in self.complained:
        if not self.m1GenTauDecay_branch and "m1GenTauDecay":
            warnings.warn( "MuMuTree: Expected branch m1GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenTauDecay")
        else:
            self.m1GenTauDecay_branch.SetAddress(<void*>&self.m1GenTauDecay_value)

        #print "making m1GenVZ"
        self.m1GenVZ_branch = the_tree.GetBranch("m1GenVZ")
        #if not self.m1GenVZ_branch and "m1GenVZ" not in self.complained:
        if not self.m1GenVZ_branch and "m1GenVZ":
            warnings.warn( "MuMuTree: Expected branch m1GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVZ")
        else:
            self.m1GenVZ_branch.SetAddress(<void*>&self.m1GenVZ_value)

        #print "making m1GenVtxPVMatch"
        self.m1GenVtxPVMatch_branch = the_tree.GetBranch("m1GenVtxPVMatch")
        #if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch" not in self.complained:
        if not self.m1GenVtxPVMatch_branch and "m1GenVtxPVMatch":
            warnings.warn( "MuMuTree: Expected branch m1GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1GenVtxPVMatch")
        else:
            self.m1GenVtxPVMatch_branch.SetAddress(<void*>&self.m1GenVtxPVMatch_value)

        #print "making m1HcalIsoDR03"
        self.m1HcalIsoDR03_branch = the_tree.GetBranch("m1HcalIsoDR03")
        #if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03" not in self.complained:
        if not self.m1HcalIsoDR03_branch and "m1HcalIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m1HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1HcalIsoDR03")
        else:
            self.m1HcalIsoDR03_branch.SetAddress(<void*>&self.m1HcalIsoDR03_value)

        #print "making m1IP3D"
        self.m1IP3D_branch = the_tree.GetBranch("m1IP3D")
        #if not self.m1IP3D_branch and "m1IP3D" not in self.complained:
        if not self.m1IP3D_branch and "m1IP3D":
            warnings.warn( "MuMuTree: Expected branch m1IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3D")
        else:
            self.m1IP3D_branch.SetAddress(<void*>&self.m1IP3D_value)

        #print "making m1IP3DErr"
        self.m1IP3DErr_branch = the_tree.GetBranch("m1IP3DErr")
        #if not self.m1IP3DErr_branch and "m1IP3DErr" not in self.complained:
        if not self.m1IP3DErr_branch and "m1IP3DErr":
            warnings.warn( "MuMuTree: Expected branch m1IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IP3DErr")
        else:
            self.m1IP3DErr_branch.SetAddress(<void*>&self.m1IP3DErr_value)

        #print "making m1IsGlobal"
        self.m1IsGlobal_branch = the_tree.GetBranch("m1IsGlobal")
        #if not self.m1IsGlobal_branch and "m1IsGlobal" not in self.complained:
        if not self.m1IsGlobal_branch and "m1IsGlobal":
            warnings.warn( "MuMuTree: Expected branch m1IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsGlobal")
        else:
            self.m1IsGlobal_branch.SetAddress(<void*>&self.m1IsGlobal_value)

        #print "making m1IsPFMuon"
        self.m1IsPFMuon_branch = the_tree.GetBranch("m1IsPFMuon")
        #if not self.m1IsPFMuon_branch and "m1IsPFMuon" not in self.complained:
        if not self.m1IsPFMuon_branch and "m1IsPFMuon":
            warnings.warn( "MuMuTree: Expected branch m1IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsPFMuon")
        else:
            self.m1IsPFMuon_branch.SetAddress(<void*>&self.m1IsPFMuon_value)

        #print "making m1IsTracker"
        self.m1IsTracker_branch = the_tree.GetBranch("m1IsTracker")
        #if not self.m1IsTracker_branch and "m1IsTracker" not in self.complained:
        if not self.m1IsTracker_branch and "m1IsTracker":
            warnings.warn( "MuMuTree: Expected branch m1IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsTracker")
        else:
            self.m1IsTracker_branch.SetAddress(<void*>&self.m1IsTracker_value)

        #print "making m1IsoDB03"
        self.m1IsoDB03_branch = the_tree.GetBranch("m1IsoDB03")
        #if not self.m1IsoDB03_branch and "m1IsoDB03" not in self.complained:
        if not self.m1IsoDB03_branch and "m1IsoDB03":
            warnings.warn( "MuMuTree: Expected branch m1IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB03")
        else:
            self.m1IsoDB03_branch.SetAddress(<void*>&self.m1IsoDB03_value)

        #print "making m1IsoDB04"
        self.m1IsoDB04_branch = the_tree.GetBranch("m1IsoDB04")
        #if not self.m1IsoDB04_branch and "m1IsoDB04" not in self.complained:
        if not self.m1IsoDB04_branch and "m1IsoDB04":
            warnings.warn( "MuMuTree: Expected branch m1IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1IsoDB04")
        else:
            self.m1IsoDB04_branch.SetAddress(<void*>&self.m1IsoDB04_value)

        #print "making m1JetArea"
        self.m1JetArea_branch = the_tree.GetBranch("m1JetArea")
        #if not self.m1JetArea_branch and "m1JetArea" not in self.complained:
        if not self.m1JetArea_branch and "m1JetArea":
            warnings.warn( "MuMuTree: Expected branch m1JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetArea")
        else:
            self.m1JetArea_branch.SetAddress(<void*>&self.m1JetArea_value)

        #print "making m1JetBtag"
        self.m1JetBtag_branch = the_tree.GetBranch("m1JetBtag")
        #if not self.m1JetBtag_branch and "m1JetBtag" not in self.complained:
        if not self.m1JetBtag_branch and "m1JetBtag":
            warnings.warn( "MuMuTree: Expected branch m1JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetBtag")
        else:
            self.m1JetBtag_branch.SetAddress(<void*>&self.m1JetBtag_value)

        #print "making m1JetDR"
        self.m1JetDR_branch = the_tree.GetBranch("m1JetDR")
        #if not self.m1JetDR_branch and "m1JetDR" not in self.complained:
        if not self.m1JetDR_branch and "m1JetDR":
            warnings.warn( "MuMuTree: Expected branch m1JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetDR")
        else:
            self.m1JetDR_branch.SetAddress(<void*>&self.m1JetDR_value)

        #print "making m1JetEtaEtaMoment"
        self.m1JetEtaEtaMoment_branch = the_tree.GetBranch("m1JetEtaEtaMoment")
        #if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment" not in self.complained:
        if not self.m1JetEtaEtaMoment_branch and "m1JetEtaEtaMoment":
            warnings.warn( "MuMuTree: Expected branch m1JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaEtaMoment")
        else:
            self.m1JetEtaEtaMoment_branch.SetAddress(<void*>&self.m1JetEtaEtaMoment_value)

        #print "making m1JetEtaPhiMoment"
        self.m1JetEtaPhiMoment_branch = the_tree.GetBranch("m1JetEtaPhiMoment")
        #if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment" not in self.complained:
        if not self.m1JetEtaPhiMoment_branch and "m1JetEtaPhiMoment":
            warnings.warn( "MuMuTree: Expected branch m1JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiMoment")
        else:
            self.m1JetEtaPhiMoment_branch.SetAddress(<void*>&self.m1JetEtaPhiMoment_value)

        #print "making m1JetEtaPhiSpread"
        self.m1JetEtaPhiSpread_branch = the_tree.GetBranch("m1JetEtaPhiSpread")
        #if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread" not in self.complained:
        if not self.m1JetEtaPhiSpread_branch and "m1JetEtaPhiSpread":
            warnings.warn( "MuMuTree: Expected branch m1JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetEtaPhiSpread")
        else:
            self.m1JetEtaPhiSpread_branch.SetAddress(<void*>&self.m1JetEtaPhiSpread_value)

        #print "making m1JetHadronFlavour"
        self.m1JetHadronFlavour_branch = the_tree.GetBranch("m1JetHadronFlavour")
        #if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour" not in self.complained:
        if not self.m1JetHadronFlavour_branch and "m1JetHadronFlavour":
            warnings.warn( "MuMuTree: Expected branch m1JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetHadronFlavour")
        else:
            self.m1JetHadronFlavour_branch.SetAddress(<void*>&self.m1JetHadronFlavour_value)

        #print "making m1JetPFCISVBtag"
        self.m1JetPFCISVBtag_branch = the_tree.GetBranch("m1JetPFCISVBtag")
        #if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag" not in self.complained:
        if not self.m1JetPFCISVBtag_branch and "m1JetPFCISVBtag":
            warnings.warn( "MuMuTree: Expected branch m1JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPFCISVBtag")
        else:
            self.m1JetPFCISVBtag_branch.SetAddress(<void*>&self.m1JetPFCISVBtag_value)

        #print "making m1JetPartonFlavour"
        self.m1JetPartonFlavour_branch = the_tree.GetBranch("m1JetPartonFlavour")
        #if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour" not in self.complained:
        if not self.m1JetPartonFlavour_branch and "m1JetPartonFlavour":
            warnings.warn( "MuMuTree: Expected branch m1JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPartonFlavour")
        else:
            self.m1JetPartonFlavour_branch.SetAddress(<void*>&self.m1JetPartonFlavour_value)

        #print "making m1JetPhiPhiMoment"
        self.m1JetPhiPhiMoment_branch = the_tree.GetBranch("m1JetPhiPhiMoment")
        #if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment" not in self.complained:
        if not self.m1JetPhiPhiMoment_branch and "m1JetPhiPhiMoment":
            warnings.warn( "MuMuTree: Expected branch m1JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPhiPhiMoment")
        else:
            self.m1JetPhiPhiMoment_branch.SetAddress(<void*>&self.m1JetPhiPhiMoment_value)

        #print "making m1JetPt"
        self.m1JetPt_branch = the_tree.GetBranch("m1JetPt")
        #if not self.m1JetPt_branch and "m1JetPt" not in self.complained:
        if not self.m1JetPt_branch and "m1JetPt":
            warnings.warn( "MuMuTree: Expected branch m1JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1JetPt")
        else:
            self.m1JetPt_branch.SetAddress(<void*>&self.m1JetPt_value)

        #print "making m1LowestMll"
        self.m1LowestMll_branch = the_tree.GetBranch("m1LowestMll")
        #if not self.m1LowestMll_branch and "m1LowestMll" not in self.complained:
        if not self.m1LowestMll_branch and "m1LowestMll":
            warnings.warn( "MuMuTree: Expected branch m1LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1LowestMll")
        else:
            self.m1LowestMll_branch.SetAddress(<void*>&self.m1LowestMll_value)

        #print "making m1Mass"
        self.m1Mass_branch = the_tree.GetBranch("m1Mass")
        #if not self.m1Mass_branch and "m1Mass" not in self.complained:
        if not self.m1Mass_branch and "m1Mass":
            warnings.warn( "MuMuTree: Expected branch m1Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mass")
        else:
            self.m1Mass_branch.SetAddress(<void*>&self.m1Mass_value)

        #print "making m1MatchedStations"
        self.m1MatchedStations_branch = the_tree.GetBranch("m1MatchedStations")
        #if not self.m1MatchedStations_branch and "m1MatchedStations" not in self.complained:
        if not self.m1MatchedStations_branch and "m1MatchedStations":
            warnings.warn( "MuMuTree: Expected branch m1MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchedStations")
        else:
            self.m1MatchedStations_branch.SetAddress(<void*>&self.m1MatchedStations_value)

        #print "making m1MatchesDoubleESingleMu"
        self.m1MatchesDoubleESingleMu_branch = the_tree.GetBranch("m1MatchesDoubleESingleMu")
        #if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu" not in self.complained:
        if not self.m1MatchesDoubleESingleMu_branch and "m1MatchesDoubleESingleMu":
            warnings.warn( "MuMuTree: Expected branch m1MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleESingleMu")
        else:
            self.m1MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleESingleMu_value)

        #print "making m1MatchesDoubleMu"
        self.m1MatchesDoubleMu_branch = the_tree.GetBranch("m1MatchesDoubleMu")
        #if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu" not in self.complained:
        if not self.m1MatchesDoubleMu_branch and "m1MatchesDoubleMu":
            warnings.warn( "MuMuTree: Expected branch m1MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMu")
        else:
            self.m1MatchesDoubleMu_branch.SetAddress(<void*>&self.m1MatchesDoubleMu_value)

        #print "making m1MatchesDoubleMuSingleE"
        self.m1MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m1MatchesDoubleMuSingleE")
        #if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE" not in self.complained:
        if not self.m1MatchesDoubleMuSingleE_branch and "m1MatchesDoubleMuSingleE":
            warnings.warn( "MuMuTree: Expected branch m1MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesDoubleMuSingleE")
        else:
            self.m1MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesDoubleMuSingleE_value)

        #print "making m1MatchesIsoMu24Path"
        self.m1MatchesIsoMu24Path_branch = the_tree.GetBranch("m1MatchesIsoMu24Path")
        #if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path" not in self.complained:
        if not self.m1MatchesIsoMu24Path_branch and "m1MatchesIsoMu24Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24Path")
        else:
            self.m1MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24Path_value)

        #print "making m1MatchesIsoMu24eta2p1Path"
        self.m1MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m1MatchesIsoMu24eta2p1Path")
        #if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m1MatchesIsoMu24eta2p1Path_branch and "m1MatchesIsoMu24eta2p1Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesIsoMu24eta2p1Path")
        else:
            self.m1MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m1MatchesIsoMu24eta2p1Path_value)

        #print "making m1MatchesMu19Tau20Filter"
        self.m1MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20Filter")
        #if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20Filter_branch and "m1MatchesMu19Tau20Filter":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Filter")
        else:
            self.m1MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Filter_value)

        #print "making m1MatchesMu19Tau20Path"
        self.m1MatchesMu19Tau20Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20Path")
        #if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path" not in self.complained:
        if not self.m1MatchesMu19Tau20Path_branch and "m1MatchesMu19Tau20Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20Path")
        else:
            self.m1MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20Path_value)

        #print "making m1MatchesMu19Tau20sL1Filter"
        self.m1MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Filter")
        #if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Filter_branch and "m1MatchesMu19Tau20sL1Filter":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Filter")
        else:
            self.m1MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Filter_value)

        #print "making m1MatchesMu19Tau20sL1Path"
        self.m1MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m1MatchesMu19Tau20sL1Path")
        #if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m1MatchesMu19Tau20sL1Path_branch and "m1MatchesMu19Tau20sL1Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu19Tau20sL1Path")
        else:
            self.m1MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m1MatchesMu19Tau20sL1Path_value)

        #print "making m1MatchesMu21Tau20sL1Filter"
        self.m1MatchesMu21Tau20sL1Filter_branch = the_tree.GetBranch("m1MatchesMu21Tau20sL1Filter")
        #if not self.m1MatchesMu21Tau20sL1Filter_branch and "m1MatchesMu21Tau20sL1Filter" not in self.complained:
        if not self.m1MatchesMu21Tau20sL1Filter_branch and "m1MatchesMu21Tau20sL1Filter":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu21Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu21Tau20sL1Filter")
        else:
            self.m1MatchesMu21Tau20sL1Filter_branch.SetAddress(<void*>&self.m1MatchesMu21Tau20sL1Filter_value)

        #print "making m1MatchesMu21Tau20sL1Path"
        self.m1MatchesMu21Tau20sL1Path_branch = the_tree.GetBranch("m1MatchesMu21Tau20sL1Path")
        #if not self.m1MatchesMu21Tau20sL1Path_branch and "m1MatchesMu21Tau20sL1Path" not in self.complained:
        if not self.m1MatchesMu21Tau20sL1Path_branch and "m1MatchesMu21Tau20sL1Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu21Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu21Tau20sL1Path")
        else:
            self.m1MatchesMu21Tau20sL1Path_branch.SetAddress(<void*>&self.m1MatchesMu21Tau20sL1Path_value)

        #print "making m1MatchesMu23Ele12DZPath"
        self.m1MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("m1MatchesMu23Ele12DZPath")
        #if not self.m1MatchesMu23Ele12DZPath_branch and "m1MatchesMu23Ele12DZPath" not in self.complained:
        if not self.m1MatchesMu23Ele12DZPath_branch and "m1MatchesMu23Ele12DZPath":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23Ele12DZPath")
        else:
            self.m1MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.m1MatchesMu23Ele12DZPath_value)

        #print "making m1MatchesMu23Ele12Path"
        self.m1MatchesMu23Ele12Path_branch = the_tree.GetBranch("m1MatchesMu23Ele12Path")
        #if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path" not in self.complained:
        if not self.m1MatchesMu23Ele12Path_branch and "m1MatchesMu23Ele12Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu23Ele12Path")
        else:
            self.m1MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m1MatchesMu23Ele12Path_value)

        #print "making m1MatchesMu8Ele23DZPath"
        self.m1MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("m1MatchesMu8Ele23DZPath")
        #if not self.m1MatchesMu8Ele23DZPath_branch and "m1MatchesMu8Ele23DZPath" not in self.complained:
        if not self.m1MatchesMu8Ele23DZPath_branch and "m1MatchesMu8Ele23DZPath":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele23DZPath")
        else:
            self.m1MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.m1MatchesMu8Ele23DZPath_value)

        #print "making m1MatchesMu8Ele23Path"
        self.m1MatchesMu8Ele23Path_branch = the_tree.GetBranch("m1MatchesMu8Ele23Path")
        #if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path" not in self.complained:
        if not self.m1MatchesMu8Ele23Path_branch and "m1MatchesMu8Ele23Path":
            warnings.warn( "MuMuTree: Expected branch m1MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesMu8Ele23Path")
        else:
            self.m1MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m1MatchesMu8Ele23Path_value)

        #print "making m1MatchesSingleESingleMu"
        self.m1MatchesSingleESingleMu_branch = the_tree.GetBranch("m1MatchesSingleESingleMu")
        #if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu" not in self.complained:
        if not self.m1MatchesSingleESingleMu_branch and "m1MatchesSingleESingleMu":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleESingleMu")
        else:
            self.m1MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleESingleMu_value)

        #print "making m1MatchesSingleMu"
        self.m1MatchesSingleMu_branch = the_tree.GetBranch("m1MatchesSingleMu")
        #if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu" not in self.complained:
        if not self.m1MatchesSingleMu_branch and "m1MatchesSingleMu":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu")
        else:
            self.m1MatchesSingleMu_branch.SetAddress(<void*>&self.m1MatchesSingleMu_value)

        #print "making m1MatchesSingleMuIso20"
        self.m1MatchesSingleMuIso20_branch = the_tree.GetBranch("m1MatchesSingleMuIso20")
        #if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20" not in self.complained:
        if not self.m1MatchesSingleMuIso20_branch and "m1MatchesSingleMuIso20":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIso20")
        else:
            self.m1MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIso20_value)

        #print "making m1MatchesSingleMuIsoTk20"
        self.m1MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m1MatchesSingleMuIsoTk20")
        #if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m1MatchesSingleMuIsoTk20_branch and "m1MatchesSingleMuIsoTk20":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuIsoTk20")
        else:
            self.m1MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m1MatchesSingleMuIsoTk20_value)

        #print "making m1MatchesSingleMuSingleE"
        self.m1MatchesSingleMuSingleE_branch = the_tree.GetBranch("m1MatchesSingleMuSingleE")
        #if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE" not in self.complained:
        if not self.m1MatchesSingleMuSingleE_branch and "m1MatchesSingleMuSingleE":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMuSingleE")
        else:
            self.m1MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m1MatchesSingleMuSingleE_value)

        #print "making m1MatchesSingleMu_leg1"
        self.m1MatchesSingleMu_leg1_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1")
        #if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_branch and "m1MatchesSingleMu_leg1":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1")
        else:
            self.m1MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_value)

        #print "making m1MatchesSingleMu_leg1_noiso"
        self.m1MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg1_noiso")
        #if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg1_noiso_branch and "m1MatchesSingleMu_leg1_noiso":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg1_noiso")
        else:
            self.m1MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg1_noiso_value)

        #print "making m1MatchesSingleMu_leg2"
        self.m1MatchesSingleMu_leg2_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2")
        #if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_branch and "m1MatchesSingleMu_leg2":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2")
        else:
            self.m1MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_value)

        #print "making m1MatchesSingleMu_leg2_noiso"
        self.m1MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m1MatchesSingleMu_leg2_noiso")
        #if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m1MatchesSingleMu_leg2_noiso_branch and "m1MatchesSingleMu_leg2_noiso":
            warnings.warn( "MuMuTree: Expected branch m1MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesSingleMu_leg2_noiso")
        else:
            self.m1MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m1MatchesSingleMu_leg2_noiso_value)

        #print "making m1MatchesTripleMu"
        self.m1MatchesTripleMu_branch = the_tree.GetBranch("m1MatchesTripleMu")
        #if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu" not in self.complained:
        if not self.m1MatchesTripleMu_branch and "m1MatchesTripleMu":
            warnings.warn( "MuMuTree: Expected branch m1MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MatchesTripleMu")
        else:
            self.m1MatchesTripleMu_branch.SetAddress(<void*>&self.m1MatchesTripleMu_value)

        #print "making m1MtToPfMet_ElectronEnDown"
        self.m1MtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m1MtToPfMet_ElectronEnDown")
        #if not self.m1MtToPfMet_ElectronEnDown_branch and "m1MtToPfMet_ElectronEnDown" not in self.complained:
        if not self.m1MtToPfMet_ElectronEnDown_branch and "m1MtToPfMet_ElectronEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ElectronEnDown")
        else:
            self.m1MtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_ElectronEnDown_value)

        #print "making m1MtToPfMet_ElectronEnUp"
        self.m1MtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m1MtToPfMet_ElectronEnUp")
        #if not self.m1MtToPfMet_ElectronEnUp_branch and "m1MtToPfMet_ElectronEnUp" not in self.complained:
        if not self.m1MtToPfMet_ElectronEnUp_branch and "m1MtToPfMet_ElectronEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_ElectronEnUp")
        else:
            self.m1MtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_ElectronEnUp_value)

        #print "making m1MtToPfMet_JetEnDown"
        self.m1MtToPfMet_JetEnDown_branch = the_tree.GetBranch("m1MtToPfMet_JetEnDown")
        #if not self.m1MtToPfMet_JetEnDown_branch and "m1MtToPfMet_JetEnDown" not in self.complained:
        if not self.m1MtToPfMet_JetEnDown_branch and "m1MtToPfMet_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetEnDown")
        else:
            self.m1MtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_JetEnDown_value)

        #print "making m1MtToPfMet_JetEnUp"
        self.m1MtToPfMet_JetEnUp_branch = the_tree.GetBranch("m1MtToPfMet_JetEnUp")
        #if not self.m1MtToPfMet_JetEnUp_branch and "m1MtToPfMet_JetEnUp" not in self.complained:
        if not self.m1MtToPfMet_JetEnUp_branch and "m1MtToPfMet_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetEnUp")
        else:
            self.m1MtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_JetEnUp_value)

        #print "making m1MtToPfMet_JetResDown"
        self.m1MtToPfMet_JetResDown_branch = the_tree.GetBranch("m1MtToPfMet_JetResDown")
        #if not self.m1MtToPfMet_JetResDown_branch and "m1MtToPfMet_JetResDown" not in self.complained:
        if not self.m1MtToPfMet_JetResDown_branch and "m1MtToPfMet_JetResDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetResDown")
        else:
            self.m1MtToPfMet_JetResDown_branch.SetAddress(<void*>&self.m1MtToPfMet_JetResDown_value)

        #print "making m1MtToPfMet_JetResUp"
        self.m1MtToPfMet_JetResUp_branch = the_tree.GetBranch("m1MtToPfMet_JetResUp")
        #if not self.m1MtToPfMet_JetResUp_branch and "m1MtToPfMet_JetResUp" not in self.complained:
        if not self.m1MtToPfMet_JetResUp_branch and "m1MtToPfMet_JetResUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_JetResUp")
        else:
            self.m1MtToPfMet_JetResUp_branch.SetAddress(<void*>&self.m1MtToPfMet_JetResUp_value)

        #print "making m1MtToPfMet_MuonEnDown"
        self.m1MtToPfMet_MuonEnDown_branch = the_tree.GetBranch("m1MtToPfMet_MuonEnDown")
        #if not self.m1MtToPfMet_MuonEnDown_branch and "m1MtToPfMet_MuonEnDown" not in self.complained:
        if not self.m1MtToPfMet_MuonEnDown_branch and "m1MtToPfMet_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_MuonEnDown")
        else:
            self.m1MtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_MuonEnDown_value)

        #print "making m1MtToPfMet_MuonEnUp"
        self.m1MtToPfMet_MuonEnUp_branch = the_tree.GetBranch("m1MtToPfMet_MuonEnUp")
        #if not self.m1MtToPfMet_MuonEnUp_branch and "m1MtToPfMet_MuonEnUp" not in self.complained:
        if not self.m1MtToPfMet_MuonEnUp_branch and "m1MtToPfMet_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_MuonEnUp")
        else:
            self.m1MtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_MuonEnUp_value)

        #print "making m1MtToPfMet_PhotonEnDown"
        self.m1MtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m1MtToPfMet_PhotonEnDown")
        #if not self.m1MtToPfMet_PhotonEnDown_branch and "m1MtToPfMet_PhotonEnDown" not in self.complained:
        if not self.m1MtToPfMet_PhotonEnDown_branch and "m1MtToPfMet_PhotonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_PhotonEnDown")
        else:
            self.m1MtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_PhotonEnDown_value)

        #print "making m1MtToPfMet_PhotonEnUp"
        self.m1MtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m1MtToPfMet_PhotonEnUp")
        #if not self.m1MtToPfMet_PhotonEnUp_branch and "m1MtToPfMet_PhotonEnUp" not in self.complained:
        if not self.m1MtToPfMet_PhotonEnUp_branch and "m1MtToPfMet_PhotonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_PhotonEnUp")
        else:
            self.m1MtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_PhotonEnUp_value)

        #print "making m1MtToPfMet_Raw"
        self.m1MtToPfMet_Raw_branch = the_tree.GetBranch("m1MtToPfMet_Raw")
        #if not self.m1MtToPfMet_Raw_branch and "m1MtToPfMet_Raw" not in self.complained:
        if not self.m1MtToPfMet_Raw_branch and "m1MtToPfMet_Raw":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_Raw")
        else:
            self.m1MtToPfMet_Raw_branch.SetAddress(<void*>&self.m1MtToPfMet_Raw_value)

        #print "making m1MtToPfMet_TauEnDown"
        self.m1MtToPfMet_TauEnDown_branch = the_tree.GetBranch("m1MtToPfMet_TauEnDown")
        #if not self.m1MtToPfMet_TauEnDown_branch and "m1MtToPfMet_TauEnDown" not in self.complained:
        if not self.m1MtToPfMet_TauEnDown_branch and "m1MtToPfMet_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_TauEnDown")
        else:
            self.m1MtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_TauEnDown_value)

        #print "making m1MtToPfMet_TauEnUp"
        self.m1MtToPfMet_TauEnUp_branch = the_tree.GetBranch("m1MtToPfMet_TauEnUp")
        #if not self.m1MtToPfMet_TauEnUp_branch and "m1MtToPfMet_TauEnUp" not in self.complained:
        if not self.m1MtToPfMet_TauEnUp_branch and "m1MtToPfMet_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_TauEnUp")
        else:
            self.m1MtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_TauEnUp_value)

        #print "making m1MtToPfMet_UnclusteredEnDown"
        self.m1MtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m1MtToPfMet_UnclusteredEnDown")
        #if not self.m1MtToPfMet_UnclusteredEnDown_branch and "m1MtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m1MtToPfMet_UnclusteredEnDown_branch and "m1MtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_UnclusteredEnDown")
        else:
            self.m1MtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1MtToPfMet_UnclusteredEnDown_value)

        #print "making m1MtToPfMet_UnclusteredEnUp"
        self.m1MtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m1MtToPfMet_UnclusteredEnUp")
        #if not self.m1MtToPfMet_UnclusteredEnUp_branch and "m1MtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m1MtToPfMet_UnclusteredEnUp_branch and "m1MtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_UnclusteredEnUp")
        else:
            self.m1MtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1MtToPfMet_UnclusteredEnUp_value)

        #print "making m1MtToPfMet_type1"
        self.m1MtToPfMet_type1_branch = the_tree.GetBranch("m1MtToPfMet_type1")
        #if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1" not in self.complained:
        if not self.m1MtToPfMet_type1_branch and "m1MtToPfMet_type1":
            warnings.warn( "MuMuTree: Expected branch m1MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MtToPfMet_type1")
        else:
            self.m1MtToPfMet_type1_branch.SetAddress(<void*>&self.m1MtToPfMet_type1_value)

        #print "making m1Mu23Ele12DZFilter"
        self.m1Mu23Ele12DZFilter_branch = the_tree.GetBranch("m1Mu23Ele12DZFilter")
        #if not self.m1Mu23Ele12DZFilter_branch and "m1Mu23Ele12DZFilter" not in self.complained:
        if not self.m1Mu23Ele12DZFilter_branch and "m1Mu23Ele12DZFilter":
            warnings.warn( "MuMuTree: Expected branch m1Mu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu23Ele12DZFilter")
        else:
            self.m1Mu23Ele12DZFilter_branch.SetAddress(<void*>&self.m1Mu23Ele12DZFilter_value)

        #print "making m1Mu23Ele12Filter"
        self.m1Mu23Ele12Filter_branch = the_tree.GetBranch("m1Mu23Ele12Filter")
        #if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter" not in self.complained:
        if not self.m1Mu23Ele12Filter_branch and "m1Mu23Ele12Filter":
            warnings.warn( "MuMuTree: Expected branch m1Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu23Ele12Filter")
        else:
            self.m1Mu23Ele12Filter_branch.SetAddress(<void*>&self.m1Mu23Ele12Filter_value)

        #print "making m1Mu8Ele23DZFilter"
        self.m1Mu8Ele23DZFilter_branch = the_tree.GetBranch("m1Mu8Ele23DZFilter")
        #if not self.m1Mu8Ele23DZFilter_branch and "m1Mu8Ele23DZFilter" not in self.complained:
        if not self.m1Mu8Ele23DZFilter_branch and "m1Mu8Ele23DZFilter":
            warnings.warn( "MuMuTree: Expected branch m1Mu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu8Ele23DZFilter")
        else:
            self.m1Mu8Ele23DZFilter_branch.SetAddress(<void*>&self.m1Mu8Ele23DZFilter_value)

        #print "making m1Mu8Ele23Filter"
        self.m1Mu8Ele23Filter_branch = the_tree.GetBranch("m1Mu8Ele23Filter")
        #if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter" not in self.complained:
        if not self.m1Mu8Ele23Filter_branch and "m1Mu8Ele23Filter":
            warnings.warn( "MuMuTree: Expected branch m1Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Mu8Ele23Filter")
        else:
            self.m1Mu8Ele23Filter_branch.SetAddress(<void*>&self.m1Mu8Ele23Filter_value)

        #print "making m1MuonHits"
        self.m1MuonHits_branch = the_tree.GetBranch("m1MuonHits")
        #if not self.m1MuonHits_branch and "m1MuonHits" not in self.complained:
        if not self.m1MuonHits_branch and "m1MuonHits":
            warnings.warn( "MuMuTree: Expected branch m1MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1MuonHits")
        else:
            self.m1MuonHits_branch.SetAddress(<void*>&self.m1MuonHits_value)

        #print "making m1NearestZMass"
        self.m1NearestZMass_branch = the_tree.GetBranch("m1NearestZMass")
        #if not self.m1NearestZMass_branch and "m1NearestZMass" not in self.complained:
        if not self.m1NearestZMass_branch and "m1NearestZMass":
            warnings.warn( "MuMuTree: Expected branch m1NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NearestZMass")
        else:
            self.m1NearestZMass_branch.SetAddress(<void*>&self.m1NearestZMass_value)

        #print "making m1NormTrkChi2"
        self.m1NormTrkChi2_branch = the_tree.GetBranch("m1NormTrkChi2")
        #if not self.m1NormTrkChi2_branch and "m1NormTrkChi2" not in self.complained:
        if not self.m1NormTrkChi2_branch and "m1NormTrkChi2":
            warnings.warn( "MuMuTree: Expected branch m1NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormTrkChi2")
        else:
            self.m1NormTrkChi2_branch.SetAddress(<void*>&self.m1NormTrkChi2_value)

        #print "making m1NormalizedChi2"
        self.m1NormalizedChi2_branch = the_tree.GetBranch("m1NormalizedChi2")
        #if not self.m1NormalizedChi2_branch and "m1NormalizedChi2" not in self.complained:
        if not self.m1NormalizedChi2_branch and "m1NormalizedChi2":
            warnings.warn( "MuMuTree: Expected branch m1NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1NormalizedChi2")
        else:
            self.m1NormalizedChi2_branch.SetAddress(<void*>&self.m1NormalizedChi2_value)

        #print "making m1PFChargedHadronIsoR04"
        self.m1PFChargedHadronIsoR04_branch = the_tree.GetBranch("m1PFChargedHadronIsoR04")
        #if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04" not in self.complained:
        if not self.m1PFChargedHadronIsoR04_branch and "m1PFChargedHadronIsoR04":
            warnings.warn( "MuMuTree: Expected branch m1PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedHadronIsoR04")
        else:
            self.m1PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m1PFChargedHadronIsoR04_value)

        #print "making m1PFChargedIso"
        self.m1PFChargedIso_branch = the_tree.GetBranch("m1PFChargedIso")
        #if not self.m1PFChargedIso_branch and "m1PFChargedIso" not in self.complained:
        if not self.m1PFChargedIso_branch and "m1PFChargedIso":
            warnings.warn( "MuMuTree: Expected branch m1PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFChargedIso")
        else:
            self.m1PFChargedIso_branch.SetAddress(<void*>&self.m1PFChargedIso_value)

        #print "making m1PFIDLoose"
        self.m1PFIDLoose_branch = the_tree.GetBranch("m1PFIDLoose")
        #if not self.m1PFIDLoose_branch and "m1PFIDLoose" not in self.complained:
        if not self.m1PFIDLoose_branch and "m1PFIDLoose":
            warnings.warn( "MuMuTree: Expected branch m1PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDLoose")
        else:
            self.m1PFIDLoose_branch.SetAddress(<void*>&self.m1PFIDLoose_value)

        #print "making m1PFIDMedium"
        self.m1PFIDMedium_branch = the_tree.GetBranch("m1PFIDMedium")
        #if not self.m1PFIDMedium_branch and "m1PFIDMedium" not in self.complained:
        if not self.m1PFIDMedium_branch and "m1PFIDMedium":
            warnings.warn( "MuMuTree: Expected branch m1PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDMedium")
        else:
            self.m1PFIDMedium_branch.SetAddress(<void*>&self.m1PFIDMedium_value)

        #print "making m1PFIDTight"
        self.m1PFIDTight_branch = the_tree.GetBranch("m1PFIDTight")
        #if not self.m1PFIDTight_branch and "m1PFIDTight" not in self.complained:
        if not self.m1PFIDTight_branch and "m1PFIDTight":
            warnings.warn( "MuMuTree: Expected branch m1PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFIDTight")
        else:
            self.m1PFIDTight_branch.SetAddress(<void*>&self.m1PFIDTight_value)

        #print "making m1PFNeutralHadronIsoR04"
        self.m1PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m1PFNeutralHadronIsoR04")
        #if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04" not in self.complained:
        if not self.m1PFNeutralHadronIsoR04_branch and "m1PFNeutralHadronIsoR04":
            warnings.warn( "MuMuTree: Expected branch m1PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralHadronIsoR04")
        else:
            self.m1PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m1PFNeutralHadronIsoR04_value)

        #print "making m1PFNeutralIso"
        self.m1PFNeutralIso_branch = the_tree.GetBranch("m1PFNeutralIso")
        #if not self.m1PFNeutralIso_branch and "m1PFNeutralIso" not in self.complained:
        if not self.m1PFNeutralIso_branch and "m1PFNeutralIso":
            warnings.warn( "MuMuTree: Expected branch m1PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFNeutralIso")
        else:
            self.m1PFNeutralIso_branch.SetAddress(<void*>&self.m1PFNeutralIso_value)

        #print "making m1PFPUChargedIso"
        self.m1PFPUChargedIso_branch = the_tree.GetBranch("m1PFPUChargedIso")
        #if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso" not in self.complained:
        if not self.m1PFPUChargedIso_branch and "m1PFPUChargedIso":
            warnings.warn( "MuMuTree: Expected branch m1PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPUChargedIso")
        else:
            self.m1PFPUChargedIso_branch.SetAddress(<void*>&self.m1PFPUChargedIso_value)

        #print "making m1PFPhotonIso"
        self.m1PFPhotonIso_branch = the_tree.GetBranch("m1PFPhotonIso")
        #if not self.m1PFPhotonIso_branch and "m1PFPhotonIso" not in self.complained:
        if not self.m1PFPhotonIso_branch and "m1PFPhotonIso":
            warnings.warn( "MuMuTree: Expected branch m1PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIso")
        else:
            self.m1PFPhotonIso_branch.SetAddress(<void*>&self.m1PFPhotonIso_value)

        #print "making m1PFPhotonIsoR04"
        self.m1PFPhotonIsoR04_branch = the_tree.GetBranch("m1PFPhotonIsoR04")
        #if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04" not in self.complained:
        if not self.m1PFPhotonIsoR04_branch and "m1PFPhotonIsoR04":
            warnings.warn( "MuMuTree: Expected branch m1PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPhotonIsoR04")
        else:
            self.m1PFPhotonIsoR04_branch.SetAddress(<void*>&self.m1PFPhotonIsoR04_value)

        #print "making m1PFPileupIsoR04"
        self.m1PFPileupIsoR04_branch = the_tree.GetBranch("m1PFPileupIsoR04")
        #if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04" not in self.complained:
        if not self.m1PFPileupIsoR04_branch and "m1PFPileupIsoR04":
            warnings.warn( "MuMuTree: Expected branch m1PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PFPileupIsoR04")
        else:
            self.m1PFPileupIsoR04_branch.SetAddress(<void*>&self.m1PFPileupIsoR04_value)

        #print "making m1PVDXY"
        self.m1PVDXY_branch = the_tree.GetBranch("m1PVDXY")
        #if not self.m1PVDXY_branch and "m1PVDXY" not in self.complained:
        if not self.m1PVDXY_branch and "m1PVDXY":
            warnings.warn( "MuMuTree: Expected branch m1PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDXY")
        else:
            self.m1PVDXY_branch.SetAddress(<void*>&self.m1PVDXY_value)

        #print "making m1PVDZ"
        self.m1PVDZ_branch = the_tree.GetBranch("m1PVDZ")
        #if not self.m1PVDZ_branch and "m1PVDZ" not in self.complained:
        if not self.m1PVDZ_branch and "m1PVDZ":
            warnings.warn( "MuMuTree: Expected branch m1PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PVDZ")
        else:
            self.m1PVDZ_branch.SetAddress(<void*>&self.m1PVDZ_value)

        #print "making m1Phi"
        self.m1Phi_branch = the_tree.GetBranch("m1Phi")
        #if not self.m1Phi_branch and "m1Phi" not in self.complained:
        if not self.m1Phi_branch and "m1Phi":
            warnings.warn( "MuMuTree: Expected branch m1Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi")
        else:
            self.m1Phi_branch.SetAddress(<void*>&self.m1Phi_value)

        #print "making m1Phi_MuonEnDown"
        self.m1Phi_MuonEnDown_branch = the_tree.GetBranch("m1Phi_MuonEnDown")
        #if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown" not in self.complained:
        if not self.m1Phi_MuonEnDown_branch and "m1Phi_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnDown")
        else:
            self.m1Phi_MuonEnDown_branch.SetAddress(<void*>&self.m1Phi_MuonEnDown_value)

        #print "making m1Phi_MuonEnUp"
        self.m1Phi_MuonEnUp_branch = the_tree.GetBranch("m1Phi_MuonEnUp")
        #if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp" not in self.complained:
        if not self.m1Phi_MuonEnUp_branch and "m1Phi_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Phi_MuonEnUp")
        else:
            self.m1Phi_MuonEnUp_branch.SetAddress(<void*>&self.m1Phi_MuonEnUp_value)

        #print "making m1PixHits"
        self.m1PixHits_branch = the_tree.GetBranch("m1PixHits")
        #if not self.m1PixHits_branch and "m1PixHits" not in self.complained:
        if not self.m1PixHits_branch and "m1PixHits":
            warnings.warn( "MuMuTree: Expected branch m1PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1PixHits")
        else:
            self.m1PixHits_branch.SetAddress(<void*>&self.m1PixHits_value)

        #print "making m1Pt"
        self.m1Pt_branch = the_tree.GetBranch("m1Pt")
        #if not self.m1Pt_branch and "m1Pt" not in self.complained:
        if not self.m1Pt_branch and "m1Pt":
            warnings.warn( "MuMuTree: Expected branch m1Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt")
        else:
            self.m1Pt_branch.SetAddress(<void*>&self.m1Pt_value)

        #print "making m1Pt_MuonEnDown"
        self.m1Pt_MuonEnDown_branch = the_tree.GetBranch("m1Pt_MuonEnDown")
        #if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown" not in self.complained:
        if not self.m1Pt_MuonEnDown_branch and "m1Pt_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m1Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnDown")
        else:
            self.m1Pt_MuonEnDown_branch.SetAddress(<void*>&self.m1Pt_MuonEnDown_value)

        #print "making m1Pt_MuonEnUp"
        self.m1Pt_MuonEnUp_branch = the_tree.GetBranch("m1Pt_MuonEnUp")
        #if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp" not in self.complained:
        if not self.m1Pt_MuonEnUp_branch and "m1Pt_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m1Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Pt_MuonEnUp")
        else:
            self.m1Pt_MuonEnUp_branch.SetAddress(<void*>&self.m1Pt_MuonEnUp_value)

        #print "making m1Rank"
        self.m1Rank_branch = the_tree.GetBranch("m1Rank")
        #if not self.m1Rank_branch and "m1Rank" not in self.complained:
        if not self.m1Rank_branch and "m1Rank":
            warnings.warn( "MuMuTree: Expected branch m1Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rank")
        else:
            self.m1Rank_branch.SetAddress(<void*>&self.m1Rank_value)

        #print "making m1RelPFIsoDBDefault"
        self.m1RelPFIsoDBDefault_branch = the_tree.GetBranch("m1RelPFIsoDBDefault")
        #if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault" not in self.complained:
        if not self.m1RelPFIsoDBDefault_branch and "m1RelPFIsoDBDefault":
            warnings.warn( "MuMuTree: Expected branch m1RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefault")
        else:
            self.m1RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefault_value)

        #print "making m1RelPFIsoDBDefaultR04"
        self.m1RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m1RelPFIsoDBDefaultR04")
        #if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m1RelPFIsoDBDefaultR04_branch and "m1RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuTree: Expected branch m1RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoDBDefaultR04")
        else:
            self.m1RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m1RelPFIsoDBDefaultR04_value)

        #print "making m1RelPFIsoRho"
        self.m1RelPFIsoRho_branch = the_tree.GetBranch("m1RelPFIsoRho")
        #if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho" not in self.complained:
        if not self.m1RelPFIsoRho_branch and "m1RelPFIsoRho":
            warnings.warn( "MuMuTree: Expected branch m1RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1RelPFIsoRho")
        else:
            self.m1RelPFIsoRho_branch.SetAddress(<void*>&self.m1RelPFIsoRho_value)

        #print "making m1Rho"
        self.m1Rho_branch = the_tree.GetBranch("m1Rho")
        #if not self.m1Rho_branch and "m1Rho" not in self.complained:
        if not self.m1Rho_branch and "m1Rho":
            warnings.warn( "MuMuTree: Expected branch m1Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1Rho")
        else:
            self.m1Rho_branch.SetAddress(<void*>&self.m1Rho_value)

        #print "making m1SIP2D"
        self.m1SIP2D_branch = the_tree.GetBranch("m1SIP2D")
        #if not self.m1SIP2D_branch and "m1SIP2D" not in self.complained:
        if not self.m1SIP2D_branch and "m1SIP2D":
            warnings.warn( "MuMuTree: Expected branch m1SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP2D")
        else:
            self.m1SIP2D_branch.SetAddress(<void*>&self.m1SIP2D_value)

        #print "making m1SIP3D"
        self.m1SIP3D_branch = the_tree.GetBranch("m1SIP3D")
        #if not self.m1SIP3D_branch and "m1SIP3D" not in self.complained:
        if not self.m1SIP3D_branch and "m1SIP3D":
            warnings.warn( "MuMuTree: Expected branch m1SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SIP3D")
        else:
            self.m1SIP3D_branch.SetAddress(<void*>&self.m1SIP3D_value)

        #print "making m1SegmentCompatibility"
        self.m1SegmentCompatibility_branch = the_tree.GetBranch("m1SegmentCompatibility")
        #if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility" not in self.complained:
        if not self.m1SegmentCompatibility_branch and "m1SegmentCompatibility":
            warnings.warn( "MuMuTree: Expected branch m1SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1SegmentCompatibility")
        else:
            self.m1SegmentCompatibility_branch.SetAddress(<void*>&self.m1SegmentCompatibility_value)

        #print "making m1TkLayersWithMeasurement"
        self.m1TkLayersWithMeasurement_branch = the_tree.GetBranch("m1TkLayersWithMeasurement")
        #if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement" not in self.complained:
        if not self.m1TkLayersWithMeasurement_branch and "m1TkLayersWithMeasurement":
            warnings.warn( "MuMuTree: Expected branch m1TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TkLayersWithMeasurement")
        else:
            self.m1TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m1TkLayersWithMeasurement_value)

        #print "making m1TrkIsoDR03"
        self.m1TrkIsoDR03_branch = the_tree.GetBranch("m1TrkIsoDR03")
        #if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03" not in self.complained:
        if not self.m1TrkIsoDR03_branch and "m1TrkIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m1TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkIsoDR03")
        else:
            self.m1TrkIsoDR03_branch.SetAddress(<void*>&self.m1TrkIsoDR03_value)

        #print "making m1TrkKink"
        self.m1TrkKink_branch = the_tree.GetBranch("m1TrkKink")
        #if not self.m1TrkKink_branch and "m1TrkKink" not in self.complained:
        if not self.m1TrkKink_branch and "m1TrkKink":
            warnings.warn( "MuMuTree: Expected branch m1TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TrkKink")
        else:
            self.m1TrkKink_branch.SetAddress(<void*>&self.m1TrkKink_value)

        #print "making m1TypeCode"
        self.m1TypeCode_branch = the_tree.GetBranch("m1TypeCode")
        #if not self.m1TypeCode_branch and "m1TypeCode" not in self.complained:
        if not self.m1TypeCode_branch and "m1TypeCode":
            warnings.warn( "MuMuTree: Expected branch m1TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1TypeCode")
        else:
            self.m1TypeCode_branch.SetAddress(<void*>&self.m1TypeCode_value)

        #print "making m1VZ"
        self.m1VZ_branch = the_tree.GetBranch("m1VZ")
        #if not self.m1VZ_branch and "m1VZ" not in self.complained:
        if not self.m1VZ_branch and "m1VZ":
            warnings.warn( "MuMuTree: Expected branch m1VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1VZ")
        else:
            self.m1VZ_branch.SetAddress(<void*>&self.m1VZ_value)

        #print "making m1ValidFraction"
        self.m1ValidFraction_branch = the_tree.GetBranch("m1ValidFraction")
        #if not self.m1ValidFraction_branch and "m1ValidFraction" not in self.complained:
        if not self.m1ValidFraction_branch and "m1ValidFraction":
            warnings.warn( "MuMuTree: Expected branch m1ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ValidFraction")
        else:
            self.m1ValidFraction_branch.SetAddress(<void*>&self.m1ValidFraction_value)

        #print "making m1ZTTGenMatching"
        self.m1ZTTGenMatching_branch = the_tree.GetBranch("m1ZTTGenMatching")
        #if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching" not in self.complained:
        if not self.m1ZTTGenMatching_branch and "m1ZTTGenMatching":
            warnings.warn( "MuMuTree: Expected branch m1ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1ZTTGenMatching")
        else:
            self.m1ZTTGenMatching_branch.SetAddress(<void*>&self.m1ZTTGenMatching_value)

        #print "making m1_m2_CosThetaStar"
        self.m1_m2_CosThetaStar_branch = the_tree.GetBranch("m1_m2_CosThetaStar")
        #if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar" not in self.complained:
        if not self.m1_m2_CosThetaStar_branch and "m1_m2_CosThetaStar":
            warnings.warn( "MuMuTree: Expected branch m1_m2_CosThetaStar does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_CosThetaStar")
        else:
            self.m1_m2_CosThetaStar_branch.SetAddress(<void*>&self.m1_m2_CosThetaStar_value)

        #print "making m1_m2_DPhi"
        self.m1_m2_DPhi_branch = the_tree.GetBranch("m1_m2_DPhi")
        #if not self.m1_m2_DPhi_branch and "m1_m2_DPhi" not in self.complained:
        if not self.m1_m2_DPhi_branch and "m1_m2_DPhi":
            warnings.warn( "MuMuTree: Expected branch m1_m2_DPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DPhi")
        else:
            self.m1_m2_DPhi_branch.SetAddress(<void*>&self.m1_m2_DPhi_value)

        #print "making m1_m2_DR"
        self.m1_m2_DR_branch = the_tree.GetBranch("m1_m2_DR")
        #if not self.m1_m2_DR_branch and "m1_m2_DR" not in self.complained:
        if not self.m1_m2_DR_branch and "m1_m2_DR":
            warnings.warn( "MuMuTree: Expected branch m1_m2_DR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_DR")
        else:
            self.m1_m2_DR_branch.SetAddress(<void*>&self.m1_m2_DR_value)

        #print "making m1_m2_Eta"
        self.m1_m2_Eta_branch = the_tree.GetBranch("m1_m2_Eta")
        #if not self.m1_m2_Eta_branch and "m1_m2_Eta" not in self.complained:
        if not self.m1_m2_Eta_branch and "m1_m2_Eta":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Eta")
        else:
            self.m1_m2_Eta_branch.SetAddress(<void*>&self.m1_m2_Eta_value)

        #print "making m1_m2_Mass"
        self.m1_m2_Mass_branch = the_tree.GetBranch("m1_m2_Mass")
        #if not self.m1_m2_Mass_branch and "m1_m2_Mass" not in self.complained:
        if not self.m1_m2_Mass_branch and "m1_m2_Mass":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass")
        else:
            self.m1_m2_Mass_branch.SetAddress(<void*>&self.m1_m2_Mass_value)

        #print "making m1_m2_Mass_TauEnDown"
        self.m1_m2_Mass_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mass_TauEnDown")
        #if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown" not in self.complained:
        if not self.m1_m2_Mass_TauEnDown_branch and "m1_m2_Mass_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnDown")
        else:
            self.m1_m2_Mass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnDown_value)

        #print "making m1_m2_Mass_TauEnUp"
        self.m1_m2_Mass_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mass_TauEnUp")
        #if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp" not in self.complained:
        if not self.m1_m2_Mass_TauEnUp_branch and "m1_m2_Mass_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mass_TauEnUp")
        else:
            self.m1_m2_Mass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mass_TauEnUp_value)

        #print "making m1_m2_Mt"
        self.m1_m2_Mt_branch = the_tree.GetBranch("m1_m2_Mt")
        #if not self.m1_m2_Mt_branch and "m1_m2_Mt" not in self.complained:
        if not self.m1_m2_Mt_branch and "m1_m2_Mt":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt")
        else:
            self.m1_m2_Mt_branch.SetAddress(<void*>&self.m1_m2_Mt_value)

        #print "making m1_m2_MtTotal"
        self.m1_m2_MtTotal_branch = the_tree.GetBranch("m1_m2_MtTotal")
        #if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal" not in self.complained:
        if not self.m1_m2_MtTotal_branch and "m1_m2_MtTotal":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MtTotal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MtTotal")
        else:
            self.m1_m2_MtTotal_branch.SetAddress(<void*>&self.m1_m2_MtTotal_value)

        #print "making m1_m2_Mt_TauEnDown"
        self.m1_m2_Mt_TauEnDown_branch = the_tree.GetBranch("m1_m2_Mt_TauEnDown")
        #if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown" not in self.complained:
        if not self.m1_m2_Mt_TauEnDown_branch and "m1_m2_Mt_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mt_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnDown")
        else:
            self.m1_m2_Mt_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnDown_value)

        #print "making m1_m2_Mt_TauEnUp"
        self.m1_m2_Mt_TauEnUp_branch = the_tree.GetBranch("m1_m2_Mt_TauEnUp")
        #if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp" not in self.complained:
        if not self.m1_m2_Mt_TauEnUp_branch and "m1_m2_Mt_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Mt_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Mt_TauEnUp")
        else:
            self.m1_m2_Mt_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_Mt_TauEnUp_value)

        #print "making m1_m2_MvaMet"
        self.m1_m2_MvaMet_branch = the_tree.GetBranch("m1_m2_MvaMet")
        #if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet" not in self.complained:
        if not self.m1_m2_MvaMet_branch and "m1_m2_MvaMet":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMet")
        else:
            self.m1_m2_MvaMet_branch.SetAddress(<void*>&self.m1_m2_MvaMet_value)

        #print "making m1_m2_MvaMetCovMatrix00"
        self.m1_m2_MvaMetCovMatrix00_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix00")
        #if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix00_branch and "m1_m2_MvaMetCovMatrix00":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMetCovMatrix00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix00")
        else:
            self.m1_m2_MvaMetCovMatrix00_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix00_value)

        #print "making m1_m2_MvaMetCovMatrix01"
        self.m1_m2_MvaMetCovMatrix01_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix01")
        #if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix01_branch and "m1_m2_MvaMetCovMatrix01":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMetCovMatrix01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix01")
        else:
            self.m1_m2_MvaMetCovMatrix01_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix01_value)

        #print "making m1_m2_MvaMetCovMatrix10"
        self.m1_m2_MvaMetCovMatrix10_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix10")
        #if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix10_branch and "m1_m2_MvaMetCovMatrix10":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMetCovMatrix10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix10")
        else:
            self.m1_m2_MvaMetCovMatrix10_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix10_value)

        #print "making m1_m2_MvaMetCovMatrix11"
        self.m1_m2_MvaMetCovMatrix11_branch = the_tree.GetBranch("m1_m2_MvaMetCovMatrix11")
        #if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11" not in self.complained:
        if not self.m1_m2_MvaMetCovMatrix11_branch and "m1_m2_MvaMetCovMatrix11":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMetCovMatrix11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetCovMatrix11")
        else:
            self.m1_m2_MvaMetCovMatrix11_branch.SetAddress(<void*>&self.m1_m2_MvaMetCovMatrix11_value)

        #print "making m1_m2_MvaMetPhi"
        self.m1_m2_MvaMetPhi_branch = the_tree.GetBranch("m1_m2_MvaMetPhi")
        #if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi" not in self.complained:
        if not self.m1_m2_MvaMetPhi_branch and "m1_m2_MvaMetPhi":
            warnings.warn( "MuMuTree: Expected branch m1_m2_MvaMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_MvaMetPhi")
        else:
            self.m1_m2_MvaMetPhi_branch.SetAddress(<void*>&self.m1_m2_MvaMetPhi_value)

        #print "making m1_m2_PZeta"
        self.m1_m2_PZeta_branch = the_tree.GetBranch("m1_m2_PZeta")
        #if not self.m1_m2_PZeta_branch and "m1_m2_PZeta" not in self.complained:
        if not self.m1_m2_PZeta_branch and "m1_m2_PZeta":
            warnings.warn( "MuMuTree: Expected branch m1_m2_PZeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZeta")
        else:
            self.m1_m2_PZeta_branch.SetAddress(<void*>&self.m1_m2_PZeta_value)

        #print "making m1_m2_PZetaLess0p85PZetaVis"
        self.m1_m2_PZetaLess0p85PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaLess0p85PZetaVis")
        #if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaLess0p85PZetaVis_branch and "m1_m2_PZetaLess0p85PZetaVis":
            warnings.warn( "MuMuTree: Expected branch m1_m2_PZetaLess0p85PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaLess0p85PZetaVis")
        else:
            self.m1_m2_PZetaLess0p85PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaLess0p85PZetaVis_value)

        #print "making m1_m2_PZetaVis"
        self.m1_m2_PZetaVis_branch = the_tree.GetBranch("m1_m2_PZetaVis")
        #if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis" not in self.complained:
        if not self.m1_m2_PZetaVis_branch and "m1_m2_PZetaVis":
            warnings.warn( "MuMuTree: Expected branch m1_m2_PZetaVis does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_PZetaVis")
        else:
            self.m1_m2_PZetaVis_branch.SetAddress(<void*>&self.m1_m2_PZetaVis_value)

        #print "making m1_m2_Phi"
        self.m1_m2_Phi_branch = the_tree.GetBranch("m1_m2_Phi")
        #if not self.m1_m2_Phi_branch and "m1_m2_Phi" not in self.complained:
        if not self.m1_m2_Phi_branch and "m1_m2_Phi":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Phi")
        else:
            self.m1_m2_Phi_branch.SetAddress(<void*>&self.m1_m2_Phi_value)

        #print "making m1_m2_Pt"
        self.m1_m2_Pt_branch = the_tree.GetBranch("m1_m2_Pt")
        #if not self.m1_m2_Pt_branch and "m1_m2_Pt" not in self.complained:
        if not self.m1_m2_Pt_branch and "m1_m2_Pt":
            warnings.warn( "MuMuTree: Expected branch m1_m2_Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_Pt")
        else:
            self.m1_m2_Pt_branch.SetAddress(<void*>&self.m1_m2_Pt_value)

        #print "making m1_m2_SS"
        self.m1_m2_SS_branch = the_tree.GetBranch("m1_m2_SS")
        #if not self.m1_m2_SS_branch and "m1_m2_SS" not in self.complained:
        if not self.m1_m2_SS_branch and "m1_m2_SS":
            warnings.warn( "MuMuTree: Expected branch m1_m2_SS does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_SS")
        else:
            self.m1_m2_SS_branch.SetAddress(<void*>&self.m1_m2_SS_value)

        #print "making m1_m2_ToMETDPhi_Ty1"
        self.m1_m2_ToMETDPhi_Ty1_branch = the_tree.GetBranch("m1_m2_ToMETDPhi_Ty1")
        #if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1" not in self.complained:
        if not self.m1_m2_ToMETDPhi_Ty1_branch and "m1_m2_ToMETDPhi_Ty1":
            warnings.warn( "MuMuTree: Expected branch m1_m2_ToMETDPhi_Ty1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_ToMETDPhi_Ty1")
        else:
            self.m1_m2_ToMETDPhi_Ty1_branch.SetAddress(<void*>&self.m1_m2_ToMETDPhi_Ty1_value)

        #print "making m1_m2_collinearmass"
        self.m1_m2_collinearmass_branch = the_tree.GetBranch("m1_m2_collinearmass")
        #if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass" not in self.complained:
        if not self.m1_m2_collinearmass_branch and "m1_m2_collinearmass":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass")
        else:
            self.m1_m2_collinearmass_branch.SetAddress(<void*>&self.m1_m2_collinearmass_value)

        #print "making m1_m2_collinearmass_CheckUESDown"
        self.m1_m2_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m1_m2_collinearmass_CheckUESDown")
        #if not self.m1_m2_collinearmass_CheckUESDown_branch and "m1_m2_collinearmass_CheckUESDown" not in self.complained:
        if not self.m1_m2_collinearmass_CheckUESDown_branch and "m1_m2_collinearmass_CheckUESDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_CheckUESDown")
        else:
            self.m1_m2_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_CheckUESDown_value)

        #print "making m1_m2_collinearmass_CheckUESUp"
        self.m1_m2_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m1_m2_collinearmass_CheckUESUp")
        #if not self.m1_m2_collinearmass_CheckUESUp_branch and "m1_m2_collinearmass_CheckUESUp" not in self.complained:
        if not self.m1_m2_collinearmass_CheckUESUp_branch and "m1_m2_collinearmass_CheckUESUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_CheckUESUp")
        else:
            self.m1_m2_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_CheckUESUp_value)

        #print "making m1_m2_collinearmass_EleEnDown"
        self.m1_m2_collinearmass_EleEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnDown")
        #if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnDown_branch and "m1_m2_collinearmass_EleEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_EleEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnDown")
        else:
            self.m1_m2_collinearmass_EleEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnDown_value)

        #print "making m1_m2_collinearmass_EleEnUp"
        self.m1_m2_collinearmass_EleEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_EleEnUp")
        #if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_EleEnUp_branch and "m1_m2_collinearmass_EleEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_EleEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_EleEnUp")
        else:
            self.m1_m2_collinearmass_EleEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_EleEnUp_value)

        #print "making m1_m2_collinearmass_JetCheckTotalDown"
        self.m1_m2_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m1_m2_collinearmass_JetCheckTotalDown")
        #if not self.m1_m2_collinearmass_JetCheckTotalDown_branch and "m1_m2_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m1_m2_collinearmass_JetCheckTotalDown_branch and "m1_m2_collinearmass_JetCheckTotalDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetCheckTotalDown")
        else:
            self.m1_m2_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetCheckTotalDown_value)

        #print "making m1_m2_collinearmass_JetCheckTotalUp"
        self.m1_m2_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m1_m2_collinearmass_JetCheckTotalUp")
        #if not self.m1_m2_collinearmass_JetCheckTotalUp_branch and "m1_m2_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m1_m2_collinearmass_JetCheckTotalUp_branch and "m1_m2_collinearmass_JetCheckTotalUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetCheckTotalUp")
        else:
            self.m1_m2_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetCheckTotalUp_value)

        #print "making m1_m2_collinearmass_JetEnDown"
        self.m1_m2_collinearmass_JetEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnDown")
        #if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnDown_branch and "m1_m2_collinearmass_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnDown")
        else:
            self.m1_m2_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnDown_value)

        #print "making m1_m2_collinearmass_JetEnUp"
        self.m1_m2_collinearmass_JetEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_JetEnUp")
        #if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_JetEnUp_branch and "m1_m2_collinearmass_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_JetEnUp")
        else:
            self.m1_m2_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_JetEnUp_value)

        #print "making m1_m2_collinearmass_MuEnDown"
        self.m1_m2_collinearmass_MuEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnDown")
        #if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnDown_branch and "m1_m2_collinearmass_MuEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_MuEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnDown")
        else:
            self.m1_m2_collinearmass_MuEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnDown_value)

        #print "making m1_m2_collinearmass_MuEnUp"
        self.m1_m2_collinearmass_MuEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_MuEnUp")
        #if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_MuEnUp_branch and "m1_m2_collinearmass_MuEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_MuEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_MuEnUp")
        else:
            self.m1_m2_collinearmass_MuEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_MuEnUp_value)

        #print "making m1_m2_collinearmass_TauEnDown"
        self.m1_m2_collinearmass_TauEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnDown")
        #if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnDown_branch and "m1_m2_collinearmass_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnDown")
        else:
            self.m1_m2_collinearmass_TauEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnDown_value)

        #print "making m1_m2_collinearmass_TauEnUp"
        self.m1_m2_collinearmass_TauEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_TauEnUp")
        #if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_TauEnUp_branch and "m1_m2_collinearmass_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_TauEnUp")
        else:
            self.m1_m2_collinearmass_TauEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_TauEnUp_value)

        #print "making m1_m2_collinearmass_UnclusteredEnDown"
        self.m1_m2_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnDown")
        #if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnDown_branch and "m1_m2_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnDown")
        else:
            self.m1_m2_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnDown_value)

        #print "making m1_m2_collinearmass_UnclusteredEnUp"
        self.m1_m2_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m1_m2_collinearmass_UnclusteredEnUp")
        #if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m1_m2_collinearmass_UnclusteredEnUp_branch and "m1_m2_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m1_m2_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_collinearmass_UnclusteredEnUp")
        else:
            self.m1_m2_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m1_m2_collinearmass_UnclusteredEnUp_value)

        #print "making m1_m2_pt_tt"
        self.m1_m2_pt_tt_branch = the_tree.GetBranch("m1_m2_pt_tt")
        #if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt" not in self.complained:
        if not self.m1_m2_pt_tt_branch and "m1_m2_pt_tt":
            warnings.warn( "MuMuTree: Expected branch m1_m2_pt_tt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m1_m2_pt_tt")
        else:
            self.m1_m2_pt_tt_branch.SetAddress(<void*>&self.m1_m2_pt_tt_value)

        #print "making m2AbsEta"
        self.m2AbsEta_branch = the_tree.GetBranch("m2AbsEta")
        #if not self.m2AbsEta_branch and "m2AbsEta" not in self.complained:
        if not self.m2AbsEta_branch and "m2AbsEta":
            warnings.warn( "MuMuTree: Expected branch m2AbsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2AbsEta")
        else:
            self.m2AbsEta_branch.SetAddress(<void*>&self.m2AbsEta_value)

        #print "making m2BestTrackType"
        self.m2BestTrackType_branch = the_tree.GetBranch("m2BestTrackType")
        #if not self.m2BestTrackType_branch and "m2BestTrackType" not in self.complained:
        if not self.m2BestTrackType_branch and "m2BestTrackType":
            warnings.warn( "MuMuTree: Expected branch m2BestTrackType does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2BestTrackType")
        else:
            self.m2BestTrackType_branch.SetAddress(<void*>&self.m2BestTrackType_value)

        #print "making m2Charge"
        self.m2Charge_branch = the_tree.GetBranch("m2Charge")
        #if not self.m2Charge_branch and "m2Charge" not in self.complained:
        if not self.m2Charge_branch and "m2Charge":
            warnings.warn( "MuMuTree: Expected branch m2Charge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Charge")
        else:
            self.m2Charge_branch.SetAddress(<void*>&self.m2Charge_value)

        #print "making m2Chi2LocalPosition"
        self.m2Chi2LocalPosition_branch = the_tree.GetBranch("m2Chi2LocalPosition")
        #if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition" not in self.complained:
        if not self.m2Chi2LocalPosition_branch and "m2Chi2LocalPosition":
            warnings.warn( "MuMuTree: Expected branch m2Chi2LocalPosition does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Chi2LocalPosition")
        else:
            self.m2Chi2LocalPosition_branch.SetAddress(<void*>&self.m2Chi2LocalPosition_value)

        #print "making m2ComesFromHiggs"
        self.m2ComesFromHiggs_branch = the_tree.GetBranch("m2ComesFromHiggs")
        #if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs" not in self.complained:
        if not self.m2ComesFromHiggs_branch and "m2ComesFromHiggs":
            warnings.warn( "MuMuTree: Expected branch m2ComesFromHiggs does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ComesFromHiggs")
        else:
            self.m2ComesFromHiggs_branch.SetAddress(<void*>&self.m2ComesFromHiggs_value)

        #print "making m2DPhiToPfMet_ElectronEnDown"
        self.m2DPhiToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_ElectronEnDown")
        #if not self.m2DPhiToPfMet_ElectronEnDown_branch and "m2DPhiToPfMet_ElectronEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_ElectronEnDown_branch and "m2DPhiToPfMet_ElectronEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_ElectronEnDown")
        else:
            self.m2DPhiToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_ElectronEnDown_value)

        #print "making m2DPhiToPfMet_ElectronEnUp"
        self.m2DPhiToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_ElectronEnUp")
        #if not self.m2DPhiToPfMet_ElectronEnUp_branch and "m2DPhiToPfMet_ElectronEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_ElectronEnUp_branch and "m2DPhiToPfMet_ElectronEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_ElectronEnUp")
        else:
            self.m2DPhiToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_ElectronEnUp_value)

        #print "making m2DPhiToPfMet_JetEnDown"
        self.m2DPhiToPfMet_JetEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_JetEnDown")
        #if not self.m2DPhiToPfMet_JetEnDown_branch and "m2DPhiToPfMet_JetEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_JetEnDown_branch and "m2DPhiToPfMet_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetEnDown")
        else:
            self.m2DPhiToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetEnDown_value)

        #print "making m2DPhiToPfMet_JetEnUp"
        self.m2DPhiToPfMet_JetEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_JetEnUp")
        #if not self.m2DPhiToPfMet_JetEnUp_branch and "m2DPhiToPfMet_JetEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_JetEnUp_branch and "m2DPhiToPfMet_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetEnUp")
        else:
            self.m2DPhiToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetEnUp_value)

        #print "making m2DPhiToPfMet_JetResDown"
        self.m2DPhiToPfMet_JetResDown_branch = the_tree.GetBranch("m2DPhiToPfMet_JetResDown")
        #if not self.m2DPhiToPfMet_JetResDown_branch and "m2DPhiToPfMet_JetResDown" not in self.complained:
        if not self.m2DPhiToPfMet_JetResDown_branch and "m2DPhiToPfMet_JetResDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetResDown")
        else:
            self.m2DPhiToPfMet_JetResDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetResDown_value)

        #print "making m2DPhiToPfMet_JetResUp"
        self.m2DPhiToPfMet_JetResUp_branch = the_tree.GetBranch("m2DPhiToPfMet_JetResUp")
        #if not self.m2DPhiToPfMet_JetResUp_branch and "m2DPhiToPfMet_JetResUp" not in self.complained:
        if not self.m2DPhiToPfMet_JetResUp_branch and "m2DPhiToPfMet_JetResUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_JetResUp")
        else:
            self.m2DPhiToPfMet_JetResUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_JetResUp_value)

        #print "making m2DPhiToPfMet_MuonEnDown"
        self.m2DPhiToPfMet_MuonEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_MuonEnDown")
        #if not self.m2DPhiToPfMet_MuonEnDown_branch and "m2DPhiToPfMet_MuonEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_MuonEnDown_branch and "m2DPhiToPfMet_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_MuonEnDown")
        else:
            self.m2DPhiToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_MuonEnDown_value)

        #print "making m2DPhiToPfMet_MuonEnUp"
        self.m2DPhiToPfMet_MuonEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_MuonEnUp")
        #if not self.m2DPhiToPfMet_MuonEnUp_branch and "m2DPhiToPfMet_MuonEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_MuonEnUp_branch and "m2DPhiToPfMet_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_MuonEnUp")
        else:
            self.m2DPhiToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_MuonEnUp_value)

        #print "making m2DPhiToPfMet_PhotonEnDown"
        self.m2DPhiToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_PhotonEnDown")
        #if not self.m2DPhiToPfMet_PhotonEnDown_branch and "m2DPhiToPfMet_PhotonEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_PhotonEnDown_branch and "m2DPhiToPfMet_PhotonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_PhotonEnDown")
        else:
            self.m2DPhiToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_PhotonEnDown_value)

        #print "making m2DPhiToPfMet_PhotonEnUp"
        self.m2DPhiToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_PhotonEnUp")
        #if not self.m2DPhiToPfMet_PhotonEnUp_branch and "m2DPhiToPfMet_PhotonEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_PhotonEnUp_branch and "m2DPhiToPfMet_PhotonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_PhotonEnUp")
        else:
            self.m2DPhiToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_PhotonEnUp_value)

        #print "making m2DPhiToPfMet_TauEnDown"
        self.m2DPhiToPfMet_TauEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_TauEnDown")
        #if not self.m2DPhiToPfMet_TauEnDown_branch and "m2DPhiToPfMet_TauEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_TauEnDown_branch and "m2DPhiToPfMet_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_TauEnDown")
        else:
            self.m2DPhiToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_TauEnDown_value)

        #print "making m2DPhiToPfMet_TauEnUp"
        self.m2DPhiToPfMet_TauEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_TauEnUp")
        #if not self.m2DPhiToPfMet_TauEnUp_branch and "m2DPhiToPfMet_TauEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_TauEnUp_branch and "m2DPhiToPfMet_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_TauEnUp")
        else:
            self.m2DPhiToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_TauEnUp_value)

        #print "making m2DPhiToPfMet_UnclusteredEnDown"
        self.m2DPhiToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m2DPhiToPfMet_UnclusteredEnDown")
        #if not self.m2DPhiToPfMet_UnclusteredEnDown_branch and "m2DPhiToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m2DPhiToPfMet_UnclusteredEnDown_branch and "m2DPhiToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_UnclusteredEnDown")
        else:
            self.m2DPhiToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2DPhiToPfMet_UnclusteredEnDown_value)

        #print "making m2DPhiToPfMet_UnclusteredEnUp"
        self.m2DPhiToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m2DPhiToPfMet_UnclusteredEnUp")
        #if not self.m2DPhiToPfMet_UnclusteredEnUp_branch and "m2DPhiToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m2DPhiToPfMet_UnclusteredEnUp_branch and "m2DPhiToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_UnclusteredEnUp")
        else:
            self.m2DPhiToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2DPhiToPfMet_UnclusteredEnUp_value)

        #print "making m2DPhiToPfMet_type1"
        self.m2DPhiToPfMet_type1_branch = the_tree.GetBranch("m2DPhiToPfMet_type1")
        #if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1" not in self.complained:
        if not self.m2DPhiToPfMet_type1_branch and "m2DPhiToPfMet_type1":
            warnings.warn( "MuMuTree: Expected branch m2DPhiToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2DPhiToPfMet_type1")
        else:
            self.m2DPhiToPfMet_type1_branch.SetAddress(<void*>&self.m2DPhiToPfMet_type1_value)

        #print "making m2EcalIsoDR03"
        self.m2EcalIsoDR03_branch = the_tree.GetBranch("m2EcalIsoDR03")
        #if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03" not in self.complained:
        if not self.m2EcalIsoDR03_branch and "m2EcalIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m2EcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EcalIsoDR03")
        else:
            self.m2EcalIsoDR03_branch.SetAddress(<void*>&self.m2EcalIsoDR03_value)

        #print "making m2EffectiveArea2011"
        self.m2EffectiveArea2011_branch = the_tree.GetBranch("m2EffectiveArea2011")
        #if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011" not in self.complained:
        if not self.m2EffectiveArea2011_branch and "m2EffectiveArea2011":
            warnings.warn( "MuMuTree: Expected branch m2EffectiveArea2011 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2011")
        else:
            self.m2EffectiveArea2011_branch.SetAddress(<void*>&self.m2EffectiveArea2011_value)

        #print "making m2EffectiveArea2012"
        self.m2EffectiveArea2012_branch = the_tree.GetBranch("m2EffectiveArea2012")
        #if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012" not in self.complained:
        if not self.m2EffectiveArea2012_branch and "m2EffectiveArea2012":
            warnings.warn( "MuMuTree: Expected branch m2EffectiveArea2012 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2EffectiveArea2012")
        else:
            self.m2EffectiveArea2012_branch.SetAddress(<void*>&self.m2EffectiveArea2012_value)

        #print "making m2ErsatzGenEta"
        self.m2ErsatzGenEta_branch = the_tree.GetBranch("m2ErsatzGenEta")
        #if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta" not in self.complained:
        if not self.m2ErsatzGenEta_branch and "m2ErsatzGenEta":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenEta")
        else:
            self.m2ErsatzGenEta_branch.SetAddress(<void*>&self.m2ErsatzGenEta_value)

        #print "making m2ErsatzGenM"
        self.m2ErsatzGenM_branch = the_tree.GetBranch("m2ErsatzGenM")
        #if not self.m2ErsatzGenM_branch and "m2ErsatzGenM" not in self.complained:
        if not self.m2ErsatzGenM_branch and "m2ErsatzGenM":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenM")
        else:
            self.m2ErsatzGenM_branch.SetAddress(<void*>&self.m2ErsatzGenM_value)

        #print "making m2ErsatzGenPhi"
        self.m2ErsatzGenPhi_branch = the_tree.GetBranch("m2ErsatzGenPhi")
        #if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi" not in self.complained:
        if not self.m2ErsatzGenPhi_branch and "m2ErsatzGenPhi":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenPhi")
        else:
            self.m2ErsatzGenPhi_branch.SetAddress(<void*>&self.m2ErsatzGenPhi_value)

        #print "making m2ErsatzGenpT"
        self.m2ErsatzGenpT_branch = the_tree.GetBranch("m2ErsatzGenpT")
        #if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT" not in self.complained:
        if not self.m2ErsatzGenpT_branch and "m2ErsatzGenpT":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpT")
        else:
            self.m2ErsatzGenpT_branch.SetAddress(<void*>&self.m2ErsatzGenpT_value)

        #print "making m2ErsatzGenpX"
        self.m2ErsatzGenpX_branch = the_tree.GetBranch("m2ErsatzGenpX")
        #if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX" not in self.complained:
        if not self.m2ErsatzGenpX_branch and "m2ErsatzGenpX":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpX")
        else:
            self.m2ErsatzGenpX_branch.SetAddress(<void*>&self.m2ErsatzGenpX_value)

        #print "making m2ErsatzGenpY"
        self.m2ErsatzGenpY_branch = the_tree.GetBranch("m2ErsatzGenpY")
        #if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY" not in self.complained:
        if not self.m2ErsatzGenpY_branch and "m2ErsatzGenpY":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzGenpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzGenpY")
        else:
            self.m2ErsatzGenpY_branch.SetAddress(<void*>&self.m2ErsatzGenpY_value)

        #print "making m2ErsatzVispX"
        self.m2ErsatzVispX_branch = the_tree.GetBranch("m2ErsatzVispX")
        #if not self.m2ErsatzVispX_branch and "m2ErsatzVispX" not in self.complained:
        if not self.m2ErsatzVispX_branch and "m2ErsatzVispX":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzVispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispX")
        else:
            self.m2ErsatzVispX_branch.SetAddress(<void*>&self.m2ErsatzVispX_value)

        #print "making m2ErsatzVispY"
        self.m2ErsatzVispY_branch = the_tree.GetBranch("m2ErsatzVispY")
        #if not self.m2ErsatzVispY_branch and "m2ErsatzVispY" not in self.complained:
        if not self.m2ErsatzVispY_branch and "m2ErsatzVispY":
            warnings.warn( "MuMuTree: Expected branch m2ErsatzVispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ErsatzVispY")
        else:
            self.m2ErsatzVispY_branch.SetAddress(<void*>&self.m2ErsatzVispY_value)

        #print "making m2Eta"
        self.m2Eta_branch = the_tree.GetBranch("m2Eta")
        #if not self.m2Eta_branch and "m2Eta" not in self.complained:
        if not self.m2Eta_branch and "m2Eta":
            warnings.warn( "MuMuTree: Expected branch m2Eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta")
        else:
            self.m2Eta_branch.SetAddress(<void*>&self.m2Eta_value)

        #print "making m2Eta_MuonEnDown"
        self.m2Eta_MuonEnDown_branch = the_tree.GetBranch("m2Eta_MuonEnDown")
        #if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown" not in self.complained:
        if not self.m2Eta_MuonEnDown_branch and "m2Eta_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2Eta_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnDown")
        else:
            self.m2Eta_MuonEnDown_branch.SetAddress(<void*>&self.m2Eta_MuonEnDown_value)

        #print "making m2Eta_MuonEnUp"
        self.m2Eta_MuonEnUp_branch = the_tree.GetBranch("m2Eta_MuonEnUp")
        #if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp" not in self.complained:
        if not self.m2Eta_MuonEnUp_branch and "m2Eta_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2Eta_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Eta_MuonEnUp")
        else:
            self.m2Eta_MuonEnUp_branch.SetAddress(<void*>&self.m2Eta_MuonEnUp_value)

        #print "making m2GenCharge"
        self.m2GenCharge_branch = the_tree.GetBranch("m2GenCharge")
        #if not self.m2GenCharge_branch and "m2GenCharge" not in self.complained:
        if not self.m2GenCharge_branch and "m2GenCharge":
            warnings.warn( "MuMuTree: Expected branch m2GenCharge does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenCharge")
        else:
            self.m2GenCharge_branch.SetAddress(<void*>&self.m2GenCharge_value)

        #print "making m2GenDirectPromptTauDecayFinalState"
        self.m2GenDirectPromptTauDecayFinalState_branch = the_tree.GetBranch("m2GenDirectPromptTauDecayFinalState")
        #if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState" not in self.complained:
        if not self.m2GenDirectPromptTauDecayFinalState_branch and "m2GenDirectPromptTauDecayFinalState":
            warnings.warn( "MuMuTree: Expected branch m2GenDirectPromptTauDecayFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenDirectPromptTauDecayFinalState")
        else:
            self.m2GenDirectPromptTauDecayFinalState_branch.SetAddress(<void*>&self.m2GenDirectPromptTauDecayFinalState_value)

        #print "making m2GenEnergy"
        self.m2GenEnergy_branch = the_tree.GetBranch("m2GenEnergy")
        #if not self.m2GenEnergy_branch and "m2GenEnergy" not in self.complained:
        if not self.m2GenEnergy_branch and "m2GenEnergy":
            warnings.warn( "MuMuTree: Expected branch m2GenEnergy does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEnergy")
        else:
            self.m2GenEnergy_branch.SetAddress(<void*>&self.m2GenEnergy_value)

        #print "making m2GenEta"
        self.m2GenEta_branch = the_tree.GetBranch("m2GenEta")
        #if not self.m2GenEta_branch and "m2GenEta" not in self.complained:
        if not self.m2GenEta_branch and "m2GenEta":
            warnings.warn( "MuMuTree: Expected branch m2GenEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenEta")
        else:
            self.m2GenEta_branch.SetAddress(<void*>&self.m2GenEta_value)

        #print "making m2GenIsPrompt"
        self.m2GenIsPrompt_branch = the_tree.GetBranch("m2GenIsPrompt")
        #if not self.m2GenIsPrompt_branch and "m2GenIsPrompt" not in self.complained:
        if not self.m2GenIsPrompt_branch and "m2GenIsPrompt":
            warnings.warn( "MuMuTree: Expected branch m2GenIsPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenIsPrompt")
        else:
            self.m2GenIsPrompt_branch.SetAddress(<void*>&self.m2GenIsPrompt_value)

        #print "making m2GenMotherPdgId"
        self.m2GenMotherPdgId_branch = the_tree.GetBranch("m2GenMotherPdgId")
        #if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId" not in self.complained:
        if not self.m2GenMotherPdgId_branch and "m2GenMotherPdgId":
            warnings.warn( "MuMuTree: Expected branch m2GenMotherPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenMotherPdgId")
        else:
            self.m2GenMotherPdgId_branch.SetAddress(<void*>&self.m2GenMotherPdgId_value)

        #print "making m2GenParticle"
        self.m2GenParticle_branch = the_tree.GetBranch("m2GenParticle")
        #if not self.m2GenParticle_branch and "m2GenParticle" not in self.complained:
        if not self.m2GenParticle_branch and "m2GenParticle":
            warnings.warn( "MuMuTree: Expected branch m2GenParticle does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenParticle")
        else:
            self.m2GenParticle_branch.SetAddress(<void*>&self.m2GenParticle_value)

        #print "making m2GenPdgId"
        self.m2GenPdgId_branch = the_tree.GetBranch("m2GenPdgId")
        #if not self.m2GenPdgId_branch and "m2GenPdgId" not in self.complained:
        if not self.m2GenPdgId_branch and "m2GenPdgId":
            warnings.warn( "MuMuTree: Expected branch m2GenPdgId does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPdgId")
        else:
            self.m2GenPdgId_branch.SetAddress(<void*>&self.m2GenPdgId_value)

        #print "making m2GenPhi"
        self.m2GenPhi_branch = the_tree.GetBranch("m2GenPhi")
        #if not self.m2GenPhi_branch and "m2GenPhi" not in self.complained:
        if not self.m2GenPhi_branch and "m2GenPhi":
            warnings.warn( "MuMuTree: Expected branch m2GenPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPhi")
        else:
            self.m2GenPhi_branch.SetAddress(<void*>&self.m2GenPhi_value)

        #print "making m2GenPrompt"
        self.m2GenPrompt_branch = the_tree.GetBranch("m2GenPrompt")
        #if not self.m2GenPrompt_branch and "m2GenPrompt" not in self.complained:
        if not self.m2GenPrompt_branch and "m2GenPrompt":
            warnings.warn( "MuMuTree: Expected branch m2GenPrompt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPrompt")
        else:
            self.m2GenPrompt_branch.SetAddress(<void*>&self.m2GenPrompt_value)

        #print "making m2GenPromptFinalState"
        self.m2GenPromptFinalState_branch = the_tree.GetBranch("m2GenPromptFinalState")
        #if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState" not in self.complained:
        if not self.m2GenPromptFinalState_branch and "m2GenPromptFinalState":
            warnings.warn( "MuMuTree: Expected branch m2GenPromptFinalState does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptFinalState")
        else:
            self.m2GenPromptFinalState_branch.SetAddress(<void*>&self.m2GenPromptFinalState_value)

        #print "making m2GenPromptTauDecay"
        self.m2GenPromptTauDecay_branch = the_tree.GetBranch("m2GenPromptTauDecay")
        #if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay" not in self.complained:
        if not self.m2GenPromptTauDecay_branch and "m2GenPromptTauDecay":
            warnings.warn( "MuMuTree: Expected branch m2GenPromptTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPromptTauDecay")
        else:
            self.m2GenPromptTauDecay_branch.SetAddress(<void*>&self.m2GenPromptTauDecay_value)

        #print "making m2GenPt"
        self.m2GenPt_branch = the_tree.GetBranch("m2GenPt")
        #if not self.m2GenPt_branch and "m2GenPt" not in self.complained:
        if not self.m2GenPt_branch and "m2GenPt":
            warnings.warn( "MuMuTree: Expected branch m2GenPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenPt")
        else:
            self.m2GenPt_branch.SetAddress(<void*>&self.m2GenPt_value)

        #print "making m2GenTauDecay"
        self.m2GenTauDecay_branch = the_tree.GetBranch("m2GenTauDecay")
        #if not self.m2GenTauDecay_branch and "m2GenTauDecay" not in self.complained:
        if not self.m2GenTauDecay_branch and "m2GenTauDecay":
            warnings.warn( "MuMuTree: Expected branch m2GenTauDecay does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenTauDecay")
        else:
            self.m2GenTauDecay_branch.SetAddress(<void*>&self.m2GenTauDecay_value)

        #print "making m2GenVZ"
        self.m2GenVZ_branch = the_tree.GetBranch("m2GenVZ")
        #if not self.m2GenVZ_branch and "m2GenVZ" not in self.complained:
        if not self.m2GenVZ_branch and "m2GenVZ":
            warnings.warn( "MuMuTree: Expected branch m2GenVZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVZ")
        else:
            self.m2GenVZ_branch.SetAddress(<void*>&self.m2GenVZ_value)

        #print "making m2GenVtxPVMatch"
        self.m2GenVtxPVMatch_branch = the_tree.GetBranch("m2GenVtxPVMatch")
        #if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch" not in self.complained:
        if not self.m2GenVtxPVMatch_branch and "m2GenVtxPVMatch":
            warnings.warn( "MuMuTree: Expected branch m2GenVtxPVMatch does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2GenVtxPVMatch")
        else:
            self.m2GenVtxPVMatch_branch.SetAddress(<void*>&self.m2GenVtxPVMatch_value)

        #print "making m2HcalIsoDR03"
        self.m2HcalIsoDR03_branch = the_tree.GetBranch("m2HcalIsoDR03")
        #if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03" not in self.complained:
        if not self.m2HcalIsoDR03_branch and "m2HcalIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m2HcalIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2HcalIsoDR03")
        else:
            self.m2HcalIsoDR03_branch.SetAddress(<void*>&self.m2HcalIsoDR03_value)

        #print "making m2IP3D"
        self.m2IP3D_branch = the_tree.GetBranch("m2IP3D")
        #if not self.m2IP3D_branch and "m2IP3D" not in self.complained:
        if not self.m2IP3D_branch and "m2IP3D":
            warnings.warn( "MuMuTree: Expected branch m2IP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3D")
        else:
            self.m2IP3D_branch.SetAddress(<void*>&self.m2IP3D_value)

        #print "making m2IP3DErr"
        self.m2IP3DErr_branch = the_tree.GetBranch("m2IP3DErr")
        #if not self.m2IP3DErr_branch and "m2IP3DErr" not in self.complained:
        if not self.m2IP3DErr_branch and "m2IP3DErr":
            warnings.warn( "MuMuTree: Expected branch m2IP3DErr does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IP3DErr")
        else:
            self.m2IP3DErr_branch.SetAddress(<void*>&self.m2IP3DErr_value)

        #print "making m2IsGlobal"
        self.m2IsGlobal_branch = the_tree.GetBranch("m2IsGlobal")
        #if not self.m2IsGlobal_branch and "m2IsGlobal" not in self.complained:
        if not self.m2IsGlobal_branch and "m2IsGlobal":
            warnings.warn( "MuMuTree: Expected branch m2IsGlobal does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsGlobal")
        else:
            self.m2IsGlobal_branch.SetAddress(<void*>&self.m2IsGlobal_value)

        #print "making m2IsPFMuon"
        self.m2IsPFMuon_branch = the_tree.GetBranch("m2IsPFMuon")
        #if not self.m2IsPFMuon_branch and "m2IsPFMuon" not in self.complained:
        if not self.m2IsPFMuon_branch and "m2IsPFMuon":
            warnings.warn( "MuMuTree: Expected branch m2IsPFMuon does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsPFMuon")
        else:
            self.m2IsPFMuon_branch.SetAddress(<void*>&self.m2IsPFMuon_value)

        #print "making m2IsTracker"
        self.m2IsTracker_branch = the_tree.GetBranch("m2IsTracker")
        #if not self.m2IsTracker_branch and "m2IsTracker" not in self.complained:
        if not self.m2IsTracker_branch and "m2IsTracker":
            warnings.warn( "MuMuTree: Expected branch m2IsTracker does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsTracker")
        else:
            self.m2IsTracker_branch.SetAddress(<void*>&self.m2IsTracker_value)

        #print "making m2IsoDB03"
        self.m2IsoDB03_branch = the_tree.GetBranch("m2IsoDB03")
        #if not self.m2IsoDB03_branch and "m2IsoDB03" not in self.complained:
        if not self.m2IsoDB03_branch and "m2IsoDB03":
            warnings.warn( "MuMuTree: Expected branch m2IsoDB03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB03")
        else:
            self.m2IsoDB03_branch.SetAddress(<void*>&self.m2IsoDB03_value)

        #print "making m2IsoDB04"
        self.m2IsoDB04_branch = the_tree.GetBranch("m2IsoDB04")
        #if not self.m2IsoDB04_branch and "m2IsoDB04" not in self.complained:
        if not self.m2IsoDB04_branch and "m2IsoDB04":
            warnings.warn( "MuMuTree: Expected branch m2IsoDB04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2IsoDB04")
        else:
            self.m2IsoDB04_branch.SetAddress(<void*>&self.m2IsoDB04_value)

        #print "making m2JetArea"
        self.m2JetArea_branch = the_tree.GetBranch("m2JetArea")
        #if not self.m2JetArea_branch and "m2JetArea" not in self.complained:
        if not self.m2JetArea_branch and "m2JetArea":
            warnings.warn( "MuMuTree: Expected branch m2JetArea does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetArea")
        else:
            self.m2JetArea_branch.SetAddress(<void*>&self.m2JetArea_value)

        #print "making m2JetBtag"
        self.m2JetBtag_branch = the_tree.GetBranch("m2JetBtag")
        #if not self.m2JetBtag_branch and "m2JetBtag" not in self.complained:
        if not self.m2JetBtag_branch and "m2JetBtag":
            warnings.warn( "MuMuTree: Expected branch m2JetBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetBtag")
        else:
            self.m2JetBtag_branch.SetAddress(<void*>&self.m2JetBtag_value)

        #print "making m2JetDR"
        self.m2JetDR_branch = the_tree.GetBranch("m2JetDR")
        #if not self.m2JetDR_branch and "m2JetDR" not in self.complained:
        if not self.m2JetDR_branch and "m2JetDR":
            warnings.warn( "MuMuTree: Expected branch m2JetDR does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetDR")
        else:
            self.m2JetDR_branch.SetAddress(<void*>&self.m2JetDR_value)

        #print "making m2JetEtaEtaMoment"
        self.m2JetEtaEtaMoment_branch = the_tree.GetBranch("m2JetEtaEtaMoment")
        #if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment" not in self.complained:
        if not self.m2JetEtaEtaMoment_branch and "m2JetEtaEtaMoment":
            warnings.warn( "MuMuTree: Expected branch m2JetEtaEtaMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaEtaMoment")
        else:
            self.m2JetEtaEtaMoment_branch.SetAddress(<void*>&self.m2JetEtaEtaMoment_value)

        #print "making m2JetEtaPhiMoment"
        self.m2JetEtaPhiMoment_branch = the_tree.GetBranch("m2JetEtaPhiMoment")
        #if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment" not in self.complained:
        if not self.m2JetEtaPhiMoment_branch and "m2JetEtaPhiMoment":
            warnings.warn( "MuMuTree: Expected branch m2JetEtaPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiMoment")
        else:
            self.m2JetEtaPhiMoment_branch.SetAddress(<void*>&self.m2JetEtaPhiMoment_value)

        #print "making m2JetEtaPhiSpread"
        self.m2JetEtaPhiSpread_branch = the_tree.GetBranch("m2JetEtaPhiSpread")
        #if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread" not in self.complained:
        if not self.m2JetEtaPhiSpread_branch and "m2JetEtaPhiSpread":
            warnings.warn( "MuMuTree: Expected branch m2JetEtaPhiSpread does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetEtaPhiSpread")
        else:
            self.m2JetEtaPhiSpread_branch.SetAddress(<void*>&self.m2JetEtaPhiSpread_value)

        #print "making m2JetHadronFlavour"
        self.m2JetHadronFlavour_branch = the_tree.GetBranch("m2JetHadronFlavour")
        #if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour" not in self.complained:
        if not self.m2JetHadronFlavour_branch and "m2JetHadronFlavour":
            warnings.warn( "MuMuTree: Expected branch m2JetHadronFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetHadronFlavour")
        else:
            self.m2JetHadronFlavour_branch.SetAddress(<void*>&self.m2JetHadronFlavour_value)

        #print "making m2JetPFCISVBtag"
        self.m2JetPFCISVBtag_branch = the_tree.GetBranch("m2JetPFCISVBtag")
        #if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag" not in self.complained:
        if not self.m2JetPFCISVBtag_branch and "m2JetPFCISVBtag":
            warnings.warn( "MuMuTree: Expected branch m2JetPFCISVBtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPFCISVBtag")
        else:
            self.m2JetPFCISVBtag_branch.SetAddress(<void*>&self.m2JetPFCISVBtag_value)

        #print "making m2JetPartonFlavour"
        self.m2JetPartonFlavour_branch = the_tree.GetBranch("m2JetPartonFlavour")
        #if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour" not in self.complained:
        if not self.m2JetPartonFlavour_branch and "m2JetPartonFlavour":
            warnings.warn( "MuMuTree: Expected branch m2JetPartonFlavour does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPartonFlavour")
        else:
            self.m2JetPartonFlavour_branch.SetAddress(<void*>&self.m2JetPartonFlavour_value)

        #print "making m2JetPhiPhiMoment"
        self.m2JetPhiPhiMoment_branch = the_tree.GetBranch("m2JetPhiPhiMoment")
        #if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment" not in self.complained:
        if not self.m2JetPhiPhiMoment_branch and "m2JetPhiPhiMoment":
            warnings.warn( "MuMuTree: Expected branch m2JetPhiPhiMoment does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPhiPhiMoment")
        else:
            self.m2JetPhiPhiMoment_branch.SetAddress(<void*>&self.m2JetPhiPhiMoment_value)

        #print "making m2JetPt"
        self.m2JetPt_branch = the_tree.GetBranch("m2JetPt")
        #if not self.m2JetPt_branch and "m2JetPt" not in self.complained:
        if not self.m2JetPt_branch and "m2JetPt":
            warnings.warn( "MuMuTree: Expected branch m2JetPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2JetPt")
        else:
            self.m2JetPt_branch.SetAddress(<void*>&self.m2JetPt_value)

        #print "making m2LowestMll"
        self.m2LowestMll_branch = the_tree.GetBranch("m2LowestMll")
        #if not self.m2LowestMll_branch and "m2LowestMll" not in self.complained:
        if not self.m2LowestMll_branch and "m2LowestMll":
            warnings.warn( "MuMuTree: Expected branch m2LowestMll does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2LowestMll")
        else:
            self.m2LowestMll_branch.SetAddress(<void*>&self.m2LowestMll_value)

        #print "making m2Mass"
        self.m2Mass_branch = the_tree.GetBranch("m2Mass")
        #if not self.m2Mass_branch and "m2Mass" not in self.complained:
        if not self.m2Mass_branch and "m2Mass":
            warnings.warn( "MuMuTree: Expected branch m2Mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mass")
        else:
            self.m2Mass_branch.SetAddress(<void*>&self.m2Mass_value)

        #print "making m2MatchedStations"
        self.m2MatchedStations_branch = the_tree.GetBranch("m2MatchedStations")
        #if not self.m2MatchedStations_branch and "m2MatchedStations" not in self.complained:
        if not self.m2MatchedStations_branch and "m2MatchedStations":
            warnings.warn( "MuMuTree: Expected branch m2MatchedStations does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchedStations")
        else:
            self.m2MatchedStations_branch.SetAddress(<void*>&self.m2MatchedStations_value)

        #print "making m2MatchesDoubleESingleMu"
        self.m2MatchesDoubleESingleMu_branch = the_tree.GetBranch("m2MatchesDoubleESingleMu")
        #if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu" not in self.complained:
        if not self.m2MatchesDoubleESingleMu_branch and "m2MatchesDoubleESingleMu":
            warnings.warn( "MuMuTree: Expected branch m2MatchesDoubleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleESingleMu")
        else:
            self.m2MatchesDoubleESingleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleESingleMu_value)

        #print "making m2MatchesDoubleMu"
        self.m2MatchesDoubleMu_branch = the_tree.GetBranch("m2MatchesDoubleMu")
        #if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu" not in self.complained:
        if not self.m2MatchesDoubleMu_branch and "m2MatchesDoubleMu":
            warnings.warn( "MuMuTree: Expected branch m2MatchesDoubleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMu")
        else:
            self.m2MatchesDoubleMu_branch.SetAddress(<void*>&self.m2MatchesDoubleMu_value)

        #print "making m2MatchesDoubleMuSingleE"
        self.m2MatchesDoubleMuSingleE_branch = the_tree.GetBranch("m2MatchesDoubleMuSingleE")
        #if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE" not in self.complained:
        if not self.m2MatchesDoubleMuSingleE_branch and "m2MatchesDoubleMuSingleE":
            warnings.warn( "MuMuTree: Expected branch m2MatchesDoubleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesDoubleMuSingleE")
        else:
            self.m2MatchesDoubleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesDoubleMuSingleE_value)

        #print "making m2MatchesIsoMu24Path"
        self.m2MatchesIsoMu24Path_branch = the_tree.GetBranch("m2MatchesIsoMu24Path")
        #if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path" not in self.complained:
        if not self.m2MatchesIsoMu24Path_branch and "m2MatchesIsoMu24Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesIsoMu24Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24Path")
        else:
            self.m2MatchesIsoMu24Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24Path_value)

        #print "making m2MatchesIsoMu24eta2p1Path"
        self.m2MatchesIsoMu24eta2p1Path_branch = the_tree.GetBranch("m2MatchesIsoMu24eta2p1Path")
        #if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path" not in self.complained:
        if not self.m2MatchesIsoMu24eta2p1Path_branch and "m2MatchesIsoMu24eta2p1Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesIsoMu24eta2p1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesIsoMu24eta2p1Path")
        else:
            self.m2MatchesIsoMu24eta2p1Path_branch.SetAddress(<void*>&self.m2MatchesIsoMu24eta2p1Path_value)

        #print "making m2MatchesMu19Tau20Filter"
        self.m2MatchesMu19Tau20Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20Filter")
        #if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20Filter_branch and "m2MatchesMu19Tau20Filter":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu19Tau20Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Filter")
        else:
            self.m2MatchesMu19Tau20Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Filter_value)

        #print "making m2MatchesMu19Tau20Path"
        self.m2MatchesMu19Tau20Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20Path")
        #if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path" not in self.complained:
        if not self.m2MatchesMu19Tau20Path_branch and "m2MatchesMu19Tau20Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu19Tau20Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20Path")
        else:
            self.m2MatchesMu19Tau20Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20Path_value)

        #print "making m2MatchesMu19Tau20sL1Filter"
        self.m2MatchesMu19Tau20sL1Filter_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Filter")
        #if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Filter_branch and "m2MatchesMu19Tau20sL1Filter":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu19Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Filter")
        else:
            self.m2MatchesMu19Tau20sL1Filter_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Filter_value)

        #print "making m2MatchesMu19Tau20sL1Path"
        self.m2MatchesMu19Tau20sL1Path_branch = the_tree.GetBranch("m2MatchesMu19Tau20sL1Path")
        #if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path" not in self.complained:
        if not self.m2MatchesMu19Tau20sL1Path_branch and "m2MatchesMu19Tau20sL1Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu19Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu19Tau20sL1Path")
        else:
            self.m2MatchesMu19Tau20sL1Path_branch.SetAddress(<void*>&self.m2MatchesMu19Tau20sL1Path_value)

        #print "making m2MatchesMu21Tau20sL1Filter"
        self.m2MatchesMu21Tau20sL1Filter_branch = the_tree.GetBranch("m2MatchesMu21Tau20sL1Filter")
        #if not self.m2MatchesMu21Tau20sL1Filter_branch and "m2MatchesMu21Tau20sL1Filter" not in self.complained:
        if not self.m2MatchesMu21Tau20sL1Filter_branch and "m2MatchesMu21Tau20sL1Filter":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu21Tau20sL1Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu21Tau20sL1Filter")
        else:
            self.m2MatchesMu21Tau20sL1Filter_branch.SetAddress(<void*>&self.m2MatchesMu21Tau20sL1Filter_value)

        #print "making m2MatchesMu21Tau20sL1Path"
        self.m2MatchesMu21Tau20sL1Path_branch = the_tree.GetBranch("m2MatchesMu21Tau20sL1Path")
        #if not self.m2MatchesMu21Tau20sL1Path_branch and "m2MatchesMu21Tau20sL1Path" not in self.complained:
        if not self.m2MatchesMu21Tau20sL1Path_branch and "m2MatchesMu21Tau20sL1Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu21Tau20sL1Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu21Tau20sL1Path")
        else:
            self.m2MatchesMu21Tau20sL1Path_branch.SetAddress(<void*>&self.m2MatchesMu21Tau20sL1Path_value)

        #print "making m2MatchesMu23Ele12DZPath"
        self.m2MatchesMu23Ele12DZPath_branch = the_tree.GetBranch("m2MatchesMu23Ele12DZPath")
        #if not self.m2MatchesMu23Ele12DZPath_branch and "m2MatchesMu23Ele12DZPath" not in self.complained:
        if not self.m2MatchesMu23Ele12DZPath_branch and "m2MatchesMu23Ele12DZPath":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu23Ele12DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23Ele12DZPath")
        else:
            self.m2MatchesMu23Ele12DZPath_branch.SetAddress(<void*>&self.m2MatchesMu23Ele12DZPath_value)

        #print "making m2MatchesMu23Ele12Path"
        self.m2MatchesMu23Ele12Path_branch = the_tree.GetBranch("m2MatchesMu23Ele12Path")
        #if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path" not in self.complained:
        if not self.m2MatchesMu23Ele12Path_branch and "m2MatchesMu23Ele12Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu23Ele12Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu23Ele12Path")
        else:
            self.m2MatchesMu23Ele12Path_branch.SetAddress(<void*>&self.m2MatchesMu23Ele12Path_value)

        #print "making m2MatchesMu8Ele23DZPath"
        self.m2MatchesMu8Ele23DZPath_branch = the_tree.GetBranch("m2MatchesMu8Ele23DZPath")
        #if not self.m2MatchesMu8Ele23DZPath_branch and "m2MatchesMu8Ele23DZPath" not in self.complained:
        if not self.m2MatchesMu8Ele23DZPath_branch and "m2MatchesMu8Ele23DZPath":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu8Ele23DZPath does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele23DZPath")
        else:
            self.m2MatchesMu8Ele23DZPath_branch.SetAddress(<void*>&self.m2MatchesMu8Ele23DZPath_value)

        #print "making m2MatchesMu8Ele23Path"
        self.m2MatchesMu8Ele23Path_branch = the_tree.GetBranch("m2MatchesMu8Ele23Path")
        #if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path" not in self.complained:
        if not self.m2MatchesMu8Ele23Path_branch and "m2MatchesMu8Ele23Path":
            warnings.warn( "MuMuTree: Expected branch m2MatchesMu8Ele23Path does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesMu8Ele23Path")
        else:
            self.m2MatchesMu8Ele23Path_branch.SetAddress(<void*>&self.m2MatchesMu8Ele23Path_value)

        #print "making m2MatchesSingleESingleMu"
        self.m2MatchesSingleESingleMu_branch = the_tree.GetBranch("m2MatchesSingleESingleMu")
        #if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu" not in self.complained:
        if not self.m2MatchesSingleESingleMu_branch and "m2MatchesSingleESingleMu":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleESingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleESingleMu")
        else:
            self.m2MatchesSingleESingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleESingleMu_value)

        #print "making m2MatchesSingleMu"
        self.m2MatchesSingleMu_branch = the_tree.GetBranch("m2MatchesSingleMu")
        #if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu" not in self.complained:
        if not self.m2MatchesSingleMu_branch and "m2MatchesSingleMu":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu")
        else:
            self.m2MatchesSingleMu_branch.SetAddress(<void*>&self.m2MatchesSingleMu_value)

        #print "making m2MatchesSingleMuIso20"
        self.m2MatchesSingleMuIso20_branch = the_tree.GetBranch("m2MatchesSingleMuIso20")
        #if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20" not in self.complained:
        if not self.m2MatchesSingleMuIso20_branch and "m2MatchesSingleMuIso20":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMuIso20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIso20")
        else:
            self.m2MatchesSingleMuIso20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIso20_value)

        #print "making m2MatchesSingleMuIsoTk20"
        self.m2MatchesSingleMuIsoTk20_branch = the_tree.GetBranch("m2MatchesSingleMuIsoTk20")
        #if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20" not in self.complained:
        if not self.m2MatchesSingleMuIsoTk20_branch and "m2MatchesSingleMuIsoTk20":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMuIsoTk20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuIsoTk20")
        else:
            self.m2MatchesSingleMuIsoTk20_branch.SetAddress(<void*>&self.m2MatchesSingleMuIsoTk20_value)

        #print "making m2MatchesSingleMuSingleE"
        self.m2MatchesSingleMuSingleE_branch = the_tree.GetBranch("m2MatchesSingleMuSingleE")
        #if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE" not in self.complained:
        if not self.m2MatchesSingleMuSingleE_branch and "m2MatchesSingleMuSingleE":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMuSingleE does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMuSingleE")
        else:
            self.m2MatchesSingleMuSingleE_branch.SetAddress(<void*>&self.m2MatchesSingleMuSingleE_value)

        #print "making m2MatchesSingleMu_leg1"
        self.m2MatchesSingleMu_leg1_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1")
        #if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_branch and "m2MatchesSingleMu_leg1":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMu_leg1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1")
        else:
            self.m2MatchesSingleMu_leg1_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_value)

        #print "making m2MatchesSingleMu_leg1_noiso"
        self.m2MatchesSingleMu_leg1_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg1_noiso")
        #if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg1_noiso_branch and "m2MatchesSingleMu_leg1_noiso":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMu_leg1_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg1_noiso")
        else:
            self.m2MatchesSingleMu_leg1_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg1_noiso_value)

        #print "making m2MatchesSingleMu_leg2"
        self.m2MatchesSingleMu_leg2_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2")
        #if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_branch and "m2MatchesSingleMu_leg2":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMu_leg2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2")
        else:
            self.m2MatchesSingleMu_leg2_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_value)

        #print "making m2MatchesSingleMu_leg2_noiso"
        self.m2MatchesSingleMu_leg2_noiso_branch = the_tree.GetBranch("m2MatchesSingleMu_leg2_noiso")
        #if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso" not in self.complained:
        if not self.m2MatchesSingleMu_leg2_noiso_branch and "m2MatchesSingleMu_leg2_noiso":
            warnings.warn( "MuMuTree: Expected branch m2MatchesSingleMu_leg2_noiso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesSingleMu_leg2_noiso")
        else:
            self.m2MatchesSingleMu_leg2_noiso_branch.SetAddress(<void*>&self.m2MatchesSingleMu_leg2_noiso_value)

        #print "making m2MatchesTripleMu"
        self.m2MatchesTripleMu_branch = the_tree.GetBranch("m2MatchesTripleMu")
        #if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu" not in self.complained:
        if not self.m2MatchesTripleMu_branch and "m2MatchesTripleMu":
            warnings.warn( "MuMuTree: Expected branch m2MatchesTripleMu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MatchesTripleMu")
        else:
            self.m2MatchesTripleMu_branch.SetAddress(<void*>&self.m2MatchesTripleMu_value)

        #print "making m2MtToPfMet_ElectronEnDown"
        self.m2MtToPfMet_ElectronEnDown_branch = the_tree.GetBranch("m2MtToPfMet_ElectronEnDown")
        #if not self.m2MtToPfMet_ElectronEnDown_branch and "m2MtToPfMet_ElectronEnDown" not in self.complained:
        if not self.m2MtToPfMet_ElectronEnDown_branch and "m2MtToPfMet_ElectronEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_ElectronEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ElectronEnDown")
        else:
            self.m2MtToPfMet_ElectronEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_ElectronEnDown_value)

        #print "making m2MtToPfMet_ElectronEnUp"
        self.m2MtToPfMet_ElectronEnUp_branch = the_tree.GetBranch("m2MtToPfMet_ElectronEnUp")
        #if not self.m2MtToPfMet_ElectronEnUp_branch and "m2MtToPfMet_ElectronEnUp" not in self.complained:
        if not self.m2MtToPfMet_ElectronEnUp_branch and "m2MtToPfMet_ElectronEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_ElectronEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_ElectronEnUp")
        else:
            self.m2MtToPfMet_ElectronEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_ElectronEnUp_value)

        #print "making m2MtToPfMet_JetEnDown"
        self.m2MtToPfMet_JetEnDown_branch = the_tree.GetBranch("m2MtToPfMet_JetEnDown")
        #if not self.m2MtToPfMet_JetEnDown_branch and "m2MtToPfMet_JetEnDown" not in self.complained:
        if not self.m2MtToPfMet_JetEnDown_branch and "m2MtToPfMet_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetEnDown")
        else:
            self.m2MtToPfMet_JetEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_JetEnDown_value)

        #print "making m2MtToPfMet_JetEnUp"
        self.m2MtToPfMet_JetEnUp_branch = the_tree.GetBranch("m2MtToPfMet_JetEnUp")
        #if not self.m2MtToPfMet_JetEnUp_branch and "m2MtToPfMet_JetEnUp" not in self.complained:
        if not self.m2MtToPfMet_JetEnUp_branch and "m2MtToPfMet_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetEnUp")
        else:
            self.m2MtToPfMet_JetEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_JetEnUp_value)

        #print "making m2MtToPfMet_JetResDown"
        self.m2MtToPfMet_JetResDown_branch = the_tree.GetBranch("m2MtToPfMet_JetResDown")
        #if not self.m2MtToPfMet_JetResDown_branch and "m2MtToPfMet_JetResDown" not in self.complained:
        if not self.m2MtToPfMet_JetResDown_branch and "m2MtToPfMet_JetResDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetResDown")
        else:
            self.m2MtToPfMet_JetResDown_branch.SetAddress(<void*>&self.m2MtToPfMet_JetResDown_value)

        #print "making m2MtToPfMet_JetResUp"
        self.m2MtToPfMet_JetResUp_branch = the_tree.GetBranch("m2MtToPfMet_JetResUp")
        #if not self.m2MtToPfMet_JetResUp_branch and "m2MtToPfMet_JetResUp" not in self.complained:
        if not self.m2MtToPfMet_JetResUp_branch and "m2MtToPfMet_JetResUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_JetResUp")
        else:
            self.m2MtToPfMet_JetResUp_branch.SetAddress(<void*>&self.m2MtToPfMet_JetResUp_value)

        #print "making m2MtToPfMet_MuonEnDown"
        self.m2MtToPfMet_MuonEnDown_branch = the_tree.GetBranch("m2MtToPfMet_MuonEnDown")
        #if not self.m2MtToPfMet_MuonEnDown_branch and "m2MtToPfMet_MuonEnDown" not in self.complained:
        if not self.m2MtToPfMet_MuonEnDown_branch and "m2MtToPfMet_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_MuonEnDown")
        else:
            self.m2MtToPfMet_MuonEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_MuonEnDown_value)

        #print "making m2MtToPfMet_MuonEnUp"
        self.m2MtToPfMet_MuonEnUp_branch = the_tree.GetBranch("m2MtToPfMet_MuonEnUp")
        #if not self.m2MtToPfMet_MuonEnUp_branch and "m2MtToPfMet_MuonEnUp" not in self.complained:
        if not self.m2MtToPfMet_MuonEnUp_branch and "m2MtToPfMet_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_MuonEnUp")
        else:
            self.m2MtToPfMet_MuonEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_MuonEnUp_value)

        #print "making m2MtToPfMet_PhotonEnDown"
        self.m2MtToPfMet_PhotonEnDown_branch = the_tree.GetBranch("m2MtToPfMet_PhotonEnDown")
        #if not self.m2MtToPfMet_PhotonEnDown_branch and "m2MtToPfMet_PhotonEnDown" not in self.complained:
        if not self.m2MtToPfMet_PhotonEnDown_branch and "m2MtToPfMet_PhotonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_PhotonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_PhotonEnDown")
        else:
            self.m2MtToPfMet_PhotonEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_PhotonEnDown_value)

        #print "making m2MtToPfMet_PhotonEnUp"
        self.m2MtToPfMet_PhotonEnUp_branch = the_tree.GetBranch("m2MtToPfMet_PhotonEnUp")
        #if not self.m2MtToPfMet_PhotonEnUp_branch and "m2MtToPfMet_PhotonEnUp" not in self.complained:
        if not self.m2MtToPfMet_PhotonEnUp_branch and "m2MtToPfMet_PhotonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_PhotonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_PhotonEnUp")
        else:
            self.m2MtToPfMet_PhotonEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_PhotonEnUp_value)

        #print "making m2MtToPfMet_Raw"
        self.m2MtToPfMet_Raw_branch = the_tree.GetBranch("m2MtToPfMet_Raw")
        #if not self.m2MtToPfMet_Raw_branch and "m2MtToPfMet_Raw" not in self.complained:
        if not self.m2MtToPfMet_Raw_branch and "m2MtToPfMet_Raw":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_Raw does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_Raw")
        else:
            self.m2MtToPfMet_Raw_branch.SetAddress(<void*>&self.m2MtToPfMet_Raw_value)

        #print "making m2MtToPfMet_TauEnDown"
        self.m2MtToPfMet_TauEnDown_branch = the_tree.GetBranch("m2MtToPfMet_TauEnDown")
        #if not self.m2MtToPfMet_TauEnDown_branch and "m2MtToPfMet_TauEnDown" not in self.complained:
        if not self.m2MtToPfMet_TauEnDown_branch and "m2MtToPfMet_TauEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_TauEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_TauEnDown")
        else:
            self.m2MtToPfMet_TauEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_TauEnDown_value)

        #print "making m2MtToPfMet_TauEnUp"
        self.m2MtToPfMet_TauEnUp_branch = the_tree.GetBranch("m2MtToPfMet_TauEnUp")
        #if not self.m2MtToPfMet_TauEnUp_branch and "m2MtToPfMet_TauEnUp" not in self.complained:
        if not self.m2MtToPfMet_TauEnUp_branch and "m2MtToPfMet_TauEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_TauEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_TauEnUp")
        else:
            self.m2MtToPfMet_TauEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_TauEnUp_value)

        #print "making m2MtToPfMet_UnclusteredEnDown"
        self.m2MtToPfMet_UnclusteredEnDown_branch = the_tree.GetBranch("m2MtToPfMet_UnclusteredEnDown")
        #if not self.m2MtToPfMet_UnclusteredEnDown_branch and "m2MtToPfMet_UnclusteredEnDown" not in self.complained:
        if not self.m2MtToPfMet_UnclusteredEnDown_branch and "m2MtToPfMet_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_UnclusteredEnDown")
        else:
            self.m2MtToPfMet_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2MtToPfMet_UnclusteredEnDown_value)

        #print "making m2MtToPfMet_UnclusteredEnUp"
        self.m2MtToPfMet_UnclusteredEnUp_branch = the_tree.GetBranch("m2MtToPfMet_UnclusteredEnUp")
        #if not self.m2MtToPfMet_UnclusteredEnUp_branch and "m2MtToPfMet_UnclusteredEnUp" not in self.complained:
        if not self.m2MtToPfMet_UnclusteredEnUp_branch and "m2MtToPfMet_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_UnclusteredEnUp")
        else:
            self.m2MtToPfMet_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2MtToPfMet_UnclusteredEnUp_value)

        #print "making m2MtToPfMet_type1"
        self.m2MtToPfMet_type1_branch = the_tree.GetBranch("m2MtToPfMet_type1")
        #if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1" not in self.complained:
        if not self.m2MtToPfMet_type1_branch and "m2MtToPfMet_type1":
            warnings.warn( "MuMuTree: Expected branch m2MtToPfMet_type1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MtToPfMet_type1")
        else:
            self.m2MtToPfMet_type1_branch.SetAddress(<void*>&self.m2MtToPfMet_type1_value)

        #print "making m2Mu23Ele12DZFilter"
        self.m2Mu23Ele12DZFilter_branch = the_tree.GetBranch("m2Mu23Ele12DZFilter")
        #if not self.m2Mu23Ele12DZFilter_branch and "m2Mu23Ele12DZFilter" not in self.complained:
        if not self.m2Mu23Ele12DZFilter_branch and "m2Mu23Ele12DZFilter":
            warnings.warn( "MuMuTree: Expected branch m2Mu23Ele12DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu23Ele12DZFilter")
        else:
            self.m2Mu23Ele12DZFilter_branch.SetAddress(<void*>&self.m2Mu23Ele12DZFilter_value)

        #print "making m2Mu23Ele12Filter"
        self.m2Mu23Ele12Filter_branch = the_tree.GetBranch("m2Mu23Ele12Filter")
        #if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter" not in self.complained:
        if not self.m2Mu23Ele12Filter_branch and "m2Mu23Ele12Filter":
            warnings.warn( "MuMuTree: Expected branch m2Mu23Ele12Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu23Ele12Filter")
        else:
            self.m2Mu23Ele12Filter_branch.SetAddress(<void*>&self.m2Mu23Ele12Filter_value)

        #print "making m2Mu8Ele23DZFilter"
        self.m2Mu8Ele23DZFilter_branch = the_tree.GetBranch("m2Mu8Ele23DZFilter")
        #if not self.m2Mu8Ele23DZFilter_branch and "m2Mu8Ele23DZFilter" not in self.complained:
        if not self.m2Mu8Ele23DZFilter_branch and "m2Mu8Ele23DZFilter":
            warnings.warn( "MuMuTree: Expected branch m2Mu8Ele23DZFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu8Ele23DZFilter")
        else:
            self.m2Mu8Ele23DZFilter_branch.SetAddress(<void*>&self.m2Mu8Ele23DZFilter_value)

        #print "making m2Mu8Ele23Filter"
        self.m2Mu8Ele23Filter_branch = the_tree.GetBranch("m2Mu8Ele23Filter")
        #if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter" not in self.complained:
        if not self.m2Mu8Ele23Filter_branch and "m2Mu8Ele23Filter":
            warnings.warn( "MuMuTree: Expected branch m2Mu8Ele23Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Mu8Ele23Filter")
        else:
            self.m2Mu8Ele23Filter_branch.SetAddress(<void*>&self.m2Mu8Ele23Filter_value)

        #print "making m2MuonHits"
        self.m2MuonHits_branch = the_tree.GetBranch("m2MuonHits")
        #if not self.m2MuonHits_branch and "m2MuonHits" not in self.complained:
        if not self.m2MuonHits_branch and "m2MuonHits":
            warnings.warn( "MuMuTree: Expected branch m2MuonHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2MuonHits")
        else:
            self.m2MuonHits_branch.SetAddress(<void*>&self.m2MuonHits_value)

        #print "making m2NearestZMass"
        self.m2NearestZMass_branch = the_tree.GetBranch("m2NearestZMass")
        #if not self.m2NearestZMass_branch and "m2NearestZMass" not in self.complained:
        if not self.m2NearestZMass_branch and "m2NearestZMass":
            warnings.warn( "MuMuTree: Expected branch m2NearestZMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NearestZMass")
        else:
            self.m2NearestZMass_branch.SetAddress(<void*>&self.m2NearestZMass_value)

        #print "making m2NormTrkChi2"
        self.m2NormTrkChi2_branch = the_tree.GetBranch("m2NormTrkChi2")
        #if not self.m2NormTrkChi2_branch and "m2NormTrkChi2" not in self.complained:
        if not self.m2NormTrkChi2_branch and "m2NormTrkChi2":
            warnings.warn( "MuMuTree: Expected branch m2NormTrkChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormTrkChi2")
        else:
            self.m2NormTrkChi2_branch.SetAddress(<void*>&self.m2NormTrkChi2_value)

        #print "making m2NormalizedChi2"
        self.m2NormalizedChi2_branch = the_tree.GetBranch("m2NormalizedChi2")
        #if not self.m2NormalizedChi2_branch and "m2NormalizedChi2" not in self.complained:
        if not self.m2NormalizedChi2_branch and "m2NormalizedChi2":
            warnings.warn( "MuMuTree: Expected branch m2NormalizedChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2NormalizedChi2")
        else:
            self.m2NormalizedChi2_branch.SetAddress(<void*>&self.m2NormalizedChi2_value)

        #print "making m2PFChargedHadronIsoR04"
        self.m2PFChargedHadronIsoR04_branch = the_tree.GetBranch("m2PFChargedHadronIsoR04")
        #if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04" not in self.complained:
        if not self.m2PFChargedHadronIsoR04_branch and "m2PFChargedHadronIsoR04":
            warnings.warn( "MuMuTree: Expected branch m2PFChargedHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedHadronIsoR04")
        else:
            self.m2PFChargedHadronIsoR04_branch.SetAddress(<void*>&self.m2PFChargedHadronIsoR04_value)

        #print "making m2PFChargedIso"
        self.m2PFChargedIso_branch = the_tree.GetBranch("m2PFChargedIso")
        #if not self.m2PFChargedIso_branch and "m2PFChargedIso" not in self.complained:
        if not self.m2PFChargedIso_branch and "m2PFChargedIso":
            warnings.warn( "MuMuTree: Expected branch m2PFChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFChargedIso")
        else:
            self.m2PFChargedIso_branch.SetAddress(<void*>&self.m2PFChargedIso_value)

        #print "making m2PFIDLoose"
        self.m2PFIDLoose_branch = the_tree.GetBranch("m2PFIDLoose")
        #if not self.m2PFIDLoose_branch and "m2PFIDLoose" not in self.complained:
        if not self.m2PFIDLoose_branch and "m2PFIDLoose":
            warnings.warn( "MuMuTree: Expected branch m2PFIDLoose does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDLoose")
        else:
            self.m2PFIDLoose_branch.SetAddress(<void*>&self.m2PFIDLoose_value)

        #print "making m2PFIDMedium"
        self.m2PFIDMedium_branch = the_tree.GetBranch("m2PFIDMedium")
        #if not self.m2PFIDMedium_branch and "m2PFIDMedium" not in self.complained:
        if not self.m2PFIDMedium_branch and "m2PFIDMedium":
            warnings.warn( "MuMuTree: Expected branch m2PFIDMedium does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDMedium")
        else:
            self.m2PFIDMedium_branch.SetAddress(<void*>&self.m2PFIDMedium_value)

        #print "making m2PFIDTight"
        self.m2PFIDTight_branch = the_tree.GetBranch("m2PFIDTight")
        #if not self.m2PFIDTight_branch and "m2PFIDTight" not in self.complained:
        if not self.m2PFIDTight_branch and "m2PFIDTight":
            warnings.warn( "MuMuTree: Expected branch m2PFIDTight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFIDTight")
        else:
            self.m2PFIDTight_branch.SetAddress(<void*>&self.m2PFIDTight_value)

        #print "making m2PFNeutralHadronIsoR04"
        self.m2PFNeutralHadronIsoR04_branch = the_tree.GetBranch("m2PFNeutralHadronIsoR04")
        #if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04" not in self.complained:
        if not self.m2PFNeutralHadronIsoR04_branch and "m2PFNeutralHadronIsoR04":
            warnings.warn( "MuMuTree: Expected branch m2PFNeutralHadronIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralHadronIsoR04")
        else:
            self.m2PFNeutralHadronIsoR04_branch.SetAddress(<void*>&self.m2PFNeutralHadronIsoR04_value)

        #print "making m2PFNeutralIso"
        self.m2PFNeutralIso_branch = the_tree.GetBranch("m2PFNeutralIso")
        #if not self.m2PFNeutralIso_branch and "m2PFNeutralIso" not in self.complained:
        if not self.m2PFNeutralIso_branch and "m2PFNeutralIso":
            warnings.warn( "MuMuTree: Expected branch m2PFNeutralIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFNeutralIso")
        else:
            self.m2PFNeutralIso_branch.SetAddress(<void*>&self.m2PFNeutralIso_value)

        #print "making m2PFPUChargedIso"
        self.m2PFPUChargedIso_branch = the_tree.GetBranch("m2PFPUChargedIso")
        #if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso" not in self.complained:
        if not self.m2PFPUChargedIso_branch and "m2PFPUChargedIso":
            warnings.warn( "MuMuTree: Expected branch m2PFPUChargedIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPUChargedIso")
        else:
            self.m2PFPUChargedIso_branch.SetAddress(<void*>&self.m2PFPUChargedIso_value)

        #print "making m2PFPhotonIso"
        self.m2PFPhotonIso_branch = the_tree.GetBranch("m2PFPhotonIso")
        #if not self.m2PFPhotonIso_branch and "m2PFPhotonIso" not in self.complained:
        if not self.m2PFPhotonIso_branch and "m2PFPhotonIso":
            warnings.warn( "MuMuTree: Expected branch m2PFPhotonIso does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIso")
        else:
            self.m2PFPhotonIso_branch.SetAddress(<void*>&self.m2PFPhotonIso_value)

        #print "making m2PFPhotonIsoR04"
        self.m2PFPhotonIsoR04_branch = the_tree.GetBranch("m2PFPhotonIsoR04")
        #if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04" not in self.complained:
        if not self.m2PFPhotonIsoR04_branch and "m2PFPhotonIsoR04":
            warnings.warn( "MuMuTree: Expected branch m2PFPhotonIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPhotonIsoR04")
        else:
            self.m2PFPhotonIsoR04_branch.SetAddress(<void*>&self.m2PFPhotonIsoR04_value)

        #print "making m2PFPileupIsoR04"
        self.m2PFPileupIsoR04_branch = the_tree.GetBranch("m2PFPileupIsoR04")
        #if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04" not in self.complained:
        if not self.m2PFPileupIsoR04_branch and "m2PFPileupIsoR04":
            warnings.warn( "MuMuTree: Expected branch m2PFPileupIsoR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PFPileupIsoR04")
        else:
            self.m2PFPileupIsoR04_branch.SetAddress(<void*>&self.m2PFPileupIsoR04_value)

        #print "making m2PVDXY"
        self.m2PVDXY_branch = the_tree.GetBranch("m2PVDXY")
        #if not self.m2PVDXY_branch and "m2PVDXY" not in self.complained:
        if not self.m2PVDXY_branch and "m2PVDXY":
            warnings.warn( "MuMuTree: Expected branch m2PVDXY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDXY")
        else:
            self.m2PVDXY_branch.SetAddress(<void*>&self.m2PVDXY_value)

        #print "making m2PVDZ"
        self.m2PVDZ_branch = the_tree.GetBranch("m2PVDZ")
        #if not self.m2PVDZ_branch and "m2PVDZ" not in self.complained:
        if not self.m2PVDZ_branch and "m2PVDZ":
            warnings.warn( "MuMuTree: Expected branch m2PVDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PVDZ")
        else:
            self.m2PVDZ_branch.SetAddress(<void*>&self.m2PVDZ_value)

        #print "making m2Phi"
        self.m2Phi_branch = the_tree.GetBranch("m2Phi")
        #if not self.m2Phi_branch and "m2Phi" not in self.complained:
        if not self.m2Phi_branch and "m2Phi":
            warnings.warn( "MuMuTree: Expected branch m2Phi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi")
        else:
            self.m2Phi_branch.SetAddress(<void*>&self.m2Phi_value)

        #print "making m2Phi_MuonEnDown"
        self.m2Phi_MuonEnDown_branch = the_tree.GetBranch("m2Phi_MuonEnDown")
        #if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown" not in self.complained:
        if not self.m2Phi_MuonEnDown_branch and "m2Phi_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2Phi_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnDown")
        else:
            self.m2Phi_MuonEnDown_branch.SetAddress(<void*>&self.m2Phi_MuonEnDown_value)

        #print "making m2Phi_MuonEnUp"
        self.m2Phi_MuonEnUp_branch = the_tree.GetBranch("m2Phi_MuonEnUp")
        #if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp" not in self.complained:
        if not self.m2Phi_MuonEnUp_branch and "m2Phi_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2Phi_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Phi_MuonEnUp")
        else:
            self.m2Phi_MuonEnUp_branch.SetAddress(<void*>&self.m2Phi_MuonEnUp_value)

        #print "making m2PixHits"
        self.m2PixHits_branch = the_tree.GetBranch("m2PixHits")
        #if not self.m2PixHits_branch and "m2PixHits" not in self.complained:
        if not self.m2PixHits_branch and "m2PixHits":
            warnings.warn( "MuMuTree: Expected branch m2PixHits does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2PixHits")
        else:
            self.m2PixHits_branch.SetAddress(<void*>&self.m2PixHits_value)

        #print "making m2Pt"
        self.m2Pt_branch = the_tree.GetBranch("m2Pt")
        #if not self.m2Pt_branch and "m2Pt" not in self.complained:
        if not self.m2Pt_branch and "m2Pt":
            warnings.warn( "MuMuTree: Expected branch m2Pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt")
        else:
            self.m2Pt_branch.SetAddress(<void*>&self.m2Pt_value)

        #print "making m2Pt_MuonEnDown"
        self.m2Pt_MuonEnDown_branch = the_tree.GetBranch("m2Pt_MuonEnDown")
        #if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown" not in self.complained:
        if not self.m2Pt_MuonEnDown_branch and "m2Pt_MuonEnDown":
            warnings.warn( "MuMuTree: Expected branch m2Pt_MuonEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnDown")
        else:
            self.m2Pt_MuonEnDown_branch.SetAddress(<void*>&self.m2Pt_MuonEnDown_value)

        #print "making m2Pt_MuonEnUp"
        self.m2Pt_MuonEnUp_branch = the_tree.GetBranch("m2Pt_MuonEnUp")
        #if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp" not in self.complained:
        if not self.m2Pt_MuonEnUp_branch and "m2Pt_MuonEnUp":
            warnings.warn( "MuMuTree: Expected branch m2Pt_MuonEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Pt_MuonEnUp")
        else:
            self.m2Pt_MuonEnUp_branch.SetAddress(<void*>&self.m2Pt_MuonEnUp_value)

        #print "making m2Rank"
        self.m2Rank_branch = the_tree.GetBranch("m2Rank")
        #if not self.m2Rank_branch and "m2Rank" not in self.complained:
        if not self.m2Rank_branch and "m2Rank":
            warnings.warn( "MuMuTree: Expected branch m2Rank does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rank")
        else:
            self.m2Rank_branch.SetAddress(<void*>&self.m2Rank_value)

        #print "making m2RelPFIsoDBDefault"
        self.m2RelPFIsoDBDefault_branch = the_tree.GetBranch("m2RelPFIsoDBDefault")
        #if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault" not in self.complained:
        if not self.m2RelPFIsoDBDefault_branch and "m2RelPFIsoDBDefault":
            warnings.warn( "MuMuTree: Expected branch m2RelPFIsoDBDefault does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefault")
        else:
            self.m2RelPFIsoDBDefault_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefault_value)

        #print "making m2RelPFIsoDBDefaultR04"
        self.m2RelPFIsoDBDefaultR04_branch = the_tree.GetBranch("m2RelPFIsoDBDefaultR04")
        #if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04" not in self.complained:
        if not self.m2RelPFIsoDBDefaultR04_branch and "m2RelPFIsoDBDefaultR04":
            warnings.warn( "MuMuTree: Expected branch m2RelPFIsoDBDefaultR04 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoDBDefaultR04")
        else:
            self.m2RelPFIsoDBDefaultR04_branch.SetAddress(<void*>&self.m2RelPFIsoDBDefaultR04_value)

        #print "making m2RelPFIsoRho"
        self.m2RelPFIsoRho_branch = the_tree.GetBranch("m2RelPFIsoRho")
        #if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho" not in self.complained:
        if not self.m2RelPFIsoRho_branch and "m2RelPFIsoRho":
            warnings.warn( "MuMuTree: Expected branch m2RelPFIsoRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2RelPFIsoRho")
        else:
            self.m2RelPFIsoRho_branch.SetAddress(<void*>&self.m2RelPFIsoRho_value)

        #print "making m2Rho"
        self.m2Rho_branch = the_tree.GetBranch("m2Rho")
        #if not self.m2Rho_branch and "m2Rho" not in self.complained:
        if not self.m2Rho_branch and "m2Rho":
            warnings.warn( "MuMuTree: Expected branch m2Rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2Rho")
        else:
            self.m2Rho_branch.SetAddress(<void*>&self.m2Rho_value)

        #print "making m2SIP2D"
        self.m2SIP2D_branch = the_tree.GetBranch("m2SIP2D")
        #if not self.m2SIP2D_branch and "m2SIP2D" not in self.complained:
        if not self.m2SIP2D_branch and "m2SIP2D":
            warnings.warn( "MuMuTree: Expected branch m2SIP2D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP2D")
        else:
            self.m2SIP2D_branch.SetAddress(<void*>&self.m2SIP2D_value)

        #print "making m2SIP3D"
        self.m2SIP3D_branch = the_tree.GetBranch("m2SIP3D")
        #if not self.m2SIP3D_branch and "m2SIP3D" not in self.complained:
        if not self.m2SIP3D_branch and "m2SIP3D":
            warnings.warn( "MuMuTree: Expected branch m2SIP3D does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SIP3D")
        else:
            self.m2SIP3D_branch.SetAddress(<void*>&self.m2SIP3D_value)

        #print "making m2SegmentCompatibility"
        self.m2SegmentCompatibility_branch = the_tree.GetBranch("m2SegmentCompatibility")
        #if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility" not in self.complained:
        if not self.m2SegmentCompatibility_branch and "m2SegmentCompatibility":
            warnings.warn( "MuMuTree: Expected branch m2SegmentCompatibility does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2SegmentCompatibility")
        else:
            self.m2SegmentCompatibility_branch.SetAddress(<void*>&self.m2SegmentCompatibility_value)

        #print "making m2TkLayersWithMeasurement"
        self.m2TkLayersWithMeasurement_branch = the_tree.GetBranch("m2TkLayersWithMeasurement")
        #if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement" not in self.complained:
        if not self.m2TkLayersWithMeasurement_branch and "m2TkLayersWithMeasurement":
            warnings.warn( "MuMuTree: Expected branch m2TkLayersWithMeasurement does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TkLayersWithMeasurement")
        else:
            self.m2TkLayersWithMeasurement_branch.SetAddress(<void*>&self.m2TkLayersWithMeasurement_value)

        #print "making m2TrkIsoDR03"
        self.m2TrkIsoDR03_branch = the_tree.GetBranch("m2TrkIsoDR03")
        #if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03" not in self.complained:
        if not self.m2TrkIsoDR03_branch and "m2TrkIsoDR03":
            warnings.warn( "MuMuTree: Expected branch m2TrkIsoDR03 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkIsoDR03")
        else:
            self.m2TrkIsoDR03_branch.SetAddress(<void*>&self.m2TrkIsoDR03_value)

        #print "making m2TrkKink"
        self.m2TrkKink_branch = the_tree.GetBranch("m2TrkKink")
        #if not self.m2TrkKink_branch and "m2TrkKink" not in self.complained:
        if not self.m2TrkKink_branch and "m2TrkKink":
            warnings.warn( "MuMuTree: Expected branch m2TrkKink does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TrkKink")
        else:
            self.m2TrkKink_branch.SetAddress(<void*>&self.m2TrkKink_value)

        #print "making m2TypeCode"
        self.m2TypeCode_branch = the_tree.GetBranch("m2TypeCode")
        #if not self.m2TypeCode_branch and "m2TypeCode" not in self.complained:
        if not self.m2TypeCode_branch and "m2TypeCode":
            warnings.warn( "MuMuTree: Expected branch m2TypeCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2TypeCode")
        else:
            self.m2TypeCode_branch.SetAddress(<void*>&self.m2TypeCode_value)

        #print "making m2VZ"
        self.m2VZ_branch = the_tree.GetBranch("m2VZ")
        #if not self.m2VZ_branch and "m2VZ" not in self.complained:
        if not self.m2VZ_branch and "m2VZ":
            warnings.warn( "MuMuTree: Expected branch m2VZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2VZ")
        else:
            self.m2VZ_branch.SetAddress(<void*>&self.m2VZ_value)

        #print "making m2ValidFraction"
        self.m2ValidFraction_branch = the_tree.GetBranch("m2ValidFraction")
        #if not self.m2ValidFraction_branch and "m2ValidFraction" not in self.complained:
        if not self.m2ValidFraction_branch and "m2ValidFraction":
            warnings.warn( "MuMuTree: Expected branch m2ValidFraction does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ValidFraction")
        else:
            self.m2ValidFraction_branch.SetAddress(<void*>&self.m2ValidFraction_value)

        #print "making m2ZTTGenMatching"
        self.m2ZTTGenMatching_branch = the_tree.GetBranch("m2ZTTGenMatching")
        #if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching" not in self.complained:
        if not self.m2ZTTGenMatching_branch and "m2ZTTGenMatching":
            warnings.warn( "MuMuTree: Expected branch m2ZTTGenMatching does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2ZTTGenMatching")
        else:
            self.m2ZTTGenMatching_branch.SetAddress(<void*>&self.m2ZTTGenMatching_value)

        #print "making m2_m1_collinearmass"
        self.m2_m1_collinearmass_branch = the_tree.GetBranch("m2_m1_collinearmass")
        #if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass" not in self.complained:
        if not self.m2_m1_collinearmass_branch and "m2_m1_collinearmass":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass")
        else:
            self.m2_m1_collinearmass_branch.SetAddress(<void*>&self.m2_m1_collinearmass_value)

        #print "making m2_m1_collinearmass_CheckUESDown"
        self.m2_m1_collinearmass_CheckUESDown_branch = the_tree.GetBranch("m2_m1_collinearmass_CheckUESDown")
        #if not self.m2_m1_collinearmass_CheckUESDown_branch and "m2_m1_collinearmass_CheckUESDown" not in self.complained:
        if not self.m2_m1_collinearmass_CheckUESDown_branch and "m2_m1_collinearmass_CheckUESDown":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_CheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_CheckUESDown")
        else:
            self.m2_m1_collinearmass_CheckUESDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_CheckUESDown_value)

        #print "making m2_m1_collinearmass_CheckUESUp"
        self.m2_m1_collinearmass_CheckUESUp_branch = the_tree.GetBranch("m2_m1_collinearmass_CheckUESUp")
        #if not self.m2_m1_collinearmass_CheckUESUp_branch and "m2_m1_collinearmass_CheckUESUp" not in self.complained:
        if not self.m2_m1_collinearmass_CheckUESUp_branch and "m2_m1_collinearmass_CheckUESUp":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_CheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_CheckUESUp")
        else:
            self.m2_m1_collinearmass_CheckUESUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_CheckUESUp_value)

        #print "making m2_m1_collinearmass_JetCheckTotalDown"
        self.m2_m1_collinearmass_JetCheckTotalDown_branch = the_tree.GetBranch("m2_m1_collinearmass_JetCheckTotalDown")
        #if not self.m2_m1_collinearmass_JetCheckTotalDown_branch and "m2_m1_collinearmass_JetCheckTotalDown" not in self.complained:
        if not self.m2_m1_collinearmass_JetCheckTotalDown_branch and "m2_m1_collinearmass_JetCheckTotalDown":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_JetCheckTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetCheckTotalDown")
        else:
            self.m2_m1_collinearmass_JetCheckTotalDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetCheckTotalDown_value)

        #print "making m2_m1_collinearmass_JetCheckTotalUp"
        self.m2_m1_collinearmass_JetCheckTotalUp_branch = the_tree.GetBranch("m2_m1_collinearmass_JetCheckTotalUp")
        #if not self.m2_m1_collinearmass_JetCheckTotalUp_branch and "m2_m1_collinearmass_JetCheckTotalUp" not in self.complained:
        if not self.m2_m1_collinearmass_JetCheckTotalUp_branch and "m2_m1_collinearmass_JetCheckTotalUp":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_JetCheckTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetCheckTotalUp")
        else:
            self.m2_m1_collinearmass_JetCheckTotalUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetCheckTotalUp_value)

        #print "making m2_m1_collinearmass_JetEnDown"
        self.m2_m1_collinearmass_JetEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnDown")
        #if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnDown_branch and "m2_m1_collinearmass_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnDown")
        else:
            self.m2_m1_collinearmass_JetEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnDown_value)

        #print "making m2_m1_collinearmass_JetEnUp"
        self.m2_m1_collinearmass_JetEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_JetEnUp")
        #if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_JetEnUp_branch and "m2_m1_collinearmass_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_JetEnUp")
        else:
            self.m2_m1_collinearmass_JetEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_JetEnUp_value)

        #print "making m2_m1_collinearmass_UnclusteredEnDown"
        self.m2_m1_collinearmass_UnclusteredEnDown_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnDown")
        #if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnDown_branch and "m2_m1_collinearmass_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnDown")
        else:
            self.m2_m1_collinearmass_UnclusteredEnDown_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnDown_value)

        #print "making m2_m1_collinearmass_UnclusteredEnUp"
        self.m2_m1_collinearmass_UnclusteredEnUp_branch = the_tree.GetBranch("m2_m1_collinearmass_UnclusteredEnUp")
        #if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp" not in self.complained:
        if not self.m2_m1_collinearmass_UnclusteredEnUp_branch and "m2_m1_collinearmass_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch m2_m1_collinearmass_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m2_m1_collinearmass_UnclusteredEnUp")
        else:
            self.m2_m1_collinearmass_UnclusteredEnUp_branch.SetAddress(<void*>&self.m2_m1_collinearmass_UnclusteredEnUp_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "MuMuTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "MuMuTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov00_DESYlike"
        self.metcov00_DESYlike_branch = the_tree.GetBranch("metcov00_DESYlike")
        #if not self.metcov00_DESYlike_branch and "metcov00_DESYlike" not in self.complained:
        if not self.metcov00_DESYlike_branch and "metcov00_DESYlike":
            warnings.warn( "MuMuTree: Expected branch metcov00_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00_DESYlike")
        else:
            self.metcov00_DESYlike_branch.SetAddress(<void*>&self.metcov00_DESYlike_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "MuMuTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metcov01_DESYlike"
        self.metcov01_DESYlike_branch = the_tree.GetBranch("metcov01_DESYlike")
        #if not self.metcov01_DESYlike_branch and "metcov01_DESYlike" not in self.complained:
        if not self.metcov01_DESYlike_branch and "metcov01_DESYlike":
            warnings.warn( "MuMuTree: Expected branch metcov01_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01_DESYlike")
        else:
            self.metcov01_DESYlike_branch.SetAddress(<void*>&self.metcov01_DESYlike_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "MuMuTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov10_DESYlike"
        self.metcov10_DESYlike_branch = the_tree.GetBranch("metcov10_DESYlike")
        #if not self.metcov10_DESYlike_branch and "metcov10_DESYlike" not in self.complained:
        if not self.metcov10_DESYlike_branch and "metcov10_DESYlike":
            warnings.warn( "MuMuTree: Expected branch metcov10_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10_DESYlike")
        else:
            self.metcov10_DESYlike_branch.SetAddress(<void*>&self.metcov10_DESYlike_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "MuMuTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov11_DESYlike"
        self.metcov11_DESYlike_branch = the_tree.GetBranch("metcov11_DESYlike")
        #if not self.metcov11_DESYlike_branch and "metcov11_DESYlike" not in self.complained:
        if not self.metcov11_DESYlike_branch and "metcov11_DESYlike":
            warnings.warn( "MuMuTree: Expected branch metcov11_DESYlike does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11_DESYlike")
        else:
            self.metcov11_DESYlike_branch.SetAddress(<void*>&self.metcov11_DESYlike_value)

        #print "making muGlbIsoVetoPt10"
        self.muGlbIsoVetoPt10_branch = the_tree.GetBranch("muGlbIsoVetoPt10")
        #if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10" not in self.complained:
        if not self.muGlbIsoVetoPt10_branch and "muGlbIsoVetoPt10":
            warnings.warn( "MuMuTree: Expected branch muGlbIsoVetoPt10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muGlbIsoVetoPt10")
        else:
            self.muGlbIsoVetoPt10_branch.SetAddress(<void*>&self.muGlbIsoVetoPt10_value)

        #print "making muVetoPt15IsoIdVtx"
        self.muVetoPt15IsoIdVtx_branch = the_tree.GetBranch("muVetoPt15IsoIdVtx")
        #if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx" not in self.complained:
        if not self.muVetoPt15IsoIdVtx_branch and "muVetoPt15IsoIdVtx":
            warnings.warn( "MuMuTree: Expected branch muVetoPt15IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt15IsoIdVtx")
        else:
            self.muVetoPt15IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt15IsoIdVtx_value)

        #print "making muVetoPt5"
        self.muVetoPt5_branch = the_tree.GetBranch("muVetoPt5")
        #if not self.muVetoPt5_branch and "muVetoPt5" not in self.complained:
        if not self.muVetoPt5_branch and "muVetoPt5":
            warnings.warn( "MuMuTree: Expected branch muVetoPt5 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5")
        else:
            self.muVetoPt5_branch.SetAddress(<void*>&self.muVetoPt5_value)

        #print "making muVetoPt5IsoIdVtx"
        self.muVetoPt5IsoIdVtx_branch = the_tree.GetBranch("muVetoPt5IsoIdVtx")
        #if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx" not in self.complained:
        if not self.muVetoPt5IsoIdVtx_branch and "muVetoPt5IsoIdVtx":
            warnings.warn( "MuMuTree: Expected branch muVetoPt5IsoIdVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoPt5IsoIdVtx")
        else:
            self.muVetoPt5IsoIdVtx_branch.SetAddress(<void*>&self.muVetoPt5IsoIdVtx_value)

        #print "making muVetoZTTp001dxyz"
        self.muVetoZTTp001dxyz_branch = the_tree.GetBranch("muVetoZTTp001dxyz")
        #if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz" not in self.complained:
        if not self.muVetoZTTp001dxyz_branch and "muVetoZTTp001dxyz":
            warnings.warn( "MuMuTree: Expected branch muVetoZTTp001dxyz does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyz")
        else:
            self.muVetoZTTp001dxyz_branch.SetAddress(<void*>&self.muVetoZTTp001dxyz_value)

        #print "making muVetoZTTp001dxyzR0"
        self.muVetoZTTp001dxyzR0_branch = the_tree.GetBranch("muVetoZTTp001dxyzR0")
        #if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0" not in self.complained:
        if not self.muVetoZTTp001dxyzR0_branch and "muVetoZTTp001dxyzR0":
            warnings.warn( "MuMuTree: Expected branch muVetoZTTp001dxyzR0 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("muVetoZTTp001dxyzR0")
        else:
            self.muVetoZTTp001dxyzR0_branch.SetAddress(<void*>&self.muVetoZTTp001dxyzR0_value)

        #print "making nTruePU"
        self.nTruePU_branch = the_tree.GetBranch("nTruePU")
        #if not self.nTruePU_branch and "nTruePU" not in self.complained:
        if not self.nTruePU_branch and "nTruePU":
            warnings.warn( "MuMuTree: Expected branch nTruePU does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nTruePU")
        else:
            self.nTruePU_branch.SetAddress(<void*>&self.nTruePU_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "MuMuTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making nvtx"
        self.nvtx_branch = the_tree.GetBranch("nvtx")
        #if not self.nvtx_branch and "nvtx" not in self.complained:
        if not self.nvtx_branch and "nvtx":
            warnings.warn( "MuMuTree: Expected branch nvtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nvtx")
        else:
            self.nvtx_branch.SetAddress(<void*>&self.nvtx_value)

        #print "making processID"
        self.processID_branch = the_tree.GetBranch("processID")
        #if not self.processID_branch and "processID" not in self.complained:
        if not self.processID_branch and "processID":
            warnings.warn( "MuMuTree: Expected branch processID does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("processID")
        else:
            self.processID_branch.SetAddress(<void*>&self.processID_value)

        #print "making puppiMetEt"
        self.puppiMetEt_branch = the_tree.GetBranch("puppiMetEt")
        #if not self.puppiMetEt_branch and "puppiMetEt" not in self.complained:
        if not self.puppiMetEt_branch and "puppiMetEt":
            warnings.warn( "MuMuTree: Expected branch puppiMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetEt")
        else:
            self.puppiMetEt_branch.SetAddress(<void*>&self.puppiMetEt_value)

        #print "making puppiMetPhi"
        self.puppiMetPhi_branch = the_tree.GetBranch("puppiMetPhi")
        #if not self.puppiMetPhi_branch and "puppiMetPhi" not in self.complained:
        if not self.puppiMetPhi_branch and "puppiMetPhi":
            warnings.warn( "MuMuTree: Expected branch puppiMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("puppiMetPhi")
        else:
            self.puppiMetPhi_branch.SetAddress(<void*>&self.puppiMetPhi_value)

        #print "making pvChi2"
        self.pvChi2_branch = the_tree.GetBranch("pvChi2")
        #if not self.pvChi2_branch and "pvChi2" not in self.complained:
        if not self.pvChi2_branch and "pvChi2":
            warnings.warn( "MuMuTree: Expected branch pvChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvChi2")
        else:
            self.pvChi2_branch.SetAddress(<void*>&self.pvChi2_value)

        #print "making pvDX"
        self.pvDX_branch = the_tree.GetBranch("pvDX")
        #if not self.pvDX_branch and "pvDX" not in self.complained:
        if not self.pvDX_branch and "pvDX":
            warnings.warn( "MuMuTree: Expected branch pvDX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDX")
        else:
            self.pvDX_branch.SetAddress(<void*>&self.pvDX_value)

        #print "making pvDY"
        self.pvDY_branch = the_tree.GetBranch("pvDY")
        #if not self.pvDY_branch and "pvDY" not in self.complained:
        if not self.pvDY_branch and "pvDY":
            warnings.warn( "MuMuTree: Expected branch pvDY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDY")
        else:
            self.pvDY_branch.SetAddress(<void*>&self.pvDY_value)

        #print "making pvDZ"
        self.pvDZ_branch = the_tree.GetBranch("pvDZ")
        #if not self.pvDZ_branch and "pvDZ" not in self.complained:
        if not self.pvDZ_branch and "pvDZ":
            warnings.warn( "MuMuTree: Expected branch pvDZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvDZ")
        else:
            self.pvDZ_branch.SetAddress(<void*>&self.pvDZ_value)

        #print "making pvIsFake"
        self.pvIsFake_branch = the_tree.GetBranch("pvIsFake")
        #if not self.pvIsFake_branch and "pvIsFake" not in self.complained:
        if not self.pvIsFake_branch and "pvIsFake":
            warnings.warn( "MuMuTree: Expected branch pvIsFake does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsFake")
        else:
            self.pvIsFake_branch.SetAddress(<void*>&self.pvIsFake_value)

        #print "making pvIsValid"
        self.pvIsValid_branch = the_tree.GetBranch("pvIsValid")
        #if not self.pvIsValid_branch and "pvIsValid" not in self.complained:
        if not self.pvIsValid_branch and "pvIsValid":
            warnings.warn( "MuMuTree: Expected branch pvIsValid does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvIsValid")
        else:
            self.pvIsValid_branch.SetAddress(<void*>&self.pvIsValid_value)

        #print "making pvNormChi2"
        self.pvNormChi2_branch = the_tree.GetBranch("pvNormChi2")
        #if not self.pvNormChi2_branch and "pvNormChi2" not in self.complained:
        if not self.pvNormChi2_branch and "pvNormChi2":
            warnings.warn( "MuMuTree: Expected branch pvNormChi2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvNormChi2")
        else:
            self.pvNormChi2_branch.SetAddress(<void*>&self.pvNormChi2_value)

        #print "making pvRho"
        self.pvRho_branch = the_tree.GetBranch("pvRho")
        #if not self.pvRho_branch and "pvRho" not in self.complained:
        if not self.pvRho_branch and "pvRho":
            warnings.warn( "MuMuTree: Expected branch pvRho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvRho")
        else:
            self.pvRho_branch.SetAddress(<void*>&self.pvRho_value)

        #print "making pvX"
        self.pvX_branch = the_tree.GetBranch("pvX")
        #if not self.pvX_branch and "pvX" not in self.complained:
        if not self.pvX_branch and "pvX":
            warnings.warn( "MuMuTree: Expected branch pvX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvX")
        else:
            self.pvX_branch.SetAddress(<void*>&self.pvX_value)

        #print "making pvY"
        self.pvY_branch = the_tree.GetBranch("pvY")
        #if not self.pvY_branch and "pvY" not in self.complained:
        if not self.pvY_branch and "pvY":
            warnings.warn( "MuMuTree: Expected branch pvY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvY")
        else:
            self.pvY_branch.SetAddress(<void*>&self.pvY_value)

        #print "making pvZ"
        self.pvZ_branch = the_tree.GetBranch("pvZ")
        #if not self.pvZ_branch and "pvZ" not in self.complained:
        if not self.pvZ_branch and "pvZ":
            warnings.warn( "MuMuTree: Expected branch pvZ does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvZ")
        else:
            self.pvZ_branch.SetAddress(<void*>&self.pvZ_value)

        #print "making pvndof"
        self.pvndof_branch = the_tree.GetBranch("pvndof")
        #if not self.pvndof_branch and "pvndof" not in self.complained:
        if not self.pvndof_branch and "pvndof":
            warnings.warn( "MuMuTree: Expected branch pvndof does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pvndof")
        else:
            self.pvndof_branch.SetAddress(<void*>&self.pvndof_value)

        #print "making raw_pfMetEt"
        self.raw_pfMetEt_branch = the_tree.GetBranch("raw_pfMetEt")
        #if not self.raw_pfMetEt_branch and "raw_pfMetEt" not in self.complained:
        if not self.raw_pfMetEt_branch and "raw_pfMetEt":
            warnings.warn( "MuMuTree: Expected branch raw_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetEt")
        else:
            self.raw_pfMetEt_branch.SetAddress(<void*>&self.raw_pfMetEt_value)

        #print "making raw_pfMetPhi"
        self.raw_pfMetPhi_branch = the_tree.GetBranch("raw_pfMetPhi")
        #if not self.raw_pfMetPhi_branch and "raw_pfMetPhi" not in self.complained:
        if not self.raw_pfMetPhi_branch and "raw_pfMetPhi":
            warnings.warn( "MuMuTree: Expected branch raw_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("raw_pfMetPhi")
        else:
            self.raw_pfMetPhi_branch.SetAddress(<void*>&self.raw_pfMetPhi_value)

        #print "making recoilDaught"
        self.recoilDaught_branch = the_tree.GetBranch("recoilDaught")
        #if not self.recoilDaught_branch and "recoilDaught" not in self.complained:
        if not self.recoilDaught_branch and "recoilDaught":
            warnings.warn( "MuMuTree: Expected branch recoilDaught does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilDaught")
        else:
            self.recoilDaught_branch.SetAddress(<void*>&self.recoilDaught_value)

        #print "making recoilWithMet"
        self.recoilWithMet_branch = the_tree.GetBranch("recoilWithMet")
        #if not self.recoilWithMet_branch and "recoilWithMet" not in self.complained:
        if not self.recoilWithMet_branch and "recoilWithMet":
            warnings.warn( "MuMuTree: Expected branch recoilWithMet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("recoilWithMet")
        else:
            self.recoilWithMet_branch.SetAddress(<void*>&self.recoilWithMet_value)

        #print "making rho"
        self.rho_branch = the_tree.GetBranch("rho")
        #if not self.rho_branch and "rho" not in self.complained:
        if not self.rho_branch and "rho":
            warnings.warn( "MuMuTree: Expected branch rho does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("rho")
        else:
            self.rho_branch.SetAddress(<void*>&self.rho_value)

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "MuMuTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making singleE24SingleLooseIsoTau30Group"
        self.singleE24SingleLooseIsoTau30Group_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30Group")
        #if not self.singleE24SingleLooseIsoTau30Group_branch and "singleE24SingleLooseIsoTau30Group" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30Group_branch and "singleE24SingleLooseIsoTau30Group":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30Group")
        else:
            self.singleE24SingleLooseIsoTau30Group_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30Group_value)

        #print "making singleE24SingleLooseIsoTau30Pass"
        self.singleE24SingleLooseIsoTau30Pass_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30Pass")
        #if not self.singleE24SingleLooseIsoTau30Pass_branch and "singleE24SingleLooseIsoTau30Pass" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30Pass_branch and "singleE24SingleLooseIsoTau30Pass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30Pass")
        else:
            self.singleE24SingleLooseIsoTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30Pass_value)

        #print "making singleE24SingleLooseIsoTau30Prescale"
        self.singleE24SingleLooseIsoTau30Prescale_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30Prescale")
        #if not self.singleE24SingleLooseIsoTau30Prescale_branch and "singleE24SingleLooseIsoTau30Prescale" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30Prescale_branch and "singleE24SingleLooseIsoTau30Prescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30Prescale")
        else:
            self.singleE24SingleLooseIsoTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30Prescale_value)

        #print "making singleE24SingleLooseIsoTau30TightIDGroup"
        self.singleE24SingleLooseIsoTau30TightIDGroup_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30TightIDGroup")
        #if not self.singleE24SingleLooseIsoTau30TightIDGroup_branch and "singleE24SingleLooseIsoTau30TightIDGroup" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30TightIDGroup_branch and "singleE24SingleLooseIsoTau30TightIDGroup":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30TightIDGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30TightIDGroup")
        else:
            self.singleE24SingleLooseIsoTau30TightIDGroup_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30TightIDGroup_value)

        #print "making singleE24SingleLooseIsoTau30TightIDPass"
        self.singleE24SingleLooseIsoTau30TightIDPass_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30TightIDPass")
        #if not self.singleE24SingleLooseIsoTau30TightIDPass_branch and "singleE24SingleLooseIsoTau30TightIDPass" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30TightIDPass_branch and "singleE24SingleLooseIsoTau30TightIDPass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30TightIDPass")
        else:
            self.singleE24SingleLooseIsoTau30TightIDPass_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30TightIDPass_value)

        #print "making singleE24SingleLooseIsoTau30TightIDPrescale"
        self.singleE24SingleLooseIsoTau30TightIDPrescale_branch = the_tree.GetBranch("singleE24SingleLooseIsoTau30TightIDPrescale")
        #if not self.singleE24SingleLooseIsoTau30TightIDPrescale_branch and "singleE24SingleLooseIsoTau30TightIDPrescale" not in self.complained:
        if not self.singleE24SingleLooseIsoTau30TightIDPrescale_branch and "singleE24SingleLooseIsoTau30TightIDPrescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleLooseIsoTau30TightIDPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleLooseIsoTau30TightIDPrescale")
        else:
            self.singleE24SingleLooseIsoTau30TightIDPrescale_branch.SetAddress(<void*>&self.singleE24SingleLooseIsoTau30TightIDPrescale_value)

        #print "making singleE24SingleMediumIsoTau30Group"
        self.singleE24SingleMediumIsoTau30Group_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30Group")
        #if not self.singleE24SingleMediumIsoTau30Group_branch and "singleE24SingleMediumIsoTau30Group" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30Group_branch and "singleE24SingleMediumIsoTau30Group":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30Group")
        else:
            self.singleE24SingleMediumIsoTau30Group_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30Group_value)

        #print "making singleE24SingleMediumIsoTau30Pass"
        self.singleE24SingleMediumIsoTau30Pass_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30Pass")
        #if not self.singleE24SingleMediumIsoTau30Pass_branch and "singleE24SingleMediumIsoTau30Pass" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30Pass_branch and "singleE24SingleMediumIsoTau30Pass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30Pass")
        else:
            self.singleE24SingleMediumIsoTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30Pass_value)

        #print "making singleE24SingleMediumIsoTau30Prescale"
        self.singleE24SingleMediumIsoTau30Prescale_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30Prescale")
        #if not self.singleE24SingleMediumIsoTau30Prescale_branch and "singleE24SingleMediumIsoTau30Prescale" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30Prescale_branch and "singleE24SingleMediumIsoTau30Prescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30Prescale")
        else:
            self.singleE24SingleMediumIsoTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30Prescale_value)

        #print "making singleE24SingleMediumIsoTau30TightIDGroup"
        self.singleE24SingleMediumIsoTau30TightIDGroup_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30TightIDGroup")
        #if not self.singleE24SingleMediumIsoTau30TightIDGroup_branch and "singleE24SingleMediumIsoTau30TightIDGroup" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30TightIDGroup_branch and "singleE24SingleMediumIsoTau30TightIDGroup":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30TightIDGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30TightIDGroup")
        else:
            self.singleE24SingleMediumIsoTau30TightIDGroup_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30TightIDGroup_value)

        #print "making singleE24SingleMediumIsoTau30TightIDPass"
        self.singleE24SingleMediumIsoTau30TightIDPass_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30TightIDPass")
        #if not self.singleE24SingleMediumIsoTau30TightIDPass_branch and "singleE24SingleMediumIsoTau30TightIDPass" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30TightIDPass_branch and "singleE24SingleMediumIsoTau30TightIDPass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30TightIDPass")
        else:
            self.singleE24SingleMediumIsoTau30TightIDPass_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30TightIDPass_value)

        #print "making singleE24SingleMediumIsoTau30TightIDPrescale"
        self.singleE24SingleMediumIsoTau30TightIDPrescale_branch = the_tree.GetBranch("singleE24SingleMediumIsoTau30TightIDPrescale")
        #if not self.singleE24SingleMediumIsoTau30TightIDPrescale_branch and "singleE24SingleMediumIsoTau30TightIDPrescale" not in self.complained:
        if not self.singleE24SingleMediumIsoTau30TightIDPrescale_branch and "singleE24SingleMediumIsoTau30TightIDPrescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleMediumIsoTau30TightIDPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleMediumIsoTau30TightIDPrescale")
        else:
            self.singleE24SingleMediumIsoTau30TightIDPrescale_branch.SetAddress(<void*>&self.singleE24SingleMediumIsoTau30TightIDPrescale_value)

        #print "making singleE24SingleTightIsoTau30Group"
        self.singleE24SingleTightIsoTau30Group_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30Group")
        #if not self.singleE24SingleTightIsoTau30Group_branch and "singleE24SingleTightIsoTau30Group" not in self.complained:
        if not self.singleE24SingleTightIsoTau30Group_branch and "singleE24SingleTightIsoTau30Group":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30Group")
        else:
            self.singleE24SingleTightIsoTau30Group_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30Group_value)

        #print "making singleE24SingleTightIsoTau30Pass"
        self.singleE24SingleTightIsoTau30Pass_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30Pass")
        #if not self.singleE24SingleTightIsoTau30Pass_branch and "singleE24SingleTightIsoTau30Pass" not in self.complained:
        if not self.singleE24SingleTightIsoTau30Pass_branch and "singleE24SingleTightIsoTau30Pass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30Pass")
        else:
            self.singleE24SingleTightIsoTau30Pass_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30Pass_value)

        #print "making singleE24SingleTightIsoTau30Prescale"
        self.singleE24SingleTightIsoTau30Prescale_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30Prescale")
        #if not self.singleE24SingleTightIsoTau30Prescale_branch and "singleE24SingleTightIsoTau30Prescale" not in self.complained:
        if not self.singleE24SingleTightIsoTau30Prescale_branch and "singleE24SingleTightIsoTau30Prescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30Prescale")
        else:
            self.singleE24SingleTightIsoTau30Prescale_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30Prescale_value)

        #print "making singleE24SingleTightIsoTau30TightIDGroup"
        self.singleE24SingleTightIsoTau30TightIDGroup_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30TightIDGroup")
        #if not self.singleE24SingleTightIsoTau30TightIDGroup_branch and "singleE24SingleTightIsoTau30TightIDGroup" not in self.complained:
        if not self.singleE24SingleTightIsoTau30TightIDGroup_branch and "singleE24SingleTightIsoTau30TightIDGroup":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30TightIDGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30TightIDGroup")
        else:
            self.singleE24SingleTightIsoTau30TightIDGroup_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30TightIDGroup_value)

        #print "making singleE24SingleTightIsoTau30TightIDPass"
        self.singleE24SingleTightIsoTau30TightIDPass_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30TightIDPass")
        #if not self.singleE24SingleTightIsoTau30TightIDPass_branch and "singleE24SingleTightIsoTau30TightIDPass" not in self.complained:
        if not self.singleE24SingleTightIsoTau30TightIDPass_branch and "singleE24SingleTightIsoTau30TightIDPass":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30TightIDPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30TightIDPass")
        else:
            self.singleE24SingleTightIsoTau30TightIDPass_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30TightIDPass_value)

        #print "making singleE24SingleTightIsoTau30TightIDPrescale"
        self.singleE24SingleTightIsoTau30TightIDPrescale_branch = the_tree.GetBranch("singleE24SingleTightIsoTau30TightIDPrescale")
        #if not self.singleE24SingleTightIsoTau30TightIDPrescale_branch and "singleE24SingleTightIsoTau30TightIDPrescale" not in self.complained:
        if not self.singleE24SingleTightIsoTau30TightIDPrescale_branch and "singleE24SingleTightIsoTau30TightIDPrescale":
            warnings.warn( "MuMuTree: Expected branch singleE24SingleTightIsoTau30TightIDPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE24SingleTightIsoTau30TightIDPrescale")
        else:
            self.singleE24SingleTightIsoTau30TightIDPrescale_branch.SetAddress(<void*>&self.singleE24SingleTightIsoTau30TightIDPrescale_value)

        #print "making singleE27TightGroup"
        self.singleE27TightGroup_branch = the_tree.GetBranch("singleE27TightGroup")
        #if not self.singleE27TightGroup_branch and "singleE27TightGroup" not in self.complained:
        if not self.singleE27TightGroup_branch and "singleE27TightGroup":
            warnings.warn( "MuMuTree: Expected branch singleE27TightGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightGroup")
        else:
            self.singleE27TightGroup_branch.SetAddress(<void*>&self.singleE27TightGroup_value)

        #print "making singleE27TightPass"
        self.singleE27TightPass_branch = the_tree.GetBranch("singleE27TightPass")
        #if not self.singleE27TightPass_branch and "singleE27TightPass" not in self.complained:
        if not self.singleE27TightPass_branch and "singleE27TightPass":
            warnings.warn( "MuMuTree: Expected branch singleE27TightPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPass")
        else:
            self.singleE27TightPass_branch.SetAddress(<void*>&self.singleE27TightPass_value)

        #print "making singleE27TightPrescale"
        self.singleE27TightPrescale_branch = the_tree.GetBranch("singleE27TightPrescale")
        #if not self.singleE27TightPrescale_branch and "singleE27TightPrescale" not in self.complained:
        if not self.singleE27TightPrescale_branch and "singleE27TightPrescale":
            warnings.warn( "MuMuTree: Expected branch singleE27TightPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleE27TightPrescale")
        else:
            self.singleE27TightPrescale_branch.SetAddress(<void*>&self.singleE27TightPrescale_value)

        #print "making singleIsoMu20Group"
        self.singleIsoMu20Group_branch = the_tree.GetBranch("singleIsoMu20Group")
        #if not self.singleIsoMu20Group_branch and "singleIsoMu20Group" not in self.complained:
        if not self.singleIsoMu20Group_branch and "singleIsoMu20Group":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Group")
        else:
            self.singleIsoMu20Group_branch.SetAddress(<void*>&self.singleIsoMu20Group_value)

        #print "making singleIsoMu20Pass"
        self.singleIsoMu20Pass_branch = the_tree.GetBranch("singleIsoMu20Pass")
        #if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass" not in self.complained:
        if not self.singleIsoMu20Pass_branch and "singleIsoMu20Pass":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Pass")
        else:
            self.singleIsoMu20Pass_branch.SetAddress(<void*>&self.singleIsoMu20Pass_value)

        #print "making singleIsoMu20Prescale"
        self.singleIsoMu20Prescale_branch = the_tree.GetBranch("singleIsoMu20Prescale")
        #if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale" not in self.complained:
        if not self.singleIsoMu20Prescale_branch and "singleIsoMu20Prescale":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu20Prescale")
        else:
            self.singleIsoMu20Prescale_branch.SetAddress(<void*>&self.singleIsoMu20Prescale_value)

        #print "making singleIsoMu24Group"
        self.singleIsoMu24Group_branch = the_tree.GetBranch("singleIsoMu24Group")
        #if not self.singleIsoMu24Group_branch and "singleIsoMu24Group" not in self.complained:
        if not self.singleIsoMu24Group_branch and "singleIsoMu24Group":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Group")
        else:
            self.singleIsoMu24Group_branch.SetAddress(<void*>&self.singleIsoMu24Group_value)

        #print "making singleIsoMu24Pass"
        self.singleIsoMu24Pass_branch = the_tree.GetBranch("singleIsoMu24Pass")
        #if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass" not in self.complained:
        if not self.singleIsoMu24Pass_branch and "singleIsoMu24Pass":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Pass")
        else:
            self.singleIsoMu24Pass_branch.SetAddress(<void*>&self.singleIsoMu24Pass_value)

        #print "making singleIsoMu24Prescale"
        self.singleIsoMu24Prescale_branch = the_tree.GetBranch("singleIsoMu24Prescale")
        #if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale" not in self.complained:
        if not self.singleIsoMu24Prescale_branch and "singleIsoMu24Prescale":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24Prescale")
        else:
            self.singleIsoMu24Prescale_branch.SetAddress(<void*>&self.singleIsoMu24Prescale_value)

        #print "making singleIsoMu24eta2p1Group"
        self.singleIsoMu24eta2p1Group_branch = the_tree.GetBranch("singleIsoMu24eta2p1Group")
        #if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group" not in self.complained:
        if not self.singleIsoMu24eta2p1Group_branch and "singleIsoMu24eta2p1Group":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Group")
        else:
            self.singleIsoMu24eta2p1Group_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Group_value)

        #print "making singleIsoMu24eta2p1Pass"
        self.singleIsoMu24eta2p1Pass_branch = the_tree.GetBranch("singleIsoMu24eta2p1Pass")
        #if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass" not in self.complained:
        if not self.singleIsoMu24eta2p1Pass_branch and "singleIsoMu24eta2p1Pass":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Pass")
        else:
            self.singleIsoMu24eta2p1Pass_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Pass_value)

        #print "making singleIsoMu24eta2p1Prescale"
        self.singleIsoMu24eta2p1Prescale_branch = the_tree.GetBranch("singleIsoMu24eta2p1Prescale")
        #if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale" not in self.complained:
        if not self.singleIsoMu24eta2p1Prescale_branch and "singleIsoMu24eta2p1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu24eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu24eta2p1Prescale")
        else:
            self.singleIsoMu24eta2p1Prescale_branch.SetAddress(<void*>&self.singleIsoMu24eta2p1Prescale_value)

        #print "making singleIsoMu27Group"
        self.singleIsoMu27Group_branch = the_tree.GetBranch("singleIsoMu27Group")
        #if not self.singleIsoMu27Group_branch and "singleIsoMu27Group" not in self.complained:
        if not self.singleIsoMu27Group_branch and "singleIsoMu27Group":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Group")
        else:
            self.singleIsoMu27Group_branch.SetAddress(<void*>&self.singleIsoMu27Group_value)

        #print "making singleIsoMu27Pass"
        self.singleIsoMu27Pass_branch = the_tree.GetBranch("singleIsoMu27Pass")
        #if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass" not in self.complained:
        if not self.singleIsoMu27Pass_branch and "singleIsoMu27Pass":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Pass")
        else:
            self.singleIsoMu27Pass_branch.SetAddress(<void*>&self.singleIsoMu27Pass_value)

        #print "making singleIsoMu27Prescale"
        self.singleIsoMu27Prescale_branch = the_tree.GetBranch("singleIsoMu27Prescale")
        #if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale" not in self.complained:
        if not self.singleIsoMu27Prescale_branch and "singleIsoMu27Prescale":
            warnings.warn( "MuMuTree: Expected branch singleIsoMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleIsoMu27Prescale")
        else:
            self.singleIsoMu27Prescale_branch.SetAddress(<void*>&self.singleIsoMu27Prescale_value)

        #print "making singleMu20Group"
        self.singleMu20Group_branch = the_tree.GetBranch("singleMu20Group")
        #if not self.singleMu20Group_branch and "singleMu20Group" not in self.complained:
        if not self.singleMu20Group_branch and "singleMu20Group":
            warnings.warn( "MuMuTree: Expected branch singleMu20Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20Group")
        else:
            self.singleMu20Group_branch.SetAddress(<void*>&self.singleMu20Group_value)

        #print "making singleMu20Pass"
        self.singleMu20Pass_branch = the_tree.GetBranch("singleMu20Pass")
        #if not self.singleMu20Pass_branch and "singleMu20Pass" not in self.complained:
        if not self.singleMu20Pass_branch and "singleMu20Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu20Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20Pass")
        else:
            self.singleMu20Pass_branch.SetAddress(<void*>&self.singleMu20Pass_value)

        #print "making singleMu20Prescale"
        self.singleMu20Prescale_branch = the_tree.GetBranch("singleMu20Prescale")
        #if not self.singleMu20Prescale_branch and "singleMu20Prescale" not in self.complained:
        if not self.singleMu20Prescale_branch and "singleMu20Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu20Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20Prescale")
        else:
            self.singleMu20Prescale_branch.SetAddress(<void*>&self.singleMu20Prescale_value)

        #print "making singleMu20eta2p1LooseTau27eta2p1Group"
        self.singleMu20eta2p1LooseTau27eta2p1Group_branch = the_tree.GetBranch("singleMu20eta2p1LooseTau27eta2p1Group")
        #if not self.singleMu20eta2p1LooseTau27eta2p1Group_branch and "singleMu20eta2p1LooseTau27eta2p1Group" not in self.complained:
        if not self.singleMu20eta2p1LooseTau27eta2p1Group_branch and "singleMu20eta2p1LooseTau27eta2p1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1LooseTau27eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1LooseTau27eta2p1Group")
        else:
            self.singleMu20eta2p1LooseTau27eta2p1Group_branch.SetAddress(<void*>&self.singleMu20eta2p1LooseTau27eta2p1Group_value)

        #print "making singleMu20eta2p1LooseTau27eta2p1Pass"
        self.singleMu20eta2p1LooseTau27eta2p1Pass_branch = the_tree.GetBranch("singleMu20eta2p1LooseTau27eta2p1Pass")
        #if not self.singleMu20eta2p1LooseTau27eta2p1Pass_branch and "singleMu20eta2p1LooseTau27eta2p1Pass" not in self.complained:
        if not self.singleMu20eta2p1LooseTau27eta2p1Pass_branch and "singleMu20eta2p1LooseTau27eta2p1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1LooseTau27eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1LooseTau27eta2p1Pass")
        else:
            self.singleMu20eta2p1LooseTau27eta2p1Pass_branch.SetAddress(<void*>&self.singleMu20eta2p1LooseTau27eta2p1Pass_value)

        #print "making singleMu20eta2p1LooseTau27eta2p1Prescale"
        self.singleMu20eta2p1LooseTau27eta2p1Prescale_branch = the_tree.GetBranch("singleMu20eta2p1LooseTau27eta2p1Prescale")
        #if not self.singleMu20eta2p1LooseTau27eta2p1Prescale_branch and "singleMu20eta2p1LooseTau27eta2p1Prescale" not in self.complained:
        if not self.singleMu20eta2p1LooseTau27eta2p1Prescale_branch and "singleMu20eta2p1LooseTau27eta2p1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1LooseTau27eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1LooseTau27eta2p1Prescale")
        else:
            self.singleMu20eta2p1LooseTau27eta2p1Prescale_branch.SetAddress(<void*>&self.singleMu20eta2p1LooseTau27eta2p1Prescale_value)

        #print "making singleMu20eta2p1MediumTau27eta2p1Group"
        self.singleMu20eta2p1MediumTau27eta2p1Group_branch = the_tree.GetBranch("singleMu20eta2p1MediumTau27eta2p1Group")
        #if not self.singleMu20eta2p1MediumTau27eta2p1Group_branch and "singleMu20eta2p1MediumTau27eta2p1Group" not in self.complained:
        if not self.singleMu20eta2p1MediumTau27eta2p1Group_branch and "singleMu20eta2p1MediumTau27eta2p1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1MediumTau27eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1MediumTau27eta2p1Group")
        else:
            self.singleMu20eta2p1MediumTau27eta2p1Group_branch.SetAddress(<void*>&self.singleMu20eta2p1MediumTau27eta2p1Group_value)

        #print "making singleMu20eta2p1MediumTau27eta2p1Pass"
        self.singleMu20eta2p1MediumTau27eta2p1Pass_branch = the_tree.GetBranch("singleMu20eta2p1MediumTau27eta2p1Pass")
        #if not self.singleMu20eta2p1MediumTau27eta2p1Pass_branch and "singleMu20eta2p1MediumTau27eta2p1Pass" not in self.complained:
        if not self.singleMu20eta2p1MediumTau27eta2p1Pass_branch and "singleMu20eta2p1MediumTau27eta2p1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1MediumTau27eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1MediumTau27eta2p1Pass")
        else:
            self.singleMu20eta2p1MediumTau27eta2p1Pass_branch.SetAddress(<void*>&self.singleMu20eta2p1MediumTau27eta2p1Pass_value)

        #print "making singleMu20eta2p1MediumTau27eta2p1Prescale"
        self.singleMu20eta2p1MediumTau27eta2p1Prescale_branch = the_tree.GetBranch("singleMu20eta2p1MediumTau27eta2p1Prescale")
        #if not self.singleMu20eta2p1MediumTau27eta2p1Prescale_branch and "singleMu20eta2p1MediumTau27eta2p1Prescale" not in self.complained:
        if not self.singleMu20eta2p1MediumTau27eta2p1Prescale_branch and "singleMu20eta2p1MediumTau27eta2p1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1MediumTau27eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1MediumTau27eta2p1Prescale")
        else:
            self.singleMu20eta2p1MediumTau27eta2p1Prescale_branch.SetAddress(<void*>&self.singleMu20eta2p1MediumTau27eta2p1Prescale_value)

        #print "making singleMu20eta2p1TightTau27eta2p1Group"
        self.singleMu20eta2p1TightTau27eta2p1Group_branch = the_tree.GetBranch("singleMu20eta2p1TightTau27eta2p1Group")
        #if not self.singleMu20eta2p1TightTau27eta2p1Group_branch and "singleMu20eta2p1TightTau27eta2p1Group" not in self.complained:
        if not self.singleMu20eta2p1TightTau27eta2p1Group_branch and "singleMu20eta2p1TightTau27eta2p1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1TightTau27eta2p1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1TightTau27eta2p1Group")
        else:
            self.singleMu20eta2p1TightTau27eta2p1Group_branch.SetAddress(<void*>&self.singleMu20eta2p1TightTau27eta2p1Group_value)

        #print "making singleMu20eta2p1TightTau27eta2p1Pass"
        self.singleMu20eta2p1TightTau27eta2p1Pass_branch = the_tree.GetBranch("singleMu20eta2p1TightTau27eta2p1Pass")
        #if not self.singleMu20eta2p1TightTau27eta2p1Pass_branch and "singleMu20eta2p1TightTau27eta2p1Pass" not in self.complained:
        if not self.singleMu20eta2p1TightTau27eta2p1Pass_branch and "singleMu20eta2p1TightTau27eta2p1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1TightTau27eta2p1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1TightTau27eta2p1Pass")
        else:
            self.singleMu20eta2p1TightTau27eta2p1Pass_branch.SetAddress(<void*>&self.singleMu20eta2p1TightTau27eta2p1Pass_value)

        #print "making singleMu20eta2p1TightTau27eta2p1Prescale"
        self.singleMu20eta2p1TightTau27eta2p1Prescale_branch = the_tree.GetBranch("singleMu20eta2p1TightTau27eta2p1Prescale")
        #if not self.singleMu20eta2p1TightTau27eta2p1Prescale_branch and "singleMu20eta2p1TightTau27eta2p1Prescale" not in self.complained:
        if not self.singleMu20eta2p1TightTau27eta2p1Prescale_branch and "singleMu20eta2p1TightTau27eta2p1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu20eta2p1TightTau27eta2p1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu20eta2p1TightTau27eta2p1Prescale")
        else:
            self.singleMu20eta2p1TightTau27eta2p1Prescale_branch.SetAddress(<void*>&self.singleMu20eta2p1TightTau27eta2p1Prescale_value)

        #print "making singleMu23SingleE12DZGroup"
        self.singleMu23SingleE12DZGroup_branch = the_tree.GetBranch("singleMu23SingleE12DZGroup")
        #if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup" not in self.complained:
        if not self.singleMu23SingleE12DZGroup_branch and "singleMu23SingleE12DZGroup":
            warnings.warn( "MuMuTree: Expected branch singleMu23SingleE12DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZGroup")
        else:
            self.singleMu23SingleE12DZGroup_branch.SetAddress(<void*>&self.singleMu23SingleE12DZGroup_value)

        #print "making singleMu23SingleE12DZPass"
        self.singleMu23SingleE12DZPass_branch = the_tree.GetBranch("singleMu23SingleE12DZPass")
        #if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass" not in self.complained:
        if not self.singleMu23SingleE12DZPass_branch and "singleMu23SingleE12DZPass":
            warnings.warn( "MuMuTree: Expected branch singleMu23SingleE12DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPass")
        else:
            self.singleMu23SingleE12DZPass_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPass_value)

        #print "making singleMu23SingleE12DZPrescale"
        self.singleMu23SingleE12DZPrescale_branch = the_tree.GetBranch("singleMu23SingleE12DZPrescale")
        #if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale" not in self.complained:
        if not self.singleMu23SingleE12DZPrescale_branch and "singleMu23SingleE12DZPrescale":
            warnings.warn( "MuMuTree: Expected branch singleMu23SingleE12DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu23SingleE12DZPrescale")
        else:
            self.singleMu23SingleE12DZPrescale_branch.SetAddress(<void*>&self.singleMu23SingleE12DZPrescale_value)

        #print "making singleMu24eta2p1LooseTau20TightIDsingleL1Group"
        self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20TightIDsingleL1Group")
        #if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Group" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20TightIDsingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20TightIDsingleL1Group")
        else:
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_value)

        #print "making singleMu24eta2p1LooseTau20TightIDsingleL1Pass"
        self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20TightIDsingleL1Pass")
        #if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20TightIDsingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20TightIDsingleL1Pass")
        else:
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_value)

        #print "making singleMu24eta2p1LooseTau20TightIDsingleL1Prescale"
        self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20TightIDsingleL1Prescale")
        #if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1LooseTau20TightIDsingleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20TightIDsingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20TightIDsingleL1Prescale")
        else:
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_value)

        #print "making singleMu24eta2p1LooseTau20singleL1Group"
        self.singleMu24eta2p1LooseTau20singleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20singleL1Group")
        #if not self.singleMu24eta2p1LooseTau20singleL1Group_branch and "singleMu24eta2p1LooseTau20singleL1Group" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20singleL1Group_branch and "singleMu24eta2p1LooseTau20singleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20singleL1Group")
        else:
            self.singleMu24eta2p1LooseTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20singleL1Group_value)

        #print "making singleMu24eta2p1LooseTau20singleL1Pass"
        self.singleMu24eta2p1LooseTau20singleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20singleL1Pass")
        #if not self.singleMu24eta2p1LooseTau20singleL1Pass_branch and "singleMu24eta2p1LooseTau20singleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20singleL1Pass_branch and "singleMu24eta2p1LooseTau20singleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20singleL1Pass")
        else:
            self.singleMu24eta2p1LooseTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20singleL1Pass_value)

        #print "making singleMu24eta2p1LooseTau20singleL1Prescale"
        self.singleMu24eta2p1LooseTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1LooseTau20singleL1Prescale")
        #if not self.singleMu24eta2p1LooseTau20singleL1Prescale_branch and "singleMu24eta2p1LooseTau20singleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1LooseTau20singleL1Prescale_branch and "singleMu24eta2p1LooseTau20singleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1LooseTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1LooseTau20singleL1Prescale")
        else:
            self.singleMu24eta2p1LooseTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1LooseTau20singleL1Prescale_value)

        #print "making singleMu24eta2p1MediumTau20TightIDsingleL1Group"
        self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20TightIDsingleL1Group")
        #if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Group" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20TightIDsingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20TightIDsingleL1Group")
        else:
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_value)

        #print "making singleMu24eta2p1MediumTau20TightIDsingleL1Pass"
        self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20TightIDsingleL1Pass")
        #if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20TightIDsingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20TightIDsingleL1Pass")
        else:
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_value)

        #print "making singleMu24eta2p1MediumTau20TightIDsingleL1Prescale"
        self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20TightIDsingleL1Prescale")
        #if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1MediumTau20TightIDsingleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20TightIDsingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20TightIDsingleL1Prescale")
        else:
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_value)

        #print "making singleMu24eta2p1MediumTau20singleL1Group"
        self.singleMu24eta2p1MediumTau20singleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20singleL1Group")
        #if not self.singleMu24eta2p1MediumTau20singleL1Group_branch and "singleMu24eta2p1MediumTau20singleL1Group" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20singleL1Group_branch and "singleMu24eta2p1MediumTau20singleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20singleL1Group")
        else:
            self.singleMu24eta2p1MediumTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20singleL1Group_value)

        #print "making singleMu24eta2p1MediumTau20singleL1Pass"
        self.singleMu24eta2p1MediumTau20singleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20singleL1Pass")
        #if not self.singleMu24eta2p1MediumTau20singleL1Pass_branch and "singleMu24eta2p1MediumTau20singleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20singleL1Pass_branch and "singleMu24eta2p1MediumTau20singleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20singleL1Pass")
        else:
            self.singleMu24eta2p1MediumTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20singleL1Pass_value)

        #print "making singleMu24eta2p1MediumTau20singleL1Prescale"
        self.singleMu24eta2p1MediumTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1MediumTau20singleL1Prescale")
        #if not self.singleMu24eta2p1MediumTau20singleL1Prescale_branch and "singleMu24eta2p1MediumTau20singleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1MediumTau20singleL1Prescale_branch and "singleMu24eta2p1MediumTau20singleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1MediumTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1MediumTau20singleL1Prescale")
        else:
            self.singleMu24eta2p1MediumTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1MediumTau20singleL1Prescale_value)

        #print "making singleMu24eta2p1TightTau20TightIDsingleL1Group"
        self.singleMu24eta2p1TightTau20TightIDsingleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20TightIDsingleL1Group")
        #if not self.singleMu24eta2p1TightTau20TightIDsingleL1Group_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Group" not in self.complained:
        if not self.singleMu24eta2p1TightTau20TightIDsingleL1Group_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20TightIDsingleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20TightIDsingleL1Group")
        else:
            self.singleMu24eta2p1TightTau20TightIDsingleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20TightIDsingleL1Group_value)

        #print "making singleMu24eta2p1TightTau20TightIDsingleL1Pass"
        self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20TightIDsingleL1Pass")
        #if not self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20TightIDsingleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20TightIDsingleL1Pass")
        else:
            self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_value)

        #print "making singleMu24eta2p1TightTau20TightIDsingleL1Prescale"
        self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20TightIDsingleL1Prescale")
        #if not self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch and "singleMu24eta2p1TightTau20TightIDsingleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20TightIDsingleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20TightIDsingleL1Prescale")
        else:
            self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_value)

        #print "making singleMu24eta2p1TightTau20singleL1Group"
        self.singleMu24eta2p1TightTau20singleL1Group_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20singleL1Group")
        #if not self.singleMu24eta2p1TightTau20singleL1Group_branch and "singleMu24eta2p1TightTau20singleL1Group" not in self.complained:
        if not self.singleMu24eta2p1TightTau20singleL1Group_branch and "singleMu24eta2p1TightTau20singleL1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20singleL1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20singleL1Group")
        else:
            self.singleMu24eta2p1TightTau20singleL1Group_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20singleL1Group_value)

        #print "making singleMu24eta2p1TightTau20singleL1Pass"
        self.singleMu24eta2p1TightTau20singleL1Pass_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20singleL1Pass")
        #if not self.singleMu24eta2p1TightTau20singleL1Pass_branch and "singleMu24eta2p1TightTau20singleL1Pass" not in self.complained:
        if not self.singleMu24eta2p1TightTau20singleL1Pass_branch and "singleMu24eta2p1TightTau20singleL1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20singleL1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20singleL1Pass")
        else:
            self.singleMu24eta2p1TightTau20singleL1Pass_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20singleL1Pass_value)

        #print "making singleMu24eta2p1TightTau20singleL1Prescale"
        self.singleMu24eta2p1TightTau20singleL1Prescale_branch = the_tree.GetBranch("singleMu24eta2p1TightTau20singleL1Prescale")
        #if not self.singleMu24eta2p1TightTau20singleL1Prescale_branch and "singleMu24eta2p1TightTau20singleL1Prescale" not in self.complained:
        if not self.singleMu24eta2p1TightTau20singleL1Prescale_branch and "singleMu24eta2p1TightTau20singleL1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu24eta2p1TightTau20singleL1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu24eta2p1TightTau20singleL1Prescale")
        else:
            self.singleMu24eta2p1TightTau20singleL1Prescale_branch.SetAddress(<void*>&self.singleMu24eta2p1TightTau20singleL1Prescale_value)

        #print "making singleMu27Group"
        self.singleMu27Group_branch = the_tree.GetBranch("singleMu27Group")
        #if not self.singleMu27Group_branch and "singleMu27Group" not in self.complained:
        if not self.singleMu27Group_branch and "singleMu27Group":
            warnings.warn( "MuMuTree: Expected branch singleMu27Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu27Group")
        else:
            self.singleMu27Group_branch.SetAddress(<void*>&self.singleMu27Group_value)

        #print "making singleMu27Pass"
        self.singleMu27Pass_branch = the_tree.GetBranch("singleMu27Pass")
        #if not self.singleMu27Pass_branch and "singleMu27Pass" not in self.complained:
        if not self.singleMu27Pass_branch and "singleMu27Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu27Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu27Pass")
        else:
            self.singleMu27Pass_branch.SetAddress(<void*>&self.singleMu27Pass_value)

        #print "making singleMu27Prescale"
        self.singleMu27Prescale_branch = the_tree.GetBranch("singleMu27Prescale")
        #if not self.singleMu27Prescale_branch and "singleMu27Prescale" not in self.complained:
        if not self.singleMu27Prescale_branch and "singleMu27Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu27Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu27Prescale")
        else:
            self.singleMu27Prescale_branch.SetAddress(<void*>&self.singleMu27Prescale_value)

        #print "making singleMu50Group"
        self.singleMu50Group_branch = the_tree.GetBranch("singleMu50Group")
        #if not self.singleMu50Group_branch and "singleMu50Group" not in self.complained:
        if not self.singleMu50Group_branch and "singleMu50Group":
            warnings.warn( "MuMuTree: Expected branch singleMu50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu50Group")
        else:
            self.singleMu50Group_branch.SetAddress(<void*>&self.singleMu50Group_value)

        #print "making singleMu50Pass"
        self.singleMu50Pass_branch = the_tree.GetBranch("singleMu50Pass")
        #if not self.singleMu50Pass_branch and "singleMu50Pass" not in self.complained:
        if not self.singleMu50Pass_branch and "singleMu50Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu50Pass")
        else:
            self.singleMu50Pass_branch.SetAddress(<void*>&self.singleMu50Pass_value)

        #print "making singleMu50Prescale"
        self.singleMu50Prescale_branch = the_tree.GetBranch("singleMu50Prescale")
        #if not self.singleMu50Prescale_branch and "singleMu50Prescale" not in self.complained:
        if not self.singleMu50Prescale_branch and "singleMu50Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu50Prescale")
        else:
            self.singleMu50Prescale_branch.SetAddress(<void*>&self.singleMu50Prescale_value)

        #print "making singleMu8SingleE23DZGroup"
        self.singleMu8SingleE23DZGroup_branch = the_tree.GetBranch("singleMu8SingleE23DZGroup")
        #if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup" not in self.complained:
        if not self.singleMu8SingleE23DZGroup_branch and "singleMu8SingleE23DZGroup":
            warnings.warn( "MuMuTree: Expected branch singleMu8SingleE23DZGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZGroup")
        else:
            self.singleMu8SingleE23DZGroup_branch.SetAddress(<void*>&self.singleMu8SingleE23DZGroup_value)

        #print "making singleMu8SingleE23DZPass"
        self.singleMu8SingleE23DZPass_branch = the_tree.GetBranch("singleMu8SingleE23DZPass")
        #if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass" not in self.complained:
        if not self.singleMu8SingleE23DZPass_branch and "singleMu8SingleE23DZPass":
            warnings.warn( "MuMuTree: Expected branch singleMu8SingleE23DZPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPass")
        else:
            self.singleMu8SingleE23DZPass_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPass_value)

        #print "making singleMu8SingleE23DZPrescale"
        self.singleMu8SingleE23DZPrescale_branch = the_tree.GetBranch("singleMu8SingleE23DZPrescale")
        #if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale" not in self.complained:
        if not self.singleMu8SingleE23DZPrescale_branch and "singleMu8SingleE23DZPrescale":
            warnings.warn( "MuMuTree: Expected branch singleMu8SingleE23DZPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu8SingleE23DZPrescale")
        else:
            self.singleMu8SingleE23DZPrescale_branch.SetAddress(<void*>&self.singleMu8SingleE23DZPrescale_value)

        #print "making singleMu_leg1Group"
        self.singleMu_leg1Group_branch = the_tree.GetBranch("singleMu_leg1Group")
        #if not self.singleMu_leg1Group_branch and "singleMu_leg1Group" not in self.complained:
        if not self.singleMu_leg1Group_branch and "singleMu_leg1Group":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Group")
        else:
            self.singleMu_leg1Group_branch.SetAddress(<void*>&self.singleMu_leg1Group_value)

        #print "making singleMu_leg1Pass"
        self.singleMu_leg1Pass_branch = the_tree.GetBranch("singleMu_leg1Pass")
        #if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass" not in self.complained:
        if not self.singleMu_leg1Pass_branch and "singleMu_leg1Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Pass")
        else:
            self.singleMu_leg1Pass_branch.SetAddress(<void*>&self.singleMu_leg1Pass_value)

        #print "making singleMu_leg1Prescale"
        self.singleMu_leg1Prescale_branch = the_tree.GetBranch("singleMu_leg1Prescale")
        #if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale" not in self.complained:
        if not self.singleMu_leg1Prescale_branch and "singleMu_leg1Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1Prescale")
        else:
            self.singleMu_leg1Prescale_branch.SetAddress(<void*>&self.singleMu_leg1Prescale_value)

        #print "making singleMu_leg1_noisoGroup"
        self.singleMu_leg1_noisoGroup_branch = the_tree.GetBranch("singleMu_leg1_noisoGroup")
        #if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup" not in self.complained:
        if not self.singleMu_leg1_noisoGroup_branch and "singleMu_leg1_noisoGroup":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoGroup")
        else:
            self.singleMu_leg1_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg1_noisoGroup_value)

        #print "making singleMu_leg1_noisoPass"
        self.singleMu_leg1_noisoPass_branch = the_tree.GetBranch("singleMu_leg1_noisoPass")
        #if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass" not in self.complained:
        if not self.singleMu_leg1_noisoPass_branch and "singleMu_leg1_noisoPass":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPass")
        else:
            self.singleMu_leg1_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPass_value)

        #print "making singleMu_leg1_noisoPrescale"
        self.singleMu_leg1_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg1_noisoPrescale")
        #if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale" not in self.complained:
        if not self.singleMu_leg1_noisoPrescale_branch and "singleMu_leg1_noisoPrescale":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg1_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg1_noisoPrescale")
        else:
            self.singleMu_leg1_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg1_noisoPrescale_value)

        #print "making singleMu_leg2Group"
        self.singleMu_leg2Group_branch = the_tree.GetBranch("singleMu_leg2Group")
        #if not self.singleMu_leg2Group_branch and "singleMu_leg2Group" not in self.complained:
        if not self.singleMu_leg2Group_branch and "singleMu_leg2Group":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Group")
        else:
            self.singleMu_leg2Group_branch.SetAddress(<void*>&self.singleMu_leg2Group_value)

        #print "making singleMu_leg2Pass"
        self.singleMu_leg2Pass_branch = the_tree.GetBranch("singleMu_leg2Pass")
        #if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass" not in self.complained:
        if not self.singleMu_leg2Pass_branch and "singleMu_leg2Pass":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Pass")
        else:
            self.singleMu_leg2Pass_branch.SetAddress(<void*>&self.singleMu_leg2Pass_value)

        #print "making singleMu_leg2Prescale"
        self.singleMu_leg2Prescale_branch = the_tree.GetBranch("singleMu_leg2Prescale")
        #if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale" not in self.complained:
        if not self.singleMu_leg2Prescale_branch and "singleMu_leg2Prescale":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2Prescale")
        else:
            self.singleMu_leg2Prescale_branch.SetAddress(<void*>&self.singleMu_leg2Prescale_value)

        #print "making singleMu_leg2_noisoGroup"
        self.singleMu_leg2_noisoGroup_branch = the_tree.GetBranch("singleMu_leg2_noisoGroup")
        #if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup" not in self.complained:
        if not self.singleMu_leg2_noisoGroup_branch and "singleMu_leg2_noisoGroup":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2_noisoGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoGroup")
        else:
            self.singleMu_leg2_noisoGroup_branch.SetAddress(<void*>&self.singleMu_leg2_noisoGroup_value)

        #print "making singleMu_leg2_noisoPass"
        self.singleMu_leg2_noisoPass_branch = the_tree.GetBranch("singleMu_leg2_noisoPass")
        #if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass" not in self.complained:
        if not self.singleMu_leg2_noisoPass_branch and "singleMu_leg2_noisoPass":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2_noisoPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPass")
        else:
            self.singleMu_leg2_noisoPass_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPass_value)

        #print "making singleMu_leg2_noisoPrescale"
        self.singleMu_leg2_noisoPrescale_branch = the_tree.GetBranch("singleMu_leg2_noisoPrescale")
        #if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale" not in self.complained:
        if not self.singleMu_leg2_noisoPrescale_branch and "singleMu_leg2_noisoPrescale":
            warnings.warn( "MuMuTree: Expected branch singleMu_leg2_noisoPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleMu_leg2_noisoPrescale")
        else:
            self.singleMu_leg2_noisoPrescale_branch.SetAddress(<void*>&self.singleMu_leg2_noisoPrescale_value)

        #print "making singleTau140Group"
        self.singleTau140Group_branch = the_tree.GetBranch("singleTau140Group")
        #if not self.singleTau140Group_branch and "singleTau140Group" not in self.complained:
        if not self.singleTau140Group_branch and "singleTau140Group":
            warnings.warn( "MuMuTree: Expected branch singleTau140Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Group")
        else:
            self.singleTau140Group_branch.SetAddress(<void*>&self.singleTau140Group_value)

        #print "making singleTau140Pass"
        self.singleTau140Pass_branch = the_tree.GetBranch("singleTau140Pass")
        #if not self.singleTau140Pass_branch and "singleTau140Pass" not in self.complained:
        if not self.singleTau140Pass_branch and "singleTau140Pass":
            warnings.warn( "MuMuTree: Expected branch singleTau140Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Pass")
        else:
            self.singleTau140Pass_branch.SetAddress(<void*>&self.singleTau140Pass_value)

        #print "making singleTau140Prescale"
        self.singleTau140Prescale_branch = the_tree.GetBranch("singleTau140Prescale")
        #if not self.singleTau140Prescale_branch and "singleTau140Prescale" not in self.complained:
        if not self.singleTau140Prescale_branch and "singleTau140Prescale":
            warnings.warn( "MuMuTree: Expected branch singleTau140Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Prescale")
        else:
            self.singleTau140Prescale_branch.SetAddress(<void*>&self.singleTau140Prescale_value)

        #print "making singleTau140Trk50Group"
        self.singleTau140Trk50Group_branch = the_tree.GetBranch("singleTau140Trk50Group")
        #if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group" not in self.complained:
        if not self.singleTau140Trk50Group_branch and "singleTau140Trk50Group":
            warnings.warn( "MuMuTree: Expected branch singleTau140Trk50Group does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Group")
        else:
            self.singleTau140Trk50Group_branch.SetAddress(<void*>&self.singleTau140Trk50Group_value)

        #print "making singleTau140Trk50Pass"
        self.singleTau140Trk50Pass_branch = the_tree.GetBranch("singleTau140Trk50Pass")
        #if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass" not in self.complained:
        if not self.singleTau140Trk50Pass_branch and "singleTau140Trk50Pass":
            warnings.warn( "MuMuTree: Expected branch singleTau140Trk50Pass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Pass")
        else:
            self.singleTau140Trk50Pass_branch.SetAddress(<void*>&self.singleTau140Trk50Pass_value)

        #print "making singleTau140Trk50Prescale"
        self.singleTau140Trk50Prescale_branch = the_tree.GetBranch("singleTau140Trk50Prescale")
        #if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale" not in self.complained:
        if not self.singleTau140Trk50Prescale_branch and "singleTau140Trk50Prescale":
            warnings.warn( "MuMuTree: Expected branch singleTau140Trk50Prescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("singleTau140Trk50Prescale")
        else:
            self.singleTau140Trk50Prescale_branch.SetAddress(<void*>&self.singleTau140Trk50Prescale_value)

        #print "making tauVetoPt20Loose3HitsVtx"
        self.tauVetoPt20Loose3HitsVtx_branch = the_tree.GetBranch("tauVetoPt20Loose3HitsVtx")
        #if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx" not in self.complained:
        if not self.tauVetoPt20Loose3HitsVtx_branch and "tauVetoPt20Loose3HitsVtx":
            warnings.warn( "MuMuTree: Expected branch tauVetoPt20Loose3HitsVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20Loose3HitsVtx")
        else:
            self.tauVetoPt20Loose3HitsVtx_branch.SetAddress(<void*>&self.tauVetoPt20Loose3HitsVtx_value)

        #print "making tauVetoPt20TightMVALTVtx"
        self.tauVetoPt20TightMVALTVtx_branch = the_tree.GetBranch("tauVetoPt20TightMVALTVtx")
        #if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx" not in self.complained:
        if not self.tauVetoPt20TightMVALTVtx_branch and "tauVetoPt20TightMVALTVtx":
            warnings.warn( "MuMuTree: Expected branch tauVetoPt20TightMVALTVtx does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tauVetoPt20TightMVALTVtx")
        else:
            self.tauVetoPt20TightMVALTVtx_branch.SetAddress(<void*>&self.tauVetoPt20TightMVALTVtx_value)

        #print "making topQuarkPt1"
        self.topQuarkPt1_branch = the_tree.GetBranch("topQuarkPt1")
        #if not self.topQuarkPt1_branch and "topQuarkPt1" not in self.complained:
        if not self.topQuarkPt1_branch and "topQuarkPt1":
            warnings.warn( "MuMuTree: Expected branch topQuarkPt1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt1")
        else:
            self.topQuarkPt1_branch.SetAddress(<void*>&self.topQuarkPt1_value)

        #print "making topQuarkPt2"
        self.topQuarkPt2_branch = the_tree.GetBranch("topQuarkPt2")
        #if not self.topQuarkPt2_branch and "topQuarkPt2" not in self.complained:
        if not self.topQuarkPt2_branch and "topQuarkPt2":
            warnings.warn( "MuMuTree: Expected branch topQuarkPt2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("topQuarkPt2")
        else:
            self.topQuarkPt2_branch.SetAddress(<void*>&self.topQuarkPt2_value)

        #print "making tripleEGroup"
        self.tripleEGroup_branch = the_tree.GetBranch("tripleEGroup")
        #if not self.tripleEGroup_branch and "tripleEGroup" not in self.complained:
        if not self.tripleEGroup_branch and "tripleEGroup":
            warnings.warn( "MuMuTree: Expected branch tripleEGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEGroup")
        else:
            self.tripleEGroup_branch.SetAddress(<void*>&self.tripleEGroup_value)

        #print "making tripleEPass"
        self.tripleEPass_branch = the_tree.GetBranch("tripleEPass")
        #if not self.tripleEPass_branch and "tripleEPass" not in self.complained:
        if not self.tripleEPass_branch and "tripleEPass":
            warnings.warn( "MuMuTree: Expected branch tripleEPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPass")
        else:
            self.tripleEPass_branch.SetAddress(<void*>&self.tripleEPass_value)

        #print "making tripleEPrescale"
        self.tripleEPrescale_branch = the_tree.GetBranch("tripleEPrescale")
        #if not self.tripleEPrescale_branch and "tripleEPrescale" not in self.complained:
        if not self.tripleEPrescale_branch and "tripleEPrescale":
            warnings.warn( "MuMuTree: Expected branch tripleEPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleEPrescale")
        else:
            self.tripleEPrescale_branch.SetAddress(<void*>&self.tripleEPrescale_value)

        #print "making tripleMuGroup"
        self.tripleMuGroup_branch = the_tree.GetBranch("tripleMuGroup")
        #if not self.tripleMuGroup_branch and "tripleMuGroup" not in self.complained:
        if not self.tripleMuGroup_branch and "tripleMuGroup":
            warnings.warn( "MuMuTree: Expected branch tripleMuGroup does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuGroup")
        else:
            self.tripleMuGroup_branch.SetAddress(<void*>&self.tripleMuGroup_value)

        #print "making tripleMuPass"
        self.tripleMuPass_branch = the_tree.GetBranch("tripleMuPass")
        #if not self.tripleMuPass_branch and "tripleMuPass" not in self.complained:
        if not self.tripleMuPass_branch and "tripleMuPass":
            warnings.warn( "MuMuTree: Expected branch tripleMuPass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPass")
        else:
            self.tripleMuPass_branch.SetAddress(<void*>&self.tripleMuPass_value)

        #print "making tripleMuPrescale"
        self.tripleMuPrescale_branch = the_tree.GetBranch("tripleMuPrescale")
        #if not self.tripleMuPrescale_branch and "tripleMuPrescale" not in self.complained:
        if not self.tripleMuPrescale_branch and "tripleMuPrescale":
            warnings.warn( "MuMuTree: Expected branch tripleMuPrescale does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("tripleMuPrescale")
        else:
            self.tripleMuPrescale_branch.SetAddress(<void*>&self.tripleMuPrescale_value)

        #print "making type1_pfMetEt"
        self.type1_pfMetEt_branch = the_tree.GetBranch("type1_pfMetEt")
        #if not self.type1_pfMetEt_branch and "type1_pfMetEt" not in self.complained:
        if not self.type1_pfMetEt_branch and "type1_pfMetEt":
            warnings.warn( "MuMuTree: Expected branch type1_pfMetEt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetEt")
        else:
            self.type1_pfMetEt_branch.SetAddress(<void*>&self.type1_pfMetEt_value)

        #print "making type1_pfMetPhi"
        self.type1_pfMetPhi_branch = the_tree.GetBranch("type1_pfMetPhi")
        #if not self.type1_pfMetPhi_branch and "type1_pfMetPhi" not in self.complained:
        if not self.type1_pfMetPhi_branch and "type1_pfMetPhi":
            warnings.warn( "MuMuTree: Expected branch type1_pfMetPhi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMetPhi")
        else:
            self.type1_pfMetPhi_branch.SetAddress(<void*>&self.type1_pfMetPhi_value)

        #print "making type1_pfMet_shiftedPhi_CHARGEDUESDown"
        self.type1_pfMet_shiftedPhi_CHARGEDUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_CHARGEDUESDown")
        #if not self.type1_pfMet_shiftedPhi_CHARGEDUESDown_branch and "type1_pfMet_shiftedPhi_CHARGEDUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_CHARGEDUESDown_branch and "type1_pfMet_shiftedPhi_CHARGEDUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_CHARGEDUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_CHARGEDUESDown")
        else:
            self.type1_pfMet_shiftedPhi_CHARGEDUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_CHARGEDUESDown_value)

        #print "making type1_pfMet_shiftedPhi_CHARGEDUESUp"
        self.type1_pfMet_shiftedPhi_CHARGEDUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_CHARGEDUESUp")
        #if not self.type1_pfMet_shiftedPhi_CHARGEDUESUp_branch and "type1_pfMet_shiftedPhi_CHARGEDUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_CHARGEDUESUp_branch and "type1_pfMet_shiftedPhi_CHARGEDUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_CHARGEDUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_CHARGEDUESUp")
        else:
            self.type1_pfMet_shiftedPhi_CHARGEDUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_CHARGEDUESUp_value)

        #print "making type1_pfMet_shiftedPhi_ECALUESDown"
        self.type1_pfMet_shiftedPhi_ECALUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ECALUESDown")
        #if not self.type1_pfMet_shiftedPhi_ECALUESDown_branch and "type1_pfMet_shiftedPhi_ECALUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ECALUESDown_branch and "type1_pfMet_shiftedPhi_ECALUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_ECALUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ECALUESDown")
        else:
            self.type1_pfMet_shiftedPhi_ECALUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ECALUESDown_value)

        #print "making type1_pfMet_shiftedPhi_ECALUESUp"
        self.type1_pfMet_shiftedPhi_ECALUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_ECALUESUp")
        #if not self.type1_pfMet_shiftedPhi_ECALUESUp_branch and "type1_pfMet_shiftedPhi_ECALUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_ECALUESUp_branch and "type1_pfMet_shiftedPhi_ECALUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_ECALUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_ECALUESUp")
        else:
            self.type1_pfMet_shiftedPhi_ECALUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_ECALUESUp_value)

        #print "making type1_pfMet_shiftedPhi_HCALUESDown"
        self.type1_pfMet_shiftedPhi_HCALUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_HCALUESDown")
        #if not self.type1_pfMet_shiftedPhi_HCALUESDown_branch and "type1_pfMet_shiftedPhi_HCALUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_HCALUESDown_branch and "type1_pfMet_shiftedPhi_HCALUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_HCALUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_HCALUESDown")
        else:
            self.type1_pfMet_shiftedPhi_HCALUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_HCALUESDown_value)

        #print "making type1_pfMet_shiftedPhi_HCALUESUp"
        self.type1_pfMet_shiftedPhi_HCALUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_HCALUESUp")
        #if not self.type1_pfMet_shiftedPhi_HCALUESUp_branch and "type1_pfMet_shiftedPhi_HCALUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_HCALUESUp_branch and "type1_pfMet_shiftedPhi_HCALUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_HCALUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_HCALUESUp")
        else:
            self.type1_pfMet_shiftedPhi_HCALUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_HCALUESUp_value)

        #print "making type1_pfMet_shiftedPhi_HFUESDown"
        self.type1_pfMet_shiftedPhi_HFUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_HFUESDown")
        #if not self.type1_pfMet_shiftedPhi_HFUESDown_branch and "type1_pfMet_shiftedPhi_HFUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_HFUESDown_branch and "type1_pfMet_shiftedPhi_HFUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_HFUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_HFUESDown")
        else:
            self.type1_pfMet_shiftedPhi_HFUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_HFUESDown_value)

        #print "making type1_pfMet_shiftedPhi_HFUESUp"
        self.type1_pfMet_shiftedPhi_HFUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_HFUESUp")
        #if not self.type1_pfMet_shiftedPhi_HFUESUp_branch and "type1_pfMet_shiftedPhi_HFUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_HFUESUp_branch and "type1_pfMet_shiftedPhi_HFUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_HFUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_HFUESUp")
        else:
            self.type1_pfMet_shiftedPhi_HFUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_HFUESUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteScaleUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPhi_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPhi_JetAbsoluteStatUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPhi_JetEnDown"
        self.type1_pfMet_shiftedPhi_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnDown")
        #if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnDown_branch and "type1_pfMet_shiftedPhi_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnDown")
        else:
            self.type1_pfMet_shiftedPhi_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnDown_value)

        #print "making type1_pfMet_shiftedPhi_JetEnUp"
        self.type1_pfMet_shiftedPhi_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetEnUp")
        #if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetEnUp_branch and "type1_pfMet_shiftedPhi_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetEnUp")
        else:
            self.type1_pfMet_shiftedPhi_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetEnUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPhi_JetFlavorQCDUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationDown"
        self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch and "type1_pfMet_shiftedPhi_JetFragmentationDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPhi_JetFragmentationUp"
        self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch and "type1_pfMet_shiftedPhi_JetFragmentationUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPhi_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPhi_JetPileUpDataMCUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtBBUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPhi_JetPileUpPtEC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPhi_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPhi_JetPileUpPtRefUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalDown"
        self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch and "type1_pfMet_shiftedPhi_JetRelativeBalDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeBalUp"
        self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch and "type1_pfMet_shiftedPhi_JetRelativeBalUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeFSRUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativeJEREC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeJERHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtBBUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPhi_JetRelativePtEC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativePtHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatECUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatFSRUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPhi_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPhi_JetRelativeStatHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPhi_JetResDown"
        self.type1_pfMet_shiftedPhi_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResDown")
        #if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResDown_branch and "type1_pfMet_shiftedPhi_JetResDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResDown")
        else:
            self.type1_pfMet_shiftedPhi_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResDown_value)

        #print "making type1_pfMet_shiftedPhi_JetResUp"
        self.type1_pfMet_shiftedPhi_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetResUp")
        #if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetResUp_branch and "type1_pfMet_shiftedPhi_JetResUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetResUp")
        else:
            self.type1_pfMet_shiftedPhi_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetResUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionECALUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPhi_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPhi_JetSinglePionHCALUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPhi_JetTimePtEtaUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalDown"
        self.type1_pfMet_shiftedPhi_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalDown")
        #if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalDown_branch and "type1_pfMet_shiftedPhi_JetTotalDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPhi_JetTotalUp"
        self.type1_pfMet_shiftedPhi_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_JetTotalUp")
        #if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_JetTotalUp_branch and "type1_pfMet_shiftedPhi_JetTotalUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPhi_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPhi_RunIUESDown"
        self.type1_pfMet_shiftedPhi_RunIUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_RunIUESDown")
        #if not self.type1_pfMet_shiftedPhi_RunIUESDown_branch and "type1_pfMet_shiftedPhi_RunIUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_RunIUESDown_branch and "type1_pfMet_shiftedPhi_RunIUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_RunIUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_RunIUESDown")
        else:
            self.type1_pfMet_shiftedPhi_RunIUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_RunIUESDown_value)

        #print "making type1_pfMet_shiftedPhi_RunIUESUp"
        self.type1_pfMet_shiftedPhi_RunIUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_RunIUESUp")
        #if not self.type1_pfMet_shiftedPhi_RunIUESUp_branch and "type1_pfMet_shiftedPhi_RunIUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_RunIUESUp_branch and "type1_pfMet_shiftedPhi_RunIUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_RunIUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_RunIUESUp")
        else:
            self.type1_pfMet_shiftedPhi_RunIUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_RunIUESUp_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnDown"
        self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch and "type1_pfMet_shiftedPhi_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPhi_UnclusteredEnUp"
        self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch and "type1_pfMet_shiftedPhi_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPhi_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPhi_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value)

        #print "making type1_pfMet_shiftedPt_CHARGEDUESDown"
        self.type1_pfMet_shiftedPt_CHARGEDUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_CHARGEDUESDown")
        #if not self.type1_pfMet_shiftedPt_CHARGEDUESDown_branch and "type1_pfMet_shiftedPt_CHARGEDUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_CHARGEDUESDown_branch and "type1_pfMet_shiftedPt_CHARGEDUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_CHARGEDUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_CHARGEDUESDown")
        else:
            self.type1_pfMet_shiftedPt_CHARGEDUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_CHARGEDUESDown_value)

        #print "making type1_pfMet_shiftedPt_CHARGEDUESUp"
        self.type1_pfMet_shiftedPt_CHARGEDUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_CHARGEDUESUp")
        #if not self.type1_pfMet_shiftedPt_CHARGEDUESUp_branch and "type1_pfMet_shiftedPt_CHARGEDUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_CHARGEDUESUp_branch and "type1_pfMet_shiftedPt_CHARGEDUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_CHARGEDUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_CHARGEDUESUp")
        else:
            self.type1_pfMet_shiftedPt_CHARGEDUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_CHARGEDUESUp_value)

        #print "making type1_pfMet_shiftedPt_ECALUESDown"
        self.type1_pfMet_shiftedPt_ECALUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ECALUESDown")
        #if not self.type1_pfMet_shiftedPt_ECALUESDown_branch and "type1_pfMet_shiftedPt_ECALUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ECALUESDown_branch and "type1_pfMet_shiftedPt_ECALUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_ECALUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ECALUESDown")
        else:
            self.type1_pfMet_shiftedPt_ECALUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ECALUESDown_value)

        #print "making type1_pfMet_shiftedPt_ECALUESUp"
        self.type1_pfMet_shiftedPt_ECALUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_ECALUESUp")
        #if not self.type1_pfMet_shiftedPt_ECALUESUp_branch and "type1_pfMet_shiftedPt_ECALUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_ECALUESUp_branch and "type1_pfMet_shiftedPt_ECALUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_ECALUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_ECALUESUp")
        else:
            self.type1_pfMet_shiftedPt_ECALUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_ECALUESUp_value)

        #print "making type1_pfMet_shiftedPt_HCALUESDown"
        self.type1_pfMet_shiftedPt_HCALUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_HCALUESDown")
        #if not self.type1_pfMet_shiftedPt_HCALUESDown_branch and "type1_pfMet_shiftedPt_HCALUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_HCALUESDown_branch and "type1_pfMet_shiftedPt_HCALUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_HCALUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_HCALUESDown")
        else:
            self.type1_pfMet_shiftedPt_HCALUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_HCALUESDown_value)

        #print "making type1_pfMet_shiftedPt_HCALUESUp"
        self.type1_pfMet_shiftedPt_HCALUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_HCALUESUp")
        #if not self.type1_pfMet_shiftedPt_HCALUESUp_branch and "type1_pfMet_shiftedPt_HCALUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_HCALUESUp_branch and "type1_pfMet_shiftedPt_HCALUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_HCALUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_HCALUESUp")
        else:
            self.type1_pfMet_shiftedPt_HCALUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_HCALUESUp_value)

        #print "making type1_pfMet_shiftedPt_HFUESDown"
        self.type1_pfMet_shiftedPt_HFUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_HFUESDown")
        #if not self.type1_pfMet_shiftedPt_HFUESDown_branch and "type1_pfMet_shiftedPt_HFUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_HFUESDown_branch and "type1_pfMet_shiftedPt_HFUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_HFUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_HFUESDown")
        else:
            self.type1_pfMet_shiftedPt_HFUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_HFUESDown_value)

        #print "making type1_pfMet_shiftedPt_HFUESUp"
        self.type1_pfMet_shiftedPt_HFUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_HFUESUp")
        #if not self.type1_pfMet_shiftedPt_HFUESUp_branch and "type1_pfMet_shiftedPt_HFUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_HFUESUp_branch and "type1_pfMet_shiftedPt_HFUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_HFUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_HFUESUp")
        else:
            self.type1_pfMet_shiftedPt_HFUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_HFUESUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteFlavMapUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteMPFBiasUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteScaleUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteScaleUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteScaleUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteScaleUp_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatDown"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatDown")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatDown_value)

        #print "making type1_pfMet_shiftedPt_JetAbsoluteStatUp"
        self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        #if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch and "type1_pfMet_shiftedPt_JetAbsoluteStatUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetAbsoluteStatUp")
        else:
            self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetAbsoluteStatUp_value)

        #print "making type1_pfMet_shiftedPt_JetCheckUESDown"
        self.type1_pfMet_shiftedPt_JetCheckUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetCheckUESDown")
        #if not self.type1_pfMet_shiftedPt_JetCheckUESDown_branch and "type1_pfMet_shiftedPt_JetCheckUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetCheckUESDown_branch and "type1_pfMet_shiftedPt_JetCheckUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetCheckUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetCheckUESDown")
        else:
            self.type1_pfMet_shiftedPt_JetCheckUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetCheckUESDown_value)

        #print "making type1_pfMet_shiftedPt_JetCheckUESUp"
        self.type1_pfMet_shiftedPt_JetCheckUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetCheckUESUp")
        #if not self.type1_pfMet_shiftedPt_JetCheckUESUp_branch and "type1_pfMet_shiftedPt_JetCheckUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetCheckUESUp_branch and "type1_pfMet_shiftedPt_JetCheckUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetCheckUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetCheckUESUp")
        else:
            self.type1_pfMet_shiftedPt_JetCheckUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetCheckUESUp_value)

        #print "making type1_pfMet_shiftedPt_JetEnDown"
        self.type1_pfMet_shiftedPt_JetEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnDown")
        #if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnDown_branch and "type1_pfMet_shiftedPt_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnDown")
        else:
            self.type1_pfMet_shiftedPt_JetEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnDown_value)

        #print "making type1_pfMet_shiftedPt_JetEnUp"
        self.type1_pfMet_shiftedPt_JetEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetEnUp")
        #if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetEnUp_branch and "type1_pfMet_shiftedPt_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetEnUp")
        else:
            self.type1_pfMet_shiftedPt_JetEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetEnUp_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDDown"
        self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch and "type1_pfMet_shiftedPt_JetFlavorQCDDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDDown")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDDown_value)

        #print "making type1_pfMet_shiftedPt_JetFlavorQCDUp"
        self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        #if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch and "type1_pfMet_shiftedPt_JetFlavorQCDUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFlavorQCDUp")
        else:
            self.type1_pfMet_shiftedPt_JetFlavorQCDUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFlavorQCDUp_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationDown"
        self.type1_pfMet_shiftedPt_JetFragmentationDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationDown")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationDown_branch and "type1_pfMet_shiftedPt_JetFragmentationDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationDown")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationDown_value)

        #print "making type1_pfMet_shiftedPt_JetFragmentationUp"
        self.type1_pfMet_shiftedPt_JetFragmentationUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetFragmentationUp")
        #if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetFragmentationUp_branch and "type1_pfMet_shiftedPt_JetFragmentationUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetFragmentationUp")
        else:
            self.type1_pfMet_shiftedPt_JetFragmentationUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetFragmentationUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCDown"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpDataMCUp"
        self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch and "type1_pfMet_shiftedPt_JetPileUpDataMCUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpDataMCUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpDataMCUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtBBUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtBBUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC1Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Down"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtEC2Up"
        self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch and "type1_pfMet_shiftedPt_JetPileUpPtEC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtHFUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefDown"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefDown")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefDown_value)

        #print "making type1_pfMet_shiftedPt_JetPileUpPtRefUp"
        self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        #if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch and "type1_pfMet_shiftedPt_JetPileUpPtRefUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetPileUpPtRefUp")
        else:
            self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetPileUpPtRefUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalDown"
        self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch and "type1_pfMet_shiftedPt_JetRelativeBalDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeBalUp"
        self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeBalUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch and "type1_pfMet_shiftedPt_JetRelativeBalUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeBalUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeBalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeBalUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeFSRDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeFSRUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC1Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Down"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJEREC2Up"
        self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch and "type1_pfMet_shiftedPt_JetRelativeJEREC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJEREC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJEREC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeJERHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeJERHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeJERHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeJERHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBDown"
        self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch and "type1_pfMet_shiftedPt_JetRelativePtBBDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtBBUp"
        self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch and "type1_pfMet_shiftedPt_JetRelativePtBBUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtBBUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtBBUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtBBUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC1Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC1Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC1Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC1Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Down"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Down":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Down")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Down_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtEC2Up"
        self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch and "type1_pfMet_shiftedPt_JetRelativePtEC2Up":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtEC2Up")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtEC2Up_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFDown"
        self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch and "type1_pfMet_shiftedPt_JetRelativePtHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativePtHFUp"
        self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch and "type1_pfMet_shiftedPt_JetRelativePtHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativePtHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativePtHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativePtHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatECDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatECUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatECUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatECUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatECUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatECUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatFSRUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatFSRUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatFSRUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatFSRUp_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFDown"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFDown")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFDown_value)

        #print "making type1_pfMet_shiftedPt_JetRelativeStatHFUp"
        self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        #if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch and "type1_pfMet_shiftedPt_JetRelativeStatHFUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetRelativeStatHFUp")
        else:
            self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetRelativeStatHFUp_value)

        #print "making type1_pfMet_shiftedPt_JetResDown"
        self.type1_pfMet_shiftedPt_JetResDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResDown")
        #if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResDown_branch and "type1_pfMet_shiftedPt_JetResDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetResDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResDown")
        else:
            self.type1_pfMet_shiftedPt_JetResDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResDown_value)

        #print "making type1_pfMet_shiftedPt_JetResUp"
        self.type1_pfMet_shiftedPt_JetResUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetResUp")
        #if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetResUp_branch and "type1_pfMet_shiftedPt_JetResUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetResUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetResUp")
        else:
            self.type1_pfMet_shiftedPt_JetResUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetResUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionECALDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionECALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionECALUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionECALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionECALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionECALUp_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALDown"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALDown")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALDown_value)

        #print "making type1_pfMet_shiftedPt_JetSinglePionHCALUp"
        self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        #if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch and "type1_pfMet_shiftedPt_JetSinglePionHCALUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetSinglePionHCALUp")
        else:
            self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetSinglePionHCALUp_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaDown"
        self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch and "type1_pfMet_shiftedPt_JetTimePtEtaDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaDown")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaDown_value)

        #print "making type1_pfMet_shiftedPt_JetTimePtEtaUp"
        self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        #if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch and "type1_pfMet_shiftedPt_JetTimePtEtaUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTimePtEtaUp")
        else:
            self.type1_pfMet_shiftedPt_JetTimePtEtaUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTimePtEtaUp_value)

        #print "making type1_pfMet_shiftedPt_JetTotalDown"
        self.type1_pfMet_shiftedPt_JetTotalDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalDown")
        #if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalDown_branch and "type1_pfMet_shiftedPt_JetTotalDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalDown")
        else:
            self.type1_pfMet_shiftedPt_JetTotalDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalDown_value)

        #print "making type1_pfMet_shiftedPt_JetTotalUp"
        self.type1_pfMet_shiftedPt_JetTotalUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_JetTotalUp")
        #if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_JetTotalUp_branch and "type1_pfMet_shiftedPt_JetTotalUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_JetTotalUp")
        else:
            self.type1_pfMet_shiftedPt_JetTotalUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_JetTotalUp_value)

        #print "making type1_pfMet_shiftedPt_RunIUESDown"
        self.type1_pfMet_shiftedPt_RunIUESDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_RunIUESDown")
        #if not self.type1_pfMet_shiftedPt_RunIUESDown_branch and "type1_pfMet_shiftedPt_RunIUESDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_RunIUESDown_branch and "type1_pfMet_shiftedPt_RunIUESDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_RunIUESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_RunIUESDown")
        else:
            self.type1_pfMet_shiftedPt_RunIUESDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_RunIUESDown_value)

        #print "making type1_pfMet_shiftedPt_RunIUESUp"
        self.type1_pfMet_shiftedPt_RunIUESUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_RunIUESUp")
        #if not self.type1_pfMet_shiftedPt_RunIUESUp_branch and "type1_pfMet_shiftedPt_RunIUESUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_RunIUESUp_branch and "type1_pfMet_shiftedPt_RunIUESUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_RunIUESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_RunIUESUp")
        else:
            self.type1_pfMet_shiftedPt_RunIUESUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_RunIUESUp_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnDown"
        self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnDown")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch and "type1_pfMet_shiftedPt_UnclusteredEnDown":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnDown")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnDown_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnDown_value)

        #print "making type1_pfMet_shiftedPt_UnclusteredEnUp"
        self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch = the_tree.GetBranch("type1_pfMet_shiftedPt_UnclusteredEnUp")
        #if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp" not in self.complained:
        if not self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch and "type1_pfMet_shiftedPt_UnclusteredEnUp":
            warnings.warn( "MuMuTree: Expected branch type1_pfMet_shiftedPt_UnclusteredEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("type1_pfMet_shiftedPt_UnclusteredEnUp")
        else:
            self.type1_pfMet_shiftedPt_UnclusteredEnUp_branch.SetAddress(<void*>&self.type1_pfMet_shiftedPt_UnclusteredEnUp_value)

        #print "making vbfDeta"
        self.vbfDeta_branch = the_tree.GetBranch("vbfDeta")
        #if not self.vbfDeta_branch and "vbfDeta" not in self.complained:
        if not self.vbfDeta_branch and "vbfDeta":
            warnings.warn( "MuMuTree: Expected branch vbfDeta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta")
        else:
            self.vbfDeta_branch.SetAddress(<void*>&self.vbfDeta_value)

        #print "making vbfDeta_JetEnDown"
        self.vbfDeta_JetEnDown_branch = the_tree.GetBranch("vbfDeta_JetEnDown")
        #if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown" not in self.complained:
        if not self.vbfDeta_JetEnDown_branch and "vbfDeta_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfDeta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnDown")
        else:
            self.vbfDeta_JetEnDown_branch.SetAddress(<void*>&self.vbfDeta_JetEnDown_value)

        #print "making vbfDeta_JetEnUp"
        self.vbfDeta_JetEnUp_branch = the_tree.GetBranch("vbfDeta_JetEnUp")
        #if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp" not in self.complained:
        if not self.vbfDeta_JetEnUp_branch and "vbfDeta_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfDeta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDeta_JetEnUp")
        else:
            self.vbfDeta_JetEnUp_branch.SetAddress(<void*>&self.vbfDeta_JetEnUp_value)

        #print "making vbfDijetrap"
        self.vbfDijetrap_branch = the_tree.GetBranch("vbfDijetrap")
        #if not self.vbfDijetrap_branch and "vbfDijetrap" not in self.complained:
        if not self.vbfDijetrap_branch and "vbfDijetrap":
            warnings.warn( "MuMuTree: Expected branch vbfDijetrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap")
        else:
            self.vbfDijetrap_branch.SetAddress(<void*>&self.vbfDijetrap_value)

        #print "making vbfDijetrap_JetEnDown"
        self.vbfDijetrap_JetEnDown_branch = the_tree.GetBranch("vbfDijetrap_JetEnDown")
        #if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown" not in self.complained:
        if not self.vbfDijetrap_JetEnDown_branch and "vbfDijetrap_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfDijetrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnDown")
        else:
            self.vbfDijetrap_JetEnDown_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnDown_value)

        #print "making vbfDijetrap_JetEnUp"
        self.vbfDijetrap_JetEnUp_branch = the_tree.GetBranch("vbfDijetrap_JetEnUp")
        #if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp" not in self.complained:
        if not self.vbfDijetrap_JetEnUp_branch and "vbfDijetrap_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfDijetrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDijetrap_JetEnUp")
        else:
            self.vbfDijetrap_JetEnUp_branch.SetAddress(<void*>&self.vbfDijetrap_JetEnUp_value)

        #print "making vbfDphi"
        self.vbfDphi_branch = the_tree.GetBranch("vbfDphi")
        #if not self.vbfDphi_branch and "vbfDphi" not in self.complained:
        if not self.vbfDphi_branch and "vbfDphi":
            warnings.warn( "MuMuTree: Expected branch vbfDphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi")
        else:
            self.vbfDphi_branch.SetAddress(<void*>&self.vbfDphi_value)

        #print "making vbfDphi_JetEnDown"
        self.vbfDphi_JetEnDown_branch = the_tree.GetBranch("vbfDphi_JetEnDown")
        #if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown" not in self.complained:
        if not self.vbfDphi_JetEnDown_branch and "vbfDphi_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfDphi_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnDown")
        else:
            self.vbfDphi_JetEnDown_branch.SetAddress(<void*>&self.vbfDphi_JetEnDown_value)

        #print "making vbfDphi_JetEnUp"
        self.vbfDphi_JetEnUp_branch = the_tree.GetBranch("vbfDphi_JetEnUp")
        #if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp" not in self.complained:
        if not self.vbfDphi_JetEnUp_branch and "vbfDphi_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfDphi_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphi_JetEnUp")
        else:
            self.vbfDphi_JetEnUp_branch.SetAddress(<void*>&self.vbfDphi_JetEnUp_value)

        #print "making vbfDphihj"
        self.vbfDphihj_branch = the_tree.GetBranch("vbfDphihj")
        #if not self.vbfDphihj_branch and "vbfDphihj" not in self.complained:
        if not self.vbfDphihj_branch and "vbfDphihj":
            warnings.warn( "MuMuTree: Expected branch vbfDphihj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj")
        else:
            self.vbfDphihj_branch.SetAddress(<void*>&self.vbfDphihj_value)

        #print "making vbfDphihj_JetEnDown"
        self.vbfDphihj_JetEnDown_branch = the_tree.GetBranch("vbfDphihj_JetEnDown")
        #if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown" not in self.complained:
        if not self.vbfDphihj_JetEnDown_branch and "vbfDphihj_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfDphihj_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnDown")
        else:
            self.vbfDphihj_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihj_JetEnDown_value)

        #print "making vbfDphihj_JetEnUp"
        self.vbfDphihj_JetEnUp_branch = the_tree.GetBranch("vbfDphihj_JetEnUp")
        #if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp" not in self.complained:
        if not self.vbfDphihj_JetEnUp_branch and "vbfDphihj_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfDphihj_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihj_JetEnUp")
        else:
            self.vbfDphihj_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihj_JetEnUp_value)

        #print "making vbfDphihjnomet"
        self.vbfDphihjnomet_branch = the_tree.GetBranch("vbfDphihjnomet")
        #if not self.vbfDphihjnomet_branch and "vbfDphihjnomet" not in self.complained:
        if not self.vbfDphihjnomet_branch and "vbfDphihjnomet":
            warnings.warn( "MuMuTree: Expected branch vbfDphihjnomet does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet")
        else:
            self.vbfDphihjnomet_branch.SetAddress(<void*>&self.vbfDphihjnomet_value)

        #print "making vbfDphihjnomet_JetEnDown"
        self.vbfDphihjnomet_JetEnDown_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnDown")
        #if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown" not in self.complained:
        if not self.vbfDphihjnomet_JetEnDown_branch and "vbfDphihjnomet_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfDphihjnomet_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnDown")
        else:
            self.vbfDphihjnomet_JetEnDown_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnDown_value)

        #print "making vbfDphihjnomet_JetEnUp"
        self.vbfDphihjnomet_JetEnUp_branch = the_tree.GetBranch("vbfDphihjnomet_JetEnUp")
        #if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp" not in self.complained:
        if not self.vbfDphihjnomet_JetEnUp_branch and "vbfDphihjnomet_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfDphihjnomet_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfDphihjnomet_JetEnUp")
        else:
            self.vbfDphihjnomet_JetEnUp_branch.SetAddress(<void*>&self.vbfDphihjnomet_JetEnUp_value)

        #print "making vbfHrap"
        self.vbfHrap_branch = the_tree.GetBranch("vbfHrap")
        #if not self.vbfHrap_branch and "vbfHrap" not in self.complained:
        if not self.vbfHrap_branch and "vbfHrap":
            warnings.warn( "MuMuTree: Expected branch vbfHrap does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap")
        else:
            self.vbfHrap_branch.SetAddress(<void*>&self.vbfHrap_value)

        #print "making vbfHrap_JetEnDown"
        self.vbfHrap_JetEnDown_branch = the_tree.GetBranch("vbfHrap_JetEnDown")
        #if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown" not in self.complained:
        if not self.vbfHrap_JetEnDown_branch and "vbfHrap_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfHrap_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnDown")
        else:
            self.vbfHrap_JetEnDown_branch.SetAddress(<void*>&self.vbfHrap_JetEnDown_value)

        #print "making vbfHrap_JetEnUp"
        self.vbfHrap_JetEnUp_branch = the_tree.GetBranch("vbfHrap_JetEnUp")
        #if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp" not in self.complained:
        if not self.vbfHrap_JetEnUp_branch and "vbfHrap_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfHrap_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfHrap_JetEnUp")
        else:
            self.vbfHrap_JetEnUp_branch.SetAddress(<void*>&self.vbfHrap_JetEnUp_value)

        #print "making vbfJetVeto20"
        self.vbfJetVeto20_branch = the_tree.GetBranch("vbfJetVeto20")
        #if not self.vbfJetVeto20_branch and "vbfJetVeto20" not in self.complained:
        if not self.vbfJetVeto20_branch and "vbfJetVeto20":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20")
        else:
            self.vbfJetVeto20_branch.SetAddress(<void*>&self.vbfJetVeto20_value)

        #print "making vbfJetVeto20_JetEnDown"
        self.vbfJetVeto20_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto20_JetEnDown")
        #if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown" not in self.complained:
        if not self.vbfJetVeto20_JetEnDown_branch and "vbfJetVeto20_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnDown")
        else:
            self.vbfJetVeto20_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnDown_value)

        #print "making vbfJetVeto20_JetEnUp"
        self.vbfJetVeto20_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto20_JetEnUp")
        #if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp" not in self.complained:
        if not self.vbfJetVeto20_JetEnUp_branch and "vbfJetVeto20_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto20_JetEnUp")
        else:
            self.vbfJetVeto20_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto20_JetEnUp_value)

        #print "making vbfJetVeto30"
        self.vbfJetVeto30_branch = the_tree.GetBranch("vbfJetVeto30")
        #if not self.vbfJetVeto30_branch and "vbfJetVeto30" not in self.complained:
        if not self.vbfJetVeto30_branch and "vbfJetVeto30":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30")
        else:
            self.vbfJetVeto30_branch.SetAddress(<void*>&self.vbfJetVeto30_value)

        #print "making vbfJetVeto30_JetEnDown"
        self.vbfJetVeto30_JetEnDown_branch = the_tree.GetBranch("vbfJetVeto30_JetEnDown")
        #if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown" not in self.complained:
        if not self.vbfJetVeto30_JetEnDown_branch and "vbfJetVeto30_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnDown")
        else:
            self.vbfJetVeto30_JetEnDown_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnDown_value)

        #print "making vbfJetVeto30_JetEnUp"
        self.vbfJetVeto30_JetEnUp_branch = the_tree.GetBranch("vbfJetVeto30_JetEnUp")
        #if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp" not in self.complained:
        if not self.vbfJetVeto30_JetEnUp_branch and "vbfJetVeto30_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfJetVeto30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfJetVeto30_JetEnUp")
        else:
            self.vbfJetVeto30_JetEnUp_branch.SetAddress(<void*>&self.vbfJetVeto30_JetEnUp_value)

        #print "making vbfMVA"
        self.vbfMVA_branch = the_tree.GetBranch("vbfMVA")
        #if not self.vbfMVA_branch and "vbfMVA" not in self.complained:
        if not self.vbfMVA_branch and "vbfMVA":
            warnings.warn( "MuMuTree: Expected branch vbfMVA does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA")
        else:
            self.vbfMVA_branch.SetAddress(<void*>&self.vbfMVA_value)

        #print "making vbfMVA_JetEnDown"
        self.vbfMVA_JetEnDown_branch = the_tree.GetBranch("vbfMVA_JetEnDown")
        #if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown" not in self.complained:
        if not self.vbfMVA_JetEnDown_branch and "vbfMVA_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfMVA_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnDown")
        else:
            self.vbfMVA_JetEnDown_branch.SetAddress(<void*>&self.vbfMVA_JetEnDown_value)

        #print "making vbfMVA_JetEnUp"
        self.vbfMVA_JetEnUp_branch = the_tree.GetBranch("vbfMVA_JetEnUp")
        #if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp" not in self.complained:
        if not self.vbfMVA_JetEnUp_branch and "vbfMVA_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfMVA_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMVA_JetEnUp")
        else:
            self.vbfMVA_JetEnUp_branch.SetAddress(<void*>&self.vbfMVA_JetEnUp_value)

        #print "making vbfMass"
        self.vbfMass_branch = the_tree.GetBranch("vbfMass")
        #if not self.vbfMass_branch and "vbfMass" not in self.complained:
        if not self.vbfMass_branch and "vbfMass":
            warnings.warn( "MuMuTree: Expected branch vbfMass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass")
        else:
            self.vbfMass_branch.SetAddress(<void*>&self.vbfMass_value)

        #print "making vbfMass_JetAbsoluteFlavMapDown"
        self.vbfMass_JetAbsoluteFlavMapDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapDown")
        #if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapDown_branch and "vbfMass_JetAbsoluteFlavMapDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteFlavMapDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapDown")
        else:
            self.vbfMass_JetAbsoluteFlavMapDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapDown_value)

        #print "making vbfMass_JetAbsoluteFlavMapUp"
        self.vbfMass_JetAbsoluteFlavMapUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteFlavMapUp")
        #if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteFlavMapUp_branch and "vbfMass_JetAbsoluteFlavMapUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteFlavMapUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteFlavMapUp")
        else:
            self.vbfMass_JetAbsoluteFlavMapUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteFlavMapUp_value)

        #print "making vbfMass_JetAbsoluteMPFBiasDown"
        self.vbfMass_JetAbsoluteMPFBiasDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasDown")
        #if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasDown_branch and "vbfMass_JetAbsoluteMPFBiasDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteMPFBiasDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasDown")
        else:
            self.vbfMass_JetAbsoluteMPFBiasDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasDown_value)

        #print "making vbfMass_JetAbsoluteMPFBiasUp"
        self.vbfMass_JetAbsoluteMPFBiasUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteMPFBiasUp")
        #if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteMPFBiasUp_branch and "vbfMass_JetAbsoluteMPFBiasUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteMPFBiasUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteMPFBiasUp")
        else:
            self.vbfMass_JetAbsoluteMPFBiasUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteMPFBiasUp_value)

        #print "making vbfMass_JetAbsoluteScaleDown"
        self.vbfMass_JetAbsoluteScaleDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleDown")
        #if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleDown_branch and "vbfMass_JetAbsoluteScaleDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleDown")
        else:
            self.vbfMass_JetAbsoluteScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleDown_value)

        #print "making vbfMass_JetAbsoluteScaleUp"
        self.vbfMass_JetAbsoluteScaleUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteScaleUp")
        #if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteScaleUp_branch and "vbfMass_JetAbsoluteScaleUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteScaleUp")
        else:
            self.vbfMass_JetAbsoluteScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteScaleUp_value)

        #print "making vbfMass_JetAbsoluteStatDown"
        self.vbfMass_JetAbsoluteStatDown_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatDown")
        #if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatDown_branch and "vbfMass_JetAbsoluteStatDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteStatDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatDown")
        else:
            self.vbfMass_JetAbsoluteStatDown_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatDown_value)

        #print "making vbfMass_JetAbsoluteStatUp"
        self.vbfMass_JetAbsoluteStatUp_branch = the_tree.GetBranch("vbfMass_JetAbsoluteStatUp")
        #if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp" not in self.complained:
        if not self.vbfMass_JetAbsoluteStatUp_branch and "vbfMass_JetAbsoluteStatUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetAbsoluteStatUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetAbsoluteStatUp")
        else:
            self.vbfMass_JetAbsoluteStatUp_branch.SetAddress(<void*>&self.vbfMass_JetAbsoluteStatUp_value)

        #print "making vbfMass_JetClosureDown"
        self.vbfMass_JetClosureDown_branch = the_tree.GetBranch("vbfMass_JetClosureDown")
        #if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown" not in self.complained:
        if not self.vbfMass_JetClosureDown_branch and "vbfMass_JetClosureDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetClosureDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureDown")
        else:
            self.vbfMass_JetClosureDown_branch.SetAddress(<void*>&self.vbfMass_JetClosureDown_value)

        #print "making vbfMass_JetClosureUp"
        self.vbfMass_JetClosureUp_branch = the_tree.GetBranch("vbfMass_JetClosureUp")
        #if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp" not in self.complained:
        if not self.vbfMass_JetClosureUp_branch and "vbfMass_JetClosureUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetClosureUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetClosureUp")
        else:
            self.vbfMass_JetClosureUp_branch.SetAddress(<void*>&self.vbfMass_JetClosureUp_value)

        #print "making vbfMass_JetEnDown"
        self.vbfMass_JetEnDown_branch = the_tree.GetBranch("vbfMass_JetEnDown")
        #if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown" not in self.complained:
        if not self.vbfMass_JetEnDown_branch and "vbfMass_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnDown")
        else:
            self.vbfMass_JetEnDown_branch.SetAddress(<void*>&self.vbfMass_JetEnDown_value)

        #print "making vbfMass_JetEnUp"
        self.vbfMass_JetEnUp_branch = the_tree.GetBranch("vbfMass_JetEnUp")
        #if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp" not in self.complained:
        if not self.vbfMass_JetEnUp_branch and "vbfMass_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetEnUp")
        else:
            self.vbfMass_JetEnUp_branch.SetAddress(<void*>&self.vbfMass_JetEnUp_value)

        #print "making vbfMass_JetFlavorQCDDown"
        self.vbfMass_JetFlavorQCDDown_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDDown")
        #if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown" not in self.complained:
        if not self.vbfMass_JetFlavorQCDDown_branch and "vbfMass_JetFlavorQCDDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDDown")
        else:
            self.vbfMass_JetFlavorQCDDown_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDDown_value)

        #print "making vbfMass_JetFlavorQCDUp"
        self.vbfMass_JetFlavorQCDUp_branch = the_tree.GetBranch("vbfMass_JetFlavorQCDUp")
        #if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp" not in self.complained:
        if not self.vbfMass_JetFlavorQCDUp_branch and "vbfMass_JetFlavorQCDUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFlavorQCDUp")
        else:
            self.vbfMass_JetFlavorQCDUp_branch.SetAddress(<void*>&self.vbfMass_JetFlavorQCDUp_value)

        #print "making vbfMass_JetFragmentationDown"
        self.vbfMass_JetFragmentationDown_branch = the_tree.GetBranch("vbfMass_JetFragmentationDown")
        #if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown" not in self.complained:
        if not self.vbfMass_JetFragmentationDown_branch and "vbfMass_JetFragmentationDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetFragmentationDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationDown")
        else:
            self.vbfMass_JetFragmentationDown_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationDown_value)

        #print "making vbfMass_JetFragmentationUp"
        self.vbfMass_JetFragmentationUp_branch = the_tree.GetBranch("vbfMass_JetFragmentationUp")
        #if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp" not in self.complained:
        if not self.vbfMass_JetFragmentationUp_branch and "vbfMass_JetFragmentationUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetFragmentationUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetFragmentationUp")
        else:
            self.vbfMass_JetFragmentationUp_branch.SetAddress(<void*>&self.vbfMass_JetFragmentationUp_value)

        #print "making vbfMass_JetPileUpDataMCDown"
        self.vbfMass_JetPileUpDataMCDown_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCDown")
        #if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCDown_branch and "vbfMass_JetPileUpDataMCDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpDataMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCDown")
        else:
            self.vbfMass_JetPileUpDataMCDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCDown_value)

        #print "making vbfMass_JetPileUpDataMCUp"
        self.vbfMass_JetPileUpDataMCUp_branch = the_tree.GetBranch("vbfMass_JetPileUpDataMCUp")
        #if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp" not in self.complained:
        if not self.vbfMass_JetPileUpDataMCUp_branch and "vbfMass_JetPileUpDataMCUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpDataMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpDataMCUp")
        else:
            self.vbfMass_JetPileUpDataMCUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpDataMCUp_value)

        #print "making vbfMass_JetPileUpPtBBDown"
        self.vbfMass_JetPileUpPtBBDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBDown")
        #if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBDown_branch and "vbfMass_JetPileUpPtBBDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBDown")
        else:
            self.vbfMass_JetPileUpPtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBDown_value)

        #print "making vbfMass_JetPileUpPtBBUp"
        self.vbfMass_JetPileUpPtBBUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtBBUp")
        #if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtBBUp_branch and "vbfMass_JetPileUpPtBBUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtBBUp")
        else:
            self.vbfMass_JetPileUpPtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtBBUp_value)

        #print "making vbfMass_JetPileUpPtEC1Down"
        self.vbfMass_JetPileUpPtEC1Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Down")
        #if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Down_branch and "vbfMass_JetPileUpPtEC1Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Down")
        else:
            self.vbfMass_JetPileUpPtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Down_value)

        #print "making vbfMass_JetPileUpPtEC1Up"
        self.vbfMass_JetPileUpPtEC1Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC1Up")
        #if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC1Up_branch and "vbfMass_JetPileUpPtEC1Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC1Up")
        else:
            self.vbfMass_JetPileUpPtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC1Up_value)

        #print "making vbfMass_JetPileUpPtEC2Down"
        self.vbfMass_JetPileUpPtEC2Down_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Down")
        #if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Down_branch and "vbfMass_JetPileUpPtEC2Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Down")
        else:
            self.vbfMass_JetPileUpPtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Down_value)

        #print "making vbfMass_JetPileUpPtEC2Up"
        self.vbfMass_JetPileUpPtEC2Up_branch = the_tree.GetBranch("vbfMass_JetPileUpPtEC2Up")
        #if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up" not in self.complained:
        if not self.vbfMass_JetPileUpPtEC2Up_branch and "vbfMass_JetPileUpPtEC2Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtEC2Up")
        else:
            self.vbfMass_JetPileUpPtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtEC2Up_value)

        #print "making vbfMass_JetPileUpPtHFDown"
        self.vbfMass_JetPileUpPtHFDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFDown")
        #if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFDown_branch and "vbfMass_JetPileUpPtHFDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFDown")
        else:
            self.vbfMass_JetPileUpPtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFDown_value)

        #print "making vbfMass_JetPileUpPtHFUp"
        self.vbfMass_JetPileUpPtHFUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtHFUp")
        #if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtHFUp_branch and "vbfMass_JetPileUpPtHFUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtHFUp")
        else:
            self.vbfMass_JetPileUpPtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtHFUp_value)

        #print "making vbfMass_JetPileUpPtRefDown"
        self.vbfMass_JetPileUpPtRefDown_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefDown")
        #if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefDown_branch and "vbfMass_JetPileUpPtRefDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtRefDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefDown")
        else:
            self.vbfMass_JetPileUpPtRefDown_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefDown_value)

        #print "making vbfMass_JetPileUpPtRefUp"
        self.vbfMass_JetPileUpPtRefUp_branch = the_tree.GetBranch("vbfMass_JetPileUpPtRefUp")
        #if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp" not in self.complained:
        if not self.vbfMass_JetPileUpPtRefUp_branch and "vbfMass_JetPileUpPtRefUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetPileUpPtRefUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetPileUpPtRefUp")
        else:
            self.vbfMass_JetPileUpPtRefUp_branch.SetAddress(<void*>&self.vbfMass_JetPileUpPtRefUp_value)

        #print "making vbfMass_JetRelativeBalDown"
        self.vbfMass_JetRelativeBalDown_branch = the_tree.GetBranch("vbfMass_JetRelativeBalDown")
        #if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown" not in self.complained:
        if not self.vbfMass_JetRelativeBalDown_branch and "vbfMass_JetRelativeBalDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalDown")
        else:
            self.vbfMass_JetRelativeBalDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalDown_value)

        #print "making vbfMass_JetRelativeBalUp"
        self.vbfMass_JetRelativeBalUp_branch = the_tree.GetBranch("vbfMass_JetRelativeBalUp")
        #if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp" not in self.complained:
        if not self.vbfMass_JetRelativeBalUp_branch and "vbfMass_JetRelativeBalUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeBalUp")
        else:
            self.vbfMass_JetRelativeBalUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeBalUp_value)

        #print "making vbfMass_JetRelativeFSRDown"
        self.vbfMass_JetRelativeFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRDown")
        #if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeFSRDown_branch and "vbfMass_JetRelativeFSRDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRDown")
        else:
            self.vbfMass_JetRelativeFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRDown_value)

        #print "making vbfMass_JetRelativeFSRUp"
        self.vbfMass_JetRelativeFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeFSRUp")
        #if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeFSRUp_branch and "vbfMass_JetRelativeFSRUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeFSRUp")
        else:
            self.vbfMass_JetRelativeFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeFSRUp_value)

        #print "making vbfMass_JetRelativeJEREC1Down"
        self.vbfMass_JetRelativeJEREC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Down")
        #if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Down_branch and "vbfMass_JetRelativeJEREC1Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJEREC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Down")
        else:
            self.vbfMass_JetRelativeJEREC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Down_value)

        #print "making vbfMass_JetRelativeJEREC1Up"
        self.vbfMass_JetRelativeJEREC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC1Up")
        #if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC1Up_branch and "vbfMass_JetRelativeJEREC1Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJEREC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC1Up")
        else:
            self.vbfMass_JetRelativeJEREC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC1Up_value)

        #print "making vbfMass_JetRelativeJEREC2Down"
        self.vbfMass_JetRelativeJEREC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Down")
        #if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Down_branch and "vbfMass_JetRelativeJEREC2Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJEREC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Down")
        else:
            self.vbfMass_JetRelativeJEREC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Down_value)

        #print "making vbfMass_JetRelativeJEREC2Up"
        self.vbfMass_JetRelativeJEREC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativeJEREC2Up")
        #if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up" not in self.complained:
        if not self.vbfMass_JetRelativeJEREC2Up_branch and "vbfMass_JetRelativeJEREC2Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJEREC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJEREC2Up")
        else:
            self.vbfMass_JetRelativeJEREC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJEREC2Up_value)

        #print "making vbfMass_JetRelativeJERHFDown"
        self.vbfMass_JetRelativeJERHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFDown")
        #if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFDown_branch and "vbfMass_JetRelativeJERHFDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJERHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFDown")
        else:
            self.vbfMass_JetRelativeJERHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFDown_value)

        #print "making vbfMass_JetRelativeJERHFUp"
        self.vbfMass_JetRelativeJERHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeJERHFUp")
        #if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeJERHFUp_branch and "vbfMass_JetRelativeJERHFUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeJERHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeJERHFUp")
        else:
            self.vbfMass_JetRelativeJERHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeJERHFUp_value)

        #print "making vbfMass_JetRelativePtBBDown"
        self.vbfMass_JetRelativePtBBDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBDown")
        #if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown" not in self.complained:
        if not self.vbfMass_JetRelativePtBBDown_branch and "vbfMass_JetRelativePtBBDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtBBDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBDown")
        else:
            self.vbfMass_JetRelativePtBBDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBDown_value)

        #print "making vbfMass_JetRelativePtBBUp"
        self.vbfMass_JetRelativePtBBUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtBBUp")
        #if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp" not in self.complained:
        if not self.vbfMass_JetRelativePtBBUp_branch and "vbfMass_JetRelativePtBBUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtBBUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtBBUp")
        else:
            self.vbfMass_JetRelativePtBBUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtBBUp_value)

        #print "making vbfMass_JetRelativePtEC1Down"
        self.vbfMass_JetRelativePtEC1Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Down")
        #if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Down_branch and "vbfMass_JetRelativePtEC1Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Down")
        else:
            self.vbfMass_JetRelativePtEC1Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Down_value)

        #print "making vbfMass_JetRelativePtEC1Up"
        self.vbfMass_JetRelativePtEC1Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC1Up")
        #if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC1Up_branch and "vbfMass_JetRelativePtEC1Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC1Up")
        else:
            self.vbfMass_JetRelativePtEC1Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC1Up_value)

        #print "making vbfMass_JetRelativePtEC2Down"
        self.vbfMass_JetRelativePtEC2Down_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Down")
        #if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Down_branch and "vbfMass_JetRelativePtEC2Down":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Down")
        else:
            self.vbfMass_JetRelativePtEC2Down_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Down_value)

        #print "making vbfMass_JetRelativePtEC2Up"
        self.vbfMass_JetRelativePtEC2Up_branch = the_tree.GetBranch("vbfMass_JetRelativePtEC2Up")
        #if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up" not in self.complained:
        if not self.vbfMass_JetRelativePtEC2Up_branch and "vbfMass_JetRelativePtEC2Up":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtEC2Up")
        else:
            self.vbfMass_JetRelativePtEC2Up_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtEC2Up_value)

        #print "making vbfMass_JetRelativePtHFDown"
        self.vbfMass_JetRelativePtHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFDown")
        #if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown" not in self.complained:
        if not self.vbfMass_JetRelativePtHFDown_branch and "vbfMass_JetRelativePtHFDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFDown")
        else:
            self.vbfMass_JetRelativePtHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFDown_value)

        #print "making vbfMass_JetRelativePtHFUp"
        self.vbfMass_JetRelativePtHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativePtHFUp")
        #if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp" not in self.complained:
        if not self.vbfMass_JetRelativePtHFUp_branch and "vbfMass_JetRelativePtHFUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativePtHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativePtHFUp")
        else:
            self.vbfMass_JetRelativePtHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativePtHFUp_value)

        #print "making vbfMass_JetRelativeStatECDown"
        self.vbfMass_JetRelativeStatECDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECDown")
        #if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatECDown_branch and "vbfMass_JetRelativeStatECDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatECDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECDown")
        else:
            self.vbfMass_JetRelativeStatECDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECDown_value)

        #print "making vbfMass_JetRelativeStatECUp"
        self.vbfMass_JetRelativeStatECUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatECUp")
        #if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatECUp_branch and "vbfMass_JetRelativeStatECUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatECUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatECUp")
        else:
            self.vbfMass_JetRelativeStatECUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatECUp_value)

        #print "making vbfMass_JetRelativeStatFSRDown"
        self.vbfMass_JetRelativeStatFSRDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRDown")
        #if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRDown_branch and "vbfMass_JetRelativeStatFSRDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatFSRDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRDown")
        else:
            self.vbfMass_JetRelativeStatFSRDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRDown_value)

        #print "making vbfMass_JetRelativeStatFSRUp"
        self.vbfMass_JetRelativeStatFSRUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatFSRUp")
        #if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatFSRUp_branch and "vbfMass_JetRelativeStatFSRUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatFSRUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatFSRUp")
        else:
            self.vbfMass_JetRelativeStatFSRUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatFSRUp_value)

        #print "making vbfMass_JetRelativeStatHFDown"
        self.vbfMass_JetRelativeStatHFDown_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFDown")
        #if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFDown_branch and "vbfMass_JetRelativeStatHFDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFDown")
        else:
            self.vbfMass_JetRelativeStatHFDown_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFDown_value)

        #print "making vbfMass_JetRelativeStatHFUp"
        self.vbfMass_JetRelativeStatHFUp_branch = the_tree.GetBranch("vbfMass_JetRelativeStatHFUp")
        #if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp" not in self.complained:
        if not self.vbfMass_JetRelativeStatHFUp_branch and "vbfMass_JetRelativeStatHFUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetRelativeStatHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetRelativeStatHFUp")
        else:
            self.vbfMass_JetRelativeStatHFUp_branch.SetAddress(<void*>&self.vbfMass_JetRelativeStatHFUp_value)

        #print "making vbfMass_JetSinglePionECALDown"
        self.vbfMass_JetSinglePionECALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALDown")
        #if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionECALDown_branch and "vbfMass_JetSinglePionECALDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSinglePionECALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALDown")
        else:
            self.vbfMass_JetSinglePionECALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALDown_value)

        #print "making vbfMass_JetSinglePionECALUp"
        self.vbfMass_JetSinglePionECALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionECALUp")
        #if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionECALUp_branch and "vbfMass_JetSinglePionECALUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSinglePionECALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionECALUp")
        else:
            self.vbfMass_JetSinglePionECALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionECALUp_value)

        #print "making vbfMass_JetSinglePionHCALDown"
        self.vbfMass_JetSinglePionHCALDown_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALDown")
        #if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALDown_branch and "vbfMass_JetSinglePionHCALDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSinglePionHCALDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALDown")
        else:
            self.vbfMass_JetSinglePionHCALDown_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALDown_value)

        #print "making vbfMass_JetSinglePionHCALUp"
        self.vbfMass_JetSinglePionHCALUp_branch = the_tree.GetBranch("vbfMass_JetSinglePionHCALUp")
        #if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp" not in self.complained:
        if not self.vbfMass_JetSinglePionHCALUp_branch and "vbfMass_JetSinglePionHCALUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSinglePionHCALUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSinglePionHCALUp")
        else:
            self.vbfMass_JetSinglePionHCALUp_branch.SetAddress(<void*>&self.vbfMass_JetSinglePionHCALUp_value)

        #print "making vbfMass_JetSubTotalAbsoluteDown"
        self.vbfMass_JetSubTotalAbsoluteDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalAbsoluteDown")
        #if not self.vbfMass_JetSubTotalAbsoluteDown_branch and "vbfMass_JetSubTotalAbsoluteDown" not in self.complained:
        if not self.vbfMass_JetSubTotalAbsoluteDown_branch and "vbfMass_JetSubTotalAbsoluteDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalAbsoluteDown")
        else:
            self.vbfMass_JetSubTotalAbsoluteDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalAbsoluteDown_value)

        #print "making vbfMass_JetSubTotalAbsoluteUp"
        self.vbfMass_JetSubTotalAbsoluteUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalAbsoluteUp")
        #if not self.vbfMass_JetSubTotalAbsoluteUp_branch and "vbfMass_JetSubTotalAbsoluteUp" not in self.complained:
        if not self.vbfMass_JetSubTotalAbsoluteUp_branch and "vbfMass_JetSubTotalAbsoluteUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalAbsoluteUp")
        else:
            self.vbfMass_JetSubTotalAbsoluteUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalAbsoluteUp_value)

        #print "making vbfMass_JetSubTotalMCDown"
        self.vbfMass_JetSubTotalMCDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalMCDown")
        #if not self.vbfMass_JetSubTotalMCDown_branch and "vbfMass_JetSubTotalMCDown" not in self.complained:
        if not self.vbfMass_JetSubTotalMCDown_branch and "vbfMass_JetSubTotalMCDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalMCDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalMCDown")
        else:
            self.vbfMass_JetSubTotalMCDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalMCDown_value)

        #print "making vbfMass_JetSubTotalMCUp"
        self.vbfMass_JetSubTotalMCUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalMCUp")
        #if not self.vbfMass_JetSubTotalMCUp_branch and "vbfMass_JetSubTotalMCUp" not in self.complained:
        if not self.vbfMass_JetSubTotalMCUp_branch and "vbfMass_JetSubTotalMCUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalMCUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalMCUp")
        else:
            self.vbfMass_JetSubTotalMCUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalMCUp_value)

        #print "making vbfMass_JetSubTotalPileUpDown"
        self.vbfMass_JetSubTotalPileUpDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalPileUpDown")
        #if not self.vbfMass_JetSubTotalPileUpDown_branch and "vbfMass_JetSubTotalPileUpDown" not in self.complained:
        if not self.vbfMass_JetSubTotalPileUpDown_branch and "vbfMass_JetSubTotalPileUpDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalPileUpDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPileUpDown")
        else:
            self.vbfMass_JetSubTotalPileUpDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPileUpDown_value)

        #print "making vbfMass_JetSubTotalPileUpUp"
        self.vbfMass_JetSubTotalPileUpUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalPileUpUp")
        #if not self.vbfMass_JetSubTotalPileUpUp_branch and "vbfMass_JetSubTotalPileUpUp" not in self.complained:
        if not self.vbfMass_JetSubTotalPileUpUp_branch and "vbfMass_JetSubTotalPileUpUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalPileUpUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPileUpUp")
        else:
            self.vbfMass_JetSubTotalPileUpUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPileUpUp_value)

        #print "making vbfMass_JetSubTotalPtDown"
        self.vbfMass_JetSubTotalPtDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalPtDown")
        #if not self.vbfMass_JetSubTotalPtDown_branch and "vbfMass_JetSubTotalPtDown" not in self.complained:
        if not self.vbfMass_JetSubTotalPtDown_branch and "vbfMass_JetSubTotalPtDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalPtDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPtDown")
        else:
            self.vbfMass_JetSubTotalPtDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPtDown_value)

        #print "making vbfMass_JetSubTotalPtUp"
        self.vbfMass_JetSubTotalPtUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalPtUp")
        #if not self.vbfMass_JetSubTotalPtUp_branch and "vbfMass_JetSubTotalPtUp" not in self.complained:
        if not self.vbfMass_JetSubTotalPtUp_branch and "vbfMass_JetSubTotalPtUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalPtUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalPtUp")
        else:
            self.vbfMass_JetSubTotalPtUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalPtUp_value)

        #print "making vbfMass_JetSubTotalRelativeDown"
        self.vbfMass_JetSubTotalRelativeDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalRelativeDown")
        #if not self.vbfMass_JetSubTotalRelativeDown_branch and "vbfMass_JetSubTotalRelativeDown" not in self.complained:
        if not self.vbfMass_JetSubTotalRelativeDown_branch and "vbfMass_JetSubTotalRelativeDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalRelativeDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalRelativeDown")
        else:
            self.vbfMass_JetSubTotalRelativeDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalRelativeDown_value)

        #print "making vbfMass_JetSubTotalRelativeUp"
        self.vbfMass_JetSubTotalRelativeUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalRelativeUp")
        #if not self.vbfMass_JetSubTotalRelativeUp_branch and "vbfMass_JetSubTotalRelativeUp" not in self.complained:
        if not self.vbfMass_JetSubTotalRelativeUp_branch and "vbfMass_JetSubTotalRelativeUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalRelativeUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalRelativeUp")
        else:
            self.vbfMass_JetSubTotalRelativeUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalRelativeUp_value)

        #print "making vbfMass_JetSubTotalScaleDown"
        self.vbfMass_JetSubTotalScaleDown_branch = the_tree.GetBranch("vbfMass_JetSubTotalScaleDown")
        #if not self.vbfMass_JetSubTotalScaleDown_branch and "vbfMass_JetSubTotalScaleDown" not in self.complained:
        if not self.vbfMass_JetSubTotalScaleDown_branch and "vbfMass_JetSubTotalScaleDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalScaleDown")
        else:
            self.vbfMass_JetSubTotalScaleDown_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalScaleDown_value)

        #print "making vbfMass_JetSubTotalScaleUp"
        self.vbfMass_JetSubTotalScaleUp_branch = the_tree.GetBranch("vbfMass_JetSubTotalScaleUp")
        #if not self.vbfMass_JetSubTotalScaleUp_branch and "vbfMass_JetSubTotalScaleUp" not in self.complained:
        if not self.vbfMass_JetSubTotalScaleUp_branch and "vbfMass_JetSubTotalScaleUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetSubTotalScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetSubTotalScaleUp")
        else:
            self.vbfMass_JetSubTotalScaleUp_branch.SetAddress(<void*>&self.vbfMass_JetSubTotalScaleUp_value)

        #print "making vbfMass_JetTimePtEtaDown"
        self.vbfMass_JetTimePtEtaDown_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaDown")
        #if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown" not in self.complained:
        if not self.vbfMass_JetTimePtEtaDown_branch and "vbfMass_JetTimePtEtaDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetTimePtEtaDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaDown")
        else:
            self.vbfMass_JetTimePtEtaDown_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaDown_value)

        #print "making vbfMass_JetTimePtEtaUp"
        self.vbfMass_JetTimePtEtaUp_branch = the_tree.GetBranch("vbfMass_JetTimePtEtaUp")
        #if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp" not in self.complained:
        if not self.vbfMass_JetTimePtEtaUp_branch and "vbfMass_JetTimePtEtaUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetTimePtEtaUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTimePtEtaUp")
        else:
            self.vbfMass_JetTimePtEtaUp_branch.SetAddress(<void*>&self.vbfMass_JetTimePtEtaUp_value)

        #print "making vbfMass_JetTotalDown"
        self.vbfMass_JetTotalDown_branch = the_tree.GetBranch("vbfMass_JetTotalDown")
        #if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown" not in self.complained:
        if not self.vbfMass_JetTotalDown_branch and "vbfMass_JetTotalDown":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetTotalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalDown")
        else:
            self.vbfMass_JetTotalDown_branch.SetAddress(<void*>&self.vbfMass_JetTotalDown_value)

        #print "making vbfMass_JetTotalUp"
        self.vbfMass_JetTotalUp_branch = the_tree.GetBranch("vbfMass_JetTotalUp")
        #if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp" not in self.complained:
        if not self.vbfMass_JetTotalUp_branch and "vbfMass_JetTotalUp":
            warnings.warn( "MuMuTree: Expected branch vbfMass_JetTotalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfMass_JetTotalUp")
        else:
            self.vbfMass_JetTotalUp_branch.SetAddress(<void*>&self.vbfMass_JetTotalUp_value)

        #print "making vbfNJets20"
        self.vbfNJets20_branch = the_tree.GetBranch("vbfNJets20")
        #if not self.vbfNJets20_branch and "vbfNJets20" not in self.complained:
        if not self.vbfNJets20_branch and "vbfNJets20":
            warnings.warn( "MuMuTree: Expected branch vbfNJets20 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20")
        else:
            self.vbfNJets20_branch.SetAddress(<void*>&self.vbfNJets20_value)

        #print "making vbfNJets20_JetEnDown"
        self.vbfNJets20_JetEnDown_branch = the_tree.GetBranch("vbfNJets20_JetEnDown")
        #if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown" not in self.complained:
        if not self.vbfNJets20_JetEnDown_branch and "vbfNJets20_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfNJets20_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnDown")
        else:
            self.vbfNJets20_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets20_JetEnDown_value)

        #print "making vbfNJets20_JetEnUp"
        self.vbfNJets20_JetEnUp_branch = the_tree.GetBranch("vbfNJets20_JetEnUp")
        #if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp" not in self.complained:
        if not self.vbfNJets20_JetEnUp_branch and "vbfNJets20_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfNJets20_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets20_JetEnUp")
        else:
            self.vbfNJets20_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets20_JetEnUp_value)

        #print "making vbfNJets30"
        self.vbfNJets30_branch = the_tree.GetBranch("vbfNJets30")
        #if not self.vbfNJets30_branch and "vbfNJets30" not in self.complained:
        if not self.vbfNJets30_branch and "vbfNJets30":
            warnings.warn( "MuMuTree: Expected branch vbfNJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30")
        else:
            self.vbfNJets30_branch.SetAddress(<void*>&self.vbfNJets30_value)

        #print "making vbfNJets30_JetEnDown"
        self.vbfNJets30_JetEnDown_branch = the_tree.GetBranch("vbfNJets30_JetEnDown")
        #if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown" not in self.complained:
        if not self.vbfNJets30_JetEnDown_branch and "vbfNJets30_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfNJets30_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnDown")
        else:
            self.vbfNJets30_JetEnDown_branch.SetAddress(<void*>&self.vbfNJets30_JetEnDown_value)

        #print "making vbfNJets30_JetEnUp"
        self.vbfNJets30_JetEnUp_branch = the_tree.GetBranch("vbfNJets30_JetEnUp")
        #if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp" not in self.complained:
        if not self.vbfNJets30_JetEnUp_branch and "vbfNJets30_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfNJets30_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfNJets30_JetEnUp")
        else:
            self.vbfNJets30_JetEnUp_branch.SetAddress(<void*>&self.vbfNJets30_JetEnUp_value)

        #print "making vbfVispt"
        self.vbfVispt_branch = the_tree.GetBranch("vbfVispt")
        #if not self.vbfVispt_branch and "vbfVispt" not in self.complained:
        if not self.vbfVispt_branch and "vbfVispt":
            warnings.warn( "MuMuTree: Expected branch vbfVispt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt")
        else:
            self.vbfVispt_branch.SetAddress(<void*>&self.vbfVispt_value)

        #print "making vbfVispt_JetEnDown"
        self.vbfVispt_JetEnDown_branch = the_tree.GetBranch("vbfVispt_JetEnDown")
        #if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown" not in self.complained:
        if not self.vbfVispt_JetEnDown_branch and "vbfVispt_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfVispt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnDown")
        else:
            self.vbfVispt_JetEnDown_branch.SetAddress(<void*>&self.vbfVispt_JetEnDown_value)

        #print "making vbfVispt_JetEnUp"
        self.vbfVispt_JetEnUp_branch = the_tree.GetBranch("vbfVispt_JetEnUp")
        #if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp" not in self.complained:
        if not self.vbfVispt_JetEnUp_branch and "vbfVispt_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfVispt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfVispt_JetEnUp")
        else:
            self.vbfVispt_JetEnUp_branch.SetAddress(<void*>&self.vbfVispt_JetEnUp_value)

        #print "making vbfdijetpt"
        self.vbfdijetpt_branch = the_tree.GetBranch("vbfdijetpt")
        #if not self.vbfdijetpt_branch and "vbfdijetpt" not in self.complained:
        if not self.vbfdijetpt_branch and "vbfdijetpt":
            warnings.warn( "MuMuTree: Expected branch vbfdijetpt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt")
        else:
            self.vbfdijetpt_branch.SetAddress(<void*>&self.vbfdijetpt_value)

        #print "making vbfdijetpt_JetEnDown"
        self.vbfdijetpt_JetEnDown_branch = the_tree.GetBranch("vbfdijetpt_JetEnDown")
        #if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown" not in self.complained:
        if not self.vbfdijetpt_JetEnDown_branch and "vbfdijetpt_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfdijetpt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnDown")
        else:
            self.vbfdijetpt_JetEnDown_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnDown_value)

        #print "making vbfdijetpt_JetEnUp"
        self.vbfdijetpt_JetEnUp_branch = the_tree.GetBranch("vbfdijetpt_JetEnUp")
        #if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp" not in self.complained:
        if not self.vbfdijetpt_JetEnUp_branch and "vbfdijetpt_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfdijetpt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfdijetpt_JetEnUp")
        else:
            self.vbfdijetpt_JetEnUp_branch.SetAddress(<void*>&self.vbfdijetpt_JetEnUp_value)

        #print "making vbfj1eta"
        self.vbfj1eta_branch = the_tree.GetBranch("vbfj1eta")
        #if not self.vbfj1eta_branch and "vbfj1eta" not in self.complained:
        if not self.vbfj1eta_branch and "vbfj1eta":
            warnings.warn( "MuMuTree: Expected branch vbfj1eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta")
        else:
            self.vbfj1eta_branch.SetAddress(<void*>&self.vbfj1eta_value)

        #print "making vbfj1eta_JetEnDown"
        self.vbfj1eta_JetEnDown_branch = the_tree.GetBranch("vbfj1eta_JetEnDown")
        #if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown" not in self.complained:
        if not self.vbfj1eta_JetEnDown_branch and "vbfj1eta_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfj1eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnDown")
        else:
            self.vbfj1eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj1eta_JetEnDown_value)

        #print "making vbfj1eta_JetEnUp"
        self.vbfj1eta_JetEnUp_branch = the_tree.GetBranch("vbfj1eta_JetEnUp")
        #if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp" not in self.complained:
        if not self.vbfj1eta_JetEnUp_branch and "vbfj1eta_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfj1eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1eta_JetEnUp")
        else:
            self.vbfj1eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj1eta_JetEnUp_value)

        #print "making vbfj1pt"
        self.vbfj1pt_branch = the_tree.GetBranch("vbfj1pt")
        #if not self.vbfj1pt_branch and "vbfj1pt" not in self.complained:
        if not self.vbfj1pt_branch and "vbfj1pt":
            warnings.warn( "MuMuTree: Expected branch vbfj1pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt")
        else:
            self.vbfj1pt_branch.SetAddress(<void*>&self.vbfj1pt_value)

        #print "making vbfj1pt_JetEnDown"
        self.vbfj1pt_JetEnDown_branch = the_tree.GetBranch("vbfj1pt_JetEnDown")
        #if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown" not in self.complained:
        if not self.vbfj1pt_JetEnDown_branch and "vbfj1pt_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfj1pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnDown")
        else:
            self.vbfj1pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj1pt_JetEnDown_value)

        #print "making vbfj1pt_JetEnUp"
        self.vbfj1pt_JetEnUp_branch = the_tree.GetBranch("vbfj1pt_JetEnUp")
        #if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp" not in self.complained:
        if not self.vbfj1pt_JetEnUp_branch and "vbfj1pt_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfj1pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj1pt_JetEnUp")
        else:
            self.vbfj1pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj1pt_JetEnUp_value)

        #print "making vbfj2eta"
        self.vbfj2eta_branch = the_tree.GetBranch("vbfj2eta")
        #if not self.vbfj2eta_branch and "vbfj2eta" not in self.complained:
        if not self.vbfj2eta_branch and "vbfj2eta":
            warnings.warn( "MuMuTree: Expected branch vbfj2eta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta")
        else:
            self.vbfj2eta_branch.SetAddress(<void*>&self.vbfj2eta_value)

        #print "making vbfj2eta_JetEnDown"
        self.vbfj2eta_JetEnDown_branch = the_tree.GetBranch("vbfj2eta_JetEnDown")
        #if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown" not in self.complained:
        if not self.vbfj2eta_JetEnDown_branch and "vbfj2eta_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfj2eta_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnDown")
        else:
            self.vbfj2eta_JetEnDown_branch.SetAddress(<void*>&self.vbfj2eta_JetEnDown_value)

        #print "making vbfj2eta_JetEnUp"
        self.vbfj2eta_JetEnUp_branch = the_tree.GetBranch("vbfj2eta_JetEnUp")
        #if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp" not in self.complained:
        if not self.vbfj2eta_JetEnUp_branch and "vbfj2eta_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfj2eta_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2eta_JetEnUp")
        else:
            self.vbfj2eta_JetEnUp_branch.SetAddress(<void*>&self.vbfj2eta_JetEnUp_value)

        #print "making vbfj2pt"
        self.vbfj2pt_branch = the_tree.GetBranch("vbfj2pt")
        #if not self.vbfj2pt_branch and "vbfj2pt" not in self.complained:
        if not self.vbfj2pt_branch and "vbfj2pt":
            warnings.warn( "MuMuTree: Expected branch vbfj2pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt")
        else:
            self.vbfj2pt_branch.SetAddress(<void*>&self.vbfj2pt_value)

        #print "making vbfj2pt_JetEnDown"
        self.vbfj2pt_JetEnDown_branch = the_tree.GetBranch("vbfj2pt_JetEnDown")
        #if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown" not in self.complained:
        if not self.vbfj2pt_JetEnDown_branch and "vbfj2pt_JetEnDown":
            warnings.warn( "MuMuTree: Expected branch vbfj2pt_JetEnDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnDown")
        else:
            self.vbfj2pt_JetEnDown_branch.SetAddress(<void*>&self.vbfj2pt_JetEnDown_value)

        #print "making vbfj2pt_JetEnUp"
        self.vbfj2pt_JetEnUp_branch = the_tree.GetBranch("vbfj2pt_JetEnUp")
        #if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp" not in self.complained:
        if not self.vbfj2pt_JetEnUp_branch and "vbfj2pt_JetEnUp":
            warnings.warn( "MuMuTree: Expected branch vbfj2pt_JetEnUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vbfj2pt_JetEnUp")
        else:
            self.vbfj2pt_JetEnUp_branch.SetAddress(<void*>&self.vbfj2pt_JetEnUp_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "MuMuTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "MuMuTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making idx"
        self.idx_branch = the_tree.GetBranch("idx")
        #if not self.idx_branch and "idx" not in self.complained:
        if not self.idx_branch and "idx":
            warnings.warn( "MuMuTree: Expected branch idx does not exist!"                " It will crash if you try and use it!",Warning)
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

    property Flag_badCloneMuonFilter:
        def __get__(self):
            self.Flag_badCloneMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_badCloneMuonFilter_value

    property Flag_badGlobalMuonFilter:
        def __get__(self):
            self.Flag_badGlobalMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_badGlobalMuonFilter_value

    property Flag_badMuons:
        def __get__(self):
            self.Flag_badMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_badMuons_value

    property Flag_duplicateMuons:
        def __get__(self):
            self.Flag_duplicateMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_duplicateMuons_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_globalTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalTightHalo2016Filter_value

    property Flag_goodVertices:
        def __get__(self):
            self.Flag_goodVertices_branch.GetEntry(self.localentry, 0)
            return self.Flag_goodVertices_value

    property Flag_noBadMuons:
        def __get__(self):
            self.Flag_noBadMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_noBadMuons_value

    property GenWeight:
        def __get__(self):
            self.GenWeight_branch.GetEntry(self.localentry, 0)
            return self.GenWeight_value

    property Ht:
        def __get__(self):
            self.Ht_branch.GetEntry(self.localentry, 0)
            return self.Ht_value

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

    property doubleESingleMuGroup:
        def __get__(self):
            self.doubleESingleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuGroup_value

    property doubleESingleMuPass:
        def __get__(self):
            self.doubleESingleMuPass_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuPass_value

    property doubleESingleMuPrescale:
        def __get__(self):
            self.doubleESingleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleESingleMuPrescale_value

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

    property doubleLooseIsoTau35Group:
        def __get__(self):
            self.doubleLooseIsoTau35Group_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau35Group_value

    property doubleLooseIsoTau35Pass:
        def __get__(self):
            self.doubleLooseIsoTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau35Pass_value

    property doubleLooseIsoTau35Prescale:
        def __get__(self):
            self.doubleLooseIsoTau35Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau35Prescale_value

    property doubleLooseIsoTau40Group:
        def __get__(self):
            self.doubleLooseIsoTau40Group_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau40Group_value

    property doubleLooseIsoTau40Pass:
        def __get__(self):
            self.doubleLooseIsoTau40Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau40Pass_value

    property doubleLooseIsoTau40Prescale:
        def __get__(self):
            self.doubleLooseIsoTau40Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleLooseIsoTau40Prescale_value

    property doubleMuGroup:
        def __get__(self):
            self.doubleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuGroup_value

    property doubleMuPass:
        def __get__(self):
            self.doubleMuPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPass_value

    property doubleMuPrescale:
        def __get__(self):
            self.doubleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuPrescale_value

    property doubleMuSingleEGroup:
        def __get__(self):
            self.doubleMuSingleEGroup_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEGroup_value

    property doubleMuSingleEPass:
        def __get__(self):
            self.doubleMuSingleEPass_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPass_value

    property doubleMuSingleEPrescale:
        def __get__(self):
            self.doubleMuSingleEPrescale_branch.GetEntry(self.localentry, 0)
            return self.doubleMuSingleEPrescale_value

    property doubleTau35Group:
        def __get__(self):
            self.doubleTau35Group_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Group_value

    property doubleTau35Pass:
        def __get__(self):
            self.doubleTau35Pass_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Pass_value

    property doubleTau35Prescale:
        def __get__(self):
            self.doubleTau35Prescale_branch.GetEntry(self.localentry, 0)
            return self.doubleTau35Prescale_value

    property eVetoMVAIso:
        def __get__(self):
            self.eVetoMVAIso_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIso_value

    property eVetoMVAIsoVtx:
        def __get__(self):
            self.eVetoMVAIsoVtx_branch.GetEntry(self.localentry, 0)
            return self.eVetoMVAIsoVtx_value

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

    property j1csv:
        def __get__(self):
            self.j1csv_branch.GetEntry(self.localentry, 0)
            return self.j1csv_value

    property j1eta:
        def __get__(self):
            self.j1eta_branch.GetEntry(self.localentry, 0)
            return self.j1eta_value

    property j1hadronflavor:
        def __get__(self):
            self.j1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j1hadronflavor_value

    property j1partonflavor:
        def __get__(self):
            self.j1partonflavor_branch.GetEntry(self.localentry, 0)
            return self.j1partonflavor_value

    property j1phi:
        def __get__(self):
            self.j1phi_branch.GetEntry(self.localentry, 0)
            return self.j1phi_value

    property j1pt:
        def __get__(self):
            self.j1pt_branch.GetEntry(self.localentry, 0)
            return self.j1pt_value

    property j1ptDown:
        def __get__(self):
            self.j1ptDown_branch.GetEntry(self.localentry, 0)
            return self.j1ptDown_value

    property j1ptUp:
        def __get__(self):
            self.j1ptUp_branch.GetEntry(self.localentry, 0)
            return self.j1ptUp_value

    property j1pu:
        def __get__(self):
            self.j1pu_branch.GetEntry(self.localentry, 0)
            return self.j1pu_value

    property j1rawf:
        def __get__(self):
            self.j1rawf_branch.GetEntry(self.localentry, 0)
            return self.j1rawf_value

    property j2csv:
        def __get__(self):
            self.j2csv_branch.GetEntry(self.localentry, 0)
            return self.j2csv_value

    property j2eta:
        def __get__(self):
            self.j2eta_branch.GetEntry(self.localentry, 0)
            return self.j2eta_value

    property j2hadronflavor:
        def __get__(self):
            self.j2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.j2hadronflavor_value

    property j2partonflavor:
        def __get__(self):
            self.j2partonflavor_branch.GetEntry(self.localentry, 0)
            return self.j2partonflavor_value

    property j2phi:
        def __get__(self):
            self.j2phi_branch.GetEntry(self.localentry, 0)
            return self.j2phi_value

    property j2pt:
        def __get__(self):
            self.j2pt_branch.GetEntry(self.localentry, 0)
            return self.j2pt_value

    property j2ptDown:
        def __get__(self):
            self.j2ptDown_branch.GetEntry(self.localentry, 0)
            return self.j2ptDown_value

    property j2ptUp:
        def __get__(self):
            self.j2ptUp_branch.GetEntry(self.localentry, 0)
            return self.j2ptUp_value

    property j2pu:
        def __get__(self):
            self.j2pu_branch.GetEntry(self.localentry, 0)
            return self.j2pu_value

    property j2rawf:
        def __get__(self):
            self.j2rawf_branch.GetEntry(self.localentry, 0)
            return self.j2rawf_value

    property jb1csv:
        def __get__(self):
            self.jb1csv_branch.GetEntry(self.localentry, 0)
            return self.jb1csv_value

    property jb1csv_CSVL:
        def __get__(self):
            self.jb1csv_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1csv_CSVL_value

    property jb1eta:
        def __get__(self):
            self.jb1eta_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_value

    property jb1eta_CSVL:
        def __get__(self):
            self.jb1eta_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1eta_CSVL_value

    property jb1hadronflavor:
        def __get__(self):
            self.jb1hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_value

    property jb1hadronflavor_CSVL:
        def __get__(self):
            self.jb1hadronflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1hadronflavor_CSVL_value

    property jb1partonflavor:
        def __get__(self):
            self.jb1partonflavor_branch.GetEntry(self.localentry, 0)
            return self.jb1partonflavor_value

    property jb1partonflavor_CSVL:
        def __get__(self):
            self.jb1partonflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1partonflavor_CSVL_value

    property jb1phi:
        def __get__(self):
            self.jb1phi_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_value

    property jb1phi_CSVL:
        def __get__(self):
            self.jb1phi_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1phi_CSVL_value

    property jb1pt:
        def __get__(self):
            self.jb1pt_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_value

    property jb1ptDown:
        def __get__(self):
            self.jb1ptDown_branch.GetEntry(self.localentry, 0)
            return self.jb1ptDown_value

    property jb1ptDown_CSVL:
        def __get__(self):
            self.jb1ptDown_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1ptDown_CSVL_value

    property jb1ptUp:
        def __get__(self):
            self.jb1ptUp_branch.GetEntry(self.localentry, 0)
            return self.jb1ptUp_value

    property jb1ptUp_CSVL:
        def __get__(self):
            self.jb1ptUp_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1ptUp_CSVL_value

    property jb1pt_CSVL:
        def __get__(self):
            self.jb1pt_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1pt_CSVL_value

    property jb1pu:
        def __get__(self):
            self.jb1pu_branch.GetEntry(self.localentry, 0)
            return self.jb1pu_value

    property jb1pu_CSVL:
        def __get__(self):
            self.jb1pu_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1pu_CSVL_value

    property jb1rawf:
        def __get__(self):
            self.jb1rawf_branch.GetEntry(self.localentry, 0)
            return self.jb1rawf_value

    property jb1rawf_CSVL:
        def __get__(self):
            self.jb1rawf_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb1rawf_CSVL_value

    property jb2csv:
        def __get__(self):
            self.jb2csv_branch.GetEntry(self.localentry, 0)
            return self.jb2csv_value

    property jb2csv_CSVL:
        def __get__(self):
            self.jb2csv_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2csv_CSVL_value

    property jb2eta:
        def __get__(self):
            self.jb2eta_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_value

    property jb2eta_CSVL:
        def __get__(self):
            self.jb2eta_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2eta_CSVL_value

    property jb2hadronflavor:
        def __get__(self):
            self.jb2hadronflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_value

    property jb2hadronflavor_CSVL:
        def __get__(self):
            self.jb2hadronflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2hadronflavor_CSVL_value

    property jb2partonflavor:
        def __get__(self):
            self.jb2partonflavor_branch.GetEntry(self.localentry, 0)
            return self.jb2partonflavor_value

    property jb2partonflavor_CSVL:
        def __get__(self):
            self.jb2partonflavor_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2partonflavor_CSVL_value

    property jb2phi:
        def __get__(self):
            self.jb2phi_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_value

    property jb2phi_CSVL:
        def __get__(self):
            self.jb2phi_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2phi_CSVL_value

    property jb2pt:
        def __get__(self):
            self.jb2pt_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_value

    property jb2ptDown:
        def __get__(self):
            self.jb2ptDown_branch.GetEntry(self.localentry, 0)
            return self.jb2ptDown_value

    property jb2ptDown_CSVL:
        def __get__(self):
            self.jb2ptDown_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2ptDown_CSVL_value

    property jb2ptUp:
        def __get__(self):
            self.jb2ptUp_branch.GetEntry(self.localentry, 0)
            return self.jb2ptUp_value

    property jb2ptUp_CSVL:
        def __get__(self):
            self.jb2ptUp_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2ptUp_CSVL_value

    property jb2pt_CSVL:
        def __get__(self):
            self.jb2pt_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2pt_CSVL_value

    property jb2pu:
        def __get__(self):
            self.jb2pu_branch.GetEntry(self.localentry, 0)
            return self.jb2pu_value

    property jb2pu_CSVL:
        def __get__(self):
            self.jb2pu_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2pu_CSVL_value

    property jb2rawf:
        def __get__(self):
            self.jb2rawf_branch.GetEntry(self.localentry, 0)
            return self.jb2rawf_value

    property jb2rawf_CSVL:
        def __get__(self):
            self.jb2rawf_CSVL_branch.GetEntry(self.localentry, 0)
            return self.jb2rawf_CSVL_value

    property jetVeto20:
        def __get__(self):
            self.jetVeto20_branch.GetEntry(self.localentry, 0)
            return self.jetVeto20_value

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

    property jetVeto30_JetSubTotalAbsoluteDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalAbsoluteDown_value

    property jetVeto30_JetSubTotalAbsoluteUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalAbsoluteUp_value

    property jetVeto30_JetSubTotalMCDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalMCDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalMCDown_value

    property jetVeto30_JetSubTotalMCUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalMCUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalMCUp_value

    property jetVeto30_JetSubTotalPileUpDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalPileUpDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPileUpDown_value

    property jetVeto30_JetSubTotalPileUpUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalPileUpUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPileUpUp_value

    property jetVeto30_JetSubTotalPtDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalPtDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPtDown_value

    property jetVeto30_JetSubTotalPtUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalPtUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalPtUp_value

    property jetVeto30_JetSubTotalRelativeDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalRelativeDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalRelativeDown_value

    property jetVeto30_JetSubTotalRelativeUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalRelativeUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalRelativeUp_value

    property jetVeto30_JetSubTotalScaleDown:
        def __get__(self):
            self.jetVeto30_JetSubTotalScaleDown_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalScaleDown_value

    property jetVeto30_JetSubTotalScaleUp:
        def __get__(self):
            self.jetVeto30_JetSubTotalScaleUp_branch.GetEntry(self.localentry, 0)
            return self.jetVeto30_JetSubTotalScaleUp_value

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

    property m1AbsEta:
        def __get__(self):
            self.m1AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m1AbsEta_value

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

    property m1DPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_ElectronEnDown_value

    property m1DPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_ElectronEnUp_value

    property m1DPhiToPfMet_JetEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetEnDown_value

    property m1DPhiToPfMet_JetEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetEnUp_value

    property m1DPhiToPfMet_JetResDown:
        def __get__(self):
            self.m1DPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetResDown_value

    property m1DPhiToPfMet_JetResUp:
        def __get__(self):
            self.m1DPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_JetResUp_value

    property m1DPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_MuonEnDown_value

    property m1DPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_MuonEnUp_value

    property m1DPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_PhotonEnDown_value

    property m1DPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_PhotonEnUp_value

    property m1DPhiToPfMet_TauEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_TauEnDown_value

    property m1DPhiToPfMet_TauEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_TauEnUp_value

    property m1DPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m1DPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_UnclusteredEnDown_value

    property m1DPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m1DPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_UnclusteredEnUp_value

    property m1DPhiToPfMet_type1:
        def __get__(self):
            self.m1DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m1DPhiToPfMet_type1_value

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

    property m1ErsatzGenEta:
        def __get__(self):
            self.m1ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenEta_value

    property m1ErsatzGenM:
        def __get__(self):
            self.m1ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenM_value

    property m1ErsatzGenPhi:
        def __get__(self):
            self.m1ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenPhi_value

    property m1ErsatzGenpT:
        def __get__(self):
            self.m1ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpT_value

    property m1ErsatzGenpX:
        def __get__(self):
            self.m1ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpX_value

    property m1ErsatzGenpY:
        def __get__(self):
            self.m1ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzGenpY_value

    property m1ErsatzVispX:
        def __get__(self):
            self.m1ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzVispX_value

    property m1ErsatzVispY:
        def __get__(self):
            self.m1ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.m1ErsatzVispY_value

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

    property m1MatchesDoubleESingleMu:
        def __get__(self):
            self.m1MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleESingleMu_value

    property m1MatchesDoubleMu:
        def __get__(self):
            self.m1MatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMu_value

    property m1MatchesDoubleMuSingleE:
        def __get__(self):
            self.m1MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesDoubleMuSingleE_value

    property m1MatchesIsoMu24Path:
        def __get__(self):
            self.m1MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24Path_value

    property m1MatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.m1MatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesIsoMu24eta2p1Path_value

    property m1MatchesMu19Tau20Filter:
        def __get__(self):
            self.m1MatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20Filter_value

    property m1MatchesMu19Tau20Path:
        def __get__(self):
            self.m1MatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20Path_value

    property m1MatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.m1MatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20sL1Filter_value

    property m1MatchesMu19Tau20sL1Path:
        def __get__(self):
            self.m1MatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu19Tau20sL1Path_value

    property m1MatchesMu21Tau20sL1Filter:
        def __get__(self):
            self.m1MatchesMu21Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu21Tau20sL1Filter_value

    property m1MatchesMu21Tau20sL1Path:
        def __get__(self):
            self.m1MatchesMu21Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu21Tau20sL1Path_value

    property m1MatchesMu23Ele12DZPath:
        def __get__(self):
            self.m1MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23Ele12DZPath_value

    property m1MatchesMu23Ele12Path:
        def __get__(self):
            self.m1MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu23Ele12Path_value

    property m1MatchesMu8Ele23DZPath:
        def __get__(self):
            self.m1MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele23DZPath_value

    property m1MatchesMu8Ele23Path:
        def __get__(self):
            self.m1MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesMu8Ele23Path_value

    property m1MatchesSingleESingleMu:
        def __get__(self):
            self.m1MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleESingleMu_value

    property m1MatchesSingleMu:
        def __get__(self):
            self.m1MatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_value

    property m1MatchesSingleMuIso20:
        def __get__(self):
            self.m1MatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuIso20_value

    property m1MatchesSingleMuIsoTk20:
        def __get__(self):
            self.m1MatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuIsoTk20_value

    property m1MatchesSingleMuSingleE:
        def __get__(self):
            self.m1MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMuSingleE_value

    property m1MatchesSingleMu_leg1:
        def __get__(self):
            self.m1MatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg1_value

    property m1MatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.m1MatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg1_noiso_value

    property m1MatchesSingleMu_leg2:
        def __get__(self):
            self.m1MatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg2_value

    property m1MatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.m1MatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesSingleMu_leg2_noiso_value

    property m1MatchesTripleMu:
        def __get__(self):
            self.m1MatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.m1MatchesTripleMu_value

    property m1MtToPfMet_ElectronEnDown:
        def __get__(self):
            self.m1MtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_ElectronEnDown_value

    property m1MtToPfMet_ElectronEnUp:
        def __get__(self):
            self.m1MtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_ElectronEnUp_value

    property m1MtToPfMet_JetEnDown:
        def __get__(self):
            self.m1MtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetEnDown_value

    property m1MtToPfMet_JetEnUp:
        def __get__(self):
            self.m1MtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetEnUp_value

    property m1MtToPfMet_JetResDown:
        def __get__(self):
            self.m1MtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetResDown_value

    property m1MtToPfMet_JetResUp:
        def __get__(self):
            self.m1MtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_JetResUp_value

    property m1MtToPfMet_MuonEnDown:
        def __get__(self):
            self.m1MtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_MuonEnDown_value

    property m1MtToPfMet_MuonEnUp:
        def __get__(self):
            self.m1MtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_MuonEnUp_value

    property m1MtToPfMet_PhotonEnDown:
        def __get__(self):
            self.m1MtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_PhotonEnDown_value

    property m1MtToPfMet_PhotonEnUp:
        def __get__(self):
            self.m1MtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_PhotonEnUp_value

    property m1MtToPfMet_Raw:
        def __get__(self):
            self.m1MtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_Raw_value

    property m1MtToPfMet_TauEnDown:
        def __get__(self):
            self.m1MtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_TauEnDown_value

    property m1MtToPfMet_TauEnUp:
        def __get__(self):
            self.m1MtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_TauEnUp_value

    property m1MtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m1MtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_UnclusteredEnDown_value

    property m1MtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m1MtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_UnclusteredEnUp_value

    property m1MtToPfMet_type1:
        def __get__(self):
            self.m1MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m1MtToPfMet_type1_value

    property m1Mu23Ele12DZFilter:
        def __get__(self):
            self.m1Mu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu23Ele12DZFilter_value

    property m1Mu23Ele12Filter:
        def __get__(self):
            self.m1Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu23Ele12Filter_value

    property m1Mu8Ele23DZFilter:
        def __get__(self):
            self.m1Mu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu8Ele23DZFilter_value

    property m1Mu8Ele23Filter:
        def __get__(self):
            self.m1Mu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.m1Mu8Ele23Filter_value

    property m1MuonHits:
        def __get__(self):
            self.m1MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m1MuonHits_value

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

    property m1Rank:
        def __get__(self):
            self.m1Rank_branch.GetEntry(self.localentry, 0)
            return self.m1Rank_value

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

    property m1_m2_CosThetaStar:
        def __get__(self):
            self.m1_m2_CosThetaStar_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_CosThetaStar_value

    property m1_m2_DPhi:
        def __get__(self):
            self.m1_m2_DPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DPhi_value

    property m1_m2_DR:
        def __get__(self):
            self.m1_m2_DR_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_DR_value

    property m1_m2_Eta:
        def __get__(self):
            self.m1_m2_Eta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Eta_value

    property m1_m2_Mass:
        def __get__(self):
            self.m1_m2_Mass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_value

    property m1_m2_Mass_TauEnDown:
        def __get__(self):
            self.m1_m2_Mass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_TauEnDown_value

    property m1_m2_Mass_TauEnUp:
        def __get__(self):
            self.m1_m2_Mass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mass_TauEnUp_value

    property m1_m2_Mt:
        def __get__(self):
            self.m1_m2_Mt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_value

    property m1_m2_MtTotal:
        def __get__(self):
            self.m1_m2_MtTotal_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MtTotal_value

    property m1_m2_Mt_TauEnDown:
        def __get__(self):
            self.m1_m2_Mt_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_TauEnDown_value

    property m1_m2_Mt_TauEnUp:
        def __get__(self):
            self.m1_m2_Mt_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Mt_TauEnUp_value

    property m1_m2_MvaMet:
        def __get__(self):
            self.m1_m2_MvaMet_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMet_value

    property m1_m2_MvaMetCovMatrix00:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix00_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix00_value

    property m1_m2_MvaMetCovMatrix01:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix01_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix01_value

    property m1_m2_MvaMetCovMatrix10:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix10_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix10_value

    property m1_m2_MvaMetCovMatrix11:
        def __get__(self):
            self.m1_m2_MvaMetCovMatrix11_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetCovMatrix11_value

    property m1_m2_MvaMetPhi:
        def __get__(self):
            self.m1_m2_MvaMetPhi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_MvaMetPhi_value

    property m1_m2_PZeta:
        def __get__(self):
            self.m1_m2_PZeta_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZeta_value

    property m1_m2_PZetaLess0p85PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaLess0p85PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaLess0p85PZetaVis_value

    property m1_m2_PZetaVis:
        def __get__(self):
            self.m1_m2_PZetaVis_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_PZetaVis_value

    property m1_m2_Phi:
        def __get__(self):
            self.m1_m2_Phi_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Phi_value

    property m1_m2_Pt:
        def __get__(self):
            self.m1_m2_Pt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_Pt_value

    property m1_m2_SS:
        def __get__(self):
            self.m1_m2_SS_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_SS_value

    property m1_m2_ToMETDPhi_Ty1:
        def __get__(self):
            self.m1_m2_ToMETDPhi_Ty1_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_ToMETDPhi_Ty1_value

    property m1_m2_collinearmass:
        def __get__(self):
            self.m1_m2_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_value

    property m1_m2_collinearmass_CheckUESDown:
        def __get__(self):
            self.m1_m2_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_CheckUESDown_value

    property m1_m2_collinearmass_CheckUESUp:
        def __get__(self):
            self.m1_m2_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_CheckUESUp_value

    property m1_m2_collinearmass_EleEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnDown_value

    property m1_m2_collinearmass_EleEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_EleEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_EleEnUp_value

    property m1_m2_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m1_m2_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetCheckTotalDown_value

    property m1_m2_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m1_m2_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetCheckTotalUp_value

    property m1_m2_collinearmass_JetEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetEnDown_value

    property m1_m2_collinearmass_JetEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_JetEnUp_value

    property m1_m2_collinearmass_MuEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_MuEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_MuEnDown_value

    property m1_m2_collinearmass_MuEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_MuEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_MuEnUp_value

    property m1_m2_collinearmass_TauEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_TauEnDown_value

    property m1_m2_collinearmass_TauEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_TauEnUp_value

    property m1_m2_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m1_m2_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_UnclusteredEnDown_value

    property m1_m2_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m1_m2_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_collinearmass_UnclusteredEnUp_value

    property m1_m2_pt_tt:
        def __get__(self):
            self.m1_m2_pt_tt_branch.GetEntry(self.localentry, 0)
            return self.m1_m2_pt_tt_value

    property m2AbsEta:
        def __get__(self):
            self.m2AbsEta_branch.GetEntry(self.localentry, 0)
            return self.m2AbsEta_value

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

    property m2DPhiToPfMet_ElectronEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_ElectronEnDown_value

    property m2DPhiToPfMet_ElectronEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_ElectronEnUp_value

    property m2DPhiToPfMet_JetEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetEnDown_value

    property m2DPhiToPfMet_JetEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetEnUp_value

    property m2DPhiToPfMet_JetResDown:
        def __get__(self):
            self.m2DPhiToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetResDown_value

    property m2DPhiToPfMet_JetResUp:
        def __get__(self):
            self.m2DPhiToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_JetResUp_value

    property m2DPhiToPfMet_MuonEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_MuonEnDown_value

    property m2DPhiToPfMet_MuonEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_MuonEnUp_value

    property m2DPhiToPfMet_PhotonEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_PhotonEnDown_value

    property m2DPhiToPfMet_PhotonEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_PhotonEnUp_value

    property m2DPhiToPfMet_TauEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_TauEnDown_value

    property m2DPhiToPfMet_TauEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_TauEnUp_value

    property m2DPhiToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m2DPhiToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_UnclusteredEnDown_value

    property m2DPhiToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m2DPhiToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_UnclusteredEnUp_value

    property m2DPhiToPfMet_type1:
        def __get__(self):
            self.m2DPhiToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m2DPhiToPfMet_type1_value

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

    property m2ErsatzGenEta:
        def __get__(self):
            self.m2ErsatzGenEta_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenEta_value

    property m2ErsatzGenM:
        def __get__(self):
            self.m2ErsatzGenM_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenM_value

    property m2ErsatzGenPhi:
        def __get__(self):
            self.m2ErsatzGenPhi_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenPhi_value

    property m2ErsatzGenpT:
        def __get__(self):
            self.m2ErsatzGenpT_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpT_value

    property m2ErsatzGenpX:
        def __get__(self):
            self.m2ErsatzGenpX_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpX_value

    property m2ErsatzGenpY:
        def __get__(self):
            self.m2ErsatzGenpY_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzGenpY_value

    property m2ErsatzVispX:
        def __get__(self):
            self.m2ErsatzVispX_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzVispX_value

    property m2ErsatzVispY:
        def __get__(self):
            self.m2ErsatzVispY_branch.GetEntry(self.localentry, 0)
            return self.m2ErsatzVispY_value

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

    property m2MatchesDoubleESingleMu:
        def __get__(self):
            self.m2MatchesDoubleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleESingleMu_value

    property m2MatchesDoubleMu:
        def __get__(self):
            self.m2MatchesDoubleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMu_value

    property m2MatchesDoubleMuSingleE:
        def __get__(self):
            self.m2MatchesDoubleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesDoubleMuSingleE_value

    property m2MatchesIsoMu24Path:
        def __get__(self):
            self.m2MatchesIsoMu24Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24Path_value

    property m2MatchesIsoMu24eta2p1Path:
        def __get__(self):
            self.m2MatchesIsoMu24eta2p1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesIsoMu24eta2p1Path_value

    property m2MatchesMu19Tau20Filter:
        def __get__(self):
            self.m2MatchesMu19Tau20Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20Filter_value

    property m2MatchesMu19Tau20Path:
        def __get__(self):
            self.m2MatchesMu19Tau20Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20Path_value

    property m2MatchesMu19Tau20sL1Filter:
        def __get__(self):
            self.m2MatchesMu19Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20sL1Filter_value

    property m2MatchesMu19Tau20sL1Path:
        def __get__(self):
            self.m2MatchesMu19Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu19Tau20sL1Path_value

    property m2MatchesMu21Tau20sL1Filter:
        def __get__(self):
            self.m2MatchesMu21Tau20sL1Filter_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu21Tau20sL1Filter_value

    property m2MatchesMu21Tau20sL1Path:
        def __get__(self):
            self.m2MatchesMu21Tau20sL1Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu21Tau20sL1Path_value

    property m2MatchesMu23Ele12DZPath:
        def __get__(self):
            self.m2MatchesMu23Ele12DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23Ele12DZPath_value

    property m2MatchesMu23Ele12Path:
        def __get__(self):
            self.m2MatchesMu23Ele12Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu23Ele12Path_value

    property m2MatchesMu8Ele23DZPath:
        def __get__(self):
            self.m2MatchesMu8Ele23DZPath_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele23DZPath_value

    property m2MatchesMu8Ele23Path:
        def __get__(self):
            self.m2MatchesMu8Ele23Path_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesMu8Ele23Path_value

    property m2MatchesSingleESingleMu:
        def __get__(self):
            self.m2MatchesSingleESingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleESingleMu_value

    property m2MatchesSingleMu:
        def __get__(self):
            self.m2MatchesSingleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_value

    property m2MatchesSingleMuIso20:
        def __get__(self):
            self.m2MatchesSingleMuIso20_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuIso20_value

    property m2MatchesSingleMuIsoTk20:
        def __get__(self):
            self.m2MatchesSingleMuIsoTk20_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuIsoTk20_value

    property m2MatchesSingleMuSingleE:
        def __get__(self):
            self.m2MatchesSingleMuSingleE_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMuSingleE_value

    property m2MatchesSingleMu_leg1:
        def __get__(self):
            self.m2MatchesSingleMu_leg1_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg1_value

    property m2MatchesSingleMu_leg1_noiso:
        def __get__(self):
            self.m2MatchesSingleMu_leg1_noiso_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg1_noiso_value

    property m2MatchesSingleMu_leg2:
        def __get__(self):
            self.m2MatchesSingleMu_leg2_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg2_value

    property m2MatchesSingleMu_leg2_noiso:
        def __get__(self):
            self.m2MatchesSingleMu_leg2_noiso_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesSingleMu_leg2_noiso_value

    property m2MatchesTripleMu:
        def __get__(self):
            self.m2MatchesTripleMu_branch.GetEntry(self.localentry, 0)
            return self.m2MatchesTripleMu_value

    property m2MtToPfMet_ElectronEnDown:
        def __get__(self):
            self.m2MtToPfMet_ElectronEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_ElectronEnDown_value

    property m2MtToPfMet_ElectronEnUp:
        def __get__(self):
            self.m2MtToPfMet_ElectronEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_ElectronEnUp_value

    property m2MtToPfMet_JetEnDown:
        def __get__(self):
            self.m2MtToPfMet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetEnDown_value

    property m2MtToPfMet_JetEnUp:
        def __get__(self):
            self.m2MtToPfMet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetEnUp_value

    property m2MtToPfMet_JetResDown:
        def __get__(self):
            self.m2MtToPfMet_JetResDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetResDown_value

    property m2MtToPfMet_JetResUp:
        def __get__(self):
            self.m2MtToPfMet_JetResUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_JetResUp_value

    property m2MtToPfMet_MuonEnDown:
        def __get__(self):
            self.m2MtToPfMet_MuonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_MuonEnDown_value

    property m2MtToPfMet_MuonEnUp:
        def __get__(self):
            self.m2MtToPfMet_MuonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_MuonEnUp_value

    property m2MtToPfMet_PhotonEnDown:
        def __get__(self):
            self.m2MtToPfMet_PhotonEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_PhotonEnDown_value

    property m2MtToPfMet_PhotonEnUp:
        def __get__(self):
            self.m2MtToPfMet_PhotonEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_PhotonEnUp_value

    property m2MtToPfMet_Raw:
        def __get__(self):
            self.m2MtToPfMet_Raw_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_Raw_value

    property m2MtToPfMet_TauEnDown:
        def __get__(self):
            self.m2MtToPfMet_TauEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_TauEnDown_value

    property m2MtToPfMet_TauEnUp:
        def __get__(self):
            self.m2MtToPfMet_TauEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_TauEnUp_value

    property m2MtToPfMet_UnclusteredEnDown:
        def __get__(self):
            self.m2MtToPfMet_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_UnclusteredEnDown_value

    property m2MtToPfMet_UnclusteredEnUp:
        def __get__(self):
            self.m2MtToPfMet_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_UnclusteredEnUp_value

    property m2MtToPfMet_type1:
        def __get__(self):
            self.m2MtToPfMet_type1_branch.GetEntry(self.localentry, 0)
            return self.m2MtToPfMet_type1_value

    property m2Mu23Ele12DZFilter:
        def __get__(self):
            self.m2Mu23Ele12DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu23Ele12DZFilter_value

    property m2Mu23Ele12Filter:
        def __get__(self):
            self.m2Mu23Ele12Filter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu23Ele12Filter_value

    property m2Mu8Ele23DZFilter:
        def __get__(self):
            self.m2Mu8Ele23DZFilter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu8Ele23DZFilter_value

    property m2Mu8Ele23Filter:
        def __get__(self):
            self.m2Mu8Ele23Filter_branch.GetEntry(self.localentry, 0)
            return self.m2Mu8Ele23Filter_value

    property m2MuonHits:
        def __get__(self):
            self.m2MuonHits_branch.GetEntry(self.localentry, 0)
            return self.m2MuonHits_value

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

    property m2Rank:
        def __get__(self):
            self.m2Rank_branch.GetEntry(self.localentry, 0)
            return self.m2Rank_value

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

    property m2_m1_collinearmass:
        def __get__(self):
            self.m2_m1_collinearmass_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_value

    property m2_m1_collinearmass_CheckUESDown:
        def __get__(self):
            self.m2_m1_collinearmass_CheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_CheckUESDown_value

    property m2_m1_collinearmass_CheckUESUp:
        def __get__(self):
            self.m2_m1_collinearmass_CheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_CheckUESUp_value

    property m2_m1_collinearmass_JetCheckTotalDown:
        def __get__(self):
            self.m2_m1_collinearmass_JetCheckTotalDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetCheckTotalDown_value

    property m2_m1_collinearmass_JetCheckTotalUp:
        def __get__(self):
            self.m2_m1_collinearmass_JetCheckTotalUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetCheckTotalUp_value

    property m2_m1_collinearmass_JetEnDown:
        def __get__(self):
            self.m2_m1_collinearmass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetEnDown_value

    property m2_m1_collinearmass_JetEnUp:
        def __get__(self):
            self.m2_m1_collinearmass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_JetEnUp_value

    property m2_m1_collinearmass_UnclusteredEnDown:
        def __get__(self):
            self.m2_m1_collinearmass_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_UnclusteredEnDown_value

    property m2_m1_collinearmass_UnclusteredEnUp:
        def __get__(self):
            self.m2_m1_collinearmass_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.m2_m1_collinearmass_UnclusteredEnUp_value

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

    property muGlbIsoVetoPt10:
        def __get__(self):
            self.muGlbIsoVetoPt10_branch.GetEntry(self.localentry, 0)
            return self.muGlbIsoVetoPt10_value

    property muVetoPt15IsoIdVtx:
        def __get__(self):
            self.muVetoPt15IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt15IsoIdVtx_value

    property muVetoPt5:
        def __get__(self):
            self.muVetoPt5_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5_value

    property muVetoPt5IsoIdVtx:
        def __get__(self):
            self.muVetoPt5IsoIdVtx_branch.GetEntry(self.localentry, 0)
            return self.muVetoPt5IsoIdVtx_value

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

    property singleE24SingleLooseIsoTau30Group:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30Group_value

    property singleE24SingleLooseIsoTau30Pass:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30Pass_value

    property singleE24SingleLooseIsoTau30Prescale:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30Prescale_value

    property singleE24SingleLooseIsoTau30TightIDGroup:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30TightIDGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30TightIDGroup_value

    property singleE24SingleLooseIsoTau30TightIDPass:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30TightIDPass_value

    property singleE24SingleLooseIsoTau30TightIDPrescale:
        def __get__(self):
            self.singleE24SingleLooseIsoTau30TightIDPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleLooseIsoTau30TightIDPrescale_value

    property singleE24SingleMediumIsoTau30Group:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30Group_value

    property singleE24SingleMediumIsoTau30Pass:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30Pass_value

    property singleE24SingleMediumIsoTau30Prescale:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30Prescale_value

    property singleE24SingleMediumIsoTau30TightIDGroup:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30TightIDGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30TightIDGroup_value

    property singleE24SingleMediumIsoTau30TightIDPass:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30TightIDPass_value

    property singleE24SingleMediumIsoTau30TightIDPrescale:
        def __get__(self):
            self.singleE24SingleMediumIsoTau30TightIDPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleMediumIsoTau30TightIDPrescale_value

    property singleE24SingleTightIsoTau30Group:
        def __get__(self):
            self.singleE24SingleTightIsoTau30Group_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30Group_value

    property singleE24SingleTightIsoTau30Pass:
        def __get__(self):
            self.singleE24SingleTightIsoTau30Pass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30Pass_value

    property singleE24SingleTightIsoTau30Prescale:
        def __get__(self):
            self.singleE24SingleTightIsoTau30Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30Prescale_value

    property singleE24SingleTightIsoTau30TightIDGroup:
        def __get__(self):
            self.singleE24SingleTightIsoTau30TightIDGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30TightIDGroup_value

    property singleE24SingleTightIsoTau30TightIDPass:
        def __get__(self):
            self.singleE24SingleTightIsoTau30TightIDPass_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30TightIDPass_value

    property singleE24SingleTightIsoTau30TightIDPrescale:
        def __get__(self):
            self.singleE24SingleTightIsoTau30TightIDPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE24SingleTightIsoTau30TightIDPrescale_value

    property singleE27TightGroup:
        def __get__(self):
            self.singleE27TightGroup_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightGroup_value

    property singleE27TightPass:
        def __get__(self):
            self.singleE27TightPass_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightPass_value

    property singleE27TightPrescale:
        def __get__(self):
            self.singleE27TightPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleE27TightPrescale_value

    property singleIsoMu20Group:
        def __get__(self):
            self.singleIsoMu20Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Group_value

    property singleIsoMu20Pass:
        def __get__(self):
            self.singleIsoMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Pass_value

    property singleIsoMu20Prescale:
        def __get__(self):
            self.singleIsoMu20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu20Prescale_value

    property singleIsoMu24Group:
        def __get__(self):
            self.singleIsoMu24Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Group_value

    property singleIsoMu24Pass:
        def __get__(self):
            self.singleIsoMu24Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Pass_value

    property singleIsoMu24Prescale:
        def __get__(self):
            self.singleIsoMu24Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24Prescale_value

    property singleIsoMu24eta2p1Group:
        def __get__(self):
            self.singleIsoMu24eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Group_value

    property singleIsoMu24eta2p1Pass:
        def __get__(self):
            self.singleIsoMu24eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Pass_value

    property singleIsoMu24eta2p1Prescale:
        def __get__(self):
            self.singleIsoMu24eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu24eta2p1Prescale_value

    property singleIsoMu27Group:
        def __get__(self):
            self.singleIsoMu27Group_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Group_value

    property singleIsoMu27Pass:
        def __get__(self):
            self.singleIsoMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Pass_value

    property singleIsoMu27Prescale:
        def __get__(self):
            self.singleIsoMu27Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleIsoMu27Prescale_value

    property singleMu20Group:
        def __get__(self):
            self.singleMu20Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu20Group_value

    property singleMu20Pass:
        def __get__(self):
            self.singleMu20Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu20Pass_value

    property singleMu20Prescale:
        def __get__(self):
            self.singleMu20Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu20Prescale_value

    property singleMu20eta2p1LooseTau27eta2p1Group:
        def __get__(self):
            self.singleMu20eta2p1LooseTau27eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1LooseTau27eta2p1Group_value

    property singleMu20eta2p1LooseTau27eta2p1Pass:
        def __get__(self):
            self.singleMu20eta2p1LooseTau27eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1LooseTau27eta2p1Pass_value

    property singleMu20eta2p1LooseTau27eta2p1Prescale:
        def __get__(self):
            self.singleMu20eta2p1LooseTau27eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1LooseTau27eta2p1Prescale_value

    property singleMu20eta2p1MediumTau27eta2p1Group:
        def __get__(self):
            self.singleMu20eta2p1MediumTau27eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1MediumTau27eta2p1Group_value

    property singleMu20eta2p1MediumTau27eta2p1Pass:
        def __get__(self):
            self.singleMu20eta2p1MediumTau27eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1MediumTau27eta2p1Pass_value

    property singleMu20eta2p1MediumTau27eta2p1Prescale:
        def __get__(self):
            self.singleMu20eta2p1MediumTau27eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1MediumTau27eta2p1Prescale_value

    property singleMu20eta2p1TightTau27eta2p1Group:
        def __get__(self):
            self.singleMu20eta2p1TightTau27eta2p1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1TightTau27eta2p1Group_value

    property singleMu20eta2p1TightTau27eta2p1Pass:
        def __get__(self):
            self.singleMu20eta2p1TightTau27eta2p1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1TightTau27eta2p1Pass_value

    property singleMu20eta2p1TightTau27eta2p1Prescale:
        def __get__(self):
            self.singleMu20eta2p1TightTau27eta2p1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu20eta2p1TightTau27eta2p1Prescale_value

    property singleMu23SingleE12DZGroup:
        def __get__(self):
            self.singleMu23SingleE12DZGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZGroup_value

    property singleMu23SingleE12DZPass:
        def __get__(self):
            self.singleMu23SingleE12DZPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZPass_value

    property singleMu23SingleE12DZPrescale:
        def __get__(self):
            self.singleMu23SingleE12DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu23SingleE12DZPrescale_value

    property singleMu24eta2p1LooseTau20TightIDsingleL1Group:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20TightIDsingleL1Group_value

    property singleMu24eta2p1LooseTau20TightIDsingleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20TightIDsingleL1Pass_value

    property singleMu24eta2p1LooseTau20TightIDsingleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20TightIDsingleL1Prescale_value

    property singleMu24eta2p1LooseTau20singleL1Group:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20singleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20singleL1Group_value

    property singleMu24eta2p1LooseTau20singleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20singleL1Pass_value

    property singleMu24eta2p1LooseTau20singleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1LooseTau20singleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1LooseTau20singleL1Prescale_value

    property singleMu24eta2p1MediumTau20TightIDsingleL1Group:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20TightIDsingleL1Group_value

    property singleMu24eta2p1MediumTau20TightIDsingleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20TightIDsingleL1Pass_value

    property singleMu24eta2p1MediumTau20TightIDsingleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20TightIDsingleL1Prescale_value

    property singleMu24eta2p1MediumTau20singleL1Group:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20singleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20singleL1Group_value

    property singleMu24eta2p1MediumTau20singleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20singleL1Pass_value

    property singleMu24eta2p1MediumTau20singleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1MediumTau20singleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1MediumTau20singleL1Prescale_value

    property singleMu24eta2p1TightTau20TightIDsingleL1Group:
        def __get__(self):
            self.singleMu24eta2p1TightTau20TightIDsingleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20TightIDsingleL1Group_value

    property singleMu24eta2p1TightTau20TightIDsingleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20TightIDsingleL1Pass_value

    property singleMu24eta2p1TightTau20TightIDsingleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20TightIDsingleL1Prescale_value

    property singleMu24eta2p1TightTau20singleL1Group:
        def __get__(self):
            self.singleMu24eta2p1TightTau20singleL1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20singleL1Group_value

    property singleMu24eta2p1TightTau20singleL1Pass:
        def __get__(self):
            self.singleMu24eta2p1TightTau20singleL1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20singleL1Pass_value

    property singleMu24eta2p1TightTau20singleL1Prescale:
        def __get__(self):
            self.singleMu24eta2p1TightTau20singleL1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu24eta2p1TightTau20singleL1Prescale_value

    property singleMu27Group:
        def __get__(self):
            self.singleMu27Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu27Group_value

    property singleMu27Pass:
        def __get__(self):
            self.singleMu27Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu27Pass_value

    property singleMu27Prescale:
        def __get__(self):
            self.singleMu27Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu27Prescale_value

    property singleMu50Group:
        def __get__(self):
            self.singleMu50Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu50Group_value

    property singleMu50Pass:
        def __get__(self):
            self.singleMu50Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu50Pass_value

    property singleMu50Prescale:
        def __get__(self):
            self.singleMu50Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu50Prescale_value

    property singleMu8SingleE23DZGroup:
        def __get__(self):
            self.singleMu8SingleE23DZGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZGroup_value

    property singleMu8SingleE23DZPass:
        def __get__(self):
            self.singleMu8SingleE23DZPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZPass_value

    property singleMu8SingleE23DZPrescale:
        def __get__(self):
            self.singleMu8SingleE23DZPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu8SingleE23DZPrescale_value

    property singleMu_leg1Group:
        def __get__(self):
            self.singleMu_leg1Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Group_value

    property singleMu_leg1Pass:
        def __get__(self):
            self.singleMu_leg1Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Pass_value

    property singleMu_leg1Prescale:
        def __get__(self):
            self.singleMu_leg1Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1Prescale_value

    property singleMu_leg1_noisoGroup:
        def __get__(self):
            self.singleMu_leg1_noisoGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoGroup_value

    property singleMu_leg1_noisoPass:
        def __get__(self):
            self.singleMu_leg1_noisoPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoPass_value

    property singleMu_leg1_noisoPrescale:
        def __get__(self):
            self.singleMu_leg1_noisoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg1_noisoPrescale_value

    property singleMu_leg2Group:
        def __get__(self):
            self.singleMu_leg2Group_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Group_value

    property singleMu_leg2Pass:
        def __get__(self):
            self.singleMu_leg2Pass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Pass_value

    property singleMu_leg2Prescale:
        def __get__(self):
            self.singleMu_leg2Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2Prescale_value

    property singleMu_leg2_noisoGroup:
        def __get__(self):
            self.singleMu_leg2_noisoGroup_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoGroup_value

    property singleMu_leg2_noisoPass:
        def __get__(self):
            self.singleMu_leg2_noisoPass_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoPass_value

    property singleMu_leg2_noisoPrescale:
        def __get__(self):
            self.singleMu_leg2_noisoPrescale_branch.GetEntry(self.localentry, 0)
            return self.singleMu_leg2_noisoPrescale_value

    property singleTau140Group:
        def __get__(self):
            self.singleTau140Group_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Group_value

    property singleTau140Pass:
        def __get__(self):
            self.singleTau140Pass_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Pass_value

    property singleTau140Prescale:
        def __get__(self):
            self.singleTau140Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Prescale_value

    property singleTau140Trk50Group:
        def __get__(self):
            self.singleTau140Trk50Group_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Group_value

    property singleTau140Trk50Pass:
        def __get__(self):
            self.singleTau140Trk50Pass_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Pass_value

    property singleTau140Trk50Prescale:
        def __get__(self):
            self.singleTau140Trk50Prescale_branch.GetEntry(self.localentry, 0)
            return self.singleTau140Trk50Prescale_value

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

    property tripleMuGroup:
        def __get__(self):
            self.tripleMuGroup_branch.GetEntry(self.localentry, 0)
            return self.tripleMuGroup_value

    property tripleMuPass:
        def __get__(self):
            self.tripleMuPass_branch.GetEntry(self.localentry, 0)
            return self.tripleMuPass_value

    property tripleMuPrescale:
        def __get__(self):
            self.tripleMuPrescale_branch.GetEntry(self.localentry, 0)
            return self.tripleMuPrescale_value

    property type1_pfMetEt:
        def __get__(self):
            self.type1_pfMetEt_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetEt_value

    property type1_pfMetPhi:
        def __get__(self):
            self.type1_pfMetPhi_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMetPhi_value

    property type1_pfMet_shiftedPhi_CHARGEDUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_CHARGEDUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_CHARGEDUESDown_value

    property type1_pfMet_shiftedPhi_CHARGEDUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_CHARGEDUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_CHARGEDUESUp_value

    property type1_pfMet_shiftedPhi_ECALUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_ECALUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_ECALUESDown_value

    property type1_pfMet_shiftedPhi_ECALUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_ECALUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_ECALUESUp_value

    property type1_pfMet_shiftedPhi_HCALUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_HCALUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_HCALUESDown_value

    property type1_pfMet_shiftedPhi_HCALUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_HCALUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_HCALUESUp_value

    property type1_pfMet_shiftedPhi_HFUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_HFUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_HFUESDown_value

    property type1_pfMet_shiftedPhi_HFUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_HFUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_HFUESUp_value

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

    property type1_pfMet_shiftedPhi_RunIUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_RunIUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_RunIUESDown_value

    property type1_pfMet_shiftedPhi_RunIUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_RunIUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_RunIUESUp_value

    property type1_pfMet_shiftedPhi_UnclusteredEnDown:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnDown_value

    property type1_pfMet_shiftedPhi_UnclusteredEnUp:
        def __get__(self):
            self.type1_pfMet_shiftedPhi_UnclusteredEnUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPhi_UnclusteredEnUp_value

    property type1_pfMet_shiftedPt_CHARGEDUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_CHARGEDUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_CHARGEDUESDown_value

    property type1_pfMet_shiftedPt_CHARGEDUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_CHARGEDUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_CHARGEDUESUp_value

    property type1_pfMet_shiftedPt_ECALUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_ECALUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_ECALUESDown_value

    property type1_pfMet_shiftedPt_ECALUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_ECALUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_ECALUESUp_value

    property type1_pfMet_shiftedPt_HCALUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_HCALUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_HCALUESDown_value

    property type1_pfMet_shiftedPt_HCALUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_HCALUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_HCALUESUp_value

    property type1_pfMet_shiftedPt_HFUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_HFUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_HFUESDown_value

    property type1_pfMet_shiftedPt_HFUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_HFUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_HFUESUp_value

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

    property type1_pfMet_shiftedPt_JetCheckUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetCheckUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetCheckUESDown_value

    property type1_pfMet_shiftedPt_JetCheckUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_JetCheckUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_JetCheckUESUp_value

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

    property type1_pfMet_shiftedPt_RunIUESDown:
        def __get__(self):
            self.type1_pfMet_shiftedPt_RunIUESDown_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_RunIUESDown_value

    property type1_pfMet_shiftedPt_RunIUESUp:
        def __get__(self):
            self.type1_pfMet_shiftedPt_RunIUESUp_branch.GetEntry(self.localentry, 0)
            return self.type1_pfMet_shiftedPt_RunIUESUp_value

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

    property vbfDeta_JetEnDown:
        def __get__(self):
            self.vbfDeta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_JetEnDown_value

    property vbfDeta_JetEnUp:
        def __get__(self):
            self.vbfDeta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDeta_JetEnUp_value

    property vbfDijetrap:
        def __get__(self):
            self.vbfDijetrap_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_value

    property vbfDijetrap_JetEnDown:
        def __get__(self):
            self.vbfDijetrap_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_JetEnDown_value

    property vbfDijetrap_JetEnUp:
        def __get__(self):
            self.vbfDijetrap_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDijetrap_JetEnUp_value

    property vbfDphi:
        def __get__(self):
            self.vbfDphi_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_value

    property vbfDphi_JetEnDown:
        def __get__(self):
            self.vbfDphi_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_JetEnDown_value

    property vbfDphi_JetEnUp:
        def __get__(self):
            self.vbfDphi_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphi_JetEnUp_value

    property vbfDphihj:
        def __get__(self):
            self.vbfDphihj_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_value

    property vbfDphihj_JetEnDown:
        def __get__(self):
            self.vbfDphihj_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_JetEnDown_value

    property vbfDphihj_JetEnUp:
        def __get__(self):
            self.vbfDphihj_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihj_JetEnUp_value

    property vbfDphihjnomet:
        def __get__(self):
            self.vbfDphihjnomet_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_value

    property vbfDphihjnomet_JetEnDown:
        def __get__(self):
            self.vbfDphihjnomet_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_JetEnDown_value

    property vbfDphihjnomet_JetEnUp:
        def __get__(self):
            self.vbfDphihjnomet_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfDphihjnomet_JetEnUp_value

    property vbfHrap:
        def __get__(self):
            self.vbfHrap_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_value

    property vbfHrap_JetEnDown:
        def __get__(self):
            self.vbfHrap_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_JetEnDown_value

    property vbfHrap_JetEnUp:
        def __get__(self):
            self.vbfHrap_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfHrap_JetEnUp_value

    property vbfJetVeto20:
        def __get__(self):
            self.vbfJetVeto20_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_value

    property vbfJetVeto20_JetEnDown:
        def __get__(self):
            self.vbfJetVeto20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_JetEnDown_value

    property vbfJetVeto20_JetEnUp:
        def __get__(self):
            self.vbfJetVeto20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto20_JetEnUp_value

    property vbfJetVeto30:
        def __get__(self):
            self.vbfJetVeto30_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_value

    property vbfJetVeto30_JetEnDown:
        def __get__(self):
            self.vbfJetVeto30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_JetEnDown_value

    property vbfJetVeto30_JetEnUp:
        def __get__(self):
            self.vbfJetVeto30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfJetVeto30_JetEnUp_value

    property vbfMVA:
        def __get__(self):
            self.vbfMVA_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_value

    property vbfMVA_JetEnDown:
        def __get__(self):
            self.vbfMVA_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_JetEnDown_value

    property vbfMVA_JetEnUp:
        def __get__(self):
            self.vbfMVA_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMVA_JetEnUp_value

    property vbfMass:
        def __get__(self):
            self.vbfMass_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_value

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

    property vbfMass_JetEnDown:
        def __get__(self):
            self.vbfMass_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnDown_value

    property vbfMass_JetEnUp:
        def __get__(self):
            self.vbfMass_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetEnUp_value

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

    property vbfMass_JetSubTotalAbsoluteDown:
        def __get__(self):
            self.vbfMass_JetSubTotalAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalAbsoluteDown_value

    property vbfMass_JetSubTotalAbsoluteUp:
        def __get__(self):
            self.vbfMass_JetSubTotalAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalAbsoluteUp_value

    property vbfMass_JetSubTotalMCDown:
        def __get__(self):
            self.vbfMass_JetSubTotalMCDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalMCDown_value

    property vbfMass_JetSubTotalMCUp:
        def __get__(self):
            self.vbfMass_JetSubTotalMCUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalMCUp_value

    property vbfMass_JetSubTotalPileUpDown:
        def __get__(self):
            self.vbfMass_JetSubTotalPileUpDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPileUpDown_value

    property vbfMass_JetSubTotalPileUpUp:
        def __get__(self):
            self.vbfMass_JetSubTotalPileUpUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPileUpUp_value

    property vbfMass_JetSubTotalPtDown:
        def __get__(self):
            self.vbfMass_JetSubTotalPtDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPtDown_value

    property vbfMass_JetSubTotalPtUp:
        def __get__(self):
            self.vbfMass_JetSubTotalPtUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalPtUp_value

    property vbfMass_JetSubTotalRelativeDown:
        def __get__(self):
            self.vbfMass_JetSubTotalRelativeDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalRelativeDown_value

    property vbfMass_JetSubTotalRelativeUp:
        def __get__(self):
            self.vbfMass_JetSubTotalRelativeUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalRelativeUp_value

    property vbfMass_JetSubTotalScaleDown:
        def __get__(self):
            self.vbfMass_JetSubTotalScaleDown_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalScaleDown_value

    property vbfMass_JetSubTotalScaleUp:
        def __get__(self):
            self.vbfMass_JetSubTotalScaleUp_branch.GetEntry(self.localentry, 0)
            return self.vbfMass_JetSubTotalScaleUp_value

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

    property vbfNJets20_JetEnDown:
        def __get__(self):
            self.vbfNJets20_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_JetEnDown_value

    property vbfNJets20_JetEnUp:
        def __get__(self):
            self.vbfNJets20_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets20_JetEnUp_value

    property vbfNJets30:
        def __get__(self):
            self.vbfNJets30_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_value

    property vbfNJets30_JetEnDown:
        def __get__(self):
            self.vbfNJets30_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_JetEnDown_value

    property vbfNJets30_JetEnUp:
        def __get__(self):
            self.vbfNJets30_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfNJets30_JetEnUp_value

    property vbfVispt:
        def __get__(self):
            self.vbfVispt_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_value

    property vbfVispt_JetEnDown:
        def __get__(self):
            self.vbfVispt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_JetEnDown_value

    property vbfVispt_JetEnUp:
        def __get__(self):
            self.vbfVispt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfVispt_JetEnUp_value

    property vbfdijetpt:
        def __get__(self):
            self.vbfdijetpt_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_value

    property vbfdijetpt_JetEnDown:
        def __get__(self):
            self.vbfdijetpt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_JetEnDown_value

    property vbfdijetpt_JetEnUp:
        def __get__(self):
            self.vbfdijetpt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfdijetpt_JetEnUp_value

    property vbfj1eta:
        def __get__(self):
            self.vbfj1eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_value

    property vbfj1eta_JetEnDown:
        def __get__(self):
            self.vbfj1eta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_JetEnDown_value

    property vbfj1eta_JetEnUp:
        def __get__(self):
            self.vbfj1eta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj1eta_JetEnUp_value

    property vbfj1pt:
        def __get__(self):
            self.vbfj1pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_value

    property vbfj1pt_JetEnDown:
        def __get__(self):
            self.vbfj1pt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_JetEnDown_value

    property vbfj1pt_JetEnUp:
        def __get__(self):
            self.vbfj1pt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj1pt_JetEnUp_value

    property vbfj2eta:
        def __get__(self):
            self.vbfj2eta_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_value

    property vbfj2eta_JetEnDown:
        def __get__(self):
            self.vbfj2eta_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_JetEnDown_value

    property vbfj2eta_JetEnUp:
        def __get__(self):
            self.vbfj2eta_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj2eta_JetEnUp_value

    property vbfj2pt:
        def __get__(self):
            self.vbfj2pt_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_value

    property vbfj2pt_JetEnDown:
        def __get__(self):
            self.vbfj2pt_JetEnDown_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_JetEnDown_value

    property vbfj2pt_JetEnUp:
        def __get__(self):
            self.vbfj2pt_JetEnUp_branch.GetEntry(self.localentry, 0)
            return self.vbfj2pt_JetEnUp_value

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


