from UWHiggs.hzg.hzg_metainfo import analysis_list
from UWHiggs.hzg.datacard.directory_prep import directory_prep
from copy import deepcopy


#eats a directory prep object and associates
#metadata to each file in a processing group

class metadata_association:
    def __init__(self,dirprep):
        self._metadata   = analysis_list
        self._procgroups = deepcopy(dirprep.procgroups())
        self._association = {}

        self.__associate()

    def __associate(self):
        for sample in self._metadata:
            subsamples = self._metadata[sample]
            assoc_sample = None
            
            if '8' in sample:
                self._association['8TeV'] = {}
                assoc_sample = self._association['8TeV']
            else:
                self._association['7TeV'] = {}
                assoc_sample = self._association['7TeV']
            
            for subsample in subsamples:
                for channel in self._procgroups:
                    
                    if channel not in assoc_sample:
                        assoc_sample[channel] = {}
                    assoc_channel =  assoc_sample[channel]                    

                    proc_group = '%s-%s'%(subsample,sample)
                    if (proc_group in self._procgroups[channel]
                        and subsample not in assoc_channel):
                        assoc_channel[subsample] = {}
                        assoc_subsample = assoc_channel[subsample]

                        for dataset in subsamples[subsample]:
                            assoc_subsample[dataset] = {}
                            assoc_subsample[dataset]['input_file']=''
                            for file in self._procgroups[channel][proc_group]:
                                dsetpath = subsamples[subsample][dataset]\
                                           ['datasetpath'][1:].replace('/','.')
                                if dsetpath in file:
                                    assoc_subsample[dataset]['input_file'] =\
                                                                           file
                                if 'data' not in subsample:
                                    assoc_subsample[dataset]['x_sec'] =\
                                        subsamples[subsample][dataset]['x_sec']
                                    assoc_subsample[dataset]['isHiggs'] =\
                                                         ('HToZG' in subsample)
                                if 'HToZG' in subsample:
                                    assoc_subsample[dataset]['mass'] =\
                                                float(dataset.split('-')[-1])
    
    def getAssociation(self):
        return self._association
        
