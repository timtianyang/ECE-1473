clc
clear
close all

fs=1600;
t=-0.05:1/fs:0.2398;
fc=500;
y=cos(2*pi*fc*t);
N=512;
plot(t,y)


F=fftshift(abs(fft(y,N)));

f=linspace(-fs/2,fs/2,N);
subplot(2,1,1)
plot(f,F)
subplot(2,1,2)
plot(t,y)
% f=linspace(-fs/2,fs/2,100);
% 
% t=linspace(0,10,100);
% carrier=cos(wc.*t);
% F=fft(carrier);
% F=fftshift(F);
% plot(f,abs(F))