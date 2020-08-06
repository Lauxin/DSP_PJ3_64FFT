%=====================================================
% Author      : Liu Xun
% Data        : 2020-07-31
% Description : % DIT 64FFT base 2
%====================================================

clear;

fft_i = gen_wave("tri",1,20);

% stage 0: reorder input
fft_d0_i = zeros(2,32);
ord_d0 = [0 ,16,8 ,24,4 ,20,12,28,2 ,18,10,26,6 ,22,14,30,1 ,17,9 ,25,5 ,21,13,29,3 ,19,11,27,7 ,23,15,31] + 1;
for i = 1:32
    fft_d0_i(1,i) = fft_i(ord_d0(i));
    fft_d0_i(2,i) = fft_i(ord_d0(i)+32);
end
fft_d0_o = reshape(fft_d0_i, 1,64);

% stage 1: group 2
fft_d1_i = zeros(2,32);
ord_d1 = 1:2:63;
% !!! "ord" here is the first positon of every 2 points FFT 
% !!! of all 32 base-2 FFT units. 
for i = 1:32
    fft_d1_i(1,i) = fft_d0_o(ord_d1(i));
    fft_d1_i(2,i) = fft_d0_o(ord_d1(i)+2/2);
end
fft_d1_o = FFT2x32(fft_d1_i(1,:), fft_d1_i(2,:),2);

% stage 2: group 4
fft_d2_i = zeros(2,32);
ord_d2 = reshape([1:4:61; 2:4:62], 1,32);
for i = 1:32
    fft_d2_i(1,i) = fft_d1_o(ord_d2(i));
    fft_d2_i(2,i) = fft_d1_o(ord_d2(i)+4/2);
end
fft_d2_o = FFT2x32(fft_d2_i(1,:), fft_d2_i(2,:),4);

% stage 3: group 8
fft_d3_i = zeros(2,32);
ord_d3 = reshape([1:8:57; 2:8:58; 3:8:59; 4:8:60], 1,32);
for i = 1:32
    fft_d3_i(1,i) = fft_d2_o(ord_d3(i));
    fft_d3_i(2,i) = fft_d2_o(ord_d3(i)+8/2);
end
fft_d3_o = FFT2x32(fft_d3_i(1,:), fft_d3_i(2,:),8);

% stage 4: group 16
fft_d4_i = zeros(2,32);
ord_d4 = [1:8, 17:24, 33:40, 49:56];
for i = 1:32
    fft_d4_i(1,i) = fft_d3_o(ord_d4(i));
    fft_d4_i(2,i) = fft_d3_o(ord_d4(i)+16/2);
end
fft_d4_o = FFT2x32(fft_d4_i(1,:), fft_d4_i(2,:),16);

% stage 5: group 32
fft_d5_i = zeros(2,32);
ord_d5 = [1:16, 33:48];
for i = 1:32
    fft_d5_i(1,i) = fft_d4_o(ord_d5(i));
    fft_d5_i(2,i) = fft_d4_o(ord_d5(i)+32/2);
end
fft_d5_o = FFT2x32(fft_d5_i(1,:), fft_d5_i(2,:),32);

% stage 6: group 64
fft_d6_i = zeros(2,32);
ord_d6 = 1:32;
for i = 1:32
    fft_d6_i(1,i) = fft_d5_o(ord_d6(i));
    fft_d6_i(2,i) = fft_d5_o(ord_d6(i)+64/2);
end
fft_o = FFT2x32(fft_d6_i(1,:), fft_d6_i(2,:),64);

% cross check
fft_c = fft(fft_i,64);
for i = 1:64
    equal_flag = norm(fft_c(i)-fft_o(i)) < 1e-12;
%     if ~isequal(vec_test(i),vector(i))
    if ~ equal_flag
        fprintf('error at %d(%d+%di not equal to %d+%di)\n', ...
            i, real(fft_o(i)), imag(fft_o(i)), real(fft_c(i)), imag(fft_c(i)));
    else
        fprintf('correct at %d\n', i);
    end
end