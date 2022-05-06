import numpy as np

def genSin(amp, t, len=64):
    return np.array([amp * np.sin(2 * np.pi * x / t) for x in range(len)])
        
def genLinear(thLow, thHigh, len=64):
    return np.linspace(thLow, thHigh, len)

def genRand(thLow, thHigh, len=64):
    return (thHigh-thLow) * np.random.rand(len) + thLow

if __name__=="__main__":
    #print(genSin(1,20,64))
    #print(genLinear(-20,20,64))
    print(genRand(-10,20,64))