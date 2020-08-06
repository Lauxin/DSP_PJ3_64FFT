function fft_o = FFT2x32(fft_i_1, fft_i_2, group)
%====================================================
% Author: Liu Xun
% Date  : 2020-07-31
% FFT2x32 
    % fft_i_1, fft_i_2 are (1x32)
    % fft_o is (1x64)
    % wn alters according to group
%====================================================

wn = zeros(1,group/2);
for i = 1:group/2
    wn(i) = exp(-1j*2*pi*(i-1)/group);
end

fft_o_1 = zeros(group/2, 64/group);
fft_o_2 = zeros(group/2, 64/group);
for i = 1:64/group
    fft_o_1(:,i) = fft_i_1((i-1)*group/2+1 : i*group/2) + wn .* fft_i_2((i-1)*group/2+1 : i*group/2) ;
    fft_o_2(:,i) = fft_i_1((i-1)*group/2+1 : i*group/2) - wn .* fft_i_2((i-1)*group/2+1 : i*group/2) ;
end
fft_o = reshape([fft_o_1;fft_o_2], 1,64);

end