import os
import sys
import re
import ROOT
import math

class MEtSys:

    def  __init__(self, fileName):
        cmsswBase ="/afs/hep.wisc.edu/home/psiddire/CMSSW_9_4_9"
        baseDir = cmsswBase + "/src/FinalStateAnalysis/TagAndProbe/data"
        _fileName = baseDir+"/"+fileName
        File = ROOT.TFile.Open(_fileName)

        if (File.IsZombie()):
            print "file not found"
            sys.exit(-1)

        typeBkgdH = File.Get("typeBkgdH")
        if (typeBkgdH == None):
            print "File should contain histogram with the name typeBkgdH "
            sys.exit(-1)

        jetBinsH = File.Get("jetBinsH")
        if (jetBinsH == None):
            print "File should contain histogram with the name jetBinsH "
            sys.exit(-1)

        global nBkgdTypes
        nBkgdTypes = typeBkgdH.GetNbinsX()
        Bkgd = []
        global nJetBins
        nJetBins = jetBinsH.GetNbinsX()
        JetBins = []

        for i in range(nBkgdTypes):
            Bkgd.append(typeBkgdH.GetXaxis().GetBinLabel(i+1))
        for i in range(nJetBins):
            JetBins.append(jetBinsH.GetXaxis().GetBinLabel(i+1))

        uncType = ["Response", "Resolution"]

        global sysUnc
        sysUnc = [[[] for x in range(2)] for y in range(nBkgdTypes)]

        for i in range(nBkgdTypes):
            histName = Bkgd[i]+"_syst"
            hist = File.Get(histName)
            if (hist == None):
                print "Histogram ", histName, " should be contained in file"
                sys.exit(-1)
            for xBin in range(2):
                for yBin in range(3):
                    sysUnc[i][xBin].append(hist.GetBinContent(xBin+1,yBin+1))

        global responseHist 
        responseHist = [[] for x in range(nBkgdTypes)] 

        for i in range(nBkgdTypes):
            for j in range(nJetBins):
                histName = Bkgd[i]+"_"+JetBins[j]
                responseHist[i].append(File.Get(histName))
                if (responseHist[i][j] == None):
                    print "Histogram ", histName, " should be contained in file"
                    sys.exit(-1)

        global histoName
        histoName = [[] for x in range(nBkgdTypes)]

        for i in range(nBkgdTypes):
            for j in range(nJetBins):
                histoName[i].append(Bkgd[i]+"_"+JetBins[j])


    def ComputeHadRecoilFromMet(self, metX, metY, genVPx, genVPy, visVPx, visVPy):

        genVPt = ROOT.TMath.Sqrt(genVPx*genVPx+genVPy*genVPy)
        unitX = genVPx/genVPt
        unitY = genVPy/genVPt

        unitPhi = ROOT.TMath.ATan2(unitY,unitX)
        unitPerpX = ROOT.TMath.Cos(unitPhi+0.5*ROOT.TMath.Pi())
        unitPerpY = ROOT.TMath.Sin(unitPhi+0.5*ROOT.TMath.Pi())

        Hx = -metX - visVPx
        Hy = -metY - visVPy

        Hparal = Hx*unitX + Hy*unitY
        Hperp = Hx*unitPerpX + Hy*unitPerpY

        return [Hparal, Hperp]


    def ComputeMetFromHadRecoil(self, Hparal, Hperp, genVPx, genVPy, visVPx, visVPy):

        genVPt = ROOT.TMath.Sqrt(genVPx*genVPx+genVPy*genVPy)
        unitX = genVPx/genVPt
        unitY = genVPy/genVPt

        unitPhi = ROOT.TMath.ATan2(unitY,unitX)
        unitPerpX = ROOT.TMath.Cos(unitPhi+0.5*ROOT.TMath.Pi())
        unitPerpY = ROOT.TMath.Sin(unitPhi+0.5*ROOT.TMath.Pi())

        det = unitX*unitPerpY - unitY*unitPerpX
        Hx = (Hparal*unitPerpY - Hperp*unitY)/det
        Hy = (Hperp*unitX - Hparal*unitPerpX)/det

        metX = -Hx - visVPx
        metY = -Hy - visVPy

        return [metX, metY]

        
    def ShiftResponseMet(self, metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysShift):

        genVPt = ROOT.TMath.Sqrt(genVPx*genVPx+genVPy*genVPy)

        if (genVPt < 1.0):
            metShiftPx = metPx
            metShiftPy = metPy
            return

        H = self.ComputeHadRecoilFromMet(metPx, metPy, genVPx, genVPy, visVPx, visVPy)
        Hparal = H[0]
        Hperp = H[1]

        jets = njets 
        if (jets > 2): jets = 2 
        if (jets < 0):
            print "MEtSys::ShiftResponseMet() : Number of jets is negative !"
            sys.exit(-1)

        if (bkgdType < 0 or bkgdType >= nBkgdTypes):
            print "MEtSys::ShiftResponseMet() : Background type ", bkgdType, " does not correspond to any of allowed options : "
            print "0 : Z(W)+Jets"
            print "1 : EWK+single-top"
            print "2 : top pair"   
            sys.exit(-1)

        File = ROOT.TFile.Open("/afs/hep.wisc.edu/home/psiddire/CMSSW_9_4_9/src/FinalStateAnalysis/TagAndProbe/data/MEtSys_2017.root")
        mean = -File.Get(histoName[bkgdType][jets]).Interpolate(genVPt)*genVPt
        shift = sysShift*mean
        Hparal = Hparal + (shift-mean)

        met = self.ComputeMetFromHadRecoil(Hparal, Hperp, genVPx, genVPy, visVPx, visVPy)

        return met


    def ShiftResolutionMet(self, metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysShift):

        genVPt = ROOT.TMath.Sqrt(genVPx*genVPx+genVPy*genVPy)

        if (genVPt < 1.0):
            metShiftPx = metPx
            metShiftPy = metPy
            return

        H = self.ComputeHadRecoilFromMet(metPx, metPy, genVPx, genVPy, visVPx, visVPy)
        Hparal = H[0]
        Hperp = H[1]

        jets = njets
        if (jets > 2): jets = 2 
        if (jets < 0):
            print "MEtSys::ShiftResponseMet() : Number of jets is negative !"
            sys.exit(-1)

        if (bkgdType < 0 or bkgdType >= nBkgdTypes):
            print "MEtSys::ShiftResponseMet() : Background type ", bkgdType, " does not correspond to any of allowed options : "
            print "0 : Z(W)+Jets"
            print "1 : EWK+single-top"
            print "2 : top pair"
            sys.exit(-1)

        File = ROOT.TFile.Open("/afs/hep.wisc.edu/home/psiddire/CMSSW_9_4_9/src/FinalStateAnalysis/TagAndProbe/data/MEtSys_2017.root")
        mean = -File.Get(histoName[bkgdType][jets]).Interpolate(genVPt)*genVPt
        Hperp = sysShift*Hperp
        Hparal = mean + (Hparal-mean)*sysShift

        met = self.ComputeMetFromHadRecoil(Hparal, Hperp, genVPx, genVPy, visVPx, visVPy)

        return met


    def ShiftMEt(self, metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysType, sysShift):

        if (sysType==0):
            met = self.ShiftResponseMet(metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysShift)
        else: 
            met = self.ShiftResolutionMet(metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysShift)

        return met


    def ApplyMEtSys(self, metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, sysType, sysShift):

        if (bkgdType < 0 or bkgdType >= nBkgdTypes):
            print "MEtSys::ShiftResponseMet() : Background type ", bkgdType, " does not correspond to any of allowed options : "
            print "0 : Z(W)+Jets"
            print "1 : EWK+single-top"
            print "2 : top pair"
            sys.exit(-1)

        jets = njets 
        if (jets > 2): jets = 2 
        if (jets < 0):
            print "MEtSys::ApplyMEtSys() : Number of jets is negative !"
            sys.exit(-1)

        typ = 0
        if (sysType!=0): typ = 1

        scale = 1 + sysUnc[bkgdType][typ][jets]
        if (sysShift!=0): scale = 1 - sysUnc[bkgdType][typ][jets]

        met = self.ShiftMEt(metPx, metPy, genVPx, genVPy, visVPx, visVPy, njets, bkgdType, typ, scale)

        return met
