function fft_o = FFT4x16(fft_i_1, fft_i_2, fft_i_3, fft_i_4, group)
%====================================================
% Author: Liu Xun
% Date  : 2020-07-31
% FFT4x16 
    % fft_i_1, fft_i_2, fft_i_3, fft_i_4 are (1x16)
    % fft_o is (1x64)
    % wn alters according to group
%====================================================

% defination of group refers to doc/
% it represents the number of required Wn.

wn = zeros(1,group/2);
for i = 1:group/2
    wn(i) = exp(-1j*2*pi*(i-1)/group);
end

fft_o_1 = zeros(group/4, 64/group);
fft_o_2 = zeros(group/4, 64/group);
fft_o_3 = zeros(group/4, 64/group);
fft_o_4 = zeros(group/4, 64/group);
for i = 1:64/group
    % d1
    fft_d1_1 = fft_i_1((i-1)*group/4+1 : i*group/4) + fft_i_2((i-1)*group/4+1 : i*group/4).*wn(1:2:group/2);
    fft_d1_2 = fft_i_1((i-1)*group/4+1 : i*group/4) - fft_i_2((i-1)*group/4+1 : i*group/4).*wn(1:2:group/2);
    fft_d1_3 = fft_i_3((i-1)*group/4+1 : i*group/4) + fft_i_4((i-1)*group/4+1 : i*group/4).*wn(1:2:group/2);
    fft_d1_4 = fft_i_3((i-1)*group/4+1 : i*group/4) - fft_i_4((i-1)*group/4+1 : i*group/4).*wn(1:2:group/2);
    % d2
    fft_o_1(:,i) = fft_d1_1 + fft_d1_3.*wn(1:group/4) ;
    fft_o_2(:,i) = fft_d1_2 + fft_d1_4.*wn(group/4+1:group/2) ;
    fft_o_3(:,i) = fft_d1_1 - fft_d1_3.*wn(1:group/4) ;
    fft_o_4(:,i) = fft_d1_2 - fft_d1_4.*wn(group/4+1:group/2) ;
end
fft_o = reshape([fft_o_1;fft_o_2;fft_o_3;fft_o_4], 1,64);

end