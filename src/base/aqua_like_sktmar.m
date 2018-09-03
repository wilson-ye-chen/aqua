function [logLike, z] = aqua_like_sktmar( ...
    delta, psi, phi, omega, alpha, beta, eta, lambda, ...
    mu0, nSigmaSq0, nPre, xi)
% [logLike, z] = aqua_like_sktmar(delta, psi, phi, omega, alpha, beta, ...
% eta, lambda, mu0, nSigmaSq0, nPre, xi) computes the log-likelihood of the
% skewed-t marginal model for an AQUA model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   January 23, 2016

    % Bounds on the degrees-of-freedom parameter
    if eta <= 2 || eta > 40
        logLike = -inf;
        z = [];
        return
    end
    
    % Bounds on the skewness parameter
    if lambda <= -1 || lambda >= 1
        logLike = -inf;
        z = [];
        return
    end
    
    % Mean stationarity
    if psi + phi <= -1 || psi + phi >= 1
        logLike = -inf;
        z = [];
        return
    end
    
    % Invertibility
    if phi <= -1 || phi >= 1
        logLike = -inf;
        z = [];
        return
    end
    
    % Constraints on variance dynamics
    if omega <= 0 || alpha < 0 || beta < 0 || alpha + beta >= 1
        logLike = -inf;
        z = [];
        return
    end
    
    % Compute the conditional means and variances
    mu = aqua_mu(delta, psi, phi, mu0, xi);
    e = xi - mu(1:(end - 1));
    sigmaSq0 = var(e(1:nSigmaSq0));
    sigmaSq = aqua_sigmasq(omega, alpha, beta, sigmaSq0, e);
    
    % Compute the log-likelihood
    sigma = sqrt(sigmaSq((nPre + 1):(end - 1)));
    z = e((nPre + 1):end) ./ sigma;
    logLike = sum(log(stdsktpdf(z, eta, lambda) ./ sigma));
end
