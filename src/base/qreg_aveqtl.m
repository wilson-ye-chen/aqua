function aveQtl = qreg_aveqtl(Theta, X)
% aveQtl = qreg_aveqtl(Theta, X) computes the quantile estimates by
% averaging over those given by sampled parameters from the posterior
% distribution of a quantile regression model. This function can be
% memory-hungry.
%
% Input:
% Theta  - matrix of sampled parameter vectors, where each row is an
%          observation and each column is a parameter.
% X      - design matrix where each row is an observation and each
%          column is a predictor.
%
% Output:
% aveQtl - column vector of quantile estimates.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   July 28, 2015

    aveQtl = mean(X * Theta', 2);
end
