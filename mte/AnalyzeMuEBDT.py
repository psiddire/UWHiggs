'''

Run LFV H->MuTau analysis in the mu+tau channel.

Authors: Maria Cepeda, Aaron Levine, Evan K. Friis, UW

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import glob
import os
import ROOT
import array
import math
import copy
import operator
import itertools
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

def deltaEta(eta1, eta2):
  return abs(eta1 - eta2)
  
def deltaR(phi1, phi2, eta1, eta2):
  deta = eta1 - eta2
  dphi = abs(phi1-phi2)
  if (dphi>pi) : dphi = 2*pi-dphi
  return sqrt(deta*deta + dphi*dphi)

def visibleMass(row):
  vm = ROOT.TLorentzVector()
  ve = ROOT.TLorentzVector()
  vm.SetPtEtaPhiM(row['mPt'], row['mEta'], row['mPhi'], row['mMass'])
  ve.SetPtEtaPhiM(row['ePt'], row['eEta'], row['ePhi'], row['eMass'])
  return (vm+ve).M()

def collMass(row):
  met = row['type1_pfMetEt']
  metPhi = row['type1_pfMetPhi']
  ptnu = abs(met*math.cos(deltaPhi(metPhi, row['ePhi'])))
  visfrac = row['ePt']/(row['ePt']+ptnu)
  m_e_Mass = visibleMass(row)
  return (m_e_Mass/sqrt(visfrac))

def transverseMass(objPt, objEta, objPhi, objMass, MetEt, MetPhi):
  vobj = ROOT.TLorentzVector()
  vmet = ROOT.TLorentzVector()
  vobj.SetPtEtaPhiM(objPt, objEta, objPhi, objMass)
  vmet.SetPtEtaPhiM(MetEt, 0, MetPhi, 0)
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def topPtreweight(pt1, pt2):
  if pt1 > 400 : pt1 = 400
  if pt2 > 400 : pt2 = 400
  a = 0.0615
  b = -0.0005
  wt1 = math.exp(a + b * pt1)
  wt2 = math.exp(a + b * pt2)
  wt = sqrt(wt1 * wt2)
  return wt

if bool('DYJetsToLL_M-50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')
elif bool('DYJetsToLL_M-10to50' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY10')
elif bool('DY1JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY1')
elif bool('DY2JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY2')
elif bool('DY3JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY3')
elif bool('DY4JetsToLL' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY4')
elif bool('TTTo2L2Nu' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTTo2L2Nu')
elif bool('TTToHadronic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToHadronic')
elif bool('TTToSemiLeptonic' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'TTToSemiLeptonic')
elif bool('VBF_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'VBFHMT')
elif bool('GluGlu_LFV_HToMuTau' in target):
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'GGHMT')
else:
  pucorrector = mcCorrections.make_puCorrector('singlem', None, 'DY')

class AnalyzeMuEBDT(MegaBase):
  tree = 'em/final/Ntuple'
  
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
    self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
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
    self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_W)
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b 
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.branches="mPt/F:ePt/F:m_e_collinearMass/F:dPhiMuMET/F:dPhiEMET/F:dPhiMuE/F:MTMuMET/F:MTEMET/F:weight/F"
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name="TreeS"
      self.title="TreeS"
    else:
      self.name="TreeB"
      self.title="TreeB"

    super(AnalyzeMuEBDT, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}

    self.w2 = mcCorrections.w2
    self.we = mcCorrections.we

    self.DYweight = {
      0 : 2.666650438,
      1 : 0.465803642,
      2 : 0.585042564,
      3 : 0.609127575,
      4 : 0.419146762
      }

    self.Wweight = {
      0 : 33.17540884,
      1 : 7.148659335,
      2 : 14.08112642,
      3 : 2.308770158,
      4 : 2.072164726
      }

  def oppositesign(self, row):
    if row['mCharge']*row['eCharge']!=-1:
      return False
    return True


  def trigger(self, row):
    if not row['IsoMu27Pass']:
      return False
    return True


  def kinematics(self, row):
    if row['mPt'] < 28 or abs(row['mEta']) >= 2.4:#2.1
      return False
    if row['ePt'] < 10 or abs(row['eEta']) >= 2.4:# bool(abs(row['eEta']) >= 2.3 or bool(abs(row['eEta']) > 1.4442 and abs(row['eEta']) < 1.566)):
      return False
    return True


  def vetos(self, row):
    return (bool(row['eVetoMVAIso'] < 0.5) and bool(row['tauVetoPt20TightMVALTVtx'] < 0.5) and bool(row['muGlbIsoVetoPt10'] < 0.5))


  def obj1_id(self, row):
    return (bool(row['mPFIDTight']) and bool(abs(row['mPVDZ']) < 0.2) and bool(abs(row['mPVDXY']) < 0.045))
  

  def obj1_iso(self, row):
    return bool(row['mRelPFIsoDBDefaultR04'] < 0.15)
    

  def obj2_iso(self, row):
    return bool(row['eRelPFIsoRho'] < 0.1)


  def obj2_id(self, row):
    return (bool(row['eMVANoisoWP80']) and bool(abs(row['ePVDZ']) < 0.2) and bool(abs(row['ePVDXY']) < 0.045) and bool(row['ePassesConversionVeto']) and bool(row['eMissingHits'] < 2))


  def bjetveto(self, row):
    return bool(row['bjetDeepCSVVeto30MediumWoNoisyJets'] < 0.5)


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
      elif varname=="ePt":
        holder[0] = row['ePt']
      elif varname=="m_e_collinearMass":
        holder[0] = collMass(row)
      elif varname=="dPhiMuMET":
        holder[0] = deltaPhi(row['mPhi'], row['type1_pfMetPhi'])
      elif varname=="dPhiEMET":
        holder[0] = deltaPhi(row['ePhi'], row['type1_pfMetPhi'])
      elif varname=="dPhiMuE":
        holder[0] = deltaPhi(row['ePhi'], row['mPhi'])
      elif varname=="MTMuMET":
        holder[0] = transverseMass(row['mPt'], row['mEta'], row['mPhi'], row['mMass'], row['type1_pfMetEt'], row['type1_pfMetPhi'])
      elif varname=="MTEMET":
        holder[0] = transverseMass(row['ePt'], row['eEta'], row['ePhi'], row['eMass'], row['type1_pfMetEt'], row['type1_pfMetPhi'])
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()


  def copyrow(self, row):
    subtemp = {}
    tmpMetEt = row.type1_pfMetEt
    tmpMetPhi = row.type1_pfMetPhi

    if self.is_recoilC and MetCorrection:
      tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
      tmpMetEt = math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1])
      tmpMetPhi = math.atan2(tmpMet[1], tmpMet[0])

    subtemp["type1_pfMetEt"] = tmpMetEt
    subtemp["type1_pfMetPhi"] = tmpMetPhi

    if self.is_DY or self.is_DYlow:
      subtemp["isZmumu"] = row.isZmumu
      subtemp["isZee"] = row.isZee

    subtemp["ePt"] = row.ePt
    subtemp["eEta"] = row.eEta
    subtemp["ePhi"] = row.ePhi
    subtemp["eMass"] = row.eMass
    subtemp["eCharge"] = row.eCharge
    subtemp["mPt"] = row.mPt
    subtemp["mEta"] = row.mEta
    subtemp["mPhi"] = row.mPhi
    subtemp["mMass"] = row.mMass
    subtemp["mCharge"] = row.mCharge
    subtemp['IsoMu27Pass'] = row.IsoMu27Pass
    subtemp["mPFIDTight"] = row.mPFIDTight
    subtemp["mPFIDMedium"] = row.mPFIDMedium
    subtemp["mRelPFIsoDBDefaultR04"] = row.mRelPFIsoDBDefaultR04
    subtemp["numGenJets"] = row.numGenJets
    subtemp["nTruePU"] = row.nTruePU
    subtemp["GenWeight"] = row.GenWeight
    subtemp["eVetoMVAIso"] = row.eVetoMVAIso
    subtemp["tauVetoPt20TightMVALTVtx"] = row.tauVetoPt20TightMVALTVtx
    subtemp["muGlbIsoVetoPt10"] = row.muGlbIsoVetoPt10
    subtemp["eMVANoisoWP80"] = row.eMVANoisoWP80
    subtemp["eMVANoisoWP90"] = row.eMVANoisoWP90
    subtemp["eRelPFIsoRho"] = row.eRelPFIsoRho
    subtemp["ePVDZ"] = row.ePVDZ
    subtemp["mPVDZ"] = row.mPVDZ
    subtemp["ePVDXY"] = row.ePVDXY
    subtemp["mPVDXY"] = row.mPVDXY
    subtemp["ePassesConversionVeto"] = row.ePassesConversionVeto
    subtemp["eMissingHits"] = row.eMissingHits
    subtemp["jetVeto30"] = row.jetVeto30
    subtemp["jetVeto30WoNoisyJets"] = row.jetVeto30WoNoisyJets
    subtemp["nvtx"] = row.nvtx
    subtemp["evt"] = row.evt
    subtemp["lumi"] = row.lumi
    subtemp["run"] = row.run
    subtemp["bjetDeepCSVVeto30Medium"] = row.bjetDeepCSVVeto30Medium
    subtemp["bjetDeepCSVVeto20MediumWoNoisyJets"] = row.bjetDeepCSVVeto20MediumWoNoisyJets
    subtemp["jb1pt"] = row.jb1pt
    subtemp["jb1hadronflavor"] = row.jb1hadronflavor
    subtemp["jb1eta"] = row.jb1eta
    subtemp["genMass"] = row.genMass
    subtemp["genpT"] = row.genpT
    subtemp["topQuarkPt1"] = row.topQuarkPt1
    subtemp["topQuarkPt2"] = row.topQuarkPt2
    subtemp["Flag_goodVertices"] = row.Flag_goodVertices
    subtemp["Flag_globalTightHalo2016Filter"] = row.Flag_globalTightHalo2016Filter
    subtemp["Flag_HBHENoiseFilter"] = row.Flag_HBHENoiseFilter
    subtemp["Flag_HBHENoiseIsoFilter"] = row.Flag_HBHENoiseIsoFilter
    subtemp["Flag_EcalDeadCellTriggerPrimitiveFilter"] = row.Flag_EcalDeadCellTriggerPrimitiveFilter
    subtemp["Flag_BadPFMuonFilter"] = row.Flag_BadPFMuonFilter
    subtemp["Flag_BadChargedCandidateFilter"] = row.Flag_BadChargedCandidateFilter
    subtemp["Flag_eeBadScFilter"] = row.Flag_eeBadScFilter
    subtemp["Flag_ecalBadCalibFilter"] = row.Flag_ecalBadCalibFilter
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

      if deltaR(nrow['ePhi'], nrow['mPhi'], nrow['eEta'], nrow['mEta']) < 0.3:
        continue

      if nrow['jetVeto30WoNoisyJets'] > 2:
        continue

      if not self.obj1_id(nrow):
        continue

      if not self.obj2_id(nrow):
        continue

      if not self.vetos(nrow):
        continue

      if self.is_DY or self.is_DYlow:
        if not bool(nrow['isZmumu'] or nrow['isZee']):
          continue

      nbtag = nrow['bjetDeepCSVVeto20MediumWoNoisyJets']
      bpt_1 = nrow['jb1pt']
      bflavor_1 = nrow['jb1hadronflavor']
      beta_1 = nrow['jb1eta']
      if (not self.is_data and not self.is_embed and nbtag > 0):
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
            x[i]=temp[i]["mRelPFIsoDBDefaultR04"]
            y[i]=temp[i]["mPt"]
            z[i]=temp[i]["eRelPFIsoRho"]
            w[i]=temp[i]["ePt"]
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
      if not self.is_data and not self.is_embed:

        self.w2.var("m_pt").setVal(newrow['mPt'])
        self.w2.var("m_eta").setVal(newrow['mEta'])
        mIso = self.w2.function("m_iso_kit_ratio").getVal()
        mID = self.w2.function("m_id_kit_ratio").getVal()
        tEff = self.w2.function("m_trg27_kit_data").getVal()/self.w2.function("m_trg27_kit_mc").getVal()
        self.w2.var("e_pt").setVal(newrow['ePt'])
        self.w2.var("e_eta").setVal(newrow['eEta'])
        eIso = self.w2.function("e_iso_kit_ratio").getVal()
        eID = self.w2.function("e_id80_kit_ratio").getVal()       
        eTrk = self.w2.function("e_trk_ratio").getVal()
        weight = weight*newrow['GenWeight']*pucorrector(newrow['nTruePU'])*tEff*mID*mIso*eID*eIso*eTrk

        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(newrow['genMass'])
          self.w2.var("z_gen_pt").setVal(newrow['genpT'])
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if newrow['numGenJets'] < 5:
            weight = weight*self.DYweight[newrow['numGenJets']]*dyweight
          else:
            weight = weight*self.DYweight[0]*dyweight
        if self.is_DYlow:
          self.w2.var("z_gen_mass").setVal(newrow['genMass'])
          self.w2.var("z_gen_pt").setVal(newrow['genpT'])
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*11.47563472*dyweight
        if self.is_GluGlu:
          weight = weight*0.005
        if self.is_VBF:
          weight = weight*0.00214
        if self.is_TTTo2L2Nu:
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.0057*topweight
        if self.is_TTToHadronic:
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.379*topweight
        if self.is_TTToSemiLeptonic:
          topweight = topPtreweight(newrow['topQuarkPt1'], newrow['topQuarkPt2'])
          weight = weight*0.00117*topweight

      if self.is_embed:
        self.we.var("gt_pt").setVal(newrow['mPt'])
        self.we.var("gt_eta").setVal(newrow['mEta'])
        msel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt_pt").setVal(newrow['ePt'])
        self.we.var("gt_eta").setVal(newrow['eEta'])
        esel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt1_pt").setVal(newrow['mPt'])
        self.we.var("gt1_eta").setVal(newrow['mEta'])
        self.we.var("gt2_pt").setVal(newrow['ePt'])
        self.we.var("gt2_eta").setVal(newrow['eEta'])
        trgsel = self.we.function("m_sel_trg_ratio").getVal()
        self.we.var("m_pt").setVal(newrow['mPt'])
        self.we.var("m_eta").setVal(newrow['mEta'])
        self.we.var("m_iso").setVal(newrow['mRelPFIsoDBDefaultR04'])
        m_iso_sf = self.we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_id_sf = self.we.function("m_id_embed_kit_ratio").getVal()
        m_trg_sf = self.we.function("m_trg27_embed_kit_ratio").getVal()
        self.we.var("e_pt").setVal(newrow['ePt'])
        self.we.var("e_eta").setVal(newrow['eEta'])
        self.we.var("e_iso").setVal(newrow['eRelPFIsoRho'])
        e_iso_sf = self.we.function("e_iso_binned_embed_kit_ratio").getVal()
        e_id_sf = self.we.function("e_id80_embed_kit_ratio").getVal()
        weight = weight*newrow['GenWeight']*m_trg_sf*m_id_sf*m_iso_sf*msel*esel*trgsel*e_id_sf*e_iso_sf

      if self.obj2_iso(newrow) and self.obj1_iso(newrow):
        if self.oppositesign(newrow):
          self.filltree(newrow, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
