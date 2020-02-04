import math

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2235 - 0.00001546*pt
            elif shift=='frp0Up':
                fr = 0.2388 - 0.00001546*pt
            elif shift=='frp0Down':
                fr = 0.2082 - 0.00001546*pt
            elif shift=='frp1Up':
                fr = 0.2235 + 0.00029534*pt
            elif shift=='frp1Down':
                fr = 0.2235 - 0.00032626*pt
        elif dm==1:
            if shift=='':
                fr = 0.1935 - 0.0007176*pt
            elif shift=='frp0Up':
                fr = 0.2014 - 0.0007176*pt
            elif shift=='frp0Down':
                fr = 0.1856 - 0.0007176*pt
            elif shift=='frp1Up':
                fr = 0.1935 - 0.0005675*pt
            elif shift=='frp1Down':
                fr = 0.1935 - 0.0008677*pt
        elif dm==10:
            if shift=='':
                fr = 0.1663 - 0.0001601*pt
            elif shift=='frp0Up':
                fr = 0.1805 - 0.0001601*pt
            elif shift=='frp0Down':
                fr = 0.1521 - 0.0001601*pt
            elif shift=='frp1Up':
                fr = 0.1663 + 0.0001346*pt
            elif shift=='frp1Down':
                fr = 0.1663 - 0.0004548*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.3117 - 0.0010520*pt
            elif shift=='frp0Up':
                fr = 0.3404 - 0.0010520*pt
            elif shift=='frp0Down':
                fr = 0.2829 - 0.0010520*pt
            elif shift=='frp1Up':
                fr = 0.3117 - 0.0004474*pt
            elif shift=='frp1Down':
                fr = 0.3117 - 0.0016566*pt
        elif dm==1:
            if shift=='':
                fr = 0.17100 - 0.0002477*pt
            elif shift=='frp0Up':
                fr = 0.18875 - 0.0002477*pt
            elif shift=='frp0Down':
                fr = 0.15325 - 0.0002477*pt
            elif shift=='frp1Up':
                fr = 0.17100 + 0.0001124*pt
            elif shift=='frp1Down':
                fr = 0.17100 - 0.0006078*pt
        elif dm==10:
            if shift=='':
                fr = 0.1402 - 0.0001903*pt
            elif shift=='frp0Up':
                fr = 0.1704 - 0.0001903*pt
            elif shift=='frp0Down':
                fr = 0.1100 - 0.0001903*pt
            elif shift=='frp1Up':
                fr = 0.1402 + 0.0004806*pt
            elif shift=='frp1Down':
                fr = 0.1402 - 0.0008612*pt
    return fr/(1-fr)

def fakerateDeep_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.1484 + 0.0013540*pt
            elif shift=='frp0Up':
                fr = 0.1769 + 0.0013540*pt
            elif shift=='frp0Down':
                fr = 0.1199 + 0.0013540*pt
            elif shift=='frp1Up':
                fr = 0.1484 + 0.0019232*pt
            elif shift=='frp1Down':
                fr = 0.1484 + 0.0007848*pt
        elif dm==1:
            if shift=='':
                fr = 0.1537 + 0.0001054*pt
            elif shift=='frp0Up':
                fr = 0.1648 + 0.0001054*pt
            elif shift=='frp0Down':
                fr = 0.1426 + 0.0001054*pt
            elif shift=='frp1Up':
                fr = 0.1537 + 0.0003326*pt
            elif shift=='frp1Down':
                fr = 0.1537 - 0.0001218*pt
        elif dm==10:
            if shift=='':
                fr = 0.1004 + 0.0007418*pt
            elif shift=='frp0Up':
                fr = 0.1135 + 0.0007418*pt
            elif shift=='frp0Down':
                fr = 0.0873 + 0.0007418*pt
            elif shift=='frp1Up':
                fr = 0.1004 + 0.0010153*pt
            elif shift=='frp1Down':
                fr = 0.1004 + 0.0004683*pt
        elif dm==11:
            if shift=='':
                fr = 0.05991 + 0.000111*pt
            elif shift=='frp0Up':
                fr = 0.07126 + 0.000111*pt
            elif shift=='frp0Down':
                fr = 0.04856 + 0.000111*pt
            elif shift=='frp1Up':
                fr = 0.05991 + 0.0003314*pt
            elif shift=='frp1Down':
                fr = 0.05991 - 0.0001094*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.17800 + 0.0002186*pt
            elif shift=='frp0Up':
                fr = 0.21556 + 0.0002186*pt
            elif shift=='frp0Down':
                fr = 0.14044 + 0.0002186*pt
            elif shift=='frp1Up':
                fr = 0.17800 + 0.0010114*pt
            elif shift=='frp1Down':
                fr = 0.17800 - 0.0005742*pt
        elif dm==1:
            if shift=='':
                fr = 0.1139 + 0.0004858*pt
            elif shift=='frp0Up':
                fr = 0.1345 + 0.0004858*pt
            elif shift=='frp0Down':
                fr = 0.0933 + 0.0004858*pt
            elif shift=='frp1Up':
                fr = 0.1139 + 0.0009229*pt
            elif shift=='frp1Down':
                fr = 0.1139 + 0.0000487*pt
        elif dm==10:
            if shift=='':
                fr = 0.1079 + 0.0004141*pt
            elif shift=='frp0Up':
                fr = 0.1333 + 0.0004141*pt
            elif shift=='frp0Down':
                fr = 0.0825 + 0.0004141*pt
            elif shift=='frp1Up':
                fr = 0.1079 + 0.0009720*pt
            elif shift=='frp1Down':
                fr = 0.1079 - 0.0001438*pt
        elif dm==11:
            if shift=='':
                fr = -0.001122 + 0.0007804*pt
            elif shift=='frp0Up':
                fr = +0.014938 + 0.0007804*pt
            elif shift=='frp0Down':
                fr = -0.017182 + 0.0007804*pt
            elif shift=='frp1Up':
                fr = -0.001122 + 0.0011339*pt
            elif shift=='frp1Down':
                fr = -0.001122 + 0.0004269*pt
    return fr/(1-fr)

def fakerateEle_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(0.07532 + 0.012550*pt)
        elif shift=='frp0Up':
            fr = math.tanh(0.11813 + 0.012550*pt)
        elif shift=='frp0Down':
            fr = math.tanh(0.03251 + 0.012550*pt)
        elif shift=='frp1Up':
            fr = math.tanh(0.07532 + 0.013791*pt)
        elif shift=='frp1Down':
            fr = math.tanh(0.07532 + 0.011309*pt)
    else:
        fr = 0
    return fr/(1-fr)
