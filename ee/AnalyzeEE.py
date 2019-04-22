'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EETree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import operator
import mcCorrections
from RecoilCorrector import RecoilCorrector
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])

fmc = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/htt_scalefactors_2017_v2.root")
wmc = fmc.Get("w")

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)

def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)

def visibleMass(row):
  vobj1 = ROOT.TLorentzVector()
  vobj2 = ROOT.TLorentzVector()
  vobj1.SetPtEtaPhiM(row['e1Pt'], row['e1Eta'], row['e1Phi'], row['e1Mass'])
  vobj2.SetPtEtaPhiM(row['e2Pt'], row['e2Eta'], row['e2Phi'], row['e2Mass'])
  return (vobj1 + vobj2).M()


if bool('DYJetsToLL_M-50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY10')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY4')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'ZZ')
elif bool('EWKWMinus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'Wminus')
elif bool('EWKWPlus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'Wplus')
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'Zll')
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'Znunu')
elif bool('ST_t-channel_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'STtantitop')
elif bool('ST_t-channel_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'STttop')
elif bool('ST_tW_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'STtWantitop')
elif bool('ST_tW_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'STtWtop')
elif bool('TTTo2L2Nu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'TTTo2L2Nu')
elif bool('TTToHadronic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'TTToHadronic')
elif bool('TTToSemiLeptonic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'TTToSemiLeptonic')
else:
  pucorrector = mcCorrections.make_puCorrector('singlee', None, 'DY')

class AnalyzeEE(MegaBase):
  tree = 'ee/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not self.is_data
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.is_EWKWMinus = bool('EWKWMinus' in target)
    self.is_EWKWPlus = bool('EWKWPlus' in target)
    self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
    self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
    self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
    self.is_STtantitop = bool('ST_t-channel_antitop' in target)
    self.is_STttop = bool('ST_t-channel_top' in target)
    self.is_STtWantitop = bool('ST_tW_antitop' in target)
    self.is_STtWtop = bool('ST_tW_top' in target)
    self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
    self.is_TTToHadronic = bool('TTToHadronic' in target)
    self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
    self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_EWK)
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeEE, self).__init__(tree, outfile, **kwargs)
    self.tree = EETree.EETree(tree)
    self.out = outfile
    self.histograms = {}

    self.fakeRate = mcCorrections.fakerate_weight
    self.DYreweight1D = mcCorrections.DYreweight1D
    self.DYreweight = mcCorrections.DYreweight

    self.DYweight = {
      0 : 2.288666996,
      1 : 0.465803642,
      2 : 0.585042564,
      3 : 0.609127575,
      4 : 0.419146762
      }


  def oppositesign(self, row):
    if row['e1Charge']*row['e2Charge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['Ele35WPTightPass']:
      return False
    return True


  def kinematics(self, row):
    if row['e1Pt'] < 36 or abs(row['e1Eta']) >= 2.1:
      return False
    if row['e2Pt'] < 25 or abs(row['e2Eta']) >= 2.1:
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20TightMVALTVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return bool(row['e1MVANoisoWP80'])
 
 
  def obj1_iso(self, row):
    return bool(row['e1RelPFIsoRho'] < 0.1)
  

  def obj2_id(self, row):
    return bool(row['e2MVANoisoWP80'])


  def obj2_iso(self, row):
    return bool(row['e2RelPFIsoRho'] < 0.1)


  def begin(self):
    names=['Initial'] 

    namesize = len(names)
    for x in range(0, namesize):
      self.book(names[x], "e1Pt", "Electron 1 Pt", 20, 0, 200)
      self.book(names[x], "e2Pt", "Electron 2 Pt", 20, 0, 200)
      self.book(names[x], "e1Eta", "Electron 1 Eta", 20, -3, 3)
      self.book(names[x], "e2Eta", "Electron 2 Eta", 20, -3, 3)
      self.book(names[x], "e1Phi", "Electron 1 Phi", 20, -4, 4)
      self.book(names[x], "e2Phi", "Electron 2 Phi", 20, -4, 4)
      self.book(names[x], "e1_e2_Mass", "Dielectron Mass", 30, 0, 300)


  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/e1Pt'].Fill(row['e1Pt'], weight)
    histos[name+'/e2Pt'].Fill(row['e2Pt'], weight)
    histos[name+'/e1Eta'].Fill(row['e1Eta'], weight)
    histos[name+'/e2Eta'].Fill(row['e2Eta'], weight)
    histos[name+'/e1Phi'].Fill(row['e1Phi'], weight)
    histos[name+'/e2Phi'].Fill(row['e2Phi'], weight)
    histos[name+'/e1_e2_Mass'].Fill(visibleMass(row), weight)


  def copyrow(self, row):
    subtemp = {}

    subtemp["e1Pt"] = row.e1Pt
    subtemp["e2Pt"] = row.e2Pt
    subtemp["e1Eta"] = row.e1Eta
    subtemp["e2Eta"] = row.e2Eta
    subtemp["e1Phi"] = row.e1Phi
    subtemp["e2Phi"] = row.e2Phi
    subtemp["e1Mass"] = row.e1Mass
    subtemp["e2Mass"] = row.e2Mass
    subtemp["e1Charge"] = row.e1Charge
    subtemp["e2Charge"] = row.e2Charge
    subtemp["e1MVANoisoWP80"] = row.e1MVANoisoWP80
    subtemp["e2MVANoisoWP80"] = row.e2MVANoisoWP80
    subtemp["e1RelPFIsoRho"] = row.e1RelPFIsoRho
    subtemp["e2RelPFIsoRho"] = row.e2RelPFIsoRho
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["Ele35WPTightPass"] = row.Ele35WPTightPass
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20TightMVALTVtx"] = row.tauVetoPt20TightMVALTVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["Flag_goodVertices"] = row.Flag_goodVertices
    subtemp["Flag_globalTightHalo2016Filter"] = row.Flag_globalTightHalo2016Filter
    subtemp["Flag_HBHENoiseFilter"] = row.Flag_HBHENoiseFilter
    subtemp["Flag_HBHENoiseIsoFilter"] = row.Flag_HBHENoiseIsoFilter
    subtemp["Flag_EcalDeadCellTriggerPrimitiveFilter"] = row.Flag_EcalDeadCellTriggerPrimitiveFilter
    subtemp["Flag_BadPFMuonFilter"] = row.Flag_BadPFMuonFilter
    subtemp["Flag_BadChargedCandidateFilter"] = row.Flag_BadChargedCandidateFilter
    subtemp["Flag_eeBadScFilter"] = row.Flag_eeBadScFilter
    subtemp["Flag_ecalBadCalibFilter"] = row.Flag_ecalBadCalibFilter
    subtemp["bjetDeepCSVVeto20Medium"] = row.bjetDeepCSVVeto20Medium
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1eta"] = row.jb1eta
    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []

    for row in self.tree:

      nrow = self.copyrow(row)

      if nrow["Flag_goodVertices"]:
        continue

      if nrow["Flag_globalTightHalo2016Filter"]:
        continue

      if nrow["Flag_HBHENoiseFilter"]:
        continue

      if nrow["Flag_HBHENoiseIsoFilter"]:
        continue

      if nrow["Flag_EcalDeadCellTriggerPrimitiveFilter"]:
        continue

      if nrow["Flag_BadPFMuonFilter"]:
        continue

      if nrow["Flag_BadChargedCandidateFilter"]:
        continue

      if self.is_data and nrow["Flag_eeBadScFilter"]:
        continue

      if nrow["Flag_ecalBadCalibFilter"]:
        continue

      if not self.trigger(nrow):
        continue

      if not self.kinematics(nrow):
        continue

      if not self.obj1_id(nrow):
        continue

      if not self.obj2_id(nrow):
        continue

      if not self.vetos(nrow):
        continue      

      nbtag = nrow['bjetDeepCSVVeto20Medium']
      bpt_1 = nrow['jb1pt']
      bflavor_1 = nrow['jb1hadronflavor']
      beta_1 = nrow['jb1eta']
      if (not self.is_data and nbtag > 0):
        nbtag = PromoteDemote(self.h_btag_eff_b, self.h_btag_eff_c, self.h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, 0)
      if (nbtag > 0):
        continue

      if count==0:
        temp.append(self.copyrow(row))
        count=count+1
        continue
      else:
        if row.evt==temp[count-1]["evt"]:
          temp.append(self.copyrow(row))
          count=count+1
          continue
        else:
          x = {}
          y = {}
          z = {}
          w = {}
          new_x = {}
          new_y = {}
          new_z = {}
          new_w = {}
          for i in range(count):
            x[i]=temp[i]["e1RelPFIsoRho"]
            y[i]=temp[i]["e1Pt"]
            z[i]=temp[i]["e2RelPFIsoRho"]
            w[i]=temp[i]["e2Pt"]
          sorted_x = sorted(x.items(), key=operator.itemgetter(1))
          for i in range(len(sorted_x)):
            if i==0:
              new_y[sorted_x[i][0]] = y[sorted_x[i][0]]
            else:
              if sorted_x[i][1] > sorted_x[i-1][1]:
                break
              else:
                new_y[sorted_x[i][0]] = y[sorted_x[i][0]]

          sorted_y = sorted(new_y.items(), key=operator.itemgetter(1), reverse=True)
          for i in range(len(sorted_y)):
            if i==0:
              new_z[sorted_y[i][0]] = z[sorted_y[i][0]]
            else:
              if sorted_y[i][1] > sorted_y[i-1][1]:
                break
              else:
                new_z[sorted_y[i][0]] = z[sorted_y[i][0]]

          sorted_z = sorted(new_z.items(), key=operator.itemgetter(1))
          for i in range(len(sorted_z)):
            if i==0:
              new_w[sorted_z[i][0]] = w[sorted_z[i][0]]
            else:
              if sorted_z[i][1] > sorted_z[i-1][1]:
                break
              else:
                new_w[sorted_z[i][0]] = w[sorted_z[i][0]]

          sorted_w = sorted(new_w.items(), key=operator.itemgetter(1), reverse=True)
          newrow = temp[sorted_w[0][0]]
          count = 1
          temp = []
          temp.append(self.copyrow(row))

      weight = 1.0
      if not self.is_data:
        wmc.var("e_pt").setVal(newrow['e1Pt'])
        wmc.var("e_eta").setVal(newrow['e1Eta'])
        e1iso = wmc.function("e_iso_kit_ratio").getVal()
        e1id = wmc.function("e_id80_kit_ratio").getVal()
        e1Trk = wmc.function("e_trk_ratio").getVal() 
        trg = wmc.function("e_trg35_kit_data").getVal()/wmc.function("e_trg35_kit_mc").getVal()
        wmc.var("e_pt").setVal(newrow['e2Pt'])
        wmc.var("e_eta").setVal(newrow['e2Eta'])
        e2iso = wmc.function("e_iso_kit_ratio").getVal()
        e2id = wmc.function("e_id80_kit_ratio").getVal()
        e2Trk = wmc.function("e_trk_ratio").getVal()
        zvtx = 0.991        
        weight = newrow['GenWeight']*pucorrector(newrow['nTruePU'])*zvtx*e1iso*e1id*e2iso*e2id*trg*e1Trk*e1Trk
        wmc.var("z_gen_mass").setVal(newrow['genMass'])
        wmc.var("z_gen_pt").setVal(newrow['genpT'])
        dyweight = wmc.function("zptmass_weight_nom").getVal()
        if self.is_DY:
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          weight = weight*(11.47563472/1.165)*dyweight
        if self.is_WW:
          weight = weight*0.407
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261
        if self.is_EWKWMinus:
          weight = weight*0.191
        if self.is_EWKWPlus:
          weight = weight*0.343
        if self.is_EWKZToLL:
          weight = weight*0.175
        if self.is_EWKZToNuNu:
          weight = weight*0.140
        if self.is_STtantitop:
          weight = weight*0.922
        if self.is_STttop:
          weight = weight*0.952
        if self.is_STtWantitop:
          weight = weight*0.00538
        if self.is_STtWtop:
          weight = weight*0.00552
        if self.is_TTTo2L2Nu:
          weight = weight*0.0057
        if self.is_TTToHadronic:
          weight = weight*0.379
        if self.is_TTToSemiLeptonic:
          weight = weight*0.00117


      if self.obj2_iso(newrow) and self.obj1_iso(newrow):
        if self.oppositesign(newrow):
          self.fill_histos(newrow, weight, 'Initial')


  def finish(self):
    self.write_histos()
