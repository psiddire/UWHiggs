from DataFormats.FWLite import Events, Handle
from ROOT import TLorentzVector

rfile='/hdfs/store/user/taroni/lpairs_mc_Oct13/DY1JetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_v6-v1/make_ntuples_cfg-026C891F-5BD2-E611-9CDB-008CFA064770.root'

events = Events(rfile)
handle_lhe = Handle('LHEEventProduct')
label_lhe = ('externalLHEProducer')

for ev in events:

    ev.getByLabel(label_lhe, handle_lhe)
    lhe = handle_lhe.product()

    outgoing = []
    invmass = []

    for status, pdg, moth, mom in zip(lhe.hepeup().ISTUP, lhe.hepeup().IDUP, lhe.hepeup().MOTHUP, lhe.hepeup().PUP):

        if status==1 and abs(pdg) in [21, 1,2,3,4,5]:            
            outgoing.append(pdg)

        if status==1 and abs(pdg) in [11, 13, 15]:
            l = TLorentzVector(mom.x[0], mom.x[1], mom.x[2], mom.x[3])
            invmass.append(l)


    print '# outgoing partons = ', len(outgoing),
    if len(invmass)==2:
        print ', m(ll) = ', (invmass[0] + invmass[1]).M()
    else:
        print 'Wrong counting !!!!!!!!!!!!!'
