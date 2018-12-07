#This module provides additional electron ID's starting from MVA's raw values
from FinalStateAnalysis.PlotTools.decorators import memo
@memo
def getVar(name, var):
    return name+var

def zh_loose_2012eid(row, name):
    value    = getattr(row, getVar(name, 'MVANonTrig'))
    pt       = getattr(row, getVar(name, 'Pt'))
    fabseta  = getattr(row, getVar(name, 'AbsEta'))
    if pt > 10. and fabseta < 0.8:
        return (value > 0.5)
    elif pt > 10. and fabseta >=0.8 and fabseta < 1.479:
        return (value > 0.12)
    elif pt > 10. and fabseta >= 1.479:
        return (value > 0.6)
    return False

def h2tau_2012_LooseId(row, name):
     return bool( getattr(row, getVar(name, 'MVAIDH2TauWP')))


def h2tau_2012_tightId(row, name):
    mva_output = getattr(row, getVar(name, 'MVANonTrig'))
    pT         = getattr(row, getVar(name, 'Pt'))
    abseta     = getattr(row, getVar(name, 'AbsEta'))
    if pT > 20  and abseta < 0.8:
        return ( mva_output > 0.925 )
    elif pT > 20  and 0.8 < abseta < 1.479:
        return ( mva_output > 0.975 )
    elif pT > 20  and abseta > 1.479:
        return ( mva_output > 0.985 )
    return False
    

#LEPTON ID-ISO
def summer_2013_eid(row, name):
    mva_output = getattr(row, getVar(name, 'MVATrigNoIP'))
    pT    = getattr(row, getVar(name, 'Pt'))
    abseta= getattr(row, getVar(name, 'AbsEta'))
    if pT < 20    and abseta < 0.8:
        return ( mva_output > -0.5375 )
    elif pT < 20  and 0.8 < abseta < 1.479:
        return ( mva_output > -0.375 )
    elif pT < 20  and abseta > 1.479:
        return ( mva_output > -0.025 )
    elif pT > 20  and abseta < 0.8:
        return ( mva_output > 0.325 )
    elif pT > 20  and 0.8 < abseta < 1.479:
        return ( mva_output > 0.775 )
    elif pT > 20  and abseta > 1.479:
        return ( mva_output > 0.775 )
    return False

def summer_2013_eid_tight(row, name):
    mva_output = getattr(row, getVar(name, 'MVATrigNoIP'))
    pT    = getattr(row, getVar(name, 'Pt'))
    abseta= getattr(row, getVar(name, 'AbsEta'))
    if pT < 20 and abseta < 0.8:
        return ( mva_output > -0.35 )
    elif pT < 20 and 0.8 < abseta < 1.479:
        return ( mva_output > 0.0 )
    elif pT < 20 and abseta > 1.479:
        return ( mva_output > 0.025 )
    elif pT > 20 and abseta < 0.8:
        return ( mva_output > 0.7 )
    elif pT > 20 and 0.8 < abseta < 1.479:
        return ( mva_output > 0.9 )
    elif pT > 20 and abseta > 1.479:
        return ( mva_output > 0.8375 )
    return False


electronIds = {
    'eid12Loose' : zh_loose_2012eid,
    'eid12Medium': h2tau_2012_LooseId,
    'eid12Tight' : h2tau_2012_tightId,
#    'eid13Loose' : summer_2013_eid,
#    'eid13Tight' : summer_2013_eid_tight,
}
