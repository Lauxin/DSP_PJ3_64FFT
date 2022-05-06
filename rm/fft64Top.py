import numpy as np
import matplotlib.pyplot as plt
import genData
import myfft64

if __name__ == "__main__":    
    #dat = genData.genSin(1,2.5,64)
    dat = genData.genLinear(-40,40,64)
    #dat = genData.genRand(0,10)
    plt.figure()
    plt.plot(dat)
    
    fftRef = np.fft.fft(dat)
    fftRefShf = np.fft.fftshift(fftRef)
    print(fftRef)
    plt.figure()
    plt.plot(np.abs(fftRefShf))
    
    fftRm = myfft64.fft64Base8(dat)
    fftRmShf = np.fft.fftshift(fftRm)
    print(fftRm)
    plt.figure()
    plt.plot(np.abs(fftRmShf))

    plt.show()
