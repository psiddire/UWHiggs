
# Tools to compile cython proxy class
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension(
    "EMTree",                 # name of extension
    ["EMTree.pyx"], #  our Cython source
    include_dirs=['/cvmfs/cms.cern.ch/slc7_amd64_gcc700/cms/cmssw/CMSSW_10_2_22/external/slc7_amd64_gcc700/bin/../../../../../../../slc7_amd64_gcc700/lcg/root/6.12.07-gnimlf7/include'],
    library_dirs=['/cvmfs/cms.cern.ch/slc7_amd64_gcc700/cms/cmssw/CMSSW_10_2_22/external/slc7_amd64_gcc700/bin/../../../../../../../slc7_amd64_gcc700/lcg/root/6.12.07-gnimlf7/lib'],
    libraries=['Tree', 'Core', 'TreePlayer'],
    language="c++", 
    extra_compile_args=['-std=c++17', '-fno-var-tracking-assignments'])],  # causes Cython to create C++ source
    cmdclass={'build_ext': build_ext})
