class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)

    def lumiWeight(self, weight): 
        if self.is_GluGlu:
            weight = weight*0.000501
        if self.is_VBF:
            weight = weight*0.000208
        if self.is_GluGluH:
            weight = weight*0.002032
        if self.is_VBFH:
            weight = weight*0.002032
        if self.is_GluGluHWW:
            weight = weight*0.001677
        if self.is_VBFHWW:
            weight = weight*0.001853
        return weight
