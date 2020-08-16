#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/kaho
export MEGAPATH=/hdfs/store/user/kaho

export jobidmt='Data2017JEC_mt'
#export jobidmt='Embed2017JEC_mt'
#export jobidmt='MC2017JEC'
export jobid=$jobidmt

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, mt/final/Ntuple, MuTauTree]"

#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, mt/metaInfo, mt/summedWeights]"
rake "meta:getmeta[inputs/$jobid, mt/metaInfo, 13, mt/summedWeights]"
