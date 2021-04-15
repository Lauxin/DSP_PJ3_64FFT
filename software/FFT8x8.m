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

% TODO: do not use group as its meaning is unclear. For example, use stage instead. 

wn = exp(-1j*2*pi*(0:group/2-1)/group);
switch group
case 8
    wn_d0 = repmat( wn(1:4:group/2).', 1,8);
    wn_d1 = repmat( wn(1:2:group/2).', 1,8);
    wn_d2 = repmat( wn(1:1:group/2).', 1,8);
case 64
    wn_d0 =         wn(1:4:group/2);
    wn_d1 = reshape(wn(1:2:group/2), 8,2).';
    wn_d2 = reshape(wn(1:1:group/2), 8,4).';
end

% d1
fft_d1_1 = fft_i_1 + fft_i_2 .* wn_d0(1,:) ;
fft_d1_2 = fft_i_1 - fft_i_2 .* wn_d0(1,:) ;
fft_d1_3 = fft_i_3 + fft_i_4 .* wn_d0(1,:) ;
fft_d1_4 = fft_i_3 - fft_i_4 .* wn_d0(1,:) ;
fft_d1_5 = fft_i_5 + fft_i_6 .* wn_d0(1,:) ;
fft_d1_6 = fft_i_5 - fft_i_6 .* wn_d0(1,:) ;
fft_d1_7 = fft_i_7 + fft_i_8 .* wn_d0(1,:) ;
fft_d1_8 = fft_i_7 - fft_i_8 .* wn_d0(1,:) ;
% fft_d1 = [fft_d1_1; fft_d1_2; fft_d1_3; fft_d1_4; fft_d1_5; fft_d1_6; fft_d1_7; fft_d1_8]
% d1
fft_d2_1 = fft_d1_1 + fft_d1_3 .* wn_d1(1,:);
fft_d2_3 = fft_d1_1 - fft_d1_3 .* wn_d1(1,:);
fft_d2_2 = fft_d1_2 + fft_d1_4 .* wn_d1(2,:);
fft_d2_4 = fft_d1_2 - fft_d1_4 .* wn_d1(2,:);
fft_d2_5 = fft_d1_5 + fft_d1_7 .* wn_d1(1,:);
fft_d2_7 = fft_d1_5 - fft_d1_7 .* wn_d1(1,:);
fft_d2_6 = fft_d1_6 + fft_d1_8 .* wn_d1(2,:);
fft_d2_8 = fft_d1_6 - fft_d1_8 .* wn_d1(2,:);
% fft_d2 = [fft_d2_1; fft_d2_2; fft_d2_3; fft_d2_4; fft_d2_5; fft_d2_6; fft_d2_7; fft_d2_8]  
% d2
fft_o_1 = fft_d2_1 + fft_d2_5 .* wn_d2(1,:);
fft_o_5 = fft_d2_1 - fft_d2_5 .* wn_d2(1,:);
fft_o_2 = fft_d2_2 + fft_d2_6 .* wn_d2(2,:);
fft_o_6 = fft_d2_2 - fft_d2_6 .* wn_d2(2,:);
fft_o_3 = fft_d2_3 + fft_d2_7 .* wn_d2(3,:);
fft_o_7 = fft_d2_3 - fft_d2_7 .* wn_d2(3,:);
fft_o_4 = fft_d2_4 + fft_d2_8 .* wn_d2(4,:);
fft_o_8 = fft_d2_4 - fft_d2_8 .* wn_d2(4,:);
fft_o = [fft_o_1;fft_o_2;fft_o_3;fft_o_4;fft_o_5;fft_o_6;fft_o_7;fft_o_8];

switch group
case 8
    % in this case, every base8 FFT is seperated with each other
    fft_o = reshape(fft_o, 1,[]);
case 64
    % in this case, base8 FFTs are overlapped
    fft_o = reshape(fft_o.', 1,[]);
end

end