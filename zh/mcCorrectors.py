import os
import glob
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections
import FinalStateAnalysis.TagAndProbe.PileupWeight       as PileupWeight
import FinalStateAnalysis.TagAndProbe.H2TauCorrections   as H2TauCorrections

################################################################################
#### MC-DATA and PU corrections ################################################
################################################################################

# Determine MC-DATA corrections
is7TeV = bool('7TeV' in os.environ['jobid'])
print "Is 7TeV:", is7TeV

# Make PU corrector from expected data PU distribution
# PU corrections .root files from pileupCalc.py
pu_distributions_doublemu  = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_DoubleMu*pu.root'))
pu_distributions_doublee   = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_DoubleElectron*pu.root'))
#pu_corrector               = PileupWeight.PileupWeight( 'S6' if is7TeV else 'S10', *pu_distributions)

#mu_pog_2011_id             = MuonPOGCorrections.make_muon_pog_PFTight_2011()
#mu_pog_2011_iso            = MuonPOGCorrections.make_muon_pog_PFRelIsoDB02_2011()
#muon_pog_IsoID             = (lambda pt, eta: mu_pog_2011_id(pt,eta)*mu_pog_2011_iso(pt,eta)) if is7TeV else H2TauCorrections.correct_mu_idiso_2012
#electron_corrections       = H2TauCorrections.correct_e_idiso_2011 if is7TeV else H2TauCorrections.correct_e_idiso_2012

muon_pog_Mu17Mu8_Mu17_2012 = MuonPOGCorrections.make_muon_pog_Mu17Mu8_Mu17_2012()
muon_pog_Mu17Mu8_Mu8_2012  = MuonPOGCorrections.make_muon_pog_Mu17Mu8_Mu8_2012()
#muon_pog_Mu17Mu8_2011      = MuonPOGCorrections.muon_pog_Mu17Mu8_eta_eta_2011 # takes etas of muons

def make_puCorrector(dataset, kind=None):
    if not kind:
        kind = 'S6' if is7TeV else 'S10'
    if dataset is 'doublemu':
        return PileupWeight.PileupWeight( 'S6' if is7TeV else 'S10', *pu_distributions_doublemu)
    elif dataset is 'doublee':
        return PileupWeight.PileupWeight( 'S6' if is7TeV else 'S10', *pu_distributions_doublee)
    return None
## def force_pu_distribution(kind):
##     pu_corrector = PileupWeight.PileupWeight( kind, *pu_distributions)
    

def get_muon_corrections(row,*args):
    ret = 1.
    #for arg in args:
    #    eta = getattr(row, '%sEta' % arg)
    #    pt  = getattr(row, '%sPt'  % arg)
    #    ret *= muon_pog_IsoID( pt, eta)
    #return ret
    return 1 ## total hack FIXME!!

def double_muon_trigger(row,m1,m2):
    if is7TeV:
        return muon_pog_Mu17Mu8_2011(getattr(row, '%sEta' % m1), getattr(row, '%sEta' % m2) )
    else:
        f1 = muon_pog_Mu17Mu8_Mu17_2012(getattr(row, '%sPt' % m1), getattr(row, '%sEta' % m1))
        f2 =  muon_pog_Mu17Mu8_Mu8_2012(getattr(row, '%sPt' % m2), getattr(row, '%sEta' % m2))
        return f1*f2

def get_electron_corrections(row,*args):
    ret = 1.
    #for arg in args:
    #    abseta = abs(getattr(row, '%sEta' % arg))
    #    pt     = getattr(row, '%sPt'  % arg)
    #    ret   *= electron_corrections(pt,abseta)
    return ret


## # Make PU corrector from expected data PU distribution
## # PU corrections .root files from pileupCalc.py
## pu_distributions = glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_DoubleMu*pu.root'))
## pu_corrector = PileupWeight.PileupWeight( 'S6' if is7TeV else 'S10', *pu_distributions)
