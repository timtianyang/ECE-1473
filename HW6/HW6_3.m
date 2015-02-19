clc
clear
close all
tou=1.5
n=3:1:11;
E=1./(tou.*factorial(n-1).*tou.^(n-1)).*factorial(n-1)./(tou).^n;
plot(E,n)
xlabel('n')
ylabel('E')
title('Pulse Energy vs. n when tou=1.5')