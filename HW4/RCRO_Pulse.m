function [ h ,t] = RCRO_Pulse( Kt,Tb,samp_per_bit,r )
%2Kt, number of bit period to be computed, Tb, bit period,  r rolloff factor
%
%
t=linspace(-Kt*Tb,Kt*Tb,2*Kt*samp_per_bit);
f0=1/Tb/2
fd=r*f0
r
h=0*t;
zero_t=1/(4*fd)%value that will cause divide by zero error

for l=1:length(t)
  
   c=(cos(2*pi*fd.*t(l)))./(1-(4*fd*t(l)).^2);
    if abs((abs(t(l))-zero_t))<0.0001
       t(l)
       c=pi*sin(2*pi*fd*t(l))./(16*fd*t(l))%using l'hospital rule
    end
   h(l)=2*f0*sinc(2.*f0.*t(l))*c;
 
end

end

