function [ output ] = DSBSC( f,s,fc )
    [~,I]=min(abs(f(f>0)-fc));
   
    output=circshift(s,[0,length(f)-I])./2;
    output=output+circshift(s,[0,-length(f)+I])./2;
end

