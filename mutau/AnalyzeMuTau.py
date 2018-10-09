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
from copy import deepcopy
import operator
import mcCorrections
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi


cut_flow_step = ['TauLooseOS', 'TauLooseSS', 'MuonLooseOS', 'MuonLooseSS', 'MuonLooseTauLooseOS', 'MuonLooseTauLooseSS', 'TightOS', 'TightSS']

def deltaPhi(phi1, phi2):
  PHI = abs(phi1-phi2)
  if PHI<=pi:
    return PHI
  else:
    return 2*pi-PHI


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
  met = row['puppiMetEt']
  metPhi = row['puppiMetPhi']
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row['tPhi'])))
  visfrac = row['tPt']/(row['tPt']+ptnu)
  m_t_Mass = visibleMass(row)
  return (m_t_Mass/sqrt(visfrac))


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
elif bool('WJetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W')
elif bool('W1JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W1')
elif bool('W2JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W2')
elif bool('W3JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W3')
elif bool('W4JetsToLNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'W4')
elif bool('WW_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WW')
elif bool('WZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WZ')
elif bool('ZZ_TuneCP5' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZZ')
elif bool('ZHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ZHTT')
elif bool('ttHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'ttH')
elif bool('Wminus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WminusHTT')
elif bool('Wplus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'WplusHTT')
elif bool('ST_t-channel_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtantitop')
elif bool('ST_t-channel_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STttop')
elif bool('ST_tW_antitop' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWantitop')
elif bool('ST_tW_top' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'STtWtop')
elif bool('TTTo2L2Nu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTTo2L2Nu')
elif bool('TTToHadronic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToHadronic')
elif bool('TTToSemiLeptonic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToSemiLeptonic')
elif bool('VBFHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHTT')
elif bool('VBF_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHMT')
elif bool('GluGluHToTauTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHTT')
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHMT')
elif bool('QCD' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'QCD')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')


class AnalyzeMuTau(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_mc = not (self.is_data)
    self.is_DY = bool('DY' in target)
    self.is_W = bool('JetsToLNu' in target)

    super(AnalyzeMuTau, self).__init__(tree, outfile, **kwargs)
    self.tree = MuTauTree.MuTauTree(tree)
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

    self.DYweight = {
      0 : 2.580886465,
      1 : 0.710032286,
      2 : 0.936178296,
      3 : 0.589537006,
      4 : 0.404224719
      }

    self.Wweight = {
      0 : 36.79747369,
      1 : 7.546943825,
      2 : 13.23876037,
      3 : 2.301051766,
      4 : 2.202236679
      }

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


  def event_weight(self, row):

    if self.is_data:
      mcweight = 1.

    else:
      mcweight = row['GenWeight']*pucorrector(row['nTruePU'])

      if self.is_DY:
        if row['numGenJets'] < 5:
          mcweight = mcweight*self.DYweight[row['numGenJets']]
        else:
          mcweight = mcweight*self.DYweight[0]

      if self.is_W:
        if row['numGenJets'] < 5:
          mcweight = mcweight*self.Wweight[row['numGenJets']]
        else:
          mcweight = mcweight*self.Wweight[0]

    weights = {'': mcweight}

    return weights


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
    return bool(row['tDecayModeFinding'] > 0.5) and bool(row['tAgainstElectronTightMVA6'] > 0.5) and bool(row['tAgainstMuonTight3'] > 0.5)


  def obj2_tight(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTTight'] > 0.5)


  def obj2_loose(self, row):
    return bool(row['tRerunMVArun2v2DBoldDMwLTLoose'] > 0.5)


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30Loose'] < 0.5)


  def begin(self):
    names=['TauLooseOS', 'TauLooseSS', 'MuonLooseOS', 'MuonLooseSS', 'MuonLooseTauLooseOS', 'MuonLooseTauLooseSS', 'TightOS', 'TightSS']
    namesize = len(names)
    for x in range(0,namesize):
      self.book(names[x], "mPt", "Muon  Pt", 30, 0, 300)
      self.book(names[x], "tPt", "Tau  Pt", 30, 0, 300)
      self.book(names[x], "mEta", "Muon Eta", 10, -5, 5)
      self.book(names[x], "tEta", "Tau Eta", 10, -5, 5)
      self.book(names[x], "mPhi", "Muon Phi", 10, -5, 5)
      self.book(names[x], "tPhi", "Tau Phi", 10, -5, 5)
      self.book(names[x], "puppiMetEt", "Puppi MET Et", 30, 0, 300)
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 30, 0, 300)
      self.book(names[x], "puppiMetPhi", "Puppi MET Phi", 10, -5, 5)
      self.book(names[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -5, 5)
      self.book(names[x], "m_t_Mass", "Muon + Tau Mass", 30, 0, 300)
      self.book(names[x], "m_t_CollinearMass", "Muon + Tau Collinear Mass", 30, 0, 300)      
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "deltaPhiMuMET", "Delta Phi Mu MET", 100, 0, 3.2)
      self.book(names[x], "deltaPhiTauMET", "Delta Phi Tau MET", 100, 0, 3.2)
      self.book(names[x], "MTMuMET", "Muon MET Transverse Mass", 30, 0, 300)
      self.book(names[x], "MTTauMET", "Tau MET Transverse Mass", 30, 0, 300)

    self.book('', "CUT_FLOW", "Cut Flow", len(cut_flow_step), 0, len(cut_flow_step))
            
    xaxis = self.histograms['CUT_FLOW'].GetXaxis()
    self.cut_flow_histo = self.histograms['CUT_FLOW']
    self.cut_flow_map   = {}
    for i, name in enumerate(cut_flow_step):
      xaxis.SetBinLabel(i+1, name)
      self.cut_flow_map[name] = i+0.5


  def fill_histos(self, row, weight, name=''):
    histos = self.histograms
    histos[name+'/mPt'].Fill(row['mPt'], weight)
    histos[name+'/tPt'].Fill(row['tPt'], weight)
    histos[name+'/mEta'].Fill(row['mEta'], weight)
    histos[name+'/tEta'].Fill(row['tEta'], weight)
    histos[name+'/mPhi'].Fill(row['mPhi'], weight)
    histos[name+'/tPhi'].Fill(row['tPhi'], weight)
    histos[name+'/puppiMetEt'].Fill(row['puppiMetEt'], weight)
    histos[name+'/type1_pfMetEt'].Fill(row['type1_pfMetEt'], weight)
    histos[name+'/puppiMetPhi'].Fill(row['puppiMetPhi'], weight)
    histos[name+'/type1_pfMetPhi'].Fill(row['type1_pfMetPhi'], weight)
    histos[name+'/m_t_Mass'].Fill(visibleMass(row), weight)
    histos[name+'/m_t_CollinearMass'].Fill(collMass(row), weight)
    histos[name+'/numOfJets'].Fill(row['jetVeto30'], weight)
    histos[name+'/numOfVtx'].Fill(row['nvtx'], weight)
    histos[name+'/deltaPhiMuMET'].Fill(deltaPhi(row['mPhi'], row['puppiMetPhi']), weight)#type1_pfMetPhi
    histos[name+'/deltaPhiTauMET'].Fill(deltaPhi(row['tPhi'], row['puppiMetPhi']), weight)
    histos[name+'/MTMuMET'].Fill(transverseMass(row['mPt'], row['mEta'], row['mPhi'], row['mMass'], row['puppiMetEt'], row['puppiMetPhi']), weight)
    histos[name+'/MTTauMET'].Fill(transverseMass(row['tPt'], row['tEta'], row['tPhi'], row['tMass'], row['puppiMetEt'], row['puppiMetPhi']), weight)


  def copyrow(self, row):
    subtemp = {}
    subtemp["mPt"] = row.mPt
    if (not self.is_data) and (not row.isZmumu) and (not row.isZee) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        subtemp["tPt"] = 0.97*row.tPt
        subtemp["puppiMetEt"] = row.puppiMetEt+0.03*row.tPt
      elif row.tDecayMode == 1:
        subtemp["tPt"] = 0.98*row.tPt
        subtemp["puppiMetEt"] = row.puppiMetEt+0.02*row.tPt
      elif row.tDecayMode == 10:
        subtemp["tPt"] = 0.99*row.tPt
        subtemp["puppiMetEt"] = row.puppiMetEt+0.01*row.tPt    
      else:
        subtemp["tPt"] = row.tPt
        subtemp["puppiMetEt"] = row.puppiMetEt
    else:
      subtemp["tPt"] = row.tPt
      subtemp["puppiMetEt"] = row.puppiMetEt
    subtemp["mEta"] = row.mEta
    subtemp["tEta"] = row.tEta
    subtemp["mPhi"] = row.mPhi
    subtemp["tPhi"] = row.tPhi
    subtemp["mMass"] = row.mMass
    subtemp["tMass"] = row.tMass
    subtemp["mCharge"] = row.mCharge
    subtemp["tCharge"] = row.tCharge
    subtemp["type1_pfMetEt"] = row.type1_pfMetEt
    subtemp["puppiMetPhi"] = row.puppiMetPhi
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
    subtemp["dimuonVeto"] = row.dimuonVeto
    subtemp["tPVDZ"] = row.tPVDZ
    subtemp["eVetoZTTp001dxyz"] = row.eVetoZTTp001dxyz
    subtemp["muVetoZTTp001dxyz"] = row.muVetoZTTp001dxyz
    subtemp["bjetDeepCSVVeto30Loose"] = row.bjetDeepCSVVeto30Loose
    return subtemp


  def process(self):
    count = 0
    temp = []
    newrow = []
    cut_flow_histo = self.cut_flow_histo
    cut_flow_trk   = cut_flow_tracker(cut_flow_histo)

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

      try:
        weight_map = self.event_weight(newrow)
        if weight_map[''] == 0: continue
        weight = weight_map['']
      except AttributeError:
        weight = 1.0

      cut_flow_trk.new_row(newrow['run'], newrow['lumi'], newrow['evt'])

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

      if not self.bjetveto(newrow):
        continue

      if not self.is_data:
        tEff = self.triggerEff(newrow['mPt'], abs(newrow['mEta']))
        mID = self.muonTightID(newrow['mPt'], abs(newrow['mEta']))
        weight = weight*tEff*mID
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

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and self.obj1_tight(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        mIso = 1
        tIso = 1
        if not self.is_data:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          tIso = self.tauSF['loose']
        if self.oppositesign(newrow):
          cut_flow_trk.Fill('TauLooseOS')
          self.fill_histos(newrow, weight*frTau*mIso*tIso, 'TauLooseOS')
        if not self.oppositesign(newrow):
          cut_flow_trk.Fill('TauLooseSS')
          self.fill_histos(newrow, weight*frTau*mIso*tIso, 'TauLooseSS')

      if not self.obj1_tight(newrow) and self.obj1_loose(newrow) and self.obj2_tight(newrow):
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          tIso = self.tauSF['tight']
        if self.oppositesign(newrow):
          cut_flow_trk.Fill('MuonLooseOS')
          self.fill_histos(newrow, weight*frMuon*mIso*tIso, 'MuonLooseOS')
        if not self.oppositesign(newrow):
          cut_flow_trk.Fill('MuonLooseSS')
          self.fill_histos(newrow, weight*frMuon*mIso*tIso, 'MuonLooseSS')

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and not self.obj1_tight(newrow) and self.obj1_loose(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          tIso = self.tauSF['loose']
        if self.oppositesign(newrow):
          cut_flow_trk.Fill('MuonLooseTauLooseOS')
          self.fill_histos(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS')
        if not self.oppositesign(newrow):
          cut_flow_trk.Fill('MuonLooseTauLooseSS')
          self.fill_histos(newrow, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseSS')

      if self.obj2_tight(newrow) and self.obj1_tight(newrow):
        mIso = 1
        tIso = 1
        if not self.is_data:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          tIso = self.tauSF['tight']
        if self.oppositesign(newrow):
          cut_flow_trk.Fill('TightOS')
          self.fill_histos(newrow, weight*mIso*tIso, 'TightOS')
        if not self.oppositesign(newrow):
          cut_flow_trk.Fill('TightSS')
          self.fill_histos(newrow, weight*mIso*tIso, 'TightSS')


  def finish(self):
    self.write_histos()
