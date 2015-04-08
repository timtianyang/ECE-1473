function [ frequency_resp ] = GenRCRFreq( f, Tb, r)
%%%generates a RCRO frequency plot so in time domain it
%%%corresponds to a pulse that has max of 2f0
f0 = 1/ (2*Tb);
fdelta = r*f0;
f1 = f0 - fdelta;
Beta = f1 + 2*fdelta;

frequency_resp=f*0;
for k = 1:length(f)
   
   if (abs(f(k)) < f1)
       frequency_resp(k) = 1;
   elseif (abs(f(k)) < Beta)
       frequency_resp(k) = 1/2*(1 + cos(pi/2 * (abs(f(k)) - f1)/fdelta));
   else
       frequency_resp(k) = 0;
   end

end

%frequency_resp = frequency_resp *Tb;%% could normalize it so in time
%domain, the max is just 1, but it's corrected by dividing Tb in the PSD formula

end