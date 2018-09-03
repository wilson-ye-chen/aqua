function logLike = realgarch_like_skt( ...
    mu, omega, beta, gamma, eta, lambda, xi, psi, tau1, tau2, sigmaU, ...
    logSigmaSq0, nPre, r, logX)
% logLike = realgarch_like_t(mu, omega, beta, gamma, eta, lambda, xi, ...
% psi, tau1, tau2, sigmaU, logSigmaSq0, nPre, r, logX) computes the log-
% likelihood of the Realised-GARCH-skt model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 2, 2015

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
    llR = sum(log(stdsktpdf((r - mu) ./ sigma, eta, lambda) ./ sigma));
    
    % Log-likelihood of log realised variances
    z = (r - mu) ./ sigma;
    tau = tau1 .* z + tau2 .* (z .^ 2 - 1);
    llX = sum(log(normpdf(logX, xi + psi .* logSigmaSq + tau, sigmaU)));
    
    % Joint log-likelihood
    logLike = llR + llX;
end
