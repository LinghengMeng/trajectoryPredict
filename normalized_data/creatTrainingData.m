% function [ trainingData ] = creatTrainingData( data )
% %UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here
% training_input_Data: 4 x data_num
% training_output_Data: 2 x data_num
Data = csvread('projectiles.csv');
Data = Data';

[data_norm mu_norm sigma_norm] = featureNormalize(Data(2:3,:));
re = denormalization( data_norm, mu_norm, sigma_norm);

num_train = 1;
[start_time_point start_point]= find(data_norm(1,:) == 0);
for index_traj = 1:size(start_point,2)
%     start_point(index_traj)
    if index_traj ~= size(start_point,2)
        for i = start_point(index_traj):start_point(index_traj+1)-3
            input_Data(:,num_train) = [data_norm(2:3,i); data_norm(2:3,i+1)];
            target_Data(:,num_train) = data_norm(2:3,i+2);
            num_train = num_train +1;
        end
    else
        for i = start_point(index_traj):size(data_norm,2)-3
            input_Data(:,num_train) = [data_norm(2:3,i); data_norm(2:3,i+1)];
            target_Data(:,num_train) = data_norm(2:3,i+2);
            num_train = num_train +1;
        end
    end
end

%  LIA = ismember(training_input_Data,training_input_Data,'rows')

% end

