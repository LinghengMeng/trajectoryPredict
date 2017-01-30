close all; clc; clear all
addpath .\normalized_data
normalizedData
%%

% findHiddenSize;

% train
if isequal(questdlg('retrain or load the network?', 'retrain / load ?', 'retrain', 'load', 'load'), 'retrain')
    hiddenSize = 10;% 10; 105
    net = newff( train_input,train_target,hiddenSize);
    net = train( net, train_input , train_target) ;
else
    load('trainedNet_10hiddenSize');% directly load trained net
end

Y = sim( net, test_input );
error = test_target - Y;
t = denormalization( Y, mu_norm, sigma_norm);
t_target = denormalization( test_target, mu_norm, sigma_norm);

figure('Name','predict_test'), plot(t(1,:),t(2,:),'r x ', 'MarkerSize',10);title('predicted locations on test dataset');
figure('Name','target_test'), plot(t_target(1,:),t_target(2,:),'r x ', 'MarkerSize',10);title('target locations on test dataset');
%%
%% plot all trajectories
% % Data_original = csvread('projectiles.csv');
% % Data_original = Data_original';
Data_original = Data;
figure('Name','trajectories'), hold on
trajectories = cell(length(start_point),1);
for i = 1:length(start_point)
     if i ==  length(start_point)
       trajectories{i} = Data_original(:,start_point(i):size(Data_original,2));
       plot(Data_original(1,start_point(i):size(Data_original,2)),Data_original(2,start_point(i):size(Data_original,2)),'r x :', 'MarkerSize',10); 
       break;
     end
    trajectories{i} = Data_original(:,start_point(i):start_point(i+1)-1);
    plot(Data_original(1,start_point(i):start_point(i+1)-1),Data_original(2,start_point(i):start_point(i+1)-1),'r x :', 'MarkerSize',10);
end
figure('Name','t1'),plot(trajectories{1}(1,:),trajectories{1}(2,:),'r x :', 'MarkerSize',10);
%% test trajectory 1
predictWholeTrajectory = csvread('projectiles.csv');
predictWholeTrajectory = predictWholeTrajectory';
projectile_all = 1:20; %change this value to test different trajectory
figure('Name','trajectories');

plot_y = 5;
plot_x = ceil(length(projectile_all) / plot_y);
for view_trajectory_index = 1:length(projectile_all)
    projectile_start = start_point(projectile_all(view_trajectory_index));
    if projectile_all(view_trajectory_index) ~= length(start_point)
        projectile_end = start_point(projectile_all(view_trajectory_index)+1)-1;
    else
        projectile_end = size(predictWholeTrajectory,2);
    end
    p1 = predictWholeTrajectory(:,projectile_start);
    p2 = predictWholeTrajectory(:,projectile_start+1);
    p = [p1 p2];
    i = 1;
    % ****************** predict method 1 *******************
    while 1
        [ predict, re  ] = predictionFromTwoPoint( p(:,i), p(:,i+1), mu_norm, sigma_norm, net );
        if sum(predict < 0)>=1 || i > 100 %|| previousNode(2) > predict(2)
            break;
        end
        p(:,i+2) = predict;
        i = i+1;
    end

    % ***************** predict method 2: symmetrically use only the left half ********************
    i = 1;
    previousNode = p2;
    while 1
        [ predict, re  ] = predictionFromTwoPoint( p(:,i), p(:,i+1), mu_norm, sigma_norm, net );
        if sum(predict < 0)>1 || previousNode(3) > predict(3) || previousNode(2) > predict(2)
            p(:,i+1:end) = [];
            break;
        end
        p(:,i+2) = predict;
        previousNode = predict;
        i = i+1;
    end
    [ p_whole ] = half2whole( p );
    % ***************** target trajectory ********************
    target_trajectory = predictWholeTrajectory(:,projectile_start:projectile_end);
    % ***************** draw trajectories ********************
 
    subplot(plot_x, plot_y, view_trajectory_index);
    hold on
    view_trajectory_index
    title(['trajectory ' num2str(projectile_all(view_trajectory_index))]);
    plot(p(2,:),p(3,:),'r ^ :', 'MarkerSize',10)
    plot(p_whole(2,:),p_whole(3,:),'b o -', 'MarkerSize',10)
    plot(trajectories{projectile_all(view_trajectory_index)}(1,:),trajectories{projectile_all(view_trajectory_index)}(2,:),'g * -.', 'MarkerSize',10)
    hold off
end
legend('predicted trajectory method 1','predicted trajectory method 2','target trajectory')
%% predict the whole trajectory
p1 = [0;0;0;];
p2 = [1;0.707106781187;0.658106781187];
p = [p1 p2];
i = 1;
while 1
    [ predict, re  ] = predictionFromTwoPoint( p(:,i), p(:,i+1), mu_norm, sigma_norm, net );
    if sum(predict < 0)>=1 || i > 100 || previousNode(2) > predict(2)
%     if  i > 10
        break;
    end
    p(:,i+2) = predict;
    i = i+1;
end
figure('Name','predicted trajectory'),hold on; plot(p(2,:),p(3,:),'r ^ :', 'MarkerSize',10)
%% predict half of trajectory
p1 = [0;0;0;];
p2 = [1;0.707106781187;0.658106781187];
p = [p1 p2];
i = 1;
previousNode = p2;
while 1
    [ predict, re  ] = predictionFromTwoPoint( p(:,i), p(:,i+1), mu_norm, sigma_norm, net );
    if sum(predict < 0)>1 || previousNode(3) > predict(3) || previousNode(2) > predict(2)
        break;
    end
    p(:,i+2) = predict;
    previousNode = predict;
    i = i+1;
end
[ p_whole ] = half2whole( p );
plot(p_whole(2,:),p_whole(3,:),'b o -', 'MarkerSize',10)
legend('predicted trajectory method 1','predicted trajectory method 2');
hold off;
% % fid = fopen('predictedTrajactory.csv','w');
% % % fprintf(fid,'%2d  %12.8f  %12.8f\n',p_whole);
% % fclose(fid);

csvwrite('predictedTrajactory.csv',p_whole');

str1 = sprintf('%2s  %12s  %12s','[time_index]' , '[x]' , '[y] ');
str = sprintf('%12d  %12.8f  %12.8f\n',p_whole);
disp('The predicted trajectory:')
disp(str1)
disp(str)

