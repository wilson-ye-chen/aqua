function [xi, mu, sigmaSq] = aqua_sim_sktmar( ...
    delta, psi, phi, omega, alpha, beta, eta, lambda, ...
    mu0, sigmaSq0, u)
% [xi, mu, sigmaSq] = aqua_sim_sktmar(delta, psi, phi, omega, alpha, beta, ...
% eta, lambda, mu0, sigmaSq0, u) simulates a vector of observations from a
% skewed-t marginal model of an AQUA model, where u is an IID vector from an
% Uniform(0, 1) distribution. The conditional mean and conditional variance
% recursions can be conventionally initialised respectively as: mu0 = delta /
% (1 - psi - phi) and sigmaSq0 = omega / (1 - alpha - beta).
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   October 14, 2015

    nObs = numel(u);
    sigmaSq = zeros(nObs, 1);
    e = zeros(nObs, 1);
    mu = zeros(nObs, 1);
    xi = zeros(nObs, 1);
    
    % Generate skewed-t innovations
    z = stdsktinv(u, eta, lambda);
    
    % Generate the first observation
    sigmaSq(1) = sigmaSq0;
    e(1) = sqrt(sigmaSq(1)) .* z(1);
    mu(1) = mu0;
    xi(1) = mu(1) + e(1);
    
    % Generate the rest
    for i = 2:nObs
        sigmaSq(i) = omega + alpha .* e(i - 1) .^ 2 + beta .* sigmaSq(i - 1);
        e(i) = sqrt(sigmaSq(i)) .* z(i);
        mu(i) = delta + psi .* xi(i - 1) + phi .* mu(i - 1);
        xi(i) = mu(i) + e(i);
    end
end
