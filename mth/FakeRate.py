def fakerate_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2629 - 0.0006034*pt
            elif shift=='frp0Up':
                fr = 0.2743 - 0.0006034*pt
            elif shift=='frp0Down':
                fr = 0.2515 - 0.0006034*pt
            elif shift=='frp1Up':
                fr = 0.2629 - 0.0003713*pt
            elif shift=='frp1Down':
                fr = 0.2629 - 0.0008355*pt
        elif dm==1:
            if shift=='':
                fr = 0.2032 - 0.0005448*pt
            elif shift=='frp0Up':
                fr = 0.2099 - 0.0005448*pt
            elif shift=='frp0Down':
                fr = 0.1964 - 0.0005448*pt
            elif shift=='frp1Up':
                fr = 0.2032 - 0.0004108*pt
            elif shift=='frp1Down':
                fr = 0.2032 - 0.0006788*pt
        elif dm==10:
            if shift=='':
                fr = 0.1717 - 0.0002652*pt
            elif shift=='frp0Up':
                fr = 0.1849 - 0.0002652*pt
            elif shift=='frp0Down':
                fr = 0.1584 - 0.0002652*pt
            elif shift=='frp1Up':
                fr = 0.1717 + 0.0000232*pt
            elif shift=='frp1Down':
                fr = 0.1717 - 0.0005536*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.2816 - 0.0007871*pt
            elif shift=='frp0Up':
                fr = 0.3009 - 0.0007871*pt
            elif shift=='frp0Down':
                fr = 0.2623 - 0.0007871*pt
            elif shift=='frp1Up':
                fr = 0.2816 - 0.0003953*pt
            elif shift=='frp1Down':
                fr = 0.2816 - 0.0011789*pt
        elif dm==1:
            if shift=='':
                fr = 0.1978 - 0.0009533*pt
            elif shift=='frp0Up':
                fr = 0.2078 - 0.0009533*pt
            elif shift=='frp0Down':
                fr = 0.1878 - 0.0009533*pt
            elif shift=='frp1Up':
                fr = 0.1978 - 0.0007721*pt
            elif shift=='frp1Down':
                fr = 0.1978 - 0.0011345*pt
        elif dm==10:
            if shift=='':
                fr = 0.1068 + 0.0007412*pt
            elif shift=='frp0Up':
                fr = 0.1301 + 0.0007412*pt
            elif shift=='frp0Down':
                fr = 0.0835 + 0.0007412*pt
            elif shift=='frp1Up':
                fr = 0.1068 + 0.0012720*pt
            elif shift=='frp1Down':
                fr = 0.1068 + 0.0002104*pt
    return fr/(1-fr)

def fakerateDeep_weight(pt, eta, dm, shift=''):
    if eta < 1.5:
        if dm==0:
            if shift=='':
                fr = 0.2535 - 0.0004245*pt
            elif shift=='frp0Up':
                fr = 0.2669 - 0.0004245*pt
            elif shift=='frp0Down':
                fr = 0.2400 - 0.0004245*pt
            elif shift=='frp1Up':
                fr = 0.2535 - 0.0001531*pt
            elif shift=='frp1Down':
                fr = 0.2535 - 0.0006959*pt
        elif dm==1:
            if shift=='':
                fr = 0.1619 - 0.0000363*pt
            elif shift=='frp0Up':
                fr = 0.1699 - 0.0000363*pt
            elif shift=='frp0Down':
                fr = 0.1539 - 0.0000363*pt
            elif shift=='frp1Up':
                fr = 0.1619 + 0.0001284*pt
            elif shift=='frp1Down':
                fr = 0.1619 - 0.0002010*pt
        elif dm==10:
            if shift=='':
                fr = 0.09829 + 0.0008355*pt
            elif shift=='frp0Up':
                fr = 0.10956 + 0.0008355*pt
            elif shift=='frp0Down':
                fr = 0.08702 + 0.0008355*pt
            elif shift=='frp1Up':
                fr = 0.09829 + 0.0010750*pt
            elif shift=='frp1Down':
                fr = 0.09829 + 0.0005960*pt
        elif dm==11:
            if shift=='':
                fr = 0.05200 + 0.0003307*pt
            elif shift=='frp0Up':
                fr = 0.06315 + 0.0003307*pt
            elif shift=='frp0Down':
                fr = 0.04085 + 0.0003307*pt
            elif shift=='frp1Up':
                fr = 0.05200 + 0.0005617*pt
            elif shift=='frp1Down':
                fr = 0.05200 + 0.0000997*pt
    else:
        if dm==0:
            if shift=='':
                fr = 0.1359 + 0.0008005*pt
            elif shift=='frp0Up':
                fr = 0.1609 + 0.0008005*pt
            elif shift=='frp0Down':
                fr = 0.1109 + 0.0008005*pt
            elif shift=='frp1Up':
                fr = 0.1359 + 0.0013383*pt
            elif shift=='frp1Down':
                fr = 0.1359 + 0.0002627*pt
        elif dm==1:
            if shift=='':
                fr = 0.1353 - 0.00001524*pt
            elif shift=='frp0Up':
                fr = 0.1499 - 0.00001524*pt
            elif shift=='frp0Down':
                fr = 0.1207 - 0.00001524*pt
            elif shift=='frp1Up':
                fr = 0.1353 + 0.00029236*pt
            elif shift=='frp1Down':
                fr = 0.1353 - 0.00032284*pt
        elif dm==10:
            if shift=='':
                fr = 0.06742 + 0.001015*pt
            elif shift=='frp0Up':
                fr = 0.08644 + 0.001015*pt
            elif shift=='frp0Down':
                fr = 0.04840 + 0.001015*pt
            elif shift=='frp1Up':
                fr = 0.06742 + 0.0014335*pt
            elif shift=='frp1Down':
                fr = 0.06742 + 0.0005965*pt
        elif dm==11:
            if shift=='':
                fr = 0.01726 + 0.0005942*pt
            elif shift=='frp0Up':
                fr = 0.03232 + 0.0005942*pt
            elif shift=='frp0Down':
                fr = 0.00220 + 0.0005942*pt
            elif shift=='frp1Up':
                fr = 0.01726 + 0.0009167*pt
            elif shift=='frp1Down':
                fr = 0.01726 + 0.0002717*pt
    return fr/(1-fr)

def fakerateMuon_weight(pt, shift=''):
    if pt < 100:
        if shift=='':
            fr = 0.7905 + 0.001371*pt
        elif shift=='frp0Up':
            fr = 0.797167 + 0.001371*pt
        elif shift=='frp0Down':
            fr = 0.783833 + 0.001371*pt
        elif shift=='frp1Up':
            fr = 0.7905 + 0.00146129*pt
        elif shift=='frp1Down':
            fr = 0.7905 + 0.00128071*pt
    else:
        fr = 0
    return fr/(1-fr)
