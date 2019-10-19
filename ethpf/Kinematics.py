from math import sqrt, pi, exp, cos

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

def visibleMass(v1, v2):
  return (v1+v2).M()

def collMass(myEle, myMET, myTau):
  ptnu = abs(myMET.Et()*cos(deltaPhi(myMET.Phi(), myTau.Phi())))
  visfrac = myTau.Pt()/(myTau.Pt() + ptnu)
  m_t_Mass = visibleMass(myEle, myTau)
  return (m_t_Mass/sqrt(visfrac))

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

jes = ['JetAbsoluteFlavMapUp', 'JetAbsoluteFlavMapDown', 'JetAbsoluteMPFBiasUp', 'JetAbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']

fakes = ['', 'EleFakep0EBUp', 'EleFakep0EBDown', 'EleFakep1EBUp', 'EleFakep1EBDown', 'EleFakep2EBUp', 'EleFakep2EBDown', 'EleFakep3EBUp', 'EleFakep3EBDown', 'EleFakep0EEUp', 'EleFakep0EEDown', 'EleFakep1EEUp', 'EleFakep1EEDown', 'EleFakep2EEUp', 'EleFakep2EEDown', 'EleFakep3EEUp', 'EleFakep3EEDown', 'TauFakep0EBDM0Up', 'TauFakep0EBDM0Down', 'TauFakep0EBDM1Up', 'TauFakep0EBDM1Down', 'TauFakep0EBDM10Up', 'TauFakep0EBDM10Down', 'TauFakep0EEDM0Up', 'TauFakep0EEDM0Down', 'TauFakep0EEDM1Up', 'TauFakep0EEDM1Down', 'TauFakep0EEDM10Up', 'TauFakep0EEDM10Down', 'TauFakep1EBDM0Up', 'TauFakep1EBDM0Down', 'TauFakep1EBDM1Up', 'TauFakep1EBDM1Down', 'TauFakep1EBDM10Up', 'TauFakep1EBDM10Down', 'TauFakep1EEDM0Up', 'TauFakep1EEDM0Down', 'TauFakep1EEDM1Up', 'TauFakep1EEDM1Down', 'TauFakep1EEDM10Up', 'TauFakep1EEDM10Down']

#fakes = ['', 'EleFakep0EBUp', 'EleFakep0EBDown', 'EleFakep1EBUp', 'EleFakep1EBDown', 'EleFakep2EBUp', 'EleFakep2EBDown', 'EleFakep0EEUp', 'EleFakep0EEDown', 'EleFakep1EEUp', 'EleFakep1EEDown', 'EleFakep2EEUp', 'EleFakep2EEDown', 'TauFakep0EBDM0Up', 'TauFakep0EBDM0Down', 'TauFakep0EBDM1Up', 'TauFakep0EBDM1Down', 'TauFakep0EBDM10Up', 'TauFakep0EBDM10Down', 'TauFakep0EEDM0Up', 'TauFakep0EEDM0Down', 'TauFakep0EEDM1Up', 'TauFakep0EEDM1Down', 'TauFakep0EEDM10Up', 'TauFakep0EEDM10Down', 'TauFakep1EBDM0Up', 'TauFakep1EBDM0Down', 'TauFakep1EBDM1Up', 'TauFakep1EBDM1Down', 'TauFakep1EBDM10Up', 'TauFakep1EBDM10Down', 'TauFakep1EEDM0Up', 'TauFakep1EEDM0Down', 'TauFakep1EEDM1Up', 'TauFakep1EEDM1Down', 'TauFakep1EEDM10Up', 'TauFakep1EEDM10Down']

sys = ['', 'puUp', 'puDown', 'pfUp', 'pfDown', 'trUp', 'trDown', 'tidUp', 'tidDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'bTagUp', 'bTagDown', 'embtrUp', 'embtrDown', 'embtrkUp', 'embtrkDown', 'mtfakeUp', 'mtfakeDown', 'etfakeUp', 'etfakeDown', 'etefakeUp', 'etefakeDown', 'scaletDM0Up', 'scaletDM0Down', 'scaletDM1Up', 'scaletDM1Down', 'scaletDM10Up', 'scaletDM10Down', 'eesUp', 'eesDown', 'DYptreweightUp', 'DYptreweightDown', 'UnclusteredEnDown', 'UnclusteredEnUp', 'TopptreweightUp', 'TopptreweightDown']

fakeSys = ['/TauFakep0EBDM0Up', '/TauFakep0EBDM0Down', '/TauFakep0EBDM1Up', '/TauFakep0EBDM1Down', '/TauFakep0EBDM10Up', '/TauFakep0EBDM10Down', '/TauFakep0EEDM0Up', '/TauFakep0EEDM0Down', '/TauFakep0EEDM1Up', '/TauFakep0EEDM1Down', '/TauFakep0EEDM10Up', '/TauFakep0EEDM10Down', '/TauFakep1EBDM0Up', '/TauFakep1EBDM0Down', '/TauFakep1EBDM1Up', '/TauFakep1EBDM1Down', '/TauFakep1EBDM10Up', '/TauFakep1EBDM10Down', '/TauFakep1EEDM0Up', '/TauFakep1EEDM0Down', '/TauFakep1EEDM1Up', '/TauFakep1EEDM1Down', '/TauFakep1EEDM10Up', '/TauFakep1EEDM10Down']

fakeEleSys = ['/EleFakep0EBUp', '/EleFakep0EBDown', '/EleFakep1EBUp', '/EleFakep1EBDown', '/EleFakep2EBUp', '/EleFakep2EBDown', '/EleFakep3EBUp', '/EleFakep3EBDown', '/EleFakep0EEUp', '/EleFakep0EEDown', '/EleFakep1EEUp', '/EleFakep1EEDown', '/EleFakep2EEUp', '/EleFakep2EEDown', '/EleFakep3EEUp', '/EleFakep3EEDown']

#fakeEleSys = ['/EleFakep0EBUp', '/EleFakep0EBDown', '/EleFakep1EBUp', '/EleFakep1EBDown', '/EleFakep2EBUp', '/EleFakep2EBDown', '/EleFakep0EEUp', '/EleFakep0EEDown', '/EleFakep1EEUp', '/EleFakep1EEDown', '/EleFakep2EEUp', '/EleFakep2EEDown']

scaleSys = ['/scaletDM0Up', '/scaletDM0Down', '/scaletDM1Up', '/scaletDM1Down', '/scaletDM10Up', '/scaletDM10Down']
