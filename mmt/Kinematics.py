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

def visibleMass(vm, ve):
  return (vm+ve).M()

def collMass(myMuon, myMET, myEle):
  ptnu = abs(myMET.Et()*cos(deltaPhi(myMET.Phi(), myEle.Phi())))
  visfrac = myEle.Pt()/(myEle.Pt() + ptnu)
  m_e_Mass = visibleMass(myMuon, myEle)
  return (m_e_Mass/sqrt(visfrac))

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

jes = ['JetAbsoluteFlavMapUp', 'JetAbsoluteFlavMapDown', 'JetAbsoluteMPFBiasUp', 'JetAbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']
