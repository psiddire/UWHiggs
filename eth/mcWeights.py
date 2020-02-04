class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_embed = target.startswith('embedded_')
        self.is_mc = not self.is_data and not self.is_embed
        self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
        self.is_DY = bool('DY' in target) and not self.is_DYlow
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_W = bool('JetsToLNu' in target)
        self.is_WG = bool('WGToLNuG' in target)
        self.is_WW = bool('WW_Tune' in target)
        self.is_WZ = bool('WZ_Tune' in target)
        self.is_ZZ = bool('ZZ_Tune' in target)
        self.is_EWKWMinus = bool('EWKWMinus' in target)
        self.is_EWKWPlus = bool('EWKWPlus' in target)
        self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
        self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
        self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
        self.is_ZHTT = bool('ZHToTauTau' in target)
        self.is_Wminus = bool('Wminus' in target)
        self.is_Wplus = bool('Wplus' in target)
        self.is_STtantitop = bool('ST_t-channel_antitop' in target)
        self.is_STttop = bool('ST_t-channel_top' in target)
        self.is_STtWantitop = bool('ST_tW_antitop' in target)
        self.is_STtWtop = bool('ST_tW_top' in target)
        self.is_TT = bool('TT_' in target)
        self.is_ST = bool(self.is_STtantitop or self.is_STttop or self.is_STtWantitop or self.is_STtWtop)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_VBFHWW or self.is_GluGluHWW or self.is_W)
        self.DYweight = {
            0 : 1.50919237,
            1 : 0.481912142,
            2 : 0.49924333,
            3 : 0.529136939,
            4 : 0.881668827
        } 
        self.Wweight = {
            0 : 25.7159816,
            1 : 6.922117517,
            2 : 3.904817721,
            3 : 1.039121461,
            4 : 7.413353904
        }

    def lumiWeight(self, weight):
        if self.is_DYlow:
            weight = weight*0.0#19.468
        if self.is_WG:
            weight = weight*0.000699
        if self.is_GluGlu:
            weight = weight*0.0706
        if self.is_VBF:
            weight = weight*0.00147
        if self.is_WW:
            weight = weight*0.345*(118.7/75.88)
        if self.is_WZ:
            weight = weight*0.250*(51.11/27.57)
        if self.is_ZZ:
            weight = weight*0.222*(16.91/12.14)#0.239
        if self.is_EWKWMinus:
            weight = weight*0.158
        if self.is_EWKWPlus:
            weight = weight*0.199
        if self.is_EWKZToLL:
            weight = weight*0.965
        if self.is_EWKZToNuNu:
            weight = weight*0.121
        if self.is_ZHTT:
            weight = weight*0.00449#0.00512
        if self.is_Wminus:
            weight = weight*0.0102#0.00514
        if self.is_Wplus:
            weight = weight*0.00649#0.00516
        if self.is_STtantitop:
            weight = weight*0.07577#0.07969
        if self.is_STttop:
            weight = weight*0.08355#0.07969
        if self.is_STtWantitop:
            weight = weight*0.24#0.336
        if self.is_STtWtop:
            weight = weight*1.558#0.476
        if self.is_TT:
            weight = weight*0.676#0.465
        if self.is_VBFH:
            weight = weight*0.00154
        if self.is_GluGluH:
            weight = weight*0.0114
        if self.is_VBFHWW:
            weight = weight*0.00245
        if self.is_GluGluHWW:
            weight = weight*0.191
        return weight
