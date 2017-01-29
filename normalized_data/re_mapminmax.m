function [ data ] = re_mapminmax( data_norm, setting )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
data = data_norm .* repmat(setting.xrange,1,size(data_norm,2)) + repmat(setting.xmin,1,size(data_norm,2));

end

