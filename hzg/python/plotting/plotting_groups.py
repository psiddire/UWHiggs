from UWHiggs.hzg.datacard.metadata_association import metadata_association


# Using the input metadata, create associated plotting groups.
# The higgs signal for a given production mode for each given
# mass point will be inserted.
# a plot group is 'group':{'filenames':[files], isData = True/False}
def make_plot_groups(mda,
                     higgs_masses = [120,125,130,135,140,145,150],
                     higgs_prod = 'ggH'):
    assc = mda.getAssociation() #get our metadata
    plot_groups = {}
    for (sample, chanlist) in assc.iteritems():
        plot_groups[sample] = {}
        for (channel, proclist) in chanlist.iteritems():
            plot_groups[sample][channel] = {}            
            for (process,subproclist) in proclist.iteritems():
                if 'HToZG' in process:
                    if higgs_prod in process:
                        for subproc in subproclist:
                            for mass in higgs_masses:
                                if str(mass) in subproc:
                                    plot_groups[sample][channel][subproc]={}
                                    dsc = plot_groups[sample][channel][subproc]
                                    dsc['filenames'] = \
                                          [subproclist[subproc]['input_file']]
                                    dsc['scale'] = 100.0 #scale higgs by 100
                                    dsc['n_events'] = float(
                                        subproclist[subproc]['num_mc_events']
                                        )
                                    
                else:
                    if 'data' in process:
                        if 'data' not in plot_groups[sample][channel]:
                            plot_groups[sample][channel]['data'] = {}
                            plot_groups[sample][channel]['data']\
                                                   ['filenames'] = []
                            plot_groups[sample][channel]['data']\
                                                       ['scale'] = 1.0
                            
                        data_group = plot_groups[sample][channel]['data']
                        for subp in subproclist:
                            data_group['filenames'].append(
                                subproclist[subp]['input_file']
                                )
                    else: #an MC channel
                        for subproc in subproclist:
                            plot_groups[sample][channel][subproc]={}
                            dsc = plot_groups[sample][channel][subproc]
                            dsc['filenames'] = \
                                          [subproclist[subproc]['input_file']]
                            dsc['scale'] = 1.0
                            dsc['n_events'] = float(
                                subproclist[subproc]['num_mc_events']
                                )
    return plot_groups
    
    
    
