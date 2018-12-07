from trees import tree_manager
from math import hypot,fabs,sqrt
from copy import deepcopy

class measurement:
    def __init__(self, name,central=None,
                 stat_err_up=None,stat_err_down=None,
                 syst_dict = {}):
        self._syst_dict = deepcopy(syst_dict)
        for syst in self._syst_dict.itervalues():
            syst.setdefault('correlation',{})
        self._stat_err_up = stat_err_up
        self._stat_err_down = stat_err_down
        self._central = central
        self._name = name

    def setCentralValue(self,centralValue):
        self._central = centralValue
    def centralValue(self):
        return self._central

    def setStatError(self,up,down=None):
        self._stat_err_up = up
        if down is None:
            self._stat_err_down = up
        else:
            self._stat_err_down = down
    def statError(self):
        return (self._stat_err_up,self._stat_err_down)

    def addSystematic(self,name,up,down=None,correlation={}):
        if down is None:
            down = up        
        self._syst_dict[name] = {'correlation':correlation,
                                 'up':up,
                                 'down':down}
    def getSystematic(self,name):
        return (self._syst_dict[name]['up'],
                self._syst_dict[name]['down'])

    def __add__(self,o):
        out = deepcopy(self)        
        if isinstance(o,measurement):
            out._central += o._central
            out._stat_err_up = hypot(out._stat_err_up,o._stat_err_up)
            out._stat_err_down = hypot(out._stat_err_down,o._stat_err_down)
            out._syst_dict.update(o.syst_dict)
        else:
            raise Exception('Cannot add measurement and normal number')
        return out        

    def __sub__(self,o):
        out = deepcopy(self)        
        if isinstance(o,measurement):
            out._central -= o._central
            out._stat_err_up = hypot(out._stat_err_up,o._stat_err_up)
            out._stat_err_down = hypot(out._stat_err_down,o._stat_err_down)
            out._syst_dict.update(o.syst_dict)
        else:
            raise Exception('Cannot subtract measurement and normal number')
        return out    
    
    def __mul__(self,o):
        out = deepcopy(self)        
        if isinstance(o,measurement):
            out._central *= o._central
            out._stat_err_up = hypot(self._stat_err_up*(out._central/
                                                        self._central),
                                     o._stat_err_up*(out._central/
                                                     o._central))
            out._stat_err_down = hypot(self._stat_err_down*(out._central/
                                                            self._central),
                                       o._stat_err_down*(out._central/
                                                         o._central))
            for name,syst in out._syst_dict.iteritems():
                syst['up']   *= out._central/self._central
                syst['down'] *= out._central/self._central
            new_systs = deepcopy(o._syst_dict)
            for name,syst in new_systs:
                syst['up']   *= out._central/o._central
                syst['down'] *= out._central/o._central
            out._syst_dict.update(new_systs)
        else:
            out._central *= o
            out._stat_err_up *= o
            out._stat_err_down *= o
            for syst in out._syst_dict.valueitems():
                syst['up'] *= o
                syst['down'] *= o
        return out

    def __div__(self,o):
        out = deepcopy(self)        
        if isinstance(o,measurement):
            out._central /= o._central
            out._stat_err_up = hypot(self._stat_err_up*(out._central/
                                                        self._central),
                                     o._stat_err_up*(out._central/
                                                     o._central))
            out._stat_err_down = hypot(self._stat_err_down*(out._central/
                                                            self._central),
                                       o._stat_err_down*(out._central/
                                                         o._central))
            for name,syst in out._syst_dict.iteritems():
                syst['up']   *= out._central/self._central
                syst['down'] *= out._central/self._central
            new_systs = deepcopy(o._syst_dict)
            for name,syst in new_systs:
                syst['up']   *= out._central/o._central
                syst['down'] *= out._central/o._central
            out._syst_dict.update(new_systs)
        else:
            out = out * (1/o)
        return out

    def __repr__(self):
        syst_up = 0.0
        syst_down = 0.0
        for syst in self._syst_dict.itervalues():
            syst_up += syst['up']**2
            syst_down += syst['down']**2
        syst_up = sqrt(syst_up)
        syst_down = sqrt(syst_down)
        return '%s: %.3f +/- %.3f/%.3f (stat.) +/- %.3f/%.3f (syst.)' \
               %(self._name,self._central,
                 self._stat_err_up,self._stat_err_down,
                 syst_up,syst_down)

#cross section is a measurement with lumi error and four sub measurements
# N_sig, A*eff, rho_eff, lumi
#lumi error is always in percent and is 100% correlated between channels
class cross_section(measurement):
    def __init__(self,name,
                 N_sig,Aeff,rho_eff,lumi,lumi_err,
                 central=None,
                 stat_err_up=None,stat_err_down=None,
                 syst_dict = {}):

        lumi_meas = measurement('lumi',lumi)
        self._lumi_err = lumi_err        

        self = N_sig/(Aeff*rho_eff*lumi_meas)        

    def setLumi(self,lumi,err):
        self._lumi = lumi
        self._lumi_err = err

    def __repr__(self):
        stat_syst = measurement.__repr__(self)
        lumi_abs = self._lumi_err*self._central
        return stat_syst+' +/- %.3f (lumi.)'%(lumi_abs)
    

#this is the base class, it represents a simple number
class systematic:    
    def __init__(self,name,
                 central,sigma_up,sigma_down=None):
        self._name = name
        self._isPercent = False
        self._central = central
        if sigma_down is None:
            self._sigma_up = sigma_up
            self._sigma_down = sigma_up
        else:
            self._sigma_up = sigma_up
            self._sigma_down = sigma_down

    def setName(self,name):
        self._name = name

    def name(self):
        return self._name

    def setPercent(self,p):
        self._isPercent=p

    def isPercent(self):
        return self._isPercent

    def setCentralValue(self,cv):
        self._central = cv

    def centralValue(self):
        return self._central

    def setSigma(self,s):
        self._sigma_up = s
        self._sigma_down = s
        
    def setSigmaUp(self,s):
        self._sigma_up = s
   
    def setSigmaDown(self,s):
        self._sigma_down = s
    
    def syst_up(self):
        if self._isPercent:
            return self._central*self._sigma_up
        return self._sigma_up

    def syst_down(self):
        if self._isPercent:
            return self._central*self._sigma_down
        return self._sigma_down

    def __add__(self,syst):
        if(self._central != syst.centralValue()):
            raise Exception('Adding systematics that mean different things.')
        tot_up = hypot(self.syst_up(),syst.syst_up())
        tot_down = hypot(self.syst_down(),syst.syst_down())
        newName = '%s + %s'%(self._name,syst.name())
        if(self._name == syst.name()):
            newName = self._name            
        return systematic(newName,
                          self._central,
                          tot_up,
                          tot_down)

#a systematic variation for things like efficiency scale factors
#here central values and errors can be functions that all take the same input
#this class accumulates the average errors and central values over input data
class averaging_systematic(systematic):
    def __init__(self,name,central,up,down=None):
        self._nTot = 0.0
        self._tot_central = 0.0
        self._tot_syst_up = 0.0
        self._tot_syst_down = 0.0
        up_var,down_var,c_var = (0,0,0)        
        if isinstance(central,(int,float,complex,long)):
            c_var = central
            self._c_fun = None
        else:
            self._c_fun = central
        if isinstance(up,(int,float,complex,long)):
            up_var = up
            self._up_fun = None
        else:
            self._up_fun = up
        if down is None:
            down_var = up_var
            self._down_fun = self._up_fun
        elif isinstance(down,(int,float,complex,long)):
            down_var = down
            self._down_fun = None
        else:
            self._down_fun = down            
        systematic.__init__(self,name,c_var,up_var,down_var)

    def centralValue(self):
        return self._tot_central/self._nTot
    
    def _getCentral(self,varlist=None):
        if varlist is None:
            return systematic.centralValue()
        else:
            return self._c_fun(*tuple(varlist))

    def _getUp(self,varlist=None):
        if varlist is None:
            return systematic.syst_up()
        else:
            return self._up_fun(*tuple(varlist))

    def _getDown(self,varlist=None):
        if varlist is None:
            return systematic.syst_down()
        else:
            return self._down_fun(*tuple(varlist))

    def calc_syst(self,varlist=[]):
        self._nTot += 1.0
        self._tot_central   += self._getCentral(varlist)
        self._tot_syst_up   += self._getUp(varlist)
        self._tot_syst_down += self._getDown(varlist)

    def syst_up(self):
        if self._isPercent:
            return self._tot_central*self._tot_syst_up/self._nTot**2
        return (self._tot_syst_up - self._tot_central)/self._nTot

    def syst_down(self):
        if self._isPercent:
            return self._tot_central*self._tot_syst_down/self._nTot**2
        return (self._tot_syst_down - self._tot_central)/self._nTot

#a systematic that accumulates numbers and takes differences
#here central values and errors can be functions that all take the same input
#this class accumulates totals and takes the differences as systematics
class accumulating_systematic(systematic):
    def __init__(self,name,central,up,down=None):        
        self._tot_central = 0.0
        self._tot_syst_up = 0.0
        self._tot_syst_down = 0.0
        up_var,down_var,c_var = (0,0,0)        
        if isinstance(central,(int,float,complex,long)):
            c_var = central
            self._c_fun = None
        else:
            self._c_fun = central
        if isinstance(up,(int,float,complex,long)):
            up_var = up
            self._up_fun = None
        else:
            self._up_fun = up
        if down is None:
            down_var = up_var
            self._down_fun = self._up_fun
        elif isinstance(down,(int,float,complex,long)):
            down_var = down
            self._down_fun = None
        else:
            self._down_fun = down            
        systematic.__init__(self,name,c_var,up_var,down_var)

    def centralValue(self):
        return self._tot_central
    
    def _getCentral(self,varlist=None):
        if varlist is None:
            return systematic.centralValue()
        else:
            return self._c_fun(*tuple(varlist))

    def _getUp(self,varlist=None):
        if varlist is None:
            return systematic.syst_up()
        else:
            return self._up_fun(*tuple(varlist))

    def _getDown(self,varlist=None):
        if varlist is None:
            return systematic.syst_down()
        else:
            return self._down_fun(*tuple(varlist))

    def calc_syst(self,varlist=[]):        
        self._tot_central   += self._getCentral(varlist)
        self._tot_syst_up   += self._getUp(varlist)
        self._tot_syst_down += self._getDown(varlist)

    def syst_up(self):
        if self._isPercent:
            return self._tot_syst_up/self._tot_central - 1.0
        return self._tot_syst_up - self._nTot

    def syst_down(self):
        if self._isPercent:
            return self._tot_syst_down/self._tot_central - 1.0
        return self._nTot - self._tot_syst_down

#a systematic variation for things like JES and PhES
#this class multiplexes an input tree into multiple output trees
#representing the upward and downward fluctuations
class variable_scale_systematic(systematic):
    def __init__(self):
        print 'hi'

#systematic vartions for things like MET cluster-up/down and n-jet at threshold
# as with the scale systematic, it accumulates the error over the fluctuated
# input datasets.
class reconstruction_systematic(systematic):
    def __init__(self):
        print 'hi'
