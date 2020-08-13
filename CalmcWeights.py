import os
import glob
import  json
datalumi = 41557.0
files = []
files.extend(glob.glob('inputs/MCLHE/*.lumicalc.sum')) 
Xcross = {"W": 52940, "W1": 8104.0, "W2": 2793.0, "W3": 992.5, "W4": 544.3, "DY": 5343, "DY1": 877.8, "DY2": 304.4, "DY3": 111.5, "DY4": 44.03}
NNLO = {"W":61526.7, "DY": 6077.22}
DYorWweights = {"DY": 1, "DY1": 1, "DY2": 1, "DY3": 1, "DY4": 1, "W": 1, "W1": 1, "W2": 1, "W3": 1, "W4": 1}
weights = {"ST_t-channel_top": 1, "ST_t-channel_antitop": 1, "Wplus": 1, "Wminus": 1, "ttHToTauTau": 1, "ZHToTauTau": 1, "EWKZ2Jets_ZToNuNu": 1, "EWKZ2Jets_ZToLL": 1, "EWKWPlus": 1, "EWKWMinus": 1, "ZZ_TuneCP5": 1, "WZ_TuneCP5": 1, "WW_TuneCP5": 1, "VBF_LFV": 1, "GluGlu_LFV": 1, "WGToLNuG": 1, "DYJetsToLL_M-10to50": 1, "GluGluHToTauTau": 1, "GluGluHToWW": 1, "VBFHToWW": 1, "VBFHToTauTau": 1, "TTTo2L2Nu": 1, "TTToHadronic": 1, "TTToSemiLeptonic": 1, "ST_tW_antitop": 1, "ST_tW_top": 1, }
Nevents0 = {"DY": 1, "W": 1}
for f in files:
  for x in {"DY", "W"}:
    if ("{}Jets".format(x) in f) and ("DYJetsToLL_M-10to50" not in f):
        Nevents0[x] = json.load(open(f.replace("lumicalc.sum", "meta.json"), "r"))['n_evts']
        mclumi = Nevents0[x]/Xcross[x]
        DYorWweights[x] = datalumi*(NNLO[x]/Xcross[x])/mclumi
        files.remove(f)
        break

for f in files:
  foundsample = False
  for x in {"DY", "W"}:
    for y in {"1", "2", "3", "4"}:
      if x+y+"Jets" in f:
        Nevents = json.load(open(f.replace("lumicalc.sum", "meta.json"), "r"))['n_evts']
        mclumi = Nevents/Xcross[x+y]
        DYorWweights[x+y] = datalumi*(NNLO[x]/Xcross[x])/(Nevents0[x]/Xcross[x]+mclumi)
        files.remove(f)
        foundsample = True
        break
    if foundsample == True:
      break  
  if foundsample == True:
      break  
  for z in weights:
    if z in f:
      lumifile = open(f, "r")
      weights[z] = datalumi/float(lumifile.readline())
      files.remove(f)
      break 
weights.update(DYorWweights)
print weights
