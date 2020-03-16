from math import sqrt, pi, exp, cos
import os
from FinalStateAnalysis.StatTools.RooFunctorFromWS import FunctorFromMVA

var_d_star = ['mPt', 'ePt', 'm_e_collinearMass', 'dPhiMuMET', 'dPhiEMET', 'dPhiMuE', 'MTMuMET', 'MTEMET']
xml_name = os.path.join(os.getcwd(), "bdtdata/dataset/weights/TMVAClassification_BDT.weights.xml")
functor = FunctorFromMVA('BDT method', xml_name, *var_d_star)

def var_d(myMuon, myMET, myEle):
    return {'mPt' : myMuon.Pt(), 'ePt' : myEle.Pt(), 'm_e_collinearMass' : collMass(myMuon, myMET, myEle), 'dPhiMuMET' : deltaPhi(myMuon.Phi(), myMET.Phi()), 'dPhiEMET' : deltaPhi(myEle.Phi(), myMET.Phi()), 'dPhiMuE' : deltaPhi(myMuon.Phi(), myEle.Phi()), 'MTMuMET' : transverseMass(myMuon, myMET), 'MTEMET' : transverseMass(myEle, myMET)}

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

jes = ['JetAbsoluteFlavMapUp', 'JetAbsoluteFlavMapDown', 'JetAbsoluteMPFBiasUp', 'JetAbsoluteMPFBiasDown', 'JetAbsoluteScaleUp', 'JetAbsoluteScaleDown', 'JetAbsoluteStatUp', 'JetAbsoluteStatDown', 'JetFlavorQCDUp', 'JetFlavorQCDDown', 'JetFragmentationUp', 'JetFragmentationDown', 'JetPileUpDataMCUp', 'JetPileUpDataMCDown', 'JetPileUpPtBBUp', 'JetPileUpPtBBDown', 'JetPileUpPtEC1Up', 'JetPileUpPtEC1Down', 'JetPileUpPtEC2Up', 'JetPileUpPtEC2Down', 'JetPileUpPtHFUp', 'JetPileUpPtHFDown', 'JetPileUpPtRefUp', 'JetPileUpPtRefDown', 'JetRelativeFSRUp', 'JetRelativeFSRDown', 'JetRelativeJEREC1Up', 'JetRelativeJEREC1Down', 'JetRelativeJEREC2Up', 'JetRelativeJEREC2Down', 'JetRelativeJERHFUp', 'JetRelativeJERHFDown', 'JetRelativePtBBUp', 'JetRelativePtBBDown', 'JetRelativePtEC1Up', 'JetRelativePtEC1Down', 'JetRelativePtEC2Up', 'JetRelativePtEC2Down', 'JetRelativePtHFUp', 'JetRelativePtHFDown', 'JetRelativeStatECUp', 'JetRelativeStatECDown', 'JetRelativeStatFSRUp', 'JetRelativeStatFSRDown', 'JetRelativeStatHFUp', 'JetRelativeStatHFDown', 'JetSinglePionECALUp', 'JetSinglePionECALDown', 'JetSinglePionHCALUp', 'JetSinglePionHCALDown', 'JetTimePtEtaUp', 'JetTimePtEtaDown', 'JetRelativeBalUp', 'JetRelativeBalDown', 'JetRelativeSampleUp', 'JetRelativeSampleDown']

ues = ['UnclusteredEnUp', 'UnclusteredEnDown', 'UesCHARGEDUp', 'UesCHARGEDDown', 'UesECALUp', 'UesECALDown', 'UesHCALUp', 'UesHCALDown', 'UesHFUp', 'UesHFDown']

names = ['TightOS', 'TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF']

ssnames = ['TightSS', 'TightSS0Jet', 'TightSS1Jet', 'TightSS2Jet', 'TightSS2JetVBF']

plotnames = ['TightOS', 'TightSS', 'TightOS0Jet', 'TightSS0Jet', 'TightOS1Jet', 'TightSS1Jet', 'TightOS0JetCut', 'TightSS0JetCut', 'TightOS1JetCut', 'TightSS1JetCut', 'TightOS2Jet', 'TightSS2Jet', 'TightOS2JetVBF', 'TightSS2JetVBF', 'TightOS2JetCut', 'TightSS2JetCut', 'TightOS2JetVBFCut', 'TightSS2JetVBFCut']

zttnames = ['TightOS', 'TightOS0Jet', 'TightOS1Jet', 'TightOS2Jet', 'TightOS2JetVBF', 'TightSS', 'TightSS0Jet', 'TightSS1Jet', 'TightSS2Jet', 'TightSS2JetVBF']

sys = ['', 'puUp', 'puDown', 'pfUp', 'pfDown', 'trUp', 'trDown', 'recrespUp', 'recrespDown', 'recresoUp', 'recresoDown', 'bTagUp', 'bTagDown', 'eescUp', 'eescDown', 'mesUp', 'mesDown', 'DYptreweightUp', 'DYptreweightDown', 'TopptreweightUp', 'TopptreweightDown']

sssys = ['', 'Rate0JetUp', 'Rate0JetDown', 'Shape0JetUp', 'Shape0JetDown', 'Rate1JetUp', 'Rate1JetDown', 'Shape1JetUp', 'Shape1JetDown', 'Rate2JetUp', 'Rate2JetDown', 'Shape2JetUp', 'Shape2JetDown', 'IsoUp', 'IsoDown']

qcdsys = ['', '/Rate0JetUp', '/Rate0JetDown', '/Shape0JetUp', '/Shape0JetDown', '/Rate1JetUp', '/Rate1JetDown', '/Shape1JetUp', '/Shape1JetDown', '/Rate2JetUp', '/Rate2JetDown', '/Shape2JetUp', '/Shape2JetDown', '/IsoUp', '/IsoDown']
