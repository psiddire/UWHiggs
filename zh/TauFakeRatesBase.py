'''
Base analyzer for hadronic tau fake-rate estimation
'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import baseSelections as selections
import os

class TauFakeRatesBase(MegaBase):
    def __init__(self, tree, outfile, wrapper, **kwargs):
        super(TauFakeRatesBase, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = wrapper(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.numerators = ['LooseIso3Hits', 'MediumIso']

    def begin(self):
        # Book histograms
        region = 'ztt'
        for denom in ['pt10']:
            denom_key = (region, denom)
            denom_histos = {}
            self.histograms[denom_key] = denom_histos

            for numerator in self.numerators:
                num_key = (region, denom, numerator)
                num_histos = {}
                self.histograms[num_key] = num_histos

                def book_histo(name, *args):
                    # Helper to book a histogram
                    if name not in denom_histos:
                        denom_histos[name] = self.book(os.path.join(
                            region, denom), name, *args)
                    num_histos[name] = self.book(os.path.join(
                        region, denom, numerator), name, *args)

                book_histo('tauPt', 'Tau Pt', 150, 0, 150)
                book_histo('tauJetPt', 'Tau Jet Pt', 150, 0, 150)
                book_histo('tauAbsEta', 'Tau Abs Eta', 100, -2.5, 2.5)
                book_histo('tauTauInvMass', ';M_{#tau #tau} [GeV/c^{2}];Events/10 [GeV/c^{2}]', 51, 0., 255)

    def process(self):
        # Generic filler function to fill plots after selection
        def fill(the_histos, row, t):
            weight = 1.0
            the_histos['tauPt'].Fill(getattr( row,t+'Pt'), weight)
            the_histos['tauJetPt'].Fill(getattr( row,t+'JetPt'), weight)
            the_histos['tauAbsEta'].Fill(getattr( row,t+'AbsEta'), weight)

        def preselection(self, row):
            if not self.zSelection(row):     return False
            if not selections.signalTauSelection(row, 't1'): return False
            if not selections.signalTauSelection(row, 't2'): return False
            if not bool(row.t1AntiMuonLoose2): return False
            if not bool(row.t1AntiElectronLoose): return False
            if not bool(row.t2AntiMuonLoose2): return False
            if not bool(row.t2AntiElectronLoose): return False
            if row.t1Pt < row.t2Pt: return False #Avoid double counting
            if row.t1Pt + row.t2Pt < 60: return False
            if not bool(row.t1_t2_SS):       return False
            return True

        histos = self.histograms

        # Denominator regions (dicts of histograms)
        pt10 = histos[('ztt', 'pt10')]
        #pt10_antiElMVATight_antiMuLoose = histos[('ztt', 'pt10-antiElMVATight-antiMuLoose')]
        #pt10_antiElMed_antiMuMed = histos[('ztt','pt10-antiElMed-antiMuMed')]
        #pt10_antiElLoose_antiMuTight = histos[('ztt','pt10-antiElLoose-antiMuTight')]

        # Analyze data.  Select events with a good Z.
        for row in self.tree:
            if not preselection(self, row):
                continue

            fill(pt10, row, 't1')
            fill(pt10, row, 't2')
            for t in ['t1','t2']:
                  for num in self.numerators:
                    if bool( getattr(row,t+num) ):
                        fill(histos[('ztt', 'pt10', num)], row, t)
            pt10['tauTauInvMass'].Fill( row.t1_t2_Mass, 1.)

            # Fill denominator
         #   if row.t1AntiElectronLoose and row.t2AntiElectronLoose and row.t1AntiMuonTight2 and row.t2AntiMuonTight2: 
         #       fill(pt10_antiElLoose_antiMuTight, row, 't1')
         #       fill(pt10_antiElLoose_antiMuTight, row, 't2')
         #       for t in ['t1','t2']:
         #         for num in self.numerators:
         #           if bool( getattr(row,t+num) ):
         #               fill(histos[('ztt', 'pt10-antiElLoose-antiMuTight', num)], row, t)

         #   if row.t1AntiElectronMVA2Tight and row.t2AntiElectronMVA2Tight and row.t1AntiMuonLoose and row.t2AntiMuonLoose:
         #       fill(pt10_antiElMVATight_antiMuLoose, row, 't1')
         #       fill(pt10_antiElMVATight_antiMuLoose, row, 't2')
         #       for t in ['t1','t2']:
         #         for num in self.numerators:
          #          if bool( getattr(row,t+num) ):
          #              fill(histos[('ztt','pt10-antiElMVATight-antiMuLoose', num)], row, t)

          #  if row.t1AntiElectronMedium and row.t2AntiElectronMedium and row.t1AntiMuonMedium2 and row.t2AntiMuonMedium2:
          #      fill(pt10_antiElMed_antiMuMed, row, 't1')
          #      fill(pt10_antiElMed_antiMuMed, row, 't2')
          #      for t in ['t1','t2']:
          #        for num in self.numerators:
          #          if bool( getattr(row,t+num) ):
          #              fill(histos[('ztt','pt10-antiElMed-antiMuMed', num,)], row, t)


    def finish(self):
        self.write_histos()

