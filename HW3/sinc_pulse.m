function [ t,h ] = sinc_pulse( bit_period,sample_per_bit )
%generates a rect pulse
%return time and pulse
    
t=linspace(-5*bit_period,5*bit_period,sample_per_bit*10*bit_period);
h=sinc(pi*t./bit_period);

end
