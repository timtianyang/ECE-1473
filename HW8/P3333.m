%%%%%3/24 Meeting with Jacobs:
%%%%%PSD=A/Tb*|F(f)|*sum(auto_corr) should use the correct A, which is in
%%%%%the an array.
%%%%%value at sample time for a signal
%%%%%|F(f)| is the pulse, it doesn't need to be normalized because Tb in
%%%%%the PSD formular takes care of it
%%%%%the Eb calculation should multiply the pulse with the carrier. Dont
%%%%%know why it has to be devided by two.

clear
clc
close all
num_random_bits=200;
R=5000;%bps might cause aliasing
bit_period=1/R;
sample_per_bit=128;
Kt=5;
r=0.6;
%%%%carrier
fc=10000;
wc=2*pi*fc;
Ac=1;
%%%%for DFT
Tb=bit_period;
N=num_random_bits * sample_per_bit; %number of FFT must be big enough to have more fine details
N2 = N + 2*Kt*sample_per_bit;
fs=sample_per_bit*R;  %%%%%%%%%%it looks like sampling speed foe FFT must match the original signal to avoid aliasing
d_t=1/fs;
T=N*d_t;
iterations=50;

% %%%%generating a pulse
[h,t]=RootRCRO_Pulse(Kt,bit_period,sample_per_bit,r);
figure(11)
plot(t,h)
%[h,t]=GenRRCR(Kt,bit_period,sample_per_bit,r);
%[h, t] = rect_pulse(bit_period, sample_per_bit);
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%modulation and detection
%%one realization
%%%%generating bits
A=1;
[n, an]=random_bits(num_random_bits,[A 0]);
figure(5)
subplot(2,1,1)
stem(n,an,'r*')
title('random bits')
xlabel('number')
ylabel('bits')



%%%%generating baseband signal
[s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );
subplot(2,1,2)
plot(tt,s_t)


%%%%generating passband signal
carrier=Ac*cos(wc.*tt);
modulated=carrier.*s_t;
hold on

plot(tt,modulated)
title(strcat('s(t) using RCRO pulse r= ',sprintf('%0.3f',r)));
xlabel('t (sec)')
ylabel('OOK signal')

%plotting stars
for i=0:num_random_bits-1
    if an(i+1)>0
        plot(bit_period*i,1,'g*');
    else
        plot(bit_period*i,0,'g*');
    end
   
end
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%using a product detector
figure(6)
modulated=2*carrier.*modulated;%%compensate the 1/2 from cosine
rt=conv(modulated,h,'same');%%normalize to one so A=1 and use matched filter
plot(tt,rt)

hold on
%plotting stars as sampling time
peak=sample_per_bit;%%for RRCRO, the value is always sample_per_bit
for l=0:1:length(an)-1
   plot(l*bit_period,peak*an(l+1),'g*'); 
end
hold off
title('after using a matched filter, the signal has zero ISI')
xlabel('time')
ylabel('signal')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PSD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plotting
f=linspace(-fs/2,fs/2,N2);

theory_PSD_L = 1/16 * Tb*GenRCRFreq(f + fc, Tb, r);

theory_PSD_R = 1/16 * Tb*GenRCRFreq(f - fc, Tb, r);

theory_PSD = theory_PSD_L + theory_PSD_R;
figure(3)%%plotting the PSD from equation




averagedPSD=0*theory_PSD;

%input('press anything to simulate PSD>>>')
for i=1:iterations
    %%%%generating bits
    [n, an]=random_bits(num_random_bits,[1 0]);

    %%%%generating baseband signal
    [s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );%removing the beginning and the end (DC)

    %%%%comparing with carrier
    carrier=Ac*cos(wc.*tt);
    modulated=carrier.*s_t;

    F=fft(modulated);
    F=fftshift(abs(F));
    F=F*d_t;%normalize
    PSD=abs(F.^2)./T;
   
    averagedPSD=averagedPSD+PSD;

end
%%plotting the PSD from equation
figure(3)
plot(f,(abs(theory_PSD)),'r')
hold on
plot(f,(abs(averagedPSD)/i))
hold off




figure(4)
plot(f,10*log10(abs(theory_PSD)),'r')
hold on
plot(f,10*log10(abs(averagedPSD)/i))
hold off

xlabel('freq (Hz)')
ylabel('|S_t| in dB')
title('simulated PSD vs. theory')

disp('calculating BER..')
% Error detection
trials = 10;
% Generate noise parameters, starting from ebN0 first
% guarantees theoretical will always be right.
noise_length = 50;
ebN0 = logspace(-1, 1.2, noise_length);
ebN0db = 10*log10(ebN0);

h2=h.*cos(wc.*t)/2;%

Eb = sum((h2).^2) * (bit_period/sample_per_bit);

noise_variance = fs .* Eb ./ebN0 ;
p_e = 0;
for p = 1:noise_length
    for m = 1:trials
        
        [n, an]=random_bits(num_random_bits,[1 0]);
        [s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );
        carrier=Ac*cos(wc.*tt);
        modulated=carrier.*s_t + sqrt(noise_variance(p))*randn(1,length(s_t)); %apply noise
        modulated=2*carrier.*modulated;%%compensate the 1/2 from cosine
        rt=conv(modulated,h,'same')/ sample_per_bit;%%matched filter
        
     

        

        
        errors(m) = 0;
        % Count errors
        for i = 1:num_random_bits
           if rt(Kt*sample_per_bit + sample_per_bit*(i-1)+1) > .5 && an(i) == 0
               %plot((i-1)*bit_period,1,'r*')
               errors(m) = errors(m) + 1;
           elseif rt(Kt*sample_per_bit + sample_per_bit*(i-1)+1) <= .5 && an(i) == 1
               errors(m) = errors(m) + 1;
               %plot((i-1)*bit_period,0,'r*')
           %else
               %plot((i-1)*bit_period,2,'g*')
           end
        end
       

    end
    % Matrix containing average of different noise levels
    p_e(p) = sum(errors) / (num_random_bits*trials);
    disp('.')

end

% Plots
figure(10);
% Q(sqrt(Eb/N0)) is theoretical
semilogy(ebN0db, qfunc(sqrt(ebN0)));
hold on;
% Generate results
semilogy(ebN0db, p_e, 'r-')
legend('Theoretical', 'Simulated');
xlabel('Eb/N0 (dB)');
ylabel('P(e)');
disp('done')