
# Tools to compile cython proxy class
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension(
    "MuMuTauTree",                 # name of extension
    ["MuMuTauTree.pyx"], #  our Cython source
    include_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_9/external/slc6_amd64_gcc630/bin/../../../../../../../slc6_amd64_gcc630/lcg/root/6.10.08-elfike2/include'],
    library_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_9/external/slc6_amd64_gcc630/bin/../../../../../../../slc6_amd64_gcc630/lcg/root/6.10.08-elfike2/lib'],
    libraries=['Tree', 'Core', 'TreePlayer'],
    language="c++", 
    extra_compile_args=['-std=c++1y', '-fno-var-tracking-assignments'])],  # causes Cython to create C++ source
    cmdclass={'build_ext': build_ext})
