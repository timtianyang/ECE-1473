function [n,an]=random_bits(num_bits,values)
%num_bits to be generated
%values(1) is assigned to 1 and values(2) is assigned to 0
    n=1:num_bits;
    an=0*n;
    for i=n
        temp=rand();
        if temp>=0.5
           an(i)=values(1); 
        else
           an(i)=values(2); 
            
        end
    end
    

end