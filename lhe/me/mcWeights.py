class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)
        self.is_recoilC = bool(self.is_GluGlu or self.is_VBF or self.is_VBFH or self.is_GluGluH or self.is_VBFHWW or self.is_GluGluHWW)
        self.MetCorrection = True

    def lumiWeight(self, weight):
        if self.is_GluGlu:
            weight = weight*0.000671
        if self.is_VBF:
            weight = weight*0.000294
        if self.is_GluGluH:
            weight = weight*0.000669
        if self.is_VBFH:
            weight = weight*0.001215
        if self.is_GluGluHWW:
            weight = weight*0.002266
        if self.is_VBFHWW:
            weight = weight*0.001314
        return weight
