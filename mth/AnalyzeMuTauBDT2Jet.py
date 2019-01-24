'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import math
import array
from copy import deepcopy
import operator
import mcCorrections
import itertools
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi


def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI

def invert_case(letter):
  if letter.upper() == letter:
    return letter.lower()
  else:
    return letter.upper()

def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)


def transverseMass(objPt, objEta, objPhi, objMass, MetEt, MetPhi):
  vobj = ROOT.TLorentzVector()
  vmet = ROOT.TLorentzVector()
  vobj.SetPtEtaPhiM(objPt, objEta, objPhi, objMass)
  vmet.SetPtEtaPhiM(MetEt, 0, MetPhi, 0)
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))


def visibleMass(row):
  vobj1 = ROOT.TLorentzVector()
  vobj2 = ROOT.TLorentzVector()
  vobj1.SetPtEtaPhiM(row['mPt'], row['mEta'], row['mPhi'], row['mMass'])
  vobj2.SetPtEtaPhiM(row['tPt'], row['tEta'], row['tPhi'], row['tMass'])
  return (vobj1 + vobj2).M()


def collMass(row):
  met = row['type1_pfMetEt']
  metPhi = row['type1_pfMetPhi']
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row['tPhi'])))
  visfrac = row['tPt']/(row['tPt']+ptnu)
  m_t_Mass = visibleMass(row)
  return (m_t_Mass/sqrt(visfrac))


target = os.path.basename(os.environ['megatarget'])

if bool('VBF_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHMT')
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHMT')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeMuTauBDT2Jet(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_GluGlu = bool('GluGlu_LFV' in target)
    self.is_VBF = bool('VBF_LFV' in target)
    self.branches="mPt/F:tPt/F:dPhiMuTau/F:dEtaMuTau/F:type1_pfMetEt/F:m_t_collinearMass/F:MTTauMET/F:dPhiTauMET/F:vbfMass/F:vbfDeta/F:weight/F"
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name="TreeS"
      self.title="TreeS"
    else:
      self.name="TreeB"
      self.title="TreeB"

    super(AnalyzeMuTauBDT2Jet, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
    self.out = outfile
    self.histograms = {}

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017 if not self.is_data else 1.
    self.muonTightID = mcCorrections.muonID_tight if not self.is_data else 1.
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid if not self.is_data else 1.
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateMuon = mcCorrections.fakerateMuon_weight
    self.muTracking = mcCorrections.muonTracking 

    self.tauSF={ 
      'vloose' : 0.88,
      'loose'  : 0.89,
      'medium' : 0.89,
      'tight'  : 0.89,
      'vtight' : 0.86,
      'vvtight': 0.84
      }


  def oppositesign(self, row):
    if row['mCharge']*row['tCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['IsoMu27Pass']:
      return False
    return True


  def kinematics(self, row):
    if row['mPt'] < 29 or abs(row['mEta']) >= 2.4:
      return False
    if row['tPt'] < 30 or abs(row['tEta']) >= 2.3:
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20Loose3HitsVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return bool(row['mPFIDTight'])
 
 
  def obj1_tight(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.15)
  

  def obj1_loose(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.25)

  
  def obj2_id(self, row):
    return bool(row['tDecayModeFinding'] > 0.5) and bool(row['tAgainstElectronVLooseMVA6'] > 0.5) and bool(row['tAgainstMuonTight3'] > 0.5)


  def obj2_tight(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTTight'] > 0.5)


  def obj2_loose(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTLoose'] > 0.5)


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30Loose'] < 0.5)


  def begin(self):
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))

    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)

  def filltree(self, row, weight):
    for varname, holder in self.holders:
      if varname=="mPt":
        holder[0] = row['mPt']
      elif varname=="tPt":
        holder[0] = row['tPt']
      elif varname=="dPhiMuTau":
        holder[0] = deltaPhi(row['mPhi'], row['tPhi'])
      elif varname=="dEtaMuTau": 
        holder[0] = abs(row['mEta'] - row['tEta'])
      elif varname=="type1_pfMetEt":
        holder[0] = row['type1_pfMetEt']
      elif varname=="m_t_collinearMass":
        holder[0] = collMass(row)
      elif varname=="MTTauMET":
        holder[0] = transverseMass(row['tPt'], row['tEta'], row['tPhi'], row['tMass'], row['type1_pfMetEt'], row['type1_pfMetPhi'])
      elif varname=="dPhiTauMET":
        holder[0] = deltaPhi(row['tPhi'], row['type1_pfMetPhi'])
      elif varname=="vbfMass":
        holder[0] = row['vbfMass']
      elif varname=="vbfDeta":
        holder[0] = row['vbfDeta']
      elif varname=="weight": 
        holder[0] = weight
    self.tree1.Fill()

  def copyrow(self, row):
    subtemp = {}
    subtemp["mPt"] = row.mPt
    if (not self.is_data) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        subtemp["tPt"] = 1.007*row.tPt
        subtemp["type1_pfMetEt"] = row.type1_pfMetEt - 0.007*row.tPt
      elif row.tDecayMode == 1:
        subtemp["tPt"] = 0.998*row.tPt
        subtemp["type1_pfMetEt"] = row.type1_pfMetEt + 0.002*row.tPt
      elif row.tDecayMode == 10:
        subtemp["tPt"] = 1.001*row.tPt
        subtemp["type1_pfMetEt"] = row.type1_pfMetEt - 0.001*row.tPt    
      else:
        subtemp["tPt"] = row.tPt
        subtemp["type1_pfMetEt"] = row.type1_pfMetEt
    else:
      subtemp["tPt"] = row.tPt
      subtemp["type1_pfMetEt"] = row.type1_pfMetEt
    subtemp["mEta"] = row.mEta
    subtemp["tEta"] = row.tEta
    subtemp["mPhi"] = row.mPhi
    subtemp["tPhi"] = row.tPhi
    subtemp["mMass"] = row.mMass
    subtemp["tMass"] = row.tMass
    subtemp["mCharge"] = row.mCharge
    subtemp["tCharge"] = row.tCharge
    subtemp["type1_pfMetPhi"] = row.type1_pfMetPhi
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["IsoMu27Pass"] = row.IsoMu27Pass
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20Loose3HitsVtx"] = row.tauVetoPt20Loose3HitsVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["mPFIDTight"] = row.mPFIDTight
    subtemp["mRelPFIsoDBDefaultR04"] = row.mRelPFIsoDBDefaultR04
    subtemp["tDecayModeFinding"] = row.tDecayModeFinding
    subtemp["tDecayMode"] = row.tDecayMode
    subtemp["tAgainstElectronVLooseMVA6"] = row.tAgainstElectronVLooseMVA6
    subtemp["tAgainstElectronTightMVA6"] = row.tAgainstElectronTightMVA6
    subtemp["tAgainstMuonTight3"] = row.tAgainstMuonTight3
    subtemp["tRerunMVArun2v2DBoldDMwLTTight"] = row.tRerunMVArun2v2DBoldDMwLTTight
    subtemp["tRerunMVArun2v2DBoldDMwLTLoose"] = row.tRerunMVArun2v2DBoldDMwLTLoose
    subtemp["tByCombinedIsolationDeltaBetaCorrRaw3Hits"] = row.tByCombinedIsolationDeltaBetaCorrRaw3Hits
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["tZTTGenMatching"] = row.tZTTGenMatching
    subtemp["tPVDZ"] = row.tPVDZ
    subtemp["eVetoZTTp001dxyz"] = row.eVetoZTTp001dxyz
    subtemp["muVetoZTTp001dxyz"] = row.muVetoZTTp001dxyz
    subtemp["bjetDeepCSVVeto30Loose"] = row.bjetDeepCSVVeto30Loose
    subtemp["vbfNJets30"] = row.vbfNJets30
    subtemp["vbfMass"] = row.vbfMass
    subtemp["vbfDeta"] = row.vbfDeta
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []

    for row in self.tree:
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
            x[i]=temp[i]["mRelPFIsoDBDefaultR04"]
            y[i]=temp[i]["mPt"]
            z[i]=temp[i]["tByCombinedIsolationDeltaBetaCorrRaw3Hits"]
            w[i]=temp[i]["tPt"]
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

      if not self.trigger(newrow):
        continue

      if not self.kinematics(newrow):
        continue

      if deltaR(newrow['mPhi'], newrow['tPhi'], newrow['mEta'], newrow['tEta']) < 0.5:
        continue

      if newrow['jetVeto30'] > 2:
        continue

      if not self.obj1_id(newrow):
        continue

      if not self.obj2_id(newrow):
        continue

      if not self.vetos(newrow):
        continue      

      weight = 1.0
      if not self.is_data:
        mtracking = self.muTracking(newrow['mEta'])[0]
        tEff = self.triggerEff(newrow['mPt'], abs(newrow['mEta']))
        mID = self.muonTightID(newrow['mPt'], abs(newrow['mEta']))
        weight = newrow['GenWeight']*pucorrector(newrow['nTruePU'])*tEff*mID*mtracking
        if self.is_GluGlu:
          weight = weight*0.00519
        if self.is_VBF:
          weight = weight*0.00214
        if newrow['tZTTGenMatching']==2 or newrow['tZTTGenMatching']==4:
          if abs(newrow['tEta']) < 0.4:
            weight = weight*1.17
          elif abs(newrow['tEta']) < 0.8:
            weight = weight*1.29
          elif abs(newrow['tEta']) < 1.2:
            weight = weight*1.14
          elif abs(newrow['tEta']) < 1.7:
            weight = weight*0.93
          else:
            weight = weight*1.61
        elif newrow['tZTTGenMatching']==1 or newrow['tZTTGenMatching']==3:
          if abs(newrow['tEta']) < 1.46:
            weight = weight*1.09
          elif abs(newrow['tEta']) > 1.558:
            weight = weight*1.19

      if newrow['vbfNJets30']!=2:
        continue

      if self.is_data:
        if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and not self.obj1_tight(newrow) and self.obj1_loose(newrow):
          frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
          frMuon = self.fakeRateMuon(newrow['mPt'])
          if not self.oppositesign(newrow):
            self.filltree(newrow, weight*frTau*frMuon)

      if not self.is_data:
        if self.obj2_tight(newrow) and self.obj1_tight(newrow):
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          tIso = self.tauSF['tight']
          if self.oppositesign(newrow):
            self.filltree(newrow, weight*mIso*tIso)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
