function [ p_whole ] = half2whole( p )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
[n, m] = size(p);
p_whole = zeros(n,m*2-1);
p_whole(1:n,1:m) = p;
intervals_xy = zeros(2,m-1);
for j = m:-1:2
    intervals_xy(:,m-j+1) = p(2:3,j) - p(2:3,j-1);
end
index_p = m;
x = m;
for i = m+1:2*m-1
    if index_p-1 == 0
        break;
    end
    p_whole(:,i) = [i-1; p_whole(2,x)+intervals_xy(1,i-m); p(3,index_p-1)];
    index_p = index_p -1;
    x = x+1;
end
end

