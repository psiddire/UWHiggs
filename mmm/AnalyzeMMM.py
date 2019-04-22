import MuMuMuTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
import copy
import operator
import mcCorrections
from math import sqrt, pi
from ROOT import gROOT, gRandom, TRandom3, TFile
from bTagSF import PromoteDemote

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI
  
def visibleMass(row):
  vm1 = ROOT.TLorentzVector()
  vm2 = ROOT.TLorentzVector()
  vm1.SetPtEtaPhiM(row['m1Pt'], row['m1Eta'], row['m1Phi'], row['m1Mass'])
  vm2.SetPtEtaPhiM(row['m2Pt'], row['m2Eta'], row['m2Phi'], row['m2Mass'])
  #vm1.SetPtEtaPhiM(row.m1Pt, row.m1Eta, row.m1Phi, row.m1Mass)                                                                                                                                                                                                 
  #vm2.SetPtEtaPhiM(row.m2Pt, row.m2Eta, row.m2Phi, row.m2Mass)
  return (vm1+vm2).M()

target = os.path.basename(os.environ['megatarget'])

if bool('DYJetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY4')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZZ')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeMMM(MegaBase):
  tree = 'mmm/final/Ntuple'
  
  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.f_btag_eff = TFile("btag.root","r")
    self.h_btag_eff_b = self.f_btag_eff.Get("btag_eff_b")
    self.h_btag_eff_c = self.f_btag_eff.Get("btag_eff_c")
    self.h_btag_eff_oth = self.f_btag_eff.Get("btag_eff_oth")

    super(AnalyzeMMM, self).__init__(tree, outfile, **kwargs)
    self.tree = MuMuMuTree.MuMuMuTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonTightID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonMediumID = mcCorrections.muonID_medium if not self.is_data else 1.
    self.muonLooseID = mcCorrections.muonID_loose if not self.is_data else 1.
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid if not self.is_data else 1.
    self.muonTightIsoMediumID = mcCorrections.muonIso_tight_mediumid if not self.is_data else 1.
    self.muonLooseIsoLooseID = mcCorrections.muonIso_loose_looseid if not self.is_data else 1.
    self.muonLooseIsoMediumID = mcCorrections.muonIso_loose_mediumid if not self.is_data else 1.
    self.muonLooseIsoTightID = mcCorrections.muonIso_loose_tightid if not self.is_data else 1.
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.DYreweight1D = mcCorrections.DYreweight1D
    self.DYreweight = mcCorrections.DYreweight
    self.muTracking = mcCorrections.muonTracking
    self.embedTrg = mcCorrections.embedTrg
    self.embedmID = mcCorrections.embedmID
    self.embedmIso = mcCorrections.embedmIso

    self.DYweight = {
      0 : 2.580886465,
      1 : 0.710032286,
      2 : 0.936178296,
      3 : 0.589537006,
      4 : 0.404224719
      }


  def oppositesign(self,row):
    if row.m1Charge*row.m2Charge!=-1:
      return False
    return True


  def trigger(self, row):
    if not row.IsoMu27Pass:
      return False
    return True


  def kinematics(self, row):
    if row.m1Pt < 29 or abs(row.m1Eta) >= 2.1:
      return False
    if row.m2Pt < 10 or abs(row.m2Eta) >= 2.1:
      return False
    if row.m3Pt < 10 or abs(row.m3Eta) >= 2.1:
      return False
    return True


  def obj1_id(self,row):
    return bool(row.m1PFIDMedium)#Tight
 
 
  def obj1_iso(self,row):
    return bool(row.m1RelPFIsoDBDefaultR04 < 0.25)
  
  
  def obj2_id(self, row):
    return bool(row.m2PFIDMedium)#Tight


  def obj2_iso(self, row):
    return bool(row.m2RelPFIsoDBDefaultR04 < 0.25)


  def obj3_id(self, row):
    return bool(row['m3PFIDTight'])


  def obj3_iso(self, row):
    return bool(row['m3RelPFIsoDBDefaultR04'] < 0.25)


  def obj3_tightiso(self, row):
    return bool(row['m3RelPFIsoDBDefaultR04'] < 0.15)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5) and bool(row.tauVetoPt20TightMVALTVtx < 0.5))


  def bjetveto(self, row):
    return bool(row.bjetDeepCSVVeto30Medium < 0.5)


  def begin(self):
    names=['initial', 'muonloose', 'muontight']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "m3Pt", "Muon 3 Pt", 20, 0, 200)
      self.book(names[x], "m3Eta", "Muon 3 Eta", 20, -3.0, 3.0)
      self.book(names[x], "m1_m2_Mass", "Invariant Muon Mass", 10, 50, 150)
      self.book(names[x], "m1Pt", "Muon 1 Pt", 20, 0, 200)
      self.book(names[x], "m1Eta", "Muon 1 Eta", 20, -3.0, 3.0)
      self.book(names[x], "m2Pt", "Muon 2 Pt", 20, 0, 200)
      self.book(names[x], "m2Eta", "Muon 2 Eta", 20, -3.0, 3.0)

  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/m3Pt'].Fill(row['m3Pt'], weight)
    histos[name+'/m3Eta'].Fill(row['m3Eta'], weight)
    histos[name+'/m1_m2_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m1Pt'].Fill(row['m1Pt'], weight)
    histos[name+'/m1Eta'].Fill(row['m1Eta'], weight)
    histos[name+'/m2Pt'].Fill(row['m2Pt'], weight)
    histos[name+'/m2Eta'].Fill(row['m2Eta'], weight)

  def copyrow(self, row):
    subtemp = {}

    subtemp["m1Pt"] = row.m1Pt
    subtemp["m1Eta"] = row.m1Eta
    subtemp["m1Phi"] = row.m1Phi
    subtemp["m1Mass"] = row.m1Mass
    subtemp["m2Pt"] = row.m2Pt
    subtemp["m2Eta"] = row.m2Eta
    subtemp["m2Phi"] = row.m2Phi
    subtemp["m2Mass"] = row.m2Mass
    subtemp["m3Pt"] = row.m3Pt
    subtemp["m3Eta"] = row.m3Eta
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["m3PFIDTight"] = row.m3PFIDTight
    subtemp["m3RelPFIsoDBDefaultR04"] = row.m3RelPFIsoDBDefaultR04
    subtemp["m2RelPFIsoDBDefaultR04"] = row.m2RelPFIsoDBDefaultR04
    subtemp["m1RelPFIsoDBDefaultR04"] = row.m1RelPFIsoDBDefaultR04
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []

    for row in self.tree:

      if row.Flag_goodVertices:
        continue

      if row.Flag_globalTightHalo2016Filter:
        continue

      if row.Flag_HBHENoiseFilter:
        continue

      if row.Flag_HBHENoiseIsoFilter:
        continue

      if row.Flag_EcalDeadCellTriggerPrimitiveFilter:
        continue

      if row.Flag_BadPFMuonFilter:
        continue

      if row.Flag_BadChargedCandidateFilter:
        continue

      if self.is_data and row.Flag_eeBadScFilter:
        continue

      if row.Flag_ecalBadCalibFilter:
        continue

      if not self.oppositesign(row):
        continue

      if not self.trigger(row):
        continue

      if not self.kinematics(row):
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj1_iso(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.obj2_iso(row):
        continue

      if not self.vetos(row):
        continue

      nbtag = row.bjetDeepCSVVeto20Medium
      bpt_1 = row.jb1pt
      bflavor_1 = row.jb1hadronflavor
      beta_1 = row.jb1eta
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
          v = {}
          new_x = {}
          new_y = {}
          new_z = {}
          new_w = {}
          new_v = {}
          for i in range(count):
            x[i]=temp[i]["m1RelPFIsoDBDefaultR04"]
            y[i]=temp[i]["m1Pt"]
            z[i]=temp[i]["m2RelPFIsoDBDefaultR04"]
            w[i]=temp[i]["m2Pt"]
            v[i]=temp[i]["m3Pt"]
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
          for i in range(len(sorted_w)):
            if i==0:
              new_v[sorted_w[i][0]] = v[sorted_w[i][0]]
            else:
              if sorted_w[i][1] > sorted_w[i-1][1]:
                break
              else:
                new_v[sorted_w[i][0]] = v[sorted_w[i][0]]

          sorted_v = sorted(new_v.items(), key=operator.itemgetter(1), reverse=True)
          newrow = temp[sorted_v[0][0]]
          count = 1
          temp = []
          temp.append(self.copyrow(row))

      weight = 1.0
      if not self.is_data:
        tEff = self.triggerEff(newrow['m1Pt'], abs(newrow['m1Eta']))
        m1ID = self.muonMediumID(newrow['m1Pt'], abs(newrow['m1Eta']))#Tight
        m1Iso = self.muonLooseIsoMediumID(newrow['m1Pt'], abs(newrow['m1Eta']))
        m2ID = self.muonMediumID(newrow['m2Pt'], abs(newrow['m2Eta']))
        m2Iso = self.muonLooseIsoMediumID(newrow['m2Pt'], abs(newrow['m2Eta']))
        weight = weight*m2ID*m2Iso*m1ID*m1Iso*tEff*newrow['GenWeight']*pucorrector(newrow['nTruePU'])
        if self.is_WW:
          weight = weight*0.407
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261

      if visibleMass(newrow) < 70 or visibleMass(newrow) > 110:
        continue

      self.fill_histos(newrow, weight, 'initial')

      if not self.obj3_id(newrow):
        continue

      if not self.obj3_iso(newrow):
        continue
      m3ID = 1
      m3Iso = 1
      if not self.is_data:
        m3ID = self.muonTightID(newrow['m3Pt'], abs(newrow['m3Eta']))
        m3Iso = self.muonLooseIsoTightID(newrow['m3Pt'], abs(newrow['m3Eta']))
      self.fill_histos(newrow, weight*m3ID*m3Iso, 'muonloose')

      if not self.obj3_tightiso(newrow):
        continue
      m3ID = 1
      m3Iso = 1
      if not self.is_data:
        m3ID = self.muonTightID(newrow['m3Pt'], abs(newrow['m3Eta']))
        m3Iso = self.muonTightIsoTightID(newrow['m3Pt'], abs(newrow['m3Eta']))
      self.fill_histos(newrow, weight*m3ID*m3Iso, 'muontight')


  def finish(self):
    self.write_histos()
