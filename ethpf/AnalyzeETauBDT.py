'''

Run LFV H->ETau analysis in the e+tau_h channel.

Authors: Prasanna Siddireddy

'''

import ETauTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import array
import mcCorrections
import mcWeights
import Kinematics

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target)
Emb = False

class AnalyzeETauBDT(MegaBase):
  tree = 'et/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_GluGlu = self.mcWeight.is_GluGlu
    self.is_VBF = self.mcWeight.is_VBF

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
    self.tauSF = mcCorrections.tauSF

    self.fakeRate = mcCorrections.fakerate_weight
    self.fakeRateEle = mcCorrections.fakerateElectron_weight
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we

    self.DYweight = self.mcWeight.DYweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.invert_case = Kinematics.invert_case

    self.branches="ePt/F:tPt/F:dPhiETau/F:dEtaETau/F:dPhiEMET/F:dPhiTauMET/F:e_t_collinearMass/F:e_t_visibleMass/F:e_t_PZeta/F:MTTauMET/F:MTEMET/F:type1_pfMetEt/F:njets/I:vbfMass/F:weight/F"
    self.holders = []
    if self.is_GluGlu or self.is_VBF:
      self.name="TreeS"
      self.title="TreeS"
    else:
      self.name="TreeB"
      self.title="TreeB"

    super(AnalyzeETauBDT, self).__init__(tree, outfile, **kwargs)
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
    branch_names = self.branches.split(':')
    self.tree1 = ROOT.TTree(self.name, self.title)
    for name in branch_names:
      try:
        varname, vartype = tuple(name.split('/'))
      except:
        raise ValueError('Problem parsing %s' % name)
      inverted_type = self.invert_case(vartype.rsplit("_", 1)[0])
      self.holders.append((varname, array.array(inverted_type, [0])))
    for name, varinfo in zip(branch_names, self.holders):
      varname, holder = varinfo
      self.tree1.Branch(varname, holder, name)


  def filltree(self, row, myEle, myMET, myTau, njets, weight):
    for varname, holder in self.holders:
      if varname=="ePt":
        holder[0] = myEle.Pt()
      elif varname=="tPt":
        holder[0] = myTau.Pt()
      elif varname=="dPhiETau":
        holder[0] = self.deltaPhi(myEle.Phi(), myTau.Phi())
      elif varname=="dEtaETau":
        holder[0] = self.deltaEta(myEle.Eta(), myTau.Eta())
      elif varname=="dPhiEMET":
        holder[0] = self.deltaPhi(myEle.Phi(), myMET.Phi())
      elif varname=="dPhiTauMET":
        holder[0] = self.deltaPhi(myTau.Eta(), myMET.Eta())
      elif varname=="e_t_collinearMass":
        holder[0] = self.collMass(myEle, myMET, myTau)
      elif varname=="e_t_visibleMass":
        holder[0] = self.visibleMass(myEle, myTau)
      elif varname=="e_t_PZeta":
        holder[0] = row.e_t_PZeta
      elif varname=="MTTauMET":
        holder[0] = self.transverseMass(myTau, myMET)
      elif varname=="MTEMET":
        holder[0] = self.transverseMass(myEle, myMET)
      elif varname=="type1_pfMetEt":
        holder[0] = myMET.Pt()
      elif varname=="njets":
        holder[0] = int(njets)
      elif varname=="vbfMass":
        holder[0] = row.vbfMassWoNoisyJets
      elif varname=="weight":
        holder[0] = weight
    self.tree1.Fill()


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
        trigger2430 = row.Ele24Tau30Pass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1
      else:
        trigger2430 = row.Ele24LooseTau30TightIDPass and row.eMatchesEle24Tau30Filter and row.eMatchesEle24Tau30Path and row.tMatchesEle24Tau30Filter and row.tMatchesEle24Tau30Path and row.ePt > 25 and row.ePt < 28 and row.tPt > 35 and abs(row.tEta) < 2.1

      if self.filters(row):
        continue

      if not bool(trigger27 or trigger32 or trigger35 or trigger2430):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.tPhi, row.ePhi, row.tEta, row.eEta) < 0.5:
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
        tmpMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
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
        weight = self.mcWeight.lumiWeight(weight)

      if self.is_data:

        if not self.obj2_tight(row) and self.obj2_loose(row) and not self.obj1_tight(row) and self.obj1_loose(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          frEle = self.fakeRateEle(myEle.Pt())
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, njets, weight*frTau*frEle*-1)

        if not self.obj2_tight(row) and self.obj2_loose(row) and self.obj1_tight(row):
          frTau = self.fakeRate(myTau.Pt(), myTau.Eta(), row.tDecayMode)
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, njets, weight*frTau)

        if not self.obj1_tight(row) and self.obj1_loose(row) and self.obj2_tight(row):
          frEle = self.fakeRateEle(myEle.Pt())
          if not self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, njets, weight*frEle)

      if self.is_mc:
        if self.obj2_tight(row) and self.obj1_tight(row):
          if self.oppositesign(row):
            self.filltree(row, myEle, myMET, myTau, njets, weight)


  def finish(self):
    self.tree1.Write()
    self.write_histos()
