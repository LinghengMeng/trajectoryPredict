function [ data ] = denormalization( data, mu, sigma)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

data = data .* repmat(sigma,1,size(data,2)) + repmat(mu,1,size(data,2));


end

