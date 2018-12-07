source jobid.sh
export jobid=$jobid8
hadd -f results/$jobid8/ZHAnalyzeEEEM/data.root results/$jobid8/ZHAnalyzeEEEM/data*.root
hadd -f results/$jobid8/ZHAnalyzeEEET/data.root results/$jobid8/ZHAnalyzeEEET/data*.root
hadd -f results/$jobid8/ZHAnalyzeEEMT/data.root results/$jobid8/ZHAnalyzeEEMT/data*.root
hadd -f results/$jobid8/ZHAnalyzeEETT/data.root results/$jobid8/ZHAnalyzeEETT/data*.root
hadd -f results/$jobid8/ZHAnalyzeMMEM/data.root results/$jobid8/ZHAnalyzeMMEM/data*.root
hadd -f results/$jobid8/ZHAnalyzeMMET/data.root results/$jobid8/ZHAnalyzeMMET/data*.root
hadd -f results/$jobid8/ZHAnalyzeMMMT/data.root results/$jobid8/ZHAnalyzeMMMT/data*.root
hadd -f results/$jobid8/ZHAnalyzeMMTT/data.root results/$jobid8/ZHAnalyzeMMTT/data*.root
mkdir -p results/$jobid8/ZHAnalyzeCOMB
cd results/$jobid8/ZHAnalyzeCOMB
rm data.root
rm Zjets_M50.root
rm  ZZJetsTo4L_pythia.root
rm WZJetsTo3LNu_pythia.root
rm VH_H2Tau_M-125.root
rm VH_H2Tau_M-120.root
hadd -f data.root ../ZHAnalyze*/data.root
hadd -f Zjets_M50.root ../ZHAnalyze*/Zjets_M50.root
hadd -f ZZJetsTo4L_pythia.root ../ZHAnalyze*/ZZJetsTo4L_pythia.root
hadd -f WZJetsTo3LNu_pythia.root ../ZHAnalyze*/WZJetsTo3LNu_pythia.root
hadd -f VH_H2Tau_M-125.root ../ZHAnalyze*/VH_H2Tau_M-125.root
hadd -f VH_H2Tau_M-120.root ../ZHAnalyze*/VH_H2Tau_M-120.root
cd ../../../ 
