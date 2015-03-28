function [ t,h ] = rect_pulse( Kt,bit_period,sample_per_bit )
%generates a rect pulse
%return time and pulse
    
t=linspace(-Kt*bit_period,Kt*bit_period,sample_per_bit*2*Kt*bit_period);
h=(t<bit_period/2.0)&(t>-bit_period/2.0);

end

