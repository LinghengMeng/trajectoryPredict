% choose parameter
p1 = [0;0;0;];
p2 = [1;0.707106781187;0.658106781187];
p = [p1 p2];
p3 = [3; 2.12132034356; 1.68032034356];
%set parameters
hiddenSize = 95;
minError = [100;100;100];
optHiddenSize = 10;
increasement = 10;
while 1
    disp(['hiddenSize: ' num2str(hiddenSize) '    optHiddenSize: ' num2str(optHiddenSize)]);
    net = newff( train_input,train_target,hiddenSize);

    %start training
    net = train( net, train_input , train_target) ;
    
    [ predict, re  ] = predictionFromTwoPoint( p(:,1), p(:,2), mu_norm, sigma_norm, net );
    error = abs(predict - p3);
    if sum(error)<0.001 || hiddenSize > 400
        break;
    end
    if sum(error) < sum(minError)
        minError = error;
        optHiddenSize = hiddenSize;
    end
    hiddenSize = hiddenSize + increasement;
end