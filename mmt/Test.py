import FinalStateAnalysis.TagAndProbe.TauPOGCorrections as TauPOGCorrections

tauvsj = TauPOGCorrections.make_tau_pog_DeepTauVSe_2016("Tight")

print tauvsj(2.2)
