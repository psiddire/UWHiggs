class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_embed = target.startswith('embedded_')
        self.is_mc = not self.is_data and not self.is_embed
        self.is_DY = bool('DY' in target)
        self.is_WW = bool('WW_' in target)
        self.is_WZ = bool('WZ_' in target)
        self.is_ZZ = bool('ZZ_' in target)
        self.DYweight = {
            0 : 2.603355744,
            1 : 0.840953578,
            2 : 0.9293673,
            3 : 1.665781189,
            4 : 0.4402355
        } 

    def lumiWeight(self, weight): 
        if self.is_WW:
            weight = weight*0.409*(118.7/75.88)
        if self.is_WZ:
            weight = weight*0.294*(51.11/27.57)
        if self.is_ZZ:
            weight = weight*0.264*(16.91/12.14)
        return weight
