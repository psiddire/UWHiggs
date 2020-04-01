#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/psiddire
export MEGAPATH=/hdfs/store/user/psiddire

export jobidet='MCLHE'
export jobid=$jobidet

export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
rake "make_wrapper[$afile, et/final/Ntuple, ETauTree]"

ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, et/metaInfo, et/summedWeights]"
rake "meta:getmeta[inputs/$jobid, et/metaInfo, 13, et/summedWeights]"
