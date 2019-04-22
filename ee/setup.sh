#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/psiddire
export MEGAPATH=/hdfs/store/user/psiddire

source jobid.sh
export jobid=$jobidmt

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, ee/final/Ntuple, EETree]"

#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

#rake "meta:getinputs[$jobid, $datasrc, ee/metaInfo, ee/summedWeights]"
rake "meta:getmeta[inputs/$jobid, ee/metaInfo, 13, ee/summedWeights]"


