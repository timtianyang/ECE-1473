function [ s_t,tt ] = get_baseband( pulse,t,bit_period,random_bits,sample_per_bit )
%gets a baseband signal based on pulse and random bits
%  get_baseband( pulse,t,bit_period,random_bits,sample_per_bit )

    num_random_bits=length(random_bits);
    size_of_s=(length(t)+(num_random_bits)*sample_per_bit);
    s_t=zeros(1,size_of_s);
    tt=linspace(t(1),t(length(t))+(num_random_bits)*bit_period,size_of_s);
 
    %generating signals
    for i=1:num_random_bits
       shamt=(i-1)*sample_per_bit+1;
       s_t(1,shamt:(length(t)+shamt-1))=s_t(1,shamt:(length(t)+shamt-1))+random_bits(i).*pulse ;  
    end

end

