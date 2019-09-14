'''

Run LFV H->MuE analysis in the mu+tau_e channel.

Authors: Prasanna Siddireddy

'''

import EMTree
from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import os
import ROOT
import math
import mcCorrections
import mcWeights
import Kinematics
from bTagSF import PromoteDemote, PromoteDemoteSyst, bTagEventWeight

MetCorrection = True
target = os.path.basename(os.environ['megatarget'])
pucorrector = mcCorrections.puCorrector(target) 
Emb = True

class AnalyzeMuESys(MegaBase):
  tree = 'em/final/Ntuple'

  def __init__(self, tree, outfile, **kwargs):

    self.mcWeight = mcWeights.mcWeights(target)
    self.is_data = self.mcWeight.is_data
    self.is_embed = self.mcWeight.is_embed
    self.is_mc = self.mcWeight.is_mc
    self.is_DY = self.mcWeight.is_DY
    self.is_W = self.mcWeight.is_W
    self.is_TT = self.mcWeight.is_TT

    self.is_recoilC = self.mcWeight.is_recoilC
    if self.is_recoilC and MetCorrection:
      self.Metcorected = mcCorrections.Metcorected
      self.MetSys = mcCorrections.MetSys

    self.f_btag_eff = mcCorrections.f_btag_eff
    self.h_btag_eff_b = mcCorrections.h_btag_eff_b
    self.h_btag_eff_c = mcCorrections.h_btag_eff_c
    self.h_btag_eff_oth = mcCorrections.h_btag_eff_oth

    self.triggerEff = mcCorrections.efficiency_trigger_mu_2017
    self.muonTightID = mcCorrections.muonID_tight
    self.muonTightIsoTightID = mcCorrections.muonIso_tight_tightid
    self.muTracking = mcCorrections.muonTracking
    self.eIDnoIsoWP80 = mcCorrections.eIDnoIsoWP80
    self.eReco = mcCorrections.eReco
    self.EmbedEta = mcCorrections.EmbedEta
    self.rc = mcCorrections.rc
    self.w1 = mcCorrections.w1
    self.w2 = mcCorrections.w2
    self.w3 = mcCorrections.w3
    self.we = mcCorrections.we
    self.wp = mcCorrections.wp

    self.DYweight = self.mcWeight.DYweight
    self.Wweight = self.mcWeight.Wweight

    self.deltaPhi = Kinematics.deltaPhi
    self.deltaEta = Kinematics.deltaEta
    self.deltaR = Kinematics.deltaR
    self.visibleMass = Kinematics.visibleMass
    self.collMass = Kinematics.collMass
    self.transverseMass = Kinematics.transverseMass
    self.topPtreweight = Kinematics.topPtreweight
    self.jes = Kinematics.jes

    super(AnalyzeMuESys, self).__init__(tree, outfile, **kwargs)
    self.tree = EMTree.EMTree(tree)
    self.out = outfile
    self.histograms = {}


  def oppositesign(self, row):
    if row.mCharge*row.eCharge!=-1:
      return False
    return True


  def kinematics(self, row):
    if row.mPt < 10 or abs(row.mEta) >= 2.4:
      return False
    if row.ePt < 13 or abs(row.eEta) >= 2.5:
      return False
    return True


  def filters(self, row):
    if row.Flag_goodVertices or row.Flag_globalTightHalo2016Filter or row.Flag_HBHENoiseFilter or row.Flag_HBHENoiseIsoFilter or row.Flag_EcalDeadCellTriggerPrimitiveFilter or row.Flag_BadPFMuonFilter or row.Flag_BadChargedCandidateFilter or row.Flag_ecalBadCalibFilter or bool(self.is_data and row.Flag_eeBadScFilter):
      return True
    return False


  def obj1_id(self, row):
    return (bool(row.mPFIDTight) and bool(abs(row.mPVDZ) < 0.2) and bool(abs(row.mPVDXY) < 0.045))
 
 
  def obj1_iso(self, row):
    return bool(row.mRelPFIsoDBDefaultR04 < 0.15)
  

  def obj2_id(self, row):
    return (bool(row.eMVANoisoWP80) and bool(abs(row.ePVDZ) < 0.2) and bool(abs(row.ePVDXY) < 0.045) and bool(row.ePassesConversionVeto) and bool(row.eMissingHits < 2))


  def obj2_iso(self, row):
    return bool(row.eRelPFIsoRho < 0.1)


  def vetos(self, row):
    return (bool(row.eVetoMVAIso < 0.5) and bool(row.tauVetoPt20LooseMVALTVtx < 0.5) and bool(row.muGlbIsoVetoPt10 < 0.5))


  def begin(self):
    folder = []
    names = ['TightOS', 'TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF']
    ssnames = ['TightSS', 'TightSS0Jet', 'TightSS1Jet', 'TightSS2Jet', 'TightSS2JetVBF']
    sys = ['', 'puUp', 'puDown', 'pfUp', 'pfDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'bTagUp', 'bTagDown', 'eescUp', 'eescDown', 'eesiUp', 'eesiDown', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'TopptreweightUp', 'TopptreweightDown']
    sssys = ['', 'Rate0JetUp', 'Rate0JetDown', 'Rate1JetUp', 'Rate1JetDown', 'Shape0JetUp', 'Shape0JetDown', 'Shape1JetUp', 'Shape1JetDown', 'IsoUp', 'IsoDown']

    for tuple_path in itertools.product(names, sys):
      folder.append(os.path.join(*tuple_path))
    for tuple_path_jes in itertools.product(names, self.jes):
      folder.append(os.path.join(*tuple_path_jes))
    for tuple_path_ss in itertools.product(ssnames, sssys):
      folder.append(os.path.join(*tuple_path_ss))

    for f in folder:
      self.book(f, "m_e_CollinearMass", "Muon + Electron Collinear Mass", 60, 0, 300)      


  def fill_histos(self, myMuon, myMET, myEle, weight, name=''):
    histos = self.histograms 
    histos[name+'/m_e_CollinearMass'].Fill(self.collMass(myMuon, myMET, myEle), weight)


  def fill_categories(self, myMuon, myMET, myEle, njets, mjj, weight, name=''):
    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
    mtmumet = self.transverseMass(myMuon, myMET)
    self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS'+name)
    if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS0Jet'+name)
    elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS1Jet'+name)
    elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2Jet'+name)
    elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
        self.fill_histos(myMuon, myMET, myEle, weight, 'TightOS2JetVBF'+name)


  def fill_sshistos(self, myMuon, myMET, myEle, njets, weight, name=''):
    self.w3.var("njets").setVal(njets)
    self.w3.var("dR").setVal(self.deltaR(myEle.Phi(), myMuon.Phi(), myEle.Phi(), myMuon.Eta()))
    self.w3.var("e_pt").setVal(myEle.Pt())
    self.w3.var("m_pt").setVal(myMuon.Pt())
    osss = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0rup = self.w3.function("em_qcd_osss_0jet_rateup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0rdown = self.w3.function("em_qcd_osss_0jet_ratedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0sup = self.w3.function("em_qcd_osss_0jet_shapeup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss0sdown = self.w3.function("em_qcd_osss_0jet_shapedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1rup = self.w3.function("em_qcd_osss_1jet_rateup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1rdown = self.w3.function("em_qcd_osss_1jet_ratedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1sup = self.w3.function("em_qcd_osss_1jet_shapeup").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osss1sdown = self.w3.function("em_qcd_osss_1jet_shapedown").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osssisoup = self.w3.function("em_qcd_osss_binned").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal() * self.w3.function("em_qcd_extrap_uncert").getVal()
    osssisodown = self.w3.function("em_qcd_osss_binned").getVal()
    if '0Jet' in name:
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name)
      self.fill_histos(myMuon, myMET, myEle, weight*osss0rup, name+'/Rate0JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss0rdown, name+'/Rate0JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss0sup, name+'/Shape0JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss0sdown, name+'/Shape0JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Rate1JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Rate1JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Shape1JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Shape1JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osssisoup, name+'/IsoUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osssisodown, name+'/IsoDown')
    else:
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name)
      self.fill_histos(myMuon, myMET, myEle, weight*osss1rup, name+'/Rate1JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss1rdown, name+'/Rate1JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss1sup, name+'/Shape1JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss1sdown, name+'/Shape1JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Rate0JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Rate0JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Shape0JetUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osss, name+'/Shape0JetDown')
      self.fill_histos(myMuon, myMET, myEle, weight*osssisoup, name+'/IsoUp')
      self.fill_histos(myMuon, myMET, myEle, weight*osssisodown, name+'/IsoDown')


  def fill_sscategories(self, row, myMuon, myMET, myEle, njets, weight, name=''):
    dphiemu = self.deltaPhi(myEle.Phi(), myMuon.Phi())
    dphiemet = self.deltaPhi(myEle.Phi(), myMET.Phi())
    mtmumet = self.transverseMass(myMuon, myMET)
    mjj = getattr(row, 'vbfMassWoNoisyJets')
    self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS')
    if njets==0 and mtmumet > 60 and dphiemet < 0.7 and dphiemu > 2.5 and myMuon.Pt() > 30:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS0Jet') 
    elif njets==1 and mtmumet > 40 and dphiemet < 0.7 and dphiemu > 1.0 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS1Jet') 
    elif njets==2 and mjj < 550 and mtmumet > 15 and dphiemet < 0.5 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2Jet') 
    elif njets==2 and mjj > 550 and mtmumet > 15 and dphiemet < 0.3 and myMuon.Pt() > 26:
        self.fill_sshistos(myMuon, myMET, myEle, njets, weight, 'TightSS2JetVBF')


  def fill_sys(self, row, myMuon, myMET, myEle, njets, weight):

    tmpMuon = ROOT.TLorentzVector()
    tmpEle = ROOT.TLorentzVector()
    tmpEleC = ROOT.TLorentzVector()
    tmpMET = ROOT.TLorentzVector()
    mjj = row.vbfMassWoNoisyJets

    if self.is_mc:

      if self.is_recoilC and MetCorrection:
        tmpMET.SetPtEtaPhiM(myMET.Pt(), 0, myMET.Phi(), 0)
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 0, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recrespDown')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 0)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoUp')
        sysMet = self.MetSys.ApplyMEtSys(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)), 0, 1, 1)
        if sysMet!=None:
          tmpMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)
        self.fill_categories(myMuon, tmpMET, myEle, njets, mjj, weight, '/recresoDown')

      puweightUp = pucorrector['puUp'](row.nTruePU)
      puweightDown = pucorrector['puDown'](row.nTruePU)
      puweight = pucorrector[''](row.nTruePU)
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      if nbtag==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/bTagDown')
      if nbtag > 0:
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        btagweightup = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 1, 0)
        btagweightdown = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, -1, 0)
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightup/btagweight, '/bTagUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * btagweightdown/btagweight, '/bTagDown')

      if puweight==0:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, 0, '/puDown')
      else:
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightUp/puweight, '/puUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * puweightDown/puweight, '/puDown')

      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * 1.02, '/trUp')
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * 0.98, '/trDown')

      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_up/row.prefiring_weight, '/pfUp')
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight * row.prefiring_weight_down/row.prefiring_weight, '/pfDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescDown')

      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaUp/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiUp')
      myMETpx = myMET.Px() + myEle.Px()
      myMETpy = myMET.Py() + myEle.Py()
      tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
      tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaDown/row.eecalEnergy)
      myMETpx = myMETpx - tmpEle.Px()
      myMETpy = myMETpy - tmpEle.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiDown')
      
      myMETpx = myMET.Px() - 0.002 * myMuon.Px()
      myMETpy = myMET.Py() - 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(1.002)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesUp')
      myMETpx = myMET.Px() + 0.002 * myMuon.Px()
      myMETpy = myMET.Py() + 0.002 * myMuon.Py()
      tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
      tmpMuon = myMuon * ROOT.Double(0.998)
      self.fill_categories(tmpMuon, tmpMET, myEle, njets, mjj, weight, '/mesDown')

      if self.is_DY:
        self.w2.var("z_gen_mass").setVal(row.genMass)
        self.w2.var("z_gen_pt").setVal(row.genpT)
        dyweight = self.w2.function("zptmass_weight_nom").getVal()
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*dyweight, '/DYptreweightUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight/dyweight, '/DYptreweightDown')

      if self.is_TT:
        topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight*topweight, '/TopptreweightUp')
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight/topweight, '/TopptreweightDown')
      
      if not (self.is_recoilC and MetCorrection):
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEleC = tmpEle * ROOT.Double(row.eCorrectedEt/row.eecalEnergy)
        myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnUp, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnUp, 0)
        myMETpx = myMET.Px() + tmpEle.Px()
        myMETpy = myMET.Py() + tmpEle.Py()
        myMETpx = myMETpx - tmpEleC.Px()
        myMETpy = myMETpy - tmpEleC.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy)) 
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/UnclusteredEnUp')
        myMET.SetPtEtaPhiM(row.type1_pfMet_shiftedPt_UnclusteredEnDown, 0, row.type1_pfMet_shiftedPhi_UnclusteredEnDown, 0)
        myMETpx = myMET.Px() + tmpEle.Px()
        myMETpy = myMET.Py() + tmpEle.Py()
        myMETpx = myMETpx - tmpEleC.Px()
        myMETpy = myMETpy - tmpEleC.Py()
        myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/UnclusteredEnDown')

        for j in self.jes:
          myMET.SetPtEtaPhiM(getattr(row, 'type1_pfMet_shiftedPt_'+j) , 0, getattr(row, 'type1_pfMet_shiftedPhi_'+j), 0)
          myMETpx = myMET.Px() + tmpEle.Px()
          myMETpy = myMET.Py() + tmpEle.Py()
          myMETpx = myMETpx - tmpEleC.Px()
          myMETpy = myMETpy - tmpEleC.Py()
          myMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
          njets = getattr(row, 'jetVeto30WoNoisyJets_'+j)
          mjj = getattr(row, 'vbfMassWoNoisyJets_'+j) 
          self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '/'+j)

    else:
      self.fill_categories(myMuon, myMET, myEle, njets, mjj, weight, '')
      if self.is_embed:
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleUp/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergyScaleDown/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eescDown')

        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaUp/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiUp')
        myMETpx = myMET.Px() + myEle.Px()
        myMETpy = myMET.Py() + myEle.Py()
        tmpEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
        tmpEle = tmpEle * ROOT.Double(row.eEnergySigmaDown/row.eecalEnergy)
        myMETpx = myMETpx - tmpEle.Px()
        myMETpy = myMETpy - tmpEle.Py()
        tmpMET.SetPxPyPzE(myMETpx, myMETpy, 0, math.sqrt(myMETpx * myMETpx + myMETpy * myMETpy))
        self.fill_categories(myMuon, tmpMET, tmpEle, njets, mjj, weight, '/eesiDown')


  def process(self):

    for row in self.tree:

      triggerm8e23 = row.mu8e23DZPass and row.mPt > 10 and row.ePt > 24# and row.eMatchesMu8e23DZFilter and row.eMatchesMu8e23DZPath and row.mMatchesMu8e23DZFilter and row.mMatchesMu8e23DZPath
      triggerm23e12 = row.mu23e12DZPass and row.mPt > 24 and row.ePt > 13# and row.eMatchesMu23e12DZFilter and row.eMatchesMu23e12DZPath and row.mMatchesMu23e12DZFilter and row.mMatchesMu23e12DZPath

      if self.filters(row):
        continue

      if not bool(triggerm8e23 or triggerm23e12):
        continue

      if not self.kinematics(row):
        continue

      if self.deltaR(row.ePhi, row.mPhi, row.eEta, row.mEta) < 0.3:
        continue

      njets = row.jetVeto30WoNoisyJets
      if njets > 2:
        continue 

      if Emb and self.is_DY:
        if not bool(row.isZmumu or row.isZee):
          continue

      if not self.obj1_id(row):
        continue

      if not self.obj2_id(row):
        continue

      if not self.vetos(row):
        continue      

      nbtag = row.bjetDeepCSVVeto20Medium_2017_DR0p5
      if nbtag > 2:
        nbtag = 2

      myMuon = ROOT.TLorentzVector()
      myMuon.SetPtEtaPhiM(row.mPt, row.mEta, row.mPhi, row.mMass)

      myMET = ROOT.TLorentzVector()
      myMET.SetPtEtaPhiM(row.type1_pfMetEt, 0, row.type1_pfMetPhi, 0)

      myEle = ROOT.TLorentzVector()
      myEle.SetPtEtaPhiM(row.ePt, row.eEta, row.ePhi, row.eMass)
         
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
        sysMet = self.Metcorected.CorrectByMeanResolution(myMET.Et()*math.cos(myMET.Phi()), myMET.Et()*math.sin(myMET.Phi()), row.genpX, row.genpY, row.vispX, row.vispY, int(round(njets)))
        myMET.SetPtEtaPhiM(math.sqrt(sysMet[0]*sysMet[0] + sysMet[1]*sysMet[1]), 0, math.atan2(sysMet[1], sysMet[0]), 0)

      weight = 1.0
      eff_trg_data = 0
      eff_trg_mc = 0
      eff_trg_embed = 0
      if self.is_mc:
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        if triggerm8e23:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_8_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
        if triggerm23e12:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
          eff_trg_mc = eff_trg_mc + self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_12_mc").getVal()
        if triggerm8e23 and triggerm23e12:
          eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_mc = eff_trg_mc - self.w1.function("m_trg_binned_23_mc").getVal()*self.w1.function("e_trg_binned_23_mc").getVal()
        tEff = 0 if eff_trg_mc==0 else eff_trg_data/eff_trg_mc
        mID = self.muonTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mIso = self.muonTightIsoTightID(myMuon.Pt(), abs(myMuon.Eta()))
        mTrk = self.muTracking(myMuon.Eta())[0]
        eID = self.eIDnoIsoWP80(myEle.Pt(), abs(myEle.Eta()))
        eTrk = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        mcSF = self.rc.kSpreadMC(row.mCharge, myMuon.Pt(), myMuon.Eta(), myMuon.Phi(), row.mGenPt, 0, 0)
        weight = weight*row.GenWeight*pucorrector[''](row.nTruePU)*tEff*mID*mIso*mTrk*eID*eTrk*mcSF*row.prefiring_weight
        if self.is_DY:
          self.w2.var("z_gen_mass").setVal(row.genMass)
          self.w2.var("z_gen_pt").setVal(row.genpT)
          dyweight = self.w2.function("zptmass_weight_nom").getVal()
          weight = weight*dyweight
          if row.numGenJets < 5:
            weight = weight*self.DYweight[row.numGenJets]
          else:
            weight = weight*self.DYweight[0]
        if self.is_W:
          if row.numGenJets < 5:
            weight = weight*self.Wweight[row.numGenJets]
          else:
            weight = weight*self.Wweight[0]
        if self.is_TT:
          topweight = self.topPtreweight(row.topQuarkPt1, row.topQuarkPt2)
          weight = weight*topweight
          if row.mZTTGenMatching > 2 and row.mZTTGenMatching < 6 and row.eZTTGenMatching > 2 and row.eZTTGenMatching < 6 and Emb:
            continue
        weight = self.mcWeight.lumiWeight(weight)

      mjj = getattr(row, 'vbfMassWoNoisyJets')

      if self.is_embed:
        self.w1.var("gt_pt").setVal(myMuon.Pt())
        self.w1.var("gt_eta").setVal(myMuon.Eta())
        msel = self.w1.function("m_sel_idEmb_ratio").getVal()
        self.w1.var("gt_pt").setVal(myEle.Pt())
        self.w1.var("gt_eta").setVal(myEle.Eta())
        esel = self.w1.function("m_sel_idEmb_ratio").getVal()
        self.w1.var("gt1_pt").setVal(myMuon.Pt())
        self.w1.var("gt1_eta").setVal(myMuon.Eta())
        self.w1.var("gt2_pt").setVal(myEle.Pt())
        self.w1.var("gt2_eta").setVal(myEle.Eta())
        trgsel = self.w1.function("m_sel_trg_ratio").getVal()
        self.we.var("m_pt").setVal(myMuon.Pt())
        self.we.var("m_eta").setVal(myMuon.Eta())
        self.we.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        m_id_sf = self.we.function("m_id_embed_kit_ratio").getVal()
        m_iso_sf = self.we.function("m_iso_binned_embed_kit_ratio").getVal()
        m_trk_sf = self.muTracking(myMuon.Eta())[0]
        self.wp.var("e_pt").setVal(myEle.Pt())
        self.wp.var("e_eta").setVal(myEle.Eta())
        self.wp.var("e_phi").setVal(myEle.Phi())
        self.wp.var("e_iso").setVal(row.eRelPFIsoRho)
        e_id_sf = self.wp.function("e_id80_embed_kit_ratio").getVal()
        e_iso_sf = self.wp.function("e_iso_binned_embed_kit_ratio").getVal()
        e_trk_sf = self.eReco(myEle.Pt(), abs(myEle.Eta()))
        self.w1.var("m_pt").setVal(myMuon.Pt())
        self.w1.var("m_eta").setVal(myMuon.Eta())
        self.w1.var("m_iso").setVal(row.mRelPFIsoDBDefaultR04)
        self.w1.var("e_pt").setVal(myEle.Pt())
        self.w1.var("e_eta").setVal(myEle.Eta())
        self.w1.var("e_iso").setVal(row.eRelPFIsoRho)
        if triggerm8e23:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_8_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_8_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        if triggerm23e12:
          eff_trg_data = eff_trg_data + self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_12_data").getVal()
          eff_trg_embed = eff_trg_embed + self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_12_embed").getVal()
        if triggerm8e23 and triggerm23e12:
          eff_trg_data = eff_trg_data - self.w1.function("m_trg_binned_23_data").getVal()*self.w1.function("e_trg_binned_23_data").getVal()
          eff_trg_embed = eff_trg_embed - self.w1.function("m_trg_binned_23_embed").getVal()*self.w1.function("e_trg_binned_23_embed").getVal()
        trg_sf = 0 if eff_trg_embed==0 else eff_trg_data/eff_trg_embed
        weight = weight*row.GenWeight*msel*esel*trgsel*trg_sf*m_id_sf*m_iso_sf*m_trk_sf*e_id_sf*e_iso_sf*e_trk_sf*self.EmbedEta(myEle.Eta(), njets, mjj)

      if bool(self.is_mc and nbtag > 0):
        btagweight = bTagEventWeight(nbtag, row.jb1pt, row.jb1hadronflavor, row.jb2pt, row.jb2hadronflavor, 1, 0, 0)
        weight = weight * btagweight
      if bool(self.is_data or self.is_embed):
        if nbtag > 0:
          weight = 0

      if self.obj1_iso(row) and self.obj2_iso(row):
        if self.oppositesign(row):
          self.fill_sys(row, myMuon, myMET, myEle, njets, weight)
        else:
          self.fill_sscategories(row, myMuon, myMET, myEle, njets, weight)


  def finish(self):
    self.write_histos()
