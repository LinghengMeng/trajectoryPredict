function numgrad = computeNumericalGradient(J, theta)
% numgrad = computeNumericalGradient(J, theta)
% theta: a vector of parameters
% J: a function that outputs a real-number. Calling y = J(theta) will return the
% function value at theta. 

% Initialize numgrad with zeros
numgrad = zeros(size(theta));

%% ---------- YOUR CODE HERE --------------------------------------
% Instructions: 
% Implement numerical gradient checking, and return the result in numgrad.  
% (See Section 2.3 of the lecture notes.)
% You should write code so that numgrad(i) is (the numerical approximation to) the 
% partial derivative of J with respect to the i-th input argument, evaluated at theta.  
% I.e., numgrad(i) should be the (approximately) the partial derivative of J with 
% respect to theta(i).
%                
% Hint: You will probably want to compute the elements of numgrad one at a time. 
Epsilon = 10 ^ (-4);
num = size(theta,1);
for i = 1:num
    disp(['computNumericalGrad' num2str(i)]);
    ei = zeros(num,1);
    ei(i, 1) = 1;
    numgrad(i) = ( J(theta + Epsilon .* ei) - J(theta - Epsilon .* ei)) ./ (2*Epsilon);
end

%% ---------------------------------------------------------------
end
