import ROOT
from ROOT import TTree, gROOT, AddressOf, gDirectory
from math import pi
from copy import deepcopy
from weakref import proxy as wrProxy

#for now only deals with flat trees with arrays
#branched trees and objects are for the future
class tree_manager:
    def __init__(self):
        self.myTrees = {}
        self.importedTrees = {}
        self.myStructs = {}
        self.myDicts = {}

    def __getitem__(self,idx):
        if idx in self.myTrees:
            return self.myTrees[idx]
        elif idx in self.importedTrees:
            return self.importedTrees[idx]

    def keys(self):
        return self.myTrees.keys() + self.importedTrees.keys()

    def imported_keys(self):
        return self.importedTrees.keys()
    
    def created_keys(self):
        return self.myTrees.keys()

    def getStruct(self,name):
        return self.myStructs[name]
    
    #attach to a tree and scan it for variables that we want to use
    #if no specifics are given we take the whole tree
    def importTree(self, name, tree, specific = None):
        "Does not takes ownership of the passed tree."
        if( name in self.importedTrees.keys() ):
            print 'Replacing Tree: %s!'%(name)

        #first things first, reset this tree to it's initial state
        #this gives us a nice way to build up the tree's struct
        tree.ResetBranchAddresses()
        
        #build the struct
        if name not in self.importedTrees.keys():
            stct =  self._makeStruct(name,specific,tree)
            if len(stct) > 0:
                gROOT.ProcessLine('.L %s_vars.C'%(name))
            else:
                gROOT.ProcessLine(stct)
        else:
            blah = self.myStructs[name]
            self.myStructs[name] = None
            
        print 'binding!'
        self.myStructs[name] = getattr(ROOT,"%s_vars"%(name))()
        print self.myStructs[name]
        self.importedTrees[name] = wrProxy(tree)
        print self.importedTrees[name]
        self.importedTrees[name].SetName(name)
        print 'Set name to %s'%name
        #self.importedTrees[name].SetCacheSize(long(1e6))
        self._bindBranches(name,specific,
                           self.importedTrees[name])
        print 'called _bindBranches'
        
        

    #this takes an existing imported tree, clones it and allows for filling
    #selected entries
    def cloneTree(self,name,name_clone,specific=None):
        if name_clone in self.myTrees.keys():
            print 'Tree: %s already cloned'%(name_clone)
            return
        if name == name_clone:
            raise Exception('Cloning imported tree '
                            '%s to owned tree %s'%(name,
                                                   name_clone))
        print 'cloning tree %s to %s'%(name,name_clone)
        self.myTrees[name_clone] = self.importedTrees[name].CloneTree(0)
        self.myTrees[name_clone].SetName(name_clone)
        self.myTrees[name_clone].SetCacheSize()
        self._bindBranches(name,specific,self.myTrees[name_clone])
    
    #this creates a tree if it does not exist in the dictionary
    #and then fills it with the entire/specified contents of the
    #event passed in
    def fillTree(self, name, event, specific = None):        
         #determine if we need all event info or only part
        keys = event.keys()
        if specific is not None:
            keys = specific
        #if we haven't made the tree, create it and set it up
        if name not in self.myTrees.keys():
            print 'creating tree %s'%name
            self.myTrees[name] = TTree(name,name)
            gDirectory.Add(self.myTrees[name])
            self.myTrees[name] = gDirectory.Get(name)
            #create the struct we bind to our branches
            stct = self._makeStruct(name,keys,event)            
            if len(stct) > 0:
                gROOT.ProcessLine('.L %s_vars.C'%(name))
            else:
                gROOT.ProcessLine(stct)
            gROOT.ProcessLine('%s_vars %s_vars_holder;'%(name,name))
            self.myStructs[name] = getattr(ROOT,"%s_vars"%(name))()
            #bind branches to the members of the struct we've created
            self._bindBranches(name,keys,event)
            self.myTrees[name].SetCacheSize()
        #we are now done setting up the tree (if needed) -> set values and fill        
        if isinstance(event,dict):
            for key in keys:
                if hasattr(self.myStructs[name],key):
                    setattr(self.myStructs[name],key,event[key])
                else:
                    self.myDicts[name][key] = event[key]
                    self.myTrees[name].SetBranchAddress(key,
                                                        self.myDicts[name][key])
                    
        self.myTrees[name].Fill()

    #only write the trees that we created
    def write(self):
        for key in self.myTrees.keys():
            self.myTrees[key].Write()
    
    def _makeStruct(self,name,items,datastore):        
        stct = "struct %s_vars{ "%(name)
        #if we're making a tree from a python dict,
        #construct the corresponding struct
        if isinstance(datastore,dict):
            if items is None:
                items = datastore.keys()
            self.myDicts[name]= {}
            for item in items:                
                if ( isinstance(datastore[item],int) or
                     isinstance(datastore[item],bool) ):
                    stct += "Int_t %s; "%(item)
                elif isinstance(datastore[item],float):
                    stct += "Float_t %s; "%(item)
                elif isinstance(datastore[item],long):
                    stct += "Long_t %s; "%(item)
                elif isinstance(datastore[item],ROOT.TObject):
                    self.myDicts[name][item] = datastore[item]
                else:
                    raise Exception("Type %s not supported"%type(datastore[item]))
        #if we're making a struct for an existing tree use the Tree's info
        elif isinstance(datastore,TTree):
            leaves = datastore.GetListOfLeaves()
            size = leaves.GetEntries()
            for i in range(size):
                leafName = leaves.At(i).GetName()
                if leafName[-1] == '_':
                    leafName = leafName[0:-1]                
                if ( items is None or
                     leafName in items ):
                    if leaves.At(i).GetNdata() > 1:
                        stct += "%s %s[%i]; "%(leaves.At(i).GetTypeName(),
                                               leafName,
                                               leaves.At(i).GetNdata())
                    else:
                        stct += "%s %s; "%(leaves.At(i).GetTypeName(),
                                           leafName)
                else:
                    datastore.SetBranchStatus(leafName,False)
        else:
            print "Data store type %s is not supported!"%(str(type(datastore)))
            exit(1)
        stct += "};"        
        if len(stct) > 0:
            f = open('%s_vars.C'%name,'w')
            f.write(stct)
            f.close()
        return stct

    def _bindBranches(self,name,items,datastore):        
        struct = self.myStructs[name]
        if isinstance(datastore,dict):
            tree = self.myTrees[name]
            #print ROOT.selected_z_vars_holder.ell1LVec
            for item in items:                
                #print name, item, getattr(struct,item)
                if ( isinstance(datastore[item],int) or
                     isinstance(datastore[item],bool) ):
                    tree.Branch(item,
                                AddressOf(struct,item),
                               '%s/I'%item)
                elif isinstance(datastore[item],float):
                    tree.Branch(item,
                                AddressOf(struct,item),
                                '%s/F'%item)
                elif isinstance(datastore[item],long):
                    tree.Branch(item,
                                AddressOf(struct,item),
                                '%s/L'%item)
                elif isinstance(datastore[item],ROOT.TObject):
                    tree.Branch(item,
                                datastore[item].Class().GetName(),
                                self.myDicts[name][item])
                else:
                    raise Exception("Type %s not supported"%type(datastore[item]))
        elif isinstance(datastore,TTree):
            
            tree = self.importedTrees[name]
            leaves = tree.GetListOfLeaves()
            size = leaves.GetEntries()
            for i in range(size):                
                leafName = leaves.At(i).GetName()
                #sanitize leafnames... weirdness
                if leafName[-1] == '_':
                    leafName = leafName[0:-1]               
                if ( items is None or
                     leafName in items ):
                    tree.SetBranchAddress(leafName,
                                          AddressOf(struct,leafName))
                    
        else:
            print "Data store type %s is not supported!"%(str(type(datastore)))
            exit(1) 
