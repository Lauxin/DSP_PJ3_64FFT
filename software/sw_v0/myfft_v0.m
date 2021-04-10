% function [ ret_val ] = myfft( vector )
%======================================
% 
%======================================
clear
close all

fp_src   = fopen('./check_data/fft_data_in.dat'   , 'w');   
fp_rord  = fopen('./check_data/fft_data_rord.dat' , 'w');
fp_ord   = fopen('./check_data/fft_ord.dat'       , 'w');       
fp_tmp   = fopen('./check_data/fft_data_tmp.dat'  , 'w');  
fp_mid   = fopen('./check_data/fft_data_mid.dat'  , 'w');  
fp_wn    = fopen('./check_data/fft_wn_64.dat'     , 'w');     
fp_out   = fopen('./check_data/fft_data_out.dat'  , 'w');  

%% input
% [x, fs] = audioread('music3.wav');
x = gen_wave("tri",1/16,30);

vector = x';

N = length(vector);
bitnum = 8;

for k = 1:length(vector)
    fft_i_re = floor(real(vector(k)) * 2^bitnum);
    fft_i_im = floor(imag(vector(k)) * 2^bitnum);
    fprintf(fp_src,'%d + %di\n', fft_i_re, fft_i_im);
end

%% reorder
j = 0;
for i = 1 : N
    fprintf(fp_ord,'%d ',j);
    if i < j + 1
        tmp0 = vector(j + 1);
        vector(j + 1) = vector(i);
        vector(i) =tmp0;
    end
    k = N / 2;
    while k <= j
        j = j - k;
        k = k / 2;
    end
    j = j + k;
end
fprintf(fp_ord,'\n');

for k = 1:length(vector)
    fft_i_re = floor(real(vector(k)) * 2^bitnum);
    fft_i_im = floor(imag(vector(k)) * 2^bitnum);
    fprintf(fp_rord,'%d + %di\n', fft_i_re, fft_i_im);
end

%% 
depth = log2(N);

n = N / 2;
for stage = 1 : depth
    dist = 2 ^ (stage - 1);     % offset 1/2/4/8/...
    idx = 1;
    fprintf('stage %d ...\n',stage);
    for i = 1 : n
        idx_tmp = idx;
        for j = 1 : N / (2 * n)
            r = (idx - 1) * 2 ^ (depth - stage);
            fprintf(fp_tmp,'%d ',r);
            coef = exp(1j * (-2 * pi * r / N));
            fprintf(fp_tmp,'%d + %di\n',real(coef), imag(coef));
            tmp0 = vector(idx);
            tmp1 = vector(idx+dist);
            vector(idx) = tmp0 + tmp1 * coef;
            vector(idx + dist) = tmp0 - tmp1 * coef;  
            fprintf('\t%d and %d; ',idx, idx+dist);
            fprintf(fp_ord,'%d %d ',idx-1,idx+dist-1);
            idx = idx + 1;
        end
        idx = idx_tmp + 2 * dist;
    end % 
    n = n / 2;
    fprintf('\n');
    fprintf(fp_ord,'\n');
    %dump
    for k = 1:length(vector)
        re_tmp = floor(real(vector(k)) * 2^bitnum);
        im_tmp = floor(imag(vector(k)) * 2^bitnum);
        fprintf(fp_mid, '%d + %di, ', re_tmp,im_tmp);
    end
    fprintf(fp_mid, '\n');
end % N*LOG(N)

ret_val = vector;
for k = 1:length(vector)
    fft_o_re = floor(real(vector(k)) * 2^bitnum);
    fft_o_im = floor(imag(vector(k)) * 2^bitnum);
    fprintf(fp_out,'%d + %di\n', fft_o_re, fft_o_im);
end
for k = 0:N-1
    wn = exp(1i * (-2*pi*k/N));
    wn_re = floor(real(wn) * 2^bitnum);
    wn_im = floor(imag(wn) * 2^bitnum);
    fprintf(fp_wn, '%d + %di\n', wn_re, wn_im);
end

%% cross check myfft with fft
vec_test = fft(x')
wrong_flag = 0;
for i = 1:N
    equal_flag = abs(vec_test(i)-ret_val(i)) < 1e-10;
%     if ~isequal(vec_test(i),vector(i))
    if ~ equal_flag
        fprintf('error at %d(%d+%di not equal to %d+%di)\n', ...
            i, real(vec_test(i)), imag(vec_test(i)), real(ret_val(i)), imag(ret_val(i)));
        wrong_flag = 1;
    end
    if ~wrong_flag
        fprintf('correct at %d\n', i);
    end
end
% end

%% 
fclose(fp_src);
fclose(fp_rord);
fclose(fp_ord);
fclose(fp_mid);
fclose(fp_tmp);
fclose(fp_wn);
fclose(fp_out);
