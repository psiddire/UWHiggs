class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_mc = not self.is_data
        self.is_DY = bool('DY' in target)
        self.is_WW = bool('WW_TuneCP5' in target)
        self.is_WZ = bool('WZ_TuneCP5' in target)
        self.is_ZZ = bool('ZZ_TuneCP5' in target)
        self.DYweight = {
            0 : 3.60210681,
            1 : 0.694100474,
            2 : 0.78541431,
            3 : 0.973058402,
            4 : 0.825056081
        }

    def lumiWeight(self, weight):
        if self.is_WW:
            weight = weight*0.8966
        if self.is_WZ:
            weight = weight*0.7804
        if self.is_ZZ:
            weight = weight*0.5065
        return weight*(59281.0/59262.0)
