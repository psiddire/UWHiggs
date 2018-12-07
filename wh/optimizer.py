'small interface module to deal with optimizization'

import os
import itertools

RUN_OPTIMIZATION = ('RUN_OPTIMIZATION' in os.environ) and eval(os.environ['RUN_OPTIMIZATION'])

lep_id = [
    'eid12Tight_idiso02', 
    'eid12Tight_h2taucuts', 
    'eid12Tight_h2taucuts020', 
    'eid12Loose_idiso02', 
    'eid12Loose_h2taucuts', 
    'eid12Loose_h2taucuts020', 
    'eid12Medium_idiso02', 
    'eid12Medium_h2taucuts', 
    'eid12Medium_h2taucuts020'
    ] \
    if RUN_OPTIMIZATION else \
    [
    'eid12Medium_idiso02', 
    'eid12Loose_idiso02', 
    'eid12Tight_idiso02', 
    'eid12Loose_h2taucuts', 
    'eid12Loose_h2taucuts020', 
    'eid12Tight_h2taucuts',
    'eid12Medium_h2taucuts020',
    'eid12Medium_h2taucuts'
    ]

LT_cut = [
    0,
    80,
    110,
    140,
    170,
    200,
    3000
    ]

tauIDs = [
    'tMediumIso3Hits',
    None
    ]

tauPTs = [
    0,
    30,
    40,
    60
    ]

charge_fakes = [
    80,
    ]

grid_search = {}
counter_1, counter_2, counter_3, counter_4 = 0, 0, 0, 0
if RUN_OPTIMIZATION:
    for lead_id, sublead_id, lt_thr, tauID, tauPT, charge_fakes in \
        itertools.product(lep_id, lep_id, LT_cut, tauIDs, tauPTs, charge_fakes):
        cut_name = '%s:%s:%s:%s:%s:%s' % (lead_id, sublead_id, lt_thr, tauID, tauPT, charge_fakes)
        counter_1 += 1
        if (lead_id.startswith('eid13Loose') or sublead_id.startswith('eid13Loose')) and \
            not (lead_id.startswith('eid13Loose') and sublead_id.startswith('eid13Loose')):
            continue
        counter_2 += 1 
        if tauPT > 0 and lt_thr > 0:
            continue
        counter_3 += 1
        ## if lt_thr and not tauID:
        ##     continue
        ## counter_4 += 1
        grid_search[cut_name] = {
            'leading_iso' : lead_id,
            'subleading_iso' : sublead_id,
            'LT'   : lt_thr,
            'tauID': tauID,
            'tauPT': tauPT,
            'charge_fakes' : charge_fakes,
        }
else:
    grid_search['MMT'] = {
        'leading_iso'    : 'eid12Loose_h2taucuts',
        'subleading_iso' : 'eid12Loose_h2taucuts020',
        'LT'             : 50,
        'tauID'          : None,
        'tauPT'          : 0,
        'charge_fakes'   : 80,
    }
    grid_search['EMT'] = {
        'leading_iso'    : 'eid12Medium_h2taucuts',
        'subleading_iso' : 'eid12Medium_h2taucuts',
        'LT'             : 50,
        'tauID'          : None,
        'tauPT'          : 0,
        'charge_fakes'   : 80,
    }
    grid_search['EET'] = {
        'leading_iso'    : 'eid12Tight_h2taucuts',
        'subleading_iso' : 'eid12Medium_h2taucuts020',
        'LT'             : 50, 
        'tauID'          : None,
        'tauPT'          : 0,
        'charge_fakes'   : 100,
    }


if __name__ == "__main__":
    print '\n'.join(grid_search.keys())
else:
    print "Running optimization: %s" % RUN_OPTIMIZATION
