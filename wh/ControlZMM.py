'''

Make control plots of Z->mumu events.

Author: Evan K. Friis, UW

'''

import MuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import baseSelections as selections
import mcCorrectors
import optimizer
import ROOT

################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################

# Determine MC-DATA corrections
is7TeV = bool('7TeV' in os.environ['jobid'])
print "Is 7TeV:", is7TeV

leadleptonId = optimizer.grid_search['MMT']['leading_iso']
subleptonId  = optimizer.grid_search['MMT']['subleading_iso']

class ControlZMM(MegaBase):
    tree = 'mm/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        super(ControlZMM, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = MuMuTree.MuMuTree(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.pucorrector = mcCorrectors.make_puCorrector('doublemu')

    def begin(self):
        self.book('zmm', "weight", "Event weight", 100, 0, 5)
        self.book('zmm', "weight_nopu", "Event weight without PU", 100, 0, 5)

        self.book('zmm', "rho", "Fastjet #rho", 100, 0, 25)
        self.book('zmm', "nvtx", "Number of vertices", 31, -0.5, 30.5)
        self.book('zmm', "prescale", "HLT prescale", 21, -0.5, 20.5)

        self.book('zmm', "m1Pt", "Muon 1 Pt", 100, 0, 100)
        self.book('zmm', "m2Pt", "Muon 2 Pt", 100, 0, 100)
        self.book('zmm', "m1AbsEta", "Muon 1 eta", 100, -2.5, 2.5)
        self.book('zmm', "m2AbsEta", "Muon 2 eta", 100, -2.5, 2.5)
        self.book('zmm', "m1m2Mass", "Muon 1-2 Mass", 240, 60, 120)

        self.book('zmm', 'm1PixHits', 'Mu 1 pix hits', 10, -0.5, 9.5)
        self.book('zmm', 'm2PixHits', 'Mu 2 pix hits', 10, -0.5, 9.5)

        self.book('zmm', 'm1JetBtag', 'Mu 1 JetBtag', 100, -5.5, 9.5)
        self.book('zmm', 'm2JetBtag', 'Mu 2 JetBtag', 100, -5.5, 9.5)

        # Vetoes
        self.book('zmm', 'bjetVeto', 'Number of b-jets', 5, -0.5, 4.5)
        self.book('zmm', 'bjetCSVVeto', 'Number of b-jets', 5, -0.5, 4.5)
        self.book('zmm', 'muVetoPt5', 'Number of extra muons', 5, -0.5, 4.5)
        self.book('zmm', 'tauVetoPt20', 'Number of extra taus', 5, -0.5, 4.5)
        self.book('zmm', 'eVetoCicTightIso', 'Number of extra CiC tight electrons', 5, -0.5, 4.5)

    def correction(self, row):
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m1','m2') * \
            mcCorrectors.double_muon_trigger(row,'m1','m2')

    def fill_histos(self, row):
        histos = self.histograms
        weight = self.correction(row)
        histos['zmm/weight'].Fill(weight)
        histos['zmm/weight_nopu'].Fill(self.correction(row))
        histos['zmm/rho'].Fill(row.rho, weight)
        histos['zmm/nvtx'].Fill(row.nvtx, weight)
        histos['zmm/prescale'].Fill(row.doubleMuPrescale, weight)
        histos['zmm/m1Pt'].Fill(row.m1Pt, weight)
        histos['zmm/m2Pt'].Fill(row.m2Pt, weight)
        histos['zmm/m1AbsEta'].Fill(row.m1AbsEta, weight)
        histos['zmm/m2AbsEta'].Fill(row.m2AbsEta, weight)
        histos['zmm/m1PixHits'].Fill(row.m1PixHits, weight)
        histos['zmm/m2PixHits'].Fill(row.m2PixHits, weight)
        histos['zmm/m1JetBtag'].Fill(row.m1JetBtag, weight)
        histos['zmm/m2JetBtag'].Fill(row.m2JetBtag, weight)
        histos['zmm/m1m2Mass'].Fill(row.m1_m2_Mass, weight)

        histos['zmm/bjetVeto'].Fill(row.bjetVeto, weight)
        histos['zmm/bjetCSVVeto'].Fill(row.bjetCSVVeto, weight)
        histos['zmm/muVetoPt5'].Fill(row.muVetoPt5, weight)
        histos['zmm/tauVetoPt20'].Fill(row.tauVetoPt20, weight)
        histos['zmm/eVetoCicTightIso'].Fill(row.eVetoCicTightIso, weight)

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        double_mu_pass =  row.doubleMuPass and \
            row.m1MatchesDoubleMuPaths > 0 and \
            row.m2MatchesDoubleMuPaths > 0
        double_muTrk_pass = row.doubleMuTrkPass and \
             row.m1MatchesDoubleMuTrkPaths > 0 and \
             row.m2MatchesDoubleMuTrkPaths > 0
        if not ( double_mu_pass or double_muTrk_pass ): return False
        if row.m1_m2_SS:         return False
        if row.m1Pt < row.m2Pt:  return False
        if row.m1_m2_Mass < 60:  return False
        if row.m1_m2_Mass > 120: return False
        if not selections.muSelection(row, 'm1'): return False #applies basic selection (eta, pt > 10, DZ, pixHits, jetBTag)
        if not selections.muSelection(row, 'm2'): return False #applies basic selection (eta, pt > 10, DZ, pixHits, jetBTag)
        return True

    def obj1_id(self, row):
        return selections.lepton_id_iso(row, 'm1', leadleptonId) 
        #bool(row.m1PFIDTight) and bool(row.m1RelPFIsoDB < 0.2)

    def obj2_id(self, row):
        return selections.lepton_id_iso(row, 'm2', subleptonId )
        #bool(row.m2PFIDTight) and bool(row.m2RelPFIsoDB < 0.2)

    def process(self):
        for row in self.tree:
            if not self.preselection(row):
                continue
            if not self.obj1_id(row) or not self.obj2_id(row):
                continue
            self.fill_histos(row)

    def finish(self):
        self.write_histos()
