
#right now it's just a simple class wrapper for a function
class background_estimate:
    def __init__(self,name,estfun):
        self._name = name
        self._estfun = estfun

    def __call__(self,varlist):
        return self._estfun(*tuple(varlist))

    def name():
        return name
