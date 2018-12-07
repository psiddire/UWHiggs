'''
Base analyzer for hadronic tau fake-rate estimation: Z->mu mu
'''

import TauFakeRatesBase
import baseSelections as selections
from MuMuTauTauTree import MuMuTauTauTree


class TauFakeRatesMMTT(TauFakeRatesBase.TauFakeRatesBase):
    tree = 'mmtt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(TauFakeRatesMMTT, self).__init__(tree, outfile, MuMuTauTauTree, **kwargs)
        
    def zSelection(self, row):
        if not selections.ZMuMuSelection(row): return False
        return (not selections.overlap(row, 'm1','m2','t1','t2'))


       
