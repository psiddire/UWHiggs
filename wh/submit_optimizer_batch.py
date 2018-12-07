import os
import sys
import fnmatch
import glob
#from argparse import OptionParser

channels = 'emt,mmt,eet'.split(',')
batch_id = 'Batch_Optimization3'
input_hdfs= '/hdfs/store/user/mverzett/2013-May-14-8TeV'
channel_deps = {
    'mmt' : 'DoubleMu',
    'emt' : 'MuEG',
    'eet' : 'DoubleElectron',
    }

def map_sample_to_sample_name(samples):
    ret = []
    for sample in samples:
        sample_name = os.path.basename(sample).split('.')[0]
        first_infile = open(sample).readlines()[0].strip()
        true_sample_name = os.path.dirname(first_infile).split('/')[-1]
        yield sample_name, true_sample_name

def yield_batch_command(channel, sample_name, true_sample_name):
    user_dir = '/scratch/{user}/{batch_id}/{channel}_{sample}'.format(
        user = os.environ['USER'],
        batch_id = batch_id,
        channel = channel,
        sample = sample_name
        )
    print 'mkdir -p %s/dags' % user_dir
    print 'farmoutAnalysisJobs --infer-cmssw-path "--submit-dir={user_dir}/submit"' \
        ' "--output-dag-file={user_dir}/dags/dag"' \
        ' "--output-dir=srm://cmssrm.hep.wisc.edu:8443/srm/v2/server?SFN=/hdfs/store/user/{user}/{batch_id}/{channel}_{sample_name}/"' \
        ' --input-files-per-job=10 --fwklite --shared-fs "--input-dir={input_hdfs}/{true_sample_name}/"'\
        ' {batch_id}-{channel}-{sample_name}' \
        ' optimizer_batch.sh WHAnalyze{CHANNEL}.py {sample_name} \'$inputFileNames\' \'$outputFileName\''.format(
            user_dir = user_dir,
            user = os.environ['USER'],
            batch_id = batch_id,
            channel = channel,
            sample_name = sample_name,
            CHANNEL=channel.upper(),
            true_sample_name = true_sample_name,
            input_hdfs = input_hdfs
            )
    print '\n'

jobid = os.environ['jobid']
user  = os.environ['USER']
input_dir = 'inputs/%s/' % jobid
available_samples = glob.glob( os.path.join(input_dir, '*.txt') )
data_samples = filter(lambda x: os.path.basename(x).startswith('data'), available_samples)
mc_samples   = filter(lambda x: not os.path.basename(x).startswith('data') , available_samples)

for channel in channels:
    data_for_channel = filter(lambda x: channel_deps[channel] in x, available_samples)
    for sample_name, true_sample_name in map_sample_to_sample_name(data_for_channel):
        yield_batch_command(channel, sample_name, true_sample_name)
    for sample_name, true_sample_name in map_sample_to_sample_name(mc_samples):
        yield_batch_command(channel, sample_name, true_sample_name)
    
    


