from MuTauTree import MuTauTree
import sys
import logging
logging.basicConfig(stream=sys.stderr, level=logging.WARNING)
import os
import ROOT
import math
import glob
import array
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

class LFVMuTauAnalyserGen(MegaBase):
    tree = 'mt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        logging.debug('LFVMuTauAnalyserGen constructor')
        self.channel='MT'
        target = os.path.basename(os.environ['megatarget'])

        super(LFVMuTauAnalyserGen, self).__init__(tree, outfile, **kwargs)
        self.tree = MuTauTree(tree)
        self.out=outfile
        self.histograms = {}
        self.histo_locations = {}
        self.hfunc   = {}
        ROOT.TH1.AddDirectory(True)



    def begin(self):
        folder = ['mt',"fromHiggs"]
        for f in folder:
            
       # f='mt' this is the name of the folder with histo in the output file
            self.book(f,"tPt", "t Pt", 200, 0, 200 )
            self.book(f,"tEta", "t Eta", 100, -10, 10 )
            self.book(f,"tPhi", "t Phi", 100, -10, 10 )
            self.book(f,"mPt", "m Pt", 200, 0, 200 )
            self.book(f,"mEta", "m Eta", 100, -10, 10 )
            self.book(f,"mPhi", "m Phi", 100, -10, 10 )
            self.book(f,"j1pt", "jet1 Pt", 200, 0, 200 )
            self.book(f,"j2pt", "jet2 Pt", 200, 0, 200 )
            self.book(f,"m_t_Mass", "m t Mass", 300, 0, 300 )
            self.book(f,"vbfNJets20", "# of Jets above 20Gev", 100, 0, 10 )
            self.book(f,"vbfj1pt", "Jet1 Pt", 200, 0, 200 )
            self.book(f,"vbfj1eta", "Jet1 Eta", 100, -10, 10 )
            self.book(f,"vbfj2pt", "Jet2 Pt", 200, 0, 200 )
            self.book(f,"vbfj2eta", "Jet2 Eta", 100, -10, 10 )
            self.book(f,"vbfdijetpt", "Jets Pt", 200, 0, 200 )
            self.book(f,"vbfMass", "Jets Mass", 200, 0, 200 )
            self.book(f,"vbfDeta", "Delta Eta Jets", 100, 0, 10 )
            self.book(f,"vbfDphi", "Delta Phi Jets", 100, 0, 10 )
            self.book(f,"m_t_collinearmass", "Collinear Mass", 300, 0, 300)
            self.book(f,"tGenPt", "t Gen Pt", 200, 0, 200 )
            self.book(f,"mGenPt", "m Gen Pt", 200, 0, 200 )
            self.book(f,"tGenPhi", "t Gen Phi", 100, -10, 10 )
            self.book(f,"mGenPhi", "m Gen Phi", 100, -10, 10 )
            self.book(f,"tGenEta", "t Gen Eta", 100, -10, 10 )
            self.book(f,"mGenEta", "m Gen Eta", 100, -10, 10 )
            self.book(f,"mGenMotherPdgId", "mGenMotherPdgId", 100, -50, 50 )
            self.book(f,"tGenMotherPdgId", "tGenMotherPdgId", 100, -50, 50 )
            self.book(f,"tGenCharge", "t Gen Charge", 100, -2, 2 )
           

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
             dirnames = ['mt']
             weight_to_use = row.GenWeight #it should be changed when using corrections
         #    if row.tGenPdgID
#             print row.tGenMotherPdgId, row.tGenPdgId
             if row.tGenMotherPdgId==25 and row.mGenMotherPdgId==25:
                 dirnames.append("fromHiggs")
             for dirname in dirnames:    
                 self.fill_histos(dirname, row, weight_to_use)


    def finish(self):
        self.write_histos()
