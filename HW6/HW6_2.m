clear
clc
close all
num_random_bits=20;
bit_period=1/200;
sample_per_bit=16;
Kt=5;
r=0.25;
figure(1)



%%%%generating bits
[n, an]=random_bits(num_random_bits,[1 -1]);
an=[ -1 1 -1 1 1 -1 1 1 -1 -1 1 -1 1 1 1 1 -1 1 1 -1];
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
title(strcat('s(t) using RCRO pulse r= ',sprintf('%0.3f',r)));


%%%%drawing dots for sample time
hold on
peak=h(t==0);
for l=0:1:length(an)-1
   %plot(l,interp1(tt,s_t,l),'r*');  
   plot(l*bit_period,peak*an(l+1),'r*'); 
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

%%%%drawing dots for sample time
hold on
peak=sample_per_bit;%it has to be
for l=0:1:length(an)-1
   %plot(l,interp1(tt,s_t,l),'r*');  
   plot(l*bit_period,peak*an(l+1),'r*'); 
end
hold off
xlabel('t (sec)')
ylabel('r(t)')
title('Output using a matched filter')



%add noise
figure(3)
plot(tt,s_t)
noise_std=4;
hold on
xlabel('time seconds')
ylabel('signal')
title(strcat('s(t) using RCRO pulse with r= ',sprintf('%0.3f',r),' var= ',sprintf('%0.3f',noise_std)));
noise_st=0*s_t;
for l=1:length(s_t)
        noise_st(l)=s_t(l)+randn(1)*noise_std;
end
plot(tt,noise_st)

hold off



figure(5)

for noise_std=1:25
    sn=0*s_t;
    for l=1:length(s_t)
        noise_st(l)=s_t(l)+randn(1)*noise_std;
    end
    
    
    rt=conv(noise_st,h,'same');
    plot(tt,rt)
    hold on 
    index=1;
    for l=0:bit_period:(num_random_bits-1)*bit_period
        sample=interp1(tt,rt,l);
        if (sample*an(index)>0)
            plot(l,interp1(tt,rt,l),'r*'); 
        else
            plot(l,interp1(tt,rt,l),'g*'); 
        end
         
       index=index+1;
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