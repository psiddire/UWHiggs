#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/ndev
export MEGAPATH=/hdfs/store/user/ndev

source jobid.sh

export afile=`find $datasrc/$jobid | grep root | head -n 1`

# Build the cython wrappers
rake "make_wrapper[$afile, emm/final/Ntuple, EMMTree]"

#ls *pyx | sed "s|pyx|so|" | xargs rake 
ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, emm/metaInfo, emm/summedWeights]"
#rake "meta:getmeta[inputs/$jobid, emm/metaInfo, 13, emm/summedWeights]"


