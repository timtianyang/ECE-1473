clear
clc
num_bits=30;

[n,an]=random_bits(num_bits,[-1,1]);%produce 100 bits, and assign the value an = ?1 for a binary and an = +1 for a binary 1.
stem(n,an);
%get relative freq of each data value
freq_one=sum(an==1);
freq_negative_one=sum(an==-1);

figure(2)
[t,h]=rect_pulse(1,60);
stem(t,h)
s_t=0*h;

for i=1:num_bits
   s_t=s_t+an(i)*h() 
end