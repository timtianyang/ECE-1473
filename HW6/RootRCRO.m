function [ t,h ] = RootRCRO( Kt,Tb,bits_per_samp,r )
%Root Raised Cosine Rolloff pulse
%  Tb is the bit period and 2kT represents the number of bit periods
t=linspace(-Kt*Tb,Kt*Tb,2*Kt*bits_per_samp);
h=0*t;
R=1/Tb;

for t1=1:length(t)    
   if t(t1)==0
       h(t1)=1-r+4*r/pi;       
   elseif abs(t(t1))==Tb/4/r           
       h(t1)=r/2^0.5*((1+2/pi)*sin(pi/4/r)+(1-2/pi)*cos(pi/4/r)) ; 
   else       
       h(t1)=(sin(pi*R*t(t1)*(1-r))+4*R*r*t(t1)*cos(pi*R*t(t1)*(1+r)))./(pi*R*t(t1)*(1-(4*R*r*t(t1)).^2));      
   end   
end
end

