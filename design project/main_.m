clc;clear;close all;
Kt=2;
R=100;
Tb=1/R;
r=0.6;%small blips when r=0.6,0.5
sample_per_bit=128;
fc=300;
wc=2*pi*fc;

%%%this has too be a even number for now
num_random_bits=6;%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=1;%bit 1 is represented as 1, bit 0 as -1

%generating a pulse%%%%%%%%%%%%%%%%%%%%%
[h,t]=RootRCRO_Pulse(Kt,Tb,sample_per_bit,r);%RRCRO pulse
%[ h,t ] = rect_pulse(Kt, Tb,sample_per_bit );%Rect pulse
%[h,t]=root_rcro( Kt,Tb, sample_per_bit, r);%kevins RRCRO has blips as
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
s_i=m_i.*cos(wc*t_i);
s_q=m_q.*sin(wc*t_q);
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
title('I minus Q')

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
title('OQPSK I minus Q without clipping')

figure(3)
%clipping off the first and the last Tb/2: http://en.wikipedia.org/wiki/Phase-shift_keying
m_i(t_i<=0)=0;
s_i(t_i<=0)=0;
m_q(t_q>=(num_random_bits/2-0.5)*Tb)=0;
s_q(t_q>=(num_random_bits/2-0.5)*Tb)=0;
s_trans=s_i-s_q;
subplot(3,1,1)
plot(t_i,s_i)
hold on
plot(t_i,m_i,'-r')
hold off
xlabel('time s')
ylabel('channel I')
title('even bits')
subplot(3,1,2)
plot(t_q,s_q)
hold on
plot(t_q,m_q,'-r')
hold off
xlabel('time s')
ylabel('channel Q')
title('odd bits')
subplot(3,1,3)
plot(t_q,s_trans,'-r')
title('OQPSK I minus Q with clipping')

%demodulating
s_i=s_trans.*cos(wc*t_i)*2;
s_q=-s_trans.*sin(wc*t_q)*2;
rt_q=conv(s_q,h,'same')/sample_per_bit;%match filter
rt_i=conv(s_i,h,'same')/sample_per_bit;%match filter
figure(4)
subplot(2,1,1)
hold on
plot(t_i,rt_i)
title('i channel')
for i=1:length(a_i)
   if a_i(i)<0
       plot((i-1)*Tb,-A,'*r') 
   else
       plot((i-1)*Tb,A,'*r') 
   end
end
hold off


subplot(2,1,2)
title('q channel')
hold on
plot(t_q,rt_q)
for i=1:length(a_q)
   if a_q(i)<0
       plot((i-1)*Tb,-A,'*r') 
   else
       plot((i-1)*Tb,A,'*r') 
   end
end
hold off
