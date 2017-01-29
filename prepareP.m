function [ p_input ] = prepareP( p1, p2, mu_norm, sigma_norm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p = [p1, p2];
start_point = [1];
%compute angle and velocity
[ angle velocity ] = computeAngleVelocity( p1, p2);
p1_AV = [p1;angle;velocity];
p2_AV = [p2;angle;velocity];
p1_AV(1,:) = []; 
p2_AV(1,:) = []; 
p1_AV_norm = (p1_AV - repmat(mu_norm,[1, size(p1_AV,2)])) ./ repmat(sigma_norm, [1, size(p1_AV,2)]);
p2_AV_norm = (p2_AV - repmat(mu_norm,[1, size(p2_AV,2)])) ./ repmat(sigma_norm, [1, size(p2_AV,2)]);
p_input = [p1_AV_norm; p2_AV_norm];

end

