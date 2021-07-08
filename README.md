## Software
### v0
Impletement of Base 2 FFT. And 64-FFT contains 6 stages. Every stage the dist(⬆) and group size(n)(⬇) is different. 
### v1
Impletement of Base 2/4/8 FFT. Specify the dist and group size of evey stage. The refference model of Hardware. 

---

## Hardware
### v0
- time sequence: 
   - 64 clk for input -> (6-1)x3 clk for order/reorder and 32xBase2FFT -> 64clk for output.
   - total for 143 clk.
- architecture
   - serial input + 32xBase2FFT / order / reorder + serial output.
   - require 64 [DATA_RE_WD+DATA_IM_WD -1 :0] register. 
   - high calculation density: 8clk & 32xBase2FFT.
- pipeline
   - not consider
   
### v1
Use base 8 FFT first as it contains the least number of stage.
- time sequence:
   - 64 clk for input, at the same time gathering 8xBase8FFT data. At the last 8 clk of the 64 clk, eight groups of Base8FFT data is ready -> 1 clk for calculation -> 64 clk for output. At the first 8 clock, result of the 2nd stage of 8xBase8FFT is calculated.
   - total for 128/129 clk
- architecture
   - serial input + 1xBase8FFT + serial output
   - require 128 [DATA_RE_WD+DATA_IM_WD -1 :0] register. Can not reuse register in stage 1 and stage 2, because of data dependency. 
   - lower calculation density: 16/17clk & 1x8Base2FFT.
   - if use base 4 FFT, the calculation density would be lower, but the complexity of data path increased. 
- pipe line
   - not consider. 

### what should be involved in the new architecture
1. Increase precision while calculating butterfly FFT unit. Otherwise error would accumulate at each stage.
2. use modelsim as the simulator.