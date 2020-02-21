import math

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.1961 + 0.0004182*pt
            elif shift=='frp0Up':
                fr = 0.2215 + 0.0004182*pt
            elif shift=='frp0Down':
                fr = 0.1707 + 0.0004182*pt
            elif shift=='frp1Up':
                fr = 0.1961 + 0.0009117*pt
            elif shift=='frp1Down':
                fr = 0.1961 - 0.0000753*pt
        elif dm==1:
            if shift=='':
                fr = 0.1751 - 0.00008975*pt
            elif shift=='frp0Up':
                fr = 0.1844 - 0.00008975*pt
            elif shift=='frp0Down':
                fr = 0.1658 - 0.00008975*pt
            elif shift=='frp1Up':
                fr = 0.1751 + 0.00009375*pt
            elif shift=='frp1Down':
                fr = 0.1751 - 0.00027325*pt
        elif dm==10:
            if shift=='':
                fr = 0.1098 + 0.0006436*pt
            elif shift=='frp0Up':
                fr = 0.1209 + 0.0006436*pt
            elif shift=='frp0Down':
                fr = 0.0987 + 0.0006436*pt
            elif shift=='frp1Up':
                fr = 0.1098 + 0.0008747*pt
            elif shift=='frp1Down':
                fr = 0.1098 + 0.0004125*pt
        elif dm==11:
            if shift=='':
                fr = 0.05171 + 0.0003276*pt
            elif shift=='frp0Up':
                fr = 0.06326 + 0.0003276*pt
            elif shift=='frp0Down':
                fr = 0.04016 + 0.0003276*pt
            elif shift=='frp1Up':
                fr = 0.05171 + 0.0005632*pt
            elif shift=='frp1Down':
                fr = 0.05171 + 0.0000920*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.1141 + 0.00216*pt
            elif shift=='frp0Up':
                fr = 0.1534 + 0.00216*pt
            elif shift=='frp0Down':
                fr = 0.0748 + 0.00216*pt
            elif shift=='frp1Up':
                fr = 0.1141 + 0.0030235*pt
            elif shift=='frp1Down':
                fr = 0.1141 + 0.0012965*pt
        elif dm==1:
            if shift=='':
                fr = 0.1583 + 0.0005381*pt
            elif shift=='frp0Up':
                fr = 0.1799 + 0.0005381*pt
            elif shift=='frp0Down':
                fr = 0.1367 + 0.0005381*pt
            elif shift=='frp1Up':
                fr = 0.1583 + 0.0009898*pt
            elif shift=='frp1Down':
                fr = 0.1583 + 0.0000864*pt
        elif dm==10:
            if shift=='':
                fr = 0.1216 + 0.0002178*pt
            elif shift=='frp0Up':
                fr = 0.1416 + 0.0002178*pt
            elif shift=='frp0Down':
                fr = 0.1016 + 0.0002178*pt
            elif shift=='frp1Up':
                fr = 0.1216 + 0.0006493*pt
            elif shift=='frp1Down':
                fr = 0.1216 - 0.0002137*pt
        elif dm==11:
            if shift=='':
                fr = 0.0675 - 0.00005908*pt
            elif shift=='frp0Up':
                fr = 0.08527 - 0.00005908*pt
            elif shift=='frp0Down':
                fr = 0.04973 - 0.00005908*pt
            elif shift=='frp1Up':
                fr = 0.0675 + 0.0002901*pt
            elif shift=='frp1Down':
                fr = 0.0675 - 0.0004083*pt
    return fr/(1-fr)

def fakerateEle_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(0.1955 + 0.01097*pt)
        elif shift=='frp0Up':
            fr = math.tanh(0.2284 + 0.01097*pt)
        elif shift=='frp0Down':
            fr = math.tanh(0.1627 + 0.01097*pt)
        elif shift=='frp1Up':
            fr = math.tanh(0.1955 + 0.01191*pt)
        elif shift=='frp1Down':
            fr = math.tanh(0.1955 + 0.01003*pt)
    else:
        fr = 0
    return fr/(1-fr)
