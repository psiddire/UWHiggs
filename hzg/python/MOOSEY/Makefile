PYTHONFLAGS=$(shell python-config --cflags --libs)
PYTHONINC=$(shell python-config --includes)

ROOTFLAGS=$(shell root-config --cflags)
ROOTINC=$(shell root-config --incdir)

reflex=genreflex
cpp=g++

all:
	$(reflex) PyROOTTTreePatch.h --deep -s selection_PyROOT.xml -I$(ROOTINC) -I$(PYTHONINC)
	$(cpp) PyROOTTTreePatch.h PyROOTTTreePatch_rflx.cpp PyROOTTTreePatch.cxx -o RootUtilsPyROOT.so $(PYTHONFLAGS) $(ROOTFLAGS) -L`root-config --libdir` -lTreePlayer -lCore -lReflex -lTree -lPyROOT -shared