import numpy as np

def genSin(amp, t, len=64, offset=0):
    return np.array([amp * np.sin(2 * np.pi / t * x) + offset for x in range(len)])
        
def genTri(amp, t, len=64, offset=0):
    return np.array([amp * 2 * (1 / t * x - np.floor(1 / t * x)) - amp + offset for x in range(len)])

def genSqr(amp, t, len=64, offset=0):
    return np.array([amp * np.sign(np.sin(2 * np.pi / t * x)) + offset for x in range(len)])

def genRand(thLow, thHigh, len=64):
    return (thHigh-thLow) * np.random.rand(len) + thLow

if __name__=="__main__":
    #print(genSin(1,20,64))
    #print(genLinear(-20,20,64))
    print(genRand(-10,20,64))