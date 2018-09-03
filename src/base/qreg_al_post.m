function logPost = qreg_al_post(beta, y, X, u)
% logPost = qreg_al_post(beta, y, X, u) evaluates the log-posterior of a
% quantile regression model, where the likelihood is asymmetric Laplace
% and the prior is proportional to one over the scale parameter. The scale
% parameter of the ALD is integrated out of the posterior.
%
% Input:
% beta    - vector of coefficients.
% y       - vector of observed responses.
% X       - design matrix where each row is an observation and each column
%           is a predictor.
% u       - scalar in (0, 1) setting the quantile level.
%
% Output:
% logPost - value of the log-posterior function.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   September 21, 2015

    n = numel(y);
    logPost = -n .* log(sum(loss(y(:) - X * beta(:), u)));
end

function rho = loss(e, u)
    rho = 0.5 .* (abs(e) + (2 .* u - 1) .* e);
end
