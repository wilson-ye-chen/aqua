function logLike = gjr_like_skt( ...
    mu, omega, alpha1, alpha2, beta, eta, lambda, sigmaSq0, nPre, r)
% logLike = gjr_like_t(mu, omega, alpha1, alpha2, beta, eta, lambda, ...
% sigmaSq0, nPre, r) computes the log-likelihood of the GJR-GARCH-skt model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 3, 2015

    % Bounds on the degrees-of-freedom parameter
    if eta <= 2 || eta > 40
        logLike = -inf;
        return
    end
    
    % Bounds on the skewness parameter
    if lambda <= -1 || lambda >= 1
        logLike = -inf;
        return
    end
    
    % Positivity constraints
    if omega <= 0 || alpha1 < 0 || alpha1 + alpha2 < 0 || beta < 0
        logLike = -inf;
        return
    end
    
    % Stationarity constraint
    if alpha1 + (0.5 .* alpha2) + beta >= 1
        logLike = -inf;
        return
    end
    
    % Compute the conditional variances
    a = r - mu;
    sigmaSq = gjr_sigmasq(omega, alpha1, alpha2, beta, sigmaSq0, a);
    
    % Trim pre-sample observations
    a = a((nPre + 1):end);
    sigmaSq = sigmaSq((nPre + 1):(end - 1));
    
    % Compute log-likelihood
    sigma = sqrt(sigmaSq);
    logLike = sum(log(stdsktpdf(a ./ sigma, eta, lambda) ./ sigma));
end
