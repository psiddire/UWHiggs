class mcWeights:
    def __init__(self, target):
        self.is_data = target.startswith('data_')
        self.is_mc = not self.is_data
        self.is_DY = bool('DY' in target)
        self.is_WW = bool('WW' in target)
        self.is_WZ = bool('WZ' in target)
        self.is_ZZ = bool('ZZ' in target)
        self.DYweight = {
            0 : 1.50919237,
            1 : 0.481912142,
            2 : 0.49924333,
            3 : 0.511827833,
            4 : 1.264012429
        }

    def lumiWeight(self, weight):
        #if self.is_DY:
        #    weight = weight*3.601/1.1374
        if self.is_WW:
            weight = weight*0.3453*(118.7/75.88)
        if self.is_WZ:
            weight = weight*0.2505*(51.11/27.57)
        if self.is_ZZ:
            weight = weight*0.2218*(16.91/12.14)
        return weight                                                                                                                                                                                                                                                         
