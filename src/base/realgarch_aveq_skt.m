function QAve = realgarch_aveq_skt(u, Theta, logX, logSigmaSq0)
% QAve = realgarch_aveq_skt(u, Theta, logX, logSigmaSq0) computes the
% conditional quantiles by averaging over those given by the Realised-GARCH-
% skt model with parameters sampled from the posterior distribution.
%
% Input:
% u           - vector of quantile levels.
% Theta       - matrix of observed parameter vectors, where each row is an
%               observation, and each column is a parameter.
% logX        - vector of log realised variances.
% logSigmaSq0 - log variance of the first period.
%
% Output:
% QAve        - matrix of average conditional quantiles, containing one more
%               element than the number of observations, where the last row
%               is the out-of-sample one-period-ahead forecast.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 2, 2015

    nObs = numel(logX);
    nLev = numel(u);
    nTheta = size(Theta, 1);
    
    QSum = zeros(nObs + 1, nLev);
    for i = 1:nTheta
        mu     = Theta(i, 1);
        omega  = Theta(i, 2);
        beta   = Theta(i, 3);
        gamma  = Theta(i, 4);
        eta    = Theta(i, 5);
        lambda = Theta(i, 6);
        logSigmaSq = realgarch_logsigmasq( ...
            omega, beta, gamma, logSigmaSq0, logX);
        sigma = sqrt(exp(logSigmaSq));
        Q = mu + ...
            repmat(sigma, 1, nLev) .* ...
            repmat(stdsktinv(u(:)', eta, lambda), nObs + 1, 1);
        QSum = QSum + Q;
    end
    QAve = QSum ./ nTheta;
end
