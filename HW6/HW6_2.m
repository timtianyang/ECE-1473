clear
clc
close all
num_random_bits=20;
bit_period=1.000000000000000e-03;
sample_per_bit=64;
Kt=5;
r=0.25;
figure(1)



%%%%generating bits
[n, an]=random_bits(num_random_bits,[1 -1]);
an=[ -1 1 -1  -1   1 -1  -1  -1  -1  1 -1   1  -1  1   1   1  -1  1  -1 -1];
subplot(2,1,1)
stem(n,an,'r*')
title('random bits')
xlabel('number')
ylabel('bits')
figure(2)



%%%%generating a pulse
[h,t]=RootRCRO_Pulse(Kt,bit_period,sample_per_bit,r);
plot(t,h,'*')
xlabel('time seconds')
ylabel('signal')
title('h(t) using RCRO r=0.6')


%%%%generating baseband signal
figure(1)
[s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );
subplot(2,1,2)
plot(tt,s_t)
xlabel('time seconds')
ylabel('signal')
title('s(t) using RCRO pulse r=0.6')



%%%%drawing dots for sample time
hold on
for l=0:bit_period:tt(length(tt))-bit_period*Kt  
   plot(l,interp1(tt,s_t,l),'r*');     
end
hold off



%%passign through a filter
figure(4)
%tt=linspace(tt(1),(length(tt)+length(h)-1)*(tt(2)-tt(1)),length(tt)+length(h)-1);
rt=conv(s_t,h,'same');
%tt=tt+(tt(2)-tt(1));
title('filtered signal without noise and zero ISI')
xlabel('time')
ylabel('receiver output')
plot(tt,rt)

hold on 

for l=0:bit_period:(num_random_bits-1)*bit_period
   plot(l,interp1(tt,rt,l),'r*');   
end
hold off

return;
%add noise
figure(5)

for noise_std=1:40
    sn=0*s_t;
    for l=1:length(s_t)
        sn(l)=s_t(l)+randn(1)*noise_std;
    end
    
    
    rt=conv(sn,h,'same');
    plot(tt,rt)
    hold on 
    for l=0:bit_period:(num_random_bits-1)*bit_period
       plot(l,interp1(tt,rt,l),'r*');   
    end
    plot(tt,0.*tt)
    hold off
    title(strcat('filtered signal with noise std=',sprintf('%0.5f',noise_std)))
    xlabel('time')
    ylabel('receiver output')
    annotation('textbox', [0.25,0.8,0.1,0.1],...
           'String', num2str(an));
    pause
end