clc;clear;close all;
Kt=20;
R=500;
Tb=1/R;
r=0.5;%small blips when r=0.6,0.5
sample_per_bit=128;%high fc might need more precision

%%%this has too be a even number for now
num_random_bits=100;%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc=10000;
wc=2*pi*fc;
Ac=1;
iterations=200;






A=1;%bit 1 is represented as 1, bit 0 as -1

%generating a pulse%%%%%%%%%%%%%%%%%%%%%
%[h,t]=RootRCRO_Pulse(Kt,Tb,sample_per_bit,r);%my RRCRO pulse produces a
%0.01 error compared to Kevins
%[ h,t ] = rect_pulse(Kt, Tb,sample_per_bit );%Rect pulse
[h,t]=root_rcro( Kt,Tb, sample_per_bit, r);%kevins RRCRO has blips as
%well, it might be the basband function


%generating bits%%%%%%%%%%%%%%%%%%%%%%%%
[n,an]=random_bits(num_random_bits,[A -A]);%Polar NRZ


%Even bits to I channel

a_i=an(mod(n,2) == 0);
[ m_i,t_i ] = get_baseband(h,t,a_i,sample_per_bit );



%Odd bits to Q channel
a_q=an(mod(n,2) ~= 0);
[ m_q,t_q ] = get_baseband( h,t,a_q,sample_per_bit );


%modulation without time shift (QPSK) for debugging
figure(1)
s_i=m_i.*Ac.*cos(wc*t_i);
s_q=m_q.*Ac.*sin(wc*t_q);
s_trans=s_i-s_q;


subplot(3,2,1)
plot(t_i,s_i)
hold on
plot(t_i,m_i,'-r')
hold off
xlabel('time s')
ylabel('channel I')
title('even bits')
subplot(3,2,3)
plot(t_q,s_q)
hold on
plot(t_q,m_q,'-r')
hold off
xlabel('time s')
ylabel('channel Q')
title('odd bits')
subplot(3,2,5)
plot(t_q,s_trans,'-r')
title('QPSK I minus Q')

%modulation with time shift on Q channel(OQPSK)
%shifting and extending Q channel
%extending I channel
dt=t_q(2)-t_q(1);
shamt=ceil(Tb/2/dt);
for i=1:shamt
    m_q=[0 m_q];
    s_q=[0 s_q];
    t_q=[t_q t_q(length(t_q))+dt];
    m_i=[m_i 0];
    s_i=[s_i 0];
    t_i=[t_i t_i(length(t_i))+dt];
end

s_trans=s_i-s_q;


subplot(3,2,2)
plot(t_i,s_i)
hold on
plot(t_i,m_i,'-r')
hold off
xlabel('time s')
ylabel('channel I')
title('even bits')
subplot(3,2,4)
plot(t_q,s_q)
hold on
plot(t_q,m_q,'-r')
hold off
xlabel('time s')
ylabel('channel Q')
title('odd bits')
subplot(3,2,6)
plot(t_q,s_trans,'-r')
title('OQPSK I minus Q')



%demodulating
s_i=s_trans.*cos(wc*t_i)*2/Ac;
s_q=-s_trans.*sin(wc*t_q)*2/Ac;
rt_q=conv(s_q,h,'same')/sample_per_bit;%match filter
rt_i=conv(s_i,h,'same')/sample_per_bit;%match filter

figure(4)
subplot(2,1,1)
hold on
plot(t_i,rt_i)
title('i channel after matched filter')
for i=1:length(a_i)
    if a_i(i)<0
        plot((i-1)*Tb,-A,'*r')
    else
        plot((i-1)*Tb,A,'*r')
    end
end
hold off


subplot(2,1,2)
title('q channel after matched filter')
hold on
plot(t_q,rt_q)
for i=1:length(a_q)
    if a_q(i)<0
        plot((i-1)*Tb+Tb/2,-A,'*r')
    else
        plot((i-1)*Tb+Tb/2,A,'*r')
    end
end
hold off



N=length(s_trans);
fs=sample_per_bit*R;
d_t=1/fs;
T=N*d_t;
f=linspace(-fs/2,fs/2,N);

F=fft(s_trans);
F=fftshift(abs(F));
F=F*d_t;%normalize
PSD=abs(F.^2)./T;
average_PSD=0*PSD;
theory_PSD_L = GenRCRFreq(f + fc, Tb, r)/2;
theory_PSD_R = GenRCRFreq(f - fc, Tb, r)/2;
theory_PSD = theory_PSD_L + theory_PSD_R;
theory_PSD=theory_PSD/2*Tb;

% theoretical_RCRO_R = RCROfreq_kevin( Tb,r,1 ,1,f,fc);
% theoretical_RCRO_L = RCROfreq_kevin( Tb,r,1 ,1,f,-fc);
% theoretical_RCRO=theoretical_RCRO_R+theoretical_RCRO_L;
% theoretical_RCRO=theoretical_RCRO*2/4*0.707*0.707*0.707;
% %theoretical_RCRO(f>0)=2*Tb/4*(sinc((f(f<0)-fc)*Tb)).^2;
%theoretical_RCRO(f<0)=2*Tb/4*(sinc((f(f<0)+fc)*Tb)).^2;






for i=1:iterations
    
    %generating bits%%%%%%%%%%%%%%%%%%%%%%%%
    [n,an]=random_bits(num_random_bits,[A -A]);%Polar NRZ
    
    
    %Even bits to I channel
    
    a_i=an(mod(n,2) == 0);
    [ m_i,t_i ] = get_baseband(h,t,a_i,sample_per_bit );
    
    
    
    %Odd bits to Q channel
    a_q=an(mod(n,2) ~= 0);
    [ m_q,t_q ] = get_baseband( h,t,a_q,sample_per_bit );
    
    
    %modulation without time shift (QPSK) for debugging
    figure(1)
    s_i=m_i.*Ac.*cos(wc*t_i);
    s_q=m_q.*Ac.*sin(wc*t_q);
    s_trans=s_i-s_q;
    
    
    
    %modulation with time shift on Q channel(OQPSK)
    %shifting and extending Q channel
    %extending I channel
    dt=t_q(2)-t_q(1);
    shamt=ceil(Tb/2/dt);
    for i=1:shamt
        m_q=[0 m_q];
        s_q=[0 s_q];
        t_q=[t_q t_q(length(t_q))+dt];
        m_i=[m_i 0];
        s_i=[s_i 0];
        t_i=[t_i t_i(length(t_i))+dt];
    end
    
    s_trans=s_i-s_q;
      
    %demodulating
    s_i=s_trans.*cos(wc*t_i)*2/Ac;
    s_q=-s_trans.*sin(wc*t_q)*2/Ac;
    rt_q=conv(s_q,h,'same')/sample_per_bit;%match filter
    rt_i=conv(s_i,h,'same')/sample_per_bit;%match filter
        
    %PSD calculation  
    F=fft(s_trans);
    F=fftshift(abs(F));
    F=F*d_t;%normalize
    PSD=abs(F.^2)./T;
    
    
    average_PSD=(average_PSD+PSD);
    
end

figure(6)
average_PSD=average_PSD/iterations;
plot(f,average_PSD)
hold on
plot(f,theory_PSD,'r')
xlabel('f (Hz)')
ylabel('PSD')
title('PSD with a fudge factor of 2')

figure(7)
plot(f,10*log10(average_PSD))
hold on
plot(f,10*log10((theory_PSD)))
xlabel('f (Hz)')
ylabel('PSD(dB)')
title('PSD(dB) with a fudge factor of 2')