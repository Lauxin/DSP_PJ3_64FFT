import numpy as np
import matplotlib.pyplot as plt
import genData
import myfft64

if __name__ == "__main__":    
    # dat = genData.genSin(40,10,64,10)
    dat = genData.genTri(40,50,64,10)
    # dat = genData.genSqr(10,25,64)
    # dat = genData.genRand(0,10)
    print(dat)
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
