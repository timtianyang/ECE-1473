function [ h,t ] = rect_pulse( Kt,bit_period,sample_per_bit )
%generates a rect pulse
%return time and pulse
    
t=linspace(-Kt*bit_period,Kt*bit_period,Kt*2*sample_per_bit);

h=t*0;
h(abs(t)<=(bit_period/2))=h(abs(t)<=(bit_period/2))+1;

end

