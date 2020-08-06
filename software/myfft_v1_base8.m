%=====================================================
% Author      : Liu Xun
% Data        : 2020-07-31
% Description : % DIT 64FFT base 8
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

% stage 1: group 8
fft_d1_i = zeros(8,8);
ord_d1 = 1:8:57;
% !!! "ord" here is the first positon of every 8 points FFT 
% !!! of all 8 base-8 FFT units. 
for i = 1:8
    fft_d1_i(1,i) = fft_d0_o(ord_d1(i));
    fft_d1_i(2,i) = fft_d0_o(ord_d1(i)+1);
    fft_d1_i(3,i) = fft_d0_o(ord_d1(i)+2);
    fft_d1_i(4,i) = fft_d0_o(ord_d1(i)+3);
    fft_d1_i(5,i) = fft_d0_o(ord_d1(i)+4);
    fft_d1_i(6,i) = fft_d0_o(ord_d1(i)+5);
    fft_d1_i(7,i) = fft_d0_o(ord_d1(i)+6);
    fft_d1_i(8,i) = fft_d0_o(ord_d1(i)+7);
end
fft_d1_o = FFT8x8(fft_d1_i(1,:),...
                  fft_d1_i(2,:),...
                  fft_d1_i(3,:),...
                  fft_d1_i(4,:),...
                  fft_d1_i(5,:),...
                  fft_d1_i(6,:),...
                  fft_d1_i(7,:),...
                  fft_d1_i(8,:), 8);

% stage 2: group 64
fft_d2_i = zeros(8,8);
ord_d2 = 1:8;
for i = 1:8
    fft_d2_i(1,i) = fft_d1_o(ord_d2(i));
    fft_d2_i(2,i) = fft_d1_o(ord_d2(i)+1*64/8);
    fft_d2_i(3,i) = fft_d1_o(ord_d2(i)+2*64/8);
    fft_d2_i(4,i) = fft_d1_o(ord_d2(i)+3*64/8);
    fft_d2_i(5,i) = fft_d1_o(ord_d2(i)+4*64/8);
    fft_d2_i(6,i) = fft_d1_o(ord_d2(i)+5*64/8);
    fft_d2_i(7,i) = fft_d1_o(ord_d2(i)+6*64/8);
    fft_d2_i(8,i) = fft_d1_o(ord_d2(i)+7*64/8);
end
fft_o = FFT8x8(fft_d2_i(1,:),...
               fft_d2_i(2,:),...
               fft_d2_i(3,:),...
               fft_d2_i(4,:),...
               fft_d2_i(5,:),...
               fft_d2_i(6,:),...
               fft_d2_i(7,:),...
               fft_d2_i(8,:),64);

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