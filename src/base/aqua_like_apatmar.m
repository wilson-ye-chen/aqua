function [logLike, mu, w] = aqua_like_apatmar( ...
    delta, psi, phi, lnGamma, c, sigma, eta, lambda, iota, ...
    mu0, nPre, xi)
% [logLike, mu, w] = aqua_like_apatmar(delta, psi, phi, lnGamma, c, ...
% sigma, eta, lambda, iota, mu0, nPre, xi) computes the log-likelihood
% of the Apatosaurus marginal model for an AQUA model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 5, 2016

    % Positivity of the scale parameter
    if sigma <= 0
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Bounds on the degrees of freedom and skewness parameters
    if eta <= 2 || eta > 40 || lambda <= -1 || lambda >= 1
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Positivity and stationarity of conditional modes
    if delta <= 0 || psi < 0 || phi < 0 || psi + phi >= 1
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Positivity of the mean parameter of the Exponential
    if iota <= 0
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Bounds on log-gamma (transition speed)
    if lnGamma < -6 || lnGamma > 6
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Bounds on c (transition location)
    if c < 0 || c > 1
        logLike = -inf;
        mu = [];
        w = [];
        return
    end
    
    % Compute the conditional modes
    mu = aqua_mu(delta, psi, phi, mu0, xi);
    gamma = exp(lnGamma);
    w = 0.5 + 0.5 ./ (1 + exp(-gamma .* (mu - c)));
    
    mu = mu((nPre + 1):(end - 1));
    w = w((nPre + 1):(end - 1));
    
    % Compute the log-likelihood
    xi = xi((nPre + 1):end);
    logLike = sum(log(apatpdf(xi, mu, sigma, eta, lambda, iota, w)));
end
