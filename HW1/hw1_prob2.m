clc
clear
s1=[1,1,1,1,1];
s0=[-1,-1,-1,-1,-1];
x=[s1,s0,s0,s1,s1,s0,s0,s1];
t=0:0.2:7.8;

n=-20:19;
X_fft=fft(x)*0.2*10^-3;
X_fft=fftshift(X_fft);
plot(t,x);
title('part a')
xlabel('t ms')
ylabel('signal')
pause
subplot(2,1,1)
stem(n,real(X_fft),'r.')
title('real part of the FFT')
subplot(2,1,2)
stem(n,imag(X_fft),'b.')
title('imaginary part of the FFT')

pause
%part c
N=length(x);
n=-N/2:(N-1)/2;
x=0.5*(x+x(mod(-n,N)+1));
X_fft=fft(x)*0.2*10^-3;
X_fft=fftshift(X_fft);
subplot(2,1,1)
stem(n,real(X_fft),'r.')
title('real part of the FFT')
subplot(2,1,2)
stem(n,imag(X_fft),'b.')
title('imaginary part of the FFT')
pause

%part d
x=[x,x];x=[x,x];x=[x,x];x=[x,x];%640 bits
t=0:0.2:127.8;
figure(2)
plot(t,x);
title('part a with longer duration')
xlabel('t ms')
ylabel('signal')
pause
N=length(x);
n=-N/2:(N-1)/2;
x=0.5*(x+x(mod(-n,N)+1));
X_fft=fft(x)*0.2*10^-3;
X_fft=fftshift(X_fft);
subplot(2,1,1)
stem(n,real(X_fft),'r.')
title('real part of the FFT')
subplot(2,1,2)
stem(n,imag(X_fft),'b.')
title('imaginary part of the FFT')

%part e
s1=[s1,s1,s1,s1,s1];s1=[s1,s1];
s0=[s0,s0,s0,s0,s0];s0=[s0,s0];
x=[s1,s0,s0,s1,s1,s0,s0,s1];
t=0:0.02:7.98;
figure(3)
plot(t,x);
title('part a with higer sampling rate')
xlabel('t ms')
ylabel('signal')
pause
N=length(x);
n=-N/2:(N-1)/2;
x=0.5*(x+x(mod(-n,N)+1));
X_fft=fft(x)*0.02*10^-3;
X_fft=fftshift(X_fft);
subplot(2,1,1)
stem(n,real(X_fft),'r.')
title('real part of the FFT')
subplot(2,1,2)
stem(n,imag(X_fft),'b.')
title('imaginary part of the FFT')
