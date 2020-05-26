#!/bin/bash

# Get the data
export datasrc=/hdfs/store/user/caillol
export MEGAPATH=/hdfs/store/user/caillol

#export jobidem='Data2018_Dec_em'
export jobidem='smhem2018_5mar_merged'
#export jobidem='Embed2018em'
export jobid=$jobidem

export afile=`find $datasrc/$jobid | grep root | head -n 1`

## Build the cython wrappers
rake "make_wrapper[$afile, emu_tree, EMTree]"

ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake

rake "meta:getinputs[$jobid, $datasrc, em/metaInfo, nevents]"
#rake "meta:getmeta[inputs/$jobid, em/metaInfo, 13, em/summedWeights]"
