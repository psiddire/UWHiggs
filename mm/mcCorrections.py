
import os
import glob
#import FinalStateAnalysis.TagAndProbe.HetauCorrection as HetauCorrection
import FinalStateAnalysis.TagAndProbe.PileupWeight as PileupWeight
from FinalStateAnalysis.PlotTools.decorators import memo, memo_last
#import FinalStateAnalysis.TagAndProbe.EGammaPOGCorrections as EGammaPOGCorrections
import FinalStateAnalysis.TagAndProbe.MuonPOGCorrections as MuonPOGCorrections

@memo
def getVar(name, var):
    return name+var

is7TeV = bool('7TeV' in os.environ['jobid'])
pu_distributions  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu.root'))
    }
pu_distributionsUp  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_up.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_up.root'))
    }
pu_distributionsDown  = {
    'singlee'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleElectron*pu_down.root')),
    'singlem'  : glob.glob(os.path.join( 'inputs', os.environ['jobid'], 'data_SingleMuon*pu_down.root'))
    }
mc_pu_tag = 'S6' if is7TeV else 'PU2017'


def make_puCorrector(dataset, kind=None, puname=''):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced %s'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributions:# and dataset in pu_distributionsUp and dataset in pu_distributionsDown:
        return PileupWeight.PileupWeight( 'S6' if is7TeV else puname, *pu_distributions[dataset])
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorUp(dataset, kind=None):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight( 'S6' if is7TeV else 'MC_Moriond17', *(pu_distributionsUp[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_puCorrectorDown(dataset, kind=None):
    'makes PU reweighting according to the pu distribution of the reference data and the MC, MC distribution can be forced'
    if not kind:
        kind = mc_pu_tag
    if dataset in pu_distributions:
        return PileupWeight.PileupWeight( 'S6' if is7TeV else 'MC_Moriond17', *(pu_distributionsDown[dataset]))
    else:
        raise KeyError('dataset not present. Please check the spelling or add it to mcCorrectors.py')

def make_shifted_weights(default, shifts, functors):
    '''make_shifted_weights(default, shifts, functors) --> functor
    takes as imput the central value functor and two lists
    the name of the shifts and the shifted functors
    the returned functor takes one additional string to
    select the shifted functor. If the shift kwarg is missing
    or does not match any shift tag the central (default)
    fuctor output is returned'''
    #make default fetching faster
    default = default 
    def functor(*args, **kwargs):
        shift = ''
        if 'shift' in kwargs:
            shift = kwargs['shift']
            del kwargs['shift']

            #check if to apply shifts
            for tag, fcn in zip(shifts, functors):
                if tag == shift:
                    return fcn(*args, **kwargs)

        return default(*args, **kwargs)
    return functor

#def make_multiple(fcn, indexed=False, shift=0):
    '''make_multiple(fcn, indexed=True, shift=0) --> functor
    takes as imput a weight correction function of pt and eta
    and returns a functor multiple(row,*args) --> weight
    where *args are the base name of the objects upon which 
    compute the correction.
    If indexed is true means that fcn returns a tuple 
    (weight, error) shift +/-1 makes the functor return the 
    weight+/-error in this case'''
#    def multiple(row,*args):
#        ret = 1.
#        for arg in args:
#            abseta = getattr(
#                row,
#                getVar(arg,'AbsEta')
#            ) 
#            pt     = getattr(row, getVar(arg,'Pt'))
#            if pt<30: pt =30 #only fakerate checks allow pt < 30. This is an approximation to not re-run the Tag and Probe
#            fcn_ret = fcn(pt,abseta)
#            if indexed:
#                value, err = fcn_ret
#                if shift == 1:
#                    ret *= (value + err)
#                elif shift == -1:
#                    ret *= (value - err)
#                else:
#                    ret *= value
#            else:
#                ret   *= fcn_ret
#        return ret
#    return multiple


#efficiency_trigger_2016    = make_multiple(HetauCorrection.single_ele_2016, indexed=True)
#efficiency_trigger_2016_up = make_multiple(HetauCorrection.single_ele_2016, indexed=True, shift=1)
#efficiency_trigger_2016_dw = make_multiple(HetauCorrection.single_ele_2016, indexed=True, shift=-1)


#electronID_WP90_2016 = EGammaPOGCorrections.make_egamma_pog_electronID_ICHEP2016('nontrigWP90')
#electronID_WP80_2016 = EGammaPOGCorrections.make_egamma_pog_electronID_ICHEP2016('nontrigWP80')
#electronIso_0p15_2016 = make_multiple(HetauCorrection.iso0p15_ele_2016, indexed=True)
#electronIso_0p10_2016 = make_multiple(HetauCorrection.iso0p10_ele_2016, indexed=True)

muonID_tight = MuonPOGCorrections.make_muon_pog_PFTight_2017ReReco()
muonIso_tight = MuonPOGCorrections.make_muon_pog_TightIso_2017ReReco('Tight')
efficiency_trigger_mu_2017 = MuonPOGCorrections.make_muon_pog_IsoMu27_2017ReReco()
#muonTracking = MuonPOGCorrections.mu_trackingEta_2016
#DYreweight = HetauCorrection.make_DYreweight()
