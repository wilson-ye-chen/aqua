function [logLike, mu] = margin_like_apat( ...
    delta, psi, phi, omega, alpha, ...
    sigma, eta, lambda, iota, ...
    mu0, nPre, xi)
% [logLike, mu] = margin_like_apat(delta, psi, phi, omega, alpha, ...
% sigma, eta, lambda, iota, mu0, nPre, xi) computes the log-likelihood of the
% Apatosaurus marginal model for an AQUA model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   December 16, 2015

    % Positivity of the scale parameter
    if sigma <= 0
        logLike = -inf;
        mu = [];
        return
    end
    
    % Bounds on the degrees of freedom and skewness parameters
    if eta <= 2 || eta > 40 || lambda <= -1 || lambda >= 1
        logLike = -inf;
        mu = [];
        return
    end
    
    % Constraints on mode dynamics
    if delta <= 0 || psi < 0 || phi < 0 || phi >= 1
        logLike = -inf;
        mu = [];
        return
    end
    
    % Positivity of the mean parameter of the Exponential
    if iota <= 0
        logLike = -inf;
        mu = [];
        return
    end
    
    % Compute the conditional modes
    mu = aqua_mu(delta, psi, phi, mu0, xi);
    wAst = omega + alpha .* mu;
    if any(wAst <= -10 | wAst >= 10)
        logLike = -inf;
        mu =[];
        return
    end
    w = 0.5 + 0.5 ./ (1 + exp(-wAst));
    
    mu = mu((nPre + 1):(end - 1));
    w = w((nPre + 1):(end - 1));
    
    % Compute the log-likelihood
    xi = xi((nPre + 1):end);
    logLike = sum(log(apatpdf(xi, mu, sigma, eta, lambda, iota, w)));
end
