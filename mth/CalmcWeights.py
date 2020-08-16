import os
import glob
import  json
datalumi = 41557.0
files = []
files.extend(glob.glob('inputs/MC2017JEC/*.lumicalc.sum')) 

weights = {"ST_t-channel_top": 1, "ST_t-channel_antitop": 1, "ST_tW_antitop": 1, "ST_tW_top": 1, "Wplus": 1, "Wminus": 1, "ZHToTauTau": 1, "EWKZ2Jets_ZToNuNu": 1, "EWKZ2Jets_ZToLL": 1, "EWKWPlus": 1, "EWKWMinus": 1, "ZZ_": 1, "WZ_": 1, "WW_": 1, "VBF_LFV": 1, "GluGlu_LFV": 1, "WGToLNuG": 1, "GluGluHToTauTau": 1, "GluGluHToWW": 1, "VBFHToWW": 1, "VBFHToTauTau": 1, "TTTo2L2Nu": 1, "TTToHadronic": 1, "TTToSemiLeptonic": 1}

for f in files:
  foundsample = False
  for w in weights:
    if w in f:
      lumifile = open(f, "r")
      weights[w] = datalumi/float(lumifile.readline())
      continue

print weights
