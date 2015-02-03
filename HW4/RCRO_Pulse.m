function [ h ,t] = RCRO_Pulse( Kt,Tb,samp_per_bit,r )
%2Kt, number of bit period to be computed, Tb, bit period,  r rolloff factor
%
%
t=linspace(-Kt*Tb,Kt*Tb,2*Kt*Tb*samp_per_bit);
f0=1/Tb;
fd=r*f0;
h=2*f0*sinc(2.*f0.*t).*(cos(2*pi*fd.*t))./(1-(4*fd*t).^2);
end

