University of Wisconsin (and friends) CMS Higgs Analyses
========================================================

Contains final plotting/analysis code for UW Higgs analyses.

Installation
------------

Start from a CMSSW 5_3_9 or greater working area.
Clone the code from the remote repository::

   git clone --recursive https://github.com/uwcms/UWHiggs.git

The --recursive option is necessary for the dependencies, which are stored as
git submodules, to be downloaded correctly.  Now check out/install all the
extra dependencies::

   cmsenv
   kinit YOUR_CERN_USERNAME@CERN.CH 
   cd UWHiggs
   ./install.sh
   scram b -j 8


Quick Start
-----------

To run the WH analysis::
   
   source FinalStateAnalysis/environment.sh
   cd UWHiggs/wh
   ./setup.sh # run once
   ./run.sh  # run anytime analyzers are changed
   ./plot.sh # plot results

