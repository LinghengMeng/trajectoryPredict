function [ angle velocity ] = computeAngleVelocity( p1, p2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
initial = p2 - p1;
angle = initial(2,:) ./ initial(3,:);
velocity = initial(2:3,:);
% sections_all = ;

end

