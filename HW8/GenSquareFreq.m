function [ frequency_resp ] = GenSquareFreq( f, Tb)
    frequency_resp=Tb*sinc(f*Tb);


end

