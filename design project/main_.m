clc;clear;close all;
Kt=20;
R=1000;
Tb=2/R;
r=0.5;%small blips when r=0.6,0.5
sample_per_bit=128;%high fc might need more precision

%%%this has too be a even number for now
num_random_bits=50;%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc=10000;
wc=2*pi*fc;
Ac=1;
iterations=200;
noise_variance = 5;





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


% Figure for report
subplot(3,1,1)
stem(n-1, an)
%axis([-19 26 -2 2]);
title('Random bit sequence');
xlabel('Bit number');
ylabel('an');
subplot(3,1,2)
plot(t_q,m_q)
hold on;
for i=1:length(a_q)
    if a_q(i)<0
        plot((i-1)*Tb,-A,'*r')
    else
        plot((i-1)*Tb,A,'*r')
    end
end
hold off;
%axis([-.04 .05 -2 2]);
title('Q channel, receives odd bits');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,3)
plot(t_i,m_i)
hold on;
for i=1:length(a_i)
    if a_i(i)<0
        plot((i-1)*Tb,-A,'*r')
    else
        plot((i-1)*Tb,A,'*r')
    end
end
hold off
%axis([-.04 .05 -2 2]);
title('I channel, receives even bits');
xlabel('Time (s)');
ylabel('Amplitude');

%modulation without time shift (QPSK) for debugging
figure(2)
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


subplot(3,1,1)
plot(t_i,s_i)
hold on
plot(t_i,m_i,'-r')
hold off
xlabel('Time (s)')
%axis([-.01 .02 -2 2]);
ylabel('Amplitude (V)')
title('I Channel Modulated')
subplot(3,1,2)
plot(t_q,s_q)
hold on
plot(t_q,m_q,'-r')
hold off
xlabel('Time (s)')
ylabel('Amplitude (V)')
%axis([-.01 .02 -2 2]);
title('Q Channel Modulated')
subplot(3,1,3)
plot(t_q,s_trans,'-r')
title('OQPSK I minus Q')
%axis([-.01 .02 -2 2]);

s_trans_n = s_trans + sqrt(noise_variance)*randn(1, length(s_trans));

%demodulating no noise
s_i=s_trans.*cos(wc*t_i)*2/Ac;
s_q=-s_trans.*sin(wc*t_q)*2/Ac;
rt_q=conv(s_q,h,'same')/sample_per_bit;%match filter
rt_i=conv(s_i,h,'same')/sample_per_bit;%match filter
% demodulating with noise
s_i_n=s_trans_n.*cos(wc*t_i)*2/Ac;
s_q_n=-s_trans_n.*sin(wc*t_q)*2/Ac;
rt_q_n=conv(s_q_n,h,'same')/sample_per_bit;%match filter
rt_i_n=conv(s_i_n,h,'same')/sample_per_bit;%match filter

figure(3)
subplot(3,1,1)
plot(t_i, s_trans);
title('TX signal with noise variance = 0');
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(3,1,2)
hold on
plot(t_i,rt_i)
title('I channel after matched filter')
xlabel('Time (s)');
ylabel('Voltage (V)');
for i=1:length(a_i)
    if a_i(i)<0
        plot((i-1)*Tb,-A,'*r')
    else
        plot((i-1)*Tb,A,'*r')
    end
end
hold off


subplot(3,1,3)
title('Q channel after matched filter')
xlabel('Time (s)');
ylabel('Voltage (V)');
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

% figure 5 report
figure(4)
subplot(3,1,1)
plot(t_i, s_trans_n);
title('TX signal with noise variance = 5');
xlabel('Time (s)');
ylabel('Voltage (V)');
subplot(3,1,2)
hold on
plot(t_i,rt_i_n)
title('I channel after matched filter')
xlabel('Time (s)');
ylabel('Voltage (V)');
for i=1:length(a_i)
    if a_i(i)<0
        plot((i-1)*Tb,-A,'*r')
    else
        plot((i-1)*Tb,A,'*r')
    end
end
hold off


subplot(3,1,3)
title('Q channel after matched filter')
xlabel('Time (s)');
ylabel('Voltage (V)');
hold on
plot(t_q,rt_q_n)
for i=1:length(a_q)
    if a_q(i)<0
        plot((i-1)*Tb+Tb/2,-A,'*r')
    else
        plot((i-1)*Tb+Tb/2,A,'*r')
    end
end
hold off


N=length(s_trans);
fs=sample_per_bit*1/Tb;
d_t=1/fs;
T=N*d_t;
f=linspace(-fs/2,fs/2,N);

F=fft(s_trans);
F=fftshift(abs(F));
F=F*d_t;%normalize
PSD=abs(F.^2)./T;
average_PSD=0*PSD;
theory_PSD_L = GenRCRFreq(f + fc, Tb, r);
theory_PSD_R = GenRCRFreq(f - fc, Tb, r);
theory_PSD = theory_PSD_L + theory_PSD_R;
theory_PSD=theory_PSD*Tb*2;

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
    PSD=abs(F.^2)./(T*num_random_bits);
    
    
    average_PSD=(average_PSD+PSD);
    
end

figure(5)
average_PSD=average_PSD/iterations;
plot(f,average_PSD)
hold on
plot(f,theory_PSD,'r')
xlabel('f (Hz)')
ylabel('PSD')
title('PSD (W) of theoretical vs simulated')

figure(6)
plot(f,10*log10(average_PSD))
hold on
plot(f,10*log10((theory_PSD)), 'r')
xlabel('f (Hz)')
ylabel('PSD(dB)')
title('PSD(dB) of theoretical vs simulated')



disp('calculating BER..')
% Error detection
trials = 10;
% Generate noise parameters, starting from ebN0 first
% guarantees theoretical will always be right.
noise_length = 50;
ebN0 = logspace(-1.5, 1.2, noise_length);
ebN0db = 10*log10(ebN0);

h2=h.*cos(wc.*t)/2;
h3=h.*sin(wc.*t)/2;
h4=(sum((h2).^2)+sum((h3).^2));
Eb = h4 * (Tb/sample_per_bit);

shannon = 10000*log2(1+ebN0);
figure(8);
plot(ebN0db,shannon)
title('Shannon Capacity for SNR values');
xlabel('SNR (dB)');
ylabel('bits/sec');
noise_variance =  fs .* Eb ./ebN0 ;
p_e = 0;
for p = 1:noise_length
    for m = 1:trials
        
        [n, an]=random_bits(num_random_bits,[-A A]);
        %Even bits to I channel
        
        a_i=an(mod(n,2) == 0);
        [ m_i,t_i ] = get_baseband(h,t,a_i,sample_per_bit );
        
        
        
        %Odd bits to Q channel
        a_q=an(mod(n,2) ~= 0);
        [ m_q,t_q ] = get_baseband( h,t,a_q,sample_per_bit );
        
        
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
        
        s_i=m_i.*Ac.*cos(wc*t_i);
        s_q=m_q.*Ac.*sin(wc*t_q);
        s_trans=s_i-s_q;
        noise_s_trans = s_trans + sqrt(noise_variance(p))*randn(1,length(s_trans)); %apply noise
        
        
        s_i=noise_s_trans.*cos(wc*t_i)*2/Ac;
        s_q=-noise_s_trans.*sin(wc*t_q)*2/Ac;
        rt_q=conv(s_q,h,'same')/sample_per_bit;%match filter
        rt_i=conv(s_i,h,'same')/sample_per_bit;%match filter
        
        
        errors(m) = 0;
        
%         figure(10)
%          hold off
%         subplot(2,1,1)
%         plot(t_i,rt_i)
%         hold on
%         subplot(2,1,2)
%         hold off
%         plot(t_q,rt_q)
%          hold on
  
        % Count errors
        for i = 1:num_random_bits
            if mod(i,2) == 1
                %subplot(2,1,2)
                if rt_q(Kt*sample_per_bit + shamt + sample_per_bit/2*(i-1)) > 0 && an(i) == -1
                    %plot(t_q(Kt*sample_per_bit + shamt + sample_per_bit/2*(i-1)),1,'r*')
                    errors(m) = errors(m) + 1;
                elseif rt_q(Kt*sample_per_bit + shamt + sample_per_bit/2*(i-1)) <= 0 && an(i) == 1
                    errors(m) = errors(m) + 1;
                    %plot(t_q(Kt*sample_per_bit + shamt + sample_per_bit/2*(i-1)),-1,'r*')
                else
                   % plot(t_q(Kt*sample_per_bit + shamt + sample_per_bit/2*(i-1)),an(i),'g*')
                    
                end
                
            else
                %subplot(2,1,1)
                if rt_i(Kt*sample_per_bit + sample_per_bit/2*(i-2)) > 0 && an(i) == -1
                   % plot(t_i(Kt*sample_per_bit  + sample_per_bit/2*(i-2)),1,'r*')
                    errors(m) = errors(m) + 1;
                elseif rt_i(Kt*sample_per_bit + sample_per_bit/2*(i-2)) <= 0 && an(i) == 1
                    errors(m) = errors(m) + 1;
                    %plot(t_i(Kt*sample_per_bit  + sample_per_bit/2*(i-2)),-1,'r*')
                    
                else
                    %plot(t_i(Kt*sample_per_bit  + sample_per_bit/2*(i-2)),an(i),'g*')
                end
               
            end
        end
        
    end
    % Matrix containing average of different noise levels
    p_e(p) = sum(errors) / (num_random_bits*trials);
    disp('.')

end

% Plots
figure(7);
% Q(sqrt(Eb/N0)) is theoretical
semilogy(ebN0db, qfunc(sqrt(2*ebN0)));
hold on;
% Generate results
semilogy(ebN0db, p_e, 'r--')
legend('Theoretical', 'Simulated');
title('Theoretical vs Simulated BER');
xlabel('Eb/N0 (dB)');
ylabel('P(e)');
disp('done')