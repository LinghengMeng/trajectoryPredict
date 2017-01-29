function [ a3 ] = predictionSparsityNN(theta,visibleSize, hiddenSize,outputSize,input)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
W2 = reshape(theta(hiddenSize*visibleSize+1:hiddenSize*visibleSize+outputSize*hiddenSize), outputSize, hiddenSize);
b1 = theta(hiddenSize*visibleSize+outputSize*hiddenSize+1:hiddenSize*visibleSize+outputSize*hiddenSize+hiddenSize);
b2 = theta(hiddenSize*visibleSize+outputSize*hiddenSize+hiddenSize+1:end);

[n m] = size(input);

z2 = W1*input+repmat(b1,1,m);
a2 = sigmoid(z2);
z3 = W2*a2+repmat(b2,1,m);
a3 = z3;

end

function sigm = sigmoid(x)
  
    sigm = 1 ./ (1 + exp(-x));
end
function sigmInv = sigmoidInv(x)

    sigmInv = sigmoid(x).*(1-sigmoid(x));
end