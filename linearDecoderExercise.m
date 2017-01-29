%% CS294A/CS294W Linear Decoder Exercise

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  linear decoder exericse. For this exercise, you will only need to modify
%  the code in sparseAutoencoderLinearCost.m. You will not need to modify
%  any code in this file.

%%======================================================================
%% STEP 0: Initialization
%  Here we initialize some parameters used for the exercise.
start = tic;
addpath .\normalized_data
normalizedData
%%
visibleSize = size(train_input,1);  % number of input units 
outputSize  = size(train_target,1);   % number of output units
hiddenSize  = 400;           % number of hidden units 

sparsityParam = 0.035; % desired average activation of the hidden units.
lambda = 3e-3;         % weight decay parameter       
beta = 5;              % weight of sparsity penalty term       

epsilon = 0.1;	       % epsilon for ZCA whitening
%% STEP 2c: Learn features
%  You will now use your sparse autoencoder (with linear decoder) to learn
%  features on the preprocessed patches. This should take around 45 minutes.

theta = initializeParameters(hiddenSize, visibleSize, outputSize);

% Use minFunc to minimize the function
addpath minFunc/

options = struct;
options.Method = 'lbfgs'; 
options.maxIter = 800;
options.display = 'on';

[optTheta, cost] = minFunc( @(p) sparseAutoencoderLinearCost(p, ...
                                   visibleSize, hiddenSize,outputSize, ...
                                   lambda, sparsityParam, ...
                                   beta, train_input, train_target), ...
                              theta, options);

%%
predict_Y = predictionSparsityNN(optTheta,visibleSize, hiddenSize,outputSize,test_input);

error = test_target - predict_Y;
t = denormalization( predict_Y, mu_norm, sigma_norm);
t_target = denormalization( test_target, mu_norm, sigma_norm);
figure('Name','predict_test'), plot(t(1,:),t(2,:),'r x ', 'MarkerSize',10);
figure('Name','target_test'), plot(t_target(1,:),t_target(2,:),'r x ', 'MarkerSize',10);
%% STEP 2d: Visualize learned features
p1 = [0;0;0;];
p2 = [1;0.707106781187;0.658106781187];
p = [p1 p2];
i = 1;
while 1
    [ p_input ] = prepareP( p(:,i), p(:,i+1), mu_norm, sigma_norm);
    predict = predictionSparsityNN(optTheta,visibleSize, hiddenSize,outputSize,p_input);
    if sum(predict < 0)>=1 || i > 100
        break;
    end
    p(:,i+2) = predict;
    i = i+1;
end
figure,plot(p(2,:),p(3,:),'r x :', 'MarkerSize',10)
% % 
% % train_predictions = predict( theta,visibleSize, hiddenSize,outputSize,train_input_norm );
% % train_errors = train_target_norm - train_predictions;
% % 
% % predictions = predict( theta,visibleSize, hiddenSize,outputSize,test_input_norm );
% % errors = test_target_norm - predictions;

disp(['Finished...Totally spent ' num2str(toc(start)) ' seconds.']);