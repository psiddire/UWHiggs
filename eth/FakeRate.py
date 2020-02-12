import math

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.1881 + 0.0009793*pt
            elif shift=='frp0Up':
                fr = 0.2173 + 0.0009793*pt
            elif shift=='frp0Down':
                fr = 0.1589 + 0.0009793*pt
            elif shift=='frp1Up':
                fr = 0.1881 + 0.0015397*pt
            elif shift=='frp1Down':
                fr = 0.1881 + 0.0004189*pt
        elif dm==1:
            if shift=='':
                fr = 0.1963 - 0.0001146*pt
            elif shift=='frp0Up':
                fr = 0.2066 - 0.0001146*pt
            elif shift=='frp0Down':
                fr = 0.1860 - 0.0001146*pt
            elif shift=='frp1Up':
                fr = 0.1963 + 0.0000922*pt
            elif shift=='frp1Down':
                fr = 0.1963 - 0.0003214*pt
        elif dm==10:
            if shift=='':
                fr = 0.1203 + 0.0003771*pt
            elif shift=='frp0Up':
                fr = 0.1311 + 0.0003771*pt
            elif shift=='frp0Down':
                fr = 0.1095 + 0.0003771*pt
            elif shift=='frp1Up':
                fr = 0.1203 + 0.0005994*pt
            elif shift=='frp1Down':
                fr = 0.1203 + 0.0001548*pt
        elif dm==11:
            if shift=='':
                fr = 0.06572 + 0.0002651*pt
            elif shift=='frp0Up':
                fr = 0.07741 + 0.0002651*pt
            elif shift=='frp0Down':
                fr = 0.05403 + 0.0002651*pt
            elif shift=='frp1Up':
                fr = 0.06572 + 0.0005039*pt
            elif shift=='frp1Down':
                fr = 0.06572 + 0.0000263*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.2578 - 0.0004516*pt
            elif shift=='frp0Up':
                fr = 0.2918 - 0.0004516*pt
            elif shift=='frp0Down':
                fr = 0.2238 - 0.0004516*pt
            elif shift=='frp1Up':
                fr = 0.2578 + 0.0002112*pt
            elif shift=='frp1Down':
                fr = 0.2578 - 0.0011144*pt
        elif dm==1:
            if shift=='':
                fr = 0.1434 + 0.0004326*pt
            elif shift=='frp0Up':
                fr = 0.1642 + 0.0004326*pt
            elif shift=='frp0Down':
                fr = 0.1226 + 0.0004326*pt
            elif shift=='frp1Up':
                fr = 0.1434 + 0.0008731*pt
            elif shift=='frp1Down':
                fr = 0.1434 - 0.0000079*pt
        elif dm==10:
            if shift=='':
                fr = 0.1193 + 0.0001082*pt
            elif shift=='frp0Up':
                fr = 0.1372 + 0.0001082*pt
            elif shift=='frp0Down':
                fr = 0.1014 + 0.0001082*pt
            elif shift=='frp1Up':
                fr = 0.1193 + 0.0004949*pt
            elif shift=='frp1Down':
                fr = 0.1193 - 0.0002785*pt
        elif dm==11:
            if shift=='':
                fr = 0.03396 + 0.0005418*pt
            elif shift=='frp0Up':
                fr = 0.05346 + 0.0005418*pt
            elif shift=='frp0Down':
                fr = 0.01446 + 0.0005418*pt
            elif shift=='frp1Up':
                fr = 0.03396 + 0.0009643*pt
            elif shift=='frp1Down':
                fr = 0.03396 + 0.0001193*pt
    return fr/(1-fr)

def fakerateEle_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(0.09314 + 0.01229*pt)
        elif shift=='frp0Up':
            fr = math.tanh(0.11952 + 0.01229*pt)
        elif shift=='frp0Down':
            fr = math.tanh(0.06676 + 0.01229*pt)
        elif shift=='frp1Up':
            fr = math.tanh(0.09314 + 0.01303*pt)
        elif shift=='frp1Down':
            fr = math.tanh(0.09314 + 0.01155*pt)
    else:
        fr = 0
    return fr/(1-fr)
