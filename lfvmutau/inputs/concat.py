import fileinput
outfilename = "DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8_v14.txt"
filenames = ['DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8_v14-v1.txt','DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8_v14_ext1-v1.txt']
with open(outfilename, 'w') as fout:
    fin = fileinput.input(filenames)
    for line in fin:
        fout.write(line)
    fin.close()
