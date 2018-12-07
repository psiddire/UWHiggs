import ROOT
from ROOT import TTree, TLorentzVector, Math
import math

# This is a thin configurable layer ontop of FSA TTrees that
# gives us in a uniformly presented way the corrected versions
# of leptons/photons that have been stored in the event.

# this module creates a common set of kinematic variables to use
# the 'setup' function is at the bottom of the file

# corrNames available in the ntuple (right now) are:
# electrons: CorrReg, CorrSmearedNoReg, CorrSmearedReg
# muons: RochCor

baseNames = {'electron'  : ['e1','e2','g'],
             'muon'      : ['m1','m2','g']}

electronTargetNames = {(2011,'mc'):'Fall11',
                       (2011,'data'):'Jan16ReReco',
                       (2012,'mc'):'Summer12_DR53X_HCP2012',
                       #(2012,'data'):'Summer12_DR53X_HCP2012'}
                       (2012,'data'):'2012Jul13ReReco'}

muonTargetNames = {(2011,'A'):'2011A',
                   (2011,'B'):'2011B',
                   (2012,'ABCD'):'2012'}

#base class for a set of functors
class correction:
    def __init__(self, year, run, channel, gamCorrName):
        self._l1Name = baseNames[channel][0]
        self._l2Name = baseNames[channel][1]
        self._gName  = baseNames[channel][2]
        self._gamCorrName = gamCorrName
        self._year = year
        self._run = run
        self._channel = channel

        self._lep1CorrPt = self.lep1CorrPt()
        self._lep2CorrPt = self.lep2CorrPt()
        self._gamCorrPt = self.gamCorrPt()

        self._lep1CorrEta = self.lep1CorrEta()
        self._lep2CorrEta = self.lep2CorrEta()
        self._gamCorrEta = self.gamCorrEta()

        self._lep1CorrPhi = self.lep1CorrPhi()
        self._lep2CorrPhi = self.lep2CorrPhi()

    def setVanilla(self, doVanilla=True):
        if doVanilla:
            self._lep1CorrPt = '%sPt'%(self._l1Name)
            self._lep2CorrPt = '%sPt'%(self._l2Name)
            self._gamCorrpt = '%sPt'%(self._gName)
            
            self._lep1CorrEta = '%sEta'%(self._l1Name)
            self._lep2CorrEta = '%sEta'%(self._l2Name)
            self._gamCorrEta = '%sEta'%(self._gName)
            
            self._lep1CorrPhi = '%sPhi'%(self._l1Name)
            self._lep2CorrPhi = '%sPhi'%(self._l2Name)            
            
        else:
            self._lep1CorrPt = self.lep1CorrPt()
            self._lep2CorrPt = self.lep2CorrPt()
            self._gamCorrPt = self.gamCorrPt()
            
            self._lep1CorrEta = self.lep1CorrEta()
            self._lep2CorrEta = self.lep2CorrEta()
            self._gamCorrEta = self.gamCorrEta()
            
            self._lep1CorrPhi = self.lep1CorrPhi()
            self._lep2CorrPhi = self.lep2CorrPhi()
    
    def gamCorrPt(self):
        return '%sPt'%(self._gName)

    def gamCorrEta(self):
        return '%sEta'%(self._gName)

    def lep1CorrPt(self):
        raise Exception('not implemented in base')
    def lep1CorrEta(self):
        raise Exception('not implemented in base')
    def lep1CorrPhi(self):
        raise Exception('not implemented in base')

    def lep2CorrPt(self):
        raise Exception('not implemented in base')
    def lep2CorrEta(self):
        raise Exception('not implemented in base')
    def lep2CorrPhi(self):
        raise Exception('not implemented in base')
        
    def __call__(self,event):
        #corrected electrons to put into the event
        corre1s = []
        corre2s = []
        corrgs   = []
        Zs = []
        Zgs = []
        
        corrPtName1 = self._lep1CorrPt
        corrPtName2 = self._lep2CorrPt
        corrPtNameG = self._gamCorrPt

        corrEtaName1 = self._lep1CorrEta
        corrEtaName2 = self._lep2CorrEta
        corrEtaNameG = self._gamCorrEta
        
        corrPhiName1 = self._lep1CorrPhi
        corrPhiName2 = self._lep2CorrPhi

        corrPt_1 = getattr(event,corrPtName1)
        corrPt_2 = getattr(event,corrPtName2)
        corrPt_G = getattr(event,corrPtNameG)

        corrEta_1 = getattr(event,corrEtaName1)
        corrEta_2 = getattr(event,corrEtaName2)
        corrEta_G = getattr(event,corrEtaNameG)

        corrPhi_1 = getattr(event,corrPhiName1)
        corrPhi_2 = getattr(event,corrPhiName2)
        
        for i in range(event.N_PATFinalState):
            #recalculate the photon vector from the PV
            corrgs.append(TLorentzVector())
            pv    = Math.XYZPoint(event.pvX[i], event.pvY[i], event.pvZ[i])
            phoSC = Math.XYZPoint(event.gPositionX[i],
                                  event.gPositionY[i],
                                  event.gPositionZ[i])
            phoTemp = Math.XYZVector(phoSC.X() - pv.X(),
                                     phoSC.Y() - pv.Y(),
                                     phoSC.Z() - pv.Z())            
            corrE_G = corrPt_G[i]*math.cosh(corrEta_G[i])           
            phoP3 = phoTemp.unit()*corrE_G
            phoP4 = Math.XYZTVector(phoP3.x(),
                                    phoP3.y(),
                                    phoP3.z(),
                                    corrE_G)            
            corrgs[-1].SetPtEtaPhiM(phoP4.pt(),phoP4.eta(),phoP4.phi(),0.0)
            #create e1 corrected LorentzVector and error
            corre1s.append(TLorentzVector())
            pt1 = corrPt_1[i]
            eta1 = corrEta_1[i]
            phi1 = corrPhi_1[i]
            corre1s[-1].SetPtEtaPhiM(pt1,eta1,phi1,self._leptonMass)
            #create e2 corrected LorentzVector and error
            corre2s.append(TLorentzVector())
            pt2 = corrPt_2[i]
            eta2 = corrEta_2[i]
            phi2 = corrPhi_2[i]
            corre2s[-1].SetPtEtaPhiM(pt2,eta2,phi2,self._leptonMass)
            #make composite particles
            Zs.append(corre1s[-1]+corre2s[-1])
            Zgs.append(corre1s[-1]+corre2s[-1]+corrgs[-1])

        #add the newly calculated particles back to the event
        #using a common naming
        setattr(event,'ell1',corre1s)
        setattr(event,'ell2',corre2s)
        setattr(event,'gam',corrgs)
        setattr(event,'Z',Zs)
        setattr(event,'Zg',Zgs)

class eChan_correction(correction):
    def __init__(self, year, run, channel, datType,
                 eleCorrName, gamCorrName):
        self._leptonMass = 0.000511 # in GeV
        self._lepCorrName = eleCorrName        
        idx = (year, datType)
        self._targetName = electronTargetNames[idx]
        correction.__init__(self,year,run,channel,gamCorrName)

    def lep1CorrPt(self):
        return '%sPt%s_%s'%(self._l1Name,self._lepCorrName,
                                self._targetName)
    def lep1CorrEta(self):
        return '%sEta%s_%s'%(self._l1Name,self._lepCorrName,
                                 self._targetName)
    def lep1CorrPhi(self):
        return '%sPhi%s_%s'%(self._l1Name,self._lepCorrName,
                                 self._targetName)

    def lep2CorrPt(self):
        return '%sPt%s_%s'%(self._l2Name,self._lepCorrName,
                            self._targetName)
    def lep2CorrEta(self):
        return '%sEta%s_%s'%(self._l2Name,self._lepCorrName,
                             self._targetName)
    def lep2CorrPhi(self):
        return '%sPhi%s_%s'%(self._l2Name,self._lepCorrName,
                             self._targetName)

class muChan_correction(correction):
    def __init__(self, year, run, channel, datType,
                 muCorrName, gamCorrName):
        self._leptonMass = 0.105658 # in GeV
        self._lepCorrName = muCorrName        
        idx = (year, run)
        self._targetName = muonTargetNames[idx]
        correction.__init__(self,year,run,channel,gamCorrName)

    def lep1CorrPt(self):
        return '%sPt%s%s'%(self._l1Name,self._lepCorrName,
                           self._targetName)
    def lep1CorrEta(self):
        return '%sEta%s%s'%(self._l1Name,self._lepCorrName,
                            self._targetName)
    def lep1CorrPhi(self):        
        return '%sPhi%s%s'%(self._l1Name,self._lepCorrName,
                            self._targetName)
        
    def lep2CorrPt(self):
        return '%sPt%s%s'%(self._l2Name,self._lepCorrName,
                           self._targetName)
    def lep2CorrEta(self):
        return '%sEta%s%s'%(self._l2Name,self._lepCorrName,
                            self._targetName)
    def lep2CorrPhi(self):
        return '%sPhi%s%s'%(self._l2Name,self._lepCorrName,
                             self._targetName)

channels = ['electron','muon']
corrections = { 'electron' : eChan_correction,
                'muon'     : muChan_correction }

lep_corrs = { 'electron' : ['CorrReg', 'CorrSmearedNoReg', 'CorrSmearedReg'],
              'muon'     : ['RochCor'] }

def setup_corrections(year, run, channel, datType, lepCorrName='',
                      gamCorrName='',vanilla=False):
    if channel not in channels:
        raise Exception('Channel must be "electron" or "muon"!')
    if lepCorrName not in lep_corrs[channel] and not vanilla:
        raise Exception( 'Correction %s not available please choose from: '\
                         %(lepCorrName) + repr(lep_corrs[channel]) )
    correction = corrections[channel](year, run, channel, datType,
                                      lepCorrName, gamCorrName)
    correction.setVanilla(vanilla)
    return correction
    
    
    
