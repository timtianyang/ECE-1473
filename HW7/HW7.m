clc
clear
close all

sample_per_bit=16;
bit_period=1;
A=5;
N=512; %fft
R=100;%bits/s
fs=16*R;
d_t=1/fs;
T=N*d_t;
iterations=100;

[ t,h ] = rect_pulse( bit_period,sample_per_bit );
f=linspace(-fs/2,fs/2,N);
theory_PSD=A^2*1/R*(sinc(1/R.*f)).^2;
tempPSD=0*f;


for i=1:iterations
%generating random signals
[n,an]=random_bits(32,[A,-A]);
[ s_t,tt ] = get_baseband( h,t,bit_period,an,sample_per_bit );
tt=tt(s_t~=0);%getting rid of zeros
s_t=s_t(s_t~=0);
figure(1)
plot(tt,s_t)%plotting signals
title('random sigals')
xlabel('t')
ylabel('signals')
F=fft(s_t,N);
F=fftshift(F);

F=F*d_t;
PSD=abs(F.^2)./T;
figure(2)
subplot(2,1,1)%plotting PSD of the signal
plot(f,PSD)
title('One realization')
subplot(2,1,2)
tempPSD=tempPSD+PSD;
tempPSD=tempPSD/2;
plot(f,tempPSD)%plot averaged PSD
hold on
plot(f,theory_PSD) %plotting PSD from equation
hold off
title(strcat('Averaged PSD over  ', num2str(i),' iterations'))
xlabel('f')
ylabel('PSD')
end