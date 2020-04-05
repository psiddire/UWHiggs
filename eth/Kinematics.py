from math import sqrt, pi, exp, cos
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star = ['ePt', 'tPt', 'dPhiETau', 'dEtaETau', 'e_t_collinearMass', 'e_t_visibleMass', 'MTTauMET', 'dPhiTauMET']
xml_name = os.path.join(os.getcwd(), 'bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml')
functor = FunctorFromMVA('BDT', xml_name, *var_d_star)

def var_d(myEle, myMET, myTau):
  return {'ePt' : myEle.Pt(), 'tPt' : myTau.Pt(), 'dPhiETau' : deltaPhi(myEle.Phi(), myTau.Phi()), 'dEtaETau' : deltaEta(myEle.Eta(), myTau.Eta()), 'e_t_collinearMass' : collMass(myEle, myMET, myTau), 'e_t_visibleMass' : visibleMass(myEle, myTau), 'MTTauMET' : transverseMass(myTau, myMET), 'dPhiTauMET' : deltaPhi(myTau.Phi(), myMET.Phi())}

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

loosenames = ['TauLooseOS', 'EleLooseOS', 'EleLooseTauLooseOS', 'TauLooseOS0Jet', 'EleLooseOS0Jet', 'EleLooseTauLooseOS0Jet', 'TauLooseOS1Jet', 'EleLooseOS1Jet', 'EleLooseTauLooseOS1Jet', 'TauLooseOS2Jet', 'EleLooseOS2Jet', 'EleLooseTauLooseOS2Jet', 'TauLooseOS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseTauLooseOS2JetVBF']

jes = ['JetAbsoluteUp', 'JetAbsoluteDown', 'JetAbsoluteyearUp', 'JetAbsoluteyearDown', 'JetBBEC1Up', 'JetBBEC1Down', 'JetBBEC1yearUp', 'JetBBEC1yearDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetEC2Up', 'JetEC2Down', 'JetEC2yearUp', 'JetEC2yearDown', 'JetHFUp', 'JetHFDown', 'JetHFyearUp', 'JetHFyearDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown', 'JERUp', 'JERDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

fakes = ['', 'EleFakep0Up', 'EleFakep0Down', 'EleFakep1Up', 'EleFakep1Down', 'EleFakep2Up', 'EleFakep2Down', 'TauFakep0EBDM0Up', 'TauFakep0EBDM0Down', 'TauFakep0EBDM1Up', 'TauFakep0EBDM1Down', 'TauFakep0EBDM10Up', 'TauFakep0EBDM10Down', 'TauFakep0EEDM0Up', 'TauFakep0EEDM0Down', 'TauFakep0EEDM1Up', 'TauFakep0EEDM1Down', 'TauFakep0EEDM10Up', 'TauFakep0EEDM10Down', 'TauFakep1EBDM0Up', 'TauFakep1EBDM0Down', 'TauFakep1EBDM1Up', 'TauFakep1EBDM1Down', 'TauFakep1EBDM10Up', 'TauFakep1EBDM10Down', 'TauFakep1EEDM0Up', 'TauFakep1EEDM0Down', 'TauFakep1EEDM1Up', 'TauFakep1EEDM1Down', 'TauFakep1EEDM10Up', 'TauFakep1EEDM10Down', 'TauFakep0EBDM11Up', 'TauFakep0EBDM11Down', 'TauFakep0EEDM11Up', 'TauFakep0EEDM11Down', 'TauFakep1EBDM11Up', 'TauFakep1EBDM11Down', 'TauFakep1EEDM11Up', 'TauFakep1EEDM11Down']

sys = ['', 'puUp', 'puDown', 'pfUp', 'pfDown', 'tid30Up', 'tid30Down', 'tid35Up', 'tid35Down', 'tid40Up', 'tid40Down', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'bTagUp', 'bTagDown', 'embtrk0Up', 'embtrk0Down', 'embtrk1Up', 'embtrk1Down', 'mtfake0Up', 'mtfake0Down', 'mtfake0p4Up', 'mtfake0p4Down', 'mtfake0p8Up', 'mtfake0p8Down', 'mtfake1p2Up', 'mtfake1p2Down', 'mtfake1p7Up', 'mtfake1p7Down', 'etfakebUp', 'etfakebDown', 'etfakeeUp', 'etfakeeDown', 'etfakeesbdm0Up', 'etfakeesbdm0Down', 'etfakesebdm1Up', 'etfakeesbdm1Down', 'etfakeesedm0Up', 'etfakeesedm0Down', 'etfakeesedm1Up', 'etfakeesedm1Down', 'mtfakeesdm0Up', 'mtfakeesdm0Down', 'mtfakeesdm1Up', 'mtfakeesdm1Down', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'scaletDM11Up', 'scaletDM11Down', 'eesUp', 'eesDown', 'DYptreweightUp', 'DYptreweightDown']

fakeSys = ['/TauFakep0EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep0EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep0EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep0EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep0EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep0EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EBDM0Up', '/TauFakep1EBDM0Down', '/TauFakep1EBDM1Up', '/TauFakep1EBDM1Down', '/TauFakep1EBDM10Up', '/TauFakep1EBDM10Down', '/TauFakep1EEDM0Up', '/TauFakep1EEDM0Down', '/TauFakep1EEDM1Up', '/TauFakep1EEDM1Down', '/TauFakep1EEDM10Up', '/TauFakep1EEDM10Down', '/TauFakep0EBDM11Up', '/TauFakep0EBDM11Down', '/TauFakep1EBDM11Up', '/TauFakep1EBDM11Down', '/TauFakep0EEDM11Up', '/TauFakep0EEDM11Down', '/TauFakep1EEDM11Up', '/TauFakep1EEDM11Down']

scaleSys = ['/scaletDM0Up', '/scaletDM0Down', '/scaletDM1Up', '/scaletDM1Down', '/scaletDM10Up', '/scaletDM10Down', '/scaletDM11Up', '/scaletDM11Down']

tauidSys = ['/tid30Up', '/tid30Down', '/tid35Up', '/tid35Down', '/tid40Up', '/tid40Down']

mtfakeSys = ['/mtfake0Up', '/mtfake0Down', '/mtfake0p4Up', '/mtfake0p4Down', '/mtfake0p8Up', '/mtfake0p8Down', '/mtfake1p2Up', '/mtfake1p2Down', '/mtfake1p7Up', '/mtfake1p7Down']

etfakeSys = ['/etfakebUp', '/etfakebDown', '/etfakeeUp', '/etfakeeDown']

etfakeesSys = ['/etfakeesbdm0Up', '/etfakeesbdm0Down', '/etfakeesbdm1Up', '/etfakeesbdm1Down', '/etfakeesedm0Up', '/etfakeesedm0Down', '/etfakeesedm1Up', '/etfakeesedm1Down']

mtfakeesSys = ['/mtfakeesdm0Up', '/mtfakeesdm0Down', '/mtfakeesdm1Up', '/mtfakeesdm1Down']

plotnames = ['TauLooseWOS', 'TauLooseOS', 'TauLooseSS', 'EleLooseWOS', 'EleLooseOS', 'EleLooseSS', 'EleLooseTauLooseWOS', 'EleLooseTauLooseOS', 'EleLooseTauLooseSS', 'TightWOS', 'TightOS', 'TightSS', 'TauLooseWOS0Jet', 'TauLooseOS0Jet', 'TauLooseSS0Jet', 'EleLooseWOS0Jet', 'EleLooseOS0Jet', 'EleLooseSS0Jet', 'EleLooseTauLooseWOS0Jet', 'EleLooseTauLooseOS0Jet', 'EleLooseTauLooseSS0Jet', 'TightWOS0Jet', 'TightOS0Jet', 'TightSS0Jet', 'TauLooseWOS1Jet', 'TauLooseOS1Jet', 'TauLooseSS1Jet', 'EleLooseWOS1Jet', 'EleLooseOS1Jet', 'EleLooseSS1Jet', 'EleLooseTauLooseWOS1Jet', 'EleLooseTauLooseOS1Jet', 'EleLooseTauLooseSS1Jet', 'TightWOS1Jet', 'TightOS1Jet', 'TightSS1Jet', 'TauLooseWOS2Jet', 'TauLooseOS2Jet', 'TauLooseSS2Jet', 'EleLooseWOS2Jet', 'EleLooseOS2Jet', 'EleLooseSS2Jet', 'EleLooseTauLooseWOS2Jet', 'EleLooseTauLooseOS2Jet', 'EleLooseTauLooseSS2Jet', 'TightWOS2Jet', 'TightOS2Jet', 'TightSS2Jet', 'TauLooseWOS2JetVBF', 'TauLooseOS2JetVBF', 'TauLooseSS2JetVBF', 'EleLooseWOS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseSS2JetVBF', 'EleLooseTauLooseWOS2JetVBF', 'EleLooseTauLooseOS2JetVBF', 'EleLooseTauLooseSS2JetVBF', 'TightWOS2JetVBF', 'TightOS2JetVBF', 'TightSS2JetVBF']

zttnames = ['TauLooseOS', 'EleLooseOS', 'EleLooseTauLooseOS', 'TightOS', 'TauLooseOS0Jet', 'EleLooseOS0Jet', 'EleLooseTauLooseOS0Jet', 'TightOS0Jet', 'TauLooseOS1Jet', 'EleLooseOS1Jet', 'EleLooseTauLooseOS1Jet', 'TightOS1Jet', 'TauLooseOS2Jet', 'EleLooseOS2Jet', 'EleLooseTauLooseOS2Jet', 'TightOS2Jet', 'TauLooseOS2JetVBF', 'EleLooseOS2JetVBF', 'EleLooseTauLooseOS2JetVBF', 'TightOS2JetVBF']

zeenames = ['TauLooseOS', 'EleLooseOS', 'EleLooseTauLooseOS', 'TightOS']
