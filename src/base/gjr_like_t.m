function logLike = gjr_like_t( ...
    mu, omega, alpha1, alpha2, beta, nu, sigmaSq0, nPre, r)
% logLike = gjr_like_t(mu, omega, alpha1, alpha2, beta, nu, sigmaSq0, ...
% nPre, r) computes the log-likelihood of the GJR-GARCH-t model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 3, 2015

    % Bounds on the degrees-of-freedom parameter
    if nu <= 2 || nu > 40
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
    s = sqrt(sigmaSq) .* sqrt((nu - 2) ./ nu);
    logLike = sum(log(tpdf(a ./ s, nu) ./ s));
end
