import math

def TESup(tau, met, tauphi, metphi):
    tau = 1.008 * tau
    tauex = tau * math.cos(tauphi)
    tauey = tau * math.sin(tauphi)
    mex = met * math.cos(metphi) - 0.008 * (tauex/1.008)
    mey = met * math.sin(metphi) - 0.008 * (tauey/1.008)
    return (tau, tauex, tauey, abs(math.sqrt(mex * mex + mey * mey)), mex, mey)

def TESdown(tau, met, tauphi, metphi):
    tau = 0.992 * tau
    tauex = tau * math.cos(tauphi)
    tauey = tau * math.sin(tauphi)
    mex = met * math.cos(metphi) + 0.008 * (tauex/0.992)
    mey = met * math.sin(metphi) + 0.008 * (tauey/0.992)
    return (tau, tauex, tauey, abs(math.sqrt(mex * mex + mey * mey)), mex, mey)

#def MFTup(mytau,mymet,mytauphi,mymetphi):
#    mytau=1.015*mytau
#    tauex=mytau*math.cos(mytauphi)
#    tauey=mytau*math.sin(mytauphi)
#    mex = mymet*math.cos(mymetphi)-0.015*(tauex/1.015)
#    mey = mymet*math.sin(mymetphi)-0.015*(tauey/1.015)
#    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)

#def MFTdown(mytau,mymet,mytauphi,mymetphi):
#    mytau=0.985*mytau
#    tauex=mytau*math.cos(mytauphi)
#    tauey=mytau*math.sin(mytauphi)
#    mex = mymet*math.cos(mymetphi)+0.015*(tauex/0.985)
#    mey = mymet*math.sin(mymetphi)+0.015*(tauey/0.985)
#    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)

def UESup(met_UESup, metphi_UESup):
    met_UESup_x = met_UESup * math.cos(metphi_UESup)
    met_UESup_y = met_UESup * math.sin(metphi_UESup)
    return (met_UESup, met_UESup_x, met_UESup_y, metphi_UESup, 0, 0)

def UESdown(met_UESdown, metphi_UESdown):
    met_UESdown_x = met_UESdown * math.cos(metphi_UESdown)
    met_UESdown_y = met_UESdown * math.sin(metphi_UESdown)
    return (met_UESdown, met_UESdown_x, met_UESdown_y, metphi_UESdown, 0, 0)

def MESup(mu, mueta, met, muphi, metphi):
    mu = 1.002 * mu
    muex = mu * math.cos(muphi)
    muey = mu * math.sin(muphi)
    mex = met * math.cos(metphi) - 0.002 * (muex/1.002)
    mey = met * math.sin(metphi) - 0.002 * (muey/1.002)
    return (mu, muex, muey, abs(math.sqrt(mex * mex + mey * mey)), mex, mey)

def MESdown(mu, mueta, met, muphi, metphi):
    mu = 0.998 * mu
    muex = mu * math.cos(muphi)
    muey = mu * math.sin(muphi)
    mex = met * math.cos(metphi) + 0.002 * (muex/0.998)
    mey = met * math.sin(metphi) + 0.002 * (muey/0.998)
    return (mu, muex, muey, abs(math.sqrt(mex * mex + mey * mey)), mex, mey)
