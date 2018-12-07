import ROOT
from ROOT import TH1D,TH2D,TH3D,TTreeFormula
from copy import deepcopy
import random,string

def id_gen(size=5,chars=string.ascii_uppercase+string.digits):
    return ''.join(random.choice(chars) for x in range(size))

#tree2hists plot with a deepcopy mechanism (original is from Mike Anderson)
#can't really inherit since base class isn't easy to make a deepcopy for
class Plot:
    def __init__(self, treeVariables=None, histogram=None,
                 cuts="", externalFunction = None, normByBinWidth=False,
                 storeErrors=True):
        self.treeVariables = deepcopy(treeVariables)
        self.histogram = histogram        
        self.cuts = cuts
        self.normByBinWidth = normByBinWidth
        self.externalFunction = externalFunction
        if not not histogram:
            self.name = self.histogram.GetName()
            if storeErrors: self.histogram.Sumw2()

    def __add__(self,other):
        out = deepcopy(other)
        if self.treeVariables == other.treeVariables:
            out.Add(other.histogram)
        else:
            raise Exception('cannot add histograms with different variables')
        return out

    def __iadd__(self,other):
        if self.treeVariables == other.treeVariables:
            self.histogram.Add(other.histogram)
        else:
            raise Exception('cannot add histograms with different variables')
        return self

    def __mul__(self,other):
        out = deepcopy(other)
        if self.treeVariables == other.treeVariables:
            out.Multiply(other.histogram)
        else:
            raise Exception('cannot multiply histograms'
                            ' with different variables')
        return out

    def __imul__(self,other):
        if self.treeVariables == other.treeVariables:
            self.histogram.Multiply(other.histogram)
        else:
            raise Exception('cannot multiply histograms'
                            ' with different variables')
        return self

    def reset(self,opt='ICES'):
        self.histogram.Reset(opt)

    def write(self):
        realName = self.histogram.GetName()
        self.histogram.SetName(self.name)
        if self.normByBinWidth:
            self.histogram.Scale(1.0,'width')
        self.histogram.Write()
        self.histogram.SetName(realName)
    
    def __deepcopy__(self,memo):
        out = Plot()
        out.treeVariables = deepcopy(self.treeVariables,memo)        
        out.histogram = self.histogram.Clone('%s_%s'%(self.name,id_gen()))
        out.name = deepcopy(self.name,memo)
        out.cuts = deepcopy(self.cuts,memo)
        out.externalFunction = deepcopy(self.externalFunction)
        out.normByBinWidth = deepcopy(self.normByBinWidth,memo)
        return out

class PlotList(list):
    def write(self):
        for plot in self:
            plot.write()
    
    def reset(self,opt='ICES'):
        for plot in self:
            plot.reset(opt)

#base class for reweighing functors
class Reweigher:
    def __init__(self,tree):
        pass
    
    def __call__(self,event):
        raise Exception('reweigher base class does nothing')   

#class for plotting things from trees
class TreePlotter:
    def __init__(self,tree,weights=[],cuts=[],reweigher=Reweigher):
        self._tree = tree        
        self._weights = weights
        self._cuts = cuts
        self._expr = self._buildexpr(self._weights,
                                     self._cuts)
        self._reweigher = reweigher(tree)
        self._sumw2 = True
                
    def _buildexpr(self,weights,cuts):
        cutstr = ''
        weightstr = ''
        if isinstance(cuts,str):
            cutstr = '(%s)'%cuts
        else:
            for cut in cuts:
                if '||' in cut:
                    cut = '(%s)'%cut
            cutstr = '(%s)'%('&&'.join(cuts))
        if cutstr == '()':
            cutstr = '(1)'
        if isinstance(weights,str):
            weightstr = '(%s)'%weights
        else:
            for weight in weights:
                if '+' in weights:
                    weight = '(%s)'%weight        
            weightstr = '(%s)'%('*'.join(weights))
        if weightstr == '()':
            weightstr = '(1)'

        #print weightstr, cutstr
        return '%s*%s'%(weightstr,cutstr)

    def setWeights(self,weights):
        self._weights = weights
        self._expr = self._buildexpr(self._weights,
                                     self._cuts)

    def setCuts(self,cuts):
        self._cuts = cuts
        self._expr = self._buildexpr(self._weights,
                                     self._cuts)

    def setReweigher(self,normalization):
        self._normalization = normalization

    def setSumw2(self,doSumw2):
        self._sumw2 = doSumw2

    #hists can be a Plot object or a list of Plot objects
    def __call__(self,plots):
        plist = plots        
        if isinstance(plist,Plot):
            plist = [plots]
        plot_formulae = self._genPlotFormulae(plots)
        plot_cuts = self._genPlotCuts(plots)
        
        try:            
            for event in self._tree:                
                weight = self._reweigher(event)
                for wname in self._weights:
                    weight *= getattr(event,wname)                    
                for i,plot in enumerate(plist):
                    vars = []
                    if plot.externalFunction is None:
                        vars = self._eval_formulae(plot_formulae[i])
                    else:
                        vars.append(plot.externalFunction(event))
                    local_cut = 1.0
                    if plot.cuts != "":
                        local_cut = self._eval_formulae(plot_cuts[i])[0]
                    vars.append(weight*local_cut)                    
                    plot.histogram.Fill(*tuple(vars))
        except Exception as e:            
            plots_extfunc = []
            for plot in plist:
                if plot.externalFunction is None:
                    varlist = deepcopy(plot.treeVariables)
                    varlist.reverse()
                    local_expr = self._expr
                    if plot.cuts != "":
                        local_expr = self._buildexpr(self._weights,
                                                     self._cuts+[plot.cuts])
                    self._tree.Draw('%s >> %s'%(':'.join(varlist),
                                                plot.histogram.GetName()),
                                    local_expr,'goff')
                        
                else:
                    plots_extfunc.append(plot)

            if len(plots_extfunc):
                for event in self._tree:
                    weight = 1.0
                    for wname in self._weights:
                        weight *= getattr(event,wname)
                    for plot in plots_extfunc:
                        vars = [plot.externalFunction(event)]
                        local_cut = 1.0                        
                        if plot.cuts != "":                           
                            local_cut = self._eval_formulae(plot_cuts[i])[0]
                        vars.append(weight*local_cut)
                        plot.histogram.Fill(*tuple(vars))

    def _genPlotCuts(self,plots):
        cuts = []
        for plot in plots:
            cutstr = '1.0'
            if plot.cuts != "":                
                cutstr = plot.cuts            
            cuts.append([TTreeFormula(id_gen(10),
                                      cutstr,
                                      self._tree)])                
        return cuts
    
    def _genPlotFormulae(self,plots):
        formulae = []
        for plot in plots:
            formulae.append([])
            for var in plot.treeVariables:
                if plot.externalFunction is None:
                    formulae[-1].append(TTreeFormula(id_gen(10),
                                                     var,
                                                     self._tree))
        return formulae
    
    def _eval_formulae(self,formulae):
        outvars = []
        for formula in formulae:            
            formula.UpdateFormulaLeaves()
            out = formula.EvalInstance()           
            outvars.append(out)
        return outvars
    

#this needs to be turned into a class at some point
#plot_group_dict looks like a = {'reweigher':myweights,'files':[list,of,files]}
#tree_dict looks like a ={'treename':{'weights':[..],'cuts':[..],'plots':[..]}}
def plot_group(name,plots,tree_dict,plot_group_dict):
    pass
        
