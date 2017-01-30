% creatTrainingData
Data = csvread('projectiles.csv');
Data = Data';
[start_time_point start_point]= find(Data(1,:) == 0);
%compute angle and velocity
[ Data ] = angle_Velocity( Data, start_point);
Data(1,:) = [];

[data_norm mu_norm sigma_norm] = featureNormalize(Data);
% [data_norm setting] =mapminmax(Data);
% re_data = re_mapminmax( data_norm, setting );
% [data DC pstd] = normalizeDataMethod2(Data);
re = denormalization( data_norm, mu_norm, sigma_norm);

num_train = 1;

input_Data = zeros(size(data_norm,1)*2,size(data_norm,2));
target_Data = zeros(size(data_norm,1),size(data_norm,2));

for index_traj = 1:size(start_point,2)
    if index_traj ~= size(start_point,2)
        for i = start_point(index_traj):start_point(index_traj+1)-3
            input_Data(:,num_train) = [data_norm(:,i); data_norm(:,i+1)];
            target_Data(:,num_train) = data_norm(:,i+2);
            num_train = num_train +1;
        end
    else
        for i = start_point(index_traj):size(data_norm,2)-3
            input_Data(:,num_train) = [data_norm(:,i); data_norm(:,i+1)];
            target_Data(:,num_train) = data_norm(:,i+2);
            num_train = num_train +1;
        end
    end
end

num = size(input_Data,2);
P = randperm(num);
train_num = round(num * 0.9);
test_num = round(num - train_num);

train_input = input_Data(:, P(1:train_num));
train_target = target_Data(:, P(1:train_num));

test_input = input_Data(:, P(train_num+1:num));
test_target = target_Data(:, P(train_num+1:num));
test_trajectories = Data(:, P(train_num+1:num));

% % [train_input_norm mu_train_input_norm sigma_train_input_norm] = featureNormalize(train_input);
% % [train_target_norm mu_train_target_norm sigma_train_target_norm] = featureNormalize(train_target);

% % test_input_norm = (test_input - repmat(mu_train_input_norm,[1, size(test_input,2)])) ./ repmat(sigma_train_input_norm, [1, size(test_input,2)]);
% % test_target_norm = (test_target - repmat(mu_train_target_norm,[1, size(test_target,2)])) ./ repmat(sigma_train_target_norm, [1, size(test_target,2)]);