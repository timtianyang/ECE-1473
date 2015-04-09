function theoretical = RCROfreq_kevin( Tb,r,amplitudePulse ,amplitudeCarrier,freqRange,fc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
theoretical = zeros(1,length(freqRange));
f0 = 1/(2*Tb);
fd = r*f0;
f1 = f0 - fd;
B = fd +f0;
theoretical(abs(freqRange - fc) < f1) = 1/16 * Tb * amplitudePulse * amplitudeCarrier;
theoretical((abs(freqRange - fc) > f1) & ...
            (abs(freqRange - fc) < B)) = 1/16 * Tb * 1/2 * (1+cos( ...
                                            pi/(2*fd)*(abs(freqRange((abs(freqRange - fc) > f1) & ...
                                            (abs(freqRange - fc) < B))- fc) - f1)));
end

