function [ s_t,tt ] = get_baseband( pulse,t,random_bits,sample_per_bit )
%gets a baseband signal based on pulse and random bits
%  get_baseband(kt, pulse,t,bit_period,random_bits,sample_per_bit )

    num_random_bits=length(random_bits);
    pulse_length=length(pulse);
    %shamt=pulse_length-(kt-0.5)*sample_per_bit;    
    size_of_s=(pulse_length+(num_random_bits)*sample_per_bit);
    dt=t(2)-t(1);
    s_t=zeros(1,size_of_s);
    
    tt=linspace(t(1),t(1)+dt*(size_of_s-1),size_of_s);
    s_t(1,1:pulse_length)=s_t(1,1:pulse_length)+pulse*random_bits(1);
    if num_random_bits==1
        return
    end
    %generating signals
    for i=2:num_random_bits
        start=(i-1)*sample_per_bit+1;
        tail=start+pulse_length-1;
       s_t(1,start:tail)=s_t(1,start:tail)+random_bits(i).*pulse ;  
    end
    %plot(tt,s_t,'*')

end

