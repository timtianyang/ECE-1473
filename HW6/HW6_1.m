clc
clear
close all
Kt=5;
Tb=1/200;

sample_per_bit=1024;

figure(1)
hold on
Legend=cell(10,1);
N=1;
for r=0.1:0.1:1
    [h,t]=RootRCRO_Pulse( Kt,Tb,sample_per_bit,r );
    plot(t,h)   
    Legend{N}=strcat('r= ', num2str(r))';
    N=N+1;
end
hold off
legend(Legend)
xlabel('time')
ylabel('pulse value')