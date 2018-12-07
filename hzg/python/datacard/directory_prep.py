import os
from os import path
import subprocess
from copy import deepcopy

#this class expects to be given the directory which contains
#the root of a directory structure containing all signal samples,
#background samples, and real data samples
#
# ex: /path/to/dirs/<sample dir name>/<channels>/<sample groups>/<samples>.root
#
def get_leaf_dirs(arg,dirname,names):
    namescopy = deepcopy(names)
    for i,name in enumerate(names):        
        if not path.isdir(path.join(dirname,name)):            
            namescopy.remove(name)
                
    if len(namescopy) == 0:        
        arg.append(dirname)

def needs_update(arg,dirname,names):
    last_built = path.getctime('%s.root'%dirname)

    times = []
    for name in names:
        times.append(path.getctime(path.join(dirname,name)))
    
    arg[0] = (last_built < max(times))    
    

class directory_prep:
    def __init__(self, path_to_root, sample_name):
        self._path_to_root = path_to_root
        self._sample_name = sample_name    

    def build_inputs(self):
        root_path = path.join(self._path_to_root,self._sample_name)
        root_path = path.expanduser(root_path)
        
        sample_dirs = []
        path.walk(root_path,get_leaf_dirs,sample_dirs)

        proc_groups = {}

        for dir in sample_dirs:
            dirroot,name = path.split(dir)
            chanroot,procname = path.split(dirroot)
            dontcare,channame = path.split(chanroot)

            if channame not in proc_groups:
                proc_groups[channame] = {}
            
            if procname not in proc_groups[channame]:
                proc_groups[channame][procname] = []

            isMod = [True]

            if(path.exists('%s.root'%dir)):                
                path.walk(dir,needs_update,isMod)
                
            if isMod[0]:
                print 'Creating input file %s.root'%name
                command = 'hadd -v 0 -f %s.root %s/*.root'%(dir,dir)
                subprocess.call(command,shell=True)

            proc_groups[channame][procname].append('%s.root'%dir)

        self._proc_groups = proc_groups

    def procgroups(self):
        return self._proc_groups

            
