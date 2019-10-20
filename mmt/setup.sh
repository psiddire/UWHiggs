#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/ndev
export MEGAPATH=/hdfs/store/user/ndev

source jobid.sh

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

# Build the cython wrappers
#rake "make_wrapper[$afile, mmt/final/Ntuple, MuMuTauTree]"

#ls *pyx | sed "s|pyx|so|" | xargs rake 
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

#rake "meta:getinputs[$jobid, $datasrc, mmt/metaInfo, mmt/summedWeights]"
rake "meta:getmeta[inputs/$jobid, mmt/metaInfo, 13, mmt/summedWeights]"


