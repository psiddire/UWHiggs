#!/bin/bash
export OVERRIDE_META_TREE_data_ET='et/metaInfo'

export IGNORE_LUMI_ERRORS=1

source jobid.sh

#./make_proxies.sh

export datasrc=/hdfs/store/user/$USER/  #$(ls -d /scratch/*/data/$jobid | awk -F
export MEGAPATH=/hdfs/store/user/$USER

export jobid=$jobidMC
echo $jobid
#rake "meta:getinputs[$jobid, $datasrc,em/metaInfo, em/summedWeights]"
rake "meta:getmeta[inputs/$jobid, em/metaInfo, 13, em/summedWeights]"



unset OVERRIDE_META_TREE_data_ET
unset IGNORE_LUMI_ERRORS