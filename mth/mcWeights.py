class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_embed = target.startswith('embedded_')
        self.is_embedB = target.startswith('embedded_EmbeddingRun2016B')
        self.is_embedC = target.startswith('embedded_EmbeddingRun2016C')
        self.is_embedD = target.startswith('embedded_EmbeddingRun2016D')
        self.is_embedE = target.startswith('embedded_EmbeddingRun2016E')
        self.is_embedF = target.startswith('embedded_EmbeddingRun2016F')
        self.is_embedG = target.startswith('embedded_EmbeddingRun2016G')
        self.is_embedH = target.startswith('embedded_EmbeddingRun2016H')
        self.is_mc = not self.is_data and not self.is_embed
        self.is_DYlow = bool('DYJetsToLL_M-10to50' in target)
        self.is_DY = bool('DY' in target) and not self.is_DYlow
        self.is_GluGlu = bool('GluGlu_LFV' in target)
        self.is_VBF = bool('VBF_LFV' in target)
        self.is_W = bool('JetsToLNu' in target)
        self.is_WG = bool('WGToLNuG' in target)
        self.is_WW = bool('WW_TuneCUETP8M1' in target)
        self.is_WZ = bool('WZ_TuneCUETP8M1' in target)
        self.is_ZZ = bool('ZZ_TuneCUETP8M1' in target)
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
            0 : 2.087463032,#2.207407706,#1.1374
            1 : 0.477922551,#0.425351833,
            2 : 0.516520454,#0.481309881,
            3 : 0.557573834,#0.59630009,
            4 : 0.595144313#0.505602761
        } 
        self.Wweight = {
            0 : 25.47903748,#25.7159816,
            1 : 6.846391613,#5.83996765,
            2 : 3.861020439,#3.373031009,
            3 : 1.027193702,#1.026014681,
            4 : 7.332587867,#7.745621503
        }

    def lumiWeight(self, weight):
        if self.is_embedB:
            weight = weight*(1.0/0.899)
        if self.is_embedC:
            weight = weight*(1.0/0.881)
        if self.is_embedD:
            weight = weight*(1.0/0.877)
        if self.is_embedE:
            weight = weight*(1.0/0.939)
        if self.is_embedF:
            weight = weight*(1.0/0.936)
        if self.is_embedG:
            weight = weight*(1.0/0.908)
        if self.is_embedH:
            weight = weight*(1.0/0.962)
        if self.is_DY:
            weight = weight*1.326*1.1374
        if self.is_DYlow:
            weight = weight*19.468
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
            weight = weight*0.085#0.07969
        if self.is_STtWantitop:
            weight = weight*0.24#0.336
        if self.is_STtWtop:
            weight = weight*38.783#0.476
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
