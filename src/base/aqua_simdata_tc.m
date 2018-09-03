function [Xi, Mu, SigmaSq, W] = aqua_simdata_tc()
% [Xi, Mu, SigmaSq, W] = aqua_simdata_tc() generates a data-set from the
% gh-AQUA model, where the dependencies are modelled using a t-copula, the
% conditional marginal distributions of a, log(b), and g are skewed-t, and
% those of h are Apatosaurus. The data-set contains 1000 samples with 3050
% observations in each.
%
% Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
% Date:   February 21, 2017

    % Parameter values
    a = [0, 0.06, 0.91, 6e-8, 0.15, 0.84, 8, -0.16];
    b = [-0.13, 0.43, 0.53, 5e-3, 0.06, 0.88, 15, 0];
    g = [0, 0.05, 0.93, 7e-5, 0.07, 0.92, 18, 0.14];
    h = [3e-3, 0.22, 0.74, 3.7, 0.03, 0.06, 6, 0.15, 1e-4];
    c = [-0.3, -0.1, 0.2, -0.22, -0.6, 0.12];
    df = 15;
    
    % Initial values of mu recursions
    muA0 = a(1) ./ (1 - a(2) - a(3));
    muB0 = b(1) ./ (1 - b(2) - b(3));
    muG0 = g(1) ./ (1 - g(2) - g(3));
    muH0 = 0.15;
    mu0 = [muA0, muB0, muG0, muH0];
    
    % Initial values of sigmaSq recursions
    sigmaSqA0 = a(4) ./ (1 - a(5) - a(6));
    sigmaSqB0 = b(4) ./ (1 - b(5) - b(6));
    sigmaSqG0 = g(4) ./ (1 - g(5) - g(6));
    sigmaSq0 = [sigmaSqA0, sigmaSqB0, sigmaSqG0];
    
    % Simulate 1000 samples with 3050 observations in each
    nSim = 1000;
    nPre = 500;
    nObs = 3050;
    
    Xi = zeros(nObs, 4, nSim);
    Mu = zeros(nObs, 4, nSim);
    SigmaSq = zeros(nObs, 3, nSim);
    W = zeros(nObs, nSim);
    
    for i = 1:nSim
        [Xi(:, :, i), Mu(:, :, i), SigmaSq(:, :, i), W(:, i)] = ...
            aqua_sim_tc(a, b, g, h, c, df, mu0, sigmaSq0, nPre, nObs);
    end
end
