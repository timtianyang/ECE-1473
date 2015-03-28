clear
clc
close all

R=1;
l=2;
r=0.35;
Tb=1/R;
f=linspace(0,8*r/l,1000);

F_squared = GenRCRFreq( f, Tb, r);
plot(f,10*log10(F_squared))
ylabel('power spectral density (dB)')
xlabel('f Hz')
title('PSD for complex envelope using RRCRO')