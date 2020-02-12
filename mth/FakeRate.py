import math

def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2215 - 0.0001835*pt
            elif shift=='frp0Up':
                fr = 0.2356 - 0.0001835*pt
            elif shift=='frp0Down':
                fr = 0.2074 - 0.0001835*pt
            elif shift=='frp1Up':
                fr = 0.2215 + 0.0001153*pt
            elif shift=='frp1Down':
                fr = 0.2215 - 0.0004823*pt
        elif dm==1:
            if shift=='':
                fr = 0.1790 + 0.00006756*pt
            elif shift=='frp0Up':
                fr = 0.1866 + 0.00006756*pt
            elif shift=='frp0Down':
                fr = 0.1714 + 0.00006756*pt
            elif shift=='frp1Up':
                fr = 0.1790 + 0.00022376*pt
            elif shift=='frp1Down':
                fr = 0.1790 - 0.00008864*pt
        elif dm==10:
            if shift=='':
                fr = 0.09535 + 0.001027*pt
            elif shift=='frp0Up':
                fr = 0.10543 + 0.001027*pt
            elif shift=='frp0Down':
                fr = 0.08527 + 0.001027*pt
            elif shift=='frp1Up':
                fr = 0.09535 + 0.001244*pt
            elif shift=='frp1Down':
                fr = 0.09535 + 0.000809*pt
        elif dm==11:
            if shift=='':
                fr = 0.05510 + 0.0001976*pt
            elif shift=='frp0Up':
                fr = 0.06375 + 0.0001976*pt
            elif shift=='frp0Down':
                fr = 0.04645 + 0.0001976*pt
            elif shift=='frp1Up':
                fr = 0.05510 + 0.0003757*pt
            elif shift=='frp1Down':
                fr = 0.05510 + 0.0000195*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.1743 + 0.0004906*pt
            elif shift=='frp0Up':
                fr = 0.1972 + 0.0004906*pt
            elif shift=='frp0Down':
                fr = 0.1514 + 0.0004906*pt
            elif shift=='frp1Up':
                fr = 0.1743 + 0.0009840*pt
            elif shift=='frp1Down':
                fr = 0.1743 - 0.0000028*pt
        elif dm==1:
            if shift=='':
                fr = 0.1615 - 0.0001123*pt
            elif shift=='frp0Up':
                fr = 0.1758 - 0.0001123*pt
            elif shift=='frp0Down':
                fr = 0.1472 - 0.0001123*pt
            elif shift=='frp1Up':
                fr = 0.1615 + 0.0001863*pt
            elif shift=='frp1Down':
                fr = 0.1615 - 0.0004109*pt
        elif dm==10:
            if shift=='':
                fr = 0.1092 + 0.000406*pt
            elif shift=='frp0Up':
                fr = 0.1257 + 0.000406*pt
            elif shift=='frp0Down':
                fr = 0.0927 + 0.000406*pt
            elif shift=='frp1Up':
                fr = 0.1092 + 0.000769*pt
            elif shift=='frp1Down':
                fr = 0.1092 + 0.000042*pt
        elif dm==11:
            if shift=='':
                fr = 0.0495 + 0.0001732*pt
            elif shift=='frp0Up':
                fr = 0.0639 + 0.0001732*pt
            elif shift=='frp0Down':
                fr = 0.0351 + 0.0001732*pt
            elif shift=='frp1Up':
                fr = 0.0495 + 0.0004628*pt
            elif shift=='frp1Down':
                fr = 0.0495 - 0.0001164*pt
    return fr/(1-fr)

def fakerateMuon_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = math.tanh(0.4978 + 0.008416*pt)
        elif shift=='frp0Up':
            fr = math.tanh(0.5481 + 0.008416*pt)
        elif shift=='frp0Down':
            fr = math.tanh(0.4475 + 0.008416*pt)
        elif shift=='frp1Up':
            fr = math.tanh(0.4978 + 0.009715*pt)
        elif shift=='frp1Down':
            fr = math.tanh(0.4978 + 0.007117*pt)
    else:
        fr = 0
    return fr/(1-fr)
