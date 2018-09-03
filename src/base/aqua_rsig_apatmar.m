function [rSig, xi, mu, w, m] = aqua_rsig_apatmar( ...
    delta, psi, phi, lnGamma, c, sigma, eta, lambda, iota)
% [rSig, xi, mu, w, m] = aqua_rsig_apatmar(delta, psi, phi, lnGamma, ...
% c, sigma, eta, lambda, iota) computes the signal ratio of the Apatosaurus
% conditional marginal model via simulation with 20000 observations. The
% parameters must be scalars.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   June 30, 2017

    nPre = 500;
    nObs = 20000;
    nSim = nPre + nObs;

    mu0 = delta ./ (1 - psi - phi);
    u = unifrnd(0, 1, nSim, 1);
    [xi, mu, w] = aqua_sim_apatmar( ...
        delta, psi, phi, lnGamma, c, ...
        sigma, eta, lambda, iota, ...
        mu0, u);
    xi = xi((nPre + 1):end);
    mu = mu((nPre + 1):end);
    w = w((nPre + 1):end);
    m = apatmean(mu, sigma, eta, lambda, iota, w);
    rSig = var(m) ./ var(xi);
end
