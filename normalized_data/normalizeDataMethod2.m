function [data, DC, pstd] = normalizeDataMethod2(data)

% Squash data to [0.1, 0.9] since we use sigmoid as the activation
% function in the output layer

% Remove DC (mean of images). 
DC = mean(data,2);
data = data - repmat(DC,1,size(data,2));

% Truncate to +/-3 standard deviations and scale to -1 to 1
pstd = 3 * std(data, 0, 2);
data = data ./ repmat(pstd,1,size(data,2));
% data = max(min(data, pstd), -pstd) / pstd;

% % Rescale from [-1,1] to [0.1,0.9]
% data = (data + 1) * 0.4 + 0.1;

end

