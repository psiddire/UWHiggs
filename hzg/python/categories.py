
# category 1: one barrel muon or two barrel electrons + high r9 barrel photon
# category 2: all events with a barrel photon and no 'good lepton' req.
# category 3: all events with an endcap photon and no 'good lepton' req.
# category 4: one barrel muon or two barrel electrons + low r9 barrel photon
def hzg_4cat_r9based_muon(event,i):
    mu1, mu2 = event.ell1[i], event.ell2[i]
    gSCEta = event.gSCEta[i]
    gR9 = event.gR9[i]

    if( abs(gSCEta) < 1.4442 ):
        if( (abs(mu1.Eta()) < 0.9  or abs(mu2.Eta()) < 0.9) and
            (abs(mu1.Eta()) < 2.1 and abs(mu2.Eta()) < 2.1) ):
            if( gR9 > 0.94 ):
                return 1
            else:
                return 4
        else:
            return 2
    else:
        return 3

def hzg_4cat_r9based_electron(event,i):
    e1SCEta, e2SCEta = event.e1SCEta[i], event.e2SCEta[i]
    gSCEta = event.gSCEta[i]
    gR9 = event.gR9[i]

    if( abs(gSCEta) < 1.4442 ):
        if( (abs(e1SCEta) < 1.4442 and abs(e2SCEta) < 1.4442) ):
            if( gR9 > 0.94 ):
                return 1
            else:
                return 4
        else:
            return 2
    else:
        return 3

hzg_4cat_r9based = {'muon'    :hzg_4cat_r9based_muon,
                    'electron':hzg_4cat_r9based_electron}

# category 1: one barrel muon or two barrel electrons + high r9 barrel photon
# category 2: all events with a barrel photon and no 'good lepton' req.
# category 3: all events with an endcap photon and no 'good lepton' req.
# category 4: one barrel muon or two barrel electrons + low r9 barrel photon
def hzg_4cat_r9based_mod_muon(event,i):
    mu1, mu2 = event.ell1[i], event.ell2[i]
    gSCEta = event.gSCEta[i]
    gR9 = event.gR9[i]

    if( abs(gSCEta) < 1.0 ):
        if( (abs(mu1.Eta()) < 0.9  or abs(mu2.Eta()) < 0.9) and
            (abs(mu1.Eta()) < 2.1 and abs(mu2.Eta()) < 2.1) ):
            if( gR9 > 0.94 ):
                return 1
            else:
                return 4
        else:
            return 2
    else:
        return 3

def hzg_4cat_r9based_mod_electron(event,i):
    e1SCEta, e2SCEta = event.e1SCEta[i], event.e2SCEta[i]
    gSCEta = event.gSCEta[i]
    gR9 = event.gR9[i]

    if( abs(gSCEta) < 1.0 ):
        if( (abs(e1SCEta) < 1.0 and abs(e2SCEta) < 1.0) ):
            if( gR9 > 0.94 ):
                return 1
            else:
                return 4
        else:
            return 2
    else:
        return 3

hzg_4cat_r9based_mod = {'muon'    :hzg_4cat_r9based_mod_muon,
                        'electron':hzg_4cat_r9based_mod_electron}
