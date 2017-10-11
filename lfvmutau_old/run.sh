#!/bin/bash

set -o nounset
set -o errexit

#export jobid=SubmitMuTauSingleMU
#export jobid=MuTauSingleMUV6
#export jobid=MuTauSingleMuJetReReco
#export jobid=MuTauSingleMuJetReReco
export jobid=MuTauSingleMuJetReRecoSkim
export PU=true
rake mttight
export PU=false
rake pu1mttight
export jobid=MuTauSingleMuJetReReco
export jobidPU=MuTauSingleMuJetReReco

rake analyzeMuTauData
rake analyzeMuTauMC

