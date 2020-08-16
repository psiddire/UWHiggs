class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_mc = not self.is_data
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_recoilC = bool(self.is_GluGlu or self.is_VBF)
        self.MetCorrection = True

    def lumiWeight(self, weight):
        if self.is_GluGlu:
            weight = weight*0.000479
        if self.is_VBF:
            weight = weight*0.000205
        return weight
