import ROOT
import math

def GetSF(WP, x, flavour, syst):
    
    if (WP==1):
        if (abs(flavour)==4 or abs(flavour)==5):
            if (syst==0):
                return 0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))

            if (syst==-1):
                if (x < 30): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.19771461188793182)
                elif (x < 50): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.045167062431573868)
                elif (x < 70): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.040520280599594116)
                elif (x < 100): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.045320175588130951)
                elif (x < 140): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.043860536068677902)
                elif (x < 200): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.036484666168689728)
                elif (x < 300): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.048719070851802826)
                elif (x < 600): return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.11997123062610626)
                else: return 0.909339+((0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18))))))-0.20536302030086517)

            if (syst==1):
               if (x < 30): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.19771461188793182
               elif (x < 50): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.045167062431573868
               elif (x < 70): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.040520280599594116
               elif (x < 100): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.045320175588130951
               elif (x < 140): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.043860536068677902
               elif (x < 200): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.036484666168689728
               elif (x < 300): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.048719070851802826
               elif (x < 600): return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.11997123062610626
               else: return (0.909339+(0.00354*(math.log(x+19)*(math.log(x+18)*(3-(0.471623*math.log(x+18)))))))+0.20536302030086517

        else : 
            if (syst==0): return 1.6329+-0.00160255*x+1.9899e-06*x*x+-6.72613e-10*x*x*x
            if (syst==-1): return (1.6329+-0.00160255*x+1.9899e-06*x*x+-6.72613e-10*x*x*x)*(1-(0.122811+0.000162564*x+-1.66422e-07*x*x))
            if (syst==1): return (1.6329+-0.00160255*x+1.9899e-06*x*x+-6.72613e-10*x*x*x)*(1+(0.122811+0.000162564*x+-1.66422e-07*x*x))
    else:
        return 0


def bTagEventWeight( nBtaggedJets, bjetpt_1,  bjetflavour_1,  bjetpt_2,  bjetflavour_2,  WP,  syst, nBTags):
    if (nBtaggedJets > 2): return -10000
    if (nBTags > 2): return -10000

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
