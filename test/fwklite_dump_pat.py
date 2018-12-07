#! /bin/env python

import ROOT
import pprint
from DataFormats.FWLite import Events, Handle
ROOT.gROOT.SetBatch()


events = Events('/hdfs/store/user/tapas/DoubleMu/Run2012D-16Jan2013-v2/AOD/2013-04-01-8TeV-53X-PatTuple_Master/patTuple_cfg-00A4899E-666B-E211-A2AC-E0CB4E29C50D.root')

evt = events.__iter__().next()
evt.getByLabel(label, handle)

handle = Handle('std::vector<pat::Tau>')
label  = "patTriggerEvent"
obj = handle.product()
algo_names = [i.name() for i in obj.paths()]
print filter(lambda x: 'Mu8_Ele17' in x, algo_names)


## handle = Handle('pat::TriggerEvent')
## label  = "patTriggerEvent"
## obj = handle.product()
## algo_names = [i.name() for i in obj.paths()]
## print filter(lambda x: 'Mu8_Ele17' in x, algo_names)
        
