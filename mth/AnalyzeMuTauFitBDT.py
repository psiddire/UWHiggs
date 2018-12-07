'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import MuTauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array as arr
import math
from copy import deepcopy
import operator
import mcCorrections
from RecoilCorrector import RecoilCorrector
from cutflowtracker import cut_flow_tracker
from math import sqrt, pi
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA
from ROOT import gROOT, gRandom, TRandom3
import bTagSF

gRandom.SetSeed()
rnd = gRandom.Rndm
MetCorrection = True
target = os.path.basename(os.environ['megatarget'])


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


if bool('DYJetsToLL_M-50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY10')
elif bool('DYJetsToLL_M-50_TuneCP5_13TeV-amcatnloFXFX' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DYAMC')
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
elif bool('EWKWMinus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wminus')
elif bool('EWKWPlus' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Wplus')
elif bool('EWKZ2Jets_ZToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Zll')
elif bool('EWKZ2Jets_ZToNuNu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'Znunu')
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


class AnalyzeMuTauFitBDT(MegaBase):
  tree = 'mt/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.is_data = target.startswith('data_')
    self.is_embed = target.startswith('embedded_')
    self.is_mc = not self.is_data and not self.is_embed
    self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
    self.is_DY = bool('DY' in target) and not self.is_DYlow
    self.is_GluGlu = bool('GluGlu_LFV' in target)
    self.is_VBF = bool('VBF_LFV' in target)
    self.is_W = bool('JetsToLNu' in target)
    self.is_WW = bool('WW_TuneCP5' in target)
    self.is_WZ = bool('WZ_TuneCP5' in target)
    self.is_ZZ = bool('ZZ_TuneCP5' in target)
    self.is_EWKWMinus = bool('EWKWMinus' in target)
    self.is_EWKWPlus = bool('EWKWPlus' in target)
    self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
    self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
    self.is_ZHTT = bool('ZHToTauTau' in target)
    self.is_ttH = bool('ttHToTauTau' in target)
    self.is_Wminus = bool('Wminus' in target)
    self.is_Wplus = bool('Wplus' in target)
    self.is_STtantitop = bool('ST_t-channel_antitop' in target)
    self.is_STttop = bool('ST_t-channel_top' in target)
    self.is_STtWantitop = bool('ST_tW_antitop' in target)
    self.is_STtWtop = bool('ST_tW_top' in target)
    self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
    self.is_TTToHadronic = bool('TTToHadronic' in target)
    self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
    self.is_VBFH = bool('VBFHToTauTau' in target)
    self.is_GluGluH = bool('GluGluHToTauTau' in target)
    self.is_recoilC = bool(('HTo' in target) or ('Jets' in target))
    if self.is_recoilC and MetCorrection:
      self.Metcorected = RecoilCorrector("Type1_PFMET_2017.root")
    self.var_d_star =['mPt', 'tPt', 'dPhiMuTau', 'dEtaMuTau', 'type1_pfMetEt', 'm_t_collinearMass', 'MTTauMET', 'dPhiTauMET', 'vbfMass']#, 'vbfDeta'] 
    self.xml_name = os.path.join(os.getcwd(), "bdtdata/datasetSVM/weights/TMVAClassification_SVM.weights.xml")
    self.functor = FunctorFromMVA('BDT method', self.xml_name, *self.var_d_star)
    #self.xml_name0 = os.path.join(os.getcwd(), "bdtdata/dataset0Jet/weights/TMVAClassification_BDT.weights.xml")
    #self.functor0 = FunctorFromMVA('BDT method', self.xml_name0, *self.var_d_star)
    #self.xml_name1 = os.path.join(os.getcwd(), "bdtdata/dataset1Jet/weights/TMVAClassification_BDT.weights.xml")
    #self.functor1 = FunctorFromMVA('BDT method', self.xml_name1, *self.var_d_star)
    #self.xml_name2 = os.path.join(os.getcwd(), "bdtdata/dataset2Jet/weights/TMVAClassification_BDT.weights.xml")
    #self.functor2 = FunctorFromMVA('BDT method', self.xml_name2, *self.var_d_star)

    super(AnalyzeMuTauFitBDT, self).__init__(tree, outfile, **kwargs)
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
    self.DYreweight1D = mcCorrections.DYreweight1D
    self.DYreweight = mcCorrections.DYreweight
    self.muTracking = mcCorrections.muonTracking 
    self.embedTrg = mcCorrections.embedTrg
    self.embedmID = mcCorrections.embedmID
    self.embedmIso = mcCorrections.embedmIso

    self.DYweight = {
      0 : 2.79668853,
      1 : 0.492824977,
      2 : 1.014457295,
      3 : 0.64402901,
      4 : 0.449235695
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
    return bool(row['bjetDeepCSVVeto30Medium'] < 0.5)


  def begin(self):
    names=['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TightOS2Jet','TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book(names[x], "bdtDiscriminator", "SVM Discriminator", 10, 0.0, 1.0)


  def fill_histos(self, mva, weight, name=''):
    histos = self.histograms
    histos[name+'/bdtDiscriminator'].Fill(mva, weight)


  def copyrow(self, row):

    subtemp = {}

    tmpMetEt = row.type1_pfMetEt
    tmpMetPhi = row.type1_pfMetPhi
    if self.is_recoilC and MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])

    if self.is_mc and (not row.isZmumu) and (not row.isZee) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        subtemp["tPt"] = 1.007*row.tPt
        subtemp["type1_pfMetEt"] = tmpMetEt - 0.007*row.tPt
      elif row.tDecayMode == 1:
        subtemp["tPt"] = 0.998*row.tPt
        subtemp["type1_pfMetEt"] = tmpMetEt + 0.002*row.tPt
      elif row.tDecayMode == 10:
        subtemp["tPt"] = 1.001*row.tPt
        subtemp["type1_pfMetEt"] = tmpMetEt - 0.001*row.tPt    
      else:
        subtemp["tPt"] = row.tPt
        subtemp["type1_pfMetEt"] = tmpMetEt
    else:
      subtemp["tPt"] = row.tPt
      subtemp["type1_pfMetEt"] = tmpMetEt
    subtemp["type1_pfMetPhi"] = tmpMetPhi

    if self.is_DY:
      subtemp["isZmumu"] = row.isZmumu
      subtemp["isZee"] = row.isZee

    subtemp["mPt"] = row.mPt
    subtemp["mEta"] = row.mEta
    subtemp["tEta"] = row.tEta
    subtemp["mPhi"] = row.mPhi
    subtemp["tPhi"] = row.tPhi
    subtemp["mMass"] = row.mMass
    subtemp["tMass"] = row.tMass
    subtemp["mCharge"] = row.mCharge
    subtemp["tCharge"] = row.tCharge
    subtemp["puppiMetEt"] = row.puppiMetEt
    subtemp["puppiMetPhi"] = row.puppiMetPhi
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
    subtemp["tAgainstElectronVLooseMVA6"] = row.tAgainstElectronVLooseMVA6
    subtemp["tAgainstMuonTight3"] = row.tAgainstMuonTight3
    subtemp["tRerunMVArun2v2DBoldDMwLTTight"] = row.tRerunMVArun2v2DBoldDMwLTTight
    subtemp["tRerunMVArun2v2DBoldDMwLTLoose"] = row.tRerunMVArun2v2DBoldDMwLTLoose
    subtemp["tByCombinedIsolationDeltaBetaCorrRaw3Hits"] = row.tByCombinedIsolationDeltaBetaCorrRaw3Hits
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["tDecayMode"] = row.tDecayMode
    subtemp["tZTTGenMatching"] = row.tZTTGenMatching
    subtemp["dimuonVeto"] = row.dimuonVeto
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["vbfNJets30"] = row.vbfNJets30
    subtemp["vbfMass"] = row.vbfMass
    subtemp["vbfDeta"] = row.vbfDeta
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp['jb1pt'] = row.jb1pt
    subtemp['jb1hadronflavor'] = row.jb1hadronflavor
    subtemp['jb2pt'] = row.jb2pt
    subtemp['jb2hadronflavor'] = row.jb2hadronflavor
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

      if self.is_DY:
        if not bool(newrow['isZmumu'] or newrow['isZee']):
          continue

      self.var_d_0 = {'mPt' : newrow['mPt'], 'tPt' : newrow['tPt'], 'dPhiMuTau' : deltaPhi(newrow['mPhi'], newrow['tPhi']), 'dEtaMuTau' : abs(newrow['mEta'] - newrow['tEta']), 'type1_pfMetEt' : newrow['type1_pfMetEt'], 'm_t_collinearMass' : collMass(newrow), 'MTTauMET' : transverseMass(newrow['tPt'], newrow['tEta'], newrow['tPhi'], newrow['tMass'], newrow['type1_pfMetEt'], newrow['type1_pfMetPhi']), 'dPhiTauMET' : deltaPhi(newrow['tPhi'], newrow['type1_pfMetPhi']), 'vbfMass' : newrow['vbfMass']}#, 'vbfDeta' : newrow['vbfDeta']}
      MVA = self.functor(**self.var_d_0)
      print MVA
      #MVA0 = self.functor0(**self.var_d_0)
      #MVA1 = self.functor1(**self.var_d_0)
      #MVA2 = self.functor2(**self.var_d_0)

      weight = 1.0
      if not self.is_data and not self.is_embed:

        mtracking = self.muTracking(newrow['mEta'])[0]
        tEff = self.triggerEff(newrow['mPt'], abs(newrow['mEta']))
        mID = self.muonTightID(newrow['mPt'], abs(newrow['mEta']))
        if newrow['tZTTGenMatching']==5:
          tID = 0.89
        else:
          tID = 1.0
        weight = newrow['GenWeight']*pucorrector(newrow['nTruePU'])*tEff*mID*mtracking*tID
        if self.is_DY:
          dyweight = self.DYreweight(newrow['genMass'], newrow['genpT'])
          weight = weight*dyweight#*0.00007357
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          dyweight = self.DYreweight1D(newrow['genpT']) 
          weight = weight*23.105*dyweight
        if self.is_GluGlu:
          weight = weight*0.000519
        if self.is_VBF:
          weight = weight*0.000214
        if self.is_WW:
          weight = weight*0.417
        if self.is_WZ:
          weight = weight*0.294
        if self.is_ZZ:
          weight = weight*0.261
        if self.is_EWKWMinus:
          weight = weight*0.191
        if self.is_EWKWPlus:
          weight = weight*0.246
        if self.is_EWKZToLL:
          weight = weight*0.185
        if self.is_EWKZToNuNu:
          weight = weight*0.142
        if self.is_ZHTT:
          weight = weight*0.000598
        if self.is_ttH:
          weight = weight*0.000118
        if self.is_Wminus:
          weight = weight*0.000670
        if self.is_Wplus:
          weight = weight*0.000636
        if self.is_STtantitop:
          weight = weight*0.922
        if self.is_STttop:
          weight = weight*0.952
        if self.is_STtWantitop:
          weight = weight*0.00545
        if self.is_STtWtop:
          weight = weight*0.00552
        if self.is_TTTo2L2Nu:
          weight = weight*0.00574
        if self.is_TTToHadronic:
          weight = weight*0.385
        if self.is_TTToSemiLeptonic:
          weight = weight*0.00118
        if self.is_VBFH:
          weight = weight*0.000864
        if self.is_GluGluH:
          weight = weight*0.000488
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

      if self.is_embed:
        weight = weight*newrow['GenWeight']

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and self.obj1_tight(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          #tIso = self.tauSF['loose']
        if self.oppositesign(newrow):
          self.fill_histos(MVA, weight*frTau*mIso*tIso, 'TauLooseOS')
          if newrow['vbfNJets30']==0:
            self.fill_histos(MVA, weight*frTau*mIso*tIso, 'TauLooseOS0Jet')
          elif newrow['vbfNJets30']==1:
            self.fill_histos(MVA, weight*frTau*mIso*tIso, 'TauLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550:
            self.fill_histos(MVA, weight*frTau*mIso*tIso, 'TauLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550:
            self.fill_histos(MVA, weight*frTau*mIso*tIso, 'TauLooseOS2JetVBF')

      if not self.obj1_tight(newrow) and self.obj1_loose(newrow) and self.obj2_tight(newrow):
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          #tIso = self.tauSF['tight']
        if self.oppositesign(newrow):
          self.fill_histos(MVA, weight*frMuon*mIso*tIso, 'MuonLooseOS')
          if newrow['vbfNJets30']==0:
            self.fill_histos(MVA, weight*frMuon*mIso*tIso, 'MuonLooseOS0Jet')
          elif newrow['vbfNJets30']==1:
            self.fill_histos(MVA, weight*frMuon*mIso*tIso, 'MuonLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550:
            self.fill_histos(MVA, weight*frMuon*mIso*tIso, 'MuonLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550:
            self.fill_histos(MVA, weight*frMuon*mIso*tIso, 'MuonLooseOS2JetVBF')

      if not self.obj2_tight(newrow) and self.obj2_loose(newrow) and not self.obj1_tight(newrow) and self.obj1_loose(newrow):
        frTau = self.fakeRate(newrow['tPt'], newrow['tEta'], newrow['tDecayMode'])
        frMuon = self.fakeRateMuon(newrow['mPt'])
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonLooseIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          #tIso = self.tauSF['loose']
        if self.oppositesign(newrow):
          self.fill_histos(MVA, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS')
          if newrow['vbfNJets30']==0:
            self.fill_histos(MVA, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS0Jet')
          elif newrow['vbfNJets30']==1:
            self.fill_histos(MVA, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550:
            self.fill_histos(MVA, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550:
            self.fill_histos(MVA, weight*frTau*frMuon*mIso*tIso, 'MuonLooseTauLooseOS2JetVBF')

      if self.obj2_tight(newrow) and self.obj1_tight(newrow):
        mIso = 1
        tIso = 1
        if not self.is_data and not self.is_embed:
          mIso = self.muonTightIsoTightID(newrow['mPt'], abs(newrow['mEta']))
          #tIso = self.tauSF['tight']
        if self.oppositesign(newrow):
          self.fill_histos(MVA, weight*mIso*tIso, 'TightOS')
          if newrow['vbfNJets30']==0:
            self.fill_histos(MVA, weight*mIso*tIso, 'TightOS0Jet')
          elif newrow['vbfNJets30']==1:
            self.fill_histos(MVA, weight*mIso*tIso, 'TightOS1Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] < 550:
            self.fill_histos(MVA, weight*mIso*tIso, 'TightOS2Jet')
          elif newrow['vbfNJets30']==2 and newrow['vbfMass'] > 550:
            self.fill_histos(MVA, weight*mIso*tIso, 'TightOS2JetVBF')


  def finish(self):
    self.write_histos()
