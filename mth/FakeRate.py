import math

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2385 - 0.0003658*pt
            elif shift=='frp0Up':
                fr = 0.25067 - 0.0003658*pt
            elif shift=='frp0Down':
                fr = 0.22633 - 0.0003658*pt
            elif shift=='frp1Up':
                fr = 0.2385 - 0.0001098*pt
            elif shift=='frp1Down':
                fr = 0.2385 - 0.0006218*pt
        elif dm==1:
            if shift=='':
                fr = 0.1798 + 0.00004593*pt
            elif shift=='frp0Up':
                fr = 0.186194 + 0.00004593*pt
            elif shift=='frp0Down':
                fr = 0.173406 + 0.00004593*pt
            elif shift=='frp1Up':
                fr = 0.1798 + 0.00017703*pt
            elif shift=='frp1Down':
                fr = 0.1798 - 0.00008517*pt
        elif dm==10:
            if shift=='':
                fr = 0.09101 + 0.001114*pt
            elif shift=='frp0Up':
                fr = 0.0994 + 0.001114*pt
            elif shift=='frp0Down':
                fr = 0.08262 + 0.001114*pt
            elif shift=='frp1Up':
                fr = 0.09101 + 0.0012944*pt
            elif shift=='frp1Down':
                fr = 0.09101 + 0.0009336*pt
        elif dm==11:
            if shift=='':
                fr = 0.07229 + 0.0001237*pt
            elif shift=='frp0Up':
                fr = 0.080138 + 0.0001237*pt
            elif shift=='frp0Down':
                fr = 0.064442 + 0.0001237*pt
            elif shift=='frp1Up':
                fr = 0.07229 + 0.000282*pt
            elif shift=='frp1Down':
                fr = 0.07229 - 0.0000346*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.1868 + 0.0002551*pt
            elif shift=='frp0Up':
                fr = 0.20663 + 0.0002551*pt
            elif shift=='frp0Down':
                fr = 0.16697 + 0.0002551*pt
            elif shift=='frp1Up':
                fr = 0.1868 + 0.0006764*pt
            elif shift=='frp1Down':
                fr = 0.1868 - 0.0001662*pt
        elif dm==1:
            if shift=='':
                fr = 0.1642 + 0.0002072*pt
            elif shift=='frp0Up':
                fr = 0.17705 + 0.0002072*pt
            elif shift=='frp0Down':
                fr = 0.15135 + 0.0002072*pt
            elif shift=='frp1Up':
                fr = 0.1642 + 0.0004819*pt
            elif shift=='frp1Down':
                fr = 0.1642 - 0.0000675*pt
        elif dm==10:
            if shift=='':
                fr = 0.1127 + 0.0003705*pt
            elif shift=='frp0Up':
                fr = 0.12614 + 0.0003705*pt
            elif shift=='frp0Down':
                fr = 0.09926 + 0.0003705*pt
            elif shift=='frp1Up':
                fr = 0.1127 + 0.0006654*pt
            elif shift=='frp1Down':
                fr = 0.1127 + 0.0000756*pt
        elif dm==11:
            if shift=='':
                fr = 0.03502 + 0.0004482*pt
            elif shift=='frp0Up':
                fr = 0.04757 + 0.0004482*pt
            elif shift=='frp0Down':
                fr = 0.02247 + 0.0004482*pt
            elif shift=='frp1Up':
                fr = 0.03502 + 0.0007159*pt
            elif shift=='frp1Down':
                fr = 0.03502 + 0.0001805*pt
    return fr/(1-fr)

def fakerateMuon_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(0.5021 + 0.009104*pt)
        elif shift=='frp0Up':
            fr = math.tanh(0.5389 + 0.009104*pt)
        elif shift=='frp0Down':
            fr = math.tanh(0.4653 + 0.009104*pt)
        elif shift=='frp1Up':
            fr = math.tanh(0.5021 + 0.010057*pt)
        elif shift=='frp1Down':
            fr = math.tanh(0.5021 + 0.008151*pt)
    else:
        fr = 0
    return fr/(1-fr)
