import ROOT
import array, sys


def plotVar(v):
   h = ROOT.TH1F("h", "h", 100, 0, 0.5)
   for i in v:
      h.Fill(i)
   h.Draw()
   print h.Integral(60, 100)
   print h.Integral()
   raw_input()


def fcn(npar, gin, f, par, iflag):
   global ncount, target
   f[0] = abs(target - func(par))
   ncount += 1


def func(par):
   global sigVar, bkgVar, sigWeights, bkgWeights, direction
   varSigCut = 0
   for i, val in enumerate(sigVar):
      if (direction):
         if (val < par[0]):
            varSigCut += sigWeights[i]
      else:
         if (val > par[0]):
            varSigCut += sigWeights[i]
   varBkgCut = 0
   for i, val in enumerate(bkgVar):
      if (val < par[0] and direction):
         varBkgCut += bkgWeights[i]
      if (val > par[0] and not direction):
         varBkgCut += bkgWeights[i]
   if (varBkgCut == 0):
      value = 1000000.
   else:
      value = varSigCut/varBkgCut
   return value


def minimization(conditions):
    global ncount
    ncount = 0

    gMinuit = ROOT.TMinuit(1)
    gMinuit.SetFCN(fcn)

    arglist = array.array('d', 10*[0.])
    ierflg = ROOT.Long(1982)

    arglist[0] = 1.
    gMinuit.mnexcm("SET ERR", arglist, 1, ierflg)

    # Set starting values and step sizes for parameters
    vstart = array.array( 'd', (conditions[0],))
    step   = array.array( 'd', (conditions[1],))
    gMinuit.mnparm( 0, "a1", vstart[0], step[0], conditions[2], conditions[3], ierflg)
    
    # Now ready for minimization step
    arglist[0] = 1000
    arglist[1] = .1
    gMinuit.mnexcm("MIGRAD", arglist, 2, ierflg)
    
    val = ROOT.Double()
    err = ROOT.Double()
    gMinuit.GetParameter(0, val, err)

    return val


def integral(var, weights, cut, lt=True):
   num = 0
   for i, val in enumerate(var):
      if (val < cut and lt):
         num += weights[i]
      if (val > cut and not lt):
         num += weights[i]
   return num


def efficiency(integral2, var, weights, cut, lt=True):
   ratio = integral(var, weights, cut, lt)/integral2
   return ratio

f1 = ROOT.TFile("Input/Opt.root")
t1 = f1.Get("opttree")

sigTuple = []
bkgTuple = []
direction = False

for z in xrange(t1.GetEntries()):
   t1.GetEntry(z)
   if (t1.e_m_Mass > 100.):
      # ePt, mPt, type1_pfMetEt, weight
      if (t1.itype < 0):
         sigTuple.append([t1.ePt, t1.mPt, t1.type1_pfMetEt, t1.weight])
      else:
         bkgTuple.append([t1.ePt, t1.mPt, t1.type1_pfMetEt, t1.weight])

# SET INITIAL CONDITIONS
sigVar     = array.array('f', [y[0] for y in sigTuple])
sigWeights = array.array('f', [y[-1] for y in sigTuple])
bkgVar     = array.array('f', [y[0] for y in bkgTuple])
bkgWeights = array.array('f', [y[-1] for y in bkgTuple])
sob = func([-1])
sigTupleLen = integral(sigVar, sigWeights, -1., direction)
print sob, sigTupleLen

sob_vs_sig = []
targets = [sob+(50*sob/500.)*float(y) for y in xrange(500)]
# ePt, mPt, type1_pfMetEt
conditions = [[30, 0.01, 24, 100, False], [30, 0.01, 24, 100, False], [50, 0.01, 10, 100, True]]

previousEff = 1.0
for target in targets:
   results = []
   for v in xrange(len(conditions)):
      ncount = 0
      direction = conditions[v][-1]
      sigVar     = array.array('f', [y[v] for y in sigTuple])
      sigWeights = array.array('f', [y[-1] for y in sigTuple])
      bkgVar     = array.array('f', [y[v] for y in bkgTuple])
      bkgWeights = array.array('f', [y[-1] for y in bkgTuple])
      cut = minimization(conditions[v])
      results.append((cut, efficiency(sigTupleLen, sigVar, sigWeights, cut, direction)))

   maxCut=0.
   maxEff = 1.0
   maxVar = ""
   f = open("migrad_results.txt", "append")
   f.write("+++++++++++++++++++++++++++++\n")
   for i,r in enumerate(results):
      f.write(str(r[0])+" "+str(r[1])+ "\n")
      if ((previousEff-r[1]) < maxEff):
         maxEff = previousEff-r[1]
         maxVar = i
         maxCut = r[0]
         
   previousEff = results[maxVar][1]
   sob_vs_sig.append((previousEff, target))

   f.write("Chosen:%d\n"%maxVar)
   if (conditions[maxVar][-1]):
      conditions[maxVar][0]=maxCut*0.95
      if (maxCut > conditions[maxVar][2]):
         conditions[maxVar][3]=maxCut
   else:
      conditions[maxVar][0]=maxCut*1.05
      if (maxCut < conditions[maxVar][3]):
         conditions[maxVar][2]=maxCut

   strFinaleOld = ""
   strFinale = " "
   effFinale = " Eff:%1.3f SoB:%3.3f" %(previousEff, target)
   for c in conditions:
      if(c[-1]):
         strFinale = strFinale + " %1.3f"%(c[3])
      else:
         strFinale = strFinale + " %1.3f"%(c[2])
   f.write(effFinale)
   f.write("Current Selection: "+strFinale)
   
   if (strFinale != strFinaleOld):
      strFinaleOld = strFinale
   else:
      print "No improvement found."
      break

   # pruning lists 
   newSigTuple   = []
   newSigWeights = []
   for i,n in enumerate(sigTuple):
      if (n[maxVar] < maxCut and conditions[maxVar][-1]):
         newSigTuple.append(n)
         newSigWeights.append(sigWeights[i])
      if (n[maxVar] > maxCut and not conditions[maxVar][-1]):
         newSigTuple.append(n)
         newSigWeights.append(sigWeights[i])
   sigTuple   = newSigTuple
   sigWeights = newSigWeights

   newBkgTuple   = []
   newBkgWeights = []
   for i,n in enumerate(bkgTuple):
      if (n[maxVar] < maxCut and conditions[maxVar][-1]):
         newBkgTuple.append(n)
         newBkgWeights.append(bkgWeights[i])
      if (n[maxVar] > maxCut and not conditions[maxVar][-1]):
         newBkgTuple.append(n)
         newBkgWeights.append(bkgWeights[i])
   bkgTuple   = newBkgTuple
   bkgWeights = newBkgWeights

   f.close()

x = array.array('f', [])
y = array.array('f', [])

for i in sob_vs_sig:
    x.append(i[0])
    y.append(i[1])

g1 = ROOT.TGraph(len(x), x, y)

g1.Draw("AP")
raw_input()
