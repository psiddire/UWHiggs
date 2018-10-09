import fileinput
outfilename = "WJetsToLNu_TuneCP5_13TeV-madgraphMLM-pythia8_v14.txt"
filenames = ['WJetsToLNu_TuneCP5_13TeV-madgraphMLM-pythia8_v14-v2.txt','WJetsToLNu_TuneCP5_13TeV-madgraphMLM-pythia8_v14_ext1-v2.txt']
with open(outfilename, 'w') as fout:
    fin = fileinput.input(filenames)
    for line in fin:
        fout.write(line)
    fin.close()
