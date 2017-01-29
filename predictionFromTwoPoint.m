function [ predict, re ] = predictionFromTwoPoint( p1, p2, mu_norm, sigma_norm, net )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
[ p_input ] = prepareP( p1, p2, mu_norm, sigma_norm);
p_predict = sim( net, p_input );

re = denormalization( p_predict, mu_norm, sigma_norm);

predict = [ p2(1)+1 ;re(1:2)];

end

