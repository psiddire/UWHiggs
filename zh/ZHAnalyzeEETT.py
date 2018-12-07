'''

Analyze EETT events for the ZH analysis

'''

#from FinalStateAnalysis.StatTools.RooFunctorFromWS import build_roofunctor
import glob
from EETauTauTree import EETauTauTree
import os
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
import baseSelections as selections
import mcCorrectors
import ZHAnalyzerBase
import ROOT
import fake_rate_functions as fr_fcn

################################################################################
#### Analysis logic ############################################################
################################################################################

class ZHAnalyzeEETT(ZHAnalyzerBase.ZHAnalyzerBase):
    tree = 'eett/final/Ntuple'
    name = 8
    def __init__(self, tree, outfile, **kwargs):
        super(ZHAnalyzeEETT, self).__init__(tree, outfile, EETauTauTree, 'TT', **kwargs)
        # Hack to use S6 weights for the one 7TeV sample we use in 8TeV
        target = os.environ['megatarget']
        self.pucorrector = mcCorrectors.make_puCorrector('doublee')
        ## if 'HWW3l' in target:
        ##     print "HACK using S6 PU weights for HWW3l"
        ##     mcCorrectors.force_pu_distribution('S6')

    def Z_decay_products(self):
        return ('e1','e2')

    def H_decay_products(self):
        return ('t1','t2')

    def book_histos(self, folder):
        self.book_general_histos(folder)
        self.book_kin_histos(folder, 'e1')
        self.book_kin_histos(folder, 'e2')
        self.book_kin_histos(folder, 't1')
        self.book_kin_histos(folder, 't2')
        self.book_Z_histos(folder)
        self.book_H_histos(folder)
 
    def leg3_id(self, row):
        return bool(row.t1LooseIso3Hits) ##THIS SEEMS too low

    def leg4_id(self, row):
        return bool(row.t2LooseIso3Hits) ##SHOULD BE TIGHT!!!

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        if not selections.ZEESelection(row): return False
        #print "passed Z->EE selection"
        if selections.overlap(row, 'e1','e2','t1','t2') : return False
        if not selections.signalTauSelection(row,'t1'): return False
        if not selections.signalTauSelection(row,'t2'): return False
        if not bool(row.t1AntiMuonLoose2): return False
        if not bool(row.t1AntiElectronLoose): return False
        if not bool(row.t2AntiMuonLoose2): return False
        if not bool(row.t2AntiElectronLoose): return False
        if row.t1Pt < row.t2Pt: return False #Avoid double counting
        #if row.LT < 75: return False
        if row.t1Pt + row.t2Pt < 70: return False
        #if (row.t1_t2_SVfitMass < 100 or row.t1_t2_SVfitMass > 150): return False # for MSSM
        return True

    def sign_cut(self, row):
        ''' Returns true if muons are SS '''
        return not bool(row.t1_t2_SS)

    def event_weight(self, row):
        if row.run > 2:
            return 1.
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_electron_corrections(row, 'e1','e2')

    def leg3_weight(self, row):
        return fr_fcn.tau_jetpt_fr( row.t1JetPt ) / (1 - fr_fcn.tau_jetpt_fr( row.t1JetPt ))

    def leg4_weight(self, row):
        return fr_fcn.tau_jetpt_fr( row.t2JetPt ) / (1 - fr_fcn.tau_jetpt_fr( row.t2JetPt ))
