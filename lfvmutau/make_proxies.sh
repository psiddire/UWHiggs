#!/bin/bash

# Generate the cython proxies used in the analyses

source jobid.sh

export jobid=$jobidmm

#export datasrc=/hdfs/store/user/ndev/$jobid
#export datasrc=/hdfs/store/user/ndev/LFV_Mar15_mc/
export datasrc=/hdfs/store/user/taroni/$jobid

if [ -z $1 ]; then
    export afile=`find $datasrc  | grep root | head -n 1`
else
    export afile=$1
fi

echo "Building cython wrappers from file: $afile"
#rake "make_wrapper[$afile, mt/final/Ntuple, MuTauTree]"
rake "make_wrapper[$afile, mm/final/Ntuple, MuMuTree]"
ls *pyx | sed "s|pyx|so|" | xargs -n 1 -P 10 rake