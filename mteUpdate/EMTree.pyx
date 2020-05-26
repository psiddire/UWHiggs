

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

cdef class EMTree:
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

    cdef TBranch* run_branch
    cdef int run_value

    cdef TBranch* lumi_branch
    cdef int lumi_value

    cdef TBranch* evt_branch
    cdef int evt_value

    cdef TBranch* genpX_branch
    cdef float genpX_value

    cdef TBranch* genpY_branch
    cdef float genpY_value

    cdef TBranch* genM_branch
    cdef float genM_value

    cdef TBranch* genpT_branch
    cdef float genpT_value

    cdef TBranch* vispX_branch
    cdef float vispX_value

    cdef TBranch* vispY_branch
    cdef float vispY_value

    cdef TBranch* genpt_1_branch
    cdef float genpt_1_value

    cdef TBranch* geneta_1_branch
    cdef float geneta_1_value

    cdef TBranch* genpt_2_branch
    cdef float genpt_2_value

    cdef TBranch* geneta_2_branch
    cdef float geneta_2_value

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

    cdef TBranch* Rivet_stage1_1_fine_cat_pTjet30GeV_branch
    cdef float Rivet_stage1_1_fine_cat_pTjet30GeV_value

    cdef TBranch* Rivet_stage1_1_cat_pTjet30GeV_branch
    cdef float Rivet_stage1_1_cat_pTjet30GeV_value

    cdef TBranch* npv_branch
    cdef float npv_value

    cdef TBranch* npu_branch
    cdef float npu_value

    cdef TBranch* pt_1_ScaleUp_branch
    cdef float pt_1_ScaleUp_value

    cdef TBranch* pt_1_ScaleDown_branch
    cdef float pt_1_ScaleDown_value

    cdef TBranch* pt_1_branch
    cdef float pt_1_value

    cdef TBranch* phi_1_branch
    cdef float phi_1_value

    cdef TBranch* eta_1_branch
    cdef float eta_1_value

    cdef TBranch* m_1_branch
    cdef float m_1_value

    cdef TBranch* e_1_branch
    cdef float e_1_value

    cdef TBranch* q_1_branch
    cdef float q_1_value

    cdef TBranch* iso_1_branch
    cdef float iso_1_value

    cdef TBranch* pt_2_branch
    cdef float pt_2_value

    cdef TBranch* phi_2_branch
    cdef float phi_2_value

    cdef TBranch* eta_2_branch
    cdef float eta_2_value

    cdef TBranch* m_2_branch
    cdef float m_2_value

    cdef TBranch* e_2_branch
    cdef float e_2_value

    cdef TBranch* q_2_branch
    cdef float q_2_value

    cdef TBranch* iso_2_branch
    cdef float iso_2_value

    cdef TBranch* numGenJets_branch
    cdef float numGenJets_value

    cdef TBranch* bweight_branch
    cdef float bweight_value

    cdef TBranch* Flag_ecalBadCalibReducedMINIAODFilter_branch
    cdef float Flag_ecalBadCalibReducedMINIAODFilter_value

    cdef TBranch* Flag_goodVertices_branch
    cdef float Flag_goodVertices_value

    cdef TBranch* Flag_globalSuperTightHalo2016Filter_branch
    cdef float Flag_globalSuperTightHalo2016Filter_value

    cdef TBranch* Flag_eeBadScFilter_branch
    cdef float Flag_eeBadScFilter_value

    cdef TBranch* Flag_ecalBadCalibFilter_branch
    cdef float Flag_ecalBadCalibFilter_value

    cdef TBranch* Flag_badMuons_branch
    cdef float Flag_badMuons_value

    cdef TBranch* Flag_duplicateMuons_branch
    cdef float Flag_duplicateMuons_value

    cdef TBranch* Flag_HBHENoiseIsoFilter_branch
    cdef float Flag_HBHENoiseIsoFilter_value

    cdef TBranch* Flag_HBHENoiseFilter_branch
    cdef float Flag_HBHENoiseFilter_value

    cdef TBranch* Flag_EcalDeadCellTriggerPrimitiveFilter_branch
    cdef float Flag_EcalDeadCellTriggerPrimitiveFilter_value

    cdef TBranch* Flag_BadPFMuonFilter_branch
    cdef float Flag_BadPFMuonFilter_value

    cdef TBranch* Flag_BadChargedCandidateFilter_branch
    cdef float Flag_BadChargedCandidateFilter_value

    cdef TBranch* met_branch
    cdef float met_value

    cdef TBranch* metSig_branch
    cdef float metSig_value

    cdef TBranch* metcov00_branch
    cdef float metcov00_value

    cdef TBranch* metcov10_branch
    cdef float metcov10_value

    cdef TBranch* metcov11_branch
    cdef float metcov11_value

    cdef TBranch* metcov01_branch
    cdef float metcov01_value

    cdef TBranch* metphi_branch
    cdef float metphi_value

    cdef TBranch* met_py_branch
    cdef float met_py_value

    cdef TBranch* met_px_branch
    cdef float met_px_value

    cdef TBranch* met_UESUp_branch
    cdef float met_UESUp_value

    cdef TBranch* metphi_UESUp_branch
    cdef float metphi_UESUp_value

    cdef TBranch* met_UESDown_branch
    cdef float met_UESDown_value

    cdef TBranch* metphi_UESDown_branch
    cdef float metphi_UESDown_value

    cdef TBranch* met_JetAbsoluteUp_branch
    cdef float met_JetAbsoluteUp_value

    cdef TBranch* metphi_JetAbsoluteUp_branch
    cdef float metphi_JetAbsoluteUp_value

    cdef TBranch* met_JetAbsoluteDown_branch
    cdef float met_JetAbsoluteDown_value

    cdef TBranch* metphi_JetAbsoluteDown_branch
    cdef float metphi_JetAbsoluteDown_value

    cdef TBranch* met_JetAbsoluteyearUp_branch
    cdef float met_JetAbsoluteyearUp_value

    cdef TBranch* metphi_JetAbsoluteyearUp_branch
    cdef float metphi_JetAbsoluteyearUp_value

    cdef TBranch* met_JetAbsoluteyearDown_branch
    cdef float met_JetAbsoluteyearDown_value

    cdef TBranch* metphi_JetAbsoluteyearDown_branch
    cdef float metphi_JetAbsoluteyearDown_value

    cdef TBranch* met_JetBBEC1Up_branch
    cdef float met_JetBBEC1Up_value

    cdef TBranch* metphi_JetBBEC1Up_branch
    cdef float metphi_JetBBEC1Up_value

    cdef TBranch* met_JetBBEC1Down_branch
    cdef float met_JetBBEC1Down_value

    cdef TBranch* metphi_JetBBEC1Down_branch
    cdef float metphi_JetBBEC1Down_value

    cdef TBranch* met_JetBBEC1yearUp_branch
    cdef float met_JetBBEC1yearUp_value

    cdef TBranch* metphi_JetBBEC1yearUp_branch
    cdef float metphi_JetBBEC1yearUp_value

    cdef TBranch* met_JetBBEC1yearDown_branch
    cdef float met_JetBBEC1yearDown_value

    cdef TBranch* metphi_JetBBEC1yearDown_branch
    cdef float metphi_JetBBEC1yearDown_value

    cdef TBranch* met_JetEC2Up_branch
    cdef float met_JetEC2Up_value

    cdef TBranch* metphi_JetEC2Up_branch
    cdef float metphi_JetEC2Up_value

    cdef TBranch* met_JetEC2Down_branch
    cdef float met_JetEC2Down_value

    cdef TBranch* metphi_JetEC2Down_branch
    cdef float metphi_JetEC2Down_value

    cdef TBranch* met_JetEC2yearUp_branch
    cdef float met_JetEC2yearUp_value

    cdef TBranch* metphi_JetEC2yearUp_branch
    cdef float metphi_JetEC2yearUp_value

    cdef TBranch* met_JetEC2yearDown_branch
    cdef float met_JetEC2yearDown_value

    cdef TBranch* metphi_JetEC2yearDown_branch
    cdef float metphi_JetEC2yearDown_value

    cdef TBranch* met_JetFlavorQCDUp_branch
    cdef float met_JetFlavorQCDUp_value

    cdef TBranch* metphi_JetFlavorQCDUp_branch
    cdef float metphi_JetFlavorQCDUp_value

    cdef TBranch* met_JetFlavorQCDDown_branch
    cdef float met_JetFlavorQCDDown_value

    cdef TBranch* metphi_JetFlavorQCDDown_branch
    cdef float metphi_JetFlavorQCDDown_value

    cdef TBranch* met_JetHFUp_branch
    cdef float met_JetHFUp_value

    cdef TBranch* metphi_JetHFUp_branch
    cdef float metphi_JetHFUp_value

    cdef TBranch* met_JetHFDown_branch
    cdef float met_JetHFDown_value

    cdef TBranch* metphi_JetHFDown_branch
    cdef float metphi_JetHFDown_value

    cdef TBranch* met_JetHFyearUp_branch
    cdef float met_JetHFyearUp_value

    cdef TBranch* metphi_JetHFyearUp_branch
    cdef float metphi_JetHFyearUp_value

    cdef TBranch* met_JetHFyearDown_branch
    cdef float met_JetHFyearDown_value

    cdef TBranch* metphi_JetHFyearDown_branch
    cdef float metphi_JetHFyearDown_value

    cdef TBranch* met_JetRelativeBalUp_branch
    cdef float met_JetRelativeBalUp_value

    cdef TBranch* metphi_JetRelativeBalUp_branch
    cdef float metphi_JetRelativeBalUp_value

    cdef TBranch* met_JetRelativeBalDown_branch
    cdef float met_JetRelativeBalDown_value

    cdef TBranch* metphi_JetRelativeBalDown_branch
    cdef float metphi_JetRelativeBalDown_value

    cdef TBranch* met_JetRelativeSampleUp_branch
    cdef float met_JetRelativeSampleUp_value

    cdef TBranch* metphi_JetRelativeSampleUp_branch
    cdef float metphi_JetRelativeSampleUp_value

    cdef TBranch* met_JetRelativeSampleDown_branch
    cdef float met_JetRelativeSampleDown_value

    cdef TBranch* metphi_JetRelativeSampleDown_branch
    cdef float metphi_JetRelativeSampleDown_value

    cdef TBranch* met_JERUp_branch
    cdef float met_JERUp_value

    cdef TBranch* metphi_JERUp_branch
    cdef float metphi_JERUp_value

    cdef TBranch* met_JERDown_branch
    cdef float met_JERDown_value

    cdef TBranch* metphi_JERDown_branch
    cdef float metphi_JERDown_value

    cdef TBranch* met_responseUp_branch
    cdef float met_responseUp_value

    cdef TBranch* met_responseDown_branch
    cdef float met_responseDown_value

    cdef TBranch* met_resolutionUp_branch
    cdef float met_resolutionUp_value

    cdef TBranch* met_resolutionDown_branch
    cdef float met_resolutionDown_value

    cdef TBranch* metphi_responseUp_branch
    cdef float metphi_responseUp_value

    cdef TBranch* metphi_responseDown_branch
    cdef float metphi_responseDown_value

    cdef TBranch* metphi_resolutionUp_branch
    cdef float metphi_resolutionUp_value

    cdef TBranch* metphi_resolutionDown_branch
    cdef float metphi_resolutionDown_value

    cdef TBranch* mjj_branch
    cdef float mjj_value

    cdef TBranch* mjj_JetAbsoluteUp_branch
    cdef float mjj_JetAbsoluteUp_value

    cdef TBranch* mjj_JetAbsoluteDown_branch
    cdef float mjj_JetAbsoluteDown_value

    cdef TBranch* mjj_JetAbsoluteyearUp_branch
    cdef float mjj_JetAbsoluteyearUp_value

    cdef TBranch* mjj_JetAbsoluteyearDown_branch
    cdef float mjj_JetAbsoluteyearDown_value

    cdef TBranch* mjj_JetBBEC1Up_branch
    cdef float mjj_JetBBEC1Up_value

    cdef TBranch* mjj_JetBBEC1Down_branch
    cdef float mjj_JetBBEC1Down_value

    cdef TBranch* mjj_JetBBEC1yearUp_branch
    cdef float mjj_JetBBEC1yearUp_value

    cdef TBranch* mjj_JetBBEC1yearDown_branch
    cdef float mjj_JetBBEC1yearDown_value

    cdef TBranch* mjj_JetEC2Up_branch
    cdef float mjj_JetEC2Up_value

    cdef TBranch* mjj_JetEC2Down_branch
    cdef float mjj_JetEC2Down_value

    cdef TBranch* mjj_JetEC2yearUp_branch
    cdef float mjj_JetEC2yearUp_value

    cdef TBranch* mjj_JetEC2yearDown_branch
    cdef float mjj_JetEC2yearDown_value

    cdef TBranch* mjj_JetFlavorQCDUp_branch
    cdef float mjj_JetFlavorQCDUp_value

    cdef TBranch* mjj_JetFlavorQCDDown_branch
    cdef float mjj_JetFlavorQCDDown_value

    cdef TBranch* mjj_JetHFUp_branch
    cdef float mjj_JetHFUp_value

    cdef TBranch* mjj_JetHFDown_branch
    cdef float mjj_JetHFDown_value

    cdef TBranch* mjj_JetHFyearUp_branch
    cdef float mjj_JetHFyearUp_value

    cdef TBranch* mjj_JetHFyearDown_branch
    cdef float mjj_JetHFyearDown_value

    cdef TBranch* mjj_JetRelativeBalUp_branch
    cdef float mjj_JetRelativeBalUp_value

    cdef TBranch* mjj_JetRelativeBalDown_branch
    cdef float mjj_JetRelativeBalDown_value

    cdef TBranch* mjj_JetRelativeSampleUp_branch
    cdef float mjj_JetRelativeSampleUp_value

    cdef TBranch* mjj_JetRelativeSampleDown_branch
    cdef float mjj_JetRelativeSampleDown_value

    cdef TBranch* mjj_JERUp_branch
    cdef float mjj_JERUp_value

    cdef TBranch* mjj_JERDown_branch
    cdef float mjj_JERDown_value

    cdef TBranch* gen_match_1_branch
    cdef int gen_match_1_value

    cdef TBranch* gen_match_2_branch
    cdef int gen_match_2_value

    cdef TBranch* nbtag_branch
    cdef int nbtag_value

    cdef TBranch* nbtagL_branch
    cdef int nbtagL_value

    cdef TBranch* njets_branch
    cdef int njets_value

    cdef TBranch* njets_JetAbsoluteUp_branch
    cdef int njets_JetAbsoluteUp_value

    cdef TBranch* njets_JetAbsoluteDown_branch
    cdef int njets_JetAbsoluteDown_value

    cdef TBranch* njets_JetAbsoluteyearUp_branch
    cdef int njets_JetAbsoluteyearUp_value

    cdef TBranch* njets_JetAbsoluteyearDown_branch
    cdef int njets_JetAbsoluteyearDown_value

    cdef TBranch* njets_JetBBEC1Up_branch
    cdef int njets_JetBBEC1Up_value

    cdef TBranch* njets_JetBBEC1Down_branch
    cdef int njets_JetBBEC1Down_value

    cdef TBranch* njets_JetBBEC1yearUp_branch
    cdef int njets_JetBBEC1yearUp_value

    cdef TBranch* njets_JetBBEC1yearDown_branch
    cdef int njets_JetBBEC1yearDown_value

    cdef TBranch* njets_JetEC2Up_branch
    cdef int njets_JetEC2Up_value

    cdef TBranch* njets_JetEC2Down_branch
    cdef int njets_JetEC2Down_value

    cdef TBranch* njets_JetEC2yearUp_branch
    cdef int njets_JetEC2yearUp_value

    cdef TBranch* njets_JetEC2yearDown_branch
    cdef int njets_JetEC2yearDown_value

    cdef TBranch* njets_JetFlavorQCDUp_branch
    cdef int njets_JetFlavorQCDUp_value

    cdef TBranch* njets_JetFlavorQCDDown_branch
    cdef int njets_JetFlavorQCDDown_value

    cdef TBranch* njets_JetHFUp_branch
    cdef int njets_JetHFUp_value

    cdef TBranch* njets_JetHFDown_branch
    cdef int njets_JetHFDown_value

    cdef TBranch* njets_JetHFyearUp_branch
    cdef int njets_JetHFyearUp_value

    cdef TBranch* njets_JetHFyearDown_branch
    cdef int njets_JetHFyearDown_value

    cdef TBranch* njets_JetRelativeBalUp_branch
    cdef int njets_JetRelativeBalUp_value

    cdef TBranch* njets_JetRelativeBalDown_branch
    cdef int njets_JetRelativeBalDown_value

    cdef TBranch* njets_JetRelativeSampleUp_branch
    cdef int njets_JetRelativeSampleUp_value

    cdef TBranch* njets_JetRelativeSampleDown_branch
    cdef int njets_JetRelativeSampleDown_value

    cdef TBranch* njets_JERUp_branch
    cdef int njets_JERUp_value

    cdef TBranch* njets_JERDown_branch
    cdef int njets_JERDown_value

    cdef TBranch* jpt_1_branch
    cdef float jpt_1_value

    cdef TBranch* jeta_1_branch
    cdef float jeta_1_value

    cdef TBranch* jcsv_1_branch
    cdef float jcsv_1_value

    cdef TBranch* jphi_1_branch
    cdef float jphi_1_value

    cdef TBranch* jpt_2_branch
    cdef float jpt_2_value

    cdef TBranch* jeta_2_branch
    cdef float jeta_2_value

    cdef TBranch* jcsv_2_branch
    cdef float jcsv_2_value

    cdef TBranch* jphi_2_branch
    cdef float jphi_2_value

    cdef TBranch* bpt_1_branch
    cdef float bpt_1_value

    cdef TBranch* bflavor_1_branch
    cdef float bflavor_1_value

    cdef TBranch* beta_1_branch
    cdef float beta_1_value

    cdef TBranch* bphi_1_branch
    cdef float bphi_1_value

    cdef TBranch* passMu23E12_branch
    cdef float passMu23E12_value

    cdef TBranch* passMu8E23_branch
    cdef float passMu8E23_value

    cdef TBranch* matchMu23E12_1_branch
    cdef float matchMu23E12_1_value

    cdef TBranch* matchMu8E23_1_branch
    cdef float matchMu8E23_1_value

    cdef TBranch* filterMu23E12_1_branch
    cdef float filterMu23E12_1_value

    cdef TBranch* filterMu8E23_1_branch
    cdef float filterMu8E23_1_value

    cdef TBranch* matchMu23E12_2_branch
    cdef float matchMu23E12_2_value

    cdef TBranch* matchMu8E23_2_branch
    cdef float matchMu8E23_2_value

    cdef TBranch* filterMu23E12_2_branch
    cdef float filterMu23E12_2_value

    cdef TBranch* filterMu8E23_2_branch
    cdef float filterMu8E23_2_value

    cdef TBranch* bpt_2_branch
    cdef float bpt_2_value

    cdef TBranch* bflavor_2_branch
    cdef float bflavor_2_value

    cdef TBranch* beta_2_branch
    cdef float beta_2_value

    cdef TBranch* bphi_2_branch
    cdef float bphi_2_value

    cdef TBranch* pt_top1_branch
    cdef float pt_top1_value

    cdef TBranch* pt_top2_branch
    cdef float pt_top2_value

    cdef TBranch* genweight_branch
    cdef float genweight_value

    cdef TBranch* gen_Higgs_pt_branch
    cdef float gen_Higgs_pt_value

    cdef TBranch* gen_Higgs_mass_branch
    cdef float gen_Higgs_mass_value


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

        #print "making run"
        self.run_branch = the_tree.GetBranch("run")
        #if not self.run_branch and "run" not in self.complained:
        if not self.run_branch and "run":
            warnings.warn( "EMTree: Expected branch run does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("run")
        else:
            self.run_branch.SetAddress(<void*>&self.run_value)

        #print "making lumi"
        self.lumi_branch = the_tree.GetBranch("lumi")
        #if not self.lumi_branch and "lumi" not in self.complained:
        if not self.lumi_branch and "lumi":
            warnings.warn( "EMTree: Expected branch lumi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("lumi")
        else:
            self.lumi_branch.SetAddress(<void*>&self.lumi_value)

        #print "making evt"
        self.evt_branch = the_tree.GetBranch("evt")
        #if not self.evt_branch and "evt" not in self.complained:
        if not self.evt_branch and "evt":
            warnings.warn( "EMTree: Expected branch evt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("evt")
        else:
            self.evt_branch.SetAddress(<void*>&self.evt_value)

        #print "making genpX"
        self.genpX_branch = the_tree.GetBranch("genpX")
        #if not self.genpX_branch and "genpX" not in self.complained:
        if not self.genpX_branch and "genpX":
            warnings.warn( "EMTree: Expected branch genpX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpX")
        else:
            self.genpX_branch.SetAddress(<void*>&self.genpX_value)

        #print "making genpY"
        self.genpY_branch = the_tree.GetBranch("genpY")
        #if not self.genpY_branch and "genpY" not in self.complained:
        if not self.genpY_branch and "genpY":
            warnings.warn( "EMTree: Expected branch genpY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpY")
        else:
            self.genpY_branch.SetAddress(<void*>&self.genpY_value)

        #print "making genM"
        self.genM_branch = the_tree.GetBranch("genM")
        #if not self.genM_branch and "genM" not in self.complained:
        if not self.genM_branch and "genM":
            warnings.warn( "EMTree: Expected branch genM does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genM")
        else:
            self.genM_branch.SetAddress(<void*>&self.genM_value)

        #print "making genpT"
        self.genpT_branch = the_tree.GetBranch("genpT")
        #if not self.genpT_branch and "genpT" not in self.complained:
        if not self.genpT_branch and "genpT":
            warnings.warn( "EMTree: Expected branch genpT does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpT")
        else:
            self.genpT_branch.SetAddress(<void*>&self.genpT_value)

        #print "making vispX"
        self.vispX_branch = the_tree.GetBranch("vispX")
        #if not self.vispX_branch and "vispX" not in self.complained:
        if not self.vispX_branch and "vispX":
            warnings.warn( "EMTree: Expected branch vispX does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispX")
        else:
            self.vispX_branch.SetAddress(<void*>&self.vispX_value)

        #print "making vispY"
        self.vispY_branch = the_tree.GetBranch("vispY")
        #if not self.vispY_branch and "vispY" not in self.complained:
        if not self.vispY_branch and "vispY":
            warnings.warn( "EMTree: Expected branch vispY does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("vispY")
        else:
            self.vispY_branch.SetAddress(<void*>&self.vispY_value)

        #print "making genpt_1"
        self.genpt_1_branch = the_tree.GetBranch("genpt_1")
        #if not self.genpt_1_branch and "genpt_1" not in self.complained:
        if not self.genpt_1_branch and "genpt_1":
            warnings.warn( "EMTree: Expected branch genpt_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpt_1")
        else:
            self.genpt_1_branch.SetAddress(<void*>&self.genpt_1_value)

        #print "making geneta_1"
        self.geneta_1_branch = the_tree.GetBranch("geneta_1")
        #if not self.geneta_1_branch and "geneta_1" not in self.complained:
        if not self.geneta_1_branch and "geneta_1":
            warnings.warn( "EMTree: Expected branch geneta_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("geneta_1")
        else:
            self.geneta_1_branch.SetAddress(<void*>&self.geneta_1_value)

        #print "making genpt_2"
        self.genpt_2_branch = the_tree.GetBranch("genpt_2")
        #if not self.genpt_2_branch and "genpt_2" not in self.complained:
        if not self.genpt_2_branch and "genpt_2":
            warnings.warn( "EMTree: Expected branch genpt_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genpt_2")
        else:
            self.genpt_2_branch.SetAddress(<void*>&self.genpt_2_value)

        #print "making geneta_2"
        self.geneta_2_branch = the_tree.GetBranch("geneta_2")
        #if not self.geneta_2_branch and "geneta_2" not in self.complained:
        if not self.geneta_2_branch and "geneta_2":
            warnings.warn( "EMTree: Expected branch geneta_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("geneta_2")
        else:
            self.geneta_2_branch.SetAddress(<void*>&self.geneta_2_value)

        #print "making Rivet_VEta"
        self.Rivet_VEta_branch = the_tree.GetBranch("Rivet_VEta")
        #if not self.Rivet_VEta_branch and "Rivet_VEta" not in self.complained:
        if not self.Rivet_VEta_branch and "Rivet_VEta":
            warnings.warn( "EMTree: Expected branch Rivet_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VEta")
        else:
            self.Rivet_VEta_branch.SetAddress(<void*>&self.Rivet_VEta_value)

        #print "making Rivet_VPt"
        self.Rivet_VPt_branch = the_tree.GetBranch("Rivet_VPt")
        #if not self.Rivet_VPt_branch and "Rivet_VPt" not in self.complained:
        if not self.Rivet_VPt_branch and "Rivet_VPt":
            warnings.warn( "EMTree: Expected branch Rivet_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_VPt")
        else:
            self.Rivet_VPt_branch.SetAddress(<void*>&self.Rivet_VPt_value)

        #print "making Rivet_errorCode"
        self.Rivet_errorCode_branch = the_tree.GetBranch("Rivet_errorCode")
        #if not self.Rivet_errorCode_branch and "Rivet_errorCode" not in self.complained:
        if not self.Rivet_errorCode_branch and "Rivet_errorCode":
            warnings.warn( "EMTree: Expected branch Rivet_errorCode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_errorCode")
        else:
            self.Rivet_errorCode_branch.SetAddress(<void*>&self.Rivet_errorCode_value)

        #print "making Rivet_higgsEta"
        self.Rivet_higgsEta_branch = the_tree.GetBranch("Rivet_higgsEta")
        #if not self.Rivet_higgsEta_branch and "Rivet_higgsEta" not in self.complained:
        if not self.Rivet_higgsEta_branch and "Rivet_higgsEta":
            warnings.warn( "EMTree: Expected branch Rivet_higgsEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsEta")
        else:
            self.Rivet_higgsEta_branch.SetAddress(<void*>&self.Rivet_higgsEta_value)

        #print "making Rivet_higgsPt"
        self.Rivet_higgsPt_branch = the_tree.GetBranch("Rivet_higgsPt")
        #if not self.Rivet_higgsPt_branch and "Rivet_higgsPt" not in self.complained:
        if not self.Rivet_higgsPt_branch and "Rivet_higgsPt":
            warnings.warn( "EMTree: Expected branch Rivet_higgsPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_higgsPt")
        else:
            self.Rivet_higgsPt_branch.SetAddress(<void*>&self.Rivet_higgsPt_value)

        #print "making Rivet_nJets25"
        self.Rivet_nJets25_branch = the_tree.GetBranch("Rivet_nJets25")
        #if not self.Rivet_nJets25_branch and "Rivet_nJets25" not in self.complained:
        if not self.Rivet_nJets25_branch and "Rivet_nJets25":
            warnings.warn( "EMTree: Expected branch Rivet_nJets25 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets25")
        else:
            self.Rivet_nJets25_branch.SetAddress(<void*>&self.Rivet_nJets25_value)

        #print "making Rivet_nJets30"
        self.Rivet_nJets30_branch = the_tree.GetBranch("Rivet_nJets30")
        #if not self.Rivet_nJets30_branch and "Rivet_nJets30" not in self.complained:
        if not self.Rivet_nJets30_branch and "Rivet_nJets30":
            warnings.warn( "EMTree: Expected branch Rivet_nJets30 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_nJets30")
        else:
            self.Rivet_nJets30_branch.SetAddress(<void*>&self.Rivet_nJets30_value)

        #print "making Rivet_p4decay_VEta"
        self.Rivet_p4decay_VEta_branch = the_tree.GetBranch("Rivet_p4decay_VEta")
        #if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta" not in self.complained:
        if not self.Rivet_p4decay_VEta_branch and "Rivet_p4decay_VEta":
            warnings.warn( "EMTree: Expected branch Rivet_p4decay_VEta does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VEta")
        else:
            self.Rivet_p4decay_VEta_branch.SetAddress(<void*>&self.Rivet_p4decay_VEta_value)

        #print "making Rivet_p4decay_VPt"
        self.Rivet_p4decay_VPt_branch = the_tree.GetBranch("Rivet_p4decay_VPt")
        #if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt" not in self.complained:
        if not self.Rivet_p4decay_VPt_branch and "Rivet_p4decay_VPt":
            warnings.warn( "EMTree: Expected branch Rivet_p4decay_VPt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_p4decay_VPt")
        else:
            self.Rivet_p4decay_VPt_branch.SetAddress(<void*>&self.Rivet_p4decay_VPt_value)

        #print "making Rivet_prodMode"
        self.Rivet_prodMode_branch = the_tree.GetBranch("Rivet_prodMode")
        #if not self.Rivet_prodMode_branch and "Rivet_prodMode" not in self.complained:
        if not self.Rivet_prodMode_branch and "Rivet_prodMode":
            warnings.warn( "EMTree: Expected branch Rivet_prodMode does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_prodMode")
        else:
            self.Rivet_prodMode_branch.SetAddress(<void*>&self.Rivet_prodMode_value)

        #print "making Rivet_stage0_cat"
        self.Rivet_stage0_cat_branch = the_tree.GetBranch("Rivet_stage0_cat")
        #if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat" not in self.complained:
        if not self.Rivet_stage0_cat_branch and "Rivet_stage0_cat":
            warnings.warn( "EMTree: Expected branch Rivet_stage0_cat does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage0_cat")
        else:
            self.Rivet_stage0_cat_branch.SetAddress(<void*>&self.Rivet_stage0_cat_value)

        #print "making Rivet_stage1_1_fine_cat_pTjet30GeV"
        self.Rivet_stage1_1_fine_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_1_fine_cat_pTjet30GeV")
        #if not self.Rivet_stage1_1_fine_cat_pTjet30GeV_branch and "Rivet_stage1_1_fine_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_1_fine_cat_pTjet30GeV_branch and "Rivet_stage1_1_fine_cat_pTjet30GeV":
            warnings.warn( "EMTree: Expected branch Rivet_stage1_1_fine_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_1_fine_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_1_fine_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_1_fine_cat_pTjet30GeV_value)

        #print "making Rivet_stage1_1_cat_pTjet30GeV"
        self.Rivet_stage1_1_cat_pTjet30GeV_branch = the_tree.GetBranch("Rivet_stage1_1_cat_pTjet30GeV")
        #if not self.Rivet_stage1_1_cat_pTjet30GeV_branch and "Rivet_stage1_1_cat_pTjet30GeV" not in self.complained:
        if not self.Rivet_stage1_1_cat_pTjet30GeV_branch and "Rivet_stage1_1_cat_pTjet30GeV":
            warnings.warn( "EMTree: Expected branch Rivet_stage1_1_cat_pTjet30GeV does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Rivet_stage1_1_cat_pTjet30GeV")
        else:
            self.Rivet_stage1_1_cat_pTjet30GeV_branch.SetAddress(<void*>&self.Rivet_stage1_1_cat_pTjet30GeV_value)

        #print "making npv"
        self.npv_branch = the_tree.GetBranch("npv")
        #if not self.npv_branch and "npv" not in self.complained:
        if not self.npv_branch and "npv":
            warnings.warn( "EMTree: Expected branch npv does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npv")
        else:
            self.npv_branch.SetAddress(<void*>&self.npv_value)

        #print "making npu"
        self.npu_branch = the_tree.GetBranch("npu")
        #if not self.npu_branch and "npu" not in self.complained:
        if not self.npu_branch and "npu":
            warnings.warn( "EMTree: Expected branch npu does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("npu")
        else:
            self.npu_branch.SetAddress(<void*>&self.npu_value)

        #print "making pt_1_ScaleUp"
        self.pt_1_ScaleUp_branch = the_tree.GetBranch("pt_1_ScaleUp")
        #if not self.pt_1_ScaleUp_branch and "pt_1_ScaleUp" not in self.complained:
        if not self.pt_1_ScaleUp_branch and "pt_1_ScaleUp":
            warnings.warn( "EMTree: Expected branch pt_1_ScaleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_1_ScaleUp")
        else:
            self.pt_1_ScaleUp_branch.SetAddress(<void*>&self.pt_1_ScaleUp_value)

        #print "making pt_1_ScaleDown"
        self.pt_1_ScaleDown_branch = the_tree.GetBranch("pt_1_ScaleDown")
        #if not self.pt_1_ScaleDown_branch and "pt_1_ScaleDown" not in self.complained:
        if not self.pt_1_ScaleDown_branch and "pt_1_ScaleDown":
            warnings.warn( "EMTree: Expected branch pt_1_ScaleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_1_ScaleDown")
        else:
            self.pt_1_ScaleDown_branch.SetAddress(<void*>&self.pt_1_ScaleDown_value)

        #print "making pt_1"
        self.pt_1_branch = the_tree.GetBranch("pt_1")
        #if not self.pt_1_branch and "pt_1" not in self.complained:
        if not self.pt_1_branch and "pt_1":
            warnings.warn( "EMTree: Expected branch pt_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_1")
        else:
            self.pt_1_branch.SetAddress(<void*>&self.pt_1_value)

        #print "making phi_1"
        self.phi_1_branch = the_tree.GetBranch("phi_1")
        #if not self.phi_1_branch and "phi_1" not in self.complained:
        if not self.phi_1_branch and "phi_1":
            warnings.warn( "EMTree: Expected branch phi_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("phi_1")
        else:
            self.phi_1_branch.SetAddress(<void*>&self.phi_1_value)

        #print "making eta_1"
        self.eta_1_branch = the_tree.GetBranch("eta_1")
        #if not self.eta_1_branch and "eta_1" not in self.complained:
        if not self.eta_1_branch and "eta_1":
            warnings.warn( "EMTree: Expected branch eta_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eta_1")
        else:
            self.eta_1_branch.SetAddress(<void*>&self.eta_1_value)

        #print "making m_1"
        self.m_1_branch = the_tree.GetBranch("m_1")
        #if not self.m_1_branch and "m_1" not in self.complained:
        if not self.m_1_branch and "m_1":
            warnings.warn( "EMTree: Expected branch m_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_1")
        else:
            self.m_1_branch.SetAddress(<void*>&self.m_1_value)

        #print "making e_1"
        self.e_1_branch = the_tree.GetBranch("e_1")
        #if not self.e_1_branch and "e_1" not in self.complained:
        if not self.e_1_branch and "e_1":
            warnings.warn( "EMTree: Expected branch e_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_1")
        else:
            self.e_1_branch.SetAddress(<void*>&self.e_1_value)

        #print "making q_1"
        self.q_1_branch = the_tree.GetBranch("q_1")
        #if not self.q_1_branch and "q_1" not in self.complained:
        if not self.q_1_branch and "q_1":
            warnings.warn( "EMTree: Expected branch q_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("q_1")
        else:
            self.q_1_branch.SetAddress(<void*>&self.q_1_value)

        #print "making iso_1"
        self.iso_1_branch = the_tree.GetBranch("iso_1")
        #if not self.iso_1_branch and "iso_1" not in self.complained:
        if not self.iso_1_branch and "iso_1":
            warnings.warn( "EMTree: Expected branch iso_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("iso_1")
        else:
            self.iso_1_branch.SetAddress(<void*>&self.iso_1_value)

        #print "making pt_2"
        self.pt_2_branch = the_tree.GetBranch("pt_2")
        #if not self.pt_2_branch and "pt_2" not in self.complained:
        if not self.pt_2_branch and "pt_2":
            warnings.warn( "EMTree: Expected branch pt_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_2")
        else:
            self.pt_2_branch.SetAddress(<void*>&self.pt_2_value)

        #print "making phi_2"
        self.phi_2_branch = the_tree.GetBranch("phi_2")
        #if not self.phi_2_branch and "phi_2" not in self.complained:
        if not self.phi_2_branch and "phi_2":
            warnings.warn( "EMTree: Expected branch phi_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("phi_2")
        else:
            self.phi_2_branch.SetAddress(<void*>&self.phi_2_value)

        #print "making eta_2"
        self.eta_2_branch = the_tree.GetBranch("eta_2")
        #if not self.eta_2_branch and "eta_2" not in self.complained:
        if not self.eta_2_branch and "eta_2":
            warnings.warn( "EMTree: Expected branch eta_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("eta_2")
        else:
            self.eta_2_branch.SetAddress(<void*>&self.eta_2_value)

        #print "making m_2"
        self.m_2_branch = the_tree.GetBranch("m_2")
        #if not self.m_2_branch and "m_2" not in self.complained:
        if not self.m_2_branch and "m_2":
            warnings.warn( "EMTree: Expected branch m_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("m_2")
        else:
            self.m_2_branch.SetAddress(<void*>&self.m_2_value)

        #print "making e_2"
        self.e_2_branch = the_tree.GetBranch("e_2")
        #if not self.e_2_branch and "e_2" not in self.complained:
        if not self.e_2_branch and "e_2":
            warnings.warn( "EMTree: Expected branch e_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("e_2")
        else:
            self.e_2_branch.SetAddress(<void*>&self.e_2_value)

        #print "making q_2"
        self.q_2_branch = the_tree.GetBranch("q_2")
        #if not self.q_2_branch and "q_2" not in self.complained:
        if not self.q_2_branch and "q_2":
            warnings.warn( "EMTree: Expected branch q_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("q_2")
        else:
            self.q_2_branch.SetAddress(<void*>&self.q_2_value)

        #print "making iso_2"
        self.iso_2_branch = the_tree.GetBranch("iso_2")
        #if not self.iso_2_branch and "iso_2" not in self.complained:
        if not self.iso_2_branch and "iso_2":
            warnings.warn( "EMTree: Expected branch iso_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("iso_2")
        else:
            self.iso_2_branch.SetAddress(<void*>&self.iso_2_value)

        #print "making numGenJets"
        self.numGenJets_branch = the_tree.GetBranch("numGenJets")
        #if not self.numGenJets_branch and "numGenJets" not in self.complained:
        if not self.numGenJets_branch and "numGenJets":
            warnings.warn( "EMTree: Expected branch numGenJets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("numGenJets")
        else:
            self.numGenJets_branch.SetAddress(<void*>&self.numGenJets_value)

        #print "making bweight"
        self.bweight_branch = the_tree.GetBranch("bweight")
        #if not self.bweight_branch and "bweight" not in self.complained:
        if not self.bweight_branch and "bweight":
            warnings.warn( "EMTree: Expected branch bweight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bweight")
        else:
            self.bweight_branch.SetAddress(<void*>&self.bweight_value)

        #print "making Flag_ecalBadCalibReducedMINIAODFilter"
        self.Flag_ecalBadCalibReducedMINIAODFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibReducedMINIAODFilter")
        #if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter" not in self.complained:
        if not self.Flag_ecalBadCalibReducedMINIAODFilter_branch and "Flag_ecalBadCalibReducedMINIAODFilter":
            warnings.warn( "EMTree: Expected branch Flag_ecalBadCalibReducedMINIAODFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibReducedMINIAODFilter")
        else:
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibReducedMINIAODFilter_value)

        #print "making Flag_goodVertices"
        self.Flag_goodVertices_branch = the_tree.GetBranch("Flag_goodVertices")
        #if not self.Flag_goodVertices_branch and "Flag_goodVertices" not in self.complained:
        if not self.Flag_goodVertices_branch and "Flag_goodVertices":
            warnings.warn( "EMTree: Expected branch Flag_goodVertices does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_goodVertices")
        else:
            self.Flag_goodVertices_branch.SetAddress(<void*>&self.Flag_goodVertices_value)

        #print "making Flag_globalSuperTightHalo2016Filter"
        self.Flag_globalSuperTightHalo2016Filter_branch = the_tree.GetBranch("Flag_globalSuperTightHalo2016Filter")
        #if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter" not in self.complained:
        if not self.Flag_globalSuperTightHalo2016Filter_branch and "Flag_globalSuperTightHalo2016Filter":
            warnings.warn( "EMTree: Expected branch Flag_globalSuperTightHalo2016Filter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_globalSuperTightHalo2016Filter")
        else:
            self.Flag_globalSuperTightHalo2016Filter_branch.SetAddress(<void*>&self.Flag_globalSuperTightHalo2016Filter_value)

        #print "making Flag_eeBadScFilter"
        self.Flag_eeBadScFilter_branch = the_tree.GetBranch("Flag_eeBadScFilter")
        #if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter" not in self.complained:
        if not self.Flag_eeBadScFilter_branch and "Flag_eeBadScFilter":
            warnings.warn( "EMTree: Expected branch Flag_eeBadScFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_eeBadScFilter")
        else:
            self.Flag_eeBadScFilter_branch.SetAddress(<void*>&self.Flag_eeBadScFilter_value)

        #print "making Flag_ecalBadCalibFilter"
        self.Flag_ecalBadCalibFilter_branch = the_tree.GetBranch("Flag_ecalBadCalibFilter")
        #if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter" not in self.complained:
        if not self.Flag_ecalBadCalibFilter_branch and "Flag_ecalBadCalibFilter":
            warnings.warn( "EMTree: Expected branch Flag_ecalBadCalibFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_ecalBadCalibFilter")
        else:
            self.Flag_ecalBadCalibFilter_branch.SetAddress(<void*>&self.Flag_ecalBadCalibFilter_value)

        #print "making Flag_badMuons"
        self.Flag_badMuons_branch = the_tree.GetBranch("Flag_badMuons")
        #if not self.Flag_badMuons_branch and "Flag_badMuons" not in self.complained:
        if not self.Flag_badMuons_branch and "Flag_badMuons":
            warnings.warn( "EMTree: Expected branch Flag_badMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_badMuons")
        else:
            self.Flag_badMuons_branch.SetAddress(<void*>&self.Flag_badMuons_value)

        #print "making Flag_duplicateMuons"
        self.Flag_duplicateMuons_branch = the_tree.GetBranch("Flag_duplicateMuons")
        #if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons" not in self.complained:
        if not self.Flag_duplicateMuons_branch and "Flag_duplicateMuons":
            warnings.warn( "EMTree: Expected branch Flag_duplicateMuons does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_duplicateMuons")
        else:
            self.Flag_duplicateMuons_branch.SetAddress(<void*>&self.Flag_duplicateMuons_value)

        #print "making Flag_HBHENoiseIsoFilter"
        self.Flag_HBHENoiseIsoFilter_branch = the_tree.GetBranch("Flag_HBHENoiseIsoFilter")
        #if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter" not in self.complained:
        if not self.Flag_HBHENoiseIsoFilter_branch and "Flag_HBHENoiseIsoFilter":
            warnings.warn( "EMTree: Expected branch Flag_HBHENoiseIsoFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseIsoFilter")
        else:
            self.Flag_HBHENoiseIsoFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseIsoFilter_value)

        #print "making Flag_HBHENoiseFilter"
        self.Flag_HBHENoiseFilter_branch = the_tree.GetBranch("Flag_HBHENoiseFilter")
        #if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter" not in self.complained:
        if not self.Flag_HBHENoiseFilter_branch and "Flag_HBHENoiseFilter":
            warnings.warn( "EMTree: Expected branch Flag_HBHENoiseFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_HBHENoiseFilter")
        else:
            self.Flag_HBHENoiseFilter_branch.SetAddress(<void*>&self.Flag_HBHENoiseFilter_value)

        #print "making Flag_EcalDeadCellTriggerPrimitiveFilter"
        self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch = the_tree.GetBranch("Flag_EcalDeadCellTriggerPrimitiveFilter")
        #if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter" not in self.complained:
        if not self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch and "Flag_EcalDeadCellTriggerPrimitiveFilter":
            warnings.warn( "EMTree: Expected branch Flag_EcalDeadCellTriggerPrimitiveFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_EcalDeadCellTriggerPrimitiveFilter")
        else:
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.SetAddress(<void*>&self.Flag_EcalDeadCellTriggerPrimitiveFilter_value)

        #print "making Flag_BadPFMuonFilter"
        self.Flag_BadPFMuonFilter_branch = the_tree.GetBranch("Flag_BadPFMuonFilter")
        #if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter" not in self.complained:
        if not self.Flag_BadPFMuonFilter_branch and "Flag_BadPFMuonFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadPFMuonFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadPFMuonFilter")
        else:
            self.Flag_BadPFMuonFilter_branch.SetAddress(<void*>&self.Flag_BadPFMuonFilter_value)

        #print "making Flag_BadChargedCandidateFilter"
        self.Flag_BadChargedCandidateFilter_branch = the_tree.GetBranch("Flag_BadChargedCandidateFilter")
        #if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter" not in self.complained:
        if not self.Flag_BadChargedCandidateFilter_branch and "Flag_BadChargedCandidateFilter":
            warnings.warn( "EMTree: Expected branch Flag_BadChargedCandidateFilter does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("Flag_BadChargedCandidateFilter")
        else:
            self.Flag_BadChargedCandidateFilter_branch.SetAddress(<void*>&self.Flag_BadChargedCandidateFilter_value)

        #print "making met"
        self.met_branch = the_tree.GetBranch("met")
        #if not self.met_branch and "met" not in self.complained:
        if not self.met_branch and "met":
            warnings.warn( "EMTree: Expected branch met does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met")
        else:
            self.met_branch.SetAddress(<void*>&self.met_value)

        #print "making metSig"
        self.metSig_branch = the_tree.GetBranch("metSig")
        #if not self.metSig_branch and "metSig" not in self.complained:
        if not self.metSig_branch and "metSig":
            warnings.warn( "EMTree: Expected branch metSig does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metSig")
        else:
            self.metSig_branch.SetAddress(<void*>&self.metSig_value)

        #print "making metcov00"
        self.metcov00_branch = the_tree.GetBranch("metcov00")
        #if not self.metcov00_branch and "metcov00" not in self.complained:
        if not self.metcov00_branch and "metcov00":
            warnings.warn( "EMTree: Expected branch metcov00 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov00")
        else:
            self.metcov00_branch.SetAddress(<void*>&self.metcov00_value)

        #print "making metcov10"
        self.metcov10_branch = the_tree.GetBranch("metcov10")
        #if not self.metcov10_branch and "metcov10" not in self.complained:
        if not self.metcov10_branch and "metcov10":
            warnings.warn( "EMTree: Expected branch metcov10 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov10")
        else:
            self.metcov10_branch.SetAddress(<void*>&self.metcov10_value)

        #print "making metcov11"
        self.metcov11_branch = the_tree.GetBranch("metcov11")
        #if not self.metcov11_branch and "metcov11" not in self.complained:
        if not self.metcov11_branch and "metcov11":
            warnings.warn( "EMTree: Expected branch metcov11 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov11")
        else:
            self.metcov11_branch.SetAddress(<void*>&self.metcov11_value)

        #print "making metcov01"
        self.metcov01_branch = the_tree.GetBranch("metcov01")
        #if not self.metcov01_branch and "metcov01" not in self.complained:
        if not self.metcov01_branch and "metcov01":
            warnings.warn( "EMTree: Expected branch metcov01 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metcov01")
        else:
            self.metcov01_branch.SetAddress(<void*>&self.metcov01_value)

        #print "making metphi"
        self.metphi_branch = the_tree.GetBranch("metphi")
        #if not self.metphi_branch and "metphi" not in self.complained:
        if not self.metphi_branch and "metphi":
            warnings.warn( "EMTree: Expected branch metphi does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi")
        else:
            self.metphi_branch.SetAddress(<void*>&self.metphi_value)

        #print "making met_py"
        self.met_py_branch = the_tree.GetBranch("met_py")
        #if not self.met_py_branch and "met_py" not in self.complained:
        if not self.met_py_branch and "met_py":
            warnings.warn( "EMTree: Expected branch met_py does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_py")
        else:
            self.met_py_branch.SetAddress(<void*>&self.met_py_value)

        #print "making met_px"
        self.met_px_branch = the_tree.GetBranch("met_px")
        #if not self.met_px_branch and "met_px" not in self.complained:
        if not self.met_px_branch and "met_px":
            warnings.warn( "EMTree: Expected branch met_px does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_px")
        else:
            self.met_px_branch.SetAddress(<void*>&self.met_px_value)

        #print "making met_UESUp"
        self.met_UESUp_branch = the_tree.GetBranch("met_UESUp")
        #if not self.met_UESUp_branch and "met_UESUp" not in self.complained:
        if not self.met_UESUp_branch and "met_UESUp":
            warnings.warn( "EMTree: Expected branch met_UESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_UESUp")
        else:
            self.met_UESUp_branch.SetAddress(<void*>&self.met_UESUp_value)

        #print "making metphi_UESUp"
        self.metphi_UESUp_branch = the_tree.GetBranch("metphi_UESUp")
        #if not self.metphi_UESUp_branch and "metphi_UESUp" not in self.complained:
        if not self.metphi_UESUp_branch and "metphi_UESUp":
            warnings.warn( "EMTree: Expected branch metphi_UESUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_UESUp")
        else:
            self.metphi_UESUp_branch.SetAddress(<void*>&self.metphi_UESUp_value)

        #print "making met_UESDown"
        self.met_UESDown_branch = the_tree.GetBranch("met_UESDown")
        #if not self.met_UESDown_branch and "met_UESDown" not in self.complained:
        if not self.met_UESDown_branch and "met_UESDown":
            warnings.warn( "EMTree: Expected branch met_UESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_UESDown")
        else:
            self.met_UESDown_branch.SetAddress(<void*>&self.met_UESDown_value)

        #print "making metphi_UESDown"
        self.metphi_UESDown_branch = the_tree.GetBranch("metphi_UESDown")
        #if not self.metphi_UESDown_branch and "metphi_UESDown" not in self.complained:
        if not self.metphi_UESDown_branch and "metphi_UESDown":
            warnings.warn( "EMTree: Expected branch metphi_UESDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_UESDown")
        else:
            self.metphi_UESDown_branch.SetAddress(<void*>&self.metphi_UESDown_value)

        #print "making met_JetAbsoluteUp"
        self.met_JetAbsoluteUp_branch = the_tree.GetBranch("met_JetAbsoluteUp")
        #if not self.met_JetAbsoluteUp_branch and "met_JetAbsoluteUp" not in self.complained:
        if not self.met_JetAbsoluteUp_branch and "met_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch met_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetAbsoluteUp")
        else:
            self.met_JetAbsoluteUp_branch.SetAddress(<void*>&self.met_JetAbsoluteUp_value)

        #print "making metphi_JetAbsoluteUp"
        self.metphi_JetAbsoluteUp_branch = the_tree.GetBranch("metphi_JetAbsoluteUp")
        #if not self.metphi_JetAbsoluteUp_branch and "metphi_JetAbsoluteUp" not in self.complained:
        if not self.metphi_JetAbsoluteUp_branch and "metphi_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch metphi_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetAbsoluteUp")
        else:
            self.metphi_JetAbsoluteUp_branch.SetAddress(<void*>&self.metphi_JetAbsoluteUp_value)

        #print "making met_JetAbsoluteDown"
        self.met_JetAbsoluteDown_branch = the_tree.GetBranch("met_JetAbsoluteDown")
        #if not self.met_JetAbsoluteDown_branch and "met_JetAbsoluteDown" not in self.complained:
        if not self.met_JetAbsoluteDown_branch and "met_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch met_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetAbsoluteDown")
        else:
            self.met_JetAbsoluteDown_branch.SetAddress(<void*>&self.met_JetAbsoluteDown_value)

        #print "making metphi_JetAbsoluteDown"
        self.metphi_JetAbsoluteDown_branch = the_tree.GetBranch("metphi_JetAbsoluteDown")
        #if not self.metphi_JetAbsoluteDown_branch and "metphi_JetAbsoluteDown" not in self.complained:
        if not self.metphi_JetAbsoluteDown_branch and "metphi_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch metphi_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetAbsoluteDown")
        else:
            self.metphi_JetAbsoluteDown_branch.SetAddress(<void*>&self.metphi_JetAbsoluteDown_value)

        #print "making met_JetAbsoluteyearUp"
        self.met_JetAbsoluteyearUp_branch = the_tree.GetBranch("met_JetAbsoluteyearUp")
        #if not self.met_JetAbsoluteyearUp_branch and "met_JetAbsoluteyearUp" not in self.complained:
        if not self.met_JetAbsoluteyearUp_branch and "met_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch met_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetAbsoluteyearUp")
        else:
            self.met_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.met_JetAbsoluteyearUp_value)

        #print "making metphi_JetAbsoluteyearUp"
        self.metphi_JetAbsoluteyearUp_branch = the_tree.GetBranch("metphi_JetAbsoluteyearUp")
        #if not self.metphi_JetAbsoluteyearUp_branch and "metphi_JetAbsoluteyearUp" not in self.complained:
        if not self.metphi_JetAbsoluteyearUp_branch and "metphi_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch metphi_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetAbsoluteyearUp")
        else:
            self.metphi_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.metphi_JetAbsoluteyearUp_value)

        #print "making met_JetAbsoluteyearDown"
        self.met_JetAbsoluteyearDown_branch = the_tree.GetBranch("met_JetAbsoluteyearDown")
        #if not self.met_JetAbsoluteyearDown_branch and "met_JetAbsoluteyearDown" not in self.complained:
        if not self.met_JetAbsoluteyearDown_branch and "met_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch met_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetAbsoluteyearDown")
        else:
            self.met_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.met_JetAbsoluteyearDown_value)

        #print "making metphi_JetAbsoluteyearDown"
        self.metphi_JetAbsoluteyearDown_branch = the_tree.GetBranch("metphi_JetAbsoluteyearDown")
        #if not self.metphi_JetAbsoluteyearDown_branch and "metphi_JetAbsoluteyearDown" not in self.complained:
        if not self.metphi_JetAbsoluteyearDown_branch and "metphi_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch metphi_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetAbsoluteyearDown")
        else:
            self.metphi_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.metphi_JetAbsoluteyearDown_value)

        #print "making met_JetBBEC1Up"
        self.met_JetBBEC1Up_branch = the_tree.GetBranch("met_JetBBEC1Up")
        #if not self.met_JetBBEC1Up_branch and "met_JetBBEC1Up" not in self.complained:
        if not self.met_JetBBEC1Up_branch and "met_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch met_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetBBEC1Up")
        else:
            self.met_JetBBEC1Up_branch.SetAddress(<void*>&self.met_JetBBEC1Up_value)

        #print "making metphi_JetBBEC1Up"
        self.metphi_JetBBEC1Up_branch = the_tree.GetBranch("metphi_JetBBEC1Up")
        #if not self.metphi_JetBBEC1Up_branch and "metphi_JetBBEC1Up" not in self.complained:
        if not self.metphi_JetBBEC1Up_branch and "metphi_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch metphi_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetBBEC1Up")
        else:
            self.metphi_JetBBEC1Up_branch.SetAddress(<void*>&self.metphi_JetBBEC1Up_value)

        #print "making met_JetBBEC1Down"
        self.met_JetBBEC1Down_branch = the_tree.GetBranch("met_JetBBEC1Down")
        #if not self.met_JetBBEC1Down_branch and "met_JetBBEC1Down" not in self.complained:
        if not self.met_JetBBEC1Down_branch and "met_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch met_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetBBEC1Down")
        else:
            self.met_JetBBEC1Down_branch.SetAddress(<void*>&self.met_JetBBEC1Down_value)

        #print "making metphi_JetBBEC1Down"
        self.metphi_JetBBEC1Down_branch = the_tree.GetBranch("metphi_JetBBEC1Down")
        #if not self.metphi_JetBBEC1Down_branch and "metphi_JetBBEC1Down" not in self.complained:
        if not self.metphi_JetBBEC1Down_branch and "metphi_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch metphi_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetBBEC1Down")
        else:
            self.metphi_JetBBEC1Down_branch.SetAddress(<void*>&self.metphi_JetBBEC1Down_value)

        #print "making met_JetBBEC1yearUp"
        self.met_JetBBEC1yearUp_branch = the_tree.GetBranch("met_JetBBEC1yearUp")
        #if not self.met_JetBBEC1yearUp_branch and "met_JetBBEC1yearUp" not in self.complained:
        if not self.met_JetBBEC1yearUp_branch and "met_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch met_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetBBEC1yearUp")
        else:
            self.met_JetBBEC1yearUp_branch.SetAddress(<void*>&self.met_JetBBEC1yearUp_value)

        #print "making metphi_JetBBEC1yearUp"
        self.metphi_JetBBEC1yearUp_branch = the_tree.GetBranch("metphi_JetBBEC1yearUp")
        #if not self.metphi_JetBBEC1yearUp_branch and "metphi_JetBBEC1yearUp" not in self.complained:
        if not self.metphi_JetBBEC1yearUp_branch and "metphi_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch metphi_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetBBEC1yearUp")
        else:
            self.metphi_JetBBEC1yearUp_branch.SetAddress(<void*>&self.metphi_JetBBEC1yearUp_value)

        #print "making met_JetBBEC1yearDown"
        self.met_JetBBEC1yearDown_branch = the_tree.GetBranch("met_JetBBEC1yearDown")
        #if not self.met_JetBBEC1yearDown_branch and "met_JetBBEC1yearDown" not in self.complained:
        if not self.met_JetBBEC1yearDown_branch and "met_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch met_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetBBEC1yearDown")
        else:
            self.met_JetBBEC1yearDown_branch.SetAddress(<void*>&self.met_JetBBEC1yearDown_value)

        #print "making metphi_JetBBEC1yearDown"
        self.metphi_JetBBEC1yearDown_branch = the_tree.GetBranch("metphi_JetBBEC1yearDown")
        #if not self.metphi_JetBBEC1yearDown_branch and "metphi_JetBBEC1yearDown" not in self.complained:
        if not self.metphi_JetBBEC1yearDown_branch and "metphi_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch metphi_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetBBEC1yearDown")
        else:
            self.metphi_JetBBEC1yearDown_branch.SetAddress(<void*>&self.metphi_JetBBEC1yearDown_value)

        #print "making met_JetEC2Up"
        self.met_JetEC2Up_branch = the_tree.GetBranch("met_JetEC2Up")
        #if not self.met_JetEC2Up_branch and "met_JetEC2Up" not in self.complained:
        if not self.met_JetEC2Up_branch and "met_JetEC2Up":
            warnings.warn( "EMTree: Expected branch met_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetEC2Up")
        else:
            self.met_JetEC2Up_branch.SetAddress(<void*>&self.met_JetEC2Up_value)

        #print "making metphi_JetEC2Up"
        self.metphi_JetEC2Up_branch = the_tree.GetBranch("metphi_JetEC2Up")
        #if not self.metphi_JetEC2Up_branch and "metphi_JetEC2Up" not in self.complained:
        if not self.metphi_JetEC2Up_branch and "metphi_JetEC2Up":
            warnings.warn( "EMTree: Expected branch metphi_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetEC2Up")
        else:
            self.metphi_JetEC2Up_branch.SetAddress(<void*>&self.metphi_JetEC2Up_value)

        #print "making met_JetEC2Down"
        self.met_JetEC2Down_branch = the_tree.GetBranch("met_JetEC2Down")
        #if not self.met_JetEC2Down_branch and "met_JetEC2Down" not in self.complained:
        if not self.met_JetEC2Down_branch and "met_JetEC2Down":
            warnings.warn( "EMTree: Expected branch met_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetEC2Down")
        else:
            self.met_JetEC2Down_branch.SetAddress(<void*>&self.met_JetEC2Down_value)

        #print "making metphi_JetEC2Down"
        self.metphi_JetEC2Down_branch = the_tree.GetBranch("metphi_JetEC2Down")
        #if not self.metphi_JetEC2Down_branch and "metphi_JetEC2Down" not in self.complained:
        if not self.metphi_JetEC2Down_branch and "metphi_JetEC2Down":
            warnings.warn( "EMTree: Expected branch metphi_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetEC2Down")
        else:
            self.metphi_JetEC2Down_branch.SetAddress(<void*>&self.metphi_JetEC2Down_value)

        #print "making met_JetEC2yearUp"
        self.met_JetEC2yearUp_branch = the_tree.GetBranch("met_JetEC2yearUp")
        #if not self.met_JetEC2yearUp_branch and "met_JetEC2yearUp" not in self.complained:
        if not self.met_JetEC2yearUp_branch and "met_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch met_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetEC2yearUp")
        else:
            self.met_JetEC2yearUp_branch.SetAddress(<void*>&self.met_JetEC2yearUp_value)

        #print "making metphi_JetEC2yearUp"
        self.metphi_JetEC2yearUp_branch = the_tree.GetBranch("metphi_JetEC2yearUp")
        #if not self.metphi_JetEC2yearUp_branch and "metphi_JetEC2yearUp" not in self.complained:
        if not self.metphi_JetEC2yearUp_branch and "metphi_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch metphi_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetEC2yearUp")
        else:
            self.metphi_JetEC2yearUp_branch.SetAddress(<void*>&self.metphi_JetEC2yearUp_value)

        #print "making met_JetEC2yearDown"
        self.met_JetEC2yearDown_branch = the_tree.GetBranch("met_JetEC2yearDown")
        #if not self.met_JetEC2yearDown_branch and "met_JetEC2yearDown" not in self.complained:
        if not self.met_JetEC2yearDown_branch and "met_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch met_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetEC2yearDown")
        else:
            self.met_JetEC2yearDown_branch.SetAddress(<void*>&self.met_JetEC2yearDown_value)

        #print "making metphi_JetEC2yearDown"
        self.metphi_JetEC2yearDown_branch = the_tree.GetBranch("metphi_JetEC2yearDown")
        #if not self.metphi_JetEC2yearDown_branch and "metphi_JetEC2yearDown" not in self.complained:
        if not self.metphi_JetEC2yearDown_branch and "metphi_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch metphi_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetEC2yearDown")
        else:
            self.metphi_JetEC2yearDown_branch.SetAddress(<void*>&self.metphi_JetEC2yearDown_value)

        #print "making met_JetFlavorQCDUp"
        self.met_JetFlavorQCDUp_branch = the_tree.GetBranch("met_JetFlavorQCDUp")
        #if not self.met_JetFlavorQCDUp_branch and "met_JetFlavorQCDUp" not in self.complained:
        if not self.met_JetFlavorQCDUp_branch and "met_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch met_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetFlavorQCDUp")
        else:
            self.met_JetFlavorQCDUp_branch.SetAddress(<void*>&self.met_JetFlavorQCDUp_value)

        #print "making metphi_JetFlavorQCDUp"
        self.metphi_JetFlavorQCDUp_branch = the_tree.GetBranch("metphi_JetFlavorQCDUp")
        #if not self.metphi_JetFlavorQCDUp_branch and "metphi_JetFlavorQCDUp" not in self.complained:
        if not self.metphi_JetFlavorQCDUp_branch and "metphi_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch metphi_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetFlavorQCDUp")
        else:
            self.metphi_JetFlavorQCDUp_branch.SetAddress(<void*>&self.metphi_JetFlavorQCDUp_value)

        #print "making met_JetFlavorQCDDown"
        self.met_JetFlavorQCDDown_branch = the_tree.GetBranch("met_JetFlavorQCDDown")
        #if not self.met_JetFlavorQCDDown_branch and "met_JetFlavorQCDDown" not in self.complained:
        if not self.met_JetFlavorQCDDown_branch and "met_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch met_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetFlavorQCDDown")
        else:
            self.met_JetFlavorQCDDown_branch.SetAddress(<void*>&self.met_JetFlavorQCDDown_value)

        #print "making metphi_JetFlavorQCDDown"
        self.metphi_JetFlavorQCDDown_branch = the_tree.GetBranch("metphi_JetFlavorQCDDown")
        #if not self.metphi_JetFlavorQCDDown_branch and "metphi_JetFlavorQCDDown" not in self.complained:
        if not self.metphi_JetFlavorQCDDown_branch and "metphi_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch metphi_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetFlavorQCDDown")
        else:
            self.metphi_JetFlavorQCDDown_branch.SetAddress(<void*>&self.metphi_JetFlavorQCDDown_value)

        #print "making met_JetHFUp"
        self.met_JetHFUp_branch = the_tree.GetBranch("met_JetHFUp")
        #if not self.met_JetHFUp_branch and "met_JetHFUp" not in self.complained:
        if not self.met_JetHFUp_branch and "met_JetHFUp":
            warnings.warn( "EMTree: Expected branch met_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetHFUp")
        else:
            self.met_JetHFUp_branch.SetAddress(<void*>&self.met_JetHFUp_value)

        #print "making metphi_JetHFUp"
        self.metphi_JetHFUp_branch = the_tree.GetBranch("metphi_JetHFUp")
        #if not self.metphi_JetHFUp_branch and "metphi_JetHFUp" not in self.complained:
        if not self.metphi_JetHFUp_branch and "metphi_JetHFUp":
            warnings.warn( "EMTree: Expected branch metphi_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetHFUp")
        else:
            self.metphi_JetHFUp_branch.SetAddress(<void*>&self.metphi_JetHFUp_value)

        #print "making met_JetHFDown"
        self.met_JetHFDown_branch = the_tree.GetBranch("met_JetHFDown")
        #if not self.met_JetHFDown_branch and "met_JetHFDown" not in self.complained:
        if not self.met_JetHFDown_branch and "met_JetHFDown":
            warnings.warn( "EMTree: Expected branch met_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetHFDown")
        else:
            self.met_JetHFDown_branch.SetAddress(<void*>&self.met_JetHFDown_value)

        #print "making metphi_JetHFDown"
        self.metphi_JetHFDown_branch = the_tree.GetBranch("metphi_JetHFDown")
        #if not self.metphi_JetHFDown_branch and "metphi_JetHFDown" not in self.complained:
        if not self.metphi_JetHFDown_branch and "metphi_JetHFDown":
            warnings.warn( "EMTree: Expected branch metphi_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetHFDown")
        else:
            self.metphi_JetHFDown_branch.SetAddress(<void*>&self.metphi_JetHFDown_value)

        #print "making met_JetHFyearUp"
        self.met_JetHFyearUp_branch = the_tree.GetBranch("met_JetHFyearUp")
        #if not self.met_JetHFyearUp_branch and "met_JetHFyearUp" not in self.complained:
        if not self.met_JetHFyearUp_branch and "met_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch met_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetHFyearUp")
        else:
            self.met_JetHFyearUp_branch.SetAddress(<void*>&self.met_JetHFyearUp_value)

        #print "making metphi_JetHFyearUp"
        self.metphi_JetHFyearUp_branch = the_tree.GetBranch("metphi_JetHFyearUp")
        #if not self.metphi_JetHFyearUp_branch and "metphi_JetHFyearUp" not in self.complained:
        if not self.metphi_JetHFyearUp_branch and "metphi_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch metphi_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetHFyearUp")
        else:
            self.metphi_JetHFyearUp_branch.SetAddress(<void*>&self.metphi_JetHFyearUp_value)

        #print "making met_JetHFyearDown"
        self.met_JetHFyearDown_branch = the_tree.GetBranch("met_JetHFyearDown")
        #if not self.met_JetHFyearDown_branch and "met_JetHFyearDown" not in self.complained:
        if not self.met_JetHFyearDown_branch and "met_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch met_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetHFyearDown")
        else:
            self.met_JetHFyearDown_branch.SetAddress(<void*>&self.met_JetHFyearDown_value)

        #print "making metphi_JetHFyearDown"
        self.metphi_JetHFyearDown_branch = the_tree.GetBranch("metphi_JetHFyearDown")
        #if not self.metphi_JetHFyearDown_branch and "metphi_JetHFyearDown" not in self.complained:
        if not self.metphi_JetHFyearDown_branch and "metphi_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch metphi_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetHFyearDown")
        else:
            self.metphi_JetHFyearDown_branch.SetAddress(<void*>&self.metphi_JetHFyearDown_value)

        #print "making met_JetRelativeBalUp"
        self.met_JetRelativeBalUp_branch = the_tree.GetBranch("met_JetRelativeBalUp")
        #if not self.met_JetRelativeBalUp_branch and "met_JetRelativeBalUp" not in self.complained:
        if not self.met_JetRelativeBalUp_branch and "met_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch met_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetRelativeBalUp")
        else:
            self.met_JetRelativeBalUp_branch.SetAddress(<void*>&self.met_JetRelativeBalUp_value)

        #print "making metphi_JetRelativeBalUp"
        self.metphi_JetRelativeBalUp_branch = the_tree.GetBranch("metphi_JetRelativeBalUp")
        #if not self.metphi_JetRelativeBalUp_branch and "metphi_JetRelativeBalUp" not in self.complained:
        if not self.metphi_JetRelativeBalUp_branch and "metphi_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch metphi_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetRelativeBalUp")
        else:
            self.metphi_JetRelativeBalUp_branch.SetAddress(<void*>&self.metphi_JetRelativeBalUp_value)

        #print "making met_JetRelativeBalDown"
        self.met_JetRelativeBalDown_branch = the_tree.GetBranch("met_JetRelativeBalDown")
        #if not self.met_JetRelativeBalDown_branch and "met_JetRelativeBalDown" not in self.complained:
        if not self.met_JetRelativeBalDown_branch and "met_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch met_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetRelativeBalDown")
        else:
            self.met_JetRelativeBalDown_branch.SetAddress(<void*>&self.met_JetRelativeBalDown_value)

        #print "making metphi_JetRelativeBalDown"
        self.metphi_JetRelativeBalDown_branch = the_tree.GetBranch("metphi_JetRelativeBalDown")
        #if not self.metphi_JetRelativeBalDown_branch and "metphi_JetRelativeBalDown" not in self.complained:
        if not self.metphi_JetRelativeBalDown_branch and "metphi_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch metphi_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetRelativeBalDown")
        else:
            self.metphi_JetRelativeBalDown_branch.SetAddress(<void*>&self.metphi_JetRelativeBalDown_value)

        #print "making met_JetRelativeSampleUp"
        self.met_JetRelativeSampleUp_branch = the_tree.GetBranch("met_JetRelativeSampleUp")
        #if not self.met_JetRelativeSampleUp_branch and "met_JetRelativeSampleUp" not in self.complained:
        if not self.met_JetRelativeSampleUp_branch and "met_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch met_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetRelativeSampleUp")
        else:
            self.met_JetRelativeSampleUp_branch.SetAddress(<void*>&self.met_JetRelativeSampleUp_value)

        #print "making metphi_JetRelativeSampleUp"
        self.metphi_JetRelativeSampleUp_branch = the_tree.GetBranch("metphi_JetRelativeSampleUp")
        #if not self.metphi_JetRelativeSampleUp_branch and "metphi_JetRelativeSampleUp" not in self.complained:
        if not self.metphi_JetRelativeSampleUp_branch and "metphi_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch metphi_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetRelativeSampleUp")
        else:
            self.metphi_JetRelativeSampleUp_branch.SetAddress(<void*>&self.metphi_JetRelativeSampleUp_value)

        #print "making met_JetRelativeSampleDown"
        self.met_JetRelativeSampleDown_branch = the_tree.GetBranch("met_JetRelativeSampleDown")
        #if not self.met_JetRelativeSampleDown_branch and "met_JetRelativeSampleDown" not in self.complained:
        if not self.met_JetRelativeSampleDown_branch and "met_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch met_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JetRelativeSampleDown")
        else:
            self.met_JetRelativeSampleDown_branch.SetAddress(<void*>&self.met_JetRelativeSampleDown_value)

        #print "making metphi_JetRelativeSampleDown"
        self.metphi_JetRelativeSampleDown_branch = the_tree.GetBranch("metphi_JetRelativeSampleDown")
        #if not self.metphi_JetRelativeSampleDown_branch and "metphi_JetRelativeSampleDown" not in self.complained:
        if not self.metphi_JetRelativeSampleDown_branch and "metphi_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch metphi_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JetRelativeSampleDown")
        else:
            self.metphi_JetRelativeSampleDown_branch.SetAddress(<void*>&self.metphi_JetRelativeSampleDown_value)

        #print "making met_JERUp"
        self.met_JERUp_branch = the_tree.GetBranch("met_JERUp")
        #if not self.met_JERUp_branch and "met_JERUp" not in self.complained:
        if not self.met_JERUp_branch and "met_JERUp":
            warnings.warn( "EMTree: Expected branch met_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JERUp")
        else:
            self.met_JERUp_branch.SetAddress(<void*>&self.met_JERUp_value)

        #print "making metphi_JERUp"
        self.metphi_JERUp_branch = the_tree.GetBranch("metphi_JERUp")
        #if not self.metphi_JERUp_branch and "metphi_JERUp" not in self.complained:
        if not self.metphi_JERUp_branch and "metphi_JERUp":
            warnings.warn( "EMTree: Expected branch metphi_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JERUp")
        else:
            self.metphi_JERUp_branch.SetAddress(<void*>&self.metphi_JERUp_value)

        #print "making met_JERDown"
        self.met_JERDown_branch = the_tree.GetBranch("met_JERDown")
        #if not self.met_JERDown_branch and "met_JERDown" not in self.complained:
        if not self.met_JERDown_branch and "met_JERDown":
            warnings.warn( "EMTree: Expected branch met_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_JERDown")
        else:
            self.met_JERDown_branch.SetAddress(<void*>&self.met_JERDown_value)

        #print "making metphi_JERDown"
        self.metphi_JERDown_branch = the_tree.GetBranch("metphi_JERDown")
        #if not self.metphi_JERDown_branch and "metphi_JERDown" not in self.complained:
        if not self.metphi_JERDown_branch and "metphi_JERDown":
            warnings.warn( "EMTree: Expected branch metphi_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_JERDown")
        else:
            self.metphi_JERDown_branch.SetAddress(<void*>&self.metphi_JERDown_value)

        #print "making met_responseUp"
        self.met_responseUp_branch = the_tree.GetBranch("met_responseUp")
        #if not self.met_responseUp_branch and "met_responseUp" not in self.complained:
        if not self.met_responseUp_branch and "met_responseUp":
            warnings.warn( "EMTree: Expected branch met_responseUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_responseUp")
        else:
            self.met_responseUp_branch.SetAddress(<void*>&self.met_responseUp_value)

        #print "making met_responseDown"
        self.met_responseDown_branch = the_tree.GetBranch("met_responseDown")
        #if not self.met_responseDown_branch and "met_responseDown" not in self.complained:
        if not self.met_responseDown_branch and "met_responseDown":
            warnings.warn( "EMTree: Expected branch met_responseDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_responseDown")
        else:
            self.met_responseDown_branch.SetAddress(<void*>&self.met_responseDown_value)

        #print "making met_resolutionUp"
        self.met_resolutionUp_branch = the_tree.GetBranch("met_resolutionUp")
        #if not self.met_resolutionUp_branch and "met_resolutionUp" not in self.complained:
        if not self.met_resolutionUp_branch and "met_resolutionUp":
            warnings.warn( "EMTree: Expected branch met_resolutionUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_resolutionUp")
        else:
            self.met_resolutionUp_branch.SetAddress(<void*>&self.met_resolutionUp_value)

        #print "making met_resolutionDown"
        self.met_resolutionDown_branch = the_tree.GetBranch("met_resolutionDown")
        #if not self.met_resolutionDown_branch and "met_resolutionDown" not in self.complained:
        if not self.met_resolutionDown_branch and "met_resolutionDown":
            warnings.warn( "EMTree: Expected branch met_resolutionDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("met_resolutionDown")
        else:
            self.met_resolutionDown_branch.SetAddress(<void*>&self.met_resolutionDown_value)

        #print "making metphi_responseUp"
        self.metphi_responseUp_branch = the_tree.GetBranch("metphi_responseUp")
        #if not self.metphi_responseUp_branch and "metphi_responseUp" not in self.complained:
        if not self.metphi_responseUp_branch and "metphi_responseUp":
            warnings.warn( "EMTree: Expected branch metphi_responseUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_responseUp")
        else:
            self.metphi_responseUp_branch.SetAddress(<void*>&self.metphi_responseUp_value)

        #print "making metphi_responseDown"
        self.metphi_responseDown_branch = the_tree.GetBranch("metphi_responseDown")
        #if not self.metphi_responseDown_branch and "metphi_responseDown" not in self.complained:
        if not self.metphi_responseDown_branch and "metphi_responseDown":
            warnings.warn( "EMTree: Expected branch metphi_responseDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_responseDown")
        else:
            self.metphi_responseDown_branch.SetAddress(<void*>&self.metphi_responseDown_value)

        #print "making metphi_resolutionUp"
        self.metphi_resolutionUp_branch = the_tree.GetBranch("metphi_resolutionUp")
        #if not self.metphi_resolutionUp_branch and "metphi_resolutionUp" not in self.complained:
        if not self.metphi_resolutionUp_branch and "metphi_resolutionUp":
            warnings.warn( "EMTree: Expected branch metphi_resolutionUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_resolutionUp")
        else:
            self.metphi_resolutionUp_branch.SetAddress(<void*>&self.metphi_resolutionUp_value)

        #print "making metphi_resolutionDown"
        self.metphi_resolutionDown_branch = the_tree.GetBranch("metphi_resolutionDown")
        #if not self.metphi_resolutionDown_branch and "metphi_resolutionDown" not in self.complained:
        if not self.metphi_resolutionDown_branch and "metphi_resolutionDown":
            warnings.warn( "EMTree: Expected branch metphi_resolutionDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("metphi_resolutionDown")
        else:
            self.metphi_resolutionDown_branch.SetAddress(<void*>&self.metphi_resolutionDown_value)

        #print "making mjj"
        self.mjj_branch = the_tree.GetBranch("mjj")
        #if not self.mjj_branch and "mjj" not in self.complained:
        if not self.mjj_branch and "mjj":
            warnings.warn( "EMTree: Expected branch mjj does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj")
        else:
            self.mjj_branch.SetAddress(<void*>&self.mjj_value)

        #print "making mjj_JetAbsoluteUp"
        self.mjj_JetAbsoluteUp_branch = the_tree.GetBranch("mjj_JetAbsoluteUp")
        #if not self.mjj_JetAbsoluteUp_branch and "mjj_JetAbsoluteUp" not in self.complained:
        if not self.mjj_JetAbsoluteUp_branch and "mjj_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch mjj_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetAbsoluteUp")
        else:
            self.mjj_JetAbsoluteUp_branch.SetAddress(<void*>&self.mjj_JetAbsoluteUp_value)

        #print "making mjj_JetAbsoluteDown"
        self.mjj_JetAbsoluteDown_branch = the_tree.GetBranch("mjj_JetAbsoluteDown")
        #if not self.mjj_JetAbsoluteDown_branch and "mjj_JetAbsoluteDown" not in self.complained:
        if not self.mjj_JetAbsoluteDown_branch and "mjj_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch mjj_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetAbsoluteDown")
        else:
            self.mjj_JetAbsoluteDown_branch.SetAddress(<void*>&self.mjj_JetAbsoluteDown_value)

        #print "making mjj_JetAbsoluteyearUp"
        self.mjj_JetAbsoluteyearUp_branch = the_tree.GetBranch("mjj_JetAbsoluteyearUp")
        #if not self.mjj_JetAbsoluteyearUp_branch and "mjj_JetAbsoluteyearUp" not in self.complained:
        if not self.mjj_JetAbsoluteyearUp_branch and "mjj_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch mjj_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetAbsoluteyearUp")
        else:
            self.mjj_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.mjj_JetAbsoluteyearUp_value)

        #print "making mjj_JetAbsoluteyearDown"
        self.mjj_JetAbsoluteyearDown_branch = the_tree.GetBranch("mjj_JetAbsoluteyearDown")
        #if not self.mjj_JetAbsoluteyearDown_branch and "mjj_JetAbsoluteyearDown" not in self.complained:
        if not self.mjj_JetAbsoluteyearDown_branch and "mjj_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch mjj_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetAbsoluteyearDown")
        else:
            self.mjj_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.mjj_JetAbsoluteyearDown_value)

        #print "making mjj_JetBBEC1Up"
        self.mjj_JetBBEC1Up_branch = the_tree.GetBranch("mjj_JetBBEC1Up")
        #if not self.mjj_JetBBEC1Up_branch and "mjj_JetBBEC1Up" not in self.complained:
        if not self.mjj_JetBBEC1Up_branch and "mjj_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch mjj_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetBBEC1Up")
        else:
            self.mjj_JetBBEC1Up_branch.SetAddress(<void*>&self.mjj_JetBBEC1Up_value)

        #print "making mjj_JetBBEC1Down"
        self.mjj_JetBBEC1Down_branch = the_tree.GetBranch("mjj_JetBBEC1Down")
        #if not self.mjj_JetBBEC1Down_branch and "mjj_JetBBEC1Down" not in self.complained:
        if not self.mjj_JetBBEC1Down_branch and "mjj_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch mjj_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetBBEC1Down")
        else:
            self.mjj_JetBBEC1Down_branch.SetAddress(<void*>&self.mjj_JetBBEC1Down_value)

        #print "making mjj_JetBBEC1yearUp"
        self.mjj_JetBBEC1yearUp_branch = the_tree.GetBranch("mjj_JetBBEC1yearUp")
        #if not self.mjj_JetBBEC1yearUp_branch and "mjj_JetBBEC1yearUp" not in self.complained:
        if not self.mjj_JetBBEC1yearUp_branch and "mjj_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch mjj_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetBBEC1yearUp")
        else:
            self.mjj_JetBBEC1yearUp_branch.SetAddress(<void*>&self.mjj_JetBBEC1yearUp_value)

        #print "making mjj_JetBBEC1yearDown"
        self.mjj_JetBBEC1yearDown_branch = the_tree.GetBranch("mjj_JetBBEC1yearDown")
        #if not self.mjj_JetBBEC1yearDown_branch and "mjj_JetBBEC1yearDown" not in self.complained:
        if not self.mjj_JetBBEC1yearDown_branch and "mjj_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch mjj_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetBBEC1yearDown")
        else:
            self.mjj_JetBBEC1yearDown_branch.SetAddress(<void*>&self.mjj_JetBBEC1yearDown_value)

        #print "making mjj_JetEC2Up"
        self.mjj_JetEC2Up_branch = the_tree.GetBranch("mjj_JetEC2Up")
        #if not self.mjj_JetEC2Up_branch and "mjj_JetEC2Up" not in self.complained:
        if not self.mjj_JetEC2Up_branch and "mjj_JetEC2Up":
            warnings.warn( "EMTree: Expected branch mjj_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetEC2Up")
        else:
            self.mjj_JetEC2Up_branch.SetAddress(<void*>&self.mjj_JetEC2Up_value)

        #print "making mjj_JetEC2Down"
        self.mjj_JetEC2Down_branch = the_tree.GetBranch("mjj_JetEC2Down")
        #if not self.mjj_JetEC2Down_branch and "mjj_JetEC2Down" not in self.complained:
        if not self.mjj_JetEC2Down_branch and "mjj_JetEC2Down":
            warnings.warn( "EMTree: Expected branch mjj_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetEC2Down")
        else:
            self.mjj_JetEC2Down_branch.SetAddress(<void*>&self.mjj_JetEC2Down_value)

        #print "making mjj_JetEC2yearUp"
        self.mjj_JetEC2yearUp_branch = the_tree.GetBranch("mjj_JetEC2yearUp")
        #if not self.mjj_JetEC2yearUp_branch and "mjj_JetEC2yearUp" not in self.complained:
        if not self.mjj_JetEC2yearUp_branch and "mjj_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch mjj_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetEC2yearUp")
        else:
            self.mjj_JetEC2yearUp_branch.SetAddress(<void*>&self.mjj_JetEC2yearUp_value)

        #print "making mjj_JetEC2yearDown"
        self.mjj_JetEC2yearDown_branch = the_tree.GetBranch("mjj_JetEC2yearDown")
        #if not self.mjj_JetEC2yearDown_branch and "mjj_JetEC2yearDown" not in self.complained:
        if not self.mjj_JetEC2yearDown_branch and "mjj_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch mjj_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetEC2yearDown")
        else:
            self.mjj_JetEC2yearDown_branch.SetAddress(<void*>&self.mjj_JetEC2yearDown_value)

        #print "making mjj_JetFlavorQCDUp"
        self.mjj_JetFlavorQCDUp_branch = the_tree.GetBranch("mjj_JetFlavorQCDUp")
        #if not self.mjj_JetFlavorQCDUp_branch and "mjj_JetFlavorQCDUp" not in self.complained:
        if not self.mjj_JetFlavorQCDUp_branch and "mjj_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch mjj_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetFlavorQCDUp")
        else:
            self.mjj_JetFlavorQCDUp_branch.SetAddress(<void*>&self.mjj_JetFlavorQCDUp_value)

        #print "making mjj_JetFlavorQCDDown"
        self.mjj_JetFlavorQCDDown_branch = the_tree.GetBranch("mjj_JetFlavorQCDDown")
        #if not self.mjj_JetFlavorQCDDown_branch and "mjj_JetFlavorQCDDown" not in self.complained:
        if not self.mjj_JetFlavorQCDDown_branch and "mjj_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch mjj_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetFlavorQCDDown")
        else:
            self.mjj_JetFlavorQCDDown_branch.SetAddress(<void*>&self.mjj_JetFlavorQCDDown_value)

        #print "making mjj_JetHFUp"
        self.mjj_JetHFUp_branch = the_tree.GetBranch("mjj_JetHFUp")
        #if not self.mjj_JetHFUp_branch and "mjj_JetHFUp" not in self.complained:
        if not self.mjj_JetHFUp_branch and "mjj_JetHFUp":
            warnings.warn( "EMTree: Expected branch mjj_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetHFUp")
        else:
            self.mjj_JetHFUp_branch.SetAddress(<void*>&self.mjj_JetHFUp_value)

        #print "making mjj_JetHFDown"
        self.mjj_JetHFDown_branch = the_tree.GetBranch("mjj_JetHFDown")
        #if not self.mjj_JetHFDown_branch and "mjj_JetHFDown" not in self.complained:
        if not self.mjj_JetHFDown_branch and "mjj_JetHFDown":
            warnings.warn( "EMTree: Expected branch mjj_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetHFDown")
        else:
            self.mjj_JetHFDown_branch.SetAddress(<void*>&self.mjj_JetHFDown_value)

        #print "making mjj_JetHFyearUp"
        self.mjj_JetHFyearUp_branch = the_tree.GetBranch("mjj_JetHFyearUp")
        #if not self.mjj_JetHFyearUp_branch and "mjj_JetHFyearUp" not in self.complained:
        if not self.mjj_JetHFyearUp_branch and "mjj_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch mjj_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetHFyearUp")
        else:
            self.mjj_JetHFyearUp_branch.SetAddress(<void*>&self.mjj_JetHFyearUp_value)

        #print "making mjj_JetHFyearDown"
        self.mjj_JetHFyearDown_branch = the_tree.GetBranch("mjj_JetHFyearDown")
        #if not self.mjj_JetHFyearDown_branch and "mjj_JetHFyearDown" not in self.complained:
        if not self.mjj_JetHFyearDown_branch and "mjj_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch mjj_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetHFyearDown")
        else:
            self.mjj_JetHFyearDown_branch.SetAddress(<void*>&self.mjj_JetHFyearDown_value)

        #print "making mjj_JetRelativeBalUp"
        self.mjj_JetRelativeBalUp_branch = the_tree.GetBranch("mjj_JetRelativeBalUp")
        #if not self.mjj_JetRelativeBalUp_branch and "mjj_JetRelativeBalUp" not in self.complained:
        if not self.mjj_JetRelativeBalUp_branch and "mjj_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch mjj_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetRelativeBalUp")
        else:
            self.mjj_JetRelativeBalUp_branch.SetAddress(<void*>&self.mjj_JetRelativeBalUp_value)

        #print "making mjj_JetRelativeBalDown"
        self.mjj_JetRelativeBalDown_branch = the_tree.GetBranch("mjj_JetRelativeBalDown")
        #if not self.mjj_JetRelativeBalDown_branch and "mjj_JetRelativeBalDown" not in self.complained:
        if not self.mjj_JetRelativeBalDown_branch and "mjj_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch mjj_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetRelativeBalDown")
        else:
            self.mjj_JetRelativeBalDown_branch.SetAddress(<void*>&self.mjj_JetRelativeBalDown_value)

        #print "making mjj_JetRelativeSampleUp"
        self.mjj_JetRelativeSampleUp_branch = the_tree.GetBranch("mjj_JetRelativeSampleUp")
        #if not self.mjj_JetRelativeSampleUp_branch and "mjj_JetRelativeSampleUp" not in self.complained:
        if not self.mjj_JetRelativeSampleUp_branch and "mjj_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch mjj_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetRelativeSampleUp")
        else:
            self.mjj_JetRelativeSampleUp_branch.SetAddress(<void*>&self.mjj_JetRelativeSampleUp_value)

        #print "making mjj_JetRelativeSampleDown"
        self.mjj_JetRelativeSampleDown_branch = the_tree.GetBranch("mjj_JetRelativeSampleDown")
        #if not self.mjj_JetRelativeSampleDown_branch and "mjj_JetRelativeSampleDown" not in self.complained:
        if not self.mjj_JetRelativeSampleDown_branch and "mjj_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch mjj_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JetRelativeSampleDown")
        else:
            self.mjj_JetRelativeSampleDown_branch.SetAddress(<void*>&self.mjj_JetRelativeSampleDown_value)

        #print "making mjj_JERUp"
        self.mjj_JERUp_branch = the_tree.GetBranch("mjj_JERUp")
        #if not self.mjj_JERUp_branch and "mjj_JERUp" not in self.complained:
        if not self.mjj_JERUp_branch and "mjj_JERUp":
            warnings.warn( "EMTree: Expected branch mjj_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JERUp")
        else:
            self.mjj_JERUp_branch.SetAddress(<void*>&self.mjj_JERUp_value)

        #print "making mjj_JERDown"
        self.mjj_JERDown_branch = the_tree.GetBranch("mjj_JERDown")
        #if not self.mjj_JERDown_branch and "mjj_JERDown" not in self.complained:
        if not self.mjj_JERDown_branch and "mjj_JERDown":
            warnings.warn( "EMTree: Expected branch mjj_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("mjj_JERDown")
        else:
            self.mjj_JERDown_branch.SetAddress(<void*>&self.mjj_JERDown_value)

        #print "making gen_match_1"
        self.gen_match_1_branch = the_tree.GetBranch("gen_match_1")
        #if not self.gen_match_1_branch and "gen_match_1" not in self.complained:
        if not self.gen_match_1_branch and "gen_match_1":
            warnings.warn( "EMTree: Expected branch gen_match_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gen_match_1")
        else:
            self.gen_match_1_branch.SetAddress(<void*>&self.gen_match_1_value)

        #print "making gen_match_2"
        self.gen_match_2_branch = the_tree.GetBranch("gen_match_2")
        #if not self.gen_match_2_branch and "gen_match_2" not in self.complained:
        if not self.gen_match_2_branch and "gen_match_2":
            warnings.warn( "EMTree: Expected branch gen_match_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gen_match_2")
        else:
            self.gen_match_2_branch.SetAddress(<void*>&self.gen_match_2_value)

        #print "making nbtag"
        self.nbtag_branch = the_tree.GetBranch("nbtag")
        #if not self.nbtag_branch and "nbtag" not in self.complained:
        if not self.nbtag_branch and "nbtag":
            warnings.warn( "EMTree: Expected branch nbtag does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nbtag")
        else:
            self.nbtag_branch.SetAddress(<void*>&self.nbtag_value)

        #print "making nbtagL"
        self.nbtagL_branch = the_tree.GetBranch("nbtagL")
        #if not self.nbtagL_branch and "nbtagL" not in self.complained:
        if not self.nbtagL_branch and "nbtagL":
            warnings.warn( "EMTree: Expected branch nbtagL does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("nbtagL")
        else:
            self.nbtagL_branch.SetAddress(<void*>&self.nbtagL_value)

        #print "making njets"
        self.njets_branch = the_tree.GetBranch("njets")
        #if not self.njets_branch and "njets" not in self.complained:
        if not self.njets_branch and "njets":
            warnings.warn( "EMTree: Expected branch njets does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets")
        else:
            self.njets_branch.SetAddress(<void*>&self.njets_value)

        #print "making njets_JetAbsoluteUp"
        self.njets_JetAbsoluteUp_branch = the_tree.GetBranch("njets_JetAbsoluteUp")
        #if not self.njets_JetAbsoluteUp_branch and "njets_JetAbsoluteUp" not in self.complained:
        if not self.njets_JetAbsoluteUp_branch and "njets_JetAbsoluteUp":
            warnings.warn( "EMTree: Expected branch njets_JetAbsoluteUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetAbsoluteUp")
        else:
            self.njets_JetAbsoluteUp_branch.SetAddress(<void*>&self.njets_JetAbsoluteUp_value)

        #print "making njets_JetAbsoluteDown"
        self.njets_JetAbsoluteDown_branch = the_tree.GetBranch("njets_JetAbsoluteDown")
        #if not self.njets_JetAbsoluteDown_branch and "njets_JetAbsoluteDown" not in self.complained:
        if not self.njets_JetAbsoluteDown_branch and "njets_JetAbsoluteDown":
            warnings.warn( "EMTree: Expected branch njets_JetAbsoluteDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetAbsoluteDown")
        else:
            self.njets_JetAbsoluteDown_branch.SetAddress(<void*>&self.njets_JetAbsoluteDown_value)

        #print "making njets_JetAbsoluteyearUp"
        self.njets_JetAbsoluteyearUp_branch = the_tree.GetBranch("njets_JetAbsoluteyearUp")
        #if not self.njets_JetAbsoluteyearUp_branch and "njets_JetAbsoluteyearUp" not in self.complained:
        if not self.njets_JetAbsoluteyearUp_branch and "njets_JetAbsoluteyearUp":
            warnings.warn( "EMTree: Expected branch njets_JetAbsoluteyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetAbsoluteyearUp")
        else:
            self.njets_JetAbsoluteyearUp_branch.SetAddress(<void*>&self.njets_JetAbsoluteyearUp_value)

        #print "making njets_JetAbsoluteyearDown"
        self.njets_JetAbsoluteyearDown_branch = the_tree.GetBranch("njets_JetAbsoluteyearDown")
        #if not self.njets_JetAbsoluteyearDown_branch and "njets_JetAbsoluteyearDown" not in self.complained:
        if not self.njets_JetAbsoluteyearDown_branch and "njets_JetAbsoluteyearDown":
            warnings.warn( "EMTree: Expected branch njets_JetAbsoluteyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetAbsoluteyearDown")
        else:
            self.njets_JetAbsoluteyearDown_branch.SetAddress(<void*>&self.njets_JetAbsoluteyearDown_value)

        #print "making njets_JetBBEC1Up"
        self.njets_JetBBEC1Up_branch = the_tree.GetBranch("njets_JetBBEC1Up")
        #if not self.njets_JetBBEC1Up_branch and "njets_JetBBEC1Up" not in self.complained:
        if not self.njets_JetBBEC1Up_branch and "njets_JetBBEC1Up":
            warnings.warn( "EMTree: Expected branch njets_JetBBEC1Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetBBEC1Up")
        else:
            self.njets_JetBBEC1Up_branch.SetAddress(<void*>&self.njets_JetBBEC1Up_value)

        #print "making njets_JetBBEC1Down"
        self.njets_JetBBEC1Down_branch = the_tree.GetBranch("njets_JetBBEC1Down")
        #if not self.njets_JetBBEC1Down_branch and "njets_JetBBEC1Down" not in self.complained:
        if not self.njets_JetBBEC1Down_branch and "njets_JetBBEC1Down":
            warnings.warn( "EMTree: Expected branch njets_JetBBEC1Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetBBEC1Down")
        else:
            self.njets_JetBBEC1Down_branch.SetAddress(<void*>&self.njets_JetBBEC1Down_value)

        #print "making njets_JetBBEC1yearUp"
        self.njets_JetBBEC1yearUp_branch = the_tree.GetBranch("njets_JetBBEC1yearUp")
        #if not self.njets_JetBBEC1yearUp_branch and "njets_JetBBEC1yearUp" not in self.complained:
        if not self.njets_JetBBEC1yearUp_branch and "njets_JetBBEC1yearUp":
            warnings.warn( "EMTree: Expected branch njets_JetBBEC1yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetBBEC1yearUp")
        else:
            self.njets_JetBBEC1yearUp_branch.SetAddress(<void*>&self.njets_JetBBEC1yearUp_value)

        #print "making njets_JetBBEC1yearDown"
        self.njets_JetBBEC1yearDown_branch = the_tree.GetBranch("njets_JetBBEC1yearDown")
        #if not self.njets_JetBBEC1yearDown_branch and "njets_JetBBEC1yearDown" not in self.complained:
        if not self.njets_JetBBEC1yearDown_branch and "njets_JetBBEC1yearDown":
            warnings.warn( "EMTree: Expected branch njets_JetBBEC1yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetBBEC1yearDown")
        else:
            self.njets_JetBBEC1yearDown_branch.SetAddress(<void*>&self.njets_JetBBEC1yearDown_value)

        #print "making njets_JetEC2Up"
        self.njets_JetEC2Up_branch = the_tree.GetBranch("njets_JetEC2Up")
        #if not self.njets_JetEC2Up_branch and "njets_JetEC2Up" not in self.complained:
        if not self.njets_JetEC2Up_branch and "njets_JetEC2Up":
            warnings.warn( "EMTree: Expected branch njets_JetEC2Up does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetEC2Up")
        else:
            self.njets_JetEC2Up_branch.SetAddress(<void*>&self.njets_JetEC2Up_value)

        #print "making njets_JetEC2Down"
        self.njets_JetEC2Down_branch = the_tree.GetBranch("njets_JetEC2Down")
        #if not self.njets_JetEC2Down_branch and "njets_JetEC2Down" not in self.complained:
        if not self.njets_JetEC2Down_branch and "njets_JetEC2Down":
            warnings.warn( "EMTree: Expected branch njets_JetEC2Down does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetEC2Down")
        else:
            self.njets_JetEC2Down_branch.SetAddress(<void*>&self.njets_JetEC2Down_value)

        #print "making njets_JetEC2yearUp"
        self.njets_JetEC2yearUp_branch = the_tree.GetBranch("njets_JetEC2yearUp")
        #if not self.njets_JetEC2yearUp_branch and "njets_JetEC2yearUp" not in self.complained:
        if not self.njets_JetEC2yearUp_branch and "njets_JetEC2yearUp":
            warnings.warn( "EMTree: Expected branch njets_JetEC2yearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetEC2yearUp")
        else:
            self.njets_JetEC2yearUp_branch.SetAddress(<void*>&self.njets_JetEC2yearUp_value)

        #print "making njets_JetEC2yearDown"
        self.njets_JetEC2yearDown_branch = the_tree.GetBranch("njets_JetEC2yearDown")
        #if not self.njets_JetEC2yearDown_branch and "njets_JetEC2yearDown" not in self.complained:
        if not self.njets_JetEC2yearDown_branch and "njets_JetEC2yearDown":
            warnings.warn( "EMTree: Expected branch njets_JetEC2yearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetEC2yearDown")
        else:
            self.njets_JetEC2yearDown_branch.SetAddress(<void*>&self.njets_JetEC2yearDown_value)

        #print "making njets_JetFlavorQCDUp"
        self.njets_JetFlavorQCDUp_branch = the_tree.GetBranch("njets_JetFlavorQCDUp")
        #if not self.njets_JetFlavorQCDUp_branch and "njets_JetFlavorQCDUp" not in self.complained:
        if not self.njets_JetFlavorQCDUp_branch and "njets_JetFlavorQCDUp":
            warnings.warn( "EMTree: Expected branch njets_JetFlavorQCDUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetFlavorQCDUp")
        else:
            self.njets_JetFlavorQCDUp_branch.SetAddress(<void*>&self.njets_JetFlavorQCDUp_value)

        #print "making njets_JetFlavorQCDDown"
        self.njets_JetFlavorQCDDown_branch = the_tree.GetBranch("njets_JetFlavorQCDDown")
        #if not self.njets_JetFlavorQCDDown_branch and "njets_JetFlavorQCDDown" not in self.complained:
        if not self.njets_JetFlavorQCDDown_branch and "njets_JetFlavorQCDDown":
            warnings.warn( "EMTree: Expected branch njets_JetFlavorQCDDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetFlavorQCDDown")
        else:
            self.njets_JetFlavorQCDDown_branch.SetAddress(<void*>&self.njets_JetFlavorQCDDown_value)

        #print "making njets_JetHFUp"
        self.njets_JetHFUp_branch = the_tree.GetBranch("njets_JetHFUp")
        #if not self.njets_JetHFUp_branch and "njets_JetHFUp" not in self.complained:
        if not self.njets_JetHFUp_branch and "njets_JetHFUp":
            warnings.warn( "EMTree: Expected branch njets_JetHFUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetHFUp")
        else:
            self.njets_JetHFUp_branch.SetAddress(<void*>&self.njets_JetHFUp_value)

        #print "making njets_JetHFDown"
        self.njets_JetHFDown_branch = the_tree.GetBranch("njets_JetHFDown")
        #if not self.njets_JetHFDown_branch and "njets_JetHFDown" not in self.complained:
        if not self.njets_JetHFDown_branch and "njets_JetHFDown":
            warnings.warn( "EMTree: Expected branch njets_JetHFDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetHFDown")
        else:
            self.njets_JetHFDown_branch.SetAddress(<void*>&self.njets_JetHFDown_value)

        #print "making njets_JetHFyearUp"
        self.njets_JetHFyearUp_branch = the_tree.GetBranch("njets_JetHFyearUp")
        #if not self.njets_JetHFyearUp_branch and "njets_JetHFyearUp" not in self.complained:
        if not self.njets_JetHFyearUp_branch and "njets_JetHFyearUp":
            warnings.warn( "EMTree: Expected branch njets_JetHFyearUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetHFyearUp")
        else:
            self.njets_JetHFyearUp_branch.SetAddress(<void*>&self.njets_JetHFyearUp_value)

        #print "making njets_JetHFyearDown"
        self.njets_JetHFyearDown_branch = the_tree.GetBranch("njets_JetHFyearDown")
        #if not self.njets_JetHFyearDown_branch and "njets_JetHFyearDown" not in self.complained:
        if not self.njets_JetHFyearDown_branch and "njets_JetHFyearDown":
            warnings.warn( "EMTree: Expected branch njets_JetHFyearDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetHFyearDown")
        else:
            self.njets_JetHFyearDown_branch.SetAddress(<void*>&self.njets_JetHFyearDown_value)

        #print "making njets_JetRelativeBalUp"
        self.njets_JetRelativeBalUp_branch = the_tree.GetBranch("njets_JetRelativeBalUp")
        #if not self.njets_JetRelativeBalUp_branch and "njets_JetRelativeBalUp" not in self.complained:
        if not self.njets_JetRelativeBalUp_branch and "njets_JetRelativeBalUp":
            warnings.warn( "EMTree: Expected branch njets_JetRelativeBalUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetRelativeBalUp")
        else:
            self.njets_JetRelativeBalUp_branch.SetAddress(<void*>&self.njets_JetRelativeBalUp_value)

        #print "making njets_JetRelativeBalDown"
        self.njets_JetRelativeBalDown_branch = the_tree.GetBranch("njets_JetRelativeBalDown")
        #if not self.njets_JetRelativeBalDown_branch and "njets_JetRelativeBalDown" not in self.complained:
        if not self.njets_JetRelativeBalDown_branch and "njets_JetRelativeBalDown":
            warnings.warn( "EMTree: Expected branch njets_JetRelativeBalDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetRelativeBalDown")
        else:
            self.njets_JetRelativeBalDown_branch.SetAddress(<void*>&self.njets_JetRelativeBalDown_value)

        #print "making njets_JetRelativeSampleUp"
        self.njets_JetRelativeSampleUp_branch = the_tree.GetBranch("njets_JetRelativeSampleUp")
        #if not self.njets_JetRelativeSampleUp_branch and "njets_JetRelativeSampleUp" not in self.complained:
        if not self.njets_JetRelativeSampleUp_branch and "njets_JetRelativeSampleUp":
            warnings.warn( "EMTree: Expected branch njets_JetRelativeSampleUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetRelativeSampleUp")
        else:
            self.njets_JetRelativeSampleUp_branch.SetAddress(<void*>&self.njets_JetRelativeSampleUp_value)

        #print "making njets_JetRelativeSampleDown"
        self.njets_JetRelativeSampleDown_branch = the_tree.GetBranch("njets_JetRelativeSampleDown")
        #if not self.njets_JetRelativeSampleDown_branch and "njets_JetRelativeSampleDown" not in self.complained:
        if not self.njets_JetRelativeSampleDown_branch and "njets_JetRelativeSampleDown":
            warnings.warn( "EMTree: Expected branch njets_JetRelativeSampleDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JetRelativeSampleDown")
        else:
            self.njets_JetRelativeSampleDown_branch.SetAddress(<void*>&self.njets_JetRelativeSampleDown_value)

        #print "making njets_JERUp"
        self.njets_JERUp_branch = the_tree.GetBranch("njets_JERUp")
        #if not self.njets_JERUp_branch and "njets_JERUp" not in self.complained:
        if not self.njets_JERUp_branch and "njets_JERUp":
            warnings.warn( "EMTree: Expected branch njets_JERUp does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JERUp")
        else:
            self.njets_JERUp_branch.SetAddress(<void*>&self.njets_JERUp_value)

        #print "making njets_JERDown"
        self.njets_JERDown_branch = the_tree.GetBranch("njets_JERDown")
        #if not self.njets_JERDown_branch and "njets_JERDown" not in self.complained:
        if not self.njets_JERDown_branch and "njets_JERDown":
            warnings.warn( "EMTree: Expected branch njets_JERDown does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("njets_JERDown")
        else:
            self.njets_JERDown_branch.SetAddress(<void*>&self.njets_JERDown_value)

        #print "making jpt_1"
        self.jpt_1_branch = the_tree.GetBranch("jpt_1")
        #if not self.jpt_1_branch and "jpt_1" not in self.complained:
        if not self.jpt_1_branch and "jpt_1":
            warnings.warn( "EMTree: Expected branch jpt_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jpt_1")
        else:
            self.jpt_1_branch.SetAddress(<void*>&self.jpt_1_value)

        #print "making jeta_1"
        self.jeta_1_branch = the_tree.GetBranch("jeta_1")
        #if not self.jeta_1_branch and "jeta_1" not in self.complained:
        if not self.jeta_1_branch and "jeta_1":
            warnings.warn( "EMTree: Expected branch jeta_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jeta_1")
        else:
            self.jeta_1_branch.SetAddress(<void*>&self.jeta_1_value)

        #print "making jcsv_1"
        self.jcsv_1_branch = the_tree.GetBranch("jcsv_1")
        #if not self.jcsv_1_branch and "jcsv_1" not in self.complained:
        if not self.jcsv_1_branch and "jcsv_1":
            warnings.warn( "EMTree: Expected branch jcsv_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jcsv_1")
        else:
            self.jcsv_1_branch.SetAddress(<void*>&self.jcsv_1_value)

        #print "making jphi_1"
        self.jphi_1_branch = the_tree.GetBranch("jphi_1")
        #if not self.jphi_1_branch and "jphi_1" not in self.complained:
        if not self.jphi_1_branch and "jphi_1":
            warnings.warn( "EMTree: Expected branch jphi_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jphi_1")
        else:
            self.jphi_1_branch.SetAddress(<void*>&self.jphi_1_value)

        #print "making jpt_2"
        self.jpt_2_branch = the_tree.GetBranch("jpt_2")
        #if not self.jpt_2_branch and "jpt_2" not in self.complained:
        if not self.jpt_2_branch and "jpt_2":
            warnings.warn( "EMTree: Expected branch jpt_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jpt_2")
        else:
            self.jpt_2_branch.SetAddress(<void*>&self.jpt_2_value)

        #print "making jeta_2"
        self.jeta_2_branch = the_tree.GetBranch("jeta_2")
        #if not self.jeta_2_branch and "jeta_2" not in self.complained:
        if not self.jeta_2_branch and "jeta_2":
            warnings.warn( "EMTree: Expected branch jeta_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jeta_2")
        else:
            self.jeta_2_branch.SetAddress(<void*>&self.jeta_2_value)

        #print "making jcsv_2"
        self.jcsv_2_branch = the_tree.GetBranch("jcsv_2")
        #if not self.jcsv_2_branch and "jcsv_2" not in self.complained:
        if not self.jcsv_2_branch and "jcsv_2":
            warnings.warn( "EMTree: Expected branch jcsv_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jcsv_2")
        else:
            self.jcsv_2_branch.SetAddress(<void*>&self.jcsv_2_value)

        #print "making jphi_2"
        self.jphi_2_branch = the_tree.GetBranch("jphi_2")
        #if not self.jphi_2_branch and "jphi_2" not in self.complained:
        if not self.jphi_2_branch and "jphi_2":
            warnings.warn( "EMTree: Expected branch jphi_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("jphi_2")
        else:
            self.jphi_2_branch.SetAddress(<void*>&self.jphi_2_value)

        #print "making bpt_1"
        self.bpt_1_branch = the_tree.GetBranch("bpt_1")
        #if not self.bpt_1_branch and "bpt_1" not in self.complained:
        if not self.bpt_1_branch and "bpt_1":
            warnings.warn( "EMTree: Expected branch bpt_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bpt_1")
        else:
            self.bpt_1_branch.SetAddress(<void*>&self.bpt_1_value)

        #print "making bflavor_1"
        self.bflavor_1_branch = the_tree.GetBranch("bflavor_1")
        #if not self.bflavor_1_branch and "bflavor_1" not in self.complained:
        if not self.bflavor_1_branch and "bflavor_1":
            warnings.warn( "EMTree: Expected branch bflavor_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bflavor_1")
        else:
            self.bflavor_1_branch.SetAddress(<void*>&self.bflavor_1_value)

        #print "making beta_1"
        self.beta_1_branch = the_tree.GetBranch("beta_1")
        #if not self.beta_1_branch and "beta_1" not in self.complained:
        if not self.beta_1_branch and "beta_1":
            warnings.warn( "EMTree: Expected branch beta_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("beta_1")
        else:
            self.beta_1_branch.SetAddress(<void*>&self.beta_1_value)

        #print "making bphi_1"
        self.bphi_1_branch = the_tree.GetBranch("bphi_1")
        #if not self.bphi_1_branch and "bphi_1" not in self.complained:
        if not self.bphi_1_branch and "bphi_1":
            warnings.warn( "EMTree: Expected branch bphi_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bphi_1")
        else:
            self.bphi_1_branch.SetAddress(<void*>&self.bphi_1_value)

        #print "making passMu23E12"
        self.passMu23E12_branch = the_tree.GetBranch("passMu23E12")
        #if not self.passMu23E12_branch and "passMu23E12" not in self.complained:
        if not self.passMu23E12_branch and "passMu23E12":
            warnings.warn( "EMTree: Expected branch passMu23E12 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("passMu23E12")
        else:
            self.passMu23E12_branch.SetAddress(<void*>&self.passMu23E12_value)

        #print "making passMu8E23"
        self.passMu8E23_branch = the_tree.GetBranch("passMu8E23")
        #if not self.passMu8E23_branch and "passMu8E23" not in self.complained:
        if not self.passMu8E23_branch and "passMu8E23":
            warnings.warn( "EMTree: Expected branch passMu8E23 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("passMu8E23")
        else:
            self.passMu8E23_branch.SetAddress(<void*>&self.passMu8E23_value)

        #print "making matchMu23E12_1"
        self.matchMu23E12_1_branch = the_tree.GetBranch("matchMu23E12_1")
        #if not self.matchMu23E12_1_branch and "matchMu23E12_1" not in self.complained:
        if not self.matchMu23E12_1_branch and "matchMu23E12_1":
            warnings.warn( "EMTree: Expected branch matchMu23E12_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("matchMu23E12_1")
        else:
            self.matchMu23E12_1_branch.SetAddress(<void*>&self.matchMu23E12_1_value)

        #print "making matchMu8E23_1"
        self.matchMu8E23_1_branch = the_tree.GetBranch("matchMu8E23_1")
        #if not self.matchMu8E23_1_branch and "matchMu8E23_1" not in self.complained:
        if not self.matchMu8E23_1_branch and "matchMu8E23_1":
            warnings.warn( "EMTree: Expected branch matchMu8E23_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("matchMu8E23_1")
        else:
            self.matchMu8E23_1_branch.SetAddress(<void*>&self.matchMu8E23_1_value)

        #print "making filterMu23E12_1"
        self.filterMu23E12_1_branch = the_tree.GetBranch("filterMu23E12_1")
        #if not self.filterMu23E12_1_branch and "filterMu23E12_1" not in self.complained:
        if not self.filterMu23E12_1_branch and "filterMu23E12_1":
            warnings.warn( "EMTree: Expected branch filterMu23E12_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("filterMu23E12_1")
        else:
            self.filterMu23E12_1_branch.SetAddress(<void*>&self.filterMu23E12_1_value)

        #print "making filterMu8E23_1"
        self.filterMu8E23_1_branch = the_tree.GetBranch("filterMu8E23_1")
        #if not self.filterMu8E23_1_branch and "filterMu8E23_1" not in self.complained:
        if not self.filterMu8E23_1_branch and "filterMu8E23_1":
            warnings.warn( "EMTree: Expected branch filterMu8E23_1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("filterMu8E23_1")
        else:
            self.filterMu8E23_1_branch.SetAddress(<void*>&self.filterMu8E23_1_value)

        #print "making matchMu23E12_2"
        self.matchMu23E12_2_branch = the_tree.GetBranch("matchMu23E12_2")
        #if not self.matchMu23E12_2_branch and "matchMu23E12_2" not in self.complained:
        if not self.matchMu23E12_2_branch and "matchMu23E12_2":
            warnings.warn( "EMTree: Expected branch matchMu23E12_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("matchMu23E12_2")
        else:
            self.matchMu23E12_2_branch.SetAddress(<void*>&self.matchMu23E12_2_value)

        #print "making matchMu8E23_2"
        self.matchMu8E23_2_branch = the_tree.GetBranch("matchMu8E23_2")
        #if not self.matchMu8E23_2_branch and "matchMu8E23_2" not in self.complained:
        if not self.matchMu8E23_2_branch and "matchMu8E23_2":
            warnings.warn( "EMTree: Expected branch matchMu8E23_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("matchMu8E23_2")
        else:
            self.matchMu8E23_2_branch.SetAddress(<void*>&self.matchMu8E23_2_value)

        #print "making filterMu23E12_2"
        self.filterMu23E12_2_branch = the_tree.GetBranch("filterMu23E12_2")
        #if not self.filterMu23E12_2_branch and "filterMu23E12_2" not in self.complained:
        if not self.filterMu23E12_2_branch and "filterMu23E12_2":
            warnings.warn( "EMTree: Expected branch filterMu23E12_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("filterMu23E12_2")
        else:
            self.filterMu23E12_2_branch.SetAddress(<void*>&self.filterMu23E12_2_value)

        #print "making filterMu8E23_2"
        self.filterMu8E23_2_branch = the_tree.GetBranch("filterMu8E23_2")
        #if not self.filterMu8E23_2_branch and "filterMu8E23_2" not in self.complained:
        if not self.filterMu8E23_2_branch and "filterMu8E23_2":
            warnings.warn( "EMTree: Expected branch filterMu8E23_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("filterMu8E23_2")
        else:
            self.filterMu8E23_2_branch.SetAddress(<void*>&self.filterMu8E23_2_value)

        #print "making bpt_2"
        self.bpt_2_branch = the_tree.GetBranch("bpt_2")
        #if not self.bpt_2_branch and "bpt_2" not in self.complained:
        if not self.bpt_2_branch and "bpt_2":
            warnings.warn( "EMTree: Expected branch bpt_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bpt_2")
        else:
            self.bpt_2_branch.SetAddress(<void*>&self.bpt_2_value)

        #print "making bflavor_2"
        self.bflavor_2_branch = the_tree.GetBranch("bflavor_2")
        #if not self.bflavor_2_branch and "bflavor_2" not in self.complained:
        if not self.bflavor_2_branch and "bflavor_2":
            warnings.warn( "EMTree: Expected branch bflavor_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bflavor_2")
        else:
            self.bflavor_2_branch.SetAddress(<void*>&self.bflavor_2_value)

        #print "making beta_2"
        self.beta_2_branch = the_tree.GetBranch("beta_2")
        #if not self.beta_2_branch and "beta_2" not in self.complained:
        if not self.beta_2_branch and "beta_2":
            warnings.warn( "EMTree: Expected branch beta_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("beta_2")
        else:
            self.beta_2_branch.SetAddress(<void*>&self.beta_2_value)

        #print "making bphi_2"
        self.bphi_2_branch = the_tree.GetBranch("bphi_2")
        #if not self.bphi_2_branch and "bphi_2" not in self.complained:
        if not self.bphi_2_branch and "bphi_2":
            warnings.warn( "EMTree: Expected branch bphi_2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("bphi_2")
        else:
            self.bphi_2_branch.SetAddress(<void*>&self.bphi_2_value)

        #print "making pt_top1"
        self.pt_top1_branch = the_tree.GetBranch("pt_top1")
        #if not self.pt_top1_branch and "pt_top1" not in self.complained:
        if not self.pt_top1_branch and "pt_top1":
            warnings.warn( "EMTree: Expected branch pt_top1 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_top1")
        else:
            self.pt_top1_branch.SetAddress(<void*>&self.pt_top1_value)

        #print "making pt_top2"
        self.pt_top2_branch = the_tree.GetBranch("pt_top2")
        #if not self.pt_top2_branch and "pt_top2" not in self.complained:
        if not self.pt_top2_branch and "pt_top2":
            warnings.warn( "EMTree: Expected branch pt_top2 does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("pt_top2")
        else:
            self.pt_top2_branch.SetAddress(<void*>&self.pt_top2_value)

        #print "making genweight"
        self.genweight_branch = the_tree.GetBranch("genweight")
        #if not self.genweight_branch and "genweight" not in self.complained:
        if not self.genweight_branch and "genweight":
            warnings.warn( "EMTree: Expected branch genweight does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("genweight")
        else:
            self.genweight_branch.SetAddress(<void*>&self.genweight_value)

        #print "making gen_Higgs_pt"
        self.gen_Higgs_pt_branch = the_tree.GetBranch("gen_Higgs_pt")
        #if not self.gen_Higgs_pt_branch and "gen_Higgs_pt" not in self.complained:
        if not self.gen_Higgs_pt_branch and "gen_Higgs_pt":
            warnings.warn( "EMTree: Expected branch gen_Higgs_pt does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gen_Higgs_pt")
        else:
            self.gen_Higgs_pt_branch.SetAddress(<void*>&self.gen_Higgs_pt_value)

        #print "making gen_Higgs_mass"
        self.gen_Higgs_mass_branch = the_tree.GetBranch("gen_Higgs_mass")
        #if not self.gen_Higgs_mass_branch and "gen_Higgs_mass" not in self.complained:
        if not self.gen_Higgs_mass_branch and "gen_Higgs_mass":
            warnings.warn( "EMTree: Expected branch gen_Higgs_mass does not exist!"                " It will crash if you try and use it!",Warning)
            #self.complained.add("gen_Higgs_mass")
        else:
            self.gen_Higgs_mass_branch.SetAddress(<void*>&self.gen_Higgs_mass_value)


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

    property run:
        def __get__(self):
            self.run_branch.GetEntry(self.localentry, 0)
            return self.run_value

    property lumi:
        def __get__(self):
            self.lumi_branch.GetEntry(self.localentry, 0)
            return self.lumi_value

    property evt:
        def __get__(self):
            self.evt_branch.GetEntry(self.localentry, 0)
            return self.evt_value

    property genpX:
        def __get__(self):
            self.genpX_branch.GetEntry(self.localentry, 0)
            return self.genpX_value

    property genpY:
        def __get__(self):
            self.genpY_branch.GetEntry(self.localentry, 0)
            return self.genpY_value

    property genM:
        def __get__(self):
            self.genM_branch.GetEntry(self.localentry, 0)
            return self.genM_value

    property genpT:
        def __get__(self):
            self.genpT_branch.GetEntry(self.localentry, 0)
            return self.genpT_value

    property vispX:
        def __get__(self):
            self.vispX_branch.GetEntry(self.localentry, 0)
            return self.vispX_value

    property vispY:
        def __get__(self):
            self.vispY_branch.GetEntry(self.localentry, 0)
            return self.vispY_value

    property genpt_1:
        def __get__(self):
            self.genpt_1_branch.GetEntry(self.localentry, 0)
            return self.genpt_1_value

    property geneta_1:
        def __get__(self):
            self.geneta_1_branch.GetEntry(self.localentry, 0)
            return self.geneta_1_value

    property genpt_2:
        def __get__(self):
            self.genpt_2_branch.GetEntry(self.localentry, 0)
            return self.genpt_2_value

    property geneta_2:
        def __get__(self):
            self.geneta_2_branch.GetEntry(self.localentry, 0)
            return self.geneta_2_value

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

    property Rivet_stage1_1_fine_cat_pTjet30GeV:
        def __get__(self):
            self.Rivet_stage1_1_fine_cat_pTjet30GeV_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage1_1_fine_cat_pTjet30GeV_value

    property Rivet_stage1_1_cat_pTjet30GeV:
        def __get__(self):
            self.Rivet_stage1_1_cat_pTjet30GeV_branch.GetEntry(self.localentry, 0)
            return self.Rivet_stage1_1_cat_pTjet30GeV_value

    property npv:
        def __get__(self):
            self.npv_branch.GetEntry(self.localentry, 0)
            return self.npv_value

    property npu:
        def __get__(self):
            self.npu_branch.GetEntry(self.localentry, 0)
            return self.npu_value

    property pt_1_ScaleUp:
        def __get__(self):
            self.pt_1_ScaleUp_branch.GetEntry(self.localentry, 0)
            return self.pt_1_ScaleUp_value

    property pt_1_ScaleDown:
        def __get__(self):
            self.pt_1_ScaleDown_branch.GetEntry(self.localentry, 0)
            return self.pt_1_ScaleDown_value

    property pt_1:
        def __get__(self):
            self.pt_1_branch.GetEntry(self.localentry, 0)
            return self.pt_1_value

    property phi_1:
        def __get__(self):
            self.phi_1_branch.GetEntry(self.localentry, 0)
            return self.phi_1_value

    property eta_1:
        def __get__(self):
            self.eta_1_branch.GetEntry(self.localentry, 0)
            return self.eta_1_value

    property m_1:
        def __get__(self):
            self.m_1_branch.GetEntry(self.localentry, 0)
            return self.m_1_value

    property e_1:
        def __get__(self):
            self.e_1_branch.GetEntry(self.localentry, 0)
            return self.e_1_value

    property q_1:
        def __get__(self):
            self.q_1_branch.GetEntry(self.localentry, 0)
            return self.q_1_value

    property iso_1:
        def __get__(self):
            self.iso_1_branch.GetEntry(self.localentry, 0)
            return self.iso_1_value

    property pt_2:
        def __get__(self):
            self.pt_2_branch.GetEntry(self.localentry, 0)
            return self.pt_2_value

    property phi_2:
        def __get__(self):
            self.phi_2_branch.GetEntry(self.localentry, 0)
            return self.phi_2_value

    property eta_2:
        def __get__(self):
            self.eta_2_branch.GetEntry(self.localentry, 0)
            return self.eta_2_value

    property m_2:
        def __get__(self):
            self.m_2_branch.GetEntry(self.localentry, 0)
            return self.m_2_value

    property e_2:
        def __get__(self):
            self.e_2_branch.GetEntry(self.localentry, 0)
            return self.e_2_value

    property q_2:
        def __get__(self):
            self.q_2_branch.GetEntry(self.localentry, 0)
            return self.q_2_value

    property iso_2:
        def __get__(self):
            self.iso_2_branch.GetEntry(self.localentry, 0)
            return self.iso_2_value

    property numGenJets:
        def __get__(self):
            self.numGenJets_branch.GetEntry(self.localentry, 0)
            return self.numGenJets_value

    property bweight:
        def __get__(self):
            self.bweight_branch.GetEntry(self.localentry, 0)
            return self.bweight_value

    property Flag_ecalBadCalibReducedMINIAODFilter:
        def __get__(self):
            self.Flag_ecalBadCalibReducedMINIAODFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibReducedMINIAODFilter_value

    property Flag_goodVertices:
        def __get__(self):
            self.Flag_goodVertices_branch.GetEntry(self.localentry, 0)
            return self.Flag_goodVertices_value

    property Flag_globalSuperTightHalo2016Filter:
        def __get__(self):
            self.Flag_globalSuperTightHalo2016Filter_branch.GetEntry(self.localentry, 0)
            return self.Flag_globalSuperTightHalo2016Filter_value

    property Flag_eeBadScFilter:
        def __get__(self):
            self.Flag_eeBadScFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_eeBadScFilter_value

    property Flag_ecalBadCalibFilter:
        def __get__(self):
            self.Flag_ecalBadCalibFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_ecalBadCalibFilter_value

    property Flag_badMuons:
        def __get__(self):
            self.Flag_badMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_badMuons_value

    property Flag_duplicateMuons:
        def __get__(self):
            self.Flag_duplicateMuons_branch.GetEntry(self.localentry, 0)
            return self.Flag_duplicateMuons_value

    property Flag_HBHENoiseIsoFilter:
        def __get__(self):
            self.Flag_HBHENoiseIsoFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseIsoFilter_value

    property Flag_HBHENoiseFilter:
        def __get__(self):
            self.Flag_HBHENoiseFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_HBHENoiseFilter_value

    property Flag_EcalDeadCellTriggerPrimitiveFilter:
        def __get__(self):
            self.Flag_EcalDeadCellTriggerPrimitiveFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_EcalDeadCellTriggerPrimitiveFilter_value

    property Flag_BadPFMuonFilter:
        def __get__(self):
            self.Flag_BadPFMuonFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadPFMuonFilter_value

    property Flag_BadChargedCandidateFilter:
        def __get__(self):
            self.Flag_BadChargedCandidateFilter_branch.GetEntry(self.localentry, 0)
            return self.Flag_BadChargedCandidateFilter_value

    property met:
        def __get__(self):
            self.met_branch.GetEntry(self.localentry, 0)
            return self.met_value

    property metSig:
        def __get__(self):
            self.metSig_branch.GetEntry(self.localentry, 0)
            return self.metSig_value

    property metcov00:
        def __get__(self):
            self.metcov00_branch.GetEntry(self.localentry, 0)
            return self.metcov00_value

    property metcov10:
        def __get__(self):
            self.metcov10_branch.GetEntry(self.localentry, 0)
            return self.metcov10_value

    property metcov11:
        def __get__(self):
            self.metcov11_branch.GetEntry(self.localentry, 0)
            return self.metcov11_value

    property metcov01:
        def __get__(self):
            self.metcov01_branch.GetEntry(self.localentry, 0)
            return self.metcov01_value

    property metphi:
        def __get__(self):
            self.metphi_branch.GetEntry(self.localentry, 0)
            return self.metphi_value

    property met_py:
        def __get__(self):
            self.met_py_branch.GetEntry(self.localentry, 0)
            return self.met_py_value

    property met_px:
        def __get__(self):
            self.met_px_branch.GetEntry(self.localentry, 0)
            return self.met_px_value

    property met_UESUp:
        def __get__(self):
            self.met_UESUp_branch.GetEntry(self.localentry, 0)
            return self.met_UESUp_value

    property metphi_UESUp:
        def __get__(self):
            self.metphi_UESUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_UESUp_value

    property met_UESDown:
        def __get__(self):
            self.met_UESDown_branch.GetEntry(self.localentry, 0)
            return self.met_UESDown_value

    property metphi_UESDown:
        def __get__(self):
            self.metphi_UESDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_UESDown_value

    property met_JetAbsoluteUp:
        def __get__(self):
            self.met_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetAbsoluteUp_value

    property metphi_JetAbsoluteUp:
        def __get__(self):
            self.metphi_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetAbsoluteUp_value

    property met_JetAbsoluteDown:
        def __get__(self):
            self.met_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetAbsoluteDown_value

    property metphi_JetAbsoluteDown:
        def __get__(self):
            self.metphi_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetAbsoluteDown_value

    property met_JetAbsoluteyearUp:
        def __get__(self):
            self.met_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetAbsoluteyearUp_value

    property metphi_JetAbsoluteyearUp:
        def __get__(self):
            self.metphi_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetAbsoluteyearUp_value

    property met_JetAbsoluteyearDown:
        def __get__(self):
            self.met_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetAbsoluteyearDown_value

    property metphi_JetAbsoluteyearDown:
        def __get__(self):
            self.metphi_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetAbsoluteyearDown_value

    property met_JetBBEC1Up:
        def __get__(self):
            self.met_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.met_JetBBEC1Up_value

    property metphi_JetBBEC1Up:
        def __get__(self):
            self.metphi_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetBBEC1Up_value

    property met_JetBBEC1Down:
        def __get__(self):
            self.met_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.met_JetBBEC1Down_value

    property metphi_JetBBEC1Down:
        def __get__(self):
            self.metphi_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetBBEC1Down_value

    property met_JetBBEC1yearUp:
        def __get__(self):
            self.met_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetBBEC1yearUp_value

    property metphi_JetBBEC1yearUp:
        def __get__(self):
            self.metphi_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetBBEC1yearUp_value

    property met_JetBBEC1yearDown:
        def __get__(self):
            self.met_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetBBEC1yearDown_value

    property metphi_JetBBEC1yearDown:
        def __get__(self):
            self.metphi_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetBBEC1yearDown_value

    property met_JetEC2Up:
        def __get__(self):
            self.met_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.met_JetEC2Up_value

    property metphi_JetEC2Up:
        def __get__(self):
            self.metphi_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetEC2Up_value

    property met_JetEC2Down:
        def __get__(self):
            self.met_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.met_JetEC2Down_value

    property metphi_JetEC2Down:
        def __get__(self):
            self.metphi_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetEC2Down_value

    property met_JetEC2yearUp:
        def __get__(self):
            self.met_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetEC2yearUp_value

    property metphi_JetEC2yearUp:
        def __get__(self):
            self.metphi_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetEC2yearUp_value

    property met_JetEC2yearDown:
        def __get__(self):
            self.met_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetEC2yearDown_value

    property metphi_JetEC2yearDown:
        def __get__(self):
            self.metphi_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetEC2yearDown_value

    property met_JetFlavorQCDUp:
        def __get__(self):
            self.met_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetFlavorQCDUp_value

    property metphi_JetFlavorQCDUp:
        def __get__(self):
            self.metphi_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetFlavorQCDUp_value

    property met_JetFlavorQCDDown:
        def __get__(self):
            self.met_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetFlavorQCDDown_value

    property metphi_JetFlavorQCDDown:
        def __get__(self):
            self.metphi_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetFlavorQCDDown_value

    property met_JetHFUp:
        def __get__(self):
            self.met_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetHFUp_value

    property metphi_JetHFUp:
        def __get__(self):
            self.metphi_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetHFUp_value

    property met_JetHFDown:
        def __get__(self):
            self.met_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetHFDown_value

    property metphi_JetHFDown:
        def __get__(self):
            self.metphi_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetHFDown_value

    property met_JetHFyearUp:
        def __get__(self):
            self.met_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetHFyearUp_value

    property metphi_JetHFyearUp:
        def __get__(self):
            self.metphi_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetHFyearUp_value

    property met_JetHFyearDown:
        def __get__(self):
            self.met_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetHFyearDown_value

    property metphi_JetHFyearDown:
        def __get__(self):
            self.metphi_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetHFyearDown_value

    property met_JetRelativeBalUp:
        def __get__(self):
            self.met_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetRelativeBalUp_value

    property metphi_JetRelativeBalUp:
        def __get__(self):
            self.metphi_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetRelativeBalUp_value

    property met_JetRelativeBalDown:
        def __get__(self):
            self.met_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetRelativeBalDown_value

    property metphi_JetRelativeBalDown:
        def __get__(self):
            self.metphi_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetRelativeBalDown_value

    property met_JetRelativeSampleUp:
        def __get__(self):
            self.met_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.met_JetRelativeSampleUp_value

    property metphi_JetRelativeSampleUp:
        def __get__(self):
            self.metphi_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetRelativeSampleUp_value

    property met_JetRelativeSampleDown:
        def __get__(self):
            self.met_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.met_JetRelativeSampleDown_value

    property metphi_JetRelativeSampleDown:
        def __get__(self):
            self.metphi_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JetRelativeSampleDown_value

    property met_JERUp:
        def __get__(self):
            self.met_JERUp_branch.GetEntry(self.localentry, 0)
            return self.met_JERUp_value

    property metphi_JERUp:
        def __get__(self):
            self.metphi_JERUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_JERUp_value

    property met_JERDown:
        def __get__(self):
            self.met_JERDown_branch.GetEntry(self.localentry, 0)
            return self.met_JERDown_value

    property metphi_JERDown:
        def __get__(self):
            self.metphi_JERDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_JERDown_value

    property met_responseUp:
        def __get__(self):
            self.met_responseUp_branch.GetEntry(self.localentry, 0)
            return self.met_responseUp_value

    property met_responseDown:
        def __get__(self):
            self.met_responseDown_branch.GetEntry(self.localentry, 0)
            return self.met_responseDown_value

    property met_resolutionUp:
        def __get__(self):
            self.met_resolutionUp_branch.GetEntry(self.localentry, 0)
            return self.met_resolutionUp_value

    property met_resolutionDown:
        def __get__(self):
            self.met_resolutionDown_branch.GetEntry(self.localentry, 0)
            return self.met_resolutionDown_value

    property metphi_responseUp:
        def __get__(self):
            self.metphi_responseUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_responseUp_value

    property metphi_responseDown:
        def __get__(self):
            self.metphi_responseDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_responseDown_value

    property metphi_resolutionUp:
        def __get__(self):
            self.metphi_resolutionUp_branch.GetEntry(self.localentry, 0)
            return self.metphi_resolutionUp_value

    property metphi_resolutionDown:
        def __get__(self):
            self.metphi_resolutionDown_branch.GetEntry(self.localentry, 0)
            return self.metphi_resolutionDown_value

    property mjj:
        def __get__(self):
            self.mjj_branch.GetEntry(self.localentry, 0)
            return self.mjj_value

    property mjj_JetAbsoluteUp:
        def __get__(self):
            self.mjj_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetAbsoluteUp_value

    property mjj_JetAbsoluteDown:
        def __get__(self):
            self.mjj_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetAbsoluteDown_value

    property mjj_JetAbsoluteyearUp:
        def __get__(self):
            self.mjj_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetAbsoluteyearUp_value

    property mjj_JetAbsoluteyearDown:
        def __get__(self):
            self.mjj_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetAbsoluteyearDown_value

    property mjj_JetBBEC1Up:
        def __get__(self):
            self.mjj_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetBBEC1Up_value

    property mjj_JetBBEC1Down:
        def __get__(self):
            self.mjj_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetBBEC1Down_value

    property mjj_JetBBEC1yearUp:
        def __get__(self):
            self.mjj_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetBBEC1yearUp_value

    property mjj_JetBBEC1yearDown:
        def __get__(self):
            self.mjj_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetBBEC1yearDown_value

    property mjj_JetEC2Up:
        def __get__(self):
            self.mjj_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetEC2Up_value

    property mjj_JetEC2Down:
        def __get__(self):
            self.mjj_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetEC2Down_value

    property mjj_JetEC2yearUp:
        def __get__(self):
            self.mjj_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetEC2yearUp_value

    property mjj_JetEC2yearDown:
        def __get__(self):
            self.mjj_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetEC2yearDown_value

    property mjj_JetFlavorQCDUp:
        def __get__(self):
            self.mjj_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetFlavorQCDUp_value

    property mjj_JetFlavorQCDDown:
        def __get__(self):
            self.mjj_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetFlavorQCDDown_value

    property mjj_JetHFUp:
        def __get__(self):
            self.mjj_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetHFUp_value

    property mjj_JetHFDown:
        def __get__(self):
            self.mjj_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetHFDown_value

    property mjj_JetHFyearUp:
        def __get__(self):
            self.mjj_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetHFyearUp_value

    property mjj_JetHFyearDown:
        def __get__(self):
            self.mjj_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetHFyearDown_value

    property mjj_JetRelativeBalUp:
        def __get__(self):
            self.mjj_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetRelativeBalUp_value

    property mjj_JetRelativeBalDown:
        def __get__(self):
            self.mjj_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetRelativeBalDown_value

    property mjj_JetRelativeSampleUp:
        def __get__(self):
            self.mjj_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetRelativeSampleUp_value

    property mjj_JetRelativeSampleDown:
        def __get__(self):
            self.mjj_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JetRelativeSampleDown_value

    property mjj_JERUp:
        def __get__(self):
            self.mjj_JERUp_branch.GetEntry(self.localentry, 0)
            return self.mjj_JERUp_value

    property mjj_JERDown:
        def __get__(self):
            self.mjj_JERDown_branch.GetEntry(self.localentry, 0)
            return self.mjj_JERDown_value

    property gen_match_1:
        def __get__(self):
            self.gen_match_1_branch.GetEntry(self.localentry, 0)
            return self.gen_match_1_value

    property gen_match_2:
        def __get__(self):
            self.gen_match_2_branch.GetEntry(self.localentry, 0)
            return self.gen_match_2_value

    property nbtag:
        def __get__(self):
            self.nbtag_branch.GetEntry(self.localentry, 0)
            return self.nbtag_value

    property nbtagL:
        def __get__(self):
            self.nbtagL_branch.GetEntry(self.localentry, 0)
            return self.nbtagL_value

    property njets:
        def __get__(self):
            self.njets_branch.GetEntry(self.localentry, 0)
            return self.njets_value

    property njets_JetAbsoluteUp:
        def __get__(self):
            self.njets_JetAbsoluteUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetAbsoluteUp_value

    property njets_JetAbsoluteDown:
        def __get__(self):
            self.njets_JetAbsoluteDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetAbsoluteDown_value

    property njets_JetAbsoluteyearUp:
        def __get__(self):
            self.njets_JetAbsoluteyearUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetAbsoluteyearUp_value

    property njets_JetAbsoluteyearDown:
        def __get__(self):
            self.njets_JetAbsoluteyearDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetAbsoluteyearDown_value

    property njets_JetBBEC1Up:
        def __get__(self):
            self.njets_JetBBEC1Up_branch.GetEntry(self.localentry, 0)
            return self.njets_JetBBEC1Up_value

    property njets_JetBBEC1Down:
        def __get__(self):
            self.njets_JetBBEC1Down_branch.GetEntry(self.localentry, 0)
            return self.njets_JetBBEC1Down_value

    property njets_JetBBEC1yearUp:
        def __get__(self):
            self.njets_JetBBEC1yearUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetBBEC1yearUp_value

    property njets_JetBBEC1yearDown:
        def __get__(self):
            self.njets_JetBBEC1yearDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetBBEC1yearDown_value

    property njets_JetEC2Up:
        def __get__(self):
            self.njets_JetEC2Up_branch.GetEntry(self.localentry, 0)
            return self.njets_JetEC2Up_value

    property njets_JetEC2Down:
        def __get__(self):
            self.njets_JetEC2Down_branch.GetEntry(self.localentry, 0)
            return self.njets_JetEC2Down_value

    property njets_JetEC2yearUp:
        def __get__(self):
            self.njets_JetEC2yearUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetEC2yearUp_value

    property njets_JetEC2yearDown:
        def __get__(self):
            self.njets_JetEC2yearDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetEC2yearDown_value

    property njets_JetFlavorQCDUp:
        def __get__(self):
            self.njets_JetFlavorQCDUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetFlavorQCDUp_value

    property njets_JetFlavorQCDDown:
        def __get__(self):
            self.njets_JetFlavorQCDDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetFlavorQCDDown_value

    property njets_JetHFUp:
        def __get__(self):
            self.njets_JetHFUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetHFUp_value

    property njets_JetHFDown:
        def __get__(self):
            self.njets_JetHFDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetHFDown_value

    property njets_JetHFyearUp:
        def __get__(self):
            self.njets_JetHFyearUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetHFyearUp_value

    property njets_JetHFyearDown:
        def __get__(self):
            self.njets_JetHFyearDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetHFyearDown_value

    property njets_JetRelativeBalUp:
        def __get__(self):
            self.njets_JetRelativeBalUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetRelativeBalUp_value

    property njets_JetRelativeBalDown:
        def __get__(self):
            self.njets_JetRelativeBalDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetRelativeBalDown_value

    property njets_JetRelativeSampleUp:
        def __get__(self):
            self.njets_JetRelativeSampleUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JetRelativeSampleUp_value

    property njets_JetRelativeSampleDown:
        def __get__(self):
            self.njets_JetRelativeSampleDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JetRelativeSampleDown_value

    property njets_JERUp:
        def __get__(self):
            self.njets_JERUp_branch.GetEntry(self.localentry, 0)
            return self.njets_JERUp_value

    property njets_JERDown:
        def __get__(self):
            self.njets_JERDown_branch.GetEntry(self.localentry, 0)
            return self.njets_JERDown_value

    property jpt_1:
        def __get__(self):
            self.jpt_1_branch.GetEntry(self.localentry, 0)
            return self.jpt_1_value

    property jeta_1:
        def __get__(self):
            self.jeta_1_branch.GetEntry(self.localentry, 0)
            return self.jeta_1_value

    property jcsv_1:
        def __get__(self):
            self.jcsv_1_branch.GetEntry(self.localentry, 0)
            return self.jcsv_1_value

    property jphi_1:
        def __get__(self):
            self.jphi_1_branch.GetEntry(self.localentry, 0)
            return self.jphi_1_value

    property jpt_2:
        def __get__(self):
            self.jpt_2_branch.GetEntry(self.localentry, 0)
            return self.jpt_2_value

    property jeta_2:
        def __get__(self):
            self.jeta_2_branch.GetEntry(self.localentry, 0)
            return self.jeta_2_value

    property jcsv_2:
        def __get__(self):
            self.jcsv_2_branch.GetEntry(self.localentry, 0)
            return self.jcsv_2_value

    property jphi_2:
        def __get__(self):
            self.jphi_2_branch.GetEntry(self.localentry, 0)
            return self.jphi_2_value

    property bpt_1:
        def __get__(self):
            self.bpt_1_branch.GetEntry(self.localentry, 0)
            return self.bpt_1_value

    property bflavor_1:
        def __get__(self):
            self.bflavor_1_branch.GetEntry(self.localentry, 0)
            return self.bflavor_1_value

    property beta_1:
        def __get__(self):
            self.beta_1_branch.GetEntry(self.localentry, 0)
            return self.beta_1_value

    property bphi_1:
        def __get__(self):
            self.bphi_1_branch.GetEntry(self.localentry, 0)
            return self.bphi_1_value

    property passMu23E12:
        def __get__(self):
            self.passMu23E12_branch.GetEntry(self.localentry, 0)
            return self.passMu23E12_value

    property passMu8E23:
        def __get__(self):
            self.passMu8E23_branch.GetEntry(self.localentry, 0)
            return self.passMu8E23_value

    property matchMu23E12_1:
        def __get__(self):
            self.matchMu23E12_1_branch.GetEntry(self.localentry, 0)
            return self.matchMu23E12_1_value

    property matchMu8E23_1:
        def __get__(self):
            self.matchMu8E23_1_branch.GetEntry(self.localentry, 0)
            return self.matchMu8E23_1_value

    property filterMu23E12_1:
        def __get__(self):
            self.filterMu23E12_1_branch.GetEntry(self.localentry, 0)
            return self.filterMu23E12_1_value

    property filterMu8E23_1:
        def __get__(self):
            self.filterMu8E23_1_branch.GetEntry(self.localentry, 0)
            return self.filterMu8E23_1_value

    property matchMu23E12_2:
        def __get__(self):
            self.matchMu23E12_2_branch.GetEntry(self.localentry, 0)
            return self.matchMu23E12_2_value

    property matchMu8E23_2:
        def __get__(self):
            self.matchMu8E23_2_branch.GetEntry(self.localentry, 0)
            return self.matchMu8E23_2_value

    property filterMu23E12_2:
        def __get__(self):
            self.filterMu23E12_2_branch.GetEntry(self.localentry, 0)
            return self.filterMu23E12_2_value

    property filterMu8E23_2:
        def __get__(self):
            self.filterMu8E23_2_branch.GetEntry(self.localentry, 0)
            return self.filterMu8E23_2_value

    property bpt_2:
        def __get__(self):
            self.bpt_2_branch.GetEntry(self.localentry, 0)
            return self.bpt_2_value

    property bflavor_2:
        def __get__(self):
            self.bflavor_2_branch.GetEntry(self.localentry, 0)
            return self.bflavor_2_value

    property beta_2:
        def __get__(self):
            self.beta_2_branch.GetEntry(self.localentry, 0)
            return self.beta_2_value

    property bphi_2:
        def __get__(self):
            self.bphi_2_branch.GetEntry(self.localentry, 0)
            return self.bphi_2_value

    property pt_top1:
        def __get__(self):
            self.pt_top1_branch.GetEntry(self.localentry, 0)
            return self.pt_top1_value

    property pt_top2:
        def __get__(self):
            self.pt_top2_branch.GetEntry(self.localentry, 0)
            return self.pt_top2_value

    property genweight:
        def __get__(self):
            self.genweight_branch.GetEntry(self.localentry, 0)
            return self.genweight_value

    property gen_Higgs_pt:
        def __get__(self):
            self.gen_Higgs_pt_branch.GetEntry(self.localentry, 0)
            return self.gen_Higgs_pt_value

    property gen_Higgs_mass:
        def __get__(self):
            self.gen_Higgs_mass_branch.GetEntry(self.localentry, 0)
            return self.gen_Higgs_mass_value


