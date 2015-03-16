clear
clc
close all
num_random_bits=20;
R=100;%bps might cause aliasing
bit_period=1/R;
sample_per_bit=16;
Kt=5;
r=0.25;
%%%%carrier
fc=500;
wc=2*pi*fc;
Ac=1;
%%%%for DFT
Tb=bit_period;
N=512; %fft
fs=16/bit_period;
d_t=1/fs;
T=N*d_t;
iterations=100;

%%%%generating a pulse
[h,t]=RootRCRO_Pulse(Kt,bit_period,sample_per_bit,r);




%%%%modulation and detection










f=linspace(-fs/2,fs/2,N);
theory_PSD=Ac^2/16*(Tb*(sinc((f-fc)*Tb)).^2)+Ac^2/16*(Tb*(sinc((f+fc)*Tb)).^2);
figure(3)%%plotting the PSD from equation




averagedPSD=0*theory_PSD;
figure(1)
figure(2)
input('press anything to continue>>>')
for i=1:iterations
    %%%%generating bits
    [n, an]=random_bits(num_random_bits,[1 0]);
    figure(1)
    subplot(2,1,1)
    stem(n,an,'r*')
    title('random bits')
    xlabel('number')
    ylabel('bits')



    %%%%generating baseband signal
    figure(1)
    [s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );
    subplot(2,1,2)
    plot(tt,s_t)
    xlabel('time seconds')
    ylabel('signal')
    title(strcat('s(t) using RCRO pulse r= ',sprintf('%0.3f',r)));


    %%%%comparing with carrier
    figure(2)
    carrier=Ac*cos(wc.*tt);
    modulated=carrier.*s_t;
    plot(tt,modulated)
    title('OOK Modulation')
    xlabel('t (sec)')
    ylabel('OOK signal')

    %%%%PSD
    figure(3)
    subplot(2,1,1)

    F=fft(modulated,N);
    F=fftshift(abs(F));
    F=F*d_t;%normalize
    PSD=abs(F.^2)./T;
    plot(f,PSD);

    hold on
    plot(f,theory_PSD,'r')
    hold off
    subplot(2,1,2)
   
    averagedPSD=averagedPSD+PSD;
    
    plot(f,averagedPSD/i);
    hold on
    plot(f,theory_PSD,'r')
    hold off
    
    %pause(0.1)
end
figure(3)%%plotting the PSD from equation
subplot(2,1,2)
xlabel('freq (Hz)')
ylabel('|S_t|')
title('average PSD vs. theory')
subplot(2,1,1)
xlabel('freq (Hz)')
ylabel('|S_t|')
title('one realization of PSD')

figure(4)
plot(f,20*log10(abs(theory_PSD)),'r')
hold on
plot(f,20*log10(abs(averagedPSD)/i))
hold off

xlabel('freq (Hz)')
ylabel('|S_t| in dB')
title('simulated PSD vs. theory')


