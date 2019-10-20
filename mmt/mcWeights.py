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
        self.is_WW = bool('WW_TuneCP5' in target)
        self.is_WZ = bool('WZ_TuneCP5' in target)
        self.is_ZZ = bool('ZZ_TuneCP5' in target)
        self.is_EWKWMinus = bool('EWKWMinus' in target)
        self.is_EWKWPlus = bool('EWKWPlus' in target)
        self.is_EWKZToLL = bool('EWKZ2Jets_ZToLL' in target)
        self.is_EWKZToNuNu = bool('EWKZ2Jets_ZToNuNu' in target)
        self.is_EWK = bool(self.is_EWKWMinus or self.is_EWKWPlus or self.is_EWKZToLL or self.is_EWKZToNuNu)
        self.is_ZHTT = bool('ZHToTauTau' in target)
        self.is_ttH = bool('ttHToTauTau' in target)
        self.is_Wminus = bool('Wminus' in target)
        self.is_Wplus = bool('Wplus' in target)
        self.is_STtantitop = bool('ST_t-channel_antitop' in target)
        self.is_STttop = bool('ST_t-channel_top' in target)
        self.is_STtWantitop = bool('ST_tW_antitop' in target)
        self.is_STtWtop = bool('ST_tW_top' in target)
        self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
        self.is_TTToHadronic = bool('TTToHadronic' in target)
        self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
        self.is_TT = bool(self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_VBFHWW or self.is_GluGluHWW or self.is_W)
        self.DYweight = {
            0 : 3.688765672,
            1 : 0.710799023,
            2 : 0.804309672,
            3 : 0.996468073,
            4 : 0.844905137
        } 
        self.Wweight = {
            0 : 0.0,
            1 : 7.175098403,
            2 : 4.21173945,
            3 : 2.454717213,
            4 : 2.391121278
        }

    def lumiWeight(self, weight): 
        if self.is_DYlow:
            weight = weight*22.95581643
        if self.is_WG:
            weight = weight*3.094
        if self.is_GluGlu:
            weight = weight*0.0005
        if self.is_VBF:
            weight = weight*0.000214
        if self.is_WW:
            weight = weight*0.8966
        if self.is_WZ:
            weight = weight*0.7196
        if self.is_ZZ:
            weight = weight*0.4948
        if self.is_EWKWMinus:
            weight = weight*0.191
        if self.is_EWKWPlus:
            weight = weight*0.241
        if self.is_EWKZToLL:
            weight = weight*0.189
        if self.is_EWKZToNuNu:
            weight = weight*0.140
        if self.is_ZHTT:
            weight = weight*0.000598
        if self.is_ttH:
            weight = weight*0.001276
        if self.is_Wminus:
            weight = weight*0.00067
        if self.is_Wplus:
            weight = weight*0.000636
        if self.is_STtantitop:
            weight = weight*0.922
        if self.is_STttop:
            weight = weight*0.952
        if self.is_STtWantitop:
            weight = weight*0.00538
        if self.is_STtWtop:
            weight = weight*0.00552
        if self.is_TTTo2L2Nu:
            weight = weight*0.00654
        if self.is_TTToHadronic:
            weight = weight*0.379
        if self.is_TTToSemiLeptonic:
            weight = weight*0.001175
        if self.is_VBFH:
            weight = weight*0.000864
        if self.is_GluGluH:
            weight = weight*0.00203
        if self.is_VBFHWW:
            weight = weight*0.001854
        if self.is_GluGluHWW:
            weight = weight*0.001677
        return weight
