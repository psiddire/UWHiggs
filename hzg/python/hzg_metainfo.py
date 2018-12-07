#!/usr/bin/env python

#need to mash together pattuple and hzg naming schema
import UWHiggs.hzg.hzg_pattuples as hzg
import FinalStateAnalysis.MetaData.data8TeVNew as eightTeV
import FinalStateAnalysis.MetaData.data7TeV as sevenTeV
from copy import deepcopy
import os

ntupleRoot = os.environ['hzgntupleroot']
ntupleRevision= os.environ['hzgntuplerevision']

higgsKey = 'HToZG'
higgsMasses = [120,125,130,135,140,145,150]

analysis_list = {}

for tupleset in hzg.allTuples.keys():
    analysis_list[tupleset] = {}
    if '8' in tupleset:
        parent = eightTeV.datadefs
    else:
        parent = sevenTeV.datadefs
    for tuple in hzg.allTuples[tupleset].keys():
        if( tuple == 'tupleName' or
            tuple == 'tupleRoot' or
            tuple == 'tupleDate' ): continue
        
        analysis_info = analysis_list[tupleset]
        analysis_info[tuple] = {}
        #print tupleset, tuple
        #try to reconstruct original patTuple name
        if higgsKey in tuple:
            for mass in higgsMasses:
                name = '%s_M-%i'%(tuple,mass)
                analysis_info[tuple][name] = deepcopy(parent[name])
                analysis_info[tuple][name]['vetoIFSR'] = False
                analysis_info[tuple][name]['isRealData'] = False
        else:
            for dataset in hzg.allTuples[tupleset][tuple]:
                for patTupleName in parent.keys():                    
                    if( 'datasetpath' in parent[patTupleName].keys() and
                        parent[patTupleName]['datasetpath'] == dataset ):
                        analysis_info[tuple][patTupleName] = \
                                       deepcopy(parent[patTupleName])
                        if 'DY' in dataset:
                            analysis_info[tuple][patTupleName]['vetoIFSR'] =\
                                                                          True
                        else:
                            analysis_info[tuple][patTupleName]['vetoIFSR'] =\
                                                                          False
                        
        
        
                        

        


