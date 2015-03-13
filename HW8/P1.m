clc
clear
close all

x=linspace(0,10,100);
y=x;
z=ones(1,length(x));


figure(1)

for i=0:0.1:10
    z=i*ones(1,length(x));
    plot3(x(z<x),y(z<x),z(z<x))
    hold on
    
end

z=x;
for i=0:0.1:10
    y=i*ones(1,length(x));
    plot3(x(x>y),y(x>y),z(x>y))
    hold on
    
end

y=z;
for i=0:0.1:10
    x=i*ones(1,length(x));
    plot3(x(y>x),y(y>x),z(y>x))
    hold on
    
end



hold off
xlabel('x')
ylabel('y')
zlabel('z')
grid on
title('Signal Constellation')

figure(2)
x=linspace(-3,3,1000);
y=0*ones(1,length(x));

for i=-3:0.1:3
    z=i*ones(1,length(x));  
    plot3(x,y,z)
    hold on
    
end

x=linspace(-3,3,1000);
z=0*ones(1,length(x));

for i=-3:0.1:3
    y=i*ones(1,length(x));  
    plot3(x,y,z)
    hold on
    
end

y=linspace(-3,3,1000);
x=0*ones(1,length(x));

for i=-3:0.1:3
    z=i*ones(1,length(x));  
    plot3(x,y,z)
    hold on
    
end
hold off
xlabel('x')
ylabel('y')
zlabel('z')
grid on
title('Signal Constellation')