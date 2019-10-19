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

names = ['TightOS', 'TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF']

lhe = ['lhe0', 'lhe1', 'lhe2', 'lhe3', 'lhe4', 'lhe5', 'lhe6', 'lhe7', 'lhe8', 'lhe9', 'lhe10', 'lhe11', 'lhe12', 'lhe13', 'lhe14', 'lhe15', 'lhe16', 'lhe17', 'lhe18', 'lhe19', 'lhe20', 'lhe21', 'lhe22', 'lhe23', 'lhe24', 'lhe25', 'lhe26', 'lhe27', 'lhe28', 'lhe29', 'lhe30', 'lhe31', 'lhe32', 'lhe33', 'lhe34', 'lhe35', 'lhe36', 'lhe37', 'lhe38', 'lhe39', 'lhe40', 'lhe41', 'lhe42', 'lhe43', 'lhe44', 'lhe45', 'lhe46', 'lhe47', 'lhe48', 'lhe49', 'lhe50', 'lhe51', 'lhe52', 'lhe53', 'lhe54', 'lhe55', 'lhe56', 'lhe57', 'lhe58', 'lhe59', 'lhe60', 'lhe61', 'lhe62', 'lhe63', 'lhe64', 'lhe65', 'lhe66', 'lhe67', 'lhe68', 'lhe69', 'lhe70', 'lhe71', 'lhe72', 'lhe73', 'lhe74', 'lhe75', 'lhe76', 'lhe77', 'lhe78', 'lhe79', 'lhe80', 'lhe81', 'lhe82', 'lhe83', 'lhe84', 'lhe85', 'lhe86', 'lhe87', 'lhe88', 'lhe89', 'lhe90', 'lhe91', 'lhe92', 'lhe93', 'lhe94', 'lhe95', 'lhe96', 'lhe97', 'lhe98', 'lhe99', 'lhe100', 'lhe101', 'lhe102', 'lhe103', 'lhe104', 'lhe105', 'lhe106', 'lhe107', 'lhe108', 'lhe109', 'lhe110', 'lhe111', 'lhe112', 'lhe113', 'lhe114', 'lhe115', 'lhe116', 'lhe117', 'lhe118', 'lhe119']
