clc;clear;close all;
Kt=2;
R=200;
Tb=1/R;
r=0.7;%small blips when r=0.6,0.5
sample_per_bit=128;
fc=400;
wc=2*pi*fc;

%%%this has too be a even number for now
num_random_bits=16;%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=1;%bit 1 is represented as 1, bit 0 as -1

%generating a pulse%%%%%%%%%%%%%%%%%%%%%
[h,t]=RootRCRO_Pulse(Kt,Tb,sample_per_bit,r);%RRCRO pulse
%[ h,t ] = rect_pulse(Kt, Tb,sample_per_bit );%Rect pulse


%generating bits%%%%%%%%%%%%%%%%%%%%%%%%
[n,an]=random_bits(num_random_bits,[A -A]);%Polar NRZ




%Even bits to I channel

a_i=an(mod(n,2) == 0);
[ m_i,t_i ] = get_baseband(h,t,a_i,sample_per_bit );



%Odd bits to Q channel
a_q=an(mod(n,2) ~= 0);
[ m_q,t_q ] = get_baseband( h,t,a_q,sample_per_bit );


%modulation
figure(1)
s_i=m_i.*cos(wc*t_i);
s_q=m_q.*sin(wc*t_q);



subplot(2,1,1)
plot(t_i,s_i)
hold on
plot(t_i,m_i,'-r')
hold off
xlabel('time s')
ylabel('channel I')
title('even bits')
subplot(2,1,2)
plot(t_q,s_q)
hold on
plot(t_q,m_q,'-r')
hold off
xlabel('time s')
ylabel('channel Q')
title('odd bits')



