#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/taroni
source jobid.sh

export jobid=$jobidem
export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, em/final/Ntuple, EMuTree]"

ls *pyx | sed "s|pyx|so|" | xargs rake 

#rake "meta:getinputs[$jobid, $datasrc,em/metaInfo,em/summedWeights]"
rake "meta:getmeta[inputs/$jobid, em/metaInfo,13,em/summedWeights]"


