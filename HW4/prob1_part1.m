clc
clear

for r=0:0.1:1
[h, t]=RCRO_Pulse(5,1,16,r);
plot(t,h);
hold on
end
xlabel('t seconds');
ylabel('value');
title('Raised Cosine Rolloff pulse');
