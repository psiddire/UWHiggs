#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/ndev
export MEGAPATH=/hdfs/store/user/ndev

export jobidet='Data2016et'
#export jobidet='MC2016'
#export jobidet='MC2016Sys'
#export jobidet='Embed2016ElTau'
#export jobidet='Signal2016'
export jobid=$jobidet

#export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
#rake "make_wrapper[$afile, et/final/Ntuple, ETauTree]"

#ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, et/metaInfo, et/summedWeights]"
rake "meta:getmeta[inputs/$jobid, et/metaInfo, 13, et/summedWeights]"
