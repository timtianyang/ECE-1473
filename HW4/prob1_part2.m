clear
clc
close all
num_random_bits=20;
bit_period=1;
sample_per_bit=16;
Kt=5;
r=0.6;
figure(1)
[n, an]=random_bits(num_random_bits,[1 -1]);
subplot(2,1,1)
stem(n,an,'r*')
title('random bits')
xlabel('number')
ylabel('bits')
figure(2)
[h,t]=RCRO_Pulse(Kt,bit_period,sample_per_bit,r);
plot(t,h,'*')
%axis([-5 5 -0.5 1.8])
xlabel('time seconds')
ylabel('signal')
title('h(t) using RCRO r=0.6')
size_of_s=(length(t)+(num_random_bits-1)*sample_per_bit);
s_t=zeros(1,size_of_s);
tt=linspace(t(1),t(length(t))+(num_random_bits-1)*bit_period,size_of_s);

figure(1)

for i=1:num_random_bits
   shamt=(i-1)*sample_per_bit+1;
   s_t(1,shamt:(length(t)+shamt-1))=s_t(1,shamt:(length(t)+shamt-1))+an(i).*h ;  
end
subplot(2,1,2)
plot(tt,s_t)
xlabel('time seconds')
ylabel('signal')
title('s(t) using RCRO pulse r=0.6')
hold on
for l=0:bit_period:tt(length(tt))-bit_period*Kt  
   plot(l,interp1(tt,s_t,l),'r*'); 
    
end
hold off