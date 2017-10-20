#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/taroni
export MEGAPATH=/hdfs/store/user/taroni

source jobid.sh
export jobid=$jobidmm

export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, mm/final/Ntuple, MuMuTree]"

#ls *pyx | sed "s|pyx|so|" | xargs rake 

echo $afile

#rake "meta:getinputs[$jobid, $datasrc,mm/metaInfo,mm/summedWeights]"
rake "meta:getmeta[inputs/$jobid, mm/metaInfo,13,mm/summedWeights]"

