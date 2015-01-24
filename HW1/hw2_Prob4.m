clear
clc
x=linspace(-10,10,1000);
y=2*(4*x+2).^2./(1./16./pi^2+x.^2)./(6*x+2).^2;
plot(x,y)