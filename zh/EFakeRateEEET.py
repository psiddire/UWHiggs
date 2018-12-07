'''
Base analyzer for muon id fake-rate estimation: Z->e e
'''

import EMUFakeRatesBase
from EEETauTree import EEETauTree
import baseSelections as selections

class EFakeRateEEET(EMUFakeRatesBase.EMUFakeRatesBase):
    tree = 'eeet/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        #print 'Called: EFakeRateEEET'
        super(EFakeRateEEET, self).__init__(tree, outfile, EEETauTree, **kwargs)
        self.lepton   = 'electron'
        self.branchId = 'e3'
        
    def zSelection(self, row):
        #if not selections.ZEESelectionNoVetos(row): return False
        #if selections.overlap(row, 'e1','e2','e3','t') : return False
        #if bool(row.eVetoMVAIso):       return False
        #if bool(row.bjetCSVVeto):       return False    
        #if row.tPt < 5:                 return False     
        #if not selections.signalElectronSelection(row,'e3'): return False

        if not selections.ZEESelection(row): return False
        if selections.overlap(row, 'e1','e2','e3','t') : return False
        if not selections.signalTauSelection(row,'t',5): return False
        if not bool(row.tAntiMuonLoose): return False
        if not bool(row.tAntiElectronMVA2Tight): return False
        if not selections.signalElectronSelection(row,'e3'): return False
        return True

    def lepton_passes_tight_iso(self, row):
        return bool(row.e3RelPFIsoDB < 0.10) and selections.eleID(row, 'e3') #bool( row.e3MVAIDH2TauWP ) ##THIS SEEMS too low        

    def lepton_passes_loose_iso(self, row):
        return bool(row.e3RelPFIsoDB < 0.3) and selections.eleID(row, 'e3') #bool( row.e3MVAIDH2TauWP ) ##THIS SEEMS too low        

    
