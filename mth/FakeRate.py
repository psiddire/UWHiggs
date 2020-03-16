import math
import ROOT

f = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2018/FRMMT.root")
bdm0 = f.Get("EBDM0")
bdm1 = f.Get("EBDM1")
bdm10 = f.Get("EBDM10")
bdm11 = f.Get("EBDM11")
edm0 = f.Get("EEDM0")
edm1 = f.Get("EEDM1")
edm10 = f.Get("EEDM10")
edm11 = f.Get("EEDM11")

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = bdm0.Value(0) + bdm0.Value(1) * pt
            elif shift=='frp0Up':
                fr = bdm0.Value(0) + bdm0.ParError(0) + bdm0.Value(1) * pt
            elif shift=='frp0Down':
                fr = bdm0.Value(0) - bdm0.ParError(0) + bdm0.Value(1) * pt
            elif shift=='frp1Up':
                fr = bdm0.Value(0) + (bdm0.Value(1) + bdm0.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = bdm0.Value(0) + (bdm0.Value(1) - bdm0.ParError(1)) * pt
        elif dm==1:
            if shift=='':
                fr = bdm1.Value(0) + bdm1.Value(1) * pt
            elif shift=='frp0Up':
                fr = bdm1.Value(0) + bdm1.ParError(0) + bdm1.Value(1) * pt
            elif shift=='frp0Down':
                fr = bdm1.Value(0) - bdm1.ParError(0) + bdm1.Value(1) * pt
            elif shift=='frp1Up':
                fr = bdm1.Value(0) + (bdm1.Value(1) + bdm1.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = bdm1.Value(0) + (bdm1.Value(1) - bdm1.ParError(1)) * pt
        elif dm==10:
            if shift=='':
                fr = bdm10.Value(0) + bdm10.Value(1) * pt
            elif shift=='frp0Up':
                fr = bdm10.Value(0) + bdm10.ParError(0) + bdm10.Value(1) * pt
            elif shift=='frp0Down':
                fr = bdm10.Value(0) - bdm10.ParError(0) + bdm10.Value(1) * pt
            elif shift=='frp1Up':
                fr = bdm10.Value(0) + (bdm10.Value(1) + bdm10.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = bdm10.Value(0) + (bdm10.Value(1) - bdm10.ParError(1)) * pt
        elif dm==11:
            if shift=='':
                fr = bdm11.Value(0) + bdm11.Value(1) * pt
            elif shift=='frp0Up':
                fr = bdm11.Value(0) + bdm11.ParError(0) + bdm11.Value(1) * pt
            elif shift=='frp0Down':
                fr = bdm11.Value(0) - bdm11.ParError(0) + bdm11.Value(1) * pt
            elif shift=='frp1Up':
                fr = bdm11.Value(0) + (bdm11.Value(1) + bdm11.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = bdm11.Value(0) + (bdm11.Value(1) - bdm11.ParError(1)) * pt
    else:
        if dm==0:
            if shift=='':
                fr = edm0.Value(0) + edm0.Value(1) * pt
            elif shift=='frp0Up':
                fr = edm0.Value(0) + edm0.ParError(0) + edm0.Value(1) * pt
            elif shift=='frp0Down':
                fr = edm0.Value(0) - edm0.ParError(0) + edm0.Value(1) * pt
            elif shift=='frp1Up':
                fr = edm0.Value(0) + (edm0.Value(1) + edm0.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = edm0.Value(0) + (edm0.Value(1) - edm0.ParError(1)) * pt
        elif dm==1:
            if shift=='':
                fr = edm1.Value(0) + edm1.Value(1) * pt
            elif shift=='frp0Up':
                fr = edm1.Value(0) + edm1.ParError(0) + edm1.Value(1) * pt
            elif shift=='frp0Down':
                fr = edm1.Value(0) - edm1.ParError(0) + edm1.Value(1) * pt
            elif shift=='frp1Up':
                fr = edm1.Value(0) + (edm1.Value(1) + edm1.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = edm1.Value(0) + (edm1.Value(1) - edm1.ParError(1)) * pt
        elif dm==10:
            if shift=='':
                fr = edm10.Value(0) + edm10.Value(1) * pt
            elif shift=='frp0Up':
                fr = edm10.Value(0) + edm10.ParError(0) + edm10.Value(1) * pt
            elif shift=='frp0Down':
                fr = edm10.Value(0) - edm10.ParError(0) + edm10.Value(1) * pt
            elif shift=='frp1Up':
                fr = edm10.Value(0) + (edm10.Value(1) + edm10.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = edm10.Value(0) + (edm10.Value(1) - edm10.ParError(1)) * pt
        elif dm==11:
            if shift=='':
                fr = edm11.Value(0) + edm11.Value(1) * pt
            elif shift=='frp0Up':
                fr = edm11.Value(0) + edm11.ParError(0) + edm11.Value(1) * pt
            elif shift=='frp0Down':
                fr = edm11.Value(0) - edm11.ParError(0) + edm11.Value(1) * pt
            elif shift=='frp1Up':
                fr = edm11.Value(0) + (edm11.Value(1) + edm11.ParError(1)) * pt
            elif shift=='frp1Down':
                fr = edm11.Value(0) + (edm11.Value(1) - edm11.ParError(1)) * pt
    return fr/(1-fr)

fm = ROOT.TFile("../../FinalStateAnalysis/TagAndProbe/data/2018/FRMMM.root")
mfr = fm.Get("MuonFR")

def fakerateMuon_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(mfr.Value(0) + mfr.Value(1) * pt)
        elif shift=='frp0Up':
            fr = math.tanh(mfr.Value(0) + mfr.ParError(0) + mfr.Value(1) * pt)
        elif shift=='frp0Down':
            fr = math.tanh(mfr.Value(0) - mfr.ParError(0) + mfr.Value(1) * pt)
        elif shift=='frp1Up':
            fr = math.tanh(mfr.Value(0) + (mfr.Value(1) + mfr.ParError(1)) * pt)
        elif shift=='frp1Down':
            fr = math.tanh(mfr.Value(0) + (mfr.Value(1) - mfr.ParError(1)) * pt)
    else:
        fr = 0
    return fr/(1-fr)
