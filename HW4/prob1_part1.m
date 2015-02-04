clc
clear

%for r=0:0.1:0.5
for r=0.5
[h, t]=RCRO_Pulse(5,0.3,16,r);
stem(t,h);
hold on
end
xlabel('t seconds');
ylabel('value');
title('Raised Cosine Rolloff pulse');
