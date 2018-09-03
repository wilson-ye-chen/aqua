function QAve = gjr_aveq_t(u, Theta, r, sigmaSq0)
% QAve = gjr_aveq_t(u, Theta, r, sigmaSq0) computes the conditional quantiles
% by averaging over those given by the GJR-GARCH-t model with parameters
% sampled from the posterior distribution.
%
% Input:
% u        - vector of quantile levels.
% Theta    - matrix of observed parameter vectors, where each row is an
%            observation, and each column is a parameter.
% r        - vector of returns.
% sigmaSq0 - variance of the first period.
%
% Output:
% QAve     - matrix of average conditional quantiles, containing one more
%            element than the number of observations, where the last row
%            is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 3, 2015

    nObs = numel(r);
    nLev = numel(u);
    nTheta = size(Theta, 1);
    
    QSum = zeros(nObs + 1, nLev);
    for i = 1:nTheta
        mu     = Theta(i, 1);
        omega  = Theta(i, 2);
        alpha1 = Theta(i, 3);
        alpha2 = Theta(i, 4);
        beta   = Theta(i, 5);
        nu     = Theta(i, 6);
        sigmaSq = gjr_sigmasq(omega, alpha1, alpha2, beta, sigmaSq0, r);
        s = sqrt(sigmaSq) .* sqrt((nu - 2) ./ nu);
        Q = mu + repmat(s, 1, nLev) .* repmat(tinv(u(:)', nu), nObs + 1, 1);
        QSum = QSum + Q;
    end
    QAve = QSum ./ nTheta;
end
