% % function [cost,grad,features] = sparseAutoencoderLinearCost(theta, visibleSize, hiddenSize, ...
% %                                                             lambda, sparsityParam, beta, data)
% % % -------------------- YOUR CODE HERE --------------------
% % % Instructions:
% % %   Copy sparseAutoencoderCost in sparseAutoencoderCost.m from your
% % %   earlier exercise onto this file, renaming the function to
% % %   sparseAutoencoderLinearCost, and changing the autoencoder to use a
% % %   linear decoder.
% % % -------------------- YOUR CODE HERE --------------------                                    
% % 
% % end
function [cost,grad,features] = sparseAutoencoderLinearCost(theta, visibleSize, hiddenSize,outputSize, ...
                                             lambda, sparsityParam, beta, input, target)

% visibleSize: the number of input units (probably 64) 
% hiddenSize: the number of hidden units (probably 25) 
% lambda: weight decay parameter
% sparsityParam: The desired average activation for the hidden units (denoted in the lecture
%                           notes by the greek alphabet rho, which looks like a lower-case "p").
% beta: weight of sparsity penalty term
% data: Our 64x10000 matrix containing the training data.  So, data(:,i) is the i-th training example. 
  
% The input theta is a vector (because minFunc expects the parameters to be a vector). 
% We first convert theta to the (W1, W2, b1, b2) matrix/vector format, so that this 
% follows the notation convention of the lecture notes. 

W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
W2 = reshape(theta(hiddenSize*visibleSize+1:hiddenSize*visibleSize+outputSize*hiddenSize), outputSize, hiddenSize);
b1 = theta(hiddenSize*visibleSize+outputSize*hiddenSize+1:hiddenSize*visibleSize+outputSize*hiddenSize+hiddenSize);
b2 = theta(hiddenSize*visibleSize+outputSize*hiddenSize+hiddenSize+1:end);

% Cost and gradient variables (your code needs to compute these values). 
% Here, we initialize them to zeros. 
cost = 0;
W1grad = zeros(size(W1)); 
W2grad = zeros(size(W2));
b1grad = zeros(size(b1)); 
b2grad = zeros(size(b2));

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost/optimization objective J_sparse(W,b) for the Sparse Autoencoder,
%                and the corresponding gradients W1grad, W2grad, b1grad, b2grad.
%
% W1grad, W2grad, b1grad and b2grad should be computed using backpropagation.
% Note that W1grad has the same dimensions as W1, b1grad has the same dimensions
% as b1, etc.  Your code should set W1grad to be the partial derivative of J_sparse(W,b) with
% respect to W1.  I.e., W1grad(i,j) should be the partial derivative of J_sparse(W,b) 
% with respect to the input parameter W1(i,j).  Thus, W1grad should be equal to the term 
% [(1/m) \Delta W^{(1)} + \lambda W^{(1)}] in the last block of pseudo-code in Section 2.2 
% of the lecture notes (and similarly for W2grad, b1grad, b2grad).
% 
% Stated differently, if we were using batch gradient descent to optimize the parameters,
% the gradient descent update to W1 would be W1 := W1 - alpha * W1grad, and similarly for W2, b1, b2. 
% 

Jcost = 0;%Square-error
Jweight = 0;%weight decay
Jsparse = 0;%sparsity penalty
[n m] = size(input);

z2 = W1*input+repmat(b1,1,m);
a2 = sigmoid(z2);
z3 = W2*a2+repmat(b2,1,m);
a3 = z3;

Jcost = (0.5/m)*sum(sum((a3-target).^2));
Jweight = (1/2)*(sum(sum(W1.^2))+sum(sum(W2.^2)));
rho = (1/m).*sum(a2,2);
Jsparse = sum(sparsityParam.*log(sparsityParam./rho)+ ...
        (1-sparsityParam).*log((1-sparsityParam)./(1-rho)));
cost = Jcost+lambda*Jweight+beta*Jsparse;

d3 = -(target-a3);
sterm = beta*(-sparsityParam./rho+(1-sparsityParam)./(1-rho));
d2 = (W2'*d3+repmat(sterm,1,m)).*sigmoidInv(z2); 

W1grad = W1grad+d2*input';
W1grad = (1/m)*W1grad+lambda*W1;
W2grad = W2grad+d3*a2';
W2grad = (1/m).*W2grad+lambda*W2;

b1grad = b1grad+sum(d2,2);
b1grad = (1/m)*b1grad;
b2grad = b2grad+sum(d3,2);
b2grad = (1/m)*b2grad;
%-------------------------------------------------------------------
% After computing the cost and gradient, we will convert the gradients back
% to a vector format (suitable for minFunc).  Specifically, we will unroll
% your gradient matrices into a vector.

grad = [W1grad(:) ; W2grad(:) ; b1grad(:) ; b2grad(:)];
end

%-------------------------------------------------------------------
% Here's an implementation of the sigmoid function, which you may find useful
% in your computation of the costs and the gradients.  This inputs a (row or
% column) vector (say (z1, z2, z3)) and returns (f(z1), f(z2), f(z3)). 

function sigm = sigmoid(x)
  
    sigm = 1 ./ (1 + exp(-x));
end
function sigmInv = sigmoidInv(x)

    sigmInv = sigmoid(x).*(1-sigmoid(x));
end
