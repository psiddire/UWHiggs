from math import sqrt, pi, exp, cos
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star = ['mPt', 'tPt', 'dPhiMuTau', 'dEtaMuTau', 'type1_pfMetEt', 'm_t_collinearMass', 'MTTauMET', 'dPhiTauMET']
xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml')
functor = FunctorFromMVA('BDT method', xml_name, *var_d_star)

def var_d(myMuon, myMET, myTau):
  return {'mPt' : myMuon.Pt(), 'tPt' : myTau.Pt(), 'dPhiMuTau' : deltaPhi(myMuon.Phi(), myTau.Phi()), 'dEtaMuTau' : deltaEta(myMuon.Eta(), myTau.Eta()), 'type1_pfMetEt' : myMET.Et(), 'm_t_collinearMass' : collMass(myMuon, myMET, myTau), 'MTTauMET' : transverseMass(myTau, myMET), 'dPhiTauMET' : deltaPhi(myTau.Phi(), myMET.Phi())}

def invert_case(letter):
  if letter.upper() == letter:
    return letter.lower()
  else:
    return letter.upper()

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

def visibleMass(myLep1, myLep2):
  return (myLep1+myLep2).M()

def collMass(myLep1, myMET, myLep2):
  ptnu = abs(myMET.Et()*cos(deltaPhi(myMET.Phi(), myLep2.Phi())))
  visfrac = myLep2.Pt()/(myLep2.Pt() + ptnu)
  l1_l2_Mass = visibleMass(myLep1, myLep2)
  return (l1_l2_Mass/sqrt(visfrac))

def transverseMass(vobj, vmet):
  totalEt = vobj.Et() + vmet.Et()
  totalPt = (vobj + vmet).Pt()
  mt2 = totalEt*totalEt - totalPt*totalPt;
  return sqrt(abs(mt2))

def topPtreweight(pt1, pt2):
  if pt1 > 400 : pt1 = 400
  if pt2 > 400 : pt2 = 400
  a = 0.0615
  b = -0.0005
  wt1 = exp(a + b * pt1)
  wt2 = exp(a + b * pt2)
  wt = sqrt(wt1 * wt2)
  return wt

names = ['TightOS', 'TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF']

loosenames = ['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF']

jes = ['JetAbsoluteUp', 'JetAbsoluteDown', 'JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFUp', 'JetHFDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

fakes = ['', 'MuonFakep0Up', 'MuonFakep0Down', 'MuonFakep1Up', 'MuonFakep1Down', 'TauFakep0EBDM0Up', 'TauFakep0EBDM0Down', 'TauFakep0EBDM1Up', 'TauFakep0EBDM1Down', 'TauFakep0EBDM10Up', 'TauFakep0EBDM10Down', 'TauFakep0EEDM0Up', 'TauFakep0EEDM0Down', 'TauFakep0EEDM1Up', 'TauFakep0EEDM1Down', 'TauFakep0EEDM10Up', 'TauFakep0EEDM10Down', 'TauFakep1EBDM0Up', 'TauFakep1EBDM0Down', 'TauFakep1EBDM1Up', 'TauFakep1EBDM1Down', 'TauFakep1EBDM10Up', 'TauFakep1EBDM10Down', 'TauFakep1EEDM0Up', 'TauFakep1EEDM0Down', 'TauFakep1EEDM1Up', 'TauFakep1EEDM1Down', 'TauFakep1EEDM10Up', 'TauFakep1EEDM10Down', 'TauFakep0EBDM11Up', 'TauFakep0EBDM11Down', 'TauFakep0EEDM11Up', 'TauFakep0EEDM11Down', 'TauFakep1EBDM11Up', 'TauFakep1EBDM11Down', 'TauFakep1EEDM11Up', 'TauFakep1EEDM11Down']

sys = ['', 'puUp', 'puDown', 'pfUp', 'pfDown', 'tid30Up', 'tid30Down', 'tid35Up', 'tid35Down', 'tid40Up', 'tid40Down', 'recresp0Up', 'recresp0Down', 'recreso0Up', 'recreso0Down', 'recresp1Up', 'recresp1Down', 'recreso1Up', 'recreso1Down', 'recresp2Up', 'recresp2Down', 'recreso2Up', 'recreso2Down', 'bTagUp', 'bTagDown', 'embtrk0Up', 'embtrk0Down', 'embtrk1Up', 'embtrk1Down', 'mtfake0Up', 'mtfake0Down', 'mtfake0p4Up', 'mtfake0p4Down', 'mtfake0p8Up', 'mtfake0p8Down', 'mtfake1p2Up', 'mtfake1p2Down', 'mtfake1p7Up', 'mtfake1p7Down', 'etfakebUp', 'etfakebDown', 'etfakeeUp', 'etfakeeDown', 'etfakeesbdm0Up', 'etfakeesbdm0Down', 'etfakeesbdm1Up', 'etfakeesbdm1Down', 'etfakeesedm0Up', 'etfakeesedm0Down', 'etfakeesedm1Up', 'etfakeesedm1Down', 'mtfakeesdm0Up', 'mtfakeesdm0Down', 'mtfakeesdm1Up', 'mtfakeesdm1Down', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'scaletDM11Up', 'scaletDM11Down', 'mes1p2Up', 'mes1p2Down', 'mes2p1Up', 'mes2p1Down', 'DYptreweightUp', 'DYptreweightDown']

recSys = ['/recresp0Up', '/recresp0Down', '/recreso0Up', '/recreso0Down', '/recresp1Up', '/recresp1Down', '/recreso1Up', '/recreso1Down', '/recresp2Up', '/recresp2Down', '/recreso2Up', '/recreso2Down']

fakeSys = ['/TauFakep0EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep0EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep0EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep0EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep0EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep0EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EBDM0Up', '/TauFakep1EBDM0Down', '/TauFakep1EBDM1Up', '/TauFakep1EBDM1Down', '/TauFakep1EBDM10Up', '/TauFakep1EBDM10Down', '/TauFakep1EEDM0Up', '/TauFakep1EEDM0Down', '/TauFakep1EEDM1Up', '/TauFakep1EEDM1Down', '/TauFakep1EEDM10Up', '/TauFakep1EEDM10Down', '/TauFakep0EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep1EBDM11Up', '/TauFakep1EBDM11Down', '/TauFakep0EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EEDM11Up', '/TauFakep1EEDM11Down']

scaleSys = ['/scaletDM0Up', '/scaletDM0Down', '/scaletDM1Up', '/scaletDM1Down', '/scaletDM10Up', '/scaletDM10Down', '/scaletDM11Up', '/scaletDM11Down']

tauidSys = ['/tid30Up', '/tid30Down', '/tid35Up', '/tid35Down', '/tid40Up', '/tid40Down']

mtfakeSys = ['/mtfake0Up', '/mtfake0Down', '/mtfake0p4Up', '/mtfake0p4Down', '/mtfake0p8Up', '/mtfake0p8Down', '/mtfake1p2Up', '/mtfake1p2Down', '/mtfake1p7Up', '/mtfake1p7Down']

etfakeSys = ['/etfakebUp', '/etfakebDown', '/etfakeeUp', '/etfakeeDown']

etfakeesSys = ['/etfakeesbdm0Up', '/etfakeesbdm0Down', '/etfakeesbdm1Up', '/etfakeesbdm1Down', '/etfakeesedm0Up', '/etfakeesedm0Down', '/etfakeesedm1Up', '/etfakeesedm1Down']

mtfakeesSys = ['/mtfakeesdm0Up', '/mtfakeesdm0Down', '/mtfakeesdm1Up', '/mtfakeesdm1Down']

mesSys = ['/mes1p2Up', '/mes1p2Down', '/mes2p1Up', '/mes2p1Down']

plotnames = ['TauLooseWOS', 'TauLooseOS', 'TauLooseSS', 'MuonLooseWOS', 'MuonLooseOS', 'MuonLooseSS', 'MuonLooseTauLooseWOS', 'MuonLooseTauLooseOS', 'MuonLooseTauLooseSS', 'TightWOS', 'TightOS', 'TightSS', 'TauLooseWOS0Jet', 'TauLooseOS0Jet', 'TauLooseSS0Jet', 'MuonLooseWOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseSS0Jet', 'MuonLooseTauLooseWOS0Jet', 'MuonLooseTauLooseOS0Jet', 'MuonLooseTauLooseSS0Jet', 'TightWOS0Jet', 'TightOS0Jet', 'TightSS0Jet', 'TauLooseWOS1Jet', 'TauLooseOS1Jet', 'TauLooseSS1Jet', 'MuonLooseWOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseSS1Jet', 'MuonLooseTauLooseWOS1Jet', 'MuonLooseTauLooseOS1Jet', 'MuonLooseTauLooseSS1Jet', 'TightWOS1Jet', 'TightOS1Jet', 'TightSS1Jet', 'TauLooseWOS2Jet', 'TauLooseOS2Jet', 'TauLooseSS2Jet', 'MuonLooseWOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseSS2Jet', 'MuonLooseTauLooseWOS2Jet', 'MuonLooseTauLooseOS2Jet', 'MuonLooseTauLooseSS2Jet', 'TightWOS2Jet', 'TightOS2Jet', 'TightSS2Jet', 'TauLooseWOS2JetVBF', 'TauLooseOS2JetVBF', 'TauLooseSS2JetVBF', 'MuonLooseWOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseSS2JetVBF', 'MuonLooseTauLooseWOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'MuonLooseTauLooseSS2JetVBF', 'TightWOS2JetVBF', 'TightOS2JetVBF', 'TightSS2JetVBF']

wjnames = ['TauLooseWOS', 'MuonLooseWOS', 'MuonLooseTauLooseWOS', 'TightWOS', 'TauLooseWOS0Jet', 'MuonLooseWOS0Jet', 'MuonLooseTauLooseWOS0Jet', 'TightWOS0Jet', 'TauLooseWOS1Jet', 'MuonLooseWOS1Jet', 'MuonLooseTauLooseWOS1Jet', 'TightWOS1Jet', 'TauLooseWOS2Jet', 'MuonLooseWOS2Jet', 'MuonLooseTauLooseWOS2Jet', 'TightWOS2Jet', 'TauLooseWOS2JetVBF', 'MuonLooseWOS2JetVBF', 'MuonLooseTauLooseWOS2JetVBF', 'TightWOS2JetVBF']

zttnames = ['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'MuonLooseOS0Jet', 'MuonLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'MuonLooseOS1Jet', 'MuonLooseTauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'MuonLooseOS2Jet', 'MuonLooseTauLooseOS2Jet', 'TightOS2Jet', 'TauLooseOS2JetVBF', 'MuonLooseOS2JetVBF', 'MuonLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']

zmmnames = ['TauLooseOS', 'MuonLooseOS', 'MuonLooseTauLooseOS', 'TightOS']
