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

def invariantMass(mPt, mEta, mPhi, mMass, tPt, tEta, tPhi, tMass):
    vm = ROOT.TLorentzVector()
    vt = ROOT.TLorentzVector()
    vm.SetPtEtaPhiM(mPt,mEta,mPhi,mMass)
    vt.SetPtEtaPhiM(tPt,tEta,tPhi,tMass)
    return (vm+vt).M()

class AnalyzeMuTau(MegaBase):
    tree = 'mt/final/Ntuple'
    def __init__(self, tree, outfile, **kwargs):
        logging.debug('AnalyzeMuTau constructor')
        self.channel='MT'
        target = os.path.basename(os.environ['megatarget'])

        super(AnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
        self.tree = MuTauTree(tree)
        self.out=outfile
        self.histograms = {}
        self.histo_locations = {}
        self.hfunc   = {}
        ROOT.TH1.AddDirectory(True)


    def begin(self):
        folder = ['mt','mtpasscut','mtpasstrigger']
        for f in folder:
            self.book(f,"tPt", "t Pt", 200, 0, 200 )
            self.book(f,"tEta", "t Eta", 100, -5, 5 )
            self.book(f,"tPhi", "t Phi", 100, -5, 5 )
            self.book(f,"tMass", "t Mass", 100, 0, 100 )
            self.book(f,"mPt", "m Pt", 200, 0, 200 )
            self.book(f,"mEta", "m Eta", 100, -5, 5 )
            self.book(f,"mPhi", "m Phi", 100, -5, 5 )
            self.book(f,"mMass", "m Mass", 100, 0, 100 )
            #self.book(f,"m_t_Mass", "m t Mass", 300, 0, 300 )
            #self.book(f,"m_t_collinearmass", "Collinear Mass", 300, 0, 300)
            self.book(f,"tGenPt", "t Gen Pt", 200, 0, 200 )
            self.book(f,"mGenPt", "m Gen Pt", 200, 0, 200 )
            self.book(f,"tGenPhi", "t Gen Phi", 100, -5, 5 )
            self.book(f,"mGenPhi", "m Gen Phi", 100, -5, 5 )
            self.book(f,"tGenEta", "t Gen Eta", 100, -5, 5 )
            self.book(f,"mGenEta", "m Gen Eta", 100, -5, 5 )
                       

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
                        value.Fill( result ) 
                    else:
                        value.Fill( result, out_weight )
                else:
                    #print attr, weight
                    value.Fill( getattr(row,attr), weight ) if weight is not None else value.Fill( getattr(row,attr) )


        return None

    
    def process(self):
         for row in self.tree:
             dirnames = ['mt']
             try:
                 weight_to_use = row.GenWeight #it should be changed when using corrections
             except AttributeError:    
                 weight_to_use = 1.0
             #row.m_t_Mass = invariantMass(row.mPt, row.mEta, row.mPhi, row.mMass, row.tPt, row.tEta, row.tPhi, row.tMass)
             if row.mPt > 26:
                 dirnames.append('mtpasscut')
             if row.IsoMu27Pass and row.mPt > 30:
                 dirnames.append('mtpasstrigger')
             for dirname in dirnames: 
                 self.fill_histos(dirname, row, weight_to_use)    
             

    def finish(self):
        self.write_histos()
