from OrderedDict import OrderedDict

# cutflow is a list of cuts organized like
# [['name of cut',[cut_function,arg_names,counter]],...]
# event is an entry in a ttree
class CutflowDecision:
    def __init__(self,cutflow):
        if isinstance(cutflow,CutflowDecision):
            self._cutflow = OrderedDict(cutflow._cutflow)
        else:
            self._cutflow = OrderedDict(cutflow)
        #just need functions and flags for this
        for key in self._cutflow.keys():
            self._cutflow[key] =  self._cutflow[key][:2] + [False]
        #print self._cutflow

    def __getitem__(self,idx):
        return self._cutflow[idx][-1]
    
    def __call__(self,event,index=-1):
        #print 'object index:',index
        for item in self._cutflow.itervalues():
            args = []            
            for arg in item[1]:
                argv = getattr(event,arg)
                if index > -1 and not isinstance(argv,(int,float,bool,long)):
                    args.append(argv[index])
                else:
                    args.append(argv)
            #print index, item[1], args
            #print 'calling %s with values:'%(item[0]),args
            item[-1] = bool(item[0](*tuple(args)))
                
    def __nonzero__(self):
        for item in self._cutflow.itervalues():
            if not item[-1]:
                return False
        return True

    #take the modulus of the current value of the cut
    def __mod__(self,cuts):
        for key,item in self._cutflow.iteritems():
            if key not in cuts and not item[-1]:
                return False
        return True

    #cuts is a list of names or an ordereddict
    def __sub__(self,cuts):
        cutflow = []
        if isinstance(cuts,(list,OrderedDict)):            
            for key in self._cutflow.keys():
                if key not in cuts:
                    cutflow.append([key,[self._cutflow[key]]])
        return CutflowDecision(cutflow)

    #cuts is a list as mentioned in the class comment or an ordered dict
    def __add__(self,cuts):
        cutflow = OrderDict(self._cutflow)
        if isinstance(cuts,(list,OrderedDict)):            
            cutflow += OrderedDict(cuts)
        return CutflowDecision(cutflow)

# this represents a composite cutflow applied to a TTree
class CompositeCutflow:
    def __init__(self,other=None):
        self._cutflows = {}
        self._cuts = {}
        if isinstance(other,CompositeCutflow):
            self._cuts = dict(other._cuts)
            for key in other.flowkeys():
                self.addCutflow(other.getCutflow(key))
    
    def flowkeys():
        return self._cutflows.keys()

    def cutkeys():
        return self._cuts.keys()

    def keys():
        return self._cutflows.keys() + self._cuts.keys()

    def addCutflow(self,name,cutflow):
        self._cutflows[name] = CutflowDecision(cutflow._cutflow)

    def getCutflow(self,name):
        return self._cutflows[name]

    def addCut(self,name,cut):
        self._cuts[name] = [cut,False]

    def getCut(self,name):
        return self._cuts[name]

    def __call__(self,event,**kwargs):
        for key,item in self._cutflows.iteritems():
            if key not in kwargs:
                raise Exception('Index for cutflow: \"%s\" not found!'%key)
            item(event,kwargs[key])                
        for item in self._cuts.itervalues():
            item[1] = item[0](event,kwargs)

    def __nonzero__(self):
        for key,item in self._cutflows.iteritems():
            if not item:
                return False
        for key,item in self._cuts.iteritems():
            if not item[1]:
                return False
        return True
        

def apply_selection(tree,sel,record=True):   
    for key in sel.keys():        
        if not sel[key][0](tree):
            return False
        else:
            sel[key][-1] += 1*record
    return True

def apply_selection_except(tree,sel,torm,record=True):
    reduced = sel.items()    
    reduced.remove((torm,sel[torm]))
    reduced = OrderedDict(reduced)
    return apply_selection(tree,reduced,record)

def n_minus_one(tree,sel):
    result = OrderedDict(sel)
    for key in sel.keys():
        result[key] = apply_selection_except(tree,sel,key,False) # don't save n-1 info in cut table
    #print 'n-1 result:', result
    return result

def print_table(sel):
    print 'Sequential Cut Table:'
    for key in sel.keys():
        print '%s \t:\t %d'%(key,sel[key][-1])
