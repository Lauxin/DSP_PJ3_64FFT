%=====================================================
% Author      : Liu Xun
% Data        : 2020-07-31
% Description : % DIT 64FFT base 4
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

% stage 1: group 4
fft_d1_i = zeros(4,16);
ord_d1 = 1:4:61;
% !!! "ord" here is the first positon of every 4 points FFT 
% !!! of all 16 base-4 FFT units. 
for i = 1:16
    fft_d1_i(1,i) = fft_d0_o(ord_d1(i));
    fft_d1_i(2,i) = fft_d0_o(ord_d1(i)+1);
    fft_d1_i(3,i) = fft_d0_o(ord_d1(i)+2);
    fft_d1_i(4,i) = fft_d0_o(ord_d1(i)+3);
end
fft_d1_o = FFT4x16(fft_d1_i(1,:),...
                   fft_d1_i(2,:),...
                   fft_d1_i(3,:),...
                   fft_d1_i(4,:), 4);

% stage 2: group 16
fft_d2_i = zeros(4,16);
ord_d2 = [1:4, 17:20, 33:36, 49:52];
for i = 1:16
    fft_d2_i(1,i) = fft_d1_o(ord_d2(i));
    fft_d2_i(2,i) = fft_d1_o(ord_d2(i)+1*16/4);
    fft_d2_i(3,i) = fft_d1_o(ord_d2(i)+2*16/4);
    fft_d2_i(4,i) = fft_d1_o(ord_d2(i)+3*16/4);
end
fft_d2_o = FFT4x16(fft_d2_i(1,:),...
                   fft_d2_i(2,:),...
                   fft_d2_i(3,:),...
                   fft_d2_i(4,:),16);

% stage 3: group 64
fft_d3_i = zeros(4,16);
ord_d3 = 1:16;
for i = 1:16
    fft_d3_i(1,i) = fft_d2_o(ord_d3(i));
    fft_d3_i(2,i) = fft_d2_o(ord_d3(i)+1*64/4);
    fft_d3_i(3,i) = fft_d2_o(ord_d3(i)+2*64/4);
    fft_d3_i(4,i) = fft_d2_o(ord_d3(i)+3*64/4);
end

fft_o = FFT4x16(fft_d3_i(1,:),...
                fft_d3_i(2,:),...
                fft_d3_i(3,:),...
                fft_d3_i(4,:),64);

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