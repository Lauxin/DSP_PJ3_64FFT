function fft_o = FFT8x8(fft_i_1, fft_i_2, fft_i_3, fft_i_4, ...
                        fft_i_5, fft_i_6, fft_i_7, fft_i_8, group)
%====================================================
% Author: Liu Xun
% Date  : 2020-07-31
% FFT4x16 
    % fft_i_1, fft_i_2, fft_i_3, fft_i_4, fft_i_5, fft_i_6, fft_i_7, fft_i_8 are (1x8)
    % fft_o is (1x64)
    % wn alters according to group
%====================================================

% TODO: always 8 parrally
% TODO: do not use group as its meaning is unclear. use stage instead, for example

wn = zeros(1,group/2);
for i = 1:group/2
    wn(i) = exp(-1j*2*pi*(i-1)/group);
end

fft_o_1 = zeros(group/8, 64/group);
fft_o_2 = zeros(group/8, 64/group);
fft_o_3 = zeros(group/8, 64/group);
fft_o_4 = zeros(group/8, 64/group);
fft_o_5 = zeros(group/8, 64/group);
fft_o_6 = zeros(group/8, 64/group);
fft_o_7 = zeros(group/8, 64/group);
fft_o_8 = zeros(group/8, 64/group);
for i = 1:64/group
    % d1
    fft_d1_1 = fft_i_1((i-1)*group/8+1 : i*group/8) + fft_i_2((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_2 = fft_i_1((i-1)*group/8+1 : i*group/8) - fft_i_2((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_3 = fft_i_3((i-1)*group/8+1 : i*group/8) + fft_i_4((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_4 = fft_i_3((i-1)*group/8+1 : i*group/8) - fft_i_4((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_5 = fft_i_5((i-1)*group/8+1 : i*group/8) + fft_i_6((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_6 = fft_i_5((i-1)*group/8+1 : i*group/8) - fft_i_6((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_7 = fft_i_7((i-1)*group/8+1 : i*group/8) + fft_i_8((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    fft_d1_8 = fft_i_7((i-1)*group/8+1 : i*group/8) - fft_i_8((i-1)*group/8+1 : i*group/8).*wn(1:4:group/2) ;
    % d2
    fft_d2_1 = fft_d1_1 + fft_d1_3 .* wn(1        :2:group/4);
    fft_d2_2 = fft_d1_2 + fft_d1_4 .* wn(group/4+1:2:group/2);
    fft_d2_3 = fft_d1_1 - fft_d1_3 .* wn(1        :2:group/4);
    fft_d2_4 = fft_d1_2 - fft_d1_4 .* wn(group/4+1:2:group/2);
    fft_d2_5 = fft_d1_5 + fft_d1_7 .* wn(1        :2:group/4);
    fft_d2_6 = fft_d1_6 + fft_d1_8 .* wn(group/4+1:2:group/2);
    fft_d2_7 = fft_d1_5 - fft_d1_7 .* wn(1        :2:group/4);
    fft_d2_8 = fft_d1_6 - fft_d1_8 .* wn(group/4+1:2:group/2);
    % d3
    fft_o_1(:,i) = fft_d2_1 + fft_d2_5 .* wn(1          :group/8  );
    fft_o_2(:,i) = fft_d2_2 + fft_d2_6 .* wn(group/8+1  :2*group/8);
    fft_o_3(:,i) = fft_d2_3 + fft_d2_7 .* wn(2*group/8+1:3*group/8);
    fft_o_4(:,i) = fft_d2_4 + fft_d2_8 .* wn(3*group/8+1:4*group/8);
    fft_o_5(:,i) = fft_d2_1 - fft_d2_5 .* wn(1          :group/8  );
    fft_o_6(:,i) = fft_d2_2 - fft_d2_6 .* wn(group/8+1  :2*group/8);
    fft_o_7(:,i) = fft_d2_3 - fft_d2_7 .* wn(2*group/8+1:3*group/8);
    fft_o_8(:,i) = fft_d2_4 - fft_d2_8 .* wn(3*group/8+1:4*group/8);
end
fft_o = reshape([fft_o_1;fft_o_2;fft_o_3;fft_o_4;fft_o_5;fft_o_6;fft_o_7;fft_o_8], 1,64);

end