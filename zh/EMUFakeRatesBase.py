'''
Base analyzer for hadronic tau fake-rate estimation
'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import baseSelections as selections
import os

class EMUFakeRatesBase(MegaBase):
    def __init__(self, tree, outfile, wrapper, **kwargs):
        #print 'called: TauFakeRatesBase'
        super(EMUFakeRatesBase, self).__init__(tree, outfile, **kwargs)
        # Use the cython wrapper
        self.tree = wrapper(tree)
        self.out = outfile
        # Histograms for each category
        self.histograms = {}
        self.is7TeV = '7TeV' in os.environ['jobid']
        self.lepton   = ''#self.leptonName()
        self.branchId = ''#self.branchIdentifier()

    def begin(self):
        # Book histograms
        region = 'zlt'
        for denom in ['pt10']:
            denom_key = (region, denom)
            denom_histos = {}
            self.histograms[denom_key] = denom_histos

            for numerator in ['looseId','tightId']:
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

                book_histo(self.lepton+'Pt',     self.lepton+' Pt', 150, 0, 150)
                book_histo(self.lepton+'JetPt',  self.lepton+' Jet Pt', 150, 0, 150)
                book_histo(self.lepton+'AbsEta', self.lepton+' Abs Eta', 100, -2.5, 2.5)
    
    def process(self):
        # Generic filler function to fill plots after selection
        def fill(the_histos, row):
            weight = 1.0
            the_histos[self.lepton+'Pt'].Fill(    getattr( row, self.branchId+'Pt'    ), weight)
            the_histos[self.lepton+'JetPt'].Fill( getattr( row, max(self.branchId+'JetPt',self.branchId+'Pt') ), weight)
            the_histos[self.lepton+'AbsEta'].Fill(getattr( row, self.branchId+'AbsEta'), weight)

        def preselection(self, row):
            if not self.zSelection(row):    return False
            #if row.pfMet_mes_Et > 20:                            return False
            #if row.mva_metEt > 20: return False
            if getattr(row,self.branchId+'MtToMET') > 30: return False #AN --> 30
            #if row.jetVeto30 < 0.5: return False
            if not getattr(row,self.branchId+'_t_SS'):    return False
            #if not selections.signalTauSelection(row, 't'): return False        
            ## if row.tAbsEta  > 2.3:                return False
            ## if abs(row.tDZ) > 0.1:                return False    
            ## if not bool(row.tDecayFinding):       return False
            ## if not bool(row.tAntiElectronLoose):  return False #in the AN is not specified but seems reasonable
            ## if not bool(row.tAntiMuonLoose):      return False #in the AN is not specified but seems reasonable
            #BTag on the jet associated to the tau. Not exactly as Abdollah but close enough
            ## if row.tJetCSVBtag > 0.679:     return False
            return True

        histos = self.histograms
        # Denominator regions (dicts of histograms)
        pt10 = histos[('zlt', 'pt10')]

        # Analyze data.  Select events with a good Z.
        for row in self.tree:
            if not preselection(self, row):
                continue

            # Fill denominator
            #print 'PRESELECTION PASSED!'
            fill(pt10, row)
            if self.lepton_passes_loose_iso(row):
                #print 'ISOLATION PASSED!'
                fill(histos[('zlt', 'pt10', 'looseId')], row)
            if self.lepton_passes_tight_iso(row):
                #print 'ISOLATION PASSED!'
                fill(histos[('zlt', 'pt10', 'tightId')], row)


    def finish(self):
        self.write_histos()

