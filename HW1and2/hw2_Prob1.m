%HW2 1473 part1
clear
clc
N=40;
t=linspace(-10,10,100000);
w=500*pi;
%Cn=2.*j.*exp(-pi./2.*j.*n)./(n.*pi);
%Cn=real(Cn);
f = 0*t;
figure(1)
Cn=zeros(1,2*N+1);

for k=-N:1:N
 
    if(k==0)                % skip the zeroth term
        continue;
    end;
    C_k = 2*1i*exp(-pi/2*1i*k)/(k*pi)*(sin(0.5*pi*k)^2);    % computes the k-th Fourier coefficient of the exponential form
    %C_k=250/(-1i*k*w)*(2*exp(-j*k*pi/2)-exp(j*k*pi/2)-exp(-j*k*3*pi/2));
    f_k = C_k*exp(w*1i*k*t);                 % k-th term of the series
    Cn(k+N+1)=C_k;
    f = f + f_k;                                % adds the k-th term to f
    
end
f = f + Cn(N+1);
%stem(-N:1:N,real(Cn))

plot(t,f)
axis([-1,1,-1.5,1.5])
figure(2)
stem(-N:1:N,Cn,'.');
xlabel('k')
ylabel('C_k')
title('Fourier Series Coefficients')
%hold on

%Xn=Cn(22)*exp(j.*(22)*w.*t); 
   



%plot(t,Xn)
