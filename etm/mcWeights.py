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
        self.is_WW = bool('WW_' in target)
        self.is_WZ = bool('WZ_' in target)
        self.is_ZZ = bool('ZZ_' in target)
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
        self.is_TTTo2L2Nu = bool('TTTo2L2Nu' in target)
        self.is_TTToHadronic = bool('TTToHadronic' in target)
        self.is_TTToSemiLeptonic = bool('TTToSemiLeptonic' in target)
        self.is_TT = bool(self.is_TTTo2L2Nu or self.is_TTToHadronic or self.is_TTToSemiLeptonic)
        self.is_ST = bool(self.is_STtantitop or self.is_STttop or self.is_STtWantitop or self.is_STtWtop)
        self.is_VBFH = bool('VBFHToTauTau' in target)
        self.is_GluGluH = bool('GluGluHToTauTau' in target)
        self.is_VBFHWW = bool('VBFHToWW' in target)
        self.is_GluGluHWW = bool('GluGluHToWW' in target)
        self.is_recoilC = bool(self.is_DYlow or self.is_DY or self.is_GluGlu or self.is_VBF or self.is_EWK or self.is_VBFH or self.is_GluGluH or self.is_VBFHWW or self.is_GluGluHWW or self.is_W)
        self.MetCorrection = True
        self.DYweight = {
            0 : 2.603355744,
            1 : 0.840953578,
            2 : 0.9293673,
            3 : 1.827412732,
            4 : 0.409198039
        }
        self.Wweight = {
            0 : 0.0,#121.6155691
            1 : 9.375094116,#10.15816626
            2 : 5.67195819,#5.949430225
            3 : 3.378722964,#3.475272976
            4 : 3.561646273#3.669099917
        }

    def lumiWeight(self, weight): 
        if self.is_DYlow:
            weight = weight*0.0
        if self.is_WG:
            weight = weight*3.094
        if self.is_GluGlu:
            weight = weight*0.0005
        if self.is_VBF:
            weight = weight*0.000214#6
        if self.is_WW:
            weight = weight*0.409*(118.7/75.88)
        if self.is_WZ:
            weight = weight*0.294*(51.11/27.57)
        if self.is_ZZ:
            weight = weight*0.264*(16.91/12.14)
        if self.is_EWKWMinus:
            weight = weight*0.191
        if self.is_EWKWPlus:
            weight = weight*0.241
        if self.is_EWKZToLL:
            weight = weight*0.332
        if self.is_EWKZToNuNu:
            weight = weight*0.140
        if self.is_ZHTT:
            weight = weight*0.000693
        if self.is_Wminus:
            weight = weight*0.00067
        if self.is_Wplus:
            weight = weight*0.000863
        if self.is_STtantitop:
            weight = weight*0.9218
        if self.is_STttop:
            weight = weight*0.9518
        if self.is_STtWantitop:
            weight = weight*0.0059
        if self.is_STtWtop:
            weight = weight*0.0056
        if self.is_TTTo2L2Nu:
            weight = weight*0.005818
        if self.is_TTToHadronic:
            weight = weight*0.421
        if self.is_TTToSemiLeptonic:
            weight = weight*0.001377
        if self.is_VBFH:
            weight = weight*0.000864
        if self.is_GluGluH:
            weight = weight*0.002032
        if self.is_VBFHWW:
            weight = weight*0.001854
        if self.is_GluGluHWW:
            weight = weight*0.001677
        return weight
