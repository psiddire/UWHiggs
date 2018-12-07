

#in inverse picobarns
hzg_lumi = {'electron':{2011:{'A':2252.0,
                              'B':2709.0,
                              'AB':2252.0+2709.0},
                        2012:{'A':0,
                              'B':0,
                              'C':7011.0, #missing one corrupted pattuple
                              'D':7269.0, 
                               'ABCD':0+0+7011.0+7269.0}
                        },
            'muon':{2011:{'A':2289.9,
                          'B':2709.0,
                          'AB':2289.9+2709.0},
                    2012:{'A':0,
                          'B':0,
                          'C':7020.0,
                          'D':7267.0,
                          'ABCD':0+0+7020.0+7267.0}
                    }
            }

hzg_run_indices = {'electron':{2011:{'A':0,
                                     'B':1
                                     },
                               2012:{'A':0,
                                     'B':1,
                                     'C':2, 
                                     'D':3
                                     }
                        },
            'muon':{2011:{'A':0,
                          'B':1
                          },
                    2012:{'A':0,
                          'B':1,
                          'C':2,
                          'D':3
                          }
                    }
            }

hzg_run_probs = {}

for lt in hzg_lumi:
    lepton_info = hzg_lumi[lt]
    hzg_run_probs[lt] = {}
    for year in lepton_info:
        year_info = lepton_info[year]
        hzg_run_probs[lt][year] = {}
        sum = 0.0
        #get totals
        for run in year_info.keys():
            if len(run) == 1:
                sum += year_info[run]
        #make hit table
        for run in year_info.keys():
            if len(run) == 1:
                hzg_run_probs[lt][year][run] = year_info[run]/sum

                
