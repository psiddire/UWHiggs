import fakerate_functions as frfits

def anti_charge_flip_70(row):
    z_Mass_distance = row.e1_e2_Mass - frfits.default_scaler(91.2) \
        if row.e1_e2_SS else \
        row.e1_e2_Mass - 91.2
    z_Mass_distance = abs(z_Mass_distance)
    if row.e1AbsEta < 1.48 and row.e2AbsEta < 1.48: #both barrel
        return ( ( row.mva_metEt ) > 20 or z_Mass_distance > 10 )
    elif row.e1AbsEta < 1.48 or row.e2AbsEta < 1.48: #at least one in barrel
        return ( ( row.mva_metEt ) > 25 or z_Mass_distance < 10 )
    else: #both in endcap
        return ( ( row.mva_metEt ) > 40 or z_Mass_distance > 15 )
    return True



def anti_charge_flip_80(row):
    z_Mass_distance = row.e1_e2_Mass - frfits.default_scaler(91.2) \
        if row.e1_e2_SS else \
        row.e1_e2_Mass - 91.2
    z_Mass_distance = abs(z_Mass_distance)
    if row.e1AbsEta < 1.48 and row.e2AbsEta < 1.48: #both barrel
        return ( ( row.mva_metEt ) > 25 or z_Mass_distance > 10 )
    elif row.e1AbsEta < 1.48 or row.e2AbsEta < 1.48: #at least one in barrel
        return ( ( row.mva_metEt ) > 40 or z_Mass_distance < 10 )
    else: #both in endcap
        return ( ( row.mva_metEt ) > 40 or z_Mass_distance > 20 )
    return True


def anti_charge_flip_90(row):
    z_Mass_distance = row.e1_e2_Mass - frfits.default_scaler(91.2) \
        if row.e1_e2_SS else \
        row.e1_e2_Mass - 91.2
    z_Mass_distance = abs(z_Mass_distance)
    if row.e1AbsEta < 1.48 and row.e2AbsEta < 1.48: #both barrel
        return ( ( row.mva_metEt ) > 45 or z_Mass_distance > 10 )
    elif row.e1AbsEta < 1.48 or row.e2AbsEta < 1.48: #at least one in barrel
        return ( ( row.mva_metEt ) > 55 or z_Mass_distance < 25 )
    else: #both in endcap
        return ( ( row.mva_metEt ) > 60 or z_Mass_distance > 30 )
    return True

def anti_charge_flip_100(row):
    z_Mass_distance = row.e1_e2_Mass - frfits.default_scaler(91.2) \
        if row.e1_e2_SS else \
        row.e1_e2_Mass - 91.2
    z_Mass_distance = abs(z_Mass_distance)
    if z_Mass_distance <= 10:
        return False
    return True


charge_flip_funcs = {
    70  : anti_charge_flip_70,
    80  : anti_charge_flip_80,
    90  : anti_charge_flip_90,
    100 : anti_charge_flip_100,
    }
