'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import ETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = True

class AnalyzeETau(MegaBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
    self.tauSF = mcCorrections.tauSF

    self.eReco = mcCorrections.eReco
    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateEle = mcCorrections.fakerateElectron_weight
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.wp = mcCorrections.wp
    self.EmbedEta = mcCorrections.EmbedEta
    self.EmbedPt = mcCorrections.EmbedPt
    self.DrellPt = mcCorrections.DrellPt

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight

    super(AnalyzeETau, self).__init__(tree, outfile, **kwargs)
    self.tree = ETauTree.ETauTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.eCharge*row.tCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.ePt < 25 or abs(row.eEta) >= 2.1:
      return False
    if row.tPt < 30 or abs(row.tEta) >= 2.3:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def obj1_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj1_tight(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def obj1_loose(self, row):
    return bool(row.eRelPFIsoRho < 0.5)


  def obj2_id(self, row):
    return (bool(row.tDecayModeFinding > 0.5) and bool(row.tAgainstElectronTightMVA6 > 0.5) and bool(row.tAgainstMuonLoose3 > 0.5) and bool(abs(row.tPVDZ) < 0.2))


  def obj2_tight(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTTight > 0.5)


  def obj2_loose(self, row):
    return bool(row.tRerunMVArun2v2DBoldDMwLTLoose > 0.5)


  def dieleveto(self, row):
    return bool(row.dielectronVeto < 0.5)


  def begin(self):
    names=['TauLooseWOS', 'TauLooseOS', 'TauLooseSS', 'EleLooseWOS', 'EleLooseOS', 'EleLooseSS', 'EleLooseTauLooseWOS', 'EleLooseTauLooseOS', 'EleLooseTauLooseSS', 'TightWOS', 'TightOS', 'TightSS', 'TauLooseWOS0Jet', 'TauLooseOS0Jet', 'TauLooseSS0Jet', 'EleLooseWOS0Jet', 'EleLooseOS0Jet', 'EleLooseSS0Jet', 'EleLooseTauLooseWOS0Jet', 'EleLooseTauLooseOS0Jet', 'EleLooseTauLooseSS0Jet', 'TightWOS0Jet', 'TightOS0Jet', 'TightSS0Jet', 'TauLooseWOS1Jet', 'TauLooseOS1Jet', 'TauLooseSS1Jet', 'EleLooseWOS1Jet', 'EleLooseOS1Jet', 'EleLooseSS1Jet', 'EleLooseTauLooseWOS1Jet', 'EleLooseTauLooseOS1Jet', 'EleLooseTauLooseSS1Jet', 'TightWOS1Jet', 'TightOS1Jet', 'TightSS1Jet', 'TauLooseWOS2Jet', 'TauLooseOS2Jet', 'TauLooseSS2Jet', 'EleLooseWOS2Jet', 'EleLooseOS2Jet', 'EleLooseSS2Jet', 'EleLooseTauLooseWOS2Jet', 'EleLooseTauLooseOS2Jet', 'EleLooseTauLooseSS2Jet', 'TightWOS2Jet', 'TightOS2Jet', 'TightSS2Jet']
    vbfnames=['TauLooseWOS2JetVBF', 'TauLooseOS2JetVBF', 'TauLooseSS2JetVBF', 'EleLooseWOS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseSS2JetVBF', 'EleLooseTauLooseWOS2JetVBF', 'EleLooseTauLooseOS2JetVBF', 'EleLooseTauLooseSS2JetVBF', 'TightWOS2JetVBF', 'TightOS2JetVBF', 'TightSS2JetVBF']
    namesize = len(names)
    for x in range(0, namesize):
      self.book(names[x], "ePt", "Electron  Pt", 20, 0, 200)
      self.book(names[x], "tPt", "Tau Pt", 20, 0, 200)
      self.book(names[x], "eEta", "Electron Eta", 20, -3, 3)
      self.book(names[x], "tEta", "Tau Eta", 20, -3, 3)
      self.book(names[x], "ePhi", "Electron Phi", 20, -4, 4)
      self.book(names[x], "tPhi", "Tau Phi", 20, -4, 4)
      self.book(names[x], "type1_pfMetEt", "Type1 MET Et", 20, 0, 200)
      self.book(names[x], "type1_pfMetPhi", "Type1 MET Phi", 20, -4, 4)
      self.book(names[x], "j1Pt", "Jet 1 Pt", 30, 0, 300)
      self.book(names[x], "j2Pt", "Jet 2 Pt", 30, 0, 300)
      self.book(names[x], "j1Eta", "Jet 1 Eta", 20, -3, 3)
      self.book(names[x], "j2Eta", "Jet 2 Eta", 20, -3, 3)
      self.book(names[x], "j1Phi", "Jet 1 Phi", 20, -4, 4)
      self.book(names[x], "j2Phi", "Jet 2 Phi", 20, -4, 4)
      self.book(names[x], "e_t_Mass", "Electron + Tau Mass", 30, 0, 300)
      self.book(names[x], "e_t_CollinearMass", "Electron + Tau Collinear Mass", 30, 0, 300)
      self.book(names[x], "e_t_PZeta", "Electron + Tau PZeta", 80, -400, 400)
      self.book(names[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(names[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(names[x], "vbfMass", "VBF Mass", 100, 0, 1000)
      self.book(names[x], "dEtaETau", "Delta Eta E Tau", 50, 0, 5)
      self.book(names[x], "dPhiEMET", "Delta Phi E MET", 40, 0, 4)
      self.book(names[x], "dPhiTauMET", "Delta Phi Tau MET", 40, 0, 4)
      self.book(names[x], "dPhiETau", "Delta Phi E Tau", 40, 0, 4)
      self.book(names[x], "MTEMET", "Electron MET Transverse Mass", 20, 0, 200)
      self.book(names[x], "MTTauMET", "Tau MET Transverse Mass", 20, 0, 200)

    vbfnamesize = len(vbfnames)
    for x in range(0, vbfnamesize):
      self.book(vbfnames[x], "ePt", "Electron  Pt", 10, 0, 200)
      self.book(vbfnames[x], "tPt", "Tau Pt", 10, 0, 200)
      self.book(vbfnames[x], "eEta", "Electron Eta", 10, -3, 3)
      self.book(vbfnames[x], "tEta", "Tau Eta", 10, -3, 3)
      self.book(vbfnames[x], "ePhi", "Electron Phi", 10, -4, 4)
      self.book(vbfnames[x], "tPhi", "Tau Phi", 10, -4, 4)
      self.book(vbfnames[x], "type1_pfMetEt", "Type1 MET Et", 10, 0, 200)
      self.book(vbfnames[x], "type1_pfMetPhi", "Type1 MET Phi", 10, -4, 4)
      self.book(vbfnames[x], "j1Pt", "Jet 1 Pt", 15, 0, 300)
      self.book(vbfnames[x], "j2Pt", "Jet 2 Pt", 15, 0, 300)
      self.book(vbfnames[x], "j1Eta", "Jet 1 Eta", 10, -3, 3)
      self.book(vbfnames[x], "j2Eta", "Jet 2 Eta", 10, -3, 3)
      self.book(vbfnames[x], "j1Phi", "Jet 1 Phi", 10, -4, 4)
      self.book(vbfnames[x], "j2Phi", "Jet 2 Phi", 10, -4, 4)
      self.book(vbfnames[x], "e_t_Mass", "Electron + Tau Mass", 15, 0, 300)
      self.book(vbfnames[x], "e_t_CollinearMass", "Electron + Tau Collinear Mass", 15, 0, 300)
      self.book(vbfnames[x], "e_t_PZeta", "Electron + Tau PZeta", 40, -400, 400)
      self.book(vbfnames[x], "numOfJets", "Number of Jets", 5, 0, 5)
      self.book(vbfnames[x], "numOfVtx", "Number of Vertices", 100, 0, 100)
      self.book(vbfnames[x], "vbfMass", "VBF Mass", 50, 0, 1000)
      self.book(vbfnames[x], "dEtaETau", "Delta Eta E Tau", 20, 0, 5)
      self.book(vbfnames[x], "dPhiEMET", "Delta Phi E MET", 10, 0, 4)
      self.book(vbfnames[x], "dPhiTauMET", "Delta Phi Tau MET", 10, 0, 4)
      self.book(vbfnames[x], "dPhiETau", "Delta Phi E Tau", 10, 0, 4)
      self.book(vbfnames[x], "MTEMET", "Electron MET Transverse Mass", 10, 0, 200)
      self.book(vbfnames[x], "MTTauMET", "Tau MET Transverse Mass", 10, 0, 200)


  def fill_histos(self, row, myEle, myMET, myTau, weight, name=''):
    histos = self.histograms
    histos[name+'/ePt'].Fill(myEle.Pt(), weight)
    histos[name+'/tPt'].Fill(myEle.Pt(), weight)
    histos[name+'/eEta'].Fill(myEle.Eta(), weight)
    histos[name+'/tEta'].Fill(myTau.Eta(), weight)
    histos[name+'/ePhi'].Fill(myEle.Phi(), weight)
    histos[name+'/tPhi'].Fill(myTau.Phi(), weight)
    histos[name+'/type1_pfMetEt'].Fill(myMET.Et(), weight)
    histos[name+'/type1_pfMetPhi'].Fill(myMET.Phi(), weight)
    histos[name+'/j1Pt'].Fill(row.j1ptWoNoisyJets, weight)
    histos[name+'/j2Pt'].Fill(row.j2ptWoNoisyJets, weight)
    histos[name+'/j1Eta'].Fill(row.j1etaWoNoisyJets, weight)
    histos[name+'/j2Eta'].Fill(row.j2etaWoNoisyJets, weight)
    histos[name+'/j1Phi'].Fill(row.j1phiWoNoisyJets, weight)
    histos[name+'/j2Phi'].Fill(row.j2phiWoNoisyJets, weight)
    histos[name+'/e_t_Mass'].Fill(self.visibleMass(myEle, myTau), weight)
    histos[name+'/e_t_CollinearMass'].Fill(self.collMass(myEle, myMET, myTau), weight)
    histos[name+'/e_t_PZeta'].Fill(row.e_t_PZeta, weight)
    histos[name+'/numOfJets'].Fill(row.jetVeto30WoNoisyJets, weight)
    histos[name+'/numOfVtx'].Fill(row.nvtx, weight)
    histos[name+'/vbfMass'].Fill(row.vbfMassWoNoisyJets, weight)
    histos[name+'/dEtaETau'].Fill(self.deltaEta(myEle.Eta(), myTau.Eta()), weight)
    histos[name+'/dPhiEMET'].Fill(self.deltaPhi(myEle.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiTauMET'].Fill(self.deltaPhi(myTau.Phi(), myMET.Phi()), weight)
    histos[name+'/dPhiETau'].Fill(self.deltaPhi(myEle.Phi(), myTau.Phi()), weight)
    histos[name+'/MTEMET'].Fill(self.transverseMass(myEle, myMET), weight)
    histos[name+'/MTTauMET'].Fill(self.transverseMass(myTau, myMET), weight)


  def tauPtC(self, row, myMET, myTau):
    tmpMET = myMET
    tmpTau = myTau
    if self.is_mc and (not self.is_DY) and row.tZTTGenMatching==5:
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.007 * myTau.Px()
        myMETpy = myMET.Py() - 0.007 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.007)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() + 0.002 * myTau.Px()
        myMETpy = myMET.Py() + 0.002 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(0.998)
      elif row.tDecayMode == 10:
        myMETpx = myMET.Px() - 0.001 * myTau.Px()
        myMETpy = myMET.Py() - 0.001 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.001)
    if self.is_mc and bool(row.tZTTGenMatching==1 or row.tZTTGenMatching==3):
      if row.tDecayMode == 0:
        myMETpx = myMET.Px() - 0.003 * myTau.Px()
        myMETpy = myMET.Py() - 0.003 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.003)
      elif row.tDecayMode == 1:
        myMETpx = myMET.Px() - 0.036 * myTau.Px()
        myMETpy = myMET.Py() - 0.036 * myTau.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        tmpTau = myTau * ROOT.Double(1.036)
    return [tmpMET, tmpTau]


  def process(self):

    for row in self.tree:

      trigger27 = row.Ele27WPTightPass and row.eMatchesEle27Filter and row.eMatchesEle27Path and row.ePt > 28
      trigger32 = row.Ele32WPTightPass and row.eMatchesEle32Filter and row.eMatchesEle32Path and row.ePt > 33
      trigger35 = row.Ele35WPTightPass and row.eMatchesEle35Filter and row.eMatchesEle35Path and row.ePt > 36
      if self.is_embed:
        trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1
      else:
        trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1

      if self.filters(row):
        continue

      if not bool(trigger27 or trigger32 or trigger35 or trigger2430):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.tPhi, row.eEta, row.tEta) < 0.5:
        continue

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue

      if not self.dieleveto(row):
        continue

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)

      myTau = ROOT.TLorentzVector()
      myTau.SetPtEtaPhiM(row.tPt, row.tEta, row.tPhi, row.tMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      if self.is_mc:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()

      if self.is_data or self.is_mc:
        myEle = myEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)

      if self.is_mc:
        myMETpx = myMETpx - myEle.Px()
        myMETpy = myMETpy - myEle.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))

      if self.is_recoilC and MetCorrection:
        tmpMet = self.Metcorected.CorrectByMeanResolution(row.type1_pfMetEt*math.cos(row.type1_pfMetPhi), row.type1_pfMetEt*math.sin(row.type1_pfMetPhi), row.genpX, row.genpY, row.vispX, row.vispY, int(round(row.jetVeto30WoNoisyJets)))
        myMET.SetPtEtaPhiM(math.sqrt(tmpMet[0]*tmpMet[0] + tmpMet[1]*tmpMet[1]), 0, math.atan2(tmpMet[1], tmpMet[0]), 0)

      myMET = self.tauPtC(row, myMET, myTau)[0]
      myTau = self.tauPtC(row, myMET, myTau)[1]

      weight = 1.0
      singleSF = 0
      eltauSF = 0
      if self.is_mc:
        self.w2.var("e_pt").setVal(myEle.Pt())
        self.w2.var("e_iso").setVal(row.eRelPFIsoRho)
        self.w2.var("e_eta").setVal(myEle.Eta())
        eID = self.w2.function("e_id80_kit_ratio").getVal()
        eIso = self.w2.function("e_iso_kit_ratio").getVal()
        eReco = self.w2.function("e_trk_ratio").getVal()
        zvtx = 0.991
        if trigger27 or trigger32 or trigger35:
          singleSF = 0 if self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()==0 else self.w2.function("e_trg27_trg32_trg35_kit_data").getVal()/self.w2.function("e_trg27_trg32_trg35_kit_mc").getVal()
        else:
          eltauSF = 0 if self.w2.function("e_trg_EleTau_Ele24Leg_desy_mc").getVal()==0 else self.w2.function("e_trg_EleTau_Ele24Leg_desy_data").getVal()/self.w2.function("e_trg_EleTau_Ele24Leg_desy_mc").getVal()
          eltauSF = eltauSF * self.tauSF.getETauScaleFactor(myTau.Pt(), myTau.Eta(), myTau.Phi())
        tEff = singleSF + eltauSF
        weight = row.GenWeight*pucorrector[''](row.nTruePU)*tEff*eID*eIso*eReco*zvtx*row.prefiring_weight
        if row.tZTTGenMatching==2 or row.tZTTGenMatching==4:
          if abs(myTau.Eta()) < 0.4:
            weight = weight*1.06
          elif abs(myTau.Eta()) < 0.8:
            weight = weight*1.02
          elif abs(myTau.Eta()) < 1.2:
            weight = weight*1.10
          elif abs(myTau.Eta()) < 1.7:
            weight = weight*1.03
          else:
            weight = weight*1.94
        elif row.tZTTGenMatching==1 or row.tZTTGenMatching==3:
          if abs(myTau.Eta()) < 1.46:
            weight = weight*1.80
          elif abs(myTau.Eta()) > 1.558:
            weight = weight*1.53
        elif row.tZTTGenMatching==5:
          weight = weight*0.89
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight#*self.DrellPt(myEle.Pt())
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and row.tZTTGenMatching > 2 and row.tZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = row.vbfMassWoNoisyJets

      trsel = 0
      if self.is_embed:
        tID = 0.97
        if row.tDecayMode == 0:
          dm = 0.975
        elif row.tDecayMode == 1:
          dm = 0.975*1.051
        elif row.tDecayMode == 10:
          dm = pow(0.975, 3)
        self.we.var("gt_pt").setVal(myEle.Pt())
        self.we.var("gt_eta").setVal(myEle.Eta())
        esel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt_pt").setVal(myTau.Pt())
        self.we.var("gt_eta").setVal(myTau.Eta())
        tsel = self.we.function("m_sel_idEmb_ratio").getVal()
        self.we.var("gt1_pt").setVal(myEle.Pt())
        self.we.var("gt1_eta").setVal(myEle.Eta())
        self.we.var("gt2_pt").setVal(myTau.Pt())
        self.we.var("gt2_eta").setVal(myTau.Eta())
        trgsel = self.we.function("m_sel_trg_ratio").getVal()
        self.wp.var("e_pt").setVal(myEle.Pt())
        self.wp.var("e_eta").setVal(myEle.Eta())
        self.wp.var("e_phi").setVal(myEle.Phi())
        self.wp.var("e_iso").setVal(row.eRelPFIsoRho)
        e_id_sf = self.wp.function("e_id80_embed_kit_ratio").getVal()
        e_iso_sf = self.wp.function("e_iso_binned_embed_kit_ratio").getVal()
        e_trk_sf = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        self.we.var("e_pt").setVal(myEle.Pt())
        self.we.var("e_iso").setVal(row.eRelPFIsoRho)
        self.we.var("e_eta").setVal(myEle.Eta())
        self.we.var("t_pt").setVal(myTau.Pt())
        if myEle.Eta() < 1.479:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function("e_trg27_trg32_trg35_embed_kit_ratio").getVal()
          if trigger2430:
            trsel = trsel + self.we.function("e_trg_EleTau_Ele24Leg_kit_ratio_embed").getVal()*self.we.function("et_emb_LooseChargedIsoPFTau30_kit_ratio").getVal()
        else:
          if bool(trigger27 or trigger32 or trigger35):
            trsel = trsel + self.we.function("e_trg27_trg32_trg35_kit_data").getVal()
          if trigger2430:
            trsel = trsel + self.we.function("e_trg_EleTau_Ele24Leg_desy_data").getVal()*self.tauSF.getETauEfficiencyData(myTau.Pt(), myTau.Eta(), myTau.Phi())
        weight = weight*row.GenWeight*e_id_sf*e_iso_sf*dm*esel*tsel*trgsel*trsel*self.EmbedEta(myEle.Eta())*self.EmbedPt(myEle.Pt(), njets, mjj)
        if weight > 10:
          continue

      if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        weight = weight*frTau
        if self.oppositesign(row):
          if self.transverseMass(myEle, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseWOS')
              if njets==0:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseWOS1Jet')
              elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseWOS2Jet')
              elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseWOS2JetVBF')
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS1Jet')
          elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS2Jet')
          elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseSS')
          if njets==0:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseSS0Jet')
          elif njets==1:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseSS1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseSS2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TauLooseSS2JetVBF')

      if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle
        if self.oppositesign(row):
          if self.transverseMass(myEle, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseWOS')
              if njets==0:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseWOS1Jet')
              elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseWOS2Jet')
              elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseWOS2JetVBF')
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS1Jet')
          elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS2Jet')
          elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseSS')
          if njets==0:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseSS0Jet')
          elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseSS1Jet')
          elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseSS2Jet')
          elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseSS2JetVBF')

      if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
        frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
        frEle = self.fakeRateEle(myEle.Pt())
        weight = weight*frEle*frTau
        if self.oppositesign(row):
          if self.transverseMass(myEle, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseWOS')
              if njets==0:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseWOS1Jet')
              elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseWOS2Jet')
              elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseWOS2JetVBF')
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS1Jet')
          elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS2Jet')
          elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseSS')
          if njets==0:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseSS0Jet')
          elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseSS1Jet')
          elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseSS2Jet')
          elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'EleLooseTauLooseSS2JetVBF')

      if self.obj2_tight(row) and self.obj1_tight(row):
        if self.oppositesign(row):
          if self.transverseMass(myEle, myMET) > 60:
            if self.transverseMass(myTau, myMET) > 80:
              self.fill_histos(row, myEle, myMET, myTau, weight, 'TightWOS')
              if njets==0:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TightWOS0Jet')
              elif njets==1:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TightWOS1Jet')
              elif njets==2 and mjj < 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TightWOS2Jet')
              elif njets==2 and mjj > 500:
                self.fill_histos(row, myEle, myMET, myTau, weight, 'TightWOS2JetVBF')
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS')
          if njets==0 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS0Jet')
          elif njets==1 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS1Jet')
          elif njets==2 and mjj < 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS2Jet')
          elif njets==2 and mjj > 500 and self.transverseMass(myTau, myMET) < 60:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightOS2JetVBF')
        if not self.oppositesign(row):
          self.fill_histos(row, myEle, myMET, myTau, weight, 'TightSS')
          if njets==0:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightSS0Jet')
          elif njets==1:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightSS1Jet')
          elif njets==2 and mjj < 500:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightSS2Jet')
          elif njets==2 and mjj > 500:
            self.fill_histos(row, myEle, myMET, myTau, weight, 'TightSS2JetVBF')


  def finish(self):
    self.write_histos()
