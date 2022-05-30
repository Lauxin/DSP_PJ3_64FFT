import numpy as np
import genData


###=====DUMP=====###
def fftDumpInit():
    global fft2ChkInDatFp
    global fft2ChkInWnFp 
    global fft2ChkOutFp  
    global fft8ChkInDatFp
    global fft8ChkInWnFp 
    global fft8ChkOutFp  
    global fft64ChkInFp 
    global fft64ChkOutFp
    fft2ChkInDatFp = open("./dump/fft2_data_in.dat" , "w")
    fft2ChkInWnFp  = open("./dump/fft2_wn_in.dat"   , "w")
    fft2ChkOutFp   = open("./dump/fft2_data_out.dat", "w")
    fft8ChkInDatFp = open("./dump/fft8_data_in.dat" , "w")
    fft8ChkInWnFp  = open("./dump/fft8_wn_in.dat"   , "w")
    fft8ChkOutFp   = open("./dump/fft8_data_out.dat", "w")
    fft64ChkInFp   = open("./dump/fft64_data_in.dat" , "w")
    fft64ChkOutFp  = open("./dump/fft64_data_out.dat", "w")
    return 0


def fftDumpEnd():
    global fft2ChkInDatFp
    global fft2ChkInWnFp 
    global fft2ChkOutFp  
    global fft8ChkInDatFp
    global fft8ChkInWnFp 
    global fft8ChkOutFp  
    global fft64ChkInFp 
    global fft64ChkOutFp
    fft2ChkInDatFp.close()
    fft2ChkInWnFp .close()
    fft2ChkOutFp  .close()
    fft8ChkInDatFp.close()
    fft8ChkInWnFp .close()
    fft8ChkOutFp  .close()
    fft64ChkInFp  .close()
    fft64ChkOutFp .close()
    return 0


def fft2Dump(dataIn, wn, dataOut):
    global fft2ChkInDatFp
    global fft2ChkInWnFp
    global fft2ChkOutFp
    dump_dataIn  = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataIn]
    dump_dataOut = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataOut]
    dump_dataWn  = ["({:d}+{:d}j)".format(int(complex(x).real*256), int(complex(x).imag*256)) for x in wn]
    fft2ChkInDatFp.write(", ".join( dump_dataIn ) + "\n")
    fft2ChkOutFp  .write(", ".join( dump_dataOut) + "\n")
    fft2ChkInWnFp .write(", ".join( dump_dataWn ) + "\n")
    # fft2ChkInDatFp.write(",".join( map(lambda x:str(complex(x)),dataIn ) ) + "\n")
    # fft2ChkOutFp  .write(",".join( map(lambda x:str(complex(x)),dataOut) ) + "\n")
    # fft2ChkInWnFp .write(",".join( map(lambda x:str(complex(x*256)),wn ) ) + "\n")


def fft8Dump(dataIn, wn, dataOut):
    global fft8ChkInDatFp
    global fft8ChkInWnFp
    global fft8ChkOutFp
    dump_dataIn  = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataIn]
    dump_dataOut = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataOut]
    dump_dataWn  = ["({:d}+{:d}j)".format(int(complex(x).real*256), int(complex(x).imag*256)) for x in wn]
    fft8ChkInDatFp.write(", ".join( dump_dataIn ) + "\n")
    fft8ChkOutFp  .write(", ".join( dump_dataOut) + "\n")
    fft8ChkInWnFp .write(", ".join( dump_dataWn ) + "\n")
    # fft8ChkInDatFp.write(",".join( map(lambda x:str(complex(x)),dataIn ) ) + "\n")
    # fft8ChkOutFp  .write(",".join( map(lambda x:str(complex(x)),dataOut) ) + "\n")
    # fft8ChkInWnFp .write(",".join( map(lambda x:str(complex(x*256)),wn ) ) + "\n")


def fft64Dump(dataIn, dataOut):
    global fft64ChkInFp 
    global fft64ChkOutFp
    dump_dataIn  = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataIn]
    dump_dataOut = ["({:d}+{:d}j)".format(int(complex(x).real)    , int(complex(x).imag)    ) for x in dataOut]
    fft64ChkInFp .write("\n".join(dump_dataIn ))
    fft64ChkOutFp.write("\n".join(dump_dataOut))


###=====TOOLKIT=====###
def wn_fix(data, bits):
    if isinstance(data, complex):
        return np.round(data.real * pow(2,bits)) / pow(2,bits) + \
               np.round(data.imag * pow(2,bits)) / pow(2,bits) * 1j
    else:
        return np.round(data * pow(2,bits)) / pow(2,bits)


def complex_floor(data):
    if isinstance(data, complex):
        return np.floor(data.real) + np.floor(data.imag) * 1j
    else:
        return np.floor(data)


def complex_round(data):
    if isinstance(data, complex):
        return np.round(data.real) + np.round(data.imag) * 1j
    else:
        return np.round(data)


###=====FFT=====###
def fft2(data, wn):
    assert(len(data) == 2)
    fft2Out = [data[0] + wn * data[1], data[0] - wn * data[1]]
    #---fixed---
    fft2Out = [complex_floor(x) for x in fft2Out]

    fft2Dump(data, [wn], fft2Out)
    return np.array(fft2Out)


def fft4(data, wn):
    assert(len(data) == 4)
    assert(len(wn) == 3)
    fft4D1Out = []
    fft4D2Out = []

    for i in [0,2]:
        fft4D1Out.extend(fft2(data     [i:i+2]  , wn[0]))
    for i in [0,1]:
        fft4D2Out.extend(fft2(fft4D1Out[i:i+3:2], wn[1+i]))
    ordD2 = [0,2,1,3]
    fft4D2Out = [fft4D2Out[x] for x in ordD2]

    return np.array(fft4D2Out)


def fft8(data, wn):
    assert(len(data) == 8)
    assert(len(wn) == 7)
    fft8D1Out = []
    fft8D2Out = []
    fft8D3Out = []

    for i in [0,2,4,6]:
        fft8D1Out.extend(fft2(data     [i:i+2]  , wn[0]))
    for i in [0,1,4,5]:
        fft8D2Out.extend(fft2(fft8D1Out[i:i+3:2], wn[1+(i%4)]))
    ordD2 = [0,2,1,3,4,6,5,7]
    fft8D2Out = [fft8D2Out[x] for x in ordD2]
    for i in [0,1,2,3]:
        fft8D3Out.extend(fft2(fft8D2Out[i:i+5:4], wn[3+i]))
    ordD3 = [0,2,4,6,1,3,5,7]
    fft8D3Out = [fft8D3Out[x] for x in ordD3]

    fft8Dump(data, wn, fft8D3Out)
    return np.array(fft8D3Out)


def fft64Base8(data):
    fftDumpInit()
    
    ordIn = []
    for i in range(64):
        idxT = bin(i)[2:]
        idxT = '0'*(6-len(idxT))+idxT
        idxTRev = idxT[::-1]
        ordIn.extend([int(idxTRev,2)])
    assert(len(ordIn) == 64)
    fft64In = [data[x] for x in ordIn]
    wn64 = [np.exp(-1j * 2 * np.pi * x/64) for x in range(32)]
    fft64D1Out = []
    fft64D2Out = []

    #---fixed---
    fft64In = np.floor(fft64In)
    wn64 = [wn_fix(x,8) for x in wn64]

    #--- stage 1 ---
    for i in np.array(range(8)) * 8:
        wnD1 = [np.exp(-1j * 2 * np.pi * 0/2)]
        wnD2 = [np.exp(-1j * 2 * np.pi * x/4) for x in range(2)]
        wnD3 = [np.exp(-1j * 2 * np.pi * x/8) for x in range(4)]
        wnD1 = [wn64[0]]
        wnD2 = wn64[0:32:16]
        wnD3 = wn64[0:32:8]
        wn = wnD1 + wnD2 + wnD3
        fft64D1Out.extend(fft8(fft64In[i:i+8], wn))
        
    #---stage 2 ---
    for i in np.array(range(8)):
        wnD1 = [np.exp(-1j * 2 * np.pi * i/16)]
        wnD2 = [np.exp(-1j * 2 * np.pi * (i+x)/32) for x in np.arange(0,16,8)]
        wnD3 = [np.exp(-1j * 2 * np.pi * (i+x)/64) for x in np.arange(0,32,8)]
        wnD1 = [wn64[i*4]]
        wnD2 = wn64[i*2::16]
        wnD3 = wn64[i::8]
        wn = wnD1 + wnD2 + wnD3
        fft64D2Out.append(fft8(fft64D1Out[i:i+64:8], wn))
    fft64D2Out = np.array(fft64D2Out).T
    fft64D2Out = fft64D2Out.reshape(64)

    fft64Dump(np.floor(data), fft64D2Out)
    fftDumpEnd()
    
    return fft64D2Out


if __name__ == "__main__":
    #--- TEST FFT8 ---
    # testIn = genData.genSin(5,4,8)
    # wnD1 = [np.exp(-1j * 2 * np.pi * 0/2)]
    # wnD2 = [np.exp(-1j * 2 * np.pi * i/4) for i in range(2)]
    # wnD3 = [np.exp(-1j * 2 * np.pi * i/8) for i in range(4)]
    # wn = wnD1 + wnD2 + wnD3
    # ordIn = [0,4,2,6,1,5,3,7]
    # print(wn)
    # print(fft8([testIn[x] for x in ordIn], wn))
    # print(np.fft.fft(testIn))

    #--- TEST FFT4 ---
    # testIn = genData.genRand(-2,2,4)
    # wnD1 = [np.exp(-1j * 2 * np.pi * 0/2)]
    # wnD2 = [np.exp(-1j * 2 * np.pi * i/4) for i in range(2)]
    # wn = wnD1 + wnD2
    # ordIn = [0,2,1,3]
    # print(wn)
    # print(fft4([testIn[x] for x in ordIn], wn))
    # print(np.fft.fft(testIn))

    #--- TEST FFT64 ---
    testIn = genData.genTri(40,40,64)
    print(fft64Base8(testIn))
    print(np.fft.fft(testIn))

    
