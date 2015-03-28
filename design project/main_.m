clc;clear;close all;
Kt=5;
R=1280;%%has to be 2^n
Tb=1/R;
r=0.5;
sample_per_bit=128;
fc=400;
wc=2*pi*fc;
%%%this has too be a even number for now
num_random_bits=20;%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=1;


%generating a pulse%%%%%%%%%%%%%%%%%%%%%
[h,t]=RootRCRO_Pulse(Kt,Tb,sample_per_bit,r);%RRCRO pulse
%[ t,h ] = rect_pulse(Kt, Tb,sample_per_bit );%Rect pulse my getbaseband
%has trouble with rect pulse

%generating bits%%%%%%%%%%%%%%%%%%%%%%%%
[n,an]=random_bits(num_random_bits,[A -A]);%Polar NRZ

%Even bits to I channel
a_i=an(mod(n,2) == 0);
[ m_i,t_i ] = get_baseband(h,t,Tb,a_i,sample_per_bit );
plot(t_i,m_i)

s_i=m_i.*cos(wc*t_i);
%Odd bits to Q channel
a_q=an(mod(n,2) ~= 0);
[ m_q,t_q ] = get_baseband( h,t,Tb,a_q,sample_per_bit );
s_q=m_q.*cos(wc*t_q);


subplot(2,1,1)
plot(t_i,s_i)
xlabel('time s')
ylabel('channel I')
title('even bits')
subplot(2,1,2)
plot(t_q,s_q)
xlabel('time s')
ylabel('channel Q')
title('odd bits')



