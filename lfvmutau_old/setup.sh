#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/ndev
#export datasrc=/hdfs/store/user/taroni
#export datasrc=/scratch/aglevine/data
#export datasrc=/scratch/mcepeda/data

source jobid.sh
export jobid=$jobidmt
#export jobid=LFV_mutau
#export jobid8TeV=$jobid
export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, mt/final/Ntuple, MuTauTree]"

#echo 'Note that part of the data is in login06 (under mcepeda and aglevine) and part in login05 (under aglevine)'

#ls *pyx | sed "s|pyx|so|" | xargs rake 

#rake "meta:getinputs[$jobid, $datasrc,mt/metaInfo]"
#rake "meta:getmeta[inputs/$jobid, mt/metaInfo, 8]"
#rake "meta:getinputs[$jobid, $datasrc,mt/metaInfo,mt/summedWeights]"
rake "meta:getmeta[inputs/$jobid, mt/metaInfo,13,mt/summedWeights]"

