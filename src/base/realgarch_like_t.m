function logLike = realgarch_like_t( ...
    mu, omega, beta, gamma, nu, xi, psi, tau1, tau2, sigmaU, ...
    logSigmaSq0, nPre, r, logX)
% logLike = realgarch_like_t(mu, omega, beta, gamma, nu, xi, psi, tau1, ...
% tau2, sigmaU, logSigmaSq0, nPre, r, logX) computes the log-likelihood of
% the Realised-GARCH-t model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   September 29, 2015

    % Bounds on the degrees-of-freedom parameter
    if nu <= 2 || nu > 40
        logLike = -inf;
        return
    end
    
    % Positivity of measurement error
    if sigmaU <= 0
        logLike = -inf;
        return
    end
    
    % Constraints on variance dynamics
    pers = beta + gamma .* psi;
    if pers < 0 || pers >= 1
        logLike = -inf;
        return
    end
    
    % Compute the conditional variances
    logSigmaSq = realgarch_logsigmasq(omega, beta, gamma, logSigmaSq0, logX);
    
    % Trim pre-sample observations
    logSigmaSq = logSigmaSq((nPre + 1):(end - 1));
    r = r((nPre + 1):end);
    logX = logX((nPre + 1):end);
    
    % Log-likelihood of returns
    sigma = sqrt(exp(logSigmaSq));
    s = sigma .* sqrt((nu - 2) ./ nu);
    llR = sum(log(tpdf((r - mu) ./ s, nu) ./ s));
    
    % Log-likelihood of log realised variances
    z = (r - mu) ./ sigma;
    tau = tau1 .* z + tau2 .* (z .^ 2 - 1);
    llX = sum(log(normpdf(logX, xi + psi .* logSigmaSq + tau, sigmaU)));
    
    % Joint log-likelihood
    logLike = llR + llX;
end
