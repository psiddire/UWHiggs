#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/psiddire
export MEGAPATH=/hdfs/store/user/psiddire

source jobid.sh

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, eet/final/Ntuple, EETauTree]"

#ls *pyx | sed "s|pyx|so|" | xargs rake 
#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

#rake "meta:getinputs[$jobid, $datasrc, eet/metaInfo, eet/summedWeights]"
rake "meta:getmeta[inputs/$jobid, eet/metaInfo, 13, eet/summedWeights]"


