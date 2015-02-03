function [ h ,t] = Gaussian_Pulse( Kt,Tb,samp_per_bit )
%2Kt, number of bit period to be computed, Tb, bit period

t=linspace(-Kt*Tb,Kt*Tb,2*Kt*Tb*samp_per_bit);
h=exp(-t.^2./Tb^2);

end

