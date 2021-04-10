function wave_o = gen_wave(wave_type, amplitude, sampling)
%====================================================
% Author: Liu Xun
% Date  : 2020-07-30
% 64 points output
    % square wave
        %  |-|
        % _| |_
    % sin
    % trangle wave
        %  /| /
        % / |/
% amplitude, frequency = 1, sampling frequency = n
%====================================================
% !!! Attention that frequency and sampling frequency should be in digital relation
% !!! as frequency or sampling frequency means nothing without each other.
% !!! For example, if fs = 10f, then for 64 points we get 6 cycles of wave. 

x = 0:63;
if (wave_type == "sqr") 
    wave_o = amplitude*gen_sqr(x*2*pi/sampling);
end

if (wave_type == "sin")
    wave_o = amplitude*(sin(x*2*pi/sampling) + 1)/2;
end

if (wave_type == "tri")
    wave_o = amplitude*gen_tri(x*2*pi/sampling);
end

end


function wave_o = gen_sqr(wave_i)
% cycle is 2pi
    wave_i_mod = mod(wave_i, 2*pi);
    wave_o = (wave_i_mod > pi);
end

function wave_o = gen_tri(wave_i)
% cycle is 2pi
    wave_i_mod = mod(wave_i, 2*pi);
    wave_o = 1/(2*pi) * wave_i_mod;
end

