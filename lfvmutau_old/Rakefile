# Get common recipes
recipes = ENV['fsa'] + '/PlotTools/rake/recipes.rake'
import recipes

require ENV['CMSSW_BASE'] + '/src/FinalStateAnalysis/PlotTools/rake/tools.rb'
require 'pathname'

$jobid = ENV['jobid']
$blind = ENV['blind']

# Figure out what run period we are in
$period = '13TeV'
PU = ENV['PU']
#if $jobid.include? '8TeV'
#  $period = '8TeV'
#end


################################################################################
## Sample names ################################################################
################################################################################
#
# Get sample names containing a substring
def get_sample_names(substring)
  inputs = Dir.glob("inputs/#{$jobid}/*.txt").select {|x| x.include? substring}
  inputs = inputs.map{|x| File.basename(x).sub(".txt", "")}
  return inputs
end
#
samples = Hash[
                "zHToTTMC" => get_sample_names('ZHToTauTau_M125_13TeV_powheg_pythia8_v6-v1'),
                "wplusHToTTMC" => get_sample_names('WplusHToTauTau_M125_13TeV_powheg_pythia8_v6-v1'),
                "wminusHToTTMC" => get_sample_names('WminusHToTauTau_M125_13TeV_powheg_pythia8_v6-v1'),
     		"vbfHToMTMC" => get_sample_names('VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1'),
		"vbfHToETMC" => get_sample_names('VBF_LFV_HToETau_M125_13TeV_powheg_pythia8_v6-v1'),
                "vbfHToWWMC" => get_sample_names('VBFHToWWTo2L2Nu_M125_13TeV_powheg_pythia8_v6-v1'),
                "vbfHToTTMC" => get_sample_names('VBFHToTauTau_M125_13TeV_powheg_pythia8_v6-v1'),
     		"ttHJetToTTMC" => get_sample_names('ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8_v6_ext4-v1'),
		"ggHToMTMC" => get_sample_names('GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8_v6-v1'),
                "ggHToETMC" => get_sample_names('GluGlu_LFV_HToETau_M125_13TeV_powheg_pythia8_v6-v1'),
                "ggHToWWMC" => get_sample_names('GluGluHToWWTo2L2Nu_M125_13TeV_powheg_pythia8_v6-v1'),
     		"ggHToTTMC" => get_sample_names('GluGluHToTauTau_M125_13TeV_powheg_pythia8_v6-v1')
]



# Function to get the .root files for an analyzer and samples
def get_analyzer_results(analyzer, the_samples)
  output = Array.new
  analyzer_base = analyzer.sub('.py', '')
  the_samples.each do |sample|
    output << "results/#{$jobid}/#{analyzer_base}/#{sample}.root"
  end
  return output
end
def get_plotter_results(analyzer)
  output = Array.new
  analyzer_base = analyzer.sub('.py', '')
end


task :genKinMuTau => get_analyzer_results("LFVMuTauAnalyserGen.py", samples['zHToTTMC'] + samples['wplusHToTTMC'] + samples['wminusHToTTMC'] + samples['vbfHToMTMC'] + samples['vbfHToETMC'] + samples['vbfHToWWMC'] + samples['vbfHToTTMC'] + samples['ttHJetToTTMC'] + samples['ggHToMTMC'] + samples['ggHToETMC'] + samples['ggHToWWMC'] + samples['ggHToTTMC'])

$etdir = "plots/#{$jobid}/LFVMuTauAnalyzerGen/mt_now/"
directory $etdir 
file  "#{$etdir}/plot#{$period}.root" do |t|
  sh "echo $jobid"
  sh "python myNewPlotterReco.py" 
  
end