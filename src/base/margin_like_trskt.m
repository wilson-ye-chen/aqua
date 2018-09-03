function [logLike, mu] = margin_like_trskt( ...
    delta, psi, phi, sigma, eta, lambda, ...
    mu0, nPre, xi)
% [logLike, mu] = margin_like_trskt(delta, psi, phi, sigma, eta, lambda, ...
% mu0, nPre, xi) computes the log-likelihood of the truncated-skewed-t
% marginal model for an AQUA model.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 20, 2017

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
    if delta <= 0 || psi < 0 || phi < 0 || psi + phi >= 1
        logLike = -inf;
        mu = [];
        return
    end

    % Compute the conditional modes
    mu = aqua_mu(delta, psi, phi, mu0, xi);
    mu = mu((nPre + 1):(end - 1));

    % Compute the log-likelihood
    xi = xi((nPre + 1):end);
    logLike = sum(log(trsktpdf(xi, mu, sigma, eta, lambda)));
end
