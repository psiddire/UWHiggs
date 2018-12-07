'''
Base analyzer for muon id fake-rate estimation: Z->e e
'''

import EMUFakeRatesBase
import baseSelections as selections
from MuMuETauTree import MuMuETauTree

class EFakeRateMMET(EMUFakeRatesBase.EMUFakeRatesBase):
    tree = 'emmt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(EFakeRateMMET, self).__init__(tree, outfile, MuMuETauTree, **kwargs)
        self.lepton   = 'electron'
        self.branchId = 'e'
        
    def zSelection(self, row):
        #if not selections.ZMuMuSelectionNoVetos(row): return False
        #if selections.overlap(row, 'm1','m2','e','t') : return False
        #if bool(row.eVetoMVAIso):       return False
        #if bool(row.bjetCSVVeto):       return False
        #if row.tPt < 5:                  return False
        ## if row.ePt     < 10:            return False
        ## if row.eAbsEta > 2.5:           return False
        ## if row.eDZ     > 0.1:           return False
        ## return True
        #return selections.signalElectronSelection(row,'e')

        if not selections.ZMuMuSelection(row): return False
        if selections.overlap(row, 'm1','m2','e','t') : return False
        if not selections.signalTauSelection(row,'t',5): return False
        if not bool(row.tAntiMuonLoose): return False
        if not bool(row.tAntiElectronMVA2Tight): return False
        #if not bool(row.tAntiElectronTight): return False
        #if row.LT < 45: return False
        return selections.signalElectronSelection(row,'e')
    
    def lepton_passes_tight_iso(self, row):
        return bool(row.eRelPFIsoDB < 0.10) and selections.eleID(row, 'e') #bool( row.eMVAIDH2TauWP ) ##THIS SEEMS too low        

    def lepton_passes_loose_iso(self, row):
        return bool(row.eRelPFIsoDB < 0.3)  and selections.eleID(row, 'e') ##THIS SEEMS too low        
