from MuMuTree import MuMuTree
import sys
import logging
logging.basicConfig(stream=sys.stderr, level=logging.WARNING)
import os
import ROOT
import math
import glob
import array
import baseSelections as selections
from FinalStateAnalysis.PlotTools.decorators import memo
from FinalStateAnalysis.PlotTools.decorators import memo_last
import FinalStateAnalysis.PlotTools.pytree as pytree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
from math import sqrt, pi, cos

@memo
def getVar(name, var):
    return name+var

def deltaPhi(phi1, phi2):
    PHI = abs(phi1-phi2)
    if PHI<=pi:
        return PHI
    else:
        return 2*pi-PHI

def deltaR(phi1, phi2, eta1, eta2):
    deta = eta1 - eta2
    dphi = abs(phi1-phi2)
    if (dphi>pi) : dphi = 2*pi-dphi
    return sqrt(deta*deta + dphi*dphi);

class MuMuAnalyserGen(MegaBase):
    tree = 'mm/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        logging.debug('MuMuAnalyserGen constructor')
        self.channel='MM'
        target = os.path.basename(os.environ['megatarget'])

        super(MuMuAnalyserGen, self).__init__(tree, outfile, **kwargs)
        self.tree = MuMuTree(tree)
        self.out=outfile
        self.histograms = {}
        self.histo_locations = {}
        self.hfunc   = {}
        ROOT.TH1.AddDirectory(True)



    def begin(self):
        folder = ['mm','Iso1','Iso0p5','Iso0p25','Iso0p15','Iso0p1']
        for f in folder:
            
       # f='mt' this is the name of the folder with histo in the output file
            self.book(f,"m1Pt", "m1 Pt", 200, 0, 200 )
            self.book(f,"m2Pt", "m2 Pt", 200, 0, 200 )
            self.book(f,"m1_m2_Mass", "m1 m2 Mass", 200, 0, 200 )
            self.book(f,"m1GenPt", "m1 Gen Pt", 200, 0, 200 )
            self.book(f,"m2GenPt", "m2 Gen Pt", 200, 0, 200 )
           

        for key, value in self.histograms.iteritems():
            location = os.path.dirname(key)
            name     = os.path.basename(key)
            if location not in self.histo_locations:
                self.histo_locations[location] = {name : value}
            else:
                self.histo_locations[location][name] = value
                
    def fill_histos(self, folder_str, row, weight, filter_label = ''):
        
        for attr, value in self.histo_locations[folder_str].iteritems():
            name = attr

            if value.InheritsFrom('TH2'):
                if attr in self.hfunc:
                    try:
                        result, out_weight = self.hfunc[attr](row, weight)
                    except Exception as e:
                        raise RuntimeError("Error running function %s. Error: \n\n %s" % (attr, str(e)))
                    r1, r2 = result
                    if out_weight is None:
                        value.Fill( r1, r2 ) #saves you when filling NTuples!
                    else:
                        value.Fill( r1, r2, out_weight )
                else:
                    attr1, attr2 = split(attr, '_vs_')
                    v1 = getattr(row,attr1)
                    v2 = getattr(row,attr2)
                    value.Fill( v2, v1, weight ) if weight is not None else value.Fill( v2, v1 )
            else:
                if attr in self.hfunc:
                    try:
                        result, out_weight = self.hfunc[attr](row, weight)
                    except Exception as e:
                        raise RuntimeError("Error running function %s. Error: \n\n %s" % (attr, str(e)))
                    if out_weight is None:
                        value.Fill( result ) #saves you when filling NTuples!
                    else:
                        value.Fill( result, out_weight )
                else:
                    #print attr, weight
                    value.Fill( getattr(row,attr), weight ) if weight is not None else value.Fill( getattr(row,attr) )


        return None

    
    def process(self):
         for row in self.tree:
             if row.singleIsoMu27Pass == 0:# and row.singleMu27Pass == 0:
                 continue
             dirnames = ['mm']
             weight_to_use = row.GenWeight #it should be changed when using corrections
             if row.bjetCISVVeto30Medium!=0 : continue
             if not selections.muSelection(row, 'm1') or not selections.muSelection(row, 'm2'): continue
             if not row.m1PFIDLoose == 1 or not row.m2PFIDLoose == 1: continue
             if row.m1RelPFIsoDBDefaultR04 < 1 and row.m2RelPFIsoDBDefaultR04 < 1:
                 dirnames.append('Iso1')
             if row.m1RelPFIsoDBDefaultR04 < 0.5 and row.m2RelPFIsoDBDefaultR04 < 0.5:
                 dirnames.append('Iso0p5')
             if row.m1RelPFIsoDBDefaultR04 < 0.25 and row.m2RelPFIsoDBDefaultR04 < 0.25:
                 dirnames.append('Iso0p25')
             if row.m1RelPFIsoDBDefaultR04 < 0.15 and row.m2RelPFIsoDBDefaultR04 < 0.15:
                 dirnames.append('Iso0p15')
             if row.m1RelPFIsoDBDefaultR04 < 0.1 and row.m2RelPFIsoDBDefaultR04 < 0.1:
                 dirnames.append('Iso0p1')
             for dirname in dirnames:
                 self.fill_histos(dirname, row, weight_to_use)


    def finish(self):
        self.write_histos()
