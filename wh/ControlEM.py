'''

Make control plots of Z and ttbar -> emu events.

Author: Evan K. Friis, UW

'''

import EMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import mcCorrectors
import baseSelections as selections
import fakerate_functions as frfits
import optimizer

# Determine MC-DATA corrections
is7TeV = bool('7TeV' in os.environ['jobid'])
print "Is 7TeV:", is7TeV
use_iso_trigger = not is7TeV

leadleptonId = optimizer.grid_search['EMT']['leading_iso'].replace('lead4muon_', '')
subleptonId  = optimizer.grid_search['EMT']['subleading_iso']

class ControlEM(MegaBase):
    tree = 'em/final/Ntuple'

    def __init__(self, tree, outfile, **kwargs):
        super(ControlEM, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = EMuTree.EMuTree(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.pucorrector = mcCorrectors.make_puCorrector('mueg')

    def begin(self):
        for folder in ['', '/ss', '/f2', '/f2/w2']:
            self.book('em' + folder, "weight", "Event weight", 100, 0, 5)
            self.book('em' + folder, "weight_nopu", "Event weight without PU",
                      100, 0, 5)

            self.book('em' + folder, "rho", "Fastjet #rho", 100, 0, 25)
            self.book('em' + folder, "nvtx", "Number of vertices",
                      31, -0.5, 30.5)
            self.book('em' + folder, "prescale", "HLT prescale",
                      21, -0.5, 20.5)
            self.book('em' + folder, "group", "HLT group", 21, -0.5, 20.5)

            self.book('em' + folder, "mPt", "Muon 1 Pt", 100, 0, 100)
            self.book('em' + folder, "ePt", "Muon 2 Pt", 100, 0, 100)
            self.book('em' + folder, "mAbsEta", "Muon 1 eta", 100, -2.5, 2.5)
            self.book('em' + folder, "eAbsEta", "Muon 2 eta", 100, -2.5, 2.5)
            self.book('em' + folder, "emMass", "m_{e#mu} (GeV)", 240, 0, 240)

            self.book('em' + folder, 'mPixHits', 'Mu 1 pix hits',
                      10, -0.5, 9.5)

            self.book('em' + folder, 'mJetBtag', 'Mu 1 JetBtag',
                      100, -5.5, 9.5)
            self.book('em' + folder, 'eJetBtag', 'Mu 2 JetBtag',
                      100, -5.5, 9.5)

            # Vetoes
            self.book('em' + folder, 'bjetVeto', 'Number of b-jets',
                      5, -0.5, 4.5)
            self.book('em' + folder, 'bjetCSVVeto', 'Number of b-jets',
                      5, -0.5, 4.5)
            self.book('em' + folder, 'muVetoPt5', 'Number of extra muons',
                      5, -0.5, 4.5)
            self.book('em' + folder, 'tauVetoPt20', 'Number of extra taus',
                      5, -0.5, 4.5)
            self.book('em' + folder, 'eVetoCicTightIso',
                      'Number of extra CiC tight electrons', 5, -0.5, 4.5)

    def correction(self, row):
        return self.pucorrector(row.nTruePU) * \
            mcCorrectors.get_muon_corrections(row,'m') * \
            mcCorrectors.get_electron_corrections(row,'e') * \
            mcCorrectors.correct_mueg_mu(row.mPt, row.mAbsEta) * \
            mcCorrectors.correct_mueg_e(row.ePt, row.eAbsEta)

    def fill_histos(self, row):
        histos = self.histograms
        weight = self.correction(row)

        def fill_folder(x, w):
            histos[x + '/weight'].Fill(w)
            histos[x + '/rho'].Fill(row.rho, w)
            histos[x + '/nvtx'].Fill(row.nvtx, w)
            histos[x + '/prescale'].Fill(row.mu17ele8Prescale, w)
            histos[x + '/group'].Fill(row.mu17ele8Group, w)
            histos[x + '/ePt'].Fill(row.ePt, w)
            histos[x + '/mPt'].Fill(row.mPt, w)
            histos[x + '/eAbsEta'].Fill(row.eAbsEta, w)
            histos[x + '/mAbsEta'].Fill(row.mAbsEta, w)
            histos[x + '/mPixHits'].Fill(row.mPixHits, w)
            histos[x + '/eJetBtag'].Fill(row.eJetBtag, w)
            histos[x + '/mJetBtag'].Fill(row.mJetBtag, w)
            histos[x + '/emMass'].Fill(row.e_m_Mass, w)

            histos[x + '/bjetVeto'].Fill(row.bjetVeto, w)
            histos[x + '/bjetCSVVeto'].Fill(row.bjetCSVVeto, w)
            histos[x + '/muVetoPt5'].Fill(row.muVetoPt5, w)
            histos[x + '/tauVetoPt20'].Fill(row.tauVetoPt20, w)
            histos[x + '/eVetoCicTightIso'].Fill(row.eVetoCicTightIso, w)

        passes_e_id_iso = self.obj2_id(row)
        if row.e_m_SS and passes_e_id_iso:
            fill_folder('em/ss', weight)
        elif passes_e_id_iso:
            fill_folder('em', weight)
        else:
            fill_folder('em/f2', weight)
            fill_folder('em/f2/w2', weight * self.obj2_weight(row))

    def preselection(self, row):
        ''' Preselection applied to events.

        Excludes FR object IDs and sign cut.
        '''
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        mu8e17 = (row.mu8ele17isoPass and row.ePt >= 20) #if use_iso_trigger else (row.mu17ele8Pass and row.mPt < 20)
        if not (mu17e8 or mu8e17):                return False
        if not selections.muSelection(row, 'm'):  return False #applies basic selection (eta, pt > 10, DZ, pixHits, jetBTag)
        if not selections.eSelection(row, 'e'):   return False #applies basic selection (eta, pt > 10, DZ, missingHits, jetBTag, HasConversion and chargedIdTight)
        if not selections.vetos(row):             return False #applies mu bjet e additional tau vetoes
        return True

    def obj1_id(self, row):
        return selections.lepton_id_iso(row, 'm', leadleptonId)
        #bool(row.mPFIDTight) and (
        #    row.mRelPFIsoDB < 0.1 or
        #    (row.mRelPFIsoDB < 0.15 and row.mAbsEta < 1.479))

    def obj2_id(self, row):
        return selections.lepton_id_iso(row, 'e', subleptonId)
        #bool(row.eMVAIDH2TauWP) and bool(
        #    row.eRelPFIsoDB < 0.1 or
        #    (row.eRelPFIsoDB < 0.15 and row.eAbsEta < 1.479))

    def obj2_weight(self, row):
        mu17e8 = (row.mu17ele8isoPass and row.mPt >= 20) if use_iso_trigger else (row.mu17ele8Pass and row.mPt >= 20)
        fr = 0.
        if mu17e8:
            fr = frfits.lowpt_e_fr[subleptonId](electronJetPt=max(row.eJetPt, row.ePt), electronPt=row.ePt)
        else:
            fr = frfits.highpt_e_fr[subleptonId](electronJetPt=max(row.eJetPt, row.ePt),electronPt=row.ePt)
        return fr / (1. - fr)

    def process(self):
        for row in self.tree:
            if not self.preselection(row):
                continue
            if not self.obj1_id(row):
                continue
            self.fill_histos(row)

    def finish(self):
        self.write_histos()
