clear
clc
num_random_bits=100;
bit_period=1;
sample_per_bit=16;
[n,an]=random_bits(num_random_bits,[-1,1]);%produce 100 bits, and assign the value an = -1 for a binary and an = +1 for a binary 1.
stem(n,an);
xlabel('time seconds')
ylabel('signal')
title('random bits')
%get relative freq of each data value
freq_one=sum(an==1);
freq_negative_one=sum(an==-1);



%%using rect
figure(2)
[t,h]=rect_pulse(bit_period,sample_per_bit);
stem(t,h,'*')
axis([-5 5 -0.5 1.2])
xlabel('time seconds')
ylabel('signal')
title('h(t)')
size_of_s=length(t)+(num_random_bits-1)*bit_period*sample_per_bit;
s_t=zeros(1,size_of_s);
tt=linspace(t(1),t(length(t))+(num_random_bits-1)*bit_period,size_of_s);

figure(3)

for i=1:num_random_bits
   shamt=(i-1)*sample_per_bit+1;
   s_t(1,shamt:(length(t)+shamt-1))=s_t(1,shamt:(length(t)+shamt-1))+an(i).*h ;  
end
plot(tt,s_t)
xlabel('time seconds')
ylabel('signal')
title('s(t) using rectangular pulse')
axis([-5 tt(length(tt)) -1.7 1.7])

figure(4)
[t,h]=sinc_pulse(bit_period,sample_per_bit);
stem(t,h,'*')
axis([-5 5 -0.5 1.2])
xlabel('time seconds')
ylabel('signal')
title('h(t)')
size_of_s=length(t)+(num_random_bits-1)*bit_period*sample_per_bit;
s_t=zeros(1,size_of_s);
tt=linspace(t(1),t(length(t))+(num_random_bits-1)*bit_period,size_of_s);
%%using sinc
figure(5)

for i=1:num_random_bits
   shamt=(i-1)*sample_per_bit+1;
   s_t(1,shamt:(length(t)+shamt-1))=s_t(1,shamt:(length(t)+shamt-1))+an(i).*h ;  
end
plot(tt,s_t)
xlabel('time seconds')
ylabel('signal')
title('s(t) using sinc pulse')
axis([-5 tt(length(tt)) -1.7 1.7])