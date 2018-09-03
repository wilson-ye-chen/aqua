function [xi, mu, w] = aqua_sim_apatmar( ...
    delta, psi, phi, lnGamma, c, sigma, eta, lambda, iota, mu0, u)
% [xi, mu, w] = aqua_sim_apatmar(delta, psi, phi, lnGamma, c, sigma, ...
% eta, lambda, iota, mu0, u) simulates a vector of observations from an
% Apatosaurus marginal model of an AQUA model, where u is an IID vector
% from an uniform distribution on the interval (0, 1).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 6, 2016

    nObs = numel(u);
    mu = zeros(nObs, 1);
    w = zeros(nObs, 1);
    xi = zeros(nObs, 1);
    
    % Generate the first observation
    mu(1) = mu0;
    gamma = exp(lnGamma);
    w(1) = 0.5 + 0.5 ./ (1 + exp(-gamma .* (mu0 - c)));
    if logical(binornd(1, w(1), 1, 1));
        xi(1) = trsktinv(u(1), mu0, sigma, eta, lambda);
    else
        xi(1) = expinv(u(1), iota);
    end
    
    % Generate the rest
    for i = 2:nObs
        mu(i) = delta + psi .* xi(i - 1) + phi .* mu(i - 1);
        w(i) = 0.5 + 0.5 ./ (1 + exp(-gamma .* (mu(i) - c)));
        if logical(binornd(1, w(i), 1, 1));
            xi(i) = trsktinv(u(i), mu(i), sigma, eta, lambda);
        else
            xi(i) = expinv(u(i), iota);
        end
    end
end
