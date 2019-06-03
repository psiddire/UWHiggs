import ROOT

def GetSF(WP, x, flavour, syst):
    
    if (WP==1):
        if (abs(flavour)==4 or abs(flavour)==5):
            if (syst==0):
                return 2.22144*((1.+(0.540134*x))/(1.+(1.30246*x)))
                
            if (syst==-1):
                if (x < 30): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.1161959320306778
                elif (x < 50): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.045411378145217896
                elif (x < 70): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.041932329535484314
                elif (x < 100): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.037821229547262192
                elif (x < 140): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.041939254850149155
                elif (x < 200): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.045033644884824753
                elif (x < 300): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.1036531925201416
                elif (x < 600): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.12050666660070419
                else: return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))-0.16405443847179413
        
            if (syst==1):
               if (x < 30): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.1161959320306778
               elif (x < 50): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.045411378145217896
               elif (x < 70): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.041932329535484314
               elif (x < 100): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.037821229547262192
               elif (x < 140): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.041939254850149155
               elif (x < 200): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.045033644884824753
               elif (x < 300): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.1036531925201416
               elif (x < 600): return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.12050666660070419
               else: return (2.22144*((1.+(0.540134*x))/(1.+(1.30246*x))))+0.16405443847179413
    
        else : 
            if (syst==0): return 0.972902+0.000201811*x+3.96396e-08*x*x+-4.53965e-10*x*x*x
            if (syst==-1): return (0.972902+0.000201811*x+3.96396e-08*x*x+-4.53965e-10*x*x*x)*(1-(0.101236+0.000212696*x+-1.71672e-07*x*x))
            if (syst==1): return (0.972902+0.000201811*x+3.96396e-08*x*x+-4.53965e-10*x*x*x)*(1+(0.101236+0.000212696*x+-1.71672e-07*x*x))
    else:
        return 0



def bTagEventWeight( nBtaggedJets, bjetpt_1,  bjetflavour_1,  bjetpt_2,  bjetflavour_2,  WP,  syst, nBTags):
    if (nBtaggedJets > 2): return -10000
    if ( nBTags > 2 ): return -10000

 
    ##################################################################
 #   Event weight matrix:
 #   ------------------------------------------------------------------
 #   nBTags\b-tagged jets  |    0        1             2
 #   ------------------------------------------------------------------
 #     0                   |    1      1-SF      (1-SF1)(1-SF2)
 #                         |
 #     1                   |    0       SF    SF1(1-SF2)+(1-SF1)SF2
 #                         |
 #     2                   |    0        0           SF1SF2
    ##################################################################
 
  
    if ( nBTags > nBtaggedJets): return 0
    if ( nBTags==0 and nBtaggedJets==0): return 1

    weight = 0
    if (nBtaggedJets==1):
        SF = GetSF(WP, bjetpt_1, bjetflavour_1, syst)
        for  i in range(2):
            if ( i != nBTags ): continue
            weight += pow(SF, i)*pow(1-SF, 1-i)
    
    elif (nBtaggedJets==2):
        SF1 = GetSF(WP, bjetpt_1, bjetflavour_1, syst)
        SF2 = GetSF(WP, bjetpt_2, bjetflavour_2, syst)
    
        for i in range(2):
            for j in range(2):
                if( (i+j) != nBTags ): continue
                weight += pow(SF1, i)*pow(1-SF1, 1-i)*pow(SF2, j)*pow(1-SF2, 1-j)

    return weight


def PromoteDemote(h_btag_eff_b, h_btag_eff_c, h_btag_eff_oth, nbtag, bpt_1, bflavor_1, beta_1, syst):

        SF = GetSF(1, bpt_1, bflavor_1, syst)
        
        beff = 1.0

        if ( bflavor_1==5 ):
            if ( bpt_1 > h_btag_eff_b.GetXaxis().GetBinLowEdge(h_btag_eff_b.GetNbinsX() + 1) ):
                beff = h_btag_eff_b.GetBinContent(h_btag_eff_b.GetNbinsX(), h_btag_eff_b.GetYaxis().FindBin(abs(beta_1)))
            else:
                beff = h_btag_eff_b.GetBinContent(h_btag_eff_b.GetXaxis().FindBin(bpt_1), h_btag_eff_b.GetYaxis().FindBin(abs(beta_1)))
        elif ( bflavor_1==4 ):
            if ( bpt_1 > h_btag_eff_c.GetXaxis().GetBinLowEdge(h_btag_eff_c.GetNbinsX() + 1) ):
                beff = h_btag_eff_c.GetBinContent(h_btag_eff_c.GetNbinsX(), h_btag_eff_c.GetYaxis().FindBin(abs(beta_1)))
            else:
                beff = h_btag_eff_c.GetBinContent(h_btag_eff_c.GetXaxis().FindBin(bpt_1), h_btag_eff_c.GetYaxis().FindBin(abs(beta_1)))
        else:
            if ( bpt_1 > h_btag_eff_oth.GetXaxis().GetBinLowEdge(h_btag_eff_oth.GetNbinsX() + 1)):
                beff = h_btag_eff_oth.GetBinContent(h_btag_eff_oth.GetNbinsX(), h_btag_eff_oth.GetYaxis().FindBin(abs(beta_1)))
            else:
                beff = h_btag_eff_oth.GetBinContent(h_btag_eff_oth.GetXaxis().FindBin(bpt_1), h_btag_eff_oth.GetYaxis().FindBin(abs(beta_1)))

        #gRandom.SetSeed(int((beta_1+5)*100000))
        #myrand = gRandom.Rndm
        rand = ROOT.TRandom3()
        rand.SetSeed(int((beta_1+5)*100000))
        myrand = rand.Rndm()
        if ( SF < 1 and myrand < (1-SF)): 
            nbtag = nbtag-1
        if ( SF > 1 and myrand < ((1-SF)/(1-1.0/beff))): 
            nbtag = nbtag+1

        return nbtag
