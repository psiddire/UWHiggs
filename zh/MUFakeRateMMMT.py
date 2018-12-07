'''
Base analyzer for muon id fake-rate estimation: Z->mu mu
'''

import EMUFakeRatesBase
import baseSelections as selections
from MuMuMuTauTree import MuMuMuTauTree

class MUFakeRateMMMT(EMUFakeRatesBase.EMUFakeRatesBase):
    tree = 'mmmt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(MUFakeRateMMMT, self).__init__(tree, outfile, MuMuMuTauTree, **kwargs)
        self.lepton   = 'muon'
        self.branchId = 'm3'
        
    def zSelection(self, row):
        #if not selections.ZMuMuSelectionNoVetos(row): return False
        #if bool(row.muGlbIsoVetoPt10):  return False
        #if bool(row.bjetCSVVeto):       return False
        #if selections.overlap(row, 'm1','m2','m3','t') : return False 
        #if row.tPt < 5:                 return False
        ### if row.m3Pt < 10:              return False
        ### if row.m3AbsEta > 2.4:         return False
        ### if row.m3DZ > 0.1:             return False
        ### return True
        #return selections.signalMuonSelection(row,'m3')

        if not selections.ZMuMuSelection(row): return False
        if selections.overlap(row, 'm1','m2','m3','t') : return False
        if not selections.signalTauSelection(row,'t',5): return False
        if not bool(row.tAntiMuonTight2): return False
        if not bool(row.tAntiElectronLoose): return False
        return selections.signalMuonSelection(row,'m3')

    def lepton_passes_tight_iso(self, row):
        return bool(row.m3RelPFIsoDB < 0.15) and bool(getattr(row, 'm3PFIDTight') ) ##THIS SEEMS too low        

    def lepton_passes_loose_iso(self, row):
        return bool(row.m3RelPFIsoDB < 0.30) and bool(getattr(row, 'm3PFIDTight') ) ##THIS SEEMS too low        
