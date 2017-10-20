from FinalStateAnalysis.PlotTools.decorators import memo
from FinalStateAnalysis.Utilities.struct import struct
#from electronids import electronIds


@memo
def getVar(name, var):
    return name+var

@memo
def splitEid(label):
    return label.split('_')[-1], label.split('_')[0] 

#OBJECT SELECTION
def muSelection(row, name):
    if getattr( row, getVar(name,'Pt')) < 30:       return False
    if abs(getattr( row, getVar(name,'Eta'))) > 2.4:  return False
    if getattr( row, getVar(name,'PixHits')) < 1:   return False
    #if getattr( row, getVar(name,'JetPFCISVBtag')) > 0.89: return False
    if abs(getattr( row, getVar(name,'PVDZ'))) > 0.2: return False
    #if abs(getattr(row, getVar(name, 'PVDXY'))) > 0.045: return False
    return True


#VETOS

#def vetos(row):
#    if row.bjetCISVVeto30Medium: return False
    
#    return True

#def lepton_id_iso(row, name, label): #label in the format eidtype_isotype
#    'One function to rule them all'
#    LEPTON_ID = False
#    isolabel #eidlabel = splitEid(label) #memoizes to be faster!
#    if name[0]=='m':
#        #definition of good global muon
#        goodGlob = True
#        if not getattr(row, getVar(name,'IsGlobal')): goodGlob = False
#        if not getattr(row, getVar(name, 'NormalizedChi2')) < 3: goodGlob = False
#        if not getattr(row, getVar(name,'Chi2LocalPosition')) < 12: goodGlob = False
#        if not getattr(row, getVar(name,'TrkKink')) < 20: goodGlob = False
#        
        #definition of ICHEP Medium Muon
#        LEPTON_ID =True
#        if not getattr(row, getVar(name,'PFIDLoose')): LEPTON_ID =False
#        if not getattr(row, getVar(name,'ValidFraction')) > 0.49 : LEPTON_ID = False
#        if not bool((goodGlob == True and getattr(row, getVar(name,'SegmentCompatibility')) > 0.303) or (getattr(row, getVar(name,'SegmentCompatibility')) > 0.451)) : LEPTON_ID =False
        
#    else:
#        LEPTON_ID = getattr(row, getVar(name, 'PFIDTight'))
#    if not LEPTON_ID:
#        return False
#    RelPFIsoDB   = getattr(row, getVar(name, 'IsoDB03'))
#    AbsEta       = getattr(row, getVar(name, 'AbsEta'))
#    if isolabel == 'idiso01':
#        return bool( RelPFIsoDB < 0.10 )
#    if isolabel == 'idiso015':
#        return bool( RelPFIsoDB < 0.15 )
#    if isolabel == 'idiso02':
#        return bool( RelPFIsoDB < 0.20 )
#    if isolabel == 'idiso025':
#        return bool( RelPFIsoDB < 0.25 )
#    if isolabel == 'idiso05':
#        return bool( RelPFIsoDB < 0.5 )
#    if isolabel == 'idiso1':
#        return bool (RelPFIsoDB < 1.0 ) 
        
        

